# DMF0068 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\DMF0068_DemandManager40.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\DMF0068_DemandManager40.csproj | 1338 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\DMF0068_DemandManager40.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\DMF0068_DemandManager40.csproj | 372 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\DMF0068_DemandManager40.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\DMF0068_DemandManager40.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\DMF0068_DemandManager40.csproj | 27 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0068_VersionPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 390 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0068_VersionPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 536 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0068_DemandManager40.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1235 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0068_DemandManager40.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 372 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 245 | DM.DMF0068_GET_CONT_VIEW_VERSIONPOPUP | MATCH | SP DMF0068_GET_CONT_VIEW_VERSIONPOPUP |
| button:FindButton | FindButton > FindData | 632 | DM.DMF0068_GET_ORDERLIST | MATCH | SP DMF0068_GET_ORDERLIST |
| button:InsertButton | InsertButton > InsertRow > GetLookupProject | 128 | DM.DMF0068_GET_LOOKUPPROJECT | MATCH | SP DMF0068_GET_LOOKUPPROJECT |
| button:SaveButton | SaveButton > SaveData > FindData | 632 | DM.DMF0068_GET_ORDERLIST | MATCH | SP DMF0068_GET_ORDERLIST |
| button:SaveButton | SaveButton > SaveData | 1057 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveDemandManager] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1057 | DM\Plan\DMF0068_DemandManager40#SaveDemandManager | MATCH_PATTERN | SP DMF0068_SAVE_ORDERLIST |
| button:SaveButton | SaveButton > SaveData | 1107 | biz:AppService.GeneralRunProcedureCustomTable [procedure=DelDemandManager] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1107 | DM\Plan\DMF0068_DemandManager40#DelDemandManager | MATCH_PATTERN | SP DMF0068_DEL_ORDERLIST |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 245 | DM.DMF0068_GET_CONT_VIEW_VERSIONPOPUP | MATCH | SP DMF0068_GET_CONT_VIEW_VERSIONPOPUP |
| event:this.Load | Form_Load > InitControls | 116 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 245 | DM.DMF0068_GET_CONT_VIEW_VERSIONPOPUP | MATCH | SP DMF0068_GET_CONT_VIEW_VERSIONPOPUP |
| event:this.Load | Form_Load > InitControls > GetLookupData | 377 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.txtDes.KeyDown | txtItemID_KeyDown > FindButton > FindData | 245 | DM.DMF0068_GET_CONT_VIEW_VERSIONPOPUP | MATCH | SP DMF0068_GET_CONT_VIEW_VERSIONPOPUP |
| unreached:(진입점 미연결) | <field:dtDivision> | 45 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetSpdTitle | 319 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=DelDemandManager] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveDemandManager] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DM0000_GET_COMMON_SPREAD_TITLE | EXEC:DM0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| DM.DMF0068_GET_CONT_VIEW_VERSIONPOPUP | MATCH | 1 | SP DMF0068_GET_CONT_VIEW_VERSIONPOPUP | EXEC:DMF0068_GET_CONT_VIEW_VERSIONPOPUP, SELECT:DM_MDF_VERSION |  |
| DM.DMF0068_GET_LOOKUPPROJECT | MATCH | 1 | SP DMF0068_GET_LOOKUPPROJECT | EXEC:DMF0068_GET_LOOKUPPROJECT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0068_GET_ORDERLIST | MATCH | 1 | SP DMF0068_GET_ORDERLIST | EXEC:DMF0068_GET_ORDERLIST, SELECT:DM_MDF_VERSION, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_CELL_PACK_COUNT, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TMP_PJTIFO, SELECT:SCM_MST_SITE_ITEM, SELECT:#TEMP_CELL_PACK_COUNT, INSERT:#TMP_SRESULT_SPLAN, SELECT:DM_PLN_ORDER_MGT, SELECT:DM_PLN_SALES_PLAN_C, SELECT:#TMP_PJTIFO, SELECT:DM_PLN_SALES_PLAN_RESULT, INSERT:#TMP_BRESULT_BPLAN, SELECT:DM_PLN_BP_FCST_C, EXEC:SP_EXECUTESQL |  |
| DM\Plan\DMF0068_DemandManager40#DelDemandManager | MATCH_PATTERN | 1 | SP DMF0068_DEL_ORDERLIST | EXEC:DMF0068_DEL_ORDERLIST, EXEC:PR_SCM_SYS_LOG_BATCH, DELETE:DM_PLN_ORDER_MGT, INSERT:SCM_SYS_LOG_BATCH |  |
| DM\Plan\DMF0068_DemandManager40#SaveDemandManager | MATCH_PATTERN | 1 | SP DMF0068_SAVE_ORDERLIST | EXEC:DMF0068_SAVE_ORDERLIST, SELECT:DM_PLN_ORDER_MGT, EXEC:PR_SCM_SYS_LOG_BATCH, MERGE:DM_PLN_ORDER_MGT, UPDATE:DM_PLN_ORDER_MGT, INSERT:SCM_SYS_LOG_BATCH |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtDivision> | UserInfoContext.Current | NowGroupID |
| btnSPVer_Click | UserInfoContext.Current | TimeZone |
| EditButton | c | CODE |
| EditButton | UserInfoContext.Current | NowGroupID |
| FindData | c | CODE |
| FindData | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE |
| InitControls | UserInfoContext.Current | NowGroupID |
| SaveData | dr | PROJECT_CODE, MEASURE, ATTRIBUTE1, YYYYMM_FROM, YYYYMM_TO, ORDER_APPROVAL, ORDER_NOW, ATTRIBUTE2 |
| SaveData | dr_del | ATTRIBUTE2 |
| SaveData | r | PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO |
| SaveData | row | PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO |
| SaveData | result.Rows[0] | result_code, result_cnt |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:251 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:516 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | FindData:215 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnSPVer | Click | btnSPVer_Click | InitializeComponent:173 |
| this | Load | Form_Load | .ctor:180 |
| this.txtDes | KeyDown | txtItemID_KeyDown | InitializeComponent:131 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:172 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:227 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:431 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:432 |
| this | Load | Form_Load | .ctor:91 |

