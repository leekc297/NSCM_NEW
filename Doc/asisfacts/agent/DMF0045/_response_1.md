=== FILE: analysis.md ===
# DMF0045 ShipmentRequest — AS-IS 분석서

> 근거: AsisFacts 정적 추출 Fact Pack(DMF0045). Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | DMF0045 |
| 클래스 | `DMF0045_ShipmentRequest` |
| 폼 Text | `ShipmentRequest` (Designer.cs:1039) |
| 도메인 | DM (프로젝트 `GSCM.DM.Plan.UIL`, FoxQuery 그룹 `DM.*`, 1건은 `SCM.*`) |
| 업무 개요 | 업무 정의 문서는 Fact Pack에 없음 → **확인 필요**. 저장 SP가 `DM_PLN_SHIPMENT_REQ` / `DM_PLN_SHIPMENT_REQ_H`에 INSERT한다는 사실만 확인됨 |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only(현행) | 06.UIL\GSCM.DM.Plan.UIL\DMF0045_ShipmentRequest.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 2305 |
| only(현행) | 06.UIL\GSCM.DM.Plan.UIL\DMF0045_ShipmentRequest.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1129 |
| shared | 없음(Fact Pack 기준) | — | — |
| legacy | 없음(Fact Pack 기준) | — | — |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| Form Load(`this.Load`) | Form_Load > InitControls | 200 | `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH | — |
| Form Load | Form_Load > InitControls | 231 | `biz:CommonData.CommonDataList` [code=Measure] | BIZ_MATCH | — |
| Form Load | Form_Load > InitControls > GetBucketType | 2266 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | DM0003_GET_BUCKET_TYPE_CODE |
| Form Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2249 | `DM.DMF0045_GET_SPREAD_TITLE` | MATCH | DMF0045_GET_SPREAD_TITLE |
| 조회(FindButton) | FindButton > FindData | 579 | `biz:CommonData.CommonDataList` [code=Measure] | BIZ_MATCH | — |
| 조회(FindButton) | FindButton > FindData | 609 | `DM.DMF0045_GET_SHIPMENT_REQUEST` | MATCH | DMF0045_GET_SHIPMENT_REQUEST |
| 조회(FindButton) | FindButton > FindData > InitSpread > GetSpdTitle | 2249 | `DM.DMF0045_GET_SPREAD_TITLE` | MATCH | DMF0045_GET_SPREAD_TITLE |
| 행추가(InsertButton) | InsertButton > InsertRow | 1001 | `biz:CommonData.CommonDataList` [code=FCST_TYPE] | BIZ_MATCH | — |
| 행추가(InsertButton) | InsertButton > InsertRow | 1004 | `biz:CommonData.CommonDataList` [code=Measure] | BIZ_MATCH | — |
| 저장(SaveButton) | SaveButton > SaveData | 896 | `DM.DMF0045_SAVE_SHIPMENT_REQUEST` | MATCH | DMF0045_SAVE_SHIPMENT_REQUEST |
| 저장(SaveButton) | SaveButton > SaveData > FindData | 579 | `biz:CommonData.CommonDataList` [code=Measure] | BIZ_MATCH | — |
| 저장(SaveButton) | SaveButton > SaveData > FindData | 609 | `DM.DMF0045_GET_SHIPMENT_REQUEST` | MATCH | DMF0045_GET_SHIPMENT_REQUEST |
| 저장(SaveButton) | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 2249 | `DM.DMF0045_GET_SPREAD_TITLE` | MATCH | DMF0045_GET_SPREAD_TITLE |
| `btnMeasure_Click` | btnMeasure_Click > InitSpread > GetSpdTitle | 2249 | `DM.DMF0045_GET_SPREAD_TITLE` | MATCH | DMF0045_GET_SPREAD_TITLE |
| `btnColumn_Click` | btnColumn_Click > InitSpread > GetSpdTitle | 2249 | `DM.DMF0045_GET_SPREAD_TITLE` | MATCH | DMF0045_GET_SPREAD_TITLE |
| `cboDivision_SelectedIndexChanged` | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2249 | `DM.DMF0045_GET_SPREAD_TITLE` | MATCH | DMF0045_GET_SPREAD_TITLE |
| `spdMain_ComboSelChange` | spdMain_ComboSelChange | 1194 | `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure] | BIZ_MATCH | — |
| `spdMain_Changed` (dsdmPack/dsdmCell.Changed) | spdMain_Changed | 1749 | `biz:CommonData.CommonDataList` [code=DefaultBucketDay] | BIZ_MATCH | — |
| `spdMain_Changed` (dsdmPack/dsdmCell.Changed) | spdMain_Changed | 1811 | `biz:CommonData.CommonDataList` [code=DefaultBucketDay] | BIZ_MATCH | — |
| (진입점 미연결) | GetBizTypebyDivision | 2278 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | MATCH | SCM0001_GET_BIZ_TYPE_BY_DIVISION |

