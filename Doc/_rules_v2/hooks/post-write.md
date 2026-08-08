# Hook — post-write (파일 작성 직후 검증)

> **트리거**: 모든 `.ts / .tsx / .java / .sql / .md` 파일 작성 / 수정 직후
>
> **목적**: 작성된 파일이 룰 v2 표준 통과하는지 grep 자동 검증

---

## §0 작성 직후 grep 검증

### §0.1 FE `.tsx / .ts`

```bash
F="{written_file}"

# 1. 상대 경로 import
grep -c "from '\(\.\./\)\{3,\}" "$F"   # = 0

# 2. console.log 잔존
grep -c "console\.log" "$F"   # = 0

# 3. inline style
grep -c "style=\{\{" "$F"   # = 0

# 4. () => undefined / () => {} 빈 handler (메모리 사고)
grep -cE "=> undefined|=> \{\s*\}" "$F"   # = 0

# 5. @shared/lges 의 없는 export (Box / Dialog 등)
grep -cE "from '@shared/lges'.*\b(Box|Dialog|Container|Paper|TextField)\b" "$F"   # = 0

# 6. FlexGrid 직접 import (DataGrid wrapper 사용 안 함)
grep -c "from '@mescius/wijmo.react.grid'" "$F"   # = 0

# 7. FlexGridColumnGroup JSX single-child (DMF0043 사고)
awk '/<FlexGridColumnGroup/,/<\/FlexGridColumnGroup>/' "$F" | grep -c "<FlexGridColumn " 
# ≥ 2 또는 그룹 사용 안 함

# 8. NUMBER → String 변환 누락 패턴 (DMF0043 YEAR 사고)
# 수동 검토: <CustomDropdown value={row.COL}> 의 row.COL 이 Oracle NUMBER 컬럼인지

# 9. useMemo preSearchParams (refetch loop)
grep -B 2 "preSearchParams=\{\{ \.\.\." "$F" | grep -c "useMemo"   # ≥ 1 (사용 시)

# ===== ⭐ type-check 17 패턴 자동 검증 (cloud type-check 회피) =====
# 상세: ./type-check-error-patterns.md §6

# 10. useTabProcQuery / useProcMutation 의 tabId 누락
grep -nP 'use(Tab)?Proc(Query|Mutation)\(\{[^}]*\}\)' "$F" | grep -v 'tabId:' \
  && echo "⚠ TS2345: tabId 누락 (use type-check-error-patterns §1)"

# 11. ByDivisionModal 의 callFromCell 누락
grep -nP '<(Project|Item|Owner|Customer)ByDivisionModal' "$F" | grep -v 'callFromCell' \
  && echo "⚠ TS2741: callFromCell required prop 누락 (use type-check-error-patterns §1)"

# 12. as XxxRow[] direct cast (TS2352)
grep -nP 'as [A-Z]\w*Row\[\]' "$F" | grep -v 'as unknown as' \
  && echo "⚠ TS2352: direct cast 차단 — 'as unknown as XxxRow[]' 우회 (use type-check-error-patterns §2)"

# 13. as Record<string, unknown> direct cast (TS2352)
grep -nP 'as Record<string, unknown>' "$F" | grep -v 'as unknown as' \
  && echo "⚠ TS2352: Record direct cast — 'as unknown as Record<string, unknown>' 우회"

# 14. DialogNavigationSize string literal 거부 (TS2322)
grep -nP "size='(large|medium|small)'" "$F" \
  && echo "⚠ TS2322: Dialog size 는 number literal 만 (1200/800/600 등)"

# 15. CustomDialog deprecated prop
grep -nP '<CustomDialog[^/]*?(width=|height=|title=|onClose=)' "$F" \
  && echo "⚠ TS2322: CustomDialog deprecated prop — customHeaderTitle/handleClose/size 사용"

# 16. popupBtnStyle JSX 사용 전 정의 (no-use-before-define)
LINE_USE=$(grep -n "style={popupBtnStyle}" "$F" | head -1 | cut -d: -f1)
LINE_DEF=$(grep -n "const popupBtnStyle\s*=" "$F" | head -1 | cut -d: -f1)
[ -n "$LINE_USE" ] && [ -n "$LINE_DEF" ] && [ "$LINE_USE" -lt "$LINE_DEF" ] \
  && echo "⚠ eslint no-use-before-define: popupBtnStyle JSX 사용 전 정의 의무"

# 17. DataGrid<T> 의 T 가 WijmoRowItem constraint 만족하는지 확인 의무
grep -nP '<DataGrid<' "$F" \
  && echo "ℹ DataGrid<T>: T extends WijmoRowItem 또는 [key:string]: WijmoPrimitive 의무 확인"

# ===== ⭐ SYS0017 2026-08-06 감사 계기 신설 (#18~#21) =====

# 18. 자체 행상태 필드 신설 검출 (hook #99 §0 — 저장 판정 = CRUD_TYPE 전용)
grep -nE "rowStatus|ROW_STATUS|actionFlag|isNewRow" "$F" \
  && echo "⛔ 자체 행상태 필드 — CRUD_TYPE(GridAction/EditTracker 마킹) 전용. 값이 I/M/D 로 같아도 공통버튼·셀편집과 단절 → 저장 0건 (SYS0017 실사고)"

# 19. 결과 판정 없는 apiClient.post(call-proc) 검출 (screen-completion-gate §1-3)
#     — call-proc 호출 후 5줄 안에 res.status/res.data.code 실패 분기가 없으면 위반
grep -nA 5 "apiClient\.post(.*call-proc" "$F" | grep -qE "res\.status *>= *400|\.code\)" \
  || { grep -q "apiClient\.post(.*call-proc" "$F" \
       && echo "⛔ call-proc 저장 결과 무검증 — axios responseErrorInterceptor 는 500/403 도 resolve (false success). 정본 business-plan/utils/business-plan.api.ts:71"; }

# 20. '^' bulk 감사키 빈문자열 검출 (hook #99 §0.1)
grep -nE "map\(\(\) *=> *''\)|createdBy: *''" "$F" \
  && echo "⛔ 감사키 빈문자열 — 세션 사용자(useSessionStore userId) FE 필수 전달 (BE 자동 주입은 sesUserId 뿐)"
```

