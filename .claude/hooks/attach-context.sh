#!/bin/bash
# Claude Code UserPromptSubmit hook — 키워드 → 룰 문서 자동 첨부 (bash 버전)
# 2026-06-18 갱신 (R-3): RULESET_MASTER 단일 진입 + v2 캐노니컬 경로 + UI/수정 키워드 그룹
# ※ staged 사본. 적용: .claude/hooks/attach-context.sh 로 복사

set -u
PAYLOAD=$(cat)
PROMPT=$(printf '%s' "$PAYLOAD" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('prompt',''))" 2>/dev/null || echo "")
[ -z "$PROMPT" ] && exit 0

ROOT="/c/Projects/NSCM"
V2="$ROOT/Doc/_rules_v2"
CONS="$ROOT/Doc/_rules_consolidation"
MEM_ROOT="/c/Users/ejene/.claude/projects/C--Projects-NSCM/memory"

ATTACH=()

if echo "$PROMPT" | grep -qiE 'SQL|INSERT|DELETE|UPDATE|DBeaver|ORA-|PLS-|PROC_M|MSG_M|MNU_M|API_M|SHEET_COLUMNS|USER_GR|\bSP\b|PKG_|cursor|MERGE'; then
  ATTACH+=("$V2/anti-simplification.md")
  ATTACH+=("$V2/hooks/oracle-db-workflow.md")
  ATTACH+=("$MEM_ROOT/feedback_dbeaver_sql_mandatory_grep.md")
  ATTACH+=("$MEM_ROOT/feedback_sql_dual_output.md")
  ATTACH+=("$MEM_ROOT/reference_scm_adm_user_gr_btn_mpg_m.md")
fi

if echo "$PROMPT" | grep -qiE 'import|컴포넌트|화면|tsx|모달|Wijmo|Grid|DataGrid|Form|Dropdown|CustomDialog|SearchArea|combo|cascade'; then
  ATTACH+=("$CONS/RULESET_MASTER.md")
  ATTACH+=("$V2/hooks/datagrid-shared-component-mandatory.md")
  ATTACH+=("$V2/hooks/screen-shell-composition-mandatory.md")
  ATTACH+=("$MEM_ROOT/feedback_no_type_cast_around_runtime.md")
  ATTACH+=("$MEM_ROOT/reference_pnpm_scripts.md")
fi

if echo "$PROMPT" | grep -qiE 'as-is|As-Is|매핑|validation|expression|이벤트|핸들러|\.cs\b'; then
  ATTACH+=("$V2/hooks/asis-coverage-check.md")
fi

if echo "$PROMPT" | grep -qiE '화면\s*(생성|추가|신규|만들|개발|작성)|신규\s*화면|to-be\s*화면|create\s+(new\s+)?(screen|page)|new\s+(screen|page)|add\s+(screen|page)|build\s+page|(DMF|FPF|SCF|SSF|CMF|SPF|MNF|ATF)[0-9]{4}.*(만들|추가|생성|작성|개발|create|build|add)'; then
  ATTACH+=("$V2/anti-simplification.md")
  ATTACH+=("$CONS/RULESET_MASTER.md")
  ATTACH+=("$V2/hooks/ui-dynamic-property-management.md")
  ATTACH+=("$V2/hooks/screen-conventions-mandatory.md")
  ATTACH+=("$V2/hooks/regression-zero-mandatory.md")
  ATTACH+=("$V2/hooks/screen-completion-gate.md")
  ATTACH+=("$MEM_ROOT/feedback_new_screen_mandatory.md")
fi

if echo "$PROMPT" | grep -qiE '(화면|컬럼|column|grid|속성|메타).*(수정|변경|고쳐|바꿔|재작업|modify|change|update|fix|rework)|(수정|변경|재작업).*(화면|컬럼|column|grid)'; then
  ATTACH+=("$CONS/RULESET_MASTER.md")
  ATTACH+=("$V2/hooks/regression-zero-mandatory.md")
  ATTACH+=("$V2/hooks/column-meta-rework-checklist.md")
fi

[ ${#ATTACH[@]} -eq 0 ] && exit 0

# 중복 제거
UNIQ=($(printf '%s\n' "${ATTACH[@]}" | awk '!seen[$0]++'))

echo "===== AUTO-ATTACHED RULE CONTEXT (attach-context hook) ====="
echo "The following rules are MANDATORY for this task. Do not skip verification steps."
echo "Single entry: RULESET_MASTER.md (Doc/_rules_consolidation). UI work: pass RULESET_MASTER 3 (UI-MANDATORY checklist)."
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
