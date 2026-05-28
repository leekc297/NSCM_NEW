# Pre-Submit Hook — 작업 종료 / PR 제출 직전 최종 검증

> ⚠️ **이 Hook 실행 전 반드시 Read**: `Doc/_dev_rules/hooks/anti-simplification.md` (2026-05-22 신규)
> 작업 단순화 절대 금지 — 다중 패턴, Cross-check, 기존 자료 활용 의무. 위반 시 신뢰성 손상.


> 한 단위 작업(화면 1개, 기능 1개)을 마무리하고 commit/PR 단계로 가기 직전 AI 자동 점검 Hook.
> **사람용 정식 머지 게이트 룰**: [`../18_CODE_REVIEW_CHECKLIST.md`](../18_CODE_REVIEW_CHECKLIST.md)
> 두 문서는 동일한 항목을 다루며 — 본 문서는 AI 가 빌드/grep/SQL 실행으로 자동 수행하고, 18 은 리뷰어가 PR 화면에서 ✅ 체크하는 형태.

## 1. 빌드 / 검증 통과 확인

**FE**:
```bash
pnpm lint:fix         # 자동 수정 + 잔존 오류 확인
pnpm type-check       # 타입 오류 0건
pnpm build            # 빌드 성공
pnpm test             # 단위 테스트 통과
```

**BE**:
```bash
./gradlew spotlessApply   # 코드 포맷 적용
./gradlew build           # 빌드 + 컴파일
./gradlew test            # 테스트 통과
```

모두 통과해야 다음 단계 진행.

## 1.5 신규 화면 — 7개 영역 메타 등록 최종 검증 ⭐ (자기완결형)

> 2026-05-19 업데이트: 외부 PKG 폐기 + 자기완결형 인라인 DML 패턴 + SQL 4-파일 세트 의무화

신규 화면 추가 PR이라면 다음 모두 확인:

### A. SQL 파일 세트 (4개) 동봉

```
[ ] registrations/{prefix}_{MENU_ID}_Registration.sql                  (SQL*Plus / SQLcl)
[ ] registrations/{prefix}_{MENU_ID}_Registration_DBeaver.sql          (DBeaver 등록)
[ ] registrations/{prefix}_{MENU_ID}_Registration_DBeaver_Verify.sql   (DBeaver 검증)
[ ] registrations/{prefix}_{MENU_ID}_Registration_DBeaver_Diagnose.sql (DBeaver 진단)
```

### B. DBeaver 파일 금지 사항 점검

```
[ ] PKG_NSCM_SCREEN_REGISTRATION 호출 0건 (PKG 폐기됨)
[ ] END; 뒤 `/` 종결자 0건 (ORA-00911 유발)
[ ] 단일 파일에 PL/SQL 블록 + SELECT 혼재 0건 (PLS-00103 유발)
[ ] SET DEFINE / DEFINE / &변수 / PROMPT / UNDEFINE 0건 (ORA-00922 유발)
```

### C. 7개 영역 row count 검증 SQL 실행 + 결과 첨부

```sql
-- _DBeaver_Verify.sql 실행 결과를 PR 본문에 첨부
SELECT '1.MENU'         AS K, COUNT(*) AS CNT, 1 AS EXPECT_MIN FROM SCM_ADM_MNU_M             WHERE MNU_ID = '{MENU_ID}'
UNION ALL SELECT '2.MENU_AUTH',  COUNT(*), 1 FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '{MENU_ID}'
UNION ALL SELECT '3.UI_COLS',    COUNT(*), 1 FROM SCM_MST_SHEET_COLUMNS     WHERE PROGRAM_ID = '{MENU_ID}'
UNION ALL SELECT '4.PROC',       COUNT(*), 3 FROM SCM_ADM_PROC_M            WHERE PROC_NM LIKE 'PKG_{MENU_ID}.%'  -- ★ 누락 시 DMF0007 같은 빈 결과
UNION ALL SELECT '5.API',        COUNT(*), 1 FROM SCM_ADM_API_M             WHERE API_ID LIKE '{MENU_ID}\_%' ESCAPE '\'
UNION ALL SELECT '6.MNU_BTN_MPG',COUNT(*), 1 FROM SCM_ADM_MNU_BTN_MPG_M     WHERE MNU_ID = '{MENU_ID}'
UNION ALL SELECT '7.I18N_MNU',   COUNT(*), 3 FROM SCM_ADM_MSG_M             WHERE MSG_ID = 'MNU_{MENU_ID}';
```

