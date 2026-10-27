# 작업 원장 — SCP0125 · 2026-10-26 12:55

> 검사 인스턴스 804건 중 PASS·NA 195건 외 **609건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 12 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 7 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 27 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 182 | 실행 → PASS |
| W7 | 기대값 확정 | 380 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 373 · E2E 182 · 하네스 34 · 대조표 19 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 64 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| D3 | EDIT |  |  |  |  |  | 16 | 40 |  |  | 행 값 기반 조건부 잠금 |
| D1 | EDIT |  |  |  |  |  | 16 | 35 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| E4 | EDIT |  |  |  |  |  | 27 | 11 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| D4 | EDIT |  |  |  |  |  | 8 | 26 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| C3 | CASCADE |  |  |  |  |  | 14 | 13 |  |  | 연쇄 자동 채움 |
| H2 | DESIGN |  |  |  |  |  | 6 | 21 |  |  | 배경·글자색 규칙 |
| B4 | COMBO |  |  |  |  | 8 |  | 18 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 7 |  |  | 16 |  |  | 콤보 후보 정렬 = AS-IS |
| C2 | CASCADE |  |  |  |  |  | 14 | 7 |  |  | 그리드 셀 cascade 후보 |
| A5 | DESIGN |  |  |  |  |  | 5 | 15 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 5 | 15 |  |  | 라벨 명칭 |
| A1 | GEN |  |  |  |  |  |  | 20 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-LOC | GEN |  | 12 |  |  |  |  | 7 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G1 | GEN |  |  |  |  |  | 5 | 13 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C6 | CASCADE |  |  |  |  |  | 10 | 7 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| F4 | DB |  |  |  |  |  | 12 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E1 | EDIT |  |  |  |  |  | 8 | 3 |  |  | 숫자 소수자리·정수·부호·범위 |
| M4 | POPUP |  |  |  |  |  | 5 | 4 |  |  | 팝업 선택값 반영 |
| A6 | GEN |  |  |  |  |  | 7 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G5 | POPUP |  |  |  |  | 3 |  | 4 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 1 | 4 |  |  | 팝업 표준·열림 |
| X-REASON | DESIGN |  |  |  |  |  |  | 7 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| E2 | EDIT |  |  |  |  | 1 |  | 5 |  |  | 날짜 형식·유효성 |
| G4 | DESIGN |  |  |  |  |  | 2 | 4 |  |  | 조회조건 표시·라벨·활성 |
| D5 | EDIT |  |  |  |  |  | 2 | 4 |  |  | 셀 에디터 유형 |
| G6 | GEN |  |  |  |  |  | 2 | 4 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| DB-SYN | DB |  |  |  |  | 4 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| C1 | CASCADE |  |  |  |  |  | 3 | 2 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B1 | COMBO |  |  |  |  | 2 |  | 2 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 2 |  | 2 |  |  | 콤보 후보 중복 없음 |
| E5 | EDIT |  |  |  |  | 2 |  | 2 |  |  | 콤보 셀 후보 외 값 차단 |
| C4 | CASCADE |  |  |  |  |  | 2 | 2 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0125-0001 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-SCP0125-0002 | X-LOC | 10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (10) |
| WK-SCP0125-0003 | X-LOC | 2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2) |
| WK-SCP0125-0004 | X-LOC | 3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3) |
| WK-SCP0125-0005 | X-LOC | 4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (4) |
| WK-SCP0125-0006 | X-LOC | 5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (5) |
| WK-SCP0125-0007 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-SCP0125-0008 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-SCP0125-0009 | X-LOC | 9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9) |
| WK-SCP0125-0010 | X-LOC | FrozenColumnCount | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FrozenColumnCount) |
| WK-SCP0125-0011 | X-LOC | Sort / Filter | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Sort / Filter) |
| WK-SCP0125-0012 | X-LOC | 셀 병합 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (셀 병합) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0125-0013 | H10 | SCP0125 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0125 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: hooks/useWorkbenchValidation.ts |  | 16 (E-04 D-06 D-14 D-18 0' 3.1 3.2 6' 9 영역1 ) |

## W4 검사기 구현 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0125-0014 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0125_Workbench.GetOperationByLine) |
| WK-SCP0125-0015 | B3 | INCOTERMS | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 INCOTERMS | 있음(SHEET_COLUMNS) | 1 (B-04) |
| WK-SCP0125-0016 | B3 | OPERATION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_ID | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0125_Workbench.GetOperationByLine) |
| WK-SCP0125-0017 | B3 | PLANT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLANT_ID | 있음(SHEET_COLUMNS) | 5 (B-17 ACT:SCP0125_Workbench.GetOperationB) |
| WK-SCP0125-0018 | B3 | PROJECT_CODE_40 | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PROJECT_CODE_40 | 있음(SHEET_COLUMNS) | 1 (B-14) |
| WK-SCP0125-0019 | B3 | STOCK_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 STOCK_TYPE | 있음(SHEET_COLUMNS) | 1 (B-05) |
| WK-SCP0125-0020 | B3 | STOCK_TYPE_NAME | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 STOCK_TYPE_NAME | 있음(SHEET_COLUMNS) | 1 (B-05) |

## W5 검사기 연결 (27)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0125-0021 | B1 | FCST_TYPE_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL FCST_TYPE_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0125-0022 | B1 | STOCK_TYPE_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL STOCK_TYPE_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0125-0023 | B2 | FCST_TYPE_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL FCST_TYPE_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0125-0024 | B2 | STOCK_TYPE_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL STOCK_TYPE_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0125-0025 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0125_Workbench.GetOperationByLine) |
| WK-SCP0125-0026 | B4 | FCST_TYPE_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FCST_TYPE_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0125-0027 | B4 | INCOTERMS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL INCOTERMS | 있음(SHEET_COLUMNS) | 1 (B-04) |
| WK-SCP0125-0028 | B4 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0125_Workbench.GetOperationByLine) |
| WK-SCP0125-0029 | B4 | PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_ID | 있음(SHEET_COLUMNS) | 5 (B-17 ACT:SCP0125_Workbench.GetOperationB) |
| WK-SCP0125-0030 | B4 | PROJECT_CODE_40 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PROJECT_CODE_40 | 있음(SHEET_COLUMNS) | 1 (B-14) |
| WK-SCP0125-0031 | B4 | STOCK_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL STOCK_TYPE | 있음(SHEET_COLUMNS) | 1 (B-05) |
| WK-SCP0125-0032 | B4 | STOCK_TYPE_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL STOCK_TYPE_NAME | 있음(SHEET_COLUMNS) | 2 (B-05 COMMON:UC-05) |
| WK-SCP0125-0033 | F2 | SCP0125 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0125 화면 | 판단불가(대상 단위 SCREEN) | 16 (D-04 D-06 D-13 P-05 0 0' 4 5 9 10 COMMON) |
| WK-SCP0125-0034 | F6 | SCP0125 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0125 화면 | 판단불가(대상 단위 SCREEN) | 4 (ACT:SCP0125_Workbench.SaveButton ACT:SCP) |
| WK-SCP0125-0035 | DB-SYN | SCP0125_GET_MKT_FCST_ELEC_DEMAND | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0125_GET_MKT_FCST_ELEC_DEMAND | 없음(PROC_M 대응 없음) | 7 (ACT:SCP0125_Workbench.FindData_Main:655:) |
| WK-SCP0125-0036 | DB-SYN | SCP0125_GET_STOCK_ELEC_PLNT_UC | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0125_GET_STOCK_ELEC_PLNT_UC | 없음(PROC_M 대응 없음) | 7 (ACT:SCP0125_Workbench.FindData_Main:655:) |
| WK-SCP0125-0037 | DB-SYN | SCP0125_SAVE_MKT_FCST_ELEC_DEMAND | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0125_SAVE_MKT_FCST_ELEC_DEMAND | 없음(PROC_M 대응 없음) | 4 (ACT:SCP0125_Workbench.Save_Data:1103:152) |
| WK-SCP0125-0038 | DB-SYN | SCP0125_SAVE_STOCK_SECOND_OCV | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0125_SAVE_STOCK_SECOND_OCV | 없음(PROC_M 대응 없음) | 5 (ACT:SCP0125_Workbench.Save_Data:1103:152) |
| WK-SCP0125-0039 | E2 | YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL YYYYMMDD | 있음(SHEET_COLUMNS) | 1 (3) |
| WK-SCP0125-0040 | E5 | FCST_TYPE_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL FCST_TYPE_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0125-0041 | E5 | STOCK_TYPE_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL STOCK_TYPE_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0125-0042 | G03-WIRE | SCP0125 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0125 화면 | 판단불가(대상 단위 SCREEN) | 12 (ACT:SCP0125_Workbench..ctor ACT:SCP0125_) |
| WK-SCP0125-0043 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 12 (U-07 ACT:SCP0125_Workbench.SpdMain_CellD) |
| WK-SCP0125-0044 | G5 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 29 (U-06 ACT:SCP0125_Workbench.SpdMain_CellD) |
| WK-SCP0125-0045 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0125_Workbench.SpdMain_CellDouble) |
| WK-SCP0125-0046 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 12 (U-07 ACT:SCP0125_Workbench.SpdMain_CellD) |
| WK-SCP0125-0047 | H6 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 29 (U-06 ACT:SCP0125_Workbench.SpdMain_CellD) |

