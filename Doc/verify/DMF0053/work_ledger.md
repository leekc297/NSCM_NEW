# 작업 원장 — DMF0053 · 2026-10-26 12:51

> 검사 인스턴스 552건 중 PASS·NA 171건 외 **381건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 3 | 구현 위치 실존 |
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 18 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 96 | 실행 → PASS |
| W7 | 기대값 확정 | 261 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 248 · E2E 96 · 하네스 21 · 대조표 16
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 8건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 76 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  | 14 | 13 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 23 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G4 | DESIGN |  |  |  |  |  | 14 | 8 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 14 | 8 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C1 | CASCADE |  |  |  |  |  | 9 | 12 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F4 | DB |  |  |  |  |  | 11 | 9 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E4 | EDIT |  |  |  |  |  | 14 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  | 1 | 17 |  |  | 연쇄 자동 채움 |
| DB-SYN | DB |  |  |  |  | 8 |  | 9 |  |  | BE 계정 시노님·권한·대상 객체 |
| B4 | COMBO |  |  |  |  | 3 |  | 13 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 3 |  |  | 12 |  |  | 콤보 후보 정렬 = AS-IS |
| X-REASON | DESIGN |  |  |  |  |  |  | 13 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| H5 | DESIGN |  |  |  |  |  | 2 | 9 |  |  | 라벨 명칭 |
| A6 | GEN |  |  |  |  |  | 2 | 8 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-LOC | GEN |  | 3 |  |  |  |  | 6 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G5 | POPUP |  |  |  |  | 3 |  | 6 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 1 | 6 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 2 | 6 |  |  | 팝업 선택값 반영 |
| E1 | EDIT |  |  |  |  |  | 1 | 2 |  |  | 숫자 소수자리·정수·부호·범위 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0053-0001 | X-LOC | REQ:CHAT-20260828-UM05-DMF0053 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260828-UM05-DMF0053) |
| WK-DMF0053-0002 | X-LOC | REQ:CHAT-20260828-UM08-DMF0053 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260828-UM08-DMF0053) |
| WK-DMF0053-0003 | X-LOC | UM-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: data-grid/DataGrid.tsx 없음 |  | 1 (UM-06) |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0053-0004 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:DMF0053_CustFcstWaterfall.GetSpdTitl) |
| WK-DMF0053-0005 | B3 | cboDivision / Division*  / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division*  / Division | 있음(FE 소스) | 2 (ACT:DMF0053_CustFcstWaterfall.GetSpdTitl) |
| WK-DMF0053-0006 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 2 (ACT:DMF0053_CustFcstWaterfall.GetSpdTitl) |

## W5 검사기 연결 (18)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0053-0007 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:DMF0053_CustFcstWaterfall.GetSpdTitl) |
| WK-DMF0053-0008 | B4 | cboDivision / Division*  / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division*  / Division | 있음(FE 소스) | 2 (ACT:DMF0053_CustFcstWaterfall.GetSpdTitl) |
| WK-DMF0053-0009 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 2 (ACT:DMF0053_CustFcstWaterfall.GetSpdTitl) |
| WK-DMF0053-0010 | F2 | DMF0053 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0053 화면 | 판단불가(대상 단위 SCREEN) | 2 (MODAL:ColumnLayoutModal COMMON:UC-03) |
| WK-DMF0053-0011 | DB-SYN | DMF0003_GET_QTY_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_GET_QTY_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0053_CustFcstWaterfall.GetQtyData) |
| WK-DMF0053-0012 | DB-SYN | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0053_CustFcstWaterfall.GetBucketT) |
| WK-DMF0053-0013 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0053_CustFcstWaterfall.GetBizType) |
| WK-DMF0053-0014 | DB-SYN | SCM0001_GET_CUSTOMER_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_CUSTOMER_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0053_CustFcstWaterfall.GetCustome) |
| WK-DMF0053-0015 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0053_CustFcstWaterfall.GetItemTyp) |
| WK-DMF0053-0016 | DB-SYN | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0053_CustFcstWaterfall.GetPlantSi) |
| WK-DMF0053-0017 | DB-SYN | SCM0001_GET_SITE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SITE_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0053_CustFcstWaterfall.GetScmSite) |
| WK-DMF0053-0018 | DB-SYN | SCM0001_GET_TEAM_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_TEAM_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0053_CustFcstWaterfall.GetTeambyD) |
| WK-DMF0053-0019 | G03-WIRE | DMF0053 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0053 화면 | 판단불가(대상 단위 SCREEN) | 8 (ACT:DMF0053_CustFcstWaterfall..ctor ACT:) |
| WK-DMF0053-0020 | G5 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL C | 있음(FE 소스) | 1 (MODAL:ColumnLayoutModal) |
| WK-DMF0053-0021 | G5 | M | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL M | 있음(FE 소스) | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0053-0022 | G5 | cboDivision / Division*  / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division*  / Division | 있음(FE 소스) | 2 (ACT:DMF0053_CustFcstWaterfall.btnColumn_) |
| WK-DMF0053-0023 | H6 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL C | 있음(FE 소스) | 1 (MODAL:ColumnLayoutModal) |
| WK-DMF0053-0024 | H6 | M | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL M | 있음(FE 소스) | 1 (MODAL:MeasureSelectModal) |

