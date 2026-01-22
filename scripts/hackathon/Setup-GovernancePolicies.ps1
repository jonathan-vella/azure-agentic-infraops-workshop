<#
.SYNOPSIS
    Sets up Azure Policies for the hackathon environment.

.DESCRIPTION
    Deploys governance policies that force teams to handle real compliance constraints.
    Checks for existing policies before deploying to avoid duplicates.

.PARAMETER SubscriptionId
    The Azure subscription ID to deploy policies to.

.PARAMETER ResourceGroupName
    Optional. Scope policies to a specific resource group instead of subscription.

.PARAMETER WhatIf
    Preview policy assignments without deploying.

.EXAMPLE
    .\Setup-GovernancePolicies.ps1 -SubscriptionId "12345678-1234-1234-1234-123456789012"

.EXAMPLE
    .\Setup-GovernancePolicies.ps1 -SubscriptionId "12345678-..." -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$SubscriptionId,

    [Parameter()]
    [string]$ResourceGroupName,

    [Parameter()]
    [string[]]$AllowedLocations = @('swedencentral', 'germanywestcentral'),

    [Parameter()]
    [string[]]$RequiredTags = @('Environment', 'ManagedBy', 'Project', 'Owner')
)

$ErrorActionPreference = 'Stop'

# Policy definitions to assign (built-in Azure Policies)
$Policies = @(
    @{
        Name           = 'hackathon-allowed-locations'
        DisplayName    = '[Hackathon] Allowed locations'
        Description    = 'Restricts deployments to approved regions for GDPR compliance'
        PolicyId       = 'e56962a6-4747-49cd-b67b-bf8b01975c4c'  # Built-in: Allowed locations
        Parameters     = @{ listOfAllowedLocations = @{ value = $AllowedLocations } }
        Effect         = 'Deny'
    },
    @{
        Name           = 'hackathon-require-tag-environment'
        DisplayName    = '[Hackathon] Require Environment tag'
        Description    = 'Requires Environment tag on all resources'
        PolicyId       = '871b6d14-10aa-478d-b590-94f262ecfa99'  # Built-in: Require a tag on resources
        Parameters     = @{ tagName = @{ value = 'Environment' } }
        Effect         = 'Deny'
    },
    @{
        Name           = 'hackathon-require-tag-project'
        DisplayName    = '[Hackathon] Require Project tag'
        Description    = 'Requires Project tag on all resources'
        PolicyId       = '871b6d14-10aa-478d-b590-94f262ecfa99'
        Parameters     = @{ tagName = @{ value = 'Project' } }
        Effect         = 'Deny'
    },
    @{
        Name           = 'hackathon-sql-aad-only'
        DisplayName    = '[Hackathon] SQL Azure AD-only authentication'
        Description    = 'Azure SQL must use Azure AD-only authentication'
        PolicyId       = 'abda6d70-9778-44e7-84a8-06713e6db027'  # Built-in: Azure SQL should have AAD-only auth
        Parameters     = @{}
        Effect         = 'Deny'
    },
    @{
        Name           = 'hackathon-storage-https'
        DisplayName    = '[Hackathon] Storage HTTPS only'
        Description    = 'Storage accounts must use HTTPS'
        PolicyId       = '404c3081-a854-4457-ae30-26a93ef643f9'  # Built-in: Secure transfer to storage accounts
        Parameters     = @{}
        Effect         = 'Deny'
    },
    @{
        Name           = 'hackathon-storage-tls12'
        DisplayName    = '[Hackathon] Storage minimum TLS 1.2'
        Description    = 'Storage accounts must use TLS 1.2 or higher'
        PolicyId       = 'fe83a0eb-a853-422d-aez1-8aba3b32f9b5'  # Built-in: Storage min TLS
        Parameters     = @{ minimumTlsVersion = @{ value = 'TLS1_2' } }
        Effect         = 'Deny'
    },
    @{
        Name           = 'hackathon-storage-no-public-blob'
        DisplayName    = '[Hackathon] Storage no public blob access'
        Description    = 'Storage accounts must not allow public blob access'
        PolicyId       = '4fa4b6c0-31ca-4c0d-b10d-24b96f62a751'  # Built-in: Storage public access should be disallowed
        Parameters     = @{}
        Effect         = 'Deny'
    },
    @{
        Name           = 'hackathon-appservice-https'
        DisplayName    = '[Hackathon] App Service HTTPS only'
        Description    = 'App Services must use HTTPS'
        PolicyId       = 'a4af4a39-4135-47fb-b175-47fbdf85311d'  # Built-in: App Service should only be accessible over HTTPS
        Parameters     = @{}
        Effect         = 'Deny'
    },
    @{
        Name           = 'hackathon-appservice-tls12'
        DisplayName    = '[Hackathon] App Service minimum TLS 1.2'
        Description    = 'App Services should use TLS 1.2 or higher'
        PolicyId       = 'f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b'  # Built-in: App Service TLS
        Parameters     = @{}
        Effect         = 'Audit'  # Audit only - some SKUs don't support TLS config
    }
)

