<#
.SYNOPSIS
    Scores a hackathon team's submission based on WAF-aligned criteria.

.DESCRIPTION
    Evaluates team artifacts against the scoring rubric (100 base + 25 bonus points).
    Checks requirements, architecture, Bicep implementation, deployment, and documentation.
    Can optionally verify Azure deployment.

.PARAMETER TeamName
    The name of the team (must match folder name in agent-output/).

.PARAMETER ResourceGroupName
    The Azure resource group to verify deployment (optional).

.PARAMETER SkipAzureCheck
    Skip Azure deployment verification if not deployed.

.EXAMPLE
    .\Score-Team.ps1 -TeamName "freshconnect"

.EXAMPLE
    .\Score-Team.ps1 -TeamName "freshconnect" -ResourceGroupName "rg-freshconnect-dev-swc"
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$TeamName,

    [Parameter()]
    [string]$ResourceGroupName,

    [Parameter()]
    [switch]$SkipAzureCheck
)

$ErrorActionPreference = 'Stop'

# Paths - go up 2 levels from scripts/hackathon/ to repo root
$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$ArtifactPath = Join-Path $RepoRoot "agent-output" $TeamName
$BicepPath = Join-Path $RepoRoot "infra" "bicep" $TeamName

# Results object
$Score = [PSCustomObject]@{
    Team            = $TeamName
    Requirements    = 0
    Architecture    = 0
    Implementation  = 0
    Deployment      = 0
    Documentation   = 0
    LoadTesting     = 0
    Bonus           = 0
    Total           = 0
    Details         = @()
    Timestamp       = Get-Date -Format 'o'
}

function Add-Score {
    param([string]$Category, [int]$Points, [string]$Reason)
    $Score.$Category += $Points
    $Score.Details += [PSCustomObject]@{
        Category = $Category
        Points   = $Points
        Reason   = $Reason
    }
    Write-Verbose "$Category +$Points : $Reason"
}

Write-Host "`n📊 Scoring Team: $TeamName" -ForegroundColor Cyan
Write-Host "=" * 50

# 1. REQUIREMENTS (20 pts)
Write-Host "`n📋 Requirements (20 pts)" -ForegroundColor Yellow
$ReqFile = Join-Path $ArtifactPath "01-requirements.md"
if (Test-Path $ReqFile) {
    $ReqContent = Get-Content $ReqFile -Raw
    
    # Check for key sections
    if ($ReqContent -match 'functional\s*requirement|business\s*requirement') {
        Add-Score -Category 'Requirements' -Points 4 -Reason "Functional requirements documented"
    }
    if ($ReqContent -match 'non.?functional|NFR|SLA|RTO|RPO') {
        Add-Score -Category 'Requirements' -Points 4 -Reason "Non-functional requirements captured"
    }
    if ($ReqContent -match 'GDPR|compliance|data\s*protection') {
        Add-Score -Category 'Requirements' -Points 4 -Reason "Compliance requirements identified"
    }
    if ($ReqContent -match 'budget|cost|\€|\$') {
        Add-Score -Category 'Requirements' -Points 4 -Reason "Budget constraints documented"
    }
    if ($ReqContent -match 'context|overview|scope') {
        Add-Score -Category 'Requirements' -Points 4 -Reason "Project context complete"
    }
} else {
    Write-Host "  ⚠️ 01-requirements.md not found" -ForegroundColor Red
}

# 2. ARCHITECTURE (25 pts)
Write-Host "`n🏗️ Architecture (25 pts)" -ForegroundColor Yellow
$ArchFile = Join-Path $ArtifactPath "02-architecture-assessment.md"
if (Test-Path $ArchFile) {
    $ArchContent = Get-Content $ArchFile -Raw
    
    if ($ArchContent -match 'cost|pricing|estimate|\€|\$') {
        Add-Score -Category 'Architecture' -Points 5 -Reason "Cost estimation included"
    }
    if ($ArchContent -match 'reliab|availab|redundan|replica') {
        Add-Score -Category 'Architecture' -Points 5 -Reason "Reliability patterns discussed"
    }
    if ($ArchContent -match 'secur|encrypt|identity|managed\s*identity') {
        Add-Score -Category 'Architecture' -Points 5 -Reason "Security controls documented"
    }
    if ($ArchContent -match 'scal|performance|auto.?scale') {
        Add-Score -Category 'Architecture' -Points 5 -Reason "Scalability approach defined"
    }
    if ($ArchContent -match 'app\s*service|sql|storage|key\s*vault') {
        Add-Score -Category 'Architecture' -Points 5 -Reason "Azure services selected"
    }
} else {
    Write-Host "  ⚠️ 02-architecture-assessment.md not found" -ForegroundColor Red
}

