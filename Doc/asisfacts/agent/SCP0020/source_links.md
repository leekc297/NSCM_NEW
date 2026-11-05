# SCP0020 소스 링크 표

> 기준 루트: AS-IS GSCM 소스. 경로 약칭은 다음과 같습니다.
> - `CS` = `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs`
> - `DES` = `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs`

## 1. 엔드포인트 호출 지점 (전수)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtValidYN>` | 57 | `biz:CommonData.YesOrNo` (Data.Common → Data.CallBizData) |
| CS | `<field:dtYesOrNo>` | 58 | `biz:CommonData.YesOrNo` |
| CS | DefineProperty | 199 | `biz:CommonData.CommonDataList` [code=LineByOperation] (Data.CallBizCommonData) |
| CS | InitControls | 218 | `biz:CommonData.YesOrNo` (UsrComboBox.DataBind) |
| CS | InitControls | 220 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| CS | Find_Packer | 980 | `SCP.SCP0020_GET_TACT_TIME_OSP` → SP SCP0020_GET_TACT_TIME_OSP |
| CS | FindData_Main | 1041 | `biz:CommonData.CommonDataList` [code=LineByOperation] |
| CS | FindData_Main | 1067 | `SCP.SCP0020_GET_TACT_TIME` → SP SCP0020_GET_TACT_TIME |
| CS | FindData_Except_Packer | 1321 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` → SP SCP0020_GET_TACT_TIME_EXCEPT_OSP |
| CS | FindData_Except | 1397 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT` → SP SCP0020_GET_TACT_TIME_EXCEPT |
| CS | SaveData_Packer | 1560 | `SCP.SCP0020_SAVE_TACT_TIME_OSP` → SP SCP0020_SAVE_TACT_TIME_OSP |
| CS | SaveData_Main | 1797 | `SCP.SCP0020_SAVE_TACT_TIME` → SP SCP0020_SAVE_TACT_TIME |
| CS | SaveData_Except_Packer | 2023 | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` → SP SCP0020_SAVE_TACT_TIME_EXCEPT_OSP |
| CS | SaveData_Except | 2227 | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT` → SP SCP0020_SAVE_TACT_TIME_EXCEPT |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| DES | InitializeComponent | 271 | `this.btnItemId.Click += btnItemId_Click` |
| DES | InitializeComponent | 505 | `this.spdMain.EditModeOff += SpdMain_EditModeOff` |
| DES | InitializeComponent | 506 | `this.spdMain.EditChange += SpdMain_EditChange` |
| DES | InitializeComponent | 558 | `this.spdExcept.EditModeOff += spdExcept_EditModeOff` |
| DES | InitializeComponent | 559 | `this.spdExcept.EditChange += spdExcept_EditChange` |
| CS | .ctor | 179 | `this.Load += Form_Load` |
| CS | InitEvent | 460 | `cboDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| CS | InitEvent | 461 | `clbPlantSite.SelectedIndexChanged += ClbPlantSite_SelectedIndexChanged` |
| CS | InitEvent | 463 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| CS | InitEvent | 464 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | InitEvent | 465 | `spdMain.CellClick += SpdMain_CellClick` |
| CS | InitEvent | 467 | `spdExcept.TopChange += SpdExcept_TopChange` |
| CS | InitEvent | 471 | `dsdmMain.Changed += SpdMain_Changed` |
| CS | InitEvent | 474 | `dsdmMainPacker.Changed += SpdMain_Changed_Packer` |
| CS | InitEvent | 476 | `spdMain.ClipboardPasted += SpdMain_ClipboardPasted` |
| CS | InitEvent | 479 | `this.spdMain.ActiveSheetChanged += SpdMain_ActiveSheetChanged` |
| CS | InitEvent | 482 | `dsdmExcept.Changed += SpdExcept_Changed` |

## 3. Grid 정의 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 374 | AddSheet spdMain `SpdSheet.shtMain` = `Plant` |
| CS | CreateSpread | 375 | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) |
| CS | CreateSpread | 377 | AddSheet spdMain `SpdSheet.shtPacker` = `Packer` |
| CS | CreateSpread | 378 / 380 | GetSheetInfo / ChangeSheet (Packer) |
| CS | CreateSpread | 384 | AddSheet spdExcept `SpdSheet.shtExcept` = `Tact Time Except` |
| CS | CreateSpread | 385 / 386 | GetSheetInfo / ChangeSheet (Tact Time Except) |
| CS | InitSpread | 395 | InitSheet(spreadInfo.SheetName), 조건 `SheetName == "Tact Time Except"` |
| CS | InitSpread | 406 | `SetSheetHeaderColumn(spreadInfo, 1)` |
| CS | InitSpread | 410 / 411 | Plant 활성 시: DAILY_CAPACITY Visible=false / OPERATION_NAME Visible=true |
| CS | InitSpread | 415 / 416 | 그 외: DAILY_CAPACITY Visible=true / OPERATION_NAME Visible=false |
| CS | InitSpread | 425 / 426 | else 분기: ChangeSheet(1) / ChangeActiveSheet(SpdSheet.shtPacker) |
| CS | SetSpreadInit | 435 / 436 / 438 | `sheetName.Equals("Plant")`: ChangeSheet(0)·InitSheet(0)·SetSheetHeaderColumn(siMain,1) |
| CS | SetSpreadInit | 442 | `siMain.ActiveSheet.Visible = false` |
| CS | SetSpreadInit | 446 / 447 / 449 | else: ChangeSheet(1)·InitSheet(1)·SetSheetHeaderColumn(siMain,1) |
| CS | EditButton | 563 / 607 / 673 | GetSheetInfo (spdMain 시트0 / 시트1 / spdExcept) |
| CS | EditButton | 641 | SetCellTypeCombo LINE_ID (INPUT_STATUS == "I") |
| CS | InsertButton | 864 | SetCellTypeCombo LINE_ID (SheetName == "Packer") |
| CS | Find_Packer | 961 | ChangeSheet(SpdSheet.shtPacker) |
| CS | FindData_Main | 1045 | ChangeSheet(SpdSheet.shtMain) |
| CS | SpdMain_CellClick | 2583 | SetCellTypeCombo LINE_ID (Plant 시트) |
| CS | SpdMain_ClipboardPasted | 2773 | SetCellTypeCombo LINE_ID (붙여넣기 범위) |
| CS | SpdMain_ActiveSheetChanged | 2792 / 2793 | ChangeSheet / ChangeActiveSheet(SpdSheet.shtMain) |
| CS | SpdMain_ActiveSheetChanged | 2799 / 2800 | ChangeSheet / ChangeActiveSheet(SpdSheet.shtPacker) |
| DES | InitializeComponent | 522~525 | spdMain 컬럼헤더 스타일 (General/Red/ColumnHeaderDefaultEnhanced/General) |
| DES | InitializeComponent | 575~578 | spdExcept 컬럼헤더 스타일 (동일) |

## 4. 메타/데이터 컬럼 읽기 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | DefineProperty | 198 | GetCheckedListValue (CODE) |
| CS | RefreshPlantSiteByDivision | 292 | GetCheckedListValue (CODE) |
| CS | RefreshLineByOperation | 301, 302 | GetCheckedListValue (CODE) |
| CS | RefreshLineByOperationOfSpd | 315, 316 | GetCheckedListValue (CODE) |
| CS | RefreshLineByPlantPacker | 327, 328 | GetCheckedListValue (CODE) |
| CS | SetChangedControl_Osp | 362 / 363 | drRow/dr `CODE` / `NAME` |
| CS | EditButton | 636 / 637 | drRow/dr `CODE` / `NAME` |
| CS | InsertButton | 859 / 860 | drRow/dr `CODE` / `NAME` |
| CS | SaveData_Packer | 1622 | dtErr.Rows[0] `ERR_MESSAGE` |
| CS | SaveData_Main | 1874 | dtErr.Rows[0] `ERR_MESSAGE` |
| CS | SaveData_Except_Packer | 2094 | dtErr.Rows[0] `ERR_MESSAGE` |
| CS | SaveData_Except | 2297 | dtErr.Rows[0] `ERR_MESSAGE` |
| CS | SpdMain_ClipboardPasted | 2769 / 2770 | drRow/dr `CODE` / `NAME` |
| CS | btnItemId_Click | 2560 | `txtItemId.Text = sItemId` |

## 5. 컨트롤 선언 지점 (DES)

| 컨트롤 | 유형 | 선언 줄 | 주요 속성 줄 |
|---|---|---:|---|
| usrConditionPanel1 | UsrConditionPanel | 34 | Dock Top 106, Size 109, UsrPanelType HidePanel 111 |
| usrLayoutControl2 | UsrLayoutControl | 35 | Dock Fill 123, Size 127 |
| cboOperationGroup | UsrCombo | 36 | Size 163, 라벨 472 |
| cboDivision | UsrCombo | 37 | Size 199, 라벨 399 |
| txtItemId | UsrMultiLineEditor | 38 | Size 233, 라벨 429 |
| btnItemId | UsrButton | 39 | Size 266 |
| cboValid | UsrComboBox | 40 | Size 280, 라벨 452 |
| clbLine | UsrCheckedList | 41 | Size 315, 라벨 410 |
| clbPlantSite | UsrCheckedList | 42 | Size 354, 라벨 388 |
| splitContainer2 | SplitContainer | 53 | Dock 479, Orientation 482, Size 491, SplitterDistance 492 |
| spdMain | FpSpread | 54 | Dock 498, Size 503 |
| spdExcept | FpSpread | 56 | Dock 551, Size 556 |
| this | Form | - | Text "Tac Time" 609 |
