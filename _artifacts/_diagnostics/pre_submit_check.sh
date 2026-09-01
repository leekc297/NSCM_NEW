#!/bin/sh
# pre_submit_check.sh — pre-submit hook §0.2 자동 검증 grep (2026-08-31 신설)
#   계기: rule_enforcement_audit 가 "hook 이 참조하는데 실존하지 않는 도구" 로 적출 (룰=코드 원칙 GAP 봉인).
#   사용: sh pre_submit_check.sh {MENU_ID}     # exit 0 = 전 grep PASS
#   범위: FE = MENU_ID 리터럴 보유 페이지 폴더(들) / BE = nscm-be 내 MENU_ID(소문자) 참조 파일 / SQL = _artifacts/*{MENU_ID}*.sql
set -u
MENU="${1:?usage: pre_submit_check.sh MENU_ID}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FAIL=0

hit() { # $1=라벨 $2=건수(0 이어야 PASS)
  if [ "$2" -gt 0 ]; then echo "FAIL  $1 = $2건"; FAIL=1; else echo "PASS  $1 = 0"; fi
}

# ── FE 페이지 폴더 탐지 (MENU_ID 리터럴) ──
FE_DIRS=$(grep -rls "MENU_ID = '$MENU'\|MENU_ID='$MENU'\|'$MENU'" "$ROOT/nscm-fe/features" --include="*.constants.ts" 2>/dev/null | xargs -r -n1 dirname | sort -u)
if [ -z "$FE_DIRS" ]; then echo "WARN  FE 페이지 폴더 미탐지 ($MENU) — FE 축 스킵"; fi

for d in $FE_DIRS; do
  echo "== FE: $d"
  hit "상대경로 import(../../..)" "$(grep -rE "from '\.\./\.\./\.\." "$d" --include='*.ts*' 2>/dev/null | wc -l)"
  hit "console.log"               "$(grep -rE 'console\.log' "$d" --include='*.ts*' 2>/dev/null | grep -v '// eslint' | wc -l)"
  hit "inline style={{"           "$(grep -rE 'style=\{\{' "$d" --include='*.tsx' 2>/dev/null | wc -l)"
  hit "@shared/lges Box/Dialog/Container import" "$(grep -rE "from '@shared/lges'.*\b(Box|Dialog|Container)\b" "$d" 2>/dev/null | wc -l)"
  hit "FlexGrid 직접 import"      "$(grep -rE "from '@mescius/wijmo.react.grid'" "$d" --include='*.tsx' 2>/dev/null | grep -v 'DataGrid\|foundation' | wc -l)"
done

# ── BE ──
BE_FILES=$(grep -rlsi "$MENU" "$ROOT/nscm-be/src/main" --include='*.java' 2>/dev/null | sort -u)
if [ -n "$BE_FILES" ]; then
  echo "== BE: $(echo "$BE_FILES" | wc -l) 파일"
  hit "@Autowired 필드 주입" "$(echo "$BE_FILES" | xargs -r grep -l '@Autowired' 2>/dev/null | wc -l)"
  hit "직접 ResponseEntity"  "$(echo "$BE_FILES" | xargs -r grep -E 'new ResponseEntity|ResponseEntity\.ok\(' 2>/dev/null | wc -l)"
  hit "println"              "$(echo "$BE_FILES" | xargs -r grep -c 'System.out.println' 2>/dev/null | awk -F: '{s+=$NF} END{print s+0}')"
fi

# ── SQL (이관/메타 산출물) ──
# AS-IS 원문 덤프·참조 사본은 MSSQL 키워드가 정당 — 제외 (오탐 계보: 첫 스모크 2,150건 전부 _asis_* 덤프)
SQLS=$(find "$ROOT/_artifacts" -maxdepth 3 -name "*${MENU}*.sql" -newer "$ROOT/CLAUDE.md" 2>/dev/null | grep -viE '_asis|/REF_|AsIs_|\.live\.sql' | head -50)
if [ -n "$SQLS" ]; then
  echo "== SQL: $(echo "$SQLS" | wc -l) 파일 (CLAUDE.md 이후 갱신분)"
  # hook #138: 주석은 판정 대상 아님 — MSSQL 키워드는 strip_code_comments.py 전처리 후 LIVE 만 카운트
  #   (오탐 계보: 변환 이력 주석의 ISNULL/DATEADD 43건×N 파일이 결함으로 집계 — 2026-08-31 스모크)
  MSSQL_LIVE=0
  for s in $SQLS; do
    n=$(python "$ROOT/_artifacts/_diagnostics/strip_code_comments.py" "$s" 2>/dev/null \
        | grep -cE '(^|[^A-Za-z_])DATEADD\(|GETDATE\(\)|(^|[^A-Za-z_])ISNULL\(|(^|[^A-Za-z_])CHARINDEX\(|(^|[^A-Za-z_.])STRING_SPLIT\(|WITH \(NOLOCK\)')
    MSSQL_LIVE=$((MSSQL_LIVE + n))
  done
  hit "INSERT ALL (멱등 X)"  "$(echo "$SQLS" | xargs -r grep -c 'INSERT ALL' 2>/dev/null | awk -F: '{s+=$NF} END{print s+0}')"
  hit "MSSQL 키워드(LIVE만 — 주석 제외)" "$MSSQL_LIVE"
  hit "MERGE 빈 ON()"         "$(echo "$SQLS" | xargs -r grep -c 'S ON ()' 2>/dev/null | awk -F: '{s+=$NF} END{print s+0}')"
  hit "감사컬럼 claude 리터럴" "$(echo "$SQLS" | xargs -r grep -c "'claude" 2>/dev/null | awk -F: '{s+=$NF} END{print s+0}')"
fi

echo "== 결과: $([ $FAIL -eq 0 ] && echo ALL PASS || echo FAIL 존재)"
exit $FAIL
