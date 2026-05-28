# 18. PR 코드 리뷰 / 머지 게이트 체크리스트

> 리뷰어가 PR 을 OK/Reject 판단할 때 사용하는 **사람용 체크리스트**.
> AI 자동 검증 버전은 `hooks/pre-submit.md` 에 동일 항목을 코드로 구현. 본 문서는 그 정식 룰 버전.
>
> ⭐ **선행 룰**: `02_DEVELOPMENT_RULES.md` (브랜치/커밋 룰), `07_DO_AND_DONT.md`
> ⭐ **연관 Hook**: `hooks/pre-submit.md` (AI 자동 수행)
>
> **사용 시점**: PR 작성자 자기 점검 → 리뷰어 1차 통과 기준 → 머지 권한자 최종 게이트

---

## 1. 머지 게이트 5종 (모두 ✅ 필요)

```
[ ] GATE-1: 빌드 / 테스트 / 린트 모두 통과 (FE + BE)
[ ] GATE-2: 절대 금지 (Top 11) 위반 0건
[ ] GATE-3: 신규 화면이면 7개 영역 메타 등록 검증 통과
[ ] GATE-4: 신규 화면 FE 면 As-Is Validation/Expression 100% 매핑
[ ] GATE-5: 일관성 ("한 사람이 짠 것처럼") 통과
```

5개 GATE 모두 ✅ 일 때만 머지 가능. 1개라도 ❌ 면 reject.

---

## 2. GATE-1: 빌드 / 테스트 / 린트

### 2.1 FE (`nscm-fe`)

```bash
pnpm lint:fix      # 자동 수정 후 잔존 오류 0
pnpm type-check    # 타입 오류 0
pnpm build         # 빌드 성공
pnpm test          # 단위 테스트 통과
```

### 2.2 BE (`nscm-be`)

```bash
./gradlew spotlessApply   # 코드 포맷 적용
./gradlew build           # 빌드 + 컴파일 성공
./gradlew test            # 테스트 통과
```

### 2.3 CI 결과

```
[ ] GitLab CI 파이프라인 green
[ ] SonarQube quality gate 통과 (적용 시)
[ ] 빌드 산출물 (jar/dist) 정상 생성 확인
```

---

## 3. GATE-2: 절대 금지 (Top 11) 위반 점검

`CLAUDE.md` §4 Top 11 + `07_DO_AND_DONT.md` 의 금지 사항이 0건인지 확인:

### 3.1 Frontend
```
[ ] 상대 경로 import (`../../../`) 없음 — alias (@shared/@foundation) 사용
[ ] Feature 간 직접 import 없음 (admin → demand 등)
[ ] console.log 잔존 없음 (운영 코드)
[ ] any 타입 사용 없음 (정확한 타입 또는 unknown + narrowing)
[ ] inline style (<div style={{...}}>) 없음 — SCSS Module
[ ] useState 로 페이지 전역 상태 관리 없음 — Zustand
[ ] fetch / axios 직접 호출 없음 — useTabProcQuery / useProcMutation
[ ] Wijmo 외 그리드 라이브러리 없음
```

### 3.2 Backend
```
[ ] Controller 에 SQL 직접 호출 없음 — Service 경유
[ ] @Autowired 필드 주입 없음 — @RequiredArgsConstructor + final
[ ] Hardcoded SQL ID 없음 — nameSpace + "method"
[ ] ResponseEntity 직접 작성 없음 — successResponseEntity(data)
[ ] System.out.println 없음 — @Slf4j + log.info
[ ] @SystemLog 누락 없음 (감사 대상 메서드)
```

### 3.3 DB / SQL
```
[ ] MSSQL 키워드 잔존 0건:
    DATEADD / CHARINDEX / STRING_SPLIT / GETDATE() / ISNULL() / IIF /
    N'...' / WITH (NOLOCK) / [bracket] / dbo. / + 문자열 결합
[ ] $$PLSQL_UNIT 사용 (v_program_name 하드코딩 X)
[ ] Synonym 사용 (SCM_MGR.TABLE 직접 참조 X)
[ ] MyBatis: #{} 만 사용 (${} 직접 바인딩 X)
[ ] PKG_NSCM_SCREEN_REGISTRATION 호출 0건 (2026-05-19 폐기)
```

---

## 4. GATE-3: 신규 화면 — 7개 영역 메타 등록 검증

**해당 PR 이 신규 화면 추가가 아니면 SKIP.**

### 4.1 SQL 파일 세트 (4-파일) 동봉

```
[ ] registrations/{prefix}_{MENU_ID}_Registration.sql                  (SQL*Plus / SQLcl)
[ ] registrations/{prefix}_{MENU_ID}_Registration_DBeaver.sql          (DBeaver 등록 PL/SQL 1 블록)
[ ] registrations/{prefix}_{MENU_ID}_Registration_DBeaver_Verify.sql   (DBeaver 검증 UNION ALL 단일문)
[ ] registrations/{prefix}_{MENU_ID}_Registration_DBeaver_Diagnose.sql (DBeaver 진단 PL/SQL)
```

