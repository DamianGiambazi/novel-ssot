# seal-check-v4.ps1 — was the Vault 4 key sealed, and pushed, before the first contract was pasted?
#   Set-Location $BOOK; .\spine\seal-check-v4.ps1
# Before any contract it prints SEALED_BEFORE_CONTRACTS (no contract pasted yet). After, it compares the seal with the
# first contract bundle in the paste log (bundle.ps1 writes UTC times). Chunk B's question is not a contract.
$ErrorActionPreference = 'Stop'
$Dev  = if ($env:V4_DEV) { $env:V4_DEV } else { 'C:\Dev' }
$log  = "$Dev\v4-work\answers\pastes.jsonl"
$seal = git log -1 --format='%cI|%h' -- spine/PREDICTION-V4.md
if (-not $seal) { 'NO_SEAL  spine\PREDICTION-V4.md is not committed'; exit 1 }
$when, $hash = $seal -split '\|'
$sealUtc = ([DateTimeOffset]::Parse($when, [Globalization.CultureInfo]::InvariantCulture)).UtcDateTime
$up = git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null
$pushed = $up -and (git branch -r --contains $hash 2>$null | Where-Object { $_.Trim() -eq $up })
"prediction sealed : $($sealUtc.ToString('yyyy-MM-dd HH:mm:ss'))Z  ($hash)"
"on GitHub         : $(if ($pushed) { "yes ($up contains the seal)" } else { 'NO' })"
$first = $null
if (Test-Path $log) {
    $first = Get-Content $log -Encoding utf8 | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json -DateKind String } |
             Where-Object { $_.bundle -like 'C*' } | Select-Object -First 1
}
if (-not $pushed) { 'SEAL_NOT_PUSHED  git push, then run this again'; exit 1 }
if (-not $first) { "first contract    : none yet"; 'SEALED_BEFORE_CONTRACTS  (no contract has been pasted)'; exit 0 }
$firstUtc = ([DateTimeOffset]::Parse($first.ts, [Globalization.CultureInfo]::InvariantCulture)).UtcDateTime
"first contract    : $($firstUtc.ToString('yyyy-MM-dd HH:mm:ss'))Z  ($($first.bundle))"
if ($sealUtc -lt $firstUtc) { 'SEALED_BEFORE_CONTRACTS' } else { 'SEAL_AFTER_CONTRACTS  the key was sealed after a contract ran'; exit 1 }
