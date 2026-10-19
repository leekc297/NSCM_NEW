# Claude Code PostToolUse hook — DB 작업 최신 원문 기준 강제 (hook #152 db-source-refresh-before-work)
#
# Input  : stdin JSON {"tool_name":"Write|Edit|MultiEdit", "tool_input": {"file_path":"..."}}
# Output : stderr 메시지 (위반 시) + exit 2 (차단)
# Rule   : Doc/_rules_v2/hooks/db-source-refresh-before-work.md
# Target : _artifacts/**/*.sql  — CREATE OR REPLACE 객체 DDL → SOURCE-FRESH 스탬프(FETCHED 24h 이내) 필수
#          _artifacts/**/*.py   — CREATE OR REPLACE 포함 → DB 재조회(ALL_SOURCE/USER_SOURCE/DBMS_METADATA) + FRESH-GATE 토큰 필수
# Skip   : 원복·백업 전용 파일 (ROLLBACK / BACKUP / .ASIS. / 00_BACKUP / 99_)

$ErrorActionPreference = 'Stop'
try {
  $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
  exit 0
}

if ($payload.tool_name -notmatch '^(Write|Edit|MultiEdit)$') { exit 0 }
$path = $payload.tool_input.file_path
if (-not $path) { exit 0 }
$norm = $path -replace '\\', '/'
if ($norm -notmatch '/_artifacts/') { exit 0 }
if ($norm -notmatch '\.(sql|py)$') { exit 0 }
if ($norm -match '(?i)(ROLLBACK|BACKUP|\.ASIS\.|/99_[^/]*$)') { exit 0 }
if (-not (Test-Path -LiteralPath $path)) { exit 0 }

$body = Get-Content -LiteralPath $path -Raw -Encoding UTF8
if (-not $body) { exit 0 }
$ddl = '(?i)CREATE\s+OR\s+REPLACE\s+(EDITIONABLE\s+|NONEDITIONABLE\s+)?(PACKAGE|PROCEDURE|FUNCTION|TRIGGER|VIEW|TYPE)\b'

function Block([string[]]$lines) {
  [Console]::Error.WriteLine("BLOCK [check-db-fresh-source]: $path")
  foreach ($l in $lines) { [Console]::Error.WriteLine("  -> $l") }
  [Console]::Error.WriteLine("  -> Rule: Doc/_rules_v2/hooks/db-source-refresh-before-work.md (#152) — DB 작업은 새로고침한 최신 원문 기준")
  exit 2
}

if ($norm -match '\.sql$') {
  if ($body -notmatch $ddl) { exit 0 }
  $m = [regex]::Match($body, '(?im)^\s*--\s*SOURCE-FRESH:.*?FETCHED=(\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2})')
  if (-not $m.Success) {
    Block @("객체 DDL 파일에 SOURCE-FRESH 스탬프가 없습니다.",
            "기준 원문을 지금 DB 에서 다시 조회(ALL_SOURCE + ALL_OBJECTS.LAST_DDL_TIME)한 뒤 파일 머리에 기록하세요:",
            "-- SOURCE-FRESH: SCM_MGR.<NAME> <TYPE> LAST_DDL=<YYYY-MM-DD HH24:MI:SS> FETCHED=<YYYY-MM-DD HH:MM> DB=ZIOUI1",
            "신규 객체: -- SOURCE-FRESH: NEW-OBJECT SCM_MGR.<NAME> <TYPE> FETCHED=<YYYY-MM-DD HH:MM> DB=ZIOUI1")
  }
  $fetched = [datetime]::ParseExact(($m.Groups[1].Value -replace 'T', ' '), 'yyyy-MM-dd HH:mm', $null)
  $age = (Get-Date) - $fetched
  if ($age.TotalHours -gt 24 -or $age.TotalMinutes -lt -10) {
    Block @("SOURCE-FRESH FETCHED=$($m.Groups[1].Value) — 조회 후 $([int]$age.TotalHours)시간 경과(허용 24h).",
            "DB 원문을 새로 조회해 변경 여부(LAST_DDL·마커)를 확인하고, 최신 원문 기준으로 파일을 다시 만드세요.")
  }
  exit 0
}

# .py — DDL 을 실행하거나 생성하는 스크립트
if ($body -notmatch '(?i)CREATE\s+OR\s+REPLACE') { exit 0 }
$missing = @()
if ($body -notmatch '(?i)\b(ALL_SOURCE|USER_SOURCE|DBA_SOURCE|DBMS_METADATA)\b') { $missing += "DB 원문 재조회(ALL_SOURCE/USER_SOURCE/DBMS_METADATA) 코드가 없습니다 — 로컬 파일을 기준본으로 쓰지 마세요." }
if ($body -notmatch 'FRESH-GATE') { $missing += "FRESH-GATE 가 없습니다 — 적용/추출 직전 DB 원문을 다시 읽어 기준본과 같은지 assert 하고 'FRESH-GATE' 주석을 남기세요." }
if ($missing.Count -gt 0) { Block $missing }
exit 0
