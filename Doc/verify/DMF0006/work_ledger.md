# 작업 원장 — DMF0006 · 2026-10-26 12:49

> 검사 인스턴스 195건 중 PASS·NA 3건 외 **192건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W4 | 검사기 구현 | 6 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 22 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 114 | 실행 → PASS |
| W7 | 기대값 확정 | 50 | 기대 확정 → PASS/FAIL |

- 담당: E2E 114 · 사람 판정 / AS-IS 원문 확인 → 재판정 50 · 하네스 28
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 25 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  | 10 | 5 |  |  | 연쇄 자동 채움 |
| D1 | EDIT |  |  |  |  |  | 14 | 1 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 14 | 1 |  |  | 행 값 기반 조건부 잠금 |
| C2 | CASCADE |  |  |  |  |  | 9 | 5 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 9 | 5 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| M4 | POPUP |  |  |  |  |  | 11 | 1 |  |  | 팝업 선택값 반영 |
| B4 | COMBO |  |  |  |  | 8 |  | 1 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 6 |  |  | 1 |  |  | 콤보 후보 정렬 = AS-IS |
| D5 | EDIT |  |  |  |  |  | 5 | 1 |  |  | 셀 에디터 유형 |
| B1 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 중복 없음 |
| C1 | CASCADE |  |  |  |  |  | 5 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G4 | DESIGN |  |  |  |  |  | 5 |  |  |  | 조회조건 표시·라벨·활성 |
| E4 | EDIT |  |  |  |  |  | 5 |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 5 |  |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | GEN |  |  |  |  |  | 5 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| A5 | DESIGN |  |  |  |  |  | 2 | 1 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 2 | 1 |  |  | 라벨 명칭 |
| F4 | DB |  |  |  |  |  | 2 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| H2 | DESIGN |  |  |  |  |  | 1 | 1 |  |  | 배경·글자색 규칙 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | GEN |  |  |  |  |  | 1 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| A1 | GEN |  |  |  |  |  |  | 1 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |

## W4 검사기 구현 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0006-0001 | B3 | DEPT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DEPT_ID | 있음(SHEET_COLUMNS) | 5 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0002 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 8 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0003 | B3 | END_CUSTOMER | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0004 | B3 | clbDivisions / Division / Divisions | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivisions / Division / Divisions | 있음(FE 소스) | 2 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0005 | B3 | clbEndCustomer / End Customer | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbEndCustomer / End Customer | 있음(FE 소스) | 1 (ACT:DMF0006_CustomerModelMapping.clbEndC) |
| WK-DMF0006-0006 | B3 | clbTeam / Team | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbTeam / Team | 있음(FE 소스) | 1 (ACT:DMF0006_CustomerModelMapping.clbDivi) |

## W5 검사기 연결 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0006-0007 | B1 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0008 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 5 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0009 | B1 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0010 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0011 | B1 | TEAM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TEAM_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0012 | B2 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0013 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 5 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0014 | B2 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0015 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0016 | B2 | TEAM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TEAM_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0017 | B4 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 9 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0018 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 13 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0019 | B4 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0020 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0021 | B4 | TEAM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TEAM_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0022 | B4 | clbDivisions / Division / Divisions | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivisions / Division / Divisions | 있음(FE 소스) | 2 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0023 | B4 | clbEndCustomer / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbEndCustomer / End Customer | 있음(FE 소스) | 1 (ACT:DMF0006_CustomerModelMapping.clbEndC) |
| WK-DMF0006-0024 | B4 | clbTeam / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbTeam / Team | 있음(FE 소스) | 1 (ACT:DMF0006_CustomerModelMapping.clbDivi) |
| WK-DMF0006-0025 | F2 | DMF0006 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0006 화면 | 판단불가(대상 단위 SCREEN) | 116 (ACT:DMF0006_CustomerModelMapping.SaveBut) |
| WK-DMF0006-0026 | F6 | DMF0006 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0006 화면 | 판단불가(대상 단위 SCREEN) | 116 (ACT:DMF0006_CustomerModelMapping.SaveBut) |
| WK-DMF0006-0027 | DB-SYN | DM0000_GET_COMMON_SPREAD_TITLE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0000_GET_COMMON_SPREAD_TITLE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0006_CustomerModelMapping.GetSpdT) |
| WK-DMF0006-0028 | G03-WIRE | DMF0006 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0006 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:DMF0006_CustomerModelMapping..ctor A) |

