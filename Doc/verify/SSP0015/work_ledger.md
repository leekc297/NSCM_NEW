# 작업 원장 — SSP0015 · 2026-11-14 23:44

> 검사 인스턴스 1015건 중 PASS·NA 381건 외 **634건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 29 | 재판정 PASS |
| W5 | 검사기 연결 | 21 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 9 | 실행 → PASS |
| W7 | 기대값 확정 | 32 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 543 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 543 · 사람 판정 / AS-IS 원문 확인 → 재판정 32 · FE 22 · 하네스 21 · E2E 9 · 화면 FE 5 · 사람판정 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 6 |  |  |  | 6 |  | 75 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 86 | 연쇄 자동 채움 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 57 | 무변경 편집 종료 시 연쇄 미발동 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 55 | 배경·글자색 규칙 |
| E4 | EDIT |  |  |  |  |  |  |  |  | 35 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| D3 | EDIT |  |  |  |  |  |  |  |  | 30 | 행 값 기반 조건부 잠금 |
| M4 | POPUP |  |  | 19 |  |  |  | 6 |  |  | 팝업 선택값 반영 |
| H6 | POPUP |  |  |  |  | 3 | 4 |  |  | 17 | 팝업 표준·열림 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 24 | 컬럼 편집 가능 여부(신규행·기존행) |
| F4 | DB |  |  |  |  |  |  | 3 |  | 19 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 17 | 그리드 셀 cascade 후보 |
| A6 | GEN |  |  | 2 |  |  |  | 1 |  | 13 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| A1 | GEN |  |  |  |  |  |  | 15 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G5 | POPUP |  |  |  |  | 6 |  |  |  | 7 | 팝업 조건 연동(인자) |
| G4 | DESIGN |  |  | 2 |  | 5 | 5 |  |  |  | 조회조건 표시·라벨·활성 |
| B3 | COMBO |  |  |  |  |  |  |  |  | 12 | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  |  |  |  |  | 12 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G6 | GEN |  |  |  |  |  |  |  |  | 12 | 조회조건 초기 기본값 = AS-IS Form_Load |
| H5 | DESIGN |  |  |  |  |  |  | 1 |  | 10 | 라벨 명칭 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 10 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| E3 | EDIT |  |  |  |  |  |  |  |  | 10 | 필수 입력 검증 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 10 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| E1 | EDIT |  |  |  |  |  |  |  |  | 8 | 숫자 소수자리·정수·부호·범위 |
| G1 | GEN |  |  |  |  |  |  |  |  | 6 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| DB-SYN | DB |  |  |  |  | 3 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| E2 | EDIT |  |  |  |  | 3 |  |  |  |  | 날짜 형식·유효성 |
| D5 | EDIT |  |  |  |  |  |  |  |  | 3 | 셀 에디터 유형 |
| C1 | CASCADE |  |  |  |  |  |  |  |  | 2 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| B1 | COMBO |  |  |  |  |  |  |  |  | 1 | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  |  |  |  |  | 1 | 콤보 후보 중복 없음 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  |  |  |  | 1 | Insert 위치·상태 유지 |

## W3 동작 수정 (29)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0015-0001 | G4 | clbResultType / Result Type | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbResultType / Result Type: E2E smoke labels — 누락 라벨 |  | 2 (ACT:SSP0015_ShipmentPSI.InitControls ACT) |
| WK-SSP0015-0002 | G4 | txtBefore_Qty / Result Type / Before_Qty | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — txtBefore_Qty / Result Type / Before_Qty: E2E smoke labels — 누락 라벨 (FX-SSP0015-085) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0003 | A6 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI: 원장 V-9120974a SP / 원장 V-c8f94294 SP / 원장 V-7ec55137 SP / 정렬대조 FAIL 1번째 키부터 다름 |  | 136 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0004 | A6 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_P | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST: 원장 V-cd8e2a4a SP / 원장 V-3ba2689e SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS |  | 79 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0005 | X-ROW | SSP0015_ShipmentPSI.FindData_Main | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0015_ShipmentPSI.FindData_Main: 진입점 집계 34검사 — ERROR:9 · PASS:8 · NA:8 · REVIEW:5 · NOPATH:2 · NOT_RUN:1 · FAIL: |  | 15 (ACT:SSP0015_ShipmentPSI.FindData_Main:24) |
| WK-SSP0015-0006 | X-ROW | SSP0015_ShipmentPSI.FindData_Main_Packer | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0015_ShipmentPSI.FindData_Main_Packer_Past: 진입점 집계 30검사 — PASS:7 · ERROR:7 · NA:7 · REVIEW:5 · NOPATH:2 · NOT_R |  | 8 (ACT:SSP0015_ShipmentPSI.FindData_Main_Pa) |
| WK-SSP0015-0007 | X-ROW | SSP0015_ShipmentPSI.InitControls | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0015_ShipmentPSI.InitControls: 진입점 집계 21검사 — PASS:11 · NA:7 · ERROR:2 · FAIL:1 (FX-SSP0015-081) |  | 17 (ACT:SSP0015_ShipmentPSI.InitControls:558) |
| WK-SSP0015-0008 | X-ROW | SSP0015_ShipmentPSI.SpdDetail_CellDouble | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0015_ShipmentPSI.SpdDetail_CellDoubleClick: 진입점 집계 20검사 — FAIL:6 · ERROR:5 · NA:4 · NOPATH:4 · PASS:1 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0009 | X-ROW | SSP0015_ShipmentPSI.SpdMain_CellDoubleCl | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0015_ShipmentPSI.SpdMain_CellDoubleClick: 진입점 집계 47검사 — FAIL:15 · ERROR:13 · NOT_RUN:9 · NOPATH:5 · NA:3 · PASS |  | 12 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0010 | X-ROW | SSP0015_ShipmentPSICommentsPopup.InitCon | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0015_ShipmentPSICommentsPopup.InitControls: 진입점 집계 26검사 — ERROR:13 · NA:6 · NOT_RUN:4 · PASS:2 · FAIL:1 (FX-SSP |  | 24 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0011 | M4 | BEFORE_QTY / Before Qty | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — BEFORE_QTY / Before Qty: 실측[T-61a0b5aa]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0012 | M4 | COMMENTS / Comments | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — COMMENTS / Comments: 실측[T-9abda072]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0013 | M4 | CONFIRM_ID / Confirm/Plan ID | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — CONFIRM_ID / Confirm/Plan ID: 실측[T-467ed6ab]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영 |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0014 | M4 | DIVISION_ID / Div | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — DIVISION_ID / Div: 실측[T-1e790a5d]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 8 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0015 | M4 | ERP_SO_NO / SO No | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — ERP_SO_NO / SO No: 실측[T-60a92a29]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 13 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0016 | M4 | FIGURE / Figure | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — FIGURE / Figure: 실측[T-24551b01]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 43 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0017 | M4 | FROM_SITE / Site | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — FROM_SITE / Site: 실측[T-78e20067]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 9 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0018 | M4 | FROM_SITE_NM / From Site | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — FROM_SITE_NM / From Site: 실측[T-53375c5e]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0019 | M4 | GAP | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — GAP: 실측[T-2f1a6d12]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0020 | M4 | ITEM_ID / Model | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — ITEM_ID / Model: 실측[T-b25e6763]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 12 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0021 | M4 | MEASURE / Measure | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — MEASURE / Measure: 실측[T-bb090136]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0022 | M4 | MEASURE_NAME / Measure | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — MEASURE_NAME / Measure: 실측[T-68f0dd44]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0023 | M4 | PLAN_TYPE | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — PLAN_TYPE: 실측[T-1f4b3f16]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 9 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0024 | M4 | REMARKS2 / Building | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — REMARKS2 / Building: 실측[T-d0505b11]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0025 | M4 | SEQ | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SEQ: 실측[T-5c63ba28]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 9 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0026 | M4 | SHIPMENT_DATE / Shipment Date | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SHIPMENT_DATE / Shipment Date: 실측[T-5d40e2d4]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반 |  | 4 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0027 | M4 | SSP0015_ShipmentPSI.SpdMain_CellDoubleCl | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SSP0015_ShipmentPSI.SpdMain_CellDoubleClick: 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SpdMain_CellDoubleClick 의 M4 19요소: FAIL |  | 45 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0028 | M4 | USER_ADD_QTY / Before Input Qty | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — USER_ADD_QTY / Before Input Qty: 실측[T-5e5396eb]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0029 | M4 | YYYYMMDD / Date | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — YYYYMMDD / Date: 실측[T-2e8d5285]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |

## W5 검사기 연결 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0015-0030 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0015_ShipmentPSI.GetBucketType:21) |
| WK-SSP0015-0031 | DB-SYN | P_PROCEDURE_KEY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PROCEDURE_KEY | 없음(PROC_M 대응 없음) | 12 (ACT:SSP0015_ShipmentPSI.FindData_Main:25) |
| WK-SSP0015-0032 | DB-SYN | SSP0002_GET_NERP_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0002_GET_NERP_CODE | 없음(PROC_M 대응 없음) | 13 (ACT:SSP0015_ShipmentPSI.FindData_Main:25) |
| WK-SSP0015-0033 | G4 | btnItemID2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemID2 | 있음(FE 소스) | 2 (ACT:SSP0015_ShipmentPSI.InitEvent ACT:SS) |
| WK-SSP0015-0034 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0015_ShipmentPSI.InitEvent ACT:SS) |
| WK-SSP0015-0035 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SSP0015_ShipmentPSI.InitEvent ACT:SS) |
| WK-SSP0015-0036 | G4 | btnRequestor | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRequestor | 있음(FE 소스) | 2 (ACT:SSP0015_ShipmentPSI.InitEvent ACT:SS) |
| WK-SSP0015-0037 | G4 | btnSearch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSearch | 있음(FE 소스) | 2 (ACT:SSP0015_ShipmentPSI.InitEvent ACT:SS) |
| WK-SSP0015-0038 | E2 | EDIT_MAIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL EDIT_MAIN | 있음(SHEET_COLUMNS) | 1 (value) |
| WK-SSP0015-0039 | E2 | NEW_ETD / ETD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL NEW_ETD / ETD | 있음(SHEET_COLUMNS) | 1 (value) |
| WK-SSP0015-0040 | E2 | NEW_SHIPMENT_DATE / Shipment Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL NEW_SHIPMENT_DATE / Shipment Date | 있음(SHEET_COLUMNS) | 1 (value) |
| WK-SSP0015-0041 | G03-WIRE | SSP0015 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0015 화면 | 판단불가(대상 단위 SCREEN) | 49 (ACT:SSP0015_ShipmentPSI..ctor ACT:SSP001) |
| WK-SSP0015-0042 | G5 | FIGURE / Figure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL FIGURE / Figure | 있음(SHEET_COLUMNS) | 43 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0043 | G5 | REMARKS2 / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL REMARKS2 / Building | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0044 | G5 | SHIPMENT_DATE / Shipment Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL SHIPMENT_DATE / Shipment Date | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0045 | G5 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 8 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0046 | G5 | clbDivision / Division / Div / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbDivision / Division / Div / Div. | 있음(FE 소스) | 2 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0047 | G5 | drpPeriod2 / Shipment Date / Period2 / P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND drpPeriod2 / Shipment Date / Period2 / Period / Fr | 있음(FE 소스) | 3 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0048 | H6 | FIGURE / Figure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FIGURE / Figure | 있음(SHEET_COLUMNS) | 43 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0049 | H6 | REMARKS2 / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL REMARKS2 / Building | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0050 | H6 | SHIPMENT_DATE / Shipment Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL SHIPMENT_DATE / Shipment Date | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |

## W6 검증 실행 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0015-0051 | G4 | chkSum / Change Qty / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Change Qty / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0015_ShipmentPSI.InitEvent ACT:SS) |
| WK-SSP0015-0052 | G4 | txtChange_Qty / Change Qty / Change_Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtChange_Qty / Change Qty / Change_Qty · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0053 | G4 | txtItem_ID / Item_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItem_ID / Item_ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0054 | G4 | txtMeasure / Measure | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtMeasure / Measure · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0055 | G4 | txtProd_Qty / Prod_Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProd_Qty / Prod_Qty · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0056 | H6 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 8 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0057 | H6 | clbDivision / Division / Div / Div. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division / Div / Div. · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0058 | H6 | drpPeriod2 / Shipment Date / Period2 / P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — drpPeriod2 / Shipment Date / Period2 / Period / Fr · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 3 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0059 | H6 | txtModel2 / Model / Model2 / Model/Nickn | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtModel2 / Model / Model2 / Model/Nickname / Nick · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 6 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |

## W7 기대값 확정 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0015-0060 | F4 | P_PROCEDURE_KEY | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — P_PROCEDURE_KEY: 실측[T-86aa3be5]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T87 |  | 714 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0061 | F4 | SSP0002_GET_NERP_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0002_GET_NERP_CODE: 실측[T-bfca527c]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed |  | 715 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0062 | F4 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0003_GET_SSP_PLAN_PROCESSING_CHECK: 실측[T-3b660f01]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv  |  | 439 (ACT:SSP0015_ShipmentPSI.EngProcessingChk) |
| WK-SSP0015-0063 | H5 | chkSum / Change Qty / Sum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — chkSum / Change Qty / Sum: 검증 엔진이 실행됐으나 이 대상(COND chkSum)을 판정하지 못함 — 라벨 명칭 시나리오 수동 확인 또는 엔진 확장 |  | 3 (ACT:SSP0015_ShipmentPSI.SetSpreadColumn ) |
| WK-SSP0015-0064 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — 대조표 FindButton '실동작(활성시트 0/1 분기)' 의 A1 17요소: REVIEW:14 · NA:2 · PASS:1 · FAIL 요소: P_PROCEDURE_KEY — |  | 1 (FindButton) |
| WK-SSP0015-0065 | A1 | PKG_SSP0015.P_SSP0015_GET_BLOCK_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_BLOCK_STOCK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0015/SSP0015_GET_BLOCK_STOCK.m |  | 124 (ACT:SSP0015_ShipmentPSI.FindData_BolckSt) |
| WK-SSP0015-0066 | A1 | PKG_SSP0015.P_SSP0015_GET_MES_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_MES_STOCK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0015/SSP0015_GET_MES_STOCK.md —  |  | 113 (ACT:SSP0015_ShipmentPSI.FindData_MesStoc) |
| WK-SSP0015-0067 | A1 | PKG_SSP0015.P_SSP0015_GET_SCS_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_SCS_STOCK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0015/SSP0015_GET_SCS_STOCK.md —  |  | 47 (ACT:SSP0015_ShipmentPSI.FindData_ScsStoc) |
| WK-SSP0015-0068 | A1 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI: golden DIFF AS-IS 0행 ↔ TO-BE 90행: Doc/golden/SSP0015/SSP0015_GET_SHIPMENT_PSI. |  | 136 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0069 | A1 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_COMMENTS: golden DIFF AS-IS 7행 ↔ TO-BE 18행: Doc/golden/SSP0015/SSP0015_GET_SHIP |  | 36 (ACT:SSP0015_ShipmentPSI.FindData_WHinPla) |
| WK-SSP0015-0070 | A1 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_P | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_PACKER: golden DIFF AS-IS 198행 ↔ TO-BE 198행: Doc/golden/SSP0015/SSP0015_GET_SHI |  | 79 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0071 | A1 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_P | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0015/SSP0015_GET_ |  | 79 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0072 | A1 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESUL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESULT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0015/SSP0015_GET_SHIPMENT_ |  | 65 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0073 | A1 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESUL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESULT_PACKER: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0015/SSP0015_GET_SH |  | 64 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0074 | A1 | PKG_SSP0015.P_SSP0015_GET_STOCK_LOCATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_STOCK_LOCATION_DETAIL: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0015/SSP0015_GET_STO |  | 65 (ACT:SSP0015_ShipmentPSI.FindData_shtStoc) |
| WK-SSP0015-0075 | A1 | PKG_SSP0015.P_SSP0015_GET_WH_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0015.P_SSP0015_GET_WH_STOCK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0015/SSP0015_GET_WH_STOCK.md — 파라 |  | 63 (ACT:SSP0015_ShipmentPSI.FindData_WHstock) |
| WK-SSP0015-0076 | A1 | PKG_SSP0026.P_SSP0026_GET_REQUEST_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0026.P_SSP0026_GET_REQUEST_DETAIL_PACK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0015/SSP0026_GET_REQUE |  | 52 (ACT:SSP0015_ShipmentPSI.FindData_Request) |
| WK-SSP0015-0077 | A1 | P_PROCEDURE_KEY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_PROCEDURE_KEY: 골든 비교 케이스 없음(P_PROCEDURE_KEY — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 334 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0078 | A1 | SSP0002_GET_NERP_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0002_GET_NERP_CODE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0015/SSP0002_GET_NERP_CODE.md — 파라미터 미정 |  | 334 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0079 | A6 | P_PROCEDURE_KEY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_PROCEDURE_KEY: 검증 엔진이 실행됐으나 이 대상(SP P_PROCEDURE_KEY)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그 |  | 334 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0080 | X-ROW | SSP0015_ShipmentPSI.CalculateSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0015_ShipmentPSI.CalculateSum: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL, 연결된 요소 검사 없음 |  | 108 (ACT:SSP0015_ShipmentPSI.CalculateSum ACT) |
| WK-SSP0015-0081 | X-ROW | SSP0015_ShipmentPSI.Convert_Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0015_ShipmentPSI.Convert_Requestor: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 12 (ACT:SSP0015_ShipmentPSI.Convert_Requesto) |
| WK-SSP0015-0082 | X-ROW | SSP0015_ShipmentPSI.ShipmentResult_GetDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0015_ShipmentPSI.ShipmentResult_GetDayRange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SSP0015_ShipmentPSI.ShipmentResult_G) |
| WK-SSP0015-0083 | X-ROW | SSP0015_ShipmentPSI.SpdDetail_SheetTabCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0015_ShipmentPSI.SpdDetail_SheetTabClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/GRID_INIT, 연결된 요소 검사 없 |  | 38 (ACT:SSP0015_ShipmentPSI.SpdDetail_SheetT) |
| WK-SSP0015-0084 | X-ROW | SSP0015_ShipmentPSI.SpdMain_EditModeOn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0015_ShipmentPSI.SpdMain_EditModeOn: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/UI_PROP, 연결된 요소 검사 없음 |  | 2 (ACT:SSP0015_ShipmentPSI.SpdMain_EditMode) |
| WK-SSP0015-0085 | X-ROW | SSP0015_ShipmentPSI.spdMain_TextTipFetch | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0015_ShipmentPSI.spdMain_TextTipFetch: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/FLAG/GRID_SET, 연결된 요소 검사 없음 |  | 8 (ACT:SSP0015_ShipmentPSI.spdMain_TextTipF) |
| WK-SSP0015-0086 | M4 | SSP0015_ShipmentPSICommentsPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0015_ShipmentPSICommentsPopup: 검증 엔진이 실행됐으나 이 대상(POPUP SSP0015_ShipmentPSICommentsPop)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 |  | 2 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0087 | M4 | btnMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnMeasure: 검증 엔진이 실행됐으나 이 대상(BTN btnMeasure)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (btnMeasure_Click) |
| WK-SSP0015-0088 | M4 | cboPlanDate / Plan-date / Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboPlanDate / Plan-date / Plan Date: 검증 엔진이 실행됐으나 이 대상(COND cboPlanDate)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 8 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0089 | M4 | clbDivision / Division / Div / Div. | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbDivision / Division / Div / Div.: 검증 엔진이 실행됐으나 이 대상(COND clbDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0090 | M4 | drpPeriod2 / Shipment Date / Period2 / P | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — drpPeriod2 / Shipment Date / Period2 / Period / Fr: 검증 엔진이 실행됐으나 이 대상(COND drpPeriod2)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 |  | 3 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0091 | M4 | txtModel2 / Model / Model2 / Model/Nickn | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtModel2 / Model / Model2 / Model/Nickname / Nick: 검증 엔진이 실행됐으나 이 대상(COND txtModel2)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인  |  | 6 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |

## W9 도구 오류 (543)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0015-0092 | J2 | SSP0015 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-938c5eac RULE_SCREEN / 원장 V-e40b6e6b DEFECT / 원장 V-7eb597b7 GENERAL / 원장 V-63df8217 GENERAL / 원장 V-769b1865 GENERA |  | 194 (FindButton InsertButton DeleteButton Edi) |
| WK-SSP0015-0093 | C1 | cboBucketType / Bucket / Bucket Type | 하네스·환경 | C1 도구 오류 — 실측[T-3ac3c66b]: 'Bucket' → 'Weekly' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 cboBucketType_SelectedIndexChanged · AS-IS 하위  |  | 1 (ACT:SSP0015_ShipmentPSI.InitControls:577) |
| WK-SSP0015-0094 | C1 | clbDivision / Division / Div / Div. | 하네스·환경 | C1 도구 오류 — 원장 V-d636536e SEARCH / 실측[T-daf8b30d]: 상위 'Div' 에서 바꿀 옵션 없음(옵션 1개 또는 ALL 만) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0015_ShipmentPSI.InitControls:562) |
| WK-SSP0015-0095 | C2 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C2 도구 오류 — 실측[T-f3f9d082]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 25 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0096 | C2 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C2 도구 오류 — 실측[T-387498df]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 5 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0097 | C2 | EDIT_MAIN | 하네스·환경 | C2 도구 오류 — 실측[T-7ecb720a]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 9 (value ACT:SSP0015_ShipmentPSI.spdDetail_) |
| WK-SSP0015-0098 | C2 | ERP_SO_NO / SO No | 하네스·환경 | C2 도구 오류 — 실측[T-0c8ba3cc]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0099 | C2 | ETA | 하네스·환경 | C2 도구 오류 — 실측[T-48bcd0e3]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (value) |
| WK-SSP0015-0100 | C2 | NEW_ETD / ETD | 하네스·환경 | C2 도구 오류 — 실측[T-6399ebfc]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (value) |
| WK-SSP0015-0101 | C2 | NEW_ROUTE_ID / Route | 하네스·환경 | C2 도구 오류 — 실측[T-e750c300]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0102 | C2 | NEW_SHIPMENT_DATE / Shipment Date | 하네스·환경 | C2 도구 오류 — 실측[T-166410bc]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (value) |
| WK-SSP0015-0103 | C2 | SSP0015_ShipmentPSI.CboPlanDate_Selected | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.CboPlanDate_SelectedIndexChanged 의 C2 10요소: ERROR:10 |  | 8 (ACT:SSP0015_ShipmentPSI.CboPlanDate_Sele) |
| WK-SSP0015-0104 | C2 | SSP0015_ShipmentPSI.SpdDetail_ActiveShee | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SpdDetail_ActiveSheetChanged 의 C2 10요소: ERROR:10 |  | 8 (ACT:SSP0015_ShipmentPSI.SpdDetail_Active) |
| WK-SSP0015-0105 | C2 | SSP0015_ShipmentPSI.SpdMain_ActiveSheetC | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SpdMain_ActiveSheetChanged 의 C2 10요소: ERROR:10 |  | 68 (ACT:SSP0015_ShipmentPSI.SpdMain_ActiveSh) |
| WK-SSP0015-0106 | C2 | SSP0015_ShipmentPSI.cboBucketType_Select | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.cboBucketType_SelectedIndexChanged 의 C2 10요소: ERROR:10 |  | 1 (ACT:SSP0015_ShipmentPSI.cboBucketType_Se) |
| WK-SSP0015-0107 | C2 | SSP0015_ShipmentPSI.chkSum_CheckedChange | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.chkSum_CheckedChanged 의 C2 10요소: ERROR:10 |  | 1 (ACT:SSP0015_ShipmentPSI.chkSum_CheckedCh) |
| WK-SSP0015-0108 | C2 | SSP0015_ShipmentPSI.clbDivision_Selected | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.clbDivision_SelectedIndexChanged 의 C2 10요소: ERROR:10 |  | 1 (ACT:SSP0015_ShipmentPSI.clbDivision_Sele) |
| WK-SSP0015-0109 | C2 | TO_SITE_SHIPTO_CODE | 하네스·환경 | C2 도구 오류 — 원장 V-49c37f99 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0110 | C2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C2 도구 오류 — 실측[T-b80cb42a]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 36 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0111 | C2 | 변경사유 (#26·46 MSG00286/287) | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 변경사유 (#26·46 MSG00286/287) "reason '-'/공백" 의 C2 10요소: ERROR:10 |  | 1 (변경사유 (#26·46 MSG00286/287)) |
| WK-SSP0015-0112 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-a0577b86 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0113 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-0c8ac879 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0114 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-9ce1f3a6 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0115 | C3 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C3 도구 오류 — 원장 V-a0577b86 ASIS / 원장 V-0659a6d8 ASIS / 원장 V-49702555 ASIS / 원장 V-0c8ac879 ASIS / 원장 V-435a4863 ASIS / 원장 V-9ce1f3a6  |  | 35 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0116 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-d79996bb |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0117 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-f3df4b85 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0118 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-539d16d1 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0119 | C3 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C3 도구 오류 — 원장 V-d79996bb ASIS / 원장 V-e19ab31c ASIS / 원장 V-f3df4b85 ASIS / 원장 V-07131b2f ASIS / 원장 V-539d16d1 ASIS / 실측[T-ebe733f8] |  | 14 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0120 | C3 | COMMENTS / Comments | 하네스·환경 | C3 도구 오류 — 실측[T-78ce1c41]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0015_ShipmentPSI.SetNote_Display ) |
| WK-SSP0015-0121 | C3 | DIVISION_ID / Div | 하네스·환경 | C3 도구 오류 — 실측[T-aae1cc82]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 13 (ACT:SSP0015_ShipmentPSI.InsertRow:7704:5) |
| WK-SSP0015-0122 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-88e855fb ASIS / 원장 V-c52ef11d ASIS / 원장 V-6db0e474 ASIS / 원장 V-0c356f9e ASIS / 원장 V-e5b5a0ea ASIS / 원장 V-b21acea4  |  | 34 (value ACT:SSP0015_ShipmentPSI.SpdDetail_) |
| WK-SSP0015-0123 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-88e855fb |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0124 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-c52ef11d |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0125 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-6db0e474 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0126 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-0c356f9e |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0127 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-e5b5a0ea |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0128 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-b21acea4 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0129 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-8fb6c141 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0130 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-6d8a4205 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0131 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-f83ed690 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0132 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-49ddc83a |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0133 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-baeac17e |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0134 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-64b2163c |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0135 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-e19ab31c |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0136 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-07131b2f |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0137 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-1ed7ad36 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0138 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-1a639478 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0139 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-0659a6d8 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0140 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-49702555 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0141 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-435a4863 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0142 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-975e2c61 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0143 | C3 | ERP_SO_NO / SO No | 하네스·환경 | C3 도구 오류 — 실측[T-c9aed0fd]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 28 (ACT:SSP0015_ShipmentPSI.SetSoNoColumnVis) |
| WK-SSP0015-0144 | C3 | ETA | 하네스·환경 | C3 도구 오류 — 실측[T-80c9dacb]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (value) |
| WK-SSP0015-0145 | C3 | FIGURE / Figure | 하네스·환경 | C3 도구 오류 — 실측[T-23468115]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0146 | C3 | FROM_SITE / Site | 하네스·환경 | C3 도구 오류 — 실측[T-6fa9bddf]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 9 (ACT:SSP0015_ShipmentPSI.InsertRow:7705:6) |
| WK-SSP0015-0147 | C3 | FROM_SITE_NM / From Site | 하네스·환경 | C3 도구 오류 — 실측[T-f757acc9]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0015_ShipmentPSI.InsertRow:7706:7) |
| WK-SSP0015-0148 | C3 | HOLD_YYYYMMDD / Start Date | 하네스·환경 | C3 도구 오류 — 실측[T-abbd6c0b]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 0 () |
| WK-SSP0015-0149 | C3 | INCOTERMS / Incoterms | 하네스·환경 | C3 도구 오류 — 실측[T-940c6a0f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 5 (ACT:SSP0015_ShipmentPSI.SetImageCell ACT) |
| WK-SSP0015-0150 | C3 | ITEM_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-68d7bed2]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 11 (ACT:SSP0015_ShipmentPSI.FindData_mes_sto) |
| WK-SSP0015-0151 | C3 | LT_DAY / Aging L/T | 하네스·환경 | C3 도구 오류 — 실측[T-40514e83]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0015_ShipmentPSI.FindData_Main:26) |
| WK-SSP0015-0152 | C3 | MEASURE / Measure | 하네스·환경 | C3 도구 오류 — 실측[T-eabb84a7]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0015_ShipmentPSI.SetBalanceMinus ) |
| WK-SSP0015-0153 | C3 | NEW_ETA | 하네스·환경 | C3 도구 오류 — 원장 V-6639c249 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0154 | C3 | NEW_ETA | 하네스·환경 | C3 도구 오류 — 원장 V-12df7cec |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0155 | C3 | NEW_ETA / ETA | 하네스·환경 | C3 도구 오류 — 원장 V-6639c249 ASIS / 원장 V-12df7cec ASIS / 실측[T-24a255f6]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0156 | C3 | NEW_ETD | 하네스·환경 | C3 도구 오류 — 원장 V-2b7c4580 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0157 | C3 | NEW_ETD | 하네스·환경 | C3 도구 오류 — 원장 V-563055ec |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0158 | C3 | NEW_ETD / ETD | 하네스·환경 | C3 도구 오류 — 원장 V-2b7c4580 ASIS / 원장 V-563055ec ASIS / 실측[T-6e11227e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow |  | 4 (value ACT:SSP0015_ShipmentPSI.SpdDetail_) |
| WK-SSP0015-0159 | C3 | NEW_LT_DAY / L/T(Day | 하네스·환경 | C3 도구 오류 — 실측[T-9f92bdf0]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0160 | C3 | NEW_ROUTE_ID / Route | 하네스·환경 | C3 도구 오류 — 실측[T-d6638216]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0161 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-f9dd162e |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0162 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-a2dbe995 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0163 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-88c821fd |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0164 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-4bbb02da |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0165 | C3 | NEW_SHIPMENT_DATE / Shipment Date | 하네스·환경 | C3 도구 오류 — 원장 V-f9dd162e ASIS / 원장 V-a2dbe995 ASIS / 원장 V-88c821fd ASIS / 원장 V-4bbb02da ASIS / 실측[T-17b6c18e]: [측정 경로 없음] 조회 후 Ins |  | 7 (value ACT:SSP0015_ShipmentPSI.SpdDetail_) |
| WK-SSP0015-0166 | C3 | NICK_NAME / Nick Name | 하네스·환경 | C3 도구 오류 — 실측[T-d34f287f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0015_ShipmentPSI.InsertRow:7708:9) |
| WK-SSP0015-0167 | C3 | ORIGIN_FROM_DIVISION_ID | 하네스·환경 | C3 도구 오류 — 실측[T-e1e42c5e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0168 | C3 | PROD_DATE / Production Date | 하네스·환경 | C3 도구 오류 — 실측[T-42ee6dcc]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0015_ShipmentPSI.FindData_Main:27) |
| WK-SSP0015-0169 | C3 | PSI_NAME / PSI | 하네스·환경 | C3 도구 오류 — 실측[T-be9c3a94]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0015_ShipmentPSI.InitSpread:778:1) |
| WK-SSP0015-0170 | C3 | REMARKS / Remarks | 하네스·환경 | C3 도구 오류 — 원장 V-b21acea4 ASIS / 원장 V-8fb6c141 ASIS / 원장 V-a0577b86 ASIS / 원장 V-6d8a4205 ASIS / 원장 V-f83ed690 ASIS / 원장 V-d79996bb  |  | 7 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0171 | C3 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | C3 도구 오류 — 원장 V-e5b5a0ea ASIS / 원장 V-b21acea4 ASIS / 원장 V-8fb6c141 ASIS / 원장 V-a0577b86 ASIS / 원장 V-6d8a4205 ASIS / 원장 V-f83ed690  |  | 5 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0172 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-ab138d95 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0173 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-b6685f68 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0174 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-66c2aee4 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0175 | C3 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | C3 도구 오류 — 원장 V-ab138d95 ASIS / 원장 V-2b7c4580 ASIS / 원장 V-6639c249 ASIS / 원장 V-f9dd162e ASIS / 원장 V-6db0e474 ASIS / 원장 V-b6685f68  |  | 18 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0176 | C3 | SHIPTO_DESCRIPTION / Ship to Name | 하네스·환경 | C3 도구 오류 — 실측[T-63d369ca]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0177 | C3 | SHIP_TO / Ship to | 하네스·환경 | C3 도구 오류 — 실측[T-dd741b6f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0178 | C3 | SSP0015_ShipmentPSI.CboPlanDate_Selected | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.CboPlanDate_SelectedIndexChanged 의 C3 74요소: ERROR:72 · NA:2 |  | 8 (ACT:SSP0015_ShipmentPSI.CboPlanDate_Sele) |
| WK-SSP0015-0179 | C3 | SSP0015_ShipmentPSI.SetChangeControl | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SetChangeControl 의 C3 74요소: ERROR:72 · NA:2 |  | 11 (ACT:SSP0015_ShipmentPSI.SetChangeControl) |
| WK-SSP0015-0180 | C3 | SSP0015_ShipmentPSI.SetChangedControl | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SetChangedControl 의 C3 74요소: ERROR:72 · NA:2 |  | 11 (ACT:SSP0015_ShipmentPSI.SetChangedContro) |
| WK-SSP0015-0181 | C3 | SSP0015_ShipmentPSI.SetLockSumColumn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SetLockSumColumn 의 C3 74요소: ERROR:72 · NA:2 |  | 3 (ACT:SSP0015_ShipmentPSI.SetLockSumColumn) |
| WK-SSP0015-0182 | C3 | SSP0015_ShipmentPSI.SetNote_Display | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SetNote_Display 의 C3 5요소: ERROR:5 |  | 2 (ACT:SSP0015_ShipmentPSI.SetNote_Display:) |
| WK-SSP0015-0183 | C3 | SSP0015_ShipmentPSI.SetProdNote_Display | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SetProdNote_Display 의 C3 4요소: ERROR:4 |  | 7 (ACT:SSP0015_ShipmentPSI.SetProdNote_Disp) |
| WK-SSP0015-0184 | C3 | SSP0015_ShipmentPSI.SetSpreadColumn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SetSpreadColumn 의 C3 1요소: ERROR:1 |  | 1 (ACT:SSP0015_ShipmentPSI.SetSpreadColumn:) |
| WK-SSP0015-0185 | C3 | SSP0015_ShipmentPSI.Set_SumValues | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.Set_SumValues 의 C3 2요소: ERROR:2 |  | 28 (ACT:SSP0015_ShipmentPSI.Set_SumValues:29) |
| WK-SSP0015-0186 | C3 | SSP0015_ShipmentPSI.SpdDetail_ActiveShee | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SpdDetail_ActiveSheetChanged 의 C3 74요소: ERROR:72 · NA:2 |  | 8 (ACT:SSP0015_ShipmentPSI.SpdDetail_Active) |
| WK-SSP0015-0187 | C3 | SSP0015_ShipmentPSI.SpdMain_ActiveSheetC | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SpdMain_ActiveSheetChanged 의 C3 74요소: ERROR:72 · NA:2 |  | 68 (ACT:SSP0015_ShipmentPSI.SpdMain_ActiveSh) |
| WK-SSP0015-0188 | C3 | SSP0015_ShipmentPSI.cboBucketType_Select | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.cboBucketType_SelectedIndexChanged 의 C3 74요소: ERROR:72 · NA:2 |  | 1 (ACT:SSP0015_ShipmentPSI.cboBucketType_Se) |
| WK-SSP0015-0189 | C3 | SSP0015_ShipmentPSI.chkSum_CheckedChange | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.chkSum_CheckedChanged 의 C3 74요소: ERROR:72 · NA:2 |  | 1 (ACT:SSP0015_ShipmentPSI.chkSum_CheckedCh) |
| WK-SSP0015-0190 | C3 | SSP0015_ShipmentPSI.clbDivision_Selected | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.clbDivision_SelectedIndexChanged 의 C3 74요소: ERROR:72 · NA:2 |  | 1 (ACT:SSP0015_ShipmentPSI.clbDivision_Sele) |
| WK-SSP0015-0191 | C3 | TO_SITE / To Site | 하네스·환경 | C3 도구 오류 — 실측[T-c1c29142]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0192 | C3 | TO_SITE_SHIPTO_CODE / Ship to | 하네스·환경 | C3 도구 오류 — 실측[T-69da2133]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0193 | C3 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C3 도구 오류 — 원장 V-88e855fb ASIS / 원장 V-c52ef11d ASIS / 원장 V-ab138d95 ASIS / 원장 V-2b7c4580 ASIS / 원장 V-6639c249 ASIS / 원장 V-f9dd162e  |  | 45 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0194 | C3 | TYPE / Status | 하네스·환경 | C3 도구 오류 — 실측[T-b34ea577]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0015_ShipmentPSI.InitSpread:776:1) |
| WK-SSP0015-0195 | C3 | USER_MOD_RELEASE_DATE / User Modified Re | 하네스·환경 | C3 도구 오류 — 실측[T-28ec1c86]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0015_ShipmentPSI.FindData_MesStoc) |
| WK-SSP0015-0196 | C3 | YYYYMMDD / Date | 하네스·환경 | C3 도구 오류 — 실측[T-f5a76d0b]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0015_ShipmentPSI.SetNote_Display ) |
| WK-SSP0015-0197 | C3 | 변경사유 (#26·46 MSG00286/287) | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 변경사유 (#26·46 MSG00286/287) "reason '-'/공백" 의 C3 74요소: ERROR:72 · NA:2 |  | 1 (변경사유 (#26·46 MSG00286/287)) |
| WK-SSP0015-0198 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-f735d1d0 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0199 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-923b3c3f |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0200 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-63b63925 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0201 | C6 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C6 도구 오류 — 원장 V-f735d1d0 ASIS / 원장 V-2d806d82 ASIS / 원장 V-737fcaf8 ASIS / 원장 V-720edb77 ASIS / 원장 V-923b3c3f ASIS / 원장 V-d8e645f8  |  | 25 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0202 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-d269c3f9 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0203 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-36c7f323 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0204 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-737fcaf8 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0205 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-d8e645f8 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0206 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-d84cb492 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0207 | C6 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C6 도구 오류 — 원장 V-d269c3f9 ASIS / 원장 V-d0e6904b ASIS / 원장 V-36c7f323 ASIS / 원장 V-66d6807f ASIS / 원장 V-737fcaf8 ASIS / 원장 V-d8e645f8  |  | 5 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0208 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-73ccd0c1 ASIS / 원장 V-79ec38ea ASIS / 원장 V-ee2b16e5 ASIS / 원장 V-6a644898 ASIS / 원장 V-f50ac75e ASIS / 원장 V-4800b32a  |  | 9 (value ACT:SSP0015_ShipmentPSI.spdDetail_) |
| WK-SSP0015-0209 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-73ccd0c1 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0210 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-79ec38ea |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0211 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-ee2b16e5 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0212 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-6a644898 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0213 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-f50ac75e |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0214 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-4800b32a |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0215 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-742bb9b9 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0216 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-0dd6b039 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0217 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-b76ee780 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0218 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-1c32647c |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0219 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-d79d8310 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0220 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-6a64cee7 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0221 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-d0e6904b |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0222 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-66d6807f |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0223 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-d0ef5ce3 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0224 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-9c291a4c |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0225 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-2d806d82 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0226 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-720edb77 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0227 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-af2a64bf |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0228 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-747d2e79 |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0229 | C6 | ERP_SO_NO / SO No | 하네스·환경 | C6 도구 오류 — 실측[T-8c52182e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0230 | C6 | ETA | 하네스·환경 | C6 도구 오류 — 실측[T-ea145b86]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (value) |
| WK-SSP0015-0231 | C6 | NEW_ETA | 하네스·환경 | C6 도구 오류 — 원장 V-aef05c32 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0232 | C6 | NEW_ETA | 하네스·환경 | C6 도구 오류 — 원장 V-2c7946d2 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0233 | C6 | NEW_ETD | 하네스·환경 | C6 도구 오류 — 원장 V-b08a60be |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0234 | C6 | NEW_ETD | 하네스·환경 | C6 도구 오류 — 원장 V-0de29101 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0235 | C6 | NEW_ETD / ETD | 하네스·환경 | C6 도구 오류 — 원장 V-b08a60be ASIS / 원장 V-0de29101 ASIS / 실측[T-22ff9f0e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow |  | 1 (value) |
| WK-SSP0015-0236 | C6 | NEW_ROUTE_ID / Route | 하네스·환경 | C6 도구 오류 — 실측[T-afff1af1]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0237 | C6 | NEW_SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-cc70a8f9 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0238 | C6 | NEW_SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-8fbce4de |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0239 | C6 | NEW_SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-acb2a380 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0240 | C6 | NEW_SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-3aa29620 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0241 | C6 | NEW_SHIPMENT_DATE / Shipment Date | 하네스·환경 | C6 도구 오류 — 원장 V-cc70a8f9 ASIS / 원장 V-8fbce4de ASIS / 원장 V-acb2a380 ASIS / 원장 V-3aa29620 ASIS / 실측[T-8bf3eb83]: [측정 경로 없음] 조회 후 Ins |  | 1 (value) |
| WK-SSP0015-0242 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-0fd86f98 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0243 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-bb338868 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0244 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-4c38ec21 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0245 | C6 | SSP0015_ShipmentPSI.CboPlanDate_Selected | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.CboPlanDate_SelectedIndexChanged 의 C6 50요소: ERROR:50 |  | 8 (ACT:SSP0015_ShipmentPSI.CboPlanDate_Sele) |
| WK-SSP0015-0246 | C6 | SSP0015_ShipmentPSI.SpdDetail_ActiveShee | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SpdDetail_ActiveSheetChanged 의 C6 50요소: ERROR:50 |  | 8 (ACT:SSP0015_ShipmentPSI.SpdDetail_Active) |
| WK-SSP0015-0247 | C6 | SSP0015_ShipmentPSI.SpdMain_ActiveSheetC | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SpdMain_ActiveSheetChanged 의 C6 50요소: ERROR:50 |  | 68 (ACT:SSP0015_ShipmentPSI.SpdMain_ActiveSh) |
| WK-SSP0015-0248 | C6 | SSP0015_ShipmentPSI.cboBucketType_Select | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.cboBucketType_SelectedIndexChanged 의 C6 50요소: ERROR:50 |  | 1 (ACT:SSP0015_ShipmentPSI.cboBucketType_Se) |
| WK-SSP0015-0249 | C6 | SSP0015_ShipmentPSI.chkSum_CheckedChange | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.chkSum_CheckedChanged 의 C6 50요소: ERROR:50 |  | 1 (ACT:SSP0015_ShipmentPSI.chkSum_CheckedCh) |
| WK-SSP0015-0250 | C6 | SSP0015_ShipmentPSI.clbDivision_Selected | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.clbDivision_SelectedIndexChanged 의 C6 50요소: ERROR:50 |  | 1 (ACT:SSP0015_ShipmentPSI.clbDivision_Sele) |
| WK-SSP0015-0251 | C6 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C6 도구 오류 — 원장 V-9969647d ASIS / 원장 V-73ccd0c1 ASIS / 원장 V-79ec38ea ASIS / 원장 V-e42ecde3 ASIS / 원장 V-0fd86f98 ASIS / 원장 V-b08a60be  |  | 36 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0252 | C6 | siDetail.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-9969647d |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0253 | C6 | siDetail.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-e42ecde3 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0254 | C6 | 변경사유 (#26·46 MSG00286/287) | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 변경사유 (#26·46 MSG00286/287) "reason '-'/공백" 의 C6 50요소: ERROR:50 |  | 1 (변경사유 (#26·46 MSG00286/287)) |
| WK-SSP0015-0255 | B1 | TO_SITE_SHIPTO_CODE / Ship to | 하네스·환경 | B1 도구 오류 — 원장 V-f1126801 COLUMN |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0256 | B2 | TO_SITE_SHIPTO_CODE / Ship to | 하네스·환경 | B2 도구 오류 — 원장 V-1a31e2f9 COLUMN |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0257 | B3 | DIVISION_ID / Div | 하네스·환경 | B3 도구 오류 — 원장 V-e28f2602 COLUMN / 원장 V-72acb2e6 COLUMN / 원장 V-1fea0d12 COLUMN / 원장 V-c39b6c95 COLUMN / 원장 V-9503abc9 COLUMN / 원장 V |  | 8 (ACT:SSP0015_ShipmentPSI.GetERPInterface ) |
| WK-SSP0015-0258 | B3 | SSP0015_ShipmentPSI.GetBucketType | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetBucketType 의 B3 13요소: NA:8 · ERROR:5 |  | 2 (ACT:SSP0015_ShipmentPSI.GetBucketType:21) |
| WK-SSP0015-0259 | B3 | SSP0015_ShipmentPSI.GetDayRange | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetDayRange 의 B3 1요소: ERROR:1 |  | 9 (ACT:SSP0015_ShipmentPSI.GetDayRange:9260) |
| WK-SSP0015-0260 | B3 | SSP0015_ShipmentPSI.GetERPInterface | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetERPInterface 의 B3 6요소: NA:5 · ERROR:1 |  | 84 (ACT:SSP0015_ShipmentPSI.GetERPInterface:) |
| WK-SSP0015-0261 | B3 | SSP0015_ShipmentPSI.GetErpIFCheckNew | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetErpIFCheckNew 의 B3 13요소: NA:8 · ERROR:5 |  | 43 (ACT:SSP0015_ShipmentPSI.GetErpIFCheckNew) |
| WK-SSP0015-0262 | B3 | SSP0015_ShipmentPSI.GetErpSoNoCnt | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetErpSoNoCnt 의 B3 13요소: NA:8 · ERROR:5 |  | 9 (ACT:SSP0015_ShipmentPSI.GetErpSoNoCnt:71) |
| WK-SSP0015-0263 | B3 | SSP0015_ShipmentPSI.GetNERPCode | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetNERPCode 의 B3 13요소: NA:8 · ERROR:5 |  | 9 (ACT:SSP0015_ShipmentPSI.GetNERPCode:2898) |
| WK-SSP0015-0264 | B3 | SSP0015_ShipmentPSI.GetSSPUserCheck | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetSSPUserCheck 의 B3 13요소: NA:8 · ERROR:5 |  | 9 (ACT:SSP0015_ShipmentPSI.GetSSPUserCheck:) |
| WK-SSP0015-0265 | B3 | TO_SITE_SHIPTO_CODE / Ship to | 하네스·환경 | B3 도구 오류 — 원장 V-f7170c29 COLUMN |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0266 | B3 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | B3 도구 오류 — 원장 V-6d1e755c COLUMN |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0267 | B3 | cboPlanDate / Plan-date / Plan Date | 하네스·환경 | B3 도구 오류 — 원장 V-34ae22a2 SEARCH |  | 3 (ACT:SSP0015_ShipmentPSI.GetDayRange ACT:) |
| WK-SSP0015-0268 | B3 | clbDivision / Division / Div / Div. | 하네스·환경 | B3 도구 오류 — 원장 V-d3582f4b SEARCH |  | 1 (ACT:SSP0015_ShipmentPSI.SetChangeControl) |
| WK-SSP0015-0269 | B4 | DIVISION_ID / Div | 하네스·환경 | B4 도구 오류 — 원장 V-273a9bff COLUMN / 원장 V-4ebca3db COLUMN / 원장 V-ae5ce5eb COLUMN / 원장 V-90b6ce52 COLUMN / 원장 V-b9aebf05 COLUMN / 원장 V |  | 8 (ACT:SSP0015_ShipmentPSI.GetERPInterface ) |
| WK-SSP0015-0270 | B4 | SSP0015_ShipmentPSI.GetBucketType | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetBucketType 의 B4 13요소: NA:8 · ERROR:5 |  | 2 (ACT:SSP0015_ShipmentPSI.GetBucketType:21) |
| WK-SSP0015-0271 | B4 | SSP0015_ShipmentPSI.GetDayRange | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetDayRange 의 B4 1요소: ERROR:1 |  | 9 (ACT:SSP0015_ShipmentPSI.GetDayRange:9260) |
| WK-SSP0015-0272 | B4 | SSP0015_ShipmentPSI.GetERPInterface | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetERPInterface 의 B4 6요소: NA:5 · ERROR:1 |  | 84 (ACT:SSP0015_ShipmentPSI.GetERPInterface:) |
| WK-SSP0015-0273 | B4 | SSP0015_ShipmentPSI.GetErpIFCheckNew | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetErpIFCheckNew 의 B4 13요소: NA:8 · ERROR:5 |  | 43 (ACT:SSP0015_ShipmentPSI.GetErpIFCheckNew) |
| WK-SSP0015-0274 | B4 | SSP0015_ShipmentPSI.GetErpSoNoCnt | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetErpSoNoCnt 의 B4 13요소: NA:8 · ERROR:5 |  | 9 (ACT:SSP0015_ShipmentPSI.GetErpSoNoCnt:71) |
| WK-SSP0015-0275 | B4 | SSP0015_ShipmentPSI.GetNERPCode | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetNERPCode 의 B4 13요소: NA:8 · ERROR:5 |  | 9 (ACT:SSP0015_ShipmentPSI.GetNERPCode:2898) |
| WK-SSP0015-0276 | B4 | SSP0015_ShipmentPSI.GetSSPUserCheck | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetSSPUserCheck 의 B4 13요소: NA:8 · ERROR:5 |  | 9 (ACT:SSP0015_ShipmentPSI.GetSSPUserCheck:) |
| WK-SSP0015-0277 | B4 | TO_SITE_SHIPTO_CODE / Ship to | 하네스·환경 | B4 도구 오류 — 원장 V-31debcb2 COLUMN |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0278 | B4 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | B4 도구 오류 — 원장 V-007cb90b COLUMN |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0279 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스·환경 | B4 도구 오류 — 원장 V-2db3ab5b SEARCH |  | 3 (ACT:SSP0015_ShipmentPSI.GetDayRange ACT:) |
| WK-SSP0015-0280 | B4 | clbDivision / Division / Div / Div. | 하네스·환경 | B4 도구 오류 — 원장 V-695022fb SEARCH |  | 1 (ACT:SSP0015_ShipmentPSI.SetChangeControl) |
| WK-SSP0015-0281 | K4 | SSP0015 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-36051a98 GENERAL / 원장 V-51d9607d GENERAL / 원장 V-e3ef5877 GENERAL / 원장 V-81eccbca GENERAL / 원장 V-33078932 GENERAL / |  | 182 (ACT:SSP0015_ShipmentPSI.BtnChecked_Click) |
| WK-SSP0015-0282 | F1 | SSP0015 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-71439f46 RULE_SCREEN / 원장 V-5d8fbcd9 RULE_SCREEN / 원장 V-b37938d5 RULE_SCREEN / 원장 V-024946ae RULE_SCREEN / 원장 V-11 |  | 586 (DeleteButton SaveButton 변경없음 (#11·15 MSG) |
| WK-SSP0015-0283 | F2 | SSP0015 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-51e9c07a RULE_SCREEN / 원장 V-5d4e6478 RULE_SCREEN / 원장 V-a055c4b2 GENERAL / 원장 V-65934a07 GENERAL / 원장 V-35c18f17 G |  | 575 (SaveButton 변경없음 (#11·15 MSG00133) Detail) |
| WK-SSP0015-0284 | F3 | SSP0015 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-adf6ba72 RULE_SCREEN / 원장 V-fb41dfab RULE_SCREEN / 원장 V-b1a18dd4 GENERAL / 원장 V-590ce20d GENERAL / 원장 V-7f1e78eb G |  | 111 (value ACT:SSP0015_ShipmentPSI.SpdDetail_) |
| WK-SSP0015-0285 | F5 | SSP0015 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-dd7a6977 RULE_SCREEN / 원장 V-ebee3198 RULE_SCREEN / 원장 V-4f0890c5 RULE_SCREEN / 원장 V-5e1d9e94 DEFECT / 원장 V-8282103 |  | 11 (DeleteButton other ACT:SSP0015_ShipmentP) |
| WK-SSP0015-0286 | F6 | SSP0015 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-e9d841e7 RULE_SCREEN / 원장 V-be3f195f RULE_SCREEN / 원장 V-c8db60df RULE_SCREEN / 원장 V-4a567b5f RULE_SCREEN / 원장 V-df |  | 569 (ACT:SSP0015_ShipmentPSI.SaveButton ACT:S) |
| WK-SSP0015-0287 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | 하네스·환경 | F4 도구 오류 — 실측[T-3b0e6622]: PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD: SCP0009/main/W26, SCP0009/main/W52, SCP0025/main/GET_SCP_DAY_ |  | 2 (ACT:SSP0015_ShipmentPSI.GetDayRange:9289) |
| WK-SSP0015-0288 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 하네스·환경 | F4 도구 오류 — 실측[T-d56b0201]: PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: SCP0009/calendar/SEARCH, SCP0010/calendar/SEARCH, SCP00 |  | 1666 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0289 | F4 | PKG_SSP0015.P_SSP0015_GET_BLOCK_STOCK | 하네스·환경 | F4 도구 오류 — 실측[T-558cba5e]: PKG_SSP0015.P_SSP0015_GET_BLOCK_STOCK: SSP0015/holdStock/SEARCH, SSP0015/main/GET_BLOCK_STOCK — 화면 진입·조 |  | 124 (ACT:SSP0015_ShipmentPSI.FindData_BolckSt) |
| WK-SSP0015-0290 | F4 | PKG_SSP0015.P_SSP0015_GET_ERP_SO_NO_CNT | 하네스·환경 | F4 도구 오류 — 실측[T-f2ed0014]: PKG_SSP0015.P_SSP0015_GET_ERP_SO_NO_CNT: SSP0015/main/GET_ERP_SO_NO_CNT — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회  |  | 443 (ACT:SSP0015_ShipmentPSI.GetERPInterface:) |
| WK-SSP0015-0291 | F4 | PKG_SSP0015.P_SSP0015_GET_MES_STOCK | 하네스·환경 | F4 도구 오류 — 실측[T-3d0d8149]: PKG_SSP0015.P_SSP0015_GET_MES_STOCK: SSP0015/main/GET_MES_STOCK, SSP0015/mesStock/SEARCH — 화면 진입·조회 중 호 |  | 425 (ACT:SSP0015_ShipmentPSI.FindData_MesStoc) |
| WK-SSP0015-0292 | F4 | PKG_SSP0015.P_SSP0015_GET_SCS_STOCK | 하네스·환경 | F4 도구 오류 — 실측[T-4b76a738]: PKG_SSP0015.P_SSP0015_GET_SCS_STOCK: SSP0015/main/GET_SCS_STOCK, SSP0015/scsStock/SEARCH — 화면 진입·조회 중 호 |  | 47 (ACT:SSP0015_ShipmentPSI.FindData_ScsStoc) |
| WK-SSP0015-0293 | F4 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFI | 하네스·환경 | F4 도구 오류 — 실측[T-cf8b9b19]: PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL: SSP0015/confirmDetail/SEARCH, SSP0015/main/GET_SHIPM |  | 529 (ACT:SSP0015_ShipmentPSI.FindData_Detail ) |
| WK-SSP0015-0294 | F4 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFI | 하네스·환경 | F4 도구 오류 — 실측[T-04b31804]: PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER: SSP0015/main/GET_SHIPMENT_CONFIRM_DETAIL_PACK |  | 205 (ACT:SSP0015_ShipmentPSI.FindData_Detail_) |
| WK-SSP0015-0295 | F4 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_P | 하네스·환경 | F4 도구 오류 — 실측[T-0808d38f]: PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_PACKER: SSP0015/main/GET_SHIPMENT_PSI_PACKER, SSP0015/mainPacker |  | 79 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0296 | F4 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_P | 하네스·환경 | F4 도구 오류 — 실측[T-c3d0a86d]: PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST: SSP0015/main/GET_SHIPMENT_PSI_PACKER_PAST — 화면 진입·조 |  | 79 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0297 | F4 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESUL | 하네스·환경 | F4 도구 오류 — 실측[T-ade21b38]: PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESULT: SSP0015/main/GET_SHIPMENT_RESULT, SSP0015/shipmentResult/SEA |  | 65 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0298 | F4 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESUL | 하네스·환경 | F4 도구 오류 — 실측[T-f1a480a1]: PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESULT_PACKER: SSP0015/main/GET_SHIPMENT_RESULT_PACKER — 화면 진입·조회 중  |  | 64 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0299 | F4 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_STATU | 하네스·환경 | F4 도구 오류 — 실측[T-fd61fc07]: PKG_SSP0015.P_SSP0015_GET_SHIPMENT_STATUS: SSP0015/main/GET_SHIPMENT_STATUS — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 |  | 443 (ACT:SSP0015_ShipmentPSI.GetERPInterface:) |
| WK-SSP0015-0300 | F4 | PKG_SSP0015.P_SSP0015_GET_STOCK_LOCATION | 하네스·환경 | F4 도구 오류 — 실측[T-d6d96245]: PKG_SSP0015.P_SSP0015_GET_STOCK_LOCATION_DETAIL: SSP0015/main/GET_STOCK_LOCATION_DETAIL, SSP0015/stockL |  | 65 (ACT:SSP0015_ShipmentPSI.FindData_shtStoc) |
| WK-SSP0015-0301 | F4 | PKG_SSP0015.P_SSP0015_GET_WH_STOCK | 하네스·환경 | F4 도구 오류 — 실측[T-aaa99da2]: PKG_SSP0015.P_SSP0015_GET_WH_STOCK: SSP0015/main/GET_WH_STOCK, SSP0015/whStock/SEARCH — 화면 진입·조회 중 호출 없 |  | 63 (ACT:SSP0015_ShipmentPSI.FindData_WHstock) |
| WK-SSP0015-0302 | F4 | PKG_SSP0026.P_SSP0026_GET_REQUEST_DETAIL | 하네스·환경 | F4 도구 오류 — 실측[T-db7f8a1a]: PKG_SSP0026.P_SSP0026_GET_REQUEST_DETAIL_PACK: SSP0026/requestDetail/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 |  | 52 (ACT:SSP0015_ShipmentPSI.FindData_Request) |
| WK-SSP0015-0303 | F4 | PKG_SSP0202.P_SSP0202_GET_SCS_CONFIRM_ID | 하네스·환경 | F4 도구 오류 — 실측[T-662e8fbd]: PKG_SSP0202.P_SSP0202_GET_SCS_CONFIRM_ID_CHECK: SSP0202/main/SCS_CHECK — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경 |  | 134 (ACT:SSP0015_ShipmentPSI.SaveButton ACT:S) |
| WK-SSP0015-0304 | F4 | SSP0015_ShipmentPSI.ChkConfirmChangeTime | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.ChkConfirmChangeTime 의 F4 34요소: ERROR:17 · NA:11 · REVIEW:3 · PASS:3 · FAIL 요소: SSP000 |  | 2 (ACT:SSP0015_ShipmentPSI.ChkConfirmChange) |
| WK-SSP0015-0305 | F4 | SSP0015_ShipmentPSI.GetErpIFCheckNew | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.GetErpIFCheckNew 의 F4 34요소: ERROR:17 · NA:11 · REVIEW:3 · PASS:3 · FAIL 요소: SSP0003_GE |  | 6 (ACT:SSP0015_ShipmentPSI.GetErpIFCheckNew) |
| WK-SSP0015-0306 | A5 | FindButton | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 FindButton '실동작(활성시트 0/1 분기)' 의 A5 12요소: PASS:7 · ERROR:4 · NA:1 |  | 1 (FindButton) |
| WK-SSP0015-0307 | A5 | HOLD_QTY / Hold Qty | 하네스·환경 | A5 도구 오류 — 실측[T-d3e6a2b8]: HOLD_QTY: [측정 경로 없음] AS-IS 시트 Hold stock/Hold stock Detail/W/H stock/W/H stock Detail 의 TO-BE 그리드를 화면에서 |  | 3 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0308 | A5 | LOT_QTY | 하네스·환경 | A5 도구 오류 — 실측[T-017a362f]: LOT_QTY: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 2 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0309 | A5 | Measure 활성그리드 (#4·5 MSG00007) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 Measure 활성그리드 (#4·5 MSG00007) 'fps null / spdDetail' 의 A5 12요소: PASS:7 · ERROR:4 · NA:1 |  | 1 (Measure 활성그리드 (#4·5 MSG00007)) |
| WK-SSP0015-0310 | A5 | PROD_DATE / Production Date | 하네스·환경 | A5 도구 오류 — 실측[T-8065685d]: PROD_DATE: [측정 경로 없음] AS-IS 시트 SCS Stock Detail 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 2 (ACT:SSP0015_ShipmentPSI.FindData_Main:27) |
| WK-SSP0015-0311 | A5 | SSP0015_ShipmentPSI.CreateSpread | 하네스·환경 | A5 도구 오류 — 실측[T-2573133e]: AS-IS 기본 표시 컬럼 3 ⊆ TO-BE 그리드 52: 누락 ATTRIBUTE10, attribute3, attribute6 (AS-IS 숨김·코드추가 helper 컬럼은 비교 제외 |  | 56 (ACT:SSP0015_ShipmentPSI.CreateSpread:656) |
| WK-SSP0015-0312 | A5 | SSP0015_ShipmentPSI.SetSpreadColumn | 하네스·환경 | A5 도구 오류 — 실측[T-dff28a3f]: AS-IS 기본 표시 컬럼 3 ⊆ TO-BE 그리드 52: 누락 ATTRIBUTE10, attribute3, attribute6 (AS-IS 숨김·코드추가 helper 컬럼은 비교 제외 |  | 1 (ACT:SSP0015_ShipmentPSI.SetSpreadColumn:) |
| WK-SSP0015-0313 | A5 | USER_MOD_RELEASE_DATE / User Modified Re | 하네스·환경 | A5 도구 오류 — 실측[T-4bdd35a4]: USER_MOD_RELEASE_DATE: [측정 경로 없음] AS-IS 시트 MES Stock Detail/Stock Detail 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여 |  | 1 (color) |
| WK-SSP0015-0314 | A5 | other | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 other '55' 의 A5 12요소: PASS:7 · ERROR:4 · NA:1 |  | 1 (other) |
| WK-SSP0015-0315 | A5 | 읽기전용 sheet (#3 MSG00109) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 읽기전용 sheet (#3 MSG00109) 'Edit 거부 8종' 의 A5 12요소: PASS:7 · ERROR:4 · NA:1 |  | 1 (읽기전용 sheet (#3 MSG00109)) |
| WK-SSP0015-0316 | H10 | SSP0015 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 8 (Measure 활성그리드 (#4·5 MSG00007) master 음수 ) |
| WK-SSP0015-0317 | H2 | CHANGE_REASON_CODE | 하네스·환경 | H2 도구 오류 — 원장 V-88a11d08 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0318 | H2 | CHANGE_REASON_CODE | 하네스·환경 | H2 도구 오류 — 원장 V-b14dd99c |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0319 | H2 | ERP_SO_NO | 하네스·환경 | H2 도구 오류 — 원장 V-541df8b4 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0320 | H2 | ERP_SO_NO / SO No | 하네스·환경 | H2 도구 오류 — 원장 V-3e22494f COLUMN / 원장 V-b345b780 COLUMN / 원장 V-541df8b4 ASIS / 실측[T-1754297e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 —  |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0321 | H2 | FindButton | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 FindButton '실동작(활성시트 0/1 분기)' 의 H2 51요소: ERROR:49 · NA:2 |  | 1 (FindButton) |
| WK-SSP0015-0322 | H2 | HOLD_QTY / Hold Qty | 하네스·환경 | H2 도구 오류 — 원장 V-8d11c44a COLUMN / 원장 V-f899e4dc COLUMN / 원장 V-b7d9e1c3 COLUMN / 원장 V-a21aa50e COLUMN / 실측[T-c0c0782e]: [측정 경로 없음]  |  | 3 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0323 | H2 | LOT_QTY | 하네스·환경 | H2 도구 오류 — 실측[T-db064e21]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0324 | H2 | MEASURE / Measure | 하네스·환경 | H2 도구 오류 — 원장 V-f2bb502f COLUMN / 원장 V-64a74880 COLUMN / 원장 V-b661b840 ASIS / 실측[T-ac97dffe]: MEASURE: 그리드 미표시 — AS-IS Division 전부 |  | 6 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0325 | H2 | Measure 활성그리드 (#4·5 MSG00007) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 Measure 활성그리드 (#4·5 MSG00007) 'fps null / spdDetail' 의 H2 51요소: ERROR:49 · NA:2 |  | 1 (Measure 활성그리드 (#4·5 MSG00007)) |
| WK-SSP0015-0326 | H2 | PSI_NAME / PSI | 하네스·환경 | H2 도구 오류 — 원장 V-e5a65afa COLUMN / 원장 V-ef8d4a56 COLUMN / 원장 V-785d3415 COLUMN / 실측[T-a2faaf85]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음  |  | 3 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0327 | H2 | REMARKS / Remarks | 하네스·환경 | H2 도구 오류 — 원장 V-829d23ba COLUMN / 원장 V-f5e63830 COLUMN / 원장 V-da02b1d1 COLUMN / 원장 V-8e51187e COLUMN / 원장 V-c2c0efa5 COLUMN / 원장 V |  | 2 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0328 | H2 | REMARKS2 / Building | 하네스·환경 | H2 도구 오류 — 원장 V-e5126be8 COLUMN / 원장 V-63ed5bce ASIS / 원장 V-d145f1be ASIS / 실측[T-443a016d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS |  | 2 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0329 | H2 | SHIPMENT_CONFIRM_QTY | 하네스·환경 | H2 도구 오류 — 원장 V-7031d131 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0330 | H2 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | H2 도구 오류 — 원장 V-0d99c132 COLUMN / 원장 V-7031d131 ASIS / 원장 V-5ece886f ASIS / 원장 V-fd85ce75 ASIS / 원장 V-88a11d08 ASIS / 원장 V-b14dd99 |  | 2 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0331 | H2 | SHIPMENT_DATE | 하네스·환경 | H2 도구 오류 — 원장 V-caf789ed |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0332 | H2 | SHIPMENT_DATE | 하네스·환경 | H2 도구 오류 — 원장 V-7eb5d76b |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0333 | H2 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | H2 도구 오류 — 원장 V-5e3dcd2a COLUMN / 원장 V-caf789ed ASIS / 원장 V-5ece886f ASIS / 원장 V-fd85ce75 ASIS / 원장 V-7eb5d76b ASIS / 원장 V-88a11d0 |  | 3 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0334 | H2 | SSP0015_ShipmentPSI.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.CreateSpread 의 H2 51요소: ERROR:49 · NA:2 |  | 56 (ACT:SSP0015_ShipmentPSI.CreateSpread:656) |
| WK-SSP0015-0335 | H2 | SSP0015_ShipmentPSI.SetSpreadColumn | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SetSpreadColumn 의 H2 1요소: ERROR:1 |  | 1 (ACT:SSP0015_ShipmentPSI.SetSpreadColumn:) |
| WK-SSP0015-0336 | H2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | H2 도구 오류 — 원장 V-f4fb5d01 COLUMN / 원장 V-09f8a100 COLUMN / 원장 V-b20904be ASIS / 원장 V-7031d131 ASIS / 원장 V-caf789ed ASIS / 원장 V-5ece8 |  | 2 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0337 | H2 | TYPE / Status | 하네스·환경 | H2 도구 오류 — 원장 V-5b9e9561 COLUMN / 원장 V-a827f879 COLUMN / 원장 V-477ccac7 COLUMN / 원장 V-6690dd7c COLUMN / 실측[T-0d4cf817]: [측정 경로 없음]  |  | 5 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0338 | H2 | USER_MOD_RELEASE_DATE / User Modified Re | 하네스·환경 | H2 도구 오류 — 원장 V-733153ac COLUMN / 원장 V-38d72318 COLUMN / 실측[T-04500e1d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(Inser |  | 1 (color) |
| WK-SSP0015-0339 | H2 | other | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 other '55' 의 H2 51요소: ERROR:49 · NA:2 |  | 1 (other) |
| WK-SSP0015-0340 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-a2d161f0 |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0341 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-7bf58597 |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0342 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-09559814 |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0343 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-98667afe |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0344 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-2efa5d91 |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0345 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-f1b1cc3d |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0346 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-63ed5bce |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0347 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-d145f1be |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0348 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-5582b75f |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0349 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-f43ee2f7 |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0350 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-c1a0509e |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0351 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-526a28d7 |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0352 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-efc9b79a |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0353 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-a5f3abb8 |  | 1 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0354 | H2 | siDetail.ActiveSheet.Cells[iRow, siDetai | 하네스·환경 | H2 도구 오류 — 원장 V-b20904be |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0355 | H2 | siDetail.ActiveSheet.Cells[iRow, siDetai | 하네스·환경 | H2 도구 오류 — 원장 V-5ece886f |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0356 | H2 | siDetail.ActiveSheet.Cells[iRow, siDetai | 하네스·환경 | H2 도구 오류 — 원장 V-fd85ce75 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0357 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-5ccc6ff3 |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_BolckSt) |
| WK-SSP0015-0358 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-8b1d83e9 |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_Detail:) |
| WK-SSP0015-0359 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-0904358b |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_Detail:) |
| WK-SSP0015-0360 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-e3e716bd |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_Detail_) |
| WK-SSP0015-0361 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-54a5d38d |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_MesStoc) |
| WK-SSP0015-0362 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-67959328 |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0363 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-81043db8 |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0364 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-ecb5da2b |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_block_s) |
| WK-SSP0015-0365 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-7755240f |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_mes_sto) |
| WK-SSP0015-0366 | H2 | siMain.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-d901c4f4 |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Main:53) |
| WK-SSP0015-0367 | H2 | siMain.SetBGColor2 | 하네스·환경 | H2 도구 오류 — 원장 V-9fa723b2 |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1812:) |
| WK-SSP0015-0368 | H2 | siMain.SetBGColor2 | 하네스·환경 | H2 도구 오류 — 원장 V-cc90640e |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1849:) |
| WK-SSP0015-0369 | H2 | siMain.SetBGColor2 | 하네스·환경 | H2 도구 오류 — 원장 V-6e96fced |  | 1 (ACT:SSP0015_ShipmentPSI.Re_Design:2865:2) |
| WK-SSP0015-0370 | H2 | spdMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-b661b840 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellClic) |
| WK-SSP0015-0371 | H2 | 읽기전용 sheet (#3 MSG00109) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 읽기전용 sheet (#3 MSG00109) 'Edit 거부 8종' 의 H2 51요소: ERROR:49 · NA:2 |  | 1 (읽기전용 sheet (#3 MSG00109)) |
| WK-SSP0015-0372 | H4 | SSP0015 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-4aff13d8 RULE_SCREEN / 원장 V-51b78e0c RULE_SCREEN / 원장 V-2c84600e RULE_SCREEN / 원장 V-28f4fbfa RULE_SCREEN / 원장 V-e1 |  | 7 (ACT:SSP0015_ShipmentPSI.SpdDetail_TopCha) |
| WK-SSP0015-0373 | H5 | FindButton | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 FindButton '실동작(활성시트 0/1 분기)' 의 H5 12요소: ERROR:4 · PASS:4 · NA:3 · NOT_RUN:1 |  | 1 (FindButton) |
| WK-SSP0015-0374 | H5 | HOLD_QTY / Hold Qty | 하네스·환경 | H5 도구 오류 — 실측[T-1b25f004]: HOLD_QTY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0375 | H5 | LOT_QTY | 하네스·환경 | H5 도구 오류 — 실측[T-c9e0b7d7]: LOT_QTY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0376 | H5 | Measure 활성그리드 (#4·5 MSG00007) | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 Measure 활성그리드 (#4·5 MSG00007) 'fps null / spdDetail' 의 H5 12요소: ERROR:4 · PASS:4 · NA:3 · NOT_RUN:1 |  | 1 (Measure 활성그리드 (#4·5 MSG00007)) |
| WK-SSP0015-0377 | H5 | PROD_DATE / Production Date | 하네스·환경 | H5 도구 오류 — 실측[T-35d9daa8]: PROD_DATE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0015_ShipmentPSI.FindData_Main:27) |
| WK-SSP0015-0378 | H5 | SSP0015_ShipmentPSI.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.CreateSpread 의 H5 12요소: ERROR:4 · PASS:4 · NA:3 · NOT_RUN:1 |  | 56 (ACT:SSP0015_ShipmentPSI.CreateSpread:656) |
| WK-SSP0015-0379 | H5 | SSP0015_ShipmentPSI.SetSpreadColumn | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SetSpreadColumn 의 H5 3요소: NA:1 · PASS:1 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0015_ShipmentPSI.SetSpreadColumn:) |
| WK-SSP0015-0380 | H5 | USER_MOD_RELEASE_DATE / User Modified Re | 하네스·환경 | H5 도구 오류 — 실측[T-47e9028b]: USER_MOD_RELEASE_DATE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (color) |
| WK-SSP0015-0381 | H5 | other | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 other '55' 의 H5 12요소: ERROR:4 · PASS:4 · NA:3 · NOT_RUN:1 |  | 1 (other) |
| WK-SSP0015-0382 | H5 | 읽기전용 sheet (#3 MSG00109) | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 읽기전용 sheet (#3 MSG00109) 'Edit 거부 8종' 의 H5 12요소: ERROR:4 · PASS:4 · NA:3 · NOT_RUN:1 |  | 1 (읽기전용 sheet (#3 MSG00109)) |
| WK-SSP0015-0383 | I1 | SSP0015 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-9e43aac8 RULE_SCREEN / 원장 V-f5eda9cf RULE_SCREEN / 원장 V-cb13b3b1 RULE_SCREEN / 원장 V-ebfebbf5 DEFECT / 원장 V-6a9c0d0 |  | 70 (Measure 활성그리드 (#4·5 MSG00007) master 음수 ) |
| WK-SSP0015-0384 | D1 | AVAILABLE_YN / Available stock YN | 하네스·환경 | D1 도구 오류 — 원장 V-f2002e7a COLUMN / 원장 V-009e05a5 COLUMN / 원장 V-efb1ffb1 COLUMN / 원장 V-63dfd264 COLUMN / 실측[T-533afbd6]: 기존행 r0 AVAI |  | 4 (ACT:SSP0015_ShipmentPSI.EditButton:1948:) |
| WK-SSP0015-0385 | D1 | DIVISION_ID / Div | 하네스·환경 | D1 도구 오류 — 원장 V-af128757 COLUMN / 원장 V-d5827d51 COLUMN / 원장 V-da748ae5 COLUMN / 원장 V-231bcbea COLUMN / 원장 V-eb4e4a34 COLUMN / 원장 V |  | 11 (ACT:SSP0015_ShipmentPSI.EditButton:1910:) |
| WK-SSP0015-0386 | D1 | EditButton | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 EditButton '모드토글' 의 D1 39요소: ERROR:20 · NA:19 |  | 1 (EditButton) |
| WK-SSP0015-0387 | D1 | FCST_TYPE / FCST Type | 하네스·환경 | D1 도구 오류 — 원장 V-786a97c6 COLUMN / 원장 V-fa76552f COLUMN / 원장 V-5c6cfd41 COLUMN / 원장 V-e21ebac7 COLUMN / 실측[T-5a6d4cea]: 기존행 r0 FCST |  | 5 (ACT:SSP0015_ShipmentPSI.EditButton:1913:) |
| WK-SSP0015-0388 | D1 | FCS_HOLD_YN / FCS Hold YN | 하네스·환경 | D1 도구 오류 — 원장 V-754bb1c1 COLUMN / 원장 V-8f3a0ca2 COLUMN / 원장 V-975ae86e COLUMN / 원장 V-cb579635 COLUMN / 실측[T-536acba6]: 기존행 r0 FCS_ |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1963:) |
| WK-SSP0015-0389 | D1 | HOLD_YYYYMMDD / Start Date | 하네스·환경 | D1 도구 오류 — 원장 V-2e9d4358 COLUMN / 원장 V-909bbdf5 COLUMN / 원장 V-168cfda0 COLUMN / 원장 V-d53cd9e5 COLUMN / 실측[T-26aca5e8]: 기존행 r0 HOLD |  | 1 (ACT:SSP0015_ShipmentPSI.InsertRow:7710:1) |
| WK-SSP0015-0390 | D1 | INCOTERMS / Incoterms | 하네스·환경 | D1 도구 오류 — 원장 V-bd731c5a COLUMN / 원장 V-0c748304 COLUMN / 원장 V-c2668c67 COLUMN / 원장 V-e9a01548 COLUMN / 원장 V-f7c9de41 COLUMN / 원장 V |  | 4 (ACT:SSP0015_ShipmentPSI.EditButton:1916:) |
| WK-SSP0015-0391 | D1 | JUDG_VLD_DATE / Judge Vaild Date | 하네스·환경 | D1 도구 오류 — 원장 V-4d7c90a1 COLUMN / 원장 V-835eddee COLUMN / 원장 V-523a92d9 COLUMN / 원장 V-b3eaf591 COLUMN / 실측[T-e4d5c4a3]: 기존행 r0 JUDG |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1964:) |
| WK-SSP0015-0392 | D1 | LAST_UPDATED_BY / Last Updated By | 하네스·환경 | D1 도구 오류 — 원장 V-d95b80a7 COLUMN / 원장 V-c8a8fdcf COLUMN / 원장 V-f727165f COLUMN / 원장 V-cdb76573 COLUMN / 원장 V-f497494f COLUMN / 원장 V |  | 1 (ACT:SSP0015_ShipmentPSI.InsertRow:7711:1) |
| WK-SSP0015-0393 | D1 | LAST_UPDATE_DATE / Last Updated Date | 하네스·환경 | D1 도구 오류 — 원장 V-c3cad968 COLUMN / 원장 V-5fa63ec8 COLUMN / 원장 V-bdede275 COLUMN / 원장 V-3fb52589 COLUMN / 원장 V-22364cc6 COLUMN / 원장 V |  | 4 (ACT:SSP0015_ShipmentPSI.EditButton:1956:) |
| WK-SSP0015-0394 | D1 | MEASURE / Measure | 하네스·환경 | D1 도구 오류 — 원장 V-b60bac34 COLUMN / 원장 V-6a3ed7f5 COLUMN / 원장 V-f80ce3d0 COLUMN / 원장 V-7321c737 COLUMN / 실측[T-2ed0b4aa]: 기존행 r0 MEAS |  | 6 (ACT:SSP0015_ShipmentPSI.EditButton ACT:S) |
| WK-SSP0015-0395 | D1 | MES_CHANGE_STATUS / Change Status | 하네스·환경 | D1 도구 오류 — 원장 V-2f962f36 COLUMN / 원장 V-d89d9552 COLUMN / 원장 V-ef60d922 COLUMN / 원장 V-33761028 COLUMN / 실측[T-f8994f7c]: MES_CHANGE_ |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1951:) |
| WK-SSP0015-0396 | D1 | QMS_HOLD_RELEASE / QMS Unhold Sched Date | 하네스·환경 | D1 도구 오류 — 원장 V-c06e6087 COLUMN / 원장 V-c6309bbc COLUMN / 원장 V-c4f41f3c COLUMN / 원장 V-60c33d76 COLUMN / 실측[T-3eb8252e]: QMS_HOLD_RE |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1943:) |
| WK-SSP0015-0397 | D1 | REMARKS3 / Customer Requirement | 하네스·환경 | D1 도구 오류 — 원장 V-4ec30688 COLUMN / 원장 V-140735c9 COLUMN / 실측[T-a6a14c1e]: 기존행 r0 REMARKS3: 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1934:) |
| WK-SSP0015-0398 | D1 | REQUESTOR / Shipment Requestor | 하네스·환경 | D1 도구 오류 — 원장 V-a8b9a4b7 COLUMN / 원장 V-05e92bca COLUMN / 실측[T-85e49af5]: 기존행 r0 REQUESTOR: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0015_ShipmentPSI.EditButton:1922:) |
| WK-SSP0015-0399 | D1 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | D1 도구 오류 — 원장 V-31a6cfde COLUMN / 원장 V-6886d5e9 COLUMN / 실측[T-fa60e3c3]: 기존행 r0 SHIPMENT_CONFIRM_QTY: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0015_ShipmentPSI.EditButton:1932:) |
| WK-SSP0015-0400 | D1 | SHIPMENT_STATUS / Status | 하네스·환경 | D1 도구 오류 — 원장 V-02c93dd9 COLUMN / 원장 V-27455569 COLUMN / 실측[T-65dbc0eb]: 기존행 r0 SHIPMENT_STATUS: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0015_ShipmentPSI.EditButton:1927:) |
| WK-SSP0015-0401 | D1 | SHIP_FROZEN / ship_frozen | 하네스·환경 | D1 도구 오류 — 실측[T-2930c7f8]: SHIP_FROZEN AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0015_ShipmentPSI.EditButton ACT:S) |
| WK-SSP0015-0402 | D1 | SSP0015_ShipmentPSI.EditButton | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.EditButton 의 D1 17요소: ERROR:16 · NA:1 |  | 53 (ACT:SSP0015_ShipmentPSI.EditButton:1737:) |
| WK-SSP0015-0403 | D1 | TO_SITE_SHIPTO_CODE / Ship to | 하네스·환경 | D1 도구 오류 — 원장 V-7964600b COLUMN / 원장 V-205e3696 COLUMN / 실측[T-9f4abf3b]: 기존행 r0 TO_SITE_SHIPTO_CODE: 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1921:) |
| WK-SSP0015-0404 | D1 | TO_SITE_SOLDTO_CODE / Sold to | 하네스·환경 | D1 도구 오류 — 원장 V-3e112572 COLUMN / 원장 V-c99b9350 COLUMN / 실측[T-601a2bd2]: 기존행 r0 TO_SITE_SOLDTO_CODE: 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (ACT:SSP0015_ShipmentPSI.InsertRow:7861:1) |
| WK-SSP0015-0405 | D1 | USER_MOD_RELEASE_DATE / User Modified Re | 하네스·환경 | D1 도구 오류 — 원장 V-c14fd15b COLUMN / 원장 V-9d9c21c9 COLUMN / 원장 V-496a5718 COLUMN / 원장 V-2c2cc5c7 COLUMN / 실측[T-999f6b04]: USER_MOD_RE |  | 1 (color) |
| WK-SSP0015-0406 | D1 | lock | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 lock '43' 의 D1 39요소: ERROR:20 · NA:19 |  | 1 (lock) |
| WK-SSP0015-0407 | D1 | 읽기전용 sheet (#3 MSG00109) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 읽기전용 sheet (#3 MSG00109) 'Edit 거부 8종' 의 D1 39요소: ERROR:20 · NA:19 |  | 1 (읽기전용 sheet (#3 MSG00109)) |
| WK-SSP0015-0408 | D3 | AVAILABLE_YN / Available stock YN | 하네스·환경 | D3 도구 오류 — 원장 V-4a84c14f ASIS / 원장 V-d9d6ad79 ASIS / 실측[T-580c1387]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sMesCha |  | 4 (ACT:SSP0015_ShipmentPSI.EditButton:1948:) |
| WK-SSP0015-0409 | D3 | AVAILABLE_YN,FCS_HOLD_YN | 하네스·환경 | D3 도구 오류 — 원장 V-d9d6ad79 / 실측[T-ce992555]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sMesChangeStatus == "D" // sAvail |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1963:) |
| WK-SSP0015-0410 | D3 | DIVISION_ID / Div | 하네스·환경 | D3 도구 오류 — 원장 V-ae04d335 ASIS / 원장 V-031b3173 ASIS / 원장 V-475382de ASIS / 원장 V-4a84c14f ASIS / 원장 V-d005f7b6 ASIS / 원장 V-e2cd0a36  |  | 11 (ACT:SSP0015_ShipmentPSI.EditButton:1910:) |
| WK-SSP0015-0411 | D3 | DIVISION_ID,AVAILABLE_YN | 하네스·환경 | D3 도구 오류 — 원장 V-4a84c14f / 실측[T-78aba7ef]: r0  → DIVISION_ID 편집=false (AS-IS 잠금 EditButton:1788) OK · r1  → DIVISION_ID 편집=false ( |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1962:) |
| WK-SSP0015-0412 | D3 | DIVISION_ID,FCST_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-031b3173 / 실측[T-bf7a2613]: r0  → DIVISION_ID 편집=false (AS-IS 잠금 EditButton:1788) OK · r1  → DIVISION_ID 편집=false ( |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1920:) |
| WK-SSP0015-0413 | D3 | DIVISION_ID,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-475382de / 실측[T-a1792cfa]: r0  → DIVISION_ID 편집=false (AS-IS 잠금 EditButton:1788) OK · r1  → DIVISION_ID 편집=false ( |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1958:) |
| WK-SSP0015-0414 | D3 | EditButton | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 EditButton '모드토글' 의 D3 45요소: ERROR:26 · PASS:14 · NA:5 |  | 1 (EditButton) |
| WK-SSP0015-0415 | D3 | FCST_TYPE / FCST Type | 하네스·환경 | D3 도구 오류 — 원장 V-ae04d335 ASIS / 원장 V-031b3173 ASIS / 원장 V-e2cd0a36 ASIS / 실측[T-bd6d26dd]: r0 FCST_TYPE 그리드에 없음 · r1 FCST_TYPE 그리드에 |  | 5 (ACT:SSP0015_ShipmentPSI.EditButton:1913:) |
| WK-SSP0015-0416 | D3 | FCS_HOLD_YN / FCS Hold YN | 하네스·환경 | D3 도구 오류 — 원장 V-d9d6ad79 ASIS / 실측[T-1696838c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sMesChangeStatus == "D" // s |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1963:) |
| WK-SSP0015-0417 | D3 | INCOTERMS | 하네스·환경 | D3 도구 오류 — 원장 V-d07f4913 / 실측[T-dc27b5db]: r0 INCOTERMS 그리드에 없음 · r1 INCOTERMS 그리드에 없음 · 계산 불가 절(판정 제외): else of (sStatus == Shipm |  | 1 (ACT:SSP0015_ShipmentPSI.InsertRow:7861:1) |
| WK-SSP0015-0418 | D3 | INCOTERMS / Incoterms | 하네스·환경 | D3 도구 오류 — 원장 V-b7af477b ASIS / 원장 V-ce510883 ASIS / 원장 V-764fcb89 ASIS / 원장 V-d07f4913 ASIS / 실측[T-091072d1]: r0 INCOTERMS 그리드에 없 |  | 4 (ACT:SSP0015_ShipmentPSI.EditButton:1916:) |
| WK-SSP0015-0419 | D3 | INCOTERMS,TO_SITE_SHIPTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-ce510883 / 실측[T-d0cfe542]: r0 INCOTERMS 그리드에 없음 · r1 INCOTERMS 그리드에 없음 · 계산 불가 절(판정 제외): else of (sStatus == Shipm |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1921:) |
| WK-SSP0015-0420 | D3 | JUDG_VLD_DATE / Judge Vaild Date | 하네스·환경 | D3 도구 오류 — 원장 V-b48af79f ASIS / 실측[T-6f13c296]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sMesChangeStatus == "D" // s |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1964:) |
| WK-SSP0015-0421 | D3 | JUDG_VLD_DATE,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-b48af79f / 실측[T-317ad6a5]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sMesChangeStatus == "D" // sAvail |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1964:) |
| WK-SSP0015-0422 | D3 | LAST_UPDATE_DATE / Last Updated Date | 하네스·환경 | D3 도구 오류 — 원장 V-475382de ASIS / 원장 V-b48af79f ASIS / 원장 V-42cc5a70 ASIS / 실측[T-01fd6f85]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미 |  | 4 (ACT:SSP0015_ShipmentPSI.EditButton:1956:) |
| WK-SSP0015-0423 | D3 | MEASURE / Measure | 하네스·환경 | D3 도구 오류 — 원장 V-9a0d49c7 ASIS / 실측[T-ec67ad88]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (fps.ActiveSheet.Columns.Get(xCol1 |  | 6 (ACT:SSP0015_ShipmentPSI.EditButton ACT:S) |
| WK-SSP0015-0424 | D3 | REMARKS3 / Customer Requirement | 하네스·환경 | D3 도구 오류 — 원장 V-a6dd2048 ASIS |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1934:) |
| WK-SSP0015-0425 | D3 | REQUESTOR | 하네스·환경 | D3 도구 오류 — 원장 V-0846911c / 실측[T-ea3a3688]: r0 REQUESTOR 그리드에 없음 · r1 REQUESTOR 그리드에 없음 · 계산 불가 절(판정 제외): else of (sStatus == Shipm |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1922:) |
| WK-SSP0015-0426 | D3 | REQUESTOR | 하네스·환경 | D3 도구 오류 — 원장 V-1b0d223a / 실측[T-d59115dc]: r0 REQUESTOR 그리드에 없음 · r1 REQUESTOR 그리드에 없음 · 계산 불가 절(판정 제외): else of (sStatus == Shipm |  | 1 (ACT:SSP0015_ShipmentPSI.InsertRow:7862:1) |
| WK-SSP0015-0427 | D3 | REQUESTOR / Shipment Requestor | 하네스·환경 | D3 도구 오류 — 원장 V-0846911c ASIS / 원장 V-1b0d223a ASIS / 실측[T-c340fe8c]: r0 REQUESTOR 그리드에 없음 · r1 REQUESTOR 그리드에 없음 · 계산 불가 절(판정 제외): |  | 2 (ACT:SSP0015_ShipmentPSI.EditButton:1922:) |
| WK-SSP0015-0428 | D3 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | D3 도구 오류 — 원장 V-a6dd2048 ASIS |  | 2 (ACT:SSP0015_ShipmentPSI.EditButton:1932:) |
| WK-SSP0015-0429 | D3 | SHIPMENT_CONFIRM_QTY,REMARKS3 | 하네스·환경 | D3 도구 오류 — 원장 V-a6dd2048 / 실측[T-aaccff86]: r0 SHIPMENT_CONFIRM_QTY 그리드에 없음 · r1 SHIPMENT_CONFIRM_QTY 그리드에 없음 · 계산 불가 절(판정 제외): if  |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1934:) |
| WK-SSP0015-0430 | D3 | SSP0015_ShipmentPSI.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-cda3db42 ASIS / 원장 V-9a0d49c7 ASIS / 원장 V-862a03db ASIS / 원장 V-ae04d335 ASIS / 원장 V-b7af477b ASIS / 원장 V-031b3173  |  | 53 (ACT:SSP0015_ShipmentPSI.EditButton:1737:) |
| WK-SSP0015-0431 | D3 | TO_SITE_SHIPTO_CODE / Ship to | 하네스·환경 | D3 도구 오류 — 원장 V-ce510883 ASIS / 실측[T-0213b18a]: r0 TO_SITE_SHIPTO_CODE 그리드에 없음 · r1 TO_SITE_SHIPTO_CODE 그리드에 없음 · 계산 불가 절(판정 제외):  |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1921:) |
| WK-SSP0015-0432 | D3 | lock | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 lock '43' 의 D3 45요소: ERROR:26 · PASS:14 · NA:5 |  | 1 (lock) |
| WK-SSP0015-0433 | D3 | siDetail.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-6b41aa77 / 실측[T-0b4e1262]: siDetail.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_BolckSt) |
| WK-SSP0015-0434 | D3 | siDetail.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-43ce4f66 / 실측[T-4913be78]: siDetail.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_WHstock) |
| WK-SSP0015-0435 | D3 | siDetail.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-e1662531 / 실측[T-5d2b8298]: siDetail.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SSP0015_ShipmentPSI.FindData_block_s) |
| WK-SSP0015-0436 | D3 | siDetail.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-d48aa15e / 실측[T-163938ee]: siDetail.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SSP0015_ShipmentPSI.EditButton:1938:) |
| WK-SSP0015-0437 | D3 | 읽기전용 sheet (#3 MSG00109) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 읽기전용 sheet (#3 MSG00109) 'Edit 거부 8종' 의 D3 45요소: ERROR:26 · PASS:14 · NA:5 |  | 1 (읽기전용 sheet (#3 MSG00109)) |
| WK-SSP0015-0438 | D5 | MEASURE / Measure | 하네스·환경 | D5 도구 오류 — 원장 V-bcdabbf1 COLUMN / 원장 V-312394dc COLUMN / 실측[T-f894974f]: MEASURE: AS-IS COMBO(cell_rules) ↔ TO-BE dataType=1 dataM |  | 5 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0439 | D5 | SSP0015_ShipmentPSI.CreateSpread | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.CreateSpread 의 D5 8요소: NA:5 · PASS:2 · ERROR:1 |  | 56 (ACT:SSP0015_ShipmentPSI.CreateSpread:656) |
| WK-SSP0015-0440 | D5 | SSP0015_ShipmentPSI.SetSpreadColumn | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 SSP0015_ShipmentPSI.SetSpreadColumn 의 D5 1요소: ERROR:1 |  | 1 (ACT:SSP0015_ShipmentPSI.SetSpreadColumn:) |
| WK-SSP0015-0441 | D6 | SSP0015 화면 | 하네스·환경 | D6 도구 오류 — 원장 V-bda29de0 RULE_SCREEN / 원장 V-79e8ff24 RULE_SCREEN / 원장 V-7a232919 RULE_SCREEN / 원장 V-ea5efece GENERAL / 원장 V-9ffa25 |  | 4 (InsertButton other ACT:SSP0015_ShipmentP) |
| WK-SSP0015-0442 | E1 | DIVISION_ID / Div | 하네스·환경 | E1 도구 오류 — 실측[T-7b0a135d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0443 | E1 | ERP_SO_NO / SO No | 하네스·환경 | E1 도구 오류 — 실측[T-457be6e5]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 13 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0444 | E1 | ETA | 하네스·환경 | E1 도구 오류 — 실측[T-90c0dd11]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (value) |
| WK-SSP0015-0445 | E1 | INCOTERMS / Incoterms | 하네스·환경 | E1 도구 오류 — 실측[T-74a50c47]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0446 | E1 | REMARKS / Remarks | 하네스·환경 | E1 도구 오류 — 실측[T-6808cb69]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0447 | E1 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | E1 도구 오류 — 원장 V-98e96940 COLUMN / 실측[T-e2fc5dd9]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetai |  | 5 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0448 | E1 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | E1 도구 오류 — 실측[T-626f7702]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 10 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0449 | E1 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | E1 도구 오류 — 실측[T-8307112a]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:7694 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0450 | E3 | DataUtil.checkRequiredOfSpread | 하네스·환경 | E3 도구 오류 — 원장 V-93b6ecff |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Detail:) |
| WK-SSP0015-0451 | E3 | DataUtil.checkRequiredOfSpread | 하네스·환경 | E3 도구 오류 — 원장 V-3f2f7a34 |  | 2 (ACT:SSP0015_ShipmentPSI.SaveData_Detail:) |
| WK-SSP0015-0452 | E3 | DataUtil.checkRequiredOfSpread | 하네스·환경 | E3 도구 오류 — 원장 V-ebc49c05 |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Detail_) |
| WK-SSP0015-0453 | E3 | Detail 확인창 (#13·17·52 MSG00324) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 Detail 확인창 (#13·17·52 MSG00324) 'GMessageBox' 의 E3 8요소: NA:4 · ERROR:3 · PASS:1 |  | 1 (Detail 확인창 (#13·17·52 MSG00324)) |
| WK-SSP0015-0454 | E3 | ERP 연쇄 (#27~39·44·50~56) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 ERP 연쇄 (#27~39·44·50~56) 'GetERPInterface RtFlag E/F/C_E, remainMinute, SO_N' 의 E3 8요소: NA:4 · ERROR:3 · PAS |  | 1 (ERP 연쇄 (#27~39·44·50~56)) |
| WK-SSP0015-0455 | E3 | Measure 활성그리드 (#4·5 MSG00007) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 Measure 활성그리드 (#4·5 MSG00007) 'fps null / spdDetail' 의 E3 8요소: NA:4 · ERROR:3 · PASS:1 |  | 1 (Measure 활성그리드 (#4·5 MSG00007)) |
| WK-SSP0015-0456 | E3 | master 음수 (#6 MSG00084) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 master 음수 (#6 MSG00084) 'nDayQty<0' 의 E3 8요소: NA:4 · ERROR:3 · PASS:1 |  | 1 (master 음수 (#6 MSG00084)) |
| WK-SSP0015-0457 | E3 | 변경사유 (#26·46 MSG00286/287) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 변경사유 (#26·46 MSG00286/287) "reason '-'/공백" 의 E3 8요소: NA:4 · ERROR:3 · PASS:1 |  | 1 (변경사유 (#26·46 MSG00286/287)) |
| WK-SSP0015-0458 | E3 | 변경없음 (#11·15 MSG00133) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 변경없음 (#11·15 MSG00133) 'bolChang_Flag' 의 E3 8요소: NA:4 · ERROR:3 · PASS:1 |  | 1 (변경없음 (#11·15 MSG00133)) |
| WK-SSP0015-0459 | E3 | 읽기전용 sheet (#3 MSG00109) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 읽기전용 sheet (#3 MSG00109) 'Edit 거부 8종' 의 E3 8요소: NA:4 · ERROR:3 · PASS:1 |  | 1 (읽기전용 sheet (#3 MSG00109)) |
| WK-SSP0015-0460 | E4 | DateUtil.Check_PeriodDate | 하네스·환경 | E4 도구 오류 — 원장 V-20b7234e / 실측[T-c1f21685]: DateUtil.Check_PeriodDate: 이 대상에 연결된 AS-IS 메시지 문장 없음 — 업무 검증 메시지 대상 아님 |  | 2 (ACT:SSP0015_ShipmentPSI.FindData_Main_Pa) |
| WK-SSP0015-0461 | E4 | DateUtil.Check_PeriodDate | 하네스·환경 | E4 도구 오류 — 원장 V-b20599c8 / 실측[T-59c4e13b]: DateUtil.Check_PeriodDate: 이 대상에 연결된 AS-IS 메시지 문장 없음 — 업무 검증 메시지 대상 아님 |  | 2 (ACT:SSP0015_ShipmentPSI.FindData_Main_Pa) |
| WK-SSP0015-0462 | E4 | DateUtil.Check_PeriodDate | 하네스·환경 | E4 도구 오류 — 원장 V-66cdc8de / 실측[T-5f8ac6a9]: DateUtil.Check_PeriodDate: 이 대상에 연결된 AS-IS 메시지 문장 없음 — 업무 검증 메시지 대상 아님 |  | 2 (ACT:SSP0015_ShipmentPSI.FindData_Request) |
| WK-SSP0015-0463 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-e0f0c4a0 ASIS / 원장 V-4e89d52b ASIS / 실측[T-7673b395]: MSG00007 — btnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 |  | 3 (Measure 활성그리드 (#4·5 MSG00007) ACT:SSP001) |
| WK-SSP0015-0464 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-e0f0c4a0 / 실측[T-58e4a8db]: MSG00007 — btnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnMeasu |  | 1 (ACT:SSP0015_ShipmentPSI.btnMeasure_Click) |
| WK-SSP0015-0465 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-4e89d52b / 실측[T-47dd4283]: MSG00007 — btnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnMeasu |  | 1 (ACT:SSP0015_ShipmentPSI.btnMeasure_Click) |
| WK-SSP0015-0466 | E4 | MSG00047 | 하네스·환경 | E4 도구 오류 — 원장 V-af322c16 / 실측[T-2a837eb3]: MSG00047 — SpdDetail_ClipboardPasted 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0467 | E4 | MSG00047 | 하네스·환경 | E4 도구 오류 — 원장 V-af322c16 ASIS / 원장 V-9593610e ASIS / 실측[T-96d974ad]: MSG00047 — SpdDetail_ClipboardPasted 경로 메시지(저장 전 검증 아님 · Save |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0468 | E4 | MSG00047 | 하네스·환경 | E4 도구 오류 — 원장 V-9593610e / 실측[T-956017cf]: MSG00047 — SpdDetail_ClipboardPasted 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0469 | E4 | MSG00050 | 하네스·환경 | E4 도구 오류 — 원장 V-4dc87319 / 실측[T-a618c81d]: MSG00050 — txtChange_Qty_TextChanged 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0015_ShipmentPSICommentsPopup.txt) |
| WK-SSP0015-0470 | E4 | MSG00050 | 하네스·환경 | E4 도구 오류 — 원장 V-4dc87319 ASIS / 실측[T-df232581]: MSG00050 — txtChange_Qty_TextChanged 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 |  | 1 (ACT:SSP0015_ShipmentPSICommentsPopup.txt) |
| WK-SSP0015-0471 | E4 | MSG00189 | 하네스·환경 | E4 도구 오류 — 원장 V-689ee7f5 ASIS / 원장 V-f1bbe4fa ASIS / 실측[T-0c91df14]: MSG00189: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guar |  | 2 (ACT:SSP0015_ShipmentPSI.GetShipmentStatu) |
| WK-SSP0015-0472 | E4 | MSG00189 | 하네스·환경 | E4 도구 오류 — 원장 V-f1bbe4fa / 실측[T-72625541]: MSG00189: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (ds.Tables[2].Rows.C |  | 1 (ACT:SSP0015_ShipmentPSI.shtDetail_Change) |
| WK-SSP0015-0473 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-a4968988 ASIS / 원장 V-7640b172 ASIS / 실측[T-8617e174]: MSG00278 — shtDetail_Change 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 |  | 3 (운송수단 필수 (#43·45 MSG00278) ACT:SSP0015_Sh) |
| WK-SSP0015-0474 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-a4968988 / 실측[T-1ffc5999]: MSG00278 — shtDetail_Change 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(shtDetai |  | 1 (ACT:SSP0015_ShipmentPSI.shtDetail_Change) |
| WK-SSP0015-0475 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-7640b172 / 실측[T-eac476e1]: MSG00278 — shtDetail_Change 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(shtDetai |  | 1 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0476 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-37250638 ASIS / 원장 V-52570783 ASIS / 원장 V-4c1ff389 ASIS / 원장 V-d9061914 ASIS / 원장 V-4e740e92 ASIS / 원장 V-171d5a49  |  | 10 (ACT:SSP0015_ShipmentPSI.NewNonSoNo:9708:) |
| WK-SSP0015-0477 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-37250638 / 실측[T-605b7da8]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSI.NonSoNo:6933:129) |
| WK-SSP0015-0478 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-52570783 / 실측[T-f82cdbe2]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Detail:) |
| WK-SSP0015-0479 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-4c1ff389 / 실측[T-9f98e684]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Detail:) |
| WK-SSP0015-0480 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-d9061914 / 실측[T-631bcea3]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Detail:) |
| WK-SSP0015-0481 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-4e740e92 / 실측[T-c8dfd804]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Detail:) |
| WK-SSP0015-0482 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-171d5a49 / 실측[T-a2dcee08]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Detail_) |
| WK-SSP0015-0483 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-f4b8f560 / 실측[T-5b1fb09a]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Main:54) |
| WK-SSP0015-0484 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-dc1e9357 / 실측[T-2611e771]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSI.SoNo:7162:144) |
| WK-SSP0015-0485 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-622aff57 / 실측[T-927247d1]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSICommentsPopup.Sav) |
| WK-SSP0015-0486 | E4 | MSG00287 | 하네스·환경 | E4 도구 오류 — 원장 V-324f6e02 / 실측[T-6b5681a8]: MSG00287 — SpdDetail_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdD |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0487 | E4 | MSG00287 | 하네스·환경 | E4 도구 오류 — 원장 V-324f6e02 ASIS / 실측[T-f4dae91c]: MSG00287 — SpdDetail_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0488 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-663ec32b ASIS / 원장 V-2b59a47f ASIS / 실측[T-f726f2a1]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — |  | 4 (Detail 확인창 (#13·17·52 MSG00324) ACT:SSP0) |
| WK-SSP0015-0489 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-663ec32b / 실측[T-a2fc874f]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Detail:) |
| WK-SSP0015-0490 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-2b59a47f / 실측[T-1ea080c5]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0015_ShipmentPSI.SaveData_Detail_) |
| WK-SSP0015-0491 | E4 | MSG00362 | 하네스·환경 | E4 도구 오류 — 원장 V-1ad498b1 / 실측[T-75263c75]: MSG00362 — shtDetail_Change 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(shtDetai |  | 1 (ACT:SSP0015_ShipmentPSI.shtDetail_Change) |
| WK-SSP0015-0492 | E4 | MSG00362 | 하네스·환경 | E4 도구 오류 — 원장 V-1ad498b1 ASIS / 실측[T-121cd195]: MSG00362 — shtDetail_Change 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(sht |  | 1 (ACT:SSP0015_ShipmentPSI.shtDetail_Change) |
| WK-SSP0015-0493 | E4 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | E4 도구 오류 — 원장 V-f065e136 ASIS / 원장 V-9593610e ASIS / 원장 V-324f6e02 ASIS / 실측[T-c01eb3f5]: MSG00049: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류  |  | 2 (ACT:SSP0015_ShipmentPSI.GetNewERPInterfa) |
| WK-SSP0015-0494 | E4 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | E4 도구 오류 — 원장 V-af322c16 ASIS / 원장 V-9593610e ASIS / 원장 V-a4968988 ASIS / 원장 V-7640b172 ASIS / 실측[T-773a08a9]: MSG00047 — SpdDetai |  | 2 (운송수단 필수 (#43·45 MSG00278) ACT:SSP0015_Sh) |
| WK-SSP0015-0495 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 하네스·환경 | A6 도구 오류 — 원장 V-c44b6191 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측 순서대조 PASS 공통 41행(Doc/golden/SSP0015/SCP0009_GET_SHEET_CALENDAR_3SPAN.order |  | 1160 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0496 | A6 | PKG_SSP0015.P_SSP0015_GET_BLOCK_STOCK | 하네스·환경 | A6 도구 오류 — 원장 V-00919c5c SP / 정렬대조 PASS AS-IS 에 없던 ORDER BY 를 TO-BE 가 추가 — 결정적 순서(TO-BE 룰  / 실측[T-598f44f5]: PKG_SSP0015.P_SSP0015 |  | 124 (ACT:SSP0015_ShipmentPSI.FindData_BolckSt) |
| WK-SSP0015-0497 | A6 | PKG_SSP0015.P_SSP0015_GET_MES_STOCK | 하네스·환경 | A6 도구 오류 — 원장 V-d584d538 SP / 정렬대조 PASS AS-IS 키 뒤에 동률 고정 키 추가 ['ITEM_ID', 'LOT_ID', 'MES_C / 실측[T-4175efd3]: PKG_SSP0015.P_SSP0015 |  | 113 (ACT:SSP0015_ShipmentPSI.FindData_MesStoc) |
| WK-SSP0015-0498 | A6 | PKG_SSP0015.P_SSP0015_GET_SCS_STOCK | 하네스·환경 | A6 도구 오류 — 원장 V-78c05ed4 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-9e9fde80]: PKG_SSP0015.P_SSP0015_GET_SCS_STOCK: 화면 진입·조회 경로에서 이 SP 가 결과를 |  | 47 (ACT:SSP0015_ShipmentPSI.FindData_ScsStoc) |
| WK-SSP0015-0499 | A6 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFI | 하네스·환경 | A6 도구 오류 — 원장 V-9703a65e SP / 원장 V-00c5bc86 SP / 정렬대조 PASS 분기 키 순서 동일 (가드 IF @p_real_flag = 'Y') / 정렬대조 PASS 분기 키 순서 동일 (가드 ELSE)  |  | 217 (ACT:SSP0015_ShipmentPSI.FindData_Detail ) |
| WK-SSP0015-0500 | A6 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFI | 하네스·환경 | A6 도구 오류 — 원장 V-4ba403cb SP / 원장 V-ba95211e SP / 정렬대조 PASS 분기 키 순서 동일 (가드 IF @p_real_flag = 'Y') / 정렬대조 PASS 분기 키 순서 동일 (가드 ELSE)  |  | 73 (ACT:SSP0015_ShipmentPSI.FindData_Detail_) |
| WK-SSP0015-0501 | A6 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_P | 하네스·환경 | A6 도구 오류 — 원장 V-617fdbb7 SP / 원장 V-2cb64429 SP / 원장 V-9a35f4a9 SP / [문장 대조는 다름 — 실측 순서 일치(공통 198행)로 판정] 정렬대조 FAIL 2번째 키부터 다름: AS-I |  | 79 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0502 | A6 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESUL | 하네스·환경 | A6 도구 오류 — 원장 V-b65724f4 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-d5a7ab2e]: PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESULT: 화면 진입·조회 경로에서 이 SP |  | 65 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0503 | A6 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESUL | 하네스·환경 | A6 도구 오류 — 원장 V-3dae9b05 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-bb6c9f90]: PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESULT_PACKER: 화면 진입·조회 경로 |  | 64 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0504 | A6 | PKG_SSP0015.P_SSP0015_GET_STOCK_LOCATION | 하네스·환경 | A6 도구 오류 — 원장 V-04d6223a SP / 원장 V-d2cc8389 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-917296bb]: PKG_SSP0015.P_SSP0015_GET_STOCK_LOCATION_D |  | 65 (ACT:SSP0015_ShipmentPSI.FindData_shtStoc) |
| WK-SSP0015-0505 | A6 | PKG_SSP0015.P_SSP0015_GET_WH_STOCK | 하네스·환경 | A6 도구 오류 — 원장 V-2368827d SP / 원장 V-f4836f1d SP / 정렬대조 PASS AS-IS 키 뒤에 동률 고정 키 추가 ['PLANT_ID', 'STORAGE_ID', ' / 실측[T-7161d4f3]: PK |  | 63 (ACT:SSP0015_ShipmentPSI.FindData_WHstock) |
| WK-SSP0015-0506 | A6 | PKG_SSP0026.P_SSP0026_GET_REQUEST_DETAIL | 하네스·환경 | A6 도구 오류 — 원장 V-dba1090d SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-01493e7d]: PKG_SSP0026.P_SSP0026_GET_REQUEST_DETAIL_PACK: 화면 진입·조회 경로에서  |  | 52 (ACT:SSP0015_ShipmentPSI.FindData_Request) |
| WK-SSP0015-0507 | A6 | SSP0002_GET_NERP_CODE | 하네스·환경 | A6 도구 오류 — 원장 V-e4a79f89 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-f55df5e1]: SSP0002_GET_NERP_CODE: 화면 진입·조회  |  | 334 (ACT:SSP0015_ShipmentPSI.FindButton ACT:S) |
| WK-SSP0015-0508 | G1 | FindButton | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindButton '실동작(활성시트 0/1 분기)' 의 G1 15요소: NA:6 · ERROR:5 · PASS:4 |  | 1 (FindButton) |
| WK-SSP0015-0509 | G1 | clbDivision / Division / Div / Div. | 하네스·환경 | G1 도구 오류 — 원장 V-6502d7fc SEARCH |  | 20 (ACT:SSP0015_ShipmentPSI.FindData_Main AC) |
| WK-SSP0015-0510 | G1 | drpPeriod / Period / From / To / 기간 | 하네스·환경 | G1 도구 오류 — 원장 V-3d0c3e60 SEARCH / 원장 V-30fc389f SEARCH / 원장 V-2c307e5b SEARCH / 원장 V-0b272b6c SEARCH |  | 17 (ACT:SSP0015_ShipmentPSI.FindData_Detail:) |
| WK-SSP0015-0511 | G1 | drpPeriod2 / Shipment Date / Period2 / P | 하네스·환경 | G1 도구 오류 — 원장 V-3d0c3e60 SEARCH / 원장 V-30fc389f SEARCH / 원장 V-2c307e5b SEARCH / 원장 V-0b272b6c SEARCH |  | 18 (ACT:SSP0015_ShipmentPSI.FindData_Detail_) |
| WK-SSP0015-0512 | G1 | drpPeriod3 / Shipment Date / Period3 / P | 하네스·환경 | G1 도구 오류 — 원장 V-3d0c3e60 SEARCH / 원장 V-30fc389f SEARCH / 원장 V-2c307e5b SEARCH / 원장 V-0b272b6c SEARCH |  | 6 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0513 | G1 | txtLotID / Lot ID | 하네스·환경 | G1 도구 오류 — 원장 V-98fafe08 SEARCH |  | 8 (ACT:SSP0015_ShipmentPSI.FindData_MesStoc) |
| WK-SSP0015-0514 | G6 | txtBefore_Qty / Result Type / Before_Qty | 하네스·환경 | G6 도구 오류 — 실측[T-4b836ce3]: 공용 팝업 내부 조건(txtBefore_Qty) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0515 | G6 | txtChange_Qty / Change Qty / Change_Qty | 하네스·환경 | G6 도구 오류 — 실측[T-11e94a4d]: 공용 팝업 내부 조건(txtChange_Qty) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0516 | G6 | txtCurrent_Qty / Shipment Date / Current | 하네스·환경 | G6 도구 오류 — 실측[T-28b8dc26]: 공용 팝업 내부 조건(txtCurrent_Qty) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0517 | G6 | txtDate / Period / Date | 하네스·환경 | G6 도구 오류 — 실측[T-de40acc0]: 공용 팝업 내부 조건(txtDate) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0518 | G6 | txtDivision_ID / Div / Division_ID | 하네스·환경 | G6 도구 오류 — 실측[T-92efd7c5]: 공용 팝업 내부 조건(txtDivision_ID) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0519 | G6 | txtFrom_Site / From_Site / From Site | 하네스·환경 | G6 도구 오류 — 실측[T-95085d6b]: 공용 팝업 내부 조건(txtFrom_Site) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0520 | G6 | txtGap_Qty / Shipment Date / Gap_Qty / P | 하네스·환경 | G6 도구 오류 — 실측[T-c1c9313d]: 공용 팝업 내부 조건(txtGap_Qty) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0521 | G6 | txtItem_ID / Item_ID | 하네스·환경 | G6 도구 오류 — 실측[T-1e9076e0]: 공용 팝업 내부 조건(txtItem_ID) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0522 | G6 | txtMeasure / Measure | 하네스·환경 | G6 도구 오류 — 실측[T-d19ea4ad]: 공용 팝업 내부 조건(txtMeasure) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0523 | G6 | txtPlan_Date / Model / Plan_Date / Plan  | 하네스·환경 | G6 도구 오류 — 실측[T-a858835f]: 공용 팝업 내부 조건(txtPlan_Date) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0524 | G6 | txtProd_Qty / Prod_Qty | 하네스·환경 | G6 도구 오류 — 실측[T-bc2c0a33]: 공용 팝업 내부 조건(txtProd_Qty) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0525 | G6 | txtWHin_Qty / From Site / WHin_Qty | 하네스·환경 | G6 도구 오류 — 실측[T-8a53e2fe]: 공용 팝업 내부 조건(txtWHin_Qty) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Ini) |
| WK-SSP0015-0526 | X-ROW | SSP0015_ShipmentPSI.BtnItemID2_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:3 · NA:3 · PASS:3 |  | 5 (ACT:SSP0015_ShipmentPSI.BtnItemID2_Click) |
| WK-SSP0015-0527 | X-ROW | SSP0015_ShipmentPSI.BtnRequestor_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — PASS:5 · ERROR:2 |  | 10 (ACT:SSP0015_ShipmentPSI.BtnRequestor_Cli) |
| WK-SSP0015-0528 | X-ROW | SSP0015_ShipmentPSI.BtnSearch_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 18 (ACT:SSP0015_ShipmentPSI.BtnSearch_Click:) |
| WK-SSP0015-0529 | X-ROW | SSP0015_ShipmentPSI.CboPlanDate_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0015_ShipmentPSI.CboPlanDate_Sele) |
| WK-SSP0015-0530 | X-ROW | SSP0015_ShipmentPSI.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · ERROR:1 |  | 1 (ACT:SSP0015_ShipmentPSI.CreateSpread) |
| WK-SSP0015-0531 | X-ROW | SSP0015_ShipmentPSI.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 59검사 — ERROR:42 · NA:11 · PASS:6 |  | 4 (ACT:SSP0015_ShipmentPSI.EditButton:1753:) |
| WK-SSP0015-0532 | X-ROW | SSP0015_ShipmentPSI.EngProcessingChk | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — PASS:2 · NA:2 · REVIEW:1 · ERROR:1 |  | 15 (ACT:SSP0015_ShipmentPSI.EngProcessingChk) |
| WK-SSP0015-0533 | X-ROW | SSP0015_ShipmentPSI.FindData_BolckStockD | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — ERROR:6 · NA:5 · PASS:4 · REVIEW:1 |  | 9 (ACT:SSP0015_ShipmentPSI.FindData_BolckSt) |
| WK-SSP0015-0534 | X-ROW | SSP0015_ShipmentPSI.FindData_Detail | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 20검사 — NA:8 · ERROR:7 · PASS:5 |  | 20 (ACT:SSP0015_ShipmentPSI.FindData_Detail:) |
| WK-SSP0015-0535 | X-ROW | SSP0015_ShipmentPSI.FindData_Detail_Pack | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — NA:8 · PASS:5 · ERROR:5 |  | 9 (ACT:SSP0015_ShipmentPSI.FindData_Detail_) |
| WK-SSP0015-0536 | X-ROW | SSP0015_ShipmentPSI.FindData_Detail_btnS | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — NA:8 · ERROR:6 · PASS:5 |  | 11 (ACT:SSP0015_ShipmentPSI.FindData_Detail_) |
| WK-SSP0015-0537 | X-ROW | SSP0015_ShipmentPSI.FindData_Main_Packer | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 30검사 — ERROR:8 · PASS:7 · NA:7 · REVIEW:5 · NOPATH:2 · NOT_RUN:1 |  | 8 (ACT:SSP0015_ShipmentPSI.FindData_Main_Pa) |
| WK-SSP0015-0538 | X-ROW | SSP0015_ShipmentPSI.FindData_MesStock_bt | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 21검사 — ERROR:8 · PASS:7 · NA:5 · REVIEW:1 |  | 7 (ACT:SSP0015_ShipmentPSI.FindData_MesStoc) |
| WK-SSP0015-0539 | X-ROW | SSP0015_ShipmentPSI.FindData_Request_Det | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — ERROR:8 · PASS:6 · NA:4 · REVIEW:1 |  | 7 (ACT:SSP0015_ShipmentPSI.FindData_Request) |
| WK-SSP0015-0540 | X-ROW | SSP0015_ShipmentPSI.FindData_ScsStock_bt | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — PASS:7 · ERROR:6 · NA:5 · REVIEW:1 |  | 5 (ACT:SSP0015_ShipmentPSI.FindData_ScsStoc) |
| WK-SSP0015-0541 | X-ROW | SSP0015_ShipmentPSI.FindData_ShipmentRes | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 20검사 — ERROR:8 · NA:6 · PASS:5 · REVIEW:1 |  | 8 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0542 | X-ROW | SSP0015_ShipmentPSI.FindData_ShipmentSCS | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — ERROR:6 · NA:6 · PASS:5 · REVIEW:1 |  | 6 (ACT:SSP0015_ShipmentPSI.FindData_Shipmen) |
| WK-SSP0015-0543 | X-ROW | SSP0015_ShipmentPSI.FindData_WHinPlanDet | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — PASS:8 · ERROR:4 · NA:2 · REVIEW:1 |  | 5 (ACT:SSP0015_ShipmentPSI.FindData_WHinPla) |
| WK-SSP0015-0544 | X-ROW | SSP0015_ShipmentPSI.FindData_WHstock | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:5 · NA:5 · PASS:4 · REVIEW:1 |  | 10 (ACT:SSP0015_ShipmentPSI.FindData_WHstock) |
| WK-SSP0015-0545 | X-ROW | SSP0015_ShipmentPSI.FindData_block_stock | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 17검사 — ERROR:7 · NA:5 · PASS:4 · REVIEW:1 |  | 11 (ACT:SSP0015_ShipmentPSI.FindData_block_s) |
| WK-SSP0015-0546 | X-ROW | SSP0015_ShipmentPSI.FindData_mes_stock | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 22검사 — ERROR:9 · PASS:7 · NA:5 · REVIEW:1 |  | 7 (ACT:SSP0015_ShipmentPSI.FindData_mes_sto) |
| WK-SSP0015-0547 | X-ROW | SSP0015_ShipmentPSI.FindData_shtStockLoc | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 26검사 — PASS:7 · ERROR:6 · REVIEW:5 · NA:5 · NOPATH:2 · NOT_RUN:1 |  | 5 (ACT:SSP0015_ShipmentPSI.FindData_shtStoc) |
| WK-SSP0015-0548 | X-ROW | SSP0015_ShipmentPSI.GetErpSoNoCnt | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  | 1 (ACT:SSP0015_ShipmentPSI.GetErpSoNoCnt) |
| WK-SSP0015-0549 | X-ROW | SSP0015_ShipmentPSI.GetNERPCode | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:2 · REVIEW:2 · NOPATH:2 · PASS:1 |  | 1 (ACT:SSP0015_ShipmentPSI.GetNERPCode) |
| WK-SSP0015-0550 | X-ROW | SSP0015_ShipmentPSI.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 23검사 — ERROR:12 · PASS:8 · NA:3 |  | 8 (ACT:SSP0015_ShipmentPSI.InitSpread ACT:S) |
| WK-SSP0015-0551 | X-ROW | SSP0015_ShipmentPSI.InsertButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0015_ShipmentPSI.InsertButton) |
| WK-SSP0015-0552 | X-ROW | SSP0015_ShipmentPSI.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 28검사 — ERROR:21 · PASS:7 |  | 128 (ACT:SSP0015_ShipmentPSI.InsertRow ACT:SS) |
| WK-SSP0015-0553 | X-ROW | SSP0015_ShipmentPSI.NonSoNo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — PASS:3 · ERROR:3 · NA:2 |  | 132 (ACT:SSP0015_ShipmentPSI.NonSoNo ACT:SSP0) |
| WK-SSP0015-0554 | X-ROW | SSP0015_ShipmentPSI.Re_Design | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 31 (ACT:SSP0015_ShipmentPSI.Re_Design ACT:SS) |
| WK-SSP0015-0555 | X-ROW | SSP0015_ShipmentPSI.SaveData_Detail | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 45검사 — ERROR:18 · PASS:17 · NA:5 · REVIEW:3 · NOPATH:2 |  | 6 (ACT:SSP0015_ShipmentPSI.SaveData_Detail:) |
| WK-SSP0015-0556 | X-ROW | SSP0015_ShipmentPSI.SaveData_Detail_Pack | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 30검사 — ERROR:14 · PASS:10 · NA:5 · REVIEW:1 |  | 3 (ACT:SSP0015_ShipmentPSI.SaveData_Detail_) |
| WK-SSP0015-0557 | X-ROW | SSP0015_ShipmentPSI.SaveData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 23검사 — ERROR:8 · PASS:7 · NA:4 · REVIEW:2 · NOPATH:2 |  | 2 (ACT:SSP0015_ShipmentPSI.SaveData_Main:53) |
| WK-SSP0015-0558 | X-ROW | SSP0015_ShipmentPSI.SetChangeControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:2 · ERROR:2 · NOT_RUN:1 |  | 10 (ACT:SSP0015_ShipmentPSI.SetChangeControl) |
| WK-SSP0015-0559 | X-ROW | SSP0015_ShipmentPSI.SetChangedControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NA:6 · PASS:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SSP0015_ShipmentPSI.SetChangedContro) |
| WK-SSP0015-0560 | X-ROW | SSP0015_ShipmentPSI.SetLockSumColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:1 · NA:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0015_ShipmentPSI.SetLockSumColumn) |
| WK-SSP0015-0561 | X-ROW | SSP0015_ShipmentPSI.SetNote_Display | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:6 · NA:6 |  | 2 (ACT:SSP0015_ShipmentPSI.SetNote_Display:) |
| WK-SSP0015-0562 | X-ROW | SSP0015_ShipmentPSI.SetProdNote_Display | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:5 · NA:5 |  | 4 (ACT:SSP0015_ShipmentPSI.SetProdNote_Disp) |
| WK-SSP0015-0563 | X-ROW | SSP0015_ShipmentPSI.SetSoNoColumnVisible | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:1 · NA:1 |  | 4 (ACT:SSP0015_ShipmentPSI.SetSoNoColumnVis) |
| WK-SSP0015-0564 | X-ROW | SSP0015_ShipmentPSI.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — ERROR:8 · NA:5 · PASS:2 · NOT_RUN:1 |  | 7 (ACT:SSP0015_ShipmentPSI.SetSpreadColumn:) |
| WK-SSP0015-0565 | X-ROW | SSP0015_ShipmentPSI.Set_SumValues | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NA:3 · ERROR:2 · NOT_RUN:1 |  | 5 (ACT:SSP0015_ShipmentPSI.Set_SumValues AC) |
| WK-SSP0015-0566 | X-ROW | SSP0015_ShipmentPSI.SoNo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — PASS:3 · ERROR:3 · NA:2 |  | 148 (ACT:SSP0015_ShipmentPSI.SoNo ACT:SSP0015) |
| WK-SSP0015-0567 | X-ROW | SSP0015_ShipmentPSI.SpdDetail_ActiveShee | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 82 (ACT:SSP0015_ShipmentPSI.SpdDetail_Active) |
| WK-SSP0015-0568 | X-ROW | SSP0015_ShipmentPSI.SpdDetail_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — ERROR:16 · PASS:2 · NA:1 |  | 60 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0569 | X-ROW | SSP0015_ShipmentPSI.SpdDetail_ClipboardP | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 91검사 — ERROR:80 · NA:11 |  | 31 (ACT:SSP0015_ShipmentPSI.SpdDetail_Clipbo) |
| WK-SSP0015-0570 | X-ROW | SSP0015_ShipmentPSI.SpdDetail_EditChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 27검사 — ERROR:27 |  | 38 (ACT:SSP0015_ShipmentPSI.SpdDetail_EditCh) |
| WK-SSP0015-0571 | X-ROW | SSP0015_ShipmentPSI.SpdDetail_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_TopCha) |
| WK-SSP0015-0572 | X-ROW | SSP0015_ShipmentPSI.SpdMain_ActiveSheetC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:3 · PASS:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0015_ShipmentPSI.SpdMain_ActiveSh) |
| WK-SSP0015-0573 | X-ROW | SSP0015_ShipmentPSI.SpdMain_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:2 · PASS:1 |  | 6 (ACT:SSP0015_ShipmentPSI.SpdMain_CellClic) |
| WK-SSP0015-0574 | X-ROW | SSP0015_ShipmentPSI.SpdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SSP0015_ShipmentPSI.SpdMain_TopChang) |
| WK-SSP0015-0575 | X-ROW | SSP0015_ShipmentPSI.TsmNotepad_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — ERROR:9 · NA:5 |  | 6 (ACT:SSP0015_ShipmentPSI.TsmNotepad_Click) |
| WK-SSP0015-0576 | X-ROW | SSP0015_ShipmentPSI.Validation_Check | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 25검사 — ERROR:21 · NA:4 |  | 105 (ACT:SSP0015_ShipmentPSI.Validation_Check) |
| WK-SSP0015-0577 | X-ROW | SSP0015_ShipmentPSI.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:3 · NA:3 · PASS:3 |  | 5 (ACT:SSP0015_ShipmentPSI.btnItemId_Click:) |
| WK-SSP0015-0578 | X-ROW | SSP0015_ShipmentPSI.btnMeasure_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NA:2 · PASS:2 |  | 5 (ACT:SSP0015_ShipmentPSI.btnMeasure_Click) |
| WK-SSP0015-0579 | X-ROW | SSP0015_ShipmentPSI.cboBucketType_Select | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0015_ShipmentPSI.cboBucketType_Se) |
| WK-SSP0015-0580 | X-ROW | SSP0015_ShipmentPSI.checkValidN | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 17 (ACT:SSP0015_ShipmentPSI.checkValidN ACT:) |
| WK-SSP0015-0581 | X-ROW | SSP0015_ShipmentPSI.chkERPIFBlockYn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 13 (ACT:SSP0015_ShipmentPSI.chkERPIFBlockYn ) |
| WK-SSP0015-0582 | X-ROW | SSP0015_ShipmentPSI.chkSaveYN | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — PASS:2 · ERROR:1 |  | 26 (ACT:SSP0015_ShipmentPSI.chkSaveYN ACT:SS) |
| WK-SSP0015-0583 | X-ROW | SSP0015_ShipmentPSI.chkSum_CheckedChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0015_ShipmentPSI.chkSum_CheckedCh) |
| WK-SSP0015-0584 | X-ROW | SSP0015_ShipmentPSI.clbDivision_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0015_ShipmentPSI.clbDivision_Sele) |
| WK-SSP0015-0585 | X-ROW | SSP0015_ShipmentPSI.shtDetail_Change | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:11 |  | 74 (ACT:SSP0015_ShipmentPSI.shtDetail_Change) |
| WK-SSP0015-0586 | X-ROW | SSP0015_ShipmentPSI.spdDetail_ComboSelCh | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 42검사 — ERROR:42 |  | 11 (ACT:SSP0015_ShipmentPSI.spdDetail_ComboS) |
| WK-SSP0015-0587 | X-ROW | SSP0015_ShipmentPSICommentsPopup..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOPATH:1 · ERROR:1 |  | 20 (ACT:SSP0015_ShipmentPSICommentsPopup..ct) |
| WK-SSP0015-0588 | X-ROW | SSP0015_ShipmentPSICommentsPopup.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.Dis) |
| WK-SSP0015-0589 | X-ROW | SSP0015_ShipmentPSICommentsPopup.Form_Lo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.For) |
| WK-SSP0015-0590 | X-ROW | SSP0015_ShipmentPSICommentsPopup.SaveBut | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:4 · NA:1 |  | 1 (ACT:SSP0015_ShipmentPSICommentsPopup.Sav) |
| WK-SSP0015-0591 | X-ROW | SSP0015_ShipmentPSICommentsPopup.SaveDat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:7 · PASS:5 · NA:3 |  | 55 (ACT:SSP0015_ShipmentPSICommentsPopup.Sav) |
| WK-SSP0015-0592 | X-ROW | SSP0015_ShipmentPSICommentsPopup.Validat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:2 · NA:2 |  | 12 (ACT:SSP0015_ShipmentPSICommentsPopup.Val) |
| WK-SSP0015-0593 | X-ROW | SSP0015_ShipmentPSICommentsPopup.btnButt | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 7 (ACT:SSP0015_ShipmentPSICommentsPopup.btn) |
| WK-SSP0015-0594 | X-ROW | SSP0015_ShipmentPSICommentsPopup.txtBefo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 7 (ACT:SSP0015_ShipmentPSICommentsPopup.txt) |
| WK-SSP0015-0595 | X-ROW | SSP0015_ShipmentPSICommentsPopup.txtChan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 3 (ACT:SSP0015_ShipmentPSICommentsPopup.txt) |
| WK-SSP0015-0596 | X-ROW | SSP0015_ShipmentPSICommentsPopup.txtChan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:4 · NOT_RUN:1 |  | 19 (ACT:SSP0015_ShipmentPSICommentsPopup.txt) |
| WK-SSP0015-0597 | X-ROW | SSP0015_ShipmentPSICommentsPopup.txtCurr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 7 (ACT:SSP0015_ShipmentPSICommentsPopup.txt) |
| WK-SSP0015-0598 | X-ROW | SSP0015_ShipmentPSICommentsPopup.txtGap_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 7 (ACT:SSP0015_ShipmentPSICommentsPopup.txt) |
| WK-SSP0015-0599 | X-ROW | SSP0015_ShipmentPSICommentsPopup.txtProd | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 7 (ACT:SSP0015_ShipmentPSICommentsPopup.txt) |
| WK-SSP0015-0600 | X-ROW | SSP0015_ShipmentPSICommentsPopup.txtWHin | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 7 (ACT:SSP0015_ShipmentPSICommentsPopup.txt) |
| WK-SSP0015-0601 | G5 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | G5 도구 오류 — 원장 V-da8769f6 ASIS / 원장 V-bff31456 ASIS |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0602 | G5 | SSP0015_ShipmentPSI.SpdMain_CellDoubleCl | 하네스·환경 | G5 도구 오류 — 원장 V-cb2e1076 ASIS / 원장 V-86b3ce9d ASIS / 원장 V-62dc5cbb ASIS / 원장 V-abbff0bc ASIS |  | 45 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0603 | G5 | new SCM0002_ShipmentPlanRequestPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-da8769f6 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0604 | G5 | pop.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-bff31456 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0605 | G5 | ssp0015Popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-86b3ce9d |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0606 | G5 | ssp0015Popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-abbff0bc |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0607 | G5 | txtModel2 / Model / Model2 / Model/Nickn | 하네스·환경 | G5 도구 오류 — 원장 V-3f2c8ad2 SEARCH / 원장 V-51dc1367 SEARCH / 원장 V-c7d22982 SEARCH / 원장 V-00b4fc33 SEARCH / 원장 V-9430a922 SEARCH / 원장 V |  | 6 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0608 | H6 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | H6 도구 오류 — 원장 V-97275d14 ASIS / 원장 V-dd647048 ASIS |  | 2 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0609 | H6 | ERP_SO_NO / SO No | 하네스·환경 | H6 도구 오류 — 원장 V-f78a3830 ASIS / 원장 V-9b128819 ASIS / 원장 V-46238110 ASIS |  | 13 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0610 | H6 | SSP0015_ShipmentPSI.SpdMain_CellDoubleCl | 하네스·환경 | H6 도구 오류 — 원장 V-a95e3873 ASIS / 원장 V-4a93eb43 ASIS / 원장 V-c6cc2d59 ASIS / 원장 V-596e2427 ASIS |  | 45 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0611 | H6 | SSP0015_ShipmentPSICommentsPopup | 하네스·환경 | H6 도구 오류 — 원장 V-a95e3873 ASIS / 원장 V-c6cc2d59 ASIS / 원장 V-5f8690ea ASIS / 원장 V-69d58d4c ASIS |  | 4 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0612 | H6 | new SCM0002_ShipmentPlanRequestPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-97275d14 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0613 | H6 | new SSP0015_ShipmentPSICommentsPopup(str | 하네스·환경 | H6 도구 오류 — 원장 V-a95e3873 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0614 | H6 | new SSP0015_ShipmentPSICommentsPopup(str | 하네스·환경 | H6 도구 오류 — 원장 V-c6cc2d59 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0615 | H6 | new SSP0015_ShipmentPSICommentsPopup(str | 하네스·환경 | H6 도구 오류 — 원장 V-5f8690ea |  | 1 (ACT:SSP0015_ShipmentPSI.TsmNotepad_Click) |
| WK-SSP0015-0616 | H6 | new SSP0015_ShipmentPSICommentsPopup(str | 하네스·환경 | H6 도구 오류 — 원장 V-69d58d4c |  | 1 (ACT:SSP0015_ShipmentPSI.TsmNotepad_Click) |
| WK-SSP0015-0617 | H6 | new SSP0300_OrderDetailPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-f78a3830 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0618 | H6 | pop.Form_Load(_DivisionID, _ErpSoNo, _Co | 하네스·환경 | H6 도구 오류 — 원장 V-9b128819 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0619 | H6 | pop.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-dd647048 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0620 | H6 | pop.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-46238110 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
| WK-SSP0015-0621 | H6 | ssp0015Popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-4a93eb43 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0622 | H6 | ssp0015Popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-596e2427 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0623 | H6 | ssp0015Popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-8f9e5110 |  | 1 (ACT:SSP0015_ShipmentPSI.TsmNotepad_Click) |
| WK-SSP0015-0624 | H6 | ssp0015Popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-84d39a0a |  | 1 (ACT:SSP0015_ShipmentPSI.TsmNotepad_Click) |
| WK-SSP0015-0625 | M3 | SSP0015_ShipmentPSICommentsPopup | 하네스·환경 | M3 도구 오류 — 원장 V-664910af ASIS / 원장 V-85754efa ASIS / 원장 V-6feeac9f ASIS / 원장 V-233821ef ASIS / 실측[T-c1dc55f0]: 팝업을 여는 트리거 셀을 화면 메타 |  | 15 (ACT:SSP0015_ShipmentPSICommentsPopup..ct) |
| WK-SSP0015-0626 | M3 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-8669ef19 |  | 1 (ACT:SSP0015_ShipmentPSI.BtnItemID2_Click) |
| WK-SSP0015-0627 | M3 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-ffbce079 |  | 1 (ACT:SSP0015_ShipmentPSI.btnItemId_Click:) |
| WK-SSP0015-0628 | M3 | new SCM0002_ShipmentPlanRequestPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-b002b24b |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellCl) |
| WK-SSP0015-0629 | M3 | new SCM0002_TitleSetForm_Popup("SSP0015" | 하네스·환경 | M3 도구 오류 — 원장 V-5dc80b6f |  | 1 (ACT:SSP0015_ShipmentPSI.btnMeasure_Click) |
| WK-SSP0015-0630 | M3 | new SSP0015_ShipmentPSICommentsPopup(str | 하네스·환경 | M3 도구 오류 — 원장 V-664910af |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0631 | M3 | new SSP0015_ShipmentPSICommentsPopup(str | 하네스·환경 | M3 도구 오류 — 원장 V-85754efa |  | 1 (ACT:SSP0015_ShipmentPSI.SpdMain_CellDoub) |
| WK-SSP0015-0632 | M3 | new SSP0015_ShipmentPSICommentsPopup(str | 하네스·환경 | M3 도구 오류 — 원장 V-6feeac9f |  | 1 (ACT:SSP0015_ShipmentPSI.TsmNotepad_Click) |
| WK-SSP0015-0633 | M3 | new SSP0015_ShipmentPSICommentsPopup(str | 하네스·환경 | M3 도구 오류 — 원장 V-233821ef |  | 1 (ACT:SSP0015_ShipmentPSI.TsmNotepad_Click) |
| WK-SSP0015-0634 | M3 | new SSP0300_OrderDetailPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-162cff79 |  | 1 (ACT:SSP0015_ShipmentPSI.SpdDetail_CellDo) |
