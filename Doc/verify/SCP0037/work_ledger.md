# 작업 원장 — SCP0037 · 2026-10-26 12:53

> 검사 인스턴스 270건 중 PASS·NA 14건 외 **256건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 17 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W5 | 검사기 연결 | 22 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 106 | 실행 → PASS |
| W7 | 기대값 확정 | 110 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 110 · E2E 106 · 하네스 22 · 대조표 17 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 17 |  |  |  |  | 11 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 24 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 14 | 6 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  | 7 | 7 |  |  | 연쇄 자동 채움 |
| D1 | EDIT |  |  |  |  |  | 10 | 3 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 10 | 3 |  |  | 행 값 기반 조건부 잠금 |
| G1 | GEN |  |  |  |  |  | 5 | 8 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A5 | DESIGN |  |  |  |  |  | 3 | 7 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 2 | 7 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 2 | 7 |  |  | 라벨 명칭 |
| E1 | EDIT |  |  |  |  |  | 6 | 3 |  |  | 숫자 소수자리·정수·부호·범위 |
| A1 | GEN |  |  |  |  |  |  | 9 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C2 | CASCADE |  |  |  |  |  | 6 | 2 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 6 | 2 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| D5 | EDIT |  |  |  |  |  | 5 | 2 |  |  | 셀 에디터 유형 |
| G4 | DESIGN |  |  |  |  | 1 | 3 | 1 |  |  | 조회조건 표시·라벨·활성 |
| D4 | EDIT |  |  |  |  |  | 2 | 3 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| B1 | COMBO |  |  |  |  | 3 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 3 |  | 1 |  |  | 콤보 후보 중복 없음 |
| B4 | COMBO |  |  |  |  | 3 |  | 1 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| E5 | EDIT |  |  |  |  | 3 |  | 1 |  |  | 콤보 셀 후보 외 값 차단 |
| C1 | CASCADE |  |  |  |  |  | 4 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G6 | GEN |  |  |  |  |  | 3 | 1 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| G5 | POPUP |  |  |  |  | 3 |  |  |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 3 |  |  |  |  | 팝업 표준·열림 |
| C4 | CASCADE |  |  |  |  |  | 2 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| F4 | DB |  |  |  |  |  | 2 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| M4 | POPUP |  |  |  |  |  | 2 |  |  |  | 팝업 선택값 반영 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | GEN |  |  |  |  |  | 1 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (17)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0001 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-SCP0037-0002 | X-LOC | 10,6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (10,6) |
| WK-SCP0037-0003 | X-LOC | 11,21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (11,21) |
| WK-SCP0037-0004 | X-LOC | 12,13,14,15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (12,13,14,15) |
| WK-SCP0037-0005 | X-LOC | 16,17,18,19,43,44,45,35 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0006 | X-LOC | 2,7,41,42 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2,7,41,42) |
| WK-SCP0037-0007 | X-LOC | 20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (20) |
| WK-SCP0037-0008 | X-LOC | 22,23 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (22,23) |
| WK-SCP0037-0009 | X-LOC | 24,25,26,27 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (24,25,26,27) |
| WK-SCP0037-0010 | X-LOC | 28,29,30 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (28,29,30) |
| WK-SCP0037-0011 | X-LOC | 3,9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3,9) |
| WK-SCP0037-0012 | X-LOC | 31~40 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (31~40) |
| WK-SCP0037-0013 | X-LOC | 4,5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (4,5) |
| WK-SCP0037-0014 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-SCP0037-0015 | X-LOC | COMMON:UC-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: gridAction.ts 없음 |  | 1 (COMMON:UC-01) |
| WK-SCP0037-0016 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: DataGrid.tsx 없음 |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0017 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: gridAction.ts 없음 |  | 1 (COMMON:UC-07) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0018 | H10 | SCP0037 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0037 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: components/OperationLTGrid.tsx, hooks/useOperationLTValidation.ts |  | 7 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |

