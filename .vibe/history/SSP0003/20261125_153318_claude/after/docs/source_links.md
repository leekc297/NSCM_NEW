# SSP0003 소스 링크 표

기준 파일:
- `CS` = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.cs`
- `DS` = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | InitControls | 317 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` |
| CS | SetChangedControl | 369 | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` (NOT_IN_FOXQUERY) |
| CS | SetChangedControl | 386 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` (NOT_IN_FOXQUERY) |
| CS | FindData_Main | 696 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| CS | FindData_Sub | 772 | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| CS | SaveDraftingData | 970 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` |
| CS | SaveData | 1207 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| CS | SaveData | 1207 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| CS | (주석) | 1209 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`. 주석 처리됨 |
| CS | GetErpIFCheck | 1337 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| CS | GetErpIFCheckNew | 1409 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| CS | GetErpIFCheckNew | 1458 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| CS | GetErpIFCheckNew | 1492 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| CS | GetErpIFCheckNew | 1541 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| CS | SetChangedPeriod | 1573 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] (Data.CallBizCommonData) |
| CS | EngProcessingChk | 1619 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` |
| CS | GetShipmentStatusChk | 1656 | `SSP.SSP0200_GET_SHIPMENT_STATUS` |
| CS | Delegate_Load | 1834 | `SSP.SSP0003_GET_DELEGATEE_LOAD` |
| CS | (주석) | 1863 | `SCP.GET_DATE_RANGE_1MONTH`. 주석 처리됨 |
| CS | GetDayRange | 1864 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 203 | this.Load += `Form_Load` |
| CS | .ctor | 204 | this.spdMain.CellDoubleClick += `SpdMain_CellDoubleClick` |
| CS | InitEvent | 275 | clbDivision.SelectedIndexChanged += `ClbDivision_SelectedIndexChanged` |
| CS | InitEvent | 276 | spdMain.TopChange += `SpdMain_TopChange` |
| CS | InitEvent | 278 | btnApproval.Click += `BtnApproval_Click` |
| CS | InitEvent | 279 | btnReject.Click += `BtnReject_Click` |
| CS | InitEvent | 280 | btnSelfReject.Click += `BtnSelfReject_Click` |
| CS | InitEvent | 281 | btnRequestUser.Click += `BtnRequestUser_Click` |
| CS | InitEvent | 282 | btnItemId.Click += `btnItemId_Click` |

## 3. 프레임워크 메타 소비 호출

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangeControl | 227~228 | Filter GROUP_ID / USER_ID, UserInfoContext.NowGroupID |
| CS | SetChangeControl | 234, 239, 244, 249, 254, 259, 264 | `DataService.GetSSPInnerTable` |
| CS | InitControls | 293, 301 | `DataService.FP_Log2` |
| CS | InitControls | 321, 330 | NowGroupID, `c["CODE"]` |
| CS | SetChangedControl | 354 | `CString.GetCheckedListValue` |
| CS | SetChangedControl | 376, 391 | NowGroupID |
| CS | FindData_Main | 675, 678, 683, 685 | `CString.GetCheckedListValue` |
| CS | InitSpread | 431, 439 | `SpreadInfo.SetSheetHeaderColumn` |
| CS | SetChangeRequestInfo | 852~859 | dt.Rows[0]: CHANGE_REQ_NO, REQUEST_TITLE, REQUEST_USER, REQUEST_DEPT, APPROVAL_USER, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, APPROVAL_DEPT_NAME |
| CS | GetErpIFCheck | 1349 | ds.Tables[0].Rows[0]["result_code"] |
| CS | GetErpIFCheckNew | 1426 | ds.Tables[0].Rows[0]["result_code"] |
| CS | SetChangedPeriod | 1580, 1581 | FROM_VALUE, TO_VALUE |
| CS | chkERPIFBlockYn | 1593, 1602 | Field: BLOCK_YN, PERIOD |
| CS | GetShipmentStatusChk | 1699 | ds.Tables[2].Rows[iRow]["CONFIRM_ID"] |
| CS | BtnSelfReject_Click | 1921 | SaveData 호출 |
| CS | BtnReject_Click | 1993 | SaveData 호출 |
| CS | BtnApproval_Click | 2029, 2061, 2063 | SaveData 호출 |

## 4. Grid 코드 정의

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 405~406 | AddSheet / GetSheetInfo: spdMain, `Shipment Change Request Confirm` (SpdSheet.shtMain, 1, 1, 30) |
| CS | CreateSpread | 409~419 | AddSheet / GetSheetInfo / ChangeSheet: txtApprovalDeptName, `Shipment Change Request Confirm Detail` (SpdSheet.shtSub, 2, 1, 30) |
| CS | InitSpread | 426, 431 | InitSheet + SetSheetHeaderColumn(spreadInfo, 1): Main |
| CS | InitSpread | 437, 439 | InitSheet + SetSheetHeaderColumn(spreadInfo, 2): Detail |
| CS | InitSpread | 447~449 | CHK CellType / Value=true / Border |
| CS | InitSpread | 475 | `_sChangeType == "P"` → ERP_SO_NO Visible=false |
| CS | InitSpread | 477~492 | P 분기 ColumnHeaderSpan ("Plan", "Confirm", 2행 헤더) |
| CS | InitSpread | 503 | else 분기 → ERP_SO_NO Visible=true |
| CS | InitSpread | 505~520 | else 분기 ColumnHeaderSpan ("Confirmed", "Change", 2행 헤더) |
| CS | FindData_Sub | 827 | VisibleColumns(0, false) (p_status 조건) |
| DS | InitializeComponent | 191~194, 839~842 | 헤더 기본 스타일(General 정렬, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |

## 5. 화면 배치 (Designer)

| 파일 | 줄 | 내용 |
|---|---:|---|
| DS | 146, 150, 162, 163 | splitContainer1: Dock Fill, Orientation Horizontal, Size(1192, 649), SplitterDistance 259 |
| DS | 169, 174 | spdMain: Dock Fill, Size(1192, 192) |
| DS | 220, 223, 225 | usrConditionPanel1: Dock Top, Size(1192, 67), HidePanel |
| DS | 648~652 | lcDivision → clbDivision, Text "Division" |
| DS | 682~690 | layoutControlItem1 → drpPeriod, Text "Request Date" |
| DS | 697~702 | layoutControlItem7 → clbFromSite, Text "From Site" |
| DS | 709~714 | PlanType → cboStatus, Text "Status" |
| DS | 804~809 | PlanType1 → cboChangeType, Text "Change Type" |
| DS | 379, 426, 437 | 버튼 Text "Self Reject", "Reject", "Approval" |
| DS | 817, 822 | txtApprovalDeptName(FpSpread): Dock Fill, Size(1192, 174) |
| DS | 867~880 | splitter1: Dock Top, 3px / panel1: Dock Top, 209px |
| DS | 908~925 | txtRequestNo, txtTitle, txtRequestor: ReadOnly true (이후 행은 Fact Pack에서 잘려 확인 필요) |
