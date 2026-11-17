# SSP0202 소스 링크 (파일·줄 기준)

기준 경로(AS-IS GSCM 소스 루트 기준):
- CS = `06.UIL\GSCM.SSP.Plan.UIL\SSP0202_ShipmentChangeRequestConfirm.cs`
- DS = `06.UIL\GSCM.SSP.Plan.UIL\SSP0202_ShipmentChangeRequestConfirm.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체 10건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | FindData_Main | 611 | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| CS | FindData_Sub | 687 | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| CS | SaveData | 875 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| CS | SaveData | 875 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| CS | GetErpIFCheck | 986 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| CS | SetChangedPeriod | 1044 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] (via `Data.CallBizCommonData`, 진입점 미연결) |
| CS | EngProcessingChk | 1090 | `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` |
| CS | chkSaveYN | 1130 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` |
| CS | Delegate_Load | 1233 | `SSP.SSP0202_GET_DELEGATEE_LOAD` |
| CS | GetDayRange | 1263 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |

## 2. 주석 처리된 호출 (주석 처리됨, 현행 아님)

| 파일 | 줄 | 내용 |
|---|---:|---|
| CS | 877 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` (주석 처리됨) |
| CS | 1262 | `SCP.GET_DATE_RANGE_1MONTH` (주석 처리됨) |

## 3. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 185 | `this.Load += Form_Load` |
| CS | .ctor | 186 | `this.spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| CS | InitEvent | 257 | `clbDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| CS | InitEvent | 258 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | InitEvent | 260 | `btnApproval.Click += BtnApproval_Click` |
| CS | InitEvent | 261 | `btnReject.Click += BtnReject_Click` |
| CS | InitEvent | 262 | `btnSelfReject.Click += BtnSelfReject_Click` |
| CS | InitEvent | 263 | `btnRequestUser.Click += BtnRequestUser_Click` |
| CS | InitEvent | 264 | `btnItemId.Click += btnItemId_Click` |

## 4. 프레임워크 메타 소비 호출

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangeControl | 209, 210 | Filter GROUP_ID / USER_ID, UserInfoContext.Current.NowGroupID |
| CS | SetChangeControl | 216, 221, 226, 231, 236, 241, 246 | `DataService.GetSSPInnerTable` |
| CS | InitControls | 275, 283 | `DataService.FP_Log2` |
| CS | InitControls | 295 | `c["CODE"]` |
| CS | SetChangedControl | 319 | `CString.GetCheckedListValue` |
| CS | SetChangedControl | 327 | UserInfoContext.Current.NowGroupID |
| CS | CreateSpread | 342, 343 | AddSheet / GetSheetInfo `Shipment Change Request Confirm` (spdMain) |
| CS | CreateSpread | 346, 347, 349, 352, 356 | AddSheet / GetSheetInfo / ChangeSheet `Shipment Change Request Confirm Detail` (txtApprovalDeptName) |
| CS | InitSpread | 363, 368 | InitSheet, `SetSheetHeaderColumn(spreadInfo, 1)` — Main |
| CS | InitSpread | 397, 399 | InitSheet, `SetSheetHeaderColumn(spreadInfo, 2)` — Detail |
| CS | InitSpread | 405 | `_sChangeType == "P"` → ERP_SO_NO Visible = false |
| CS | InitSpread | 407~422 | "P" 분기 ColumnHeaderSpan (Plan / Confirm, 2행 헤더 라벨) |
| CS | InitSpread | 427 | else → ERP_SO_NO Visible = true |
| CS | InitSpread | 429~444 | else 분기 ColumnHeaderSpan (Confirmed / Change, 2행 헤더 라벨) |
| CS | FindData_Main | 593, 594, 598, 600 | `CString.GetCheckedListValue` |
| CS | SetChangeRequestInfo | 723~730 | dt.Rows[0] CHANGE_REQ_NO … APPROVAL_DEPT_NAME |
| CS | GetErpIFCheck | 998 | `ds.Tables[0].Rows[0]["result_code"]` |
| CS | SetChangedPeriod | 1051, 1052 | FROM_VALUE, TO_VALUE |
| CS | chkERPIFBlockYn | 1064, 1073 | `Field<T>("BLOCK_YN")`, `Field<T>("PERIOD")` |
| CS | chkSaveYN | 1141, 1147, 1161 | CNT |
| CS | BtnSelfReject_Click | 1311 | SaveData (4-2에서 PersonalSettingPopup.SaveData로 매핑됨, 확인 필요) |
| CS | BtnReject_Click | 1369 | SaveData (위와 같음) |
| CS | BtnApproval_Click | 1412 | SaveData (위와 같음) |

## 5. Designer 주요 위치

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| DS | InitializeComponent | 144, 148, 160, 161 | splitContainer1 Dock Fill / Orientation Horizontal / Size(1192,649) / SplitterDistance 259 |
| DS | InitializeComponent | 167, 172 | spdMain Dock Fill / Size(1192,192) |
| DS | InitializeComponent | 189~192 | spdMain 헤더 스타일(HorizontalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VerticalAlignment General) |
| DS | InitializeComponent | 218~223 | usrConditionPanel1 Dock Top / Size(1192,67) / HidePanel |
| DS | InitializeComponent | 377, 424, 435 | 버튼 Text "Self Reject" / "Reject" / "Approval" |
| DS | InitializeComponent | 650, 688, 700, 712, 807 | 조건 라벨 "Division" / "Request Date" / "From Site" / "Status" / "Change Type" |
| DS | InitializeComponent | 815, 820 | txtApprovalDeptName(FpSpread) Dock Fill / Size(1192,174) |
| DS | InitializeComponent | 837~840 | txtApprovalDeptName 헤더 스타일(위와 같음) |
| DS | InitializeComponent | 865~878 | splitter1 Top(3) / panel1 Top(209) |
| DS | InitializeComponent | 906~1006 | 상세 TextBox ReadOnly·Size, usrLabel2 "Request Confirm Detail"(991) |
| DS | InitializeComponent | 1041 | layoutControlItem5 Text "Request No" |
