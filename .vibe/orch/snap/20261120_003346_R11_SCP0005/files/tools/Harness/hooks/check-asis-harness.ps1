# Claude Code PostToolUse hook — To-Be 화면 폴더 저장 시 하네스 게이트(check.js) 실행
#   BLOCK → exit 2 (stderr 가 Claude 에게 전달되어 즉시 수정)
#   WARN  → additionalContext 로 Claude 에게 전달 (차단 없음)
$ErrorActionPreference = 'Stop'
try { $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch { exit 0 }
if ($payload.tool_name -notmatch '^(Write|Edit|MultiEdit)$') { exit 0 }
$path = $payload.tool_input.file_path
if (-not $path -or $path -notmatch '[\\/]features[\\/].*[\\/]pages[\\/]') { exit 0 }
if ($path -notmatch '\.(tsx?|md)$') { exit 0 }
$harness = "C:\Projects\NSCM\tools\Harness"
$out = & node "$harness\check.js" --file $path --json 2>&1 | Out-String
$code = $LASTEXITCODE
if ($code -eq 2) {
  try { $j = $out | ConvertFrom-Json; $msg = ($j.findings | Where-Object level -eq 'BLOCK' | ForEach-Object { "  x $($_.code) $($_.msg) @$($_.where)" }) -join "`n" } catch { $msg = $out }
  [Console]::Error.WriteLine("[Harness BLOCK] 아래 위반을 고치기 전에는 진행 불가 (rules: $harness\rules):`n$msg")
  exit 2
}
if ($code -eq 1) {
  try { $j = $out | ConvertFrom-Json; $msg = ($j.findings | Select-Object -First 25 | ForEach-Object { "  ! $($_.code) $($_.msg) @$($_.where)" }) -join "`n" } catch { $msg = $out }
  $ctx = "[Harness WARN] $($j.id) 미완료 항목 — __asis-mapping__.md 의 미구현을 구현으로 바꾸려면 해당 로직을 이식하고 위치를 적을 것:`n$msg"
  @{ hookSpecificOutput = @{ hookEventName = 'PostToolUse'; additionalContext = $ctx } } | ConvertTo-Json -Compress -Depth 4
}
exit 0