**전부 `CNT >= EXPECT_MIN` 이어야 머지 가능.** 1개라도 0 이면 머지 차단.

### D. FE 측

```
[ ] FE procedures.d.ts 에 화면 entry 추가됨
[ ] git diff configs/types/procedures.d.ts 변경분이 실제 SP 컬럼과 일치
[ ] ROUTE_PATHS 에 신규 MENU_ID 1행 추가
[ ] apps/web/src/core/Router.tsx 에 LazyLoader + route 등록
```

## 1.6 ⭐ As-Is Validation/Expression 카운트 최종 검증

신규 화면 FE 작업 PR이라면 **반드시** 카운트 일치 확인:

```
[ ] __asis-mapping__.md 파일 존재
[ ] As-Is validation.md 행 수 == To-Be 적용 건수 (매트릭스 합산)
[ ] As-Is expressions.md 행 수 == To-Be 적용 건수 (매트릭스 합산)
[ ] 모든 매트릭스 행 상태가 ✅
[ ] 사업부 분기 (40/81/82) 그대로 보존됨
[ ] Cell.Formula 사용 화면은 FlexSheet 적용
[ ] MSG#### → t('msg.MSG####') 변환 완료
```

자동 검증 SQL/명령 예시:
```bash
# As-Is 카운트 추출
AS_VAL=$(grep -E '^\*\*총.*추출.*\*\*: \*\*' Doc/_analysis/domain_DM/screens/DMF0099/validation.md | grep -oE '[0-9]+')
AS_EXP=$(grep -E '^\*\*총.*추출.*\*\*: \*\*' Doc/_analysis/domain_DM/screens/DMF0099/expressions.md | grep -oE '[0-9]+')

# To-Be 적용 카운트 (매트릭스 ✅ 행 수)
TB_TOTAL=$(grep -c '| ✅ |$' features/demand/src/pages/dmf0099/__asis-mapping__.md)
TB_PENDING=$(grep -c '| ❌ |$' features/demand/src/pages/dmf0099/__asis-mapping__.md)

if [ "$TB_PENDING" -gt 0 ]; then
    echo "❌ 미적용 행 $TB_PENDING 건 — PR 머지 차단"
    exit 1
fi
if [ "$TB_TOTAL" != "$((AS_VAL + AS_EXP))" ]; then
    echo "❌ 카운트 불일치: As-Is=$((AS_VAL + AS_EXP)) / To-Be=$TB_TOTAL"
    exit 1
fi
echo "✅ As-Is 매핑 검증 통과 ($TB_TOTAL 건 모두 적용)"
```

→ 스크립트화: `nscm-fe/scripts/check-asis-mapping.sh` (06_HOOKS.md §4.4)
→ 상세: `Doc/_dev_rules/09_WIJMO_VALIDATION_EXPRESSION.md`

## 1.7. ⭐ procedures.d.ts / i18n msg.json 동기화 검증

신규 화면 또는 SP 컬럼 변경이 있다면 두 파일이 최신 상태인지 확인:

```bash
# 1. procedures.d.ts 최신화 확인
cd nscm-fe && pnpm gen:procedures
git diff --exit-code configs/types/procedures.d.ts || {
    echo "❌ procedures.d.ts outdated. 변경분을 커밋하세요."; exit 1
}

# 2. msg.json 동기화 확인
python3 Doc/_analysis/scripts/gen_i18n_msg_json.py --out /tmp/i18n_check/
diff /tmp/i18n_check/ko/msg.json apps/web/src/locales/ko/msg.json || {
    echo "❌ msg.json outdated."; exit 1
}
```

검증 명령:
```bash
# DB
sqlplus SCM_MGR/pw@ESSCMD @verification_dmf0099.sql

# FE
pnpm gen:procedures
git diff --exit-code configs/types/procedures.d.ts || echo "procedures.d.ts 최신화 필요"
```

## 2. 화면 단위 통합 점검 (FE + BE + DB)

신규 화면 1개를 위한 작업이라면:

```
✅ DB
[ ] PKG_{UI_ID} 생성 및 Oracle에서 컴파일 OK
[ ] MENU_ID 등록 (SCM_ADM_MENU_M)
[ ] SCMD_APP에 EXECUTE GRANT 부여
[ ] Synonym 생성 (필요 시)

✅ BE
[ ] {Feature}Controller.java
[ ] {Feature}Service.java (interface)
[ ] {Feature}ServiceImpl.java
[ ] dto/{Feature}Request.java + Response.java
[ ] sql/{domain}/{Feature}.xml
[ ] 단위 테스트 작성
[ ] Swagger UI에서 endpoint 노출 확인

✅ FE
[ ] features/{domain}/src/pages/{kebab-page}/{PageName}.tsx
[ ] {page-name}.constants.ts
[ ] use{PageName}Store.ts
[ ] index.ts
[ ] components/{PageName}Form.tsx + .module.scss
[ ] components/{PageName}Grid.tsx
[ ] apps/web 라우팅 등록
[ ] i18n 메시지 코드 등록
[ ] 단위 테스트 작성

✅ 통합 동작
[ ] 화면 로드 → 검색 영역 표시
[ ] 검색 버튼 → BE 호출 → 그리드 표시
[ ] 행 추가/수정/삭제 → CRUD_TYPE 마킹
[ ] 저장 → BE 호출 → DB 반영 확인
[ ] 에러 케이스 (필수값 누락 등) 적절히 표시
```

## 3. 일관성 최종 점검 ("한 사람이 짠 것처럼")

```
[ ] 폴더 구조가 user-management와 동일한가?
[ ] import 순서가 표준을 따르는가? (foundation → shared → 같은 feature → 외부)
[ ] 함수/변수 명명이 일관되는가?
[ ] 에러 처리 패턴이 일관되는가? (useMessageStore + SystemException)
[ ] 주석 스타일이 일관되는가? (BE는 Javadoc 표준 헤더)
[ ] BaseController/BaseService 패턴 일관 적용?
```

## 4. 문서 갱신 점검

```
[ ] 해당 화면의 validation.md 갱신 (검증 로직 변경 시)
[ ] 해당 화면의 analysis.md 갱신 (구조 변경 시)
[ ] Doc/_analysis/domain_*/INDEX.md (신규 화면 추가 시 카운트 갱신)
[ ] Doc/_analysis/INDEX.md (마스터 INDEX 갱신 필요 시)
[ ] Doc/_analysis/PROGRESS.md (마일스톤 완료 시)
[ ] 변경 이력 (CHANGELOG 또는 헤더 주석)
```

## 5. 보안 점검

```
[ ] 하드코딩된 패스워드/토큰 없음
[ ] SQL Injection 방어 (#{} 바인딩만)
[ ] XSS 방어 (dangerouslySetInnerHTML 없음)
[ ] 권한 체크 (FE + BE 양쪽 모두)
[ ] Sensitive 데이터 로깅 없음 (패스워드, 주민번호 등)
```

## 6. 성능 점검

```
[ ] Wijmo Grid 가상화 활성화 (대량 데이터 시)
[ ] Zustand 셀렉터 개별 사용 (리렌더링 최소화)
[ ] BE Procedure에 적절한 인덱스 활용
[ ] N+1 쿼리 없음
[ ] 대량 INSERT/UPDATE 시 BULK 활용
```

## 7. 커밋 메시지 점검

```
[ ] Conventional Commits 형식 (feat/fix/docs/style/refactor/test/chore)
[ ] Scope 명시 (도메인 또는 화면 ID)
[ ] Subject 한 줄 명확히
[ ] Body에 변경 이유 + 영향 범위
[ ] Footer에 PJ 번호 또는 BREAKING CHANGE
```

예시:
```
feat(demand): DMF0099 Sales Monitor 화면 추가

- Wijmo FlexGrid 기반 메인 그리드 + 검색/저장
- Zustand store: useDmf0099SalesMonitorStore
- BE: PKG_DMF0099.P_DMF0099_GET_MAIN_DATA 호출
- i18n 메시지 코드 LBL00200, MSG_DMF0099_SAVED 등록

Refs: PJ2026-12345
```

## 8. 브랜치 / PR 점검

```
[ ] 브랜치명: feat/fix/docs/style/refactor/test/chore + kebab-case
[ ] 변경 파일 수가 적절한가? (>100개면 분리 권장)
[ ] PR 제목이 커밋 메시지와 일치
[ ] PR 본문에 작업 내용 / 변경 이유 / 테스트 결과 포함
```

