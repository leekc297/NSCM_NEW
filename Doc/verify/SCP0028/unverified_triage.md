# SCP0028 미검증 분류 · 2026-11-20 09:47:29 · 라운드 1

- 원장 미검증(ERROR) 138 → 138행. 처리 대상(엔진·대조표·판단·미분류·자동 남음) 54 · 사람 확인 0 · 집계 87
- 집계 행 = 하위 행 판정을 따라감. 하위 행이 풀리면 같이 풀림(따로 고치지 않음).
- 자동 재측정: 없음

| 담당 | 유형 | 행 |
|---|---|---|
| 집계 | 집계 | 87 |
| 엔진 | 검사기공백 | 32 |
| 판단 | 판단 | 16 |
| 엔진 | AI검토:검사기오판 | 3 |
| 엔진 | 데이터전제 | 2 |
| 엔진 | 미분류 | 1 |

## 담당 엔진 (38행)

### AI검토:검사기오판 · 규칙 A1 · 1행
- 처리: AI 판정 검토: 검사기오판 — tools/Harness/verify 의 A1 추적 행 생성기가 TO-BE 에만 있는 PROC 도 AS-IS 대응 SP 없이 골든 비교 대상으로 만들어, 대응 SP 가 없으면 NA 로 내도록 고쳐야 합니다. / AS-IS 의 Model 조회 팝업(btnItemId)은 SCM0002_GET_ITEM_BY_DIVISION_POPUP 을 부르며, AS-IS 화면에는 P_SCM0002_GET_MATERIAL_BY_DIVISION 에 대응하는 SP 호출이 없습니다. 대조할 AS-IS SP 가 없으므로 이 차등 비교 행은 해당없음입니다. 팝업을 바꾼 차이는 T-b3755ed5 행에서 판정합니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:246 ; GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ItembyDivisionPopup.cs:242 ; nscm-fe/features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx:367 → 원인(파일:줄) 확인 · 검사기 수정 · 결함 유형(T번호) 기록 · 전 화면 공통이면 룰 등록(confirmed_requirements.csv → tobe_rule_registry.py --build/--check)
- T-18793b28 [TRACE] PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION | [판정필요] AS-IS 의 Model 조회 팝업(btnItemId)은 SCM0002_GET_ITEM_BY_DIVISION_POPUP 을 부르며, AS-IS 화면에는 P_SCM0002_GET_MATERIAL_BY_DIVISION 에 대응하는 SP 호출이 없습니다. 대조할 AS-IS SP 가 없으므로 이 차등 비교 행은 해당없음입니다. 팝업을 바꾼 차이는 T-b3755ed5 행에서 판정합니다.

### AI검토:검사기오판 · 규칙 A6 · 1행
- 처리: AI 판정 검토: 검사기오판 — tools/Harness/verify/sort_check.py: AS-IS ORDER BY 가 없는 SP 에도 AS-IS 콜레이션(NULL 먼저·대소문자 무시) 기대를 적용해 판정필요로 남겼습니다. / AS-IS 의 Input 조회 SP 는 임시 테이블을 ORDER BY 없이 그대로 반환하므로, 비교 기준이 될 AS-IS 정렬 순서가 없습니다. TO-BE 가 ORDER BY 를 넣은 것은 CR-075 ①의 결정적 순서 요건을 충족하는 것입니다. Division, From Site, To Site, Item 은 INNER JOIN 을 통과한 값이라 NULL 행이 생기지 않으므로 NULL 먼저 기대는 이 SP 에 맞지 않습니다. / 근거 Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:112953 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:112847 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:112851 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/ → 원인(파일:줄) 확인 · 검사기 수정 · 결함 유형(T번호) 기록 · 전 화면 공통이면 룰 등록(confirmed_requirements.csv → tobe_rule_registry.py --build/--check)
- EG-c77e3290 [RULE_SCREEN] SCP0028 문자 정렬 PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | [판정필요] AS-IS 의 Input 조회 SP 는 임시 테이블을 ORDER BY 없이 그대로 반환하므로, 비교 기준이 될 AS-IS 정렬 순서가 없습니다. TO-BE 가 ORDER BY 를 넣은 것은 CR-075 ①의 결정적 순서 요건을 충족하는 것입니다. Division, From Site, To Site, Item 은 INNER JOIN 을 통과한 값이라 NULL 행이 생기지 않으므로 