## W6 검증 실행 (96)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0053-0025 | J2 | DMF0053 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0053 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 78 (CRUD:E15:SEARCH CRUD:E16:SEARCH MODAL:Co) |
| WK-DMF0053-0026 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0027 | C1 | cboDivision / Division*  / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division*  / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0028 | C1 | cboQTY / QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboQTY / QTY · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0029 | C1 | clbBizType / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbBizType / Biz Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0030 | C1 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 6 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0031 | C1 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0032 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0033 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 5 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0034 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0035 | C3 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (E14) |
| WK-DMF0053-0036 | G3 | DMF0053 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — DMF0053 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |
| WK-DMF0053-0037 | K4 | DMF0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0053 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 68 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |
| WK-DMF0053-0038 | F1 | DMF0053 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0053 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 2 (MODAL:ColumnLayoutModal COMMON:UC-03) |
| WK-DMF0053-0039 | F3 | DMF0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — DMF0053 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 2 (E14 HANDLER:spdMain_KeyUp) |
| WK-DMF0053-0040 | F4 | DMF0003_GET_QTY_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0003_GET_QTY_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetQtyData) |
| WK-DMF0053-0041 | F4 | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0003_GET_REPORT_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetBucketT) |
| WK-DMF0053-0042 | F4 | PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 87 (ACT:DMF0053_CustFcstWaterfall.FindButton) |
| WK-DMF0053-0043 | F4 | PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 86 (ACT:DMF0053_CustFcstWaterfall.FindButton) |
| WK-DMF0053-0044 | F4 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_BIZ_TYPE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetBizType) |
| WK-DMF0053-0045 | F4 | SCM0001_GET_CUSTOMER_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_CUSTOMER_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetCustome) |
| WK-DMF0053-0046 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetDivisio) |
| WK-DMF0053-0047 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetItemTyp) |
| WK-DMF0053-0048 | F4 | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetPlantSi) |
| WK-DMF0053-0049 | F4 | SCM0001_GET_SITE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SITE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetScmSite) |
| WK-DMF0053-0050 | F4 | SCM0001_GET_TEAM_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_TEAM_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetTeambyD) |
| WK-DMF0053-0051 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 14 (ACT:DMF0053_CustFcstWaterfall.DefineProp) |
| WK-DMF0053-0052 | G4 | cboDivision / Division*  / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division*  / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 12 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0053 | G4 | cboQTY / QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboQTY / QTY · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0054 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0055 | G4 | clbBizType / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbBizType / Biz Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0056 | G4 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0057 | G4 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbItemType / Item Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0058 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0059 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0060 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0061 | G4 | drpCreateDate / Input Date / Create Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpCreateDate / Input Date / Create Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData:7) |
| WK-DMF0053-0062 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData:6) |
| WK-DMF0053-0063 | G4 | txtItemId / Model / Nickname / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0064 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0065 | H4 | DMF0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0053 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 6 (E13 HANDLER:spdMain_TopChange ACT:DMF005) |
| WK-DMF0053-0066 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 26 (ACT:DMF0053_CustFcstWaterfall.InitSpread) |
| WK-DMF0053-0067 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 9 (ACT:DMF0053_CustFcstWaterfall.InitSpread) |
| WK-DMF0053-0068 | I1 | DMF0053 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0053 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 12 (A-01 A-02 A-03 A-04 A-05 ACT:DMF0053_Cus) |
| WK-DMF0053-0069 | SC1 | DMF0053 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0053 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (COMMON:UC-06 FilterMyDivision (#0) Filte) |
| WK-DMF0053-0070 | D6 | DMF0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0053 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (COMMON:UC-03) |
| WK-DMF0053-0071 | E1 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (E14) |
| WK-DMF0053-0072 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (A-01 ACT:DMF0053_CustFcstWaterfall.FindD) |
| WK-DMF0053-0073 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (A-02 A-04 ACT:DMF0053_CustFcstWaterfall.) |
| WK-DMF0053-0074 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0053_CustFcstWaterfall.EditButton) |
| WK-DMF0053-0075 | E4 | MSG00164 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00164 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (A-03 A-05 ACT:DMF0053_CustFcstWaterfall.) |
| WK-DMF0053-0076 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 18 (ACT:DMF0053_CustFcstWaterfall.SetSpreadC) |
| WK-DMF0053-0077 | E4 | cboDivision / Division*  / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division*  / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 2 (ACT:DMF0053_CustFcstWaterfall.SetClbVers) |
| WK-DMF0053-0078 | E4 | cboQTY / QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboQTY / QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 15 (ACT:DMF0053_CustFcstWaterfall.SetAmountC) |
| WK-DMF0053-0079 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0053_CustFcstWaterfall.SetSpreadC) |
| WK-DMF0053-0080 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:DMF0053_CustFcstWaterfall.SetClbVers) |
| WK-DMF0053-0081 | E4 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:DMF0053_CustFcstWaterfall.SetClbVers) |
| WK-DMF0053-0082 | E4 | drpCreateDate / Input Date / Create Date | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpCreateDate / Input Date / Create Date · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시 |  | 1 (ACT:DMF0053_CustFcstWaterfall.FindData:7) |
| WK-DMF0053-0083 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0053_CustFcstWaterfall.FindData:6) |
| WK-DMF0053-0084 | E4 | txtItemId / Model / Nickname / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지· |  | 2 (ACT:DMF0053_CustFcstWaterfall.SetClbVers) |
| WK-DMF0053-0085 | E4 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 2 (ACT:DMF0053_CustFcstWaterfall.SetClbVers) |
| WK-DMF0053-0086 | A10 | DMF0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0053 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 78 (ACT:DMF0053_CustFcstWaterfall.DefineProp) |
| WK-DMF0053-0087 | A6 | PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 87 (ACT:DMF0053_CustFcstWaterfall.FindButton) |
| WK-DMF0053-0088 | A6 | PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 84 (ACT:DMF0053_CustFcstWaterfall.FindButton) |
| WK-DMF0053-0089 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0090 | G1 | cboDivision / Division*  / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division*  / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0091 | G1 | clbBizType / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbBizType / Biz Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0092 | G1 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0093 | G1 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbItemType / Item Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0094 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0095 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0096 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0097 | G1 | drpCreateDate / Input Date / Create Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpCreateDate / Input Date / Create Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0098 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0099 | G1 | txtItemId / Model / Nickname / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0100 | G1 | txtOwner / Owner | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtOwner / Owner · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0101 | G1 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0102 | G1 | txtVersion / Date / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtVersion / Date / Version · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.FindData A) |
| WK-DMF0053-0103 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 14 (ACT:DMF0053_CustFcstWaterfall.DefineProp) |
| WK-DMF0053-0104 | G6 | cboDivision / Division*  / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division*  / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 12 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0105 | G6 | cboQTY / QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboQTY / QTY · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0106 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0107 | G6 | clbBizType / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbBizType / Biz Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0108 | G6 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0109 | G6 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0110 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0111 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0112 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0113 | G6 | drpCreateDate / Input Date / Create Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpCreateDate / Input Date / Create Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0114 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0115 | G6 | txtItemId / Model / Nickname / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0116 | G6 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0117 | X-REOPEN | DMF0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0053 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 16 (ACT:DMF0053_CustFcstWaterfall.Dispose AC) |
| WK-DMF0053-0118 | H6 | cboDivision / Division*  / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division*  / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:DMF0053_CustFcstWaterfall.btnColumn_) |
| WK-DMF0053-0119 | M4 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — C · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (MODAL:ColumnLayoutModal) |
| WK-DMF0053-0120 | M4 | M | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — M · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (MODAL:MeasureSelectModal) |

