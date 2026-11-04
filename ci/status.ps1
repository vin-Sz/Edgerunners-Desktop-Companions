# What GitHub's Actions last said about a branch, and why anything failed, without opening the website or installing gh.
#   ./ci/status.ps1                this branch
#   ./ci/status.ps1 -Branch main   another branch
# It runs nothing on this PC. GitHub allows 60 of these calls an hour without a login; set GITHUB_TOKEN to get more.
param([string]$Branch)
$ErrorActionPreference = 'Stop'
$api = 'https://api.github.com/repos/vin-Sz/Edgerunners-Desktop-Companions'
$headers = @{ 'User-Agent' = 'edgerunners-ci-status' }
if ($env:GITHUB_TOKEN) { $headers['Authorization'] = 'Bearer ' + $env:GITHUB_TOKEN }
if (-not $Branch) { $Branch = (git rev-parse --abbrev-ref HEAD).Trim() }

# Results only cover what's been pushed, so say when this PC has commits GitHub hasn't tested.
$ahead = git rev-list --count "origin/$Branch..$Branch" 2>$null
$global:LASTEXITCODE = 0
if ($ahead -and [int]$ahead -gt 0) { Write-Output "$Branch has $ahead commit(s) here that GitHub hasn't seen, so these results don't cover them." }

$runs = (Invoke-RestMethod -Headers $headers -Uri ("$api/actions/runs?per_page=30&branch=" + [uri]::EscapeDataString($Branch))).workflow_runs
if (-not $runs) { Write-Output "No runs on $Branch."; return }

# Only the newest run of each workflow.
foreach ($group in @($runs | Group-Object name)) {
    $run = $group.Group | Sort-Object { [datetime]$_.created_at } -Descending | Select-Object -First 1
    $result = if ($run.status -eq 'completed') { $run.conclusion } else { $run.status }
    Write-Output ("{0}: {1} ({2}, {3})" -f $run.name, $result, $run.head_sha.Substring(0, 7), $run.html_url)
    if ($run.status -ne 'completed' -or $run.conclusion -eq 'success') { continue }
    foreach ($job in @((Invoke-RestMethod -Headers $headers -Uri $run.jobs_url).jobs | Where-Object { $_.conclusion -ne 'success' })) {
        $failedSteps = @($job.steps | Where-Object { $_.conclusion -eq 'failure' } | ForEach-Object { $_.name }) -join ', '
        Write-Output ("  {0}: {1}{2}" -f $job.name, $job.conclusion, $(if ($failedSteps) { " at $failedSteps" } elseif (-not $job.steps) { ' before it started (no machine picked it up)' } else { '' }))
        foreach ($note in @(Invoke-RestMethod -Headers $headers -Uri "$api/check-runs/$($job.id)/annotations")) {
            if ($note.annotation_level -ne 'failure' -or $note.message -like 'Process completed with exit code*') { continue }
            Write-Output ('    ' + ($note.message -replace "`r?`n", "`n    "))
        }
    }
}