### AI검토:검사기오판 · 규칙 H10 · 1행
- 처리: AI 판정 검토: 검사기오판 — Doc/e2e/specs: InsertRow 가 빈 화면에서는 insert 대신 LOT_SIZE 칸 편집으로 편집 중 상태를 만들고, 그 상태를 확인한 뒤에 Input 을 눌러야 합니다. / AS-IS Insert 버튼의 InsertRow 는 내용이 비어 있어 새 행이 생기지 않고, TO-BE Insert 도 같은 이유로 아무 동작을 하지 않습니다. 시험 기록도 insert 뒤 신규 0행, 편집기 null 이어서 편집 중 상태가 만들어지지 않은 채 Input 을 눌렀습니다. 그래서 MSG00680 이 뜰 조건이 없었고, 이 시나리오는 이 화면에서 대상이 없습니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:571 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:202 ; nscm-fe/features/shipping/src/pages/shipment-lot-size/Shipme → 원인(파일:줄) 확인 · 검사기 수정 · 결함 유형(T번호) 기록 · 전 화면 공통이면 룰 등록(confirmed_requirements.csv → tobe_rule_registry.py --build/--check)
- V-a1923fff [RULE_SCREEN] SCP0028 시나리오 [자동] 편집 중 Input 실행 → MSG00680(DM-52 일반 규칙) | [FAIL] AS-IS Insert 버튼의 InsertRow 는 내용이 비어 있어 새 행이 생기지 않고, TO-BE Insert 도 같은 이유로 아무 동작을 하지 않습니다. 시험 기록도 insert 뒤 신규 0행, 편집기 null 이어서 편집 중 상태가 만들어지지 않은 채 Input 을 눌렀습니다. 그래서 MSG00680 이 뜰 조건이 없었고, 이 시나리오는 이 화면에서 대상이 없습니다.

