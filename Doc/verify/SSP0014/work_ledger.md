# 작업 원장 — SSP0014 · 2026-10-26 12:56

> 검사 인스턴스 436건 중 PASS·NA 72건 외 **364건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 1 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 54 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 145 | 실행 → PASS |
| W7 | 기대값 확정 | 161 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 155 · E2E 145 · 하네스 56 · 대조표 7 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 28 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 1 |  |  |  |  | 21 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G1 | GEN |  |  |  |  |  | 6 | 16 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A5 | DESIGN |  |  |  |  |  | 10 | 10 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 9 | 9 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 10 | 8 |  |  | 라벨 명칭 |
| E4 | EDIT |  |  |  |  |  | 15 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A1 | GEN |  |  |  |  |  |  | 18 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G5 | POPUP |  |  |  |  | 10 |  | 6 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 9 | 1 | 6 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 10 | 6 |  |  | 팝업 선택값 반영 |
| C3 | CASCADE |  |  |  |  |  | 9 | 3 |  |  | 연쇄 자동 채움 |
| D1 | EDIT |  |  |  |  |  | 10 | 2 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 10 | 2 |  |  | 행 값 기반 조건부 잠금 |
| D5 | EDIT |  |  |  |  |  | 11 | 1 |  |  | 셀 에디터 유형 |
| G4 | DESIGN |  |  |  |  | 1 | 6 | 4 |  |  | 조회조건 표시·라벨·활성 |
| B4 | COMBO |  |  |  |  | 8 |  | 2 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D4 | EDIT |  |  |  |  |  | 9 | 1 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| G6 | GEN |  |  |  |  |  | 6 | 4 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B1 | COMBO |  |  |  |  | 7 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 7 |  |  |  |  | 콤보 후보 중복 없음 |
| X-REASON | DESIGN |  |  |  |  |  |  | 6 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| F4 | DB |  |  |  |  |  | 4 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B3 | COMBO |  |  |  | 2 |  |  | 2 |  |  | 콤보 후보 정렬 = AS-IS |
| B6 | COMBO |  |  |  |  | 4 |  |  |  |  | ALL 옵션·다중선택 사양 |
| C1 | CASCADE |  |  |  |  |  | 4 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| DB-SYN | DB |  |  |  |  | 2 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| E5 | EDIT |  |  |  |  | 3 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| A6 | GEN |  |  |  |  |  | 2 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| C4 | CASCADE |  |  |  |  |  | 1 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0001 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: SubTitle.tsx 없음, SearchArea.tsx 없음 |  | 1 (COMMON:UC-02) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0002 | H10 | SSP0014 화면 | DB(🛠️/🧯 적용 가능) | H10 FAIL 수정 — SSP0014 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: components/ShipmentModelPicForm.tsx |  | 8 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0003 | B3 | OPERATION_GROUP | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_GROUP | 있음(SHEET_COLUMNS) | 2 (Operation Group ACT:SSP0014_ShipmentMode) |
| WK-SSP0014-0004 | B3 | USER_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 USER_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0014_ShipmentModelPIC.GetUserIDCh) |