## 6. 컨트롤 (36개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | lblVersion, layoutControlItem1, layoutControlItem3, layoutControlItem1, lblDivision, Period, Description, lblType |
| EmptySpaceItem | 6 | emptySpaceItem1, emptySpaceItem1, emptySpaceItem2, emptySpaceItem4, emptySpaceItem5, emptySpaceItem3 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrMultiLineEditor | 1 | txtVersion |
| UsrButton | 1 | btnSPVer |
| UsrMonthRangePicker | 1 | drpPeriodMonth |
| TextBox | 1 | txtDes |
| UsrCheckedList | 1 | clbDivision |
| UsrButtonList | 1 | btnButtonList |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrCombo | 1 | clbType |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1057 | SaveData | {?definition_path}#SaveDemandManager | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1107 | SaveData | {?definition_path}#DelDemandManager | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 42 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 17 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_H | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 159 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 234 | DM.DMF0043_GET_SALES_LIST_SPREAD_TITLE | commented:MATCH |
| 229 | DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0068 | ContributeSalesList | 156/0 | 156/0 | 156/0 | 156/0 | 156/0 | 156/0 | 156/0 | 156/0 | 156/0 | 156/0 | 156/0 | 156/0 | 156/0 | 156/0 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 2212건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ContributeSalesList, VersionPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:251

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadMonth |  | 271 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(i <= 154) |
| SetSpreadMonth |  | 283 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(i <= 11 + intMonCnt) |
| SetSpreadMonth |  | 285 | 표시/라벨 변경 | set:Text | Text = {?dt.AddMonths("0").ToString("yyyy.MM")} |  | for(i <= 11 + intMonCnt) |
| SetSpreadHeaderSpan |  | 364 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| InitializeComponent |  | 298 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 299 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 300 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 301 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread_X |  | 161 | 하드코딩 | AddTextColumn | Divison | DIVISION_ID |  |
| InitSpread_X |  | 162 | 하드코딩 | AddTextColumn | Version | VERSION_NO |  |
| InitSpread_X |  | 163 | 하드코딩 | AddTextColumn | Description | VERSION_DESCRIPTION |  |
| InitSpread_X |  | 164 | 하드코딩 | AddTextColumn | Type | VERSION_TYPE |  |
| InitSpread_X |  | 165 | 하드코딩 | AddTextColumn | Seq | VER_CRE_SEQ |  |
| InitSpread_X |  | 166 | 하드코딩 | AddTextColumn | Date | YYYYMMDD |  |
| InitSpread_X |  | 167 | 하드코딩 | AddTextColumn | Create By | CREATED_BY |  |
| InitSpread_X |  | 168 | 하드코딩 | AddTextColumn | Create Date | CREATION_DATE |  |
| InitializeComponent |  | 448 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 449 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 450 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 451 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ContributeSalesList | META+코드연결 | 156 | 156 | 156 | 156 | 156 | 156 | 156 | 156 | 156 | 156 | 156 | 156 | 156 | 156 |
| VersionPopup | 코드 하드코딩 전용(메타 없음) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
