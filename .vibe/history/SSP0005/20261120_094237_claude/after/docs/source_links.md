# SSP0005 — 소스 링크 표

기준 경로:
- `CS` = `06.UIL\GSCM.SSP.Plan.UIL\SSP0005_ShipmentWorkingDay.cs`
- `DS` = `06.UIL\GSCM.SSP.Plan.UIL\SSP0005_ShipmentWorkingDay.Designer.cs`

## 1. 엔드포인트 호출 지점 (전수 12건 + 주석 2건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtMyDivision>` | 45 | `biz:CommonData.CommonDataList` [code=MyDivision] (`UserInfoContext.Current.NowGroupID` 사용) |
| CS | `<field:dtCompany>` | 46 | `biz:CommonData.CommonDataList` [code=Company] |
| CS | `<field:dtDayWeek>` | 47 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| CS | `<field:dtYesOrNo>` | 48 | `biz:CommonData.YesOrNo` |
| CS | `InitControls` | 168 | `biz:CommonData.YesOrNo` (`UsrComboBox.DataBind`) |
| CS | `FindData_Main` | 403 | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` |
| CS | `SaveData_Main` | 535 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` |
| CS | `SaveData_Main` | 536 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` |
| CS | `SaveData_Main` | 537 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` |
| CS | `SetChangedPeriod` | 910 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] |
| CS | `GetSpdTitle` | 925 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| CS | `GetDayRange` | 941 | `SCP.SCM0001_GET_SCP_PERIOD` |
| CS | (주석) | 569 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY` — 주석 처리됨 |
| CS | (주석) | 940 | `SCP.GET_DATE_RANGE_1MONTH` — 주석 처리됨 |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `.ctor` | 123 | `this.Load += Form_Load` |
| CS | `InitEvent` | 311 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| CS | `InitEvent` | 312 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | `InitEvent` | 314 | `cboDayWeek.SelectedIndexChanged += CboDayWeek_SelectedIndexChanged` |
| CS | `InitEvent` | 316 | `btnInput.Click += BtnInput_Click` |
| CS | `BtnInput_Click` | 725 | `dsdm.Changed -= SpdMain_Changed` |
| CS | `BtnInput_Click` | 821 | `dsdm.Changed += SpdMain_Changed` |
| CS | `SpdMain_Changed` | 878 | `dsdm.Changed -= SpdMain_Changed` |
| CS | `SpdMain_Changed` | 902 | `dsdm.Changed += SpdMain_Changed` |

## 3. Grid 구성 / 메타 소비

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `CreateSpread` | 179 | `AddSheet` — `Shipment Working Day` (args 3 ¦ 1 ¦ 35) |
| CS | `CreateSpread` | 180 | `GetSheetInfo(spdMain.Name, 0)` |
| CS | `CreateSpread` | 182 | `ChangeSheet` |
| CS | `InitSpread` | 190 | `GetSpdTitle` (프레임워크 `SpreadInfo.GetSpdTitle`: COLUMN_NAME, SORT_ORDER_NO) |
| CS | `InitSpread` | 194 | `InitSheet` — `if(spdInfo.SheetName == "Shipment Working Day")` |
| CS | `InitSpread` | 196 | `SetSheetHeaderColumn(spdInfo, 3)` |
| CS | `InitSpread` | 198 | `InitSpreadDateColumn(spdInfo, nIdxDataMain)` |
| CS | `InitSpreadDateColumn` | 263 | `AddComboColumn` (DB 루프, 폭 70, YesOrNo, Center/Center) |
| CS | `InitSpreadDateColumn` | 267 | ForeColor: SAT=Blue, 그 외(SUN)=Red |
| CS | `InitSpreadDateColumn` | 274 / 303 | `ColumnHeaderSpan` row 0 (LARGE_CLASS_LABEL_NAME) |
| CS | `InitSpreadDateColumn` | 280 / 290 / 301 | `ColumnHeaderSpan` row 1 (SMALL_CLASS_LABEL_NAME) |
| CS | `EditButton` | 352 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` |
| CS | `SpdMain_CellDoubleClick` | 840 | `M_` 헤더 → `W_` 컬럼 Visible 반전 |
| CS | `SpdMain_CellDoubleClick` | 843 | `M_` 헤더 → 보이는 `D_` 컬럼 Visible 반전 |
| CS | `SpdMain_CellDoubleClick` | 854 | `W_` 헤더 → `D_` 컬럼 Visible 반전 |
| DS | `InitializeComponent` | 467~470 | 헤더 스타일(HAlign General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VAlign General) |

## 4. 기타 로직 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `FindData_Main` | 387, 388 | `CString.GetCheckedListValue` (CODE) |
| CS | `SaveData_Main` | 502 | `dr["A"]` |
| CS | `SaveData_Main` | 527 | `row["A"]` |
| CS | `SaveData_Main` | 538 | `FPExtensions.GetChanges` (ROW_ID) |
| CS | `CboDayWeek_SelectedIndexChanged` | 660 | `GetCheckedListValue` |
| CS | `CboDayWeek_SelectedIndexChanged` | 663 / 666 | `cboInputValue.Enabled = false / true` |
| CS | `BtnInput_Click` | 682 | `GetCheckedListValue` |
| CS | `GetDayOfWeek` | 827 / 828 | `row.Field("COLUMN_NAME")` / `dr["DAY_CODE"]` |
| CS | `SetChangedPeriod` | 916 / 917 | `dt.Rows[0]["FROM_VALUE"]` / `["TO_VALUE"]` |
| DS | `InitializeComponent` | 501 | `this.Text = "Working Time"` |
