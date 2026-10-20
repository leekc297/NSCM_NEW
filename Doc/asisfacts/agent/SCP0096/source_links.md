# SCP0096 — 소스 링크 표

경로 기준 루트: `06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/`
- **CS** = `SCP0096_Shipment_Working_Day_OSP.cs`
- **DS** = `SCP0096_Shipment_Working_Day_OSP.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L49) | `<field:dtDayWeek>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon] — Data.Common(LookupCommon) > Data.CallBizCommonData |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L51) | `<field:dtValidYN>` | 51 | `biz:CommonData.YesOrNo` — Data.Common(YesOrNo) > Data.CallBizData |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L394) | GetBucketType | 394 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L456) | FindData_Main | 456 | `SCP.SCP0019_GET_WORKING_TIME` — **주석 처리됨** |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L457) | FindData_Main | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L831) | GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L103) | .ctor | 103 | this.Load += Form_Load |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L249) | InitEvent | 249 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L250) | InitEvent | 250 | spdMain.TopChange += SpdMain_TopChange |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L251) | InitEvent | 251 | cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L252) | InitEvent | 252 | clbPlantSite.SelectedIndexChanged += ClbPlantSite_SelectedIndexChanged |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L253) | InitEvent | 253 | cboDayWeek.SelectedIndexChanged += CboDayWeek_SelectedIndexChanged |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L254) | InitEvent | 254 | btnInput.Click += BtnInput_Click |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L255) | InitEvent | 255 | this.chkSum.CheckedChanged += chkSum_CheckedChanged |

## 3. Grid 구성 코드

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L142) | CreateSpread | 142 | AddSheet(spdMain, SpdSheet.shtMain, …, 3, 1, 35) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L143) | CreateSpread | 143 | GetSheetInfo(spdMain.Name, 0) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L144) | CreateSpread | 144 | ChangeSheet |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L151) | InitSpread | 151 | GetSpdTitle (SpreadInfo.GetSpdTitle — COLUMN_NAME, SORT_ORDER_NO) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L155) | InitSpread | 155 | InitSheet(SpdSheet.shtMain) — if(SheetName == "Shipment Working Day OSP") |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L156) | InitSpread | 156 | SetSheetHeaderColumn(siMain, 3) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L159) | InitSpread | 159 | InitSpreadDateColumn(spdInfo, nIdxDataMain = MEASURE+1) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L160) | InitSpread | 160 | SetSpreadColumn(siMain) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L196) | InitSpreadDateColumn | 196 | `B_` 포함 → AddTextColumn(너비 0, 숨김) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L203) | InitSpreadDateColumn | 203 | 그 외 → AddComboColumn(너비 50, dtValidYN, Center) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L208) | InitSpreadDateColumn | 208 | SAT=Blue / SUN=Red ForeColor |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L215) | InitSpreadDateColumn | 215~244 | ColumnHeaderSpan (Large/Small class, "SUM") |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L288) | EditButton | 288 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L311) | cboBucketType_SelectedIndexChanged | 311, 316 | SetSpreadColumn (배선 없음) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L330) | chkSum_CheckedChanged | 330, 335 | SetSpreadColumn |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L350) | SetSpreadColumn | 350 | D_/W_ → Visible = true |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L355) | SetSpreadColumn | 355 | M_/W_ → Visible = chkSum.Checked |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L484) | FindData_Main | 484 | if(GetMaxRowIndex() > 0) SetSpreadColumn |
| [DS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs#L628) | InitializeComponent | 628~631 | ColumnHeaderDefaultEnhanced 스타일(General 정렬, NoteIndicatorColor Red) |

## 4. 데이터·컨트롤 처리

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L121) | DefineProperty | 121 | chkSum.Checked = false |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L417) | SetChangedControl | 417, 425 | GetCheckedListValue |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L442) | FindData_Main | 442, 443 | GetCheckedListValue (조회 파라미터) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L558) | SaveData_Main | 558~581 | dr["A"], p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L600) | SaveData_Main | 600 | row["A"] |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L609) | SaveData_Main | 609 | GetChanges (FPExtensions — ROW_ID) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L672) | CboDayWeek_SelectedIndexChanged | 672 | GetCheckedListValue |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L675) | CboDayWeek_SelectedIndexChanged | 675, 679 | cboInputValue.Enabled = false / true |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L695) | BtnInput_Click | 695, 696 | GetCheckedListValue |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L815) | GetDayOfWeek | 815, 816 | row.Field("COLUMN_NAME"), dr["DAY_CODE"] |
| [DS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs#L663) | InitializeComponent | 663 | this.Text = "Shipment Working Day OSP" |