### 4.2 DBeaver 파일 금지 사항 (한 줄이라도 위반 시 reject)

```
[ ] SET DEFINE / DEFINE / &변수 / PROMPT / UNDEFINE 0건
[ ] END; 뒤 `/` 종결자 0건 (ORA-00911)
[ ] 단일 파일에 PL/SQL 블록 + SELECT 혼재 0건 (PLS-00103)
[ ] _Verify.sql 은 UNION ALL 로 묶은 단일 SELECT (여러 SELECT 를 ;로 나누면 ORA-00933)
```

### 4.3 7개 영역 row count 검증 SQL 실행 결과 PR 본문 첨부

```sql
SELECT '1.MENU'         AS K, COUNT(*) AS CNT, 1 AS EXPECT_MIN FROM SCM_ADM_MNU_M             WHERE MNU_ID = '{MENU_ID}'
UNION ALL SELECT '2.MENU_AUTH',  COUNT(*), 1 FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '{MENU_ID}'
UNION ALL SELECT '3.UI_COLS',    COUNT(*), 1 FROM SCM_MST_SHEET_COLUMNS     WHERE PROGRAM_ID = '{MENU_ID}'
UNION ALL SELECT '4.PROC',       COUNT(*), 3 FROM SCM_ADM_PROC_M            WHERE PROC_NM LIKE 'PKG_{MENU_ID}.%'  -- ★ 누락 시 빈 결과
UNION ALL SELECT '5.API',        COUNT(*), 1 FROM SCM_ADM_API_M             WHERE API_ID LIKE '{MENU_ID}\_%' ESCAPE '\'
UNION ALL SELECT '6.MNU_BTN_MPG',COUNT(*), 1 FROM SCM_ADM_MNU_BTN_MPG_M     WHERE MNU_ID = '{MENU_ID}'
UNION ALL SELECT '7.I18N_MNU',   COUNT(*), 3 FROM SCM_ADM_MSG_M             WHERE MSG_ID = 'MNU_{MENU_ID}';
```

→ 전부 `CNT >= EXPECT_MIN` 이어야 머지 가능. 한 행이라도 0 이면 머지 차단.

### 4.4 FE 메타 동기화

```
[ ] configs/types/procedures.d.ts 에 화면 entry 추가됨
[ ] git diff 가 실제 SP 컬럼 정의와 일치
[ ] ROUTE_PATHS 상수에 신규 MENU_ID 1행 추가
[ ] apps/web/src/core/Router.tsx 에 LazyLoader + route 등록
[ ] i18n msg.json (ko/en/cn) 모두 신규 MSG/LBL 코드 포함
```

---

## 5. GATE-4: As-Is Validation / Expression 100% 매핑

**As-Is GSCM 화면 마이그레이션이 아니면 SKIP.**

```
[ ] __asis-mapping__.md 파일 존재 (FE 화면 폴더)
[ ] As-Is validation.md 행 수 == To-Be 적용 건수 (매트릭스 ✅ 합산)
[ ] As-Is expressions.md 행 수 == To-Be 적용 건수
[ ] 모든 매트릭스 행 상태가 ✅, ❌ 0 건
[ ] 각 적용 코드에 // AS-IS: {파일명}.cs:{라인} 주석 포함
[ ] 사업부 분기 (40/81/82) 통합 없이 그대로 보존
[ ] Cell.Formula 사용 As-Is 화면은 To-Be 에서 FlexSheet 사용 (FlexGrid 아님)
[ ] MSG#### 하드코딩 없음 → t('msg.MSG####') 변환
```

자동 검증 (CI 또는 로컬):
```bash
PENDING=$(grep -c '| ❌ |$' features/{domain}/src/pages/{page}/__asis-mapping__.md)
[ $PENDING -eq 0 ] || { echo "❌ 미적용 $PENDING 건"; exit 1; }
```

→ 상세 룰: `09_WIJMO_VALIDATION_EXPRESSION.md`

---

## 6. GATE-5: 일관성 ("한 사람이 짠 것처럼")

리뷰어가 새 파일을 표준 화면과 나란히 놓고 비교:

```
[ ] 폴더 구조가 features/admin/src/pages/user-management/ 와 동일한가?
[ ] import 순서가 표준 (foundation → shared → 같은 feature → 외부) 인가?
[ ] 함수/변수 명명이 표준 패턴 (camelCase / PascalCase / kebab-case) 인가?
[ ] export 방식 (named) 일관되는가?
[ ] 빈 줄 / indent / 주석 스타일이 user-management 와 일치하는가?
[ ] BE: BaseController / BaseService 패턴 일관 적용?
[ ] BE: 클래스 헤더 Javadoc 표준 (@Project @Package @FileName @author @date @description) 포함?
[ ] 에러 처리 패턴 일관 (`14_ERROR_HANDLING.md` 표준 따름) ?
```

