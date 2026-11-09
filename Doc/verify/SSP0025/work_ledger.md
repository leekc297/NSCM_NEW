# 작업 원장 — SSP0025 · 2026-11-09 11:50

> 검사 인스턴스 457건 중 PASS·NA 347건 외 **110건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 48 | 재판정 PASS |
| W5 | 검사기 연결 | 30 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 4 | 실행 → PASS |
| W7 | 기대값 확정 | 14 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 14 | 원인 해소 → 재판정 |

- 담당: FE 45 · 하네스 30 · 사람 판정 / AS-IS 원문 확인 → 재판정 14 · 하네스·환경 14 · E2E 4 · DB 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 17 |  |  |  | 1 |  | 4 | 대조표 행이 서술한 동작을 화면에서 재현 |
| H6 | POPUP |  |  | 14 |  | 3 | 2 |  |  |  | 팝업 표준·열림 |
| G1 | GEN |  |  |  |  |  | 2 |  |  | 7 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 9 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C3 | CASCADE |  |  | 6 |  |  |  |  |  |  | 연쇄 자동 채움 |
| B3 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G5 | POPUP |  |  |  |  | 5 |  |  |  |  | 팝업 조건 연동(인자) |
| E4 | EDIT |  |  | 4 |  |  |  |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A6 | GEN |  |  | 3 |  |  |  |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B1 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 중복 없음 |
| E5 | EDIT |  |  |  |  | 3 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| M4 | POPUP |  |  |  |  |  |  | 3 |  |  | 팝업 선택값 반영 |
| G4 | DESIGN |  |  |  |  | 2 |  |  |  |  | 조회조건 표시·라벨·활성 |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| D6 | EDIT |  |  | 1 |  |  |  |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  | 1 |  |  |  |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| H3 | DESIGN |  |  |  |  |  |  | 1 |  |  | 셀 병합 = AS-IS |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (48)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0001 | C3 | CellClick 순수가드(619/674) | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — CellClick 순수가드(619/674): 행 집계 — 대조표 CellClick 순수가드(619/674) 'cs:619,674' 의 C3 13요소: NA:9 · PASS:2 · FAIL:2 · FAIL 요소: |  | 1 (CellClick 순수가드(619/674)) |
| WK-SSP0025-0002 | C3 | ITEM_ID | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — ITEM_ID: 실측[T-24b369d1]: 신규행 연쇄 DIVISION_ID → ITEM_ID: DIVISION_ID='81 Automotive Battery' → ITEM_ID='' / DIVISION_ID |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0003 | C3 | R15 ComboSelChange 가드(행0) | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — R15 ComboSelChange 가드(행0): 행 집계 — 대조표 R15 ComboSelChange 가드(행0) 'cs:674' 의 C3 13요소: NA:9 · PASS:2 · FAIL:2 · FAIL 요소: |  | 1 (R15 ComboSelChange 가드(행0)) |
| WK-SSP0025-0004 | C3 | SITE_DESCRIPTION | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — SITE_DESCRIPTION: 원장 V-ecb624d9 ASIS / 실측[T-f95e2155]: 신규행 연쇄 DIVISION_ID → SITE_DESCRIPTION: DIVISION_ID='81 Automot |  | 5 (R13 SITE→TO_SITE 파생 ACT:SSP0025_Shipment) |
| WK-SSP0025-0005 | C3 | SSP0025_ShipmentRequestorPIC.CboDivision | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — SSP0025_ShipmentRequestorPIC.CboDivision_SelectedIndexChange: 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.CboDivision_S |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CboDivi) |
| WK-SSP0025-0006 | C3 | SSP0025_ShipmentRequestorPIC.SetChangedC | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — SSP0025_ShipmentRequestorPIC.SetChangedControl: 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.SetChangedControl 의 C3 13요소 |  | 0 () |
| WK-SSP0025-0007 | F1 | SSP0025 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F1 FAIL 수정 — SSP0025 화면: 원장 V-ba998255 RULE_SCREEN / 원장 V-e401c028 RULE_SCREEN / 원장 V-b43554df RULE_SCREEN / 원장 V-9c07278c RULE_SC |  | 69 (EditButton(SwitchLock) + GetSSPUserCheck) |
| WK-SSP0025-0008 | F5 | SSP0025 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F5 FAIL 수정 — SSP0025 화면: 원장 V-73ae37f0 RULE_SCREEN / 원장 V-4e526a5c RULE_SCREEN / 원장 V-c336a170 RULE_SCREEN / 원장 V-5286bad7 DEFECT  |  | 5 (DeleteButton(action='I'만 제거) R19 삭제=신규행만) |
| WK-SSP0025-0009 | D6 | SSP0025 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | D6 FAIL 수정 — SSP0025 화면: 원장 V-f3d9b7b1 RULE_SCREEN / 원장 V-2dd948ca RULE_SCREEN / 원장 V-a5043f1c RULE_SCREEN / 원장 V-33299f4e GENERAL |  | 5 (InsertButton(IsLock=false 가드) R7 신규행 VAL) |
| WK-SSP0025-0010 | E4 | MSG00004 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00004: 원장 V-0834b71f ASIS / 실측[T-e53b2a1c]: MSG00004: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 FAIL: 저장 성공 메시지 후 재조 |  | 2 (COMMON:UC-04 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0011 | E4 | MSG00004 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00004: 원장 V-0834b71f / 실측[T-f7377943]: MSG00251 — EditButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(EditButton)에서 판정 → 기계 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SaveDat) |
| WK-SSP0025-0012 | E4 | MSG00284 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00284: 원장 V-9ae33640 / 실측[T-5d505e7b]: MSG00251 — EditButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(EditButton)에서 판정 → 기계 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SaveDat) |
| WK-SSP0025-0013 | E4 | MSG00284 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00284: 원장 V-9ae33640 ASIS / 실측[T-51aa1216]: MSG00284: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 FAIL: 저장 성공 메시지 후 재조 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SaveDat) |
| WK-SSP0025-0014 | A10 | SSP0025 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | A10 FAIL 수정 — SSP0025 화면: 원장 V-da3afa6e RULE_SCREEN / 원장 V-cf4026ca GENERAL / 실측[T-da75f148]: 화면 진입 직후(조회 전) 그리드 0행 · 진입 시 호출 ssoU |  | 78 (ACT:SSP0025_ItembyDivisionPopup.DefinePr) |
| WK-SSP0025-0015 | A6 | FindButton → FindData_Main | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — FindButton → FindData_Main: 행 집계 — 대조표 FindButton → FindData_Main 'cs:185,249~284' 의 A6 2요소: FAIL:2 · FAIL 요소: PKG_SS |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0016 | A6 | PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISI | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP: 원장 V-d4de13d9 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['ITEM_ID', 'DIVISIO |  | 35 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0017 | A6 | PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUE | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC: 원장 V-10718e78 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['DIVISION_ID'] ↔ TO |  | 39 (ACT:SSP0025_ShipmentRequestorPIC.FindBut) |
| WK-SSP0025-0018 | X-ROW | SSP0025_ItembyDivisionPopup.DefineProper | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ItembyDivisionPopup.DefineProperty: 진입점 집계 2검사 — FAIL:1 · NA:1 |  | 2 (ACT:SSP0025_ItembyDivisionPopup.DefinePr) |
| WK-SSP0025-0019 | X-ROW | SSP0025_ItembyDivisionPopup.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ItembyDivisionPopup.FindButton: 진입점 집계 4검사 — NA:2 · REVIEW:1 · FAIL:1 |  | 2 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0020 | X-ROW | SSP0025_ItembyDivisionPopup.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ItembyDivisionPopup.FindData: 진입점 집계 11검사 — NA:5 · PASS:2 · NOT_RUN:2 · REVIEW:1 · FAIL:1 |  | 32 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0021 | X-ROW | SSP0025_ItembyDivisionPopup.Form_Load | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ItembyDivisionPopup.Form_Load: 진입점 집계 2검사 — NA:1 · FAIL:1 |  | 13 (ACT:SSP0025_ItembyDivisionPopup.Form_Loa) |
| WK-SSP0025-0022 | X-ROW | SSP0025_ItembyDivisionPopup.InitControls | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ItembyDivisionPopup.InitControls: 진입점 집계 12검사 — NA:7 · PASS:4 · FAIL:1 |  | 14 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0023 | X-ROW | SSP0025_ItembyDivisionPopup.InitSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ItembyDivisionPopup.InitSpread: 진입점 집계 2검사 — FAIL:1 · NA:1 |  | 14 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0024 | X-ROW | SSP0025_ShipmentRequestorPIC.DefinePrope | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.DefineProperty: 진입점 집계 1검사 — FAIL:1 |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.DefineP) |
| WK-SSP0025-0025 | X-ROW | SSP0025_ShipmentRequestorPIC.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.FindButton: 진입점 집계 3검사 — REVIEW:1 · FAIL:1 · PASS:1 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.FindBut) |
| WK-SSP0025-0026 | X-ROW | SSP0025_ShipmentRequestorPIC.FindData_Ma | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.FindData_Main: 진입점 집계 12검사 — PASS:5 · NA:5 · REVIEW:1 · FAIL:1 |  | 7 (ACT:SSP0025_ShipmentRequestorPIC.FindDat) |
| WK-SSP0025-0027 | X-ROW | SSP0025_ShipmentRequestorPIC.Form_Load | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.Form_Load: 진입점 집계 1검사 — FAIL:1 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.Form_Lo) |
| WK-SSP0025-0028 | X-ROW | SSP0025_ShipmentRequestorPIC.InitControl | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.InitControls: 진입점 집계 5검사 — PASS:4 · FAIL:1 |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitCon) |
| WK-SSP0025-0029 | X-ROW | SSP0025_ShipmentRequestorPIC.InitSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.InitSpread: 진입점 집계 16검사 — PASS:12 · NA:3 · FAIL:1 |  | 5 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0030 | X-ROW | SSP0025_ShipmentRequestorPIC.InsertButto | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.InsertButton: 진입점 집계 1검사 — FAIL:1 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertB) |
| WK-SSP0025-0031 | X-ROW | SSP0025_ShipmentRequestorPIC.SaveData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.SaveData: 진입점 집계 16검사 — PASS:8 · FAIL:5 · ERROR:2 · NA:1 |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SaveDat) |
| WK-SSP0025-0032 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.SpdMain_CellClick: 진입점 집계 25검사 — NA:18 · NOPATH:3 · FAIL:2 · ERROR:1 · PASS:1 |  | 29 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0033 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.SpdMain_CellDoubleClick: 진입점 집계 33검사 — NA:20 · FAIL:10 · PASS:3 |  | 21 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0034 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Com | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0025_ShipmentRequestorPIC.SpdMain_ComboSelChange: 진입점 집계 36검사 — PASS:23 · NA:11 · FAIL:2 |  | 8 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0035 | H6 | ITEM_ID | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — ITEM_ID: 원장 V-f68afbcd ASIS / 원장 V-a654a081 ASIS / 원장 V-e2ffc896 ASIS |  | 1 (R12 신규행 ITEM 팝업) |
| WK-SSP0025-0036 | H6 | PART_LEADER | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — PART_LEADER: 원장 V-ed6e2a1b ASIS / 원장 V-466afccb ASIS |  | 13 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0037 | H6 | R21 이미지셀 아이콘 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — R21 이미지셀 아이콘: 행 집계 — 대조표 R21 이미지셀 아이콘 'cs:162~164,347~353' 의 H6 26요소: FAIL:12 · NA:9 · NOPATH:3 · NOT_RUN:2 · FAIL 요소 |  | 1 (R21 이미지셀 아이콘) |
| WK-SSP0025-0038 | H6 | SITE_DESCRIPTION | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — SITE_DESCRIPTION: 원장 V-f68afbcd ASIS / 원장 V-a654a081 ASIS / 원장 V-e2ffc896 ASIS |  | 1 (셀 SITE_DESCRIPTION) |
| WK-SSP0025-0039 | H6 | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — SSP0025_ShipmentRequestorPIC.SpdMain_CellDoubleClick: 원장 V-97ed4734 ASIS / 원장 V-81497250 ASIS / 원장 V-ed6e2a1b ASIS /  |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0040 | H6 | TEAM_LEADER | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — TEAM_LEADER: 원장 V-a1a6a97f ASIS / 원장 V-883bdd72 ASIS |  | 13 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0041 | H6 | USER_ID | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — USER_ID: 원장 V-97ed4734 ASIS / 원장 V-81497250 ASIS |  | 14 (R16 USER_ID 더블클릭 팝업 ACT:SSP0025_Shipment) |
| WK-SSP0025-0042 | H6 | new UserInfoPopup() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new UserInfoPopup(): 원장 V-97ed4734 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0043 | H6 | new UserInfoPopup() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new UserInfoPopup(): 원장 V-ed6e2a1b |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0044 | H6 | new UserInfoPopup() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new UserInfoPopup(): 원장 V-a1a6a97f |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0045 | H6 | popup.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popup.ShowDialog(): 원장 V-e2ffc896 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0046 | H6 | popup.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popup.ShowDialog(): 원장 V-81497250 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0047 | H6 | popup.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popup.ShowDialog(): 원장 V-466afccb |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0048 | H6 | popup.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popup.ShowDialog(): 원장 V-883bdd72 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |

## W5 검사기 연결 (30)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0049 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0050 | B1 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (COMMON:UC-05 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0051 | B1 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0025-0052 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0053 | B2 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (COMMON:UC-05 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0054 | B2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0025-0055 | B3 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (셀 DIVISION_ID) |
| WK-SSP0025-0056 | B3 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 PCOL N | 판단불가(대상 단위 PCOL) | 3 (UserInfoPopup(User/Part/Team) ACT:SSP002) |
| WK-SSP0025-0057 | B3 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (셀 SITE_DESCRIPTION) |
| WK-SSP0025-0058 | B3 | USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL USER_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0025_ShipmentRequestorPIC.GetUser) |
| WK-SSP0025-0059 | B3 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (셀 VALID_YN) |
| WK-SSP0025-0060 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (셀 DIVISION_ID COMMON:UC-05 ACT:SSP0025_S) |
| WK-SSP0025-0061 | B4 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL N | 판단불가(대상 단위 PCOL) | 3 (UserInfoPopup(User/Part/Team) ACT:SSP002) |
| WK-SSP0025-0062 | B4 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 4 (셀 SITE_DESCRIPTION COMMON:UC-05 ACT:SSP0) |
| WK-SSP0025-0063 | B4 | USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL USER_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0025_ShipmentRequestorPIC.GetUser) |
| WK-SSP0025-0064 | B4 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 2 (셀 VALID_YN COMMON:UC-05) |
| WK-SSP0025-0065 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitEve) |
| WK-SSP0025-0066 | G4 | btnModelId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnModelId | 있음(FE 소스) | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitEve) |
| WK-SSP0025-0067 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0025-0068 | E5 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0025-0069 | E5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0025-0070 | G03-WIRE | SSP0025 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0025 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SSP0025_ItembyDivisionPopup..ctor AC) |
| WK-SSP0025-0071 | G5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (셀 DIVISION_ID) |
| WK-SSP0025-0072 | G5 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 PCOL N | 판단불가(대상 단위 PCOL) | 1 (UserInfoPopup(User/Part/Team)) |
| WK-SSP0025-0073 | G5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (셀 VALID_YN) |
| WK-SSP0025-0074 | G5 | cboDivision / Div / Division / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboDivision / Div / Division / Div. | 있음(FE 소스) | 2 (cboDivision 셀 DIVISION_ID) |
| WK-SSP0025-0075 | G5 | clbFromSite / Plant Site / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbFromSite / Plant Site / From Site | 있음(FE 소스) | 1 (clbFromSite) |
| WK-SSP0025-0076 | H6 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (셀 DIVISION_ID) |
| WK-SSP0025-0077 | H6 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 PCOL N | 판단불가(대상 단위 PCOL) | 1 (UserInfoPopup(User/Part/Team)) |
| WK-SSP0025-0078 | H6 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (셀 VALID_YN) |

