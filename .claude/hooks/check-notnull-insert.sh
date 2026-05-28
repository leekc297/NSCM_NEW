#!/bin/bash
# Claude Code PostToolUse hook — NOT NULL 컬럼 누락 차단 (bash 버전)
# 동일 로직: check-notnull-insert.ps1

set -u
PAYLOAD=$(cat)
TOOL_NAME=$(printf '%s' "$PAYLOAD" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('tool_name',''))" 2>/dev/null || echo "")
FILE_PATH=$(printf '%s' "$PAYLOAD" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")

case "$TOOL_NAME" in
  Write|Edit|MultiEdit) ;;
  *) exit 0 ;;
esac

[ -z "$FILE_PATH" ] && exit 0
echo "$FILE_PATH" | grep -qE '/sql/.*\.sql$' || exit 0
[ -f "$FILE_PATH" ] || exit 0

# Python 한 줄 검증 (NOT NULL 룩업)
python3 - "$FILE_PATH" <<'PYEOF'
import sys, re

required = {
  'SCM_ADM_USER_GR_MNU_BTN_MPG_M': ['USER_GR_ID','MNU_ID','SHT_NM','MNU_BTN_CD','USE_YN','CREATED_BY','LAST_UPDATED_BY'],
  'SCM_ADM_USER_GR_MNU_MPG_M':     ['USER_GR_ID','MNU_ID','USE_YN','CREATED_BY','LAST_UPDATED_BY'],
  'SCM_ADM_MNU_BTN_MPG_M':         ['MNU_ID','SHT_NM','MNU_BTN_CD','USE_YN','CREATED_BY','LAST_UPDATED_BY'],
  'SCM_ADM_MNU_M':                 ['MNU_ID','MNU_MSG_ID','SORT_ORD','MNU_LV_NO','MNU_TP_CD','UNIT_TP_CD','USE_YN','CREATED_BY','LAST_UPDATED_BY'],
  'SCM_ADM_MSG_M':                 ['MSG_ID','LANG_CD','MSG_TP_CD','USE_YN','CREATED_BY','LAST_UPDATED_BY'],
  'SCM_ADM_API_M':                 ['API_ID','API_TP_CD','API_MSG_ID','API_URL','USE_YN','CREATED_BY','LAST_UPDATED_BY'],
}

path = sys.argv[1]
with open(path, 'r', encoding='utf-8', errors='replace') as f:
  body = f.read()

violations = []
pattern = re.compile(r'INSERT\s+(?:ALL\s+)?INTO\s+([A-Z_][A-Z0-9_]*)\s*\(([^)]+)\)', re.IGNORECASE | re.DOTALL)
for m in pattern.finditer(body):
  table = m.group(1).upper()
  if table not in required:
    continue
  cols = [c.strip().upper() for c in re.split(r'[,\s]+', m.group(2)) if c.strip()]
  missing = [c for c in required[table] if c not in cols]
  if missing:
    line_no = body[:m.start()].count('\n') + 1
    violations.append(f"  -> Table {table} (line {line_no}): missing NOT NULL columns: {', '.join(missing)}")

if violations:
  print(f"BLOCK [check-notnull-insert]: {path}", file=sys.stderr)
  for v in violations:
    print(v, file=sys.stderr)
  print("  -> NOT NULL columns without DEFAULT must be explicitly listed (avoids ORA-01400).", file=sys.stderr)
  print("  -> Reference: anti-simplification.md §1.4 + memory/reference_scm_adm_user_gr_btn_mpg_m.md", file=sys.stderr)
  sys.exit(2)

sys.exit(0)
PYEOF
exit $?
