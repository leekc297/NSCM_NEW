# Claude Code PostToolUse hook — INSERT 문에서 NOT NULL 컬럼 누락 차단
#
# Input  : stdin JSON {"tool_name", "tool_input": {"file_path"}}
# Output : stderr 메시지 + exit 2
# Rule   : Doc/_dev_rules/hooks/anti-simplification.md §1.4 (DDL 5層 cross-check)
# Target : **/sql/*.sql
# DDL 소스 : To-be_v2_converted/03_GTT/02_GTT_OTHER_part4.sql

$ErrorActionPreference = 'Stop'
try {
  $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
  exit 0
}

$toolName = $payload.tool_name
if ($toolName -notmatch '^(Write|Edit|MultiEdit)$') { exit 0 }
$path = $payload.tool_input.file_path
if (-not $path) { exit 0 }
if ($path -notmatch '[\\/]sql[\\/].*\.sql$') { exit 0 }
if (-not (Test-Path -LiteralPath $path)) { exit 0 }

# DDL 기반 NOT NULL 룩업 (DEFAULT 없는 컬럼은 INSERT 시 명시 의무)
# Source: To-be_v2_converted/03_GTT/02_GTT_OTHER_part4.sql
$ddlRequired = @{
  'SCM_ADM_USER_GR_MNU_BTN_MPG_M' = @('USER_GR_ID','MNU_ID','SHT_NM','MNU_BTN_CD','USE_YN','CREATED_BY','LAST_UPDATED_BY')
  'SCM_ADM_USER_GR_MNU_MPG_M'     = @('USER_GR_ID','MNU_ID','USE_YN','CREATED_BY','LAST_UPDATED_BY')
  'SCM_ADM_MNU_BTN_MPG_M'         = @('MNU_ID','SHT_NM','MNU_BTN_CD','USE_YN','CREATED_BY','LAST_UPDATED_BY')
  'SCM_ADM_MNU_M'                 = @('MNU_ID','MNU_MSG_ID','SORT_ORD','MNU_LV_NO','MNU_TP_CD','UNIT_TP_CD','USE_YN','CREATED_BY','LAST_UPDATED_BY')
  'SCM_ADM_MSG_M'                 = @('MSG_ID','LANG_CD','MSG_TP_CD','USE_YN','CREATED_BY','LAST_UPDATED_BY')
  'SCM_ADM_API_M'                 = @('API_ID','API_TP_CD','API_MSG_ID','API_URL','USE_YN','CREATED_BY','LAST_UPDATED_BY')
}

$body = Get-Content -LiteralPath $path -Raw -Encoding UTF8

# INSERT INTO <TABLE> (<cols>) 패턴 매칭 (multi-line, 대소문자 무시)
$insertPattern = '(?is)INSERT\s+(?:ALL\s+)?INTO\s+([A-Z_][A-Z0-9_]*)\s*\(([^)]+)\)'
$matches = [regex]::Matches($body, $insertPattern)

$violations = @()
foreach ($m in $matches) {
  $table = $m.Groups[1].Value.ToUpper()
  if (-not $ddlRequired.ContainsKey($table)) { continue }
  $cols = ($m.Groups[2].Value -split '[,\s]+' | Where-Object { $_ }) | ForEach-Object { $_.Trim().ToUpper() }
  $missing = $ddlRequired[$table] | Where-Object { $cols -notcontains $_ }
  if ($missing.Count -gt 0) {
    $lineNo = ($body.Substring(0, $m.Index) -split "`n").Count
    $violations += "  -> Table $table (line $lineNo): missing NOT NULL columns: $($missing -join ', ')"
  }
}

if ($violations.Count -gt 0) {
  [Console]::Error.WriteLine("BLOCK [check-notnull-insert]: $path")
  $violations | ForEach-Object { [Console]::Error.WriteLine($_) }
  [Console]::Error.WriteLine("  -> NOT NULL columns without DEFAULT must be explicitly listed (avoids ORA-01400).")
  [Console]::Error.WriteLine("  -> Reference: anti-simplification.md §1.4 + memory/reference_scm_adm_user_gr_btn_mpg_m.md")
  exit 2
}

exit 0
