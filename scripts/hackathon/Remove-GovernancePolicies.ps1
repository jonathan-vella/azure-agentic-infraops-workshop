<#
.SYNOPSIS
    Removes hackathon Azure Policy assignments.

.DESCRIPTION
    Cleans up governance policies deployed for the hackathon.
    Only removes policies with the 'hackathon-' prefix.

.PARAMETER SubscriptionId
    The Azure subscription ID to remove policies from.

.PARAMETER ResourceGroupName
    Optional. Scope to a specific resource group.

.PARAMETER WhatIf
    Preview removals without executing.

.EXAMPLE
    .\Remove-GovernancePolicies.ps1 -SubscriptionId "12345678-..."

.EXAMPLE
    .\Remove-GovernancePolicies.ps1 -SubscriptionId "12345678-..." -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$SubscriptionId,

    [Parameter()]
    [string]$ResourceGroupName
)

$ErrorActionPreference = 'Stop'

Write-Host "`n🧹 Hackathon Governance Policy Cleanup" -ForegroundColor Cyan
Write-Host "=" * 50

# Set subscription context
Write-Host "`nSetting subscription context..." -ForegroundColor Yellow
az account set --subscription $SubscriptionId
$SubName = az account show --query name -o tsv
Write-Host "  Subscription: $SubName" -ForegroundColor Green

# Determine scope
if ($ResourceGroupName) {
    $Scope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName"
} else {
    $Scope = "/subscriptions/$SubscriptionId"
}

# Get hackathon policy assignments
Write-Host "`nFinding hackathon policy assignments..." -ForegroundColor Yellow
$Assignments = az policy assignment list --scope $Scope 2>$null | ConvertFrom-Json
$HackathonPolicies = $Assignments | Where-Object { $_.name -like 'hackathon-*' }

if ($HackathonPolicies.Count -eq 0) {
    Write-Host "`n✅ No hackathon policies found." -ForegroundColor Green
    exit 0
}

Write-Host "  Found $($HackathonPolicies.Count) hackathon policy assignment(s)" -ForegroundColor Yellow

# Remove policies
$Removed = 0
$Failed = 0

foreach ($Policy in $HackathonPolicies) {
    if ($PSCmdlet.ShouldProcess($Policy.name, "Delete policy assignment")) {
        try {
            Write-Host "  Removing: $($Policy.displayName)..." -NoNewline
            az policy assignment delete --name $Policy.name --scope $Scope 2>&1 | Out-Null
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host " ✅" -ForegroundColor Green
                $Removed++
            } else {
                Write-Host " ❌" -ForegroundColor Red
                $Failed++
            }
        } catch {
            Write-Host " ❌ $($_.Exception.Message)" -ForegroundColor Red
            $Failed++
        }
    }
}

# Summary
Write-Host "`n" + "=" * 50
Write-Host "📊 Summary" -ForegroundColor Cyan
Write-Host "  Removed: $Removed"
Write-Host "  Failed:  $Failed"

Write-Host "`n✅ Governance cleanup complete." -ForegroundColor Green