- 저장 흐름은 `SaveData`가 저장 SP를 호출한 뒤 `FindData`로 재조회하는 구조입니다(경로 `SaveButton > SaveData > FindData`).
- `GetBizTypebyDivision`(2278)은 정적 분석상 **어떤 진입점에서도 도달하지 않습니다**(unreached). 그래서 런타임에 쓰이는지는 **확인 필요**입니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 테이블/객체(요약) |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH | 1 | (코드분기) UP_FX_GetCommonDataList | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION |
| `biz:CommonData.CommonDataList` [code=Measure] | BIZ_MATCH | 3 | (코드분기) UP_FX_GetCommonDataList | SCM_MST_SHEET_MEASURE, DM_MST_CUSTOMER_FCST |
| `biz:CommonData.CommonDataList` [code=FCST_TYPE] | BIZ_MATCH | 1 | (코드분기) UP_FX_GetCommonDataList, UP_FX_GETCOMMONDATALIST_DM | SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure] | BIZ_MATCH | 1 | (코드분기) UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, DM_MST_CUSTOMER_FCST |
| `biz:CommonData.CommonDataList` [code=DefaultBucketDay] | BIZ_MATCH | 2 | (코드분기) UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL |
| `DM.DMF0045_GET_SHIPMENT_REQUEST` | MATCH | 1 | DMF0045_GET_SHIPMENT_REQUEST | TB_FX_USER, SCM_MST_TITLESET_USER(SELECT/INSERT), SCM_MST_SHEET_MEASURE, DM_PLN_SHIPMENT_REQ, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_SSO_DEPT_INFO, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_PLAN_VERSION_V, SCP_MST_BOD_N_V, SCP_PLN_SHIPMENT_PLAN_PEGGING, SCP_PLN_SHIPMENT_PLAN, SCM_SYS_CALENDAR_M, SCP_MST_BOD_V, DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SCM_DNM_CELL_INHOUSE_PLAN_SN, SSP_DNM_FP_PLAN_FROZEN, SCP_ANL_PRODUCTION_PLAN, SSP_DNM_STOCK_C, SCM_MST_LOCATION, SCP_MST_FINAL_ITEM, SSP_DNM_ESS_PACKER_STOCK_V. 함수 FN_GET_SSP_ETD_DATE, FN_NEXT_DAY, STRING_SPLIT. 동적 SQL(DYNAMIC@). 임시테이블 다수 |
| `DM.DMF0045_SAVE_SHIPMENT_REQUEST` | MATCH | 1 | DMF0045_SAVE_SHIPMENT_REQUEST | SCP_MST_BOD, SCP_MST_DISTRIBUTION_ROUTE, DM_PLN_SHIPMENT_REQ(SELECT/INSERT), DM_PLN_SHIPMENT_REQ_H(INSERT), SCM_SYS_LOG_BATCH(INSERT). EXEC PR_SCM_SYS_LOG_BATCH. 함수 SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| `DM.DMF0045_GET_SPREAD_TITLE` | MATCH | 1 | DMF0045_GET_SPREAD_TITLE | SCM_MST_SHEET_COLUMNS, SCM_SYS_CALENDAR_M, STRING_SPLIT |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | MATCH | 1 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | SCM_MST_PROJECT, REF:VALUE, REF:NODES |

### 3-1. 엔드포인트 목록에 없는 데이터 호출(확인 필요)
- `spdMain_ComboSelChange`:1158 — `Data.UserSiteByEndCustomer(...)` / `Data.UserSiteByEndCustomerAuth(...)`의 결과를 FROM_SITE 콤보에 넣습니다. 어떤 엔드포인트·SP를 쓰는지는 Fact Pack에 없음 → **확인 필요**
- `InsertRow`:1005, `spdMain_ComboSelChange`:1195 — MEASURE 콤보 데이터 소스 후보가 `Data.Common(Data.Type.Measure)` / `Data.Common(Data.Type.Measure, false, "DMF0045", 시트명)` / `Data.Common(Data.Type.MktFcstEditMeasure, ...)` 3가지로 추출되었습니다. 실제로 어느 분기를 타는지는 **확인 필요**

## 4. 이벤트 배선 표

