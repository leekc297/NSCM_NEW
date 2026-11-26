# Claude Code PreToolUse hook — 계획한 구현을 다 끝내기 전에 화면 측정·통합 시험 금지 (2026-11-25 사용자 지시)
#   "아직 잔여 작업이 D2, D3, D4 가 있는데 SCP0005 를 돌렸다는 점이 잘못된 점. 필요한 작업이 있으면 먼저 전체를 진행하고 테스트를 진행.
#    RULE, HOOK, 하네스에도 등록해서 반복되는 실수를 하지 않도록"
#
# Input  : stdin JSON {"tool_name":"Bash"|"PowerShell", "tool_input": {"command":"..."}}
# 판단   : tools/Harness/plan_state.json 에 남은 항목(status todo)이 있으면 아래 명령을 막는다
#   화면 측정·통합 시험 = run_verify.py · checklist_run.py · row_run.py · e2e_suite.py · eg_chain.py · run-e2e.cmd · playwright ... test
# 막지 않음 : 컴파일 검사·자기 시험(tsc, --selftest, engine_selfcheck.py, test/run_all.js), 파일 읽기·수정, DB 조회
# 우회 : 명령 앞 ALLOW_TEST_BEFORE_PLAN=1 (사용자가 '지금 시험하라'고 직접 말한 때만)
# 계획 기록 : python tools/Harness/plan_state.py set|done|drop|status|clear

$ErrorActionPreference = 'Stop'
try { $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch { exit 0 }
if ($payload.tool_name -notin @('Bash', 'PowerShell')) { exit 0 }
$cmd = [string]$payload.tool_input.command
if (-not $cmd) { exit 0 }
if ($cmd -match '(^|\s)ALLOW_TEST_BEFORE_PLAN=1\b') { exit 0 }
if ($cmd -match '--selftest') { exit 0 }

# 실행만 잡음(2026-11-25 sed·grep 으로 파일을 읽는 명령까지 막던 결함 수정): 파이썬 실행 뒤 스크립트, 명령 자리의 run-e2e.cmd, npx/node playwright test
$pats = @(
  '(?:^|[\s;&|(''"])(?:python3?|py)(?:\.exe)?\s+(?:-\S+\s+)*\S*?(run_verify|checklist_run|row_run|e2e_suite|eg_chain)\.py',
  '(?:^|[;&|]\s*|\bcall\s+|\bcmd(?:\.exe)?\s+/c\s+|&\s*[''"]?)\S*(run-e2e)\.cmd',
  '(@playwright[\/]+test[\/]+cli\.js)\s+test\b',
  '\b(?:npx|exec)\s+(playwright)\s+test\b'
)
$hit = $null
foreach ($pt in $pats) { if ($cmd -match $pt) { $hit = $Matches[1]; break } }
if (-not $hit) { exit 0 }

$state = Join-Path $PSScriptRoot '..\..\tools\Harness\plan_state.json'
if (-not (Test-Path $state)) { exit 0 }
try { $s = Get-Content -Raw -Encoding UTF8 $state | ConvertFrom-Json } catch { exit 0 }
$left = @($s.items | Where-Object { $_.status -ne 'done' -and $_.status -ne 'dropped' })
if ($left.Count -eq 0) { exit 0 }

$names = ($left | ForEach-Object { $_.name }) -join ', '
$reason = @(
  "BLOCKED: 계획 '$($s.plan)' 의 구현 항목 $($left.Count)개가 남아 있어 화면 측정·통합 시험($hit)을 하지 않습니다.",
  "남은 항목: $names",
  "사용자 지시(2026-11-25): 필요한 작업이 있으면 먼저 전체를 진행하고 테스트를 진행한다.",
  "할 일: 남은 항목을 모두 구현 → python tools/Harness/plan_state.py done <항목> → 그 뒤 시험.",
  "사용자가 빼라고 한 항목만: python tools/Harness/plan_state.py drop <항목> `"<사유>`"",
  "사용자가 '지금 시험하라'고 직접 말한 경우만 명령 앞에 ALLOW_TEST_BEFORE_PLAN=1"
) -join "`n"
@{ hookSpecificOutput = @{ hookEventName = 'PreToolUse'; permissionDecision = 'deny'; permissionDecisionReason = $reason } } | ConvertTo-Json -Depth 4 -Compress
exit 0