## W5 검사기 연결 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0019 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0020 | B1 | LT_OPERATION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL LT_OPERATION | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0021 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 7 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0022 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0023 | B2 | LT_OPERATION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL LT_OPERATION | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0024 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 7 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0025 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0026 | B4 | LT_OPERATION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LT_OPERATION | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0027 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 7 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0028 | F2 | SCP0037 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0037 화면 | 판단불가(대상 단위 SCREEN) | 66 (ACT:SCP0037_OperationLT.SaveButton ACT:S) |
| WK-SCP0037-0029 | F6 | SCP0037 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0037 화면 | 판단불가(대상 단위 SCREEN) | 66 (ACT:SCP0037_OperationLT.SaveButton ACT:S) |
| WK-SCP0037-0030 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SCP0037_OperationLT.InitEvent ACT:SC) |
| WK-SCP0037-0031 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0032 | E5 | LT_OPERATION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL LT_OPERATION | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0033 | E5 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0034 | G03-WIRE | SCP0037 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0037 화면 | 판단불가(대상 단위 SCREEN) | 11 (ACT:SCP0037_OperationLT..ctor ACT:SCP003) |
| WK-SCP0037-0035 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 3 (4 11 22,23) |
| WK-SCP0037-0036 | G5 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (22,23) |
| WK-SCP0037-0037 | G5 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0038 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 3 (4 11 22,23) |
| WK-SCP0037-0039 | H6 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (22,23) |
| WK-SCP0037-0040 | H6 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |

## W6 검증 실행 (106)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0041 | J2 | SCP0037 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0037 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 29 (4 7 8 10 13 3,9 4,5 12,13,14,15 10,6 16,) |
| WK-SCP0037-0042 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (2 ACT:SCP0037_OperationLT.InitControls:1) |
| WK-SCP0037-0043 | C1 | cboLTOperation / LT Operation / LTOperat | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboLTOperation / LT Operation / LTOperation / Oper · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (3 ACT:SCP0037_OperationLT.InitControls:1) |
| WK-SCP0037-0044 | C1 | cboValid / Site Item Valid / Valid / Act | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Site Item Valid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0037_OperationLT.InitControls:178) |
| WK-SCP0037-0045 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 5 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0046 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0047 | C2 | INV_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — INV_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0048 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0049 | C2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0050 | C2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (6 ACT:SCP0037_OperationLT.SpdMain_ComboS) |
| WK-SCP0037-0051 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (6 9 ACT:SCP0037_OperationLT.SpdMain_Comb) |
| WK-SCP0037-0052 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 49 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0053 | C3 | INV_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — INV_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0054 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0055 | C3 | LT_OPERATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LT_OPERATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0056 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0057 | C3 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (6 31~40 ACT:SCP0037_OperationLT.SpdMain_) |
| WK-SCP0037-0058 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 25 (6 9 31~40 ACT:SCP0037_OperationLT.SpdMai) |
| WK-SCP0037-0059 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (2) |
| WK-SCP0037-0060 | C4 | cboLTOperation / LT Operation / LTOperat | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboLTOperation / LT Operation / LTOperation / Oper · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (3) |
| WK-SCP0037-0061 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0062 | C6 | INV_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — INV_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0063 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0064 | C6 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0065 | C6 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (6 ACT:SCP0037_OperationLT.SpdMain_ComboS) |
| WK-SCP0037-0066 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (6 9 ACT:SCP0037_OperationLT.SpdMain_Comb) |
| WK-SCP0037-0067 | G3 | SCP0037 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0037 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0037-0068 | K4 | SCP0037 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0037 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 20 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0037-0069 | F1 | SCP0037 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0037 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 76 (10,6 ACT:SCP0037_OperationLT.DeleteButto) |
| WK-SCP0037-0070 | F3 | SCP0037 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0037 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 37 (5 12 13 31~40 ACT:SCP0037_OperationLT.Sp) |
| WK-SCP0037-0071 | F5 | SCP0037 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0037 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 10 (10,6 ACT:SCP0037_OperationLT.DeleteButto) |
| WK-SCP0037-0072 | F4 | PKG_SCP0037.P_SCP0037_GET_OPERATION_LT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0037.P_SCP0037_GET_OPERATION_LT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 101 (ACT:SCP0037_OperationLT.FindButton ACT:S) |
| WK-SCP0037-0073 | F4 | PKG_SCP0037.P_SCP0037_SAVE_OPERATION_LT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0037.P_SCP0037_SAVE_OPERATION_LT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 66 (ACT:SCP0037_OperationLT.SaveButton ACT:S) |
| WK-SCP0037-0074 | A5 | INV_FLAG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — INV_FLAG · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0075 | A5 | LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0076 | A5 | SCM_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0077 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0037_OperationLT.InitControls ACT) |
| WK-SCP0037-0078 | G4 | cboLTOperation / LT Operation / LTOperat | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboLTOperation / LT Operation / LTOperation / Oper · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0037_OperationLT.InitControls ACT) |
| WK-SCP0037-0079 | G4 | cboValid / Site Item Valid / Valid / Act | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Site Item Valid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0037_OperationLT.InitControls ACT) |
| WK-SCP0037-0080 | H2 | INV_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — INV_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0081 | H2 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0082 | H5 | INV_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — INV_FLAG · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0083 | H5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0084 | I1 | SCP0037 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0037 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 8 (COMMON:UC-02 ACT:SCP0037_OperationLT.Sav) |
| WK-SCP0037-0085 | SC1 | SCP0037 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0037 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 1 (COMMON:UC-06) |
| WK-SCP0037-0086 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (4,5 16,17,18,19,43,44,45,35 20 24,25,26,) |
| WK-SCP0037-0087 | D1 | INV_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — INV_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (4,5 12,13,14,15) |
| WK-SCP0037-0088 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (4 7 10 12,13,14,15) |
| WK-SCP0037-0089 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.EditButton:281:4) |
| WK-SCP0037-0090 | D1 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (4,5 12,13,14,15) |
| WK-SCP0037-0091 | D1 | LT_OPERATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LT_OPERATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (4,5 16,17,18,19,43,44,45,35 ACT:SCP0037_) |
| WK-SCP0037-0092 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0037_OperationLT.InsertRow:405:13) |
| WK-SCP0037-0093 | D1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0037_OperationLT.InsertRow:404:12) |
| WK-SCP0037-0094 | D1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (12,13,14,15 16,17,18,19,43,44,45,35) |
| WK-SCP0037-0095 | D1 | SITE_ITEM_VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SITE_ITEM_VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (4,5 ACT:SCP0037_OperationLT.EditButton A) |
| WK-SCP0037-0096 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (4,5 16,17,18,19,43,44,45,35 20 24,25,26,) |
| WK-SCP0037-0097 | D3 | INV_FLAG | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — INV_FLAG · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (4,5 12,13,14,15) |
| WK-SCP0037-0098 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (4 7 10 12,13,14,15) |
| WK-SCP0037-0099 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.EditButton:281:4) |
| WK-SCP0037-0100 | D3 | LT_DAY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LT_DAY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (4,5 12,13,14,15) |
| WK-SCP0037-0101 | D3 | LT_OPERATION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LT_OPERATION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (4,5 16,17,18,19,43,44,45,35 ACT:SCP0037_) |
| WK-SCP0037-0102 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0037_OperationLT.InsertRow:405:13) |
| WK-SCP0037-0103 | D3 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0037_OperationLT.InsertRow:404:12) |
| WK-SCP0037-0104 | D3 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (12,13,14,15 16,17,18,19,43,44,45,35) |
| WK-SCP0037-0105 | D3 | SITE_ITEM_VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SITE_ITEM_VALID_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (4,5 ACT:SCP0037_OperationLT.EditButton A) |
| WK-SCP0037-0106 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (11,21) |
| WK-SCP0037-0107 | D4 | LT_OPERATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — LT_OPERATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (11,21) |
| WK-SCP0037-0108 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0109 | D5 | INV_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — INV_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0110 | D5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0111 | D5 | LT_OPERATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_OPERATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0112 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 7 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0113 | D6 | SCP0037 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0037 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 5 (10,6 COMMON:UC-01 COMMON:UC-03 ACT:SCP00) |
| WK-SCP0037-0114 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 23 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0115 | E1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0116 | E1 | LT_OPERATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — LT_OPERATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0117 | E1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0118 | E1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 8 (31~40 ACT:SCP0037_OperationLT.SpdMain_Cl) |
| WK-SCP0037-0119 | E1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 14 (31~40 ACT:SCP0037_OperationLT.SpdMain_Cl) |
| WK-SCP0037-0120 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 14 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0121 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0037-0122 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0037_OperationLT.SaveData:506:56) |
| WK-SCP0037-0123 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0037_OperationLT.SaveData:522:63) |
| WK-SCP0037-0124 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0037_OperationLT.checkValidN1:970) |
| WK-SCP0037-0125 | E4 | MSG00093 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00093 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0126 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0037-0127 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0128 | E4 | MSG01092 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01092 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0037-0129 | E4 | MSG01122 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01122 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0037-0130 | E4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0131 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0132 | E4 | cboLTOperation / LT Operation / LTOperat | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboLTOperation / LT Operation / LTOperation / Oper · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 2 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0133 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 6 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0134 | A10 | SCP0037 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0037 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 59 (ACT:SCP0037_OperationLT.DefineProperty A) |
| WK-SCP0037-0135 | A6 | PKG_SCP0037.P_SCP0037_GET_OPERATION_LT | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0037.P_SCP0037_GET_OPERATION_LT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 37 (ACT:SCP0037_OperationLT.FindButton ACT:S) |
| WK-SCP0037-0136 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0037_OperationLT.FindData ACT:SCP) |
| WK-SCP0037-0137 | G1 | cboLTOperation / LT Operation / LTOperat | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboLTOperation / LT Operation / LTOperation / Oper · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0037_OperationLT.FindData ACT:SCP) |
| WK-SCP0037-0138 | G1 | cboValid / Site Item Valid / Valid / Act | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Site Item Valid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0037_OperationLT.FindData ACT:SCP) |
| WK-SCP0037-0139 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0037_OperationLT.FindData ACT:SCP) |
| WK-SCP0037-0140 | G1 | txtItemId / Material / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Material / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0037_OperationLT.FindData ACT:SCP) |
| WK-SCP0037-0141 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0037_OperationLT.InitControls ACT) |
| WK-SCP0037-0142 | G6 | cboLTOperation / LT Operation / LTOperat | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboLTOperation / LT Operation / LTOperation / Oper · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0037_OperationLT.InitControls ACT) |
| WK-SCP0037-0143 | G6 | cboValid / Site Item Valid / Valid / Act | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Site Item Valid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0037_OperationLT.InitControls ACT) |
| WK-SCP0037-0144 | X-REOPEN | SCP0037 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0037 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:SCP0037_OperationLT.Dispose ACT:SCP0) |
| WK-SCP0037-0145 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (4 11 22,23) |
| WK-SCP0037-0146 | M4 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (22,23) |

