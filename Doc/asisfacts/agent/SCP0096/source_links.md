# SCP0096 소스 링크

기준 경로: `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\`
- CS = `SCP0096_Shipment_Working_Day_OSP.cs`
- DS = `SCP0096_Shipment_Working_Day_OSP.Designer.cs`

## 1. 엔드포인트 호출 지점 (전수 6건 + 주석 1건)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtDayWeek>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon]. Data.Common(LookupCommon) > CallBizCommonData |
| CS | `<field:dtValidYN>` | 51 | `biz:CommonData.YesOrNo`. Data.Common(YesOrNo) > CallBizData |
| CS | GetBucketType | 394 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| CS | FindData_Main | 456 | (주석 처리됨) `SCP.SCP0019_GET_WORKING_TIME` |
| CS | FindData_Main | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| CS | SaveData_Main | 608 | `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` |
| CS | GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |

## 2. 이벤트 배선
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 103 | this.Load += Form_Load |
| CS | InitEvent | 249 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| CS | InitEvent | 250 | spdMain.TopChange += SpdMain_TopChange |
| CS | InitEvent | 251 | cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged |
| CS | InitEvent | 252 | clbPlantSite.SelectedIndexChanged += ClbPlantSite_SelectedIndexChanged |
| CS | InitEvent | 253 | cboDayWeek.SelectedIndexChanged += CboDayWeek_SelectedIndexChanged |
| CS | InitEvent | 254 | btnInput.Click += BtnInput_Click |
| CS | InitEvent | 255 | this.chkSum.CheckedChanged += chkSum_CheckedChanged |

## 3. Grid 구성
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 142 | AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) |
| CS | CreateSpread | 143–144 | GetSheetInfo(spdMain.Name, 0) / ChangeSheet |
| CS | InitSpread | 151 | GetSpdTitle (SCP0009) |
| CS | InitSpread | 155 | InitSheet(SpdSheet.shtMain) |
| CS | InitSpread | 156 | SetSheetHeaderColumn(siMain, 3) |
| CS | InitSpread | 159 | InitSpreadDateColumn(spdInfo, nIdxDataMain) |
| CS | InitSpread | 160 | SetSpreadColumn(siMain) |
| CS | InitSpreadDateColumn | 196 | AddTextColumn(B_ 컬럼, 폭 0, 숨김) |
| CS | InitSpreadDateColumn | 203 | AddComboColumn(폭 50, dtValidYN, Center/Center) |
| CS | InitSpreadDateColumn | 208 | 토/일 ForeColor(SAT Blue, 그 외 Red) |
| CS | InitSpreadDateColumn | 215–244 | ColumnHeaderSpan(Large/Small/"SUM") |
| CS | EditButton | 288 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| CS | cboBucketType_SelectedIndexChanged | 311, 316 | SetSpreadColumn(siMain) |
| CS | chkSum_CheckedChanged | 330, 335 | SetSpreadColumn(siMain) |
| CS | SetSpreadColumn | 350 | D_/W_ 컬럼 Visible = true |
| CS | SetSpreadColumn | 355 | M_/W_ 컬럼 Visible = chkSum.Checked |
| CS | FindData_Main | 484 | 조회 결과가 1행을 넘으면 SetSpreadColumn |
| DS | InitializeComponent | 628–631 | 헤더 스타일(General 정렬, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |

## 4. 컨트롤 값과 속성
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | DefineProperty | 121 | chkSum.Checked = false |
| CS | SetChangedControl | 417, 425 | GetCheckedListValue |
| CS | FindData_Main | 442, 443 | GetCheckedListValue |
| CS | CboDayWeek_SelectedIndexChanged | 672 | GetCheckedListValue |
| CS | CboDayWeek_SelectedIndexChanged | 675 / 679 | cboInputValue.Enabled = false / true |
| CS | BtnInput_Click | 695, 696 | GetCheckedListValue |
| CS | SaveData_Main | 558–581 | dr["A"], p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default |
| CS | SaveData_Main | 600 | row["A"] |
| CS | SaveData_Main | 609 | GetChanges(ROW_ID) |
| CS | GetDayOfWeek | 815, 816 | row.Field("COLUMN_NAME"), dr["DAY_CODE"] |
| DS | InitializeComponent | 346 | chkSum.Visible = false |
