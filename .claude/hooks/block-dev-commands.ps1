# Claude Code PreToolUse hook — local 환경에서 실수로 실행되면 안 되는 명령 차단
#
# Input  : stdin JSON {"tool_name":"Bash", "tool_input": {"command":"..."}}
# Output : stdout JSON ({permissionDecision: "deny"}) — 매칭 시
#
# 차단 대상 (선행 환경변수 prefix `VAR=val ...` 포함):
#   pnpm install / i / type-check / typecheck / build / dev / local /
#        update / add / remove / lint   (= PC profile 차단 리스트와 동일)
#   pnpm run lint  (run wrapper 우회 차단, 2026-06-17 사용자 명시 추가)
#   pnpm exec turbo run dev
#   turbo run dev / turbo run lint
#   eslint <path>  (lint 도구 직접 호출 차단, 2026-06-17)
#
# Bash + PowerShell 둘 다 검사 (2026-06-17): PowerShell tool 로 우회 시도 차단.
#
# Escape:
#   ALLOW_PNPM=1 prefix 가 있으면 통과 (PC profile 과 동일 규약).
#
# 정상 서버 기동:
#   cd C:\Projects\NSCM\nscm-fe\apps\web
#   .\node_modules\.bin\vite

$ErrorActionPreference = 'Stop'
try {
  $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
  exit 0
}

if ($payload.tool_name -notin @('Bash', 'PowerShell')) { exit 0 }
$cmd = $payload.tool_input.command
if (-not $cmd) { exit 0 }

# 선행 환경변수 (VAR=value ...) 제거 후 검사 — `COREPACK_ENABLE_STRICT=0 pnpm dev` 같은 우회 차단.
# 단, ALLOW_PNPM=1 prefix 가 있으면 사용자 의도적 우회로 간주하고 통과.
if ($cmd -match '(^|\s)ALLOW_PNPM=1?\b') { exit 0 }

$stripped = $cmd -replace '^(\s*[A-Za-z_][A-Za-z0-9_]*=\S+\s+)+', ''

$pnpmSubs = 'install|i|type-check|typecheck|build|dev|local|update|add|remove|lint'

$patterns = @(
  @{ Re = "(^|[;&|`(\s])pnpm\s+($pnpmSubs)(\s|$)";              Name = 'pnpm <blocked-sub>' },
  @{ Re = "(^|[;&|`(\s])pnpm\s+run\s+($pnpmSubs)(\s|$)";        Name = 'pnpm run <blocked-sub>' },
  @{ Re = '(^|[;&|`(\s])pnpm\s+exec\s+turbo\s+run\s+(dev|lint)\b'; Name = 'pnpm exec turbo run <dev|lint>' },
  @{ Re = '(^|[;&|`(\s])turbo\s+run\s+(dev|lint)\b';            Name = 'turbo run <dev|lint>' },
  @{ Re = '(^|[;&|`(\s])eslint\s+';                              Name = 'eslint <path>' }
)

foreach ($p in $patterns) {
  if ($stripped -match $p.Re -or $cmd -match $p.Re) {
    $reason = @(
      "BLOCKED: '$($p.Name)' 명령은 local 에서 실수 방지를 위해 차단되었습니다.",
      "차단 리스트 (pnpm): install / i / type-check / typecheck / build / dev / local / update / add / remove / lint",
      "차단 리스트 (별도): pnpm run <sub> / turbo run dev / turbo run lint / eslint <path>",
      "",
      "lint 는 클라우드에서만 실행 (사용자 2026-06-17 명시).",
      "AI 는 변경 파일 목록 보고 → 사용자/클라우드 lint 결과 회신 받아 추가 fix.",
      "",
      "FE 서버 기동은 다음 명령을 사용하세요:",
      "  cd C:\Projects\NSCM\nscm-fe\apps\web",
      "  .\node_modules\.bin\vite",
      "",
      "사용자 본인이 의도적으로 실행할 경우 escape:",
      "  ALLOW_PNPM=1 pnpm <sub>",
      "",
      "참고: .claude/hooks/block-dev-commands.ps1 + ~/.bashrc + PS profiles"
    ) -join "`n"

    $out = @{
      hookSpecificOutput = @{
        hookEventName            = 'PreToolUse'
        permissionDecision       = 'deny'
        permissionDecisionReason = $reason
      }
    } | ConvertTo-Json -Compress -Depth 5

    Write-Output $out
    exit 0
  }
}

exit 0
