# SCP0041 소스 링크 표

기준 경로 접두: `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0041_StockOSP\`

## 1. 엔드포인트 호출 지점 (전수)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.cs | GetLookupData | 165 | `SCM.SCM0001_GET_LOOKUP_VALUES` 호출 (Form_Load > InitControls) |
| SCP0041_StockOSP.cs | SaveData | 354 | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` 호출 — **진입점 미연결** |
| SCP0041_StockOSP.cs | SaveDataPacker | 469 | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` 호출 (SaveButton) |
| SCP0041_StockOSP.cs | setPeriod | 549 | `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] (Data.CallBizCommonData) |
| SCP0041_StockOSP.cs | FindData_Main | 662 | `SCP.SCP0041_GET_STOCK_OSP` 호출 (FindButton) |
| SCP0041_StockOSP.cs | FindData_Pack | 740 | `SCP.SCP0041_GET_PACK_HOLD_STOCK` 호출 (FindButton, SaveDataPacker 후) |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.cs | .ctor | 117 | `this.Load += Form_Load` |
| SCP0041_StockOSP.cs | InitEvent | 219 | `btnItemId.Click += BtnItemId_Click` |
| SCP0041_StockOSP.cs | InitEvent | 220 | `cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged` |
| SCP0041_StockOSP.cs | InitEvent | 221 | `spdMain.SheetTabClick += SpdMain_SheetTabClick` |
| SCP0041_StockOSP.cs | InitEvent | 223 | `this.spdMain.EditChange += SpdMain_EditChange` |
| SCP0041_StockOSP.cs | InitEvent | 224 | `this.siMain.ActiveSheet.CellChanged += ActiveSheet_CellChanged` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 380 | `this.btnExcelUpload.Click += btnExcelUpload_Click` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 419 | `this.formDown.Click += btnExcelFormDownload_Click` |

## 3. Grid 생성·메타 소비

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.cs | CreateSpread | 174 | AddSheet `Osp Stock` (SpdSheet.shtMain, 1¦1¦35) |
| SCP0041_StockOSP.cs | CreateSpread | 175 | GetSheetInfo(spdMain.Name, ActiveSheetIndex) |
| SCP0041_StockOSP.cs | CreateSpread | 177 | AddSheet `Pack Hold Stock` (SpdSheet.shtPacker, 1¦1¦35) |
| SCP0041_StockOSP.cs | CreateSpread | 178 | GetSheetInfo |
| SCP0041_StockOSP.cs | CreateSpread | 180 | ChangeSheet |
| SCP0041_StockOSP.cs | InitSpread | 195 | ChangeSheet(0) |
| SCP0041_StockOSP.cs | InitSpread | 196 | ChangeActiveSheet(SpdSheet.shtMain = `Osp Stock`) |
| SCP0041_StockOSP.cs | SetSpreadInit | 203–204 | `if(sheetName.Equals("Osp Stock"))` → ChangeSheet(0)/InitSheet(0) |
| SCP0041_StockOSP.cs | SetSpreadInit | 208–209 | else → ChangeSheet(1)/InitSheet(1) |
| SCP0041_StockOSP.cs | SetSpreadInit | 211 | `SetSheetHeaderColumn(siMain, 1)` — 메타 컬럼 생성 |
| SCP0041_StockOSP.cs | EditButton | 268 | `if(iFocusTabIndex == 1) ⟫ … ⟫ GetSheetInfo` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 665–668 | ColumnHeader 기본 스타일 (정렬 General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |

## 4. 조회조건 값 추출(GetCheckedListValue) · 메타/데이터 읽기

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.cs | SetChangedControl | 520 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | FindData_Main | 639 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | FindData_Main | 640 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | FindData_Pack | 712 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | FindData_Pack | 713 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | FindData_Pack | 718 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | setPeriod | 558 | `dt.Rows[0]["FROM_VALUE"]` |
| SCP0041_StockOSP.cs | setPeriod | 559 | `dt.Rows[0]["TO_VALUE"]` |

## 5. 런타임 속성 변경

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.cs | InitControls | 156 | `layoutInspection.Text = DefPackLabel.INSEPECTION_ID` |
| SCP0041_StockOSP.cs | BtnItemId_Click | 882 | `txtItemId.Text = sItemId` |

## 6. Designer 주요 컨트롤 선언/속성

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.Designer.cs | (선언) | 33–59 | 컨트롤 27개 선언 |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 119–124 | usrConditionPanel1 Dock=Top, Size(1469,48), HidePanel |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 519 | Division Text `"Division*"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 533 | layoutControlItem7 Text `"Plant Site"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 551 | lblItemId Text `"Model"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 376 | btnExcelUpload Text `"Upload"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 416 | formDown Text `"Excel Form"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 605 | layoutControlItem5 Text `"Period*"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 620 | layoutInspection Text `"Inspection"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 635 | layStatus Text `"Status"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 643–648 | spdMain Dock=Fill, Size(1469,554) |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 751 | layoutCutoffDate Text `"Cutoff Date"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 765 | 폼 Text `"Plant Qty"` |
