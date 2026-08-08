# Claude Code PostToolUse hook — SHEET_COLUMNS 메타 SQL 값 단언 (2026-08-07 신설)
#
# Input  : stdin JSON
# Output : stderr + exit 2 (차단) or exit 1 (경고, non-blocking)
# Rule   : Doc/_archive/work_reports/2026-08-06_SYS0017_root_cause_audit.md §2 #4·#5 (메타 오등록 계보)
#          + hooks/corp-meta-integrity-and-wiring.md §6 (값 단언) + deploy-package-completeness §1.0-C
# Target : Write/Edit 로 저장되는 *.sql 중 SHEET_COLUMNS INSERT/UPDATE 포함 파일
#
# 검사 3종:
#   M-A CELL_CONTROL_OBJECT_TYPE_CODE 화이트리스트 밖 값                     [BLOCK]
#       화이트리스트 = column-config.ts CELL_CONTROL_TYPE 실값 파싱(FP* 14종) + 'S'(hidden
#       용도 실데이터 존재 — 감사 §5 'S' 61행/4화면) + NULL. 단문자 'C' 등 미정의값 = BLOCK.
#   M-B INPUT_TP_CD 미정의 코드 (CELL_INPUT_EDIT_TYPE {S,O,M,IO,IM} 밖 — 'MI' typo 등)  [BLOCK]
#   M-C INSERT 세트 전 행 INPUT_TP_CD='IM' 단일 코드 (편집 화면 전면 잠금 의심 — SYS0017 #4)  [WARN]
#       파일 주석에 'READONLY-SHEET' 명시 시 통과.
#
# 주의: HORIZONTAL_ALIGN_CODE 의 'C'(center) 는 정상값 — 반드시 INSERT 컬럼 목록 positional
#       매핑으로 CELL_CONTROL_OBJECT_TYPE_CODE 값만 판정한다 (naive grep 금지).

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
if ($path -notmatch '\.sql$') { exit 0 }
if (-not (Test-Path -LiteralPath $path)) { exit 0 }

$body = Get-Content -LiteralPath $path -Raw -Encoding UTF8
if ($body -notmatch 'SHEET_COLUMNS') { exit 0 }
if ($body -notmatch '(?i)\b(INSERT|UPDATE)\b') { exit 0 }

# ── 화이트리스트: column-config.ts CELL_CONTROL_TYPE 실값 파싱 (원천 단일화) ──
$ctrlWhitelist = @('S')  # 'S' = hidden 용도 실데이터 존재 (감사 §5) — 허용
$configPath = 'C:/Projects/NSCM/nscm-fe/packages/foundation/src/constants/column-config.ts'
if (Test-Path -LiteralPath $configPath) {
  $cfg = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8
  $enumMatch = [regex]::Match($cfg, 'enum\s+CELL_CONTROL_TYPE\s*\{([^}]*)\}', 'Singleline')
  if ($enumMatch.Success) {
    foreach ($m in [regex]::Matches($enumMatch.Groups[1].Value, "=\s*'([^']+)'")) {
      $ctrlWhitelist += $m.Groups[1].Value
    }
  }
}
if ($ctrlWhitelist.Count -le 1) {
  # 파싱 실패 시 fallback (2026-08-07 column-config.ts 실측 스냅샷) — 원천 파일 우선
  $ctrlWhitelist += @('FPModal','FPComboBox','FPButton','FPDate','FPDateMonth','FPDateTime','FPDateText',
                      'FPCheckBox','FPNumberText','FPTextBox','FPPercent','FPText','FPNumber','FPMultiLineTextBox')
}
$inputWhitelist = @('S','O','M','IO','IM')  # CELL_INPUT_EDIT_TYPE

function Get-LineNo([string]$text, [int]$index) {
  return ($text.Substring(0, $index) -split "`n").Count
}

function Split-TopLevel([string]$list) {
  # 최상위 콤마 분할 — 작은따옴표('' escape 포함)·괄호 내부 보호
  $items = New-Object System.Collections.Generic.List[string]
  $sb = New-Object System.Text.StringBuilder
  $depth = 0; $inQ = $false
  for ($i = 0; $i -lt $list.Length; $i++) {
    $ch = $list[$i]
    if ($inQ) {
      [void]$sb.Append($ch)
      if ($ch -eq "'") {
        if ($i + 1 -lt $list.Length -and $list[$i + 1] -eq "'") { [void]$sb.Append($list[$i + 1]); $i++ }
        else { $inQ = $false }
      }
      continue
    }
    switch ($ch) {
      "'" { $inQ = $true; [void]$sb.Append($ch); continue }
      '(' { $depth++; [void]$sb.Append($ch); continue }
      ')' { $depth--; [void]$sb.Append($ch); continue }
      ',' {
        if ($depth -eq 0) { $items.Add($sb.ToString()); [void]$sb.Clear(); continue }
        [void]$sb.Append($ch); continue
      }
      default { [void]$sb.Append($ch) }
    }
  }
  if ($sb.Length -gt 0) { $items.Add($sb.ToString()) }
  return @($items | ForEach-Object { $_.Trim() })
}

function Get-LiteralValue([string]$token) {
  # 'X' → X / NULL → $null / 그 외(SYSDATE 등) → 함수토큰 표시
  $t = $token.Trim()
  if ($t -match "^'(.*)'$") { return $Matches[1].Replace("''", "'") }
  if ($t -match '^(?i)NULL$') { return $null }
  return "«$t»"
}

