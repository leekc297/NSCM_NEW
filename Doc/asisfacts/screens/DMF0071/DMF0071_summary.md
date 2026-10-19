# DMF0071 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0051_1_BizPlanWaterfall\DMF0071_BPCutOffPopup.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0051_1_BizPlanWaterfall\DMF0051_1_BizPlanWaterfall.csproj | 523 |
| only | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0051_1_BizPlanWaterfall\DMF0071_BPCutOffPopup.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0051_1_BizPlanWaterfall\DMF0051_1_BizPlanWaterfall.csproj | 673 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0071_BPCutOffPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 497 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0071_BPCutOffPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 673 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 252 | DM.DMF0071_GET_BPCUTOFF_LIST | MATCH | SP DMF0071_GET_BPCUTOFF_LIST |
| button:FindButton | FindButton > FindData | 257 | DM.DMF0071_GET_BPCUTOFF_LIST | MATCH | SP DMF0071_GET_BPCUTOFF_LIST |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 508 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > MakeCutOff > FindData | 252 | DM.DMF0071_GET_BPCUTOFF_LIST | MATCH | SP DMF0071_GET_BPCUTOFF_LIST |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > MakeCutOff > FindData | 257 | DM.DMF0071_GET_BPCUTOFF_LIST | MATCH | SP DMF0071_GET_BPCUTOFF_LIST |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > MakeCutOff | 451 | DM.DMF0071_SAVE_BPCUTOFF | MATCH | SP DMF0071_SAVE_BPCUTOFF |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > MakeCutOff | 456 | DM.DMF0071_SAVE_BPCUTOFF | MATCH | SP DMF0071_SAVE_BPCUTOFF |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > MakeCutOff > FindData > InitSpread > GetSpdTitle | 508 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged_1 | 370 | DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged_1 | 375 | DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged_1 | 392 | DM.DMF0071_GET_RTF_VERSION | MATCH | SP DMF0071_GET_RTF_VERSION |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged_1 | 397 | DM.DMF0071_GET_RTF_VERSION | MATCH | SP DMF0071_GET_RTF_VERSION |
| event:this.drpPeriod.ValueChanged | drpPeriod_ValueChanged > clbDivision_SelectedIndexChanged_1 | 370 | DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| event:this.drpPeriod.ValueChanged | drpPeriod_ValueChanged > clbDivision_SelectedIndexChanged_1 | 375 | DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| event:this.drpPeriod.ValueChanged | drpPeriod_ValueChanged > clbDivision_SelectedIndexChanged_1 | 392 | DM.DMF0071_GET_RTF_VERSION | MATCH | SP DMF0071_GET_RTF_VERSION |
| event:this.drpPeriod.ValueChanged | drpPeriod_ValueChanged > clbDivision_SelectedIndexChanged_1 | 397 | DM.DMF0071_GET_RTF_VERSION | MATCH | SP DMF0071_GET_RTF_VERSION |
| event:this.Load | Form_Load > InitControls | 121 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 124 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 252 | DM.DMF0071_GET_BPCUTOFF_LIST | MATCH | SP DMF0071_GET_BPCUTOFF_LIST |
| event:this.Load | Form_Load > FindData | 257 | DM.DMF0071_GET_BPCUTOFF_LIST | MATCH | SP DMF0071_GET_BPCUTOFF_LIST |
| event:this.Load | Form_Load > FindData > InitSpread > GetSpdTitle | 508 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.txtDes.KeyDown | txtItemID_KeyDown > FindButton > FindData | 252 | DM.DMF0071_GET_BPCUTOFF_LIST | MATCH | SP DMF0071_GET_BPCUTOFF_LIST |
| event:this.txtDes.KeyDown | txtItemID_KeyDown > FindButton > FindData | 257 | DM.DMF0071_GET_BPCUTOFF_LIST | MATCH | SP DMF0071_GET_BPCUTOFF_LIST |
| event:this.txtDes.KeyDown | txtItemID_KeyDown > FindButton > FindData > InitSpread > GetSpdTitle | 508 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0071_GET_BPCUTOFF_LIST | MATCH | 2 | SP DMF0071_GET_BPCUTOFF_LIST | EXEC:DMF0071_GET_BPCUTOFF_LIST, SELECT:DM_PLN_BIZPLAN_C, SELECT:DM_MST_VERSION |  |
| DM.DMF0071_GET_RTF_VERSION | MATCH | 2 | SP DMF0071_GET_RTF_VERSION | EXEC:DMF0071_GET_RTF_VERSION, SELECT:SCP_ANL_BUSINESS_PLAN_RTF_DM |  |
| DM.DMF0071_SAVE_BPCUTOFF | MATCH | 2 | SP DMF0071_SAVE_BPCUTOFF | EXEC:DMF0071_SAVE_BPCUTOFF, EXEC:DMF0051_1_TRANSFER_TO_BIZPLAN, EXEC:DMF0051_1_BIZPLAN_CUTOFF, EXEC:DMF0051_1_CREATE_RTF_MEASURE, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH, CREATE:#TEMP_SITE_ITEMALL, CREATE:#TMP_DM_PLN_BIZPLAN, CREATE:#TMP_DM_PLN_BIZPLAN_40, CREATE:#TMP_PRICE_S, CREATE:#TMP_PRICE, INSERT:#TEMP_SCM_SYS_CALENDAR_M, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:DM_MST_ITEM_SINGLE_V, REF:STRING_SPLIT, INSERT:#TEMP_SITE_ITEMALL, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SITE_ITEM, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_CITY, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_FINAL_ITEM, INSERT:#TEMP_SITE_ITEM, SELECT:#TEMP_SITE_ITEMALL, DELETE:DM_PLN_BIZPLAN, INSERT:#TMP_PRICE, SELECT:DM_MST_METAL_PRICE, SELECT:#TEMP_SCM_SYS_CALENDAR_M, INSERT:DM_PLN_BIZPLAN, SELECT:DM_PLN_MKT_FCST_C, SELECT:#TEMP_SITE_ITEM, SELECT:DM_MST_METAL_PRICE_RULE, SELECT:DM_MST_ESS_METAL_PRICE_RULE, INSERT:#TMP_PLN_BIZPLAN, SELECT:DM_PLN_BIZPLAN, INSERT:#TMP_DM_PLN_BIZPLAN, SELECT:#TMP_PLN_BIZPLAN, DELETE:#TMP_DM_PLN_BIZPLAN, SELECT:#TMP_DM_PLN_BIZPLAN, UPDATE:DM_PLN_BIZPLAN, SELECT:#TMP_PRICE, SELECT:DM_MST_METAL_CURRENCY_PRICE, INSERT:#TMP_PRICE_S, SELECT:DM_PLN_BP_FCST_C, SELECT:#TMP_PRICE_S, INSERT:#TMP_PLN_BIZPLAN_40, INSERT:#TMP_DM_PLN_BIZPLAN_40, SELECT:#TMP_PLN_BIZPLAN_40, DELETE:#TMP_DM_PLN_BIZPLAN_40, SELECT:#TMP_DM_PLN_BIZPLAN_40, EXEC:DMF0051_1_GET_DM_VERSION, INSERT:DM_PLN_BIZPLAN_C, EXEC:PR_SCP_SYS_LOG_BATCH, CREATE:#TMP_RTF, SELECT:SCP_ANL_BUSINESS_PLAN_INFO |  |
| DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | 2 | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP | EXEC:SCM0002_GET_VERSIONBYWATERFALLPOPUP, SELECT:DM_MST_VERSION, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, REF:UF_FX_STRING_SPLIT, SELECT:SCP_PLN_INTERFACE_YN |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbDivision_SelectedIndexChanged_1 | response.DataSet.Tables[0].Rows[0] | RTF_VER_TXT, RTF_VER_PARAM |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | row | CODE, NAME |
| MakeCutOff | result.Tables[result.Tables.Count-1].Rows[0] | result_code |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:190 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:191 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| GetCheckedListValue | FindData:233, MakeCutOff:465, GetSpdTitle:514, FindData:228, MakeCutOff:460 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:189 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.txtDes | KeyDown | txtItemID_KeyDown | InitializeComponent:146 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:201 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged_1 | InitializeComponent:238 |
| this.drpPeriod | ValueChanged | drpPeriod_ValueChanged | InitializeComponent:377 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:556 |
| this | Load | Form_Load | .ctor:90 |
| this | Load | Form_Load | .ctor:99 |
| this | Load | Form_Load | .ctor:87 |
| this | Load | Form_Load | .ctor:96 |
| this.txtDes | KeyDown | txtItemID_KeyDown | InitializeComponent:146 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:201 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged_1 | InitializeComponent:238 |
| this.drpPeriod | ValueChanged | drpPeriod_ValueChanged | InitializeComponent:377 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:556 |

## 6. 컨트롤 (58개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | layoutControlItem1, Description, layoutControlItem2, Description1, layoutControlItem3, layoutControlItem4, Description2, Period, layoutControlItem1, Description, layoutControlItem2, Description1, layoutControlItem3, layoutControlItem4, Description2 … |
| EmptySpaceItem | 12 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem5, emptySpaceItem8, emptySpaceItem4, emptySpaceItem9, emptySpaceItem1, emptySpaceItem2, emptySpaceItem5, emptySpaceItem8, emptySpaceItem4, emptySpaceItem9 |
| TextBox | 6 | txtDes, txtRTFVer, txtCutOffYear, txtDes, txtRTFVer, txtCutOffYear |
| UsrCombo | 6 | clbDivision, clbFCST_Ver, cboBPYear, clbDivision, clbFCST_Ver, cboBPYear |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| UsrDateRangePickerWtWeek | 2 | drpPeriod, drpPeriod |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 4 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 9 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0071 | BPCutOffPopup | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: BPCutOffPopup
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:191, SetSheetHeaderColumn@InitSpread:189

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 572 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 573 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 574 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 575 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 572 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 573 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 574 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 575 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| BPCutOffPopup | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
