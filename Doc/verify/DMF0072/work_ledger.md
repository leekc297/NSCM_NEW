# 작업 원장 — DMF0072 · 2026-10-26 12:51

> 검사 인스턴스 379건 중 PASS·NA 19건 외 **360건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W4 | 검사기 구현 | 4 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 51 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 180 | 실행 → PASS |
| W7 | 기대값 확정 | 125 | 기대 확정 → PASS/FAIL |

- 담당: E2E 180 · 사람 판정 / AS-IS 원문 확인 → 재판정 125 · 하네스 55
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 33건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| F4 | DB |  |  |  |  |  | 42 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 33 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| E4 | EDIT |  |  |  |  |  | 22 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A1 | GEN |  |  |  |  |  |  | 23 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-ROW | GEN |  |  |  |  |  |  | 23 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A6 | GEN |  |  |  |  |  | 18 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C3 | CASCADE |  |  |  |  |  | 11 | 6 |  |  | 연쇄 자동 채움 |
| H2 | DESIGN |  |  |  |  |  | 14 | 2 |  |  | 배경·글자색 규칙 |
| X-LOC | GEN |  |  |  |  |  |  | 15 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| M4 | POPUP |  |  |  |  |  | 7 | 6 |  |  | 팝업 선택값 반영 |
| C2 | CASCADE |  |  |  |  |  | 6 | 4 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 6 | 4 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G1 | GEN |  |  |  |  |  | 5 | 5 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| B4 | COMBO |  |  |  |  | 6 |  | 3 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D1 | EDIT |  |  |  |  |  | 6 | 2 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 6 | 2 |  |  | 행 값 기반 조건부 잠금 |
| B3 | COMBO |  |  |  | 4 |  |  | 3 |  |  | 콤보 후보 정렬 = AS-IS |
| G5 | POPUP |  |  |  |  | 1 |  | 6 |  |  | 팝업 조건 연동(인자) |
| A5 | DESIGN |  |  |  |  |  | 3 | 4 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H6 | POPUP |  |  |  |  |  | 1 | 6 |  |  | 팝업 표준·열림 |
| C1 | CASCADE |  |  |  |  |  | 5 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G4 | DESIGN |  |  |  |  |  | 5 |  |  |  | 조회조건 표시·라벨·활성 |
| H5 | DESIGN |  |  |  |  |  | 3 | 2 |  |  | 라벨 명칭 |
| D5 | EDIT |  |  |  |  |  | 4 | 1 |  |  | 셀 에디터 유형 |
| G6 | GEN |  |  |  |  |  | 5 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B1 | COMBO |  |  |  |  | 4 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 4 |  |  |  |  | 콤보 후보 중복 없음 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W4 검사기 구현 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0072-0001 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0002 | B3 | END_CUSTOMER | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 END_CUSTOMER | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0003 | B3 | clbDivisions / Division / Divisions | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivisions / Division / Divisions | 있음(FE 소스) | 2 (ACT:DMF0072_NNMasterMapping.GetSpdTitle ) |
| WK-DMF0072-0004 | B3 | clbTeam / Team | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbTeam / Team | 있음(FE 소스) | 1 (ACT:DMF0072_NNMasterMapping.clbDivision_) |

