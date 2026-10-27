# 작업 원장 — DMF0004 · 2026-10-26 12:49

> 검사 인스턴스 199건 중 PASS·NA 10건 외 **189건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 12 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 80 | 실행 → PASS |
| W7 | 기대값 확정 | 94 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 94 · E2E 80 · 하네스 15
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 5건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 42 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 18 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  | 3 | 12 |  |  | 연쇄 자동 채움 |
| F4 | DB |  |  |  |  |  | 11 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| C2 | CASCADE |  |  |  |  |  | 1 | 9 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 1 | 9 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G4 | DESIGN |  |  |  |  |  | 7 |  |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 7 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B3 | COMBO |  |  |  | 3 |  |  | 3 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 3 |  | 3 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | CASCADE |  |  |  |  |  | 6 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G1 | GEN |  |  |  |  |  | 6 |  |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| DB-SYN | DB |  |  |  |  | 5 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| A6 | GEN |  |  |  |  |  | 5 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| A1 | GEN |  |  |  |  |  |  | 5 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| D1 | EDIT |  |  |  |  |  | 3 | 1 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 3 | 1 |  |  | 행 값 기반 조건부 잠금 |
| G5 | POPUP |  |  |  |  | 1 |  | 2 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  |  | 1 | 2 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 1 | 2 |  |  | 팝업 선택값 반영 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0004-0001 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 6 (ACT:DMF0004_SalesSite.GetSoldToCustomerD) |
| WK-DMF0004-0002 | B3 | clbSoldToCustomer / Sold-To Customer / S | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbSoldToCustomer / Sold-To Customer / Sold To Cus | 있음(FE 소스) | 1 (ACT:DMF0004_SalesSite.clbSoldToCustomer_) |
| WK-DMF0004-0003 | B3 | clbTeam / Team | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbTeam / Team | 있음(FE 소스) | 2 (ACT:DMF0004_SalesSite.GetSoldToCustomerD) |

## W5 검사기 연결 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0004-0004 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 6 (ACT:DMF0004_SalesSite.GetSoldToCustomerD) |
| WK-DMF0004-0005 | B4 | clbSoldToCustomer / Sold-To Customer / S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbSoldToCustomer / Sold-To Customer / Sold To Cus | 있음(FE 소스) | 1 (ACT:DMF0004_SalesSite.clbSoldToCustomer_) |
| WK-DMF0004-0006 | B4 | clbTeam / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbTeam / Team | 있음(FE 소스) | 2 (ACT:DMF0004_SalesSite.GetSoldToCustomerD) |
| WK-DMF0004-0007 | F2 | DMF0004 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0004 화면 | 판단불가(대상 단위 SCREEN) | 176 (ACT:DMF0004_SalesSite.SaveButton ACT:DMF) |
| WK-DMF0004-0008 | F6 | DMF0004 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0004 화면 | 판단불가(대상 단위 SCREEN) | 176 (ACT:DMF0004_SalesSite.SaveButton ACT:DMF) |
| WK-DMF0004-0009 | DB-SYN | DMF0004_GET_SALES_SITE_BUCKET_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0004_GET_SALES_SITE_BUCKET_DATA | 없음(PROC_M 대응 없음) | 4 (ACT:DMF0004_SalesSite.FindData_SubBucket) |
| WK-DMF0004-0010 | DB-SYN | DMF0004_GET_SALES_SITE_CUSTOMER_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0004_GET_SALES_SITE_CUSTOMER_DATA | 없음(PROC_M 대응 없음) | 4 (ACT:DMF0004_SalesSite.FindData_SubCustom) |
| WK-DMF0004-0011 | DB-SYN | DMF0004_GET_SALES_SITE_LOCATION_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0004_GET_SALES_SITE_LOCATION_DATA | 없음(PROC_M 대응 없음) | 4 (ACT:DMF0004_SalesSite.FindData_SubLocati) |
| WK-DMF0004-0012 | DB-SYN | DMF0004_GET_SOLDTO_CUSTOMER_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0004_GET_SOLDTO_CUSTOMER_DATA | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0004_SalesSite.GetSoldToCustomerD) |
| WK-DMF0004-0013 | DB-SYN | SCM0001_GET_PLANT_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_PLANT_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0004_SalesSite.GetPlantbyDivision) |
| WK-DMF0004-0014 | G03-WIRE | DMF0004 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0004 화면 | 판단불가(대상 단위 SCREEN) | 12 (ACT:DMF0004_SalesSite..ctor ACT:DMF0004_) |
| WK-DMF0004-0015 | G5 | cboActive / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboActive / Active | 있음(FE 소스) | 2 (ACT:DMF0004_SalesSite.spdMain_CellDouble) |

