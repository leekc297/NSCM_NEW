# 작업 원장 — DMF0008 · 2026-10-26 12:49

> 검사 인스턴스 344건 중 PASS·NA 50건 외 **294건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 16 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 77 | 실행 → PASS |
| W7 | 기대값 확정 | 200 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 200 · E2E 77 · 하네스 17
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 12건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 50 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  |  |  |  |  |  | 40 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| F4 | DB |  |  |  |  |  | 20 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A1 | GEN |  |  |  |  |  |  | 20 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C3 | CASCADE |  |  |  |  |  | 3 | 15 |  |  | 연쇄 자동 채움 |
| E4 | EDIT |  |  |  |  |  | 14 | 4 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A6 | GEN |  |  |  |  |  | 15 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| DB-SYN | DB |  |  |  |  | 12 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| C2 | CASCADE |  |  |  |  |  | 2 | 11 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 2 | 11 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| B3 | COMBO |  |  |  | 1 |  |  | 9 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 1 |  | 9 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D1 | EDIT |  |  |  |  |  | 1 | 8 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 1 | 8 |  |  | 행 값 기반 조건부 잠금 |
| M4 | POPUP |  |  |  |  |  | 3 | 5 |  |  | 팝업 선택값 반영 |
| G1 | GEN |  |  |  |  |  | 2 | 5 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G4 | DESIGN |  |  |  |  |  | 2 |  |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 2 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| C1 | CASCADE |  |  |  |  |  | 1 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0008-0001 | B3 | clbDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision / Division | 있음(FE 소스) | 5 (ACT:DMF0008_ErpEdiMaster.GetSoldToCustom) |

## W5 검사기 연결 (16)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0008-0002 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 5 (ACT:DMF0008_ErpEdiMaster.GetSoldToCustom) |
| WK-DMF0008-0003 | F2 | DMF0008 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0008 화면 | 판단불가(대상 단위 SCREEN) | 16 (Save repair project 1 5 6 7 SSPM ACT:DMF) |
| WK-DMF0008-0004 | F6 | DMF0008 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0008 화면 | 판단불가(대상 단위 SCREEN) | 8 (ACT:DMF0008_ErpEdiMaster.SaveButton ACT:) |
| WK-DMF0008-0005 | DB-SYN | DMF0000_GET_UPDATE_HISTORY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0000_GET_UPDATE_HISTORY | 없음(PROC_M 대응 없음) | 6 (updateHistory ACT:DMF0008_ErpEdiMaster.G) |
| WK-DMF0008-0006 | DB-SYN | DMF0004_GET_SALES_SITE_CUSTOMER_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0004_GET_SALES_SITE_CUSTOMER_DATA | 없음(PROC_M 대응 없음) | 3 (ACT:DMF0008_ErpEdiMaster.FindData_SubCus) |
| WK-DMF0008-0007 | DB-SYN | DMF0004_GET_SOLDTO_CUSTOMER_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0004_GET_SOLDTO_CUSTOMER_DATA | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0008_ErpEdiMaster.GetSoldToCustom) |
| WK-DMF0008-0008 | DB-SYN | DMF0008_GET_MY_DIVISION_LIST | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0008_GET_MY_DIVISION_LIST | 없음(PROC_M 대응 없음) | 1 (division) |
| WK-DMF0008-0009 | DB-SYN | P_DMF0008_DIVISION_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0008_DIVISION_GET | 없음(PROC_M 대응 없음) | 1 (division) |
| WK-DMF0008-0010 | DB-SYN | P_DMF0008_PROJECT_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0008_PROJECT_GET | 없음(PROC_M 대응 없음) | 1 (project) |
| WK-DMF0008-0011 | DB-SYN | P_DMF0008_SALES_SITE_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0008_SALES_SITE_GET | 없음(PROC_M 대응 없음) | 1 (salesSite) |
| WK-DMF0008-0012 | DB-SYN | P_DMF0008_SSPM_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0008_SSPM_GET | 없음(PROC_M 대응 없음) | 1 (sspm) |
| WK-DMF0008-0013 | DB-SYN | P_DMF0008_SUMMARY_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0008_SUMMARY_GET | 없음(PROC_M 대응 없음) | 0 () |
| WK-DMF0008-0014 | DB-SYN | P_DMF0008_UPDATE_HISTORY_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0008_UPDATE_HISTORY_GET | 없음(PROC_M 대응 없음) | 1 (updateHistory) |
| WK-DMF0008-0015 | DB-SYN | SCM0001_GET_PLANT_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_PLANT_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0008_ErpEdiMaster.GetPlantbyDivis) |
| WK-DMF0008-0016 | DB-SYN | SCM0001_GET_SITE_INFO_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SITE_INFO_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0008_ErpEdiMaster.GetScmSiteInfob) |
| WK-DMF0008-0017 | G03-WIRE | DMF0008 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0008 화면 | 판단불가(대상 단위 SCREEN) | 14 (ACT:DMF0008_ErpEdiMaster..ctor ACT:DMF00) |