## W6 검증 실행 (182)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0125-0048 | J2 | SCP0125 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0125 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 59 (C-23 E-05 G-08 G-09 G-15 G-17 G-23 G-29 ) |
| WK-SCP0125-0049 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (E-01 ACT:SCP0125_Workbench.InitControls:) |
| WK-SCP0125-0050 | C1 | cboPlanDate / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (E-02 ACT:SCP0125_Workbench.RefreshPlanDa) |
| WK-SCP0125-0051 | C1 | cboVersion / MKT FCST Ver. / Version | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboVersion / MKT FCST Ver. / Version · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.RefreshVersionNo:2) |
| WK-SCP0125-0052 | C2 | CELL_PROD_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CELL_PROD_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.spdMain_CellClick:) |
| WK-SCP0125-0053 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0054 | C2 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (G-45 ACT:SCP0125_Workbench.SpdMain_Combo) |
| WK-SCP0125-0055 | C2 | FCST_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FCST_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0056 | C2 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0125_Workbench.spdMain_CellClick:) |
| WK-SCP0125-0057 | C2 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0058 | C2 | LOCATION_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LOCATION_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.spdMain_CellClick:) |
| WK-SCP0125-0059 | C2 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (G-47 ACT:SCP0125_Workbench.SpdMain_Combo) |
| WK-SCP0125-0060 | C2 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0061 | C2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0062 | C2 | PROJECT_CODE_40 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_CODE_40 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.spdMain_CellClick:) |
| WK-SCP0125-0063 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0064 | C2 | STOCK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — STOCK_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (G-46 G-48 ACT:SCP0125_Workbench.SpdMain_) |
| WK-SCP0125-0065 | C2 | STOCK_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — STOCK_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0066 | C3 | BEFORE_DEGAS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BEFORE_DEGAS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0067 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 13 (ACT:SCP0125_Workbench.SpdMain_ClipboardP) |
| WK-SCP0125-0068 | C3 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (G-42 G-45 ACT:SCP0125_Workbench.SpdMain_) |
| WK-SCP0125-0069 | C3 | FCST_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FCST_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (ACT:SCP0125_Workbench.SpdMain_ClipboardP) |
| WK-SCP0125-0070 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.SpdMain_CellDouble) |
| WK-SCP0125-0071 | C3 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 13 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0072 | C3 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (G-44 G-47 ACT:SCP0125_Workbench.SpdMain_) |
| WK-SCP0125-0073 | C3 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0074 | C3 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0125_Workbench.SpdMain_ClipboardP) |
| WK-SCP0125-0075 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0076 | C3 | PROJECT_CODE_40 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE_40 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0077 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0078 | C3 | STOCK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — STOCK_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (G-43 G-46 G-48 ACT:SCP0125_Workbench.Spd) |
| WK-SCP0125-0079 | C3 | STOCK_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — STOCK_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0125_Workbench.SpdMain_ClipboardP) |
| WK-SCP0125-0080 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (E-01) |
| WK-SCP0125-0081 | C4 | cboPlanDate / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboPlanDate / Plan Date · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (E-02) |
| WK-SCP0125-0082 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0083 | C6 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (G-45 ACT:SCP0125_Workbench.SpdMain_Combo) |
| WK-SCP0125-0084 | C6 | FCST_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FCST_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0085 | C6 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0086 | C6 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (G-47 ACT:SCP0125_Workbench.SpdMain_Combo) |
| WK-SCP0125-0087 | C6 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0088 | C6 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0089 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0090 | C6 | STOCK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — STOCK_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (G-46 G-48 ACT:SCP0125_Workbench.SpdMain_) |
| WK-SCP0125-0091 | C6 | STOCK_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — STOCK_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0092 | G3 | SCP0125 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0125 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (C-11 C-21 COMMON:UC-01 COMMON:UC-02 COMM) |
| WK-SCP0125-0093 | K-SA | SCP0125 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0125 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 3 (C-11 C-21 COMMON:UC-02) |
| WK-SCP0125-0094 | K4 | SCP0125 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0125 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 5 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0125-0095 | F1 | SCP0125 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0125 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 30 (E-05 G-09 D-01 D-03 D-04 D-06 D-13 P-03 ) |
| WK-SCP0125-0096 | F3 | SCP0125 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0125 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 34 (E-07 G-42 G-43 G-44 D-16 P-12 ACT:SCP012) |
| WK-SCP0125-0097 | F5 | SCP0125 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0125 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 14 (E-05 G-09 D-01 D-03 P-03 ACT:SCP0125_Wor) |
| WK-SCP0125-0098 | F4 | PKG_SCP0125.P_SCP0125_GET_MKT_FCST_ADJ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0125.P_SCP0125_GET_MKT_FCST_ADJ · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 88 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0099 | F4 | PKG_SCP0125.P_SCP0125_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0125.P_SCP0125_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 2 (ACT:SCP0125_Workbench.GetSearchInfo:241:) |
| WK-SCP0125-0100 | F4 | PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 88 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0101 | F4 | PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ_UC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ_UC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 88 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0102 | F4 | PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_PLN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_PLNT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 88 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0103 | F4 | PKG_SCP0125.P_SCP0125_GET_STOCK_SECOND_O | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0125.P_SCP0125_GET_STOCK_SECOND_OCV · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 88 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0104 | F4 | PKG_SCP0125.P_SCP0125_SAVE_MKT_FCST_ADJ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0125.P_SCP0125_SAVE_MKT_FCST_ADJ · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 8 (ACT:SCP0125_Workbench.SaveButton ACT:SCP) |
| WK-SCP0125-0105 | F4 | PKG_SCP0125.P_SCP0125_SAVE_STOCK_ADJ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0125.P_SCP0125_SAVE_STOCK_ADJ · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 8 (ACT:SCP0125_Workbench.SaveButton ACT:SCP) |
| WK-SCP0125-0106 | F4 | SCP0125_GET_MKT_FCST_ELEC_DEMAND | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0125_GET_MKT_FCST_ELEC_DEMAND · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 88 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0107 | F4 | SCP0125_GET_STOCK_ELEC_PLNT_UC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0125_GET_STOCK_ELEC_PLNT_UC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 88 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0108 | F4 | SCP0125_SAVE_MKT_FCST_ELEC_DEMAND | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0125_SAVE_MKT_FCST_ELEC_DEMAND · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 8 (ACT:SCP0125_Workbench.SaveButton ACT:SCP) |
| WK-SCP0125-0109 | F4 | SCP0125_SAVE_STOCK_SECOND_OCV | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0125_SAVE_STOCK_SECOND_OCV · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 9 (ACT:SCP0125_Workbench.SaveButton ACT:SCP) |
| WK-SCP0125-0110 | A5 | INCOTERMS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (B-04) |
| WK-SCP0125-0111 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (U-07 ACT:SCP0125_Workbench.SpdMain_CellD) |
| WK-SCP0125-0112 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (U-06 ACT:SCP0125_Workbench.SpdMain_CellD) |
| WK-SCP0125-0113 | A5 | STOCK_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — STOCK_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (B-05) |
| WK-SCP0125-0114 | A5 | STOCK_TYPE_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — STOCK_TYPE_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (B-05) |
| WK-SCP0125-0115 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0125_Workbench.InitControls ACT:S) |
| WK-SCP0125-0116 | G4 | cboPlanDate / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0125_Workbench.InitEvent ACT:SCP0) |
| WK-SCP0125-0117 | H2 | CELL_PROD_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CELL_PROD_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (G-16) |
| WK-SCP0125-0118 | H2 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (B-04) |
| WK-SCP0125-0119 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (U-07) |
| WK-SCP0125-0120 | H2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (U-06) |
| WK-SCP0125-0121 | H2 | STOCK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — STOCK_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (B-05) |
| WK-SCP0125-0122 | H2 | STOCK_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — STOCK_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (B-05) |
| WK-SCP0125-0123 | H5 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — INCOTERMS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (B-04) |
| WK-SCP0125-0124 | H5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (U-07) |
| WK-SCP0125-0125 | H5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (U-06) |
| WK-SCP0125-0126 | H5 | STOCK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — STOCK_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (B-05) |
| WK-SCP0125-0127 | H5 | STOCK_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — STOCK_TYPE_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (B-05) |
| WK-SCP0125-0128 | I1 | SCP0125 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0125 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 53 (E-04 D-06 D-14 D-18 0' 3.1 3.2 6' 9 영역1 ) |
| WK-SCP0125-0129 | SC1 | SCP0125 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0125 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 4 (C-23 D-15 U-07 COMMON:UC-01) |
| WK-SCP0125-0130 | D1 | CELL_PROD_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_PROD_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (G-16 ACT:SCP0125_Workbench.Insert_Row:73) |
| WK-SCP0125-0131 | D1 | CHG_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHG_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (G-10) |
| WK-SCP0125-0132 | D1 | CHG_RSN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHG_RSN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (G-10) |
| WK-SCP0125-0133 | D1 | CHG_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHG_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (ACT:SCP0125_Workbench.EditButton ACT:SCP) |
| WK-SCP0125-0134 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (ACT:SCP0125_Workbench.EditButton ACT:SCP) |
| WK-SCP0125-0135 | D1 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.Insert_Row:750:18) |
| WK-SCP0125-0136 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SCP0125_Workbench.EditButton:519:5 A) |
| WK-SCP0125-0137 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0125_Workbench.Insert_Row:749:17 ) |
| WK-SCP0125-0138 | D1 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.Insert_Row:798:44) |
| WK-SCP0125-0139 | D1 | OPERATION_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.Insert_Row:830:59) |
| WK-SCP0125-0140 | D1 | PRE_CHG_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRE_CHG_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (5) |
| WK-SCP0125-0141 | D1 | PRE_CHG_RSN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRE_CHG_RSN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (5) |
| WK-SCP0125-0142 | D1 | QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SCP0125_Workbench.EditButton:518:4 A) |
| WK-SCP0125-0143 | D1 | SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.Insert_Row:797:43) |
| WK-SCP0125-0144 | D1 | STOCK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — STOCK_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0125_Workbench.Insert_Row:781:32 ) |
| WK-SCP0125-0145 | D1 | VERSION_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VERSION_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.Insert_Row:748:16) |
| WK-SCP0125-0146 | D3 | CELL_PROD_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_PROD_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (G-16 ACT:SCP0125_Workbench.Insert_Row:73) |
| WK-SCP0125-0147 | D3 | CHG_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHG_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (G-10) |
| WK-SCP0125-0148 | D3 | CHG_RSN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHG_RSN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (G-10) |
| WK-SCP0125-0149 | D3 | CHG_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHG_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (ACT:SCP0125_Workbench.EditButton ACT:SCP) |
| WK-SCP0125-0150 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (ACT:SCP0125_Workbench.EditButton ACT:SCP) |
| WK-SCP0125-0151 | D3 | FCST_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FCST_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.Insert_Row:750:18) |
| WK-SCP0125-0152 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SCP0125_Workbench.EditButton:519:5 A) |
| WK-SCP0125-0153 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0125_Workbench.Insert_Row:749:17 ) |
| WK-SCP0125-0154 | D3 | OPERATION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.Insert_Row:798:44) |
| WK-SCP0125-0155 | D3 | OPERATION_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.Insert_Row:830:59) |
| WK-SCP0125-0156 | D3 | PRE_CHG_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRE_CHG_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (5) |
| WK-SCP0125-0157 | D3 | PRE_CHG_RSN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRE_CHG_RSN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (5) |
| WK-SCP0125-0158 | D3 | QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SCP0125_Workbench.EditButton:518:4 A) |
| WK-SCP0125-0159 | D3 | SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SEQ · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.Insert_Row:797:43) |
| WK-SCP0125-0160 | D3 | STOCK_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — STOCK_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0125_Workbench.Insert_Row:781:32 ) |
| WK-SCP0125-0161 | D3 | VERSION_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VERSION_NO · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0125_Workbench.Insert_Row:748:16) |
| WK-SCP0125-0162 | D4 | CELL_PROD_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — CELL_PROD_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (G-16) |
| WK-SCP0125-0163 | D4 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (B-04) |
| WK-SCP0125-0164 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (G-41) |
| WK-SCP0125-0165 | D4 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (B-17) |
| WK-SCP0125-0166 | D4 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (G-40) |
| WK-SCP0125-0167 | D4 | PROJECT_CODE_40 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PROJECT_CODE_40 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (B-14) |
| WK-SCP0125-0168 | D4 | STOCK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — STOCK_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (B-05) |
| WK-SCP0125-0169 | D4 | STOCK_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — STOCK_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (B-05) |
| WK-SCP0125-0170 | D5 | FCST_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FCST_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0125-0171 | D5 | STOCK_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — STOCK_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0125-0172 | D6 | SCP0125 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0125 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 32 (G-15 G-17 G-23 G-29 G-34 G-16 D-12 F-10 ) |
| WK-SCP0125-0173 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0125_Workbench.SpdMain_ClipboardP) |
| WK-SCP0125-0174 | E1 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (G-42 ACT:SCP0125_Workbench.SpdMain_Clipb) |
| WK-SCP0125-0175 | E1 | FCST_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — FCST_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0125_Workbench.SpdMain_ClipboardP) |
| WK-SCP0125-0176 | E1 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0125_Workbench.SpdMain_ClipboardP) |
| WK-SCP0125-0177 | E1 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (G-44 ACT:SCP0125_Workbench.SpdMain_Clipb) |
| WK-SCP0125-0178 | E1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0125_Workbench.SpdMain_ClipboardP) |
| WK-SCP0125-0179 | E1 | STOCK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — STOCK_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (G-43 ACT:SCP0125_Workbench.SpdMain_Clipb) |
| WK-SCP0125-0180 | E1 | STOCK_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — STOCK_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0125_Workbench.SpdMain_ClipboardP) |
| WK-SCP0125-0181 | E4 | BEFORE_DEGAS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — BEFORE_DEGAS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0182 | E4 | CHG_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHG_TYPE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0125-0183 | E4 | LINE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LINE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0184 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCP0125_Workbench.Save_Data:928:70 A) |
| WK-SCP0125-0185 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (D-14 0' COMMON:UC-04 ACT:SCP0125_Workben) |
| WK-SCP0125-0186 | E4 | MSG00013 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00013 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0125-0187 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (3.1 ACT:SCP0125_Workbench.Save_Data:990:) |
| WK-SCP0125-0188 | E4 | MSG00050 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00050 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0125_Workbench.Save_Data:1062:127) |
| WK-SCP0125-0189 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (권한) |
| WK-SCP0125-0190 | E4 | MSG00129 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00129 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (영역1 ACT:SCP0125_Workbench.spdSub_ActiveS) |
| WK-SCP0125-0191 | E4 | MSG00260 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00260 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0125_Workbench.Save_Data:973:93 A) |
| WK-SCP0125-0192 | E4 | MSG00310 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00310 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0125_Workbench.Save_Data:1344:290) |
| WK-SCP0125-0193 | E4 | MSG00428 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00428 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0125-0194 | E4 | MSG00457 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00457 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0125_Workbench.Save_Data:1009:106) |
| WK-SCP0125-0195 | E4 | MSG00458 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00458 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0125_Workbench.Save_Data:1034:115) |
| WK-SCP0125-0196 | E4 | MSG00463 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00463 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (3.2 ACT:SCP0125_Workbench.Save_Data:997:) |
| WK-SCP0125-0197 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D-18 권한) |
| WK-SCP0125-0198 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-04) |
| WK-SCP0125-0199 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0125-0200 | E4 | MSG01027 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01027 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (6') |
| WK-SCP0125-0201 | E4 | MSG01081 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01081 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (3.1) |
| WK-SCP0125-0202 | E4 | MSG01082 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01082 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0125-0203 | E4 | MSG01149 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01149 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (E-04 D-06 9 영역1) |
| WK-SCP0125-0204 | E4 | MSG01437 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01437 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (3.2) |
| WK-SCP0125-0205 | E4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0206 | E4 | PROJECT_CODE_40 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE_40 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0207 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0208 | A10 | SCP0125 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0125 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 80 (ACT:SCP0125_Workbench.Form_Load ACT:SCP0) |
| WK-SCP0125-0209 | A6 | PKG_SCP0125.P_SCP0125_GET_MKT_FCST_ADJ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0125.P_SCP0125_GET_MKT_FCST_ADJ · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0210 | A6 | PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0211 | A6 | PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ_UC | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ_UC · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0212 | A6 | PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_PLN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_PLNT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0213 | A6 | PKG_SCP0125.P_SCP0125_GET_STOCK_SECOND_O | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0125.P_SCP0125_GET_STOCK_SECOND_OCV · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0214 | A6 | SCP0125_GET_MKT_FCST_ELEC_DEMAND | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0125_GET_MKT_FCST_ELEC_DEMAND · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0215 | A6 | SCP0125_GET_STOCK_ELEC_PLNT_UC | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0125_GET_STOCK_ELEC_PLNT_UC · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.s |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0216 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0125_Workbench.FindData_Main ACT:) |
| WK-SCP0125-0217 | G1 | cboPlanDate / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0125_Workbench.FindData_Main ACT:) |
| WK-SCP0125-0218 | G1 | cboVersion / MKT FCST Ver. / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboVersion / MKT FCST Ver. / Version · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0125_Workbench.FindData_Main ACT:) |
| WK-SCP0125-0219 | G1 | txtItem / Model / Item / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItem / Model / Item / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0125_Workbench.FindData_Main ACT:) |
| WK-SCP0125-0220 | G1 | txtNickName / Nick Name / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0125_Workbench.FindData_Main ACT:) |
| WK-SCP0125-0221 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0125_Workbench.InitControls ACT:S) |
| WK-SCP0125-0222 | G6 | cboPlanDate / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0125_Workbench.InitEvent ACT:SCP0) |
| WK-SCP0125-0223 | X-REOPEN | SCP0125 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0125 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 10 (ACT:SCP0125_Workbench.Dispose ACT:SCP012) |
| WK-SCP0125-0224 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0125_Workbench.SpdMain_CellDouble) |
| WK-SCP0125-0225 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0125_Workbench.SpdMain_CellDouble) |
| WK-SCP0125-0226 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 12 (U-07 ACT:SCP0125_Workbench.SpdMain_CellD) |
| WK-SCP0125-0227 | M4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 29 (U-06 ACT:SCP0125_Workbench.SpdMain_CellD) |
| WK-SCP0125-0228 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0125_Workbench.SpdMain_CellDouble) |
| WK-SCP0125-0229 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0125_Workbench.SpdMain_CellDouble) |

