<#
.SYNOPSIS
    Reports on current Azure Policy assignments and compliance status.

.DESCRIPTION
    Shows all policy assignments in scope and their compliance state.
    Useful for facilitators to verify governance is active.

.PARAMETER SubscriptionId
    The Azure subscription ID to check.

.PARAMETER ResourceGroupName
    Optional. Scope to a specific resource group.

.PARAMETER HackathonOnly
    Only show hackathon-prefixed policies.

.EXAMPLE
    .\Get-GovernanceStatus.ps1 -SubscriptionId "12345678-..."

.EXAMPLE
    .\Get-GovernanceStatus.ps1 -SubscriptionId "12345678-..." -HackathonOnly
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$SubscriptionId,

    [Parameter()]
    [string]$ResourceGroupName,

    [Parameter()]
    [switch]$HackathonOnly
)

$ErrorActionPreference = 'Stop'

Write-Host "`n📊 Azure Governance Status Report" -ForegroundColor Cyan
Write-Host "=" * 60

# Set subscription context
az account set --subscription $SubscriptionId | Out-Null
$SubName = az account show --query name -o tsv
Write-Host "Subscription: $SubName" -ForegroundColor Green

# Determine scope
if ($ResourceGroupName) {
    $Scope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName"
    Write-Host "Scope: Resource Group ($ResourceGroupName)" -ForegroundColor Green
} else {
    $Scope = "/subscriptions/$SubscriptionId"
    Write-Host "Scope: Subscription" -ForegroundColor Green
}

# Get policy assignments
Write-Host "`nFetching policy assignments..." -ForegroundColor Yellow
$Assignments = az policy assignment list --scope $Scope 2>$null | ConvertFrom-Json

if ($HackathonOnly) {
    $Assignments = $Assignments | Where-Object { $_.name -like 'hackathon-*' }
}

if ($Assignments.Count -eq 0) {
    Write-Host "`n⚠️  No policy assignments found." -ForegroundColor Yellow
    if ($HackathonOnly) {
        Write-Host "   Run Setup-GovernancePolicies.ps1 to deploy hackathon policies." -ForegroundColor Yellow
    }
    exit 0
}

Write-Host "`n📋 Policy Assignments ($($Assignments.Count) total)" -ForegroundColor Cyan
Write-Host "-" * 60

$TableData = $Assignments | ForEach-Object {
    $Enforcement = if ($_.enforcementMode -eq 'Default') { '🔒 Enforced' } else { '📝 Audit' }
    
    [PSCustomObject]@{
        Name        = $_.displayName
        Enforcement = $Enforcement
        Scope       = if ($_.scope -like '*resourceGroups*') { 'RG' } else { 'Sub' }
    }
}

$TableData | Format-Table -AutoSize

# Check compliance state
Write-Host "`n📈 Compliance Summary" -ForegroundColor Cyan
Write-Host "-" * 60

try {
    $Compliance = az policy state summarize --subscription $SubscriptionId 2>$null | ConvertFrom-Json
    
    $NonCompliant = $Compliance.results.nonCompliantResources
    $NonCompliantPolicies = $Compliance.results.nonCompliantPolicies
    
    if ($NonCompliant -gt 0) {
        Write-Host "  ⚠️  Non-compliant resources: $NonCompliant" -ForegroundColor Yellow
        Write-Host "  ⚠️  Non-compliant policies:  $NonCompliantPolicies" -ForegroundColor Yellow
    } else {
        Write-Host "  ✅ All resources compliant" -ForegroundColor Green
    }
} catch {
    Write-Host "  ℹ️  Compliance data not yet available (may take 15-30 minutes)" -ForegroundColor DarkGray
}

# Hackathon readiness check
if ($HackathonOnly -or ($Assignments | Where-Object { $_.name -like 'hackathon-*' })) {
    Write-Host "`n🎓 Hackathon Readiness" -ForegroundColor Cyan
    Write-Host "-" * 60
    
    $HackathonPolicies = $Assignments | Where-Object { $_.name -like 'hackathon-*' }
    $ExpectedPolicies = @(
        'hackathon-allowed-locations',
        'hackathon-require-tag-environment',
        'hackathon-require-tag-project',
        'hackathon-sql-aad-only',
        'hackathon-storage-https',
        'hackathon-appservice-https'
    )
    
    $Missing = $ExpectedPolicies | Where-Object { $_ -notin $HackathonPolicies.name }
    
    if ($Missing.Count -eq 0) {
        Write-Host "  ✅ All core hackathon policies deployed" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Missing policies:" -ForegroundColor Yellow
        $Missing | ForEach-Object { Write-Host "      - $_" -ForegroundColor Yellow }
    }
    
    Write-Host "`n  Policies will cause deployment failures for:" -ForegroundColor Cyan
    Write-Host "    • Resources outside swedencentral/germanywestcentral"
    Write-Host "    • Resources missing Environment or Project tags"
    Write-Host "    • SQL servers without Azure AD-only authentication"
    Write-Host "    • Storage accounts without HTTPS/TLS 1.2"
    Write-Host "    • App Services without HTTPS"
}

Write-Host ""