## W6 검증 실행 (77)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0008-0018 | J2 | DMF0008 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0008 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 52 (Search Insert Delete Edit Save F3 sort F) |
| WK-DMF0008-0019 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0008_ErpEdiMaster.InitControls:35) |
| WK-DMF0008-0020 | C2 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0008_ErpEdiMaster.spdSub_ComboSel) |
| WK-DMF0008-0021 | C2 | E | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — E · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0008_ErpEdiMaster.shtSSPMDataMode) |
| WK-DMF0008-0022 | C3 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0008_ErpEdiMaster.spdSub_ComboSel) |
| WK-DMF0008-0023 | C3 | E | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — E · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0008_ErpEdiMaster.shtSSPMDataMode) |
| WK-DMF0008-0024 | C3 | G | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — G · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0008_ErpEdiMaster.SetChangeContro) |
| WK-DMF0008-0025 | C6 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0008_ErpEdiMaster.spdSub_ComboSel) |
| WK-DMF0008-0026 | C6 | E | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — E · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0008_ErpEdiMaster.shtSSPMDataMode) |
| WK-DMF0008-0027 | K4 | DMF0008 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0008 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 29 (ACT:DMF0008_ErpEdiMaster.btnStatusUpdate) |
| WK-DMF0008-0028 | F1 | DMF0008 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0008 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 18 (Delete Save repair project 1 5 6 7 8 SSP) |
| WK-DMF0008-0029 | F5 | DMF0008 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0008 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (Delete 8) |
| WK-DMF0008-0030 | F4 | DMF0000_GET_UPDATE_HISTORY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0000_GET_UPDATE_HISTORY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 6 (updateHistory ACT:DMF0008_ErpEdiMaster.G) |
| WK-DMF0008-0031 | F4 | DMF0004_GET_SALES_SITE_CUSTOMER_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0004_GET_SALES_SITE_CUSTOMER_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 30 (ACT:DMF0008_ErpEdiMaster.FindData_SubCus) |
| WK-DMF0008-0032 | F4 | DMF0004_GET_SOLDTO_CUSTOMER_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0004_GET_SOLDTO_CUSTOMER_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:DMF0008_ErpEdiMaster.GetSoldToCustom) |
| WK-DMF0008-0033 | F4 | DMF0008_GET_MY_DIVISION_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0008_GET_MY_DIVISION_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (division) |
| WK-DMF0008-0034 | F4 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 252 (ACT:DMF0008_ErpEdiMaster.FindButton ACT:) |
| WK-DMF0008-0035 | F4 | PKG_DMF0008.P_DMF0008_GET_EDI_MST_REPAIR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0008.P_DMF0008_GET_EDI_MST_REPAIR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 92 (ACT:DMF0008_ErpEdiMaster.FindData_SubRep) |
| WK-DMF0008-0036 | F4 | PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMARY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 48 (ACT:DMF0008_ErpEdiMaster.FindButton ACT:) |
| WK-DMF0008-0037 | F4 | PKG_DMF0008.P_DMF0008_GET_SALES_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0008.P_DMF0008_GET_SALES_SITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 98 (salesSite ACT:DMF0008_ErpEdiMaster.FindD) |
| WK-DMF0008-0038 | F4 | PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PRO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PROJECT_MODEL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 54 (sspm project ACT:DMF0008_ErpEdiMaster.Fi) |
| WK-DMF0008-0039 | F4 | PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 1 (updateHistory) |
| WK-DMF0008-0040 | F4 | PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_ED | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 10 (ACT:DMF0008_ErpEdiMaster.SaveButton ACT:) |
| WK-DMF0008-0041 | F4 | PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_PR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_ · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 10 (ACT:DMF0008_ErpEdiMaster.SaveButton ACT:) |
| WK-DMF0008-0042 | F4 | P_DMF0008_DIVISION_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0008_DIVISION_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (division) |
| WK-DMF0008-0043 | F4 | P_DMF0008_PROJECT_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0008_PROJECT_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (project) |
| WK-DMF0008-0044 | F4 | P_DMF0008_SALES_SITE_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0008_SALES_SITE_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (salesSite) |
| WK-DMF0008-0045 | F4 | P_DMF0008_SSPM_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0008_SSPM_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (sspm) |
| WK-DMF0008-0046 | F4 | P_DMF0008_SUMMARY_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0008_SUMMARY_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-DMF0008-0047 | F4 | P_DMF0008_UPDATE_HISTORY_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0008_UPDATE_HISTORY_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (updateHistory) |
| WK-DMF0008-0048 | F4 | SCM0001_GET_PLANT_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_PLANT_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 2 (ACT:DMF0008_ErpEdiMaster.GetPlantbyDivis) |
| WK-DMF0008-0049 | F4 | SCM0001_GET_SITE_INFO_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SITE_INFO_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 2 (ACT:DMF0008_ErpEdiMaster.GetScmSiteInfob) |
| WK-DMF0008-0050 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (ACT:DMF0008_ErpEdiMaster.InitControls AC) |
| WK-DMF0008-0051 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0008_ErpEdiMaster.FindData_Main:8) |
| WK-DMF0008-0052 | H4 | DMF0008 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0008 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 8 (ACT:DMF0008_ErpEdiMaster.spdMain_TopChan) |
| WK-DMF0008-0053 | I1 | DMF0008 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0008 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 40 (1 2 3 4 5 6 7 8 9 10 SalesSite ACT:DMF00) |
| WK-DMF0008-0054 | D1 | S | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — S · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (항상 unlock (편집 가능) ACT:DMF0008_ErpEdiMast) |
| WK-DMF0008-0055 | D3 | S | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — S · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (항상 unlock (편집 가능) ACT:DMF0008_ErpEdiMast) |
| WK-DMF0008-0056 | D6 | DMF0008 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0008 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 8 (Insert 1 8 SSPM (siSub) Insert 시 lock + ) |
| WK-DMF0008-0057 | E4 | G | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — G · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0008_ErpEdiMaster.SetChangeContro) |
| WK-DMF0008-0058 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (5 ACT:DMF0008_ErpEdiMaster.SaveSalesSite) |
| WK-DMF0008-0059 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (6 ACT:DMF0008_ErpEdiMaster.SaveSalesSite) |
| WK-DMF0008-0060 | E4 | MSG00005 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00005 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (7 ACT:DMF0008_ErpEdiMaster.SaveSalesSite) |
| WK-DMF0008-0061 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (10 SalesSite ACT:DMF0008_ErpEdiMaster.sh) |
| WK-DMF0008-0062 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (1 ACT:DMF0008_ErpEdiMaster.EditButton:56) |
| WK-DMF0008-0063 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (3 ACT:DMF0008_ErpEdiMaster.FindData_Main) |
| WK-DMF0008-0064 | E4 | MSG00128 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00128 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (8 ACT:DMF0008_ErpEdiMaster.SpdSub_CellDo) |
| WK-DMF0008-0065 | E4 | MSG00129 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00129 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (9 ACT:DMF0008_ErpEdiMaster.spdSub_Active) |
| WK-DMF0008-0066 | E4 | MSG00130 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00130 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (2 ACT:DMF0008_ErpEdiMaster.EditButton:56) |
| WK-DMF0008-0067 | E4 | MSG00164 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00164 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (4 ACT:DMF0008_ErpEdiMaster.FindData_Main) |
| WK-DMF0008-0068 | E4 | MSG00445 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00445 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0008_ErpEdiMaster.FindData_SubSal) |
| WK-DMF0008-0069 | E4 | MSG00446 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00446 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0008_ErpEdiMaster.FindData_SubSal) |
| WK-DMF0008-0070 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0008_ErpEdiMaster.FindData_Main:8) |
| WK-DMF0008-0071 | A10 | DMF0008 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0008 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 77 (ACT:DMF0008_ErpEdiMaster.DefineProperty ) |
| WK-DMF0008-0072 | A6 | DMF0000_GET_UPDATE_HISTORY | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0000_GET_UPDATE_HISTORY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec( |  | 1 (updateHistory) |
| WK-DMF0008-0073 | A6 | DMF0004_GET_SALES_SITE_CUSTOMER_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0004_GET_SALES_SITE_CUSTOMER_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 30 (ACT:DMF0008_ErpEdiMaster.FindData_SubCus) |
| WK-DMF0008-0074 | A6 | DMF0008_GET_MY_DIVISION_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0008_GET_MY_DIVISION_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spe |  | 1 (division) |
| WK-DMF0008-0075 | A6 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 237 (ACT:DMF0008_ErpEdiMaster.FindButton ACT:) |
| WK-DMF0008-0076 | A6 | PKG_DMF0008.P_DMF0008_GET_EDI_MST_REPAIR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0008.P_DMF0008_GET_EDI_MST_REPAIR · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 92 (ACT:DMF0008_ErpEdiMaster.FindData_SubRep) |
| WK-DMF0008-0077 | A6 | PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMARY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 45 (ACT:DMF0008_ErpEdiMaster.FindButton ACT:) |
| WK-DMF0008-0078 | A6 | PKG_DMF0008.P_DMF0008_GET_SALES_SITE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0008.P_DMF0008_GET_SALES_SITE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 88 (salesSite ACT:DMF0008_ErpEdiMaster.FindD) |
| WK-DMF0008-0079 | A6 | PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PRO | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PROJECT_MODEL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 45 (sspm project ACT:DMF0008_ErpEdiMaster.Fi) |
| WK-DMF0008-0080 | A6 | PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (updateHistory) |
| WK-DMF0008-0081 | A6 | P_DMF0008_DIVISION_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0008_DIVISION_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tra |  | 1 (division) |
| WK-DMF0008-0082 | A6 | P_DMF0008_PROJECT_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0008_PROJECT_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trac |  | 1 (project) |
| WK-DMF0008-0083 | A6 | P_DMF0008_SALES_SITE_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0008_SALES_SITE_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 1 (salesSite) |
| WK-DMF0008-0084 | A6 | P_DMF0008_SSPM_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0008_SSPM_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (sspm) |
| WK-DMF0008-0085 | A6 | P_DMF0008_SUMMARY_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0008_SUMMARY_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trac |  | 0 () |
| WK-DMF0008-0086 | A6 | P_DMF0008_UPDATE_HISTORY_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0008_UPDATE_HISTORY_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spe |  | 1 (updateHistory) |
| WK-DMF0008-0087 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0008_ErpEdiMaster.FindData_Main A) |
| WK-DMF0008-0088 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 18 (ACT:DMF0008_ErpEdiMaster.FindData_Main A) |
| WK-DMF0008-0089 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (ACT:DMF0008_ErpEdiMaster.InitControls AC) |
| WK-DMF0008-0090 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:DMF0008_ErpEdiMaster.InitControls) |
| WK-DMF0008-0091 | X-REOPEN | DMF0008 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0008 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 20 (ACT:DMF0008_ErpEdiMaster.Dispose ACT:DMF) |
| WK-DMF0008-0092 | M4 | ACTIVE_SS | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ACTIVE_SS · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0008_ErpEdiMaster.spdRepair_CellD) |
| WK-DMF0008-0093 | M4 | G | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — G · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:DMF0008_ErpEdiMaster.spdSub_CellDoub) |
| WK-DMF0008-0094 | M4 | GSCM_SSPM | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — GSCM_SSPM · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:DMF0008_ErpEdiMaster.spdRepair_CellD) |