# 3. IMPLEMENTATION (25 pts)
Write-Host "`n⚙️ Implementation (25 pts)" -ForegroundColor Yellow
$MainBicep = Join-Path $BicepPath "main.bicep"
if (Test-Path $MainBicep) {
    $BicepContent = Get-Content $MainBicep -Raw
    
    # Try to compile
    try {
        $BuildResult = bicep build $MainBicep 2>&1
        if ($LASTEXITCODE -eq 0) {
            Add-Score -Category 'Implementation' -Points 5 -Reason "Bicep compiles successfully"
        }
    } catch {
        Write-Host "  ⚠️ Bicep build failed" -ForegroundColor Red
    }
    
    # Lint check
    try {
        $LintResult = bicep lint $MainBicep 2>&1
        if ($LintResult -notmatch 'error|warning') {
            Add-Score -Category 'Implementation' -Points 5 -Reason "Bicep lints clean"
        } else {
            Add-Score -Category 'Implementation' -Points 2 -Reason "Bicep lints with warnings"
        }
    } catch {
        Write-Verbose "Lint check skipped"
    }
    
    # Naming conventions
    if ($BicepContent -match "uniqueString\(resourceGroup\(\)\.id\)") {
        Add-Score -Category 'Implementation' -Points 5 -Reason "Unique naming convention used"
    }
    
    # Security hardening
    if ($BicepContent -match "minimumTlsVersion.*TLS1_2" -and $BicepContent -match "httpsOnly.*true") {
        Add-Score -Category 'Implementation' -Points 5 -Reason "Security hardening applied"
    }
    
    # Modular structure
    if (Test-Path (Join-Path $BicepPath "modules")) {
        Add-Score -Category 'Implementation' -Points 5 -Reason "Modular structure used"
    }
} else {
    Write-Host "  ⚠️ main.bicep not found at $BicepPath" -ForegroundColor Red
}

# 4. DEPLOYMENT (20 pts)
Write-Host "`n🚀 Deployment (20 pts)" -ForegroundColor Yellow
if (-not $SkipAzureCheck -and $ResourceGroupName) {
    try {
        $RG = az group show --name $ResourceGroupName 2>&1 | ConvertFrom-Json
        if ($RG) {
            Add-Score -Category 'Deployment' -Points 4 -Reason "Resource group exists"
            
            $Resources = az resource list --resource-group $ResourceGroupName 2>&1 | ConvertFrom-Json
            if ($Resources.Count -gt 0) {
                Add-Score -Category 'Deployment' -Points 8 -Reason "Resources deployed ($($Resources.Count) resources)"
                
                if ($Resources | Where-Object { $_.type -like '*sites*' }) {
                    Add-Score -Category 'Deployment' -Points 4 -Reason "App Service running"
                }
            }
        }
    } catch {
        Write-Host "  ⚠️ Could not verify Azure deployment" -ForegroundColor Red
    }
} else {
    # Check for deployment summary
    $DeploySummary = Join-Path $ArtifactPath "06-deployment-summary.md"
    if (Test-Path $DeploySummary) {
        Add-Score -Category 'Deployment' -Points 4 -Reason "Deployment summary documented"
        
        $DeployContent = Get-Content $DeploySummary -Raw
        if ($DeployContent -match 'what.?if|preview') {
            Add-Score -Category 'Deployment' -Points 4 -Reason "What-If executed"
        }
        if ($DeployContent -match 'success|completed|provisioned') {
            Add-Score -Category 'Deployment' -Points 8 -Reason "Deployment succeeded"
        }
    }
    
    # Check for deploy script
    $DeployScript = Join-Path $BicepPath "deploy.ps1"
    if (Test-Path $DeployScript) {
        Add-Score -Category 'Deployment' -Points 4 -Reason "Deploy script present"
    }
}

# 5. DOCUMENTATION (10 pts)
Write-Host "`n📚 Documentation (10 pts)" -ForegroundColor Yellow
$AllArtifacts = @(
    "01-requirements.md",
    "02-architecture-assessment.md",
    "04-implementation-plan.md"
)
$Present = 0
foreach ($Artifact in $AllArtifacts) {
    if (Test-Path (Join-Path $ArtifactPath $Artifact)) {
        $Present++
    }
}
if ($Present -eq $AllArtifacts.Count) {
    Add-Score -Category 'Documentation' -Points 4 -Reason "All core artifacts present"
} elseif ($Present -gt 0) {
    Add-Score -Category 'Documentation' -Points 2 -Reason "$Present of $($AllArtifacts.Count) artifacts present"
}

