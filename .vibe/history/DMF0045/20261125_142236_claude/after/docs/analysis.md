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
