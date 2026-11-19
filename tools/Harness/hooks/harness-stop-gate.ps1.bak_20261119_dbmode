# Claude Code Stop hook — 이번 작업에서 바뀐 To-Be 화면 폴더에 최종 게이트(check.js --final). 미구현/BLOCK 남으면 종료를 막고 사유를 돌려준다.
$ErrorActionPreference = 'Stop'
try { $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch { exit 0 }
if ($payload.stop_hook_active) { exit 0 }   # 이미 게이트로 재개된 턴 — 무한 루프 방지
$fe = "C:\Projects\NSCM\nscm-fe"; $harness = "C:\Projects\NSCM\tools\Harness"
if (-not (Test-Path "$fe\.git") -and -not (Test-Path "C:\Projects\NSCM\.git")) { exit 0 }
Push-Location $fe
$changed = (& git status --porcelain 2>$null) | ForEach-Object { ($_ -replace '^\s*\S+\s+', '') -replace '"', '' } | Where-Object { $_ -match 'features/[^/]+/src/pages/[^/]+/' }
Pop-Location
if (-not $changed) { exit 0 }
$dirs = $changed | ForEach-Object { ($_ -replace '(features/[^/]+/src/pages/[^/]+)/.*', '$1') } | Sort-Object -Unique
$blocks = @()
foreach ($d in $dirs) {
  $full = Join-Path $fe $d
  if (-not (Test-Path $full)) { continue }
  # 하네스로 생성한 화면(Doc\gen\<ID> 존재)만 최종 게이트 대상 — 기존 화면 수정은 PostToolUse 경고까지만
  $constFile = Get-ChildItem -Path $full -Filter '*.constants.ts' -File -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $constFile) { continue }
  $m = [regex]::Match((Get-Content $constFile.FullName -Raw), "MENU_ID = '([A-Z0-9_]+)'")
  if (-not $m.Success -or -not (Test-Path "C:\Projects\NSCM\Doc\gen\$($m.Groups[1].Value)")) { continue }
  $out = & node "$harness\check.js" --page $full --final 2>&1 | Out-String
  if ($LASTEXITCODE -eq 2) { $blocks += $out }
}
if ($blocks.Count -gt 0) {
  @{ decision = 'block'; reason = "[Harness 최종 게이트] 화면 작업이 끝나지 않았습니다. 아래 항목을 처리하고 __asis-mapping__.md 상태를 갱신하세요.`n" + ($blocks -join "`n") } | ConvertTo-Json -Compress -Depth 3
  exit 0
}
exit 0
