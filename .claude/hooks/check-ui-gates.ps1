# Claude Code PostToolUse hook — SYS0017 감사(2026-08-06) 게이트 실행 hook 승격
#
# Input  : stdin JSON
# Output : stderr + exit 2 (차단) or exit 1 (경고, non-blocking)
# Rule   : Doc/_archive/work_reports/2026-08-06_SYS0017_root_cause_audit.md §7
#          + hooks/oracle-save-payload-integrity.md §0 + screen-completion-gate §1-3 + post-write #18~#20·§0.1-B
# Target : **/features/**/pages/**/*.{ts,tsx}
#
# 검출 7종 (신규 UI 생성 시 "지적 이전" 자동 차단):
#   G-A 자체 행상태 필드 (rowStatus/ROW_STATUS/actionFlag) — CRUD_TYPE 전용 위반 [BLOCK]
#   G-B call-proc POST 직후 결과 판정 부재 (인터셉터 false success)          [BLOCK]
#   G-C 감사키 빈문자열 bulk 전송 (map(() => ''))                             [BLOCK]
#   G-D 페이지 util export 함수 미배선 (동일 폴더 import 0건)                 [WARN]
#   G-E 모달 확정/저장 버튼 부재 의심 (2026-08-07 신설 — SYS0017 #7 P9 정량 프록시) [WARN]
#       *Modal*.tsx|*Dialog*.tsx + CustomDialog + customContentArea 인데 <Button 0건.
#       예외: dblClick 확정형 (`dblClick=` prop 존재 — 더블클릭 선택 모달 선례) 통과.
#   G-F 콤보 호출의 빈 .catch (2026-08-08 신설 — hook #117 §5.8)                [BLOCK]
#   G-G 콤보 파라미터 quoting 누락 (2026-08-08 신설 — hook #117 §5.7)           [BLOCK]
#       BE makeComboQuery 는 @토큰 raw 치환 → 미따옴표 = ORA-00904/01722.

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
if ($path -notmatch '[\\/]features[\\/].*[\\/]pages[\\/]') { exit 0 }
if (-not (Test-Path -LiteralPath $path)) { exit 0 }

$body = Get-Content -LiteralPath $path -Raw -Encoding UTF8

$violations = @()
$warnings = @()

function Get-LineNo([string]$text, [int]$index) {
  return ($text.Substring(0, $index) -split "`n").Count
}

# ── G-A: 자체 행상태 필드 (CRUD_TYPE 전용 위반 — SYS0017 #12 계보) ─────────────
$ga = [regex]::Matches($body, '\b(rowStatus|ROW_STATUS|actionFlag)\b')
foreach ($m in $ga) {
  $lineNo = Get-LineNo $body $m.Index
  $violations += "  -> line $lineNo : custom row-state field '$($m.Value)'. Save-row detection MUST use CRUD_TYPE (GridAction/EditTracker). (hook #99 `$0, post-write #18)"
}

# ── G-B: call-proc POST 결과 판정 부재 (false success — SYS0017 #3 계보) ───────
#   apiClient.post('...call-proc...') 이후 400자 안에 판정 술어/헬퍼가 없으면 위반.
#   예외: 직전 5줄 내 AFTER_SAVE/fire-and-forget/DoAfterSave 주석 (의도적 예외 — Lookup.tsx 선례)
$gb = [regex]::Matches($body, 'apiClient\s*\.\s*post[^\n]*call-proc')
foreach ($m in $gb) {
  $lineNo = Get-LineNo $body $m.Index
  # 탐지 창 1200자 — payload 객체(감사키 포함 다열)가 판정보다 앞에 오는 표준 형태 커버
  $tailLen = [Math]::Min(1200, $body.Length - $m.Index)
  $tail = $body.Substring($m.Index, $tailLen)
  $headStart = [Math]::Max(0, $m.Index - 400)
  $head = $body.Substring($headStart, $m.Index - $headStart)
  $exempt = $head -match 'AFTER_SAVE|fire-and-forget|DoAfterSave'
  $judged = $tail -match 'status\s*>=\s*400|\.code\)|Number\([^)]*code|isSaveFailed|alertSaveFailed|assertCallProcOk|checkSaveResult'
  if (-not $judged -and -not $exempt) {
    $violations += "  -> line $lineNo : call-proc POST without result check. Required: 'res.status >= 400 || Number(res.data.code)' (axios interceptor resolves 500/403 = false success). Ref business-plan.api.ts:71 (gate `$1-3, post-write #19)"
  }
}

# ── G-C: 감사키 빈문자열 bulk (silent NULL — SYS0017 #13 계보) ────────────────
$gc1 = [regex]::Matches($body, "(createdBy|lastUpdatedBy)\s*[:=][^\n]*map\(\(\)\s*=>\s*''\)")
foreach ($m in $gc1) {
  $lineNo = Get-LineNo $body $m.Index
  $violations += "  -> line $lineNo : audit key '$($m.Groups[1].Value)' filled with empty strings. Use session.userId (useSessionStore.getState().session.userId). (hook #99 `$0.1, post-write #20)"
}
$gc2 = [regex]::Matches($body, "lastUpdatedBy\s*:\s*''")
foreach ($m in $gc2) {
  $lineNo = Get-LineNo $body $m.Index
  $warnings += "  -> line $lineNo : lastUpdatedBy: '' — if this is a SAVE payload, use session.userId (SEARCH filter usage is OK)."
}