Write-Host "`n🔒 Hackathon Governance Policy Setup" -ForegroundColor Cyan
Write-Host "=" * 50

# Set subscription context
Write-Host "`nSetting subscription context..." -ForegroundColor Yellow
az account set --subscription $SubscriptionId
$SubName = az account show --query name -o tsv
Write-Host "  Subscription: $SubName ($SubscriptionId)" -ForegroundColor Green

# Determine scope
if ($ResourceGroupName) {
    $Scope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName"
    Write-Host "  Scope: Resource Group ($ResourceGroupName)" -ForegroundColor Green
} else {
    $Scope = "/subscriptions/$SubscriptionId"
    Write-Host "  Scope: Subscription" -ForegroundColor Green
}

# Get existing policy assignments
Write-Host "`nChecking existing policy assignments..." -ForegroundColor Yellow
$ExistingAssignments = az policy assignment list --scope $Scope 2>$null | ConvertFrom-Json
$ExistingNames = $ExistingAssignments | ForEach-Object { $_.name }

# Track results
$Created = 0
$Skipped = 0
$Failed = 0

Write-Host "`nProcessing policies..." -ForegroundColor Yellow

foreach ($Policy in $Policies) {
    $AssignmentName = $Policy.Name
    
    # Check if already exists
    if ($ExistingNames -contains $AssignmentName) {
        Write-Host "  ⏭️  $($Policy.DisplayName) - Already exists, skipping" -ForegroundColor DarkGray
        $Skipped++
        continue
    }
    
    # Check if policy definition exists
    $PolicyDef = az policy definition show --name $Policy.PolicyId 2>$null | ConvertFrom-Json -ErrorAction SilentlyContinue
    if (-not $PolicyDef) {
        Write-Host "  ⚠️  $($Policy.DisplayName) - Policy definition not found, skipping" -ForegroundColor Yellow
        $Skipped++
        continue
    }
    
    if ($PSCmdlet.ShouldProcess($AssignmentName, "Create policy assignment")) {
        try {
            # Build parameters JSON
            $ParamsJson = $Policy.Parameters | ConvertTo-Json -Compress -Depth 10
            
            # Create assignment
            $Result = az policy assignment create `
                --name $AssignmentName `
                --display-name $Policy.DisplayName `
                --description $Policy.Description `
                --policy $Policy.PolicyId `
                --scope $Scope `
                --params $ParamsJson `
                --enforcement-mode 'Default' 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✅ $($Policy.DisplayName)" -ForegroundColor Green
                $Created++
            } else {
                Write-Host "  ❌ $($Policy.DisplayName) - $Result" -ForegroundColor Red
                $Failed++
            }
        } catch {
            Write-Host "  ❌ $($Policy.DisplayName) - $($_.Exception.Message)" -ForegroundColor Red
            $Failed++
        }
    }
}

# Summary
Write-Host "`n" + "=" * 50
Write-Host "📊 Summary" -ForegroundColor Cyan
Write-Host "  Created: $Created"
Write-Host "  Skipped: $Skipped (already exist or not found)"
Write-Host "  Failed:  $Failed"

if ($Created -gt 0) {
    Write-Host "`n⚠️  Policy assignments may take 5-15 minutes to become effective." -ForegroundColor Yellow
    Write-Host "   Teams will see deployment failures for non-compliant resources." -ForegroundColor Yellow
}

Write-Host "`n✅ Governance setup complete." -ForegroundColor Green

# Output policy list for reference
Write-Host "`n📋 Active Policies:" -ForegroundColor Cyan
$Policies | ForEach-Object {
    Write-Host "  - $($_.DisplayName) [$($_.Effect)]"
}