| 대상 | 이벤트 | 핸들러 | 배선 위치 | 핸들러에서 확인된 동작(Fact Pack) |
|---|---|---|---|---|
| this.btnMeasure | Click | `btnMeasure_Click` | Designer InitializeComponent:208 | InitSpread > GetSpdTitle → `DM.DMF0045_GET_SPREAD_TITLE` |
| this.cboDivision | SelectedIndexChanged | `cboDivision_SelectedIndexChanged` | Designer:243 | NowGroupID 읽기(1094/1099/1104/1107), GetCheckedListValue(1086/1097/1102), InitSpread > GetSpdTitle |
| this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | Designer:280 | `SetSpreadColumn` 호출(2136, `siMain != null`일 때) |
| this.btnColumn | Click | `btnColumn_Click` | Designer:357 | InitSpread > GetSpdTitle. 버튼은 `Visible=false`(Designer:356) |
| this.btnProject | Click | `btnProject_Click` | Designer:393 | `txtProject.Text = sProjectCode`(2093). 팝업 여부는 **확인 필요** |
| this.btnItemId | Click | `btnItemId_Click` | Designer:463 | `txtItemId.Text = sItemId`(2116). 팝업 여부는 **확인 필요** |
| this.cboBucketType | SelectedIndexChanged | `cboBucketType_SelectedIndexChanged` | Designer:500 | `SetSpreadColumn` 호출(1136) |
| this.clbCustomer | SelectedIndexChanged | `clbCustomer_SelectedIndexChanged` | Designer:655 | NowGroupID 읽기(1128). 이후 동작은 **확인 필요** |
| this.clbTeam | SelectedIndexChanged | `clbTeam_SelectedIndexChanged` | Designer:695 | NowGroupID 읽기(1116/1120). 이후 동작은 **확인 필요** |
| this.spdMain | CellDoubleClick | `spdMain_CellDoubleClick` | Designer:980 | 컬럼 헤더 더블클릭 시 M_/W_/D_ 태그 컬럼의 Visible 토글(1211/1217/1233) |
| this.spdMain | ComboSelChange | `spdMain_ComboSelChange` | Designer:981 | END_CUSTOMER 변경 → FROM_SITE 콤보 재설정(1158). FROM_SITE 변경 → MEASURE 콤보 재설정(1195). `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure](1194) |
| this.spdMain | TopChange | `spdMain_TopChange` | Designer:982 | Fact Pack에 동작 없음 → **확인 필요** |
| this.spdMain | KeyUp | `spdMain_KeyUp` | Designer:983 | Fact Pack에 동작 없음 → **확인 필요** |
| this | Load | `Form_Load` | .cs .ctor:165 | InitControls(MyDivision·Measure·GetBucketType), CreateSpread > InitSpread |
| dsdmPack | Changed | `spdMain_Changed` | .cs InitEvent:391 | `biz:CommonData.CommonDataList` [code=DefaultBucketDay](1749, 1811) |
| dsdmCell | Changed | `spdMain_Changed` | .cs InitEvent:394 | 위와 같음 |

- 프레임워크 버튼 진입점: `FindButton`, `InsertButton`, `SaveButton`, `EditButton`(grid_code 443에서 `GetSheetInfo` 호출이 확인됨).
- 그 밖의 프레임워크 메서드: `OnShown`(181, BaseForm.OnShown — NowGroupID·USER_ID 읽기), `GetCheckedListValue`(OnShown:183 등).

## 5. Grid 구성 방식

**구성 방식: `META(프레임워크) (+코드 표시/라벨 변경)`**

1. **시트 생성(코드 하드코딩)** — `CreateSpread`:255~265
   - `AddSheet(spdMain, "Pack Biz", ..., 3, 1, 40)` (255)
   - `AddSheet(spdMain, "Cell Biz", ..., 3, 1, 40)` (260)
   - `ChangeSheet`로 마지막에 `Pack Biz`를 활성화(265)
2. **메타 컬럼 생성(프레임워크)** — `InitSpread`:272 `CreateSheetHeaderColumn(siMain, 3, dtTitle)`
   - 헤더는 3행입니다.
   - `dtTitle`은 `DM.DMF0045_GET_SPREAD_TITLE`(SCM_MST_SHEET_COLUMNS + SCM_SYS_CALENDAR_M)의 결과입니다.
   - 프레임워크는 COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, LARGE/SMALL_CLASS_LABEL_NAME, VALID_YN 등을 읽습니다.
3. **헤더 Span·색상(화면 자체 메서드 `SetSpreadHeaderSpan`)**:327~381
   - 대분류(LARGE_LABEL)와 소분류(SMALL_LABEL)를 병합하고, 각 그룹 옆에 `SUM` 헤더를 둡니다.
   - COLUMN_NAME에 `B_`가 포함되면 숨깁니다(335).
   - DAY_CODE가 SAT이면 헤더 글자색이 Blue, SUN이면 Red입니다(346).
4. **버킷 표시 전환(화면 자체 메서드 `SetSpreadColumn`)**:2152~2184

   | cboBucketType | D_ 컬럼 | W_ 컬럼 | M_ 컬럼 |
   |---|---|---|---|
   | DAILY | true(2152) | 2152에서 true, 이어서 2157에서 `chkSum.Checked`로 설정(중복 조건, 실제 결과는 **확인 필요**) | `chkSum.Checked`(2157) |
   | WEEKLY | false(2164) | true(2168) | `chkSum.Checked`(2173) |
   | MONTHLY | false(2180) | false(2180) | true(2184) |

   호출 시점: InitSpread:277, FindData:652, cboBucketType_SelectedIndexChanged:1136, chkSum_CheckedChanged:2136.
5. **헤더 더블클릭 접기/펼치기** — `spdMain_CellDoubleClick`:1211/1217/1233. M_ 헤더를 더블클릭하면 W_/D_ 컬럼을, W_ 헤더를 더블클릭하면 D_ 컬럼을 Visible 토글합니다.
6. **Footer 합계** — `InitSpreadFooterSum`:285에서 `ColumnFooter.Visible = true`. `Set_SumValues`:734에서 MEASURE 컬럼을 참조합니다.
7. **행추가 콤보** — InsertRow:1003 FCST_TYPE 콤보, 1005 MEASURE 콤보.

### 5-1. Division별 차이 (grid_effective 기준)

| 시트 | 40 | 81 | 81_UC | 82 | 그 외(81_HD/HG/HM/ST, EE*) |
|---|---|---|---|---|---|
| Cell Biz (메타 표시 컬럼 수) | · | 13 | 13 | 13 | · |
| Pack Biz (메타 표시 컬럼 수) | · | 13 | 13 | 13 | · |
| Cell Biz (SCM_MST_SHEET_MEASURE 수) | · | 11 | 11 | 10 | · |
| Pack Biz (SCM_MST_SHEET_MEASURE 수) | · | 9 | 9 | 8 | · |

- 고정 컬럼은 81, 81_UC, 82 모두 같습니다(필수 4, 기본 9, 숨김 3).
- Measure 메타 행 수는 82가 시트마다 1개 적습니다. 어떤 Measure가 빠지는지는 Fact Pack 표에 없음 → **확인 필요**(dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv).
- Division 40과 EE 계열에는 메타 정의가 없습니다. 이 Division에서 화면을 쓸 수 있는지는 **확인 필요**.
- 실제 SP 실행 결과와 비교하면 28개 시트×division 조합에서 차이가 1054건 있습니다(grid_diff.csv). 날짜 컬럼처럼 SP가 만드는 컬럼은 '메타에 없음'으로 집계됩니다.

## 6. 확인 필요 항목

| # | 항목 | 근거 |
|---|---|---|
| 1 | `GetBizTypebyDivision`(2278, `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`)의 런타임 사용 여부 | 진입점 미연결(unreached) |
| 2 | `Data.UserSiteByEndCustomer` / `UserSiteByEndCustomerAuth`의 엔드포인트·SP | 1158, 엔드포인트 목록에 없음 |
| 3 | MEASURE 콤보 소스 3가지 중 실제 분기 | InsertRow:1005, ComboSelChange:1195 |
| 4 | `spdMain_TopChange`, `spdMain_KeyUp` 동작 | 배선만 확인됨 |
| 5 | `clbCustomer_SelectedIndexChanged`, `clbTeam_SelectedIndexChanged`가 연쇄 갱신하는 대상 | NowGroupID 읽기만 확인됨 |
| 6 | `btnProject_Click` / `btnItemId_Click`의 팝업 화면 | 텍스트 대입만 확인됨 |
| 7 | 4-2표의 `SaveData` → `PersonalSettingPopup.SaveData` 해석 | 화면 자체에 `SaveData`(807/896)가 있음. 프레임워크 동명 메서드로 잘못 해석했을 가능성 |
| 8 | DAILY일 때 W_ 컬럼 최종 Visible | 2152와 2157 조건이 겹침 |
| 9 | `drpPeriod`(Enabled=false)의 값 설정 로직, Item Type 라벨(lblItemType)에 연결된 컨트롤 | props에 Control 지정 없음 |
| 10 | SP 결과와 메타 차이 1054건의 세부 | grid_diff.csv |

- 주석 처리된 호출(commented_calls): 0건.

=== FILE: source_links.md ===
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

=== FILE: web_components.md ===
# DMF0045 화면 컴포넌트 매핑 (AS-IS → React/Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다.

| AS-IS 컨트롤 | 유형 | 라벨(원문) | 라벨 출처 | 속성(원문) | TO-BE 컴포넌트 후보 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division` | clbDivision.Text (DS:936) | Size 257×20 | 단일 선택 콤보(Wijmo ComboBox 계열) |
| cboBucketType | UsrCombo | `Bucket` | lblBucket.Text (DS:948) | Size 256×20 | 단일 선택 콤보 |
| drpPeriod | UsrDateRangePicker | 확인 필요 (LayoutControlItem 이름은 `Period`, Text 미추출) | — | **Enabled=false**(DS:515), Size 180×20 | 기간(From~To) 입력, 비활성 |
| clbPlantSite | UsrCheckedList | `Plant Site` | lblPlantSite.Text (DS:901) | Size 242×21 | 다중 선택 체크리스트 콤보(MultiSelect) |
| clbSalesSite | UsrCheckedList | `Sales Site` | lblSalesSite.Text (DS:824) | Size 242×21 | 다중 선택 |
| clbCustomer | UsrCheckedList | `End Customer` | lblCustomer.Text (DS:798) | Size 247×21 | 다중 선택 |
| clbTeam | UsrCheckedList | `Team` | lblTeam.Text (DS:786) | Size 306×21 | 다중 선택 |
| txtProject | UsrMultiLineEditor | `Project` | lblProject.Text (DS:856) | Size 255×21 | 멀티라인 입력 + 찾기 버튼 |
| btnProject | UsrButton | 확인 필요 | layoutControlItem3 | Size 39×21 | txtProject 찾기 버튼 |
| txtItemId | UsrMultiLineEditor | `Model` | lblModel.Text (DS:844) | Size 255×21 | 멀티라인 입력 + 찾기 버튼 |
| btnItemId | UsrButton | 확인 필요 | layoutControlItem1 | Size 37×21 | txtItemId 찾기 버튼 |
| chkSum | UsrCheckBox | `Sum` | chkSum.Text (DS:278) | Size 70×21 | 체크박스(합계 컬럼 표시) |
| btnMeasure | UsrButton | 확인 필요 | layoutControlItem4 | Size 34×21 | Measure 설정 버튼 |
| btnColumn | UsrButton | 확인 필요 | layoutControlItem2 | **Visible=false**(DS:356), Size 40×21 | 미표시 버튼(TO-BE 필요 여부는 확인 필요) |
| (연결 컨트롤 확인 필요) | LayoutControlItem `lblItemType` | `Item Type` | DS:703 | Size 297×24 | Control 지정이 추출되지 않음 → 확인 필요 |
| layoutControlItem6 / layoutControlItem7 | LayoutControlItem | 확인 필요 | — | 128×25 / 146×25 | 연결 컨트롤 확인 필요 |
| spdMain (+spdMain_Sheet1) | FpSpread | — | — | Dock Fill, Size 1284×479 | Wijmo FlexGrid(시트 2개 → 탭 + Grid) |
| usrConditionPanel1 | UsrConditionPanel | — | — | Dock Top, Size 1284×95, UsrPanelType=HidePanel | 조회조건 패널(접기 가능) |