## W7 기대값 확정 (380)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0125-0230 | C1 | P-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — P-06: 행 집계 — C1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (P-06) |
| WK-SCP0125-0231 | C1 | P-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — P-07: 행 집계 — C1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (P-07) |
| WK-SCP0125-0232 | C2 | D-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D-17: 행 집계 — C2 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D-17) |
| WK-SCP0125-0233 | C2 | E-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — E-08: 행 집계 — C2 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (E-08) |
| WK-SCP0125-0234 | C2 | P-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — P-13: 행 집계 — C2 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (P-13) |
| WK-SCP0125-0235 | C2 | SCP0125_Workbench.CboPlanDate_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0125_Workbench.CboPlanDate_SelectedIndexChanged: 진입점 집계 — C2 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.CboPlanDate_Select) |
| WK-SCP0125-0236 | C2 | SCP0125_Workbench.ClbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0125_Workbench.ClbDivision_SelectedIndexChanged: 진입점 집계 — C2 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0125_Workbench.ClbDivision_Select) |
| WK-SCP0125-0237 | C2 | SCP0125_Workbench.SpdMain_ActiveSheetCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0125_Workbench.SpdMain_ActiveSheetChanged: 진입점 집계 — C2 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0125_Workbench.SpdMain_ActiveShee) |
| WK-SCP0125-0238 | C2 | SCP0125_Workbench.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0125_Workbench.SpdMain_ComboSelChange: 진입점 집계 — C2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0239 | C3 | D-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D-16: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D-16) |
| WK-SCP0125-0240 | C3 | D-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D-17: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D-17) |
| WK-SCP0125-0241 | C3 | E-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — E-07: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (E-07) |
| WK-SCP0125-0242 | C3 | E-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — E-08: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (E-08) |
| WK-SCP0125-0243 | C3 | P-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — P-12: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (P-12) |
| WK-SCP0125-0244 | C3 | P-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — P-13: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (P-13) |
| WK-SCP0125-0245 | C3 | SCP0125_Workbench.CboPlanDate_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0125_Workbench.CboPlanDate_SelectedIndexChanged: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.CboPlanDate_Select) |
| WK-SCP0125-0246 | C3 | SCP0125_Workbench.ClbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0125_Workbench.ClbDivision_SelectedIndexChanged: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0125_Workbench.ClbDivision_Select) |
| WK-SCP0125-0247 | C3 | SCP0125_Workbench.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0125_Workbench.SetChangedControl: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0125_Workbench.SetChangedControl:) |
| WK-SCP0125-0248 | C3 | SCP0125_Workbench.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0125_Workbench.SetSpreadInit: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0125_Workbench.SetSpreadInit:416:) |
| WK-SCP0125-0249 | C3 | SCP0125_Workbench.SetVisibleSheetColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0125_Workbench.SetVisibleSheetColumns: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0250 | C3 | SCP0125_Workbench.SpdMain_ActiveSheetCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0125_Workbench.SpdMain_ActiveSheetChanged: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0125_Workbench.SpdMain_ActiveShee) |
| WK-SCP0125-0251 | C3 | SCP0125_Workbench.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0125_Workbench.SpdMain_ComboSelChange: 진입점 집계 — C3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0252 | C4 | P-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — P-06: 행 집계 — C4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (P-06) |
| WK-SCP0125-0253 | C4 | P-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — P-07: 행 집계 — C4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (P-07) |
| WK-SCP0125-0254 | C6 | D-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D-17: 행 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D-17) |
| WK-SCP0125-0255 | C6 | E-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — E-08: 행 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (E-08) |
| WK-SCP0125-0256 | C6 | P-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — P-13: 행 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (P-13) |
| WK-SCP0125-0257 | C6 | SCP0125_Workbench.CboPlanDate_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0125_Workbench.CboPlanDate_SelectedIndexChanged: 진입점 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.CboPlanDate_Select) |
| WK-SCP0125-0258 | C6 | SCP0125_Workbench.ClbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0125_Workbench.ClbDivision_SelectedIndexChanged: 진입점 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0125_Workbench.ClbDivision_Select) |
| WK-SCP0125-0259 | C6 | SCP0125_Workbench.SpdMain_ActiveSheetCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0125_Workbench.SpdMain_ActiveSheetChanged: 진입점 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0125_Workbench.SpdMain_ActiveShee) |
| WK-SCP0125-0260 | C6 | SCP0125_Workbench.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0125_Workbench.SpdMain_ComboSelChange: 진입점 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0261 | B1 | E-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — E-05: 행 집계 — B1 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (E-05) |
| WK-SCP0125-0262 | B1 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — 셀 타입 콤보: 행 집계 — B1 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0125-0263 | B2 | E-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — E-05: 행 집계 — B2 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (E-05) |
| WK-SCP0125-0264 | B2 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — 셀 타입 콤보: 행 집계 — B2 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0125-0265 | B3 | B-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-01: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-01) |
| WK-SCP0125-0266 | B3 | B-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-02: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-02) |
| WK-SCP0125-0267 | B3 | B-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-03: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-03) |
| WK-SCP0125-0268 | B3 | B-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-06: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-06) |
| WK-SCP0125-0269 | B3 | B-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-08: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-08) |
| WK-SCP0125-0270 | B3 | B-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-09: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-09) |
| WK-SCP0125-0271 | B3 | B-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-10: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-10) |
| WK-SCP0125-0272 | B3 | B-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-11: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-11) |
| WK-SCP0125-0273 | B3 | B-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-12: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-12) |
| WK-SCP0125-0274 | B3 | B-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-13: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-13) |
| WK-SCP0125-0275 | B3 | B-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-15: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-15) |
| WK-SCP0125-0276 | B3 | B-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-16: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-16) |
| WK-SCP0125-0277 | B3 | B-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B-18: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (B-18) |
| WK-SCP0125-0278 | B3 | F-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — F-01: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (F-01) |
| WK-SCP0125-0279 | B3 | SCP0125_Workbench.GetOperationByLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0125_Workbench.GetOperationByLine: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.GetOperationByLine) |
| WK-SCP0125-0280 | B3 | SCP0125_Workbench.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0125_Workbench.GetSearchInfo: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0125_Workbench.GetSearchInfo:234:) |
| WK-SCP0125-0281 | B4 | B-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-01: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-01) |
| WK-SCP0125-0282 | B4 | B-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-02: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-02) |
| WK-SCP0125-0283 | B4 | B-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-03: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-03) |
| WK-SCP0125-0284 | B4 | B-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-06: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-06) |
| WK-SCP0125-0285 | B4 | B-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-08: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-08) |
| WK-SCP0125-0286 | B4 | B-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-09: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-09) |
| WK-SCP0125-0287 | B4 | B-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-10: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-10) |
| WK-SCP0125-0288 | B4 | B-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-11: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-11) |
| WK-SCP0125-0289 | B4 | B-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-12: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-12) |
| WK-SCP0125-0290 | B4 | B-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-13: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-13) |
| WK-SCP0125-0291 | B4 | B-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-15: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-15) |
| WK-SCP0125-0292 | B4 | B-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-16: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-16) |
| WK-SCP0125-0293 | B4 | B-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B-18: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (B-18) |
| WK-SCP0125-0294 | B4 | E-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — E-05: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (E-05) |
| WK-SCP0125-0295 | B4 | F-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — F-01: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (F-01) |
| WK-SCP0125-0296 | B4 | SCP0125_Workbench.GetOperationByLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0125_Workbench.GetOperationByLine: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.GetOperationByLine) |
| WK-SCP0125-0297 | B4 | SCP0125_Workbench.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0125_Workbench.GetSearchInfo: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0125_Workbench.GetSearchInfo:234:) |
| WK-SCP0125-0298 | B4 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 셀 타입 콤보: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0125-0299 | DB-SYN | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 4: 행 집계 — DB-SYN 12요소: PASS:8 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0125-0300 | F4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 4: 행 집계 — F4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0125-0301 | A5 | B-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — B-18: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (B-18) |
| WK-SCP0125-0302 | A5 | C-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — C-17: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (C-17) |
| WK-SCP0125-0303 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0125-0304 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0125-0305 | A5 | D-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D-02: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D-02) |
| WK-SCP0125-0306 | A5 | D-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D-06: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D-06) |
| WK-SCP0125-0307 | A5 | FrozenColumnCount | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — FrozenColumnCount: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FrozenColumnCount) |
| WK-SCP0125-0308 | A5 | G-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G-13: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G-13) |
| WK-SCP0125-0309 | A5 | Lock 계열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Lock 계열: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열) |
| WK-SCP0125-0310 | A5 | SCP0125_Workbench.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0125_Workbench.CreateSpread: 진입점 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCP0125_Workbench.CreateSpread:312:1) |
| WK-SCP0125-0311 | A5 | SCP0125_Workbench.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0125_Workbench.SetSpreadInit: 진입점 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0125_Workbench.SetSpreadInit:416:) |
| WK-SCP0125-0312 | A5 | SetValue Auto-Sync | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SetValue Auto-Sync: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SetValue Auto-Sync) |
| WK-SCP0125-0313 | A5 | Sort / Filter | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Sort / Filter: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Sort / Filter) |
| WK-SCP0125-0314 | A5 | 셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 셀 병합: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합) |
| WK-SCP0125-0315 | A5 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 셀 타입 콤보: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0125-0316 | G4 | C-23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — C-23: 행 집계 — G4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (C-23) |
| WK-SCP0125-0317 | G4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-01: 행 집계 — G4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0125-0318 | G4 | D-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D-15: 행 집계 — G4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D-15) |
| WK-SCP0125-0319 | G4 | U-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — U-07: 행 집계 — G4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (U-07) |
| WK-SCP0125-0320 | H2 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 9: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0125-0321 | H2 | B-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — B-18: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (B-18) |
| WK-SCP0125-0322 | H2 | C-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — C-14: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (C-14) |
| WK-SCP0125-0323 | H2 | C-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — C-15: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (C-15) |
| WK-SCP0125-0324 | H2 | C-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — C-16: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (C-16) |
| WK-SCP0125-0325 | H2 | C-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — C-17: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (C-17) |
| WK-SCP0125-0326 | H2 | C-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — C-21: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (C-21) |
| WK-SCP0125-0327 | H2 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-01: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0125-0328 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0125-0329 | H2 | D-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D-02: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D-02) |
| WK-SCP0125-0330 | H2 | D-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D-06: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D-06) |
| WK-SCP0125-0331 | H2 | E-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E-03: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (E-03) |
| WK-SCP0125-0332 | H2 | FrozenColumnCount | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — FrozenColumnCount: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (FrozenColumnCount) |
| WK-SCP0125-0333 | H2 | G-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G-13: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (G-13) |
| WK-SCP0125-0334 | H2 | Lock 계열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Lock 계열: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열) |
| WK-SCP0125-0335 | H2 | SCP0125_Workbench.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0125_Workbench.CreateSpread: 진입점 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCP0125_Workbench.CreateSpread:312:1) |
| WK-SCP0125-0336 | H2 | SCP0125_Workbench.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0125_Workbench.SetSpreadInit: 진입점 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0125_Workbench.SetSpreadInit:416:) |
| WK-SCP0125-0337 | H2 | SetValue Auto-Sync | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SetValue Auto-Sync: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (SetValue Auto-Sync) |
| WK-SCP0125-0338 | H2 | Sort / Filter | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Sort / Filter: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Sort / Filter) |
| WK-SCP0125-0339 | H2 | 셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 셀 병합: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합) |
| WK-SCP0125-0340 | H2 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 셀 타입 콤보: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0125-0341 | H5 | B-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — B-18: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (B-18) |
| WK-SCP0125-0342 | H5 | C-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — C-17: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (C-17) |
| WK-SCP0125-0343 | H5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-01: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0125-0344 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0125-0345 | H5 | D-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D-02: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D-02) |
| WK-SCP0125-0346 | H5 | D-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D-06: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D-06) |
| WK-SCP0125-0347 | H5 | FrozenColumnCount | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — FrozenColumnCount: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FrozenColumnCount) |
| WK-SCP0125-0348 | H5 | G-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G-13: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G-13) |
| WK-SCP0125-0349 | H5 | Lock 계열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Lock 계열: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열) |
| WK-SCP0125-0350 | H5 | SCP0125_Workbench.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0125_Workbench.CreateSpread: 진입점 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCP0125_Workbench.CreateSpread:312:1) |
| WK-SCP0125-0351 | H5 | SCP0125_Workbench.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0125_Workbench.SetSpreadInit: 진입점 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0125_Workbench.SetSpreadInit:416:) |
| WK-SCP0125-0352 | H5 | SetValue Auto-Sync | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SetValue Auto-Sync: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SetValue Auto-Sync) |
| WK-SCP0125-0353 | H5 | Sort / Filter | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Sort / Filter: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Sort / Filter) |
| WK-SCP0125-0354 | H5 | 셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 셀 병합: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합) |
| WK-SCP0125-0355 | H5 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 셀 타입 콤보: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0125-0356 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 — **동작 미충족 — 조용히 통과시키지 않고 사유를 남긴다.** 이 화면 Key-in 조회조건은 Nick Name |  | 1 (COMMON:UC-06) |
| WK-SCP0125-0357 | X-REASON | G-14 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G-14 `LockColumn(0, max, true)` 700 — 종전 표기 **미이식**(규범 `convert-core.md §2.4` — 조회 후 전열 잠금은 **모드축**이고 모드 토글 자체를 |  | 1 (G-14) |
| WK-SCP0125-0358 | X-REASON | P-04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P-04 `EditButton` cs:512 (**NO-OP 아님**) — 종전 표기 **미이식**(규범 §2.4 — 모드 토글). `customButtons` 없음 · `hotkeyConfig.ed |  | 1 (P-04) |
| WK-SCP0125-0359 | X-REASON | U-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — U-02 `ProgressForm` (2/5) — U-01 과 동일(범위행 전개 2/5) 제외 |  | 1 (U-02) |
| WK-SCP0125-0360 | X-REASON | U-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — U-03 `ProgressForm` (3/5) — U-01 과 동일(범위행 전개 3/5) 제외 |  | 1 (U-03) |
| WK-SCP0125-0361 | X-REASON | U-04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — U-04 `ProgressForm` (4/5) — U-01 과 동일(범위행 전개 4/5) 제외 |  | 1 (U-04) |
| WK-SCP0125-0362 | X-REASON | U-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — U-05 `ProgressForm` (5/5) — U-01 과 동일(범위행 전개 5/5) 제외 |  | 1 (U-05) |
| WK-SCP0125-0363 | D1 | 0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 0: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (0) |
| WK-SCP0125-0364 | D1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 9: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0125-0365 | D1 | D-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D-06: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-06) |
| WK-SCP0125-0366 | D1 | D-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D-07: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-07) |
| WK-SCP0125-0367 | D1 | D-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D-12: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-12) |
| WK-SCP0125-0368 | D1 | D-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D-13: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-13) |
| WK-SCP0125-0369 | D1 | D-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D-16: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-16) |
| WK-SCP0125-0370 | D1 | D-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D-17: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-17) |
| WK-SCP0125-0371 | D1 | E-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — E-05: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (E-05) |
| WK-SCP0125-0372 | D1 | G-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-11: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-11) |
| WK-SCP0125-0373 | D1 | G-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-12: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-12) |
| WK-SCP0125-0374 | D1 | G-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-18: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-18) |
| WK-SCP0125-0375 | D1 | G-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-19: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-19) |
| WK-SCP0125-0376 | D1 | G-20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-20: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-20) |
| WK-SCP0125-0377 | D1 | G-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-21: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-21) |
| WK-SCP0125-0378 | D1 | G-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-22: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-22) |
| WK-SCP0125-0379 | D1 | G-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-24: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-24) |
| WK-SCP0125-0380 | D1 | G-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-25: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-25) |
| WK-SCP0125-0381 | D1 | G-26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-26: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-26) |
| WK-SCP0125-0382 | D1 | G-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-27: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-27) |
| WK-SCP0125-0383 | D1 | G-28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-28: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-28) |
| WK-SCP0125-0384 | D1 | G-30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-30: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-30) |
| WK-SCP0125-0385 | D1 | G-31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-31: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-31) |
| WK-SCP0125-0386 | D1 | G-32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-32: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-32) |
| WK-SCP0125-0387 | D1 | G-33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-33: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-33) |
| WK-SCP0125-0388 | D1 | G-35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-35: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-35) |
| WK-SCP0125-0389 | D1 | G-36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-36: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-36) |
| WK-SCP0125-0390 | D1 | G-37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-37: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-37) |
| WK-SCP0125-0391 | D1 | G-38 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-38: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-38) |
| WK-SCP0125-0392 | D1 | G-39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-39: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-39) |
| WK-SCP0125-0393 | D1 | Lock 계열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Lock 계열: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열) |
| WK-SCP0125-0394 | D1 | P-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — P-02: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (P-02) |
| WK-SCP0125-0395 | D1 | P-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — P-03: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (P-03) |
| WK-SCP0125-0396 | D1 | P-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — P-10: 행 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (P-10) |
| WK-SCP0125-0397 | D1 | SCP0125_Workbench.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0125_Workbench.EditButton: 진입점 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.EditButton:516:2 A) |
| WK-SCP0125-0398 | D3 | 0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 0: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (0) |
| WK-SCP0125-0399 | D3 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 9: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0125-0400 | D3 | C-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — C-14: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (C-14) |
| WK-SCP0125-0401 | D3 | C-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — C-15: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (C-15) |
| WK-SCP0125-0402 | D3 | C-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — C-16: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (C-16) |
| WK-SCP0125-0403 | D3 | C-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — C-21: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (C-21) |
| WK-SCP0125-0404 | D3 | D-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D-06: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-06) |
| WK-SCP0125-0405 | D3 | D-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D-07: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-07) |
| WK-SCP0125-0406 | D3 | D-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D-12: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-12) |
| WK-SCP0125-0407 | D3 | D-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D-13: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-13) |
| WK-SCP0125-0408 | D3 | D-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D-16: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-16) |
| WK-SCP0125-0409 | D3 | D-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D-17: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D-17) |
| WK-SCP0125-0410 | D3 | E-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E-03: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (E-03) |
| WK-SCP0125-0411 | D3 | E-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E-05: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (E-05) |
| WK-SCP0125-0412 | D3 | G-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-11: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-11) |
| WK-SCP0125-0413 | D3 | G-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-12: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-12) |
| WK-SCP0125-0414 | D3 | G-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-18: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-18) |
| WK-SCP0125-0415 | D3 | G-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-19: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-19) |
| WK-SCP0125-0416 | D3 | G-20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-20: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-20) |
| WK-SCP0125-0417 | D3 | G-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-21: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-21) |
| WK-SCP0125-0418 | D3 | G-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-22: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-22) |
| WK-SCP0125-0419 | D3 | G-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-24: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-24) |
| WK-SCP0125-0420 | D3 | G-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-25: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-25) |
| WK-SCP0125-0421 | D3 | G-26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-26: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-26) |
| WK-SCP0125-0422 | D3 | G-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-27: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-27) |
| WK-SCP0125-0423 | D3 | G-28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-28: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-28) |
| WK-SCP0125-0424 | D3 | G-30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-30: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-30) |
| WK-SCP0125-0425 | D3 | G-31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-31: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-31) |
| WK-SCP0125-0426 | D3 | G-32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-32: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-32) |
| WK-SCP0125-0427 | D3 | G-33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-33: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-33) |
| WK-SCP0125-0428 | D3 | G-35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-35: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-35) |
| WK-SCP0125-0429 | D3 | G-36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-36: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-36) |
| WK-SCP0125-0430 | D3 | G-37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-37: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-37) |
| WK-SCP0125-0431 | D3 | G-38 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-38: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-38) |
| WK-SCP0125-0432 | D3 | G-39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-39: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (G-39) |
| WK-SCP0125-0433 | D3 | Lock 계열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Lock 계열: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열) |
| WK-SCP0125-0434 | D3 | P-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — P-02: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (P-02) |
| WK-SCP0125-0435 | D3 | P-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — P-03: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (P-03) |
| WK-SCP0125-0436 | D3 | P-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — P-10: 행 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (P-10) |
| WK-SCP0125-0437 | D3 | SCP0125_Workbench.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0125_Workbench.EditButton: 진입점 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.EditButton:516:2 A) |
| WK-SCP0125-0438 | D4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 4: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0125-0439 | D4 | B-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-01: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-01) |
| WK-SCP0125-0440 | D4 | B-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-02: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-02) |
| WK-SCP0125-0441 | D4 | B-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-03: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-03) |
| WK-SCP0125-0442 | D4 | B-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-06: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-06) |
| WK-SCP0125-0443 | D4 | B-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-08: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-08) |
| WK-SCP0125-0444 | D4 | B-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-09: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-09) |
| WK-SCP0125-0445 | D4 | B-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-10: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-10) |
| WK-SCP0125-0446 | D4 | B-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-11: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-11) |
| WK-SCP0125-0447 | D4 | B-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-12: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-12) |
| WK-SCP0125-0448 | D4 | B-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-13: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-13) |
| WK-SCP0125-0449 | D4 | B-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-15: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-15) |
| WK-SCP0125-0450 | D4 | B-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-16: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-16) |
| WK-SCP0125-0451 | D4 | B-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B-18: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (B-18) |
| WK-SCP0125-0452 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0125-0453 | D4 | D-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D-12: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D-12) |
| WK-SCP0125-0454 | D4 | F-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — F-10: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (F-10) |
| WK-SCP0125-0455 | D4 | F-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — F-11: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (F-11) |
| WK-SCP0125-0456 | D4 | F-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — F-12: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (F-12) |
| WK-SCP0125-0457 | D4 | G-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — G-15: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (G-15) |
| WK-SCP0125-0458 | D4 | G-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — G-17: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (G-17) |
| WK-SCP0125-0459 | D4 | G-23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — G-23: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (G-23) |
| WK-SCP0125-0460 | D4 | G-29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — G-29: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (G-29) |
| WK-SCP0125-0461 | D4 | G-34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — G-34: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (G-34) |
| WK-SCP0125-0462 | D4 | P-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — P-02: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (P-02) |
| WK-SCP0125-0463 | D4 | SetValue Auto-Sync | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — SetValue Auto-Sync: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SetValue Auto-Sync) |
| WK-SCP0125-0464 | D5 | E-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — E-05: 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E-05) |
| WK-SCP0125-0465 | D5 | SCP0125_Workbench.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0125_Workbench.CreateSpread: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCP0125_Workbench.CreateSpread:312:1) |
| WK-SCP0125-0466 | D5 | SCP0125_Workbench.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0125_Workbench.SetSpreadInit: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0125_Workbench.SetSpreadInit:416:) |
| WK-SCP0125-0467 | D5 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — 셀 타입 콤보: 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0125-0468 | E1 | D-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D-16: 행 집계 — E1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D-16) |
| WK-SCP0125-0469 | E1 | E-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — E-07: 행 집계 — E1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (E-07) |
| WK-SCP0125-0470 | E1 | P-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — P-12: 행 집계 — E1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (P-12) |
| WK-SCP0125-0471 | E2 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — 1: 행 집계 — E2 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0125-0472 | E2 | 3.1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — 3.1: 행 집계 — E2 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (3.1) |
| WK-SCP0125-0473 | E2 | F-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — F-09: 행 집계 — E2 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (F-09) |
| WK-SCP0125-0474 | E2 | F-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — F-11: 행 집계 — E2 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (F-11) |
| WK-SCP0125-0475 | E2 | F-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — F-12: 행 집계 — E2 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (F-12) |
| WK-SCP0125-0476 | E4 | 0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 0: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (0) |
| WK-SCP0125-0477 | E4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 7: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0125-0478 | E4 | F-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — F-13: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (F-13) |
| WK-SCP0125-0479 | E4 | F-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — F-14: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (F-14) |
| WK-SCP0125-0480 | E4 | F-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — F-15: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (F-15) |
| WK-SCP0125-0481 | E4 | F-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — F-16: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (F-16) |
| WK-SCP0125-0482 | E4 | F-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — F-17: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (F-17) |
| WK-SCP0125-0483 | E4 | F-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — F-19: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (F-19) |
| WK-SCP0125-0484 | E4 | SCP0125_Workbench.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0125_Workbench.SetChangedControl: 진입점 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0125_Workbench.SetChangedControl:) |
| WK-SCP0125-0485 | E4 | SCP0125_Workbench.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0125_Workbench.SetSpreadInit: 진입점 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0125_Workbench.SetSpreadInit:416:) |
| WK-SCP0125-0486 | E4 | SCP0125_Workbench.SetVisibleSheetColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0125_Workbench.SetVisibleSheetColumns: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.SetVisibleSheetCol) |
| WK-SCP0125-0487 | E5 | E-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — E-05: 행 집계 — E5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (E-05) |
| WK-SCP0125-0488 | E5 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — 셀 타입 콤보: 행 집계 — E5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0125-0489 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (1) |
| WK-SCP0125-0490 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (4) |
| WK-SCP0125-0491 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (8) |
| WK-SCP0125-0492 | A1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (9) |
| WK-SCP0125-0493 | A1 | C-23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — C-23: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (C-23) |
| WK-SCP0125-0494 | A1 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-01: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (COMMON:UC-01) |
| WK-SCP0125-0495 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (COMMON:UC-02) |
| WK-SCP0125-0496 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (COMMON:UC-07) |
| WK-SCP0125-0497 | A1 | D-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D-15: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (D-15) |
| WK-SCP0125-0498 | A1 | F-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F-09: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (F-09) |
| WK-SCP0125-0499 | A1 | G-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G-08: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (G-08) |
| WK-SCP0125-0500 | A1 | P-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-01: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (P-01) |
| WK-SCP0125-0501 | A1 | PKG_SCP0125.P_SCP0125_GET_MKT_FCST_ADJ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0125.P_SCP0125_GET_MKT_FCST_ADJ: 골든 비교 케이스 없음(PKG_SCP0125.P_SCP0125_GET_MKT_FCST_ADJ — 팝업·보조 SP 는 golden_cases. |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0502 | A1 | PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ: 골든 비교 케이스 없음(PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ — 팝업·보조 SP 는 golden_cases.csv 에  |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0503 | A1 | PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ_UC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ_UC: 골든 비교 케이스 없음(PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ_UC — 팝업·보조 SP 는 golden_cases. |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0504 | A1 | PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_PLN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_PLNT: 골든 비교 케이스 없음(PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_PLNT — 팝업·보조 SP 는 golden_ |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0505 | A1 | PKG_SCP0125.P_SCP0125_GET_STOCK_SECOND_O | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0125.P_SCP0125_GET_STOCK_SECOND_OCV: 골든 비교 케이스 없음(PKG_SCP0125.P_SCP0125_GET_STOCK_SECOND_OCV — 팝업·보조 SP 는 golde |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0506 | A1 | SCP0125_GET_MKT_FCST_ELEC_DEMAND | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0125_GET_MKT_FCST_ELEC_DEMAND: 골든 비교 케이스 없음(SCP0125_GET_MKT_FCST_ELEC_DEMAND — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0507 | A1 | SCP0125_GET_STOCK_ELEC_PLNT_UC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0125_GET_STOCK_ELEC_PLNT_UC: 골든 비교 케이스 없음(SCP0125_GET_STOCK_ELEC_PLNT_UC — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미 |  | 80 (ACT:SCP0125_Workbench.FindButton ACT:SCP) |
| WK-SCP0125-0508 | A1 | U-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — U-07: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (U-07) |
| WK-SCP0125-0509 | A6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 4: 행 집계 — A6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0125-0510 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0125-0511 | G1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 4: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0125-0512 | G1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 8: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0125-0513 | G1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 9: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0125-0514 | G1 | C-23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — C-23: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (C-23) |
| WK-SCP0125-0515 | G1 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-01: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0125-0516 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0125-0517 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0125-0518 | G1 | D-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D-15: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D-15) |
| WK-SCP0125-0519 | G1 | F-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F-09: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (F-09) |
| WK-SCP0125-0520 | G1 | G-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — G-08: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G-08) |
| WK-SCP0125-0521 | G1 | P-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — P-01: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (P-01) |
| WK-SCP0125-0522 | G1 | U-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — U-07: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (U-07) |
| WK-SCP0125-0523 | G6 | C-23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — C-23: 행 집계 — G6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (C-23) |
| WK-SCP0125-0524 | G6 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-01: 행 집계 — G6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0125-0525 | G6 | D-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D-15: 행 집계 — G6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D-15) |
| WK-SCP0125-0526 | G6 | U-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — U-07: 행 집계 — G6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (U-07) |
| WK-SCP0125-0527 | X-LOC | 0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 0: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (0) |
| WK-SCP0125-0528 | X-LOC | 0' | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 0': 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (0') |
| WK-SCP0125-0529 | X-LOC | 3.1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3.1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3.1) |
| WK-SCP0125-0530 | X-LOC | 3.2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3.2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3.2) |
| WK-SCP0125-0531 | X-LOC | 6' | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6': 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6') |
| WK-SCP0125-0532 | X-LOC | 권한 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 권한: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (권한) |
| WK-SCP0125-0533 | X-LOC | 영역1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 영역1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (영역1) |
| WK-SCP0125-0534 | X-ROW | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (2) |
| WK-SCP0125-0535 | X-ROW | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (6) |
| WK-SCP0125-0536 | X-ROW | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 7: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (7) |
| WK-SCP0125-0537 | X-ROW | C-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-01) |
| WK-SCP0125-0538 | X-ROW | C-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-02) |
| WK-SCP0125-0539 | X-ROW | C-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-03) |
| WK-SCP0125-0540 | X-ROW | C-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-04: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-04) |
| WK-SCP0125-0541 | X-ROW | C-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-06) |
| WK-SCP0125-0542 | X-ROW | C-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-12) |
| WK-SCP0125-0543 | X-ROW | C-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-13: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-13) |
| WK-SCP0125-0544 | X-ROW | C-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-19: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-19) |
| WK-SCP0125-0545 | X-ROW | C-20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-20: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-20) |
| WK-SCP0125-0546 | X-ROW | D-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-05: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-05) |
| WK-SCP0125-0547 | X-ROW | D-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-08) |
| WK-SCP0125-0548 | X-ROW | D-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-09) |
| WK-SCP0125-0549 | X-ROW | D-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-10) |
| WK-SCP0125-0550 | X-ROW | D-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-11) |
| WK-SCP0125-0551 | X-ROW | F-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-02) |
| WK-SCP0125-0552 | X-ROW | F-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-03) |
| WK-SCP0125-0553 | X-ROW | F-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-04: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-04) |
| WK-SCP0125-0554 | X-ROW | F-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-05: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-05) |
| WK-SCP0125-0555 | X-ROW | F-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-06) |
| WK-SCP0125-0556 | X-ROW | F-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-07) |
| WK-SCP0125-0557 | X-ROW | F-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-08) |
| WK-SCP0125-0558 | X-ROW | F-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-18: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-18) |
| WK-SCP0125-0559 | X-ROW | F-20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-20: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-20) |
| WK-SCP0125-0560 | X-ROW | F-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-21) |
| WK-SCP0125-0561 | X-ROW | F-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-22: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-22) |
| WK-SCP0125-0562 | X-ROW | F-23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-23: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-23) |
| WK-SCP0125-0563 | X-ROW | F-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-24: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-24) |
| WK-SCP0125-0564 | X-ROW | F-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-25: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-25) |
| WK-SCP0125-0565 | X-ROW | F-26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-26: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-26) |
| WK-SCP0125-0566 | X-ROW | F-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — F-27: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (F-27) |
| WK-SCP0125-0567 | X-ROW | G-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G-01) |
| WK-SCP0125-0568 | X-ROW | G-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G-02) |
| WK-SCP0125-0569 | X-ROW | G-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G-03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G-03) |
| WK-SCP0125-0570 | X-ROW | G-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G-04: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G-04) |
| WK-SCP0125-0571 | X-ROW | G-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G-05: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G-05) |
| WK-SCP0125-0572 | X-ROW | P-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — P-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (P-08) |
| WK-SCP0125-0573 | X-ROW | P-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — P-09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (P-09) |
| WK-SCP0125-0574 | X-ROW | SCP0125_Workbench.CboPlanDate_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.CboPlanDate_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0125_Workbench.CboPlanDate_Select) |
| WK-SCP0125-0575 | X-ROW | SCP0125_Workbench.ClbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.ClbDivision_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0125_Workbench.ClbDivision_Select) |
| WK-SCP0125-0576 | X-ROW | SCP0125_Workbench.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0125_Workbench.CreateSpread) |
| WK-SCP0125-0577 | X-ROW | SCP0125_Workbench.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.FindButton: 진입점 집계 21검사 — NOT_RUN:14 · REVIEW:7 |  | 1 (ACT:SCP0125_Workbench.FindButton) |
| WK-SCP0125-0578 | X-ROW | SCP0125_Workbench.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.FindData_Main: 진입점 집계 34검사 — NOT_RUN:20 · REVIEW:7 · PASS:5 · NOPATH:2 |  | 11 (ACT:SCP0125_Workbench.FindData_Main:536:) |
| WK-SCP0125-0579 | X-ROW | SCP0125_Workbench.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0125_Workbench.Form_Load) |
| WK-SCP0125-0580 | X-ROW | SCP0125_Workbench.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.GetSearchInfo: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.GetSearchInfo ACT:) |
| WK-SCP0125-0581 | X-ROW | SCP0125_Workbench.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0125_Workbench.InitControls:191:3) |
| WK-SCP0125-0582 | X-ROW | SCP0125_Workbench.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0125_Workbench.InitSpread ACT:SCP) |
| WK-SCP0125-0583 | X-ROW | SCP0125_Workbench.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0125_Workbench.InsertButton) |
| WK-SCP0125-0584 | X-ROW | SCP0125_Workbench.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.Insert_Row: 진입점 집계 24검사 — NOT_RUN:24 (미실행 검사가 남아 판정필요) |  | 62 (ACT:SCP0125_Workbench.Insert_Row ACT:SCP) |
| WK-SCP0125-0585 | X-ROW | SCP0125_Workbench.RefreshPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.RefreshPlanDate: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0125_Workbench.RefreshPlanDate AC) |
| WK-SCP0125-0586 | X-ROW | SCP0125_Workbench.RefreshSiteByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.RefreshSiteByDivision: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0125_Workbench.RefreshSiteByDivis) |
| WK-SCP0125-0587 | X-ROW | SCP0125_Workbench.RefreshVersionNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.RefreshVersionNo: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0125_Workbench.RefreshVersionNo A) |
| WK-SCP0125-0588 | X-ROW | SCP0125_Workbench.Save_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.Save_Data: 진입점 집계 33검사 — NOT_RUN:22 · PASS:7 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 508 (ACT:SCP0125_Workbench.Save_Data ACT:SCP0) |
| WK-SCP0125-0589 | X-ROW | SCP0125_Workbench.Save_SecondOcv | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.Save_SecondOcv: 진입점 집계 24검사 — NOT_RUN:16 · PASS:5 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 143 (ACT:SCP0125_Workbench.Save_SecondOcv ACT) |
| WK-SCP0125-0590 | X-ROW | SCP0125_Workbench.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0125_Workbench.SetChangedControl) |
| WK-SCP0125-0591 | X-ROW | SCP0125_Workbench.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0125_Workbench.SetSpreadInit) |
| WK-SCP0125-0592 | X-ROW | SCP0125_Workbench.SpdMain_ActiveSheetCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.SpdMain_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0125_Workbench.SpdMain_ActiveShee) |
| WK-SCP0125-0593 | X-ROW | SCP0125_Workbench.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.SpdMain_CellDoubleClick: 진입점 집계 18검사 — NOT_RUN:10 · NOPATH:5 · REVIEW:3 |  | 4 (ACT:SCP0125_Workbench.SpdMain_CellDouble) |
| WK-SCP0125-0594 | X-ROW | SCP0125_Workbench.SpdMain_ClipboardPaste | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.SpdMain_ClipboardPasted: 진입점 집계 17검사 — NOT_RUN:17 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0125_Workbench.SpdMain_ClipboardP) |
| WK-SCP0125-0595 | X-ROW | SCP0125_Workbench.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.SpdMain_ComboSelChange: 진입점 집계 33검사 — NOT_RUN:30 · REVIEW:3 |  | 4 (ACT:SCP0125_Workbench.SpdMain_ComboSelCh) |
| WK-SCP0125-0596 | X-ROW | SCP0125_Workbench.spdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.spdMain_CellClick: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 43 (ACT:SCP0125_Workbench.spdMain_CellClick ) |
| WK-SCP0125-0597 | X-ROW | SCP0125_Workbench.spdSub_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0125_Workbench.spdSub_ActiveSheetChanging: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0125_Workbench.spdSub_ActiveSheet) |
| WK-SCP0125-0598 | G5 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 9: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0125-0599 | G5 | E-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E-06: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (E-06) |
| WK-SCP0125-0600 | G5 | P-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — P-11: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (P-11) |
| WK-SCP0125-0601 | G5 | SCP0125_Workbench.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0125_Workbench.SpdMain_CellDoubleClick: 진입점 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0125_Workbench.SpdMain_CellDouble) |
| WK-SCP0125-0602 | H6 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 9: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0125-0603 | H6 | E-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E-06: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E-06) |
| WK-SCP0125-0604 | H6 | P-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — P-11: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (P-11) |
| WK-SCP0125-0605 | H6 | SCP0125_Workbench.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0125_Workbench.SpdMain_CellDoubleClick: 진입점 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0125_Workbench.SpdMain_CellDouble) |
| WK-SCP0125-0606 | M4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 9: 행 집계 — M4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0125-0607 | M4 | E-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E-06: 행 집계 — M4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E-06) |
| WK-SCP0125-0608 | M4 | P-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — P-11: 행 집계 — M4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (P-11) |
| WK-SCP0125-0609 | M4 | SCP0125_Workbench.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0125_Workbench.SpdMain_CellDoubleClick: 진입점 집계 — M4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0125_Workbench.SpdMain_CellDouble) |