## W7 기대값 확정 (261)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0053-0121 | C1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E02: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0053-0122 | C1 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E03: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E03) |
| WK-DMF0053-0123 | C1 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E04: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0053-0124 | C1 | E09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E09: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E09) |
| WK-DMF0053-0125 | C1 | E19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E19: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E19) |
| WK-DMF0053-0126 | C1 | HANDLER:cboBucketType_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:cboBucketType_SelectedIndexChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboBucketType_SelectedIndexChang) |
| WK-DMF0053-0127 | C1 | HANDLER:cboDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:cboDivision_SelectedIndexChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboDivision_SelectedIndexChanged) |
| WK-DMF0053-0128 | C1 | HANDLER:cboQTY_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:cboQTY_SelectedIndexChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboQTY_SelectedIndexChanged) |
| WK-DMF0053-0129 | C1 | HANDLER:chkSum_CheckedChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:chkSum_CheckedChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:chkSum_CheckedChanged) |
| WK-DMF0053-0130 | C1 | HANDLER:clbCustomer_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbCustomer_SelectedIndexChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbCustomer_SelectedIndexChanged) |
| WK-DMF0053-0131 | C1 | HANDLER:clbTeam_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbTeam_SelectedIndexChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbTeam_SelectedIndexChanged) |
| WK-DMF0053-0132 | C1 | UM-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — UM-03: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (UM-03) |
| WK-DMF0053-0133 | C3 | DMF0053_CustFcstWaterfall.ClbPlantSite_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.ClbPlantSite_SelectedInd: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.ClbPlantSi) |
| WK-DMF0053-0134 | C3 | DMF0053_CustFcstWaterfall.ClbSalesSite_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.ClbSalesSite_SelectedInd: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.ClbSalesSi) |
| WK-DMF0053-0135 | C3 | DMF0053_CustFcstWaterfall.SetAmountCalcu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.SetAmountCalculating: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 24 (ACT:DMF0053_CustFcstWaterfall.SetAmountC) |
| WK-DMF0053-0136 | C3 | DMF0053_CustFcstWaterfall.SetChangeContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.SetChangeControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 17 (ACT:DMF0053_CustFcstWaterfall.SetChangeC) |
| WK-DMF0053-0137 | C3 | DMF0053_CustFcstWaterfall.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.SetSpreadC) |
| WK-DMF0053-0138 | C3 | DMF0053_CustFcstWaterfall.SetSpreadHeade | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadHeader: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0053_CustFcstWaterfall.SetSpreadH) |
| WK-DMF0053-0139 | C3 | DMF0053_CustFcstWaterfall.SetSpreadHeade | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0053_CustFcstWaterfall.SetSpreadH) |
| WK-DMF0053-0140 | C3 | DMF0053_CustFcstWaterfall.TxtProject_Cha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.TxtProject_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.TxtProject) |
| WK-DMF0053-0141 | C3 | DMF0053_CustFcstWaterfall.cboBucketType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.cboBucketType_SelectedIn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0053_CustFcstWaterfall.cboBucketT) |
| WK-DMF0053-0142 | C3 | DMF0053_CustFcstWaterfall.cboDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.cboDivision_SelectedInde: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 31 (ACT:DMF0053_CustFcstWaterfall.cboDivisio) |
| WK-DMF0053-0143 | C3 | DMF0053_CustFcstWaterfall.cboQTY_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.cboQTY_SelectedIndexChan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0053_CustFcstWaterfall.cboQTY_Sel) |
| WK-DMF0053-0144 | C3 | DMF0053_CustFcstWaterfall.chkColor_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.chkColor_CheckedChanged: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.chkColor_C) |
| WK-DMF0053-0145 | C3 | DMF0053_CustFcstWaterfall.chkSum_Checked | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.chkSum_CheckedChanged: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.chkSum_Che) |
| WK-DMF0053-0146 | C3 | DMF0053_CustFcstWaterfall.clbCustomer_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.clbCustomer_SelectedInde: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0053_CustFcstWaterfall.clbCustome) |
| WK-DMF0053-0147 | C3 | DMF0053_CustFcstWaterfall.clbTeam_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.clbTeam_SelectedIndexCha: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0053_CustFcstWaterfall.clbTeam_Se) |
| WK-DMF0053-0148 | C3 | DMF0053_CustFcstWaterfall.spdMain_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0053_CustFcstWaterfall.spdMain_ComboSelChange: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0053_CustFcstWaterfall.spdMain_Co) |
| WK-DMF0053-0149 | C3 | HANDLER:spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — HANDLER:spdMain_KeyUp: 행 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_KeyUp) |
| WK-DMF0053-0150 | B3 | DMF0053_CustFcstWaterfall.GetBizTypebyDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetBizTypebyDivision: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0053_CustFcstWaterfall.GetBizType) |
| WK-DMF0053-0151 | B3 | DMF0053_CustFcstWaterfall.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetBucketType: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetBucketT) |
| WK-DMF0053-0152 | B3 | DMF0053_CustFcstWaterfall.GetCustomerbyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetCustomerbyDivision: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0053_CustFcstWaterfall.GetCustome) |
| WK-DMF0053-0153 | B3 | DMF0053_CustFcstWaterfall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetDayRange: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0053_CustFcstWaterfall.GetDayRang) |
| WK-DMF0053-0154 | B3 | DMF0053_CustFcstWaterfall.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetDivision: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetDivisio) |
| WK-DMF0053-0155 | B3 | DMF0053_CustFcstWaterfall.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetItemType: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0053_CustFcstWaterfall.GetItemTyp) |
| WK-DMF0053-0156 | B3 | DMF0053_CustFcstWaterfall.GetLastWeekSun | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetLastWeekSunDayByDate: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0053_CustFcstWaterfall.GetLastWee) |
| WK-DMF0053-0157 | B3 | DMF0053_CustFcstWaterfall.GetPlantSiteby | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetPlantSitebyEndCustome: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.GetPlantSi) |
| WK-DMF0053-0158 | B3 | DMF0053_CustFcstWaterfall.GetQtyData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetQtyData: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetQtyData) |
| WK-DMF0053-0159 | B3 | DMF0053_CustFcstWaterfall.GetScmSitebyDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetScmSitebyDivision: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.GetScmSite) |
| WK-DMF0053-0160 | B3 | DMF0053_CustFcstWaterfall.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetSpdTitle: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0053_CustFcstWaterfall.GetSpdTitl) |
| WK-DMF0053-0161 | B3 | DMF0053_CustFcstWaterfall.GetTeambyDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0053_CustFcstWaterfall.GetTeambyDivision: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0053_CustFcstWaterfall.GetTeambyD) |
| WK-DMF0053-0162 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0053-0163 | B4 | DMF0053_CustFcstWaterfall.GetBizTypebyDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetBizTypebyDivision: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0053_CustFcstWaterfall.GetBizType) |
| WK-DMF0053-0164 | B4 | DMF0053_CustFcstWaterfall.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetBucketType: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetBucketT) |
| WK-DMF0053-0165 | B4 | DMF0053_CustFcstWaterfall.GetCustomerbyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetCustomerbyDivision: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0053_CustFcstWaterfall.GetCustome) |
| WK-DMF0053-0166 | B4 | DMF0053_CustFcstWaterfall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetDayRange: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0053_CustFcstWaterfall.GetDayRang) |
| WK-DMF0053-0167 | B4 | DMF0053_CustFcstWaterfall.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetDivision: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetDivisio) |
| WK-DMF0053-0168 | B4 | DMF0053_CustFcstWaterfall.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetItemType: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0053_CustFcstWaterfall.GetItemTyp) |
| WK-DMF0053-0169 | B4 | DMF0053_CustFcstWaterfall.GetLastWeekSun | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetLastWeekSunDayByDate: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0053_CustFcstWaterfall.GetLastWee) |
| WK-DMF0053-0170 | B4 | DMF0053_CustFcstWaterfall.GetPlantSiteby | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetPlantSitebyEndCustome: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.GetPlantSi) |
| WK-DMF0053-0171 | B4 | DMF0053_CustFcstWaterfall.GetQtyData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetQtyData: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetQtyData) |
| WK-DMF0053-0172 | B4 | DMF0053_CustFcstWaterfall.GetScmSitebyDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetScmSitebyDivision: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.GetScmSite) |
| WK-DMF0053-0173 | B4 | DMF0053_CustFcstWaterfall.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetSpdTitle: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0053_CustFcstWaterfall.GetSpdTitl) |
| WK-DMF0053-0174 | B4 | DMF0053_CustFcstWaterfall.GetTeambyDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0053_CustFcstWaterfall.GetTeambyDivision: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0053_CustFcstWaterfall.GetTeambyD) |
| WK-DMF0053-0175 | DB-SYN | A-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — A-01: 행 집계 — DB-SYN 11요소: NOPATH:8 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (A-01) |
| WK-DMF0053-0176 | DB-SYN | A-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — A-02: 행 집계 — DB-SYN 11요소: NOPATH:8 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (A-02) |
| WK-DMF0053-0177 | DB-SYN | A-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — A-03: 행 집계 — DB-SYN 11요소: NOPATH:8 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (A-03) |
| WK-DMF0053-0178 | DB-SYN | A-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — A-04: 행 집계 — DB-SYN 11요소: NOPATH:8 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (A-04) |
| WK-DMF0053-0179 | DB-SYN | A-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — A-05: 행 집계 — DB-SYN 11요소: NOPATH:8 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (A-05) |
| WK-DMF0053-0180 | DB-SYN | B-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — B-02: 행 집계 — DB-SYN 11요소: NOPATH:8 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (B-02) |
| WK-DMF0053-0181 | DB-SYN | DMF0053_CustFcstWaterfall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0053_CustFcstWaterfall.GetDayRange: 진입점 집계 — DB-SYN 11요소: NOPATH:8 · PASS:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetDayRang) |
| WK-DMF0053-0182 | DB-SYN | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:FindData: 행 집계 — DB-SYN 11요소: NOPATH:8 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0053-0183 | DB-SYN | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — UM-05: 행 집계 — DB-SYN 11요소: NOPATH:8 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (UM-05) |
| WK-DMF0053-0184 | F4 | A-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — A-01: 행 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (A-01) |
| WK-DMF0053-0185 | F4 | A-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — A-02: 행 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (A-02) |
| WK-DMF0053-0186 | F4 | A-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — A-03: 행 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (A-03) |
| WK-DMF0053-0187 | F4 | A-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — A-04: 행 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (A-04) |
| WK-DMF0053-0188 | F4 | A-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — A-05: 행 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (A-05) |
| WK-DMF0053-0189 | F4 | B-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — B-02: 행 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (B-02) |
| WK-DMF0053-0190 | F4 | DMF0053_CustFcstWaterfall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0053_CustFcstWaterfall.GetDayRange: 진입점 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.GetDayRang) |
| WK-DMF0053-0191 | F4 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:FindData: 행 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0053-0192 | F4 | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — UM-05: 행 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (UM-05) |
| WK-DMF0053-0193 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0053-0194 | G4 | FilterBizType (#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterBizType (#3): 행 집계 — G4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterBizType (#3)) |
| WK-DMF0053-0195 | G4 | FilterEndCustomerByDivision (#2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterEndCustomerByDivision (#2): 행 집계 — G4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterEndCustomerByDivision (#2)) |
| WK-DMF0053-0196 | G4 | FilterFromSiteByDivision (#5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterFromSiteByDivision (#5): 행 집계 — G4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterFromSiteByDivision (#5)) |
| WK-DMF0053-0197 | G4 | FilterMyDivision (#0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterMyDivision (#0): 행 집계 — G4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterMyDivision (#0)) |
| WK-DMF0053-0198 | G4 | FilterSiteByEndCustomer (#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterSiteByEndCustomer (#4): 행 집계 — G4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterSiteByEndCustomer (#4)) |
| WK-DMF0053-0199 | G4 | FilterTeambyDivision (#1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterTeambyDivision (#1): 행 집계 — G4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterTeambyDivision (#1)) |
| WK-DMF0053-0200 | G4 | ReportBucketType / QtyType / ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — ReportBucketType / QtyType / ItemType: 행 집계 — G4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ReportBucketType / QtyType / ItemType) |
| WK-DMF0053-0201 | H5 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-03: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0053-0202 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0053-0203 | H5 | DMF0053_CustFcstWaterfall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0053_CustFcstWaterfall.CreateSpread: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0053_CustFcstWaterfall.CreateSpre) |
| WK-DMF0053-0204 | H5 | DMF0053_CustFcstWaterfall.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadColumn: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.SetSpreadC) |
| WK-DMF0053-0205 | H5 | DMF0053_CustFcstWaterfall.SetSpreadHeade | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadHeader: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0053_CustFcstWaterfall.SetSpreadH) |
| WK-DMF0053-0206 | H5 | DMF0053_CustFcstWaterfall.SetSpreadHeade | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0053_CustFcstWaterfall.SetSpreadH) |
| WK-DMF0053-0207 | H5 | E13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E13: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E13) |
| WK-DMF0053-0208 | H5 | UM-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — UM-06: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (UM-06) |
| WK-DMF0053-0209 | H5 | UM-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — UM-07: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (UM-07) |
| WK-DMF0053-0210 | X-REASON | A-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A-06 EditButton L587~594 / 편집 시도 (F2)  해당없음 — 편집 진입점 자체 미노출 (hotkeyConfig insert/delete/save=false CustFcstWate |  | 1 (A-06) |
| WK-DMF0053-0211 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4)  해당없음 — 편집 기능  |  | 1 (COMMON:UC-02) |
| WK-DMF0053-0212 | X-REASON | E05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E05 `ClbSalesSite_SelectedIndexChanged` / —  제외 — AS-IS 미배선 사문 (Designer·InitEvent 에 += 없음 + 본문 SetClbVersion=n |  | 1 (E05) |
| WK-DMF0053-0213 | X-REASON | E06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E06 `ClbPlantSite_SelectedIndexChanged` / —  제외 — 동일 사문 (E05) 제외 |  | 1 (E06) |
| WK-DMF0053-0214 | X-REASON | E07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E07 `TxtProject_Changed` / —  제외 — 동일 사문 (E05) 제외 |  | 1 (E07) |
| WK-DMF0053-0215 | X-REASON | E08 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E08 `TxtItemId_Enter` / —  제외 — 동일 사문 (E05) 제외 |  | 1 (E08) |
| WK-DMF0053-0216 | X-REASON | HANDLER:ClbPlantSite_SelectedIndexChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:ClbPlantSite_SelectedIndexChanged AS-IS `DMF0053_CustFcstWaterfall.cs:1099` (라이브 3행) · **사문(빈 몸통)**  제외 |  | 1 (HANDLER:ClbPlantSite_SelectedIndexChange) |
| WK-DMF0053-0217 | X-REASON | HANDLER:ClbSalesSite_SelectedIndexChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:ClbSalesSite_SelectedIndexChanged AS-IS `DMF0053_CustFcstWaterfall.cs:1094` (라이브 3행) · **사문(빈 몸통)**  제외 |  | 1 (HANDLER:ClbSalesSite_SelectedIndexChange) |
| WK-DMF0053-0218 | X-REASON | HANDLER:EditButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:EditButton AS-IS `DMF0053_CustFcstWaterfall.cs:587` (라이브 7행)  해당없음 — 편집 진입점 미노출 (A-06 동일 — MSG00109 도달  |  | 1 (HANDLER:EditButton) |
| WK-DMF0053-0219 | X-REASON | HANDLER:TxtItemId_Enter | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:TxtItemId_Enter AS-IS `DMF0053_CustFcstWaterfall.cs:1109` (라이브 3행) · **사문(빈 몸통)**  제외 — 사문 — E08 제외 |  | 1 (HANDLER:TxtItemId_Enter) |
| WK-DMF0053-0220 | X-REASON | HANDLER:TxtProject_Changed | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:TxtProject_Changed AS-IS `DMF0053_CustFcstWaterfall.cs:1104` (라이브 3행) · **사문(빈 몸통)**  제외 — 사문 — E07 제외 |  | 1 (HANDLER:TxtProject_Changed) |
| WK-DMF0053-0221 | X-REASON | HANDLER:btnVersion_Click | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:btnVersion_Click AS-IS `DMF0053_CustFcstWaterfall.cs:1657` (라이브 14행)  제외 — Version 미구현 (E21) 제외 |  | 1 (HANDLER:btnVersion_Click) |
| WK-DMF0053-0222 | X-REASON | HANDLER:txtVersion_KeyDown | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:txtVersion_KeyDown AS-IS `DMF0053_CustFcstWaterfall.cs:1676` (라이브 3행) · **사문(빈 몸통)**  제외 — Version 미구현  |  | 1 (HANDLER:txtVersion_KeyDown) |
| WK-DMF0053-0223 | E1 | HANDLER:spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — HANDLER:spdMain_KeyUp: 행 집계 — E1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_KeyUp) |
| WK-DMF0053-0224 | E1 | UM-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — UM-04: 행 집계 — E1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (UM-04) |
| WK-DMF0053-0225 | E4 | DMF0053_CustFcstWaterfall.SetAmountCalcu | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0053_CustFcstWaterfall.SetAmountCalculating: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 24 (ACT:DMF0053_CustFcstWaterfall.SetAmountC) |
| WK-DMF0053-0226 | E4 | DMF0053_CustFcstWaterfall.SetChangeContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0053_CustFcstWaterfall.SetChangeControl: 진입점 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 17 (ACT:DMF0053_CustFcstWaterfall.SetChangeC) |
| WK-DMF0053-0227 | E4 | DMF0053_CustFcstWaterfall.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadColumn: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.SetSpreadC) |
| WK-DMF0053-0228 | E4 | DMF0053_CustFcstWaterfall.SetSpreadHeade | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadHeader: 진입점 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0053_CustFcstWaterfall.SetSpreadH) |
| WK-DMF0053-0229 | E4 | DMF0053_CustFcstWaterfall.SetSpreadHeade | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0053_CustFcstWaterfall.SetSpreadH) |
| WK-DMF0053-0230 | A1 | A-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-01: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (A-01) |
| WK-DMF0053-0231 | A1 | A-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (A-02) |
| WK-DMF0053-0232 | A1 | A-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-03: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (A-03) |
| WK-DMF0053-0233 | A1 | A-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-04: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (A-04) |
| WK-DMF0053-0234 | A1 | A-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-05: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (A-05) |
| WK-DMF0053-0235 | A1 | B-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (B-02) |
| WK-DMF0053-0236 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-03) |
| WK-DMF0053-0237 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-06) |
| WK-DMF0053-0238 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-DMF0053-0239 | A1 | CRUD:E15:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E15:SEARCH: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (CRUD:E15:SEARCH) |
| WK-DMF0053-0240 | A1 | CRUD:E16:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E16:SEARCH: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (CRUD:E16:SEARCH) |
| WK-DMF0053-0241 | A1 | FilterBizType (#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterBizType (#3): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterBizType (#3)) |
| WK-DMF0053-0242 | A1 | FilterEndCustomerByDivision (#2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterEndCustomerByDivision (#2): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterEndCustomerByDivision (#2)) |
| WK-DMF0053-0243 | A1 | FilterFromSiteByDivision (#5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterFromSiteByDivision (#5): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterFromSiteByDivision (#5)) |
| WK-DMF0053-0244 | A1 | FilterMyDivision (#0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterMyDivision (#0): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterMyDivision (#0)) |
| WK-DMF0053-0245 | A1 | FilterSiteByEndCustomer (#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterSiteByEndCustomer (#4): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterSiteByEndCustomer (#4)) |
| WK-DMF0053-0246 | A1 | FilterTeambyDivision (#1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterTeambyDivision (#1): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterTeambyDivision (#1)) |
| WK-DMF0053-0247 | A1 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindButton: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (HANDLER:FindButton) |
| WK-DMF0053-0248 | A1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindData: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (HANDLER:FindData) |
| WK-DMF0053-0249 | A1 | PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL: 골든 비교 케이스 없음(PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL — 팝업·보조 SP 는 |  | 87 (ACT:DMF0053_CustFcstWaterfall.FindButton) |
| WK-DMF0053-0250 | A1 | PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 84 (ACT:DMF0053_CustFcstWaterfall.FindButton) |
| WK-DMF0053-0251 | A1 | ReportBucketType / QtyType / ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ReportBucketType / QtyType / ItemType: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (ReportBucketType / QtyType / ItemType) |
| WK-DMF0053-0252 | A1 | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — UM-05: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (UM-05) |
| WK-DMF0053-0253 | A6 | A-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — A-01: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (A-01) |
| WK-DMF0053-0254 | A6 | A-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — A-02: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (A-02) |
| WK-DMF0053-0255 | A6 | A-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — A-03: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (A-03) |
| WK-DMF0053-0256 | A6 | A-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — A-04: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (A-04) |
| WK-DMF0053-0257 | A6 | A-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — A-05: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (A-05) |
| WK-DMF0053-0258 | A6 | B-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — B-02: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (B-02) |
| WK-DMF0053-0259 | A6 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — HANDLER:FindData: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0053-0260 | A6 | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — UM-05: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (UM-05) |
| WK-DMF0053-0261 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0053-0262 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0053-0263 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0053-0264 | G1 | CRUD:E15:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:E15:SEARCH: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E15:SEARCH) |
| WK-DMF0053-0265 | G1 | CRUD:E16:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:E16:SEARCH: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E16:SEARCH) |
| WK-DMF0053-0266 | G1 | FilterBizType (#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterBizType (#3): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterBizType (#3)) |
| WK-DMF0053-0267 | G1 | FilterEndCustomerByDivision (#2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterEndCustomerByDivision (#2): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterEndCustomerByDivision (#2)) |
| WK-DMF0053-0268 | G1 | FilterFromSiteByDivision (#5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterFromSiteByDivision (#5): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterFromSiteByDivision (#5)) |
| WK-DMF0053-0269 | G1 | FilterMyDivision (#0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterMyDivision (#0): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterMyDivision (#0)) |
| WK-DMF0053-0270 | G1 | FilterSiteByEndCustomer (#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterSiteByEndCustomer (#4): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterSiteByEndCustomer (#4)) |
| WK-DMF0053-0271 | G1 | FilterTeambyDivision (#1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterTeambyDivision (#1): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterTeambyDivision (#1)) |
| WK-DMF0053-0272 | G1 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:FindButton: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindButton) |
| WK-DMF0053-0273 | G1 | ReportBucketType / QtyType / ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ReportBucketType / QtyType / ItemType: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ReportBucketType / QtyType / ItemType) |
| WK-DMF0053-0274 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0053-0275 | G6 | FilterBizType (#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterBizType (#3): 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterBizType (#3)) |
| WK-DMF0053-0276 | G6 | FilterEndCustomerByDivision (#2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterEndCustomerByDivision (#2): 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterEndCustomerByDivision (#2)) |
| WK-DMF0053-0277 | G6 | FilterFromSiteByDivision (#5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterFromSiteByDivision (#5): 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterFromSiteByDivision (#5)) |
| WK-DMF0053-0278 | G6 | FilterMyDivision (#0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterMyDivision (#0): 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterMyDivision (#0)) |
| WK-DMF0053-0279 | G6 | FilterSiteByEndCustomer (#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterSiteByEndCustomer (#4): 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterSiteByEndCustomer (#4)) |
| WK-DMF0053-0280 | G6 | FilterTeambyDivision (#1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterTeambyDivision (#1): 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterTeambyDivision (#1)) |
| WK-DMF0053-0281 | G6 | ReportBucketType / QtyType / ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — ReportBucketType / QtyType / ItemType: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ReportBucketType / QtyType / ItemType) |
| WK-DMF0053-0282 | X-LOC | FilterBizType (#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FilterBizType (#3): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FilterBizType (#3)) |
| WK-DMF0053-0283 | X-LOC | FilterEndCustomerByDivision (#2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FilterEndCustomerByDivision (#2): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FilterEndCustomerByDivision (#2)) |
| WK-DMF0053-0284 | X-LOC | FilterFromSiteByDivision (#5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FilterFromSiteByDivision (#5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FilterFromSiteByDivision (#5)) |
| WK-DMF0053-0285 | X-LOC | FilterSiteByEndCustomer (#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FilterSiteByEndCustomer (#4): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FilterSiteByEndCustomer (#4)) |
| WK-DMF0053-0286 | X-LOC | FilterTeambyDivision (#1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FilterTeambyDivision (#1): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FilterTeambyDivision (#1)) |
| WK-DMF0053-0287 | X-LOC | ReportBucketType / QtyType / ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ReportBucketType / QtyType / ItemType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ReportBucketType / QtyType / ItemType) |
| WK-DMF0053-0288 | X-ROW | B-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B-01) |
| WK-DMF0053-0289 | X-ROW | C-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-02) |
| WK-DMF0053-0290 | X-ROW | DMF0053_CustFcstWaterfall.ClbPlantSite_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.ClbPlantSite_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.ClbPlantSi) |
| WK-DMF0053-0291 | X-ROW | DMF0053_CustFcstWaterfall.ClbSalesSite_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.ClbSalesSite_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.ClbSalesSi) |
| WK-DMF0053-0292 | X-ROW | DMF0053_CustFcstWaterfall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.CreateSpre) |
| WK-DMF0053-0293 | X-ROW | DMF0053_CustFcstWaterfall.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.DefineProp) |
| WK-DMF0053-0294 | X-ROW | DMF0053_CustFcstWaterfall.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.EditButton: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.EditButton) |
| WK-DMF0053-0295 | X-ROW | DMF0053_CustFcstWaterfall.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연 |  | 15 (ACT:DMF0053_CustFcstWaterfall.ExcelButto) |
| WK-DMF0053-0296 | X-ROW | DMF0053_CustFcstWaterfall.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:DMF0053_CustFcstWaterfall.FindButton) |
| WK-DMF0053-0297 | X-ROW | DMF0053_CustFcstWaterfall.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.FindData: 진입점 집계 31검사 — NOT_RUN:27 · REVIEW:2 · PASS:2 |  | 11 (ACT:DMF0053_CustFcstWaterfall.FindData:6) |
| WK-DMF0053-0298 | X-ROW | DMF0053_CustFcstWaterfall.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.Form_Load) |
| WK-DMF0053-0299 | X-ROW | DMF0053_CustFcstWaterfall.GetBizTypebyDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetBizTypebyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetBizType) |
| WK-DMF0053-0300 | X-ROW | DMF0053_CustFcstWaterfall.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetBucketType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetBucketT) |
| WK-DMF0053-0301 | X-ROW | DMF0053_CustFcstWaterfall.GetCustomerbyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetCustomerbyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetCustome) |
| WK-DMF0053-0302 | X-ROW | DMF0053_CustFcstWaterfall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetDayRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetDayRang) |
| WK-DMF0053-0303 | X-ROW | DMF0053_CustFcstWaterfall.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetDivisio) |
| WK-DMF0053-0304 | X-ROW | DMF0053_CustFcstWaterfall.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetItemType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetItemTyp) |
| WK-DMF0053-0305 | X-ROW | DMF0053_CustFcstWaterfall.GetLastWeekSun | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetLastWeekSunDayByDate: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetLastWee) |
| WK-DMF0053-0306 | X-ROW | DMF0053_CustFcstWaterfall.GetPlantSiteby | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetPlantSitebyEndCustome: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetPlantSi) |
| WK-DMF0053-0307 | X-ROW | DMF0053_CustFcstWaterfall.GetQtyData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetQtyData: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetQtyData) |
| WK-DMF0053-0308 | X-ROW | DMF0053_CustFcstWaterfall.GetScmSitebyDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetScmSitebyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetScmSite) |
| WK-DMF0053-0309 | X-ROW | DMF0053_CustFcstWaterfall.GetTeambyDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.GetTeambyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.GetTeambyD) |
| WK-DMF0053-0310 | X-ROW | DMF0053_CustFcstWaterfall.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.InitControls: 진입점 집계 38검사 — NOT_RUN:38 (미실행 검사가 남아 판정필요) |  | 11 (ACT:DMF0053_CustFcstWaterfall.InitContro) |
| WK-DMF0053-0311 | X-ROW | DMF0053_CustFcstWaterfall.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.InitSpread: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.InitSpread) |
| WK-DMF0053-0312 | X-ROW | DMF0053_CustFcstWaterfall.InitSpreadFoot | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.InitSpreadFooterSum: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.InitSpread) |
| WK-DMF0053-0313 | X-ROW | DMF0053_CustFcstWaterfall.SetAmountCalcu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.SetAmountCalculating: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.SetAmountC) |
| WK-DMF0053-0314 | X-ROW | DMF0053_CustFcstWaterfall.SetChangeContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0053_CustFcstWaterfall.SetChangeC) |
| WK-DMF0053-0315 | X-ROW | DMF0053_CustFcstWaterfall.SetClbVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.SetClbVersion: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.SetClbVers) |
| WK-DMF0053-0316 | X-ROW | DMF0053_CustFcstWaterfall.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadColumn: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0053_CustFcstWaterfall.SetSpreadC) |
| WK-DMF0053-0317 | X-ROW | DMF0053_CustFcstWaterfall.SetSpreadHeade | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadHeader: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0053_CustFcstWaterfall.SetSpreadH) |
| WK-DMF0053-0318 | X-ROW | DMF0053_CustFcstWaterfall.SetSpreadHeade | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.SetSpreadH) |
| WK-DMF0053-0319 | X-ROW | DMF0053_CustFcstWaterfall.TxtItemId_Ente | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.TxtItemId_Enter: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:DMF0053_CustFcstWaterfall.TxtItemId_) |
| WK-DMF0053-0320 | X-ROW | DMF0053_CustFcstWaterfall.TxtProject_Cha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.TxtProject_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.TxtProject) |
| WK-DMF0053-0321 | X-ROW | DMF0053_CustFcstWaterfall.btnColumn_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.btnColumn_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.btnColumn_) |
| WK-DMF0053-0322 | X-ROW | DMF0053_CustFcstWaterfall.btnItemId_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.btnItemId_) |
| WK-DMF0053-0323 | X-ROW | DMF0053_CustFcstWaterfall.btnMeasure_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.btnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.btnMeasure) |
| WK-DMF0053-0324 | X-ROW | DMF0053_CustFcstWaterfall.btnOwner_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.btnOwner_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.btnOwner_C) |
| WK-DMF0053-0325 | X-ROW | DMF0053_CustFcstWaterfall.btnProject_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.btnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0053_CustFcstWaterfall.btnProject) |
| WK-DMF0053-0326 | X-ROW | DMF0053_CustFcstWaterfall.btnVersion_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.btnVersion_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0053_CustFcstWaterfall.btnVersion) |
| WK-DMF0053-0327 | X-ROW | DMF0053_CustFcstWaterfall.cboBucketType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.cboBucketType_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.cboBucketT) |
| WK-DMF0053-0328 | X-ROW | DMF0053_CustFcstWaterfall.cboDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.cboDivision_SelectedInde: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.cboDivisio) |
| WK-DMF0053-0329 | X-ROW | DMF0053_CustFcstWaterfall.cboQTY_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.cboQTY_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.cboQTY_Sel) |
| WK-DMF0053-0330 | X-ROW | DMF0053_CustFcstWaterfall.chkColor_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.chkColor_CheckedChanged: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.chkColor_C) |
| WK-DMF0053-0331 | X-ROW | DMF0053_CustFcstWaterfall.chkSum_Checked | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.chkSum_Che) |
| WK-DMF0053-0332 | X-ROW | DMF0053_CustFcstWaterfall.clbCustomer_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.clbCustomer_SelectedInde: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.clbCustome) |
| WK-DMF0053-0333 | X-ROW | DMF0053_CustFcstWaterfall.clbTeam_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.clbTeam_SelectedIndexCha: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0053_CustFcstWaterfall.clbTeam_Se) |
| WK-DMF0053-0334 | X-ROW | DMF0053_CustFcstWaterfall.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 21 (ACT:DMF0053_CustFcstWaterfall.fnValidati) |
| WK-DMF0053-0335 | X-ROW | DMF0053_CustFcstWaterfall.spdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.spdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0053_CustFcstWaterfall.spdMain_Ce) |
| WK-DMF0053-0336 | X-ROW | DMF0053_CustFcstWaterfall.spdMain_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.spdMain_ComboSelChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0053_CustFcstWaterfall.spdMain_Co) |
| WK-DMF0053-0337 | X-ROW | DMF0053_CustFcstWaterfall.spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.spdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:DMF0053_CustFcstWaterfall.spdMain_Ke) |
| WK-DMF0053-0338 | X-ROW | DMF0053_CustFcstWaterfall.spdMain_TopCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0053_CustFcstWaterfall.spdMain_To) |
| WK-DMF0053-0339 | X-ROW | DMF0053_CustFcstWaterfall.txtVersion_Key | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0053_CustFcstWaterfall.txtVersion_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:DMF0053_CustFcstWaterfall.txtVersion) |
| WK-DMF0053-0340 | X-ROW | E17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E17: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E17) |
| WK-DMF0053-0341 | X-ROW | E18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E18: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E18) |
| WK-DMF0053-0342 | X-ROW | E23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E23: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E23) |
| WK-DMF0053-0343 | X-ROW | HANDLER:ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0053-0344 | X-ROW | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:Form_Load: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:Form_Load) |
| WK-DMF0053-0345 | X-ROW | HANDLER:btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnColumn_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnColumn_Click) |
| WK-DMF0053-0346 | X-ROW | HANDLER:btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnItemId_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnItemId_Click) |
| WK-DMF0053-0347 | X-ROW | HANDLER:btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnMeasure_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnMeasure_Click) |
| WK-DMF0053-0348 | X-ROW | HANDLER:btnOwner_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnOwner_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnOwner_Click) |
| WK-DMF0053-0349 | X-ROW | HANDLER:btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnProject_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnProject_Click) |
| WK-DMF0053-0350 | X-ROW | REQ:CHAT-20260828-UM01-DMF0053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM01-DMF0053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM01-DMF0053) |
| WK-DMF0053-0351 | X-ROW | REQ:CHAT-20260828-UM02-DMF0053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM02-DMF0053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM02-DMF0053) |
| WK-DMF0053-0352 | X-ROW | REQ:CHAT-20260828-UM03-DMF0053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM03-DMF0053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM03-DMF0053) |
| WK-DMF0053-0353 | X-ROW | REQ:CHAT-20260828-UM04-DMF0053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM04-DMF0053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM04-DMF0053) |
| WK-DMF0053-0354 | X-ROW | REQ:CHAT-20260828-UM05-DMF0053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM05-DMF0053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM05-DMF0053) |
| WK-DMF0053-0355 | X-ROW | REQ:CHAT-20260828-UM06-DMF0053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM06-DMF0053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM06-DMF0053) |
| WK-DMF0053-0356 | X-ROW | REQ:CHAT-20260828-UM07-DMF0053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM07-DMF0053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM07-DMF0053) |
| WK-DMF0053-0357 | X-ROW | REQ:CHAT-20260828-UM08-DMF0053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM08-DMF0053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM08-DMF0053) |
| WK-DMF0053-0358 | X-ROW | REQ:CHAT-20260828-UM11-DMF0053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM11-DMF0053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM11-DMF0053) |
| WK-DMF0053-0359 | X-ROW | REQ:CHAT-20260828-UM12-DMF0053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM12-DMF0053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM12-DMF0053) |
| WK-DMF0053-0360 | X-ROW | UM-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-01) |
| WK-DMF0053-0361 | X-ROW | UM-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-02) |
| WK-DMF0053-0362 | X-ROW | UM-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-08) |
| WK-DMF0053-0363 | X-ROW | UM-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-11) |
| WK-DMF0053-0364 | G5 | DMF0053_CustFcstWaterfall.spdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0053_CustFcstWaterfall.spdMain_CellDoubleClick: 진입점 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 37 (ACT:DMF0053_CustFcstWaterfall.spdMain_Ce) |
| WK-DMF0053-0365 | G5 | E11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E11: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (E11) |
| WK-DMF0053-0366 | G5 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0053-0367 | G5 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-DMF0053-0368 | G5 | MODAL:OwnerByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:OwnerByDivisionModal: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:OwnerByDivisionModal) |
| WK-DMF0053-0369 | G5 | MODAL:ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ProjectByDivisionModal: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-DMF0053-0370 | H6 | DMF0053_CustFcstWaterfall.spdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0053_CustFcstWaterfall.spdMain_CellDoubleClick: 진입점 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 37 (ACT:DMF0053_CustFcstWaterfall.spdMain_Ce) |
| WK-DMF0053-0371 | H6 | E11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E11: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E11) |
| WK-DMF0053-0372 | H6 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0053-0373 | H6 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-DMF0053-0374 | H6 | MODAL:OwnerByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:OwnerByDivisionModal: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:OwnerByDivisionModal) |
| WK-DMF0053-0375 | H6 | MODAL:ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ProjectByDivisionModal: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-DMF0053-0376 | M4 | DMF0053_CustFcstWaterfall.spdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0053_CustFcstWaterfall.spdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 37 (ACT:DMF0053_CustFcstWaterfall.spdMain_Ce) |
| WK-DMF0053-0377 | M4 | E11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E11: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E11) |
| WK-DMF0053-0378 | M4 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0053-0379 | M4 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-DMF0053-0380 | M4 | MODAL:OwnerByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:OwnerByDivisionModal: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:OwnerByDivisionModal) |
| WK-DMF0053-0381 | M4 | MODAL:ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ProjectByDivisionModal: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ProjectByDivisionModal) |
