#!/bin/bash
# Claude Code PostToolUse hook — FE 금지 import + 위험 cast 차단 (bash 버전)

set -u
PAYLOAD=$(cat)
TOOL_NAME=$(printf '%s' "$PAYLOAD" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('tool_name',''))" 2>/dev/null || echo "")
FILE_PATH=$(printf '%s' "$PAYLOAD" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")

case "$TOOL_NAME" in
  Write|Edit|MultiEdit) ;;
  *) exit 0 ;;
esac

[ -z "$FILE_PATH" ] && exit 0
echo "$FILE_PATH" | grep -qE '\.tsx?$' || exit 0
echo "$FILE_PATH" | grep -qE '/(features|packages|apps)/' || exit 0
[ -f "$FILE_PATH" ] || exit 0

python3 - "$FILE_PATH" <<'PYEOF'
import sys, re

path = sys.argv[1]
with open(path, 'r', encoding='utf-8', errors='replace') as f:
  body = f.read()

violations = []
warnings = []

fix_map = {
  '@shared/components': {
    'Dialog':          "Use 'CustomDialog' from '@shared/components'",
    'DateRangePicker': "Use 'DatePickerCalendar' from '@shared/lges' (usecase='date-range-multi')",
    'MonthPicker':     "Use 'DatePickerCalendar' from '@shared/lges' (usecase='month-single')",
    'Button':          "Move to '@shared/lges'",
    'InputField':      "Move to '@shared/lges'",
    'CheckboxField':   "Use 'Checkbox' from '@shared/lges'",
  },
  '@shared/lges': {
    'CheckboxField':   "Use 'Checkbox' from '@shared/lges' (CheckboxField does not exist)",
  },
}

import_pattern = re.compile(r"import\s*(?:type\s+)?\{\s*([\s\S]*?)\s*\}\s*from\s+['\"](@shared/components|@shared/lges)['\"]", re.MULTILINE)
for m in import_pattern.finditer(body):
  symbols_raw = m.group(1)
  source = m.group(2)
  line_no = body[:m.start()].count('\n') + 1
  for sym in re.split(r'[,\s]+', symbols_raw):
    clean = sym.strip()
    if not clean or clean == 'type':
      continue
    # 'Foo as Bar' → 'Foo'
    mm = re.match(r'^(\w+)', clean)
    if mm:
      clean = mm.group(1)
    if clean in fix_map.get(source, {}):
      violations.append(f"  -> line {line_no} : invalid import '{clean}' from '{source}'. {fix_map[source][clean]}")

# Warning: as unknown as
for m in re.finditer(r'as\s+unknown\s+as\s+', body):
  line_no = body[:m.start()].count('\n') + 1
  warnings.append(f"  -> line {line_no} : 'as unknown as X' forced cast. Verify runtime safety.")

if violations:
  print(f"BLOCK [check-fe-import]: {path}", file=sys.stderr)
  for v in violations:
    print(v, file=sys.stderr)
  if warnings:
    print("WARN [check-fe-import]:", file=sys.stderr)
    for w in warnings:
      print(w, file=sys.stderr)
  print("  -> Reference: Doc/_dev_rules/23_FE_IMPORT_INVENTORY.md", file=sys.stderr)
  sys.exit(2)

if warnings:
  print(f"WARN [check-fe-import]: {path}", file=sys.stderr)
  for w in warnings:
    print(w, file=sys.stderr)
  sys.exit(1)

sys.exit(0)
PYEOF
exit $?
