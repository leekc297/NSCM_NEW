# 작업 원장 — SSP0024 · 2026-11-09 12:11

> 검사 인스턴스 747건 중 PASS·NA 533건 외 **214건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 38 | 재판정 PASS |
| W5 | 검사기 연결 | 43 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 30 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 102 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 102 · 하네스 43 · FE 35 · 사람 판정 / AS-IS 원문 확인 → 재판정 30 · DB 3 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 16 |  |  |  | 2 |  | 7 | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  | 1 |  |  | 23 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 24 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G5 | POPUP |  |  |  |  | 8 |  |  |  | 15 | 팝업 조건 연동(인자) |
| C3 | CASCADE |  |  | 18 |  |  |  |  |  |  | 연쇄 자동 채움 |
| M4 | POPUP |  |  |  |  |  |  | 2 |  | 15 | 팝업 선택값 반영 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 9 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 9 | 배경·글자색 규칙 |
| H6 | POPUP |  |  |  |  | 8 |  |  |  |  | 팝업 표준·열림 |
| E3 | EDIT |  |  |  |  |  |  | 1 |  | 7 | 필수 입력 검증 |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 8 | 라벨 명칭 |
| B4 | COMBO |  |  |  |  | 7 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B1 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 중복 없음 |
| B3 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| A6 | GEN |  |  | 2 |  |  |  | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| D5 | EDIT |  |  |  |  |  |  |  |  | 3 | 셀 에디터 유형 |
| G4 | DESIGN |  |  |  |  | 2 |  |  |  |  | 조회조건 표시·라벨·활성 |
| E5 | EDIT |  |  |  |  | 2 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| A10 | GEN |  |  | 1 |  |  |  |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| K-SA | COMMON |  |  |  |  |  |  |  |  | 1 | 조회영역 토글 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (38)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0001 | C3 | 11 | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — 11: 행 집계 — 대조표 11 'SpdMain_ComboSelChange' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS |  | 1 (11) |
| WK-SSP0024-0002 | C3 | 14 | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — 14: 행 집계 — 대조표 14 'SpdMain_ClipboardPasted' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASI |  | 1 (14) |
| WK-SSP0024-0003 | C3 | 15 | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — 15: 행 집계 — 대조표 15 'SpdMain_ClipboardPasted' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASI |  | 1 (15) |
| WK-SSP0024-0004 | C3 | BUILDING | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — BUILDING: 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51aa299a]: BUILDING 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_ComboSelC |  | 13 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0005 | C3 | D00-2-005 | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — D00-2-005: 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — |  | 1 (D00-2-005) |
| WK-SSP0024-0006 | C3 | D00-2-007 | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — D00-2-007: 행 집계 — 대조표 D00-2-007 '§2 spdMain / ClipboardPasted' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING  |  | 1 (D00-2-007) |
| WK-SSP0024-0007 | C3 | D00-4d-011 | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — D00-4d-011: 행 집계 — 대조표 D00-4d-011 '§4d SpdMain_ComboSelChange / -' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILD |  | 1 (D00-4d-011) |
| WK-SSP0024-0008 | C3 | D00-4d-014 | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — D00-4d-014: 행 집계 — 대조표 D00-4d-014 '§4d SpdMain_ClipboardPasted / -' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUIL |  | 1 (D00-4d-014) |
| WK-SSP0024-0009 | C3 | D00-4d-015 | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — D00-4d-015: 행 집계 — 대조표 D00-4d-015 '§4d SpdMain_ClipboardPasted / -' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUIL |  | 1 (D00-4d-015) |
| WK-SSP0024-0010 | C3 | MATERIAL_ID | DB(🛠️/🧯 적용 가능) | C3 FAIL 수정 — MATERIAL_ID: 실측[T-16208542]: 신규행 연쇄 DIVISION_ID → MATERIAL_ID: DIVISION_ID='81' → MATERIAL_ID='' / DIVISION_ID='40' → |  | 7 (D00-3-042 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0011 | C3 | POST_OPER | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — POST_OPER: 원장 V-a4d95037 ASIS / 실측[T-1898295d]: POST_OPER: AS-IS 문장이 값 대입이 아님(잠금·셀 타입·스타일) — 연쇄 채움 대상 아님(D1/D3/H2 에서  |  | 10 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0012 | C3 | POST_OPER_LT | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — POST_OPER_LT: 원장 V-a4d95037 ASIS / 실측[T-3586562e]: POST_OPER_LT: 원천 POST_OPER 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값  |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0013 | C3 | POST_OPER_LT | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — POST_OPER_LT: 원장 V-a4d95037 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0014 | C3 | SSP0024_ShipmentMasterElectrode.ClbDivis | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — SSP0024_ShipmentMasterElectrode.ClbDivision_SelectedIndexCha: 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.ClbDivisio |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.ClbD) |
| WK-SSP0024-0015 | C3 | SSP0024_ShipmentMasterElectrode.SetChang | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — SSP0024_ShipmentMasterElectrode.SetChangedControl: 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.SetChangedControl 의 C |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0016 | C3 | SSP0024_ShipmentMasterElectrode.SpdMain_ | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — SSP0024_ShipmentMasterElectrode.SpdMain_ComboSelChange: 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 원장 V-b69f3426 ASIS |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0017 | C3 | SpdMain_ClipboardPasted (cs:659) | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — SpdMain_ClipboardPasted (cs:659): 행 집계 — 대조표 SpdMain_ClipboardPasted (cs:659) '붙여넣기' 의 C3 20요소: NA:8 · PASS:7 · FAIL: |  | 1 (SpdMain_ClipboardPasted (cs:659)) |
| WK-SSP0024-0018 | C3 | SpdMain_ComboSelChange (cs:596) | FE(repairScope=DB_ONLY — 이번 범위 밖) | C3 FAIL 수정 — SpdMain_ComboSelChange (cs:596): 행 집계 — 대조표 SpdMain_ComboSelChange (cs:596) '파생' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 ·  |  | 1 (SpdMain_ComboSelChange (cs:596)) |
| WK-SSP0024-0019 | F2 | SSP0024 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F2 FAIL 수정 — SSP0024 화면: 원장 V-5e35aff2 RULE_SCREEN / 원장 V-95b573aa RULE_SCREEN / 원장 V-8e986a5b RULE_SCREEN / 원장 V-fdd9071a GENERAL |  | 90 (D00-4a-002 D00-4e-002 D00-4e-003 D00-4e-) |
| WK-SSP0024-0020 | A10 | SSP0024 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | A10 FAIL 수정 — SSP0024 화면: 원장 V-6f37342c RULE_SCREEN / 원장 V-44fd59ae GENERAL / 실측[T-9031acab]: 화면 진입 직후(조회 전) 그리드 0행 · 진입 시 호출 없음 — |  | 88 (ACT:SSP0024_ItembyDivisionPopup.DefinePr) |
| WK-SSP0024-0021 | A6 | PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISI | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP: 원장 V-d7b352eb SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['DIVISION_ID', 'SCM |  | 30 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0022 | A6 | PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER: 원장 V-a0e87555 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['DIVISION_ID', 'SCM_SITE_ID',  |  | 37 (D00-4a-001 FindButton (cs:230) ACT:SSP00) |
| WK-SSP0024-0023 | X-ROW | SSP0024_ItembyDivisionPopup.DefineProper | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ItembyDivisionPopup.DefineProperty: 진입점 집계 2검사 — NA:1 · FAIL:1 |  | 2 (ACT:SSP0024_ItembyDivisionPopup.DefinePr) |
| WK-SSP0024-0024 | X-ROW | SSP0024_ItembyDivisionPopup.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ItembyDivisionPopup.FindButton: 진입점 집계 4검사 — NA:2 · REVIEW:1 · FAIL:1 |  | 2 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0025 | X-ROW | SSP0024_ItembyDivisionPopup.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ItembyDivisionPopup.FindData: 진입점 집계 10검사 — NA:4 · PASS:2 · REVIEW:1 · FAIL:1 · ERROR:1 · NOT_RUN:1 |  | 27 (ACT:SSP0024_ItembyDivisionPopup.FindData) |
| WK-SSP0024-0026 | X-ROW | SSP0024_ItembyDivisionPopup.Form_Load | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ItembyDivisionPopup.Form_Load: 진입점 집계 2검사 — FAIL:1 · NA:1 |  | 11 (ACT:SSP0024_ItembyDivisionPopup.Form_Loa) |
| WK-SSP0024-0027 | X-ROW | SSP0024_ItembyDivisionPopup.InitControls | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ItembyDivisionPopup.InitControls: 진입점 집계 10검사 — NA:6 · PASS:3 · FAIL:1 |  | 9 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0028 | X-ROW | SSP0024_ItembyDivisionPopup.InitSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ItembyDivisionPopup.InitSpread: 진입점 집계 6검사 — PASS:4 · FAIL:1 · NA:1 |  | 14 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0029 | X-ROW | SSP0024_ShipmentMasterElectrode.DefinePr | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.DefineProperty: 진입점 집계 1검사 — FAIL:1 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Defi) |
| WK-SSP0024-0030 | X-ROW | SSP0024_ShipmentMasterElectrode.FindButt | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.FindButton: 진입점 집계 3검사 — REVIEW:1 · FAIL:1 · PASS:1 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Find) |
| WK-SSP0024-0031 | X-ROW | SSP0024_ShipmentMasterElectrode.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.FindData: 진입점 집계 12검사 — NA:5 · PASS:4 · REVIEW:1 · FAIL:1 · ERROR:1 |  | 6 (ACT:SSP0024_ShipmentMasterElectrode.Find) |
| WK-SSP0024-0032 | X-ROW | SSP0024_ShipmentMasterElectrode.Form_Loa | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.Form_Load: 진입점 집계 1검사 — FAIL:1 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Form) |
| WK-SSP0024-0033 | X-ROW | SSP0024_ShipmentMasterElectrode.InitCont | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.InitControls: 진입점 집계 8검사 — PASS:4 · NOPATH:3 · FAIL:1 |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.Init) |
| WK-SSP0024-0034 | X-ROW | SSP0024_ShipmentMasterElectrode.InitSpre | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.InitSpread: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:SSP0024_ShipmentMasterElectrode.Init) |
| WK-SSP0024-0035 | X-ROW | SSP0024_ShipmentMasterElectrode.SaveData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.SaveData: 진입점 집계 15검사 — PASS:7 · NA:4 · ERROR:3 · FAIL:1 |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.Save) |
| WK-SSP0024-0036 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.SpdMain_CellClick: 진입점 집계 24검사 — NA:15 · PASS:4 · ERROR:4 · FAIL:1 |  | 37 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0037 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.SpdMain_ClipboardPasted: 진입점 집계 41검사 — PASS:18 · NA:15 · NOPATH:6 · ERROR:1 · FAIL |  | 11 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0038 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0024_ShipmentMasterElectrode.SpdMain_ComboSelChange: 진입점 집계 52검사 — PASS:29 · NA:17 · FAIL:6 |  | 10 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |

## W5 검사기 연결 (43)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0039 | B1 | BUILDING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL BUILDING | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0040 | B1 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 PCOL D | 판단불가(대상 단위 PCOL) | 1 (D00-3-052) |
| WK-SSP0024-0041 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0042 | B1 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 3 (D00-3-050 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0043 | B1 | POST_OPER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL POST_OPER | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0044 | B2 | BUILDING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL BUILDING | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0045 | B2 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 PCOL D | 판단불가(대상 단위 PCOL) | 1 (D00-3-052) |
| WK-SSP0024-0046 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0047 | B2 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 3 (D00-3-050 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0048 | B2 | POST_OPER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL POST_OPER | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0049 | B3 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 PCOL D | 판단불가(대상 단위 PCOL) | 1 (D00-4b-002) |
| WK-SSP0024-0050 | B3 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (D00-4b-002 D00-4b-003) |
| WK-SSP0024-0051 | B3 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 PCOL N | 판단불가(대상 단위 PCOL) | 2 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0052 | B3 | POST_OPER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL POST_OPER | 있음(SHEET_COLUMNS) | 1 (D00-3-031) |
| WK-SSP0024-0053 | B3 | POST_OPER_LT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL POST_OPER_LT | 있음(SHEET_COLUMNS) | 1 (D00-3-031) |
| WK-SSP0024-0054 | B4 | BUILDING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL BUILDING | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0055 | B4 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL D | 판단불가(대상 단위 PCOL) | 2 (D00-3-052 D00-4b-002) |
| WK-SSP0024-0056 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (D00-4b-002 D00-4b-003 ACT:SSP0024_Shipme) |
| WK-SSP0024-0057 | B4 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL N | 판단불가(대상 단위 PCOL) | 2 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0058 | B4 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 3 (D00-3-050 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0059 | B4 | POST_OPER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL POST_OPER | 있음(SHEET_COLUMNS) | 2 (D00-3-031 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0060 | B4 | POST_OPER_LT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL POST_OPER_LT | 있음(SHEET_COLUMNS) | 1 (D00-3-031) |
| WK-SSP0024-0061 | G4 | btnMaterialId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMaterialId | 있음(FE 소스) | 3 (D00-2-002 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0062 | G4 | btnModelId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnModelId | 있음(FE 소스) | 3 (D00-2-003 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0063 | E5 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 PCOL D | 판단불가(대상 단위 PCOL) | 1 (D00-3-052) |
| WK-SSP0024-0064 | E5 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-050) |
| WK-SSP0024-0065 | G03-WIRE | SSP0024 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0024 화면 | 판단불가(대상 단위 SCREEN) | 14 (ACT:SSP0024_ItembyDivisionPopup..ctor AC) |
| WK-SSP0024-0066 | G5 | CELL_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL CELL_TYPE | 있음(SHEET_COLUMNS) | 1 (D00-3-025) |
| WK-SSP0024-0067 | G5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-020) |
| WK-SSP0024-0068 | G5 | ELECTRODE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL ELECTRODE_TYPE | 있음(SHEET_COLUMNS) | 1 (D00-3-027) |
| WK-SSP0024-0069 | G5 | ITEM_UOM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL ITEM_UOM | 있음(SHEET_COLUMNS) | 1 (D00-3-028) |
| WK-SSP0024-0070 | G5 | MODEL_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL MODEL_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-024) |
| WK-SSP0024-0071 | G5 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (D00-3-026) |
| WK-SSP0024-0072 | G5 | PLANT_SITE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL PLANT_SITE_CODE | 있음(SHEET_COLUMNS) | 2 (D00-3-021 D00-3-022) |
| WK-SSP0024-0073 | G5 | UOM_CONVERT_IN_TACT_TIME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL UOM_CONVERT_IN_TACT_TIME | 있음(SHEET_COLUMNS) | 1 (D00-3-029) |
| WK-SSP0024-0074 | H6 | CELL_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CELL_TYPE | 있음(SHEET_COLUMNS) | 1 (D00-3-025) |
| WK-SSP0024-0075 | H6 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-020) |
| WK-SSP0024-0076 | H6 | ELECTRODE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ELECTRODE_TYPE | 있음(SHEET_COLUMNS) | 1 (D00-3-027) |
| WK-SSP0024-0077 | H6 | ITEM_UOM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_UOM | 있음(SHEET_COLUMNS) | 1 (D00-3-028) |
| WK-SSP0024-0078 | H6 | MODEL_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MODEL_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-024) |
| WK-SSP0024-0079 | H6 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (D00-3-026) |
| WK-SSP0024-0080 | H6 | PLANT_SITE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PLANT_SITE_CODE | 있음(SHEET_COLUMNS) | 2 (D00-3-021 D00-3-022) |
| WK-SSP0024-0081 | H6 | UOM_CONVERT_IN_TACT_TIME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL UOM_CONVERT_IN_TACT_TIME | 있음(SHEET_COLUMNS) | 1 (D00-3-029) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0082 | G1 | clbDivisionId / Division / Division Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisionId / Division / Division Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0024_ItembyDivisionPopup.FindData) |

