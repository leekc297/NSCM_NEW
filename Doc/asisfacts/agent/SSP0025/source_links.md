# SSP0025 소스 링크 표

> 경로 기준: AS-IS 소스 루트(GSCM)부터의 상대 경로입니다. 링크는 `경로#L줄` 형식입니다.
> 약어: **M** = `06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs`, **MD** = `…/SSP0025_ShipmentRequestorPIC.Designer.cs`, **P** = `06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs`, **PD** = `…/Popup/SSP0025_ItembyDivisionPopup.Designer.cs`

## 1. 엔드포인트 호출 지점 (endpoints.csv 12행 전체)

| # | 파일 | 메서드 | 줄 | 내용 |
|---:|---|---|---:|---|
| 1 | [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L37) | `<field:dtMyDivision>` | 37 | `biz:CommonData.CommonDataList` [code=MyDivision] (Data.Common → CallBizCommonData) |
| 2 | [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L206) | InitControls | 206 | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] |
| 3 | [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L296) | FindData | 296 | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` |
| 4 | [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L357) | clbDivision_SelectedIndexChanged | 357 | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] |
| 5 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L45) | `<field:dtMyDivision>` | 45 | `biz:CommonData.CommonDataList` [code=MyDivision] |
| 6 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L47) | `<field:dtYesOrNo>` | 47 | `biz:CommonData.YesOrNo` (Data.Common → CallBizData) |
| 7 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L140) | SetChangedControl | 140 | `biz:CommonData.CommonDataList` [code=PlantCell] |
| 8 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L274) | FindData_Main | 274 | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| 9 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L410) | SaveData | 410 | `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` |
| 10 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L458) | GetUserIDChk | 458 | `SSP.SSP0025_GET_USER_ID_CHECK` |
| 11 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L511) | GetSSPUserCheck | 511 | `SSP.SSP0002_GET_USER_INFO_LIST` |
| 12 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L639) | SpdMain_CellClick | 639 | `biz:CommonData.CommonDataList` [code=PlantCell] |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [PD](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.Designer.cs#L188) | InitializeComponent | 188 | `clbDivisionId.SelectedIndexChanged += clbDivision_SelectedIndexChanged` |
| [PD](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.Designer.cs#L281) | InitializeComponent | 281 | `btnButtonList.UsrButtonList_Click_Detected += btnButtonList_UsrButtonList_Click_Detected` |
| [PD](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.Designer.cs#L362) | InitializeComponent | 362 | `spdMain.CellDoubleClick += spdMain_CellDoubleClick` |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L172) | .ctor | 172 | `this.Load += Form_Load` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L102) | .ctor | 102 | `this.Load += Form_Load` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L170) | InitEvent | 170 | `spdMain.TopChange += SpdMain_TopChange` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L171) | InitEvent | 171 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L172) | InitEvent | 172 | `spdMain.CellClick += SpdMain_CellClick` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L173) | InitEvent | 173 | `spdMain.ComboSelChange += SpdMain_ComboSelChange` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L175) | InitEvent | 175 | `cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L177) | InitEvent | 177 | `btnItemId.Click += btnItemId_Click` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L178) | InitEvent | 178 | `btnModelId.Click += btnModelId_Click` |

## 3. Grid 구성 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L146) | CreateSpread | 146 | `AddSheet(spdMain, SpdSheet.shtMain(="Shipment Requestor PIC"), …, 1, 1, 30)` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L147) | CreateSpread | 147 | `GetSheetInfo(spdMain.Name, 0)` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L149) | CreateSpread | 149 | `ChangeSheet` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L157) | InitSpread | 157 | `InitSheet("Shipment Requestor PIC")` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L159) | InitSpread | 159 | `SetSheetHeaderColumn(spdInfo, 1)`, 메타 컬럼 생성 |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L162) | InitSpread | 162~164 | `CellType = cellTypeImage` ×3 |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L220) | EditButton | 220 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)`, 조건 `fps != null && fps.Name == "spdMain"` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L318) | InsertRow | 318 | `SetCellTypeCombo(ActiveRow, DIVISION_ID, dtMyDivision)` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L320) | InsertRow | 320 | `SetCellTypeCombo(ActiveRow, SITE_DESCRIPTION, dtToSite)` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L640) | SpdMain_CellClick | 640 | `SetCellTypeCombo(e.Row, SITE_DESCRIPTION, dtToSite)`, 조건 Action=="I" && 컬럼==SITE_DESCRIPTION |
| [MD](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.Designer.cs#L499) | InitializeComponent | 499~502 | ColumnHeader 스타일(General 정렬, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced) |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L231) | CreateSpread | 231 | `AddSheet(spdMain, SpdSheet.shtMain(="Project"), …, 1, 1, 30)` |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L240) | InitSpread | 240 | `InitSheet(siMain.SheetName)` |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L243) | InitSpread | 243~253 | `AddTextColumn` ×10 + `AddNumColumnEx` ×1 |
| [PD](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.Designer.cs#L378) | InitializeComponent | 378~381 | ColumnHeader 스타일(위와 같음) |

## 4. 메타 소비·컨트롤 값 설정 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L139) | SetChangedControl | 139 | `GetCheckedListValue` (CODE) |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L258) | FindData_Main | 258, 259 | `GetCheckedListValue` (CODE) |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L234) | SaveButton | 234 | `SaveData`. 파서는 PersonalSettingPopup.SaveData로 해석했음(**확인 필요**) |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L718) | btnItemId_Click | 718 | `txtItemId.Text = popItem.ItemId` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L736) | btnModelId_Click | 736 | `txtModelId.Text = popItem.ModelId` |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L201) | InitControls | 201~205 | txtItemId/txtModelId 초기값, clbDivisionId.Enabled=false, clbFromSiteId.Enabled=true |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L358) | clbDivision_SelectedIndexChanged | 358 | `c["DIVISION_ID"]` 읽기 |
| [MD](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.Designer.cs#L539) | InitializeComponent | 539 | `this.Text = "SSP0014_ShipmentModelPIC"` |
| [PD](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.Designer.cs#L456) | InitializeComponent | 456 | `this.Text = "Item by DivisionPopup"` |