## W6 검증 실행 (114)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0006-0029 | J2 | DMF0006 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0006 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 23 (ACT:DMF0006_CustomerModelMapping.btnMode) |
| WK-DMF0006-0030 | C1 | cboActive / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboActive / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0031 | C1 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0032 | C1 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0033 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 5 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0034 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0035 | C2 | CONVERT_QTY_CELL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CONVERT_QTY_CELL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:DMF0006_CustomerModelMapping.Dsdm_Ch) |
| WK-DMF0006-0036 | C2 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 52 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0037 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 72 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0038 | C2 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 15 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0039 | C2 | ITEM_CLASS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_CLASS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0040 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0041 | C2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (ACT:DMF0006_CustomerModelMapping.clbDivi) |
| WK-DMF0006-0042 | C2 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0043 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0044 | C3 | CONVERT_QTY_CELL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CONVERT_QTY_CELL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:DMF0006_CustomerModelMapping.Dsdm_Ch) |
| WK-DMF0006-0045 | C3 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 52 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0046 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 73 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0047 | C3 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 15 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0048 | C3 | ITEM_CLASS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_CLASS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0049 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 13 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0050 | C3 | ITEM_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0051 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 16 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0052 | C3 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 17 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0053 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0054 | C6 | CONVERT_QTY_CELL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CONVERT_QTY_CELL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:DMF0006_CustomerModelMapping.Dsdm_Ch) |
| WK-DMF0006-0055 | C6 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 52 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0056 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 72 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0057 | C6 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 15 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0058 | C6 | ITEM_CLASS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_CLASS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0059 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0060 | C6 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (ACT:DMF0006_CustomerModelMapping.clbDivi) |
| WK-DMF0006-0061 | C6 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0062 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0063 | K4 | DMF0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0006 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 23 (ACT:DMF0006_CustomerModelMapping.btnMode) |
| WK-DMF0006-0064 | F1 | DMF0006 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0006 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 119 (ACT:DMF0006_CustomerModelMapping.DeleteB) |
| WK-DMF0006-0065 | F5 | DMF0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0006 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.DeleteB) |
| WK-DMF0006-0066 | F4 | DM0000_GET_COMMON_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 2 (ACT:DMF0006_CustomerModelMapping.GetSpdT) |
| WK-DMF0006-0067 | F4 | PKG_DMF0006.P_DMF0006_GET_CUSTOMER_MODEL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0006.P_DMF0006_GET_CUSTOMER_MODEL_MAPPING_D · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 170 (ACT:DMF0006_CustomerModelMapping.FindBut) |
| WK-DMF0006-0068 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0006_CustomerModelMapping.clbDivi) |
| WK-DMF0006-0069 | A5 | PROJECT_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0070 | G4 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboActive / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0071 | G4 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivisions / Division / Divisions · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0072 | G4 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0073 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0074 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0075 | H2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0006_CustomerModelMapping.InitSpr) |
| WK-DMF0006-0076 | H4 | DMF0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0006 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0077 | H5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.clbDivi) |
| WK-DMF0006-0078 | H5 | clbDivisions / Division / Divisions | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbDivisions / Division / Divisions · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실 |  | 2 (ACT:DMF0006_CustomerModelMapping.CreateS) |
| WK-DMF0006-0079 | I1 | DMF0006 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0006 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 8 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0080 | D1 | AUTHORITY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — AUTHORITY_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0081 | D1 | CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CAPACITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0082 | D1 | CONVERT_QTY_CELL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CONVERT_QTY_CELL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0083 | D1 | CONVERT_QTY_MODULE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CONVERT_QTY_MODULE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0084 | D1 | CUSTOMER_MODEL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CUSTOMER_MODEL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0085 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0086 | D1 | ITEM_CLASS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_CLASS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0087 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0088 | D1 | ITEM_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0089 | D1 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0090 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0091 | D1 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0092 | D1 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0093 | D1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0094 | D3 | AUTHORITY_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — AUTHORITY_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0095 | D3 | CAPACITY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CAPACITY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0096 | D3 | CONVERT_QTY_CELL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CONVERT_QTY_CELL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0097 | D3 | CONVERT_QTY_MODULE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CONVERT_QTY_MODULE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0098 | D3 | CUSTOMER_MODEL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CUSTOMER_MODEL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0099 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0100 | D3 | ITEM_CLASS_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_CLASS_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0101 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0102 | D3 | ITEM_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0103 | D3 | LAST_UPDATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0104 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0105 | D3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0106 | D3 | PROJECT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0107 | D3 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0108 | D5 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0109 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0110 | D5 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0111 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0112 | D5 | TEAM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TEAM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0113 | D6 | DMF0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0006 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.InsertB) |
| WK-DMF0006-0114 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0006_CustomerModelMapping.SaveDat) |
| WK-DMF0006-0115 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0006_CustomerModelMapping.SaveDat) |
| WK-DMF0006-0116 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0006_CustomerModelMapping.SaveDat) |
| WK-DMF0006-0117 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0118 | E4 | MSG00137 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00137 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0119 | A10 | DMF0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0006 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 38 (ACT:DMF0006_CustomerModelMapping.DefineP) |
| WK-DMF0006-0120 | A6 | PKG_DMF0006.P_DMF0006_GET_CUSTOMER_MODEL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0006.P_DMF0006_GET_CUSTOMER_MODEL_MAPPING_D · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 54 (ACT:DMF0006_CustomerModelMapping.FindBut) |
| WK-DMF0006-0121 | G1 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboActive / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0122 | G1 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisions / Division / Divisions · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0123 | G1 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0124 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0125 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0126 | G6 | cboActive / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboActive / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0127 | G6 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0128 | G6 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0129 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0130 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0131 | X-REOPEN | DMF0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0006 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:DMF0006_CustomerModelMapping.Dispose) |
| WK-DMF0006-0132 | M4 | CONVERT_QTY_CELL | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CONVERT_QTY_CELL · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0133 | M4 | CONVERT_QTY_MODULE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CONVERT_QTY_MODULE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0134 | M4 | DEPT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DEPT_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0135 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0136 | M4 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0137 | M4 | ITEM_CLASS_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_CLASS_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0138 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0139 | M4 | ITEM_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0140 | M4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0141 | M4 | PROJECT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 40 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0142 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:DMF0006_CustomerModelMapping.spdMain) |