### §0.1-B ⭐ 정의-참조 게이트 (util 미배선 검출 — SYS0017 2026-08-06 감사 계기 신설)

> 페이지 폴더 내 `util/*.ts`(`*.util.ts` 포함) 의 **export 함수별로 동일 폴더 안 import 참조를 grep** 한다.
> **참조 0건 export = "미배선 의심" 으로 보고 의무** (삭제가 아니라 보고 — 배선 누락인지 dead code 인지 판정).
> 근거: 정확한 시그니처의 util 이 존재하면 구현된 것처럼 보인다 — **절반 구현이 가장 위험하다**
> (SYS0017 실측: util 10 export 중 5개 import 0건 — cascade/검증 함수를 정의만 하고 그리드 핸들러에 배선 안 함).
> tsc `noUnusedLocals` 는 export 함수를 검출하지 못하므로 본 grep 이 유일한 검출기다.

```bash
# 화면 폴더 단위 실행 (util 파일 작성/수정 직후 + screen-completion-gate 진입 시)
DIR="features/{domain}/src/pages/{screen}"
for fn in $(grep -rhoE "^export (const|function) \w+" "$DIR"/*.util.ts "$DIR"/utils/*.ts 2>/dev/null | awk '{print $3}'); do
  CNT=$(grep -rE "\b$fn\b" "$DIR" --include='*.ts' --include='*.tsx' \
        | grep -v "\.util\.ts:" | grep -vE "utils/\w+\.ts:" | wc -l)
  [ "$CNT" -eq 0 ] && echo "⚠ 미배선 의심: $fn — export 인데 동일 폴더 참조 0건 (배선 누락 or dead — 보고 의무)"
done
```

- 판정: 미배선 의심 1건이라도 있으면 **"완료" 보고 전 각 건에 [배선 완료 위치 | dead 사유] 를 명시**. 무언 통과 금지.

### §0.2 BE `.java`

```bash
F="{written_file}"

# 1. @Autowired 필드 주입
grep -c "@Autowired" "$F"   # = 0

# 2. successResponseEntity 사용
grep -c "ResponseEntity.ok\|new ResponseEntity" "$F"   # = 0 (직접 작성 X)
grep -c "successResponseEntity" "$F"   # ≥ 1 per endpoint

# 3. System.out.println
grep -cE "System.out.println|printStackTrace" "$F"   # = 0

# 4. SQL ID hardcoding
grep -cE 'selectList\("[a-z]' "$F"   # = 0 (nameSpace 변수 사용)

# 5. Hardcoded password / secret
grep -nE "password.*=.*['\"][\w!@#$%^&*]{6,}['\"]" "$F"   # = 0
```

### §0.3 SQL `.sql`

```bash
F="{written_file}"

# 1. INSERT ALL 사용 (멱등 위반)
grep -c "INSERT ALL" "$F"   # = 0

# 2. NOT EXISTS 멱등 패턴
grep -c "WHERE NOT EXISTS" "$F"   # ≥ INSERT 카운트

# 3. MSSQL 키워드
grep -cE "DATEADD\(|CHARINDEX\(|STRING_SPLIT\(|GETDATE\(\)|ISNULL\(|IIF\(|N'" "$F"   # = 0

# 4. DBeaver 호환 (`_DBeaver.sql` 만)
case "$F" in *_DBeaver.sql)
  grep -cE "^SET|^PROMPT|^DEFINE|^&\w|^/$" "$F"   # = 0
  ;;
esac

# 5. UPPR_MNU_ID 대문자 (DMF0020 사고)
grep -cE "UPPR_MNU_ID\s*=\s*'(DEMAND_MASTER|MASTER|DEMAND)'" "$F"   # = 0

# 6. SHT_NM 자유명 (단일 sheet)
grep -cE "SHT_NM\s*=\s*'(futurePrice|salesSite)'" "$F"   # = 0
```

---

## §1 검증 실패 시 처리

- **실패 1 건이라도 발견**: 즉시 fix. 다음 작업 진행 금지.
- **반복 실패**: 룰 v2 의 해당 룰 cross-ref + 메모리 사고 기록 확인.

---

## §2 적용 룰 cross-ref

| grep | 사고 메모리 |
|---|---|
| 자체 행상태 필드 (#18) / call-proc 무검증 (#19) / 감사키 빈값 (#20) / 정의-참조 게이트 (§0.1-B) | `2026-08-06_SYS0017_root_cause_audit.md` (hook #99 §0·§0.1 + screen-completion-gate §1-3) |
| Box / Dialog import | `feedback_runtime_error_prevention.md` |
| FlexGridColumnGroup single-child | `feedback_wijmo_columngroup_jsx_avoid.md` (룰 07 §3.2) |
| NUMBER → String 누락 | `feedback_no_type_cast_around_runtime.md` (룰 07 §3.6) |
| INSERT ALL | `feedback_sql_idempotent_insert_all.md` (룰 12 §2) |
| DBeaver 호환 | `feedback_dbeaver_sql_mandatory_grep.md` (룰 12 §1.3) |
| UPPR_MNU_ID 대문자 | `feedback_mnu_uppr_case_standard.md` (룰 13 §7.2) |