## W6 검증 실행 (80)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0004-0016 | C1 | cboActive / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboActive / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0004_SalesSite.InitControls:370:2) |
| WK-DMF0004-0017 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0004_SalesSite.InitControls:327:2) |
| WK-DMF0004-0018 | C1 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (ACT:DMF0004_SalesSite.InitControls:340:8) |
| WK-DMF0004-0019 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 7 (ACT:DMF0004_SalesSite.InitControls:349:1) |
| WK-DMF0004-0020 | C1 | clbSoldToCustomer / Sold-To Customer / S | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSoldToCustomer / Sold-To Customer / Sold To Cus · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (ACT:DMF0004_SalesSite.InitControls:366:2) |
| WK-DMF0004-0021 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0004_SalesSite.InitControls:333:5) |
| WK-DMF0004-0022 | C2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0004_SalesSite.shtMainDataModel_C) |
| WK-DMF0004-0023 | C3 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0004_SalesSite.SetGridHeader:2203) |
| WK-DMF0004-0024 | C3 | S | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — S · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0004_SalesSite.InsertRow:1941:51 ) |
| WK-DMF0004-0025 | C3 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0004_SalesSite.SetSubBucketData A) |
| WK-DMF0004-0026 | C6 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0004_SalesSite.shtMainDataModel_C) |
| WK-DMF0004-0027 | F1 | DMF0004 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0004 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 182 (ACT:DMF0004_SalesSite.DeleteButton ACT:D) |
| WK-DMF0004-0028 | F5 | DMF0004 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0004 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 6 (ACT:DMF0004_SalesSite.DeleteButton ACT:D) |
| WK-DMF0004-0029 | F4 | DMF0004_GET_SALES_SITE_BUCKET_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0004_GET_SALES_SITE_BUCKET_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 50 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0030 | F4 | DMF0004_GET_SALES_SITE_CUSTOMER_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0004_GET_SALES_SITE_CUSTOMER_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 58 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0031 | F4 | DMF0004_GET_SALES_SITE_LOCATION_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0004_GET_SALES_SITE_LOCATION_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 53 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0032 | F4 | DMF0004_GET_SOLDTO_CUSTOMER_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0004_GET_SOLDTO_CUSTOMER_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:DMF0004_SalesSite.GetSoldToCustomerD) |
| WK-DMF0004-0033 | F4 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 300 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0034 | F4 | PKG_DMF0004.P_DMF0004_GET_SALES_SITE_DAT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0004.P_DMF0004_GET_SALES_SITE_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 228 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0035 | F4 | PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_BU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_BUCKET_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 13 (ACT:DMF0004_SalesSite.SaveButton ACT:DMF) |
| WK-DMF0004-0036 | F4 | PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_CU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_CUSTOMER_DAT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 13 (ACT:DMF0004_SalesSite.SaveButton ACT:DMF) |
| WK-DMF0004-0037 | F4 | PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_DA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 176 (ACT:DMF0004_SalesSite.SaveButton ACT:DMF) |
| WK-DMF0004-0038 | F4 | PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_LO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_LOCATION_DAT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 13 (ACT:DMF0004_SalesSite.SaveButton ACT:DMF) |
| WK-DMF0004-0039 | F4 | SCM0001_GET_PLANT_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_PLANT_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 2 (ACT:DMF0004_SalesSite.GetPlantbyDivision) |
| WK-DMF0004-0040 | G4 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboActive / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0041 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 10 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0042 | G4 | chkDetail / Detail | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkDetail / Detail · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0004_SalesSite.DefineProperty ACT) |
| WK-DMF0004-0043 | G4 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0044 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0045 | G4 | clbSoldToCustomer / Sold-To Customer / S | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSoldToCustomer / Sold-To Customer / Sold To Cus · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0046 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0047 | H4 | DMF0004 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0004 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 8 (ACT:DMF0004_SalesSite.spdMain_TopChange ) |
| WK-DMF0004-0048 | I1 | DMF0004 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0004 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 53 (ACT:DMF0004_SalesSite.EditButton:526:4 A) |
| WK-DMF0004-0049 | D1 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:DMF0004_SalesSite.EditButton ACT:DMF) |
| WK-DMF0004-0050 | D1 | S | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — S · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0004_SalesSite.EditButton:520:1) |
| WK-DMF0004-0051 | D1 | SHIP_PLAN_AUTO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIP_PLAN_AUTO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0004_SalesSite.EditButton:541:12 ) |
| WK-DMF0004-0052 | D3 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — D · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:DMF0004_SalesSite.EditButton ACT:DMF) |
| WK-DMF0004-0053 | D3 | S | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — S · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0004_SalesSite.EditButton:520:1) |
| WK-DMF0004-0054 | D3 | SHIP_PLAN_AUTO | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIP_PLAN_AUTO · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0004_SalesSite.EditButton:541:12 ) |
| WK-DMF0004-0055 | D6 | DMF0004 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0004 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (ACT:DMF0004_SalesSite.InsertButton ACT:D) |
| WK-DMF0004-0056 | E4 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — C · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0004_SalesSite.SetGridHeader:2203) |
| WK-DMF0004-0057 | E4 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — D · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0004_SalesSite.SaveSubBucketData:) |
| WK-DMF0004-0058 | E4 | I | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — I · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0004_SalesSite.SaveSubBucketData:) |
| WK-DMF0004-0059 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 22 (ACT:DMF0004_SalesSite.SaveData:1167:102 ) |
| WK-DMF0004-0060 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0004_SalesSite.SaveData:1338:161 ) |
| WK-DMF0004-0061 | E4 | MSG00005 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00005 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0004_SalesSite.SaveData:1356:164 ) |
| WK-DMF0004-0062 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0004_SalesSite.SaveSubLocationDat) |
| WK-DMF0004-0063 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0004_SalesSite.EditButton:600:32 ) |
| WK-DMF0004-0064 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0004_SalesSite.FindData_Main:790:) |
| WK-DMF0004-0065 | E4 | MSG00120 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00120 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0004_SalesSite.SaveSubCustomerDat) |
| WK-DMF0004-0066 | E4 | MSG00128 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00128 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0004_SalesSite.spdMain_CellDouble) |
| WK-DMF0004-0067 | E4 | MSG00129 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00129 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0004_SalesSite.spdSub_ActiveSheet) |
| WK-DMF0004-0068 | E4 | MSG00130 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00130 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0004_SalesSite.EditButton:526:4 A) |
| WK-DMF0004-0069 | E4 | MSG00149 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00149 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0004_SalesSite.shtSubCustomerData) |
| WK-DMF0004-0070 | E4 | MSG00179 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00179 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0004_SalesSite.SaveSubCustomerDat) |
| WK-DMF0004-0071 | E4 | S | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — S · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0004_SalesSite.SaveSubBucketData:) |
| WK-DMF0004-0072 | E4 | YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0004_SalesSite.SetSubBucketData A) |
| WK-DMF0004-0073 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 15 (ACT:DMF0004_SalesSite.SetGridHeader ACT:) |
| WK-DMF0004-0074 | A10 | DMF0004 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0004 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 61 (ACT:DMF0004_SalesSite.DefineProperty ACT) |
| WK-DMF0004-0075 | A6 | DMF0004_GET_SALES_SITE_BUCKET_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0004_GET_SALES_SITE_BUCKET_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tra |  | 38 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0076 | A6 | DMF0004_GET_SALES_SITE_CUSTOMER_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0004_GET_SALES_SITE_CUSTOMER_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 46 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0077 | A6 | DMF0004_GET_SALES_SITE_LOCATION_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0004_GET_SALES_SITE_LOCATION_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 41 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0078 | A6 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 121 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0079 | A6 | PKG_DMF0004.P_DMF0004_GET_SALES_SITE_DAT | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0004.P_DMF0004_GET_SALES_SITE_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 54 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0080 | G1 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboActive / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0081 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0004_SalesSite.FindData_Main ACT:) |
| WK-DMF0004-0082 | G1 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0004_SalesSite.FindData_Main ACT:) |
| WK-DMF0004-0083 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0004_SalesSite.FindData_Main ACT:) |
| WK-DMF0004-0084 | G1 | clbSoldToCustomer / Sold-To Customer / S | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSoldToCustomer / Sold-To Customer / Sold To Cus · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0004_SalesSite.FindData_Main ACT:) |
| WK-DMF0004-0085 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0004_SalesSite.FindData_Main ACT:) |
| WK-DMF0004-0086 | G6 | cboActive / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboActive / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0087 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0088 | G6 | chkDetail / Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkDetail / Detail · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0004_SalesSite.DefineProperty ACT) |
| WK-DMF0004-0089 | G6 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0090 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0091 | G6 | clbSoldToCustomer / Sold-To Customer / S | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSoldToCustomer / Sold-To Customer / Sold To Cus · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0092 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0004_SalesSite.InitControls ACT:D) |
| WK-DMF0004-0093 | X-REOPEN | DMF0004 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0004 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 15 (ACT:DMF0004_SalesSite.Dispose ACT:DMF000) |
| WK-DMF0004-0094 | H6 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboActive / Active · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:DMF0004_SalesSite.spdMain_CellDouble) |
| WK-DMF0004-0095 | M4 | cboActive / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboActive / Active · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0004_SalesSite.spdMain_CellDouble) |