## W7 기대값 확정 (30)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0083 | E3 | N | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — N: 검증 엔진이 실행됐으나 이 대상(PCOL N)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 0 () |
| WK-SSP0024-0084 | A1 | BtnMaterialId_Click (cs:730) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BtnMaterialId_Click (cs:730): 행 집계 — 대조표 BtnMaterialId_Click (cs:730) '팝업' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SS |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0085 | A1 | BtnModelId_Click (cs:750) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BtnModelId_Click (cs:750): 행 집계 — 대조표 BtnModelId_Click (cs:750) '팝업' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024. |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0086 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 5요소: REVIEW:4 · NA:1 · |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0087 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 A1 5요소: REVIEW:4 · NA:1 · |  | 1 (COMMON:UC-03) |
| WK-SSP0024-0088 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소 |  | 1 (COMMON:UC-06) |
| WK-SSP0024-0089 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 5요소: REVIEW:4 · NA:1 · |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0090 | A1 | ClbDivision_SelectedIndexChanged (cs:771 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ClbDivision_SelectedIndexChanged (cs:771): 행 집계 — 대조표 ClbDivision_SelectedIndexChanged (cs:771) 'cascade' 의 A1 5요소: RE |  | 1 (ClbDivision_SelectedIndexChanged (cs:771) |
| WK-SSP0024-0091 | A1 | D00-1-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-017: 행 집계 — 대조표 D00-1-017 '§1 btnMaterialId / UsrButton' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP0 |  | 1 (D00-1-017) |
| WK-SSP0024-0092 | A1 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-020: 행 집계 — 대조표 D00-1-020 '§1 btnModelId / UsrButton' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP0024 |  | 1 (D00-1-020) |
| WK-SSP0024-0093 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — 대조표 D00-2-001 '§2 cboDivision / SelectedIndexChanged' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP00 |  | 1 (D00-2-001) |
| WK-SSP0024-0094 | A1 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-002: 행 집계 — 대조표 D00-2-002 '§2 btnMaterialId / Click' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP0024_ |  | 1 (D00-2-002) |
| WK-SSP0024-0095 | A1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-003: 행 집계 — 대조표 D00-2-003 '§2 btnModelId / Click' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP0024_GET |  | 1 (D00-2-003) |
| WK-SSP0024-0096 | A1 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-007: 행 집계 — 대조표 D00-3-007 '§3 333 / Query(ds) — 조회결과 바인딩' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP |  | 1 (D00-3-007) |
| WK-SSP0024-0097 | A1 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-008: 행 집계 — 대조표 D00-3-008 '§3 334 / 0..MaxColumnIndex 전체 lock(조회직후)' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SS |  | 1 (D00-3-008) |
| WK-SSP0024-0098 | A1 | D00-3-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-052: 행 집계 — 대조표 D00-3-052 '§3 852 / (nRow,nCol) ← dtRstDataTable(동적 셀 콤보)' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소:  |  | 1 (D00-3-052) |
| WK-SSP0024-0099 | A1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-001: 행 집계 — 대조표 D00-4b-001 '§4b Data.Common / MyDivision / dtMyDivision' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: P |  | 1 (D00-4b-001) |
| WK-SSP0024-0100 | A1 | D00-4f-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-001: 행 집계 — 대조표 D00-4f-001 '§4f ProgressForm / Show' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소: PKG_SSP0024.P_SSP0024 |  | 1 (D00-4f-001) |
| WK-SSP0024-0101 | A1 | D00-4f-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-002: 행 집계 — 대조표 D00-4f-002 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소:  |  | 1 (D00-4f-002) |
| WK-SSP0024-0102 | A1 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-003: 행 집계 — 대조표 D00-4f-003 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소:  |  | 1 (D00-4f-003) |
| WK-SSP0024-0103 | A1 | D00-4f-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-004: 행 집계 — 대조표 D00-4f-004 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 A1 5요소: REVIEW:4 · NA:1 · FAIL 요소:  |  | 1 (D00-4f-004) |
| WK-SSP0024-0104 | A1 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0024/SSP0002_GET_USER_INFO_ |  | 1 (D00-4a-003) |
| WK-SSP0024-0105 | A1 | PKG_SSP0020.P_USER_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0020.P_USER_CHECK: 골든 비교 케이스 없음(PKG_SSP0020.P_USER_CHECK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 1 (D00-4a-003) |
| WK-SSP0024-0106 | A1 | PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 30 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0107 | A1 | PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0024/SSP0024_GET_SHIP_MASTER.m |  | 37 (D00-4a-001 FindButton (cs:230) ACT:SSP00) |
| WK-SSP0024-0108 | A6 | PKG_SSP0020.P_USER_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SSP0020.P_USER_CHECK: 검증 엔진이 실행됐으나 이 대상(SP PKG_SSP0020.P_USER_CHECK)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER |  | 1 (D00-4a-003) |
| WK-SSP0024-0109 | X-ROW | SSP0024_ShipmentMasterElectrode.Re_Desig | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.Re_Design: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LIST_REBIND, 연결된 요소 검사 없음 |  | 5 (ACT:SSP0024_ShipmentMasterElectrode.Re_D) |
| WK-SSP0024-0110 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/RETURN/UI_PROP, 연결된 요 |  | 5 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0111 | M4 | DIVISION_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DIVISION_ID: 검증 엔진이 실행됐으나 이 대상(COL DIVISION_ID)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (D00-3-020) |
| WK-SSP0024-0112 | M4 | SSP0024_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0024_ItembyDivisionPopup: 검증 엔진이 실행됐으나 이 대상(POPUP SSP0024_ItembyDivisionPopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔 |  | 5 (D00-4f-002 D00-4f-003 D00-4f-004 MODAL:S) |

## W9 도구 오류 (102)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0113 | K-SA | SSP0024 화면 | 하네스·환경 | K-SA 도구 오류 — E2E smoke common Search Area 조회영역 토글 |  | 4 (D00-1-010 D00-1-012 D00-1-014 COMMON:UC-) |
| WK-SSP0024-0114 | F1 | SSP0024 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-02168149 RULE_SCREEN / 원장 V-93964b50 RULE_SCREEN / 원장 V-6187bd29 RULE_SCREEN / 원장 V-633bf419 RULE_SCREEN / 원장 V-c9 |  | 106 (D00-3-006 D00-4a-002 D00-4d-002 D00-4d-0) |
| WK-SSP0024-0115 | F3 | SSP0024 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-9573db76 RULE_SCREEN / 원장 V-f0d9887f RULE_SCREEN / 원장 V-1362e622 RULE_SCREEN / 원장 V-94cba1b9 RULE_SCREEN / 원장 V-cc |  | 46 (D00-2-007 D00-3-040 D00-3-041 D00-3-042 ) |
| WK-SSP0024-0116 | F5 | SSP0024 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-6dafbc9b RULE_SCREEN / 원장 V-93153a0e RULE_SCREEN / 원장 V-81203ff7 RULE_SCREEN / 원장 V-aaaaab59 DEFECT / 원장 V-b1a01d3 |  | 16 (D00-3-006 D00-4d-002 D00-4d-004 DeleteBu) |
| WK-SSP0024-0117 | F6 | SSP0024 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-38f078d9 RULE_SCREEN / 원장 V-ed6866f7 RULE_SCREEN / 원장 V-d90abc4b RULE_SCREEN / 원장 V-ba677002 RULE_SCREEN / 원장 V-41 |  | 86 (D00-4a-002 ACT:SSP0024_ShipmentMasterEle) |
| WK-SSP0024-0118 | A5 | 3 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 3 'DeleteButton' 의 A5 8요소: PASS:7 · ERROR:1 |  | 1 (3) |
| WK-SSP0024-0119 | A5 | COMMON:UC-07 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 8요소: PASS:7 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0120 | A5 | D | 하네스·환경 | A5 도구 오류 — 실측[T-33e2ccac]: [검사기 미검증] BUILDING 더블클릭 → 팝업 열림 감지 실패(H6) |  | 1 (PlantSiteByFactoryEEOperation "40,81,82,) |
| WK-SSP0024-0121 | A5 | D00-1-014 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-014 '§1 usrConditionPanel1 / UsrConditionPanel' 의 A5 8요소: PASS:7 · ERROR:1 |  | 1 (D00-1-014) |
| WK-SSP0024-0122 | A5 | D00-1-021 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-021 '§1 spdMain / FpSpread' 의 A5 8요소: PASS:7 · ERROR:1 |  | 1 (D00-1-021) |
| WK-SSP0024-0123 | A5 | D00-1-022 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-022 '§1 spdMain_Sheet1 / SheetView' 의 A5 8요소: PASS:7 · ERROR:1 |  | 1 (D00-1-022) |
| WK-SSP0024-0124 | A5 | D00-2-004 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / CellClick' 의 A5 8요소: PASS:7 · ERROR:1 |  | 1 (D00-2-004) |
| WK-SSP0024-0125 | A5 | D00-3-007 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-007 '§3 333 / Query(ds) — 조회결과 바인딩' 의 A5 8요소: PASS:7 · ERROR:1 |  | 1 (D00-3-007) |
| WK-SSP0024-0126 | A5 | D00-4b-001 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-4b-001 '§4b Data.Common / MyDivision / dtMyDivision' 의 A5 8요소: PASS:7 · ERROR:1 |  | 1 (D00-4b-001) |
| WK-SSP0024-0127 | H2 | 3 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 3 'DeleteButton' 의 H2 8요소: PASS:7 · ERROR:1 |  | 1 (3) |
| WK-SSP0024-0128 | H2 | COMMON:UC-07 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H2 8요소: PASS:7 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0129 | H2 | D | 하네스·환경 | H2 도구 오류 — 실측[T-9a4d0b2a]: [검사기 미검증] BUILDING 더블클릭 → 팝업 열림 감지 실패(H6) |  | 1 (PlantSiteByFactoryEEOperation "40,81,82,) |
| WK-SSP0024-0130 | H2 | D00-1-021 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-021 '§1 spdMain / FpSpread' 의 H2 8요소: PASS:7 · ERROR:1 |  | 1 (D00-1-021) |
| WK-SSP0024-0131 | H2 | D00-1-022 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-022 '§1 spdMain_Sheet1 / SheetView' 의 H2 8요소: PASS:7 · ERROR:1 |  | 1 (D00-1-022) |
| WK-SSP0024-0132 | H2 | D00-2-004 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / CellClick' 의 H2 8요소: PASS:7 · ERROR:1 |  | 1 (D00-2-004) |
| WK-SSP0024-0133 | H2 | D00-3-007 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-3-007 '§3 333 / Query(ds) — 조회결과 바인딩' 의 H2 8요소: PASS:7 · ERROR:1 |  | 1 (D00-3-007) |
| WK-SSP0024-0134 | H2 | D00-4b-001 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-4b-001 '§4b Data.Common / MyDivision / dtMyDivision' 의 H2 8요소: PASS:7 · ERROR:1 |  | 1 (D00-4b-001) |
| WK-SSP0024-0135 | H2 | SSP0024_ShipmentMasterElectrode.CreateSp | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.CreateSpread 의 H2 8요소: PASS:7 · ERROR:1 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0136 | H5 | 3 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 3 'DeleteButton' 의 H5 9요소: PASS:8 · ERROR:1 |  | 1 (3) |
| WK-SSP0024-0137 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H5 9요소: PASS:8 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0138 | H5 | D | 하네스·환경 | H5 도구 오류 — 실측[T-8061a0bf]: [검사기 미검증] BUILDING 더블클릭 → 팝업 열림 감지 실패(H6) |  | 1 (PlantSiteByFactoryEEOperation "40,81,82,) |
| WK-SSP0024-0139 | H5 | D00-1-021 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-021 '§1 spdMain / FpSpread' 의 H5 9요소: PASS:8 · ERROR:1 |  | 1 (D00-1-021) |
| WK-SSP0024-0140 | H5 | D00-1-022 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-022 '§1 spdMain_Sheet1 / SheetView' 의 H5 9요소: PASS:8 · ERROR:1 |  | 1 (D00-1-022) |
| WK-SSP0024-0141 | H5 | D00-2-004 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / CellClick' 의 H5 9요소: PASS:8 · ERROR:1 |  | 1 (D00-2-004) |
| WK-SSP0024-0142 | H5 | D00-3-007 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-3-007 '§3 333 / Query(ds) — 조회결과 바인딩' 의 H5 9요소: PASS:8 · ERROR:1 |  | 1 (D00-3-007) |
| WK-SSP0024-0143 | H5 | SSP0024_ShipmentMasterElectrode.CreateSp | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.CreateSpread 의 H5 9요소: PASS:8 · ERROR:1 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0144 | I1 | SSP0024 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-6c1afdaa RULE_SCREEN / 원장 V-f68916c0 RULE_SCREEN / 원장 V-b45c507e RULE_SCREEN / 원장 V-488f6571 DEFECT / 원장 V-22f8710 |  | 18 (D00-4d-007 D00-4d-010 D00-4e-001 D00-4e-) |
| WK-SSP0024-0145 | D5 | COMMON:UC-05 | 하네스·환경 | D5 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 D5 6요소: PASS:5 · ERROR:1 |  | 1 (COMMON:UC-05) |
| WK-SSP0024-0146 | D5 | D | 하네스·환경 | D5 도구 오류 — 실측[T-3f491a1d]: [검사기 미검증] BUILDING 더블클릭 → 팝업 열림 감지 실패(H6) |  | 1 (D00-3-052) |
| WK-SSP0024-0147 | D5 | SSP0024_ShipmentMasterElectrode.CreateSp | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.CreateSpread 의 D5 6요소: PASS:5 · ERROR:1 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0148 | E3 | 1 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 1 'EditButton' 의 E3 3요소: NOT_RUN:1 · NA:1 · PASS:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0149 | E3 | 2 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 2 'DeleteButton' 의 E3 3요소: NOT_RUN:1 · NA:1 · PASS:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0150 | E3 | 5 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 5 'SpdMain_CellClick' 의 E3 3요소: NOT_RUN:1 · NA:1 · PASS:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0151 | E3 | 6 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 6 'SpdMain_CellClick' 의 E3 3요소: NOT_RUN:1 · NA:1 · PASS:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0152 | E3 | 7 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 7 'SpdMain_CellClick' 의 E3 3요소: NOT_RUN:1 · NA:1 · PASS:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0153 | E3 | D00-4a-003 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 D00-4a-003 '§4a SSP.SSP0002_GET_USER_INFO_LIST / GetSSPUserChe' 의 E3 3요소: NOT_RUN:1 · NA:1 · PASS:1 (미실행 요소가 |  | 1 (D00-4a-003) |
| WK-SSP0024-0154 | E3 | SaveButton (cs:280) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 SaveButton (cs:280) 'Save' 의 E3 3요소: NOT_RUN:1 · NA:1 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton (cs:280)) |
| WK-SSP0024-0155 | G1 | BtnMaterialId_Click (cs:730) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 BtnMaterialId_Click (cs:730) '팝업' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0156 | G1 | BtnModelId_Click (cs:750) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 BtnModelId_Click (cs:750) '팝업' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0157 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RU |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0158 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RU |  | 1 (COMMON:UC-03) |
| WK-SSP0024-0159 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (COMMON:UC-06) |
| WK-SSP0024-0160 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RU |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0161 | G1 | ClbDivision_SelectedIndexChanged (cs:771 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 ClbDivision_SelectedIndexChanged (cs:771) 'cascade' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (ClbDivision_SelectedIndexChanged (cs:771) |
| WK-SSP0024-0162 | G1 | D00-1-012 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-012 '§1 usrLayoutControl2 / UsrLayoutControl' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-1-012) |
| WK-SSP0024-0163 | G1 | D00-1-014 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-014 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-1-014) |
| WK-SSP0024-0164 | G1 | D00-1-017 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-017 '§1 btnMaterialId / UsrButton' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-1-017) |
| WK-SSP0024-0165 | G1 | D00-1-020 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-020 '§1 btnModelId / UsrButton' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-1-020) |
| WK-SSP0024-0166 | G1 | D00-2-002 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-002 '§2 btnMaterialId / Click' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-2-002) |
| WK-SSP0024-0167 | G1 | D00-2-003 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-003 '§2 btnModelId / Click' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-2-003) |
| WK-SSP0024-0168 | G1 | D00-3-007 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-007 '§3 333 / Query(ds) — 조회결과 바인딩' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-3-007) |
| WK-SSP0024-0169 | G1 | D00-3-008 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-008 '§3 334 / 0..MaxColumnIndex 전체 lock(조회직후)' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-3-008) |
| WK-SSP0024-0170 | G1 | D00-3-052 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-052 '§3 852 / (nRow,nCol) ← dtRstDataTable(동적 셀 콤보)' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-3-052) |
| WK-SSP0024-0171 | G1 | D00-4f-001 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4f-001 '§4f ProgressForm / Show' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4f-001) |
| WK-SSP0024-0172 | G1 | D00-4f-002 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4f-002 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4f-002) |
| WK-SSP0024-0173 | G1 | D00-4f-003 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4f-003 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4f-003) |
| WK-SSP0024-0174 | G1 | D00-4f-004 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4f-004 '§4f SSP0024_ItembyDivisionPopup / ShowDialog' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (D00-4f-004) |
| WK-SSP0024-0175 | G1 | FindButton (cs:230) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindButton (cs:230) 'Search' 의 G1 7요소: NA:3 · ERROR:2 · PASS:1 · NOT_RUN:1 |  | 1 (FindButton (cs:230)) |
| WK-SSP0024-0176 | G1 | cboPlantSite / Plant Site | 하네스·환경 | G1 도구 오류 — 원장 V-9312020d SEARCH / E2E smoke cond combo |  | 3 (D00-1-015 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0177 | G1 | clbPlantSiteId / Plant Site / Plant Site | 하네스·환경 | G1 도구 오류 — 원장 V-9312020d SEARCH / E2E smoke cond combo |  | 2 (ACT:SSP0024_ItembyDivisionPopup.FindData) |
| WK-SSP0024-0178 | X-ROW | SSP0024_ItembyDivisionPopup.spdMain_Cell | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NA:2 · NOT_RUN:1 · ERROR:1 |  | 2 (ACT:SSP0024_ItembyDivisionPopup.spdMain_) |
| WK-SSP0024-0179 | X-ROW | SSP0024_ShipmentMasterElectrode.BtnMater | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — NA:5 · PASS:3 · ERROR:3 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0180 | X-ROW | SSP0024_ShipmentMasterElectrode.BtnModel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — NA:5 · PASS:3 · ERROR:3 |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0181 | X-ROW | SSP0024_ShipmentMasterElectrode.ClbDivis | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.ClbD) |
| WK-SSP0024-0182 | X-ROW | SSP0024_ShipmentMasterElectrode.CreateSp | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0183 | X-ROW | SSP0024_ShipmentMasterElectrode.SetChang | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — NA:5 · PASS:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0184 | X-ROW | SSP0024_ShipmentMasterElectrode.checkVal | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 15 (ACT:SSP0024_ShipmentMasterElectrode.chec) |
| WK-SSP0024-0185 | G5 | BtnMaterialId_Click (cs:730) | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 BtnMaterialId_Click (cs:730) '팝업' 의 G5 20요소: ERROR:9 · NOPATH:8 · PASS:3 |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0186 | G5 | BtnModelId_Click (cs:750) | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 BtnModelId_Click (cs:750) '팝업' 의 G5 20요소: ERROR:9 · NOPATH:8 · PASS:3 |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0187 | G5 | COMMON:UC-02 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G5 20요소: ERROR:9 · NOPATH:8 · PASS:3 |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0188 | G5 | D00-4d-009 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4d-009 '§4d SpdMain_CellClick / -' 의 G5 20요소: ERROR:9 · NOPATH:8 · PASS:3 |  | 1 (D00-4d-009) |
| WK-SSP0024-0189 | G5 | D00-4f-001 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4f-001 '§4f ProgressForm / Show' 의 G5 20요소: ERROR:9 · NOPATH:8 · PASS:3 |  | 1 (D00-4f-001) |
| WK-SSP0024-0190 | G5 | MATERIAL_ID | 하네스·환경 | G5 도구 오류 — 원장 V-eb229782 ASIS / 원장 V-8c455e51 ASIS / 원장 V-9e8f9463 ASIS |  | 4 (D00-3-023 D00-4d-013 SpdMain_CellClick () |
| WK-SSP0024-0191 | G5 | MODAL:ElectrodeItemByDivisionModal | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 MODAL:ElectrodeItemByDivisionModal 'FE 실존 모달 (components/modals/ElectrodeItemByDivisio' 의 G5 20요소: ERROR:9 · |  | 1 (MODAL:ElectrodeItemByDivisionModal) |
| WK-SSP0024-0192 | G5 | PLANT_SITE_ID | 하네스·환경 | G5 도구 오류 — 원장 V-eb229782 ASIS / 원장 V-8c455e51 ASIS / 원장 V-9e8f9463 ASIS |  | 1 (D00-3-022) |
| WK-SSP0024-0193 | G5 | SSP0024_ItembyDivisionPopup | 하네스·환경 | G5 도구 오류 — 원장 V-f7fd837a ASIS / 원장 V-d94412da ASIS / 원장 V-eb229782 ASIS |  | 8 (D00-4f-002 D00-4f-003 D00-4f-004 MODAL:S) |
| WK-SSP0024-0194 | G5 | new SSP0024_ItembyDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-f7fd837a |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0195 | G5 | new SSP0024_ItembyDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-d94412da |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0196 | G5 | new SSP0024_ItembyDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-eb229782 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0197 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-827b271c |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0198 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-54b0e725 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0199 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-9e8f9463 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0200 | M4 | BtnMaterialId_Click (cs:730) | 하네스·환경 | M4 도구 오류 — 실측[T-ee2628cf]: [검사기 미검증] PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0201 | M4 | BtnModelId_Click (cs:750) | 하네스·환경 | M4 도구 오류 — 실측[T-29309557]: [검사기 미검증] PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0202 | M4 | CELL_TYPE | 하네스·환경 | M4 도구 오류 — 실측[T-168454e6]: [검사기 미검증] CELL_TYPE: PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (D00-3-025) |
| WK-SSP0024-0203 | M4 | COMMON:UC-02 | 하네스·환경 | M4 도구 오류 — 실측[T-12f21b3b]: [검사기 미검증] PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0204 | M4 | D00-4d-009 | 하네스·환경 | M4 도구 오류 — 실측[T-326b94be]: [검사기 미검증] PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (D00-4d-009) |
| WK-SSP0024-0205 | M4 | D00-4f-001 | 하네스·환경 | M4 도구 오류 — 실측[T-48968bdd]: [검사기 미검증] PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (D00-4f-001) |
| WK-SSP0024-0206 | M4 | ELECTRODE_TYPE | 하네스·환경 | M4 도구 오류 — 실측[T-031b3ee0]: [검사기 미검증] ELECTRODE_TYPE: PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (D00-3-027) |
| WK-SSP0024-0207 | M4 | ITEM_UOM | 하네스·환경 | M4 도구 오류 — 실측[T-62ae19fc]: [검사기 미검증] ITEM_UOM: PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (D00-3-028) |
| WK-SSP0024-0208 | M4 | MATERIAL_ID | 하네스·환경 | M4 도구 오류 — 실측[T-c81b100b]: [검사기 미검증] MATERIAL_ID: PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (D00-3-023 D00-4d-013 SpdMain_CellClick () |
| WK-SSP0024-0209 | M4 | MODAL:ElectrodeItemByDivisionModal | 하네스·환경 | M4 도구 오류 — 실측[T-fa125908]: [검사기 미검증] PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (MODAL:ElectrodeItemByDivisionModal) |
| WK-SSP0024-0210 | M4 | MODEL_ID | 하네스·환경 | M4 도구 오류 — 실측[T-683dc7f9]: [검사기 미검증] MODEL_ID: PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (D00-3-024) |
| WK-SSP0024-0211 | M4 | NICK_NAME | 하네스·환경 | M4 도구 오류 — 실측[T-c180fca0]: [검사기 미검증] NICK_NAME: PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (D00-3-026) |
| WK-SSP0024-0212 | M4 | PLANT_SITE_CODE | 하네스·환경 | M4 도구 오류 — 실측[T-4f7aac39]: [검사기 미검증] PLANT_SITE_CODE: PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (D00-3-021 D00-3-022) |
| WK-SSP0024-0213 | M4 | PLANT_SITE_ID | 하네스·환경 | M4 도구 오류 — 실측[T-5ca34933]: [검사기 미검증] PLANT_SITE_ID: PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (D00-3-022) |
| WK-SSP0024-0214 | M4 | UOM_CONVERT_IN_TACT_TIME | 하네스·환경 | M4 도구 오류 — 실측[T-f4a4a710]: [검사기 미검증] UOM_CONVERT_IN_TACT_TIME: PLANT_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (D00-3-029) |
