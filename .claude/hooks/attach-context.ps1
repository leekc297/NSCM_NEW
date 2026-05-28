# Claude Code UserPromptSubmit hook — 프롬프트 키워드에 따라 룰 문서 자동 첨부
#
# Input  : stdin JSON {"prompt":"...", ...}
# Output : stdout (AI 컨텍스트에 첨부됨) + exit 0
# Target : 모든 UserPromptSubmit

$ErrorActionPreference = 'Stop'
try {
  $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
  exit 0
}

$prompt = "$($payload.prompt)"
if (-not $prompt) { exit 0 }

$root = "C:\Projects\NSCM"
$memRoot = "C:\Users\ejene\.claude\projects\C--Projects-NSCM\memory"

# 키워드 → 문서 매핑
$attachments = @()

# SQL / DBeaver / INSERT 관련
if ($prompt -imatch 'SQL|INSERT|DELETE|UPDATE|DBeaver|ORA-|PROC_M|MSG_M|MNU_M|API_M|SHEET_COLUMNS|USER_GR') {
  $attachments += "$root\Doc\_dev_rules\hooks\anti-simplification.md"
  $attachments += "$memRoot\feedback_dbeaver_sql_mandatory_grep.md"
  $attachments += "$memRoot\feedback_sql_dual_output.md"
  $attachments += "$memRoot\reference_scm_adm_user_gr_btn_mpg_m.md"
}

# FE / import / 화면 관련
if ($prompt -imatch 'import|컴포넌트|화면|tsx|모달|Wijmo|Grid|Form|Dropdown|CustomDialog') {
  $attachments += "$root\Doc\_dev_rules\23_FE_IMPORT_INVENTORY.md"
  $attachments += "$root\Doc\_dev_rules\hooks\fe-import-check.md"
  $attachments += "$memRoot\feedback_no_type_cast_around_runtime.md"
  $attachments += "$memRoot\reference_pnpm_scripts.md"
}

# As-Is 매핑 관련
if ($prompt -imatch 'as-is|As-Is|매핑|validation|expression|이벤트|핸들러') {
  $attachments += "$root\Doc\_dev_rules\24_ASIS_CROSSCHECK.md"
  $attachments += "$root\Doc\_dev_rules\hooks\asis-coverage-check.md"
}

# 신규 화면 생성 관련 (룰 25 — 최우선 강제)
# 트리거: "화면 생성|추가|신규|만들어|개발|작성", "to-be 화면", "DMF0099 만들어", "create/new/add screen|page"
if ($prompt -imatch '화면\s*(생성|추가|신규|만들|개발|작성)|신규\s*화면|to-be\s*화면|create\s+(new\s+)?(screen|page)|new\s+(screen|page)|add\s+(screen|page)|build\s+page|(DMF|FPF|SCF|SSF|CMF|SPF|MNF|ATF)\d{4}.*(만들|추가|생성|작성|개발|create|build|add)') {
  $attachments += "$root\Doc\_dev_rules\25_NEW_SCREEN_MANDATORY_CHECKLIST.md"
  $attachments += "$root\Doc\_dev_rules\hooks\new-screen-pre-build.md"
  $attachments += "$root\Doc\_dev_rules\hooks\anti-simplification.md"
  $attachments += "$root\Doc\_dev_rules\17_NEW_SCREEN_QUICKSTART.md"
  $attachments += "$root\Doc\_dev_rules\24_ASIS_CROSSCHECK.md"
  $attachments += "$root\Doc\_dev_rules\hooks\asis-coverage-check.md"
  $attachments += "$memRoot\feedback_new_screen_mandatory.md"
}

if ($attachments.Count -eq 0) { exit 0 }

# 중복 제거
$attachments = $attachments | Select-Object -Unique

Write-Output "===== AUTO-ATTACHED RULE CONTEXT (attach-context hook) ====="
Write-Output "The following rules are MANDATORY for this task. Do not skip verification steps."
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
