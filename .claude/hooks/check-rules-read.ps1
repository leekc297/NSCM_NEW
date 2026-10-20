# Claude Code PreToolUse hook — 필수 룰 hook 미열람 상태의 파일 작성 차단 (2026-10-12 신설)
#
# Input  : stdin JSON {"tool_name":"Write|Edit|MultiEdit","tool_input":{"file_path":"..."},"transcript_path":"..."}
# Output : stderr 사유 + exit 2 (차단 → Claude 가 사유를 읽고 해당 hook Read 후 재시도)
# 목적   : "룰이 누락되어 잘못된 답" 을 구조적으로 차단. 문서 hook 은 AI 가 읽지 않으면 효력이 없으므로
#          '읽었는가' 자체를 transcript 에서 검사한다 (Read 도구 호출 또는 attach-context 첨부 모두 인정).
# 우회   : 환경변수 NSCM_SKIP_RULE_READ=1  (긴급 핫픽스 전용 — 사용 시 보고 의무)
# 대상 → 필수 hook 매핑 (경로 분류별, 최소 집합 — 추가는 아래 $rules 표에 1줄)

$ErrorActionPreference = 'Stop'
if ($env:NSCM_SKIP_RULE_READ -eq '1') { exit 0 }
if ($env:VIBE_HARNESS -eq '1') { exit 0 }  # Vibe_Manager 하네스(claude -p) 실행 중 — 룰은 tools/VibeManager/rules/10_RULES_KEEP.md 로 주입 (2026-10-19)
try {
  $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
  exit 0
}
if ($payload.tool_name -notmatch '^(Write|Edit|MultiEdit)$') { exit 0 }
$path = $payload.tool_input.file_path
if (-not $path) { exit 0 }
$norm = ($path -replace '\\', '/')
$transcript = $payload.transcript_path
if (-not $transcript -or -not (Test-Path -LiteralPath $transcript)) { exit 0 }  # transcript 없으면 판정 불가 → 통과

# 룰/설정 파일 자체를 편집하는 경우는 제외
if ($norm -match '/(Doc/_rules_v2|Doc/_rules_consolidation|\.claude)/') { exit 0 }

# ── 경로 분류 → 필수 hook (파일명만. 존재 여부 = Read 호출 또는 attach 첨부 흔적) ──
$rules = @(
  @{ name = 'FE 화면 페이지'; re = '/nscm-fe/features/[^/]+/src/pages/.*\.(ts|tsx)$';
     req = @('TRIGGER_ROUTER.md', 'ui-work-entry-playbook.md', 'ui-dynamic-property-management.md', 'regression-zero-mandatory.md') },
  @{ name = 'FE 공용(foundation/shared)'; re = '/nscm-fe/packages/.*\.(ts|tsx|scss)$';
     req = @('TRIGGER_ROUTER.md', 'regression-zero-mandatory.md') },
  @{ name = 'BE Java'; re = '/nscm-be/src/main/.*\.(java|xml)$';
     req = @('TRIGGER_ROUTER.md', 'be-api-contract-ui.md', 'be-infrastructure-reuse.md') },
  @{ name = 'DB 객체/적용 SQL·PY'; re = '/(_artifacts|To-be_v2_converted)/.*\.(sql|py)$';
     req = @('oracle-db-workflow.md', 'db-source-refresh-before-work.md') }
)

$hit = $null
foreach ($r in $rules) { if ($norm -match $r.re) { $hit = $r; break } }
if (-not $hit) { exit 0 }

# 원복/백업/임시 파일은 제외
if ($norm -match '(?i)(ROLLBACK|BACKUP|\.ASIS\.|/99_[^/]*$|/_tmp|scratch)') { exit 0 }

$text = [IO.File]::ReadAllText($transcript)
$missing = @()
foreach ($h in $hit.req) {
  # 인정 근거 2종만: ① Read 도구 호출  "file_path":"...hook.md"   ② attach-context 본문 첨부  "BEGIN: hook.md"
  #   (경로가 단순 '언급'된 것 — NOT INLINED 안내, 본 hook 의 차단 메시지, 요약문 — 은 인정하지 않음)
  $esc = [regex]::Escape($h)
  $seen = [regex]::IsMatch($text, 'file_path\"\s*:\s*\"[^\"]*' + $esc) -or $text.Contains("BEGIN: $h")
  if (-not $seen) { $missing += $h }
}
if ($missing.Count -eq 0) { exit 0 }

[Console]::Error.WriteLine("BLOCK [check-rules-read]: $path  ($($hit.name))")
[Console]::Error.WriteLine("  -> 이 세션에서 아래 필수 룰을 아직 읽지 않았습니다. Read 후 다시 시도하세요 (누락 0 원칙):")
foreach ($m in $missing) {
  $loc = if ($m -match '^(TRIGGER_ROUTER|UI_MANDATORY_CHECKLIST)\.md$') { "Doc/_rules_consolidation/$m" } else { "Doc/_rules_v2/hooks/$m" }
  [Console]::Error.WriteLine("     Read: C:/Projects/NSCM/$loc")
}
[Console]::Error.WriteLine("  -> 긴급 우회(보고 의무): `$env:NSCM_SKIP_RULE_READ='1'")
exit 2