## W7 기대값 확정 (50)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0006-0143 | C2 | DMF0006_CustomerModelMapping.Dsdm_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0006_CustomerModelMapping.Dsdm_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0006_CustomerModelMapping.Dsdm_Ch) |
| WK-DMF0006-0144 | C2 | DMF0006_CustomerModelMapping.clbDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0006_CustomerModelMapping.clbDivision_SelectedI: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0006_CustomerModelMapping.clbDivi) |
| WK-DMF0006-0145 | C2 | DMF0006_CustomerModelMapping.clbEndCusto | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0006_CustomerModelMapping.clbEndCustomer_Select: 진입점 집계 — C2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0006-0146 | C2 | DMF0006_CustomerModelMapping.clbTeam_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0006_CustomerModelMapping.clbTeam_SelectedIndex: 진입점 집계 — C2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0006_CustomerModelMapping.clbTeam) |
| WK-DMF0006-0147 | C2 | DMF0006_CustomerModelMapping.spdMain_Com | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0006_CustomerModelMapping.spdMain_ComboSelChang: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0148 | C3 | DMF0006_CustomerModelMapping.Dsdm_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0006_CustomerModelMapping.Dsdm_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0006_CustomerModelMapping.Dsdm_Ch) |
| WK-DMF0006-0149 | C3 | DMF0006_CustomerModelMapping.clbDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0006_CustomerModelMapping.clbDivision_SelectedI: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0006_CustomerModelMapping.clbDivi) |
| WK-DMF0006-0150 | C3 | DMF0006_CustomerModelMapping.clbEndCusto | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0006_CustomerModelMapping.clbEndCustomer_Select: 진입점 집계 — C3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0006-0151 | C3 | DMF0006_CustomerModelMapping.clbTeam_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0006_CustomerModelMapping.clbTeam_SelectedIndex: 진입점 집계 — C3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0006_CustomerModelMapping.clbTeam) |
| WK-DMF0006-0152 | C3 | DMF0006_CustomerModelMapping.spdMain_Com | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0006_CustomerModelMapping.spdMain_ComboSelChang: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0153 | C6 | DMF0006_CustomerModelMapping.Dsdm_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0006_CustomerModelMapping.Dsdm_Changed: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0006_CustomerModelMapping.Dsdm_Ch) |
| WK-DMF0006-0154 | C6 | DMF0006_CustomerModelMapping.clbDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0006_CustomerModelMapping.clbDivision_SelectedI: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0006_CustomerModelMapping.clbDivi) |
| WK-DMF0006-0155 | C6 | DMF0006_CustomerModelMapping.clbEndCusto | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0006_CustomerModelMapping.clbEndCustomer_Select: 진입점 집계 — C6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0006-0156 | C6 | DMF0006_CustomerModelMapping.clbTeam_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0006_CustomerModelMapping.clbTeam_SelectedIndex: 진입점 집계 — C6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0006_CustomerModelMapping.clbTeam) |
| WK-DMF0006-0157 | C6 | DMF0006_CustomerModelMapping.spdMain_Com | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0006_CustomerModelMapping.spdMain_ComboSelChang: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0158 | B3 | DMF0006_CustomerModelMapping.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0006_CustomerModelMapping.GetSpdTitle: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0006_CustomerModelMapping.GetSpdT) |
| WK-DMF0006-0159 | B4 | DMF0006_CustomerModelMapping.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0006_CustomerModelMapping.GetSpdTitle: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0006_CustomerModelMapping.GetSpdT) |
| WK-DMF0006-0160 | A5 | DMF0006_CustomerModelMapping.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0006_CustomerModelMapping.CreateSpread: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0006_CustomerModelMapping.CreateS) |
| WK-DMF0006-0161 | H2 | DMF0006_CustomerModelMapping.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0006_CustomerModelMapping.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0006_CustomerModelMapping.CreateS) |
| WK-DMF0006-0162 | H5 | DMF0006_CustomerModelMapping.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0006_CustomerModelMapping.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0006_CustomerModelMapping.CreateS) |
| WK-DMF0006-0163 | D1 | DMF0006_CustomerModelMapping.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DMF0006_CustomerModelMapping.EditButton: 진입점 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0164 | D3 | DMF0006_CustomerModelMapping.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DMF0006_CustomerModelMapping.EditButton: 진입점 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0006_CustomerModelMapping.EditBut) |
| WK-DMF0006-0165 | D5 | DMF0006_CustomerModelMapping.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0006_CustomerModelMapping.CreateSpread: 진입점 집계 — D5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0006_CustomerModelMapping.CreateS) |
| WK-DMF0006-0166 | A1 | PKG_DMF0006.P_DMF0006_GET_CUSTOMER_MODEL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0006.P_DMF0006_GET_CUSTOMER_MODEL_MAPPING_D: 골든 비교 케이스 없음(PKG_DMF0006.P_DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA |  | 54 (ACT:DMF0006_CustomerModelMapping.FindBut) |
| WK-DMF0006-0167 | X-ROW | DMF0006_CustomerModelMapping.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.CreateSpread: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0006_CustomerModelMapping.CreateS) |
| WK-DMF0006-0168 | X-ROW | DMF0006_CustomerModelMapping.DefinePrope | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.DefineProperty: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0006_CustomerModelMapping.DefineP) |
| WK-DMF0006-0169 | X-ROW | DMF0006_CustomerModelMapping.Dsdm_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.Dsdm_Changed: 진입점 집계 7검사 — NOT_RUN:3 · REVIEW:3 · NOPATH:1 |  | 2 (ACT:DMF0006_CustomerModelMapping.Dsdm_Ch) |
| WK-DMF0006-0170 | X-ROW | DMF0006_CustomerModelMapping.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP |  | 16 (ACT:DMF0006_CustomerModelMapping.ExcelBu) |
| WK-DMF0006-0171 | X-ROW | DMF0006_CustomerModelMapping.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:DMF0006_CustomerModelMapping.FindBut) |
| WK-DMF0006-0172 | X-ROW | DMF0006_CustomerModelMapping.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.FindData: 진입점 집계 17검사 — NOT_RUN:15 · REVIEW:1 · PASS:1 |  | 6 (ACT:DMF0006_CustomerModelMapping.FindDat) |
| WK-DMF0006-0173 | X-ROW | DMF0006_CustomerModelMapping.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0006_CustomerModelMapping.Form_Lo) |
| WK-DMF0006-0174 | X-ROW | DMF0006_CustomerModelMapping.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0006_CustomerModelMapping.GetSpdT) |
| WK-DMF0006-0175 | X-ROW | DMF0006_CustomerModelMapping.InitControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.InitControls: 진입점 집계 18검사 — NOT_RUN:16 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0006_CustomerModelMapping.InitCon) |
| WK-DMF0006-0176 | X-ROW | DMF0006_CustomerModelMapping.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0006_CustomerModelMapping.InitSpr) |
| WK-DMF0006-0177 | X-ROW | DMF0006_CustomerModelMapping.InitSpread_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.InitSpread_X: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0006_CustomerModelMapping.InitSpr) |
| WK-DMF0006-0178 | X-ROW | DMF0006_CustomerModelMapping.InsertButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0006_CustomerModelMapping.InsertB) |
| WK-DMF0006-0179 | X-ROW | DMF0006_CustomerModelMapping.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.InsertRow: 진입점 집계 33검사 — NOT_RUN:24 · NOPATH:9 (미실행 검사가 남아 판정필요) |  | 39 (ACT:DMF0006_CustomerModelMapping.InsertR) |
| WK-DMF0006-0180 | X-ROW | DMF0006_CustomerModelMapping.SaveData_Da | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.SaveData_DataService: 진입점 집계 11검사 — NOT_RUN:8 · NOPATH:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0006_CustomerModelMapping.SaveDat) |
| WK-DMF0006-0181 | X-ROW | DMF0006_CustomerModelMapping.btnModelTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.btnModelType_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0006_CustomerModelMapping.btnMode) |
| WK-DMF0006-0182 | X-ROW | DMF0006_CustomerModelMapping.btnProject_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.btnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0006_CustomerModelMapping.btnProj) |
| WK-DMF0006-0183 | X-ROW | DMF0006_CustomerModelMapping.clbDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.clbDivision_SelectedI: 진입점 집계 13검사 — NOT_RUN:8 · REVIEW:3 · NOPATH:1 · TODO:1 |  | 4 (ACT:DMF0006_CustomerModelMapping.clbDivi) |
| WK-DMF0006-0184 | X-ROW | DMF0006_CustomerModelMapping.clbEndCusto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.clbEndCustomer_Select: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:2 · TODO:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0006_CustomerModelMapping.clbEndC) |
| WK-DMF0006-0185 | X-ROW | DMF0006_CustomerModelMapping.clbTeam_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.clbTeam_SelectedIndex: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0006_CustomerModelMapping.clbTeam) |
| WK-DMF0006-0186 | X-ROW | DMF0006_CustomerModelMapping.spdMain_Cel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.spdMain_CellDoubleCli: 진입점 집계 26검사 — NOT_RUN:24 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0187 | X-ROW | DMF0006_CustomerModelMapping.spdMain_Com | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.spdMain_ComboSelChang: 진입점 집계 46검사 — NOT_RUN:28 · NOPATH:12 · REVIEW:3 · TODO:3 |  | 22 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0188 | X-ROW | DMF0006_CustomerModelMapping.spdMain_Key | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.spdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0189 | X-ROW | DMF0006_CustomerModelMapping.spdMain_Top | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0006_CustomerModelMapping.spdMain) |
| WK-DMF0006-0190 | X-ROW | DMF0006_CustomerModelMapping.umltModel_K | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.umltModel_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0006_CustomerModelMapping.umltMod) |
| WK-DMF0006-0191 | X-ROW | DMF0006_CustomerModelMapping.umltProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0006_CustomerModelMapping.umltProject_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0006_CustomerModelMapping.umltPro) |
| WK-DMF0006-0192 | M4 | DMF0006_CustomerModelMapping.spdMain_Cel | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0006_CustomerModelMapping.spdMain_CellDoubleCli: 진입점 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0006_CustomerModelMapping.spdMain) |
