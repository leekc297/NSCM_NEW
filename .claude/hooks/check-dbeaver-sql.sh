#!/bin/bash
# Claude Code PostToolUse hook — DBeaver SQL 금지 패턴 차단 (bash 버전, 클라우드용)
# 동일 로직: check-dbeaver-sql.ps1

set -u
PAYLOAD=$(cat)
TOOL_NAME=$(printf '%s' "$PAYLOAD" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('tool_name',''))" 2>/dev/null || echo "")
FILE_PATH=$(printf '%s' "$PAYLOAD" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")

case "$TOOL_NAME" in
  Write|Edit|MultiEdit) ;;
  *) exit 0 ;;
esac

[ -z "$FILE_PATH" ] && exit 0
echo "$FILE_PATH" | grep -qE '_DBeaver.*\.sql$' || exit 0
[ -f "$FILE_PATH" ] || exit 0

VIOLATION=$(grep -nE '^(SET[[:space:]]|PROMPT[[:space:]]|DEFINE[[:space:]]|UNDEFINE[[:space:]]|&[a-zA-Z_]|/[[:space:]]*$|EXEC[[:space:]]|@@|CONNECT[[:space:]]|SPOOL[[:space:]]|WHENEVER[[:space:]])' "$FILE_PATH" | head -3)

if [ -n "$VIOLATION" ]; then
  {
    echo "BLOCK [check-dbeaver-sql]: $FILE_PATH"
    echo "  -> Forbidden SQL*Plus token detected:"
    printf '%s\n' "$VIOLATION" | sed 's/^/     /'
    echo "  -> DBeaver files MUST NOT contain SQL*Plus commands (causes ORA-00922)."
    echo "  -> Remove these lines. DBMS_OUTPUT uses DBeaver's Output panel (no SET SERVEROUTPUT needed)."
    echo "  -> Reference: memory/feedback_dbeaver_sql_mandatory_grep.md"
  } >&2
  exit 2
fi

exit 0