## 2. 화면 배치

- props.csv에는 SplitContainer가 **없습니다**(Orientation·SplitterDistance 없음).
- 배치는 Dock 방식입니다.

| 영역 | 컨트롤 | Dock | Size | 높이 비율(실측값 기반 계산) |
|---|---|---|---|---|
| 상단 조회조건 | usrConditionPanel1 → usrLayoutControl2 | Top | 1284×95 | 95 / (95+479) = 약 16.6% |
| 하단 Grid | spdMain | Fill | 1284×479 | 479 / 574 = 약 83.4% |

- 좌우 분할은 없습니다.
- 조회조건은 LayoutControl 기반으로 3행입니다(layoutControlGroup2 1284×95, emptySpaceItem8 높이 75 = 25×3행으로 판단). 행·열 순서 원문은 **확인 필요**.
- `usrLayoutControl1`(657×184)은 Dock Fill로 선언되어 있지만 부모가 추출되지 않았습니다. 용도는 **확인 필요**.

## 3. 시트별 Grid 컬럼

두 시트는 `CreateSpread`에서 `AddSheet(..., 헤더 3행, 1, 40)`으로 만들고, 컬럼은 `CreateSheetHeaderColumn`(메타 `SCM_MST_SHEET_COLUMNS`, SP `DMF0045_GET_SPREAD_TITLE`)으로 생성합니다.

