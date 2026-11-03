# seal-check-v3.ps1 — was the Vault 3 prediction committed (and pushed) before the reader's first call?
# Run from the repo root:   .\spine\seal-check-v3.ps1
# In C (before the run) it shows the seal and that no call has happened yet.
# After H it compares the seal with the first line of the call log.
param([string]$Log = 'C:\Dev\novel-door\calls.jsonl')
$commit = git log -1 --format=%H -- spine/PREDICTION-V3.md
if (-not $commit) { Write-Error 'SEAL_MISSING: spine/PREDICTION-V3.md is not committed'; return }
$sealed  = [datetimeoffset](git log -1 --format=%cI $commit)
$pushed  = [bool](git branch -r --contains $commit 2>$null | Select-String 'origin/main')
"prediction sealed : {0:u}  ({1})" -f $sealed.UtcDateTime, $commit.Substring(0,7)
"on GitHub         : {0}" -f $(if ($pushed) { 'yes (origin/main contains the seal)' } else { 'NO: run git push' })
$first = if (Test-Path $Log) { Get-Content $Log -TotalCount 1 } else { $null }
if (-not $first) {
    "first call        : none yet"
    if ($pushed) { 'SEALED_BEFORE_RUN  (no call has been made)' } else { Write-Error 'SEAL_NOT_PUSHED' }
    return
}
$run = [datetimeoffset]::Parse(($first | ConvertFrom-Json -DateKind String).ts)
"first call        : {0:u}" -f $run.UtcDateTime
if ($pushed -and $sealed -lt $run) { 'SEALED_BEFORE_RUN' }
else { Write-Error 'SEAL_BROKEN: the prediction was committed or pushed after the first call' }
