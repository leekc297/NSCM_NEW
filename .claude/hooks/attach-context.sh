#!/bin/bash
# Claude Code UserPromptSubmit hook — 키워드 → 룰 문서 자동 첨부 (bash 버전)

set -u
PAYLOAD=$(cat)
PROMPT=$(printf '%s' "$PAYLOAD" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('prompt',''))" 2>/dev/null || echo "")
[ -z "$PROMPT" ] && exit 0

ROOT="/c/Projects/NSCM"
MEM_ROOT="/c/Users/ejene/.claude/projects/C--Projects-NSCM/memory"

ATTACH=()

if echo "$PROMPT" | grep -qiE 'SQL|INSERT|DELETE|UPDATE|DBeaver|ORA-|PROC_M|MSG_M|MNU_M|API_M|SHEET_COLUMNS|USER_GR'; then
  ATTACH+=("$ROOT/Doc/_dev_rules/hooks/anti-simplification.md")
  ATTACH+=("$MEM_ROOT/feedback_dbeaver_sql_mandatory_grep.md")
  ATTACH+=("$MEM_ROOT/feedback_sql_dual_output.md")
  ATTACH+=("$MEM_ROOT/reference_scm_adm_user_gr_btn_mpg_m.md")
fi

if echo "$PROMPT" | grep -qiE 'import|컴포넌트|화면|tsx|모달|Wijmo|Grid|Form|Dropdown|CustomDialog'; then
  ATTACH+=("$ROOT/Doc/_dev_rules/23_FE_IMPORT_INVENTORY.md")
  ATTACH+=("$ROOT/Doc/_dev_rules/hooks/fe-import-check.md")
  ATTACH+=("$MEM_ROOT/feedback_no_type_cast_around_runtime.md")
  ATTACH+=("$MEM_ROOT/reference_pnpm_scripts.md")
fi

if echo "$PROMPT" | grep -qiE 'as-is|As-Is|매핑|validation|expression|이벤트|핸들러'; then
  ATTACH+=("$ROOT/Doc/_dev_rules/24_ASIS_CROSSCHECK.md")
  ATTACH+=("$ROOT/Doc/_dev_rules/hooks/asis-coverage-check.md")
fi

[ ${#ATTACH[@]} -eq 0 ] && exit 0

# 중복 제거
UNIQ=($(printf '%s\n' "${ATTACH[@]}" | awk '!seen[$0]++'))

echo "===== AUTO-ATTACHED RULE CONTEXT (attach-context hook) ====="
echo "The following rules are MANDATORY for this task. Do not skip verification steps."
echo ""

for f in "${UNIQ[@]}"; do
  if [ -f "$f" ]; then
    name=$(basename "$f")
    echo "----- BEGIN: $name -----"
    cat "$f"
    echo ""
    echo "----- END: $name -----"
    echo ""
  fi
done

echo "===== END AUTO-ATTACHED RULE CONTEXT ====="
exit 0