### 3-1. `Cell Biz` (grid_effective 기준, Division 81 / 81_UC / 82 동일)

| # | COLUMN | 라벨(원문) | 상태 | 비고 |
|---:|---|---|---|---|
| 1 | DIVISION_ID | Division* | 필수 | |
| 2 | TEAM_NAME_KO | Team | 필수 | |
| 3 | END_CUSTOMER | End Customer | 필수 | ComboSelChange 시 FROM_SITE 콤보 재설정(1158) |
| 4 | LAST_UPDATED_BY | Requestor | 필수 | 헤더 Span 기준 컬럼(`DefColumns.Requestor`) |
| 5 | FCST_TYPE | FCST Type* | 기본 | 행추가 콤보 [code=FCST_TYPE](1003) |
| 6 | FROM_SITE | Frorm ( Plant )* | 기본 | 원문 오탈자 'Frorm' 유지. 변경 시 MEASURE 콤보 재설정(1195) |
| 7 | TO_SITE | To ( Sales-Site )* | 기본 | |
| 8 | INCOTERMS | Incoterms* | 기본 | |
| 9 | TR_MODE | Trans Mode* | 기본 | |
| 10 | ITEM_ID | Model* | 기본 | |
| 11 | NICK_NAME | Nick Name | 기본 | |
| 12 | PROJECT_CODE | Project Code* | 기본 | |
| 13 | MEASURE | Measure* | 기본 | 행추가·콤보 변경 시 콤보 재설정(1005/1195) |
| — | BOD_ID | BOD ID* | 숨김 | |
| — | MEASURE_COLOR | MEASUR_COLOR | 숨김 | 원문 라벨 그대로 |
| — | SHIP_FROZEN | DMF0045 | 숨김 | 원문 라벨 그대로 |

- 표의 순서는 grid_effective 나열 순서가 아닙니다. 실제 SORT_ORDER_NO 순서는 **확인 필요**(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv).
- 메타 Measure 행: Division 81 = 11, 81_UC = 11, 82 = 10.

### 3-2. `Pack Biz` (grid_effective 기준, Division 81 / 81_UC / 82 동일)

- 고정 컬럼 16개(표시 13, 숨김 3)는 `Cell Biz`와 같습니다. COLUMN, 라벨, 필수/기본/숨김 구분이 모두 일치합니다.
- 메타 Measure 행: Division 81 = 9, 81_UC = 9, 82 = 8.

### 3-3. 코드 하드코딩·동적 컬럼 (두 시트 공통)

| 구분 | 내용 | 근거 |
|---|---|---|
| 날짜 버킷 컬럼 | SP `DMF0045_GET_SPREAD_TITLE`(SCM_SYS_CALENDAR_M)가 생성. 태그 접두어 `D_`(일)·`W_`(주)·`M_`(월) | SetSpreadColumn 2152~2184 |
| `B_` 포함 컬럼 | 숨김 | SetSpreadHeaderSpan 335 |
| 헤더 3행 | 0행 = 대분류(LARGE_LABEL) Span + `SUM`, 1행 = 소분류(SMALL_LABEL) Span, 2행 = `SUM` | 327~381 |
| 주말 색상 | DAY_CODE SAT = Blue, SUN = Red(헤더 ForeColor) | 346 |
| Bucket별 표시 | DAILY: D_·W_ 표시, M_·W_ = Sum 체크 / WEEKLY: D_ 숨김, W_ 표시, M_ = Sum 체크 / MONTHLY: D_·W_ 숨김, M_ 표시 | 2152~2184 |
| 헤더 더블클릭 | M_ 헤더 → W_/D_ 토글, W_ 헤더 → D_ 토글 | 1211/1217/1233 |
| Footer 합계 | ColumnFooter 표시 | 285 |

- Division 40과 EE 계열에는 메타가 없습니다(표시 컬럼 `·`).
- 메타와 SP 결과의 차이 1054건(grid_diff.csv)은 TO-BE 컬럼 확정 전에 대조가 필요합니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| `Cell Biz` | META+코드연결 | 코드가 `AddSheet`/`ChangeSheet`로 메타 시트명을 그대로 사용 |
| `Pack Biz` | META+코드연결 | 위와 같음. 초기 활성 시트(265 `ChangeSheet` Pack Biz) |

- 두 시트 사이의 데이터 연계(마스터-디테일)는 Fact Pack에 없습니다.
- 시트 선택 기준(Division의 Biz Type에 따라 Cell/Pack을 고르는지 등)은 **확인 필요**. 미연결 메서드 `GetBizTypebyDivision`이 관련 있을 수 있으나 정적 분석으로는 확정할 수 없습니다.
- 데이터소스: `dsdmPack`, `dsdmCell` 각각의 Changed 이벤트가 `spdMain_Changed`에 연결되어 있습니다(InitEvent 391/394).