## W7 기대값 확정 (200)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0008-0095 | C2 | DMF0008_ErpEdiMaster.clbDivision_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0008_ErpEdiMaster.clbDivision_SelectedIndexChan: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0008_ErpEdiMaster.clbDivision_Sel) |
| WK-DMF0008-0096 | C2 | DMF0008_ErpEdiMaster.shtSALES_SITEDataMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0008_ErpEdiMaster.shtSALES_SITEDataModel_Change: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0008_ErpEdiMaster.shtSALES_SITEDa) |
| WK-DMF0008-0097 | C2 | DMF0008_ErpEdiMaster.shtSSPMDataModel_Ch | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0008_ErpEdiMaster.shtSSPMDataModel_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0008_ErpEdiMaster.shtSSPMDataMode) |
| WK-DMF0008-0098 | C2 | DMF0008_ErpEdiMaster.shtSummaryDataModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0008_ErpEdiMaster.shtSummaryDataModel_Changed: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.shtSummaryDataM) |
| WK-DMF0008-0099 | C2 | DMF0008_ErpEdiMaster.spdMain_ComboSelCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0008_ErpEdiMaster.spdMain_ComboSelChange: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0008_ErpEdiMaster.spdMain_ComboSe) |
| WK-DMF0008-0100 | C2 | DMF0008_ErpEdiMaster.spdSub_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_Changed: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 22 (ACT:DMF0008_ErpEdiMaster.spdSub_Changed:) |
| WK-DMF0008-0101 | C2 | DMF0008_ErpEdiMaster.spdSub_ComboSelChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_ComboSelChange: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 33 (ACT:DMF0008_ErpEdiMaster.spdSub_ComboSel) |
| WK-DMF0008-0102 | C2 | SSPM | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSPM: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SSPM) |
| WK-DMF0008-0103 | C2 | SalesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SalesSite: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SalesSite) |
| WK-DMF0008-0104 | C2 | SalesSite+SSPM 통합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SalesSite+SSPM 통합: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SalesSite+SSPM 통합) |
| WK-DMF0008-0105 | C2 | Summary | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — Summary: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Summary) |
| WK-DMF0008-0106 | C3 | DMF0008_ErpEdiMaster.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.SetChangeControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 13 (ACT:DMF0008_ErpEdiMaster.SetChangeContro) |
| WK-DMF0008-0107 | C3 | DMF0008_ErpEdiMaster.SetGridHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.SetGridHeader: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.SetGridHeader:2) |
| WK-DMF0008-0108 | C3 | DMF0008_ErpEdiMaster.SetSubSSPMData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.SetSubSSPMData: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 21 (ACT:DMF0008_ErpEdiMaster.SetSubSSPMData:) |
| WK-DMF0008-0109 | C3 | DMF0008_ErpEdiMaster.SetSubSalesSiteData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.SetSubSalesSiteData: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 16 (ACT:DMF0008_ErpEdiMaster.SetSubSalesSite) |
| WK-DMF0008-0110 | C3 | DMF0008_ErpEdiMaster.clbDivision_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.clbDivision_SelectedIndexChan: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0008_ErpEdiMaster.clbDivision_Sel) |
| WK-DMF0008-0111 | C3 | DMF0008_ErpEdiMaster.shtSALES_SITEDataMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.shtSALES_SITEDataModel_Change: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0008_ErpEdiMaster.shtSALES_SITEDa) |
| WK-DMF0008-0112 | C3 | DMF0008_ErpEdiMaster.shtSSPMDataModel_Ch | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.shtSSPMDataModel_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0008_ErpEdiMaster.shtSSPMDataMode) |
| WK-DMF0008-0113 | C3 | DMF0008_ErpEdiMaster.shtSummaryDataModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.shtSummaryDataModel_Changed: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.shtSummaryDataM) |
| WK-DMF0008-0114 | C3 | DMF0008_ErpEdiMaster.spdMain_ComboSelCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.spdMain_ComboSelChange: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0008_ErpEdiMaster.spdMain_ComboSe) |
| WK-DMF0008-0115 | C3 | DMF0008_ErpEdiMaster.spdSub_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_Changed: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 22 (ACT:DMF0008_ErpEdiMaster.spdSub_Changed:) |
| WK-DMF0008-0116 | C3 | DMF0008_ErpEdiMaster.spdSub_ComboSelChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_ComboSelChange: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 33 (ACT:DMF0008_ErpEdiMaster.spdSub_ComboSel) |
| WK-DMF0008-0117 | C3 | SSPM | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSPM: 행 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SSPM) |
| WK-DMF0008-0118 | C3 | SalesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SalesSite: 행 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SalesSite) |
| WK-DMF0008-0119 | C3 | SalesSite+SSPM 통합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SalesSite+SSPM 통합: 행 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SalesSite+SSPM 통합) |
| WK-DMF0008-0120 | C3 | Summary | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — Summary: 행 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Summary) |
| WK-DMF0008-0121 | C6 | DMF0008_ErpEdiMaster.clbDivision_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0008_ErpEdiMaster.clbDivision_SelectedIndexChan: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0008_ErpEdiMaster.clbDivision_Sel) |
| WK-DMF0008-0122 | C6 | DMF0008_ErpEdiMaster.shtSALES_SITEDataMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0008_ErpEdiMaster.shtSALES_SITEDataModel_Change: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0008_ErpEdiMaster.shtSALES_SITEDa) |
| WK-DMF0008-0123 | C6 | DMF0008_ErpEdiMaster.shtSSPMDataModel_Ch | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0008_ErpEdiMaster.shtSSPMDataModel_Changed: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0008_ErpEdiMaster.shtSSPMDataMode) |
| WK-DMF0008-0124 | C6 | DMF0008_ErpEdiMaster.shtSummaryDataModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0008_ErpEdiMaster.shtSummaryDataModel_Changed: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.shtSummaryDataM) |
| WK-DMF0008-0125 | C6 | DMF0008_ErpEdiMaster.spdMain_ComboSelCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0008_ErpEdiMaster.spdMain_ComboSelChange: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0008_ErpEdiMaster.spdMain_ComboSe) |
| WK-DMF0008-0126 | C6 | DMF0008_ErpEdiMaster.spdSub_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_Changed: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 22 (ACT:DMF0008_ErpEdiMaster.spdSub_Changed:) |
| WK-DMF0008-0127 | C6 | DMF0008_ErpEdiMaster.spdSub_ComboSelChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_ComboSelChange: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 33 (ACT:DMF0008_ErpEdiMaster.spdSub_ComboSel) |
| WK-DMF0008-0128 | C6 | SSPM | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSPM: 행 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SSPM) |
| WK-DMF0008-0129 | C6 | SalesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SalesSite: 행 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SalesSite) |
| WK-DMF0008-0130 | C6 | SalesSite+SSPM 통합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SalesSite+SSPM 통합: 행 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SalesSite+SSPM 통합) |
| WK-DMF0008-0131 | C6 | Summary | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — Summary: 행 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Summary) |
| WK-DMF0008-0132 | B3 | DMF0008_ErpEdiMaster.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0008_ErpEdiMaster.GetDayRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0008_ErpEdiMaster.GetDayRange:293) |
| WK-DMF0008-0133 | B3 | DMF0008_ErpEdiMaster.GetPlantbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0008_ErpEdiMaster.GetPlantbyDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0008_ErpEdiMaster.GetPlantbyDivis) |
| WK-DMF0008-0134 | B3 | DMF0008_ErpEdiMaster.GetScmSiteInfobyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0008_ErpEdiMaster.GetScmSiteInfobyDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0008_ErpEdiMaster.GetScmSiteInfob) |
| WK-DMF0008-0135 | B3 | DMF0008_ErpEdiMaster.GetSoldToCustomerDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0008_ErpEdiMaster.GetSoldToCustomerData: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0008_ErpEdiMaster.GetSoldToCustom) |
| WK-DMF0008-0136 | B3 | DMF0008_ErpEdiMaster.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0008_ErpEdiMaster.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0008_ErpEdiMaster.GetSpdTitle:295) |
| WK-DMF0008-0137 | B3 | DMF0008_ErpEdiMaster.GetUpdateHistory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0008_ErpEdiMaster.GetUpdateHistory: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.GetUpdateHistor) |
| WK-DMF0008-0138 | B3 | project | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — project: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (project) |
| WK-DMF0008-0139 | B3 | salesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — salesSite: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (salesSite) |
| WK-DMF0008-0140 | B3 | sspm | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — sspm: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (sspm) |
| WK-DMF0008-0141 | B4 | DMF0008_ErpEdiMaster.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0008_ErpEdiMaster.GetDayRange: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0008_ErpEdiMaster.GetDayRange:293) |
| WK-DMF0008-0142 | B4 | DMF0008_ErpEdiMaster.GetPlantbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0008_ErpEdiMaster.GetPlantbyDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0008_ErpEdiMaster.GetPlantbyDivis) |
| WK-DMF0008-0143 | B4 | DMF0008_ErpEdiMaster.GetScmSiteInfobyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0008_ErpEdiMaster.GetScmSiteInfobyDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0008_ErpEdiMaster.GetScmSiteInfob) |
| WK-DMF0008-0144 | B4 | DMF0008_ErpEdiMaster.GetSoldToCustomerDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0008_ErpEdiMaster.GetSoldToCustomerData: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0008_ErpEdiMaster.GetSoldToCustom) |
| WK-DMF0008-0145 | B4 | DMF0008_ErpEdiMaster.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0008_ErpEdiMaster.GetSpdTitle: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0008_ErpEdiMaster.GetSpdTitle:295) |
| WK-DMF0008-0146 | B4 | DMF0008_ErpEdiMaster.GetUpdateHistory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0008_ErpEdiMaster.GetUpdateHistory: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.GetUpdateHistor) |
| WK-DMF0008-0147 | B4 | project | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — project: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (project) |
| WK-DMF0008-0148 | B4 | salesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — salesSite: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (salesSite) |
| WK-DMF0008-0149 | B4 | sspm | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — sspm: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (sspm) |
| WK-DMF0008-0150 | DB-SYN | DMF0008_ErpEdiMaster.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0008_ErpEdiMaster.GetDayRange: 진입점 집계 — DB-SYN 20요소: NOPATH:12 · PASS:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.GetDayRange:293) |
| WK-DMF0008-0151 | DB-SYN | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — Search: 행 집계 — DB-SYN 20요소: NOPATH:12 · PASS:8 (미실행 요소가 남아 판정필요) |  | 1 (Search) |
| WK-DMF0008-0152 | F4 | DMF0008_ErpEdiMaster.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0008_ErpEdiMaster.GetDayRange: 진입점 집계 — F4 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.GetDayRange:293) |
| WK-DMF0008-0153 | F4 | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — Search: 행 집계 — F4 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (Search) |
| WK-DMF0008-0154 | D1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 9: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-DMF0008-0155 | D1 | DMF0008_ErpEdiMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DMF0008_ErpEdiMaster.EditButton: 진입점 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 87 (ACT:DMF0008_ErpEdiMaster.EditButton:553:) |
| WK-DMF0008-0156 | D1 | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Edit) |
| WK-DMF0008-0157 | D1 | Insert 시 lock + Modify 시 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Insert 시 lock + Modify 시 unlock: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Insert 시 lock + Modify 시 unlock) |
| WK-DMF0008-0158 | D1 | Insert 시 unlock + Modify 시 lock | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Insert 시 unlock + Modify 시 lock: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Insert 시 unlock + Modify 시 lock) |
| WK-DMF0008-0159 | D1 | SSPM (siSub) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSPM (siSub): 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SSPM (siSub)) |
| WK-DMF0008-0160 | D1 | SalesSite (siSub) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SalesSite (siSub): 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SalesSite (siSub)) |
| WK-DMF0008-0161 | D1 | 항상 lock (LAST_UPDATE_DATE / LAST_UPDATED | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 항상 lock (LAST_UPDATE_DATE / LAST_UPDATED_BY 등): 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (항상 lock (LAST_UPDATE_DATE / LAST_UPDATED) |
| WK-DMF0008-0162 | D3 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 9: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-DMF0008-0163 | D3 | DMF0008_ErpEdiMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DMF0008_ErpEdiMaster.EditButton: 진입점 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 87 (ACT:DMF0008_ErpEdiMaster.EditButton:553:) |
| WK-DMF0008-0164 | D3 | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Edit) |
| WK-DMF0008-0165 | D3 | Insert 시 lock + Modify 시 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Insert 시 lock + Modify 시 unlock: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Insert 시 lock + Modify 시 unlock) |
| WK-DMF0008-0166 | D3 | Insert 시 unlock + Modify 시 lock | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Insert 시 unlock + Modify 시 lock: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Insert 시 unlock + Modify 시 lock) |
| WK-DMF0008-0167 | D3 | SSPM (siSub) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSPM (siSub): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SSPM (siSub)) |
| WK-DMF0008-0168 | D3 | SalesSite (siSub) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SalesSite (siSub): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SalesSite (siSub)) |
| WK-DMF0008-0169 | D3 | 항상 lock (LAST_UPDATE_DATE / LAST_UPDATED | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 항상 lock (LAST_UPDATE_DATE / LAST_UPDATED_BY 등): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (항상 lock (LAST_UPDATE_DATE / LAST_UPDATED) |
| WK-DMF0008-0170 | E4 | DMF0008_ErpEdiMaster.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0008_ErpEdiMaster.SetChangeControl: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 13 (ACT:DMF0008_ErpEdiMaster.SetChangeContro) |
| WK-DMF0008-0171 | E4 | DMF0008_ErpEdiMaster.SetGridHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0008_ErpEdiMaster.SetGridHeader: 진입점 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.SetGridHeader:2) |
| WK-DMF0008-0172 | E4 | DMF0008_ErpEdiMaster.SetSubSSPMData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0008_ErpEdiMaster.SetSubSSPMData: 진입점 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 21 (ACT:DMF0008_ErpEdiMaster.SetSubSSPMData:) |
| WK-DMF0008-0173 | E4 | DMF0008_ErpEdiMaster.SetSubSalesSiteData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0008_ErpEdiMaster.SetSubSalesSiteData: 진입점 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 16 (ACT:DMF0008_ErpEdiMaster.SetSubSalesSite) |
| WK-DMF0008-0174 | A1 | DMF0000_GET_UPDATE_HISTORY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0000_GET_UPDATE_HISTORY: 골든 비교 케이스 없음(DMF0000_GET_UPDATE_HISTORY — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 2 (updateHistory ACT:DMF0008_ErpEdiMaster.b) |
| WK-DMF0008-0175 | A1 | DMF0004_GET_SALES_SITE_CUSTOMER_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0004_GET_SALES_SITE_CUSTOMER_DATA: 골든 비교 케이스 없음(DMF0004_GET_SALES_SITE_CUSTOMER_DATA — 팝업·보조 SP 는 golden_cases.csv  |  | 30 (ACT:DMF0008_ErpEdiMaster.FindData_SubCus) |
| WK-DMF0008-0176 | A1 | DMF0008_GET_MY_DIVISION_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0008_GET_MY_DIVISION_LIST: 골든 비교 케이스 없음(DMF0008_GET_MY_DIVISION_LIST — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 1 (division) |
| WK-DMF0008-0177 | A1 | F10 resetCondition | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F10 resetCondition: 행 집계 — A1 15요소: REVIEW:15 |  | 1 (F10 resetCondition) |
| WK-DMF0008-0178 | A1 | F3 sort | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F3 sort: 행 집계 — A1 15요소: REVIEW:15 |  | 1 (F3 sort) |
| WK-DMF0008-0179 | A1 | F4 filter | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F4 filter: 행 집계 — A1 15요소: REVIEW:15 |  | 1 (F4 filter) |
| WK-DMF0008-0180 | A1 | F6 condition | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F6 condition: 행 집계 — A1 15요소: REVIEW:15 |  | 1 (F6 condition) |
| WK-DMF0008-0181 | A1 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE — 팝업·보조 SP 는 |  | 238 (ACT:DMF0008_ErpEdiMaster.FindButton ACT:) |
| WK-DMF0008-0182 | A1 | PKG_DMF0008.P_DMF0008_GET_EDI_MST_REPAIR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0008.P_DMF0008_GET_EDI_MST_REPAIR: 골든 비교 케이스 없음(PKG_DMF0008.P_DMF0008_GET_EDI_MST_REPAIR — 팝업·보조 SP 는 golden_ca |  | 92 (ACT:DMF0008_ErpEdiMaster.FindData_SubRep) |
| WK-DMF0008-0183 | A1 | PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMARY: 골든 비교 케이스 없음(PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMARY — 팝업·보조 SP 는 golden_ |  | 46 (ACT:DMF0008_ErpEdiMaster.FindButton ACT:) |
| WK-DMF0008-0184 | A1 | PKG_DMF0008.P_DMF0008_GET_SALES_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0008.P_DMF0008_GET_SALES_SITE: 골든 비교 케이스 없음(PKG_DMF0008.P_DMF0008_GET_SALES_SITE — 팝업·보조 SP 는 golden_cases.csv  |  | 88 (salesSite ACT:DMF0008_ErpEdiMaster.FindD) |
| WK-DMF0008-0185 | A1 | PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PRO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PROJECT_MODEL: 골든 비교 케이스 없음(PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PROJECT_MODEL —  |  | 45 (sspm project ACT:DMF0008_ErpEdiMaster.Fi) |
| WK-DMF0008-0186 | A1 | PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY: 골든 비교 케이스 없음(PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY — 팝업·보조 SP 는 golden_ca |  | 1 (updateHistory) |
| WK-DMF0008-0187 | A1 | P_DMF0008_DIVISION_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0008_DIVISION_GET: 골든 비교 케이스 없음(P_DMF0008_DIVISION_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (division) |
| WK-DMF0008-0188 | A1 | P_DMF0008_PROJECT_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0008_PROJECT_GET: 골든 비교 케이스 없음(P_DMF0008_PROJECT_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (project) |
| WK-DMF0008-0189 | A1 | P_DMF0008_SALES_SITE_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0008_SALES_SITE_GET: 골든 비교 케이스 없음(P_DMF0008_SALES_SITE_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 1 (salesSite) |
| WK-DMF0008-0190 | A1 | P_DMF0008_SSPM_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0008_SSPM_GET: 골든 비교 케이스 없음(P_DMF0008_SSPM_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (sspm) |
| WK-DMF0008-0191 | A1 | P_DMF0008_SUMMARY_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0008_SUMMARY_GET: 골든 비교 케이스 없음(P_DMF0008_SUMMARY_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-DMF0008-0192 | A1 | P_DMF0008_UPDATE_HISTORY_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0008_UPDATE_HISTORY_GET: 골든 비교 케이스 없음(P_DMF0008_UPDATE_HISTORY_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 1 (updateHistory) |
| WK-DMF0008-0193 | A1 | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Search: 행 집계 — A1 15요소: REVIEW:15 |  | 1 (Search) |
| WK-DMF0008-0194 | A6 | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — Search: 행 집계 — A6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Search) |
| WK-DMF0008-0195 | G1 | F10 resetCondition | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F10 resetCondition: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (F10 resetCondition) |
| WK-DMF0008-0196 | G1 | F3 sort | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F3 sort: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (F3 sort) |
| WK-DMF0008-0197 | G1 | F4 filter | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F4 filter: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (F4 filter) |
| WK-DMF0008-0198 | G1 | F6 condition | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F6 condition: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (F6 condition) |
| WK-DMF0008-0199 | G1 | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Search: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Search) |
| WK-DMF0008-0200 | X-LOC | (Repair) CustomerModal / ProjectByDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (Repair) CustomerModal / ProjectByDivisionModal / : 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((Repair) CustomerModal / ProjectByDivisi) |
| WK-DMF0008-0201 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-DMF0008-0202 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-DMF0008-0203 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-DMF0008-0204 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-DMF0008-0205 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-DMF0008-0206 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-DMF0008-0207 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-DMF0008-0208 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-DMF0008-0209 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-DMF0008-0210 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-DMF0008-0211 | X-LOC | ADMIN 권한 분기 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ADMIN 권한 분기 unlock: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ADMIN 권한 분기 unlock) |
| WK-DMF0008-0212 | X-LOC | Delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Delete: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Delete) |
| WK-DMF0008-0213 | X-LOC | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Edit: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Edit) |
| WK-DMF0008-0214 | X-LOC | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Excel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Excel) |
| WK-DMF0008-0215 | X-LOC | F10 resetCondition | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — F10 resetCondition: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (F10 resetCondition) |
| WK-DMF0008-0216 | X-LOC | F3 sort | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — F3 sort: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (F3 sort) |
| WK-DMF0008-0217 | X-LOC | F4 filter | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — F4 filter: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (F4 filter) |
| WK-DMF0008-0218 | X-LOC | F6 condition | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — F6 condition: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (F6 condition) |
| WK-DMF0008-0219 | X-LOC | Insert | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Insert: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Insert) |
| WK-DMF0008-0220 | X-LOC | Insert 시 lock + Modify 시 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Insert 시 lock + Modify 시 unlock: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Insert 시 lock + Modify 시 unlock) |
| WK-DMF0008-0221 | X-LOC | Insert 시 unlock + Modify 시 lock | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Insert 시 unlock + Modify 시 lock: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Insert 시 unlock + Modify 시 lock) |
| WK-DMF0008-0222 | X-LOC | Manual | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Manual: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Manual) |
| WK-DMF0008-0223 | X-LOC | Modal cell (combo cell) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Modal cell (combo cell): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Modal cell (combo cell)) |
| WK-DMF0008-0224 | X-LOC | Repair | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Repair: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Repair) |
| WK-DMF0008-0225 | X-LOC | SSPM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSPM: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSPM) |
| WK-DMF0008-0226 | X-LOC | SSPM (siSub) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSPM (siSub): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSPM (siSub)) |
| WK-DMF0008-0227 | X-LOC | SalesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SalesSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SalesSite) |
| WK-DMF0008-0228 | X-LOC | SalesSite (siSub) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SalesSite (siSub): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SalesSite (siSub)) |
| WK-DMF0008-0229 | X-LOC | SalesSite+SSPM 통합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SalesSite+SSPM 통합: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SalesSite+SSPM 통합) |
| WK-DMF0008-0230 | X-LOC | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Save: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Save) |
| WK-DMF0008-0231 | X-LOC | Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Search: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Search) |
| WK-DMF0008-0232 | X-LOC | Summary | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Summary: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Summary) |
| WK-DMF0008-0233 | X-LOC | Upload | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Upload: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Upload) |
| WK-DMF0008-0234 | X-LOC | division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (division) |
| WK-DMF0008-0235 | X-LOC | project | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — project: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (project) |
| WK-DMF0008-0236 | X-LOC | salesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — salesSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (salesSite) |
| WK-DMF0008-0237 | X-LOC | sspm | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — sspm: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (sspm) |
| WK-DMF0008-0238 | X-LOC | 항상 lock (LAST_UPDATE_DATE / LAST_UPDATED | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 항상 lock (LAST_UPDATE_DATE / LAST_UPDATED_BY 등): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (항상 lock (LAST_UPDATE_DATE / LAST_UPDATED) |
| WK-DMF0008-0239 | X-LOC | 항상 unlock (편집 가능) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 항상 unlock (편집 가능): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (항상 unlock (편집 가능)) |
| WK-DMF0008-0240 | X-ROW | ADMIN 권한 분기 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ADMIN 권한 분기 unlock: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (ADMIN 권한 분기 unlock) |
| WK-DMF0008-0241 | X-ROW | DMF0008_ErpEdiMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.CreateSpread AC) |
| WK-DMF0008-0242 | X-ROW | DMF0008_ErpEdiMaster.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.DefineProperty: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0008_ErpEdiMaster.DefineProperty ) |
| WK-DMF0008-0243 | X-ROW | DMF0008_ErpEdiMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.EditButton: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:2 |  | 52 (ACT:DMF0008_ErpEdiMaster.EditButton:609:) |
| WK-DMF0008-0244 | X-ROW | DMF0008_ErpEdiMaster.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 요소 |  | 15 (ACT:DMF0008_ErpEdiMaster.ExcelButton ACT) |
| WK-DMF0008-0245 | X-ROW | DMF0008_ErpEdiMaster.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:DMF0008_ErpEdiMaster.FindButton) |
| WK-DMF0008-0246 | X-ROW | DMF0008_ErpEdiMaster.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.FindData_Main: 진입점 집계 16검사 — NOT_RUN:12 · REVIEW:2 · PASS:2 |  | 7 (ACT:DMF0008_ErpEdiMaster.FindData_Main:8) |
| WK-DMF0008-0247 | X-ROW | DMF0008_ErpEdiMaster.FindData_SubCustome | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.FindData_SubCustomer: 진입점 집계 9검사 — NOT_RUN:5 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 8 (ACT:DMF0008_ErpEdiMaster.FindData_SubCus) |
| WK-DMF0008-0248 | X-ROW | DMF0008_ErpEdiMaster.FindData_SubRepair | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.FindData_SubRepair: 진입점 집계 15검사 — NOT_RUN:11 · REVIEW:2 · PASS:2 |  | 9 (ACT:DMF0008_ErpEdiMaster.FindData_SubRep) |
| WK-DMF0008-0249 | X-ROW | DMF0008_ErpEdiMaster.FindData_SubRepair_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.FindData_SubRepair_New: 진입점 집계 15검사 — NOT_RUN:11 · REVIEW:2 · PASS:2 |  | 9 (ACT:DMF0008_ErpEdiMaster.FindData_SubRep) |
| WK-DMF0008-0250 | X-ROW | DMF0008_ErpEdiMaster.FindData_SubSalesSi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.FindData_SubSalesSite: 진입점 집계 11검사 — NOT_RUN:7 · REVIEW:2 · PASS:2 |  | 15 (ACT:DMF0008_ErpEdiMaster.FindData_SubSal) |
| WK-DMF0008-0251 | X-ROW | DMF0008_ErpEdiMaster.FindData_SubSalesSi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.FindData_SubSalesSiteProjectM: 진입점 집계 16검사 — NOT_RUN:10 · REVIEW:3 · PASS:3 |  | 7 (ACT:DMF0008_ErpEdiMaster.FindData_SubSal) |
| WK-DMF0008-0252 | X-ROW | DMF0008_ErpEdiMaster.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.Form_Load) |
| WK-DMF0008-0253 | X-ROW | DMF0008_ErpEdiMaster.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.GetDayRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.GetDayRange) |
| WK-DMF0008-0254 | X-ROW | DMF0008_ErpEdiMaster.GetPlantbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.GetPlantbyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.GetPlantbyDivis) |
| WK-DMF0008-0255 | X-ROW | DMF0008_ErpEdiMaster.GetScmSiteInfobyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.GetScmSiteInfobyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.GetScmSiteInfob) |
| WK-DMF0008-0256 | X-ROW | DMF0008_ErpEdiMaster.GetUpdateHistory | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.GetUpdateHistory: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0008_ErpEdiMaster.GetUpdateHistor) |
| WK-DMF0008-0257 | X-ROW | DMF0008_ErpEdiMaster.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.InitControls: 진입점 집계 8검사 — NOT_RUN:6 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0008_ErpEdiMaster.InitControls:35) |
| WK-DMF0008-0258 | X-ROW | DMF0008_ErpEdiMaster.InitSaveDataTable | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.InitSaveDataTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.InitSaveDataTab) |
| WK-DMF0008-0259 | X-ROW | DMF0008_ErpEdiMaster.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.InitSpread) |
| WK-DMF0008-0260 | X-ROW | DMF0008_ErpEdiMaster.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.InsertButton) |
| WK-DMF0008-0261 | X-ROW | DMF0008_ErpEdiMaster.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.InsertRow: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 31 (ACT:DMF0008_ErpEdiMaster.InsertRow ACT:D) |
| WK-DMF0008-0262 | X-ROW | DMF0008_ErpEdiMaster.InsertRowLockRangeS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.InsertRowLockRangeSubSSPM: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_LOCK, 연결된 요소 검사 없음 |  | 13 (ACT:DMF0008_ErpEdiMaster.InsertRowLockRa) |
| WK-DMF0008-0263 | X-ROW | DMF0008_ErpEdiMaster.InsertRowLockRangeS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.InsertRowLockRangeSubSalesSit: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_LOCK, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0008_ErpEdiMaster.InsertRowLockRa) |
| WK-DMF0008-0264 | X-ROW | DMF0008_ErpEdiMaster.SaveSSPM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.SaveSSPM: 진입점 집계 10검사 — NOT_RUN:6 · PASS:4 (미실행 검사가 남아 판정필요) |  | 70 (ACT:DMF0008_ErpEdiMaster.SaveSSPM ACT:DM) |
| WK-DMF0008-0265 | X-ROW | DMF0008_ErpEdiMaster.SaveSalesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.SaveSalesSite: 진입점 집계 11검사 — NOT_RUN:8 · PASS:3 (미실행 검사가 남아 판정필요) |  | 98 (ACT:DMF0008_ErpEdiMaster.SaveSalesSite A) |
| WK-DMF0008-0266 | X-ROW | DMF0008_ErpEdiMaster.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.SetChangeControl: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0008_ErpEdiMaster.SetChangeContro) |
| WK-DMF0008-0267 | X-ROW | DMF0008_ErpEdiMaster.SetGridHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.SetGridHeader: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.SetGridHeader A) |
| WK-DMF0008-0268 | X-ROW | DMF0008_ErpEdiMaster.SetSubSSPMData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.SetSubSSPMData: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.SetSubSSPMData) |
| WK-DMF0008-0269 | X-ROW | DMF0008_ErpEdiMaster.SetSubSalesSiteData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.SetSubSalesSiteData: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.SetSubSalesSite) |
| WK-DMF0008-0270 | X-ROW | DMF0008_ErpEdiMaster.SpdSub_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.SpdSub_CellDoubleClick: 진입점 집계 5검사 — NOT_RUN:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 19 (ACT:DMF0008_ErpEdiMaster.SpdSub_CellDoub) |
| WK-DMF0008-0271 | X-ROW | DMF0008_ErpEdiMaster.btnStatusUpdate_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.btnStatusUpdate_Click: 진입점 집계 12검사 — NOT_RUN:6 · REVIEW:3 · PASS:2 · NOPATH:1 |  | 6 (ACT:DMF0008_ErpEdiMaster.btnStatusUpdate) |
| WK-DMF0008-0272 | X-ROW | DMF0008_ErpEdiMaster.clbDivision_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.clbDivision_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.clbDivision_Sel) |
| WK-DMF0008-0273 | X-ROW | DMF0008_ErpEdiMaster.shtSALES_SITEDataMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.shtSALES_SITEDataModel_Change: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0008_ErpEdiMaster.shtSALES_SITEDa) |
| WK-DMF0008-0274 | X-ROW | DMF0008_ErpEdiMaster.shtSSPMDataModel_Ch | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.shtSSPMDataModel_Changed: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.shtSSPMDataMode) |
| WK-DMF0008-0275 | X-ROW | DMF0008_ErpEdiMaster.shtSummaryDataModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.shtSummaryDataModel_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.shtSummaryDataM) |
| WK-DMF0008-0276 | X-ROW | DMF0008_ErpEdiMaster.spdMain_ComboSelCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdMain_ComboSelChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0008_ErpEdiMaster.spdMain_ComboSe) |
| WK-DMF0008-0277 | X-ROW | DMF0008_ErpEdiMaster.spdMain_LeaveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdMain_LeaveCell: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/UI_PROP, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0008_ErpEdiMaster.spdMain_LeaveCe) |
| WK-DMF0008-0278 | X-ROW | DMF0008_ErpEdiMaster.spdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.spdMain_TopChan) |
| WK-DMF0008-0279 | X-ROW | DMF0008_ErpEdiMaster.spdRepair_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdRepair_CellDoubleClick: 진입점 집계 5검사 — NOT_RUN:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0008_ErpEdiMaster.spdRepair_CellD) |
| WK-DMF0008-0280 | X-ROW | DMF0008_ErpEdiMaster.spdSub_ActiveSheetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_ActiveSheetChanging: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0008_ErpEdiMaster.spdSub_ActiveSh) |
| WK-DMF0008-0281 | X-ROW | DMF0008_ErpEdiMaster.spdSub_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_CellDoubleClick: 진입점 집계 6검사 — NOT_RUN:4 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 32 (ACT:DMF0008_ErpEdiMaster.spdSub_CellDoub) |
| WK-DMF0008-0282 | X-ROW | DMF0008_ErpEdiMaster.spdSub_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0008_ErpEdiMaster.spdSub_Changed ) |
| WK-DMF0008-0283 | X-ROW | DMF0008_ErpEdiMaster.spdSub_ComboSelChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_ComboSelChange: 진입점 집계 6검사 — REVIEW:3 · NOT_RUN:3 |  | 13 (ACT:DMF0008_ErpEdiMaster.spdSub_ComboSel) |
| WK-DMF0008-0284 | X-ROW | DMF0008_ErpEdiMaster.spdSub_SheetTabClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_SheetTabClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/RETURN, 연결된 요소 검사 |  | 10 (ACT:DMF0008_ErpEdiMaster.spdSub_SheetTab) |
| WK-DMF0008-0285 | X-ROW | DMF0008_ErpEdiMaster.spdSub_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0008_ErpEdiMaster.spdSub_TopChang) |
| WK-DMF0008-0286 | X-ROW | DMF0008_ErpEdiMaster.spdSummary_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0008_ErpEdiMaster.spdSummary_CellDoubleClick: 진입점 집계 5검사 — NOT_RUN:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0008_ErpEdiMaster.spdSummary_Cell) |
| WK-DMF0008-0287 | X-ROW | Modal cell (combo cell) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Modal cell (combo cell): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Modal cell (combo cell)) |
| WK-DMF0008-0288 | X-ROW | Repair | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Repair: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Repair) |
| WK-DMF0008-0289 | X-ROW | main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — main: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (main) |
| WK-DMF0008-0290 | M4 | (Repair) CustomerModal / ProjectByDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — (Repair) CustomerModal / ProjectByDivisionModal / : 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 ((Repair) CustomerModal / ProjectByDivisi) |
| WK-DMF0008-0291 | M4 | DMF0008_ErpEdiMaster.SpdSub_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0008_ErpEdiMaster.SpdSub_CellDoubleClick: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 73 (ACT:DMF0008_ErpEdiMaster.SpdSub_CellDoub) |
| WK-DMF0008-0292 | M4 | DMF0008_ErpEdiMaster.spdRepair_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0008_ErpEdiMaster.spdRepair_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0008_ErpEdiMaster.spdRepair_CellD) |
| WK-DMF0008-0293 | M4 | DMF0008_ErpEdiMaster.spdSub_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0008_ErpEdiMaster.spdSub_CellDoubleClick: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 132 (ACT:DMF0008_ErpEdiMaster.spdSub_CellDoub) |
| WK-DMF0008-0294 | M4 | DMF0008_ErpEdiMaster.spdSummary_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0008_ErpEdiMaster.spdSummary_CellDoubleClick: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0008_ErpEdiMaster.spdSummary_Cell) |