## W6 검증 실행 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0079 | G1 | clbDivisionId / Division / Division Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisionId / Division / Division Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0080 | G1 | clbFromSiteId / From Site / From Site Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSiteId / From Site / From Site Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0081 | H6 | cboDivision / Div / Division / Div. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Div / Division / Div. · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (cboDivision 셀 DIVISION_ID) |
| WK-SSP0025-0082 | H6 | clbFromSite / Plant Site / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbFromSite / Plant Site / From Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (clbFromSite) |

## W7 기대값 확정 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0083 | H3 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — I: 검증 엔진이 실행됐으나 이 대상(PCOL I)을 판정하지 못함 — 셀 병합 = AS-IS 시나리오 수동 확인 또는 엔진 확장 |  | 1 (R20 셀 병합) |
| WK-SSP0025-0084 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 2요소: REVIEW:2 · FAIL 요 |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0085 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_S |  | 1 (COMMON:UC-06) |
| WK-SSP0025-0086 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 2요소: REVIEW:2 · FAIL 요 |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0087 | A1 | CboDivision_SelectedIndexChanged → SetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CboDivision_SelectedIndexChanged → SetChangedContr: 행 집계 — 대조표 CboDivision_SelectedIndexChanged → SetChangedControl 'c |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SSP0025-0088 | A1 | FindButton → FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton → FindData_Main: 행 집계 — 대조표 FindButton → FindData_Main 'cs:185,249~284' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_S |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0089 | A1 | PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 35 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0090 | A1 | PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0025/SSP0025_GET_SH |  | 39 (ACT:SSP0025_ShipmentRequestorPIC.FindBut) |
| WK-SSP0025-0091 | A1 | R11 신규행 SITE 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R11 신규행 SITE 재조회: 행 집계 — 대조표 R11 신규행 SITE 재조회 'cs:637~641' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SSP0025.P_SSP0025_GET_ITE |  | 1 (R11 신규행 SITE 재조회) |
| WK-SSP0025-0092 | A1 | checkRequiredOfSearch(Division 필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — checkRequiredOfSearch(Division 필수): 행 집계 — 대조표 checkRequiredOfSearch(Division 필수) 'cs:249' 의 A1 2요소: REVIEW:2 · FAIL 요 |  | 1 (checkRequiredOfSearch(Division 필수)) |
| WK-SSP0025-0093 | X-ROW | SSP0025_ShipmentRequestorPIC.Delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.Delete: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/DATA_OP/ENTRY/EXPR/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:SSP0025_ShipmentRequestorPIC.Delete ) |
| WK-SSP0025-0094 | M4 | SSP0025_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0025_ItembyDivisionPopup: 검증 엔진이 실행됐으나 이 대상(POPUP SSP0025_ItembyDivisionPopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔 |  | 2 (SSP0025_ItembyDivisionPopup ACT:SSP0025_) |
| WK-SSP0025-0095 | M4 | cboDivision / Div / Division / Div. | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboDivision / Div / Division / Div.: 검증 엔진이 실행됐으나 이 대상(COND cboDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (cboDivision 셀 DIVISION_ID) |
| WK-SSP0025-0096 | M4 | clbFromSite / Plant Site / From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbFromSite / Plant Site / From Site: 검증 엔진이 실행됐으나 이 대상(COND clbFromSite)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (clbFromSite) |

## W9 도구 오류 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0097 | F6 | SSP0025 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-dd950e13 RULE_SCREEN / 원장 V-f3cc9d32 RULE_SCREEN / 원장 V-4c938596 RULE_SCREEN / 원장 V-540c3524 RULE_SCREEN / 원장 V-9c |  | 60 (SaveButton → SaveData ACT:SSP0025_Shipme) |
| WK-SSP0025-0098 | H10 | SSP0025 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 7 (GetUserIDChk(USER_ID_CHECK) COMMON:UC-01) |
| WK-SSP0025-0099 | I1 | SSP0025 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-3dc94623 RULE_SCREEN / 원장 V-839c3d56 RULE_SCREEN / 원장 V-257af710 RULE_SCREEN / 원장 V-386830bd DEFECT / 원장 V-167deba |  | 9 (GetUserIDChk(USER_ID_CHECK) COMMON:UC-02) |
| WK-SSP0025-0100 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요 |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0101 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요소가 남아 판정 |  | 1 (COMMON:UC-06) |
| WK-SSP0025-0102 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요 |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0103 | G1 | CboDivision_SelectedIndexChanged → SetCh | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 CboDivision_SelectedIndexChanged → SetChangedControl 'cs:699~702,137~142' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS: |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SSP0025-0104 | G1 | FindButton → FindData_Main | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindButton → FindData_Main 'cs:185,249~284' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0105 | G1 | R11 신규행 SITE 재조회 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 R11 신규행 SITE 재조회 'cs:637~641' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (R11 신규행 SITE 재조회) |
| WK-SSP0025-0106 | G1 | checkRequiredOfSearch(Division 필수) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 checkRequiredOfSearch(Division 필수) 'cs:249' 의 G1 7요소: NA:3 · NOT_RUN:2 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch(Division 필수)) |
| WK-SSP0025-0107 | X-ROW | SSP0025_ItembyDivisionPopup.spdMain_Cell | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NA:3 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.spdMain_) |
| WK-SSP0025-0108 | X-ROW | SSP0025_ShipmentRequestorPIC.CboDivision | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CboDivi) |
| WK-SSP0025-0109 | X-ROW | SSP0025_ShipmentRequestorPIC.CreateSprea | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0110 | X-ROW | SSP0025_ShipmentRequestorPIC.SetChangedC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:3 · PASS:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SetChan) |
