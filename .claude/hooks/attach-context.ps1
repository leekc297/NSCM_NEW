# Claude Code UserPromptSubmit hook — 프롬프트 키워드에 따라 룰 문서 자동 첨부 (v3, 2026-10-12 재구성)
#
# Input  : stdin JSON {"prompt":"...", ...}
# Output : stdout (AI 컨텍스트에 첨부됨) + exit 0  (차단 없음)
#
# v3 변경 (속도 ↔ 누락 0 양립):
#   1) LITE 판별 — 산출물이 생기지 않는 질의/확인 프롬프트는 룰 전문을 첨부하지 않는다 (1줄 안내만).
#      · 강제: 프롬프트 앞 `!full` = 항상 FULL / `!lite` = 항상 LITE
#   2) FULL 에서도 RULESET_MASTER.md(159KB) 전문 첨부 중단 → 경량 추출본 TRIGGER_ROUTER.md(14KB) 첨부.
#      T01/T01M 은 UI_MANDATORY_CHECKLIST.md(19KB, MASTER §3 추출본) 를 추가 첨부.
#   3) 첨부 상한 — 합계 120KB 초과 시 초과분은 본문 대신 "경로만" 안내 (check-rules-read 가 Read 를 강제하므로 누락되지 않음).
#   4) 첨부한 hook 목록을 `REQUIRED-READ:` 줄로 출력 → check-rules-read.ps1 / 사용자 추적용.
# 구 버전 = attach-context.ps1.bak_20261012

$ErrorActionPreference = 'Stop'
try {
  $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
  exit 0
}

$prompt = "$($payload.prompt)"
if (-not $prompt) { exit 0 }

$root = "C:\Projects\NSCM"
$v2   = "$root\Doc\_rules_v2"
$cons = "$root\Doc\_rules_consolidation"
$memRoot = "C:\Users\ejene\.claude\projects\C--Projects-NSCM\memory"
$maxBytes = 120KB

# ── 0. 모드 판별 ─────────────────────────────────────────────────────────────
$forceFull = $prompt -match '^\s*!full\b'
$forceLite = $prompt -match '^\s*!lite\b'
$p = $prompt -replace '^\s*!(full|lite)\b\s*', ''

# 산출물이 생기는 동사 (하나라도 있으면 FULL)
$actionRe = '만들|생성|작성|수정|변경|추가|삭제|적용|구현|변환|배포|이관|저장해|고쳐|바꿔|재작업|보완|리팩|정정|등록|반영|패치|컴파일|빌드|실행해|돌려|테스트\s*케이스|분석서|설계서|패키지|' +
            '\b(create|implement|add|update|write|refactor|deploy|apply|migrate|fix|modify|change|generate|build|convert|register|patch|rework)\b'
# 질의 신호 (짧고 물음 형태)
$questionRe = '\?|뭐|무엇|어디|몇|왜|어떻게|알려|설명|확인만|보여|있나|인가|인지|맞나|차이|의미|뜻|\b(what|where|which|why|how|explain|show)\b'

$isLite = $false
if ($forceLite) { $isLite = $true }
elseif ($forceFull) { $isLite = $false }
elseif ($p.Length -lt 300 -and $p -imatch $questionRe -and $p -inotmatch $actionRe) { $isLite = $true }

if ($isLite) {
  Write-Output "===== attach-context: [LITE] 질의 모드 ====="
  Write-Output "룰 전문 미첨부. 즉답하되 답의 근거가 룰/메타이면 해당 hook 1개만 Read 한다 (Doc/_rules_v2/hooks/<name>.md)."
  Write-Output "답이 불확실하면 추측 대신 확인할 파일 경로를 제시한다. 요청이 파일 생성/수정으로 바뀌면 Doc/_rules_consolidation/TRIGGER_ROUTER.md 를 먼저 Read 한다."
  Write-Output "첫 줄에 [LITE] 를 표기한다. (강제 전환: 프롬프트 앞에 !full)"
  Write-Output "===== END ====="
  exit 0
}

# ── 1. FULL — 키워드 → 문서 매핑 (T# 분기는 TRIGGER_ROUTER 가 담당, 여기서는 진입 hook 만) ──
$attachments = @()
$triggers = @()
$attachments += "$v2\anti-simplification.md"
$attachments += "$cons\TRIGGER_ROUTER.md"

# SQL / DBeaver / INSERT / SP / Oracle (T08/T10/T18/T19)
if ($p -imatch 'SQL|INSERT|DELETE|UPDATE|DBeaver|ORA-|PLS-|PROC_M|MSG_M|MNU_M|API_M|SHEET_COLUMNS|USER_GR|\bSP\b|PKG_|cursor|MERGE|\bDB\b|PKG|패키지|프로시저|재반영|원복') {
  $triggers += 'T08/T10/T18/T19'
  $attachments += "$v2\hooks\oracle-db-workflow.md"
  $attachments += "$v2\hooks\db-source-refresh-before-work.md"
  $attachments += "$memRoot\feedback_dbeaver_sql_mandatory_grep.md"
  $attachments += "$memRoot\feedback_sql_dual_output.md"
  $attachments += "$memRoot\reference_scm_adm_user_gr_btn_mpg_m.md"
}

