# Claude Code PreToolUse hook — local 환경에서 실수로 실행되면 안 되는 명령 차단
#
# Input  : stdin JSON {"tool_name":"Bash", "tool_input": {"command":"..."}}
# Output : stdout JSON ({permissionDecision: "deny"}) — 매칭 시
# 차단 대상 (선행 환경변수 prefix `VAR=val ...` 포함):
#   - pnpm dev / pnpm install
#   - pnpm exec turbo run dev
#   - turbo run dev
# 정상 서버 기동:
#   cd C:\Projects\NSCM\nscm-fe\apps\web
#   .\node_modules\.bin\vite

$ErrorActionPreference = 'Stop'
try {
  $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
  exit 0
}

if ($payload.tool_name -ne 'Bash') { exit 0 }
$cmd = $payload.tool_input.command
if (-not $cmd) { exit 0 }

# 선행 환경변수 (VAR=value ...) 제거 후 검사 — `COREPACK_ENABLE_STRICT=0 pnpm dev` 같은 우회 차단
$stripped = $cmd -replace '^(\s*[A-Za-z_][A-Za-z0-9_]*=\S+\s+)+', ''

$patterns = @(
  @{ Re = '(^|[;&|`(\s])pnpm\s+dev(\s|$)';                  Name = 'pnpm dev' },
  @{ Re = '(^|[;&|`(\s])pnpm\s+install(\s|$)';              Name = 'pnpm install' },
  @{ Re = '(^|[;&|`(\s])pnpm\s+i(\s|$)';                    Name = 'pnpm i' },
  @{ Re = '(^|[;&|`(\s])pnpm\s+exec\s+turbo\s+run\s+dev\b'; Name = 'pnpm exec turbo run dev' },
  @{ Re = '(^|[;&|`(\s])turbo\s+run\s+dev\b';               Name = 'turbo run dev' }
)

foreach ($p in $patterns) {
  if ($stripped -match $p.Re -or $cmd -match $p.Re) {
    $reason = @(
      "BLOCKED: '$($p.Name)' 명령은 local 에서 실수 방지를 위해 차단되었습니다.",
      "",
      "FE 서버 기동은 다음 명령을 사용하세요:",
      "  cd C:\Projects\NSCM\nscm-fe\apps\web",
      "  .\node_modules\.bin\vite",
      "",
      "참고: .claude/hooks/block-dev-commands.ps1"
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
