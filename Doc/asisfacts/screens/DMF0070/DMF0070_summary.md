# DMF0070 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0070_PRRequestAuto\DMF0070_PRRequestAuto.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0070_PRRequestAuto\DMF0070_PRRequestAuto.csproj | 1045 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0070_PRRequestAuto\DMF0070_PRRequestAuto.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0070_PRRequestAuto\DMF0070_PRRequestAuto.csproj | 752 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0070_PRRequestAuto\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0070_PRRequestAuto\DMF0070_PRRequestAuto.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0070_PRRequestAuto\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0070_PRRequestAuto\DMF0070_PRRequestAuto.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0070_PRRequestAuto\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0070_PRRequestAuto\DMF0070_PRRequestAuto.csproj | 27 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1030 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:dsdm.Changed | spdMain_Changed > GetSLOC | 973 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:FindButton | FindButton > FindData | 512 | DM.DMF0070_GET_REQUEST_AUTO_LIST | MATCH | SP DMF0070_GET_REQUEST_AUTO_LIST |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1030 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindButton > FindData | 512 | DM.DMF0070_GET_REQUEST_AUTO_LIST | MATCH | SP DMF0070_GET_REQUEST_AUTO_LIST |
| button:SaveButton | SaveButton > SaveData | 684 | DM.DMF0070_SAVE_REQUEST_AUTO_LIST | MATCH | SP DMF0070_SAVE_REQUEST_AUTO_LIST |
| button:SaveButton | SaveButton > SaveData > FindButton > FindData > InitSpread > GetSpdTitle | 1030 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 210 | biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH |  |
| event:this.Load | Form_Load > GetSPlant | 955 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.Load | Form_Load > GetSLOC | 973 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1030 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdMain.CellClick | spdMain_CellClick > GetSLOC | 973 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 50 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDayRange | 918 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0070_GET_REQUEST_AUTO_LIST | MATCH | 1 | SP DMF0070_GET_REQUEST_AUTO_LIST | EXEC:DMF0070_GET_REQUEST_AUTO_LIST, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE_ITEM, SELECT:DM_PLN_AUTO_PR_CHECK, SELECT:SCP_MST_BOD_V, REF:FN_LIST_LOOKUP_VALUE, REF:STRING_SPLIT, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| DM.DMF0070_SAVE_REQUEST_AUTO_LIST | MATCH | 1 | SP DMF0070_SAVE_REQUEST_AUTO_LIST | EXEC:DMF0070_SAVE_REQUEST_AUTO_LIST, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#T_MAIN, REF:UF_FX_STRING_SPLIT, UPDATE:ATO, SELECT:DM_PLN_AUTO_PR_CHECK, SELECT:#T_MAIN, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 2 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| EditButton | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID |
| SaveButton | UserInfoContext.Current | NowGroupID |
| SaveData | response.DataSet.Tables[0].Rows[0] | result_code, result_cnt |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:160, SetChangeControl:167, SetChangeControl:175, SetChangeControl:191, SetChangeControl:198 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetSpdTitle | InitSpread:264 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:265 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:399 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | FindData:472, cboDivision_SelectedIndexChanged:741, btnOwner_Click:931, GetSpdTitle:1036 | CString.GetCheckedListValue | CODE |
| FP_Log2 | cboDivision_SelectedIndexChanged:745, cboDivision_SelectedIndexChanged:800 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btmItem | Click | btmItem_Click | InitializeComponent:310 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:346 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:457 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:631 |
| this | Load | Form_Load | .ctor:125 |
| cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:275 |
| dsdm | Changed | spdMain_Changed | InitEvent:277 |
| drpPeriod | ValueChanged | drpPeriod_ValueChanged | InitEvent:279 |

## 6. 컨트롤 (29개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lblProject, lblScmSite, lblDivision, lblBtnProject, lblItem, lblBtnItemId, lblPeriod, lblOwner, layoutControlItem8 |
| UsrMultiLineEditor | 3 | txtProject, txtItemId, txtOwner |
| UsrButton | 3 | btmItem, btnProject, btnOwner |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cboDivision |
| UsrCheckedList | 1 | clbScmSite |
| UsrDateRangePicker | 1 | drpPeriod |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 77 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 21 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 2 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0070 | Request Auto List | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Request Auto List
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:265

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 647 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 648 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 649 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 650 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Request Auto List | META+코드연결 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
