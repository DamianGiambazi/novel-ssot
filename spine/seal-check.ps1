# seal-check.ps1 — was the prediction committed before the run started? Run from the repo root.
$sealed = [datetimeoffset](git log -1 --format=%cI -- spine/PREDICTION.md)
$run    = [datetimeoffset](Get-Content (Get-Item receipts\*_run_manifest.json).FullName -Raw |
                           ConvertFrom-Json -DateKind String).started_utc
"prediction sealed : {0:u}" -f $sealed.UtcDateTime
"run started       : {0:u}" -f $run.UtcDateTime
if ($sealed -lt $run) { "SEALED_BEFORE_RUN" } else { Write-Error "SEAL_BROKEN: prediction committed after the run" }