## W7 기대값 확정 (94)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0004-0096 | C2 | DMF0004_SalesSite.cboDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0004_SalesSite.cboDivision_SelectedIndexChanged: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:DMF0004_SalesSite.cboDivision_Select) |
| WK-DMF0004-0097 | C2 | DMF0004_SalesSite.clbEndCustomer_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0004_SalesSite.clbEndCustomer_SelectedIndexChan: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0004_SalesSite.clbEndCustomer_Sel) |
| WK-DMF0004-0098 | C2 | DMF0004_SalesSite.clbSoldToCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0004_SalesSite.clbSoldToCustomer_SelectedIndexC: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.clbSoldToCustomer_) |
| WK-DMF0004-0099 | C2 | DMF0004_SalesSite.clbTeam_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0004_SalesSite.clbTeam_SelectedIndexChanged: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0004_SalesSite.clbTeam_SelectedIn) |
| WK-DMF0004-0100 | C2 | DMF0004_SalesSite.shtMainDataModel_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0004_SalesSite.shtMainDataModel_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0004_SalesSite.shtMainDataModel_C) |
| WK-DMF0004-0101 | C2 | DMF0004_SalesSite.shtSubBucketDataModel_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0004_SalesSite.shtSubBucketDataModel_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 37 (ACT:DMF0004_SalesSite.shtSubBucketDataMo) |
| WK-DMF0004-0102 | C2 | DMF0004_SalesSite.shtSubCustomerDataMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0004_SalesSite.shtSubCustomerDataModel_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:DMF0004_SalesSite.shtSubCustomerData) |
| WK-DMF0004-0103 | C2 | DMF0004_SalesSite.spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0004_SalesSite.spdMain_ComboSelChange: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0004_SalesSite.spdMain_ComboSelCh) |
| WK-DMF0004-0104 | C2 | DMF0004_SalesSite.spdSub_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0004_SalesSite.spdSub_ComboSelChange: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.spdSub_ComboSelCha) |
| WK-DMF0004-0105 | C3 | DMF0004_SalesSite.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.SetChangeControl: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0004_SalesSite.SetChangeControl:2) |
| WK-DMF0004-0106 | C3 | DMF0004_SalesSite.SetGridHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.SetGridHeader: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.SetGridHeader:2199) |
| WK-DMF0004-0107 | C3 | DMF0004_SalesSite.SetSubBucketData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.SetSubBucketData: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0004_SalesSite.SetSubBucketData:2) |
| WK-DMF0004-0108 | C3 | DMF0004_SalesSite.cboDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.cboDivision_SelectedIndexChanged: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 18 (ACT:DMF0004_SalesSite.cboDivision_Select) |
| WK-DMF0004-0109 | C3 | DMF0004_SalesSite.clbEndCustomer_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.clbEndCustomer_SelectedIndexChan: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0004_SalesSite.clbEndCustomer_Sel) |
| WK-DMF0004-0110 | C3 | DMF0004_SalesSite.clbSoldToCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.clbSoldToCustomer_SelectedIndexC: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.clbSoldToCustomer_) |
| WK-DMF0004-0111 | C3 | DMF0004_SalesSite.clbTeam_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.clbTeam_SelectedIndexChanged: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0004_SalesSite.clbTeam_SelectedIn) |
| WK-DMF0004-0112 | C3 | DMF0004_SalesSite.shtMainDataModel_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.shtMainDataModel_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0004_SalesSite.shtMainDataModel_C) |
| WK-DMF0004-0113 | C3 | DMF0004_SalesSite.shtSubBucketDataModel_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.shtSubBucketDataModel_Changed: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 37 (ACT:DMF0004_SalesSite.shtSubBucketDataMo) |
| WK-DMF0004-0114 | C3 | DMF0004_SalesSite.shtSubCustomerDataMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.shtSubCustomerDataModel_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:DMF0004_SalesSite.shtSubCustomerData) |
| WK-DMF0004-0115 | C3 | DMF0004_SalesSite.spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.spdMain_ComboSelChange: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0004_SalesSite.spdMain_ComboSelCh) |
| WK-DMF0004-0116 | C3 | DMF0004_SalesSite.spdSub_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0004_SalesSite.spdSub_ComboSelChange: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.spdSub_ComboSelCha) |
| WK-DMF0004-0117 | C6 | DMF0004_SalesSite.cboDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0004_SalesSite.cboDivision_SelectedIndexChanged: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:DMF0004_SalesSite.cboDivision_Select) |
| WK-DMF0004-0118 | C6 | DMF0004_SalesSite.clbEndCustomer_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0004_SalesSite.clbEndCustomer_SelectedIndexChan: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0004_SalesSite.clbEndCustomer_Sel) |
| WK-DMF0004-0119 | C6 | DMF0004_SalesSite.clbSoldToCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0004_SalesSite.clbSoldToCustomer_SelectedIndexC: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.clbSoldToCustomer_) |
| WK-DMF0004-0120 | C6 | DMF0004_SalesSite.clbTeam_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0004_SalesSite.clbTeam_SelectedIndexChanged: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0004_SalesSite.clbTeam_SelectedIn) |
| WK-DMF0004-0121 | C6 | DMF0004_SalesSite.shtMainDataModel_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0004_SalesSite.shtMainDataModel_Changed: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0004_SalesSite.shtMainDataModel_C) |
| WK-DMF0004-0122 | C6 | DMF0004_SalesSite.shtSubBucketDataModel_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0004_SalesSite.shtSubBucketDataModel_Changed: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 37 (ACT:DMF0004_SalesSite.shtSubBucketDataMo) |
| WK-DMF0004-0123 | C6 | DMF0004_SalesSite.shtSubCustomerDataMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0004_SalesSite.shtSubCustomerDataModel_Changed: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:DMF0004_SalesSite.shtSubCustomerData) |
| WK-DMF0004-0124 | C6 | DMF0004_SalesSite.spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0004_SalesSite.spdMain_ComboSelChange: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0004_SalesSite.spdMain_ComboSelCh) |
| WK-DMF0004-0125 | C6 | DMF0004_SalesSite.spdSub_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0004_SalesSite.spdSub_ComboSelChange: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.spdSub_ComboSelCha) |
| WK-DMF0004-0126 | B3 | DMF0004_SalesSite.GetPlantbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0004_SalesSite.GetPlantbyDivision: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0004_SalesSite.GetPlantbyDivision) |
| WK-DMF0004-0127 | B3 | DMF0004_SalesSite.GetSoldToCustomerData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0004_SalesSite.GetSoldToCustomerData: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.GetSoldToCustomerD) |
| WK-DMF0004-0128 | B3 | DMF0004_SalesSite.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0004_SalesSite.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0004_SalesSite.GetSpdTitle:2717:2) |
| WK-DMF0004-0129 | B4 | DMF0004_SalesSite.GetPlantbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0004_SalesSite.GetPlantbyDivision: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0004_SalesSite.GetPlantbyDivision) |
| WK-DMF0004-0130 | B4 | DMF0004_SalesSite.GetSoldToCustomerData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0004_SalesSite.GetSoldToCustomerData: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.GetSoldToCustomerD) |
| WK-DMF0004-0131 | B4 | DMF0004_SalesSite.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0004_SalesSite.GetSpdTitle: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0004_SalesSite.GetSpdTitle:2717:2) |
| WK-DMF0004-0132 | D1 | DMF0004_SalesSite.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DMF0004_SalesSite.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 60 (ACT:DMF0004_SalesSite.EditButton:522:2 A) |
| WK-DMF0004-0133 | D3 | DMF0004_SalesSite.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DMF0004_SalesSite.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 60 (ACT:DMF0004_SalesSite.EditButton:522:2 A) |
| WK-DMF0004-0134 | E4 | DMF0004_SalesSite.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0004_SalesSite.SetChangeControl: 진입점 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0004_SalesSite.SetChangeControl:2) |
| WK-DMF0004-0135 | E4 | DMF0004_SalesSite.SetGridHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0004_SalesSite.SetGridHeader: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.SetGridHeader:2199) |
| WK-DMF0004-0136 | E4 | DMF0004_SalesSite.SetSubBucketData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0004_SalesSite.SetSubBucketData: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0004_SalesSite.SetSubBucketData:2) |
| WK-DMF0004-0137 | A1 | DMF0004_GET_SALES_SITE_BUCKET_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0004_GET_SALES_SITE_BUCKET_DATA: 골든 비교 케이스 없음(DMF0004_GET_SALES_SITE_BUCKET_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE |  | 38 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0138 | A1 | DMF0004_GET_SALES_SITE_CUSTOMER_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0004_GET_SALES_SITE_CUSTOMER_DATA: 골든 비교 케이스 없음(DMF0004_GET_SALES_SITE_CUSTOMER_DATA — 팝업·보조 SP 는 golden_cases.csv  |  | 46 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0139 | A1 | DMF0004_GET_SALES_SITE_LOCATION_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0004_GET_SALES_SITE_LOCATION_DATA: 골든 비교 케이스 없음(DMF0004_GET_SALES_SITE_LOCATION_DATA — 팝업·보조 SP 는 golden_cases.csv  |  | 41 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0140 | A1 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE — 팝업·보조 SP 는 |  | 121 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0141 | A1 | PKG_DMF0004.P_DMF0004_GET_SALES_SITE_DAT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0004.P_DMF0004_GET_SALES_SITE_DATA: 골든 비교 케이스 없음(PKG_DMF0004.P_DMF0004_GET_SALES_SITE_DATA — 팝업·보조 SP 는 golden_ |  | 54 (ACT:DMF0004_SalesSite.FindButton ACT:DMF) |
| WK-DMF0004-0142 | X-ROW | DMF0004_SalesSite.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.CreateSpread) |
| WK-DMF0004-0143 | X-ROW | DMF0004_SalesSite.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0004_SalesSite.DefineProperty:376) |
| WK-DMF0004-0144 | X-ROW | DMF0004_SalesSite.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 요소 검사 |  | 16 (ACT:DMF0004_SalesSite.ExcelButton ACT:DM) |
| WK-DMF0004-0145 | X-ROW | DMF0004_SalesSite.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.FindData_Main: 진입점 집계 17검사 — NOT_RUN:13 · REVIEW:2 · PASS:2 |  | 6 (ACT:DMF0004_SalesSite.FindData_Main:774:) |
| WK-DMF0004-0146 | X-ROW | DMF0004_SalesSite.FindData_SubBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.FindData_SubBucket: 진입점 집계 9검사 — NOT_RUN:5 · REVIEW:2 · NOPATH:1 · PASS:1 |  | 4 (ACT:DMF0004_SalesSite.FindData_SubBucket) |
| WK-DMF0004-0147 | X-ROW | DMF0004_SalesSite.FindData_SubCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.FindData_SubCustomer: 진입점 집계 9검사 — NOT_RUN:5 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 8 (ACT:DMF0004_SalesSite.FindData_SubCustom) |
| WK-DMF0004-0148 | X-ROW | DMF0004_SalesSite.FindData_SubLocation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.FindData_SubLocation: 진입점 집계 9검사 — NOT_RUN:5 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 4 (ACT:DMF0004_SalesSite.FindData_SubLocati) |
| WK-DMF0004-0149 | X-ROW | DMF0004_SalesSite.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.Form_Load) |
| WK-DMF0004-0150 | X-ROW | DMF0004_SalesSite.GetPlantbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.GetPlantbyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.GetPlantbyDivision) |
| WK-DMF0004-0151 | X-ROW | DMF0004_SalesSite.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.InitControls: 진입점 집계 21검사 — NOT_RUN:19 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0004_SalesSite.InitControls:327:2) |
| WK-DMF0004-0152 | X-ROW | DMF0004_SalesSite.InitSaveDataTable | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.InitSaveDataTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.InitSaveDataTable) |
| WK-DMF0004-0153 | X-ROW | DMF0004_SalesSite.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.InitSpread) |
| WK-DMF0004-0154 | X-ROW | DMF0004_SalesSite.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.InsertButton) |
| WK-DMF0004-0155 | X-ROW | DMF0004_SalesSite.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.InsertRow: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 59 (ACT:DMF0004_SalesSite.InsertRow ACT:DMF0) |
| WK-DMF0004-0156 | X-ROW | DMF0004_SalesSite.InsertRowLockRangeMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.InsertRowLockRangeMain: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_LOCK, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0004_SalesSite.InsertRowLockRange) |
| WK-DMF0004-0157 | X-ROW | DMF0004_SalesSite.InsertRowLockRangeSubB | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.InsertRowLockRangeSubBucket: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_LOCK, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0004_SalesSite.InsertRowLockRange) |
| WK-DMF0004-0158 | X-ROW | DMF0004_SalesSite.InsertRowLockRangeSubC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.InsertRowLockRangeSubCustomer: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_LOCK, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0004_SalesSite.InsertRowLockRange) |
| WK-DMF0004-0159 | X-ROW | DMF0004_SalesSite.InsertRowLockRangeSubL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.InsertRowLockRangeSubLocation: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_LOCK, 연결된 요소 검사 없음 |  | 4 (ACT:DMF0004_SalesSite.InsertRowLockRange) |
| WK-DMF0004-0160 | X-ROW | DMF0004_SalesSite.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.SaveData: 진입점 집계 14검사 — NOT_RUN:9 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.SaveData:1334:160 ) |
| WK-DMF0004-0161 | X-ROW | DMF0004_SalesSite.SaveSubBucketData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.SaveSubBucketData: 진입점 집계 14검사 — NOT_RUN:11 · PASS:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 67 (ACT:DMF0004_SalesSite.SaveSubBucketData ) |
| WK-DMF0004-0162 | X-ROW | DMF0004_SalesSite.SaveSubCustomerData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.SaveSubCustomerData: 진입점 집계 13검사 — NOT_RUN:10 · PASS:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 89 (ACT:DMF0004_SalesSite.SaveSubCustomerDat) |
| WK-DMF0004-0163 | X-ROW | DMF0004_SalesSite.SaveSubLocationData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.SaveSubLocationData: 진입점 집계 12검사 — NOT_RUN:9 · PASS:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 95 (ACT:DMF0004_SalesSite.SaveSubLocationDat) |
| WK-DMF0004-0164 | X-ROW | DMF0004_SalesSite.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0004_SalesSite.SetChangeControl A) |
| WK-DMF0004-0165 | X-ROW | DMF0004_SalesSite.SetGridHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.SetGridHeader: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0004_SalesSite.SetGridHeader ACT:) |
| WK-DMF0004-0166 | X-ROW | DMF0004_SalesSite.cboDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.cboDivision_SelectedIndexChanged: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.cboDivision_Select) |
| WK-DMF0004-0167 | X-ROW | DMF0004_SalesSite.chkDetail_CheckedChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.chkDetail_CheckedChanged: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.chkDetail_CheckedC) |
| WK-DMF0004-0168 | X-ROW | DMF0004_SalesSite.clbEndCustomer_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.clbEndCustomer_SelectedIndexChan: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.clbEndCustomer_Sel) |
| WK-DMF0004-0169 | X-ROW | DMF0004_SalesSite.clbSoldToCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.clbSoldToCustomer_SelectedIndexC: 진입점 집계 6검사 — NOT_RUN:4 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.clbSoldToCustomer_) |
| WK-DMF0004-0170 | X-ROW | DMF0004_SalesSite.clbTeam_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.clbTeam_SelectedIndexChanged: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0004_SalesSite.clbTeam_SelectedIn) |
| WK-DMF0004-0171 | X-ROW | DMF0004_SalesSite.shtMainDataModel_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.shtMainDataModel_Changed: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0004_SalesSite.shtMainDataModel_C) |
| WK-DMF0004-0172 | X-ROW | DMF0004_SalesSite.shtSubBucketDataModel_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.shtSubBucketDataModel_Changed: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.shtSubBucketDataMo) |
| WK-DMF0004-0173 | X-ROW | DMF0004_SalesSite.shtSubCustomerDataMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.shtSubCustomerDataModel_Changed: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0004_SalesSite.shtSubCustomerData) |
| WK-DMF0004-0174 | X-ROW | DMF0004_SalesSite.spdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.spdMain_CellDoubleClick: 진입점 집계 8검사 — NOT_RUN:4 · REVIEW:3 · NOPATH:1 |  | 13 (ACT:DMF0004_SalesSite.spdMain_CellDouble) |
| WK-DMF0004-0175 | X-ROW | DMF0004_SalesSite.spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.spdMain_ComboSelChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0004_SalesSite.spdMain_ComboSelCh) |
| WK-DMF0004-0176 | X-ROW | DMF0004_SalesSite.spdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.spdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/GRID_SET, 연결된 요소 검사 없음 |  | 7 (ACT:DMF0004_SalesSite.spdMain_EditChange) |
| WK-DMF0004-0177 | X-ROW | DMF0004_SalesSite.spdMain_LeaveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.spdMain_LeaveCell: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/UI_PROP, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0004_SalesSite.spdMain_LeaveCell ) |
| WK-DMF0004-0178 | X-ROW | DMF0004_SalesSite.spdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.spdMain_TopChange ) |
| WK-DMF0004-0179 | X-ROW | DMF0004_SalesSite.spdSub_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.spdSub_ActiveSheetChanging: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0004_SalesSite.spdSub_ActiveSheet) |
| WK-DMF0004-0180 | X-ROW | DMF0004_SalesSite.spdSub_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.spdSub_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 14 (ACT:DMF0004_SalesSite.spdSub_CellDoubleC) |
| WK-DMF0004-0181 | X-ROW | DMF0004_SalesSite.spdSub_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.spdSub_ComboSelChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0004_SalesSite.spdSub_ComboSelCha) |
| WK-DMF0004-0182 | X-ROW | DMF0004_SalesSite.spdSub_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.spdSub_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/GRID_SET, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0004_SalesSite.spdSub_EditChange ) |
| WK-DMF0004-0183 | X-ROW | DMF0004_SalesSite.spdSub_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0004_SalesSite.spdSub_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0004_SalesSite.spdSub_TopChange A) |
| WK-DMF0004-0184 | G5 | DMF0004_SalesSite.spdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0004_SalesSite.spdMain_CellDoubleClick: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 61 (ACT:DMF0004_SalesSite.spdMain_CellDouble) |
| WK-DMF0004-0185 | G5 | DMF0004_SalesSite.spdSub_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0004_SalesSite.spdSub_CellDoubleClick: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 22 (ACT:DMF0004_SalesSite.spdSub_CellDoubleC) |
| WK-DMF0004-0186 | H6 | DMF0004_SalesSite.spdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0004_SalesSite.spdMain_CellDoubleClick: 진입점 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 61 (ACT:DMF0004_SalesSite.spdMain_CellDouble) |
| WK-DMF0004-0187 | H6 | DMF0004_SalesSite.spdSub_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0004_SalesSite.spdSub_CellDoubleClick: 진입점 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 22 (ACT:DMF0004_SalesSite.spdSub_CellDoubleC) |
| WK-DMF0004-0188 | M4 | DMF0004_SalesSite.spdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0004_SalesSite.spdMain_CellDoubleClick: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 61 (ACT:DMF0004_SalesSite.spdMain_CellDouble) |
| WK-DMF0004-0189 | M4 | DMF0004_SalesSite.spdSub_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0004_SalesSite.spdSub_CellDoubleClick: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 22 (ACT:DMF0004_SalesSite.spdSub_CellDoubleC) |
