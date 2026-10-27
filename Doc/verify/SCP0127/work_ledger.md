# 작업 원장 — SCP0127 · 2026-10-26 12:55

> 검사 인스턴스 141건 중 PASS·NA 13건 외 **128건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 71 | 실행 → PASS |
| W7 | 기대값 확정 | 50 | 기대 확정 → PASS/FAIL |

- 담당: E2E 71 · 사람 판정 / AS-IS 원문 확인 → 재판정 50 · 하네스 7
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 27 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 12 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  | 5 | 7 |  |  | 연쇄 자동 채움 |
| C2 | CASCADE |  |  |  |  |  | 5 | 4 |  |  | 그리드 셀 cascade 후보 |
| G1 | GEN |  |  |  |  |  | 7 |  |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C1 | CASCADE |  |  |  |  |  | 6 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D1 | EDIT |  |  |  |  |  | 4 | 1 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 4 | 1 |  |  | 행 값 기반 조건부 잠금 |
| G4 | DESIGN |  |  |  |  | 1 | 3 |  |  |  | 조회조건 표시·라벨·활성 |
| M4 | POPUP |  |  |  |  |  | 3 | 1 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 2 |  | 1 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 1 | 1 |  |  | 팝업 표준·열림 |
| F4 | DB |  |  |  |  |  | 3 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| H2 | DESIGN |  |  |  |  |  | 1 | 2 |  |  | 배경·글자색 규칙 |
| G6 | GEN |  |  |  |  |  | 3 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| A5 | DESIGN |  |  |  |  |  | 1 | 1 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| E1 | EDIT |  |  |  |  |  | 2 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | GEN |  |  |  |  |  | 1 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| A1 | GEN |  |  |  |  |  |  | 1 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0001 | F2 | SCP0127 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0127 화면 | 판단불가(대상 단위 SCREEN) | 181 (ACT:SCP0127_PrecedeSafetyStockDay.SaveBu) |
| WK-SCP0127-0002 | F6 | SCP0127 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0127 화면 | 판단불가(대상 단위 SCREEN) | 181 (ACT:SCP0127_PrecedeSafetyStockDay.SaveBu) |
| WK-SCP0127-0003 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0127_PrecedeSafetyStockDay.InitEv) |
| WK-SCP0127-0004 | G03-WIRE | SCP0127 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0127 화면 | 판단불가(대상 단위 SCREEN) | 10 (ACT:SCP0127_PrecedeSafetyStockDay..ctor ) |
| WK-SCP0127-0005 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 16 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0006 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0007 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 16 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |

## W6 검증 실행 (71)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0008 | J2 | SCP0127 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0127 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 12 (ACT:SCP0127_PrecedeSafetyStockDay.btnIte) |
| WK-SCP0127-0009 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0010 | C1 | cboStage / Stage | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboStage / Stage · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Refres) |
| WK-SCP0127-0011 | C1 | cboType / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboType / Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0012 | C1 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0013 | C1 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Refres) |
| WK-SCP0127-0014 | C1 | clbSite / SCM Site / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSite / SCM Site / Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Refres) |
| WK-SCP0127-0015 | C2 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0016 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0017 | C2 | STAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — STAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0018 | C2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0019 | C2 | VALUE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VALUE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0020 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.Set_Me) |
| WK-SCP0127-0021 | C3 | FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0022 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0023 | C3 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0024 | C3 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0025 | K4 | SCP0127 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0127 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 12 (ACT:SCP0127_PrecedeSafetyStockDay.btnIte) |
| WK-SCP0127-0026 | F1 | SCP0127 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0127 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 186 (ACT:SCP0127_PrecedeSafetyStockDay.Delete) |
| WK-SCP0127-0027 | F3 | SCP0127 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0127 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 11 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0028 | F5 | SCP0127 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0127 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.Delete) |
| WK-SCP0127-0029 | F4 | PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 232 (ACT:SCP0127_PrecedeSafetyStockDay.FindBu) |
| WK-SCP0127-0030 | F4 | PKG_SCP0127.P_SCP0127_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0127.P_SCP0127_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 182 (ACT:SCP0127_PrecedeSafetyStockDay.GetSea) |
| WK-SCP0127-0031 | F4 | PKG_SCP0127.P_SCP0127_SAVE_PRECEDE_SAFET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0127.P_SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 181 (ACT:SCP0127_PrecedeSafetyStockDay.SaveBu) |
| WK-SCP0127-0032 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0033 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0034 | G4 | cboType / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboType / Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0035 | G4 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0036 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.Set_Me) |
| WK-SCP0127-0037 | H4 | SCP0127 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0127 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0038 | I1 | SCP0127 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0127 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 13 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0039 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0040 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0041 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Insert) |
| WK-SCP0127-0042 | D1 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0043 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0044 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0045 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Insert) |
| WK-SCP0127-0046 | D3 | PRE_KEY_VALUES | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRE_KEY_VALUES · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0047 | D6 | SCP0127 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0127 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.Insert) |
| WK-SCP0127-0048 | E1 | FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0049 | E1 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0050 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.Set_Me) |
| WK-SCP0127-0051 | E4 | FROM_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0052 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0053 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0054 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0055 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0056 | E4 | MSG00085 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00085 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0057 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0058 | E4 | MSG00260 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00260 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0059 | E4 | MSG00458 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00458 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0060 | E4 | TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0061 | E4 | TYPE_APPLY_DAY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TYPE_APPLY_DAY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0062 | A10 | SCP0127 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0127 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 40 (ACT:SCP0127_PrecedeSafetyStockDay.Define) |
| WK-SCP0127-0063 | A6 | PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 52 (ACT:SCP0127_PrecedeSafetyStockDay.FindBu) |
| WK-SCP0127-0064 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0065 | G1 | cboStage / Stage | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboStage / Stage · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0066 | G1 | cboType / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboType / Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0067 | G1 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0068 | G1 | clbPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlanGroup / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0069 | G1 | clbSite / SCM Site / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSite / SCM Site / Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0070 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0071 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0072 | G6 | cboType / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboType / Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0073 | G6 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0074 | X-REOPEN | SCP0127 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0127 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0127_PrecedeSafetyStockDay.Dispos) |
| WK-SCP0127-0075 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0076 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 16 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0077 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0078 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |

## W7 기대값 확정 (50)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0079 | C2 | SCP0127_PrecedeSafetyStockDay.CboDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CboDivision_Selected: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.CboDiv) |
| WK-SCP0127-0080 | C2 | SCP0127_PrecedeSafetyStockDay.CboPlanGro | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CboPlanGroup_Selecte: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.CboPla) |
| WK-SCP0127-0081 | C2 | SCP0127_PrecedeSafetyStockDay.CboPlanSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CboPlanSeq_SelectedI: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.CboPla) |
| WK-SCP0127-0082 | C2 | SCP0127_PrecedeSafetyStockDay.ClbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0127_PrecedeSafetyStockDay.ClbDivision_Selected: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.ClbDiv) |
| WK-SCP0127-0083 | C3 | SCP0127_PrecedeSafetyStockDay.CboDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CboDivision_Selected: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.CboDiv) |
| WK-SCP0127-0084 | C3 | SCP0127_PrecedeSafetyStockDay.CboPlanGro | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CboPlanGroup_Selecte: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.CboPla) |
| WK-SCP0127-0085 | C3 | SCP0127_PrecedeSafetyStockDay.CboPlanSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CboPlanSeq_SelectedI: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.CboPla) |
| WK-SCP0127-0086 | C3 | SCP0127_PrecedeSafetyStockDay.ClbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0127_PrecedeSafetyStockDay.ClbDivision_Selected: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.ClbDiv) |
| WK-SCP0127-0087 | C3 | SCP0127_PrecedeSafetyStockDay.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SetChangedControl: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.SetCha) |
| WK-SCP0127-0088 | C3 | SCP0127_PrecedeSafetyStockDay.Set_Measur | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0127_PrecedeSafetyStockDay.Set_MeasureColor: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0127_PrecedeSafetyStockDay.Set_Me) |
| WK-SCP0127-0089 | C3 | SCP0127_PrecedeSafetyStockDay.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0127_PrecedeSafetyStockDay.setPeriod: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.setPer) |
| WK-SCP0127-0090 | A5 | SCP0127_PrecedeSafetyStockDay.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.Create) |
| WK-SCP0127-0091 | H2 | SCP0127_PrecedeSafetyStockDay.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.Create) |
| WK-SCP0127-0092 | H2 | SCP0127_PrecedeSafetyStockDay.Set_Measur | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0127_PrecedeSafetyStockDay.Set_MeasureColor: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0127_PrecedeSafetyStockDay.Set_Me) |
| WK-SCP0127-0093 | D1 | SCP0127_PrecedeSafetyStockDay.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0127_PrecedeSafetyStockDay.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0094 | D3 | SCP0127_PrecedeSafetyStockDay.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0127_PrecedeSafetyStockDay.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.EditBu) |
| WK-SCP0127-0095 | E4 | SCP0127_PrecedeSafetyStockDay.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SetChangedControl: 진입점 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.SetCha) |
| WK-SCP0127-0096 | E4 | SCP0127_PrecedeSafetyStockDay.Set_Measur | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0127_PrecedeSafetyStockDay.Set_MeasureColor: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0127_PrecedeSafetyStockDay.Set_Me) |
| WK-SCP0127-0097 | E4 | SCP0127_PrecedeSafetyStockDay.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0127_PrecedeSafetyStockDay.setPeriod: 진입점 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.setPer) |
| WK-SCP0127-0098 | A1 | PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY: 골든 비교 케이스 없음(PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY —  |  | 52 (ACT:SCP0127_PrecedeSafetyStockDay.FindBu) |
| WK-SCP0127-0099 | X-ROW | SCP0127_PrecedeSafetyStockDay.CboDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CboDivision_Selected: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.CboDiv) |
| WK-SCP0127-0100 | X-ROW | SCP0127_PrecedeSafetyStockDay.CboPlanGro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CboPlanGroup_Selecte: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.CboPla) |
| WK-SCP0127-0101 | X-ROW | SCP0127_PrecedeSafetyStockDay.CboPlanSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CboPlanSeq_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.CboPla) |
| WK-SCP0127-0102 | X-ROW | SCP0127_PrecedeSafetyStockDay.ClbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.ClbDivision_Selected: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.ClbDiv) |
| WK-SCP0127-0103 | X-ROW | SCP0127_PrecedeSafetyStockDay.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Create) |
| WK-SCP0127-0104 | X-ROW | SCP0127_PrecedeSafetyStockDay.DefineProp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.Define) |
| WK-SCP0127-0105 | X-ROW | SCP0127_PrecedeSafetyStockDay.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.FindBu) |
| WK-SCP0127-0106 | X-ROW | SCP0127_PrecedeSafetyStockDay.FindData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.FindData_Main: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0107 | X-ROW | SCP0127_PrecedeSafetyStockDay.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Form_L) |
| WK-SCP0127-0108 | X-ROW | SCP0127_PrecedeSafetyStockDay.GetDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.GetDivisionChecked: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.GetDiv) |
| WK-SCP0127-0109 | X-ROW | SCP0127_PrecedeSafetyStockDay.GetSearchI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.GetSearchInfo: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.GetSea) |
| WK-SCP0127-0110 | X-ROW | SCP0127_PrecedeSafetyStockDay.InitContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.InitControls: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.InitCo) |
| WK-SCP0127-0111 | X-ROW | SCP0127_PrecedeSafetyStockDay.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0127_PrecedeSafetyStockDay.InitSp) |
| WK-SCP0127-0112 | X-ROW | SCP0127_PrecedeSafetyStockDay.InsertButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Insert) |
| WK-SCP0127-0113 | X-ROW | SCP0127_PrecedeSafetyStockDay.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.Insert_Row: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0127_PrecedeSafetyStockDay.Insert) |
| WK-SCP0127-0114 | X-ROW | SCP0127_PrecedeSafetyStockDay.RefreshPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.RefreshPlanGroupByDi: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.Refres) |
| WK-SCP0127-0115 | X-ROW | SCP0127_PrecedeSafetyStockDay.RefreshSit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.RefreshSiteByDivisio: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0127_PrecedeSafetyStockDay.Refres) |
| WK-SCP0127-0116 | X-ROW | SCP0127_PrecedeSafetyStockDay.RefreshSta | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.RefreshStageByDivisi: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0127_PrecedeSafetyStockDay.Refres) |
| WK-SCP0127-0117 | X-ROW | SCP0127_PrecedeSafetyStockDay.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SaveData: 진입점 집계 18검사 — NOT_RUN:13 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0118 | X-ROW | SCP0127_PrecedeSafetyStockDay.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SetCha) |
| WK-SCP0127-0119 | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SpdMain_CellDoubleCl: 진입점 집계 12검사 — NOT_RUN:6 · NOPATH:3 · REVIEW:3 |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0120 | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SpdMain_ClipboardPas: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0121 | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_Ed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SpdMain_EditChange: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 37 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0122 | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_To | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0123 | X-ROW | SCP0127_PrecedeSafetyStockDay.btnItemId_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.btnIte) |
| WK-SCP0127-0124 | X-ROW | SCP0127_PrecedeSafetyStockDay.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.setPeriod: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.setPer) |
| WK-SCP0127-0125 | X-ROW | SCP0127_PrecedeSafetyStockDay.spdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0127_PrecedeSafetyStockDay.spdMain_CellClick: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SCP0127_PrecedeSafetyStockDay.spdMai) |
| WK-SCP0127-0126 | G5 | SCP0127_PrecedeSafetyStockDay.SpdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SpdMain_CellDoubleCl: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0127 | H6 | SCP0127_PrecedeSafetyStockDay.SpdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SpdMain_CellDoubleCl: 진입점 집계 — H6 2요소: NOT_RUN:1 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0128 | M4 | SCP0127_PrecedeSafetyStockDay.SpdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0127_PrecedeSafetyStockDay.SpdMain_CellDoubleCl: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
