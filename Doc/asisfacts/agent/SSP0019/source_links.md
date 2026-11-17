# SSP0019 소스 링크 표

기준 파일
- CS = `06.UIL\GSCM.SSP.Plan.UIL\SSP0019_ShipmentChangeHistory.cs`
- DS = `06.UIL\GSCM.SSP.Plan.UIL\SSP0019_ShipmentChangeHistory.Designer.cs`

## 1. 엔드포인트 호출 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | FindData_Main | 409 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` (FoxQuery, MATCH) |
| CS | GetDayRange | 522 | `SCP.GET_DATE_RANGE_1MONTH` (FoxQuery statement, MATCH) |
| CS | SetChangedPeriod | 500 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] (Data.CallBizCommonData) |
| CS | (주석) | 523 | 주석 처리됨: `SCP.SCM0001_GET_SCP_DAY_PERIOD` |

## 2. 이벤트 배선
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 139 | `this.Load += Form_Load` |
| CS | InitEvent | 191 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | InitEvent | 192 | `spdMain.CellClick += SpdMain_CellClick` |
| CS | InitEvent | 193 | `this.btnItemId.Click += btnItemId_Click` |
| CS | InitEvent | 194 | `chkCurrent.CheckedChanged += ChkCurrent_CheckedChanged` |
| CS | InitEvent | 196 | `clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged` |
| CS | btnItemId_Click | 231 | `txtItemId.Text = sItemId` |

## 3. 프레임워크 메타 및 DB 컬럼 참조
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangeControl | 163 | Filter["GROUP_ID"], UserInfoContext.Current.NowGroupID |
| CS | SetChangeControl | 164 | Filter["USER_ID"] |
| CS | SetChangeControl | 170 | DataService.GetSSPInnerTable |
| CS | SetChangeControl | 175 | DataService.GetSSPInnerTable |
| CS | SetChangeControl | 180 | DataService.GetSSPInnerTable |
| CS | InitControls | 258 | DataService.FP_Log2 |
| CS | InitControls | 262 | DataService.FP_Log2 |
| CS | InitControls | 273 | c["CODE"] |
| CS | SetChangedControl | 293 | CString.GetCheckedListValue |
| CS | SetChangedControl | 298 | UserInfoContext.Current.NowGroupID |
| CS | SetChangedControl | 303 | UserInfoContext.Current.NowGroupID |
| CS | FindData_Main | 387 | CString.GetCheckedListValue |
| CS | FindData_Main | 388 | CString.GetCheckedListValue |
| CS | FindData_Main | 389 | CString.GetCheckedListValue |
| CS | FindData_Main | 390 | CString.GetCheckedListValue |
| CS | FindData_Main | 396 | CString.GetCheckedListValue |
| CS | SetChangedPeriod | 507 | dt.Rows[0]["FROM_VALUE"] |
| CS | SetChangedPeriod | 508 | dt.Rows[0]["TO_VALUE"] |

## 4. Grid 구성
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 318 | AddSheet(spdMain, SpdSheet.shtMain = "Shipment Change History", 1, 1, 30) |
| CS | CreateSpread | 319 | GetSheetInfo(spdMain.Name, 0) |
| CS | CreateSpread | 321 | ChangeSheet |
| CS | InitSpread | 330 | InitSheet — `if(spdInfo.SheetName == "Shipment Change History")` |
| CS | InitSpread | 332 | SetSheetHeaderColumn(spdInfo, 1) |
| CS | InitSpread | 339 | REQUEST_NO.CellType = cellTypeImage |
| DS | InitializeComponent | 114 | HorizontalAlignment = CellHorizontalAlignment.General |
| DS | InitializeComponent | 115 | NoteIndicatorColor = Color.Red |
| DS | InitializeComponent | 116 | Parent = "ColumnHeaderDefaultEnhanced" |
| DS | InitializeComponent | 117 | VerticalAlignment = CellVerticalAlignment.General |

## 5. 컨트롤 선언 (Designer)
| 파일 | 컨트롤 | 줄 | 유형 |
|---|---|---:|---|
| DS | spdMain | 33 | FarPoint.Win.Spread.FpSpread |
| DS | spdMain_Sheet1 | 34 | SheetView |
| DS | usrLayoutControl1 | 35 | UsrLayoutControl |
| DS | txtConfirmId | 36 | UsrMultiLineEditor |
| DS | chkCurrent | 37 | UsrCheckBox |
| DS | clbTransportMode | 38 | UsrCheckedList |
| DS | clbIncomterms | 39 | UsrCheckedList |
| DS | clbFromSite | 40 | UsrCheckedList |
| DS | txtSoNo | 41 | UsrMultiLineEditor |
| DS | drpPeriod | 42 | UsrDateRangePicker |
| DS | btnItemId | 43 | UsrButton |
| DS | clbToSite | 44 | UsrCheckedList |
| DS | txtItemId | 45 | UsrMultiLineEditor |
| DS | clbDivision | 46 | UsrCheckedList |
| DS | splitter1 | 63 | Splitter |
| DS | usrConditionPanel1 | 64 | UsrConditionPanel |
