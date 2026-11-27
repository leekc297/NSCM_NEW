# Claude Code UserPromptSubmit hook — 프롬프트에 화면ID + 신규/생성 의도가 있으면 하네스 절차와 GEN_NOTES 를 컨텍스트로 붙인다.
# 2026-11-26 개선안 20261126164445_VISION_5(사용자 승인 16:4x): ① VMO 가 띄운 Claude(env VIBE_ORCH=1)에는 붙이지 않음(harness-stop-gate 와 같은 기준)
#   ② 화면ID 와 의도 단어가 같은 문장(줄바꿈, 마침표 기준)에 있을 때만 발동 ③ 폴더 판정: 폴더 없음 / 폴더 있고 GEN_NOTES.md 없음 / GEN_NOTES.md 있음
#   사례: 11-26 16:40 VMO 컨설팅 프롬프트 개선안 목록의 SSP0020 언급에 '(Doc\gen\SSP0020 없음 — 1) 부터 실행)' 이 붙음. 폴더는 11-13 부터 있음
$ErrorActionPreference = 'Stop'
if ($env:VIBE_ORCH -eq '1') { exit 0 }
try { $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch { exit 0 }
$p = "$($payload.prompt)"
$rxId = '\b(DMF|SCP|SSP|SCM|SYS|COM|SDM)\d{4}(_\d{2})?\b'
$rxIntent = '신규|생성|만들|개발|이식|구현|새 화면|new screen|generate|implement'
$id = $null
foreach ($s in [regex]::Split($p, '[\r\n]+|(?<=[.!?。])\s+')) {
  $m = [regex]::Match($s, $rxId)
  if ($m.Success -and ($s -match $rxIntent)) { $id = $m.Value; break }
}
if (-not $id) { exit 0 }
$root = if ($env:NSCM_ROOT) { $env:NSCM_ROOT } else { 'C:\Projects\NSCM' }
$gen = "$root\Doc\gen\$id"
$lines = @("[Harness] 화면 $id 신규 개발 절차 (tools/Harness/prompts/new_screen.md 전문 Read 필수):",
  "1) 골격은 사람이 아니라 생성기가 만든다: powershell -File C:\Projects\NSCM\tools\Harness\new-screen.ps1 $id  (이미 Doc\gen\$id 가 있으면 생략)",
  "2) 생성본의 TODO(이식) 지점만 채운다. 사전(rules/map_*.csv) 규칙 부분은 바꾸지 않는다.",
  "3) 저장할 때마다 check.js 가 돌고, 작업 종료 시 --final 게이트가 __asis-mapping__.md 의 미구현 0 을 요구한다.")
if (Test-Path "$gen\GEN_NOTES.md") { $lines += ""; $lines += (Get-Content "$gen\GEN_NOTES.md" -Raw -Encoding UTF8) }
elseif (Test-Path $gen) { $lines += "   (Doc\gen\$id 있음, 생성 메모 GEN_NOTES.md 없음. new-screen.ps1 다시 실행 금지(커밋본 덮어쓰기 방지). 2) 부터 진행)" }
else { $lines += "   (Doc\gen\$id 없음 — 1) 부터 실행)" }
$lines -join "`n"
exit 0
