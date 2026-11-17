# 작업 원장 — SSP0003 · 2026-11-14 20:11

> 검사 인스턴스 371건 중 PASS·NA 188건 외 **183건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 19 | 재판정 PASS |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 42 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 113 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 113 · 사람 판정 / AS-IS 원문 확인 → 재판정 42 · FE 10 · 하네스 9 · 화면 FE 7 · DB 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 8건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| E4 | EDIT |  |  |  |  |  |  |  |  | 36 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  | 8 |  |  |  | 1 |  | 13 | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  |  |  |  |  |  | 20 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| H5 | DESIGN |  |  |  |  |  |  | 1 |  | 15 | 라벨 명칭 |
| F4 | DB |  |  |  |  |  |  | 10 |  | 3 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 11 | 연쇄 자동 채움 |
| M4 | POPUP |  |  |  |  |  |  | 6 |  | 3 | 팝업 선택값 반영 |
| H6 | POPUP |  |  |  |  |  |  |  |  | 8 | 팝업 표준·열림 |
| G1 | GEN |  |  | 4 |  |  |  |  |  | 1 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G4 | DESIGN |  |  |  |  | 5 |  |  |  |  | 조회조건 표시·라벨·활성 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 5 | 컬럼 편집 가능 여부(신규행·기존행) |
| G5 | POPUP |  |  |  |  |  |  |  |  | 5 | 팝업 조건 연동(인자) |
| A1 | GEN |  |  |  |  |  |  | 4 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B3 | COMBO |  |  | 3 |  |  |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| DB-SYN | DB |  |  |  |  | 3 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| B4 | COMBO |  |  |  |  |  |  |  |  | 2 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A6 | GEN |  |  |  |  |  |  |  |  | 2 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| M3 | POPUP |  |  |  |  |  |  |  |  | 2 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| K-SA | COMMON |  |  | 1 |  |  |  |  |  |  | 조회영역 토글 |
| I1 | DESIGN |  |  | 1 |  |  |  |  |  |  | LBL/MSG 언어별 등록 |
| E3 | EDIT |  |  | 1 |  |  |  |  |  |  | 필수 입력 검증 |
| G6 | GEN |  |  | 1 |  |  |  |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |

## W3 동작 수정 (19)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0003-0001 | B3 | SSP0003_ShipmentChangeRequestConfirm.Get | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — SSP0003_ShipmentChangeRequestConfirm.GetDayRange: 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.GetDayRange 의 B3  |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0002 | B3 | cboChangeType / Change Type | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — cboChangeType / Change Type: 원장 V-7bc634c0 SEARCH (FX-SSP0003-005) |  | 1 (cboChangeType(기본 ALL)) |
| WK-SSP0003-0003 | B3 | cboStatus / Status | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — cboStatus / Status: 원장 V-5f6e4f5f SEARCH (FX-SSP0003-004) |  | 1 (cboStatus(기본 Q)) |
| WK-SSP0003-0004 | K-SA | SSP0003 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | K-SA FAIL 수정 — SSP0003 화면: E2E smoke common Search Area 조회영역 토글 |  | 2 (usrConditionPanel1(조회조건 7종) btnApproval/) |
| WK-SSP0003-0005 | I1 | SSP0003 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | I1 FAIL 수정 — SSP0003 화면: 원장 V-9a5892b7 RULE_SCREEN / 원장 V-671736f1 RULE_SCREEN / 원장 V-9752f0ea RULE_SCREEN / 원장 V-41190682 DEFECT  |  | 31 (G4 G5 G6 G7~G11 G13 G15 G16 G17 ACT:SSP0) |
| WK-SSP0003-0006 | E3 | DataUtil.checkRequiredOfSearch | 화면 FE(범위 밖(가이드만)) | E3 FAIL 수정 — DataUtil.checkRequiredOfSearch: 원장 V-0768539f (FX-SSP0003-006) |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0007 | G1 | G2 | FE(repairScope=DB_ONLY — 이번 범위 밖) | G1 FAIL 수정 — G2: 행 집계 — 대조표 G2 'CellDoubleClick' 의 G1 7요소: PASS:4 · ERROR:1 · FAIL:1 · NA:1 · FAIL 요소: txtRequest / strRequest.Sub |  | 1 (G2) |
| WK-SSP0003-0008 | G1 | btnApproval/btnReject/btnSelfReject(우상단  | FE(repairScope=DB_ONLY — 이번 범위 밖) | G1 FAIL 수정 — btnApproval/btnReject/btnSelfReject(우상단 area1, 초기 숨김): 행 집계 — 대조표 btnApproval/btnReject/btnSelfReject(우상단 area1, 초기 숨 |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0009 | G1 | txtRequest / strRequest.Substring(0, str | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — txtRequest / strRequest.Substring(0, strRequest.Length - 1) : 원장 V-0d9d367c SEARCH / 원장 V-8a809465 SEARCH |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0010 | G1 | usrConditionPanel1(조회조건 7종) | FE(repairScope=DB_ONLY — 이번 범위 밖) | G1 FAIL 수정 — usrConditionPanel1(조회조건 7종): 행 집계 — 대조표 usrConditionPanel1(조회조건 7종) '`ShipmentChangeRequestConfirmSsp0003Form`(Search |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0003-0011 | G6 | cboStatus / Status | 화면 FE(범위 밖(가이드만)) | G6 FAIL 수정 — cboStatus / Status: 실측[T-089b59ce]: AS-IS SelectedIndex = 2(ALL 포함 목록) → 기대 항목 'Requested'(TO-BE 목록 9건 · ALL 포함) ↔ TO |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0012 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Chk | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0003_ShipmentChangeRequestConfirm.ChkDraftingData: 진입점 집계 10검사 — ERROR:9 · FAIL:1 |  | 27 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0013 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Eng | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0003_ShipmentChangeRequestConfirm.EngProcessingChk: 진입점 집계 6검사 — PASS:2 · ERROR:2 · REVIEW:1 · FAIL:1 |  | 15 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0014 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Fin | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0003_ShipmentChangeRequestConfirm.FindData_Main: 진입점 집계 14검사 — PASS:6 · REVIEW:2 · ERROR:2 · NA:2 · FAIL:2 (FX- |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0015 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Get | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0003_ShipmentChangeRequestConfirm.GetErpIFCheckNew: 진입점 집계 12검사 — ERROR:4 · NA:4 · PASS:2 · FAIL:1 · REVIEW:1 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0016 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Ini | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0003_ShipmentChangeRequestConfirm.InitControls: 진입점 집계 22검사 — PASS:13 · REVIEW:3 · NOPATH:3 · FAIL:1 · NA:1 · E |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0017 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Sav | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0003_ShipmentChangeRequestConfirm.SaveData: 진입점 집계 15검사 — ERROR:7 · PASS:4 · REVIEW:3 · FAIL:1 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0018 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Sav | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — SSP0003_ShipmentChangeRequestConfirm.SaveDraftingData: 진입점 집계 10검사 — ERROR:4 · PASS:3 · REVIEW:2 · FAIL:1 |  | 69 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0019 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.chk | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0003_ShipmentChangeRequestConfirm.chkERPIFBlockYn: 진입점 집계 3검사 — ERROR:2 · FAIL:1 |  | 13 (ACT:SSP0003_ShipmentChangeRequestConfirm) |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0003-0020 | DB-SYN | SSP0200_GET_PLANT_SITE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_PLANT_SITE_BY_DIVISION | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0021 | DB-SYN | SSP0200_GET_SHIPMENT_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_SHIPMENT_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0022 | DB-SYN | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0023 | G4 | btnApproval | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnApproval | 없음 | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0024 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0025 | G4 | btnReject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnReject | 없음 | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0026 | G4 | btnRequestUser | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRequestUser | 없음 | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0027 | G4 | btnSelfReject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSelfReject | 없음 | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0028 | G03-WIRE | SSP0003 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0003 화면 | 판단불가(대상 단위 SCREEN) | 12 (ACT:SSP0003_ShipmentChangeRequestConfirm) |

## W7 기대값 확정 (42)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0003-0029 | F4 | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONF | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM: 실측[T-ac139aa1]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturit |  | 199 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0030 | F4 | SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRA | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING: 실측[T-d6dbf643]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_matur |  | 41 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0031 | F4 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0003_GET_SSP_PLAN_PROCESSING_CHECK: 실측[T-21293768]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv  |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0032 | F4 | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM: 실측[T-b9fc6d54]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv  |  | 157 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0033 | F4 | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40: 실측[T-580f9039]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.c |  | 157 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0034 | F4 | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK: 실측[T-a7e9d2ee]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_matu |  | 10 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0035 | F4 | SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM: 실측[T-b97851e4]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.c |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0036 | F4 | SSP0200_GET_PLANT_SITE_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0200_GET_PLANT_SITE_BY_DIVISION: 실측[T-ebee8dc5]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv sta |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0037 | F4 | SSP0200_GET_SHIPMENT_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0200_GET_SHIPMENT_DIVISION: 실측[T-74791dd9]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=c |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0038 | F4 | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE: 실측[T-576ef080]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv s |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0039 | H5 | txtApprovalDeptName / Approval Dept Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — txtApprovalDeptName / Approval Dept Name: 검증 엔진이 실행됐으나 이 대상(COND txtApprovalDeptName)을 판정하지 못함 — 라벨 명칭 시나리오 수동 확인 또는 엔 |  | 4 (txtApprovalDeptName(FpSpread=siSub 54열, ) |
| WK-SSP0003-0040 | A1 | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G2: 행 집계 — 대조표 G2 'CellDoubleClick' 의 A1 2요소: REVIEW:1 · NA:1 · FAIL 요소: SSP0003_GET_SHIPMENT_CHANGE_RE — golden DIFF  |  | 1 (G2) |
| WK-SSP0003-0041 | A1 | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONF | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM: golden DIFF AS-IS 0행 ↔ TO-BE 2행: Doc/golden/SSP0003/SSP0003_GET_SHIPMENT_ |  | 43 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0042 | A1 | btnApproval/btnReject/btnSelfReject(우상단  | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnApproval/btnReject/btnSelfReject(우상단 area1, 초기 : 행 집계 — 대조표 btnApproval/btnReject/btnSelfReject(우상단 area1, 초기 숨김) ' |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0043 | A1 | usrConditionPanel1(조회조건 7종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — usrConditionPanel1(조회조건 7종): 행 집계 — 대조표 usrConditionPanel1(조회조건 7종) '`ShipmentChangeRequestConfirmSsp0003Form`(SearchA |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0003-0044 | X-LOC | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division) |
| WK-SSP0003-0045 | X-LOC | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — From Site: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (From Site) |
| WK-SSP0003-0046 | X-LOC | G1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G1) |
| WK-SSP0003-0047 | X-LOC | G12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G12) |
| WK-SSP0003-0048 | X-LOC | G13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G13) |
| WK-SSP0003-0049 | X-LOC | G14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G14) |
| WK-SSP0003-0050 | X-LOC | G15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G15: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G15) |
| WK-SSP0003-0051 | X-LOC | G16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G16) |
| WK-SSP0003-0052 | X-LOC | G17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G17: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G17) |
| WK-SSP0003-0053 | X-LOC | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G2) |
| WK-SSP0003-0054 | X-LOC | G2(E) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G2(E): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G2(E)) |
| WK-SSP0003-0055 | X-LOC | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G3) |
| WK-SSP0003-0056 | X-LOC | G3(E) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G3(E): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G3(E)) |
| WK-SSP0003-0057 | X-LOC | G4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G4) |
| WK-SSP0003-0058 | X-LOC | G5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G5) |
| WK-SSP0003-0059 | X-LOC | G6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G6) |
| WK-SSP0003-0060 | X-LOC | G7~G11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G7~G11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G7~G11) |
| WK-SSP0003-0061 | X-LOC | PKG | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PKG: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PKG) |
| WK-SSP0003-0062 | X-LOC | ROUTE_PATH | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ROUTE_PATH: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ROUTE_PATH) |
| WK-SSP0003-0063 | X-LOC | siSub 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — siSub 컬럼: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (siSub 컬럼) |
| WK-SSP0003-0064 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Cle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.ClearRequestI: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/VALUE_CLEAR, 연결된 요소 검사 없음 |  | 9 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0065 | M4 | APPROVAL_USER / Approval | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — APPROVAL_USER / Approval: 검증 엔진이 실행됐으나 이 대상(COL APPROVAL_USER)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0066 | M4 | CHANGE_TYPE / Change Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — CHANGE_TYPE / Change Type: 검증 엔진이 실행됐으나 이 대상(COL CHANGE_TYPE)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0067 | M4 | DELEGATEE_USER / Delegatee | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DELEGATEE_USER / Delegatee: 검증 엔진이 실행됐으나 이 대상(COL DELEGATEE_USER)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0068 | M4 | DIVISION_ID / division | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DIVISION_ID / division: 검증 엔진이 실행됐으나 이 대상(COL DIVISION_ID)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0069 | M4 | REQUEST_USER / Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQUEST_USER / Requestor: 검증 엔진이 실행됐으나 이 대상(COL REQUEST_USER)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0070 | M4 | SHIPMENT_STATUS / Status | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SHIPMENT_STATUS / Status: 검증 엔진이 실행됐으나 이 대상(COL SHIPMENT_STATUS)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |

## W9 도구 오류 (113)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0003-0071 | J2 | SSP0003 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-6f84977f RULE_SCREEN / 원장 V-fd8b9f87 DEFECT / 원장 V-80870d55 GENERAL / 원장 V-4b80546a GENERAL / 원장 V-80750232 GENERA |  | 105 (usrConditionPanel1(조회조건 7종) btnApproval/) |
| WK-SSP0003-0072 | C3 | APPROVAL_USER / Approval | 하네스·환경 | C3 도구 오류 — 실측[T-46d0a782]: APPROVAL_USER 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0073 | C3 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C3 도구 오류 — 실측[T-10f4d690]: CHANGE_REASON_CODE 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0074 | C3 | CHANGE_REQ_NO / change_req_no | 하네스·환경 | C3 도구 오류 — 실측[T-59f6355a]: CHANGE_REQ_NO 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0075 | C3 | CHK / ALL | 하네스·환경 | C3 도구 오류 — 실측[T-e286bfc3]: CHK 연쇄 원천 컬럼 해석 불가 — AS-IS FindData_Sub:800 siSub.SetValue(iRow, siSub.GetColumnIndex(DefColumns.CHK),  |  | 7 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0076 | C3 | REQUEST_DEPT / Requestor Dept Name | 하네스·환경 | C3 도구 오류 — 실측[T-6e706af6]: REQUEST_DEPT 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0077 | C3 | REQUEST_TITLE / Title | 하네스·환경 | C3 도구 오류 — 실측[T-14806f97]: REQUEST_TITLE 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0078 | C3 | REQUEST_USER / Requestor | 하네스·환경 | C3 도구 오류 — 실측[T-8124106c]: REQUEST_USER 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0079 | C3 | SSP0003_ShipmentChangeRequestConfirm.Clb | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.ClbDivision_SelectedIndexChanged 의 C3 8요소: ERROR:7 · NA:1 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0080 | C3 | SSP0003_ShipmentChangeRequestConfirm.Set | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.SetChangeControl 의 C3 8요소: ERROR:7 · NA:1 |  | 8 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0081 | C3 | SSP0003_ShipmentChangeRequestConfirm.Set | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.SetChangeRequestInfo 의 C3 6요소: ERROR:6 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0082 | C3 | SSP0003_ShipmentChangeRequestConfirm.Set | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.SetChangedControl 의 C3 8요소: ERROR:7 · NA:1 |  | 13 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0083 | B4 | SSP0003_ShipmentChangeRequestConfirm.Get | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.GetDayRange 의 B4 5요소: PASS:2 · NA:2 · ERROR:1 |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0084 | B4 | clbDivision / Division / Div / Div. | 하네스·환경 | B4 도구 오류 — 원장 V-cf54df81 SEARCH |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0085 | K4 | SSP0003 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-10bf63ed GENERAL / 원장 V-0fbd2c9f GENERAL / 원장 V-afd79dd0 GENERAL / 원장 V-607a2e50 GENERAL / 원장 V-83c3b81c GENERAL / |  | 101 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0086 | F1 | SSP0003 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-3ec954d6 RULE_SCREEN / 원장 V-882c61e5 RULE_SCREEN / 원장 V-43b115bd RULE_SCREEN / 원장 V-f10e9ee4 RULE_SCREEN / 원장 V-95 |  | 158 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0087 | F2 | SSP0003 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-4486d649 RULE_SCREEN / 원장 V-31a9c4df RULE_SCREEN / 원장 V-acfb535c GENERAL / 원장 V-c45c39c7 GENERAL / 원장 V-6ae9ae66 G |  | 158 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0088 | F6 | SSP0003 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-9debb419 RULE_SCREEN / 원장 V-34a46f26 RULE_SCREEN / 원장 V-e314b5ea RULE_SCREEN / 원장 V-411b89f8 RULE_SCREEN / 원장 V-4a |  | 158 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0089 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | 하네스·환경 | F4 도구 오류 — 실측[T-c79fbd0d]: PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD: SCP0009/main/W26, SCP0009/main/W52, SCP0025/main/GET_SCP_DAY_ |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0090 | F4 | PKG_SSP0003.P_SSP0003_GET_DELEGATEE_LOAD | 하네스·환경 | F4 도구 오류 — 실측[T-663a7fce]: PKG_SSP0003.P_SSP0003_GET_DELEGATEE_LOAD: SSP0003/delegate/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해 |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0091 | F4 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_STATU | 하네스·환경 | F4 도구 오류 — 실측[T-082e82c1]: PKG_SSP0200.P_SSP0200_GET_SHIPMENT_STATUS: SSP0003/main/SCS_CHECK, SSP0200/main/GET_SHIPMENT_STATUS — 화 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0092 | H10 | SSP0003 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 8 (G4 G5 G6 G7~G11 G13 G15 G16 G17) |
| WK-SSP0003-0093 | H4 | SSP0003 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-4a347d6c RULE_SCREEN / 원장 V-4debd98c RULE_SCREEN / 원장 V-431c6ceb RULE_SCREEN / 원장 V-b653c79e RULE_SCREEN / 원장 V-00 |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0094 | H5 | CHK / ALL | 하네스·환경 | H5 도구 오류 — 실측[T-04af1dae]: CHK 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0095 | H5 | ETA | 하네스·환경 | H5 도구 오류 — 실측[T-77512337]: ETA 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0096 | H5 | ETD | 하네스·환경 | H5 도구 오류 — 실측[T-af3d7bc7]: ETD 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0097 | H5 | LT_DAY / L/T(Day | 하네스·환경 | H5 도구 오류 — 실측[T-21b49b8f]: LT_DAY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0098 | H5 | NEW_ETA / ETA | 하네스·환경 | H5 도구 오류 — 실측[T-926f0c07]: NEW_ETA 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0099 | H5 | NEW_ETD / ETD | 하네스·환경 | H5 도구 오류 — 실측[T-b7248f23]: NEW_ETD 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0100 | H5 | NEW_LT_DAY / L/T(Day | 하네스·환경 | H5 도구 오류 — 실측[T-0c570f78]: NEW_LT_DAY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0101 | H5 | NEW_SHIPMENT_CONFIRM_QTY / Qty | 하네스·환경 | H5 도구 오류 — 실측[T-134c8799]: NEW_SHIPMENT_CONFIRM_QTY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0102 | H5 | NEW_SHIPMENT_DATE / Shipment Date | 하네스·환경 | H5 도구 오류 — 실측[T-3c16460d]: NEW_SHIPMENT_DATE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0103 | H5 | NEW_TRANSPORT_MODE / Trans Mode | 하네스·환경 | H5 도구 오류 — 실측[T-832ace83]: NEW_TRANSPORT_MODE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0104 | H5 | SHIPMENT_CONFIRM_QTY / Qty | 하네스·환경 | H5 도구 오류 — 실측[T-c138e0c7]: SHIPMENT_CONFIRM_QTY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0105 | H5 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | H5 도구 오류 — 실측[T-c4b94fdb]: SHIPMENT_DATE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0106 | H5 | SSP0003_ShipmentChangeRequestConfirm.Cre | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.CreateSpread 의 H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0107 | H5 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | H5 도구 오류 — 실측[T-54e89fe3]: TRANSPORT_MODE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0108 | H5 | spdMain(siMain 22열) | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 spdMain(siMain 22열) '`...MainGrid`(DataGrid, isReadOnly, allowMerging)' 의 H5 15요소: ERROR:13 · NOT_RUN:1 · NA |  | 1 (spdMain(siMain 22열)) |
| WK-SSP0003-0109 | D1 | G1 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 G1 'EditButton' 의 D1 9요소: NA:7 · ERROR:2 |  | 1 (G1) |
| WK-SSP0003-0110 | D1 | G2 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 G2 'CellDoubleClick' 의 D1 9요소: NA:7 · ERROR:2 |  | 1 (G2) |
| WK-SSP0003-0111 | D1 | SHIPMENT_STATUS / Status | 하네스·환경 | D1 도구 오류 — 원장 V-6aab328d COLUMN / 원장 V-bc17ed81 COLUMN / 실측[T-e9b0a789]: SHIPMENT_STATUS AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 —  |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0112 | D1 | SSP0003_ShipmentChangeRequestConfirm.Edi | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.EditButton 의 D1 4요소: NA:3 · ERROR:1 |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0113 | D1 | this.siSub.SetLockFlag | 하네스·환경 | D1 도구 오류 — 원장 V-aee5dec0 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0114 | E4 | MSG00181 | 하네스·환경 | E4 도구 오류 — 원장 V-f949e508 ASIS / 원장 V-ceb8b040 ASIS / 원장 V-7f7b04a3 ASIS / 실측[T-a9398cc2]: MSG00181 — BtnReject_Click 경로 메시지(저장 전 검 |  | 6 (G4 G7~G11 G16 ACT:SSP0003_ShipmentChange) |
| WK-SSP0003-0115 | E4 | MSG00181 | 하네스·환경 | E4 도구 오류 — 원장 V-f949e508 / 실측[T-0660d346]: MSG00181 — BtnReject_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnReject |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0116 | E4 | MSG00181 | 하네스·환경 | E4 도구 오류 — 원장 V-ceb8b040 / 실측[T-d6f13071]: MSG00181 — BtnReject_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnReject |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0117 | E4 | MSG00181 | 하네스·환경 | E4 도구 오류 — 원장 V-7f7b04a3 / 실측[T-d464b571]: MSG00181 — BtnReject_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnReject |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0118 | E4 | MSG00190 | 하네스·환경 | E4 도구 오류 — 원장 V-af3f2826 ASIS / 실측[T-d7d691ba]: MSG00190 — BtnApproval_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Bt |  | 2 (G17 ACT:SSP0003_ShipmentChangeRequestCon) |
| WK-SSP0003-0119 | E4 | MSG00190 | 하네스·환경 | E4 도구 오류 — 원장 V-af3f2826 / 실측[T-e316f440]: MSG00190 — BtnApproval_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnAppr |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0120 | E4 | MSG00191 | 하네스·환경 | E4 도구 오류 — 원장 V-b1947ba4 / 실측[T-712d2504]: MSG00191 — BtnReject_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnReject |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0121 | E4 | MSG00191 | 하네스·환경 | E4 도구 오류 — 원장 V-b1947ba4 ASIS / 실측[T-4bf6ff2f]: MSG00191 — BtnReject_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnR |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0122 | E4 | MSG00192 | 하네스·환경 | E4 도구 오류 — 원장 V-16357b9a ASIS / 실측[T-f6cc8458]: MSG00192 — BtnSelfReject_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오( |  | 2 (G6 ACT:SSP0003_ShipmentChangeRequestConf) |
| WK-SSP0003-0123 | E4 | MSG00192 | 하네스·환경 | E4 도구 오류 — 원장 V-16357b9a / 실측[T-2bce23fd]: MSG00192 — BtnSelfReject_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnSe |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0124 | E4 | MSG00197 | 하네스·환경 | E4 도구 오류 — 원장 V-99cc9b11 / 실측[T-ecbefe67]: MSG00197 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErpIFChe |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0125 | E4 | MSG00197 | 하네스·환경 | E4 도구 오류 — 원장 V-99cc9b11 ASIS / 원장 V-3ca5bf85 ASIS / 실측[T-5064a9d0]: MSG00197 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0126 | E4 | MSG00197 | 하네스·환경 | E4 도구 오류 — 원장 V-3ca5bf85 / 실측[T-a845091d]: MSG00197 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErpIFChe |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0127 | E4 | MSG00204 | 하네스·환경 | E4 도구 오류 — 원장 V-231a1d8e / 실측[T-07bb5d53]: MSG00204 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErpIFChe |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0128 | E4 | MSG00204 | 하네스·환경 | E4 도구 오류 — 원장 V-231a1d8e ASIS / 원장 V-7ee82d50 ASIS / 원장 V-fec04a6e ASIS / 원장 V-3fa36e18 ASIS / 실측[T-9397193c]: MSG00204 — GetErpIF |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0129 | E4 | MSG00204 | 하네스·환경 | E4 도구 오류 — 원장 V-7ee82d50 / 실측[T-0a025897]: MSG00204 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErpIFChe |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0130 | E4 | MSG00204 | 하네스·환경 | E4 도구 오류 — 원장 V-fec04a6e / 실측[T-bb6170a2]: MSG00204 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErpIFChe |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0131 | E4 | MSG00204 | 하네스·환경 | E4 도구 오류 — 원장 V-3fa36e18 / 실측[T-4a67261f]: MSG00204 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErpIFChe |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0132 | E4 | MSG00267 | 하네스·환경 | E4 도구 오류 — 원장 V-e8993ea3 / 실측[T-8243508f]: MSG00267 — chkERPIFBlockYn 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(chkERPIFB |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0133 | E4 | MSG00267 | 하네스·환경 | E4 도구 오류 — 원장 V-e8993ea3 ASIS / 실측[T-ba3b5d18]: MSG00267 — chkERPIFBlockYn 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(chkE |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0134 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-9a2b59f6 / 실측[T-1c08f81c]: MSG00284: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 ERROR: [측정 경로 누락] Save 버튼 없음(기본 탭) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0135 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-9a2b59f6 ASIS / 원장 V-694e7336 ASIS / 실측[T-8a264efb]: MSG00284: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 ERROR: [측정  |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0136 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-694e7336 / 실측[T-1254f52f]: MSG00284: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 ERROR: [측정 경로 누락] Save 버튼 없음(기본 탭) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0137 | E4 | MSG00291 | 하네스·환경 | E4 도구 오류 — 원장 V-a2458308 ASIS / 실측[T-20e5a924]: MSG00291 — EngProcessingChk 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Eng |  | 2 (G13 ACT:SSP0003_ShipmentChangeRequestCon) |
| WK-SSP0003-0138 | E4 | MSG00291 | 하네스·환경 | E4 도구 오류 — 원장 V-a2458308 / 실측[T-fca11a97]: MSG00291 — EngProcessingChk 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EngProce |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0139 | E4 | MSG00306 | 하네스·환경 | E4 도구 오류 — 원장 V-e7c75198 / 실측[T-ef4dfdfc]: MSG00306 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErpIFChe |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0140 | E4 | MSG00306 | 하네스·환경 | E4 도구 오류 — 원장 V-e7c75198 ASIS / 실측[T-23c81dd2]: MSG00306 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErp |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0141 | E4 | MSG00413 | 하네스·환경 | E4 도구 오류 — 원장 V-78ddd956 ASIS / 실측[T-3b71ae3a]: MSG00413 — GetShipmentStatusChk 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 2 (G15 ACT:SSP0003_ShipmentChangeRequestCon) |
| WK-SSP0003-0142 | E4 | MSG00413 | 하네스·환경 | E4 도구 오류 — 원장 V-78ddd956 / 실측[T-26597578]: MSG00413 — GetShipmentStatusChk 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetS |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0143 | E4 | MSG00420 | 하네스·환경 | E4 도구 오류 — 원장 V-821b3c45 ASIS / 실측[T-aed20308]: MSG00420 — ChkDraftingData 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ChkD |  | 2 (G16 ACT:SSP0003_ShipmentChangeRequestCon) |
| WK-SSP0003-0144 | E4 | MSG00420 | 하네스·환경 | E4 도구 오류 — 원장 V-821b3c45 / 실측[T-3cbff55c]: MSG00420 — ChkDraftingData 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ChkDrafti |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0145 | E4 | MSG00421 | 하네스·환경 | E4 도구 오류 — 원장 V-9dca4452 ASIS / 실측[T-272ab397]: MSG00421 — ChkDraftingData 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ChkD |  | 2 (G7~G11 ACT:SSP0003_ShipmentChangeRequest) |
| WK-SSP0003-0146 | E4 | MSG00421 | 하네스·환경 | E4 도구 오류 — 원장 V-9dca4452 / 실측[T-d9f7e84d]: MSG00421 — ChkDraftingData 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ChkDrafti |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0147 | E4 | MSG00422 | 하네스·환경 | E4 도구 오류 — 원장 V-afec74bd ASIS / 실측[T-e20020ab]: MSG00422 — ChkDraftingData 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ChkD |  | 2 (G5 ACT:SSP0003_ShipmentChangeRequestConf) |
| WK-SSP0003-0148 | E4 | MSG00422 | 하네스·환경 | E4 도구 오류 — 원장 V-afec74bd / 실측[T-b1db291c]: MSG00422 — ChkDraftingData 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ChkDrafti |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0149 | E4 | txtRejectReason / Reject Reason | 하네스·환경 | E4 도구 오류 — 실측[T-8ab3e76a]: MSG00181 — ChkDraftingData 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ChkDraftingData)에서 판정 → 기 |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0150 | A6 | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONF | 하네스·환경 | A6 도구 오류 — 원장 V-2585bf09 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-1f5c821a]: SSP0003_GET_SHIPMENT_CHANGE_REQU |  | 43 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0151 | A6 | SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRA | 하네스·환경 | A6 도구 오류 — 원장 V-ed6c40e8 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-febb8e4f]: SSP0003_GET_SHIPMENT_REQUEST_CON |  | 41 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0152 | G1 | clbFromSite / From Site | 하네스·환경 | G1 도구 오류 — 원장 V-04689b65 SEARCH / E2E smoke cond combo |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0153 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Btn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:7 |  | 9 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0154 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Clb | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0155 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Cre | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0156 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Del | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — PASS:2 · ERROR:1 |  | 10 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0157 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Fin | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — REVIEW:2 · ERROR:1 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0158 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Fin | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — NA:6 · PASS:4 · ERROR:3 · REVIEW:1 |  | 7 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0159 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Get | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0160 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Ini | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 59검사 — NA:30 · PASS:15 · ERROR:14 |  | 8 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0161 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Set | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:2 · NOT_RUN:1 · ERROR:1 · PASS:1 |  | 7 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0162 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Set | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — NA:3 · REVIEW:2 · NOPATH:2 · PASS:2 · ERROR:1 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0163 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Set | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NA:8 · ERROR:1 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0164 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Spd | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0165 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.btn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:6 · NA:2 · PASS:1 |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0166 | G5 | G2 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 G2 'CellDoubleClick' 의 G5 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (G2) |
| WK-SSP0003-0167 | G5 | G3 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 G3 'CellDoubleClick' 의 G5 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (G3) |
| WK-SSP0003-0168 | G5 | SSP0003_ShipmentChangeRequestConfirm.Spd | 하네스·환경 | G5 도구 오류 — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.SpdMain_CellDoubleClick 의 G5 5요소: ERROR:2 · NA:2 · PASS:1 |  | 11 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0169 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-e178ed15 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0170 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-779fc06d |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0171 | H6 | G2 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 G2 'CellDoubleClick' 의 H6 5요소: ERROR:5 |  | 1 (G2) |
| WK-SSP0003-0172 | H6 | G3 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 G3 'CellDoubleClick' 의 H6 5요소: ERROR:5 |  | 1 (G3) |
| WK-SSP0003-0173 | H6 | SSP0003_ShipmentChangeRequestConfirm.Spd | 하네스·환경 | H6 도구 오류 — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.SpdMain_CellDoubleClick 의 H6 5요소: ERROR:5 |  | 11 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0174 | H6 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-c714a6fa |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0175 | H6 | new UserInfoPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-510f28fa |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0176 | H6 | popItem.Form_Load(true, sdivision, sScmS | 하네스·환경 | H6 도구 오류 — 원장 V-3ba75fcb |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0177 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-744f3c71 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0178 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-0025658d |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0179 | M3 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-35ced168 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0180 | M3 | new UserInfoPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-acd89f2c |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0181 | M4 | G2 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 G2 'CellDoubleClick' 의 M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (G2) |
| WK-SSP0003-0182 | M4 | G3 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 G3 'CellDoubleClick' 의 M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (G3) |
| WK-SSP0003-0183 | M4 | SSP0003_ShipmentChangeRequestConfirm.Spd | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.SpdMain_CellDoubleClick 의 M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