# FE / import / 화면 / Grid / Modal (T04/T05/T06)
if ($p -imatch 'import|컴포넌트|화면|tsx|모달|Wijmo|Grid|DataGrid|Form|Dropdown|CustomDialog|SearchArea|combo|cascade') {
  $triggers += 'T04/T05/T06'
  $attachments += "$v2\hooks\datagrid-shared-component-mandatory.md"
  $attachments += "$v2\hooks\screen-shell-composition-mandatory.md"
  $attachments += "$memRoot\feedback_no_type_cast_around_runtime.md"
  $attachments += "$memRoot\reference_pnpm_scripts.md"
}

# As-Is 매핑 (T02/T03)
if ($p -imatch 'as-is|As-Is|매핑|validation|expression|이벤트|핸들러|\.cs\b') {
  $triggers += 'T02/T03'
  $attachments += "$v2\hooks\asis-coverage-check.md"
}

# 신규 화면 생성 (T01)
if ($p -imatch '화면\s*(생성|추가|신규|만들|개발|작성)|신규\s*화면|신규\s*생성|신규\s*UI|to-be\s*화면|create\s+(new\s+)?(screen|page)|new\s+(screen|page)|add\s+(screen|page)|build\s+page|(DMF|FPF|SCF|SSF|CMF|SPF|MNF|ATF)\d{4}.*(만들|추가|생성|작성|개발|create|build|add)') {
  $triggers += 'T01'
  $attachments += "$cons\UI_MANDATORY_CHECKLIST.md"
  $attachments += "$v2\hooks\ui-work-entry-playbook.md"
  $attachments += "$v2\hooks\ui-dynamic-property-management.md"
  $attachments += "$v2\hooks\screen-conventions-mandatory.md"
  $attachments += "$v2\hooks\regression-zero-mandatory.md"
  $attachments += "$v2\hooks\screen-completion-gate.md"
  $attachments += "$memRoot\feedback_new_screen_mandatory.md"
}

# 화면 수정 (T01M)
if ($p -imatch '보완|(화면|컬럼|column|grid|속성|메타|UI|팝업|popup|modal|모달).*(수정|변경|교체|고쳐|바꿔|재작업|modify|change|update|fix|rework)|(수정|변경|재작업).*(화면|컬럼|column|grid|UI)') {
  $triggers += 'T01M'
  $attachments += "$cons\UI_MANDATORY_CHECKLIST.md"
  $attachments += "$v2\hooks\ui-work-entry-playbook.md"
  $attachments += "$v2\hooks\regression-zero-mandatory.md"
  $attachments += "$v2\hooks\column-meta-rework-checklist.md"
}

$attachments = $attachments | Select-Object -Unique
$existing = @($attachments | Where-Object { Test-Path -LiteralPath $_ })

Write-Output "===== AUTO-ATTACHED RULE CONTEXT (attach-context v3) [FULL] ====="
Write-Output ("TRIGGER-HINT: " + ($(if ($triggers.Count) { $triggers -join ', ' } else { 'T00 (키워드 미매칭 — TRIGGER_ROUTER 에서 직접 T# 선택)' })))
Write-Output ("REQUIRED-READ: " + (($existing | ForEach-Object { Split-Path -Leaf $_ }) -join ', '))
Write-Output "The following rules are MANDATORY for this task. Do not skip verification steps."
Write-Output "Route with TRIGGER_ROUTER.md (T#), then Read every core hook of that row from Doc/_rules_v2/hooks/. UI work: pass UI_MANDATORY_CHECKLIST.md before writing."
Write-Output "Start your first reply with: [T# 적용: ... / Read: ...]"
Write-Output ""

$used = 0
$deferred = @()
foreach ($f in $existing) {
  $len = (Get-Item -LiteralPath $f).Length
  $name = Split-Path -Leaf $f
  if (($used + $len) -gt $maxBytes) { $deferred += $f; continue }
  $used += $len
  Write-Output "----- BEGIN: $name -----"
  Get-Content -LiteralPath $f -Raw -Encoding UTF8
  Write-Output ""
  Write-Output "----- END: $name -----"
  Write-Output ""
}
if ($deferred.Count -gt 0) {
  Write-Output "----- NOT INLINED (size cap $([int]($maxBytes/1KB))KB) — Read these files yourself before writing: -----"
  $deferred | ForEach-Object { Write-Output "  Read: $_" }
  Write-Output ""
}
Write-Output "===== END AUTO-ATTACHED RULE CONTEXT ====="
exit 0