## W5 검사기 연결 (51)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0072-0005 | B1 | COMPANY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL COMPANY_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0072_NNMasterMapping.InsertRow:55) |
| WK-DMF0072-0006 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0007 | B1 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0072_NNMasterMapping.InsertRow:57) |
| WK-DMF0072-0008 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0072_NNMasterMapping.InsertRow:57) |
| WK-DMF0072-0009 | B2 | COMPANY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL COMPANY_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0072_NNMasterMapping.InsertRow:55) |
| WK-DMF0072-0010 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0011 | B2 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0072_NNMasterMapping.InsertRow:57) |
| WK-DMF0072-0012 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0072_NNMasterMapping.InsertRow:57) |
| WK-DMF0072-0013 | B4 | COMPANY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COMPANY_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0072_NNMasterMapping.InsertRow:55) |
| WK-DMF0072-0014 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 6 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0015 | B4 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 5 (ACT:DMF0072_NNMasterMapping.InsertRow:57) |
| WK-DMF0072-0016 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0072_NNMasterMapping.InsertRow:57) |
| WK-DMF0072-0017 | B4 | clbDivisions / Division / Divisions | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivisions / Division / Divisions | 있음(FE 소스) | 2 (ACT:DMF0072_NNMasterMapping.GetSpdTitle ) |
| WK-DMF0072-0018 | B4 | clbTeam / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbTeam / Team | 있음(FE 소스) | 1 (ACT:DMF0072_NNMasterMapping.clbDivision_) |
| WK-DMF0072-0019 | F2 | DMF0072 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0072 화면 | 판단불가(대상 단위 SCREEN) | 192 (Save main ACT:DMF0072_NNMasterMapping.Sa) |
| WK-DMF0072-0020 | F6 | DMF0072 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0072 화면 | 판단불가(대상 단위 SCREEN) | 192 (Save main ACT:DMF0072_NNMasterMapping.Sa) |
| WK-DMF0072-0021 | DB-SYN | DMF0008_GET_MY_DIVISION_LIST | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0008_GET_MY_DIVISION_LIST | 없음(PROC_M 대응 없음) | 1 (division) |
| WK-DMF0072-0022 | DB-SYN | DMF0072_GET_NNMASTER_MAPPING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0072_GET_NNMASTER_MAPPING | 없음(PROC_M 대응 없음) | 4 (ACT:DMF0072_NNMasterMapping.FindData:473) |
| WK-DMF0072-0023 | DB-SYN | P_ACTIVE_FLAG | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_ACTIVE_FLAG | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0024 | DB-SYN | P_ACT_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_ACT_TYPE | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0025 | DB-SYN | P_COMPANY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_COMPANY_ID | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0026 | DB-SYN | P_CUST_FCST_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_CUST_FCST_TYPE | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0027 | DB-SYN | P_CUST_ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_CUST_ITEM_ID | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0028 | DB-SYN | P_CUST_PLANT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_CUST_PLANT | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0029 | DB-SYN | P_CUST_UNLOAD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_CUST_UNLOAD | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0030 | DB-SYN | P_DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DIVISION_ID | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0031 | DB-SYN | P_DMF0072_DATATYPE_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0072_DATATYPE_GET | 없음(PROC_M 대응 없음) | 1 (dataType) |
| WK-DMF0072-0032 | DB-SYN | P_DMF0072_DIVISION_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0072_DIVISION_GET | 없음(PROC_M 대응 없음) | 1 (division) |
| WK-DMF0072-0033 | DB-SYN | P_DMF0072_ENDCUST_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0072_ENDCUST_GET | 없음(PROC_M 대응 없음) | 1 (endCustomer) |
| WK-DMF0072-0034 | DB-SYN | P_DMF0072_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0072_GET | 없음(PROC_M 대응 없음) | 0 () |
| WK-DMF0072-0035 | DB-SYN | P_DMF0072_ITEM_POPUP_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0072_ITEM_POPUP_GET | 없음(PROC_M 대응 없음) | 1 (itemPopup) |
| WK-DMF0072-0036 | DB-SYN | P_DMF0072_PROJECT_POPUP_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0072_PROJECT_POPUP_GET | 없음(PROC_M 대응 없음) | 1 (projectPopup) |
| WK-DMF0072-0037 | DB-SYN | P_DMF0072_SALESSITE_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0072_SALESSITE_GET | 없음(PROC_M 대응 없음) | 1 (salesSite) |
| WK-DMF0072-0038 | DB-SYN | P_DMF0072_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0072_SAVE | 없음(PROC_M 대응 없음) | 1 (main) |
| WK-DMF0072-0039 | DB-SYN | P_DMF0072_TEAM_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0072_TEAM_GET | 없음(PROC_M 대응 없음) | 1 (team) |
| WK-DMF0072-0040 | DB-SYN | P_DOM_EXP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DOM_EXP | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0041 | DB-SYN | P_END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_END_CUSTOMER | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0042 | DB-SYN | P_FCST_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_FCST_TYPE | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0043 | DB-SYN | P_INCOTERMS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_INCOTERMS | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0044 | DB-SYN | P_MAPPING_ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_MAPPING_ITEM_ID | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0045 | DB-SYN | P_MAPPING_ITEM_ID_ORIGINAL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_MAPPING_ITEM_ID_ORIGINAL | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0046 | DB-SYN | P_MDM_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_MDM_CODE | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0047 | DB-SYN | P_PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PROJECT_CODE | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0048 | DB-SYN | P_SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCM_SITE_ID | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0049 | DB-SYN | P_SHIPTO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SHIPTO | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0050 | DB-SYN | P_SOLDTO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SOLDTO | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0051 | DB-SYN | P_USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_USER_ID | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0052 | DB-SYN | P_VALID_FROM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_VALID_FROM | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0053 | DB-SYN | P_VALID_TO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_VALID_TO | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0072_NNMasterMapping.SaveData:975) |
| WK-DMF0072-0054 | G03-WIRE | DMF0072 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0072 화면 | 판단불가(대상 단위 SCREEN) | 6 (ACT:DMF0072_NNMasterMapping..ctor ACT:DM) |
| WK-DMF0072-0055 | G5 | clbDivisions / Division / Divisions | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbDivisions / Division / Divisions | 있음(FE 소스) | 2 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |

## W6 검증 실행 (180)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0072-0056 | J2 | DMF0072 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0072 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 33 (Search Insert Delete Edit Save F3 sort F) |
| WK-DMF0072-0057 | C1 | clbDataTypeCode / DataType / Data Type C | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDataTypeCode / DataType / Data Type Code · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0058 | C1 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0059 | C1 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0060 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 5 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0061 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0062 | C2 | CUSTOMER_ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CUSTOMER_ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0063 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 38 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0064 | C2 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 27 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0065 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0066 | C2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:DMF0072_NNMasterMapping.clbDivision_) |
| WK-DMF0072-0067 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0068 | C3 | ACTIVE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ACTIVE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.InsertRow:58) |
| WK-DMF0072-0069 | C3 | CUSTOMER_ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CUSTOMER_ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0070 | C3 | DATA_TYPE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DATA_TYPE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0072_NNMasterMapping.InsertRow:55) |
| WK-DMF0072-0071 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 47 (ACT:DMF0072_NNMasterMapping.InsertRow:55) |
| WK-DMF0072-0072 | C3 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 30 (ACT:DMF0072_NNMasterMapping.SetChangeCon) |
| WK-DMF0072-0073 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:DMF0072_NNMasterMapping.InsertRow:58) |
| WK-DMF0072-0074 | C3 | MAPPING_ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MAPPING_ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:DMF0072_NNMasterMapping.FindData:505) |
| WK-DMF0072-0075 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 13 (ACT:DMF0072_NNMasterMapping.InsertRow:58) |
| WK-DMF0072-0076 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0077 | C3 | SHIPTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIPTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.InsertRow:56) |
| WK-DMF0072-0078 | C3 | SOLDTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SOLDTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.InsertRow:56) |
| WK-DMF0072-0079 | C6 | CUSTOMER_ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CUSTOMER_ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0080 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 38 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0081 | C6 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 27 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0082 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0083 | C6 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:DMF0072_NNMasterMapping.clbDivision_) |
| WK-DMF0072-0084 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0085 | G3 | DMF0072 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — DMF0072 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 1 (F6 condition) |
| WK-DMF0072-0086 | K-SA | DMF0072 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — DMF0072 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (F6 condition) |
| WK-DMF0072-0087 | K4 | DMF0072 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0072 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 23 (ACT:DMF0072_NNMasterMapping.btnModelType) |
| WK-DMF0072-0088 | F1 | DMF0072 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0072 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 196 (Delete Save main ACT:DMF0072_NNMasterMap) |
| WK-DMF0072-0089 | F5 | DMF0072 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0072 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 4 (Delete ACT:DMF0072_NNMasterMapping.Delet) |
| WK-DMF0072-0090 | F4 | DMF0008_GET_MY_DIVISION_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0008_GET_MY_DIVISION_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (division) |
| WK-DMF0072-0091 | F4 | DMF0072_GET_ITEM_POPUP_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0072_GET_ITEM_POPUP_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (itemPopup) |
| WK-DMF0072-0092 | F4 | DMF0072_GET_NNMASTER_MAPPING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0072_GET_NNMASTER_MAPPING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 207 (ACT:DMF0072_NNMasterMapping.FindButton A) |
| WK-DMF0072-0093 | F4 | DMF0072_GET_PROJECT_POPUP_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0072_GET_PROJECT_POPUP_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 1 (projectPopup) |
| WK-DMF0072-0094 | F4 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 207 (ACT:DMF0072_NNMasterMapping.FindButton A) |
| WK-DMF0072-0095 | F4 | PKG_DMF0072.P_DMF0072_GET_DATA_TYPE_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0072.P_DMF0072_GET_DATA_TYPE_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 1 (dataType) |
| WK-DMF0072-0096 | F4 | PKG_DMF0072.P_DMF0072_GET_END_CUSTOMER_L | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0072.P_DMF0072_GET_END_CUSTOMER_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 1 (endCustomer) |
| WK-DMF0072-0097 | F4 | PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 0 () |
| WK-DMF0072-0098 | F4 | PKG_DMF0072.P_DMF0072_GET_SALES_SITE_LIS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0072.P_DMF0072_GET_SALES_SITE_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 1 (salesSite) |
| WK-DMF0072-0099 | F4 | PKG_DMF0072.P_DMF0072_GET_TEAM_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0072.P_DMF0072_GET_TEAM_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 1 (team) |
| WK-DMF0072-0100 | F4 | PKG_DMF0072.P_DMF0072_SAVE_NNMASTER_MAPP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0072.P_DMF0072_SAVE_NNMASTER_MAPPING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 169 (main ACT:DMF0072_NNMasterMapping.SaveBut) |
| WK-DMF0072-0101 | F4 | P_ACTIVE_FLAG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_ACTIVE_FLAG · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0102 | F4 | P_ACT_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_ACT_TYPE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0103 | F4 | P_COMPANY_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_COMPANY_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0104 | F4 | P_CUST_FCST_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_CUST_FCST_TYPE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0105 | F4 | P_CUST_ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_CUST_ITEM_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0106 | F4 | P_CUST_PLANT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_CUST_PLANT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0107 | F4 | P_CUST_UNLOAD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_CUST_UNLOAD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0108 | F4 | P_DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DIVISION_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0109 | F4 | P_DMF0072_DATATYPE_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0072_DATATYPE_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (dataType) |
| WK-DMF0072-0110 | F4 | P_DMF0072_DIVISION_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0072_DIVISION_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (division) |
| WK-DMF0072-0111 | F4 | P_DMF0072_ENDCUST_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0072_ENDCUST_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (endCustomer) |
| WK-DMF0072-0112 | F4 | P_DMF0072_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0072_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-DMF0072-0113 | F4 | P_DMF0072_ITEM_POPUP_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0072_ITEM_POPUP_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (itemPopup) |
| WK-DMF0072-0114 | F4 | P_DMF0072_PROJECT_POPUP_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0072_PROJECT_POPUP_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (projectPopup) |
| WK-DMF0072-0115 | F4 | P_DMF0072_SALESSITE_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0072_SALESSITE_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (salesSite) |
| WK-DMF0072-0116 | F4 | P_DMF0072_SAVE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0072_SAVE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (main) |
| WK-DMF0072-0117 | F4 | P_DMF0072_TEAM_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0072_TEAM_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (team) |
| WK-DMF0072-0118 | F4 | P_DOM_EXP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DOM_EXP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0119 | F4 | P_END_CUSTOMER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_END_CUSTOMER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0120 | F4 | P_FCST_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_FCST_TYPE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0121 | F4 | P_INCOTERMS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_INCOTERMS · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0122 | F4 | P_MAPPING_ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_MAPPING_ITEM_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0123 | F4 | P_MAPPING_ITEM_ID_ORIGINAL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_MAPPING_ITEM_ID_ORIGINAL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0124 | F4 | P_MDM_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_MDM_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0125 | F4 | P_PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_PROJECT_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0126 | F4 | P_SCM_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCM_SITE_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0127 | F4 | P_SHIPTO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SHIPTO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0128 | F4 | P_SOLDTO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SOLDTO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0129 | F4 | P_USER_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_USER_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0130 | F4 | P_VALID_FROM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_VALID_FROM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0131 | F4 | P_VALID_TO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_VALID_TO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 166 (ACT:DMF0072_NNMasterMapping.SaveButton A) |
| WK-DMF0072-0132 | A5 | MAPPING_ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MAPPING_ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0133 | A5 | MAPPING_ITEM_ID_ORIGINAL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MAPPING_ITEM_ID_ORIGINAL · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective |  | 1 (ACT:DMF0072_NNMasterMapping.FindData:520) |
| WK-DMF0072-0134 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0072_NNMasterMapping.clbDivision_) |
| WK-DMF0072-0135 | G4 | clbDataTypeCode / DataType / Data Type C | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDataTypeCode / DataType / Data Type Code · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0136 | G4 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivisions / Division / Divisions · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0137 | G4 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0138 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0139 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0140 | H2 | ACTIVE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ACTIVE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:881) |
| WK-DMF0072-0141 | H2 | DATA_TYPE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DATA_TYPE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:790) |
| WK-DMF0072-0142 | H2 | DOM_EXP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DOM_EXP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:867) |
| WK-DMF0072-0143 | H2 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:796) |
| WK-DMF0072-0144 | H2 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:855) |
| WK-DMF0072-0145 | H2 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — I · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 18 (ACT:DMF0072_NNMasterMapping.SaveData:700) |
| WK-DMF0072-0146 | H2 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:861) |
| WK-DMF0072-0147 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.SaveData:700) |
| WK-DMF0072-0148 | H2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:843) |
| WK-DMF0072-0149 | H2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:849) |
| WK-DMF0072-0150 | H2 | SHIPTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:837) |
| WK-DMF0072-0151 | H2 | SOLDTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SOLDTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:831) |
| WK-DMF0072-0152 | H2 | VALID_END_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_END_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:708) |
| WK-DMF0072-0153 | H2 | VALID_START_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_START_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:DMF0072_NNMasterMapping.SaveData:704) |
| WK-DMF0072-0154 | H4 | DMF0072 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0072 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:DMF0072_NNMasterMapping.spdMain_TopC) |
| WK-DMF0072-0155 | H5 | MAPPING_ITEM_ID_ORIGINAL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MAPPING_ITEM_ID_ORIGINAL · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.FindData:520) |
| WK-DMF0072-0156 | H5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.clbDivision_) |
| WK-DMF0072-0157 | H5 | clbDivisions / Division / Divisions | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbDivisions / Division / Divisions · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실 |  | 2 (ACT:DMF0072_NNMasterMapping.CreateSpread) |
| WK-DMF0072-0158 | I1 | DMF0072 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0072 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 23 (ACT:DMF0072_NNMasterMapping.FindData:462) |
| WK-DMF0072-0159 | D1 | DATA_TYPE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DATA_TYPE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0072_NNMasterMapping.EditButton:2) |
| WK-DMF0072-0160 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0072_NNMasterMapping.EditButton A) |
| WK-DMF0072-0161 | D1 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.EditButton:2) |
| WK-DMF0072-0162 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0072_NNMasterMapping.EditButton A) |
| WK-DMF0072-0163 | D1 | MAPPING_ITEM_ID_ORIGINAL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MAPPING_ITEM_ID_ORIGINAL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.EditButton A) |
| WK-DMF0072-0164 | D1 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.InsertRow:56) |
| WK-DMF0072-0165 | D3 | DATA_TYPE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DATA_TYPE_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0072_NNMasterMapping.EditButton:2) |
| WK-DMF0072-0166 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0072_NNMasterMapping.EditButton A) |
| WK-DMF0072-0167 | D3 | LAST_UPDATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.EditButton:2) |
| WK-DMF0072-0168 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0072_NNMasterMapping.EditButton A) |
| WK-DMF0072-0169 | D3 | MAPPING_ITEM_ID_ORIGINAL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MAPPING_ITEM_ID_ORIGINAL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.EditButton A) |
| WK-DMF0072-0170 | D3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.InsertRow:56) |
| WK-DMF0072-0171 | D5 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:DMF0072_NNMasterMapping.InsertRow:55) |
| WK-DMF0072-0172 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0173 | D5 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.InsertRow:57) |
| WK-DMF0072-0174 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0072_NNMasterMapping.InsertRow:57) |
| WK-DMF0072-0175 | D6 | DMF0072 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0072 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 3 (Insert ACT:DMF0072_NNMasterMapping.Inser) |
| WK-DMF0072-0176 | E4 | ACTIVE_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ACTIVE_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:880) |
| WK-DMF0072-0177 | E4 | DATA_TYPE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DATA_TYPE_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0072_NNMasterMapping.SaveData:789) |
| WK-DMF0072-0178 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:DMF0072_NNMasterMapping.SetChangeCon) |
| WK-DMF0072-0179 | E4 | DOM_EXP | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DOM_EXP · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:866) |
| WK-DMF0072-0180 | E4 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0072_NNMasterMapping.SaveData:795) |
| WK-DMF0072-0181 | E4 | FCST_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FCST_TYPE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:854) |
| WK-DMF0072-0182 | E4 | I | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — I · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 17 (ACT:DMF0072_NNMasterMapping.SaveData:696) |
| WK-DMF0072-0183 | E4 | INCOTERMS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — INCOTERMS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:860) |
| WK-DMF0072-0184 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:872) |
| WK-DMF0072-0185 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 12 (ACT:DMF0072_NNMasterMapping.SaveData:696) |
| WK-DMF0072-0186 | E4 | MSG00017 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00017 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:101) |
| WK-DMF0072-0187 | E4 | MSG00020 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00020 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:980) |
| WK-DMF0072-0188 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:734) |
| WK-DMF0072-0189 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.FindData:462) |
| WK-DMF0072-0190 | E4 | MSG00105 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00105 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:750) |
| WK-DMF0072-0191 | E4 | MSG00106 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00106 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:758) |
| WK-DMF0072-0192 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:727) |
| WK-DMF0072-0193 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:993) |
| WK-DMF0072-0194 | E4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:842) |
| WK-DMF0072-0195 | E4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:848) |
| WK-DMF0072-0196 | E4 | SHIPTO_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SHIPTO_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:836) |
| WK-DMF0072-0197 | E4 | SOLDTO_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SOLDTO_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0072_NNMasterMapping.SaveData:830) |
| WK-DMF0072-0198 | A10 | DMF0072 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0072 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 36 (ACT:DMF0072_NNMasterMapping.DefineProper) |
| WK-DMF0072-0199 | A6 | DMF0008_GET_MY_DIVISION_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0008_GET_MY_DIVISION_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spe |  | 1 (division) |
| WK-DMF0072-0200 | A6 | DMF0072_GET_ITEM_POPUP_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0072_GET_ITEM_POPUP_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec |  | 1 (itemPopup) |
| WK-DMF0072-0201 | A6 | DMF0072_GET_NNMASTER_MAPPING | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0072_GET_NNMASTER_MAPPING · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spe |  | 42 (ACT:DMF0072_NNMasterMapping.FindButton A) |
| WK-DMF0072-0202 | A6 | DMF0072_GET_PROJECT_POPUP_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0072_GET_PROJECT_POPUP_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.s |  | 1 (projectPopup) |
| WK-DMF0072-0203 | A6 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 40 (ACT:DMF0072_NNMasterMapping.FindButton A) |
| WK-DMF0072-0204 | A6 | PKG_DMF0072.P_DMF0072_GET_DATA_TYPE_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0072.P_DMF0072_GET_DATA_TYPE_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (dataType) |
| WK-DMF0072-0205 | A6 | PKG_DMF0072.P_DMF0072_GET_END_CUSTOMER_L | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0072.P_DMF0072_GET_END_CUSTOMER_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조 |  | 1 (endCustomer) |
| WK-DMF0072-0206 | A6 | PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 0 () |
| WK-DMF0072-0207 | A6 | PKG_DMF0072.P_DMF0072_GET_SALES_SITE_LIS | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0072.P_DMF0072_GET_SALES_SITE_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 1 (salesSite) |
| WK-DMF0072-0208 | A6 | PKG_DMF0072.P_DMF0072_GET_TEAM_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0072.P_DMF0072_GET_TEAM_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 1 (team) |
| WK-DMF0072-0209 | A6 | P_DMF0072_DATATYPE_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0072_DATATYPE_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tra |  | 1 (dataType) |
| WK-DMF0072-0210 | A6 | P_DMF0072_DIVISION_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0072_DIVISION_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tra |  | 1 (division) |
| WK-DMF0072-0211 | A6 | P_DMF0072_ENDCUST_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0072_ENDCUST_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trac |  | 1 (endCustomer) |
| WK-DMF0072-0212 | A6 | P_DMF0072_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0072_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 0 () |
| WK-DMF0072-0213 | A6 | P_DMF0072_ITEM_POPUP_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0072_ITEM_POPUP_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 1 (itemPopup) |
| WK-DMF0072-0214 | A6 | P_DMF0072_PROJECT_POPUP_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0072_PROJECT_POPUP_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec |  | 1 (projectPopup) |
| WK-DMF0072-0215 | A6 | P_DMF0072_SALESSITE_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0072_SALESSITE_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tr |  | 1 (salesSite) |
| WK-DMF0072-0216 | A6 | P_DMF0072_TEAM_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0072_TEAM_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (team) |
| WK-DMF0072-0217 | G1 | clbDataTypeCode / DataType / Data Type C | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDataTypeCode / DataType / Data Type Code · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0072_NNMasterMapping.FindData ACT) |
| WK-DMF0072-0218 | G1 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisions / Division / Divisions · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0072_NNMasterMapping.FindData ACT) |
| WK-DMF0072-0219 | G1 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0072_NNMasterMapping.FindData ACT) |
| WK-DMF0072-0220 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0072_NNMasterMapping.FindData ACT) |
| WK-DMF0072-0221 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0072_NNMasterMapping.FindData ACT) |
| WK-DMF0072-0222 | G6 | clbDataTypeCode / DataType / Data Type C | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDataTypeCode / DataType / Data Type Code · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0223 | G6 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0224 | G6 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0225 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0226 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0227 | X-REOPEN | DMF0072 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0072 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:DMF0072_NNMasterMapping.Dispose ACT:) |
| WK-DMF0072-0228 | H6 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivisions / Division / Divisions · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0229 | M4 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0230 | M4 | MAPPING_ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MAPPING_ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 25 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0231 | M4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0232 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0233 | M4 | SHIPTO_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SHIPTO_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0234 | M4 | SOLDTO_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SOLDTO_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0235 | M4 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |

## W7 기대값 확정 (125)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0072-0236 | C2 | DMF0072_NNMasterMapping.clbDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0072_NNMasterMapping.clbDivision_SelectedIndexC: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 12 (ACT:DMF0072_NNMasterMapping.clbDivision_) |
| WK-DMF0072-0237 | C2 | DMF0072_NNMasterMapping.clbEndCustomer_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0072_NNMasterMapping.clbEndCustomer_SelectedInd: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0072_NNMasterMapping.clbEndCustom) |
| WK-DMF0072-0238 | C2 | DMF0072_NNMasterMapping.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0072_NNMasterMapping.clbTeam_SelectedIndexChang: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0072_NNMasterMapping.clbTeam_Sele) |
| WK-DMF0072-0239 | C2 | DMF0072_NNMasterMapping.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0072_NNMasterMapping.spdMain_ComboSelChange: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0240 | C3 | DMF0072_NNMasterMapping.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0072_NNMasterMapping.SetChangeControl: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:DMF0072_NNMasterMapping.SetChangeCon) |
| WK-DMF0072-0241 | C3 | DMF0072_NNMasterMapping.SetLockRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0072_NNMasterMapping.SetLockRow: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0072_NNMasterMapping.SetLockRow:1) |
| WK-DMF0072-0242 | C3 | DMF0072_NNMasterMapping.clbDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0072_NNMasterMapping.clbDivision_SelectedIndexC: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 12 (ACT:DMF0072_NNMasterMapping.clbDivision_) |
| WK-DMF0072-0243 | C3 | DMF0072_NNMasterMapping.clbEndCustomer_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0072_NNMasterMapping.clbEndCustomer_SelectedInd: 진입점 집계 — C3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0072_NNMasterMapping.clbEndCustom) |
| WK-DMF0072-0244 | C3 | DMF0072_NNMasterMapping.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0072_NNMasterMapping.clbTeam_SelectedIndexChang: 진입점 집계 — C3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0072_NNMasterMapping.clbTeam_Sele) |
| WK-DMF0072-0245 | C3 | DMF0072_NNMasterMapping.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0072_NNMasterMapping.spdMain_ComboSelChange: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0246 | C6 | DMF0072_NNMasterMapping.clbDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0072_NNMasterMapping.clbDivision_SelectedIndexC: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 12 (ACT:DMF0072_NNMasterMapping.clbDivision_) |
| WK-DMF0072-0247 | C6 | DMF0072_NNMasterMapping.clbEndCustomer_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0072_NNMasterMapping.clbEndCustomer_SelectedInd: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0072_NNMasterMapping.clbEndCustom) |
| WK-DMF0072-0248 | C6 | DMF0072_NNMasterMapping.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0072_NNMasterMapping.clbTeam_SelectedIndexChang: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0072_NNMasterMapping.clbTeam_Sele) |
| WK-DMF0072-0249 | C6 | DMF0072_NNMasterMapping.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0072_NNMasterMapping.spdMain_ComboSelChange: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0250 | B3 | DMF0072_NNMasterMapping.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0072_NNMasterMapping.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0072_NNMasterMapping.GetSpdTitle:) |
| WK-DMF0072-0251 | B3 | dataType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — dataType: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (dataType) |
| WK-DMF0072-0252 | B3 | salesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — salesSite: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (salesSite) |
| WK-DMF0072-0253 | B4 | DMF0072_NNMasterMapping.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0072_NNMasterMapping.GetSpdTitle: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0072_NNMasterMapping.GetSpdTitle:) |
| WK-DMF0072-0254 | B4 | dataType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — dataType: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (dataType) |
| WK-DMF0072-0255 | B4 | salesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — salesSite: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (salesSite) |
| WK-DMF0072-0256 | DB-SYN | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — Save: 행 집계 — DB-SYN 42요소: NOPATH:33 · PASS:9 (미실행 요소가 남아 판정필요) |  | 1 (Save) |
| WK-DMF0072-0257 | DB-SYN | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — Search: 행 집계 — DB-SYN 42요소: NOPATH:33 · PASS:9 (미실행 요소가 남아 판정필요) |  | 1 (Search) |
| WK-DMF0072-0258 | F4 | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — Save: 행 집계 — F4 42요소: NOT_RUN:42 (미실행 요소가 남아 판정필요) |  | 1 (Save) |
| WK-DMF0072-0259 | F4 | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — Search: 행 집계 — F4 42요소: NOT_RUN:42 (미실행 요소가 남아 판정필요) |  | 1 (Search) |
| WK-DMF0072-0260 | A5 | DMF0072_NNMasterMapping.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0072_NNMasterMapping.CreateSpread: 진입점 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0072_NNMasterMapping.CreateSpread) |
| WK-DMF0072-0261 | A5 | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Excel: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Excel) |
| WK-DMF0072-0262 | A5 | Manual | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Manual: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Manual) |
| WK-DMF0072-0263 | A5 | Upload | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Upload: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Upload) |
| WK-DMF0072-0264 | H2 | DMF0072_NNMasterMapping.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0072_NNMasterMapping.CreateSpread: 진입점 집계 — H2 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0072_NNMasterMapping.CreateSpread) |
| WK-DMF0072-0265 | H2 | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Excel: 행 집계 — H2 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Excel) |
| WK-DMF0072-0266 | H5 | DMF0072_NNMasterMapping.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0072_NNMasterMapping.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0072_NNMasterMapping.CreateSpread) |
| WK-DMF0072-0267 | H5 | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Excel: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Excel) |
| WK-DMF0072-0268 | D1 | DMF0072_NNMasterMapping.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DMF0072_NNMasterMapping.EditButton: 진입점 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0072_NNMasterMapping.EditButton:2) |
| WK-DMF0072-0269 | D1 | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Edit) |
| WK-DMF0072-0270 | D3 | DMF0072_NNMasterMapping.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DMF0072_NNMasterMapping.EditButton: 진입점 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0072_NNMasterMapping.EditButton:2) |
| WK-DMF0072-0271 | D3 | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Edit) |
| WK-DMF0072-0272 | D5 | DMF0072_NNMasterMapping.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0072_NNMasterMapping.CreateSpread: 진입점 집계 — D5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0072_NNMasterMapping.CreateSpread) |
| WK-DMF0072-0273 | E4 | DMF0072_NNMasterMapping.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0072_NNMasterMapping.SetChangeControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:DMF0072_NNMasterMapping.SetChangeCon) |
| WK-DMF0072-0274 | E4 | DMF0072_NNMasterMapping.SetLockRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0072_NNMasterMapping.SetLockRow: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0072_NNMasterMapping.SetLockRow:1) |
| WK-DMF0072-0275 | E4 | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — Save: 행 집계 — E4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (Save) |
| WK-DMF0072-0276 | A1 | DMF0008_GET_MY_DIVISION_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0008_GET_MY_DIVISION_LIST: 골든 비교 케이스 없음(DMF0008_GET_MY_DIVISION_LIST — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 1 (division) |
| WK-DMF0072-0277 | A1 | DMF0072_GET_ITEM_POPUP_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0072_GET_ITEM_POPUP_LIST: 골든 비교 케이스 없음(DMF0072_GET_ITEM_POPUP_LIST — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 |  | 1 (itemPopup) |
| WK-DMF0072-0278 | A1 | DMF0072_GET_NNMASTER_MAPPING | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0072_GET_NNMASTER_MAPPING: 골든 비교 케이스 없음(DMF0072_GET_NNMASTER_MAPPING — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 42 (ACT:DMF0072_NNMasterMapping.FindButton A) |
| WK-DMF0072-0279 | A1 | DMF0072_GET_PROJECT_POPUP_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0072_GET_PROJECT_POPUP_LIST: 골든 비교 케이스 없음(DMF0072_GET_PROJECT_POPUP_LIST — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미 |  | 1 (projectPopup) |
| WK-DMF0072-0280 | A1 | F10 resetCondition | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F10 resetCondition: 행 집계 — A1 18요소: REVIEW:18 |  | 1 (F10 resetCondition) |
| WK-DMF0072-0281 | A1 | F3 sort | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F3 sort: 행 집계 — A1 18요소: REVIEW:18 |  | 1 (F3 sort) |
| WK-DMF0072-0282 | A1 | F4 filter | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F4 filter: 행 집계 — A1 18요소: REVIEW:18 |  | 1 (F4 filter) |
| WK-DMF0072-0283 | A1 | F6 condition | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F6 condition: 행 집계 — A1 18요소: REVIEW:18 |  | 1 (F6 condition) |
| WK-DMF0072-0284 | A1 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE — 팝업·보조 SP 는 |  | 40 (ACT:DMF0072_NNMasterMapping.FindButton A) |
| WK-DMF0072-0285 | A1 | PKG_DMF0072.P_DMF0072_GET_DATA_TYPE_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0072.P_DMF0072_GET_DATA_TYPE_LIST: 골든 비교 케이스 없음(PKG_DMF0072.P_DMF0072_GET_DATA_TYPE_LIST — 팝업·보조 SP 는 golden_ca |  | 1 (dataType) |
| WK-DMF0072-0286 | A1 | PKG_DMF0072.P_DMF0072_GET_END_CUSTOMER_L | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0072.P_DMF0072_GET_END_CUSTOMER_LIST: 골든 비교 케이스 없음(PKG_DMF0072.P_DMF0072_GET_END_CUSTOMER_LIST — 팝업·보조 SP 는 gol |  | 1 (endCustomer) |
| WK-DMF0072-0287 | A1 | PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER: 골든 비교 케이스 없음(PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER —  |  | 0 () |
| WK-DMF0072-0288 | A1 | PKG_DMF0072.P_DMF0072_GET_SALES_SITE_LIS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0072.P_DMF0072_GET_SALES_SITE_LIST: 골든 비교 케이스 없음(PKG_DMF0072.P_DMF0072_GET_SALES_SITE_LIST — 팝업·보조 SP 는 golden_ |  | 1 (salesSite) |
| WK-DMF0072-0289 | A1 | PKG_DMF0072.P_DMF0072_GET_TEAM_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0072.P_DMF0072_GET_TEAM_LIST: 골든 비교 케이스 없음(PKG_DMF0072.P_DMF0072_GET_TEAM_LIST — 팝업·보조 SP 는 golden_cases.csv 에  |  | 1 (team) |
| WK-DMF0072-0290 | A1 | P_DMF0072_DATATYPE_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0072_DATATYPE_GET: 골든 비교 케이스 없음(P_DMF0072_DATATYPE_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (dataType) |
| WK-DMF0072-0291 | A1 | P_DMF0072_DIVISION_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0072_DIVISION_GET: 골든 비교 케이스 없음(P_DMF0072_DIVISION_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (division) |
| WK-DMF0072-0292 | A1 | P_DMF0072_ENDCUST_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0072_ENDCUST_GET: 골든 비교 케이스 없음(P_DMF0072_ENDCUST_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (endCustomer) |
| WK-DMF0072-0293 | A1 | P_DMF0072_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0072_GET: 골든 비교 케이스 없음(P_DMF0072_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-DMF0072-0294 | A1 | P_DMF0072_ITEM_POPUP_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0072_ITEM_POPUP_GET: 골든 비교 케이스 없음(P_DMF0072_ITEM_POPUP_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 1 (itemPopup) |
| WK-DMF0072-0295 | A1 | P_DMF0072_PROJECT_POPUP_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0072_PROJECT_POPUP_GET: 골든 비교 케이스 없음(P_DMF0072_PROJECT_POPUP_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 |  | 1 (projectPopup) |
| WK-DMF0072-0296 | A1 | P_DMF0072_SALESSITE_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0072_SALESSITE_GET: 골든 비교 케이스 없음(P_DMF0072_SALESSITE_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (salesSite) |
| WK-DMF0072-0297 | A1 | P_DMF0072_TEAM_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0072_TEAM_GET: 골든 비교 케이스 없음(P_DMF0072_TEAM_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (team) |
| WK-DMF0072-0298 | A1 | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Search: 행 집계 — A1 18요소: REVIEW:18 |  | 1 (Search) |
| WK-DMF0072-0299 | A6 | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — Search: 행 집계 — A6 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (Search) |
| WK-DMF0072-0300 | G1 | F10 resetCondition | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F10 resetCondition: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (F10 resetCondition) |
| WK-DMF0072-0301 | G1 | F3 sort | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F3 sort: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (F3 sort) |
| WK-DMF0072-0302 | G1 | F4 filter | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F4 filter: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (F4 filter) |
| WK-DMF0072-0303 | G1 | F6 condition | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F6 condition: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (F6 condition) |
| WK-DMF0072-0304 | G1 | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Search: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Search) |
| WK-DMF0072-0305 | X-LOC | CustomerModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CustomerModal: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CustomerModal) |
| WK-DMF0072-0306 | X-LOC | Delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Delete: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Delete) |
| WK-DMF0072-0307 | X-LOC | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Edit: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Edit) |
| WK-DMF0072-0308 | X-LOC | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Excel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Excel) |
| WK-DMF0072-0309 | X-LOC | F10 resetCondition | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — F10 resetCondition: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (F10 resetCondition) |
| WK-DMF0072-0310 | X-LOC | F3 sort | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — F3 sort: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (F3 sort) |
| WK-DMF0072-0311 | X-LOC | F4 filter | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — F4 filter: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (F4 filter) |
| WK-DMF0072-0312 | X-LOC | F6 condition | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — F6 condition: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (F6 condition) |
| WK-DMF0072-0313 | X-LOC | Insert | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Insert: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Insert) |
| WK-DMF0072-0314 | X-LOC | ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ItemByDivisionModal: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ItemByDivisionModal) |
| WK-DMF0072-0315 | X-LOC | Manual | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Manual: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Manual) |
| WK-DMF0072-0316 | X-LOC | ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ProjectByDivisionModal: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ProjectByDivisionModal) |
| WK-DMF0072-0317 | X-LOC | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Save: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Save) |
| WK-DMF0072-0318 | X-LOC | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Search: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Search) |
| WK-DMF0072-0319 | X-LOC | Upload | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Upload: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Upload) |
| WK-DMF0072-0320 | X-ROW | DMF0072_NNMasterMapping.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.CreateSpread: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0072_NNMasterMapping.CreateSpread) |
| WK-DMF0072-0321 | X-ROW | DMF0072_NNMasterMapping.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.DefineProperty: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0072_NNMasterMapping.DefineProper) |
| WK-DMF0072-0322 | X-ROW | DMF0072_NNMasterMapping.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 |  | 15 (ACT:DMF0072_NNMasterMapping.ExcelButton ) |
| WK-DMF0072-0323 | X-ROW | DMF0072_NNMasterMapping.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:DMF0072_NNMasterMapping.FindButton) |
| WK-DMF0072-0324 | X-ROW | DMF0072_NNMasterMapping.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.FindData: 진입점 집계 19검사 — NOT_RUN:15 · REVIEW:2 · NOPATH:1 · PASS:1 |  | 4 (ACT:DMF0072_NNMasterMapping.FindData:494) |
| WK-DMF0072-0325 | X-ROW | DMF0072_NNMasterMapping.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0072_NNMasterMapping.Form_Load) |
| WK-DMF0072-0326 | X-ROW | DMF0072_NNMasterMapping.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.InitControls: 진입점 집계 16검사 — NOT_RUN:16 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0072_NNMasterMapping.InitControls) |
| WK-DMF0072-0327 | X-ROW | DMF0072_NNMasterMapping.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0072_NNMasterMapping.InitSpread) |
| WK-DMF0072-0328 | X-ROW | DMF0072_NNMasterMapping.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0072_NNMasterMapping.InsertButton) |
| WK-DMF0072-0329 | X-ROW | DMF0072_NNMasterMapping.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.InsertRow: 진입점 집계 28검사 — NOT_RUN:19 · NOPATH:9 (미실행 검사가 남아 판정필요) |  | 31 (ACT:DMF0072_NNMasterMapping.InsertRow AC) |
| WK-DMF0072-0330 | X-ROW | DMF0072_NNMasterMapping.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.SaveData: 진입점 집계 89검사 — NOT_RUN:62 · NOPATH:25 · PASS:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0072_NNMasterMapping.SaveData:987) |
| WK-DMF0072-0331 | X-ROW | DMF0072_NNMasterMapping.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.SetChangeControl: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 4 (ACT:DMF0072_NNMasterMapping.SetChangeCon) |
| WK-DMF0072-0332 | X-ROW | DMF0072_NNMasterMapping.btnModelType_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.btnModelType_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0072_NNMasterMapping.btnModelType) |
| WK-DMF0072-0333 | X-ROW | DMF0072_NNMasterMapping.btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.btnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0072_NNMasterMapping.btnProject_C) |
| WK-DMF0072-0334 | X-ROW | DMF0072_NNMasterMapping.clbDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.clbDivision_SelectedIndexC: 진입점 집계 13검사 — NOT_RUN:8 · REVIEW:3 · NOPATH:1 · TODO:1 |  | 3 (ACT:DMF0072_NNMasterMapping.clbDivision_) |
| WK-DMF0072-0335 | X-ROW | DMF0072_NNMasterMapping.clbEndCustomer_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.clbEndCustomer_SelectedInd: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0072_NNMasterMapping.clbEndCustom) |
| WK-DMF0072-0336 | X-ROW | DMF0072_NNMasterMapping.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.clbTeam_SelectedIndexChang: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0072_NNMasterMapping.clbTeam_Sele) |
| WK-DMF0072-0337 | X-ROW | DMF0072_NNMasterMapping.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.spdMain_CellDoubleClick: 진입점 집계 17검사 — NOT_RUN:13 · REVIEW:3 · NOPATH:1 |  | 7 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0338 | X-ROW | DMF0072_NNMasterMapping.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.spdMain_ComboSelChange: 진입점 집계 35검사 — NOT_RUN:21 · NOPATH:9 · REVIEW:3 · TODO:2 |  | 12 (ACT:DMF0072_NNMasterMapping.spdMain_Comb) |
| WK-DMF0072-0339 | X-ROW | DMF0072_NNMasterMapping.spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.spdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0072_NNMasterMapping.spdMain_KeyU) |
| WK-DMF0072-0340 | X-ROW | DMF0072_NNMasterMapping.spdMain_TopChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0072_NNMasterMapping.spdMain_TopC) |
| WK-DMF0072-0341 | X-ROW | DMF0072_NNMasterMapping.umltModel_KeyDow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.umltModel_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0072_NNMasterMapping.umltModel_Ke) |
| WK-DMF0072-0342 | X-ROW | DMF0072_NNMasterMapping.umltProject_KeyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0072_NNMasterMapping.umltProject_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0072_NNMasterMapping.umltProject_) |
| WK-DMF0072-0343 | G5 | CustomerModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — CustomerModal: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (CustomerModal) |
| WK-DMF0072-0344 | G5 | DMF0072_NNMasterMapping.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0072_NNMasterMapping.spdMain_CellDoubleClick: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0345 | G5 | ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ItemByDivisionModal: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (ItemByDivisionModal) |
| WK-DMF0072-0346 | G5 | ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ProjectByDivisionModal: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (ProjectByDivisionModal) |
| WK-DMF0072-0347 | G5 | itemPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — itemPopup: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (itemPopup) |
| WK-DMF0072-0348 | G5 | projectPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — projectPopup: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (projectPopup) |
| WK-DMF0072-0349 | H6 | CustomerModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — CustomerModal: 행 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (CustomerModal) |
| WK-DMF0072-0350 | H6 | DMF0072_NNMasterMapping.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0072_NNMasterMapping.spdMain_CellDoubleClick: 진입점 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0351 | H6 | ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ItemByDivisionModal: 행 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ItemByDivisionModal) |
| WK-DMF0072-0352 | H6 | ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ProjectByDivisionModal: 행 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ProjectByDivisionModal) |
| WK-DMF0072-0353 | H6 | itemPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — itemPopup: 행 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (itemPopup) |
| WK-DMF0072-0354 | H6 | projectPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — projectPopup: 행 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (projectPopup) |
| WK-DMF0072-0355 | M4 | CustomerModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — CustomerModal: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (CustomerModal) |
| WK-DMF0072-0356 | M4 | DMF0072_NNMasterMapping.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0072_NNMasterMapping.spdMain_CellDoubleClick: 진입점 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0072_NNMasterMapping.spdMain_Cell) |
| WK-DMF0072-0357 | M4 | ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ItemByDivisionModal: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ItemByDivisionModal) |
| WK-DMF0072-0358 | M4 | ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ProjectByDivisionModal: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ProjectByDivisionModal) |
| WK-DMF0072-0359 | M4 | itemPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — itemPopup: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (itemPopup) |
| WK-DMF0072-0360 | M4 | projectPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — projectPopup: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (projectPopup) |