## W5 검사기 연결 (54)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0005 | B1 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0006 | B1 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0007 | B1 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0008 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SSP0014-0009 | B1 | cboOperationGroup / Operation Group / Op | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SSP0014-0010 | B1 | cboValidYN / Valid / Valid YN / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboValidYN / Valid / Valid YN / Active | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0014-0011 | B1 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SSP0014-0012 | B2 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0013 | B2 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0014 | B2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0015 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SSP0014-0016 | B2 | cboOperationGroup / Operation Group / Op | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SSP0014-0017 | B2 | cboValidYN / Valid / Valid YN / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboValidYN / Valid / Valid YN / Active | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0014-0018 | B2 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SSP0014-0019 | B4 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0020 | B4 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 3 (COMMON:UC-05 Operation Group ACT:SSP0014) |
| WK-SSP0014-0021 | B4 | USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL USER_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0014_ShipmentModelPIC.GetUserIDCh) |
| WK-SSP0014-0022 | B4 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0023 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SSP0014-0024 | B4 | cboOperationGroup / Operation Group / Op | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SSP0014-0025 | B4 | cboValidYN / Valid / Valid YN / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboValidYN / Valid / Valid YN / Active | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0014-0026 | B4 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SSP0014-0027 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SSP0014-0028 | B6 | cboOperationGroup / Operation Group / Op | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SSP0014-0029 | B6 | cboValidYN / Valid / Valid YN / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboValidYN / Valid / Valid YN / Active | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0014-0030 | B6 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SSP0014-0031 | F2 | SSP0014 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0014 화면 | 판단불가(대상 단위 SCREEN) | 105 (CRUD:SAVE COMMON:UC-04 A-1 A-3 A-5 B-1~B) |
| WK-SSP0014-0032 | F6 | SSP0014 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0014 화면 | 판단불가(대상 단위 SCREEN) | 100 (ProgressForm(FindData/SaveData) ACT:SSP0) |
| WK-SSP0014-0033 | DB-SYN | SSP0014_GET_SHIPMENT_MODEL_PIC | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0014_GET_SHIPMENT_MODEL_PIC | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0014_ShipmentModelPIC.FindData_Ma) |
| WK-SSP0014-0034 | DB-SYN | SSP0014_SAVE_SHIPMENT_MODEL_PIC | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0014_SAVE_SHIPMENT_MODEL_PIC | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0014_ShipmentModelPIC.SaveData:49) |
| WK-SSP0014-0035 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0014_ShipmentModelPIC.InitEvent A) |
| WK-SSP0014-0036 | E5 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0037 | E5 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0038 | E5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0014-0039 | G03-WIRE | SSP0014 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0014 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SSP0014_ShipmentModelPIC..ctor ACT:S) |
| WK-SSP0014-0040 | G5 | MAIL_USER1 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL MAIL_USER1 | 있음(SHEET_COLUMNS) | 14 (D00-3-018 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0041 | G5 | MAIL_USER2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL MAIL_USER2 | 있음(SHEET_COLUMNS) | 14 (D00-3-019 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0042 | G5 | MAIL_USER3 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL MAIL_USER3 | 있음(SHEET_COLUMNS) | 14 (D00-3-020 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0043 | G5 | MAIL_USER4 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL MAIL_USER4 | 있음(SHEET_COLUMNS) | 14 (D00-3-021 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0044 | G5 | MAIL_USER5 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL MAIL_USER5 | 있음(SHEET_COLUMNS) | 13 (D00-3-022 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0045 | G5 | PART_LEADER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PART_LEADER | 있음(SHEET_COLUMNS) | 14 (D00-3-016 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0046 | G5 | TEAM_LEADER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL TEAM_LEADER | 있음(SHEET_COLUMNS) | 14 (D00-3-017 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0047 | G5 | USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL USER_ID | 있음(SHEET_COLUMNS) | 16 (D00-3-015 15-22 UserInfoPopup(USER_ID/PA) |
| WK-SSP0014-0048 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (D00-2-002) |
| WK-SSP0014-0049 | G5 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0050 | H6 | MAIL_USER1 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MAIL_USER1 | 있음(SHEET_COLUMNS) | 14 (D00-3-018 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0051 | H6 | MAIL_USER2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MAIL_USER2 | 있음(SHEET_COLUMNS) | 14 (D00-3-019 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0052 | H6 | MAIL_USER3 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MAIL_USER3 | 있음(SHEET_COLUMNS) | 14 (D00-3-020 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0053 | H6 | MAIL_USER4 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MAIL_USER4 | 있음(SHEET_COLUMNS) | 14 (D00-3-021 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0054 | H6 | MAIL_USER5 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MAIL_USER5 | 있음(SHEET_COLUMNS) | 13 (D00-3-022 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0055 | H6 | PART_LEADER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PART_LEADER | 있음(SHEET_COLUMNS) | 14 (D00-3-016 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0056 | H6 | TEAM_LEADER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TEAM_LEADER | 있음(SHEET_COLUMNS) | 14 (D00-3-017 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0057 | H6 | USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL USER_ID | 있음(SHEET_COLUMNS) | 16 (D00-3-015 15-22 UserInfoPopup(USER_ID/PA) |
| WK-SSP0014-0058 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (D00-2-002) |

## W6 검증 실행 (145)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0059 | J2 | SSP0014 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0014 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 32 (D00-1-018 D00-2-001 D00-2-002 CRUD:SEARC) |
| WK-SSP0014-0060 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-001 ACT:SSP0014_ShipmentModelPIC.I) |
| WK-SSP0014-0061 | C1 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0014_ShipmentModelPIC.InitControl) |
| WK-SSP0014-0062 | C1 | cboValidYN / Valid / Valid YN / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValidYN / Valid / Valid YN / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0014_ShipmentModelPIC.InitControl) |
| WK-SSP0014-0063 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0014_ShipmentModelPIC.SetChangedC) |
| WK-SSP0014-0064 | C3 | MAIL_USER1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MAIL_USER1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0065 | C3 | MAIL_USER2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MAIL_USER2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0066 | C3 | MAIL_USER3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MAIL_USER3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0067 | C3 | MAIL_USER4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MAIL_USER4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0068 | C3 | MAIL_USER5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MAIL_USER5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0069 | C3 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SSP0014_ShipmentModelPIC.FindData_Ma) |
| WK-SSP0014-0070 | C3 | PART_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PART_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0071 | C3 | TEAM_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TEAM_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0072 | C3 | USER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — USER_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0073 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-001) |
| WK-SSP0014-0074 | G3 | SSP0014 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0014 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (D00-1-003 COMMON:UC-02 COMMON:UC-04 COMM) |
| WK-SSP0014-0075 | K-SA | SSP0014 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0014 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 3 (D00-1-003 COMMON:UC-02 A-3) |
| WK-SSP0014-0076 | K4 | SSP0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0014 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 17 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SSP0014-0077 | F1 | SSP0014 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0014 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 107 (CRUD:SAVE CRUD:DELETE COMMON:UC-04 Progr) |
| WK-SSP0014-0078 | F5 | SSP0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0014 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (CRUD:DELETE) |
| WK-SSP0014-0079 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0080 | F4 | PKG_SSP0014.P_SSP0014_GET_USER_ID_CHECK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0014.P_SSP0014_GET_USER_ID_CHECK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 100 (ACT:SSP0014_ShipmentModelPIC.GetUserIDCh) |
| WK-SSP0014-0081 | F4 | SSP0014_GET_SHIPMENT_MODEL_PIC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0014_GET_SHIPMENT_MODEL_PIC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 144 (ACT:SSP0014_ShipmentModelPIC.FindButton ) |
| WK-SSP0014-0082 | F4 | SSP0014_SAVE_SHIPMENT_MODEL_PIC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0014_SAVE_SHIPMENT_MODEL_PIC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tr |  | 99 (ACT:SSP0014_ShipmentModelPIC.SaveButton ) |
| WK-SSP0014-0083 | A5 | DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (3-7) |
| WK-SSP0014-0084 | A5 | MAIL_USER1 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MAIL_USER1 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0085 | A5 | MAIL_USER2 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MAIL_USER2 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0086 | A5 | MAIL_USER3 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MAIL_USER3 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0087 | A5 | MAIL_USER4 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MAIL_USER4 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0088 | A5 | MAIL_USER5 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MAIL_USER5 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0089 | A5 | OPERATION_GROUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SSP0014_ShipmentModelPIC.FindData_Ma) |
| WK-SSP0014-0090 | A5 | PART_LEADER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PART_LEADER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0091 | A5 | TEAM_LEADER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TEAM_LEADER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0092 | A5 | USER_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — USER_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 12 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0093 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-013 ACT:SSP0014_ShipmentModelPIC.I) |
| WK-SSP0014-0094 | G4 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-014 ACT:SSP0014_ShipmentModelPIC.I) |
| WK-SSP0014-0095 | G4 | cboValidYN / Valid / Valid YN / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValidYN / Valid / Valid YN / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-016 ACT:SSP0014_ShipmentModelPIC.I) |
| WK-SSP0014-0096 | G4 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFromSite / From Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-015) |
| WK-SSP0014-0097 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-017) |
| WK-SSP0014-0098 | G4 | txtUser / User ID(Name) / User | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtUser / User ID(Name) / User · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-019) |
| WK-SSP0014-0099 | H2 | DIVISION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (3-7) |
| WK-SSP0014-0100 | H2 | MAIL_USER1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MAIL_USER1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0101 | H2 | MAIL_USER2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MAIL_USER2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0102 | H2 | MAIL_USER3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MAIL_USER3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0103 | H2 | MAIL_USER4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MAIL_USER4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0104 | H2 | MAIL_USER5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MAIL_USER5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0105 | H2 | PART_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PART_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0106 | H2 | TEAM_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TEAM_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0107 | H2 | USER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — USER_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0108 | H4 | SSP0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0014 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 6 (4 13-14 ACT:SSP0014_ShipmentModelPIC.Spd) |
| WK-SSP0014-0109 | H5 | DIVISION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (3-7) |
| WK-SSP0014-0110 | H5 | MAIL_USER1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MAIL_USER1 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0111 | H5 | MAIL_USER2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MAIL_USER2 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0112 | H5 | MAIL_USER3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MAIL_USER3 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0113 | H5 | MAIL_USER4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MAIL_USER4 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0114 | H5 | MAIL_USER5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MAIL_USER5 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0115 | H5 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPERATION_GROUP · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SSP0014_ShipmentModelPIC.FindData_Ma) |
| WK-SSP0014-0116 | H5 | PART_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PART_LEADER · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0117 | H5 | TEAM_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TEAM_LEADER · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0118 | H5 | USER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — USER_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0119 | I1 | SSP0014 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0014 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 8 (COMMON:UC-02 COMMON:UC-04 3 + A-5 ACT:SS) |
| WK-SSP0014-0120 | SC1 | SSP0014 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0014 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 10 (D00-1-001 D00-1-003 D00-1-013 D00-1-014 ) |
| WK-SSP0014-0121 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-007 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0122 | D1 | DIVISION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (D00-3-003 3-7 ACT:SSP0014_ShipmentModelP) |
| WK-SSP0014-0123 | D1 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (D00-3-003) |
| WK-SSP0014-0124 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (D00-3-003) |
| WK-SSP0014-0125 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-007 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0126 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-003 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0127 | D1 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (D00-3-003) |
| WK-SSP0014-0128 | D1 | PART_LEADER_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PART_LEADER_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-005 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0129 | D1 | TEAM_LEADER_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TEAM_LEADER_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-006 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0130 | D1 | USER_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — USER_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-004 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0131 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-007 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0132 | D3 | DIVISION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (D00-3-003 3-7 ACT:SSP0014_ShipmentModelP) |
| WK-SSP0014-0133 | D3 | FROM_SITE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FROM_SITE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (D00-3-003) |
| WK-SSP0014-0134 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (D00-3-003) |
| WK-SSP0014-0135 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-007 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0136 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-003 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0137 | D3 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (D00-3-003) |
| WK-SSP0014-0138 | D3 | PART_LEADER_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PART_LEADER_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-005 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0139 | D3 | TEAM_LEADER_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TEAM_LEADER_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-006 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0140 | D3 | USER_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — USER_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-004 ACT:SSP0014_ShipmentModelPIC.E) |
| WK-SSP0014-0141 | D4 | MAIL_USER1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — MAIL_USER1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-018) |
| WK-SSP0014-0142 | D4 | MAIL_USER2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — MAIL_USER2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-019) |
| WK-SSP0014-0143 | D4 | MAIL_USER3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — MAIL_USER3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-020) |
| WK-SSP0014-0144 | D4 | MAIL_USER4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — MAIL_USER4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-021) |
| WK-SSP0014-0145 | D4 | MAIL_USER5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — MAIL_USER5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-022) |
| WK-SSP0014-0146 | D4 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 3 (D00-3-011 10-12 Operation Group) |
| WK-SSP0014-0147 | D4 | PART_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PART_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-016) |
| WK-SSP0014-0148 | D4 | TEAM_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — TEAM_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-017) |
| WK-SSP0014-0149 | D4 | USER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — USER_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (D00-3-015 15-22) |
| WK-SSP0014-0150 | D5 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0151 | D5 | MAIL_USER1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MAIL_USER1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0152 | D5 | MAIL_USER2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MAIL_USER2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0153 | D5 | MAIL_USER3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MAIL_USER3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0154 | D5 | MAIL_USER4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MAIL_USER4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0155 | D5 | MAIL_USER5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MAIL_USER5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0156 | D5 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0157 | D5 | PART_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PART_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0158 | D5 | TEAM_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TEAM_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0159 | D5 | USER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — USER_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0160 | D5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0161 | D6 | SSP0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0014 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (CRUD:INSERT Operation Group) |
| WK-SSP0014-0162 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SSP0014-0163 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0014_ShipmentModelPIC.SaveData:52) |
| WK-SSP0014-0164 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SSP0014-0165 | E4 | MSG00251 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00251 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (3 ACT:SSP0014_ShipmentModelPIC.GetUserID) |
| WK-SSP0014-0166 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0014_ShipmentModelPIC.SaveData:54) |
| WK-SSP0014-0167 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (A-5) |
| WK-SSP0014-0168 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (+) |
| WK-SSP0014-0169 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-04) |
| WK-SSP0014-0170 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0171 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0172 | E4 | MSG01261 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01261 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (3) |
| WK-SSP0014-0173 | E4 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0014_ShipmentModelPIC.SetChangeCo) |
| WK-SSP0014-0174 | E4 | USER_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — USER_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (A-5 ACT:SSP0014_ShipmentModelPIC.SetChan) |
| WK-SSP0014-0175 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SSP0014_ShipmentModelPIC.SetChangedC) |
| WK-SSP0014-0176 | E4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 2 (ACT:SSP0014_ShipmentModelPIC.SetChangedC) |
| WK-SSP0014-0177 | A10 | SSP0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0014 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 46 (ACT:SSP0014_ShipmentModelPIC.DefinePrope) |
| WK-SSP0014-0178 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0179 | A6 | SSP0014_GET_SHIPMENT_MODEL_PIC | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SSP0014_GET_SHIPMENT_MODEL_PIC · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.s |  | 46 (ACT:SSP0014_ShipmentModelPIC.FindButton ) |
| WK-SSP0014-0180 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-013 D00-2-001 ACT:SSP0014_Shipment) |
| WK-SSP0014-0181 | G1 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-014 ACT:SSP0014_ShipmentModelPIC.F) |
| WK-SSP0014-0182 | G1 | cboValidYN / Valid / Valid YN / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValidYN / Valid / Valid YN / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-016 ACT:SSP0014_ShipmentModelPIC.F) |
| WK-SSP0014-0183 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-015 ACT:SSP0014_ShipmentModelPIC.F) |
| WK-SSP0014-0184 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-017 ACT:SSP0014_ShipmentModelPIC.F) |
| WK-SSP0014-0185 | G1 | txtUser / User ID(Name) / User | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtUser / User ID(Name) / User · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-019 ACT:SSP0014_ShipmentModelPIC.F) |
| WK-SSP0014-0186 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-013 ACT:SSP0014_ShipmentModelPIC.I) |
| WK-SSP0014-0187 | G6 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-014 ACT:SSP0014_ShipmentModelPIC.I) |
| WK-SSP0014-0188 | G6 | cboValidYN / Valid / Valid YN / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValidYN / Valid / Valid YN / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-016 ACT:SSP0014_ShipmentModelPIC.I) |
| WK-SSP0014-0189 | G6 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-015) |
| WK-SSP0014-0190 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-017) |
| WK-SSP0014-0191 | G6 | txtUser / User ID(Name) / User | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtUser / User ID(Name) / User · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-019) |
| WK-SSP0014-0192 | X-REOPEN | SSP0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0014 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SSP0014_ShipmentModelPIC.Dispose ACT) |
| WK-SSP0014-0193 | H6 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbFromSite / From Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0194 | M4 | MAIL_USER1 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MAIL_USER1 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 14 (D00-3-018 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0195 | M4 | MAIL_USER2 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MAIL_USER2 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 14 (D00-3-019 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0196 | M4 | MAIL_USER3 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MAIL_USER3 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 14 (D00-3-020 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0197 | M4 | MAIL_USER4 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MAIL_USER4 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 14 (D00-3-021 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0198 | M4 | MAIL_USER5 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MAIL_USER5 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 13 (D00-3-022 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0199 | M4 | PART_LEADER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PART_LEADER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 14 (D00-3-016 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0200 | M4 | TEAM_LEADER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TEAM_LEADER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 14 (D00-3-017 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0201 | M4 | USER_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — USER_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 16 (D00-3-015 15-22 UserInfoPopup(USER_ID/PA) |
| WK-SSP0014-0202 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-2-002) |
| WK-SSP0014-0203 | M4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (SCM0002_ItembyDivisionPopup) |

## W7 기대값 확정 (161)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0204 | C3 | SSP0014_ShipmentModelPIC.CboDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0014_ShipmentModelPIC.CboDivision_SelectedIndex: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0014_ShipmentModelPIC.CboDivision) |
| WK-SSP0014-0205 | C3 | SSP0014_ShipmentModelPIC.SetChangeContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0014_ShipmentModelPIC.SetChangeControl: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0014_ShipmentModelPIC.SetChangeCo) |
| WK-SSP0014-0206 | C3 | SSP0014_ShipmentModelPIC.SetChangedContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0014_ShipmentModelPIC.SetChangedControl: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0014-0207 | B3 | SSP0014_ShipmentModelPIC.GetUserIDChk | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0014_ShipmentModelPIC.GetUserIDChk: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0014_ShipmentModelPIC.GetUserIDCh) |
| WK-SSP0014-0208 | B3 | Valid | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — Valid: 행 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 1 (Valid) |
| WK-SSP0014-0209 | B4 | SSP0014_ShipmentModelPIC.GetUserIDChk | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0014_ShipmentModelPIC.GetUserIDChk: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0014_ShipmentModelPIC.GetUserIDCh) |
| WK-SSP0014-0210 | B4 | Valid | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — Valid: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (Valid) |
| WK-SSP0014-0211 | DB-SYN | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — ProgressForm(FindData/SaveData): 행 집계 — DB-SYN 4요소: PASS:2 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0212 | F4 | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — ProgressForm(FindData/SaveData): 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0213 | A5 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 1: 행 집계 — A5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0014-0214 | A5 | 13-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 13-14: 행 집계 — A5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (13-14) |
| WK-SSP0014-0215 | A5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 4: 행 집계 — A5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SSP0014-0216 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0217 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0014-0218 | A5 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-003: 행 집계 — A5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-SSP0014-0219 | A5 | D00-1-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-009: 행 집계 — A5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-009) |
| WK-SSP0014-0220 | A5 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-020: 행 집계 — A5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-020) |
| WK-SSP0014-0221 | A5 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-021: 행 집계 — A5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-021) |
| WK-SSP0014-0222 | A5 | SSP0014_ShipmentModelPIC.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0014_ShipmentModelPIC.CreateSpread: 진입점 집계 — A5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0014_ShipmentModelPIC.CreateSprea) |
| WK-SSP0014-0223 | G4 | + | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — +: 행 집계 — G4 7요소: NOT_RUN:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (+) |
| WK-SSP0014-0224 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 7요소: NOT_RUN:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0014-0225 | G4 | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-001: 행 집계 — G4 7요소: NOT_RUN:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-001) |
| WK-SSP0014-0226 | G4 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-003: 행 집계 — G4 7요소: NOT_RUN:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-SSP0014-0227 | H2 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 1: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0014-0228 | H2 | 13-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 13-14: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (13-14) |
| WK-SSP0014-0229 | H2 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 4: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SSP0014-0230 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0231 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0014-0232 | H2 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-020: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-020) |
| WK-SSP0014-0233 | H2 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-021: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-021) |
| WK-SSP0014-0234 | H2 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0014-0235 | H2 | SSP0014_ShipmentModelPIC.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0014_ShipmentModelPIC.CreateSpread: 진입점 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0014_ShipmentModelPIC.CreateSprea) |
| WK-SSP0014-0236 | H5 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 1: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0014-0237 | H5 | 13-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 13-14: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (13-14) |
| WK-SSP0014-0238 | H5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 4: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SSP0014-0239 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0240 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0014-0241 | H5 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-020: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-020) |
| WK-SSP0014-0242 | H5 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-021: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-021) |
| WK-SSP0014-0243 | H5 | SSP0014_ShipmentModelPIC.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0014_ShipmentModelPIC.CreateSpread: 진입점 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0014_ShipmentModelPIC.CreateSprea) |
| WK-SSP0014-0244 | X-REASON | D00-1-022 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-022 §1 usrButton1 / UsrButton(ButtonAccessType=None, 미배치) — AS-IS 렌더 안 함(미배치 헬퍼 버튼). TO-BE 대상 아님(00 §1 근거 |  | 1 (D00-1-022) |
| WK-SSP0014-0245 | X-REASON | D00-2-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-004 §2 spdMain / TopChange(스크롤 재병합) components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 스크롤 병합 관장) 스 |  | 1 (D00-2-004) |
| WK-SSP0014-0246 | X-REASON | D00-3-001 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-001 §3 SmartColMerge / 223 (InitSpread 초기병합) components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 병합) |  | 1 (D00-3-001) |
| WK-SSP0014-0247 | X-REASON | D00-3-009 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-009 §3 LockColumn / 348 ((0,max) 조회=전체 lock 뷰) 제외 — Edit 토글 제거로 조회 후 뷰 lock 없음. lock 은 컬럼메타(13열 'S')로만 유지 |  | 1 (D00-3-009) |
| WK-SSP0014-0248 | X-REASON | D00-3-013 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-013 §3 SmartColMerge / 364 (조회 후 병합) components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 병합) 조회 후 병합 |  | 1 (D00-3-013) |
| WK-SSP0014-0249 | X-REASON | D00-3-014 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-014 §3 SmartColMerge / 622 (TopChange 재병합) components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 병합) 스 |  | 1 (D00-3-014) |
| WK-SSP0014-0250 | D1 | B-1~B-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — B-1~B-7: 행 집계 — D1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (B-1~B-7) |
| WK-SSP0014-0251 | D1 | SSP0014_ShipmentModelPIC.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSP0014_ShipmentModelPIC.EditButton: 진입점 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0014_ShipmentModelPIC.EditButton:) |
| WK-SSP0014-0252 | D3 | B-1~B-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — B-1~B-7: 행 집계 — D3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (B-1~B-7) |
| WK-SSP0014-0253 | D3 | SSP0014_ShipmentModelPIC.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSP0014_ShipmentModelPIC.EditButton: 진입점 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0014_ShipmentModelPIC.EditButton:) |
| WK-SSP0014-0254 | D4 | CRUD:INSERT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CRUD:INSERT: 행 집계 — D4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:INSERT) |
| WK-SSP0014-0255 | D5 | SSP0014_ShipmentModelPIC.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0014_ShipmentModelPIC.CreateSpread: 진입점 집계 — D5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0014_ShipmentModelPIC.CreateSprea) |
| WK-SSP0014-0256 | E4 | A-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — A-1: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (A-1) |
| WK-SSP0014-0257 | E4 | SSP0014_ShipmentModelPIC.SetChangeContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0014_ShipmentModelPIC.SetChangeControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0014_ShipmentModelPIC.SetChangeCo) |
| WK-SSP0014-0258 | E4 | SSP0014_ShipmentModelPIC.SetChangedContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0014_ShipmentModelPIC.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0014-0259 | A1 | + | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — +: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (+) |
| WK-SSP0014-0260 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 3요소: REVIEW:3 |  | 0 () |
| WK-SSP0014-0261 | A1 | 13-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 13-14: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (13-14) |
| WK-SSP0014-0262 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 3요소: REVIEW:3 |  | 0 () |
| WK-SSP0014-0263 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (3) |
| WK-SSP0014-0264 | A1 | A-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-1: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (A-1) |
| WK-SSP0014-0265 | A1 | A-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-3: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (A-3) |
| WK-SSP0014-0266 | A1 | B-1~B-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B-1~B-7: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (B-1~B-7) |
| WK-SSP0014-0267 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0268 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-07) |
| WK-SSP0014-0269 | A1 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:SEARCH) |
| WK-SSP0014-0270 | A1 | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-018: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-018) |
| WK-SSP0014-0271 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-2-001) |
| WK-SSP0014-0272 | A1 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-002: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-2-002) |
| WK-SSP0014-0273 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0274 | A1 | P_ITEM_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_ITEM_ID: 골든 비교 케이스 없음(P_ITEM_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0014-0275 | A1 | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ProgressForm(FindData/SaveData): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0276 | A1 | SSP0014_GET_SHIPMENT_MODEL_PIC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0014_GET_SHIPMENT_MODEL_PIC: 골든 비교 케이스 없음(SSP0014_GET_SHIPMENT_MODEL_PIC — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미 |  | 46 (ACT:SSP0014_ShipmentModelPIC.FindButton ) |
| WK-SSP0014-0277 | A6 | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — ProgressForm(FindData/SaveData): 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0278 | G1 | + | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — +: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (+) |
| WK-SSP0014-0279 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0014-0280 | G1 | 13-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 13-14: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (13-14) |
| WK-SSP0014-0281 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0014-0282 | G1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 3: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SSP0014-0283 | G1 | A-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — A-1: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (A-1) |
| WK-SSP0014-0284 | G1 | A-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — A-3: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (A-3) |
| WK-SSP0014-0285 | G1 | B-1~B-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — B-1~B-7: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (B-1~B-7) |
| WK-SSP0014-0286 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0287 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0014-0288 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0014-0289 | G1 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:SEARCH: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SEARCH) |
| WK-SSP0014-0290 | G1 | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-001: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-001) |
| WK-SSP0014-0291 | G1 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-003: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-SSP0014-0292 | G1 | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-018: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-018) |
| WK-SSP0014-0293 | G1 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-002: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SSP0014-0294 | G6 | + | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — +: 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (+) |
| WK-SSP0014-0295 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0014-0296 | G6 | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-001: 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-001) |
| WK-SSP0014-0297 | G6 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-003: 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-SSP0014-0298 | X-LOC | + | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — +: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (+) |
| WK-SSP0014-0299 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SSP0014-0300 | X-LOC | 10-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10-12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10-12) |
| WK-SSP0014-0301 | X-LOC | 13-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13-14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13-14) |
| WK-SSP0014-0302 | X-LOC | 15-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 15-22: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (15-22) |
| WK-SSP0014-0303 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-SSP0014-0304 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SSP0014-0305 | X-LOC | 3-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3-7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3-7) |
| WK-SSP0014-0306 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SSP0014-0307 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SSP0014-0308 | X-LOC | A-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — A-1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (A-1) |
| WK-SSP0014-0309 | X-LOC | A-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — A-3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (A-3) |
| WK-SSP0014-0310 | X-LOC | A-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — A-5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (A-5) |
| WK-SSP0014-0311 | X-LOC | B-1~B-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — B-1~B-7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (B-1~B-7) |
| WK-SSP0014-0312 | X-LOC | Division* | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division*: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division*) |
| WK-SSP0014-0313 | X-LOC | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — From Site: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (From Site) |
| WK-SSP0014-0314 | X-LOC | Operation Group | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Operation Group: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Operation Group) |
| WK-SSP0014-0315 | X-LOC | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ProgressForm(FindData/SaveData): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0316 | X-LOC | SCM0002_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM0002_ItembyDivisionPopup: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0317 | X-LOC | UserInfoPopup(USER_ID/PART/TEAM/MAIL1~5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — UserInfoPopup(USER_ID/PART/TEAM/MAIL1~5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (UserInfoPopup(USER_ID/PART/TEAM/MAIL1~5)) |
| WK-SSP0014-0318 | X-LOC | Valid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Valid: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Valid) |
| WK-SSP0014-0319 | X-ROW | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 8: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (8) |
| WK-SSP0014-0320 | X-ROW | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-002) |
| WK-SSP0014-0321 | X-ROW | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-004) |
| WK-SSP0014-0322 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SSP0014-0323 | X-ROW | D00-1-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-006) |
| WK-SSP0014-0324 | X-ROW | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-007) |
| WK-SSP0014-0325 | X-ROW | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-008) |
| WK-SSP0014-0326 | X-ROW | D00-1-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-010) |
| WK-SSP0014-0327 | X-ROW | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-008) |
| WK-SSP0014-0328 | X-ROW | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-010) |
| WK-SSP0014-0329 | X-ROW | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-012: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-012) |
| WK-SSP0014-0330 | X-ROW | Division* | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Division*: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Division*) |
| WK-SSP0014-0331 | X-ROW | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — From Site: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (From Site) |
| WK-SSP0014-0332 | X-ROW | SSP0014_ShipmentModelPIC.CboDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.CboDivision_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0014_ShipmentModelPIC.CboDivision) |
| WK-SSP0014-0333 | X-ROW | SSP0014_ShipmentModelPIC.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0014_ShipmentModelPIC.CreateSprea) |
| WK-SSP0014-0334 | X-ROW | SSP0014_ShipmentModelPIC.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0014_ShipmentModelPIC.DefinePrope) |
| WK-SSP0014-0335 | X-ROW | SSP0014_ShipmentModelPIC.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SSP0014_ShipmentModelPIC.FindButton) |
| WK-SSP0014-0336 | X-ROW | SSP0014_ShipmentModelPIC.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.FindData_Main: 진입점 집계 14검사 — NOT_RUN:12 · REVIEW:1 · NOPATH:1 |  | 8 (ACT:SSP0014_ShipmentModelPIC.FindData_Ma) |
| WK-SSP0014-0337 | X-ROW | SSP0014_ShipmentModelPIC.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0014_ShipmentModelPIC.Form_Load) |
| WK-SSP0014-0338 | X-ROW | SSP0014_ShipmentModelPIC.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.InitControls: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0014_ShipmentModelPIC.InitControl) |
| WK-SSP0014-0339 | X-ROW | SSP0014_ShipmentModelPIC.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.InitSpread: 진입점 집계 41검사 — NOT_RUN:41 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0340 | X-ROW | SSP0014_ShipmentModelPIC.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.SaveData: 진입점 집계 13검사 — NOT_RUN:8 · NOPATH:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0014_ShipmentModelPIC.SaveData:38) |
| WK-SSP0014-0341 | X-ROW | SSP0014_ShipmentModelPIC.SetChangeContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.SetChangeControl: 진입점 집계 8검사 — NOT_RUN:4 · REVIEW:2 · NOPATH:1 · TODO:1 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SetChangeCo) |
| WK-SSP0014-0342 | X-ROW | SSP0014_ShipmentModelPIC.SetChangedContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.SetChangedControl: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0014_ShipmentModelPIC.SetChangedC) |
| WK-SSP0014-0343 | X-ROW | SSP0014_ShipmentModelPIC.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.SetImageCell: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0014_ShipmentModelPIC.SetImageCel) |
| WK-SSP0014-0344 | X-ROW | SSP0014_ShipmentModelPIC.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.SpdMain_CellDoubleClick: 진입점 집계 43검사 — NOT_RUN:24 · NOPATH:16 · REVIEW:3 |  | 56 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0345 | X-ROW | SSP0014_ShipmentModelPIC.SpdMain_TopChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Top) |
| WK-SSP0014-0346 | X-ROW | SSP0014_ShipmentModelPIC.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0014_ShipmentModelPIC.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0014_ShipmentModelPIC.btnItemId_C) |
| WK-SSP0014-0347 | G5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 3: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0014-0348 | G5 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2-003: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-003) |
| WK-SSP0014-0349 | G5 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0014-0350 | G5 | MODAL:SsoUserModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:SsoUserModal: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:SsoUserModal) |
| WK-SSP0014-0351 | G5 | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ProgressForm(FindData/SaveData): 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0352 | G5 | SSP0014_ShipmentModelPIC.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SSP0014_ShipmentModelPIC.SpdMain_CellDoubleClick: 진입점 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0353 | H6 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 3: 행 집계 — H6 10요소: NOPATH:9 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0014-0354 | H6 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2-003: 행 집계 — H6 10요소: NOPATH:9 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-003) |
| WK-SSP0014-0355 | H6 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — H6 10요소: NOPATH:9 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0014-0356 | H6 | MODAL:SsoUserModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:SsoUserModal: 행 집계 — H6 10요소: NOPATH:9 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:SsoUserModal) |
| WK-SSP0014-0357 | H6 | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ProgressForm(FindData/SaveData): 행 집계 — H6 10요소: NOPATH:9 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0358 | H6 | SSP0014_ShipmentModelPIC.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SSP0014_ShipmentModelPIC.SpdMain_CellDoubleClick: 진입점 집계 — H6 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0359 | M4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 3: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0014-0360 | M4 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2-003: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-003) |
| WK-SSP0014-0361 | M4 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0014-0362 | M4 | MODAL:SsoUserModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:SsoUserModal: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:SsoUserModal) |
| WK-SSP0014-0363 | M4 | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ProgressForm(FindData/SaveData): 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0364 | M4 | SSP0014_ShipmentModelPIC.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0014_ShipmentModelPIC.SpdMain_CellDoubleClick: 진입점 집계 — M4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
