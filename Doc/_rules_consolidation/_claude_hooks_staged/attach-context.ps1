# Claude Code UserPromptSubmit hook — 프롬프트 키워드에 따라 룰 문서 자동 첨부
#
# Input  : stdin JSON {"prompt":"...", ...}
# Output : stdout (AI 컨텍스트에 첨부됨) + exit 0
# Target : 모든 UserPromptSubmit
# 2026-06-18 갱신 (R-3): 진입점 단일화(RULESET_MASTER) 반영 + 아카이브된 v1 경로 → v2 캐노니컬 경로 교체
#                        + UI mandatory / 화면 수정(T01M) 키워드 그룹 추가
#   ※ 본 파일은 staged 사본. 적용: C:\Projects\NSCM\.claude\hooks\attach-context.ps1 로 복사 (APPLY.md 참조)

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

# 키워드 → 문서 매핑 (단일 진입 = RULESET_MASTER)
$attachments = @()

# SQL / DBeaver / INSERT / SP / Oracle 관련 (T08/T10/T19)
if ($prompt -imatch 'SQL|INSERT|DELETE|UPDATE|DBeaver|ORA-|PLS-|PROC_M|MSG_M|MNU_M|API_M|SHEET_COLUMNS|USER_GR|\bSP\b|PKG_|cursor|MERGE') {
  $attachments += "$v2\anti-simplification.md"
  $attachments += "$v2\hooks\oracle-db-workflow.md"
  $attachments += "$memRoot\feedback_dbeaver_sql_mandatory_grep.md"
  $attachments += "$memRoot\feedback_sql_dual_output.md"
  $attachments += "$memRoot\reference_scm_adm_user_gr_btn_mpg_m.md"
}

# FE / import / 화면 / Grid / Modal 관련 (T04/T05/T06)
if ($prompt -imatch 'import|컴포넌트|화면|tsx|모달|Wijmo|Grid|DataGrid|Form|Dropdown|CustomDialog|SearchArea|combo|cascade') {
  $attachments += "$cons\RULESET_MASTER.md"
  $attachments += "$v2\hooks\datagrid-shared-component-mandatory.md"
  $attachments += "$v2\hooks\screen-shell-composition-mandatory.md"
  $attachments += "$memRoot\feedback_no_type_cast_around_runtime.md"
  $attachments += "$memRoot\reference_pnpm_scripts.md"
}

# As-Is 매핑 관련 (T02/T03)
if ($prompt -imatch 'as-is|As-Is|매핑|validation|expression|이벤트|핸들러|\.cs\b') {
  $attachments += "$v2\hooks\asis-coverage-check.md"
}

# 신규 화면 생성 관련 (T01 — 최우선 강제: UI-MANDATORY 체크리스트)
if ($prompt -imatch '화면\s*(생성|추가|신규|만들|개발|작성)|신규\s*화면|to-be\s*화면|create\s+(new\s+)?(screen|page)|new\s+(screen|page)|add\s+(screen|page)|build\s+page|(DMF|FPF|SCF|SSF|CMF|SPF|MNF|ATF)\d{4}.*(만들|추가|생성|작성|개발|create|build|add)') {
  $attachments += "$v2\anti-simplification.md"
  $attachments += "$cons\RULESET_MASTER.md"
  $attachments += "$v2\hooks\ui-dynamic-property-management.md"
  $attachments += "$v2\hooks\screen-conventions-mandatory.md"
  $attachments += "$v2\hooks\regression-zero-mandatory.md"
  $attachments += "$v2\hooks\screen-completion-gate.md"
  $attachments += "$memRoot\feedback_new_screen_mandatory.md"
}

# 화면 수정 관련 (T01M — 기존 화면 변경 시 regression 0 + column 재작업)
if ($prompt -imatch '(화면|컬럼|column|grid|속성|메타).*(수정|변경|고쳐|바꿔|재작업|modify|change|update|fix|rework)|(수정|변경|재작업).*(화면|컬럼|column|grid)') {
  $attachments += "$cons\RULESET_MASTER.md"
  $attachments += "$v2\hooks\regression-zero-mandatory.md"
  $attachments += "$v2\hooks\column-meta-rework-checklist.md"
}

if ($attachments.Count -eq 0) { exit 0 }

# 중복 제거
$attachments = $attachments | Select-Object -Unique

Write-Output "===== AUTO-ATTACHED RULE CONTEXT (attach-context hook) ====="
Write-Output "The following rules are MANDATORY for this task. Do not skip verification steps."
Write-Output "Single entry: RULESET_MASTER.md (Doc/_rules_consolidation). UI work: pass RULESET_MASTER 3 (UI-MANDATORY checklist)."
Write-Output ""

foreach ($f in $attachments) {
  if (Test-Path -LiteralPath $f) {
    $name = Split-Path -Leaf $f
    Write-Output "----- BEGIN: $name -----"
    Get-Content -LiteralPath $f -Raw -Encoding UTF8
    Write-Output ""
    Write-Output "----- END: $name -----"
    Write-Output ""
  }
}

Write-Output "===== END AUTO-ATTACHED RULE CONTEXT ====="
exit 0
