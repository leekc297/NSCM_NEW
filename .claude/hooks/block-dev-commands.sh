#!/bin/bash
# Claude Code PreToolUse hook (bash) — local 환경 실수 실행 차단
# block-dev-commands.ps1 의 bash 동등 버전 (2026-06-18 신설, R-7 — Linux/클라우드 parity)
#
# Input  : stdin JSON {"tool_name":"Bash","tool_input":{"command":"..."}}
# Output : stdout JSON ({hookSpecificOutput.permissionDecision:"deny"}) — 매칭 시
# Escape : ALLOW_PNPM=1 prefix 통과
# ※ staged 사본. 적용: .claude/hooks/block-dev-commands.sh 로 복사 + settings.json PreToolUse command 를 bash 로 교체

set -u
PAYLOAD=$(cat)
PY() { printf '%s' "$PAYLOAD" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('$1',''))" 2>/dev/null; }
PY2() { printf '%s' "$PAYLOAD" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('tool_input',{}).get('command',''))" 2>/dev/null; }

TOOL=$(PY tool_name)
case "$TOOL" in
  Bash|PowerShell) ;;
  *) exit 0 ;;
esac

CMD=$(PY2)
[ -z "$CMD" ] && exit 0

# ALLOW_PNPM=1 escape
echo "$CMD" | grep -qE '(^|[[:space:]])ALLOW_PNPM=1?\b' && exit 0

# 선행 환경변수 (VAR=value ...) 제거
STRIPPED=$(printf '%s' "$CMD" | sed -E 's/^([[:space:]]*[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]+[[:space:]]+)+//')

PNPM_SUBS='install|i|type-check|typecheck|build|dev|local|update|add|remove|lint'
declare -a NAMES RES
NAMES=('pnpm <blocked-sub>' 'pnpm run <blocked-sub>' 'pnpm exec turbo run <dev|lint>' 'turbo run <dev|lint>' 'eslint <path>')
RES=(
  "(^|[;&|\`( 	])pnpm[[:space:]]+($PNPM_SUBS)([[:space:]]|\$)"
  "(^|[;&|\`( 	])pnpm[[:space:]]+run[[:space:]]+($PNPM_SUBS)([[:space:]]|\$)"
  "(^|[;&|\`( 	])pnpm[[:space:]]+exec[[:space:]]+turbo[[:space:]]+run[[:space:]]+(dev|lint)\b"
  "(^|[;&|\`( 	])turbo[[:space:]]+run[[:space:]]+(dev|lint)\b"
  "(^|[;&|\`( 	])eslint[[:space:]]+"
)

for i in "${!RES[@]}"; do
  if echo "$STRIPPED" | grep -qE "${RES[$i]}" || echo "$CMD" | grep -qE "${RES[$i]}"; then
    REASON="BLOCKED: '${NAMES[$i]}' 명령은 local 에서 실수 방지를 위해 차단되었습니다.\n차단 리스트 (pnpm): install / i / type-check / typecheck / build / dev / local / update / add / remove / lint\n차단 리스트 (별도): pnpm run <sub> / turbo run dev / turbo run lint / eslint <path>\n\nlint 는 클라우드에서만 실행. FE 서버 기동: cd nscm-fe/apps/web && ./node_modules/.bin/vite\nEscape: ALLOW_PNPM=1 pnpm <sub>"
    python3 - "$REASON" <<'PYEOF'
import sys, json
reason = sys.argv[1].replace('\\n', '\n')
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse",
      "permissionDecision": "deny", "permissionDecisionReason": reason}}))
PYEOF
    exit 0
  fi
done

exit 0
