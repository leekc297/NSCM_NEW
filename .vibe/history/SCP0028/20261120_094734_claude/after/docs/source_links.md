# SCP0028 소스 링크

기준 경로(공통 접두): `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0028_Shipment_Lot_Size\`
- `.cs` = `SCP0028_Shipment_Lot_Size.cs`
- `Designer.cs` = `SCP0028_Shipment_Lot_Size.Designer.cs`

## 1. 엔드포인트 호출 지점 (전부)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | `<field:dtTransMode>` | 44 | `biz:CommonData.CommonDataList` [code=LookupCommon], 경로 `Data.Common` > `Data.CallBizCommonData` (진입점 미연결) |
| .cs | `<field:dtYesOrNo>` | 46 | `biz:CommonData.YesOrNo`, 경로 `Data.Common` > `Data.CallBizData` (진입점 미연결) |
| .cs | `InitControls` | 135 | `biz:CommonData.YesOrNo`, 경로 `UsrComboBox.DataBind` > `Data.Common` > `Data.CallBizData` |
| .cs | `InitControls` | 137 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| .cs | `SetChangedControl` | 166 | `biz:CommonData.CommonDataList` [code=FromSiteByDivision], `UserInfoContext.Current.NowGroupID` 사용 |
| .cs | `SetChangedControl` | 169 | `biz:CommonData.CommonDataList` [code=ToSiteByDivision], `UserInfoContext.Current.NowGroupID` 사용 |
| .cs | `FindData` | 349 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` (FoxQuery ctor) |
| .cs | `FindInput` | 417 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` (FoxQuery ctor) |
| .cs | `FindDelete` | 511 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` (FoxQuery ctor) |
| .cs | `SaveData` | 659 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` (FoxQuery ctor) |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | `.ctor` | 95 | `this.Load += Form_Load` |
| .cs | `InitEvent` | 117 | `this.btnInput.Click += btnInput_Click` |
| .cs | `InitEvent` | 118 | `this.btnDelete.Click += btnDelete_Click` |
| .cs | `InitEvent` | 120 | `spdMain.TopChange += SpdMain_TopChange` |
| .cs | `InitEvent` | 124 | `dsdm.Changed += spdMain_Change` |
| .cs | `InitControls` | 144 | `cboDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| .cs | `InitControls` | 146 | `this.btnItemId.Click += btnItemId_Click` |

## 3. 메타 소비 / 체크리스트 값 추출

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | `InitControls` | 135 | `DataBind` → `UsrComboBox.DataBind` (CODE, NAME) |
| .cs | `SetChangedControl` | 160 | `GetCheckedListValue` (CODE) |
| .cs | `btnInput_Click` | 265 | `GetCheckedListValue` (CODE) |
| .cs | `btnDelete_Click` | 293 | `GetCheckedListValue` (CODE) |
| .cs | `FindData` | 332~336 | `GetCheckedListValue` 5회 (CODE) |
| .cs | `InitSpread` | 186 | `SetSheetHeaderColumn` → `SpreadInfo.SetSheetHeaderColumn` |
| .cs | `SaveButton` | 207 | `SaveData` (정적 해석 결과 `PersonalSettingPopup.SaveData`, 확인 필요) |
| .cs | `btnItemId_Click` | 256 | `txtItemId.Text = sItemId` |

## 4. Grid 생성 코드

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | `CreateSpread` | 176 | `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30)`, 시트 `Shipment Lot Size` |
| .cs | `CreateSpread` | 177 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)` |
| .cs | `CreateSpread` | 178 | `ChangeSheet` |
| .cs | `InitSpread` | 185 | `InitSheet(siMain.SheetName)` |
| .cs | `InitSpread` | 186 | `SetSheetHeaderColumn(siMain, 1)` |
| .cs | `EditButton` | 231 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` |
| Designer.cs | `InitializeComponent` | 633 | ColumnHeader `HorizontalAlignment = General` |
| Designer.cs | `InitializeComponent` | 634 | `NoteIndicatorColor = Red` |
| Designer.cs | `InitializeComponent` | 635 | `Parent = "ColumnHeaderDefaultEnhanced"` |
| Designer.cs | `InitializeComponent` | 636 | `VerticalAlignment = General` |

## 5. 컨트롤 선언 (Designer.cs)

| 컨트롤 | 유형 | 줄 |
|---|---|---:|
| usrLayoutControl1 | UsrLayoutControl | 33 |
| layoutControlGroup1 | LayoutControlGroup | 34 |
| usrConditionPanel1 | UsrConditionPanel | 35 |
| usrLayoutControl2 | UsrLayoutControl | 36 |
| cboValid | UsrComboBox | 37 |
| cboDivision | UsrCombo | 38 |
| btnItemId | UsrButton | 39 |
| txtItemId | UsrMultiLineEditor | 40 |
| cboOperationGroup | UsrCombo | 41 |
| clbFromSite | UsrCheckedList | 42 |
| clbTransMode | UsrCheckedList | 43 |
| btnInput | UsrButton | 44 |
| btnDelete | UsrButton | 45 |
| layoutControlGroup2 | LayoutControlGroup | 46 |
| Division / layoutControlItem1·7·6·3·11·9·5·2 | LayoutControlItem | 47, 49~53, 55, 58, 59 |
| emptySpaceItem1·3·2·4 | EmptySpaceItem | 48, 54, 56, 57 |
| spdMain | FpSpread | 60 |
| spdMain_Sheet1 | SheetView | 61 |
| imageList1 | ImageList | 62 |
| clbToSite | UsrCheckedList | 63 |
| layoutControlItem4 | LayoutControlItem | 64 |
