# 작업 원장 — SSP0023 · 2026-11-15 02:11

> 검사 인스턴스 1315건 중 PASS·NA 533건 외 **782건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 32 | 재판정 PASS |
| W5 | 검사기 연결 | 32 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 142 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 575 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 575 · 사람 판정 / AS-IS 원문 확인 → 재판정 93 · 대조표 49 · 하네스 32 · FE 23 · 화면 FE 8 · 공통 컴포넌트 1 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 14건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| C3 | CASCADE |  |  |  |  |  |  |  |  | 95 | 연쇄 자동 채움 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 75 | 무변경 편집 종료 시 연쇄 미발동 |
| X-ROW | GEN |  |  | 4 |  |  |  | 3 |  | 48 | 대조표 행이 서술한 동작을 화면에서 재현 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 53 | 배경·글자색 규칙 |
| X-REASON | DESIGN |  |  |  |  |  |  | 49 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 47 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| A1 | GEN |  |  |  |  |  |  | 45 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| D3 | EDIT |  |  |  |  |  |  |  |  | 42 | 행 값 기반 조건부 잠금 |
| E4 | EDIT |  |  |  |  |  |  |  |  | 32 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 30 | 그리드 셀 cascade 후보 |
| G1 | GEN |  |  |  |  |  |  |  |  | 28 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 27 | 컬럼 편집 가능 여부(신규행·기존행) |
| X-LOC | GEN |  |  |  |  |  |  | 23 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| F4 | DB |  |  |  |  |  |  | 5 |  | 15 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E1 | EDIT |  |  |  |  |  |  |  |  | 20 | 숫자 소수자리·정수·부호·범위 |
| M4 | POPUP |  |  | 18 |  |  |  | 1 |  |  | 팝업 선택값 반영 |
| A6 | GEN |  |  |  |  |  |  | 12 |  | 6 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| DB-SYN | DB |  |  |  |  | 14 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G4 | DESIGN |  |  | 6 |  | 6 | 1 |  |  |  | 조회조건 표시·라벨·활성 |
| B4 | COMBO |  |  |  |  | 1 |  |  |  | 11 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| H6 | POPUP |  |  |  |  | 3 |  |  |  | 9 | 팝업 표준·열림 |
| H5 | DESIGN |  |  |  |  |  |  | 1 |  | 11 | 라벨 명칭 |
| G5 | POPUP |  |  |  |  | 3 |  |  |  | 5 | 팝업 조건 연동(인자) |
| B3 | COMBO |  |  |  |  | 1 |  |  |  | 6 | 콤보 후보 정렬 = AS-IS |
| B6 | COMBO |  |  | 1 |  | 1 |  |  |  |  | ALL 옵션·다중선택 사양 |
| M3 | POPUP |  |  | 1 |  |  |  |  |  | 1 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| B1 | COMBO |  |  |  |  | 1 |  |  |  | 1 | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  |  |  | 1 | 콤보 후보 중복 없음 |
| C1 | CASCADE |  |  |  |  |  |  |  |  | 2 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| K-SA | COMMON |  |  | 1 |  |  |  |  |  |  | 조회영역 토글 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| E5 | EDIT |  |  |  |  | 1 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| C4 | CASCADE |  |  |  |  |  |  | 1 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| SC1 | DESIGN |  |  |  |  |  |  | 1 |  |  | 조회조건 순서 = 기준표 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  |  |  |  | 1 | Insert 위치·상태 유지 |