# ── G-D: 페이지 util export 미배선 (절반 구현 — SYS0017 #6 계보) [WARN] ───────
if ($path -match '[\\/]pages[\\/][^\\/]+[\\/](utils[\\/][^\\/]+|[^\\/]+\.util)\.tsx?$') {
  $pageDir = $path
  while ($pageDir -notmatch '[\\/]pages[\\/][^\\/]+$') {
    $pageDir = Split-Path -Parent $pageDir
    if (-not $pageDir) { break }
  }
  if ($pageDir -and (Test-Path -LiteralPath $pageDir)) {
    $exports = [regex]::Matches($body, '(?m)^export\s+(?:const|function)\s+(\w+)')
    $siblings = Get-ChildItem -LiteralPath $pageDir -Recurse -File -Include *.ts, *.tsx |
      Where-Object { $_.FullName -ne (Get-Item -LiteralPath $path).FullName }
    $unref = @()
    foreach ($e in $exports) {
      $name = $e.Groups[1].Value
      $found = $false
      foreach ($f in $siblings) {
        if ((Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8) -match "\b$name\b") { $found = $true; break }
      }
      if (-not $found) { $unref += $name }
    }
    if ($unref.Count -gt 0) {
      $warnings += "  -> unwired util exports (0 imports in page folder): $($unref -join ', ') — wire them or remove. Half-implementation trap (post-write `$0.1-B, SYS0017 #6)."
    }
  }
}

# ── G-E: 모달 확정/저장 버튼 부재 의심 (SYS0017 #7 계보 — customContentArea 는 공통 footer 미렌더) [WARN]
$fileName = Split-Path -Leaf $path
if ($fileName -match '(Modal|Dialog).*\.tsx$') {
  $usesCustomContent = ($body -match 'CustomDialog') -and ($body -match 'customContentArea')
  if ($usesCustomContent) {
    $hasButton = [regex]::IsMatch($body, '<Button\b')
    $isDblClickConfirm = [regex]::IsMatch($body, '\bdblClick\s*=')
    if (-not $hasButton -and -not $isDblClickConfirm) {
      $warnings += "  -> G-E: '$fileName' uses CustomDialog+customContentArea but has 0 <Button and no dblClick= confirm — customContentArea suppresses the shared footer (CustomDialogContent:91~120 mutually-exclusive prop), so OK/Cancel may be missing entirely (SYS0017 #7, runtime-pitfalls P9). Add explicit footer Buttons or dblClick confirm."
    }
  }
}

# ── G-F: 콤보 호출의 조용한 실패 (빈 .catch) [BLOCK] ─────────────────────────
#   hook #117 §5.8 — BE makeComboQuery 는 raw 치환이라 파라미터 실수가 ORA 오류로 나는데,
#   빈 catch 가 이를 삼키면 캐스케이드가 무동작인 채로 "구현" 판정을 통과한다(DMF0082 2026-08-08 실사고).
if ([regex]::IsMatch($body, 'getCombo\s*\([\s\S]{0,600}?\.catch\s*\(\s*\(\s*\)\s*=>\s*\{\s*(/\*[\s\S]*?\*/\s*)?\}\s*\)')) {
  $violations += "  -> G-F: empty .catch on a getCombo call — swallows ORA errors so a broken cascade looks 'implemented'. Use .catch(err => console.error('[combo] <id>', err)) and document the fallback (hook #117 §5.8)."
}

# ── G-G: 콤보 파라미터 quoting 누락 [BLOCK] ──────────────────────────────────
#   hook #117 §5.7 — BaseService.makeComboQuery 는 @토큰을 raw 문자열 치환한다.
#   따옴표 없이 넘기면 `SCM_SITE_ID = KRSL` → ORA-00904 (숫자 컬럼이면 ORA-01722).
foreach ($m in [regex]::Matches($body, "getCombo\s*\(\s*\{([^}]*)\}")) {
  $objBody = $m.Groups[1].Value
  foreach ($pm in [regex]::Matches($objBody, "(?m)(?:^|[{,])\s*([A-Za-z_\$][\w\$]*)\s*:\s*([^,}\r\n]+)")) {
    $k = $pm.Groups[1].Value; $v = $pm.Groups[2].Value.Trim()
    if ($k -eq 'comboId' -or $v -eq '') { continue }
    $ok = $v.StartsWith("'") -or $v.StartsWith('"') -or $v.StartsWith("``'") -or
          [regex]::IsMatch($v, "^(q|quote|qs)\s*\(") -or [regex]::IsMatch($v, '^[\d.]+$') -or
          [regex]::IsMatch($v, "^``[^``]*'\`$\{")
    if (-not $ok) {
      $violations += "  -> G-G: combo param '$k' passed unquoted ($v) — BE substitutes raw text, so this becomes an identifier in SQL (ORA-00904/01722). Wrap with q() or ``'`${...}'`` (hook #117 §5.7)."
    }
  }
}

# ── 출력 + exit ───────────────────────────────────────────────────────────────
if ($violations.Count -gt 0) {
  [Console]::Error.WriteLine("BLOCK [check-ui-gates]: $path")
  $violations | ForEach-Object { [Console]::Error.WriteLine($_) }
  if ($warnings.Count -gt 0) {
    [Console]::Error.WriteLine("WARN [check-ui-gates]:")
    $warnings | ForEach-Object { [Console]::Error.WriteLine($_) }
  }
  [Console]::Error.WriteLine("  -> Root cause audit: Doc/_archive/work_reports/2026-08-06_SYS0017_root_cause_audit.md")
  exit 2
}

if ($warnings.Count -gt 0) {
  [Console]::Error.WriteLine("WARN [check-ui-gates]: $path")
  $warnings | ForEach-Object { [Console]::Error.WriteLine($_) }
  exit 1
}

exit 0
