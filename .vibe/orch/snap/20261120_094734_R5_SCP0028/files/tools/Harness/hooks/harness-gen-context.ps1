# Claude Code UserPromptSubmit hook — 프롬프트에 화면ID + 신규/생성 의도가 있으면 하네스 절차와 GEN_NOTES 를 컨텍스트로 붙인다.
$ErrorActionPreference = 'Stop'
try { $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch { exit 0 }
$p = "$($payload.prompt)"
$m = [regex]::Match($p, '\b(DMF|SCP|SSP|SCM|SYS|COM|SDM)\d{4}(_\d{2})?\b')
if (-not $m.Success) { exit 0 }
if ($p -notmatch '신규|생성|만들|개발|이식|구현|새 화면|new screen|generate|implement') { exit 0 }
$id = $m.Value; $gen = "C:\Projects\NSCM\Doc\gen\$id"
$lines = @("[Harness] 화면 $id 신규 개발 절차 (tools/Harness/prompts/new_screen.md 전문 Read 필수):",
  "1) 골격은 사람이 아니라 생성기가 만든다: powershell -File C:\Projects\NSCM\tools\Harness\new-screen.ps1 $id  (이미 Doc\gen\$id 가 있으면 생략)",
  "2) 생성본의 TODO(이식) 지점만 채운다. 사전(rules/map_*.csv) 규칙 부분은 바꾸지 않는다.",
  "3) 저장할 때마다 check.js 가 돌고, 작업 종료 시 --final 게이트가 __asis-mapping__.md 의 미구현 0 을 요구한다.")
if (Test-Path "$gen\GEN_NOTES.md") { $lines += ""; $lines += (Get-Content "$gen\GEN_NOTES.md" -Raw -Encoding UTF8) }
else { $lines += "   (Doc\gen\$id 없음 — 1) 부터 실행)" }
$lines -join "`n"
exit 0