## W7 기대값 확정 (110)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0147 | C2 | SCP0037_OperationLT.ClbDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0037_OperationLT.ClbDivision_SelectedIndexChang: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0148 | C2 | SCP0037_OperationLT.SpdMain_ComboSelChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0037_OperationLT.SpdMain_ComboSelChange: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0149 | C3 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 12: 행 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0037-0150 | C3 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 13: 행 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (13) |
| WK-SCP0037-0151 | C3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 5: 행 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0037-0152 | C3 | SCP0037_OperationLT.ClbDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0037_OperationLT.ClbDivision_SelectedIndexChang: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0153 | C3 | SCP0037_OperationLT.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0037_OperationLT.SetChangedControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0154 | C3 | SCP0037_OperationLT.SpdMain_ComboSelChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0037_OperationLT.SpdMain_ComboSelChange: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0155 | C3 | SCP0037_OperationLT.setScmSiteId | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0037_OperationLT.setScmSiteId: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SCP0037_OperationLT.setScmSiteId:869) |
| WK-SCP0037-0156 | C6 | SCP0037_OperationLT.ClbDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0037_OperationLT.ClbDivision_SelectedIndexChang: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0157 | C6 | SCP0037_OperationLT.SpdMain_ComboSelChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0037_OperationLT.SpdMain_ComboSelChange: 진입점 집계 — C6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0158 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0159 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0160 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0161 | A5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0037-0162 | A5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 8: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0037-0163 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0037-0164 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0165 | A5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-05: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0166 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0037-0167 | A5 | SCP0037_OperationLT.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0037_OperationLT.CreateSpread: 진입점 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0037_OperationLT.CreateSpread:230) |
| WK-SCP0037-0168 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0037-0169 | H2 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 2: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0037-0170 | H2 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 8: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0037-0171 | H2 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-01: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0037-0172 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0173 | H2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-05: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0174 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0037-0175 | H2 | SCP0037_OperationLT.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0037_OperationLT.CreateSpread: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0037_OperationLT.CreateSpread:230) |
| WK-SCP0037-0176 | H5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 2: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0037-0177 | H5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 8: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0037-0178 | H5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-01: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0037-0179 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0180 | H5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-05: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0181 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0037-0182 | H5 | SCP0037_OperationLT.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0037_OperationLT.CreateSpread: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0037_OperationLT.CreateSpread:230) |
| WK-SCP0037-0183 | D1 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 13: 행 집계 — D1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (13) |
| WK-SCP0037-0184 | D1 | 3,9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 3,9: 행 집계 — D1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (3,9) |
| WK-SCP0037-0185 | D1 | SCP0037_OperationLT.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0037_OperationLT.EditButton: 진입점 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0037_OperationLT.EditButton:277:1) |
| WK-SCP0037-0186 | D3 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 13: 행 집계 — D3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (13) |
| WK-SCP0037-0187 | D3 | 3,9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 3,9: 행 집계 — D3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (3,9) |
| WK-SCP0037-0188 | D3 | SCP0037_OperationLT.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0037_OperationLT.EditButton: 진입점 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0037_OperationLT.EditButton:277:1) |
| WK-SCP0037-0189 | D4 | 10,6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 10,6: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (10,6) |
| WK-SCP0037-0190 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0037-0191 | D4 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-03: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0037-0192 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0193 | D5 | SCP0037_OperationLT.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0037_OperationLT.CreateSpread: 진입점 집계 — D5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0037_OperationLT.CreateSpread:230) |
| WK-SCP0037-0194 | E1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 12: 행 집계 — E1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0037-0195 | E1 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 13: 행 집계 — E1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (13) |
| WK-SCP0037-0196 | E1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 5: 행 집계 — E1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0037-0197 | E4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0037-0198 | E4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 7: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0037-0199 | E4 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-04: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCP0037-0200 | E4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-06: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0037-0201 | E4 | SCP0037_OperationLT.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0037_OperationLT.SetChangedControl: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0202 | E4 | SCP0037_OperationLT.setScmSiteId | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0037_OperationLT.setScmSiteId: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SCP0037_OperationLT.setScmSiteId:869) |
| WK-SCP0037-0203 | E5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — COMMON:UC-05: 행 집계 — E5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0204 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-SCP0037-0205 | A1 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 20: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (20) |
| WK-SCP0037-0206 | A1 | 3,9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3,9: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (3,9) |
| WK-SCP0037-0207 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (8) |
| WK-SCP0037-0208 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0209 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-03) |
| WK-SCP0037-0210 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-06) |
| WK-SCP0037-0211 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0037-0212 | A1 | PKG_SCP0037.P_SCP0037_GET_OPERATION_LT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0037.P_SCP0037_GET_OPERATION_LT: 골든 비교 케이스 없음(PKG_SCP0037.P_SCP0037_GET_OPERATION_LT — 팝업·보조 SP 는 golden_cases. |  | 37 (ACT:SCP0037_OperationLT.FindButton ACT:S) |
| WK-SCP0037-0213 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0037-0214 | G1 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 20: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (20) |
| WK-SCP0037-0215 | G1 | 3,9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 3,9: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (3,9) |
| WK-SCP0037-0216 | G1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 8: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0037-0217 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0218 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0037-0219 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0037-0220 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0037-0221 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0037-0222 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0037-0223 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0037-0224 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0037-0225 | X-LOC | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13) |
| WK-SCP0037-0226 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0037-0227 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0037-0228 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0037-0229 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0037-0230 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0037-0231 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0037-0232 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0037-0233 | X-ROW | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (1) |
| WK-SCP0037-0234 | X-ROW | 2,7,41,42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2,7,41,42: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (2,7,41,42) |
| WK-SCP0037-0235 | X-ROW | 28,29,30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 28,29,30: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (28,29,30) |
| WK-SCP0037-0236 | X-ROW | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0037-0237 | X-ROW | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0037-0238 | X-ROW | SCP0037_OperationLT.ClbDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.ClbDivision_SelectedIndexChang: 진입점 집계 6검사 — REVIEW:3 · NOT_RUN:3 |  | 2 (ACT:SCP0037_OperationLT.ClbDivision_Sele) |
| WK-SCP0037-0239 | X-ROW | SCP0037_OperationLT.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0037_OperationLT.CreateSpread) |
| WK-SCP0037-0240 | X-ROW | SCP0037_OperationLT.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0037_OperationLT.DefineProperty) |
| WK-SCP0037-0241 | X-ROW | SCP0037_OperationLT.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0037_OperationLT.FindButton) |
| WK-SCP0037-0242 | X-ROW | SCP0037_OperationLT.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.FindData: 진입점 집계 11검사 — NOT_RUN:9 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0037_OperationLT.FindData:313:1 A) |
| WK-SCP0037-0243 | X-ROW | SCP0037_OperationLT.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0037_OperationLT.Form_Load) |
| WK-SCP0037-0244 | X-ROW | SCP0037_OperationLT.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.InitControls: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0037_OperationLT.InitControls:174) |
| WK-SCP0037-0245 | X-ROW | SCP0037_OperationLT.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.InitSpread: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0246 | X-ROW | SCP0037_OperationLT.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0037_OperationLT.InsertButton) |
| WK-SCP0037-0247 | X-ROW | SCP0037_OperationLT.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.InsertRow: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0037_OperationLT.InsertRow ACT:SC) |
| WK-SCP0037-0248 | X-ROW | SCP0037_OperationLT.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.SaveData: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0037_OperationLT.SaveData:422:5 A) |
| WK-SCP0037-0249 | X-ROW | SCP0037_OperationLT.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.SetChangedControl: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0250 | X-ROW | SCP0037_OperationLT.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.SpdMain_CellClick: 진입점 집계 18검사 — NOT_RUN:10 · NOPATH:8 (미실행 검사가 남아 판정필요) |  | 82 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0251 | X-ROW | SCP0037_OperationLT.SpdMain_ClipboardPas | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.SpdMain_ClipboardPasted: 진입점 집계 21검사 — NOT_RUN:15 · NOPATH:6 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0252 | X-ROW | SCP0037_OperationLT.SpdMain_ComboSelChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.SpdMain_ComboSelChange: 진입점 집계 18검사 — NOT_RUN:15 · REVIEW:3 |  | 7 (ACT:SCP0037_OperationLT.SpdMain_ComboSel) |
| WK-SCP0037-0253 | X-ROW | SCP0037_OperationLT.SpdMain_KeyPress | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/RETURN/UI_PROP, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0037_OperationLT.SpdMain_KeyPress) |
| WK-SCP0037-0254 | X-ROW | SCP0037_OperationLT.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0037_OperationLT.btnItemId_Click:) |
| WK-SCP0037-0255 | X-ROW | SCP0037_OperationLT.checkValidN1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.checkValidN1: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SCP0037_OperationLT.checkValidN1 ACT) |
| WK-SCP0037-0256 | X-ROW | SCP0037_OperationLT.setScmSiteId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.setScmSiteId: 진입점 집계 4검사 — REVIEW:2 · NOT_RUN:2 |  | 3 (ACT:SCP0037_OperationLT.setScmSiteId:893) |
