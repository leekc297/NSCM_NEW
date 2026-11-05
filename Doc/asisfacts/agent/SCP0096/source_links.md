# SCP0096 — 소스 링크 표

> 기준 경로(AS-IS 소스 루트)는 Fact Pack에 없으므로 상대 경로로 표기했습니다. 루트 경로는 확인 필요입니다.
> - `CS` = `06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs`
> - `DS` = `06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs`

## 1. 엔드포인트 호출 지점 (전수)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS:49](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L49) | `<field:dtDayWeek>` | 49 | biz:CommonData.CommonDataList [code=LookupCommon] (BIZ_MATCH, 진입점 미연결) |
| [CS:51](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L51) | `<field:dtValidYN>` | 51 | biz:CommonData.YesOrNo (BIZ_MATCH, 진입점 미연결) |
| [CS:394](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L394) | GetBucketType | 394 | DM.DM0003_GET_BUCKET_TYPE_CODE (MATCH) |
| [CS:457](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L457) | FindData_Main | 457 | SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (MATCH) |
| [CS:831](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L831) | GetSpdTitle | 831 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (MATCH) |
| [CS:456](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L456) | (FindData_Main 인접) | 456 | SCP.SCP0019_GET_WORKING_TIME — **주석 처리됨** |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS:103](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L103) | .ctor | 103 | this.Load += Form_Load |
| [CS:249](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L249) | InitEvent | 249 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| [CS:250](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L250) | InitEvent | 250 | spdMain.TopChange += SpdMain_TopChange |
| [CS:251](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L251) | InitEvent | 251 | cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged |
| [CS:252](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L252) | InitEvent | 252 | clbPlantSite.SelectedIndexChanged += ClbPlantSite_SelectedIndexChanged |
| [CS:253](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L253) | InitEvent | 253 | cboDayWeek.SelectedIndexChanged += CboDayWeek_SelectedIndexChanged |
| [CS:254](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L254) | InitEvent | 254 | btnInput.Click += BtnInput_Click |
| [CS:255](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L255) | InitEvent | 255 | this.chkSum.CheckedChanged += chkSum_CheckedChanged |

## 3. Grid 구성 코드

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS:142](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L142) | CreateSpread | 142 | AddSheet(spdMain, SpdSheet.shtMain, …, 3, 1, 35) |
| [CS:143](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L143) | CreateSpread | 143 | GetSheetInfo(spdMain.Name, 0) |
| [CS:144](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L144) | CreateSpread | 144 | ChangeSheet |
| [CS:151](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L151) | InitSpread | 151 | GetSpdTitle (SpreadInfo.GetSpdTitle) |
| [CS:155](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L155) | InitSpread | 155 | InitSheet(SpdSheet.shtMain) |
| [CS:156](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L156) | InitSpread | 156 | SetSheetHeaderColumn(siMain, 3) |
| [CS:159](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L159) | InitSpread | 159 | InitSpreadDateColumn(spdInfo, nIdxDataMain) |
| [CS:160](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L160) | InitSpread | 160 | SetSpreadColumn(siMain) |
| [CS:196](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L196) | InitSpreadDateColumn | 196 | AddTextColumn — "B_" 컬럼, 폭 0, 숨김 |
| [CS:203](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L203) | InitSpreadDateColumn | 203 | AddComboColumn — 폭 50, dtValidYN, Center |
| [CS:208](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L208) | InitSpreadDateColumn | 208 | SAT=Blue / SUN=Red ForeColor |
| [CS:215](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L215) | InitSpreadDateColumn | 215~244 | ColumnHeaderSpan (Large/Small/"SUM") |
| [CS:288](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L288) | EditButton | 288 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| [CS:311](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L311) | cboBucketType_SelectedIndexChanged | 311, 316 | SetSpreadColumn (배선 없음) |
| [CS:330](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L330) | chkSum_CheckedChanged | 330, 335 | SetSpreadColumn |
| [CS:350](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L350) | SetSpreadColumn | 350 | D_/W_ → Visible=true |
| [CS:355](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L355) | SetSpreadColumn | 355 | M_/W_ → Visible=chkSum.Checked |
| [CS:484](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L484) | FindData_Main | 484 | 조회 행이 있으면 SetSpreadColumn |
| [DS:628](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs#L628) | InitializeComponent | 628~631 | 헤더 스타일(General, NoteIndicatorColor Red, ColumnHeaderDefaultEnhanced) |

## 4. 컨트롤 값과 데이터 처리

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS:121](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L121) | DefineProperty | 121 | chkSum.Checked = false |
| [CS:417](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L417) | SetChangedControl | 417, 425 | GetCheckedListValue |
| [CS:442](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L442) | FindData_Main | 442, 443 | GetCheckedListValue |
| [CS:558](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L558) | SaveData_Main | 558~581 | dr["A"], p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default |
| [CS:600](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L600) | SaveData_Main | 600 | row["A"] |
| [CS:609](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L609) | SaveData_Main | 609 | GetChanges (ROW_ID) |
| [CS:672](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L672) | CboDayWeek_SelectedIndexChanged | 672 | GetCheckedListValue |
| [CS:675](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L675) | CboDayWeek_SelectedIndexChanged | 675 / 679 | cboInputValue.Enabled = false / true |
| [CS:695](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L695) | BtnInput_Click | 695, 696 | GetCheckedListValue |
| [CS:815](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L815) | GetDayOfWeek | 815, 816 | COLUMN_NAME, DAY_CODE |
| [DS:346](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs#L346) | InitializeComponent | 346 | chkSum.Visible = false |
| [DS:663](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs#L663) | InitializeComponent | 663 | this.Text = "Shipment Working Day OSP" |