### 검사기공백 · 규칙 A6 · 2행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-2c20a3fc [TRACE] PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | 실측[T-2c20a3fc]: [대조표 오기 의심] PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 배선 메뉴 SCM0002,SCP0033,SSP0019 · 이 화면 실행 중 호출 0건(Doc/verify/SCP0028/sqllog_calls.json) · 대조표 해당 행의 구현 위치 확인 | [미검증] 검사기(so
- T-653f1a5d [TRACE] PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION | 실측[T-653f1a5d]: [대조표 오기 의심] PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION — 배선 메뉴 COM0013 · 이 화면 실행 중 호출 0건(Doc/verify/SCP0028/sqllog_calls.json) · 대조표 해당 행의 구현 위치 확인 | [미검증] 검사기(sort_check.py(AS-IS 

### 검사기공백 · 규칙 A7 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-8da88867 [SP] SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT |  | [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 

### 검사기공백 · 규칙 C2 · 5행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정 · AI 판정 검토: 검사기오판 — tools/Harness/verify 는 다른 화면 결함원장(DM-139)의 확인 항목을 GENERAL 행으로 만들기 전에, 그 대상 칸이 이 화면 그리드에 있는지 보지 않습니다. / SCP0028 그리드에는 버전, Measure(MKT_FCST, SCM_FCST, AS_In_Req, VMI_In_Req), Unit Price, AS From Site 칸이 없습니다. 칸은 DIVISION_ID, OPERATION_GROUP_ID, FROM_SITE, TO_SITE, ITEM_ID, TRANS_MODE, LOT_SIZE, INCREMENT, VALID_YN, SPLIT_YN 뿐이고, 편집할 때 DIVISION_ID 부터 TRANS_MODE_NAME 까지 잠깁니다. 그래서 DMF0082 의 Measure 권한 통제 결함 유형은 이 화면에 적용할 대상이 없습니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:66 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shi
- V-2611b990 [GENERAL] [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 C2 판정 2행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음
- V-9b370c0f [GENERAL] [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 C2 판정 2행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음
- V-df3bcadf [GENERAL] [결함 유형 묶음 C2-G06 · 4건] 그리드 상위 셀 변경 시 하위 셀 cascade | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 C2 판정 2행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음
- V-e9891c92 [GENERAL] [DMF0003 결함 유형] AS From Site 입력 후 W35~W38 수량 | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 C2 판정 2행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음
- V-f3e94ee4 [GENERAL] [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 C2 판정 2행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음

### 검사기공백 · 규칙 DB-SYN · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-52d59336 [TRACE] PR_GET_MNU_BTN_AUTH | 실측[T-52d59336]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(syn_check.py·fixture dberr)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)

### 검사기공백 · 규칙 E4 · 3행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-0caf6c62 [TRACE] MSG00031 | MSG00031 — FindDelete 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(FindDelete)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-4677b9e5 [TRACE] MSG00284 | MSG00284 — FindDelete 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(FindDelete)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-1f64fec6 [RULE_SCREEN] SCP0028 시나리오 KO Increment > Lot Size 저장 → KO 검증 문구 | [측정 경로 없음] KO Increment > Lot Size 저장 → KO 검증 문구: [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0005,SSP0014) — 계정 언어 전환 생략(T200) · 저장 요청 0 · 편집기 null · 계정 dana.robot(Div=40;SCP Planner) → lang:0행·신규0·호출0·요청42 → 끝:0행·신규0·호출0·요청42 · 문서 S

### 검사기공백 · 규칙 F4 · 2행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-6b9a8ce8 [TRACE] PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | [측정 경로 없음] PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT: 이번 Save 는 main/SAVE 로 저장(정상 호출) — 이 SP 경로 main/INSERT 는 다른 시트·버튼 저장이라 이 시험(메인 셀 수정·Save)에서 미측정(T210) · [세션 그룹 재현 T344] 'DM Administrator' 제외: 편집 가능 · 저장 호출 ma
- T-fad117f6 [TRACE] PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: SCM0002/ModelPopup/SEARCH, SCP0033/popup/SEARCH, SSP0019/popup/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 검사기공백 · 규칙 G1 · 2행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정 · AI 판정 검토: 검사기오판 — tools/Harness/verify: 일괄삭제 팝업 저장 경로(FindDelete)의 메시지를 G1 조회조건 smoke 대상으로 배정해, 팝업을 열어 삭제를 실행하지 않는 smoke 검사가 이 행을 측정하지 못했다. / MSG00031 은 일괄삭제 팝업(btnDelete) 저장 성공 뒤 FindDelete 에서 띄우는 삭제 완료 메시지로 조회조건과 관계가 없다. TO-BE 도 일괄삭제 성공 시 DELETE_SUCCESS(MSG00031) 를 띄우지만 실행으로 확인하지 않았으므로 미검증으로 둔다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:312 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:544 ; nscm-fe/features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx:152
- V-86e7f1e2 [ASIS] MSG00031 |  | [미검증] 검사기(smoke 조회조건 동작·_verify)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(smoke 조회조건 동작·_verify)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(smoke 조회조건 동작·_verify)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W
- V-a89007be [ASIS] MSG00284 |  | [미검증] 검사기(smoke 조회조건 동작·_verify)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(smoke 조회조건 동작·_verify)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(smoke 조회조건 동작·_verify)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W

### 검사기공백 · 규칙 G2 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정 · AI 판정 검토: 검사기오판 — Doc/e2e/specs/_verify.spec.ts: Model 텍스트 조건(UsrMultiLineEditor, 기준표 없음 DM)을 실행 대상으로 잡지 못해 측정 행이 생성되지 않았다. / AS-IS 조회조건 Model(txtItemId) 은 입력 문자열을 p_item_id 로 조회 SP 에 넘기는 실재 조건이다. 검사기 _verify.spec 이 이 대상을 실행하지 않아 결과가 없으므로 미검증으로 둔다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:337 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:356
- V-db17a330 [SEARCH] 조회조건 Model |  | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W

### 검사기공백 · 규칙 G4 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정 · AI 판정 검토: 검사기오판 — tools/Harness/verify/mapping_trace.py로 추정합니다. 버튼 이름(btnDelete)으로 찾아서 asis_method 열의 btnDelete_Click과 맞추지 못한 것으로 보이며, 실제 메시지 생성 위치는 찾지 못했습니다. / AS-IS Delete 버튼은 SCM0002_ShipmentLotSizePopup을 D 모드로 여는 버튼이므로 대상이 있고 NA가 아닙니다. 검사기는 popup_args.csv에 btnDelete_Click이 없다고 기록했지만, 실제로는 같은 파일에 btnDelete_Click의 팝업 인자 행 2건이 있습니다. 팝업 조회조건 표시, 라벨, 활성 상태를 재지 못했으므로 결과는 ERROR로 둡니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:118 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:298 ; GSCM/06.UIL/G
- T-d6ad4a4e [TRACE] btnDelete | [측정 경로 없음] AS-IS btnDelete 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인)

### 검사기공백 · 규칙 G5 · 4행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정 · AI 판정 검토: 검사기오판 — tools/Harness/verify/trace_all.py: G5 검사 행을 만들 때 condition 이 popup=false 인 조회조건도 대상에 넣었고, 팝업 내부 컨트롤의 asis_ref 를 메인 조회조건에 붙였습니다. / AS-IS 메인 화면의 From Site(clbFromSite)는 Division 기준으로 목록을 채우는 체크리스트 콤보이고, 연결된 팝업이 없습니다. 메인 cs 에서 팝업을 여는 곳은 btnItemId_Click 과 btnInput/btnDelete_Click 세 곳뿐이므로 팝업 인자 연동을 검사할 대상이 없습니다. asis_ref 의 From Site 필수 검사는 일괄입력 팝업 SCM0002_ShipmentLotSizePopup 안의 다른 컨트롤에 대한 것입니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.Designer.cs:42 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Ship
- T-247bdc3c [TRACE] clbFromSite / From Site | 실측[T-247bdc3c]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행
- T-3dbd9fe5 [TRACE] TRANS_MODE_CODE / Trans Mode | 실측[T-3dbd9fe5]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하
- T-57afcab2 [TRACE] clbToSite / To Site | 실측[T-57afcab2]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행
- V-99331be4 [SEARCH] 조회조건 Model |  | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_chec

### 검사기공백 · 규칙 H6 · 3행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정 · AI 판정 검토: 검사기오판 — tools/Harness/verify/mapping_checkdefs.csv: 41행의 H6 정의가 ELEM 전체에 적용되어, popup=false인 조회조건 콤보에도 팝업 표준 행이 만들어졌습니다. / To Site 조회조건은 AS-IS에서 체크 목록 콤보(UsrCheckedList)이고 팝업 창을 여는 컨트롤이 아닙니다. 팝업 표준(OK→CLOSE 버튼 순서, No. 컬럼, 조회 건수)을 적용할 대상이 없습니다. SCP0007 From City 행을 콤보라서 판정오류로 본 지난 판정과 원인이 같습니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.Designer.cs:63 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:170
- T-0855373f [TRACE] clbToSite / To Site | 실측[T-0855373f]: 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)
- T-449b82ac [TRACE] clbFromSite / From Site | 실측[T-449b82ac]: 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)
- T-c7a94f1d [TRACE] TRANS_MODE_CODE / Trans Mode | 실측[T-c7a94f1d]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작

### 검사기공백 · 규칙 I1 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-ca2072cf [RULE_SCREEN] SCP0028 시나리오 KO 변경 없이 저장 → KO 수정사항 없음 알림 | [측정 경로 없음] KO 변경 없이 저장 → KO 수정사항 없음 알림: [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0005,SSP0014) — 계정 언어 전환 생략(T200) · 저장 요청 0 · 편집기 null · 계정 dana.robot(Div=40;SCP Planner) → lang:0행·신규0·호출0·요청42 → 끝:0행·신규0·호출0·요청42 · 문서 SCPSSP-1(사용

### 검사기공백 · 규칙 K3 · 6행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정 · 2026-11-20 SCP0005 미분류 18행(A4 무판정 · 팝업 원문 연결 · 조회조건 팝업 경로 · 버튼 이름 대응 · K3 실측 범위 밖)
- V-04302ccf [GENERAL] [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,6,0,6 · 0행 TRANS_MODE_NAME 표시값 'AIR' · Ctrl+C 클립보드 'AIR'(일치) · 우클릭 Copy 'AIR'(일치) | ctrl PASS: Ctrl+클릭 0행·2행(TRANS_MODE_NA
- V-4c3670c9 [DEFECT] 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | f5 PASS: F5 → 조회 호출 1건(SEARCH) · 페이지 이동 0회 · 미포함: 팝업 그리드(이 시험은 메인 그리드만), Sort/Filter·정렬 후 동작(K1 smoke 행) → 실측 범위 PASS · 미포함 항목은 수동 검수 대상(작업 원장 W7)
- V-6cf2af49 [GENERAL] [결함 유형 묶음 K3-G02 · 2건] 조회 단축키(F5) 실행 | f5 PASS: F5 → 조회 호출 1건(SEARCH) · 페이지 이동 0회 · 미포함: 팝업 그리드(이 시험은 메인 그리드만) → 실측 범위 PASS · 미포함 항목은 수동 검수 대상(작업 원장 W7)
- V-729c8d58 [CONFIRMED] 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | ctrl PASS: Ctrl+클릭 0행·2행(TRANS_MODE_NAME) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함: 팝업 그리드(이 시험은 메인 그리드만) → 실측 범위 PASS · 미포함 항목은 수동 검수 대상(작업 원장 W7)
- V-78baf3af [DEFECT] 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | ctrl PASS: Ctrl+클릭 0행·2행(TRANS_MODE_NAME) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함: 팝업 그리드(이 시험은 메인 그리드만) → 실측 범위 PASS · 미포함 항목은 수동 검수 대상(작업 원장 W7)
- V-cbcda052 [GENERAL] [결함 유형 묶음 K3-G01 · 1건] 그리드 Ctrl+클릭 다중 선택(팝업 그리드 포함) | ctrl PASS: Ctrl+클릭 0행·2행(TRANS_MODE_NAME) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함: 팝업 그리드(이 시험은 메인 그리드만) → 실측 범위 PASS · 미포함 항목은 수동 검수 대상(작업 원장 W7)

### 데이터전제 · 규칙 G7 · 1행
- 처리: 검사기가 조회조건·Division·행 선택을 바꿔 측정 전제를 만족시키도록 보완(ensureRows 계열 · 전 후보 순회) · AI 판정 검토: 검사기오판 — tools/AsisFacts: UsrComboBox.DataBind(Data.Type.YesOrNo) 원천을 CommonData.YesOrNo(Code=Name=Y/N)로 풀지 못해 표시 열을 '해석 불가'로 남겼습니다. / AS-IS 조회조건 Valid 콤보는 YesOrNo 목록(Code·Name 모두 Y, N)에 ALL 을 더해 바인딩하므로 코드와 이름이 같은 값입니다. 검사기는 UsrComboBox 의 표시 열을 해석하지 못해 비교하지 못했고 화면 값은 재지 않았습니다. 원문만으로 PASS 로 바꾸지 않고 미검증으로 둡니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:135 ; GSCM/03.BIZ/GSCM.Common/BLL/CommonData.cs:44 ; nscm-fe/features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx:32
- V-00ec53f0 [SEARCH] 조회조건 Valid | [화면 초기(선택 Division*=81)] AS-IS 표시 열 해석 불가(cboValid: 컨트롤 유형 UsrComboBox · 바인딩 없음) · 원천 STATIC YesOrNo @InitControls (SCP0028_Shipment_Lot_Size.cs:135 ← SCP0028_Shipment_Lot_Size) · 표현 CODE → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 데이터전제 · 규칙 H2 · 1행
- 처리: 검사기가 조회조건·Division·행 선택을 바꿔 측정 전제를 만족시키도록 보완(ensureRows 계열 · 전 후보 순회) · AI 판정 검토: 검사기오판 — tools/Harness/verify: action == FlagM 같은 실행 중 상태가 들어간 조건을 조회 결과에서 찾았습니다. Input 팝업으로 후보 행을 불러와 편집하고 되돌리는 경로로 대상 행을 만들어야 합니다. / 이 색 규칙은 Save 때 수정 표시(M)가 붙은 행 가운데 LOT_SIZE·INCREMENT 가 비고 VALID_YN=Y, SPLIT_YN=N 인 행의 상태 칸에만 적용됩니다. 이런 행은 Input 팝업으로 불러온 후보 행을 편집한 뒤에만 생깁니다. 검사기는 일반 조회 265행에서 조건에 맞는 행을 찾았으나 0행이어서 재지 못했습니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:587 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:595 ; nscm-fe/features/shipping/src/pages/shipment-lot-size/ShipmentL
- V-a99ddb18 [ASIS] siMain.SetBGColor | [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 265행 중 조건 만족 0행 — 조건 RAW(action == CAppSetting.FlagM) && COL(LOT_SIZE)=="" && COL(INCREMENT)=="" && CO

### 미분류 · 규칙 G1 · 1행
- 처리: 분류표(unverified_classes.csv)에 유형 정규식을 더하고 원인에 맞게 검사기 보완 · AI 판정 검토: 검사기오판 — tools/E2E: 조회조건 후보를 고를 때 코드값 후보를 설명 컬럼 FROM_SITE_DESCRIPTION 과 대조해 일치 후보를 못 찾고, 기본 조회 결과에 없는 후보를 골라 0행이 되었다. / From Site 에 'AU000062_81-P' 하나를 골라 조회한 요청에 값은 실렸지만 결과가 0행이라 조건이 제대로 걸렸는지 판정하지 못했다. 검사기가 결과 컬럼 FROM_SITE_DESCRIPTION 값에서 후보를 찾지 못해 기본 조회 결과(1940행)에 없는 후보를 임의로 고른 측정 실패다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:334 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:352
- V-dd4f9db4 [SEARCH] 조회조건 From Site | [멀티선택 From Site] 'AU000062_81-P' 1개 선택 조회 → 0행 · FROM_SITE_DESCRIPTION 값 없음 (기본 ALL 1940행) · 조회 요청 1건(본문에 'AU000062_81-P' 포함) · 조건 칸 표시 'AU000062_81-P' · 결과 컬럼 FROM_SITE_DESCRIPTION 값에서 고를 후보를 못 찾아 임의 후보 선택 — [측정 실패] 결과에

## 담당 판단 (16행)

### 판단 · 규칙 A6 · 1행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록 · AI 판정 검토: 검사기오판 — tools/Harness/verify/sort_check.py: 그리드에 바인딩되지 않는 TO-BE 권한 SP 를 A6 정렬 대상에서 빼지 않아 판정 불가로 남겼습니다. / PR_GET_MNU_BTN_AUTH 는 AS-IS 화면 원문(GSCM/)과 AS-IS SP 원문(Doc/_legacy_source/DB_DDL)에서 검색해도 0건입니다. AS-IS 의 Input·Delete 버튼은 클릭 이벤트만 연결돼 있습니다. 이 SP 는 버튼 권한을 조회하는 SP 로 그리드에 표시되지 않으므로 CR-075 ③에 따라 정렬 대상이 아닙니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:117 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:132
- T-6dc0e2d5 [TRACE] PR_GET_MNU_BTN_AUTH | 실측[T-6dc0e2d5]: 검증 엔진이 실행됐으나 이 대상(SP PR_GET_MNU_BTN_AUTH)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 시나리오 수동 확인 또는 엔진 확장 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 B6 · 1행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록 · AI 판정 검토: 검사기오판 — tools/Harness/verify 의 B6 판정은 조회조건 기준표 행이 없으면 ERROR 로 끝납니다. 이때는 AS-IS 컨트롤 형식(UsrComboBox 단일, DataBind isALL 인자)으로 기대값을 만들어야 합니다. / AS-IS Valid 조회조건은 DropDownList 단일 콤보이고, DataBind 두 번째 인자 true 와 조회 시 ALL 을 null 로 보내는 처리로 ALL 항목이 있습니다. TO-BE 도 CustomDropdown 단일 선택에 allOption 이 있고, 실측값도 다중=false, ALL=true 로 같습니다. 기준표에 행이 없어서 검사기가 비교하지 못하고 ERROR 로 남긴 것입니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.Designer.cs:37 ; GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.Designer.cs:142 ; GSCM/0
- V-5d06fca9 [SEARCH] 조회조건 Valid | 조회조건 Valid 사양 기준 없음 — 화면 다중=false · ALL=true → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 G5 · 2행
- 처리: TO-BE 룰 원장(Doc/verify/_tobe_rule_registry.md)·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록 · AI 판정 검토: 검사기오판 — tools/Harness/verify/popup_args_check.py: AS-IS 인자 이름 _action_flag 와 TO-BE prop 이름 mode 를 짝짓지 못해, 고정값 D 가 전달되는데도 전달 안 함으로 기록했습니다. / AS-IS Delete 버튼은 팝업에 _action_flag=D 와 Division 을 넘기고, 팝업은 그 값을 p_action_flag 로 조회 SP 에 싣습니다. TO-BE Delete 버튼은 batchMode 를 D 로 정한 뒤 mode prop 으로 팝업에 넘기고, 팝업은 그 값을 actionFlag 로 조회 조건에 싣습니다. 두 인자가 모두 전달되므로 동작이 같습니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:299 ; GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ShipmentLotSizePopup.cs:291 ; nscm-fe/features/shipping/src/pages/shipment-lot-size/ShipmentLo
- V-480372c9 [ASIS] popItem.Form_Load("D", sDivision_id.ToString()) | AS-IS SCM0002_ShipmentLotSizePopup 호출 인자 ↔ TO-BE ShipmentLotSizeBatchModal (nscm-fe/features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx:395) — [ERROR] _action_flag: [확인 대상] AS-IS 고정 플래그 _action_flag=D 를 TO-
- V-86b2f489 [ASIS] popItem.Form_Load("I", sDivision_id.ToString()) | AS-IS SCM0002_ShipmentLotSizePopup 호출 인자 ↔ TO-BE ShipmentLotSizeBatchModal (nscm-fe/features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx:395) — [ERROR] _action_flag: [확인 대상] AS-IS 고정 플래그 _action_flag=I 를 TO-

### 판단 · 규칙 H6 · 2행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- EG-6cc339e1 [RULE_SCREEN] SCP0028 팝업 SCM0002_ShipmentLotSizePopup BTN:Input COUNT | 기대 조회 건수 표시 · 실제 건수 문구 없음 · 팝업 글자 'SSP Lot Size - 입력 Div ​ From Site ​ To Site ​ Model/Nickname Operation group ​ Search(F5) No Div Operation group From S' · 근거 문서 DM-C8 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-a239a7e1 [TRACE] txtItemId / Model / Item Id | E2E smoke cond popup / 실측[T-a239a7e1]: E2E smoke cond popup → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 M3 · 1행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- EG-273588ca [RULE_SCREEN] SCP0028 팝업 SCM0002_ShipmentLotSizePopup BTN:Input DATA | 기대 팝업 조회 오류 없음 · 데이터 있음(No Permission 0) · 실제 자동 조회 6건 · Search 0건 · 행 0 · 오류 없음 · 알림 'From Site 값은 필수 입력 항목입니다. Confirm' · 근거 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 M4 · 8행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- EG-ea38ffcb [RULE_SCREEN] SCP0028 팝업 SCM0002_ItembyDivisionPopup COND:Model PICK_DBL | 기대 더블클릭 → OK 와 같은 결과 · 실제 더블클릭 후 닫히지 않음 — AS-IS 더블클릭 확정 여부 SCM0002_ItembyDivisionPopup.cs:319 · 근거 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-2a9cd623 [TRACE] btnDelete | 실측[T-2a9cd623]: 검증 엔진이 실행됐으나 이 대상(BTN btnDelete)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-41bb3f1f [TRACE] TRANS_MODE_CODE / Trans Mode | 실측[T-41bb3f1f]: 검증 엔진이 실행됐으나 이 대상(COL TRANS_MODE_CODE)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-5bb8509f [TRACE] clbFromSite / From Site | 실측[T-5bb8509f]: 검증 엔진이 실행됐으나 이 대상(COND clbFromSite)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-84c5ee4c [TRACE] clbToSite / To Site | 실측[T-84c5ee4c]: 검증 엔진이 실행됐으나 이 대상(COND clbToSite)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-8ef356b6 [TRACE] btnInput | 실측[T-8ef356b6]: 검증 엔진이 실행됐으나 이 대상(BTN btnInput)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-ba663c76 [TRACE] txtItemId / Model / Item Id | 실측[T-ba663c76]: 검증 엔진이 실행됐으나 이 대상(COND txtItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-c5782dcb [TRACE] btnItemId | 실측[T-c5782dcb]: 검증 엔진이 실행됐으나 이 대상(BTN btnItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 MS1 · 1행
- 처리: TO-BE 룰 원장(Doc/verify/_tobe_rule_registry.md)·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록 · AI 판정 검토: 검사기오판 — tools/Harness/verify/i18n_static.py 는 바로 앞에 t(코드, '기본 문구') 형태가 있을 때만 기본 문구로 빼 줍니다. 그래서 remember(MSG.INC_GT_LOT, '...') 처럼 등록 코드 상수를 첫 인자로 받는 래퍼 함수의 기본 문구를 고정 한글로 잘못 잡았습니다. / AS-IS 는 Lot Size 가 Increment 보다 작으면 MSG00099 「{0}은 {1} 보다 클 수 없습니다.」를 띄웁니다(cs:764). TO-BE 는 KO·EN·CN 에 모두 등록된 코드 MSG01127 을 t() 로 읽어 같은 문구를 띄웁니다. 검사기가 고정 한글로 잡은 문자열은 그 코드가 없을 때만 쓰는 기본 문구입니다. / 근거 GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:764 ; nscm-fe/features/shipping/src/pages/shipment-lot-size/hooks/useShipmentLotSizeValidation.ts:52 ; nscm-fe/features
- EG-bd80125c [RULE_SCREEN] SCP0028 화면 고정 한글 {0}은 {1} 보다 클 수 없습니다. | [다국어 확인 필요] 화면 고정 한글 · nscm-fe/features/shipping/src/pages/shipment-lot-size/hooks/useShipmentLotSizeValidation.ts:52 · '{0}은 {1} 보다 클 수 없습니다.'

## 담당 집계 (87행)

### 집계 · 규칙 A6 · 2행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-e57376d2 [TRACE] 팝업 Form_Load `//FindData();` (cs:146) · **'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파 | 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 A6 6요소: ERROR:3 · PASS:3
- T-f4dca6bb [TRACE] Query(ds) FindData (cs:368) · `useTabProcQuery` o_rc1 바인딩 | 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 A6 6요소: ERROR:3 · PASS:3

### 집계 · 규칙 DB-SYN · 4행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-03160f3d [TRACE] 팝업 Form_Load `//FindData();` (cs:146) · **'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파 | 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 DB-SYN 7요소: PASS:6 · ERROR:1
- T-161e01f5 [TRACE] Query(ds) FindData (cs:368) · `useTabProcQuery` o_rc1 바인딩 | 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 DB-SYN 7요소: PASS:6 · ERROR:1
- T-25c746d3 [TRACE] SaveButton SaveData (cs:574~) · `hotkeyConfig.save` → handleSave | 행 집계 — 대조표 SaveButton SaveData (cs:574~) '`hotkeyConfig.save` → handleSave' 의 DB-SYN 7요소: PASS:6 · ERROR:1
- 외 1행(unverified_triage.csv)

### 집계 · 규칙 E4 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-86208af2 [DEFECT] Lot Size<Increment 검증 메시지 | 규칙 E4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-1f64fec6] SCP0028 시나리오 KO Increment > Lot Size 저장 → KO 검증 문구: [측정 경로 없음] KO Increment > Lot Size 저장 → KO 검증 문구: [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0005,SSP0014) — 계정 언어 전환 생략(T200) ·

### 집계 · 규칙 F4 · 4행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-14732ce2 [TRACE] SaveButton SaveData (cs:574~) · `hotkeyConfig.save` → handleSave | 행 집계 — 대조표 SaveButton SaveData (cs:574~) '`hotkeyConfig.save` → handleSave' 의 F4 7요소: PASS:5 · ERROR:2
- T-80e70b77 [TRACE] 팝업 Form_Load `//FindData();` (cs:146) · **'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파 | 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 F4 7요소: PASS:5 · ERROR:2
- T-98554096 [TRACE] Query(ds) FindData (cs:368) · `useTabProcQuery` o_rc1 바인딩 | 행 집계 — 대조표 Query(ds) FindData (cs:368) '`useTabProcQuery` o_rc1 바인딩' 의 F4 7요소: PASS:5 · ERROR:2
- 외 1행(unverified_triage.csv)

### 집계 · 규칙 G1 · 10행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-59af1afb [TRACE] `SetChangedControl` cascade (cs:158~171) · Division 변경 → From/To Site 재조회(divisi | 행 집계 — 대조표 `SetChangedControl` cascade (cs:158~171) 'Division 변경 → From/To Site 재조회(divisionId 키) + res' 의 G1 9요소: PASS:6 · ERROR:3
- T-6c69b6ac [TRACE] btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) · BtnArea 커스텀 버튼(SubTitle `customButto | 행 집계 — 대조표 btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) 'BtnArea 커스텀 버튼(SubTitle `customButtons`) → 팝업 → GE' 의 G1 9요소: PASS:6 · ERROR:3
- T-7754adb7 [TRACE] 팝업 Form_Load `//FindData();` (cs:146) · **'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파 | 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 G1 9요소: PASS:6 · ERROR:3
- 외 7행(unverified_triage.csv)

### 집계 · 규칙 G2 · 2행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-a7ba5dc9 [CONFIRMED] Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | 규칙 G2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-db17a330] 조회조건 Model: | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작
- V-e08bf28a [DEFECT] Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | 규칙 G2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-db17a330] 조회조건 Model: | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작

### 집계 · 규칙 G4 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-380b4c0f [TRACE] `SetChangedControl` cascade (cs:158~171) · Division 변경 → From/To Site 재조회(divisi | 행 집계 — 대조표 `SetChangedControl` cascade (cs:158~171) 'Division 변경 → From/To Site 재조회(divisionId 키) + res' 의 G4 10요소: PASS:9 · ERROR:1

### 집계 · 규칙 G5 · 13행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-3a8b1d0e [TRACE] 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) · 공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄  | 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄 3칸)' 의 G5 16요소: ERROR:8 · NA:8
- T-47a23fbe [TRACE] **팝업 OK `SaveData` (cs:308~369)** · `handleConfirm` — 그리드 0행→`MSG01091` / 체크 0건→ | 행 집계 — 대조표 **팝업 OK `SaveData` (cs:308~369)** '`handleConfirm` — 그리드 0행→`MSG01091` / 체크 0건→`MSG00' 의 G5 16요소: ERROR:8 · NA:8
- T-484c739b [TRACE] 팝업 Form_Load `//FindData();` (cs:146) · **'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파 | 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 G5 16요소: ERROR:8 · NA:8
- 외 10행(unverified_triage.csv)

### 집계 · 규칙 H2 · 12행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-4f008f49 [TRACE] SmartColMerge (cs:371,438,721, #9/#12/#15) · `CustomMergeManager` allowMerging C | 행 집계 — 대조표 SmartColMerge (cs:371,438,721, #9/#12/#15) '`CustomMergeManager` allowMerging Cells, MERGE_COL' 의 H2 5요소: PASS:3 · ERROR:2
- T-4f69770d [TRACE] SCP0028_Shipment_Lot_Size.CreateSpread | 진입점 집계 — 대조표 SCP0028_Shipment_Lot_Size.CreateSpread 의 H2 5요소: PASS:3 · ERROR:2
- T-730ab462 [TRACE] checkValidSize LOT<INC / 0값 (cs:762~773) · `useShipmentLotSizeValidation` | 행 집계 — 대조표 checkValidSize LOT<INC / 0값 (cs:762~773) '`useShipmentLotSizeValidation`' 의 H2 5요소: PASS:3 · ERROR:2
- 외 9행(unverified_triage.csv)

### 집계 · 규칙 H6 · 17행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-1417e33a [TRACE] **toolbar DeleteButton remove-new (cs:213~224, R4)** · `hotkeyConfig.delete = () | 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** '`hotkeyConfig.delete = () => undefined` (버튼 노출+무동작' 의 H6 16요소: ERROR:12 · PASS:4
- T-31170afd [TRACE] 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) · 공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄  | 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄 3칸)' 의 H6 16요소: ERROR:12 · PASS:4
- T-505b6f16 [TRACE] 팝업 Form_Load `//FindData();` (cs:146) · **'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파 | 행 집계 — 대조표 팝업 Form_Load `//FindData();` (cs:146) "**'D' 만 진입 자동조회, 'I' 는 자동조회 없음**(AS-IS 파리티 복원)" 의 H6 16요소: ERROR:12 · PASS:4
- 외 14행(unverified_triage.csv)

### 집계 · 규칙 M3 · 5행
- 처리: 하위 행(팝업 EG 행) 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림(2026-11-20 SCP0028 H6·M3 8행)
- V-180ef854 [ASIS] new SCM0002_ShipmentLotSizePopup() | AS-IS 팝업 문장 'new SCM0002_ShipmentLotSizePopup()' → 팝업 SCM0002_ShipmentLotSizePopup 의 규칙 M3 실측 2행을 이어받음 — [EG-01b36c8b] BTN:Delete DATA: PASS | [EG-273588ca] BTN:Input DATA: ERROR
- V-922dca9e [GENERAL] [DMF0020 결함 유형] Price Batch Input 팝업 Sales Site 조건 | 규칙 M3 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-273588ca] SCP0028 팝업 SCM0002_ShipmentLotSizePopup BTN:Input DATA: 기대 팝업 조회 오류 없음 · 데이터 있음(No Permission 0) · 실제 자동 조회 6건 · Search 0건 · 행 0 · 오류 없음 · 알림 'From Site 값은 필수 입력 항목입니
- V-a2f14e5c [GENERAL] [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | 규칙 M3 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-273588ca] SCP0028 팝업 SCM0002_ShipmentLotSizePopup BTN:Input DATA: 기대 팝업 조회 오류 없음 · 데이터 있음(No Permission 0) · 실제 자동 조회 6건 · Search 0건 · 행 0 · 오류 없음 · 알림 'From Site 값은 필수 입력 항목입니
- 외 2행(unverified_triage.csv)

### 집계 · 규칙 M4 · 8행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-365b3790 [TRACE] P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP · 6 (division/opGroup/from/to/item/actionF | 행 집계 — 대조표 P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP '6 (division/opGroup/from/to/item/actionFlag)' 의 M4 7요소: ERROR:7
- T-71daa499 [TRACE] 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) · 공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄  | 행 집계 — 대조표 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) '공용 `SearchArea`(conditions 5칸 **size=4** = 한 줄 3칸)' 의 M4 7요소: ERROR:7
- T-8f84f97b [TRACE] **toolbar DeleteButton remove-new (cs:213~224, R4)** · `hotkeyConfig.delete = () | 행 집계 — 대조표 **toolbar DeleteButton remove-new (cs:213~224, R4)** '`hotkeyConfig.delete = () => undefined` (버튼 노출+무동작' 의 M4 7요소: ERROR:7
- 외 5행(unverified_triage.csv)

### 집계 · 규칙 X-ROW · 8행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-0adfea94 [TRACE] SCP0028_Shipment_Lot_Size.FindDelete | 진입점 집계 10검사 — ERROR:5 · PASS:5
- T-2a3f808e [TRACE] SCP0028_Shipment_Lot_Size.SaveData | 진입점 집계 17검사 — PASS:12 · NA:3 · ERROR:2
- T-4cec401b [TRACE] SCP0028_Shipment_Lot_Size.checkValidSize | 진입점 집계 6검사 — NA:5 · ERROR:1
- 외 5행(unverified_triage.csv)

