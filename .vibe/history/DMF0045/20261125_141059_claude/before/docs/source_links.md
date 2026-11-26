# DMF0045 소스 링크 표

> 기준 경로
> - CS = `06.UIL\GSCM.DM.Plan.UIL\DMF0045_ShipmentRequest.cs`
> - DS = `06.UIL\GSCM.DM.Plan.UIL\DMF0045_ShipmentRequest.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체 13건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | InitControls | 200 | `biz:CommonData.CommonDataList` [code=MyDivision] (Data.Common → Data.CallBizCommonData) |
| CS | InitControls | 231 | `biz:CommonData.CommonDataList` [code=Measure] |
| CS | FindData | 579 | `biz:CommonData.CommonDataList` [code=Measure] |
| CS | FindData | 609 | `DM.DMF0045_GET_SHIPMENT_REQUEST` → SP DMF0045_GET_SHIPMENT_REQUEST |
| CS | SaveData | 896 | `DM.DMF0045_SAVE_SHIPMENT_REQUEST` → SP DMF0045_SAVE_SHIPMENT_REQUEST |
| CS | InsertRow | 1001 | `biz:CommonData.CommonDataList` [code=FCST_TYPE] |
| CS | InsertRow | 1004 | `biz:CommonData.CommonDataList` [code=Measure] |
| CS | spdMain_ComboSelChange | 1194 | `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure] |
| CS | spdMain_Changed | 1749 | `biz:CommonData.CommonDataList` [code=DefaultBucketDay] |
| CS | spdMain_Changed | 1811 | `biz:CommonData.CommonDataList` [code=DefaultBucketDay] |
| CS | GetSpdTitle | 2249 | `DM.DMF0045_GET_SPREAD_TITLE` → SP DMF0045_GET_SPREAD_TITLE |
| CS | GetBucketType | 2266 | `DM.DM0003_GET_BUCKET_TYPE_CODE` → SP DM0003_GET_BUCKET_TYPE_CODE |
| CS | GetBizTypebyDivision | 2278 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` → SP SCM0001_GET_BIZ_TYPE_BY_DIVISION (진입점 미연결) |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 165 | `this.Load += Form_Load` |
| CS | InitEvent | 391 | `dsdmPack.Changed += spdMain_Changed` |
| CS | InitEvent | 394 | `dsdmCell.Changed += spdMain_Changed` |
| DS | InitializeComponent | 208 | `btnMeasure.Click += btnMeasure_Click` |
| DS | InitializeComponent | 243 | `cboDivision.SelectedIndexChanged += cboDivision_SelectedIndexChanged` |
| DS | InitializeComponent | 280 | `chkSum.CheckedChanged += chkSum_CheckedChanged` |
| DS | InitializeComponent | 357 | `btnColumn.Click += btnColumn_Click` |
| DS | InitializeComponent | 393 | `btnProject.Click += btnProject_Click` |
| DS | InitializeComponent | 463 | `btnItemId.Click += btnItemId_Click` |
| DS | InitializeComponent | 500 | `cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged` |
| DS | InitializeComponent | 655 | `clbCustomer.SelectedIndexChanged += clbCustomer_SelectedIndexChanged` |
| DS | InitializeComponent | 695 | `clbTeam.SelectedIndexChanged += clbTeam_SelectedIndexChanged` |
| DS | InitializeComponent | 980 | `spdMain.CellDoubleClick += spdMain_CellDoubleClick` |
| DS | InitializeComponent | 981 | `spdMain.ComboSelChange += spdMain_ComboSelChange` |
| DS | InitializeComponent | 982 | `spdMain.TopChange += spdMain_TopChange` |
| DS | InitializeComponent | 983 | `spdMain.KeyUp += spdMain_KeyUp` |

## 3. Grid 구성 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 255 | `AddSheet` Pack Biz (헤더 3행, 1, 40) |
| CS | CreateSpread | 256 | `GetSheetInfo` Pack Biz |
| CS | CreateSpread | 257 | `ChangeSheet` Pack Biz |
| CS | CreateSpread | 260 | `AddSheet` Cell Biz (헤더 3행, 1, 40) |
| CS | CreateSpread | 261 | `GetSheetInfo` Cell Biz |
| CS | CreateSpread | 262 | `ChangeSheet` Cell Biz |
| CS | CreateSpread | 265 | `ChangeSheet` Pack Biz |
| CS | InitSpread | 271 | `GetSpdTitle` (SpreadInfo.GetSpdTitle — COLUMN_NAME, SORT_ORDER_NO) |
| CS | InitSpread | 272 | `CreateSheetHeaderColumn(siMain, 3, dtTitle)` |
| CS | InitSpread | 276 | `SetSpreadHeaderSpan(dtTitle)` |
| CS | InitSpread | 277 | `SetSpreadColumn()` |
| CS | InitSpreadFooterSum | 285 | `ColumnFooter.Visible = true` |
| CS | SetSpreadHeaderSpan | 327~381 | 대·소분류 ColumnHeaderSpan, `SUM` 헤더, `B_` 컬럼 숨김(335), SAT/SUN 색상(346) |
| CS | EditButton | 443 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` |
| CS | FindData | 652 | `SetSpreadColumn()` (조회 결과 행이 있을 때) |
| CS | Set_SumValues | 734 | `dsBinding.Tables[0].Columns["MEASURE"]` |
| CS | SaveData | 807 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` |
| CS | InsertRow | 1003 | `SetCellTypeCombo` FCST_TYPE |
| CS | InsertRow | 1005 | `SetCellTypeCombo` MEASURE |
| CS | cboBucketType_SelectedIndexChanged | 1136 | `SetSpreadColumn()` |
| CS | spdMain_ComboSelChange | 1158 | `SetCellTypeCombo` FROM_SITE (Data.UserSiteByEndCustomer / UserSiteByEndCustomerAuth) |
| CS | spdMain_ComboSelChange | 1195 | `SetCellTypeCombo` MEASURE |
| CS | spdMain_CellDoubleClick | 1211, 1217, 1233 | M_/W_/D_ 컬럼 Visible 토글 |
| CS | chkSum_CheckedChanged | 2136 | `SetSpreadColumn()` |
| CS | SetSpreadColumn | 2152~2184 | DAILY/WEEKLY/MONTHLY별 D_/W_/M_ Visible |
| DS | InitializeComponent | 999~1002 | ColumnHeader 기본 스타일(HorizontalAlignment, NoteIndicatorColor, Parent, VerticalAlignment) |

## 4. 메타·사용자 컨텍스트 참조 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | OnShown | 181, 183 | BaseForm.OnShown(NowGroupID, USER_ID), GetCheckedListValue |
| CS | InitControls | 200, 209, 210, 214, 219, 222 | `UserInfoContext.Current["NowGroupID"]` |
| CS | InitControls | 203 | `dtDivision.Rows[i]["CODE"]` |
| CS | InitControls | 207, 213, 217 | GetCheckedListValue |
| CS | FindData | 584 | GetCheckedListValue |
| CS | InsertRow | 1000 | NowGroupID |
| CS | cboDivision_SelectedIndexChanged | 1086, 1097, 1102 | GetCheckedListValue |
| CS | cboDivision_SelectedIndexChanged | 1094, 1099, 1104, 1107 | NowGroupID |
| CS | clbTeam_SelectedIndexChanged | 1116, 1120 | NowGroupID |
| CS | clbCustomer_SelectedIndexChanged | 1128 | NowGroupID |
| CS | spdMain_ComboSelChange | 1157 | NowGroupID |
| CS | SaveButton | 569 | SaveData 호출 (4-2표는 PersonalSettingPopup.SaveData로 해석함 — 확인 필요) |
| CS | btnProject_Click | 2093 | `txtProject.Text = sProjectCode` |
| CS | btnItemId_Click | 2116 | `txtItemId.Text = sItemId` |

## 5. 주석 처리된 호출
- 0건(commented_calls.csv 비어 있음).
