# SSP0015 Shipment PSI — 단위테스트 케이스

> - 기대결과의 기준은 As-Is 동작이다. Fact Pack에서 처리 내용이 확인되지 않은 항목은 "AS-IS 실행 결과와 동일(기대값 확정 전 확인 필요)"로 적었다.
> - '근거' 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5와 화면설계서 §5의 원문과 같다.
> - '절차' 열의 컨트롤명은 화면설계서 §3의 이름을 그대로 쓴다.
> - 주석 처리된 호출은 테스트 대상에서 뺐다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0015-001 | 초기화 | 로그인(Division 권한 보유) | 메뉴에서 SSP0015 화면을 연다 | – | cboPlanDate에 PlanDateShip 공통코드 목록이 채워진다 | `Form_Load` > InitControls / `biz:CommonData.CommonDataList` [code=PlanDateShip] |
| TC-SSP0015-002 | 초기화 | 위와 같음 | 화면 로드 후 cboBucketType 목록을 확인한다 | – | DM0003 결과가 바인딩된다(DAILY/WEEKLY/MONTHLY 포함 여부 확인) | `Form_Load` > GetBucketType / `DM.DM0003_GET_BUCKET_TYPE_CODE` / SP DM0003_GET_BUCKET_TYPE_CODE |
| TC-SSP0015-003 | 초기화 | 위와 같음 | 화면 로드 후 drpPeriod 값을 확인한다 | – | GetDayRange 결과의 From~To가 설정된다 | `Form_Load` > GetDayRange / `SCP.SCM0001_GET_SCP_DAY_PERIOD` / SP SCM0001_GET_SCP_DAY_PERIOD |
| TC-SSP0015-004 | 초기화 | 위와 같음 | 화면 로드 후 spdMain과 spdDetail의 시트 탭과 날짜 헤더를 확인한다 | – | spdMain 탭 = Shipment PSI(Mobility & IT), Shipment PSI(Packer). spdDetail 탭 = 코드 생성 11개(WH In Plan Detail은 권한 시만). 날짜 컬럼 3단 헤더와 SUM이 생성된다. 초기 활성 시트는 AS-IS와 같다(확인 필요) | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle / `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` / SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| TC-SSP0015-005 | 초기화 | 위와 같음 | 화면 로드 후 chkMyModel, chkPartLeader, chkTeamLeader, chkDelegateeModel의 상태를 확인한다 | – | 4개 모두 Visible=false. chkMyModel만 Checked=true | `Form_Load` (Designer 속성) |
| TC-SSP0015-006 | 초기화 | 코멘트 팝업 진입 조건 충족(진입점 확인 필요) | 팝업을 연다 | 대상 행(DIVISION_ID, SITE, ITEM_ID, YYYYMMDD) | txtPlan_Date, txtDivision_ID, txtFrom_Site, txtItem_ID, txtDate, txtMeasure 초기값이 AS-IS와 같다(확인 필요) | `Form_Load`(팝업 .ctor:207) |
| TC-SSP0015-007 | 조회 | clbDivision·cboPlanDate·drpPeriod 입력, spdMain 활성 시트 = Shipment PSI(Mobility & IT) | 조회(FindButton)를 클릭한다 | Division=테스트 대상, Plan-date=최신, Period=기본값 | spdMain에 PSI 행이 표시된다. 행 수와 값이 AS-IS와 같다 | FindButton > FindData_Main / `SSP.SSP0015_GET_SHIPMENT_PSI` / SP SSP0015_GET_SHIPMENT_PSI / 시트 `Shipment PSI(Mobility & IT)` |
| TC-SSP0015-008 | 조회 | TC-007과 같음 | 조회 후 NERP 코드가 반영된 셀(Re_Design)을 확인한다 | – | SEGMENT2 값이 반영된다(반영 위치는 확인 필요) | FindButton > Re_Design > GetNERPCode / `SSP.SSP0002_GET_NERP_CODE` / SP SSP0002_GET_NERP_CODE |
| TC-SSP0015-009 | 조회 | spdMain 활성 시트 = Shipment PSI(Packer) | 조회를 클릭한다 | 조회조건 기본값 | Packer PSI가 표시된다. MergePolicy.Always 병합이 적용된다 | FindButton > FindData_Main_Packer / `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` / SP SSP0015_GET_SHIPMENT_PSI_PACKER / 시트 `Shipment PSI(Packer)` |
| TC-SSP0015-010 | 조회 | Packer 시트, Past 분기 조건 충족(조건 확인 필요) | 조회를 클릭한다 | 과거 Plan-date 등(확인 필요) | 과거 Packer PSI가 표시된다. AS-IS와 같다 | FindButton > FindData_Main_Packer_Past / `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` / SP SSP0015_GET_SHIPMENT_PSI_PACKER_PAST |
| TC-SSP0015-011 | 조회(빈 결과) | 데이터가 없는 조건 | 조회를 클릭한다 | 존재하지 않는 Model(txtItemId) | 행 0건. 헤더만 표시되고 오류는 없다(AS-IS 메시지 확인 필요) | `SSP.SSP0015_GET_SHIPMENT_PSI` |
| TC-SSP0015-012 | 조회(오류) | SP 실행 오류를 유도(권한 없는 계정 또는 잘못된 파라미터) | 조회를 클릭한다 | – | 오류 메시지가 표시되고 그리드가 깨지지 않는다(문구 확인 필요) | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` |
| TC-SSP0015-013 | 조회(검증) | clbDivision 미선택 | 조회를 클릭한다 | Division 빈값 | 필수(`Division*`) 처리가 AS-IS와 같다(메시지 확인 필요) | FindButton / 컨트롤 clbDivision 라벨 `Division*` |
| TC-SSP0015-014 | 그리드 | TC-007 조회 완료, Detail 활성 시트 = Shipment Confirm Detail | spdMain 데이터 셀을 더블클릭한다 | 행의 DIVISION_ID·SITE·ITEM_ID·YYYYMMDD | spdDetail에 해당 키의 출하 확정 상세가 표시된다 | `SpdMain_CellDoubleClick` > FindData_Detail / `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` / SP SSP0015_GET_SHIPMENT_CONFIRM_DETAIL / 시트 `Shipment Confirm Detail` |
| TC-SSP0015-015 | 그리드 | Detail 활성 시트 = W/H stock | spdMain 셀을 더블클릭한다 | 위와 같음 | W/H 재고가 표시된다 | `SpdMain_CellDoubleClick` > FindData_WHstock / `SSP.SSP0015_GET_WH_STOCK` / 시트 `W/H stock` |
| TC-SSP0015-016 | 그리드 | Detail 활성 시트 = Stock Detail | spdMain 셀을 더블클릭한다 | 위와 같음 | MES 재고 LOT 목록이 표시된다 | `SpdMain_CellDoubleClick` > FindData_mes_stock / `SSP.SSP0015_GET_MES_STOCK` / 시트 `Stock Detail` |
| TC-SSP0015-017 | 그리드 | Detail 활성 시트 = Hold stock | spdMain 셀을 더블클릭한다 | 위와 같음 | Hold 재고가 표시된다 | `SpdMain_CellDoubleClick` > FindData_block_stock / `SSP.SSP0015_GET_BLOCK_STOCK` / 시트 `Hold stock` |
| TC-SSP0015-018 | 그리드 | Detail 활성 시트 = Stock Location Detail | spdMain 셀을 더블클릭한다 | 위와 같음 | 위치별 재고가 표시된다. NERP 코드 조회와 헤더 재구성이 일어난다 | `SpdMain_CellDoubleClick` > FindData_shtStockLocationDetail_btnSearch / `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` / 시트 `Stock Location Detail` |
| TC-SSP0015-019 | 그리드 | Detail 활성 시트 = SCS Stock Detail | spdMain 셀을 더블클릭한다 | 위와 같음 | SCS 재고가 표시된다 | `SpdMain_CellDoubleClick` > FindData_ScsStock_btnSearch / `SSP.SSP0015_GET_SCS_STOCK` / 시트 `SCS Stock Detail` |
| TC-SSP0015-020 | 조회 | Detail 활성 시트 = Shipment Confirm Detail(Mobility & IT 계열) | usrLayoutControl3에 조건을 넣고 btnSearch를 클릭한다 | drpPeriod2(Shipment Date), txtModel2, txtRequestor | 조건에 맞는 출하 확정 상세가 표시된다 | `BtnSearch_Click` > FindData_Detail_btnSearch / `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| TC-SSP0015-021 | 조회 | Detail = Shipment Confirm Detail, Main = Packer | btnSearch를 클릭한다 | 위와 같음 | Packer 출하 확정 상세가 표시된다 | `BtnSearch_Click` > FindData_Detail_Packer_btnSearch / `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` / SP SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER |
| TC-SSP0015-022 | 조회 | Detail = Shipment Request Detail | btnSearch를 클릭한다 | drpPeriod2 등 | 출하 요청 상세 34컬럼이 표시된다 | `BtnSearch_Click` > FindData_Request_Detail / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / SP SSP0026_GET_REQUEST_DETAIL_PACK / 시트 `Shipment Request Detail` |
| TC-SSP0015-023 | 조회 | Detail = W/H stock | btnSearch를 클릭한다 | txtModel2 | W/H 재고가 표시된다 | `BtnSearch_Click` > FindData_WHstock / `SSP.SSP0015_GET_WH_STOCK` / SP SSP0015_GET_WH_STOCK |
| TC-SSP0015-024 | 조회 | Detail = Hold stock Detail | btnSearch를 클릭한다 | drpPeriod3(라벨 확인 필요) | Hold 재고 상세가 표시된다 | `BtnSearch_Click` > FindData_BolckStockDetail_btnSearch / `SSP.SSP0015_GET_BLOCK_STOCK` / SP SSP0015_GET_BLOCK_STOCK / 시트 `Hold stock Detail` |
| TC-SSP0015-025 | 조회 | Detail = Stock Location Detail | btnSearch를 클릭한다 | txtModel2 | 위치별 재고가 표시된다 | `BtnSearch_Click` > FindData_shtStockLocationDetail_btnSearch / `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` / SP SSP0015_GET_STOCK_LOCATION_DETAIL, SP SSP0002_GET_NERP_CODE |
| TC-SSP0015-026 | 조회 | Detail = SCS Stock Detail | btnSearch를 클릭한다 | txtModel2 | SCS 재고가 표시된다 | `BtnSearch_Click` > FindData_ScsStock_btnSearch / `SSP.SSP0015_GET_SCS_STOCK` / SP SSP0015_GET_SCS_STOCK |
| TC-SSP0015-027 | 조회 | Detail = Stock Detail | btnSearch를 클릭한다 | txtLotID(여러 줄 LOT) | 입력한 LOT의 MES 재고가 표시된다 | `BtnSearch_Click` > FindData_MesStock_btnSearch / `SSP.SSP0015_GET_MES_STOCK` / SP SSP0015_GET_MES_STOCK |
| TC-SSP0015-028 | 조회 | Detail = WH In Plan Detail(권한 행 존재) | btnSearch를 클릭한다 | drpPeriod2 | WH In 계획 코멘트가 표시된다 | `BtnSearch_Click` > FindData_WHinPlanDetail_btnSearch / `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` / SP SSP0015_GET_SHIPMENT_PSI_COMMENTS / 시트 `WH In Plan Detail` |
| TC-SSP0015-029 | 조회 | Detail = Shipment Result(Mobility & IT) | clbResultType을 선택하고 btnSearch를 클릭한다 | clbResultType, drpPeriod2 | 출하 실적 17컬럼이 표시된다. SHIP_TO와 SHIPTO_DESCRIPTION은 숨김 | `BtnSearch_Click` > FindData_ShipmentResult_btnSearch / `SSP.SSP0015_GET_SHIPMENT_RESULT` / SP SSP0015_GET_SHIPMENT_RESULT / 시트 `Shipment Result` |
| TC-SSP0015-030 | 조회 | Detail = Shipment Result, Main = Packer | btnSearch를 클릭한다 | 위와 같음 | SCS 출하 실적이 표시되고 헤더가 재구성된다 | `BtnSearch_Click` > FindData_ShipmentSCSResult_btnSearch / `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER` / SP SSP0015_GET_SHIPMENT_RESULT_PACKER, SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| TC-SSP0015-031 | 조회(빈 결과) | Detail 임의 시트 | 데이터가 없는 조건으로 btnSearch를 클릭한다 | txtModel2=존재하지 않는 모델 | 0건 표시, 오류 없음 | `BtnSearch_Click` / `SSP.SSP0015_GET_SCS_STOCK` |
| TC-SSP0015-032 | 조회 | Detail = W/H stock Detail | btnSearch를 클릭한다 | – | AS-IS 동작과 같다(조회 엔드포인트 미추출 → 확인 필요) | `BtnSearch_Click` / 시트 `W/H stock Detail` |
| TC-SSP0015-033 | 이벤트 | 화면 로드 완료 | btnMeasure를 클릭하고 Measure를 바꾼다 | Measure 선택값(확인 필요) | spdMain 헤더가 다시 만들어진다 | `btnMeasure_Click` > InitSpread > GetSpdTitle / `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-034 | 이벤트 | TC-007 조회 완료 | cboBucketType=DAILY를 선택한다 | chkSum 해제 | D_ 컬럼 표시, M_ 컬럼 숨김. W_ 최종 표시는 AS-IS와 같다(2116과 2121 충돌, 확인 필요) | `cboBucketType_SelectedIndexChanged` / SetSpreadColumn 2116·2121 |
| TC-SSP0015-035 | 이벤트 | 위와 같음 | cboBucketType=WEEKLY를 선택한다 | chkSum 해제 | D_ 숨김, W_ 표시, M_ 숨김 | `cboBucketType_SelectedIndexChanged` / SetSpreadColumn 2128·2132·2137 |
| TC-SSP0015-036 | 이벤트 | 위와 같음 | cboBucketType=MONTHLY를 선택한다 | – | D_·W_ 숨김, M_ 표시 | `cboBucketType_SelectedIndexChanged` / SetSpreadColumn 2144·2148 |
| TC-SSP0015-037 | 이벤트 | cboBucketType=WEEKLY | chkSum을 체크했다가 해제한다 | chkSum on/off | 체크하면 M_ 표시, 해제하면 M_ 숨김 | `chkSum_CheckedChanged` / SetSpreadColumn 2137 |
| TC-SSP0015-038 | 이벤트 | 화면 로드 완료 | clbDivision 값을 바꾼다 | 다른 Division | cboPlanDate 목록과 drpPeriod가 다시 계산된다 | `clbDivision_SelectedIndexChanged` > SetChangedControl > GetDayRange / `biz:CommonData.CommonDataList` [PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0015-039 | 이벤트 | 화면 로드 완료 | cboPlanDate 값을 바꾼다 | 다른 Plan-date | drpPeriod가 다시 계산된다 | `CboPlanDate_SelectedIndexChanged` > GetDayRange / `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0015-040 | 이벤트 | 화면 로드 완료 | spdMain 탭을 Shipment PSI(Packer)로 바꾼다 | – | LookupCommon 조회, 조회조건 재구성, 헤더 재구성. SO No 계열 컬럼 Width가 SetSoNoColumnVisible 규칙(80/0)을 따른다 | `SpdMain_ActiveSheetChanged` / `biz:CommonData.CommonDataList` [LookupCommon, PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-041 | 이벤트 | 화면 로드 완료 | btnItemId를 클릭한다 | – | AS-IS와 같은 Model 선택 동작(팝업 여부와 결과 반영 확인 필요). 선택 결과가 txtItemId에 반영된다 | `btnItemId_Click` |
| TC-SSP0015-042 | 이벤트 | 화면 로드 완료 | btnItemID2를 클릭한다 | – | AS-IS와 같은 Model 선택 동작. 결과가 txtModel2에 반영된다(확인 필요) | `BtnItemID2_Click` |
| TC-SSP0015-043 | 이벤트 | 화면 로드 완료 | btnRequestor를 클릭한다 | – | AS-IS와 같은 사용자 선택 동작. 결과가 txtRequestor에 반영된다(확인 필요) | `BtnRequestor_Click` |
| TC-SSP0015-044 | 그리드 | Shipment Confirm Detail 조회 완료, 편집 모드 | TRANSPORT_MODE 셀과 TO_SITE_SHIPTO_CODE 셀을 클릭한다 | – | Trans Mode 콤보(TransMode)와 Ship to 콤보(Division 기준)가 채워진다 | `SpdDetail_CellClick` / `biz:CommonData.CommonDataList` [TransMode, ShipToCodeByDivision] |
| TC-SSP0015-045 | 그리드 | 잠기지 않은 Detail 시트, 행 1개 이상 | 헤더 CheckBox(CHK(ALL))를 클릭한다 | – | 8618줄 분기대로 헤더 Value=false가 설정되고, 행 체크는 AS-IS와 같다 | `SpdDetail_CellClick` (IsLock=false 분기) |
| TC-SSP0015-046 | 그리드 | 잠긴 Detail 시트, 행 1개 이상 | 헤더 CheckBox를 두 번 클릭한다 | – | true→false(8653), false→true(8657)로 토글된다 | `SpdDetail_CellClick` (IsLock 분기) |
| TC-SSP0015-047 | 그리드 | Detail 콤보 셀 존재 | 콤보 값을 선택한다 | Trans Mode 값 | AS-IS와 같은 후속 처리(확인 필요) | `spdDetail_ComboSelChange` |
| TC-SSP0015-048 | 그리드 | 화면 로드 완료 | spdDetail 시트 탭을 클릭한다 | Hold stock 탭 | AS-IS와 같은 탭 전환 처리(확인 필요) | `SpdDetail_SheetTabClick` / 시트 `Hold stock` |
| TC-SSP0015-049 | 그리드 | Detail 데이터 존재 | spdDetail 셀을 더블클릭한다 | – | AS-IS와 같은 동작(확인 필요) | `SpdDetail_CellDoubleClick` |
| TC-SSP0015-050 | 그리드 | 화면 로드 완료 | spdDetail 활성 시트를 Shipment Result로 바꾼다 | – | 하단 조회조건(clbResultType 등)의 표시와 활성 상태가 AS-IS와 같다(확인 필요) | `SpdDetail_ActiveSheetChanged` / 시트 `Shipment Result` |
| TC-SSP0015-051 | 그리드 | 편집 모드, Shipment Confirm Detail | SHIPMENT_CONFIRM_QTY 셀을 편집한다 | 수량 변경 | AS-IS와 같은 편집 처리(행 상태·연동 값 확인 필요) | `SpdDetail_EditChange` |
| TC-SSP0015-052 | 그리드 | 편집 모드, Shipment Confirm Detail | Excel에서 여러 행을 복사해 TRANSPORT_MODE 열에 붙여넣는다 | 유효·무효 Trans Mode 코드 혼합 | TransMode 코드(CODE)와 대조한 결과가 AS-IS와 같다 | `SpdDetail_ClipboardPasted` / `biz:CommonData.CommonDataList` [TransMode] |
| TC-SSP0015-053 | 그리드 | 조회 완료 | spdMain 셀 편집을 시작한다 | – | 편집 가능·불가 셀 처리가 AS-IS와 같다(확인 필요) | `SpdMain_EditModeOn` |
| TC-SSP0015-054 | 그리드 | 조회 완료 | spdMain 셀을 클릭한다 | – | AS-IS와 같은 동작(확인 필요) | `SpdMain_CellClick` |
| TC-SSP0015-055 | 그리드 | Detail 데이터 존재 | Detail 바인딩 데이터를 변경한다 | – | 변경 감지 처리가 AS-IS와 같다(확인 필요) | `shtDetail_Change` (dsdm.Changed) / 시트 `Shipment Confirm Detail` |
| TC-SSP0015-056 | 그리드 | 조회 완료 | spdMain 셀에 마우스를 올린다 | – | 툴팁 내용이 AS-IS와 같다(확인 필요) | `spdMain_TextTipFetch` |
| TC-SSP0015-057 | 그리드 | 조회 완료(행이 많음) | spdMain을 세로 스크롤한다 | – | spdDetail 연동 여부가 AS-IS와 같다(확인 필요) | `SpdMain_TopChange` |
| TC-SSP0015-058 | 그리드 | Detail 행이 많음 | spdDetail을 세로 스크롤한다 | – | AS-IS와 같다(확인 필요) | `SpdDetail_TopChange` |
| TC-SSP0015-059 | 이벤트 | 코멘트 팝업 열림 | txtGap_Qty 값을 바꾼다 | 숫자 | 연동 계산이 AS-IS와 같다(확인 필요) | `txtGap_Qty_TextChanged` |
| TC-SSP0015-060 | 이벤트 | 위와 같음 | txtBefore_Qty 값을 바꾼다 | 숫자 | 위와 같음 | `txtBefore_Qty_TextChanged` |
| TC-SSP0015-061 | 이벤트 | 위와 같음 | txtProd_Qty 값을 바꾼다 | 숫자 | 위와 같음 | `txtProd_Qty_TextChanged` |
| TC-SSP0015-062 | 이벤트 | 위와 같음 | txtWHin_Qty 값을 바꾼다 | 숫자 | 위와 같음 | `txtWHin_Qty_TextChanged` |
| TC-SSP0015-063 | 이벤트 | 위와 같음 | txtCurrent_Qty 값을 바꾼다 | 숫자 | 위와 같음 | `txtCurrent_Qty_TextChanged` |
| TC-SSP0015-064 | 이벤트 | 위와 같음 | txtChange_Qty 값을 바꾼다 | 숫자 | 위와 같음 | `txtChange_Qty_TextChanged` |
| TC-SSP0015-065 | 이벤트 | 위와 같음 | txtChange_Qty에 숫자가 아닌 문자를 입력한다 | `a`, `-`, `.` | 허용 문자 규칙이 AS-IS와 같다(확인 필요) | `txtChange_Qty_KeyPress` |
| TC-SSP0015-066 | 저장 | 코멘트 팝업 열림, rtxComments 입력 | btnButtonList의 저장 버튼을 클릭한다 | 코멘트 텍스트, txtChange_Qty | SSP_ANL_SHIP_PLAN_40·WH_IN_CMT가 갱신되고 _H 이력이 INSERT된다 | `btnButtonList_UsrButtonList_Click_Detected` > SaveData / `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` / SP SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |
| TC-SSP0015-067 | 저장(오류) | 위와 같음, DB 오류 유도 | 저장을 클릭한다 | – | 오류 메시지가 표시되고 부분 반영이 없다(트랜잭션 처리 확인 필요) | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` |
| TC-SSP0015-068 | 권한 | 편집 권한 사용자 / 비권한 사용자 | 편집(EditButton)을 클릭한다 | 두 계정 | 권한 사용자는 편집 모드로 들어간다. 비권한 사용자는 AS-IS와 같이 처리된다(기준 확인 필요) | EditButton > GetSSPUserCheck / `SSP.SSP0002_GET_USER_INFO_LIST` / SP SSP0002_GET_USER_INFO_LIST / `biz:CommonData.CommonDataList` [PlanDateShip] |
| TC-SSP0015-069 | 저장 | 편집 모드, Main(Mobility & IT) 값 변경 | 저장(SaveButton)을 클릭한다 | WH In 수량·코멘트 | SSP_ANL_SHIP_PLAN_40과 WH_IN_CMT가 갱신되고 _H 이력이 생긴다 | SaveButton > SaveData_Main / `SSP.SSP0015_SAVE_SHIPMENT_PSI` / SP SSP0015_SAVE_SHIPMENT_PSI |
| TC-SSP0015-070 | 저장 | 편집 모드, Shipment Confirm Detail(Mobility & IT) 행 수정 | 저장을 클릭한다 | SHIPMENT_CONFIRM_QTY, SHIPMENT_DATE, TRANSPORT_MODE, REMARKS2, REMARKS, TO_SITE_SHIPTO_CODE | 확정이 저장되고 spdMain과 spdDetail이 다시 조회된다 | SaveButton > SaveData_Detail / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / SP SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 / 재조회 `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| TC-SSP0015-071 | 저장(검증) | TC-070과 같음 | 필수 후보 값을 비우고 저장한다 | shipment_date 빈값 / TRANSPORT_MODE 빈값 각각 | Validation_Check가 AS-IS와 같이 차단하거나 경고한다(조건·문구 확인 필요) | SaveData_Detail > Validation_Check / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| TC-SSP0015-072 | 저장 | 편집 모드, Hold stock 행 추가·수정 | 저장을 클릭한다 | HOLD_QTY(Amend Qty*), RELEASE_YYYYMMDD(End Date*) | SSP_ANL_HOLD_STOCK이 UPDATE 또는 INSERT된다 | SaveButton > SaveData_Detail / `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` / SP SSP0015_SAVE_BLOCK_STOCK_DATA / 시트 `Hold stock` |
| TC-SSP0015-073 | 저장 | 편집 모드, Stock Detail 행 수정 | 저장을 클릭한다 | USER_MOD_RELEASE_DATE | SSP_ANL_MES_FCS_STOCK_40_C와 SSP_ANL_SHIP_PLAN_40이 MERGE된다. Stock Detail이 다시 조회된다 | SaveButton > SaveData_Detail(6112/6219) / `SSP.SSP0015_SAVE_MES_STOCK` / SP SSP0015_SAVE_MES_STOCK / 재조회 `SSP.SSP0015_GET_MES_STOCK` |
| TC-SSP0015-074 | 저장 | 편집 모드, Packer Shipment Confirm Detail 수정 | 저장을 클릭한다 | 수정 행 | SCS Confirm ID 점검(CNT)이 수행된다. 판정 결과에 따른 진행·차단은 AS-IS와 같다 | SaveData_Detail_Packer > chkSaveYN / `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` / SP SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| TC-SSP0015-075 | 저장 | 위와 같음, 계획 처리 중 상태 | 저장을 클릭한다 | – | 계획 진행 점검 결과에 따른 처리가 AS-IS와 같다(차단 조건 확인 필요) | SaveData_Detail_Packer > EngProcessingChk / `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` / SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| TC-SSP0015-076 | 저장 | 위와 같음, 점검 통과 | 저장을 클릭한다 | – | SSP_ANL_SHIP_CONFIRM(_H), XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN에 반영된다. Confirm Detail이 다시 조회된다 | SaveData_Detail_Packer / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` / SP SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER / 재조회 `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-077 | 저장 | 변경 요청(CHG_REQ_DE) 존재 행 | 저장을 클릭한다 | – | 변경 시각 점검 결과에 따른 처리가 AS-IS와 같다 | GetERPInterface > ChkConfirmChangeTime / `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` / SP SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| TC-SSP0015-078 | 저장 | SO No가 있는 확정 행 | 저장을 클릭한다 | – | SO No 건수(CNT)에 따른 분기가 AS-IS와 같다 | GetERPInterface > GetErpSoNoCnt / `SSP.SSP0015_GET_ERP_SO_NO_CNT` / SP SSP0015_GET_ERP_SO_NO_CNT |
| TC-SSP0015-079 | 저장 | 출하 상태 점검 대상 행 | 저장을 클릭한다 | – | Tables[0~2]의 CONFIRM_ID 결과에 따른 처리가 AS-IS와 같다 | GetERPInterface > GetShipmentStatusChk / `SSP.SSP0015_GET_SHIPMENT_STATUS` / SP SSP0015_GET_SHIPMENT_STATUS |
| TC-SSP0015-080 | 저장 | ERP 오류 확인 대상 행 | 저장을 클릭한다 | – | SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT와 CHG_REQ(_DE) UPDATE가 AS-IS와 같다 | GetERPInterface(6665) / `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` / SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| TC-SSP0015-081 | 저장 | 기안 삭제 대상 확정 행 | 저장을 클릭한다 | – | SSP_ANL_SHIP_CONFIRM UPDATE/DELETE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT가 AS-IS와 같다 | GetERPInterface(6706), SoNo > GetErpIFCheckNew(7363) / `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` / SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| TC-SSP0015-082 | 저장 | SO No 없는 행(NonSoNo 분기, 조건 확인 필요) | 저장을 클릭한다 | – | CHG_REQ와 CHG_REQ_DE INSERT, I/F INSERT가 AS-IS와 같다 | GetERPInterface > NonSoNo(6843/6847) / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` |
| TC-SSP0015-083 | 저장 | SO No 있는 행(SoNo 분기) | 저장을 클릭한다 | – | 기안 저장이 AS-IS와 같다 | GetERPInterface > SoNo(7076/7080) / SP SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING, SP SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| TC-SSP0015-084 | 저장 | SoNo 분기, 변경 배치 대상 | 저장을 클릭한다 | – | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT와 CHG_REQ_DE UPDATE가 AS-IS와 같다 | SoNo > GetErpIFCheckNew(7389/7419) / `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` / SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| TC-SSP0015-085 | 저장(오류) | Packer 저장 중 SP 오류 유도 | 저장을 클릭한다 | – | 오류 메시지가 표시되고 이후 단계로 진행하지 않는다(롤백 범위 확인 필요) | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` |
| TC-SSP0015-086 | 저장 | ERP I/F Block 데이터 존재 | 저장을 클릭한다 | BLOCK_YN=Y, PERIOD | Block 처리가 AS-IS와 같다(데이터 원천 확인 필요) | chkERPIFBlockYn (BLOCK_YN, PERIOD) |
| TC-SSP0015-087 | 그리드 | TC-007 조회 완료 | `Shipment PSI(Mobility & IT)` 컬럼을 확인한다 | – | 표시 10개(Div·Figure·From Site·Model·Aging L/T·Measure·Nick Name·PSI·TYPE·Yield(%)), 숨김 7개, MergePolicy.Always | 시트 `Shipment PSI(Mobility & IT)` |
| TC-SSP0015-088 | 그리드 | TC-009 조회 완료 | `Shipment PSI(Packer)` 컬럼을 확인한다 | – | 표시 8개(Div·Figure·From Site·Model·Measure·Nick Name·PSI·TYPE), 숨김 9개 | 시트 `Shipment PSI(Packer)` |
| TC-SSP0015-089 | 그리드 | 화면 로드 완료 | 메타 전용 시트 `Shipment PSI(IT & Mobile)`가 있는지 확인한다 | – | 코드가 AddSheet하지 않으므로 탭이 없다(TO-BE 포함 여부 확인 필요) | 시트 `Shipment PSI(IT & Mobile)` |
| TC-SSP0015-090 | 그리드 | TC-014 조회 완료 | `Shipment Confirm Detail` 컬럼을 확인한다 | – | 표시 40개(설계서 §4 (4)), SHIPTO_DESCRIPTION 숨김 | 시트 `Shipment Confirm Detail` |
| TC-SSP0015-091 | 그리드 | TC-022 조회 완료 | `Shipment Request Detail` 컬럼을 확인한다 | – | 표시 34개. `*` 라벨 10개가 원문과 같다 | 시트 `Shipment Request Detail` |
| TC-SSP0015-092 | 그리드 | TC-023 조회 완료 | `W/H stock` 컬럼을 확인한다 | – | 메타 19개와 일치(컬럼 상세 확인 필요) | 시트 `W/H stock` |
| TC-SSP0015-093 | 그리드 | 화면 로드 완료 | `W/H stock Detail` 컬럼을 확인한다 | – | 메타 25개와 일치(컬럼 상세 확인 필요) | 시트 `W/H stock Detail` |
| TC-SSP0015-094 | 그리드 | TC-017 조회 완료 | `Hold stock` 컬럼을 확인한다 | – | 표시 10개. Amend Qty*, End Date* | 시트 `Hold stock` |
| TC-SSP0015-095 | 그리드 | TC-024 조회 완료 | `Hold stock Detail` 컬럼을 확인한다 | – | 표시 10개. Amend Qty, End Date(`*` 없음) | 시트 `Hold stock Detail` |
| TC-SSP0015-096 | 그리드 | TC-016 조회 완료 | `Stock Detail` 컬럼을 확인한다 | – | 메타 26개(USER_MOD_RELEASE_DATE = User Modified Release Date*) | 시트 `Stock Detail` |
| TC-SSP0015-097 | 그리드 | 화면 로드 완료 | 메타 전용 시트 `MES Stock Detail`이 있는지 확인한다 | – | 코드 미참조라 탭이 없다(TO-BE 포함 여부 확인 필요) | 시트 `MES Stock Detail` |
| TC-SSP0015-098 | 그리드 | TC-019 조회 완료 | `SCS Stock Detail` 컬럼을 확인한다 | – | 표시 9개 | 시트 `SCS Stock Detail` |
| TC-SSP0015-099 | 그리드 | TC-018 조회 완료 | `Stock Location Detail` 컬럼을 확인한다 | – | 메타 20개(확인된 6개 포함, 나머지 확인 필요) | 시트 `Stock Location Detail` |
| TC-SSP0015-100 | 그리드 | TC-028 조회 완료 | `WH In Plan Detail` 컬럼을 확인한다 | – | 메타 11개와 일치(상세 확인 필요) | 시트 `WH In Plan Detail` |
| TC-SSP0015-101 | 그리드 | TC-029 조회 완료 | `Shipment Result` 컬럼을 확인한다 | – | 표시 17개. Ship to와 Ship to Name 숨김 | 시트 `Shipment Result` |
| TC-SSP0015-102 | 그리드 | 날짜 헤더가 토·일을 포함하는 Period | 조회 후 날짜 헤더를 확인한다 | 주말 포함 기간 | SAT 컬럼은 Blue, SUN 컬럼은 Red. `B_` 컬럼은 숨김 | InitSpreadDateColumn 1110·1114·1118 / `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-103 | division | 14개 division 계정(또는 Division 선택) | Division을 하나씩 바꿔 각 시트 컬럼 수를 확인한다 | 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC | 모든 division에서 시트별 표시 컬럼 수가 같다(예: Shipment Confirm Detail 40, Shipment Result 17) | grid_effective / 시트 `Shipment Confirm Detail`, `Shipment Result` |
| TC-SSP0015-104 | division | Division A와 B의 Ship to 데이터가 다름 | Shipment Confirm Detail에서 TO_SITE_SHIPTO_CODE 콤보를 연다 | Division A / B | 콤보 목록이 division별로 다르게 조회된다 | `SpdDetail_CellClick` / `biz:CommonData.CommonDataList` [ShipToCodeByDivision] |
| TC-SSP0015-105 | 권한 | 프로그램 권한 행(drPgmAuthId) 없는 사용자 | 화면을 연다 | – | spdDetail에 `WH In Plan Detail` 탭이 생성되지 않는다 | CreateSpread:680 `if(drPgmAuthId != null)` / 시트 `WH In Plan Detail` |
| TC-SSP0015-106 | 권한 | TB_FX_GroupMenuAuth의 그룹별 권한(14행) | 그룹별 계정으로 조회·편집·저장 버튼 활성 상태를 확인한다 | 그룹 계정 | 버튼 활성 상태가 메뉴 권한과 같다(권한 값 확인 필요) | FindButton / EditButton / SaveButton |
| TC-SSP0015-107 | 회귀(미연결) | 화면 전 기능 수행 | 조회·저장·팝업 전체 시나리오를 수행하며 호출 로그를 확인한다 | – | 진입점 미연결 엔드포인트가 호출되지 않는다(사용 여부 확정 전 확인 필요) | unreached: GetErpIFCheck, GetErpIFCheckNew_ / `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` / SP SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0015-108 | 회귀(미연결) | 위와 같음 | 위와 같음 | – | 위와 같음 | unreached: SCM_SYS_LOG_BATCH / `SCP.PR_SCM_SYS_LOG_BATCH` / SP PR_SCM_SYS_LOG_BATCH |
| TC-SSP0015-109 | 회귀(미연결) | 위와 같음 | 위와 같음 | – | 위와 같음. Division 목록은 GetDivision이 아닌 경로로 채워진다(확인 필요) | unreached: GetDivision / `SCM.SCM0001_GET_DIVISION` / SP SCM0001_GET_DIVISION |
| TC-SSP0015-110 | 회귀(미연결) | 위와 같음 | 위와 같음 | – | CommonDataList code=PERIOD_*, PERIOD2_*와 NewNonSoNo 경로가 호출되지 않는다 | unreached: SetChangedPeriod, NewNonSoNo / `biz:CommonData.CommonDataList` [PERIOD_{p:value}, PERIOD2_{p:value}] |

### 커버리지 점검
| 대상 | 건수 | 커버 TC |
|---|---:|---|
| 이벤트 핸들러 | 33 / 33 | 001~006, 014~058(시트·이벤트), 059~066 |
| 엔드포인트 | 39 / 39 | `biz:CommonData.CommonDataList`(001, 038, 040, 044, 052, 068, 104, 110), DM0003(002), SCM0001_GET_SCP_DAY_PERIOD(003), SCP0009(004, 033), PSI 3종(007, 009, 010), NERP(008), CONFIRM_DETAIL(014, 020), _PACKER(021), WH_STOCK(015, 023), MES_STOCK(016, 027), BLOCK_STOCK(017, 024), STOCK_LOCATION(018, 025), SCS_STOCK(019, 026), SSP0026(022), PSI_COMMENTS(028), RESULT(029), RESULT_PACKER(030), SAVE_PSI_COMMENTS(066), USER_INFO_LIST(068), SAVE_SHIPMENT_PSI(069), CONFIRM_40(070), BLOCK_STOCK_DATA(072), SAVE_MES_STOCK(073), SSP0202(074), SSP0003(075), CONFIRM_PACKER(076), CHANGETIME(077), ERP_SO_NO_CNT(078), SHIPMENT_STATUS(079), ERP_ERROR_CONFIRM(080), DELETE_BY_CONFIRM(081), DRAFTING 2종(082, 083), CHG_BATCH(084), DELETE_DRAFTING(107), PR_SCM_SYS_LOG_BATCH(108), SCM0001_GET_DIVISION(109) |
| 시트 | 15 / 15 | 087~101 |
| division | 14 div 공통 1건 + division 의존 콤보 1건 | 103, 104 |
| 빈 결과·오류 | 6건 | 011, 012, 031, 067, 085 (+013 검증) |