---

## 7. 보안 / 성능 점검

### 7.1 보안
```
[ ] 하드코딩된 패스워드 / API 키 / 토큰 없음 (.env / Jasypt 사용)
[ ] SQL Injection 방어 (MyBatis #{} 만)
[ ] XSS 방어 (dangerouslySetInnerHTML 없음, sanitize)
[ ] 권한 체크 FE + BE 양쪽 (메뉴 권한 + 버튼 권한 2 테이블)
[ ] Sensitive 데이터 로깅 없음 (패스워드, 주민번호, 카드번호)
[ ] @LoginUser UserSession 사용 (SecurityContext 직접 접근 X)
```

### 7.2 성능
```
[ ] Wijmo Grid 가상화 활성화 (대량 데이터)
[ ] Zustand 셀렉터 개별 사용 (리렌더링 최소화)
[ ] BE Procedure 인덱스 적절히 활용
[ ] N+1 쿼리 없음 (단일 SP 호출)
[ ] 대량 INSERT/UPDATE BULK 활용
```

---

## 8. 커밋 / 브랜치 / PR 형식

### 8.1 브랜치명
```
[ ] feat/fix/docs/style/refactor/test/chore + kebab-case
[ ] 예시: feat/dmf0099-sales-monitor, fix/login-redirect
```

### 8.2 커밋 메시지 (Conventional Commits)
```
[ ] type(scope): subject 형식
[ ] subject 한 줄 명확 (50자 이내 권장)
[ ] body 에 변경 이유 + 영향 범위
[ ] footer 에 PJ 번호 또는 BREAKING CHANGE
```

예시:
```
feat(demand): DMF0099 Sales Monitor 화면 추가

- Wijmo FlexGrid 기반 메인 그리드 + 검색/저장
- Zustand store: useDmf0099SalesMonitorStore
- BE: PKG_DMF0099.P_DMF0099_GET_MAIN_DATA 호출
- i18n MSG: MSG_DMF0099_SAVED, LBL00200~LBL00210

Refs: PJ2026-12345
```

### 8.3 PR 본문
```
[ ] 작업 내용 (3~5줄 요약)
[ ] 변경 이유 (필요 시 As-Is 화면 ID + 분석 자료 링크)
[ ] 테스트 결과 (수동 + 자동)
[ ] 신규 화면이면 7개 영역 메타 검증 SQL 결과 첨부
[ ] 스크린샷 (UI 변경 시)
[ ] 변경 파일 수가 적절한가? (>100개면 분리 권장)
```

---

## 9. 문서 갱신 점검

```
[ ] 해당 화면의 validation.md 갱신 (검증 로직 변경 시)
[ ] 해당 화면의 analysis.md 갱신 (구조 변경 시)
[ ] Doc/_analysis/domain_*/INDEX.md (신규 화면 추가 시 카운트 갱신)
[ ] Doc/_analysis/PROGRESS.md (마일스톤 완료 시)
[ ] 변경 이력 (헤더 주석 또는 CHANGELOG)
[ ] 신규 패턴 도입 시 룰셋 (Doc/_dev_rules/) 보강 PR 동반
```

---

## 10. 머지 후 후속

```
[ ] CI 통과 모니터링
[ ] dev 브랜치 동기화
[ ] Jira/PJ 티켓 상태 변경
[ ] 다음 단계 작업 등록 (이번 PR 에서 의도적으로 미루었던 부분)
[ ] 메모리 또는 룰셋에 반영 가치 있는 결정 사항 기록
```

---

## 11. 최종 자문 (PR 제출 직전 9 질문)

1. "이 변경이 기존 코드 베이스와 자연스럽게 어우러지는가?"
2. "내가 작성한 코드를 user-management 와 나란히 두고 차이가 없는가?"
3. "리뷰어가 'OK'를 누를 만큼 완성도 있는가?"
4. "MSSQL 키워드 잔존 0건인가? (DB 변환 작업 시)"
5. "Syntax Error 없이 컴파일/빌드되는가?"
6. ⭐ "As-Is Validation/Expression 누락 0건인가? (신규 화면 FE 작업 시)"
7. ⭐ "신규 화면 등록 SQL 4-파일 세트가 모두 첨부되었는가? (SQL\*Plus 1 + DBeaver 3)"
8. ⭐ "_Verify.sql 실행 결과 7개 영역 모두 CNT ≥ EXPECT_MIN 인가?"
9. ⭐ "FE 검색/저장 핸들러에서 gridRef.current.invalidate() 직접 호출 0건인가? (Wijmo finishEditing 에러 방지)"

9개 모두 "예" 일 때만 PR 제출.

---

**본 체크리스트는 PR 의 최종 안전망입니다. 한 항목이라도 미달이면 머지 거부.**
