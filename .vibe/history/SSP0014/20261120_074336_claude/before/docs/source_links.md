# SSP0014 소스 링크

기준 경로: `06.UIL\GSCM.SSP.Plan.UIL\`

## 1. 엔드포인트 호출 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0014_ShipmentModelPIC.cs | `<field:dtYesOrNo>` | 54 | `biz:CommonData.YesOrNo` (Data.Common[Type.YesOrNo] > Data.CallBizData), 진입점 미연결 |
| SSP0014_ShipmentModelPIC.cs | FindData_Main | 329 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |
| SSP0014_ShipmentModelPIC.cs | SaveData | 497 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` |
| SSP0014_ShipmentModelPIC.cs | GetUserIDChk | 562 | `SSP.SSP0014_GET_USER_ID_CHECK` |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0014_ShipmentModelPIC.cs | .ctor | 110 | `this.Load += Form_Load` |
| SSP0014_ShipmentModelPIC.cs | InitEvent | 240 | `spdMain.TopChange += SpdMain_TopChange` |
| SSP0014_ShipmentModelPIC.cs | InitEvent | 241 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| SSP0014_ShipmentModelPIC.cs | InitEvent | 242 | `cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged` |
| SSP0014_ShipmentModelPIC.cs | InitEvent | 243 | `btnItemId.Click += btnItemId_Click` |
| SSP0014_ShipmentModelPIC.cs | btnItemId_Click | 857 | `txtItemId.Text = sItemId` |

## 3. 메타·프레임워크 호출

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0014_ShipmentModelPIC.cs | SetChangeControl | 137 | Filter GROUP_ID / UserInfoContext.Current.NowGroupID |
| SSP0014_ShipmentModelPIC.cs | SetChangeControl | 138 | Filter USER_ID |
| SSP0014_ShipmentModelPIC.cs | SetChangeControl | 144 | DataService.GetSSPInnerTable |
| SSP0014_ShipmentModelPIC.cs | SetChangeControl | 149 | DataService.GetSSPInnerTable |
| SSP0014_ShipmentModelPIC.cs | InitControls | 170 | DataService.FP_Log2 |
| SSP0014_ShipmentModelPIC.cs | InitControls | 173 | DataService.FP_Log2 |
| SSP0014_ShipmentModelPIC.cs | InitControls | 184 | insertRow["CODE"] |
| SSP0014_ShipmentModelPIC.cs | InitControls | 185 | insertRow["NAME"] |
| SSP0014_ShipmentModelPIC.cs | SetChangedControl | 197 | CString.GetCheckedListValue |
| SSP0014_ShipmentModelPIC.cs | FindData_Main | 310~313 | CString.GetCheckedListValue (4회) |
| SSP0014_ShipmentModelPIC.cs | SaveButton | 285 | SaveData 호출 (추출기 해석: PersonalSettingPopup.SaveData, 확인 필요) |

## 4. Grid 정의

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0014_ShipmentModelPIC.cs | CreateSpread | 208 | AddSheet(spdMain, SpdSheet.shtMain = "Shipment Model PIC", 1, 1, 30) |
| SSP0014_ShipmentModelPIC.cs | CreateSpread | 209 | GetSheetInfo(spdMain.Name, 0) |
| SSP0014_ShipmentModelPIC.cs | CreateSpread | 211 | ChangeSheet |
| SSP0014_ShipmentModelPIC.cs | InitSpread | 220 | InitSheet(SpdSheet.shtMain), 조건 `spdInfo.SheetName == "Shipment Model PIC"` |
| SSP0014_ShipmentModelPIC.cs | InitSpread | 222 | SpreadInfo.SetSheetHeaderColumn(spdInfo, 1) |
| SSP0014_ShipmentModelPIC.cs | InitSpread | 225, 226, 227, 229, 230, 231, 232, 233 | CellType = cellTypeImage |
| SSP0014_ShipmentModelPIC.cs | EditButton | 271 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| SSP0014_ShipmentModelPIC.Designer.cs | InitializeComponent | 411~414 | 컬럼헤더 HorizontalAlignment / NoteIndicatorColor / Parent / VerticalAlignment |

## 5. Designer 컨트롤 선언 (Designer.cs)

| 컨트롤 | 유형 | 선언 줄 | 주요 속성 줄 |
|---|---|---:|---|
| usrButton1 | UsrButton | 33 | Size 104 |
| usrConditionPanel1 | UsrConditionPanel | 34 | Dock 113, Size 116, UsrPanelType 118 |
| usrLayoutControl2 | UsrLayoutControl | 35 | Dock 130, Size 135, Text 137 |
| cboDivision | UsrCombo | 36 | Size 171 |
| cboOperationGroup | UsrCombo | 37 | Size 207 |
| clbFromSite | UsrCheckedList | 38 | Size 243 |
| cboValidYN | UsrCombo | 39 | Size 280 |
| txtUser | TextBox | 40 | Size 288 |
| layoutControlGroup2 | LayoutControlGroup | 41 | Size 307 |
| emptySpaceItem2 | EmptySpaceItem | 42 | Size 315 |
| Division | LayoutControlItem | 43 | Control 320, Size 324, Text 325 |
| layoutControlItem1 | LayoutControlItem | 44 | Control 332, Size 336, Text 337 |
| layoutControlItem7 | LayoutControlItem | 45 | Control 342, Size 346, Text 347 |
| layoutControlItem3 | LayoutControlItem | 46 | Control 354, Size 358, Text 359 |
| layoutControlItem2 | LayoutControlItem | 47 | Control 366, Size 371, Text 373 |
| emptySpaceItem1 | EmptySpaceItem | 48 | Size 383 |
| spdMain | FpSpread | 49 | Dock 389, Size 394 |
| spdMain_Sheet1 | SheetView | 50 | – |
| btnItemId | UsrButton | 51 | Size 466 |
| layoutControlItem4 | LayoutControlItem | 52 | Control 474, Size 480, Text 482 |
| txtItemId | UsrMultiLineEditor | 53 | Size 516 |
| lblItemId | LayoutControlItem | 54 | Control 522, Size 526, Text 527 |
| imageList1 | ImageList | 55 | – |
| this (Form) | – | – | Text 546 |
