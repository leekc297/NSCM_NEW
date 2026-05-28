# Claude Code PostToolUse hook — DBeaver SQL 금지 패턴 차단
#
# Input  : stdin JSON {"tool_name":"Write|Edit|...", "tool_input": {"file_path":"..."}}
# Output : stderr 메시지 (위반 시) + exit 2 (차단)
# Rule   : memory feedback_dbeaver_sql_mandatory_grep.md + Doc/_dev_rules/21_TROUBLESHOOTING.md
# Target : **/*_DBeaver*.sql

$ErrorActionPreference = 'Stop'
try {
  $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
  exit 0   # JSON 파싱 실패 시 무시 (다른 hook 영향 방지)
}

$toolName = $payload.tool_name
if ($toolName -notmatch '^(Write|Edit|MultiEdit)$') { exit 0 }

$path = $payload.tool_input.file_path
if (-not $path) { exit 0 }
if ($path -notmatch '_DBeaver.*\.sql$') { exit 0 }
if (-not (Test-Path -LiteralPath $path)) { exit 0 }

$body = Get-Content -LiteralPath $path -Raw -Encoding UTF8
$forbidden = '(?m)^(SET\s|PROMPT\s|DEFINE\s|UNDEFINE\s|&\w|/\s*$|EXEC\s|@@|CONNECT\s|SPOOL\s|WHENEVER\s)'

if ($body -match $forbidden) {
  $token = $Matches[1].Trim()
  $lineNo = ($body -split "`n" | Select-String -Pattern $forbidden -CaseSensitive -List | Select-Object -First 1).LineNumber
  [Console]::Error.WriteLine("BLOCK [check-dbeaver-sql]: $path")
  [Console]::Error.WriteLine("  -> Forbidden SQL*Plus token detected: '$token' (line $lineNo)")
  [Console]::Error.WriteLine("  -> DBeaver files MUST NOT contain SQL*Plus commands (causes ORA-00922).")
  [Console]::Error.WriteLine("  -> Remove this line. DBMS_OUTPUT uses DBeaver's Output panel (no SET SERVEROUTPUT needed).")
  [Console]::Error.WriteLine("  -> Reference: memory/feedback_dbeaver_sql_mandatory_grep.md")
  exit 2
}

exit 0