## W3 동작 수정 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0023-0001 | B6 | clbCompany_ID / Company / Company_ID | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | B6 FAIL 수정 — clbCompany_ID / Company / Company_ID: 원장 V-b7e18972 SEARCH (FX-SSP0023-022) |  | 1 (D00-1-018) |
| WK-SSP0023-0002 | K-SA | SSP0023 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | K-SA FAIL 수정 — SSP0023 화면: E2E smoke common Search Area 조회영역 토글 |  | 4 (D00-1-008 D00-1-058 D00-1-086 usrConditi) |
| WK-SSP0023-0003 | G4 | D00-1-086 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — D00-1-086: 행 집계 — 대조표 D00-1-086 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G4 20요소: NA:11 · NOPATH:6 · NOT_RUN:1 · |  | 1 (D00-1-086) |
| WK-SSP0023-0004 | G4 | D00-1-089 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — D00-1-089: 행 집계 — 대조표 D00-1-089 '§1 usrLayoutControl3 / UsrLayoutControl' 의 G4 20요소: NA:11 · NOPATH:6 · NOT_RUN:1 · P |  | 1 (D00-1-089) |
| WK-SSP0023-0005 | G4 | clbResultType / Result Type | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbResultType / Result Type: E2E smoke labels — 누락 라벨 |  | 4 (D00-1-021 clbResultType(C21) ACT:SSP0023) |
| WK-SSP0023-0006 | G4 | layoutControlGroup3(상세 조건, 활성시트별) | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — layoutControlGroup3(상세 조건, 활성시트별): 행 집계 — 대조표 layoutControlGroup3(상세 조건, 활성시트별) 'ShipmentPlanElectrodeDetailBar(detai |  | 1 (layoutControlGroup3(상세 조건, 활성시트별)) |
| WK-SSP0023-0007 | G4 | rdButton1~3(C65~67) | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — rdButton1~3(C65~67): 행 집계 — 대조표 rdButton1~3(C65~67) 'MainGrid BOH 3-radio(Button 배타)' 의 G4 20요소: NA:11 · NOPATH:6 · N |  | 1 (rdButton1~3(C65~67)) |
| WK-SSP0023-0008 | G4 | usrConditionPanel1(접이식 검색) | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — usrConditionPanel1(접이식 검색): 행 집계 — 대조표 usrConditionPanel1(접이식 검색) 'ShipmentPlanElectrodeForm + SearchArea(openSearchA |  | 1 (usrConditionPanel1(접이식 검색)) |
| WK-SSP0023-0009 | H10 | SSP0023 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H10 FAIL 수정 — SSP0023 화면: 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 5 (D00-4d-013 CRUD:EP02:SEARCH COMMON:UC-02) |
| WK-SSP0023-0010 | X-ROW | SSP0023_ShipmentPlanElectrode.BtnMeasure | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0023_ShipmentPlanElectrode.BtnMeasure_Click: 진입점 집계 11검사 — ERROR:6 · NA:2 · PASS:2 · FAIL:1 (FX-SSP0023-127) |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.BtnMea) |
| WK-SSP0023-0011 | X-ROW | SSP0023_ShipmentPlanElectrode.InitContro | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0023_ShipmentPlanElectrode.InitControls: 진입점 집계 13검사 — NA:6 · PASS:5 · FAIL:1 · ERROR:1 (FX-SSP0023-146) |  | 9 (ACT:SSP0023_ShipmentPlanElectrode.InitCo) |
| WK-SSP0023-0012 | X-ROW | SSP0023_ShipmentPlanElectrode.SpdDetail_ | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0023_ShipmentPlanElectrode.SpdDetail_CellDoubleClick: 진입점 집계 20검사 — FAIL:6 · ERROR:5 · NA:4 · NOPATH:4 · PASS:1 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0013 | X-ROW | SSP0023_ShipmentPlanElectrode.SpdMain_Ce | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0023_ShipmentPlanElectrode.SpdMain_CellDoubleClick: 진입점 집계 14검사 — FAIL:9 · NOPATH:2 · PASS:1 · NA:1 · NOT_RUN:1 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0014 | M3 | new SCM0002_TitleSetForm_Popup("SSP0023" | 화면 FE(범위 밖(가이드만)) | M3 FAIL 수정 — new SCM0002_TitleSetForm_Popup("SSP0023", shtName, false): 원장 V-7797c8e7 (FX-SSP0023-026) |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.BtnMea) |
| WK-SSP0023-0015 | M4 | CONFIRM_ID / Confirm/Plan ID | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — CONFIRM_ID / Confirm/Plan ID: 실측[T-04a1f1e5]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0016 | M4 | CONFIRM_QTY_CELL / Confirm Qty (Cell | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — CONFIRM_QTY_CELL / Confirm Qty (Cell: 실측[T-191f08d7]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0017 | M4 | CONFIRM_QTY_JR / Confirm Qty (Jumboroll  | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — CONFIRM_QTY_JR / Confirm Qty (Jumboroll m: 실측[T-261ca71c]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0018 | M4 | CONFIRM_QTY_PANCAKE / Confirm Qty (Panca | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — CONFIRM_QTY_PANCAKE / Confirm Qty (Pancake m: 실측[T-e662f6c8]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서  |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0019 | M4 | CONFIRM_QTY_ROLL_LENGTH / Confirm Qty (C | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — CONFIRM_QTY_ROLL_LENGTH / Confirm Qty (Cut: 실측[T-ee7447cb]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0020 | M4 | D00-2-025 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-2-025: 행 집계 — 대조표 D00-2-025 '§2 spdMain / CellDoubleClick' 의 M4 16요소: FAIL:15 · REVIEW:1 · FAIL 요소: btnMeasure —  |  | 1 (D00-2-025) |
| WK-SSP0023-0021 | M4 | DIVISION_ID / Div | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — DIVISION_ID / Div: 실측[T-74048dfd]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0022 | M4 | ERP_SO_NO / SO No | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — ERP_SO_NO / SO No: 실측[T-c20e55cf]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 13 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0023 | M4 | GAP / Gap | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — GAP / Gap: 실측[T-028fb6bf]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0024 | M4 | ITEM_ID / Material | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — ITEM_ID / Material: 실측[T-5078ebac]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0025 | M4 | MEASURE / Measure | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — MEASURE / Measure: 실측[T-d44ff13e]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 26 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0026 | M4 | PACKAGE_QTY / Package Qty | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — PACKAGE_QTY / Package Qty: 실측[T-5839a8a1]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지  |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0027 | M4 | REMARKS2 / Shipment No. | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — REMARKS2 / Shipment No.: 실측[T-e151f0f4]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0028 | M4 | SHIPMENT_CONFIRM_QTY / Confirm Qty | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SHIPMENT_CONFIRM_QTY / Confirm Qty: 실측[T-b315f0ef]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에  |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0029 | M4 | SHIPMENT_DATE / Shipment Date | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SHIPMENT_DATE / Shipment Date: 실측[T-84cb8fa6]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반 |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0030 | M4 | SHIPPING_PLAN_QTY / Shipping Plan Qty | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SHIPPING_PLAN_QTY / Shipping Plan Qty: 실측[T-c328c628]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이  |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0031 | M4 | SP | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SP: 실측[T-f9e80804]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (SP) |
| WK-SSP0023-0032 | M4 | SSP0023_ShipmentPlanElectrode.SpdMain_Ce | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SSP0023_ShipmentPlanElectrode.SpdMain_CellDoubleClick: 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.SpdMain_CellDoubleC |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |

## W5 검사기 연결 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0023-0033 | B1 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-021) |
| WK-SSP0023-0034 | B2 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-021) |
| WK-SSP0023-0035 | B3 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 2 (D00-1-021 clbResultType(C21)) |
| WK-SSP0023-0036 | B4 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 2 (D00-1-021 clbResultType(C21)) |
| WK-SSP0023-0037 | B6 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-021) |
| WK-SSP0023-0038 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 3 (DM0003_GET_BUCKET_TYPE_CODE(SP15) ACT:SS) |
| WK-SSP0023-0039 | DB-SYN | P_DELEGATEE_CHK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DELEGATEE_CHK | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0040 | DB-SYN | P_MY_MODEL_CHK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_MY_MODEL_CHK | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0041 | DB-SYN | P_NON_CHK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_NON_CHK | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0042 | DB-SYN | P_PART_LEADER_CHK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PART_LEADER_CHK | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0043 | DB-SYN | P_SSP0023_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0023_GET | 없음(PROC_M 대응 없음) | 1 (SSP0023_GET_SHIPMENT_PLAN(SP16)) |
| WK-SSP0023-0044 | DB-SYN | P_SSP0023_GET_CALENDAR | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0023_GET_CALENDAR | 없음(PROC_M 대응 없음) | 1 (SSP0023_GET_SHEET_CALENDAR_3SPAN(SP20)) |
| WK-SSP0023-0045 | DB-SYN | P_SSP0023_GET_DETAIL_EXCEL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0023_GET_DETAIL_EXCEL | 없음(PROC_M 대응 없음) | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(S) |
| WK-SSP0023-0046 | DB-SYN | P_SSP0023_GET_PLAN_DETAIL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0023_GET_PLAN_DETAIL | 없음(PROC_M 대응 없음) | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17)) |
| WK-SSP0023-0047 | DB-SYN | P_SSP0023_GET_RESULT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0023_GET_RESULT | 없음(PROC_M 대응 없음) | 1 (SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19)) |
| WK-SSP0023-0048 | DB-SYN | P_SSP0023_GET_STOCK_DETAIL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0023_GET_STOCK_DETAIL | 없음(PROC_M 대응 없음) | 1 (SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S) |
| WK-SSP0023-0049 | DB-SYN | P_SSP0023_SAVE_CONFIRM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0023_SAVE_CONFIRM | 없음(PROC_M 대응 없음) | 1 (SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM(SP) |
| WK-SSP0023-0050 | DB-SYN | P_SSP0023_SAVE_SIMU | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0023_SAVE_SIMU | 없음(PROC_M 대응 없음) | 2 (D00-2-007 SSP0023_SAVE_SHIPMENT_PLAN_SIM) |
| WK-SSP0023-0051 | DB-SYN | P_TEAM_LEADER_CHK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_TEAM_LEADER_CHK | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0052 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0023_ShipmentPlanElectrode.InitEv) |
| WK-SSP0023-0053 | G4 | btnItemId2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId2 | 있음(FE 소스) | 2 (ACT:SSP0023_ShipmentPlanElectrode.InitEv) |
| WK-SSP0023-0054 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 3 (btnMeasure(C06) ACT:SSP0023_ShipmentPlan) |
| WK-SSP0023-0055 | G4 | btnRequestor | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRequestor | 있음(FE 소스) | 2 (ACT:SSP0023_ShipmentPlanElectrode.InitEv) |
| WK-SSP0023-0056 | G4 | btnSearch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSearch | 있음(FE 소스) | 2 (ACT:SSP0023_ShipmentPlanElectrode.InitEv) |
| WK-SSP0023-0057 | G4 | btnSimulation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSimulation | 있음(FE 소스) | 2 (ACT:SSP0023_ShipmentPlanElectrode.InitEv) |
| WK-SSP0023-0058 | E5 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 1 (cellType(1)) |
| WK-SSP0023-0059 | G5 | REMARKS2 / Shipment No. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL REMARKS2 / Shipment No. | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0060 | G5 | SHIPMENT_DATE / Shipment Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL SHIPMENT_DATE / Shipment Date | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0061 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (MODAL:MeasureSelectModal) |
| WK-SSP0023-0062 | H6 | REMARKS2 / Shipment No. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL REMARKS2 / Shipment No. | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0063 | H6 | SHIPMENT_DATE / Shipment Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL SHIPMENT_DATE / Shipment Date | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0064 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (MODAL:MeasureSelectModal) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0023-0065 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (D00-1-016 chkSum(C16) ACT:SSP0023_Shipme) |

## W7 기대값 확정 (142)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0023-0066 | C4 | cboPlanDate / Plan-date / Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — cboPlanDate / Plan-date / Plan Date: 실측[T-0a645271]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] 조회 3 |  | 1 (D00-2-009) |
| WK-SSP0023-0067 | F4 | P_DELEGATEE_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — P_DELEGATEE_CHK: 실측[T-68615889]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T87 |  | 341 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0068 | F4 | P_MY_MODEL_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — P_MY_MODEL_CHK: 실측[T-b7c8360f]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T87· |  | 341 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0069 | F4 | P_NON_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — P_NON_CHK: 실측[T-a32bb75d]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T87·T101  |  | 341 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0070 | F4 | P_PART_LEADER_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — P_PART_LEADER_CHK: 실측[T-52f3d8ef]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T |  | 341 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0071 | F4 | P_TEAM_LEADER_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — P_TEAM_LEADER_CHK: 실측[T-919a35c5]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T |  | 341 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0072 | H5 | chkSum / Sum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — chkSum / Sum: 검증 엔진이 실행됐으나 이 대상(COND chkSum)을 판정하지 못함 — 라벨 명칭 시나리오 수동 확인 또는 엔진 확장 |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.SetSpr) |
| WK-SSP0023-0073 | SC1 | SSP0023 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | SC1 기대값 확정 — SSP0023 화면: 원장 V-6aaae0ff RULE_SCREEN / 원장 V-c3103fd4 CONFIRMED / E2E smoke cond order / 게이트 SC1 조회조건 순서가 기준표(SSP SCP |  | 29 (D00-1-010 D00-1-011 D00-1-015 D00-1-016 ) |
| WK-SSP0023-0074 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) — 공용 SubTitle/grid |  | 1 (COMMON:UC-05) |
| WK-SSP0023-0075 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) — SSP0023 1차/2차 조회조건은 전부 콤보 드롭다운(Division/Company/FromS |  | 1 (COMMON:UC-06) |
| WK-SSP0023-0076 | X-REASON | CRUD:EP04:DELETE | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CRUD:EP04:DELETE 툴바 DELETE ShipmentPlanElectrode.tsx:373 (hotkeyConfig.delete — AS-IS 빈 몸체 재현, NO-OP 노출) AS-IS  |  | 1 (CRUD:EP04:DELETE) |
| WK-SSP0023-0077 | X-REASON | D00-1-002 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-002 §1 Requestor / LayoutControlItem — Requestor 라벨 아이템 — UserInfoPopup(txtRequestor) 미이식으로 필드 미노출(04 exc |  | 1 (D00-1-002) |
| WK-SSP0023-0078 | X-REASON | D00-1-003 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-003 §1 btnExcelUpload / UsrButton — Excel Upload UI 미이식 — AS-IS 엑셀 업로드 affordance(R15b)는 iter-1 범위 외(04 e |  | 1 (D00-1-003) |
| WK-SSP0023-0079 | X-REASON | D00-1-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-004 §1 btnItemId / UsrButton — SCM0002_ItembyDivisionPopup 미이식 — Item 검색 팝업/버튼 미배치(04 excluded, §6) 제외 |  | 1 (D00-1-004) |
| WK-SSP0023-0080 | X-REASON | D00-1-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-005 §1 btnItemId2 / UsrButton — SCM0002_ItembyDivisionPopup 미이식 — Item 검색 팝업/버튼 미배치(04 excluded, §6) 제외 |  | 1 (D00-1-005) |
| WK-SSP0023-0081 | X-REASON | D00-1-012 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-012 §1 chkDelegateeModel / UsrCheckBox — 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 04 §6 My Model auto-check( |  | 1 (D00-1-012) |
| WK-SSP0023-0082 | X-REASON | D00-1-013 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-013 §1 chkMyModel / UsrCheckBox — 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 04 §6 R09 auto-check 보류) 제외 |  | 1 (D00-1-013) |
| WK-SSP0023-0083 | X-REASON | D00-1-014 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-014 §1 chkPartLeader / UsrCheckBox — 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 02 §1 검색 파라미터 그룹) 제외 |  | 1 (D00-1-014) |
| WK-SSP0023-0084 | X-REASON | D00-1-017 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-017 §1 chkTeamLeader / UsrCheckBox — 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 02 §1 검색 파라미터 그룹) 제외 |  | 1 (D00-1-017) |
| WK-SSP0023-0085 | X-REASON | D00-1-026 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-026 §1 emptySpaceItem1 / EmptySpaceItem — Designer 여백 스페이서 — React 대응 없음 해당없음 |  | 1 (D00-1-026) |
| WK-SSP0023-0086 | X-REASON | D00-1-027 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-027 §1 emptySpaceItem3 / EmptySpaceItem — Designer 여백 스페이서 — React 대응 없음 해당없음 |  | 1 (D00-1-027) |
| WK-SSP0023-0087 | X-REASON | D00-1-028 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-028 §1 emptySpaceItem4 / EmptySpaceItem — Designer 여백 스페이서 — React 대응 없음 해당없음 |  | 1 (D00-1-028) |
| WK-SSP0023-0088 | X-REASON | D00-1-029 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-029 §1 emptySpaceItem5 / EmptySpaceItem — Designer 여백 스페이서 — React 대응 없음 해당없음 |  | 1 (D00-1-029) |
| WK-SSP0023-0089 | X-REASON | D00-1-030 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-030 §1 formDown / UsrButton — Excel Download 폼 버튼 UI 미이식 — AS-IS 엑셀양식 다운로드(R15a·SP22 GET_..._EXCEL 은 배포됨) |  | 1 (D00-1-030) |
| WK-SSP0023-0090 | X-REASON | D00-1-051 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-051 §1 layoutLotId / LayoutControlItem — Lot ID 상세 텍스트필터 라벨 — 초기 Never(숨김)·spdDetail 활성시트 조건부 상세필터(02 §27 |  | 1 (D00-1-051) |
| WK-SSP0023-0091 | X-REASON | D00-1-052 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-052 §1 layoutMaterialBtn / LayoutControlItem — Item(Material) 팝업 버튼 래퍼 — ItembyDivisionPopup 미이식(04 exclu |  | 1 (D00-1-052) |
| WK-SSP0023-0092 | X-REASON | D00-1-053 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-053 §1 layoutMaterialDetail / LayoutControlItem — Material 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377) |  | 1 (D00-1-053) |
| WK-SSP0023-0093 | X-REASON | D00-1-054 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-054 §1 layoutModelDetail / LayoutControlItem — Model 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377), iter |  | 1 (D00-1-054) |
| WK-SSP0023-0094 | X-REASON | D00-1-055 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-055 §1 layoutNickNameDetail / LayoutControlItem — Nick Name 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377 |  | 1 (D00-1-055) |
| WK-SSP0023-0095 | X-REASON | D00-1-056 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-056 §1 layoutRequestorBtn / LayoutControlItem — Requestor 팝업 버튼 래퍼 — UserInfoPopup 미이식(04 excluded, §6) 제 |  | 1 (D00-1-056) |
| WK-SSP0023-0096 | X-REASON | D00-1-063 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-063 §1 lblItemId / LayoutControlItem — Item ID 라벨 — Item 텍스트 필터/팝업 미노출(04 excluded, §6) 제외 |  | 1 (D00-1-063) |
| WK-SSP0023-0097 | X-REASON | D00-1-072 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-072 §1 spdSub / FpSpread — siSub 엑셀 다운로드 버퍼 그리드 — AS-IS 엑셀 폼(R15a/b) UI 미이식, iter-1 범위 외(SHEETS.EXCEL 조회  |  | 1 (D00-1-072) |
| WK-SSP0023-0098 | X-REASON | D00-1-073 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-073 §1 spdSub_Sheet1 / SheetView — siSub 엑셀 버퍼 시트 — AS-IS 엑셀 폼 UI 미이식, iter-1 범위 외(SHEETS.EXCEL 조회 배선만) 제 |  | 1 (D00-1-073) |
| WK-SSP0023-0099 | X-REASON | D00-1-075 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-075 §1 textNickName / UsrMultiLineEditor — Nick Name 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §72), iter-1 UI |  | 1 (D00-1-075) |
| WK-SSP0023-0100 | X-REASON | D00-1-076 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-076 §1 txtItem2 / LayoutControlItem — Item 텍스트 필터 라벨 — Item 검색필터/팝업 미노출(04 excluded, §6) 제외 |  | 1 (D00-1-076) |
| WK-SSP0023-0101 | X-REASON | D00-1-077 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-077 §1 txtItem3 / LayoutControlItem — Item 텍스트 필터 라벨 — Item 검색필터/팝업 미노출(04 excluded, §6) 제외 |  | 1 (D00-1-077) |
| WK-SSP0023-0102 | X-REASON | D00-1-078 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-078 §1 txtItemId / UsrMultiLineEditor — Item ID 텍스트 검색필터 — Item 필터/팝업 미노출(04 excluded, §6) 제외 |  | 1 (D00-1-078) |
| WK-SSP0023-0103 | X-REASON | D00-1-079 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-079 §1 txtItemId2 / UsrMultiLineEditor — Item ID 텍스트 검색필터 — Item 필터/팝업 미노출(04 excluded, §6) 제외 |  | 1 (D00-1-079) |
| WK-SSP0023-0104 | X-REASON | D00-1-080 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-080 §1 txtLotID / UsrMultiLineEditor — Lot ID 상세 텍스트필터 에디터 — 초기 Never(숨김)·spdDetail 활성시트 조건부(02 §275), it |  | 1 (D00-1-080) |
| WK-SSP0023-0105 | X-REASON | D00-1-081 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-081 §1 txtModel2 / UsrMultiLineEditor — Model 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §377), iter-1 UI 미배치(범 |  | 1 (D00-1-081) |
| WK-SSP0023-0106 | X-REASON | D00-1-082 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-082 §1 txtModelId / UsrMultiLineEditor — Model 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §377), iter-1 UI 미배치( |  | 1 (D00-1-082) |
| WK-SSP0023-0107 | X-REASON | D00-1-083 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-083 §1 txtNickName2 / UsrMultiLineEditor — Nick Name 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §72), iter-1 UI |  | 1 (D00-1-083) |
| WK-SSP0023-0108 | X-REASON | D00-1-084 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-084 §1 txtRequestor / UsrTextBox — Requestor 텍스트박스 — UserInfoPopup 결과 채움용, 팝업 미이식으로 미노출(04 excluded, §6)  |  | 1 (D00-1-084) |
| WK-SSP0023-0109 | X-REASON | D00-2-001 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-001 §2 btnExcelUpload / Click — Excel Upload Click 핸들러 — AS-IS 엑셀 업로드 UI(R15b) 미이식, iter-1 범위 외(D00-1-003 |  | 1 (D00-2-001) |
| WK-SSP0023-0110 | X-REASON | D00-2-002 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-002 §2 btnItemId / Click — ItembyDivisionPopup 미이식 — Item 팝업 열기 핸들러 없음(04 excluded, §6) 제외 |  | 1 (D00-2-002) |
| WK-SSP0023-0111 | X-REASON | D00-2-003 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-003 §2 btnItemId2 / Click — ItembyDivisionPopup 미이식 — Item 팝업 열기 핸들러 없음(04 excluded, §6) 제외 |  | 1 (D00-2-003) |
| WK-SSP0023-0112 | X-REASON | D00-2-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-005 §2 btnRequestor / Click — UserInfoPopup 미이식 — Requestor 팝업 열기 핸들러 없음(04 excluded, §6) 제외 |  | 1 (D00-2-005) |
| WK-SSP0023-0113 | X-REASON | D00-2-015 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-015 §2 formDown / Click — Excel Download Click 핸들러 — AS-IS 엑셀양식 다운로드 UI(R15a) 미이식, iter-1 범위 외(D00-1-030  |  | 1 (D00-2-015) |
| WK-SSP0023-0114 | X-REASON | D00-2-020 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-020 §2 spdDetail / CellDoubleClick — Detail 그리드 셀 더블클릭 드릴다운 — AS-IS 는 Main→Detail 방향(setDetailFilter dblF |  | 1 (D00-2-020) |
| WK-SSP0023-0115 | X-REASON | D00-2-028 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-028 §2 spdMain / TopChange — AS-IS FpSpread 스크롤 TopChange(가상 스크롤 상단행 동기) — Wijmo DataGrid 가상화 내장, 화면 재현 불 |  | 1 (D00-2-028) |
| WK-SSP0023-0116 | X-REASON | D00-4b-001 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-001 §4b Data_SCP.Common / SSPBlockCheckIF / dtERPBlockYnIF — CB01 SSPBlockCheckIF 는 조회 콤보 아닌 ERP 차단 플래그( |  | 1 (D00-4b-001) |
| WK-SSP0023-0117 | X-REASON | D00-4d-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-004 §4d SpdDetail_ComboSelChange / TRANSPORT_MODE 공란 ShipmentPlanElectrode.tsx:290-299 (PLAN_DETAIL_REQU |  | 1 (D00-4d-004) |
| WK-SSP0023-0118 | X-REASON | D00-4d-014 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-014 §4d SpdDetail_CellClick / e.Column == CHANGE_REQ_NO — AS-IS CHANGE_REQ_NO 셀클릭 → 변경요청 이력 팝업 — 확정 SAVE |  | 1 (D00-4d-014) |
| WK-SSP0023-0119 | X-REASON | D00-4d-015 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-015 §4d SpdDetail_CellClick / sRequestNo 공백 — AS-IS CHANGE_REQ_NO 공백이면 이력 팝업 skip — 변경요청 이력 팝업 자체가 SP 체인 |  | 1 (D00-4d-015) |
| WK-SSP0023-0120 | X-REASON | D00-4d-028 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-028 §4d shtPlanDetail_Change / TRANSPORT_MODE 공란 ShipmentPlanElectrode.tsx:290-299 (저장부 공백검증) AS-IS 공란 되 |  | 1 (D00-4d-028) |
| WK-SSP0023-0121 | X-REASON | btnItemId/btnItemId2(C04/C05) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — btnItemId/btnItemId2(C04/C05) (Item 팝업 — 미구현) 제외: SCM0002_ItembyDivisionPopup 미이식 |  | 1 (btnItemId/btnItemId2(C04/C05)) |
| WK-SSP0023-0122 | X-REASON | txtRequestor(C84) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — txtRequestor(C84) (팝업 결과 채움 — 미구현) 제외: UserInfoPopup 미이식(§아래 제외목록) |  | 1 (txtRequestor(C84)) |
| WK-SSP0023-0123 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 19요소: REVIEW:16 · PASS |  | 1 (COMMON:UC-02) |
| WK-SSP0023-0124 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 A1 19요소: REVIEW:16 · PASS |  | 1 (COMMON:UC-03) |
| WK-SSP0023-0125 | A1 | CRUD:EP02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:EP02:SEARCH: 행 집계 — 대조표 CRUD:EP02:SEARCH '툴바 SEARCH — 조회 실행(수정 중이면 MSG00703 confirm)' 의 A1 19요소: REVIEW:16 · PASS |  | 1 (CRUD:EP02:SEARCH) |
| WK-SSP0023-0126 | A1 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-008: 행 집계 — 대조표 D00-1-008 '§1 btnSearch / SimpleButton' 의 A1 19요소: REVIEW:16 · PASS:3 · FAIL 요소: DMF0002_GET_TIT |  | 1 (D00-1-008) |
| WK-SSP0023-0127 | A1 | D00-1-089 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-089: 행 집계 — 대조표 D00-1-089 '§1 usrLayoutControl3 / UsrLayoutControl' 의 A1 19요소: REVIEW:16 · PASS:3 · FAIL 요소: DMF |  | 1 (D00-1-089) |
| WK-SSP0023-0128 | A1 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-006: 행 집계 — 대조표 D00-2-006 '§2 btnSearch / Click' 의 A1 19요소: REVIEW:16 · PASS:3 · FAIL 요소: DMF0002_GET_TITLESET_P |  | 1 (D00-2-006) |
| WK-SSP0023-0129 | A1 | D00-2-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-008: 행 집계 — 대조표 D00-2-008 '§2 cboBucketType / SelectedIndexChanged' 의 A1 19요소: REVIEW:16 · PASS:3 · FAIL 요소: DMF |  | 1 (D00-2-008) |
| WK-SSP0023-0130 | A1 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-012: 행 집계 — 대조표 D00-2-012 '§2 clbCompany_ID / SelectedIndexChanged' 의 A1 19요소: REVIEW:16 · PASS:3 · FAIL 요소: DMF |  | 1 (D00-2-012) |
| WK-SSP0023-0131 | A1 | D00-2-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-024: 행 집계 — 대조표 D00-2-024 '§2 spdDetail / SheetTabClick' 의 A1 19요소: REVIEW:16 · PASS:3 · FAIL 요소: DMF0002_GET_TI |  | 1 (D00-2-024) |
| WK-SSP0023-0132 | A1 | DM0003_GET_BUCKET_TYPE_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DM0003_GET_BUCKET_TYPE_CODE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0023/DM0003_GET_BUCKET_TYPE_CODE.md — 파라 |  | 1 (DM0003_GET_BUCKET_TYPE_CODE(SP15)) |
| WK-SSP0023-0133 | A1 | DMF0002_GET_TITLESET_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0002_GET_TITLESET_POPUP: 골든 비교 케이스 없음(DMF0002_GET_TITLESET_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (MODAL:MeasureSelectModal) |
| WK-SSP0023-0134 | A1 | FindButton(Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton(Search): 행 집계 — 대조표 FindButton(Search) 'hotkeyConfig.search=handleSearch' 의 A1 19요소: REVIEW:16 · PASS:3 · F |  | 1 (FindButton(Search)) |
| WK-SSP0023-0135 | A1 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_DETAIL: golden DIFF AS-IS 146행 ↔ TO-BE 150행: Doc/golden/SSP0023/SSP0023_GET_SH |  | 117 (SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17) A) |
| WK-SSP0023-0136 | A1 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_RESULT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0023/SSP0023_GET_SHIP |  | 63 (SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19) A) |
| WK-SSP0023-0137 | A1 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETA: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0023/SSP0023_GET_ |  | 59 (SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S) |
| WK-SSP0023-0138 | A1 | P_DELEGATEE_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DELEGATEE_CHK: 골든 비교 케이스 없음(P_DELEGATEE_CHK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 77 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0139 | A1 | P_MY_MODEL_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_MY_MODEL_CHK: 골든 비교 케이스 없음(P_MY_MODEL_CHK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 77 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0140 | A1 | P_NON_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_NON_CHK: 골든 비교 케이스 없음(P_NON_CHK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 77 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0141 | A1 | P_PART_LEADER_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_PART_LEADER_CHK: 골든 비교 케이스 없음(P_PART_LEADER_CHK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 77 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0142 | A1 | P_SSP0023_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0023_GET: 골든 비교 케이스 없음(P_SSP0023_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (SSP0023_GET_SHIPMENT_PLAN(SP16)) |
| WK-SSP0023-0143 | A1 | P_SSP0023_GET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0023_GET_CALENDAR: 골든 비교 케이스 없음(P_SSP0023_GET_CALENDAR — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (SSP0023_GET_SHEET_CALENDAR_3SPAN(SP20)) |
| WK-SSP0023-0144 | A1 | P_SSP0023_GET_DETAIL_EXCEL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0023_GET_DETAIL_EXCEL: 골든 비교 케이스 없음(P_SSP0023_GET_DETAIL_EXCEL — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(S) |
| WK-SSP0023-0145 | A1 | P_SSP0023_GET_PLAN_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0023_GET_PLAN_DETAIL: 골든 비교 케이스 없음(P_SSP0023_GET_PLAN_DETAIL — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가  |  | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17)) |
| WK-SSP0023-0146 | A1 | P_SSP0023_GET_RESULT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0023_GET_RESULT: 골든 비교 케이스 없음(P_SSP0023_GET_RESULT — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19)) |
| WK-SSP0023-0147 | A1 | P_SSP0023_GET_STOCK_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0023_GET_STOCK_DETAIL: 골든 비교 케이스 없음(P_SSP0023_GET_STOCK_DETAIL — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S) |
| WK-SSP0023-0148 | A1 | P_TEAM_LEADER_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_TEAM_LEADER_CHK: 골든 비교 케이스 없음(P_TEAM_LEADER_CHK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 77 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0149 | A1 | btnMeasure(C06) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnMeasure(C06): 행 집계 — 대조표 btnMeasure(C06) 'customButtons Measure → MeasureSelectModal' 의 A1 19요소: REVIEW:16 · PASS:3 |  | 1 (btnMeasure(C06)) |
| WK-SSP0023-0150 | A1 | cboBucketType(C10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboBucketType(C10): 행 집계 — 대조표 cboBucketType(C10) 'Form Bucket select(BUCKET_TYPE)' 의 A1 19요소: REVIEW:16 · PASS:3 · FA |  | 1 (cboBucketType(C10)) |
| WK-SSP0023-0151 | A1 | cboPlanDate(C11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboPlanDate(C11): 행 집계 — 대조표 cboPlanDate(C11) 'Form PlanDate select(COMBO.PLAN_INFOR)' 의 A1 19요소: REVIEW:16 · PASS:3 · |  | 1 (cboPlanDate(C11)) |
| WK-SSP0023-0152 | A1 | chkMyModel/PartLeader/TeamLeader/Delegat | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — chkMyModel/PartLeader/TeamLeader/DelegateeModel(C1: 행 집계 — 대조표 chkMyModel/PartLeader/TeamLeader/DelegateeModel(C12~14/ |  | 1 (chkMyModel/PartLeader/TeamLeader/Delegat) |
| WK-SSP0023-0153 | A1 | chkPastPeriod(C15) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — chkPastPeriod(C15): 행 집계 — 대조표 chkPastPeriod(C15) 'MainGrid 컨트롤바 Past Period Checkbox' 의 A1 19요소: REVIEW:16 · PASS:3 · |  | 1 (chkPastPeriod(C15)) |
| WK-SSP0023-0154 | A1 | chkSum(C16) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — chkSum(C16): 행 집계 — 대조표 chkSum(C16) 'MainGrid 컨트롤바 Sum Checkbox' 의 A1 19요소: REVIEW:16 · PASS:3 · FAIL 요소: DMF0002_GET_ |  | 1 (chkSum(C16)) |
| WK-SSP0023-0155 | A1 | clbCompanyID_SelectedIndexChanged(E12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbCompanyID_SelectedIndexChanged(E12): 행 집계 — 대조표 clbCompanyID_SelectedIndexChanged(E12) 'setCompany → FromSite/PlanD |  | 1 (clbCompanyID_SelectedIndexChanged(E12)) |
| WK-SSP0023-0156 | A1 | clbCompany_ID(C18) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbCompany_ID(C18): 행 집계 — 대조표 clbCompany_ID(C18) 'Form Company select(COMBO.COMPANY)' 의 A1 19요소: REVIEW:16 · PASS:3 · |  | 1 (clbCompany_ID(C18)) |
| WK-SSP0023-0157 | A1 | clbDivision_ID(C19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbDivision_ID(C19): 행 집계 — 대조표 clbDivision_ID(C19) 'Form Division select(COMBO.DIVISION)' 의 A1 19요소: REVIEW:16 · PASS |  | 1 (clbDivision_ID(C19)) |
| WK-SSP0023-0158 | A1 | clbDivision_ID_SelectedIndexChanged(E13) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbDivision_ID_SelectedIndexChanged(E13): 행 집계 — 대조표 clbDivision_ID_SelectedIndexChanged(E13) 'setDivision → Company 화 |  | 1 (clbDivision_ID_SelectedIndexChanged(E13)) |
| WK-SSP0023-0159 | A1 | clbFromSite(C20) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbFromSite(C20): 행 집계 — 대조표 clbFromSite(C20) 'Form FromSite select(COMBO.FROM_SITE)' 의 A1 19요소: REVIEW:16 · PASS:3 ·  |  | 1 (clbFromSite(C20)) |
| WK-SSP0023-0160 | A1 | clbResultType(C21) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbResultType(C21): 행 집계 — 대조표 clbResultType(C21) 'DetailBar Result Type(LOOKUP.RESULT_TYPE)' 의 A1 19요소: REVIEW:16 · P |  | 1 (clbResultType(C21)) |
| WK-SSP0023-0161 | A1 | drpPeriod(C23) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — drpPeriod(C23): 행 집계 — 대조표 drpPeriod(C23) 'Form Period InputField(표시전용)' 의 A1 19요소: REVIEW:16 · PASS:3 · FAIL 요소: DMF0 |  | 1 (drpPeriod(C23)) |
| WK-SSP0023-0162 | A1 | drpPeriod2/3(C24/C25) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — drpPeriod2/3(C24/C25): 행 집계 — 대조표 drpPeriod2/3(C24/C25) 'DetailBar Shipment Date(표시전용, 1차 period)' 의 A1 19요소: REVIEW:1 |  | 1 (drpPeriod2/3(C24/C25)) |
| WK-SSP0023-0163 | A1 | layoutControlGroup3(상세 조건, 활성시트별) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — layoutControlGroup3(상세 조건, 활성시트별): 행 집계 — 대조표 layoutControlGroup3(상세 조건, 활성시트별) 'ShipmentPlanElectrodeDetailBar(detail |  | 1 (layoutControlGroup3(상세 조건, 활성시트별)) |
| WK-SSP0023-0164 | A1 | rdButton1~3(C65~67) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — rdButton1~3(C65~67): 행 집계 — 대조표 rdButton1~3(C65~67) 'MainGrid BOH 3-radio(Button 배타)' 의 A1 19요소: REVIEW:16 · PASS:3 ·  |  | 1 (rdButton1~3(C65~67)) |
| WK-SSP0023-0165 | A1 | spdSub(엑셀 상세) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — spdSub(엑셀 상세): 행 집계 — 대조표 spdSub(엑셀 상세) '(SHEETS.EXCEL — 업로드 경로만, 03 §1.5)' 의 A1 19요소: REVIEW:16 · PASS:3 · FAIL 요소: D |  | 1 (spdSub(엑셀 상세)) |
| WK-SSP0023-0166 | A1 | txtModelId/textNickName/txtItemId 등 텍스트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtModelId/textNickName/txtItemId 등 텍스트: 행 집계 — 대조표 txtModelId/textNickName/txtItemId 등 텍스트 '(검색 필터 텍스트 — 미노출)' 의 A1 1 |  | 1 (txtModelId/textNickName/txtItemId 등 텍스트) |
| WK-SSP0023-0167 | A1 | usrConditionPanel1(접이식 검색) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — usrConditionPanel1(접이식 검색): 행 집계 — 대조표 usrConditionPanel1(접이식 검색) 'ShipmentPlanElectrodeForm + SearchArea(openSearchA' |  | 1 (usrConditionPanel1(접이식 검색)) |
| WK-SSP0023-0168 | A6 | DMF0002_GET_TITLESET_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — DMF0002_GET_TITLESET_POPUP: 검증 엔진이 실행됐으나 이 대상(SP DMF0002_GET_TITLESET_POPUP)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL O |  | 1 (MODAL:MeasureSelectModal) |
| WK-SSP0023-0169 | A6 | P_DELEGATEE_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_DELEGATEE_CHK: 검증 엔진이 실행됐으나 이 대상(SP P_DELEGATEE_CHK)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그 |  | 77 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0170 | A6 | P_MY_MODEL_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_MY_MODEL_CHK: 검증 엔진이 실행됐으나 이 대상(SP P_MY_MODEL_CHK)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 |  | 77 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0171 | A6 | P_NON_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_NON_CHK: 검증 엔진이 실행됐으나 이 대상(SP P_NON_CHK)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 시나리 |  | 77 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0172 | A6 | P_PART_LEADER_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_PART_LEADER_CHK: 검증 엔진이 실행됐으나 이 대상(SP P_PART_LEADER_CHK)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정 |  | 77 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0173 | A6 | P_SSP0023_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SSP0023_GET: 검증 엔진이 실행됐으나 이 대상(SP P_SSP0023_GET)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · |  | 1 (SSP0023_GET_SHIPMENT_PLAN(SP16)) |
| WK-SSP0023-0174 | A6 | P_SSP0023_GET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SSP0023_GET_CALENDAR: 검증 엔진이 실행됐으나 이 대상(SP P_SSP0023_GET_CALENDAR)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY  |  | 1 (SSP0023_GET_SHEET_CALENDAR_3SPAN(SP20)) |
| WK-SSP0023-0175 | A6 | P_SSP0023_GET_DETAIL_EXCEL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SSP0023_GET_DETAIL_EXCEL: 검증 엔진이 실행됐으나 이 대상(SP P_SSP0023_GET_DETAIL_EXCEL)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL O |  | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(S) |
| WK-SSP0023-0176 | A6 | P_SSP0023_GET_PLAN_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SSP0023_GET_PLAN_DETAIL: 검증 엔진이 실행됐으나 이 대상(SP P_SSP0023_GET_PLAN_DETAIL)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORD |  | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17)) |
| WK-SSP0023-0177 | A6 | P_SSP0023_GET_RESULT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SSP0023_GET_RESULT: 검증 엔진이 실행됐으나 이 대상(SP P_SSP0023_GET_RESULT)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19)) |
| WK-SSP0023-0178 | A6 | P_SSP0023_GET_STOCK_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SSP0023_GET_STOCK_DETAIL: 검증 엔진이 실행됐으나 이 대상(SP P_SSP0023_GET_STOCK_DETAIL)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL O |  | 1 (SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S) |
| WK-SSP0023-0179 | A6 | P_TEAM_LEADER_CHK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_TEAM_LEADER_CHK: 검증 엔진이 실행됐으나 이 대상(SP P_TEAM_LEADER_CHK)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정 |  | 77 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0180 | G03-WIRE | SSP0023 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SSP0023 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 |  | 33 (ACT:SSP0023_ShipmentPlanElectrode..ctor ) |
| WK-SSP0023-0181 | X-LOC | DM0003_GET_BUCKET_TYPE_CODE(SP15) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DM0003_GET_BUCKET_TYPE_CODE(SP15): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DM0003_GET_BUCKET_TYPE_CODE(SP15)) |
| WK-SSP0023-0182 | X-LOC | SP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SP) |
| WK-SSP0023-0183 | X-LOC | SSP0023_GET_SHEET_CALENDAR_3SPAN(SP20) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0023_GET_SHEET_CALENDAR_3SPAN(SP20): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0023_GET_SHEET_CALENDAR_3SPAN(SP20)) |
| WK-SSP0023-0184 | X-LOC | SSP0023_GET_SHIPMENT_PLAN(SP16) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0023_GET_SHIPMENT_PLAN(SP16): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0023_GET_SHIPMENT_PLAN(SP16)) |
| WK-SSP0023-0185 | X-LOC | SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17)) |
| WK-SSP0023-0186 | X-LOC | SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(SP22): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(S) |
| WK-SSP0023-0187 | X-LOC | SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19)) |
| WK-SSP0023-0188 | X-LOC | SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(SP18): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S) |
| WK-SSP0023-0189 | X-LOC | SSP0023_SAVE_SHIPMENT_PLAN_SIMU(SP21) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0023_SAVE_SHIPMENT_PLAN_SIMU(SP21): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0023_SAVE_SHIPMENT_PLAN_SIMU(SP21)) |
| WK-SSP0023-0190 | X-LOC | SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM(SP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM(SP01/02): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM(SP) |
| WK-SSP0023-0191 | X-LOC | cellType(1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cellType(1): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cellType(1)) |
| WK-SSP0023-0192 | X-LOC | color(36) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — color(36): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (color(36)) |
| WK-SSP0023-0193 | X-LOC | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — controls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (controls) |
| WK-SSP0023-0194 | X-LOC | dataSource(5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — dataSource(5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (dataSource(5)) |
| WK-SSP0023-0195 | X-LOC | events 영역2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — events 영역2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (events 영역2) |
| WK-SSP0023-0196 | X-LOC | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridSignals: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridSignals) |
| WK-SSP0023-0197 | X-LOC | lock(22) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — lock(22): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (lock(22)) |
| WK-SSP0023-0198 | X-LOC | merge(7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — merge(7): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (merge(7)) |
| WK-SSP0023-0199 | X-LOC | other(24) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — other(24): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (other(24)) |
| WK-SSP0023-0200 | X-LOC | span(10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — span(10): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (span(10)) |
| WK-SSP0023-0201 | X-LOC | toolbarOverride | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — toolbarOverride: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (toolbarOverride) |
| WK-SSP0023-0202 | X-LOC | value(91) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — value(91): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (value(91)) |
| WK-SSP0023-0203 | X-LOC | visible(88) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — visible(88): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (visible(88)) |
| WK-SSP0023-0204 | X-ROW | SSP0023_ShipmentPlanElectrode.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0023_ShipmentPlanElectrode.FindButton: 진입점 집계 21검사 — REVIEW:10 · PASS:6 · NOT_RUN:5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.FindBu) |
| WK-SSP0023-0205 | X-ROW | SSP0023_ShipmentPlanElectrode.ShipmentRe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0023_ShipmentPlanElectrode.ShipmentResult_GetDa: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SSP0023_ShipmentPlanElectrode.Shipme) |
| WK-SSP0023-0206 | X-ROW | SSP0023_ShipmentPlanElectrode.SpdDetail_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0023_ShipmentPlanElectrode.SpdDetail_SheetTabCl: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/GRID_INIT, 연결된  |  | 12 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0207 | M4 | btnMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnMeasure: 실측[T-e9267327]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 |  | 1 (MODAL:MeasureSelectModal) |

## W9 도구 오류 (575)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0023-0208 | J2 | SSP0023 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-bf325e69 RULE_SCREEN / 원장 V-20d51d97 DEFECT / 원장 V-cc801a04 GENERAL / 원장 V-613ce4f8 GENERAL / 원장 V-5a81f071 GENERA |  | 174 (D00-1-008 D00-1-009 D00-1-089 D00-2-006 ) |
| WK-SSP0023-0209 | C1 | cboBucketType / Bucket / Bucket Type | 하네스·환경 | C1 도구 오류 — 실측[T-ee375239]: 'Bucket' → 'Weekly' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 cboBucketType_SelectedIndexChanged · AS-IS 하위  |  | 2 (D00-2-008 ACT:SSP0023_ShipmentPlanElectr) |
| WK-SSP0023-0210 | C1 | chkPastPeriod / Including Past Period /  | 하네스·환경 | C1 도구 오류 — 실측[T-7df59df2]: 상위 조건 'Including Past Period' 이 콤보가 아님(checkbox) — 이 유형 변경 프로브 미구현 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-2-010) |
| WK-SSP0023-0211 | C2 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C2 도구 오류 — 실측[T-78a4ea4f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 56 (D00-4d-008 ACT:SSP0023_ShipmentPlanElect) |
| WK-SSP0023-0212 | C2 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C2 도구 오류 — 실측[T-f42f25db]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 6 (D00-2-023 ACT:SSP0023_ShipmentPlanElectr) |
| WK-SSP0023-0213 | C2 | D00-2-021 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-021 '§2 spdDetail / ClipboardPasted' 의 C2 20요소: ERROR:20 |  | 1 (D00-2-021) |
| WK-SSP0023-0214 | C2 | D00-2-026 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-026 '§2 spdMain / Change' 의 C2 20요소: ERROR:20 |  | 1 (D00-2-026) |
| WK-SSP0023-0215 | C2 | DIVISION_ID / Div | 하네스·환경 | C2 도구 오류 — 실측[T-19f30fbb]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.clbDiv) |
| WK-SSP0023-0216 | C2 | DOM_EXP / DOM/EXP. | 하네스·환경 | C2 도구 오류 — 실측[T-1815af69]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0217 | C2 | EDIT_MAIN | 하네스·환경 | C2 도구 오류 — 실측[T-1039bc01]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 18 (D00-4d-003 ACT:SSP0023_ShipmentPlanElect) |
| WK-SSP0023-0218 | C2 | ERP_SO_NO / SO No | 하네스·환경 | C2 도구 오류 — 실측[T-dbe8014c]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 16 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0219 | C2 | FACTORY_ID | 하네스·환경 | C2 도구 오류 — 원장 V-7d7c30b4 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0220 | C2 | FACTORY_ID / Building Desc. | 하네스·환경 | C2 도구 오류 — 원장 V-7d7c30b4 ASIS / 실측[T-8ac56906]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail  |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0221 | C2 | JR_BOH_QTY / J/R | 하네스·환경 | C2 도구 오류 — 실측[T-94ee8eac]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0222 | C2 | JR_BOH_QTY_CELL / J/R | 하네스·환경 | C2 도구 오류 — 실측[T-e09851bc]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0223 | C2 | JR_BOH_QTY_PCM / J/R | 하네스·환경 | C2 도구 오류 — 실측[T-60b85deb]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0224 | C2 | NEW_ROUTE_ID / Route | 하네스·환경 | C2 도구 오류 — 실측[T-48e0a99e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0225 | C2 | PACKAGE_TYPE / Package Type  | 하네스·환경 | C2 도구 오류 — 실측[T-f1ac7b71]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0226 | C2 | PC_BOH_QTY / Pancake | 하네스·환경 | C2 도구 오류 — 실측[T-84b184dd]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0227 | C2 | PC_BOH_QTY_CELL / Pancake | 하네스·환경 | C2 도구 오류 — 실측[T-94649009]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0228 | C2 | PC_BOH_QTY_PCM / Pancake | 하네스·환경 | C2 도구 오류 — 실측[T-2dc1c1c7]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0229 | C2 | SSP0023_ShipmentPlanElectrode.SpdDetail_ | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.SpdDetail_ActiveSheetChanged 의 C2 20요소: ERROR:20 |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0230 | C2 | SSP0023_ShipmentPlanElectrode.cboBucketT | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.cboBucketType_SelectedIndexChanged 의 C2 20요소: ERROR:20 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.cboBuc) |
| WK-SSP0023-0231 | C2 | SSP0023_ShipmentPlanElectrode.cboPlanDat | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.cboPlanDate_SelectedIndexChanged 의 C2 20요소: ERROR:20 |  | 18 (ACT:SSP0023_ShipmentPlanElectrode.cboPla) |
| WK-SSP0023-0232 | C2 | SSP0023_ShipmentPlanElectrode.chkPastPer | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.chkPastPeriod_CheckedChanged 의 C2 20요소: ERROR:20 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.chkPas) |
| WK-SSP0023-0233 | C2 | SSP0023_ShipmentPlanElectrode.chkSum_Che | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.chkSum_CheckedChanged 의 C2 20요소: ERROR:20 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.chkSum) |
| WK-SSP0023-0234 | C2 | SSP0023_ShipmentPlanElectrode.clbCompany | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.clbCompanyID_SelectedIndexChanged 의 C2 20요소: ERROR:20 |  | 10 (ACT:SSP0023_ShipmentPlanElectrode.clbCom) |
| WK-SSP0023-0235 | C2 | SSP0023_ShipmentPlanElectrode.clbDivisio | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.clbDivision_ID_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.clbDiv) |
| WK-SSP0023-0236 | C2 | SSP0023_ShipmentPlanElectrode.rdButton_C | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.rdButton_Changed 의 C2 9요소: ERROR:9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0237 | C2 | TOT_BOH_QTY / BOH | 하네스·환경 | C2 도구 오류 — 실측[T-28ad7cf0]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0238 | C2 | TOT_BOH_QTY_CELL / BOH | 하네스·환경 | C2 도구 오류 — 실측[T-e070d1d2]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0239 | C2 | TOT_BOH_QTY_PCM / BOH | 하네스·환경 | C2 도구 오류 — 실측[T-ada0cbb0]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0240 | C2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C2 도구 오류 — 원장 V-7d7c30b4 ASIS / 실측[T-6af3b817]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail  |  | 68 (D00-2-022 D00-4d-003 ACT:SSP0023_Shipmen) |
| WK-SSP0023-0241 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-aa003d50 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0242 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-eefdeac8 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0243 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-21db2e38 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0244 | C3 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C3 도구 오류 — 원장 V-aa003d50 ASIS / 원장 V-fae16d11 ASIS / 원장 V-c85b9372 ASIS / 원장 V-eefdeac8 ASIS / 원장 V-6b69aa42 ASIS / 원장 V-21db2e38  |  | 67 (D00-4d-008 ACT:SSP0023_ShipmentPlanElect) |
| WK-SSP0023-0245 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-64cf233a |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0246 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-e744f46f |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0247 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-e754386f |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0248 | C3 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C3 도구 오류 — 원장 V-64cf233a ASIS / 원장 V-e744f46f ASIS / 원장 V-b99cb667 ASIS / 원장 V-e754386f ASIS / 원장 V-276bc1c9 ASIS / 실측[T-38c1b01c] |  | 15 (D00-2-023 ACT:SSP0023_ShipmentPlanElectr) |
| WK-SSP0023-0249 | C3 | D00-2-021 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-021 '§2 spdDetail / ClipboardPasted' 의 C3 75요소: ERROR:75 |  | 1 (D00-2-021) |
| WK-SSP0023-0250 | C3 | D00-2-026 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-026 '§2 spdMain / Change' 의 C3 75요소: ERROR:75 |  | 1 (D00-2-026) |
| WK-SSP0023-0251 | C3 | D00-2-027 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-027 '§2 spdMain / ClipboardPasted' 의 C3 75요소: ERROR:75 |  | 1 (D00-2-027) |
| WK-SSP0023-0252 | C3 | D00-4d-005 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-005 '§4d SpdDetail_ClipboardPasted / siDetail.IsLock ==' 의 C3 75요소: ERROR:75 |  | 1 (D00-4d-005) |
| WK-SSP0023-0253 | C3 | D00-4d-006 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-006 '§4d SpdDetail_ClipboardPasted / ActiveSheet == sht' 의 C3 75요소: ERROR:75 |  | 1 (D00-4d-006) |
| WK-SSP0023-0254 | C3 | D00-4d-007 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-007 '§4d SpdDetail_ClipboardPasted / Cells[iRow,iCol].T' 의 C3 75요소: ERROR:75 |  | 1 (D00-4d-007) |
| WK-SSP0023-0255 | C3 | D00-4d-009 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-009 '§4d SpdDetail_ClipboardPasted / dr == null' 의 C3 75요소: ERROR:75 |  | 1 (D00-4d-009) |
| WK-SSP0023-0256 | C3 | DIVISION_ID / Div | 하네스·환경 | C3 도구 오류 — 실측[T-bdde1f3f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 10 (ACT:SSP0023_ShipmentPlanElectrode.SetCha) |
| WK-SSP0023-0257 | C3 | DOM_EXP / DOM/EXP. | 하네스·환경 | C3 도구 오류 — 원장 V-c1e662e6 ASIS / 원장 V-2ab85975 ASIS / 원장 V-e16a64f9 ASIS / 원장 V-feeed5f2 ASIS / 원장 V-f5e99713 ASIS / 원장 V-0d037708  |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0258 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-0f42c0f3 ASIS / 원장 V-4bcdc334 ASIS / 원장 V-eebcc3b9 ASIS / 원장 V-9ac5d45e ASIS / 원장 V-f478c117 ASIS / 원장 V-cb2e0cbf  |  | 60 (D00-4d-003 ACT:SSP0023_ShipmentPlanElect) |
| WK-SSP0023-0259 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-0f42c0f3 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0260 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-4bcdc334 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0261 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-eebcc3b9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0262 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-9ac5d45e |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0263 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-f478c117 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0264 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-cb2e0cbf |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0265 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-a6a891be |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0266 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-4bc8708d |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0267 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-10add96c |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0268 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-fd758a53 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0269 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-3e913599 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0270 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-bf863520 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0271 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-0265aac7 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0272 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-ae50fc94 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0273 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-e589e56d |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0274 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-14163dd7 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0275 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-8cc6113d |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0276 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-7fcb69d0 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0277 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-fae16d11 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0278 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-c85b9372 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0279 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-6b69aa42 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0280 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-599a5edb |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0281 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-c1e662e6 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0282 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-2ab85975 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0283 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-e16a64f9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0284 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-feeed5f2 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0285 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-f5e99713 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0286 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-0d037708 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0287 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-1d5813ef |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0288 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-f14406dc |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0289 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-b99cb667 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0290 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-276bc1c9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0291 | C3 | ELECTRODE_TYPE / Elec Type | 하네스·환경 | C3 도구 오류 — 실측[T-109fc6ad]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0292 | C3 | ERP_SO_NO / SO No | 하네스·환경 | C3 도구 오류 — 실측[T-4513e8b5]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 38 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0293 | C3 | FACTORY_ID / Building Desc. | 하네스·환경 | C3 도구 오류 — 원장 V-e16a64f9 ASIS / 원장 V-feeed5f2 ASIS / 원장 V-f5e99713 ASIS / 원장 V-0d037708 ASIS / 실측[T-f249d8a1]: [측정 경로 없음] 조회 후 Ins |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0294 | C3 | FROM_SITE / SCM Site | 하네스·환경 | C3 도구 오류 — 실측[T-59067e3d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0295 | C3 | ITEM_ID / Material | 하네스·환경 | C3 도구 오류 — 실측[T-6011e58a]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.Set_Su) |
| WK-SSP0023-0296 | C3 | JR_BOH_QTY / J/R | 하네스·환경 | C3 도구 오류 — 실측[T-095f46ea]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0297 | C3 | JR_BOH_QTY_CELL / J/R | 하네스·환경 | C3 도구 오류 — 실측[T-244c9049]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0298 | C3 | JR_BOH_QTY_PCM / J/R | 하네스·환경 | C3 도구 오류 — 실측[T-d9077e4e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0299 | C3 | MEASURE / Measure | 하네스·환경 | C3 도구 오류 — 실측[T-2521ae76]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 14 (ACT:SSP0023_ShipmentPlanElectrode.SetSpr) |
| WK-SSP0023-0300 | C3 | MODEL_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-2eab1dc4]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0301 | C3 | NEW_ETD / ETD | 하네스·환경 | C3 도구 오류 — 실측[T-2ee15422]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0302 | C3 | NEW_LT_DAY / L/T(Day | 하네스·환경 | C3 도구 오류 — 실측[T-23876903]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0303 | C3 | NEW_ROUTE_ID / Route | 하네스·환경 | C3 도구 오류 — 실측[T-9c634601]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0304 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-6aa9c9ef |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0305 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-d3b89810 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0306 | C3 | NEW_SHIPMENT_DATE / Shipment Date | 하네스·환경 | C3 도구 오류 — 원장 V-6aa9c9ef ASIS / 원장 V-d3b89810 ASIS / 실측[T-7284f7e8]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0307 | C3 | PACKAGE_TYPE / Package Type  | 하네스·환경 | C3 도구 오류 — 원장 V-f5e99713 ASIS / 원장 V-0d037708 ASIS / 실측[T-7f7e3576]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow |  | 6 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0308 | C3 | PC_BOH_QTY / Pancake | 하네스·환경 | C3 도구 오류 — 실측[T-6bcb8133]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0309 | C3 | PC_BOH_QTY_CELL / Pancake | 하네스·환경 | C3 도구 오류 — 실측[T-1a5411ab]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0310 | C3 | PC_BOH_QTY_PCM / Pancake | 하네스·환경 | C3 도구 오류 — 실측[T-75fc6a5d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0311 | C3 | PLANT_ID / Plant | 하네스·환경 | C3 도구 오류 — 실측[T-6069b04c]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0312 | C3 | REMARKS / Remarks | 하네스·환경 | C3 도구 오류 — 원장 V-cb2e0cbf ASIS / 원장 V-a6a891be ASIS / 원장 V-aa003d50 ASIS / 원장 V-4bc8708d ASIS / 원장 V-10add96c ASIS / 원장 V-64cf233a  |  | 8 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0313 | C3 | SHIPMENT_CONFIRM_QTY / Confirm Qty | 하네스·환경 | C3 도구 오류 — 원장 V-f478c117 ASIS / 원장 V-cb2e0cbf ASIS / 원장 V-a6a891be ASIS / 원장 V-aa003d50 ASIS / 원장 V-4bc8708d ASIS / 원장 V-10add96c  |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0314 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-0518a0d9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0315 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-62d56532 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0316 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-11d3d2b7 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0317 | C3 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | C3 도구 오류 — 원장 V-0518a0d9 ASIS / 원장 V-eebcc3b9 ASIS / 원장 V-62d56532 ASIS / 원장 V-9ac5d45e ASIS / 원장 V-f478c117 ASIS / 원장 V-cb2e0cbf  |  | 17 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0318 | C3 | SHIPPING_PLAN_QTY / Shipping Plan Qty | 하네스·환경 | C3 도구 오류 — 실측[T-c7ca0da5]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Re_Des) |
| WK-SSP0023-0319 | C3 | SSP0023_ShipmentPlanElectrode.SetChangeC | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.SetChangeControl 의 C3 75요소: ERROR:75 |  | 15 (ACT:SSP0023_ShipmentPlanElectrode.SetCha) |
| WK-SSP0023-0320 | C3 | SSP0023_ShipmentPlanElectrode.SetChanged | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.SetChangedControl 의 C3 1요소: ERROR:1 |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.SetCha) |
| WK-SSP0023-0321 | C3 | SSP0023_ShipmentPlanElectrode.SetSpreadC | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.SetSpreadColumn 의 C3 1요소: ERROR:1 |  | 11 (ACT:SSP0023_ShipmentPlanElectrode.SetSpr) |
| WK-SSP0023-0322 | C3 | SSP0023_ShipmentPlanElectrode.Set_SumVal | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.Set_SumValues 의 C3 75요소: ERROR:75 |  | 25 (ACT:SSP0023_ShipmentPlanElectrode.Set_Su) |
| WK-SSP0023-0323 | C3 | SSP0023_ShipmentPlanElectrode.Set_Sum_Va | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.Set_Sum_Values 의 C3 2요소: ERROR:2 |  | 35 (ACT:SSP0023_ShipmentPlanElectrode.Set_Su) |
| WK-SSP0023-0324 | C3 | SSP0023_ShipmentPlanElectrode.SpdDetail_ | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.SpdDetail_ActiveSheetChanged 의 C3 75요소: ERROR:75 |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0325 | C3 | SSP0023_ShipmentPlanElectrode.cboBucketT | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.cboBucketType_SelectedIndexChanged 의 C3 75요소: ERROR:75 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.cboBuc) |
| WK-SSP0023-0326 | C3 | SSP0023_ShipmentPlanElectrode.cboPlanDat | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.cboPlanDate_SelectedIndexChanged 의 C3 75요소: ERROR:75 |  | 18 (ACT:SSP0023_ShipmentPlanElectrode.cboPla) |
| WK-SSP0023-0327 | C3 | SSP0023_ShipmentPlanElectrode.chkPastPer | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.chkPastPeriod_CheckedChanged 의 C3 75요소: ERROR:75 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.chkPas) |
| WK-SSP0023-0328 | C3 | SSP0023_ShipmentPlanElectrode.chkSum_Che | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.chkSum_CheckedChanged 의 C3 75요소: ERROR:75 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.chkSum) |
| WK-SSP0023-0329 | C3 | SSP0023_ShipmentPlanElectrode.clbCompany | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.clbCompanyID_SelectedIndexChanged 의 C3 75요소: ERROR:75 |  | 10 (ACT:SSP0023_ShipmentPlanElectrode.clbCom) |
| WK-SSP0023-0330 | C3 | SSP0023_ShipmentPlanElectrode.clbDivisio | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.clbDivision_ID_SelectedIndexChanged 의 C3 1요소: ERROR:1 |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.clbDiv) |
| WK-SSP0023-0331 | C3 | SSP0023_ShipmentPlanElectrode.rdButton_C | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.rdButton_Changed 의 C3 9요소: ERROR:9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0332 | C3 | TOT_BOH_QTY / BOH | 하네스·환경 | C3 도구 오류 — 실측[T-70ed272d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 11 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0333 | C3 | TOT_BOH_QTY_CELL / BOH | 하네스·환경 | C3 도구 오류 — 실측[T-76fc4ca0]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0334 | C3 | TOT_BOH_QTY_PCM / BOH | 하네스·환경 | C3 도구 오류 — 실측[T-99d0fcc3]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 10 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0335 | C3 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C3 도구 오류 — 원장 V-0f42c0f3 ASIS / 원장 V-4bcdc334 ASIS / 원장 V-0518a0d9 ASIS / 원장 V-eebcc3b9 ASIS / 원장 V-62d56532 ASIS / 원장 V-9ac5d45e  |  | 74 (D00-2-022 D00-4d-003 ACT:SSP0023_Shipmen) |
| WK-SSP0023-0336 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-e372ab3b |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0337 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-aeedc15c |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0338 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-c7e6b17f |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0339 | C6 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C6 도구 오류 — 원장 V-e372ab3b ASIS / 원장 V-b1c1f5bc ASIS / 원장 V-e969ef89 ASIS / 원장 V-fb479fd9 ASIS / 원장 V-aeedc15c ASIS / 원장 V-d4ba6ca0  |  | 56 (D00-4d-008 ACT:SSP0023_ShipmentPlanElect) |
| WK-SSP0023-0340 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-5c15bc35 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0341 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-e969ef89 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0342 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-d4ba6ca0 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0343 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-34a4a34b |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0344 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-bb070dcc |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0345 | C6 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C6 도구 오류 — 원장 V-5c15bc35 ASIS / 원장 V-e969ef89 ASIS / 원장 V-d4ba6ca0 ASIS / 원장 V-34a4a34b ASIS / 원장 V-ac98085e ASIS / 원장 V-bb070dcc  |  | 6 (D00-2-023 ACT:SSP0023_ShipmentPlanElectr) |
| WK-SSP0023-0346 | C6 | D00-2-021 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-2-021 '§2 spdDetail / ClipboardPasted' 의 C6 65요소: ERROR:65 |  | 1 (D00-2-021) |
| WK-SSP0023-0347 | C6 | D00-2-026 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-2-026 '§2 spdMain / Change' 의 C6 65요소: ERROR:65 |  | 1 (D00-2-026) |
| WK-SSP0023-0348 | C6 | DIVISION_ID / Div | 하네스·환경 | C6 도구 오류 — 실측[T-cb469e61]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.clbDiv) |
| WK-SSP0023-0349 | C6 | DOM_EXP / DOM/EXP. | 하네스·환경 | C6 도구 오류 — 원장 V-f490e0bf ASIS / 원장 V-d3701b63 ASIS / 원장 V-56741ed5 ASIS / 원장 V-8f14eaea ASIS / 원장 V-cc1007e2 ASIS / 원장 V-b837ab01  |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0350 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-9a53e0c2 ASIS / 원장 V-42db4c28 ASIS / 원장 V-3d6e261b ASIS / 원장 V-3a9363f5 ASIS / 원장 V-78efd38f ASIS / 원장 V-479b6a5a  |  | 18 (D00-4d-003 ACT:SSP0023_ShipmentPlanElect) |
| WK-SSP0023-0351 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-9a53e0c2 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0352 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-42db4c28 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0353 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-3d6e261b |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0354 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-3a9363f5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0355 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-78efd38f |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0356 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-479b6a5a |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0357 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-d6136f80 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0358 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-96490279 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0359 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-035719c6 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0360 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-46043787 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0361 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-211eeb65 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0362 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-51c2f3f7 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0363 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-04c4c3ba |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0364 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-7ccdde99 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0365 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-08e4bd28 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0366 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-acc418ca |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0367 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-c9a2fdb6 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0368 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-2702ebb9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0369 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-b1c1f5bc |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0370 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-fb479fd9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0371 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-56db78a9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0372 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-07f621bf |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0373 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-f490e0bf |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0374 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-d3701b63 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0375 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-56741ed5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0376 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-8f14eaea |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0377 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-cc1007e2 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0378 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-b837ab01 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0379 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-ff582b11 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0380 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-890ff252 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0381 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-ac98085e |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0382 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-09f41a75 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0383 | C6 | ERP_SO_NO / SO No | 하네스·환경 | C6 도구 오류 — 실측[T-abbaf3e9]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 16 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0384 | C6 | FACTORY_ID / Building Desc. | 하네스·환경 | C6 도구 오류 — 원장 V-56741ed5 ASIS / 원장 V-8f14eaea ASIS / 원장 V-cc1007e2 ASIS / 원장 V-b837ab01 ASIS / 실측[T-1cfb12f0]: [측정 경로 없음] 조회 후 Ins |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0385 | C6 | JR_BOH_QTY / J/R | 하네스·환경 | C6 도구 오류 — 실측[T-eedc9171]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0386 | C6 | JR_BOH_QTY_CELL / J/R | 하네스·환경 | C6 도구 오류 — 실측[T-36ae17d5]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0387 | C6 | JR_BOH_QTY_PCM / J/R | 하네스·환경 | C6 도구 오류 — 실측[T-a78737eb]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0388 | C6 | NEW_ROUTE_ID / Route | 하네스·환경 | C6 도구 오류 — 실측[T-0c247b9f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0389 | C6 | NEW_SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-cad9ebde |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0390 | C6 | NEW_SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-7bd42e95 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0391 | C6 | PACKAGE_TYPE / Package Type  | 하네스·환경 | C6 도구 오류 — 원장 V-cc1007e2 ASIS / 원장 V-b837ab01 ASIS / 실측[T-bebf7d87]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0392 | C6 | PC_BOH_QTY / Pancake | 하네스·환경 | C6 도구 오류 — 실측[T-cd91b116]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0393 | C6 | PC_BOH_QTY_CELL / Pancake | 하네스·환경 | C6 도구 오류 — 실측[T-a5aef7c9]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0394 | C6 | PC_BOH_QTY_PCM / Pancake | 하네스·환경 | C6 도구 오류 — 실측[T-e13727f3]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0395 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-2d402356 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0396 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-641a48c6 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0397 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-d0dcb421 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0398 | C6 | SSP0023_ShipmentPlanElectrode.SpdDetail_ | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.SpdDetail_ActiveSheetChanged 의 C6 65요소: ERROR:65 |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0399 | C6 | SSP0023_ShipmentPlanElectrode.cboBucketT | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.cboBucketType_SelectedIndexChanged 의 C6 65요소: ERROR:65 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.cboBuc) |
| WK-SSP0023-0400 | C6 | SSP0023_ShipmentPlanElectrode.cboPlanDat | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.cboPlanDate_SelectedIndexChanged 의 C6 65요소: ERROR:65 |  | 18 (ACT:SSP0023_ShipmentPlanElectrode.cboPla) |
| WK-SSP0023-0401 | C6 | SSP0023_ShipmentPlanElectrode.chkPastPer | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.chkPastPeriod_CheckedChanged 의 C6 65요소: ERROR:65 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.chkPas) |
| WK-SSP0023-0402 | C6 | SSP0023_ShipmentPlanElectrode.chkSum_Che | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.chkSum_CheckedChanged 의 C6 65요소: ERROR:65 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.chkSum) |
| WK-SSP0023-0403 | C6 | SSP0023_ShipmentPlanElectrode.clbCompany | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.clbCompanyID_SelectedIndexChanged 의 C6 65요소: ERROR:65 |  | 10 (ACT:SSP0023_ShipmentPlanElectrode.clbCom) |
| WK-SSP0023-0404 | C6 | SSP0023_ShipmentPlanElectrode.clbDivisio | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.clbDivision_ID_SelectedIndexChanged 의 C6 1요소: ERROR:1 |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.clbDiv) |
| WK-SSP0023-0405 | C6 | SSP0023_ShipmentPlanElectrode.rdButton_C | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.rdButton_Changed 의 C6 9요소: ERROR:9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0406 | C6 | TOT_BOH_QTY / BOH | 하네스·환경 | C6 도구 오류 — 실측[T-2260d54a]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0407 | C6 | TOT_BOH_QTY_CELL / BOH | 하네스·환경 | C6 도구 오류 — 실측[T-e22ee7bf]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0408 | C6 | TOT_BOH_QTY_PCM / BOH | 하네스·환경 | C6 도구 오류 — 실측[T-4a998b98]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0409 | C6 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C6 도구 오류 — 원장 V-9a53e0c2 ASIS / 원장 V-42db4c28 ASIS / 원장 V-2eec4d65 ASIS / 원장 V-2d402356 ASIS / 원장 V-3d6e261b ASIS / 원장 V-641a48c6  |  | 68 (D00-2-022 D00-4d-003 ACT:SSP0023_Shipmen) |
| WK-SSP0023-0410 | C6 | siDetail.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-2eec4d65 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0411 | B1 | FACTORY_ID / Building Desc. | 하네스·환경 | B1 도구 오류 — 원장 V-262162bb COLUMN |  | 2 (cellType(1) ACT:SSP0023_ShipmentPlanElec) |
| WK-SSP0023-0412 | B2 | FACTORY_ID / Building Desc. | 하네스·환경 | B2 도구 오류 — 원장 V-2aa98662 COLUMN |  | 2 (cellType(1) ACT:SSP0023_ShipmentPlanElec) |
| WK-SSP0023-0413 | B3 | DIVISION_ID / Div | 하네스·환경 | B3 도구 오류 — 원장 V-8823bfcd COLUMN |  | 8 (ACT:SSP0023_ShipmentPlanElectrode.GetERP) |
| WK-SSP0023-0414 | B3 | SSP0023_ShipmentPlanElectrode.GetBucketT | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetBucketType 의 B3 10요소: NA:8 · NOPATH:1 · ERROR:1 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.GetBuc) |
| WK-SSP0023-0415 | B3 | SSP0023_ShipmentPlanElectrode.GetERPInte | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetERPInterface 의 B3 7요소: NA:6 · ERROR:1 |  | 87 (ACT:SSP0023_ShipmentPlanElectrode.GetERP) |
| WK-SSP0023-0416 | B3 | SSP0023_ShipmentPlanElectrode.GetErpIFCh | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetErpIFCheckNew 의 B3 10요소: NA:8 · NOPATH:1 · ERROR:1 |  | 43 (ACT:SSP0023_ShipmentPlanElectrode.GetErp) |
| WK-SSP0023-0417 | B3 | SSP0023_ShipmentPlanElectrode.GetErpSoNo | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetErpSoNoCnt 의 B3 10요소: NA:8 · NOPATH:1 · ERROR:1 |  | 9 (ACT:SSP0023_ShipmentPlanElectrode.GetErp) |
| WK-SSP0023-0418 | B3 | SSP0023_ShipmentPlanElectrode.GetSSPUser | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetSSPUserCheck 의 B3 10요소: NA:8 · NOPATH:1 · ERROR:1 |  | 9 (ACT:SSP0023_ShipmentPlanElectrode.GetSSP) |
| WK-SSP0023-0419 | B4 | DIVISION_ID / Div | 하네스·환경 | B4 도구 오류 — 원장 V-38915aa4 COLUMN |  | 8 (ACT:SSP0023_ShipmentPlanElectrode.GetERP) |
| WK-SSP0023-0420 | B4 | FACTORY_ID / Building Desc. | 하네스·환경 | B4 도구 오류 — 원장 V-9636ef0b COLUMN |  | 2 (cellType(1) ACT:SSP0023_ShipmentPlanElec) |
| WK-SSP0023-0421 | B4 | SSP0023_ShipmentPlanElectrode.GetBucketT | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetBucketType 의 B4 18요소: NA:10 · ERROR:6 · PASS:1 · NOPATH:1 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.GetBuc) |
| WK-SSP0023-0422 | B4 | SSP0023_ShipmentPlanElectrode.GetERPInte | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetERPInterface 의 B4 7요소: NA:6 · ERROR:1 |  | 87 (ACT:SSP0023_ShipmentPlanElectrode.GetERP) |
| WK-SSP0023-0423 | B4 | SSP0023_ShipmentPlanElectrode.GetErpIFCh | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetErpIFCheckNew 의 B4 18요소: NA:10 · ERROR:6 · PASS:1 · NOPATH:1 |  | 43 (ACT:SSP0023_ShipmentPlanElectrode.GetErp) |
| WK-SSP0023-0424 | B4 | SSP0023_ShipmentPlanElectrode.GetErpSoNo | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetErpSoNoCnt 의 B4 18요소: NA:10 · ERROR:6 · PASS:1 · NOPATH:1 |  | 9 (ACT:SSP0023_ShipmentPlanElectrode.GetErp) |
| WK-SSP0023-0425 | B4 | SSP0023_ShipmentPlanElectrode.GetSSPUser | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetSSPUserCheck 의 B4 18요소: NA:10 · ERROR:6 · PASS:1 · NOPATH:1 |  | 9 (ACT:SSP0023_ShipmentPlanElectrode.GetSSP) |
| WK-SSP0023-0426 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스·환경 | B4 도구 오류 — 원장 V-2916057c SEARCH |  | 1 (D00-1-011) |
| WK-SSP0023-0427 | B4 | clbCompany_ID / Company / Company_ID | 하네스·환경 | B4 도구 오류 — 원장 V-a78a685a SEARCH |  | 1 (D00-1-018) |
| WK-SSP0023-0428 | B4 | clbDivision_ID / Division / Division_ID  | 하네스·환경 | B4 도구 오류 — 원장 V-ac1c2e58 SEARCH |  | 1 (D00-1-019) |
| WK-SSP0023-0429 | B4 | clbFromSite / From Site | 하네스·환경 | B4 도구 오류 — 원장 V-4f928712 SEARCH |  | 1 (D00-1-020) |
| WK-SSP0023-0430 | K4 | SSP0023 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-8c94e7db GENERAL / 원장 V-1b84cadf GENERAL / 원장 V-fffbbfc3 GENERAL / 원장 V-cdf68a92 GENERAL / 원장 V-89836ac9 GENERAL / |  | 126 (COMMON:UC-02 COMMON:UC-03 COMMON:UC-04 A) |
| WK-SSP0023-0431 | F1 | SSP0023 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-be335b82 RULE_SCREEN / 원장 V-9aa2a938 RULE_SCREEN / 원장 V-5e3f438a RULE_SCREEN / 원장 V-6532b2f3 RULE_SCREEN / 원장 V-56 |  | 278 (D00-1-009 D00-2-006 D00-2-007 CRUD:EP03:) |
| WK-SSP0023-0432 | F2 | SSP0023 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-e1d201c9 RULE_SCREEN / 원장 V-aa248b95 RULE_SCREEN / 원장 V-6b7f2b94 GENERAL / 원장 V-75c3f6cf GENERAL / 원장 V-1cc12b6c G |  | 276 (D00-1-009 D00-2-006 CRUD:EP03:SAVE COMMO) |
| WK-SSP0023-0433 | F3 | SSP0023 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-223aa1f7 RULE_SCREEN / 원장 V-1c4cd213 RULE_SCREEN / 원장 V-c70100df GENERAL / 원장 V-cb9f54dc GENERAL / 원장 V-85e8776c G |  | 148 (D00-2-021 D00-2-026 D00-2-027 D00-4d-005) |
| WK-SSP0023-0434 | F5 | SSP0023 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-a55c4455 RULE_SCREEN / 원장 V-10099985 RULE_SCREEN / 원장 V-56d8a971 RULE_SCREEN / 원장 V-bd223c30 DEFECT / 원장 V-6911143 |  | 1 (DeleteButton(Delete)) |
| WK-SSP0023-0435 | F6 | SSP0023 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-b518546b RULE_SCREEN / 원장 V-8074f525 RULE_SCREEN / 원장 V-6e12331e RULE_SCREEN / 원장 V-6142076f RULE_SCREEN / 원장 V-7b |  | 268 (D00-2-007 SSP0023_SAVE_SHIPMENT_PLAN_SIM) |
| WK-SSP0023-0436 | F4 | DMF0002_GET_TITLESET_POPUP | 하네스·환경 | F4 도구 오류 — 실측[T-809e591e]: DMF0002_GET_TITLESET_POPUP: DMF0003/titleSet/SEARCH, DMF0003_01/titleSet/SEARCH, DMF0020/titleSet/SEARC |  | 1 (MODAL:MeasureSelectModal) |
| WK-SSP0023-0437 | F4 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | 하네스·환경 | F4 도구 오류 — 실측[T-95caffd1]: PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST: SSP0015/main/USER_CHECK, SSP0021/main/USER_CHECK, SSP0022/mai |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.GetSSP) |
| WK-SSP0023-0438 | F4 | PKG_SSP0023.P_SSP0023_GET_ERP_SO_NO_CNT | 하네스·환경 | F4 도구 오류 — 실측[T-253f0aea]: PKG_SSP0023.P_SSP0023_GET_ERP_SO_NO_CNT: SSP0023/main/GET_ERP_SO_NO_CNT — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회  |  | 269 (ACT:SSP0023_ShipmentPlanElectrode.GetERP) |
| WK-SSP0023-0439 | F4 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 하네스·환경 | F4 도구 오류 — 실측[T-b1bf9669]: PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_DETAIL: SSP0023/main/GET_SHIPMENT_PLAN_DETAIL, SSP0023/planDeta |  | 381 (SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17) A) |
| WK-SSP0023-0440 | F4 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 하네스·환경 | F4 도구 오류 — 실측[T-27a47252]: PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL: SSP0023/excel/SEARCH, SSP0023/main/GET_SHIPMENT_P |  | 80 (SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(S) |
| WK-SSP0023-0441 | F4 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 하네스·환경 | F4 도구 오류 — 실측[T-92e7a40a]: PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_RESULT: SSP0023/main/GET_SHIPMENT_PLAN_RESULT, SSP0023/shipment |  | 63 (SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19) A) |
| WK-SSP0023-0442 | F4 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 하네스·환경 | F4 도구 오류 — 실측[T-6e69c28c]: PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL: SSP0023/main/GET_SHIPMENT_PLAN_STOCK_DETAIL, SSP0 |  | 59 (SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S) |
| WK-SSP0023-0443 | F4 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_STATU | 하네스·환경 | F4 도구 오류 — 실측[T-8b3eda9c]: PKG_SSP0023.P_SSP0023_GET_SHIPMENT_STATUS: SSP0023/main/GET_SHIPMENT_STATUS — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 |  | 269 (ACT:SSP0023_ShipmentPlanElectrode.GetERP) |
| WK-SSP0023-0444 | F4 | P_SSP0023_GET_DETAIL_EXCEL | 하네스·환경 | F4 도구 오류 — 실측[T-36e58f95]: P_SSP0023_GET_DETAIL_EXCEL: SSP0023/excel/SEARCH, SSP0023/main/UPLOAD — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(S) |
| WK-SSP0023-0445 | F4 | P_SSP0023_GET_PLAN_DETAIL | 하네스·환경 | F4 도구 오류 — 실측[T-2f1cc5b1]: P_SSP0023_GET_PLAN_DETAIL: SSP0023/main/GET_SHIPMENT_PLAN_DETAIL, SSP0023/planDetail/SEARCH — 화면 진입·조회  |  | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17)) |
| WK-SSP0023-0446 | F4 | P_SSP0023_GET_RESULT | 하네스·환경 | F4 도구 오류 — 실측[T-a6baee6b]: P_SSP0023_GET_RESULT: SSP0023/main/GET_SHIPMENT_PLAN_RESULT, SSP0023/shipmentResult/SEARCH — 화면 진입·조회 중 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19)) |
| WK-SSP0023-0447 | F4 | P_SSP0023_GET_STOCK_DETAIL | 하네스·환경 | F4 도구 오류 — 실측[T-9976ab9d]: P_SSP0023_GET_STOCK_DETAIL: SSP0023/main/GET_SHIPMENT_PLAN_STOCK_DETAIL, SSP0023/stockDetail/SEARCH — 화 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S) |
| WK-SSP0023-0448 | F4 | SSP0023_ShipmentPlanElectrode.ChkConfirm | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.ChkConfirmChangeTime 의 F4 28요소: ERROR:12 · NA:7 · REVIEW:5 · PASS:4 · FAIL 요 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.ChkCon) |
| WK-SSP0023-0449 | F4 | SSP0023_ShipmentPlanElectrode.GetErpIFCh | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.GetErpIFCheckNew 의 F4 28요소: ERROR:12 · NA:7 · REVIEW:5 · PASS:4 · FAIL 요소: P |  | 6 (ACT:SSP0023_ShipmentPlanElectrode.GetErp) |
| WK-SSP0023-0450 | F4 | chkMyModel/PartLeader/TeamLeader/Delegat | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 chkMyModel/PartLeader/TeamLeader/DelegateeModel(C12~14/17) '(검색 파라미터 — 미노출)' 의 F4 28요소: ERROR:12 · NA:7 · RE |  | 1 (chkMyModel/PartLeader/TeamLeader/Delegat) |
| WK-SSP0023-0451 | A5 | D00-1-068 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-068 '§1 spdDetail / FpSpread' 의 A5 40요소: ERROR:36 · PASS:4 |  | 1 (D00-1-068) |
| WK-SSP0023-0452 | A5 | D00-1-069 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-069 '§1 spdDetail_Sheet1 / SheetView' 의 A5 40요소: ERROR:36 · PASS:4 |  | 1 (D00-1-069) |
| WK-SSP0023-0453 | A5 | D00-1-070 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-070 '§1 spdMain / FpSpread' 의 A5 40요소: ERROR:36 · PASS:4 |  | 1 (D00-1-070) |
| WK-SSP0023-0454 | A5 | D00-1-071 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-071 '§1 spdMain_Sheet1 / SheetView' 의 A5 40요소: ERROR:36 · PASS:4 |  | 1 (D00-1-071) |
| WK-SSP0023-0455 | A5 | D00-2-010 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-2-010 '§2 chkPastPeriod / CheckedChanged' 의 A5 40요소: ERROR:36 · PASS:4 |  | 1 (D00-2-010) |
| WK-SSP0023-0456 | A5 | D00-4d-006 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-4d-006 '§4d SpdDetail_ClipboardPasted / ActiveSheet == sht' 의 A5 40요소: ERROR:36 · PASS:4 |  | 1 (D00-4d-006) |
| WK-SSP0023-0457 | A5 | D00-4d-011 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-4d-011 '§4d SpdDetail_EditChange / ActiveSheet == shtPlanD' 의 A5 40요소: ERROR:36 · PASS:4 |  | 1 (D00-4d-011) |
| WK-SSP0023-0458 | A5 | D00-4d-024 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-4d-024 '§4d shtPlanDetail_Change / siDetail.RowCount == 0' 의 A5 40요소: ERROR:36 · PASS:4 |  | 1 (D00-4d-024) |
| WK-SSP0023-0459 | A5 | JR_BOH_QTY | 하네스·환경 | A5 도구 오류 — 원장 V-f78b7b06 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0460 | A5 | JR_BOH_QTY | 하네스·환경 | A5 도구 오류 — 원장 V-e4e0782c |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0461 | A5 | JR_BOH_QTY | 하네스·환경 | A5 도구 오류 — 원장 V-6e9ebe68 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0462 | A5 | JR_BOH_QTY / J/R | 하네스·환경 | A5 도구 오류 — 원장 V-f78b7b06 ASIS / 원장 V-e4e0782c ASIS / 원장 V-6e9ebe68 ASIS / E2E smoke columns / 실측[T-07b7361a]: JR_BOH_QTY: AS-IS(Di |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0463 | A5 | JR_BOH_QTY_CELL | 하네스·환경 | A5 도구 오류 — 원장 V-e8d82399 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0464 | A5 | JR_BOH_QTY_CELL | 하네스·환경 | A5 도구 오류 — 원장 V-1e6f6992 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0465 | A5 | JR_BOH_QTY_CELL | 하네스·환경 | A5 도구 오류 — 원장 V-774d99e3 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0466 | A5 | JR_BOH_QTY_CELL / J/R | 하네스·환경 | A5 도구 오류 — 원장 V-e8d82399 ASIS / 원장 V-1e6f6992 ASIS / 원장 V-774d99e3 ASIS / E2E smoke columns / 실측[T-180bebab]: JR_BOH_QTY_CELL: AS- |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0467 | A5 | JR_BOH_QTY_PCM | 하네스·환경 | A5 도구 오류 — 원장 V-18c754b2 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0468 | A5 | JR_BOH_QTY_PCM | 하네스·환경 | A5 도구 오류 — 원장 V-f156e7ee |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0469 | A5 | JR_BOH_QTY_PCM | 하네스·환경 | A5 도구 오류 — 원장 V-83799393 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0470 | A5 | JR_BOH_QTY_PCM / J/R | 하네스·환경 | A5 도구 오류 — 원장 V-18c754b2 ASIS / 원장 V-f156e7ee ASIS / 원장 V-83799393 ASIS / E2E smoke columns / 실측[T-f73ad382]: JR_BOH_QTY_PCM: AS-I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0471 | A5 | PC_BOH_QTY | 하네스·환경 | A5 도구 오류 — 원장 V-ceffebc5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0472 | A5 | PC_BOH_QTY | 하네스·환경 | A5 도구 오류 — 원장 V-623c55bd |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0473 | A5 | PC_BOH_QTY | 하네스·환경 | A5 도구 오류 — 원장 V-282a33dd |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0474 | A5 | PC_BOH_QTY / Pancake | 하네스·환경 | A5 도구 오류 — 원장 V-ceffebc5 ASIS / 원장 V-623c55bd ASIS / 원장 V-282a33dd ASIS / E2E smoke columns / 실측[T-c6794c49]: PC_BOH_QTY: AS-IS(Di |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0475 | A5 | PC_BOH_QTY_CELL | 하네스·환경 | A5 도구 오류 — 원장 V-9f7d9a5f |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0476 | A5 | PC_BOH_QTY_CELL | 하네스·환경 | A5 도구 오류 — 원장 V-9d883938 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0477 | A5 | PC_BOH_QTY_CELL | 하네스·환경 | A5 도구 오류 — 원장 V-c26848f9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0478 | A5 | PC_BOH_QTY_CELL / Pancake | 하네스·환경 | A5 도구 오류 — 원장 V-9f7d9a5f ASIS / 원장 V-9d883938 ASIS / 원장 V-c26848f9 ASIS / E2E smoke columns / 실측[T-c8043704]: PC_BOH_QTY_CELL: AS- |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0479 | A5 | PC_BOH_QTY_PCM | 하네스·환경 | A5 도구 오류 — 원장 V-046200df |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0480 | A5 | PC_BOH_QTY_PCM | 하네스·환경 | A5 도구 오류 — 원장 V-b615438e |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0481 | A5 | PC_BOH_QTY_PCM | 하네스·환경 | A5 도구 오류 — 원장 V-17521d7f |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0482 | A5 | PC_BOH_QTY_PCM / Pancake | 하네스·환경 | A5 도구 오류 — 원장 V-046200df ASIS / 원장 V-b615438e ASIS / 원장 V-17521d7f ASIS / E2E smoke columns / 실측[T-51514f48]: PC_BOH_QTY_PCM: AS-I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0483 | A5 | TOT_BOH_QTY | 하네스·환경 | A5 도구 오류 — 원장 V-41a04065 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0484 | A5 | TOT_BOH_QTY | 하네스·환경 | A5 도구 오류 — 원장 V-7f3d96e4 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0485 | A5 | TOT_BOH_QTY | 하네스·환경 | A5 도구 오류 — 원장 V-31162b51 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0486 | A5 | TOT_BOH_QTY / BOH | 하네스·환경 | A5 도구 오류 — 원장 V-41a04065 ASIS / 원장 V-7f3d96e4 ASIS / 원장 V-31162b51 ASIS / E2E smoke columns / 실측[T-4dcef101]: TOT_BOH_QTY: AS-IS(D |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0487 | A5 | TOT_BOH_QTY_CELL | 하네스·환경 | A5 도구 오류 — 원장 V-beccc3dc |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0488 | A5 | TOT_BOH_QTY_CELL | 하네스·환경 | A5 도구 오류 — 원장 V-011c4e63 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0489 | A5 | TOT_BOH_QTY_CELL | 하네스·환경 | A5 도구 오류 — 원장 V-c2737279 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0490 | A5 | TOT_BOH_QTY_CELL / BOH | 하네스·환경 | A5 도구 오류 — 원장 V-beccc3dc ASIS / 원장 V-011c4e63 ASIS / 원장 V-c2737279 ASIS / E2E smoke columns / 실측[T-c490a279]: TOT_BOH_QTY_CELL: AS |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0491 | A5 | TOT_BOH_QTY_PCM | 하네스·환경 | A5 도구 오류 — 원장 V-9eadf8e9 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0492 | A5 | TOT_BOH_QTY_PCM | 하네스·환경 | A5 도구 오류 — 원장 V-074ae418 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0493 | A5 | TOT_BOH_QTY_PCM | 하네스·환경 | A5 도구 오류 — 원장 V-064fa7df |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0494 | A5 | TOT_BOH_QTY_PCM / BOH | 하네스·환경 | A5 도구 오류 — 원장 V-9eadf8e9 ASIS / 원장 V-074ae418 ASIS / 원장 V-064fa7df ASIS / E2E smoke columns / 실측[T-e5ba41b8]: TOT_BOH_QTY_PCM: AS- |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0495 | A5 | cboBucketType(C10) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 cboBucketType(C10) 'Form Bucket select(BUCKET_TYPE)' 의 A5 40요소: ERROR:36 · PASS:4 |  | 1 (cboBucketType(C10)) |
| WK-SSP0023-0496 | A5 | layoutControlGroup3(상세 조건, 활성시트별) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 layoutControlGroup3(상세 조건, 활성시트별) 'ShipmentPlanElectrodeDetailBar(detailFieldSet)' 의 A5 40요소: ERROR:36 · PAS |  | 1 (layoutControlGroup3(상세 조건, 활성시트별)) |
| WK-SSP0023-0497 | A5 | spdDetail 3시트(PlanDetail/Stock/Result) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 spdDetail 3시트(PlanDetail/Stock/Result) 'ShipmentPlanElectrodeDetailGrid(TabWrapper)' 의 A5 40요소: ERROR:36 · P |  | 1 (spdDetail 3시트(PlanDetail/Stock/Result)) |
| WK-SSP0023-0498 | H2 | CHANGE_REASON_CODE | 하네스·환경 | H2 도구 오류 — 원장 V-02cc2f42 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0499 | H2 | CHANGE_REASON_CODE | 하네스·환경 | H2 도구 오류 — 원장 V-eff0beca |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0500 | H2 | D00-1-068 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-068 '§1 spdDetail / FpSpread' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (D00-1-068) |
| WK-SSP0023-0501 | H2 | D00-1-069 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-069 '§1 spdDetail_Sheet1 / SheetView' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (D00-1-069) |
| WK-SSP0023-0502 | H2 | D00-1-070 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-070 '§1 spdMain / FpSpread' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (D00-1-070) |
| WK-SSP0023-0503 | H2 | D00-1-071 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-071 '§1 spdMain_Sheet1 / SheetView' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (D00-1-071) |
| WK-SSP0023-0504 | H2 | D00-4d-006 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-4d-006 '§4d SpdDetail_ClipboardPasted / ActiveSheet == sht' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (D00-4d-006) |
| WK-SSP0023-0505 | H2 | D00-4d-011 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-4d-011 '§4d SpdDetail_EditChange / ActiveSheet == shtPlanD' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (D00-4d-011) |
| WK-SSP0023-0506 | H2 | D00-4d-024 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-4d-024 '§4d shtPlanDetail_Change / siDetail.RowCount == 0' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (D00-4d-024) |
| WK-SSP0023-0507 | H2 | ERP_SO_NO | 하네스·환경 | H2 도구 오류 — 원장 V-476008aa |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0508 | H2 | ERP_SO_NO / SO No | 하네스·환경 | H2 도구 오류 — 원장 V-a5fe3a15 COLUMN / 원장 V-86776d64 COLUMN / 원장 V-476008aa ASIS / 실측[T-8cb8118e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 —  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0509 | H2 | FACTORY_ID / Building Desc. | 하네스·환경 | H2 도구 오류 — 원장 V-6b7986cb COLUMN / 원장 V-449ccd17 ASIS / 원장 V-a911c76e ASIS / 실측[T-71c298a3]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0510 | H2 | FindButton(Search) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 FindButton(Search) 'hotkeyConfig.search=handleSearch' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (FindButton(Search)) |
| WK-SSP0023-0511 | H2 | PACKAGE_TYPE / Package Type  | 하네스·환경 | H2 도구 오류 — 원장 V-a708c530 COLUMN / 원장 V-cacefdca ASIS / 원장 V-08d75cf8 ASIS / 실측[T-1a8bb0ff]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0512 | H2 | REMARKS / Remarks | 하네스·환경 | H2 도구 오류 — 원장 V-a419767c COLUMN / 원장 V-02cc2f42 ASIS / 원장 V-eff0beca ASIS / 원장 V-dcf9b62f ASIS / 원장 V-3d6f6705 ASIS / 실측[T-48e09f3 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0513 | H2 | REMARKS2 / Shipment No. | 하네스·환경 | H2 도구 오류 — 원장 V-2f523f31 COLUMN / 원장 V-24a87ee1 ASIS / 원장 V-2edb9d48 ASIS / 실측[T-01ee8bb9]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0514 | H2 | SHIPMENT_CONFIRM_QTY / Confirm Qty | 하네스·환경 | H2 도구 오류 — 원장 V-02390f0e COLUMN / 원장 V-30035cc7 ASIS / 원장 V-8ec6c834 ASIS / 원장 V-02cc2f42 ASIS / 원장 V-eff0beca ASIS / 원장 V-ca0e656 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0515 | H2 | SHIPMENT_DATE | 하네스·환경 | H2 도구 오류 — 원장 V-e129faf5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0516 | H2 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | H2 도구 오류 — 원장 V-d1ef5448 COLUMN / 원장 V-30035cc7 ASIS / 원장 V-8ec6c834 ASIS / 원장 V-e129faf5 ASIS / 원장 V-02cc2f42 ASIS / 원장 V-eff0bec |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0517 | H2 | SSP0023_ShipmentPlanElectrode.CreateSpre | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.CreateSpread 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 22 (ACT:SSP0023_ShipmentPlanElectrode.Create) |
| WK-SSP0023-0518 | H2 | TOT_BOH_QTY_PCM / BOH | 하네스·환경 | H2 도구 오류 — 원장 V-b449dc67 COLUMN / 실측[T-c889cf8d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetai |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0519 | H2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | H2 도구 오류 — 원장 V-9bde0f4b COLUMN / 원장 V-c9e95618 COLUMN / 원장 V-30035cc7 ASIS / 원장 V-8ec6c834 ASIS / 원장 V-e129faf5 ASIS / 원장 V-02cc2 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0520 | H2 | cboBucketType(C10) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 cboBucketType(C10) 'Form Bucket select(BUCKET_TYPE)' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (cboBucketType(C10)) |
| WK-SSP0023-0521 | H2 | chkMyModel/PartLeader/TeamLeader/Delegat | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 chkMyModel/PartLeader/TeamLeader/DelegateeModel(C12~14/17) '(검색 파라미터 — 미노출)' 의 H2 49요소: ERROR:37 · NA:11 · P |  | 1 (chkMyModel/PartLeader/TeamLeader/Delegat) |
| WK-SSP0023-0522 | H2 | color(36) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 color(36) 'MainGrid formatItem(변경셀 Red/불일치 LightPink/과거 회색/주말' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (color(36)) |
| WK-SSP0023-0523 | H2 | layoutControlGroup3(상세 조건, 활성시트별) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 layoutControlGroup3(상세 조건, 활성시트별) 'ShipmentPlanElectrodeDetailBar(detailFieldSet)' 의 H2 49요소: ERROR:37 · NA: |  | 1 (layoutControlGroup3(상세 조건, 활성시트별)) |
| WK-SSP0023-0524 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-ca0e6561 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0525 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-76d382ab |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0526 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-3a6a0e5a |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0527 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-21aba8c1 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0528 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-449ccd17 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0529 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-a911c76e |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0530 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-cacefdca |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0531 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-08d75cf8 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0532 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-dcf9b62f |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0533 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-3d6f6705 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0534 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-24a87ee1 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0535 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-2edb9d48 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0536 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-753b3ecd |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0537 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-73af0ccd |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0538 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-f09047b3 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0539 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-5abad7c5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0540 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-4ad03d74 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0541 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-0163e6de |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0542 | H2 | siDetail.ActiveSheet.Cells[iRow, siDetai | 하네스·환경 | H2 도구 오류 — 원장 V-30035cc7 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0543 | H2 | siDetail.ActiveSheet.Cells[iRow, siDetai | 하네스·환경 | H2 도구 오류 — 원장 V-8ec6c834 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0544 | H2 | siMain.ActiveSheet.Cells[iRow, iCol].For | 하네스·환경 | H2 도구 오류 — 원장 V-602b077c |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0545 | H2 | siMain.SetBGColor2 | 하네스·환경 | H2 도구 오류 — 원장 V-7111f06a |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Re_Des) |
| WK-SSP0023-0546 | H2 | siMain.SpreadObject.SetViewportLeftColum | 하네스·환경 | H2 도구 오류 — 원장 V-1c9d8e8e |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0547 | H2 | siMain.SpreadObject.SetViewportTopRow | 하네스·환경 | H2 도구 오류 — 원장 V-2038c232 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0548 | H2 | spdDetail 3시트(PlanDetail/Stock/Result) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 spdDetail 3시트(PlanDetail/Stock/Result) 'ShipmentPlanElectrodeDetailGrid(TabWrapper)' 의 H2 49요소: ERROR:37 · N |  | 1 (spdDetail 3시트(PlanDetail/Stock/Result)) |
| WK-SSP0023-0549 | H2 | txtModelId/textNickName/txtItemId 등 텍스트 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 txtModelId/textNickName/txtItemId 등 텍스트 '(검색 필터 텍스트 — 미노출)' 의 H2 49요소: ERROR:37 · NA:11 · PASS:1 |  | 1 (txtModelId/textNickName/txtItemId 등 텍스트) |
| WK-SSP0023-0550 | H2 | usrConditionPanel1(접이식 검색) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 usrConditionPanel1(접이식 검색) 'ShipmentPlanElectrodeForm + SearchArea(openSearchA' 의 H2 49요소: ERROR:37 · NA:11  |  | 1 (usrConditionPanel1(접이식 검색)) |
| WK-SSP0023-0551 | H4 | SSP0023 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-dba3bdd6 RULE_SCREEN / 원장 V-bbf0a17e RULE_SCREEN / 원장 V-69244512 RULE_SCREEN / 원장 V-164c9081 RULE_SCREEN / 원장 V-64 |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0552 | H5 | D00-1-068 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-068 '§1 spdDetail / FpSpread' 의 H5 14요소: NA:9 · PASS:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-068) |
| WK-SSP0023-0553 | H5 | D00-1-069 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-069 '§1 spdDetail_Sheet1 / SheetView' 의 H5 14요소: NA:9 · PASS:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-069) |
| WK-SSP0023-0554 | H5 | D00-1-070 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-070 '§1 spdMain / FpSpread' 의 H5 14요소: NA:9 · PASS:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-070) |
| WK-SSP0023-0555 | H5 | D00-1-071 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-071 '§1 spdMain_Sheet1 / SheetView' 의 H5 14요소: NA:9 · PASS:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-071) |
| WK-SSP0023-0556 | H5 | D00-4d-006 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-4d-006 '§4d SpdDetail_ClipboardPasted / ActiveSheet == sht' 의 H5 14요소: NA:9 · PASS:4 · NOT_RUN:1 (미실행 요소 |  | 1 (D00-4d-006) |
| WK-SSP0023-0557 | H5 | D00-4d-011 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-4d-011 '§4d SpdDetail_EditChange / ActiveSheet == shtPlanD' 의 H5 14요소: NA:9 · PASS:4 · NOT_RUN:1 (미실행 요소 |  | 1 (D00-4d-011) |
| WK-SSP0023-0558 | H5 | D00-4d-024 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-4d-024 '§4d shtPlanDetail_Change / siDetail.RowCount == 0' 의 H5 14요소: NA:9 · PASS:4 · NOT_RUN:1 (미실행 요소가 |  | 1 (D00-4d-024) |
| WK-SSP0023-0559 | H5 | SSP0023_ShipmentPlanElectrode.CreateSpre | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.CreateSpread 의 H5 14요소: NA:9 · PASS:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SSP0023_ShipmentPlanElectrode.Create) |
| WK-SSP0023-0560 | H5 | SSP0023_ShipmentPlanElectrode.SetSpreadC | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.SetSpreadColumn 의 H5 5요소: PASS:3 · NA:1 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0023_ShipmentPlanElectrode.SetSpr) |
| WK-SSP0023-0561 | H5 | layoutControlGroup3(상세 조건, 활성시트별) | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 layoutControlGroup3(상세 조건, 활성시트별) 'ShipmentPlanElectrodeDetailBar(detailFieldSet)' 의 H5 14요소: NA:9 · PASS:4  |  | 1 (layoutControlGroup3(상세 조건, 활성시트별)) |
| WK-SSP0023-0562 | H5 | spdDetail 3시트(PlanDetail/Stock/Result) | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 spdDetail 3시트(PlanDetail/Stock/Result) 'ShipmentPlanElectrodeDetailGrid(TabWrapper)' 의 H5 14요소: NA:9 · PASS: |  | 1 (spdDetail 3시트(PlanDetail/Stock/Result)) |
| WK-SSP0023-0563 | I1 | SSP0023 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-6bc3e9fa RULE_SCREEN / 원장 V-20462eb1 RULE_SCREEN / 원장 V-84724467 RULE_SCREEN / 원장 V-2940023d DEFECT / 원장 V-1617f7f |  | 54 (D00-4d-013 CRUD:EP02:SEARCH COMMON:UC-02) |
| WK-SSP0023-0564 | D1 | BACK_COLOR / Back Color | 하네스·환경 | D1 도구 오류 — 실측[T-1d6aea73]: BACK_COLOR AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0565 | D1 | CONFIRM_DAY / Confrim Day | 하네스·환경 | D1 도구 오류 — 실측[T-271ab74a]: CONFIRM_DAY AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0566 | D1 | CONFIRM_QTY_PANCAKE / Confirm Qty (Panca | 하네스·환경 | D1 도구 오류 — 원장 V-6428ddbf COLUMN / 원장 V-31785a7b COLUMN / 실측[T-e6eb2f18]: 기존행 r0 CONFIRM_QTY_PANCAKE: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0567 | D1 | CONFIRM_QTY_ROLL_LENGTH / Confirm Qty (C | 하네스·환경 | D1 도구 오류 — 원장 V-faf16b1c COLUMN / 원장 V-21d0136d COLUMN / 실측[T-27d69db2]: 기존행 r0 CONFIRM_QTY_ROLL_LENGTH: 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0568 | D1 | D00-2-026 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2-026 '§2 spdMain / Change' 의 D1 23요소: ERROR:17 · NA:6 |  | 1 (D00-2-026) |
| WK-SSP0023-0569 | D1 | D00-4d-010 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-010 '§4d SpdDetail_EditChange / siDetail.IsLock == fals' 의 D1 23요소: ERROR:17 · NA:6 |  | 1 (D00-4d-010) |
| WK-SSP0023-0570 | D1 | D00-4d-011 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-011 '§4d SpdDetail_EditChange / ActiveSheet == shtPlanD' 의 D1 23요소: ERROR:17 · NA:6 |  | 1 (D00-4d-011) |
| WK-SSP0023-0571 | D1 | D00-4d-023 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-023 '§4d shtPlanDetail_Change / CanModelChange != true ' 의 D1 23요소: ERROR:17 · NA:6 |  | 1 (D00-4d-023) |
| WK-SSP0023-0572 | D1 | D00-4d-025 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-025 '§4d shtPlanDetail_Change / siDetail.IsLock == fals' 의 D1 23요소: ERROR:17 · NA:6 |  | 1 (D00-4d-025) |
| WK-SSP0023-0573 | D1 | DAYOFWEEK_NAME / Day | 하네스·환경 | D1 도구 오류 — 원장 V-1445e346 COLUMN / 원장 V-ba677618 COLUMN / 실측[T-566cd8ee]: 기존행 r0 DAYOFWEEK_NAME: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0574 | D1 | DIVISION_ID / Div | 하네스·환경 | D1 도구 오류 — 원장 V-4c08fe1e COLUMN / 원장 V-a5fc2e61 COLUMN / 원장 V-b3330584 COLUMN / 원장 V-0773d7ba COLUMN / 원장 V-3437ee43 COLUMN / 원장 V |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0575 | D1 | ELECTRODE_POST_OPER / Post Oper. | 하네스·환경 | D1 도구 오류 — 원장 V-28be6c3a COLUMN / 원장 V-4c481020 COLUMN / 실측[T-6abc10cd]: 기존행 r0 ELECTRODE_POST_OPER: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0576 | D1 | EditButton(Edit) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 EditButton(Edit) "canEdit=hasButton('INSERT')\\" 의 D1 23요소: ERROR:17 · NA:6 |  | 1 (EditButton(Edit)) |
| WK-SSP0023-0577 | D1 | FROM_SITE / SCM Site | 하네스·환경 | D1 도구 오류 — 원장 V-c3cec1c3 COLUMN / 원장 V-b6d8778b COLUMN / 원장 V-eef899f8 COLUMN / 원장 V-b4752090 COLUMN / 원장 V-b5ccb90e COLUMN / 원장 V |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0578 | D1 | GAP / Gap | 하네스·환경 | D1 도구 오류 — 원장 V-2c17c21c COLUMN / 원장 V-697a99e1 COLUMN / 실측[T-59e54c83]: 기존행 r0 GAP: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0579 | D1 | GUBUN_NUM | 하네스·환경 | D1 도구 오류 — 실측[T-b916a03c]: GUBUN_NUM AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0580 | D1 | MEASURE / Measure | 하네스·환경 | D1 도구 오류 — 실측[T-dabf7a73]: 기존행 r0 MEASURE 편집=false — AS-IS 기대 미식별(edit_expect 'UNKNOWN') → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 9 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0581 | D1 | PACKAGE_QTY / Package Qty | 하네스·환경 | D1 도구 오류 — 원장 V-4102b077 COLUMN / 원장 V-848bf87a COLUMN / 실측[T-4234b4c6]: 기존행 r0 PACKAGE_QTY: 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0582 | D1 | SHIPMENT_STATUS / Status | 하네스·환경 | D1 도구 오류 — 원장 V-afda6796 COLUMN / 원장 V-66b6c55e COLUMN / 실측[T-ff1837a0]: 기존행 r0 SHIPMENT_STATUS: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0583 | D1 | SHIPPING_PLAN_QTY / Shipping Plan Qty | 하네스·환경 | D1 도구 오류 — 원장 V-d2627b94 COLUMN / 원장 V-36be0207 COLUMN / 실측[T-d6f9e077]: 기존행 r0 SHIPPING_PLAN_QTY: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0584 | D1 | SHIPTO_DESCRIPTION / Ship To Party | 하네스·환경 | D1 도구 오류 — 원장 V-70837157 COLUMN / 원장 V-9f0b08c4 COLUMN / 실측[T-b51e7617]: 기존행 r0 SHIPTO_DESCRIPTION: 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0585 | D1 | SSP0023_ShipmentPlanElectrode.EditButton | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.EditButton 의 D1 18요소: ERROR:17 · NA:1 |  | 81 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0586 | D1 | TO_SITE / To Site | 하네스·환경 | D1 도구 오류 — 원장 V-e43d0e0f COLUMN / 원장 V-e7851b8e COLUMN / 실측[T-0786adfb]: 기존행 r0 TO_SITE: 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0587 | D1 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | D1 도구 오류 — 원장 V-b9a2776f COLUMN / 원장 V-fc77dce4 COLUMN / 실측[T-e19581cd]: 기존행 r0 TO_SITE_DESCRIPTION: 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0588 | D1 | lock(22) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 lock(22) 'editLock(P_SHIP_PLAN_SIMU_ETD 행 [plan_start~confir' 의 D1 23요소: ERROR:17 · NA:6 |  | 1 (lock(22)) |
| WK-SSP0023-0589 | D1 | spdDetail 3시트(PlanDetail/Stock/Result) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 spdDetail 3시트(PlanDetail/Stock/Result) 'ShipmentPlanElectrodeDetailGrid(TabWrapper)' 의 D1 23요소: ERROR:17 · N |  | 1 (spdDetail 3시트(PlanDetail/Stock/Result)) |
| WK-SSP0023-0590 | D1 | value(91) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 value(91) 'MainGrid dynamicColumns 값 바인딩 + save diff' 의 D1 23요소: ERROR:17 · NA:6 |  | 1 (value(91)) |
| WK-SSP0023-0591 | D3 | CONFIRM_QTY_PANCAKE / Confirm Qty (Panca | 하네스·환경 | D3 도구 오류 — 원장 V-69847a92 ASIS / 원장 V-c76312c5 ASIS / 실측[T-ce293d82]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth = |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0592 | D3 | CONFIRM_QTY_PANCAKE,MERGE_NUM | 하네스·환경 | D3 도구 오류 — 원장 V-c76312c5 / 실측[T-3342b6e2]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_Mode = |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Insert) |
| WK-SSP0023-0593 | D3 | CONFIRM_QTY_PANCAKE,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-69847a92 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0594 | D3 | CONFIRM_QTY_ROLL_LENGTH / Confirm Qty (C | 하네스·환경 | D3 도구 오류 — 원장 V-9a5cdd7e ASIS / 실측[T-2b03b412]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_M |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0595 | D3 | D00-2-026 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2-026 '§2 spdMain / Change' 의 D3 37요소: ERROR:31 · NA:4 · PASS:2 |  | 1 (D00-2-026) |
| WK-SSP0023-0596 | D3 | D00-4d-010 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-010 '§4d SpdDetail_EditChange / siDetail.IsLock == fals' 의 D3 37요소: ERROR:31 · NA:4 · PASS:2 |  | 1 (D00-4d-010) |
| WK-SSP0023-0597 | D3 | D00-4d-011 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-011 '§4d SpdDetail_EditChange / ActiveSheet == shtPlanD' 의 D3 37요소: ERROR:31 · NA:4 · PASS:2 |  | 1 (D00-4d-011) |
| WK-SSP0023-0598 | D3 | D00-4d-023 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-023 '§4d shtPlanDetail_Change / CanModelChange != true ' 의 D3 37요소: ERROR:31 · NA:4 · PASS:2 |  | 1 (D00-4d-023) |
| WK-SSP0023-0599 | D3 | D00-4d-025 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-025 '§4d shtPlanDetail_Change / siDetail.IsLock == fals' 의 D3 37요소: ERROR:31 · NA:4 · PASS:2 |  | 1 (D00-4d-025) |
| WK-SSP0023-0600 | D3 | DAYOFWEEK_NAME / Day | 하네스·환경 | D3 도구 오류 — 원장 V-bdd78695 ASIS / 원장 V-2d1e1c07 ASIS / 실측[T-0d10b0fb]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth = |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0601 | D3 | DAYOFWEEK_NAME,DAYOFWEEK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-bdd78695 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0602 | D3 | DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-eb96c914 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0603 | D3 | DIVISION_ID / Div | 하네스·환경 | D3 도구 오류 — 원장 V-eb96c914 ASIS / 원장 V-624d6024 ASIS / 원장 V-2d1e1c07 ASIS / 실측[T-d7e9b713]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미 |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0604 | D3 | DIVISION_ID,DAYOFWEEK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-2d1e1c07 / 실측[T-597458df]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_Mode = |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Insert) |
| WK-SSP0023-0605 | D3 | DIVISION_ID,TO_SITE_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-624d6024 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0606 | D3 | ELECTRODE_POST_OPER | 하네스·환경 | D3 도구 오류 — 원장 V-a1bbd647 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0607 | D3 | ELECTRODE_POST_OPER / Post Oper. | 하네스·환경 | D3 도구 오류 — 원장 V-a1bbd647 ASIS / 원장 V-2a19b062 ASIS / 실측[T-a73f0308]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth = |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0608 | D3 | ERP_STATUS / erp_status | 하네스·환경 | D3 도구 오류 — 실측[T-20a59e81]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_Mode == false) / if (s |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0609 | D3 | EditButton(Edit) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 EditButton(Edit) "canEdit=hasButton('INSERT')\\" 의 D3 37요소: ERROR:31 · NA:4 · PASS:2 |  | 1 (EditButton(Edit)) |
| WK-SSP0023-0610 | D3 | FROM_SITE / SCM Site | 하네스·환경 | D3 도구 오류 — 실측[T-9e17e972]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_Mode == false) / if (s |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0611 | D3 | FindButton(Search) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 FindButton(Search) 'hotkeyConfig.search=handleSearch' 의 D3 37요소: ERROR:31 · NA:4 · PASS:2 |  | 1 (FindButton(Search)) |
| WK-SSP0023-0612 | D3 | GAP / Gap | 하네스·환경 | D3 도구 오류 — 원장 V-9a5cdd7e ASIS / 원장 V-2a19b062 ASIS / 실측[T-ee23a54c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth = |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0613 | D3 | GAP,CONFIRM_QTY_ROLL_LENGTH | 하네스·환경 | D3 도구 오류 — 원장 V-9a5cdd7e |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0614 | D3 | GAP,ELECTRODE_POST_OPER | 하네스·환경 | D3 도구 오류 — 원장 V-2a19b062 / 실측[T-d3683091]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_Mode = |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Insert) |
| WK-SSP0023-0615 | D3 | MEASURE / Measure | 하네스·환경 | D3 도구 오류 — 원장 V-97cf462d ASIS / 실측[T-6ff10eb0]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / else of (bE |  | 9 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0616 | D3 | MERGE_NUM / SSP0023 | 하네스·환경 | D3 도구 오류 — 원장 V-c76312c5 ASIS / 실측[T-72de0a71]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_M |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Insert) |
| WK-SSP0023-0617 | D3 | PACKAGE_QTY / Package Qty | 하네스·환경 | D3 도구 오류 — 원장 V-2125d4df ASIS / 실측[T-6f59662c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_M |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0618 | D3 | PACKAGE_QTY,PACKAGE_QTY | 하네스·환경 | D3 도구 오류 — 원장 V-2125d4df |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0619 | D3 | SHIPMENT_STATUS / Status | 하네스·환경 | D3 도구 오류 — 실측[T-716a4910]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_Mode == false) / if (s |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0620 | D3 | SHIPPING_PLAN_QTY | 하네스·환경 | D3 도구 오류 — 원장 V-571d4395 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0621 | D3 | SHIPPING_PLAN_QTY / Shipping Plan Qty | 하네스·환경 | D3 도구 오류 — 원장 V-571d4395 ASIS / 원장 V-e88baa59 ASIS / 실측[T-75dd7104]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth = |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0622 | D3 | SHIPPING_PLAN_QTY,SHIPPING_PLAN_QTY | 하네스·환경 | D3 도구 오류 — 원장 V-e88baa59 / 실측[T-6861c460]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_Mode = |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Insert) |
| WK-SSP0023-0623 | D3 | SHIPTO_DESCRIPTION / Ship To Party | 하네스·환경 | D3 도구 오류 — 원장 V-69847a92 ASIS / 실측[T-e6cd1d91]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_M |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0624 | D3 | SSP0023_ShipmentPlanElectrode.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-129d75ad ASIS / 원장 V-eb96c914 ASIS / 원장 V-bc258c8e ASIS / 원장 V-90d9b010 ASIS / 원장 V-97cf462d ASIS / 원장 V-c21f86e1  |  | 81 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0625 | D3 | TO_SITE / To Site | 하네스·환경 | D3 도구 오류 — 실측[T-68ce5e2a]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_Mode == false) / if (s |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0626 | D3 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | D3 도구 오류 — 원장 V-624d6024 ASIS / 실측[T-e2dcd33b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / if (bEdit_M |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0627 | D3 | lock(22) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 lock(22) 'editLock(P_SHIP_PLAN_SIMU_ETD 행 [plan_start~confir' 의 D3 37요소: ERROR:31 · NA:4 · PASS:2 |  | 1 (lock(22)) |
| WK-SSP0023-0628 | D3 | siDetail.LockRange2 | 하네스·환경 | D3 도구 오류 — 원장 V-8d247295 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0629 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-bc258c8e |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0630 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-90d9b010 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0631 | D3 | spdDetail 3시트(PlanDetail/Stock/Result) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 spdDetail 3시트(PlanDetail/Stock/Result) 'ShipmentPlanElectrodeDetailGrid(TabWrapper)' 의 D3 37요소: ERROR:31 · N |  | 1 (spdDetail 3시트(PlanDetail/Stock/Result)) |
| WK-SSP0023-0632 | D3 | value(91) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 value(91) 'MainGrid dynamicColumns 값 바인딩 + save diff' 의 D3 37요소: ERROR:31 · NA:4 · PASS:2 |  | 1 (value(91)) |
| WK-SSP0023-0633 | D6 | SSP0023 화면 | 하네스·환경 | D6 도구 오류 — 원장 V-023d8105 RULE_SCREEN / 원장 V-26ba4ca7 RULE_SCREEN / 원장 V-12dd8c8a RULE_SCREEN / 원장 V-79006e77 GENERAL / 원장 V-dab9da |  | 6 (CRUD:EP05:INSERT COMMON:UC-03 InsertButt) |
| WK-SSP0023-0634 | E1 | D00-2-021 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-2-021 '§2 spdDetail / ClipboardPasted' 의 E1 22요소: ERROR:13 · NA:9 |  | 1 (D00-2-021) |
| WK-SSP0023-0635 | E1 | D00-2-026 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-2-026 '§2 spdMain / Change' 의 E1 22요소: ERROR:13 · NA:9 |  | 1 (D00-2-026) |
| WK-SSP0023-0636 | E1 | D00-2-027 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-2-027 '§2 spdMain / ClipboardPasted' 의 E1 22요소: ERROR:13 · NA:9 |  | 1 (D00-2-027) |
| WK-SSP0023-0637 | E1 | D00-4d-005 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-4d-005 '§4d SpdDetail_ClipboardPasted / siDetail.IsLock ==' 의 E1 22요소: ERROR:13 · NA:9 |  | 1 (D00-4d-005) |
| WK-SSP0023-0638 | E1 | D00-4d-006 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-4d-006 '§4d SpdDetail_ClipboardPasted / ActiveSheet == sht' 의 E1 22요소: ERROR:13 · NA:9 |  | 1 (D00-4d-006) |
| WK-SSP0023-0639 | E1 | D00-4d-007 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-4d-007 '§4d SpdDetail_ClipboardPasted / Cells[iRow,iCol].T' 의 E1 22요소: ERROR:13 · NA:9 |  | 1 (D00-4d-007) |
| WK-SSP0023-0640 | E1 | D00-4d-009 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-4d-009 '§4d SpdDetail_ClipboardPasted / dr == null' 의 E1 22요소: ERROR:13 · NA:9 |  | 1 (D00-4d-009) |
| WK-SSP0023-0641 | E1 | DIVISION_ID / Div | 하네스·환경 | E1 도구 오류 — 실측[T-63dbb452]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0642 | E1 | DOM_EXP / DOM/EXP. | 하네스·환경 | E1 도구 오류 — 실측[T-8a66975b]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0643 | E1 | ELECTRODE_TYPE / Elec Type | 하네스·환경 | E1 도구 오류 — 실측[T-3a9bface]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0644 | E1 | ERP_SO_NO / SO No | 하네스·환경 | E1 도구 오류 — 실측[T-29e78c33]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 22 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0645 | E1 | FACTORY_ID / Building Desc. | 하네스·환경 | E1 도구 오류 — 실측[T-97ac2e91]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0646 | E1 | FROM_SITE / SCM Site | 하네스·환경 | E1 도구 오류 — 실측[T-f8029163]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0647 | E1 | ITEM_ID / Material | 하네스·환경 | E1 도구 오류 — 실측[T-251a3f5a]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0648 | E1 | MODEL_ID / Model | 하네스·환경 | E1 도구 오류 — 실측[T-c333dfe5]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0649 | E1 | PACKAGE_TYPE / Package Type  | 하네스·환경 | E1 도구 오류 — 실측[T-dde4f69f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0650 | E1 | REMARKS / Remarks | 하네스·환경 | E1 도구 오류 — 실측[T-534c8d88]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0651 | E1 | SHIPMENT_CONFIRM_QTY / Confirm Qty | 하네스·환경 | E1 도구 오류 — 원장 V-f7c8a6ff COLUMN / 실측[T-5f1e6e9f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetai |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0652 | E1 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | E1 도구 오류 — 실측[T-835cebb2]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 9 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0653 | E1 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | E1 도구 오류 — 실측[T-27bc2856]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:1902 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0654 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-f2067891 ASIS / 원장 V-01cd3197 ASIS / 원장 V-b04941f7 ASIS / 실측[T-d70d7da5]: MSG00004: 저장 성공 응답('S') → 결과 메시지 — CRUD  |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SaveDa) |
| WK-SSP0023-0655 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-b04941f7 / 실측[T-0c19d66d]: MSG00004: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 PASS: 찾음 5건 · 없음 0건 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Simula) |
| WK-SSP0023-0656 | E4 | MSG00005 | 하네스·환경 | E4 도구 오류 — 원장 V-bf3dbe0d / 실측[T-71c37701]: MSG00005 — Simulation 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Simulation)에서  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Simula) |
| WK-SSP0023-0657 | E4 | MSG00005 | 하네스·환경 | E4 도구 오류 — 원장 V-bf3dbe0d ASIS / 실측[T-73da8e60]: MSG00005 — Simulation 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Simulatio |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Simula) |
| WK-SSP0023-0658 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-7455da53 / 실측[T-e727c7d1]: MSG00007 — BtnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnMeasu |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.BtnMea) |
| WK-SSP0023-0659 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-7455da53 ASIS / 원장 V-b8630633 ASIS / 실측[T-9da10201]: MSG00007 — BtnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.BtnMea) |
| WK-SSP0023-0660 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-b8630633 / 실측[T-0c2215d7]: MSG00007 — BtnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnMeasu |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.BtnMea) |
| WK-SSP0023-0661 | E4 | MSG00042 | 하네스·환경 | E4 도구 오류 — 원장 V-b997e5ad / 실측[T-be078e87]: MSG00042 — Simulation 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Simulation)에서  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Simula) |
| WK-SSP0023-0662 | E4 | MSG00042 | 하네스·환경 | E4 도구 오류 — 원장 V-b997e5ad ASIS / 실측[T-1cedfca9]: MSG00042 — Simulation 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Simulatio |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Simula) |
| WK-SSP0023-0663 | E4 | MSG00047 | 하네스·환경 | E4 도구 오류 — 원장 V-afdb030b / 실측[T-053464d2]: MSG00047 — SpdDetail_ClipboardPasted 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0664 | E4 | MSG00047 | 하네스·환경 | E4 도구 오류 — 원장 V-afdb030b ASIS / 실측[T-cdce7228]: MSG00047 — SpdDetail_ClipboardPasted 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0665 | E4 | MSG00189 | 하네스·환경 | E4 도구 오류 — 원장 V-5e46a1c3 ASIS / 원장 V-43e27d79 ASIS / 실측[T-102f69cc]: MSG00189: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guar |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.GetShi) |
| WK-SSP0023-0666 | E4 | MSG00189 | 하네스·환경 | E4 도구 오류 — 원장 V-43e27d79 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.shtPla) |
| WK-SSP0023-0667 | E4 | MSG00265 | 하네스·환경 | E4 도구 오류 — 원장 V-ba0abe2f / 실측[T-d3269dc1]: MSG00265 — btnExcelUpload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnE |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.btnExc) |
| WK-SSP0023-0668 | E4 | MSG00265 | 하네스·환경 | E4 도구 오류 — 원장 V-ba0abe2f ASIS / 실측[T-51a5877d]: MSG00265 — btnExcelUpload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.btnExc) |
| WK-SSP0023-0669 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-8d14b2be |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0670 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-8d14b2be ASIS / 원장 V-3bbfff01 ASIS / 실측[T-4ff6b9f5]: MSG00278 — SpdDetail_ComboSelChange 경로 메시지(저장 전 검증 아님 · Save  |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0671 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-3bbfff01 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.shtPla) |
| WK-SSP0023-0672 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-678d596f ASIS / 원장 V-17b4eec3 ASIS / 원장 V-c5df1f25 ASIS / 원장 V-7981f95c ASIS / 실측[T-cf238c13]: MSG00284 — NewNonSo |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.NewNon) |
| WK-SSP0023-0673 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-678d596f / 실측[T-12b82f7c]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.NonSoN) |
| WK-SSP0023-0674 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-17b4eec3 / 실측[T-12019bd0]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SaveDa) |
| WK-SSP0023-0675 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-c5df1f25 / 실측[T-b39ebd47]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SaveDa) |
| WK-SSP0023-0676 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-7981f95c / 실측[T-5e6eefaf]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SoNo:4) |
| WK-SSP0023-0677 | E4 | MSG00287 | 하네스·환경 | E4 도구 오류 — 원장 V-8f1ad22c / 실측[T-14fa20af]: MSG00287 — SpdDetail_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdD |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0678 | E4 | MSG00287 | 하네스·환경 | E4 도구 오류 — 원장 V-8f1ad22c ASIS / 실측[T-2c9c5aee]: MSG00287 — SpdDetail_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0679 | E4 | MSG00292 | 하네스·환경 | E4 도구 오류 — 원장 V-565d89d1 / 실측[T-e79068bc]: MSG00292 — Simulation 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Simulation)에서  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Simula) |
| WK-SSP0023-0680 | E4 | MSG00292 | 하네스·환경 | E4 도구 오류 — 원장 V-565d89d1 ASIS / 실측[T-6a62f149]: MSG00292 — Simulation 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Simulatio |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Simula) |
| WK-SSP0023-0681 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-239f74c6 ASIS / 원장 V-eca2841e ASIS / 실측[T-edbe7804]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.NewNon) |
| WK-SSP0023-0682 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-239f74c6 / 실측[T-0e4bed5d]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.NonSoN) |
| WK-SSP0023-0683 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-eca2841e / 실측[T-33242d34]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SoNo:4) |
| WK-SSP0023-0684 | E4 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | E4 도구 오류 — 원장 V-cffa64b4 ASIS / 원장 V-afdb030b ASIS / 원장 V-8f1ad22c ASIS / 실측[T-3408a8cf]: MSG00049: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류  |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.GetNew) |
| WK-SSP0023-0685 | E4 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | E4 도구 오류 — 원장 V-afdb030b ASIS / 원장 V-8d14b2be ASIS / 원장 V-3bbfff01 ASIS / 실측[T-6b88f829]: MSG00047 — SpdDetail_ClipboardPasted 경로  |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0686 | A6 | DM0003_GET_BUCKET_TYPE_CODE | 하네스·환경 | A6 도구 오류 — 원장 V-cb246b42 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-dfefc640]: DM0003_GET_BUCKET_TYPE_CODE: 화면  |  | 1 (DM0003_GET_BUCKET_TYPE_CODE(SP15)) |
| WK-SSP0023-0687 | A6 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 하네스·환경 | A6 도구 오류 — 원장 V-ce745c97 SP / 원장 V-a71c72bc SP / [문장 대조는 다름 — 실측 순서 일치(공통 20행)로 판정] 정렬대조 FAIL 2번째 키부터 다름: AS-IS ['YYYYMMDD', 'ITEM |  | 117 (SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17) A) |
| WK-SSP0023-0688 | A6 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 하네스·환경 | A6 도구 오류 — 원장 V-2f322ef3 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측 순서대조 PASS 공통 1565행(Doc/golden/SSP0023/SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXC |  | 80 (SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(S) |
| WK-SSP0023-0689 | A6 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 하네스·환경 | A6 도구 오류 — 원장 V-d41edf23 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-b8dbb30b]: PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_RESULT: 화면 진입·조회 경로에서 |  | 63 (SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19) A) |
| WK-SSP0023-0690 | A6 | PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_ | 하네스·환경 | A6 도구 오류 — 원장 V-7eab9dce SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-2853aad2]: PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL: 화면 진입·조 |  | 59 (SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S) |
| WK-SSP0023-0691 | A6 | chkMyModel/PartLeader/TeamLeader/Delegat | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 chkMyModel/PartLeader/TeamLeader/DelegateeModel(C12~14/17) '(검색 파라미터 — 미노출)' 의 A6 19요소: NOT_RUN:12 · ERROR:5 |  | 1 (chkMyModel/PartLeader/TeamLeader/Delegat) |
| WK-SSP0023-0692 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (COMMON:UC-02) |
| WK-SSP0023-0693 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (COMMON:UC-03) |
| WK-SSP0023-0694 | G1 | CRUD:EP02:SEARCH | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 CRUD:EP02:SEARCH '툴바 SEARCH — 조회 실행(수정 중이면 MSG00703 confirm)' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (CRUD:EP02:SEARCH) |
| WK-SSP0023-0695 | G1 | D00-1-008 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-008 '§1 btnSearch / SimpleButton' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (D00-1-008) |
| WK-SSP0023-0696 | G1 | D00-1-086 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-086 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (D00-1-086) |
| WK-SSP0023-0697 | G1 | D00-1-089 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-089 '§1 usrLayoutControl3 / UsrLayoutControl' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (D00-1-089) |
| WK-SSP0023-0698 | G1 | D00-2-006 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-006 '§2 btnSearch / Click' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (D00-2-006) |
| WK-SSP0023-0699 | G1 | D00-2-024 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-024 '§2 spdDetail / SheetTabClick' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (D00-2-024) |
| WK-SSP0023-0700 | G1 | FindButton(Search) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindButton(Search) 'hotkeyConfig.search=handleSearch' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (FindButton(Search)) |
| WK-SSP0023-0701 | G1 | MODAL:MeasureSelectModal | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 MODAL:MeasureSelectModal 'Measure 설정 모달(btnMeasure → 공통 MeasureSelectModal, ' 의 G1 22요소: PASS:12 · ERROR:7 · |  | 1 (MODAL:MeasureSelectModal) |
| WK-SSP0023-0702 | G1 | SSP0023_GET_SHIPMENT_PLAN(SP16) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SSP0023_GET_SHIPMENT_PLAN(SP16) 'P_SSP0023_GET' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (SSP0023_GET_SHIPMENT_PLAN(SP16)) |
| WK-SSP0023-0703 | G1 | SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17) 'P_SSP0023_GET_PLAN_DETAIL' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17)) |
| WK-SSP0023-0704 | G1 | SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19) 'P_SSP0023_GET_RESULT' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19)) |
| WK-SSP0023-0705 | G1 | SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(SP18) 'P_SSP0023_GET_STOCK_DETAIL' 의 G1 22요소: PASS:12 · ERROR:7 · NA: |  | 1 (SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(S) |
| WK-SSP0023-0706 | G1 | btnMeasure(C06) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnMeasure(C06) 'customButtons Measure → MeasureSelectModal' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (btnMeasure(C06)) |
| WK-SSP0023-0707 | G1 | chkDelegateeModel / Delegatee Model | 하네스·환경 | G1 도구 오류 — 원장 V-80c292d6 SEARCH / E2E smoke cond Checkbox |  | 20 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0708 | G1 | chkMyModel / My Model | 하네스·환경 | G1 도구 오류 — 원장 V-3f1fabe2 SEARCH / E2E smoke cond Checkbox |  | 21 (chkMyModel/PartLeader/TeamLeader/Delegat) |
| WK-SSP0023-0709 | G1 | chkPartLeader / Part Leader | 하네스·환경 | G1 도구 오류 — 원장 V-5124a506 SEARCH / E2E smoke cond Checkbox |  | 20 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0710 | G1 | chkPastPeriod / Including Past Period /  | 하네스·환경 | G1 도구 오류 — 원장 V-9dbfa904 SEARCH / E2E smoke cond checkbox |  | 2 (D00-1-015 chkPastPeriod(C15)) |
| WK-SSP0023-0711 | G1 | chkTeamLeader / Team Leader | 하네스·환경 | G1 도구 오류 — 원장 V-34c75b9c SEARCH / E2E smoke cond Checkbox |  | 20 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0712 | G1 | clbCompanyID_SelectedIndexChanged(E12) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 clbCompanyID_SelectedIndexChanged(E12) 'setCompany → FromSite/PlanDate react-query 키' 의 G1 22요소: PASS:12 · E |  | 1 (clbCompanyID_SelectedIndexChanged(E12)) |
| WK-SSP0023-0713 | G1 | clbDivision_ID_SelectedIndexChanged(E13) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 clbDivision_ID_SelectedIndexChanged(E13) 'setDivision → Company 화면단 필터' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (clbDivision_ID_SelectedIndexChanged(E13)) |
| WK-SSP0023-0714 | G1 | clbFromSite / From Site | 하네스·환경 | G1 도구 오류 — 원장 V-064b8e12 SEARCH / E2E smoke cond combo |  | 12 (D00-1-020 clbFromSite(C20) ACT:SSP0023_S) |
| WK-SSP0023-0715 | G1 | layoutControlGroup3(상세 조건, 활성시트별) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 layoutControlGroup3(상세 조건, 활성시트별) 'ShipmentPlanElectrodeDetailBar(detailFieldSet)' 의 G1 22요소: PASS:12 · ERRO |  | 1 (layoutControlGroup3(상세 조건, 활성시트별)) |
| WK-SSP0023-0716 | G1 | rdButton1~3(C65~67) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 rdButton1~3(C65~67) 'MainGrid BOH 3-radio(Button 배타)' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (rdButton1~3(C65~67)) |
| WK-SSP0023-0717 | G1 | spdSub(엑셀 상세) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 spdSub(엑셀 상세) '(SHEETS.EXCEL — 업로드 경로만, 03 §1.5)' 의 G1 22요소: PASS:12 · ERROR:7 · NA:3 |  | 1 (spdSub(엑셀 상세)) |
| WK-SSP0023-0718 | G1 | txtLotID / Lot ID | 하네스·환경 | G1 도구 오류 — 원장 V-f69ebf09 SEARCH / E2E smoke cond InputField |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0719 | G1 | usrConditionPanel1(접이식 검색) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 usrConditionPanel1(접이식 검색) 'ShipmentPlanElectrodeForm + SearchArea(openSearchA' 의 G1 22요소: PASS:12 · ERROR:7 |  | 1 (usrConditionPanel1(접이식 검색)) |
| WK-SSP0023-0720 | X-ROW | SSP0023_ShipmentPlanElectrode.BtnMateria | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:4 · NA:3 · ERROR:2 |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.BtnMat) |
| WK-SSP0023-0721 | X-ROW | SSP0023_ShipmentPlanElectrode.BtnRequest | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — PASS:5 · ERROR:2 |  | 10 (ACT:SSP0023_ShipmentPlanElectrode.BtnReq) |
| WK-SSP0023-0722 | X-ROW | SSP0023_ShipmentPlanElectrode.BtnSearch_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 6 (ACT:SSP0023_ShipmentPlanElectrode.BtnSea) |
| WK-SSP0023-0723 | X-ROW | SSP0023_ShipmentPlanElectrode.CreateSpre | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Create) |
| WK-SSP0023-0724 | X-ROW | SSP0023_ShipmentPlanElectrode.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 62검사 — ERROR:46 · NA:14 · PASS:2 |  | 6 (ACT:SSP0023_ShipmentPlanElectrode.EditBu) |
| WK-SSP0023-0725 | X-ROW | SSP0023_ShipmentPlanElectrode.ExportExce | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:3 · NA:2 |  | 103 (ACT:SSP0023_ShipmentPlanElectrode.Export) |
| WK-SSP0023-0726 | X-ROW | SSP0023_ShipmentPlanElectrode.FindData_D | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 23검사 — PASS:13 · ERROR:7 · NA:2 · REVIEW:1 |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0727 | X-ROW | SSP0023_ShipmentPlanElectrode.FindData_M | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 46검사 — PASS:15 · REVIEW:10 · ERROR:7 · NOT_RUN:5 · NOPATH:5 · NA:4 |  | 10 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0728 | X-ROW | SSP0023_ShipmentPlanElectrode.FindData_P | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 22검사 — PASS:14 · ERROR:7 · NA:1 |  | 4 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0729 | X-ROW | SSP0023_ShipmentPlanElectrode.FindData_S | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 21검사 — PASS:11 · ERROR:7 · NA:2 · REVIEW:1 |  | 6 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0730 | X-ROW | SSP0023_ShipmentPlanElectrode.FindData_S | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 21검사 — PASS:11 · ERROR:8 · REVIEW:1 · NA:1 |  | 8 (ACT:SSP0023_ShipmentPlanElectrode.FindDa) |
| WK-SSP0023-0731 | X-ROW | SSP0023_ShipmentPlanElectrode.GetErpSoNo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.GetErp) |
| WK-SSP0023-0732 | X-ROW | SSP0023_ShipmentPlanElectrode.GetSSPUser | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.GetSSP) |
| WK-SSP0023-0733 | X-ROW | SSP0023_ShipmentPlanElectrode.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 51검사 — NA:23 · ERROR:19 · PASS:9 |  | 32 (ACT:SSP0023_ShipmentPlanElectrode.InitSp) |
| WK-SSP0023-0734 | X-ROW | SSP0023_ShipmentPlanElectrode.InsertButt | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Insert) |
| WK-SSP0023-0735 | X-ROW | SSP0023_ShipmentPlanElectrode.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — ERROR:17 · NA:1 |  | 142 (ACT:SSP0023_ShipmentPlanElectrode.Insert) |
| WK-SSP0023-0736 | X-ROW | SSP0023_ShipmentPlanElectrode.NonSoNo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:5 · PASS:2 · NA:1 |  | 135 (ACT:SSP0023_ShipmentPlanElectrode.NonSoN) |
| WK-SSP0023-0737 | X-ROW | SSP0023_ShipmentPlanElectrode.Plan_Curre | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — NA:6 · ERROR:1 · PASS:1 |  | 25 (ACT:SSP0023_ShipmentPlanElectrode.Plan_C) |
| WK-SSP0023-0738 | X-ROW | SSP0023_ShipmentPlanElectrode.Re_Design | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 43 (ACT:SSP0023_ShipmentPlanElectrode.Re_Des) |
| WK-SSP0023-0739 | X-ROW | SSP0023_ShipmentPlanElectrode.Re_DesignD | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:SSP0023_ShipmentPlanElectrode.Re_Des) |
| WK-SSP0023-0740 | X-ROW | SSP0023_ShipmentPlanElectrode.SaveData_D | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 36검사 — ERROR:11 · PASS:11 · REVIEW:5 · NOPATH:5 · NA:4 |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.SaveDa) |
| WK-SSP0023-0741 | X-ROW | SSP0023_ShipmentPlanElectrode.SetChangeC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0023_ShipmentPlanElectrode.SetCha) |
| WK-SSP0023-0742 | X-ROW | SSP0023_ShipmentPlanElectrode.SetChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NA:4 · PASS:3 · ERROR:2 |  | 3 (ACT:SSP0023_ShipmentPlanElectrode.SetCha) |
| WK-SSP0023-0743 | X-ROW | SSP0023_ShipmentPlanElectrode.SetSpreadC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 20검사 — NA:9 · PASS:7 · ERROR:3 · NOT_RUN:1 |  | 28 (ACT:SSP0023_ShipmentPlanElectrode.SetSpr) |
| WK-SSP0023-0744 | X-ROW | SSP0023_ShipmentPlanElectrode.Set_SumVal | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.Set_Su) |
| WK-SSP0023-0745 | X-ROW | SSP0023_ShipmentPlanElectrode.Set_Sum_Va | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:3 · NA:3 |  | 6 (ACT:SSP0023_ShipmentPlanElectrode.Set_Su) |
| WK-SSP0023-0746 | X-ROW | SSP0023_ShipmentPlanElectrode.Simulation | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 29검사 — ERROR:10 · PASS:7 · REVIEW:5 · NOPATH:5 · NA:2 |  | 105 (ACT:SSP0023_ShipmentPlanElectrode.Simula) |
| WK-SSP0023-0747 | X-ROW | SSP0023_ShipmentPlanElectrode.SoNo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:5 · PASS:2 · NA:1 |  | 150 (ACT:SSP0023_ShipmentPlanElectrode.SoNo A) |
| WK-SSP0023-0748 | X-ROW | SSP0023_ShipmentPlanElectrode.SpdDetail_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 31 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0749 | X-ROW | SSP0023_ShipmentPlanElectrode.SpdDetail_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — NA:12 · ERROR:5 · PASS:2 |  | 69 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0750 | X-ROW | SSP0023_ShipmentPlanElectrode.SpdDetail_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 80검사 — ERROR:73 · NA:7 |  | 26 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0751 | X-ROW | SSP0023_ShipmentPlanElectrode.SpdDetail_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 63검사 — ERROR:63 |  | 17 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0752 | X-ROW | SSP0023_ShipmentPlanElectrode.SpdDetail_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 27검사 — ERROR:27 |  | 38 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0753 | X-ROW | SSP0023_ShipmentPlanElectrode.SpdMain_Ch | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0754 | X-ROW | SSP0023_ShipmentPlanElectrode.SpdMain_To | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0755 | X-ROW | SSP0023_ShipmentPlanElectrode.Validation | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 32검사 — ERROR:28 · NA:4 |  | 94 (ACT:SSP0023_ShipmentPlanElectrode.Valida) |
| WK-SSP0023-0756 | X-ROW | SSP0023_ShipmentPlanElectrode.btnExcelFo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.btnExc) |
| WK-SSP0023-0757 | X-ROW | SSP0023_ShipmentPlanElectrode.btnExcelUp | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:7 |  | 6 (ACT:SSP0023_ShipmentPlanElectrode.btnExc) |
| WK-SSP0023-0758 | X-ROW | SSP0023_ShipmentPlanElectrode.btnItemId_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:4 · NA:3 · ERROR:2 |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.btnIte) |
| WK-SSP0023-0759 | X-ROW | SSP0023_ShipmentPlanElectrode.cboBucketT | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.cboBuc) |
| WK-SSP0023-0760 | X-ROW | SSP0023_ShipmentPlanElectrode.cboPlanDat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NA:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0023_ShipmentPlanElectrode.cboPla) |
| WK-SSP0023-0761 | X-ROW | SSP0023_ShipmentPlanElectrode.chkERPIFBl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 13 (ACT:SSP0023_ShipmentPlanElectrode.chkERP) |
| WK-SSP0023-0762 | X-ROW | SSP0023_ShipmentPlanElectrode.chkPastPer | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.chkPas) |
| WK-SSP0023-0763 | X-ROW | SSP0023_ShipmentPlanElectrode.chkSum_Che | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.chkSum) |
| WK-SSP0023-0764 | X-ROW | SSP0023_ShipmentPlanElectrode.clbCompany | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:3 · PASS:2 · NA:2 · WARN:1 |  | 7 (ACT:SSP0023_ShipmentPlanElectrode.clbCom) |
| WK-SSP0023-0765 | X-ROW | SSP0023_ShipmentPlanElectrode.rdButton_C | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 57검사 — ERROR:54 · NOT_RUN:3 |  | 27 (ACT:SSP0023_ShipmentPlanElectrode.rdButt) |
| WK-SSP0023-0766 | X-ROW | SSP0023_ShipmentPlanElectrode.shtPlanDet | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:9 |  | 99 (ACT:SSP0023_ShipmentPlanElectrode.shtPla) |
| WK-SSP0023-0767 | X-ROW | SSP0023_ShipmentPlanElectrode.spdMain_Cl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 17검사 — ERROR:14 · NA:3 |  | 2 (ACT:SSP0023_ShipmentPlanElectrode.spdMai) |
| WK-SSP0023-0768 | G5 | D00-2-025 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-2-025 '§2 spdMain / CellDoubleClick' 의 G5 22요소: NA:15 · NOPATH:3 · PASS:2 · ERROR:2 |  | 1 (D00-2-025) |
| WK-SSP0023-0769 | G5 | SP | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 SP '24' 의 G5 22요소: NA:15 · NOPATH:3 · PASS:2 · ERROR:2 |  | 1 (SP) |
| WK-SSP0023-0770 | G5 | SSP0023_ShipmentPlanElectrode.SpdMain_Ce | 하네스·환경 | G5 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.SpdMain_CellDoubleClick 의 G5 22요소: NA:15 · NOPATH:3 · PASS:2 · ERROR:2 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0771 | G5 | frm.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-1ca473bf |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.btnExc) |
| WK-SSP0023-0772 | G5 | saveFileDialog.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-f1943722 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Export) |
| WK-SSP0023-0773 | H6 | D00-2-025 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-2-025 '§2 spdMain / CellDoubleClick' 의 H6 22요소: PASS:10 · ERROR:6 · NOPATH:3 · NA:3 |  | 1 (D00-2-025) |
| WK-SSP0023-0774 | H6 | ERP_SO_NO / SO No | 하네스·환경 | H6 도구 오류 — 원장 V-9a5494fa ASIS / 원장 V-473131bd ASIS / 원장 V-f64516aa ASIS |  | 13 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0775 | H6 | SP | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 SP '24' 의 H6 22요소: PASS:10 · ERROR:6 · NOPATH:3 · NA:3 |  | 1 (SP) |
| WK-SSP0023-0776 | H6 | SSP0023_ShipmentPlanElectrode.SpdMain_Ce | 하네스·환경 | H6 도구 오류 — 진입점 집계 — 대조표 SSP0023_ShipmentPlanElectrode.SpdMain_CellDoubleClick 의 H6 22요소: PASS:10 · ERROR:6 · NOPATH:3 · NA:3 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdMai) |
| WK-SSP0023-0777 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-fffdb679 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.btnExc) |
| WK-SSP0023-0778 | H6 | new SSP0300_OrderDetailPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-9a5494fa |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0779 | H6 | pop.Form_Load(_DivisionID, _ErpSoNo, _Co | 하네스·환경 | H6 도구 오류 — 원장 V-473131bd |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0780 | H6 | pop.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-f64516aa |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
| WK-SSP0023-0781 | H6 | saveFileDialog.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-dd0852b7 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.Export) |
| WK-SSP0023-0782 | M3 | new SSP0300_OrderDetailPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-4f497582 |  | 1 (ACT:SSP0023_ShipmentPlanElectrode.SpdDet) |