# Design artifacts
$DesignArtifacts = Get-ChildItem -Path $ArtifactPath -Filter "03-des-*.md" -ErrorAction SilentlyContinue
if ($DesignArtifacts.Count -gt 0) {
    Add-Score -Category 'Documentation' -Points 3 -Reason "Design artifacts created"
}

# Formatting check (sample)
if ((Test-Path $ReqFile) -and (Get-Content $ReqFile -Raw) -match '^#\s') {
    Add-Score -Category 'Documentation' -Points 3 -Reason "Clear markdown formatting"
}

# 6. LOAD TESTING (+5 pts)
Write-Host "`n⚡ Load Testing (+5 pts)" -ForegroundColor Yellow
$LoadTestFile = Join-Path $ArtifactPath "05-load-test-results.md"
if (Test-Path $LoadTestFile) {
    $LoadContent = Get-Content $LoadTestFile -Raw
    Add-Score -Category 'LoadTesting' -Points 2 -Reason "Load test executed"
    
    if ($LoadContent -match 'target|threshold|P95') {
        Add-Score -Category 'LoadTesting' -Points 1 -Reason "Targets documented"
    }
    if ($LoadContent -match 'result|pass|fail|observation') {
        Add-Score -Category 'LoadTesting' -Points 2 -Reason "Results analyzed"
    }
} else {
    Write-Host "  ℹ️ No load test results found" -ForegroundColor DarkGray
}

# 7. BONUS POINTS (+25 max)
Write-Host "`n🌟 Bonus Points (+25 max)" -ForegroundColor Yellow
if (Test-Path $MainBicep) {
    $BicepContent = Get-Content $MainBicep -Raw
    
    # Zone Redundancy (+5)
    if ($BicepContent -match 'zoneRedundant.*true' -or $BicepContent -match 'P1v3|P2v3|P3v3') {
        Add-Score -Category 'Bonus' -Points 5 -Reason "Zone redundancy configured"
    }
    
    # Private Endpoints (+5)
    if ($BicepContent -match 'privateEndpoint|private.*endpoint') {
        Add-Score -Category 'Bonus' -Points 5 -Reason "Private endpoints configured"
    }
    
    # Multi-Region DR (+10)
    if ($BicepContent -match 'germanywestcentral|secondary.*location|enableDR') {
        Add-Score -Category 'Bonus' -Points 10 -Reason "Multi-region DR implemented"
    }
    
    # Managed Identities (+5)
    if ($BicepContent -match "identity.*SystemAssigned|managedIdentity") {
        Add-Score -Category 'Bonus' -Points 5 -Reason "Managed identities used"
    }
}

# Calculate Total
$Score.Total = $Score.Requirements + $Score.Architecture + $Score.Implementation +
               $Score.Deployment + $Score.Documentation + $Score.LoadTesting + $Score.Bonus

# Display Results
Write-Host "`n" + "=" * 50
Write-Host "📊 FINAL SCORE: $($Score.Total)/130" -ForegroundColor Cyan
Write-Host "=" * 50
Write-Host "  Requirements:    $($Score.Requirements)/20"
Write-Host "  Architecture:    $($Score.Architecture)/25"
Write-Host "  Implementation:  $($Score.Implementation)/25"
Write-Host "  Deployment:      $($Score.Deployment)/20"
Write-Host "  Documentation:   $($Score.Documentation)/10"
Write-Host "  Load Testing:    $($Score.LoadTesting)/5"
Write-Host "  Bonus:           $($Score.Bonus)/25"
Write-Host ""

# Grade
$Percentage = [math]::Round(($Score.Total / 130) * 100, 1)
$Grade = switch ($Percentage) {
    { $_ -ge 90 } { "🏆 OUTSTANDING" }
    { $_ -ge 80 } { "🥇 EXCELLENT" }
    { $_ -ge 70 } { "🥈 GOOD" }
    { $_ -ge 60 } { "🥉 SATISFACTORY" }
    default       { "📚 NEEDS IMPROVEMENT" }
}
Write-Host "Grade: $Grade ($Percentage%)" -ForegroundColor Green

# Save results
$ResultFile = Join-Path $ArtifactPath "score-results.json"
if ($PSCmdlet.ShouldProcess($ResultFile, "Save score results")) {
    $Score | ConvertTo-Json -Depth 10 | Set-Content -Path $ResultFile -Encoding UTF8
    Write-Host "`n💾 Results saved to: $ResultFile" -ForegroundColor DarkGray
}

return $Score
