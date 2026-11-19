# SCP0111 소스 링크 표

기준 파일 약어:
- **CS** = `06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.cs`
- **DS** = `06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.Designer.cs`

## 1. 엔드포인트 호출 지점 (16건, 전부)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtPeriod>` | 66 | `biz:CommonData.CommonDataList` [code=LookupCommon] (진입점 미연결) |
| CS | SetChangedPeriod | 287 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | SetChangedPeriod | 288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | SetCalendar | 345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | GetEssPackLineAll | 490 | `SCP.SCP0111_GET_ESS_PACK_LINE` |
| CS | EditButton | 554 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | EditButton | 622 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| CS | FindData_Main | 874 | `SCP.SCP0111_GET_INTEGRATION_PSI` |
| CS | GetBucketType | 1095 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| CS | SaveData | 1154 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | SaveData | 1205 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| CS | SaveData | 1242 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | SaveData | 1379 | `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` |
| CS | SaveData | 1511 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | SaveData | 1637 | `SCP.SCP0111_SAVE_INTEGRATION_PSI` |
| CS | _defaultDataModel_Changed | 1980 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 167 | `this.Load += Form_Load` |
| CS | InitEvent | 360 | `btnNickName.Click += BtnNickName_Click` |
| CS | InitEvent | 362 | `btnItemId.Click += BtnItemId_Click` |
| CS | InitEvent | 363 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| CS | InitEvent | 364 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | InitEvent | 365 | `spdMain.CellClick += spdMain_CellClick` |
| CS | InitEvent | 367 | `cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged` |
| CS | InitEvent | 368 | `cboPlanDate.SelectedIndexChanged += CboPlanDate_SelectedIndexChanged` |
| CS | InitEvent | 369 | `cboPlanType.SelectedIndexChanged += CboPlanType_SelectedIndexChanged` |
| CS | InitEvent | 374 | `_defaultDataModel.Changed += _defaultDataModel_Changed` |

## 3. Grid 구성 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 299 | `AddSheet(spdMain, "Integration PSI", "Integration PSI", 1, 1, 35)` |
| CS | CreateSpread | 300 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)` |
| CS | CreateSpread | 301 | `ChangeSheet` |
| CS | InitSpread | 312 | `InitSheet("Integration PSI")` |
| CS | InitSpread | 333 | `SetSheetHeaderColumn(spdInfo, 1)` (메타) |
| CS | InitSpread | 336 | `SetSpreadColumn(siMain)` (화면 로컬) |
| CS | SetCalendar | 354 | `AddNumColumn(YYYYMM_NAME, YYYYMM, FPMerge.None, 75, true)` — dtCalendar 루프 |
| CS | SetSpreadColumn | 392 | Tag `D_` 또는 `W_` → Visible=false |
| CS | SetSpreadColumn | 396 | Tag `M_` → Visible=true |
| CS | EditButton | 545 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` |
| CS | SetVisibleSheetColumns | 1069 / 1070 / 1072 / 1073 | IsEditMode: SEQ_FLAG 60 / MEASURE 80 / PLANT_ID 65 / TO_SITE 75 표시 |
| CS | SetVisibleSheetColumns | 1078 / 1079 / 1081 / 1082 | 조회 모드: SEQ_FLAG 0 숨김 / MEASURE 0 숨김 / PLANT_ID 0 / TO_SITE 0 |
| DS | InitializeComponent | 858~861 | 헤더 기본 스타일(HorizontalAlignment, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced, VerticalAlignment) |

## 4. 데이터·메타 컬럼 읽기 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangedPeriod | 249, 250 | `GetCheckedListValue` (CODE) |
| CS | SetChangedPeriod | 258 | `dtPeriod.Rows[0]["CODE"]` |
| CS | SetChangedPeriod | 273 | `dtScpPlanPeriod.Rows[0]["HORIZON_END_DATE"]` |
| CS | SetChangedPeriod | 290, 291 | `UsrComboBox.DataBind` (CODE, NAME) |
| CS | RefreshPlanDate | 403 | `GetCheckedListValue` |
| CS | RefreshPlanDate | 418, 422 | `dtPlanTypeFN.Rows[i]["PLANDATE"]` |
| CS | RefreshPlanType | 438, 439 | `GetCheckedListValue` |
| CS | RefreshPlanSeq | 448, 449, 450 | `GetCheckedListValue` |
| CS | EditButton | 559 | `FoxUserInfoContext.Current.NowGroupID` |
| CS | EditButton | 629 | `dtMultiChildItem.Rows[i]["NAME"]` |
| CS | SaveButton | 816 | `SaveData` 호출(Fact Pack이 PersonalSettingPopup.SaveData로 해석 — 확인 필요) |
| CS | InsertRow | 960 | `FoxUserInfoContext.Current.NowGroupID` |
| CS | SaveData | 1159 | `FoxUserInfoContext.Current.NowGroupID` |
| CS | SaveData | 1213 | `dtTemp.Rows[0]["CODE"]` |
| CS | SaveData | 1247, 1516 | `dtToMonth.Rows[k]["CODE"]` |
| CS | SaveData | 1298, 1332, 1587 | `dtMonth.Rows[k]["CODE"]` |
| CS | spdMain_CellClick | 1781 | `dtLine.Rows[i]` NAME, CODE |
| CS | spdMain_CellClick | 1785, 1786 | `drLine` CODE, NAME |
| CS | BtnNickName_Click | 1887 | `txtNickName.Text = sNickName` |
| CS | BtnItemId_Click | 1926 | `txtItemId.Text = sItemId` |
| CS | OnShown | 1932 | `BaseForm.OnShown` (NowGroupID, USER_ID) |
