# SSP0015 Shipment PSI — 단위테스트

> 근거 열에는 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과에 "확인 필요"가 있으면, As-is 원문으로 기대값을 확정한 뒤 실행해야 합니다.
> 주석 처리된 호출은 테스트 대상이 아닙니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0015-001 | 초기화 | 로그인, SSP0015 메뉴 권한 있음 | 화면을 연다 | — | cboPlanDate에 PlanDateShip 코드 목록이 채워짐 | `Form_Load` > InitControls:568 `biz:CommonData.CommonDataList` [code=PlanDateShip] |
| TC-SSP0015-002 | 초기화 | 001과 같음 | 화면을 열고 cboBucketType 목록을 확인 | — | DAILY / WEEKLY / MONTHLY 코드가 표시됨 | `Form_Load` > GetBucketType `DM.DM0003_GET_BUCKET_TYPE_CODE` / SP DM0003_GET_BUCKET_TYPE_CODE |
| TC-SSP0015-003 | 초기화 | 001과 같음 | 화면을 열고 drpPeriod 기본값을 확인 | — | SP가 돌려준 기간이 drpPeriod에 세팅됨 | `Form_Load` > GetDayRange `SCP.SCM0001_GET_SCP_DAY_PERIOD` / SP SCM0001_GET_SCP_DAY_PERIOD |
| TC-SSP0015-004 | 초기화 | 001과 같음 | 화면을 열고 spdMain 헤더를 확인 | — | 3단 헤더 + SUM. `B_` 컬럼은 너비 0, 그 외 너비 70. SAT 헤더 파랑, SUN 헤더 빨강 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` / SP SCP0009_GET_SHEET_CALENDAR_3SPAN, 시트 `Shipment PSI(Mobility & IT)` |
| TC-SSP0015-005 | 초기화 | 001과 같음 | spdMain 시트 탭을 확인 | — | 탭 2개: Shipment PSI(Mobility & IT), Shipment PSI(Packer). Shipment PSI(IT & Mobile)는 만들어지지 않음 | `Form_Load` CreateSpread:656/660, 시트 `Shipment PSI(Mobility & IT)`, `Shipment PSI(Packer)`, `Shipment PSI(IT & Mobile)` |
| TC-SSP0015-006 | 초기화 | drPgmAuthId 있는 사용자 | spdDetail 시트 탭을 확인 | — | Shipment Confirm Detail, Shipment Request Detail, W/H stock, W/H stock Detail, Hold stock, Hold stock Detail, Stock Detail, SCS Stock Detail, Stock Location Detail, WH In Plan Detail, Shipment Result가 만들어짐. MES Stock Detail은 만들어지지 않음 | `Form_Load` CreateSpread:665~683, 시트 `MES Stock Detail` |
| TC-SSP0015-007 | 초기화 | 001과 같음 | 조회조건 영역에서 chkMyModel, chkPartLeader, chkTeamLeader, chkDelegateeModel을 찾는다 | — | 4개 모두 화면에 보이지 않음. chkMyModel 값은 Checked=true | props(Visible=false), `Form_Load` |
| TC-SSP0015-008 | 초기화 | 상단 PSI 조회 완료 | Comments 팝업을 연다 (여는 경로 확인 필요) | — | 팝업이 뜨고 txtDivision_ID ~ rtxComments, btnButtonList가 표시됨 | 팝업 `Form_Load` (.ctor:207) |
| TC-SSP0015-009 | 이벤트 | 화면 로드 완료 | clbDivision 값을 바꾼다 | Division: 40 → 81 | PlanDateShip 재조회 → cboPlanDate 갱신, drpPeriod 재설정 | `clbDivision_SelectedIndexChanged` > SetChangedControl `biz:CommonData.CommonDataList` [PlanDateShip] > GetDayRange `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0015-010 | 이벤트 | 화면 로드 완료 | cboPlanDate 값을 바꾼다 | 다른 Plan-date | drpPeriod 재설정 | `CboPlanDate_SelectedIndexChanged` > GetDayRange `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0015-011 | 이벤트 | 화면 로드 완료 | spdMain 시트를 Shipment PSI(Packer)로 바꾼다 | — | LookupCommon·PlanDateShip·DayRange를 다시 호출하고 헤더를 다시 구성함 | `SpdMain_ActiveSheetChanged` `biz:CommonData.CommonDataList` [LookupCommon] (1400/1452), SetChangedControl, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment PSI(Packer)` |
| TC-SSP0015-012 | 이벤트 | 011 수행 | spdMain 시트를 Shipment PSI(Mobility & IT)로 되돌린다 | — | 011과 같은 호출. Mobility 컬럼 구성 복원 | `SpdMain_ActiveSheetChanged`, 시트 `Shipment PSI(Mobility & IT)` |
| TC-SSP0015-013 | 이벤트 | 화면 로드 완료 | btnMeasure를 누른다 | — | spdMain이 다시 구성됨 (Measure 선택 팝업 여부 확인 필요) | `btnMeasure_Click` > InitSpread > GetSpdTitle `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-014 | 이벤트 | 상단 조회 완료 | cboBucketType을 DAILY로 선택 | DAILY | D_·W_ 컬럼 Visible=true, M_ Sum 계열은 chkSum 값을 따름 | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:2116/2121 |
| TC-SSP0015-015 | 이벤트 | 상단 조회 완료 | cboBucketType을 WEEKLY로 선택 | WEEKLY | D_ 숨김, W_ 표시, M_는 chkSum 값을 따름 | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:2128/2132/2137 |
| TC-SSP0015-016 | 이벤트 | 상단 조회 완료 | cboBucketType을 MONTHLY로 선택 | MONTHLY | D_·W_ 숨김, M_ 표시 | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:2144/2148 |
| TC-SSP0015-017 | 이벤트 | Bucket=DAILY | chkSum을 체크 | Checked=true | Sum 계열 컬럼 표시 | `chkSum_CheckedChanged`, SetSpreadColumn:2121 |
| TC-SSP0015-018 | 이벤트 | 017 수행 | chkSum을 해제 | Checked=false | Sum 계열 컬럼 숨김 | `chkSum_CheckedChanged` |
| TC-SSP0015-019 | 이벤트 | 화면 로드 완료 | btnItemId를 누른다 | — | Model 선택 동작 (팝업 여부와 선택값 반영 위치 확인 필요). 엔드포인트 호출 없음 | `btnItemId_Click` |
| TC-SSP0015-020 | 이벤트 | 화면 로드 완료 | btnItemID2를 누른다 | — | 하단 Model 선택 동작 (확인 필요). 엔드포인트 호출 없음 | `BtnItemID2_Click` |
| TC-SSP0015-021 | 이벤트 | 화면 로드 완료 | btnRequestor를 누른다 | — | Requestor 선택 동작, txtRequestor 반영 (확인 필요) | `BtnRequestor_Click` |
| TC-SSP0015-022 | 이벤트 | 상단 조회 완료 | spdMain 셀에 마우스를 올린다 | — | TextTip 표시 (내용 확인 필요) | `spdMain_TextTipFetch` |
| TC-SSP0015-023 | 이벤트 | 상단 조회 완료(행 다수) | spdMain을 세로 스크롤 | — | As-is와 같은 동작 (내부 동작 확인 필요). 오류 없음 | `SpdMain_TopChange` |
| TC-SSP0015-024 | 이벤트 | 하단 조회 완료(행 다수) | spdDetail을 세로 스크롤 | — | As-is와 같은 동작 (확인 필요). 오류 없음 | `SpdDetail_TopChange` |
| TC-SSP0015-025 | 이벤트 | 편집 진입 완료 | spdMain 셀 편집을 시작한다 | — | 편집모드 진입 처리 (허용 셀 조건 확인 필요) | `SpdMain_EditModeOn` |
| TC-SSP0015-026 | 이벤트 | 상단 조회 완료 | spdMain 셀을 한 번 클릭 | — | As-is와 같은 동작 (확인 필요). 엔드포인트 호출 없음 | `SpdMain_CellClick` |
| TC-SSP0015-027 | 이벤트 | Shipment Confirm Detail 조회 완료 | spdDetail 콤보 셀 값을 고른다 | Trans Mode 값 | 선택값 반영 (연동 처리 확인 필요) | `spdDetail_ComboSelChange`, 시트 `Shipment Confirm Detail` |
| TC-SSP0015-028 | 이벤트 | 화면 로드 완료 | spdDetail 시트 탭을 누른다 | Hold stock 탭 | 시트 전환 처리 (확인 필요) | `SpdDetail_SheetTabClick`, 시트 `Hold stock` |
| TC-SSP0015-029 | 이벤트 | 하단 조회 완료 | spdDetail 셀을 더블클릭 | — | As-is와 같은 동작 (확인 필요) | `SpdDetail_CellDoubleClick` |
| TC-SSP0015-030 | 이벤트 | 화면 로드 완료 | spdDetail 활성 시트를 Stock Detail로 바꾼다 | — | 하단 조회 바 상태 전환 (확인 필요) | `SpdDetail_ActiveSheetChanged`, 시트 `Stock Detail` |
| TC-SSP0015-031 | 이벤트 | 편집 가능한 Detail 시트 | spdDetail 셀 값을 고친다 | 수량 변경 | 변경 표시 처리 (확인 필요) | `SpdDetail_EditChange` |
| TC-SSP0015-032 | 이벤트 | 031 수행 | dsdm 데이터 변경 이벤트 발생을 확인 | — | 변경 상태 반영 (확인 필요) | `shtDetail_Change` (dsdm.Changed) |
| TC-SSP0015-033 | 이벤트 | Shipment Confirm Detail 조회 완료 | TRANSPORT_MODE 셀을 클릭 | — | TransMode 코드로 셀 콤보 목록이 채워짐(NAME 표시) | `SpdDetail_CellClick`:8583 `biz:CommonData.CommonDataList` [code=TransMode] |
| TC-SSP0015-034 | 이벤트 | 033과 같음 | TO_SITE_SHIPTO_CODE 셀을 클릭 | — | ShipToCodeByDivision 목록이 채워짐 | `SpdDetail_CellClick`:8604 `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0015-035 | 이벤트 | Detail 시트 잠금 아님, 행 1개 이상 | 컬럼헤더 CheckBox(CHK `ALL`)를 두 번 누른다 | — | 1번째 클릭에서 전체 체크, 2번째 클릭에서 전체 해제 (값 토글) | `SpdDetail_CellClick`:8618/8653/8657, 시트 `Shipment Confirm Detail` |
| TC-SSP0015-036 | 이벤트 | `siDetail.IsLock(SheetName)==true` | 컬럼헤더 CheckBox를 누른다 | — | 토글되지 않음 | `SpdDetail_CellClick` (IsLock 분기) |
| TC-SSP0015-037 | 이벤트 | Shipment Confirm Detail 편집 가능 | Trans Mode 열에 값을 붙여넣는다 | 클립보드 Trans Mode 값 | TransMode CODE 목록과 대조 (불일치 처리 확인 필요) | `SpdDetail_ClipboardPasted`:8954 `biz:CommonData.CommonDataList` [code=TransMode] |
| TC-SSP0015-038 | 조회 | 시트 Mobility & IT, 필수조건 입력 | 툴바 조회 | Division=40, Plan-date, Period | 상단 PSI 데이터 표시 | FindButton > FindData_Main `SSP.SSP0015_GET_SHIPMENT_PSI` / SP SSP0015_GET_SHIPMENT_PSI, 시트 `Shipment PSI(Mobility & IT)` |
| TC-SSP0015-039 | 조회 | 시트 Packer | 툴바 조회 | Packer 조건 | Packer PSI 표시 | FindButton > FindData_Main_Packer `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` / SP SSP0015_GET_SHIPMENT_PSI_PACKER |
| TC-SSP0015-040 | 조회 | Packer, 과거 조건 (분기 조건 확인 필요) | 툴바 조회 | 과거 Plan-date | Past PSI 표시. NERP 코드 반영, 헤더 재구성 | FindButton > FindData_Main_Packer_Past `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST`, Re_Design > `SSP.SSP0002_GET_NERP_CODE` (SEGMENT2), `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-041 | 조회 | 데이터 없는 조건 | 툴바 조회 | 데이터 없는 Model | 빈 그리드. 오류 없음 (안내 메시지 확인 필요) | `SSP.SSP0015_GET_SHIPMENT_PSI` 빈 결과 |
| TC-SSP0015-042 | 조회 | SP 오류 유발(테스트 DB) | 툴바 조회 | — | 오류 메시지 표시, 그리드 유지 (문구 확인 필요) | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` 오류 응답 |
| TC-SSP0015-043 | 조회 | 상단 조회 완료 | spdMain 셀 더블클릭 (Confirm 관련 Measure) | 행 DIVISION_ID/SITE/ITEM_ID/YYYYMMDD | Shipment Confirm Detail 조회 결과 표시 | `SpdMain_CellDoubleClick` > FindData_Detail `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| TC-SSP0015-044 | 조회 | 043과 같음 | W/H 재고 관련 셀 더블클릭 | 행 키 | W/H stock 조회 결과 | `SpdMain_CellDoubleClick` > FindData_WHstock `SSP.SSP0015_GET_WH_STOCK`, 시트 `W/H stock` |
| TC-SSP0015-045 | 조회 | 043과 같음 | MES 재고 관련 셀 더블클릭 | 행 키 | Stock Detail 조회 결과 | `SpdMain_CellDoubleClick` > FindData_mes_stock `SSP.SSP0015_GET_MES_STOCK` |
| TC-SSP0015-046 | 조회 | 043과 같음 | Hold 재고 관련 셀 더블클릭 | 행 키 | Hold stock 조회 결과 | `SpdMain_CellDoubleClick` > FindData_block_stock `SSP.SSP0015_GET_BLOCK_STOCK` |
| TC-SSP0015-047 | 조회 | 043과 같음 | 재고 위치 관련 셀 더블클릭 | 행 키 | Stock Location Detail 조회 결과, NERP 코드 반영 | `SpdMain_CellDoubleClick` > FindData_shtStockLocationDetail_btnSearch `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-048 | 조회 | 043과 같음 | SCS 재고 관련 셀 더블클릭 | 행 키 | SCS Stock Detail 조회 결과 | `SpdMain_CellDoubleClick` > FindData_ScsStock_btnSearch `SSP.SSP0015_GET_SCS_STOCK` |
| TC-SSP0015-049 | 조회 | 043과 같음 | 상단 재조회가 일어나는 셀 더블클릭 (조건 확인 필요) | 행 키 | 상단 PSI 재조회 | `SpdMain_CellDoubleClick` > FindData_Main `SSP.SSP0015_GET_SHIPMENT_PSI` |
| TC-SSP0015-050 | 조회 | Comments가 있는 셀 | spdMain 셀 더블클릭 | — | Comments의 GAP / BEFORE_QTY / USER_ADD_QTY를 읽음 (팝업 전달 여부 확인 필요) | `SpdMain_CellDoubleClick` (8290~8306) |
| TC-SSP0015-051 | 조회 | 활성 시트 Shipment Confirm Detail(40 계열) | drpPeriod2 입력 후 btnSearch 클릭 | Shipment Date 기간 | Confirm Detail 표시. 일부 컬럼 숨김 | `BtnSearch_Click` > FindData_Detail_btnSearch `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` / SP SSP0015_GET_SHIPMENT_CONFIRM_DETAIL, 시트 `Shipment Confirm Detail` |
| TC-SSP0015-052 | 조회 | 활성 시트 Shipment Confirm Detail(Packer 계열) | btnSearch 클릭 | Shipment Date 기간 | Packer Confirm Detail 표시 | `BtnSearch_Click` > FindData_Detail_Packer_btnSearch `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` |
| TC-SSP0015-053 | 조회 | 활성 시트 Shipment Request Detail | txtRequestor 입력 후 btnSearch 클릭 | Requestor | 요청 상세 표시 | `BtnSearch_Click` > FindData_Request_Detail `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / SP SSP0026_GET_REQUEST_DETAIL_PACK, 시트 `Shipment Request Detail` |
| TC-SSP0015-054 | 조회 | 활성 시트 W/H stock | btnSearch 클릭 | txtModel2 | 창고 재고 표시 | `BtnSearch_Click` > FindData_WHstock `SSP.SSP0015_GET_WH_STOCK` |
| TC-SSP0015-055 | 조회 | 활성 시트 Hold stock Detail | btnSearch 클릭 | drpPeriod3 (매핑 확인 필요) | Hold 재고 상세 표시 | `BtnSearch_Click` > FindData_BolckStockDetail_btnSearch `SSP.SSP0015_GET_BLOCK_STOCK`, 시트 `Hold stock Detail` |
| TC-SSP0015-056 | 조회 | 활성 시트 Stock Detail | txtLotID 입력 후 btnSearch 클릭 | Lot ID | MES 재고 상세 표시 | `BtnSearch_Click` > FindData_MesStock_btnSearch `SSP.SSP0015_GET_MES_STOCK` |
| TC-SSP0015-057 | 조회 | 활성 시트 SCS Stock Detail | btnSearch 클릭 | txtModel2 | SCS 재고 표시 | `BtnSearch_Click` > FindData_ScsStock_btnSearch `SSP.SSP0015_GET_SCS_STOCK`, 시트 `SCS Stock Detail` |
| TC-SSP0015-058 | 조회 | 활성 시트 Stock Location Detail | btnSearch 클릭 | txtModel2 | 재고 위치 표시, NERP 반영 | `BtnSearch_Click` > FindData_shtStockLocationDetail_btnSearch `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE` |
| TC-SSP0015-059 | 조회 | 활성 시트 WH In Plan Detail (권한 있음) | btnSearch 클릭 | — | 입고계획 Comments 표시 | `BtnSearch_Click` > FindData_WHinPlanDetail_btnSearch `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` / SP SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| TC-SSP0015-060 | 조회 | 활성 시트 Shipment Result (ERP 실적) | clbResultType 선택 후 btnSearch 클릭 | Result Type | 실적 표시. SHIP_TO, SHIPTO_DESCRIPTION 숨김 | `BtnSearch_Click` > FindData_ShipmentResult_btnSearch `SSP.SSP0015_GET_SHIPMENT_RESULT`:4991/4992 |
| TC-SSP0015-061 | 조회 | 활성 시트 Shipment Result (SCS 실적, 분기 조건 확인 필요) | btnSearch 클릭 | Result Type | SCS 실적 표시, 헤더 재구성 | `BtnSearch_Click` > FindData_ShipmentSCSResult_btnSearch `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-062 | 조회 | 활성 Detail 시트 아무거나 | 데이터 없는 조건으로 btnSearch 클릭 | 데이터 없는 Lot | 빈 그리드, 오류 없음 | `BtnSearch_Click` 빈 결과 (`SSP.SSP0015_GET_MES_STOCK`) |
| TC-SSP0015-063 | 권한 | 편집 권한 있는 사용자 | 툴바 Edit | — | PlanDateShip 확인, 사용자 정보 조회 뒤 편집 가능 상태 | EditButton:1753/1757 `biz:CommonData.CommonDataList` [PlanDateShip], GetSSPUserCheck `SSP.SSP0002_GET_USER_INFO_LIST` / SP SSP0002_GET_USER_INFO_LIST |
| TC-SSP0015-064 | 권한 | 사용자 그룹 정보 없음 | 툴바 Edit | — | 사용자 조회 결과가 비었을 때 처리 (차단·메시지 확인 필요) | `SSP.SSP0002_GET_USER_INFO_LIST` 빈 결과 |
| TC-SSP0015-065 | 저장 | 상단 PSI 편집 완료 | 툴바 저장 | 입고 수량·Comment 변경 | SSP_ANL_SHIP_PLAN_40 / _WH_IN_CMT 갱신, 이력(_WH_IN_H, _WH_IN_CMT_H)과 SCM_SYS_LOG_BATCH 기록 | SaveButton > SaveData_Main `SSP.SSP0015_SAVE_SHIPMENT_PSI` / SP SSP0015_SAVE_SHIPMENT_PSI |
| TC-SSP0015-066 | 저장 | Shipment Confirm Detail(40) 편집, 필수항목 입력 | 툴바 저장 | Shipment Qty, Shipment Date, Trans Mode, Ship to | SSP_ANL_SHIP_CONFIRM 반영, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN 적재, DM_PLN_MKT_FCST_CONFIRM 반영. 저장 후 상단·Detail 재조회 | SaveButton > SaveData_Detail `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / SP SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40, 재조회 `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| TC-SSP0015-067 | 저장 | 066과 같지만 Trans Mode 빈칸 | 툴바 저장 | TRANSPORT_MODE='' | 검증에 걸려 저장 SP를 호출하지 않음 (메시지 확인 필요) | SaveData_Detail > Validation_Check (shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE) |
| TC-SSP0015-068 | 저장 | Hold stock 시트에서 행 편집 | 툴바 저장 | Amend Qty, End Date | SSP_ANL_HOLD_STOCK UPDATE/INSERT, 로그 기록 | SaveButton > SaveData_Detail:6011 `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` / SP SSP0015_SAVE_BLOCK_STOCK_DATA, 시트 `Hold stock` |
| TC-SSP0015-069 | 저장 | Stock Detail 편집 | 툴바 저장 | User Modified Release Date | SSP_ANL_MES_FCS_STOCK_40_C, SSP_ANL_SHIP_PLAN_40 MERGE. MES 재고 재조회 | SaveButton > SaveData_Detail:6112/6219 `SSP.SSP0015_SAVE_MES_STOCK` / SP SSP0015_SAVE_MES_STOCK, 재조회 `SSP.SSP0015_GET_MES_STOCK` |
| TC-SSP0015-070 | 저장 | Packer Confirm Detail 편집 | 툴바 저장 | Confirm ID | SCS Confirm ID 체크(CNT) 결과에 따라 진행 또는 중단 (기준 확인 필요) | SaveData_Detail_Packer > chkSaveYN `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` / SP SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| TC-SSP0015-071 | 저장 | 070 통과 | 저장 계속 | — | 계획 진행 중 여부 체크 (진행 중일 때 동작 확인 필요) | SaveData_Detail_Packer > EngProcessingChk `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` / SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| TC-SSP0015-072 | 저장 | 071 통과 | 저장 계속 | — | SSP_ANL_SHIP_CONFIRM 반영, XIF_ERP_PACK_SHIP_PLAN_S_SN·XIF_SCS_PACK_SHIP_PLAN_S_SN·SSP_MST_SEND_MAIL_REQ 적재 | SaveData_Detail_Packer:5602 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` / SP SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER |
| TC-SSP0015-073 | 저장 | 072 수행, 변경 요청 있음 | ERP 인터페이스 단계 | — | 확정 변경시각 체크 수행 | GetERPInterface > ChkConfirmChangeTime `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` / SP SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| TC-SSP0015-074 | 저장 | 073과 같음 | ERP 인터페이스 단계 | — | SO 건수(CNT) 조회 결과로 SoNo/NonSoNo 경로가 결정됨 (기준 확인 필요) | GetERPInterface > GetErpSoNoCnt `SSP.SSP0015_GET_ERP_SO_NO_CNT` / SP SSP0015_GET_ERP_SO_NO_CNT |
| TC-SSP0015-075 | 저장 | 073과 같음 | ERP 인터페이스 단계 | — | 출하 상태 Tables[0..2].CONFIRM_ID 확인 | GetERPInterface > GetShipmentStatusChk `SSP.SSP0015_GET_SHIPMENT_STATUS` / SP SSP0015_GET_SHIPMENT_STATUS |
| TC-SSP0015-076 | 저장 | ERP 오류 건 존재 | ERP 인터페이스 단계 | — | SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT, CHG_REQ / CHG_REQ_DE UPDATE | GetERPInterface:6665 `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` / SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| TC-SSP0015-077 | 저장 | 확정 삭제 대상 존재 | ERP 인터페이스 단계 | — | SSP_ANL_SHIP_CONFIRM UPDATE/DELETE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT | GetERPInterface:6706 `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` / SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| TC-SSP0015-078 | 저장 | SO No 없음 | ERP 인터페이스 NonSoNo 경로 | — | CHG_REQ / CHG_REQ_DE INSERT. 40은 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, Packer는 XIF_ERP_PACK / XIF_SCS_PACK 적재 | NonSoNo:6843 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` / SP SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING, :6847 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` / SP SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| TC-SSP0015-079 | 저장 | SO No 있음 | ERP 인터페이스 SoNo 경로 | — | 078과 같은 Drafting SP 호출 | SoNo:7076 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, :7080 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` |
| TC-SSP0015-080 | 저장 | 079 수행 | GetErpIFCheckNew 단계 | — | 확정 삭제 처리 후 CHG 배치. XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT, CHG_REQ_DE UPDATE | GetErpIFCheckNew:7363 `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, :7389/7419 `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` / SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| TC-SSP0015-081 | 저장 | 072~080 완료 | 저장 완료 후 확인 | — | Packer Confirm Detail 재조회, 헤더 재구성 | SaveData_Detail_Packer > FindData_Detail_Packer_btnSearch `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-082 | 저장 | SP 오류 유발(테스트 DB) | 툴바 저장 | — | 오류 메시지 표시, 부분 반영 없음 (트랜잭션 범위 확인 필요) | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 오류 응답 |
| TC-SSP0015-083 | 저장 | ERP I/F 차단 데이터(BLOCK_YN) 존재 | Packer 저장 | — | 차단 여부 판정 (원천과 동작 확인 필요) | chkERPIFBlockYn (BLOCK_YN, PERIOD) |
| TC-SSP0015-084 | 이벤트 | 팝업 열림 | txtGap_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtGap_Qty_TextChanged` |
| TC-SSP0015-085 | 이벤트 | 팝업 열림 | txtBefore_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtBefore_Qty_TextChanged` |
| TC-SSP0015-086 | 이벤트 | 팝업 열림 | txtProd_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtProd_Qty_TextChanged` |
| TC-SSP0015-087 | 이벤트 | 팝업 열림 | txtWHin_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtWHin_Qty_TextChanged` |
| TC-SSP0015-088 | 이벤트 | 팝업 열림 | txtCurrent_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtCurrent_Qty_TextChanged` |
| TC-SSP0015-089 | 이벤트 | 팝업 열림 | txtChange_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtChange_Qty_TextChanged` |
| TC-SSP0015-090 | 이벤트 | 팝업 열림 | txtChange_Qty에 문자를 입력 | `abc` | 입력 제한 여부 (확인 필요) | `txtChange_Qty_KeyPress` |
| TC-SSP0015-091 | 저장 | 팝업에 rtxComments 입력 | btnButtonList 저장 클릭 | Comment, 변경수량 | SSP_ANL_SHIP_PLAN_40 UPDATE, _WH_IN_CMT UPDATE/INSERT, 이력·로그 기록 | `btnButtonList_UsrButtonList_Click_Detected` > SaveData:333 `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` / SP SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |
| TC-SSP0015-092 | 저장 | SP 오류 유발 | 팝업 btnButtonList 저장 | — | 오류 메시지, 팝업 유지 (확인 필요) | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` 오류 응답 |
| TC-SSP0015-093 | 저장 | 진입점 미연결 확인용 | 런타임 추적(SQL 로그)으로 호출 여부 확인 | Packer/40 저장 전체 시나리오 | 호출 0건이면 미사용으로 확정. 호출되면 CHG_REQ / CHG_REQ_DE UPDATE 검증 | GetErpIFCheck:7285, GetErpIFCheckNew_:9731 `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` / SP SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0015-094 | 저장 | 093과 같음 | 런타임 추적 | 저장 시나리오 | 호출 여부 확정. 호출되면 SCM_SYS_LOG_BATCH INSERT | SCM_SYS_LOG_BATCH:7876 `SCP.PR_SCM_SYS_LOG_BATCH` / SP PR_SCM_SYS_LOG_BATCH |
| TC-SSP0015-095 | 조회 | 093과 같음 | 런타임 추적 | 화면 로드·Division 변경 | 호출 여부 확정. 호출되면 SCM_MST_DIVISION 결과가 clbDivision에 반영되는지 확인 | GetDivision:9192 `SCM.SCM0001_GET_DIVISION` / SP SCM0001_GET_DIVISION |
| TC-SSP0015-096 | 조회 | 093과 같음 | 런타임 추적 | — | 호출 여부 확정. FROM_VALUE / TO_VALUE 사용처 확인 | SetChangedPeriod:9207/9211 `biz:CommonData.CommonDataList` [PERIOD_{p:value}], [PERIOD2_{p:value}] |
| TC-SSP0015-097 | 저장 | 093과 같음 | 런타임 추적 | — | NewNonSoNo 호출 여부 확정 | NewNonSoNo:9611/9615 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` |
| TC-SSP0015-098 | 그리드 | 상단 조회 완료 | Shipment PSI(Mobility & IT) 컬럼 확인 | — | 표시 10: Div, Figure, From Site, Model, Aging L/T, Measure, Nick Name, PSI, TYPE, Yield(%). 셀 병합(Always) | 시트 `Shipment PSI(Mobility & IT)`, SetSheetHeaderColumn InitSpread:759, MergePolicy 776/778 |
| TC-SSP0015-099 | 그리드 | Packer 조회 완료 | Shipment PSI(Packer) 컬럼 확인 | — | 표시 8: Div, Figure, From Site, Model, Measure(MEASURE), Nick Name, PSI, TYPE. LT_DAY / YEILD 숨김 | 시트 `Shipment PSI(Packer)`, InitSpread:786, MergePolicy 803/805 |
| TC-SSP0015-100 | 그리드 | ichkbtn==1 상태 (조건 확인 필요) | Packer 시트와 Mobility 시트의 SO No 계열 컬럼 폭 비교 | — | Packer 시트 Width 80, 다른 시트 0. ichkbtn≠1이면 반대 | SetSoNoColumnVisible:9778~9793, 시트 `Shipment PSI(Packer)` |
| TC-SSP0015-101 | 그리드 | 화면 로드 | 메타 전용 시트 확인 | — | Shipment PSI(IT & Mobile) 탭이 없음 (이관 여부 결정 후 확정) | 시트 `Shipment PSI(IT & Mobile)` (메타 정의만, 코드 미참조) |
| TC-SSP0015-102 | 그리드 | Confirm Detail 조회 완료 | 컬럼 확인 | — | 표시 40 (§4-3 목록). SHIPTO_DESCRIPTION 숨김. 메타 39와 1컬럼 차이 원인 확인 | 시트 `Shipment Confirm Detail`, FindData_Detail Visible 3218~3221 |
| TC-SSP0015-103 | 그리드 | Request Detail 조회 완료 | 컬럼 확인 | — | 표시 34 (§4-4 목록) | 시트 `Shipment Request Detail` |
| TC-SSP0015-104 | 그리드 | W/H stock 조회 완료 | 컬럼 확인 | — | 메타 19컬럼 표시 (목록은 메타 원문으로 확정) | 시트 `W/H stock` |
| TC-SSP0015-105 | 그리드 | W/H stock Detail 탭 선택 | 컬럼 확인 | — | 메타 25컬럼 표시 (목록·원천 SP 확인 필요) | 시트 `W/H stock Detail` |
| TC-SSP0015-106 | 그리드 | Hold stock 조회 완료 | 컬럼 확인 | — | 표시 10. 라벨 Amend Qty*, End Date*. FROM_SITE, HOLD_ID 숨김 | 시트 `Hold stock` |
| TC-SSP0015-107 | 그리드 | Hold stock Detail 조회 완료 | 컬럼 확인 | — | 표시 10. 라벨 Amend Qty, End Date (`*` 없음) | 시트 `Hold stock Detail` |
| TC-SSP0015-108 | 그리드 | Stock Detail 조회 완료 | 컬럼 확인 | — | 표시 26. LONGTERM_HOLD_YN, LOT_QTY_MES_NG 포함 | 시트 `Stock Detail` |
| TC-SSP0015-109 | 그리드 | 화면 로드 | 메타 전용 시트 확인 | — | MES Stock Detail 탭이 없음 (이관 여부 결정 후 확정) | 시트 `MES Stock Detail` (메타 정의만) |
| TC-SSP0015-110 | 그리드 | SCS Stock Detail 조회 완료 | 컬럼 확인 | — | 표시 9: CUTOFF_DATE, DIVISION_ID, Hold Y/N, Update Date, Model, PLANT_ID, PLANT_NAME, Production Date, QTY | 시트 `SCS Stock Detail` |
| TC-SSP0015-111 | 그리드 | Stock Location Detail 조회 완료 | 컬럼 확인 | — | 메타 20컬럼. 라벨 `Deffect Qty` 원문 유지 | 시트 `Stock Location Detail` |
| TC-SSP0015-112 | 그리드 | WH In Plan Detail 조회 완료 | 컬럼 확인 | — | 메타 11컬럼 표시 (목록 확인 필요) | 시트 `WH In Plan Detail` |
| TC-SSP0015-113 | 그리드 | Shipment Result 조회 완료 | 컬럼 확인 | — | 표시 17. SHIP_TO `Ship to`, SHIPTO_DESCRIPTION `Ship to Name` 숨김 | 시트 `Shipment Result`, FindData_ShipmentResult_btnSearch:4991/4992 |
| TC-SSP0015-114 | 권한 | drPgmAuthId == null 사용자 | 화면 열기 | — | WH In Plan Detail 탭이 만들어지지 않음 | CreateSpread:680, 시트 `WH In Plan Detail` |
| TC-SSP0015-115 | 권한 | 메뉴 권한 없는 그룹 | 메뉴 접근 | — | 접근·버튼 제한 (TB_FX_GroupMenuAuth 값으로 기대값 확정 필요) | TB_FX_GroupMenuAuth 14행, `Form_Load` |
| TC-SSP0015-116 | division | Division=40 | 모든 Detail 시트를 조회 | 40 | 시트별 표시 컬럼 수가 §12 집계와 같음 (예: Shipment Confirm Detail 40, Shipment Result 17) | grid_rule/grid_effective 40열, 시트 `Shipment Confirm Detail`, `Shipment Result` |
| TC-SSP0015-117 | division | Division=81 | 116과 같은 절차 | 81 | 컬럼 수가 40과 같음 | grid_effective 81열, `SpdDetail_CellClick` [ShipToCodeByDivision] |
| TC-SSP0015-118 | division | Division=82 | 116과 같은 절차 | 82 | 컬럼 수가 40과 같음 | grid_effective 82열 |
| TC-SSP0015-119 | division | Division=EE | 116과 같은 절차 | EE | 컬럼 수가 40과 같음 | grid_effective EE열 |
| TC-SSP0015-120 | division | Division 81_HD / EE_UC 등 하위 division | 116과 같은 절차 | 81_HD, EE_UC | 컬럼 수가 40과 같음 (Packer / 40 저장 분기와의 관계는 확인 필요) | grid_effective 81_HD·EE_UC열, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |

### 커버리지 점검
| 대상 | 수 | 커버 TC |
|---|---:|---|
| 이벤트 핸들러 | 33 | 001~037, 084~091 (`Form_Load` 001·008) |
| 엔드포인트 | 39 | 001~004, 009~013, 033~034, 037~081, 091~097 |
| 시트 | 15 | 004~006, 011, 028, 030, 044, 051~061, 098~114, 116 |
| division | 14 (변형 없음) | 116~120 |
| 빈 결과 / 오류 | — | 041, 042, 062, 064, 082, 092 |