=== FILE: oracle_migration.md ===
# DMF0045 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | FoxQuery ID | 호출 지점 | 참조 객체(SELECT/INSERT/UPDATE/DELETE/EXEC/REF) |
|---|---|---|---|
| `DMF0045_GET_SHIPMENT_REQUEST` | DM.DMF0045_GET_SHIPMENT_REQUEST | FindData:609 | 아래 1-1 참조 |
| `DMF0045_SAVE_SHIPMENT_REQUEST` | DM.DMF0045_SAVE_SHIPMENT_REQUEST | SaveData:896 | 아래 1-2 참조 |
| `DMF0045_GET_SPREAD_TITLE` | DM.DMF0045_GET_SPREAD_TITLE | GetSpdTitle:2249 | SELECT SCM_MST_SHEET_COLUMNS, SELECT SCM_SYS_CALENDAR_M, REF STRING_SPLIT |
| `DM0003_GET_BUCKET_TYPE_CODE` | DM.DM0003_GET_BUCKET_TYPE_CODE | GetBucketType:2266 | SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCM0001_GET_BIZ_TYPE_BY_DIVISION` | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | GetBizTypebyDivision:2278 (**진입점 미연결**) | SELECT SCM_MST_PROJECT, REF VALUE, REF NODES |

### 1-1. `DMF0045_GET_SHIPMENT_REQUEST`

| 구분 | 객체 |
|---|---|
| 실 테이블/뷰 SELECT | TB_FX_USER, SCM_MST_TITLESET_USER, SCM_MST_SHEET_MEASURE, DM_PLN_SHIPMENT_REQ, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_SSO_DEPT_INFO, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_PLAN_VERSION_V, SCP_MST_BOD_N_V, SCP_PLN_SHIPMENT_PLAN_PEGGING, SCP_PLN_SHIPMENT_PLAN, SCM_SYS_CALENDAR_M, SCP_MST_BOD_V, DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SCM_DNM_CELL_INHOUSE_PLAN_SN, SSP_DNM_FP_PLAN_FROZEN, SCP_ANL_PRODUCTION_PLAN, SSP_DNM_STOCK_C, SCM_MST_LOCATION, SCP_MST_FINAL_ITEM, SSP_DNM_ESS_PACKER_STOCK_V |
| 실 테이블 쓰기 | **INSERT SCM_MST_TITLESET_USER** (조회 SP 안에서 사용자 타이틀셋을 기록함) |
| 별칭 대상 DML | UPDATE A, DELETE A, UPDATE TOT (실제 대상 테이블은 **확인 필요**) |
| 임시 테이블 | #TBL_LOC, #TBLDYNAMIC_MEASURE, #TBLDYNAMIC_SHIP_REQ, #TBLDYNAMIC_PLAN, #TBLDYNAMIC_SHIP_ROW, #TBLDYNAMIC_CAL_QTY, #TMP_SCP_ANL_SHIPMENT_PLAN_FG, #TBLDYNAMIC_REQUESTOR, #TBLDYNAMIC_SHIP_PIVOT |
| 함수 | FN_GET_SSP_ETD_DATE, FN_NEXT_DAY, STRING_SPLIT |
| 동적 SQL | DYNAMIC@DMF0045_GET_SHIPMENT_REQUEST |

### 1-2. `DMF0045_SAVE_SHIPMENT_REQUEST`

| 구분 | 객체 |
|---|---|
| SELECT | SCP_MST_BOD, SCP_MST_DISTRIBUTION_ROUTE, DM_PLN_SHIPMENT_REQ |
| INSERT | DM_PLN_SHIPMENT_REQ, DM_PLN_SHIPMENT_REQ_H, SCM_SYS_LOG_BATCH |
| 별칭 DML | UPDATE A (대상은 **확인 필요**) |
| 임시 테이블 | #TBLDYNAMIC_DMF0045_SHPIMENTREQ (원문 철자 'SHPIMENTREQ') |
| EXEC 체인 | PR_SCM_SYS_LOG_BATCH |
| 함수 | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL (구분자 문자열 분해) |

- DM_PLN_SHIPMENT_REQ에 대해 UPDATE·DELETE는 추출되지 않았고 INSERT와 _H(이력) INSERT만 있습니다. 기존 행을 처리하는 방식(별칭 A의 UPDATE 대상 여부 포함)은 **확인 필요**.

### 1-3. EXEC 체인 요약

```
DMF0045_SAVE_SHIPMENT_REQUEST ──EXEC──▶ PR_SCM_SYS_LOG_BATCH
DMF0045_GET_SHIPMENT_REQUEST  ──(EXEC 체인 없음, 함수 FN_GET_SSP_ETD_DATE / FN_NEXT_DAY 참조)
```

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList`)

| code | 호출 지점 | 분기 SP | 참조 테이블 |
|---|---|---|---|
| MyDivision | InitControls:200 | UP_FX_GetCommonDataList | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION |
| Measure | InitControls:231, FindData:579, InsertRow:1004 | UP_FX_GetCommonDataList | SCM_MST_SHEET_MEASURE, DM_MST_CUSTOMER_FCST |
| FCST_TYPE | InsertRow:1001 | UP_FX_GetCommonDataList, UP_FX_GETCOMMONDATALIST_DM | SCM_ADM_LOOKUP_MASTER_DETAIL |
| MktFcstEditMeasure | spdMain_ComboSelChange:1194 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, DM_MST_CUSTOMER_FCST |
| DefaultBucketDay | spdMain_Changed:1749, 1811 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL |

- FCST_TYPE은 분기 SP 후보가 2개(UP_FX_GetCommonDataList / UP_FX_GETCOMMONDATALIST_DM)로 추출되었습니다. 실제 경로는 **확인 필요**.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 이 화면의 FoxQuery 엔드포인트 5건은 모두 상태가 `MATCH`이고, 미등록 건은 0건입니다.
- 엔드포인트로 추출되지 않은 데이터 호출(**확인 필요**):
  - `Data.UserSiteByEndCustomer(...)`, `Data.UserSiteByEndCustomerAuth(...)` (spdMain_ComboSelChange:1158)
- 프레임워크 메타 조회 `SpreadInfo.GetSpdTitle`(InitSpread:271)이 화면 엔드포인트 `DM.DMF0045_GET_SPREAD_TITLE`과 같은 호출인지는 **확인 필요**.
- 주석 처리된 호출: 0건.

## 4. Oracle 전환 시 확인 포인트 (추출 사실 기반)