## 9. 최종 자문

작업 종료 전 마지막 자문:

1. "이 변경이 기존 코드 베이스와 자연스럽게 어우러지는가?"
2. "내가 작성한 코드를 user-management와 나란히 두고 차이가 없는가?"
3. "리뷰어가 'OK'를 누를 만큼 완성도 있는가?"
4. "MSSQL 키워드 잔존 0건인가? (DB 변환 작업 시)"
5. "Syntax Error 없이 컴파일/빌드되는가?"
6. ⭐ "As-Is Validation/Expression 누락 0건인가? (신규 화면 FE 작업 시)"
7. ⭐ "신규 화면 등록 SQL 4파일 세트가 모두 첨부되었는가? (SQL\*Plus 1개 + DBeaver 3개)"
8. ⭐ "_DBeaver_Verify.sql 실행 결과 7개 영역 모두 CNT ≥ EXPECT_MIN 인가?"
9. ⭐ "FE 검색/저장 핸들러에서 gridRef.current.invalidate() 직접 호출 0건인가? (Wijmo finishEditing 에러 방지)"

9개 모두 "예"일 때만 PR 제출 단계 진행.

## 9.5 확장 패턴 화면 추가 자문 ⭐ (2026-05-22 신설 — DMF0020 작업 반영)

신규 화면이 확장 패턴 (Validation ≥ 20 / Expression ≥ 5 / 사업부 분기 ≥ 6 / POPUP ≥ 1) 이면 추가 5 자문:

10. ⭐ "hooks/ 서브폴더 분리 (Validation + Expression) 되어 있는가?"
11. ⭐ "사업부 분기 (40/81/82) 가 메서드명 분리 (editButtonForDivision40 등) 로 보존되어 있는가?
       case-switch 통합은 PR Reject 사유."
12. ⭐ "components/modals/ 안에 As-Is 전용 POPUP 별 modal 컴포넌트가 각각 존재하는가?
       (공통 POPUP 은 호출만 + 매트릭스에 ⚠ 표기)"
13. ⭐ "__asis-mapping__.md 가 §1.1~§1.N 카테고리별 섹션으로 분리되었는가? (메인 + POPUP §3 분리)"
14. ⭐ "동적 컬럼 화면이면 fetchDynamicColumns 가 별도 메타 SP 호출하고,
       3-tier 헤더가 buildLargeSumHeader 로 구성되었는가?"

→ 상세 룰: `05_SCREEN_TEMPLATE.md` §2.0.2, `09_WIJMO_VALIDATION_EXPRESSION.md` §3/§7, `12_GRID_COMMON.md` §6/§10/§11

## 9.6 이관 패키지 자문 ⭐ (2026-05-22 신설 — DMF0020 작업 반영)

DB/서버 미연결 환경에서 작성된 화면을 압축 패키지로 이관할 때 추가 5 자문:

15. ⭐ "_{screen_id}_artifacts/ 폴더 명명 규약 준수 + 압축파일명 {SCREEN_ID}_To-Be_{YYYYMMDD}.zip 형식?"
16. ⭐ "_README.md 의 §3 적용 순서가 7-step 으로 명확하고, 트러블슈팅 5종 (빈 결과 / No Permission / API not found / Grid 빈 컬럼 / Wijmo finishEditing) 포함?"
17. ⭐ "_COMMON_FILES_GUIDE.md 의 4 파일 patch 가 Before/After 형식이고,
       Follow-up (공통 POPUP / BE Java / PKG SP) 명시?"
18. ⭐ "압축 zip 내부에 BE Java / PKG SP / node_modules / 분석자료 미포함?"
19. ⭐ "FE 폴더 안에 __asis-mapping__.md 가 포함되어 있는가? (룰 09 §3)"

→ 상세 룰: `22_PACKAGE_ARTIFACTS.md`

## 10. PR 제출 후 후속 작업

```
[ ] CI 통과 모니터링
[ ] 리뷰 코멘트 응답
[ ] 머지 후 dev 브랜치 동기화
[ ] 관련 jira/PJ 티켓 상태 변경
[ ] 후속 작업 (다음 화면 등) 계획
```

---

**이 체크리스트는 작업의 최종 안전망입니다. 통과한 후에만 PR을 제출하세요.**
