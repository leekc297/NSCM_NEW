# Claude Code PostToolUse hook — FE 금지 import + 위험 cast 차단
#
# Input  : stdin JSON
# Output : stderr + exit 2 (차단) or exit 1 (경고, non-blocking)
# Rule   : Doc/_dev_rules/23_FE_IMPORT_INVENTORY.md + memory/feedback_no_type_cast_around_runtime.md
# Target : **/features/**/*.{ts,tsx} + **/packages/**/*.{ts,tsx}

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
if ($path -notmatch '\.tsx?$') { exit 0 }
if ($path -notmatch '[\\/](features|packages|apps)[\\/]') { exit 0 }
if (-not (Test-Path -LiteralPath $path)) { exit 0 }

$body = Get-Content -LiteralPath $path -Raw -Encoding UTF8
$lines = $body -split "`n"

$violations = @()
$warnings = @()

# import 구문 전체 매칭 — group1: 심볼 리스트, group2: 소스 ('@shared/components' or '@shared/lges')
# multiline import 도 매칭 ([\s\S]*?)
$importPattern = "(?m)import\s*(?:type\s+)?\{\s*([\s\S]*?)\s*\}\s*from\s+['""](@shared/components|@shared/lges)['""]"

$fixMap = @{
  '@shared/components' = @{
    'Dialog'          = "Use 'CustomDialog' from '@shared/components'"
    'DateRangePicker' = "Use 'DatePickerCalendar' from '@shared/lges' (usecase='date-range-multi')"
    'MonthPicker'     = "Use 'DatePickerCalendar' from '@shared/lges' (usecase='month-single')"
    'Button'          = "Move to '@shared/lges'"
    'InputField'      = "Move to '@shared/lges'"
    'CheckboxField'   = "Use 'Checkbox' from '@shared/lges'"
  }
  '@shared/lges' = @{
    'CheckboxField'   = "Use 'Checkbox' from '@shared/lges' (CheckboxField does not exist)"
  }
}

$matchesImport = [regex]::Matches($body, $importPattern)
foreach ($m in $matchesImport) {
  $symbolsRaw = $m.Groups[1].Value
  $source = $m.Groups[2].Value
  $lineNo = ($body.Substring(0, $m.Index) -split "`n").Count
  # 심볼 분리 (콤마/공백/줄바꿈)
  $symbols = $symbolsRaw -split '[,\s]+' | Where-Object { $_ -and $_ -notmatch '^type$' }
  foreach ($sym in $symbols) {
    $clean = $sym.Trim()
    # 'as alias' 처리: "Foo as Bar" → "Foo"
    if ($clean -match '^(\w+)') { $clean = $Matches[1] }
    if ($fixMap[$source].ContainsKey($clean)) {
      $violations += "  -> line $lineNo : invalid import '$clean' from '$source'. $($fixMap[$source][$clean])"
    }
  }
}

# 경고 패턴: as unknown as ... (런타임 폭발 위험)
$rule3 = '(?m)as\s+unknown\s+as\s+'
$m3 = [regex]::Matches($body, $rule3)
foreach ($m in $m3) {
  $lineNo = ($body.Substring(0, $m.Index) -split "`n").Count
  $warnings += "  -> line $lineNo : 'as unknown as X' forced cast. Verify runtime safety (memory/feedback_no_type_cast_around_runtime.md)."
}

# 출력 + exit code 결정
if ($violations.Count -gt 0) {
  [Console]::Error.WriteLine("BLOCK [check-fe-import]: $path")
  $violations | ForEach-Object { [Console]::Error.WriteLine($_) }
  if ($warnings.Count -gt 0) {
    [Console]::Error.WriteLine("WARN [check-fe-import]:")
    $warnings | ForEach-Object { [Console]::Error.WriteLine($_) }
  }
  [Console]::Error.WriteLine("  -> Reference: Doc/_dev_rules/23_FE_IMPORT_INVENTORY.md")
  exit 2
}

if ($warnings.Count -gt 0) {
  [Console]::Error.WriteLine("WARN [check-fe-import]: $path")
  $warnings | ForEach-Object { [Console]::Error.WriteLine($_) }
  exit 1   # non-blocking warning
}

exit 0