| # | 대상 SP | 사실 | 전환 시 확인 사항 |
|---|---|---|---|
| 1 | DMF0045_GET_SHIPMENT_REQUEST, DMF0045_GET_SPREAD_TITLE | `STRING_SPLIT` 참조 | MSSQL 전용 함수. Oracle 대체 구현 필요(프로젝트 금지 키워드 ⑩) |
| 2 | DMF0045_GET_SHIPMENT_REQUEST | 임시 테이블 9종(#...) | Oracle GTT 또는 WITH 절로 전환. GTT를 쓰면 세션 내 재조회 시 비우기 처리 확인 |
| 3 | DMF0045_GET_SHIPMENT_REQUEST | `DYNAMIC@` 동적 SQL, `#TBLDYNAMIC_SHIP_PIVOT` | 날짜 버킷 피벗 동적 컬럼. Oracle 동적 SQL/SYS_REFCURSOR 결과 컬럼명이 Grid 태그(D_/W_/M_)와 일치하는지 확인 |
| 4 | DMF0045_GET_SHIPMENT_REQUEST | 조회 SP 안의 `INSERT SCM_MST_TITLESET_USER` | 조회 중 쓰기 발생. 트랜잭션/커밋 경계 확인 |
| 5 | DMF0045_GET_SHIPMENT_REQUEST | FN_GET_SSP_ETD_DATE, FN_NEXT_DAY | Oracle에 동명 함수가 있는지 확인 |
| 6 | DMF0045_SAVE_SHIPMENT_REQUEST | SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL | 구분자 배열 파라미터 처리 함수의 Oracle 대응 객체 확인 |
| 7 | DMF0045_SAVE_SHIPMENT_REQUEST | EXEC PR_SCM_SYS_LOG_BATCH, INSERT SCM_SYS_LOG_BATCH | 로그 프로시저의 Oracle 대응 객체 확인 |
| 8 | DMF0045_SAVE_SHIPMENT_REQUEST | INSERT DM_PLN_SHIPMENT_REQ / DM_PLN_SHIPMENT_REQ_H | NOT NULL 컬럼과 이력 키 확인 |
| 9 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | REF VALUE, REF NODES | XML 타입 메서드(.nodes/.value)일 가능성. 원문 확인 후 Oracle XMLTABLE 등으로 대체. 다만 화면에서 미연결이므로 전환 필요 여부부터 확인 |
| 10 | DM0003_GET_BUCKET_TYPE_CODE | SELECT SCM_ADM_LOOKUP_MASTER_DETAIL 단일 | 다른 객체 참조 없음 |

### 난이도 (추출된 사실 개수만으로 분류)

| SP | 근거 | 분류 |
|---|---|---|
| DMF0045_GET_SHIPMENT_REQUEST | 실 객체 23종 이상 + 임시 테이블 9 + 동적 SQL + STRING_SPLIT + 사용자 함수 2 | 상 |
| DMF0045_SAVE_SHIPMENT_REQUEST | EXEC 체인 1 + 배열 분해 함수 2 + 임시 테이블 1 + INSERT 3 | 중 |
| DMF0045_GET_SPREAD_TITLE | 테이블 2 + STRING_SPLIT | 중하 |
| DM0003_GET_BUCKET_TYPE_CODE | 테이블 1 | 하 |
| SCM0001_GET_BIZ_TYPE_BY_DIVISION | 테이블 1 + XML 메서드 참조 추정 | 하~중 (미연결) |

=== FILE: tobe_design.md ===
# DMF0045 TO-BE 설계 입력 정리

## 1. 조회조건 (컨트롤 기준)

| 조건 | AS-IS 컨트롤 | 라벨 원문 | 데이터 소스(사실) | 비고 |
|---|---|---|---|---|
| Division | cboDivision (UsrCombo) | Division | `biz:CommonData.CommonDataList` [code=MyDivision] (InitControls:200) | 변경 시 InitSpread > `DM.DMF0045_GET_SPREAD_TITLE` 재호출 |
| Bucket | cboBucketType (UsrCombo) | Bucket | `DM.DM0003_GET_BUCKET_TYPE_CODE` (GetBucketType:2266) | 값 DAILY/WEEKLY/MONTHLY(SetSpreadColumn 분기). 변경 시 SetSpreadColumn |
| 기간 | drpPeriod (UsrDateRangePicker) | 확인 필요 (항목명 `Period`) | 확인 필요 | Enabled=false |
| Plant Site | clbPlantSite (UsrCheckedList) | Plant Site | 확인 필요 | 다중 선택 |
| Sales Site | clbSalesSite (UsrCheckedList) | Sales Site | 확인 필요 | 다중 선택 |
| End Customer | clbCustomer (UsrCheckedList) | End Customer | 확인 필요 | 다중 선택. SelectedIndexChanged 연쇄 동작은 확인 필요 |
| Team | clbTeam (UsrCheckedList) | Team | 확인 필요 | 다중 선택. SelectedIndexChanged 연쇄 동작은 확인 필요 |
| Project | txtProject + btnProject | Project | btnProject_Click → `txtProject.Text = sProjectCode` | 멀티라인 |
| Model | txtItemId + btnItemId | Model | btnItemId_Click → `txtItemId.Text = sItemId` | 멀티라인 |
| Sum | chkSum (UsrCheckBox) | Sum | — | 합계(M_/W_) 컬럼 표시 토글 |
| Item Type | (연결 컨트롤 확인 필요) | Item Type | 확인 필요 | lblItemType |
| Measure 설정 | btnMeasure | 확인 필요 | InitSpread 재호출 | |
| Column 설정 | btnColumn | 확인 필요 | InitSpread 재호출 | AS-IS Visible=false |

- 필수 조회조건(필수 표시, 검증)은 Fact Pack에 없음 → **확인 필요**. validation 원문이 필요합니다.
- 조회조건 저장 메타 `TB_FX_SearchCondition`에 615행이 있습니다(dbmeta). 기본값과 개인화 내용은 **확인 필요**.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 API 후보 |
|---|---|---|
| 화면 진입 | Form_Load > InitControls / CreateSpread | `biz:CommonData.CommonDataList`(MyDivision, Measure), `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM.DMF0045_GET_SPREAD_TITLE` |
| 조회 | FindButton > FindData | `biz:CommonData.CommonDataList`(Measure), `DM.DMF0045_GET_SHIPMENT_REQUEST`, `DM.DMF0045_GET_SPREAD_TITLE` → SetSpreadColumn |
| 저장 | SaveButton > SaveData | `DM.DMF0045_SAVE_SHIPMENT_REQUEST` → 재조회(FindData 흐름 전체) |
| 행추가 | InsertButton > InsertRow | `biz:CommonData.CommonDataList`(FCST_TYPE, Measure) → FCST_TYPE·MEASURE 셀 콤보 |
| 편집 | EditButton | GetSheetInfo(활성 시트)만 확인됨. API 없음 |
| Division 변경 | cboDivision_SelectedIndexChanged | `DM.DMF0045_GET_SPREAD_TITLE` |
| Bucket 변경 / Sum 체크 | cboBucketType_SelectedIndexChanged / chkSum_CheckedChanged | API 없음. 클라이언트에서 컬럼 표시만 전환 |
| Measure / Column 버튼 | btnMeasure_Click / btnColumn_Click | `DM.DMF0045_GET_SPREAD_TITLE` |
| Grid END_CUSTOMER 변경 | spdMain_ComboSelChange | Data.UserSiteByEndCustomer / UserSiteByEndCustomerAuth (API 확인 필요) → FROM_SITE 콤보 |
| Grid FROM_SITE 변경 | spdMain_ComboSelChange | `biz:CommonData.CommonDataList`(MktFcstEditMeasure) → MEASURE 콤보 |
| Grid 셀 값 변경 | spdMain_Changed | `biz:CommonData.CommonDataList`(DefaultBucketDay) |
| 헤더 더블클릭 | spdMain_CellDoubleClick | API 없음. M_/W_/D_ 컬럼 접기·펼치기 |
| (미연결) | GetBizTypebyDivision | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`. TO-BE 필요 여부는 확인 필요 |

## 3. Division별 Grid 변형 요약

| 시트 | 81 | 81_UC | 82 | 40 / EE / 81 하위(HD·HG·HM·ST) |
|---|---|---|---|---|
| Cell Biz 고정 컬럼(표시) | 13 | 13 | 13 | 메타 없음 |
| Cell Biz Measure 메타 수 | 11 | 11 | 10 | 메타 없음 |
| Pack Biz 고정 컬럼(표시) | 13 | 13 | 13 | 메타 없음 |
| Pack Biz Measure 메타 수 | 9 | 9 | 8 | 메타 없음 |

- 고정 컬럼은 Division 사이에 차이가 없습니다. Division 간 차이는 Measure 행 수에만 있습니다.
- 날짜 버킷 컬럼(D_/W_/M_)은 SP가 생성하며, 표시는 Bucket과 Sum 상태에 따라 클라이언트가 바꿉니다.
- 메타와 SP 결과 차이 1054건(grid_diff.csv)을 대조한 뒤 컬럼을 확정해야 합니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| `TB_FX_GroupMenuAuth`에 DMF0045 관련 13행 존재 | dbmeta 8장. 행 내용은 **확인 필요** |
| `TB_FX_ProgramInfo` 1행, `TB_FX_MenuItemInfo` 1행 존재 | dbmeta |
| 프레임워크 버튼 Find/Insert/Save/Edit 진입점 존재 | flow.csv, grid_code 443 |
| Division 목록이 사용자 그룹 권한 테이블 `TB_FX_USERGROUPAUTHEXTENTION`을 참조 | [code=MyDivision] 분기 |
| FROM_SITE 콤보에 권한 버전 함수(`UserSiteByEndCustomerAuth`) 분기 존재 | spdMain_ComboSelChange:1158 |
| `InsertRow`는 `siMain.IsLock(...) == false`일 때만 동작 | grid_code 1003/1005 조건 |
| `UserInfoContext.Current["NowGroupID"]`를 여러 지점에서 참조 | meta_reads.csv |

- Delete 버튼과 삭제 API는 Fact Pack에 없습니다. TO-BE에서 삭제 기능이 필요한지는 **확인 필요**.

## 5. 미확정 사항

1. 기간(drpPeriod) 라벨, 기본값 설정 로직, Enabled=false의 이유
2. Item Type 라벨과 연결 컨트롤, layoutControlItem6/7의 연결 컨트롤
3. Plant Site / Sales Site / End Customer / Team 콤보의 데이터 소스와 연쇄 갱신 규칙
4. Project / Model 찾기 팝업 화면 ID
5. MEASURE 콤보 소스 3가지 후보 중 실제 분기, FROM_SITE 콤보 API
6. `spdMain_TopChange`, `spdMain_KeyUp` 동작
7. `GetBizTypebyDivision`(SCM0001) 미연결 메서드를 TO-BE에 반영할지 여부
8. 시트(Cell Biz / Pack Biz) 선택 규칙(Division의 Biz Type과의 관계)
9. DAILY 버킷에서 W_ 컬럼의 최종 표시 상태(2152·2157 조건 중복)
10. 조회 SP 안의 `SCM_MST_TITLESET_USER` INSERT를 TO-BE에서 어떻게 처리할지
11. 저장 SP의 기존 행 처리 방식(UPDATE A 대상)과 필수 검증(validation) 원문
12. `TB_FX_GroupMenuAuth` 13행의 권한 값
