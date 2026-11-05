# 작업 원장 — SCP0096 · 2026-10-31 05:46

> 검사 인스턴스 374건 중 PASS·NA 297건 외 **77건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_FE** — FE 항목은 적용 대상. 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 18 | 재판정 PASS |
| W5 | 검사기 연결 | 8 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 26 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 25 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 25 · 사람 판정 / AS-IS 원문 확인 → 재판정 22 · 화면 FE 8 · 하네스 8 · FE 6 · 대조표 4 · 사람판정 3 · 공통 컴포넌트 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 16 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  |  |  |  | 13 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-ROW | GEN |  |  | 4 |  |  |  | 2 |  | 6 | 대조표 행이 서술한 동작을 화면에서 재현 |
| G4 | DESIGN |  |  | 8 |  | 1 |  |  |  |  | 조회조건 표시·라벨·활성 |
| H5 | DESIGN |  |  |  |  |  |  | 1 |  | 6 | 라벨 명칭 |
| A6 | GEN |  |  | 3 |  |  |  | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B3 | COMBO |  |  |  |  | 4 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B4 | COMBO |  |  |  |  | 2 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C4 | CASCADE |  |  | 1 |  |  |  |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| G3 | COMMON |  |  | 1 |  |  |  |  |  |  | 조회조건 저장·복원 |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W3 동작 수정 (18)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0001 | C4 | cboDivision / Division / Div | 화면 FE(적용 예정) | C4 FAIL 수정 — cboDivision / Division / Div: 실측[T-d83840e6]: 조회 1행 → 'Div' 변경('40 Mobility & IT Battery') 후 0행 · 자동 재조회 1건 — 기대 AS-I |  | 1 (D00-2-001) |
| WK-SCP0096-0002 | G3 | SCP0096 화면 | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | G3 FAIL 수정 — SCP0096 화면: 원장 V-d255e233 RULE_SCREEN / 원장 V-79856a2d GENERAL / 원장 V-259399ae GENERAL / 원장 V-ec1622c0 GENERAL / 원장 V- |  | 7 (D00-1-010 COMMON:UC-02 COMMON:UC-03 COMM) |
| WK-SCP0096-0003 | F5 | SCP0096 화면 | 화면 FE(적용 예정) | F5 FAIL 수정 — SCP0096 화면: 원장 V-9ce92210 RULE_SCREEN / 원장 V-81765b2a DEFECT / 원장 V-0e99ed45 GENERAL / 원장 V-3a57e322 GENERAL / 원장 V-e |  | 1 (CRUD:DELETE) |
| WK-SCP0096-0004 | G4 | COMMON:UC-06 | 화면 FE(적용 예정) | G4 FAIL 수정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 전건 조회' 의 G4 7요소: FAIL:6 · NOPATH:1 · FAIL 요소: cboDivision |  | 1 (COMMON:UC-06) |
| WK-SCP0096-0005 | G4 | D00-1-010 | 화면 FE(적용 예정) | G4 FAIL 수정 — D00-1-010: 행 집계 — 대조표 D00-1-010 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G4 7요소: FAIL:6 · NOPATH:1 · FAIL 요소: cb |  | 1 (D00-1-010) |
| WK-SCP0096-0006 | G4 | cboDayWeek / Day of the week / Day Week  | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G4 FAIL 수정 — cboDayWeek / Day of the week / Day Week / -: 기준표 제외(BUTTON_AREA: 조회조건 영역 → 버튼 영역) — SCP·SSP 조회조건은 기준표(search_cond.csv |  | 5 (D00-1-003 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0007 | G4 | cboDivision / Division / Div | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G4 FAIL 수정 — cboDivision / Division / Div: 원장 V-5814a68d SEARCH / E2E smoke labels |  | 5 (D00-1-001 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0008 | G4 | cboInputValue / Input Value / - | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G4 FAIL 수정 — cboInputValue / Input Value / -: 기준표 제외(BUTTON_AREA: 조회조건 영역 → 버튼 영역) — SCP·SSP 조회조건은 기준표(search_cond.csv) 정의 조건만 사용( |  | 3 (D00-1-004 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0009 | G4 | chkSum / Sum | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G4 FAIL 수정 — chkSum / Sum: E2E smoke labels / 실측[T-9c5f2d8e]: 조회조건 'sum' 은 TO-BE 조회조건 기준표(search_cond.csv) 대상이 아님(기준표에 없는 AS-IS 조건 |  | 5 (D00-1-005 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0010 | G4 | clbPlantSite / Plant Site | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G4 FAIL 수정 — clbPlantSite / Plant Site: 원장 V-e5df6715 SEARCH / E2E smoke labels |  | 3 (D00-1-002 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0011 | G4 | usrButton1 / Button1 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G4 FAIL 수정 — usrButton1 / Button1: E2E smoke labels / 실측[T-4802619b]: 조회조건 'button1' 은 TO-BE 조회조건 기준표(search_cond.csv) 대상이 아님(기준표에 |  | 1 (D00-1-011) |
| WK-SCP0096-0012 | A6 | CRUD:SEARCH | 사람판정(사람판정 대기) | A6 FAIL 수정 — CRUD:SEARCH: 행 집계 — 대조표 CRUD:SEARCH 'Main 조회(FindData_Main)' 의 A6 3요소: PASS:1 · NOT_RUN:1 · FAIL:1 · FAIL 요소: PKG_SCP |  | 1 (CRUD:SEARCH) |
| WK-SCP0096-0013 | A6 | D00-3-021 | 사람판정(사람판정 대기) | A6 FAIL 수정 — D00-3-021: 행 집계 — 대조표 D00-3-021 '§3 Query / 470 (FindData_Main 조회)' 의 A6 3요소: PASS:1 · NOT_RUN:1 · FAIL:1 · FAIL 요소:  |  | 1 (D00-3-021) |
| WK-SCP0096-0014 | A6 | PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKI | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP: 원장 V-b713388c SP / 원장 V-a007d973 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS |  | 38 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0015 | X-ROW | SCP0096_Shipment_Working_Day_OSP.DefineP | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0096_Shipment_Working_Day_OSP.DefineProperty: 진입점 집계 3검사 — FAIL:1 · NA:1 · PASS:1 (FX-SCP0096-030) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Def) |
| WK-SCP0096-0016 | X-ROW | SCP0096_Shipment_Working_Day_OSP.FindBut | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0096_Shipment_Working_Day_OSP.FindButton: 진입점 집계 9검사 — REVIEW:3 · PASS:3 · NOT_RUN:1 · FAIL:1 · NA:1 (FX-SCP009 |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0017 | X-ROW | SCP0096_Shipment_Working_Day_OSP.FindDat | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0096_Shipment_Working_Day_OSP.FindData_Main: 진입점 집계 19검사 — PASS:10 · REVIEW:3 · NA:3 · NOT_RUN:1 · FAIL:1 · WAR |  | 8 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0018 | X-ROW | SCP0096_Shipment_Working_Day_OSP.InitCon | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0096_Shipment_Working_Day_OSP.InitControls: 진입점 집계 11검사 — PASS:4 · NA:4 · FAIL:3 (FX-SCP0096-036) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |

## W5 검사기 연결 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0019 | B3 | COLUMN_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0020 | B3 | DAY_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL DAY_CODE | 있음(FE 소스) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0021 | B3 | cboDayWeek / Day of the week / Day Week  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND cboDayWeek / Day of the week / Day Week / - | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0096-0022 | B3 | cboInputValue / Input Value / - | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND cboInputValue / Input Value / - | 있음(FE 소스) | 1 (D00-4b-003) |
| WK-SCP0096-0023 | B4 | COLUMN_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0024 | B4 | DAY_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DAY_CODE | 있음(FE 소스) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0025 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0026 | G4 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnInput | 있음(FE 소스) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |

## W7 기대값 확정 (26)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0027 | H5 | chkSum / Sum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — chkSum / Sum: 검증 엔진이 실행됐으나 이 대상(COND chkSum)을 판정하지 못함 — 라벨 명칭 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0028 | I1 | SCP0096 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0096 화면: 원장 V-b9443e02 RULE_SCREEN / 원장 V-de85e28c DEFECT / 원장 V-2131d48b DEFECT / 원장 V-97b95ba1 DEFECT / 원장 V-b5a0 |  | 12 (D00-4d-001 D00-4d-003 D00-4d-004 D00-4d-) |
| WK-SCP0096-0029 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태 신규행 Insert 시 필터 유지 (keepRowVisibleUnderFilter) — 이 화면은 신규행 Insert 없음(pivot 셀 편집 전용, Insert= |  | 1 (COMMON:UC-01) |
| WK-SCP0096-0030 | X-REASON | D00-3-020 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-020 §3 LockColumn / 405 (spdInfo 제목시트 잠금) — 제목/헤더 시트 편집 불가 = TO-BE 는 헤더가 columnGroups 표현 전용(편집 대상 아님) — 구 |  | 1 (D00-3-020) |
| WK-SCP0096-0031 | X-REASON | D00-3-032 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-032 §3 SetDblClickColumnShowHide / 819 — 더블클릭 컬럼 접기/펼치기 — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화면 pivot 편의기능 미이식 |  | 1 (D00-3-032) |
| WK-SCP0096-0032 | X-REASON | MODAL:(none) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:(none) 팝업/모달 없음 — AS-IS SCP0096 은 팝업 없는 단일 화면(조회조건+pivot 편집 그리드) — 분석 md·FE 양쪽 모달 파일 0 해당없음 |  | 1 (MODAL:(none)) |
| WK-SCP0096-0033 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 '수정 중 재조회 시 confirm (MSG00703)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0 |  | 1 (COMMON:UC-02) |
| WK-SCP0096-0034 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 설정 적용 시 Reset 후 재조회' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET |  | 1 (COMMON:UC-03) |
| WK-SCP0096-0035 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 전건 조회' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009 |  | 1 (COMMON:UC-06) |
| WK-SCP0096-0036 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 필터 유지 (rebindFilterColumns)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_C |  | 1 (COMMON:UC-07) |
| WK-SCP0096-0037 | A1 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:SEARCH: 행 집계 — 대조표 CRUD:SEARCH 'Main 조회(FindData_Main)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_S |  | 1 (CRUD:SEARCH) |
| WK-SCP0096-0038 | A1 | D00-1-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-010: 행 집계 — 대조표 D00-1-010 '§1 usrConditionPanel1 / UsrConditionPanel' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000. |  | 1 (D00-1-010) |
| WK-SCP0096-0039 | A1 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-011: 행 집계 — 대조표 D00-1-011 '§1 usrButton1 / UsrButton' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SH |  | 1 (D00-1-011) |
| WK-SCP0096-0040 | A1 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-021: 행 집계 — 대조표 D00-3-021 '§3 Query / 470 (FindData_Main 조회)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP000 |  | 1 (D00-3-021) |
| WK-SCP0096-0041 | A1 | D00-3-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-023: 행 집계 — 대조표 D00-3-023 '§3 SmartColMerge / 477 (조회 후 재병합)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP000 |  | 1 (D00-3-023) |
| WK-SCP0096-0042 | A1 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-024: 행 집계 — 대조표 D00-3-024 '§3 Get / 683 (Columns.Get(0).Visible 조회 전 차단)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0 |  | 1 (D00-3-024) |
| WK-SCP0096-0043 | A1 | D00-3-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-026: 행 집계 — 대조표 D00-3-026 '§3 GetModelColumnFromViewColumn / 735' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SC |  | 1 (D00-3-026) |
| WK-SCP0096-0044 | A1 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-004: 행 집계 — 대조표 D00-4b-004 '§4b Data_SCP.Common / PlantByDivisionOperOsp3 / dt' 의 A1 3요소: REVIEW:3 · FAIL 요소: P |  | 1 (D00-4b-004) |
| WK-SCP0096-0045 | A1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-001: 행 집계 — 대조표 D00-4d-001 '§4d BtnInput_Click 가드 #1 조회 전(MSG00135)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000. |  | 1 (D00-4d-001) |
| WK-SCP0096-0046 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP0009_GET_SHEE |  | 36 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0047 | A1 | PKG_SCP0019.P_SCP0019_GET_WORKING_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0019.P_SCP0019_GET_WORKING_TIME: 골든 비교 케이스 없음(PKG_SCP0019.P_SCP0019_GET_WORKING_TIME — 팝업·보조 SP 는 golden_cases. |  | 37 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0048 | A1 | PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP0096_GET_ |  | 38 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0049 | A6 | PKG_SCP0019.P_SCP0019_GET_WORKING_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SCP0019.P_SCP0019_GET_WORKING_TIME: 검증 엔진이 실행됐으나 이 대상(SP PKG_SCP0019.P_SCP0019_GET_WORK)을 판정하지 못함 — 결과 행 정렬 순서 — A |  | 37 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0050 | G03-WIRE | SCP0096 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0096 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 / 실측[T-db7f51c4]: 게이트 G03 As-is 이벤트 this.Load → For |  | 11 (ACT:SCP0096_Shipment_Working_Day_OSP..ct) |
| WK-SCP0096-0051 | X-ROW | SCP0096_Shipment_Working_Day_OSP.BtnInpu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.BtnInput_Click: 진입점 집계 7검사 — NA:4 · PASS:2 · WARN:1 |  | 5 (ACT:SCP0096_Shipment_Working_Day_OSP.Btn) |
| WK-SCP0096-0052 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SaveDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SaveData_Main: 진입점 집계 18검사 — PASS:11 · NA:6 · WARN:1 |  | 6 (ACT:SCP0096_Shipment_Working_Day_OSP.Sav) |

## W9 도구 오류 (25)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0053 | H5 | D00-1-008 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-008 '§1 spdMain / FpSpread' 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-008) |
| WK-SCP0096-0054 | H5 | D00-1-009 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-009 '§1 spdMain_Sheet1 / SheetView' 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-009) |
| WK-SCP0096-0055 | H5 | D00-3-002 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-3-002 '§3 SmartColMerge / 162 (spdInfo 제목시트)' 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-002) |
| WK-SCP0096-0056 | H5 | D00-3-014 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-3-014 '§3 SmartColMerge / 258 (좌측키 세로병합)' 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-014) |
| WK-SCP0096-0057 | H5 | SCP0096_Shipment_Working_Day_OSP.CreateS | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SCP0096_Shipment_Working_Day_OSP.CreateSpread 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Cre) |
| WK-SCP0096-0058 | H5 | SCP0096_Shipment_Working_Day_OSP.SetSpre | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SCP0096_Shipment_Working_Day_OSP.SetSpreadColumn 의 H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0059 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 '수정 중 재조회 시 confirm (MSG00703)' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (COMMON:UC-02) |
| WK-SCP0096-0060 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 설정 적용 시 Reset 후 재조회' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (COMMON:UC-03) |
| WK-SCP0096-0061 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 전건 조회' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (COMMON:UC-06) |
| WK-SCP0096-0062 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 필터 유지 (rebindFilterColumns)' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0096-0063 | G1 | CRUD:SEARCH | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 CRUD:SEARCH 'Main 조회(FindData_Main)' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (CRUD:SEARCH) |
| WK-SCP0096-0064 | G1 | D00-1-010 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-010 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (D00-1-010) |
| WK-SCP0096-0065 | G1 | D00-3-021 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-021 '§3 Query / 470 (FindData_Main 조회)' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (D00-3-021) |
| WK-SCP0096-0066 | G1 | D00-3-023 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-023 '§3 SmartColMerge / 477 (조회 후 재병합)' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (D00-3-023) |
| WK-SCP0096-0067 | G1 | D00-3-024 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-024 '§3 Get / 683 (Columns.Get(0).Visible 조회 전 차단)' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (D00-3-024) |
| WK-SCP0096-0068 | G1 | D00-3-026 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-026 '§3 GetModelColumnFromViewColumn / 735' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (D00-3-026) |
| WK-SCP0096-0069 | G1 | D00-4d-001 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4d-001 '§4d BtnInput_Click 가드 #1 조회 전(MSG00135)' 의 G1 7요소: NA:3 · PASS:2 · ERROR:2 |  | 1 (D00-4d-001) |
| WK-SCP0096-0070 | G1 | cboDayWeek / Day of the week / Day Week  | 하네스·환경 | G1 도구 오류 — 기준표 제외(BUTTON_AREA: 조회조건 영역 → 버튼 영역) — SCP·SSP 조회조건은 기준표(search_cond.csv) 정의 조건만 사용(TO-BE 룰 CR-071) → AS-IS 조건 cboDayWe |  | 1 (D00-1-003) |
| WK-SCP0096-0071 | G1 | cboInputValue / Input Value / - | 하네스·환경 | G1 도구 오류 — 기준표 제외(BUTTON_AREA: 조회조건 영역 → 버튼 영역) — SCP·SSP 조회조건은 기준표(search_cond.csv) 정의 조건만 사용(TO-BE 룰 CR-071) → AS-IS 조건 cboInput |  | 1 (D00-1-004) |
| WK-SCP0096-0072 | X-ROW | SCP0096_Shipment_Working_Day_OSP.CboDayW | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Cbo) |
| WK-SCP0096-0073 | X-ROW | SCP0096_Shipment_Working_Day_OSP.CboDivi | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Cbo) |
| WK-SCP0096-0074 | X-ROW | SCP0096_Shipment_Working_Day_OSP.CreateS | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Cre) |
| WK-SCP0096-0075 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SetLock | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0076 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SetSpre | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — NOT_RUN:5 · NA:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0077 | X-ROW | SCP0096_Shipment_Working_Day_OSP.chkSum_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.chk) |