$violations = @()
$warnings = @()
$imValues = @()   # INSERT 행별 INPUT_TP_CD 수집 (M-C)

# ── INSERT 문 파싱 (positional 매핑) ─────────────────────────────────────────
$insertRe = [regex]'(?is)INSERT\s+INTO\s+[A-Z0-9_."]*SHEET_COLUMNS[A-Z0-9_."]*\s*\((?<cols>[^)]*)\)\s*VALUES\s*\((?<vals>(?:[^()'']|''(?:[^'']|'''')*''|\((?:[^()]|\([^()]*\))*\))*)\)'
foreach ($m in $insertRe.Matches($body)) {
  $lineNo = Get-LineNo $body $m.Index
  $cols = @((Split-TopLevel $m.Groups['cols'].Value) | ForEach-Object { $_.Trim('"').ToUpper() })
  $vals = @(Split-TopLevel $m.Groups['vals'].Value)
  if ($cols.Count -ne $vals.Count) {
    $warnings += "  -> line $lineNo : INSERT column/value count mismatch ($($cols.Count) vs $($vals.Count)) — positional check skipped for this stmt."
    continue
  }
  $ci = [array]::IndexOf($cols, 'CELL_CONTROL_OBJECT_TYPE_CODE')
  if ($ci -ge 0) {
    $v = Get-LiteralValue $vals[$ci]
    if ($null -ne $v -and $v -notlike '«*' -and $ctrlWhitelist -notcontains $v) {
      $violations += "  -> line $lineNo : CELL_CONTROL_OBJECT_TYPE_CODE '$v' not in whitelist (column-config.ts CELL_CONTROL_TYPE FP* + 'S' + NULL). 'C' etc. undefined value breaks dataMap auto-wiring (SYS0017 #5). Use 'FPComboBox' etc."
    }
  }
  $ii = [array]::IndexOf($cols, 'INPUT_TP_CD')
  if ($ii -ge 0) {
    $v = Get-LiteralValue $vals[$ii]
    if ($null -ne $v -and $v -notlike '«*') {
      $imValues += $v
      if ($inputWhitelist -notcontains $v) {
        $violations += "  -> line $lineNo : INPUT_TP_CD '$v' not in CELL_INPUT_EDIT_TYPE (S/O/M/IO/IM)."
      }
    }
  }
}

# ── UPDATE 문 파싱 — SET 절만 판정 (WHERE 조건절의 구값 참조는 정상: 8/6 fix SQL 선례) ──
$updateRe = [regex]'(?is)UPDATE\s+[A-Z0-9_."]*SHEET_COLUMNS[A-Z0-9_."]*\s+SET\s+(?<set>.*?)(?=\bWHERE\b|;|$)'
foreach ($u in $updateRe.Matches($body)) {
  $setClause = $u.Groups['set'].Value
  $setBase = $u.Groups['set'].Index
  foreach ($m in [regex]::Matches($setClause, "(?i)CELL_CONTROL_OBJECT_TYPE_CODE\s*=\s*'([^']*)'")) {
    $v = $m.Groups[1].Value
    $lineNo = Get-LineNo $body ($setBase + $m.Index)
    if ($ctrlWhitelist -notcontains $v) {
      $violations += "  -> line $lineNo : UPDATE SET CELL_CONTROL_OBJECT_TYPE_CODE '$v' not in whitelist (column-config.ts FP* + 'S')."
    }
  }
  foreach ($m in [regex]::Matches($setClause, "(?i)\bINPUT_TP_CD\s*=\s*'([^']*)'")) {
    $v = $m.Groups[1].Value
    $lineNo = Get-LineNo $body ($setBase + $m.Index)
    if ($inputWhitelist -notcontains $v) {
      $violations += "  -> line $lineNo : UPDATE SET INPUT_TP_CD '$v' not in CELL_INPUT_EDIT_TYPE (S/O/M/IO/IM)."
    }
  }
}

# ── M-C: INSERT 세트 전면 'IM' (편집 화면 전면 잠금 의심 — SYS0017 #4) ───────
if ($imValues.Count -gt 0) {
  $distinct = @($imValues | Sort-Object -Unique)
  if ($distinct.Count -eq 1 -and $distinct[0] -eq 'IM' -and $body -notmatch 'READONLY-SHEET') {
    $warnings += "  -> all $($imValues.Count) INSERT rows have INPUT_TP_CD='IM' (search-only). If this screen has editable columns this locks the whole grid (SYS0017 #4: 32-row 'IM' passed review as 'spec'). If intentionally read-only, add comment 'READONLY-SHEET' to this file."
  }
}

# ── 출력 + exit (기존 hook 규약: 2=BLOCK / 1=WARN / 0=PASS) ──────────────────
if ($violations.Count -gt 0) {
  [Console]::Error.WriteLine("BLOCK [check-meta-sql]: $path")
  $violations | ForEach-Object { [Console]::Error.WriteLine($_) }
  if ($warnings.Count -gt 0) {
    [Console]::Error.WriteLine("WARN [check-meta-sql]:")
    $warnings | ForEach-Object { [Console]::Error.WriteLine($_) }
  }
  [Console]::Error.WriteLine("  -> Value assertion standard: hooks/corp-meta-integrity-and-wiring.md `$6 / audit 2026-08-06 `$2 #4-#5")
  exit 2
}
if ($warnings.Count -gt 0) {
  [Console]::Error.WriteLine("WARN [check-meta-sql]: $path")
  $warnings | ForEach-Object { [Console]::Error.WriteLine($_) }
  exit 1
}
exit 0
