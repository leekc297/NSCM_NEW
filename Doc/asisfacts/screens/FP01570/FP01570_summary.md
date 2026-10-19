# FP01570 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01570_PlanID_History.UIL\FP01570_PlanID_History.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01570_PlanID_History.UIL\FP01570_PlanID_History.csproj | 887 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01570_PlanID_History.UIL\FP01570_PlanID_History.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01570_PlanID_History.UIL\FP01570_PlanID_History.csproj | 636 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01570_PlanID_History.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01570_PlanID_History.UIL\FP01570_PlanID_History.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01570_PlanID_History.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01570_PlanID_History.UIL\FP01570_PlanID_History.csproj | 84 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP01570_PlanID_History.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 878 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP01570_PlanID_History.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 610 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 252 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangeControl | 252 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged > SetChangeControl | 252 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:cboPlanWeek.SelectedIndexChanged | CboPlanWeek_SelectedIndexChanged > SetChangeControl | 252 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Execute | 569 | FP_Master.PR_UI_FP01570_PLANID_HISTORY | MATCH | SP PR_UI_FP01570_PLANID_HISTORY |
| event:popSql.OnSql | RunSqlSource > Find_Data_Execute | 569 | FP_Master.PR_UI_FP01570_PLANID_HISTORY | MATCH | SP PR_UI_FP01570_PLANID_HISTORY |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Execute | 569 | FP_Master.PR_UI_FP01570_PLANID_HISTORY | MATCH | SP PR_UI_FP01570_PLANID_HISTORY |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Execute | 706 | FP_Master.PR_UI_FP01570_SAVE | MATCH | SP PR_UI_FP01570_SAVE |
| event:this.Load | Form_Load > InitControls | 203 | biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 208 | biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 216 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_WEEK] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 220 | biz:FPCommonDataBLL.FPCommonDataList [code=WEEK_EXP] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 226 | biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 252 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_WEEK] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=WEEK_EXP] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP01570_PLANID_HISTORY | MATCH | 1 | SP PR_UI_FP01570_PLANID_HISTORY | EXEC:PR_UI_FP01570_PLANID_HISTORY | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP01570_SAVE | MATCH | 1 | SP PR_UI_FP01570_SAVE | EXEC:PR_UI_FP01570_SAVE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | dtCurDate.Rows[0] | CUR_DATE |
| SetChangeControl | Filter | USER_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetInnerTable | SetChangeControl:245 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | SetChangeControl:247, SetChangeControl:259, Find_Data_Execute:546, Find_Data_Execute:547, Find_Data_Execute:548, Find_Data_Execute:549 | CString.GetCheckedListValue | CODE |
| FP_Log2 | CboInstance_SelectedIndexChanged:745, CboInstance_SelectedIndexChanged:747 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:134 |
| cboInstance | SelectedIndexChanged | CboInstance_SelectedIndexChanged | InitEvent:344 |
| cboPlanID | SelectedIndexChanged | CboPlanID_SelectedIndexChanged | InitEvent:345 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:346 |
| cboPlanWeek | SelectedIndexChanged | CboPlanWeek_SelectedIndexChanged | InitEvent:347 |
| drpPeriod | ValueChanged | drpPeriod_changed | InitEvent:348 |
| popSql | OnSql | RunSqlSource | btnSql_Click:452 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:365 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:517 |

## 6. 컨트롤 (25개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | lblSql, lblPlanType, lblPlanID, lblInstance, lblPlanWeek, lblPeriod, lblTarget |
| UsrCombo | 4 | cboInstance, cboPlanID, cboPlanType, cboPlanWeek |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker2 | 1 | drpPeriod |
| UsrButton | 1 | btnSql |
| CheckEdit | 1 | chkLastReleaseFlag |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imgList |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 40 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 16 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 4 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP01570 | Main | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 | 37/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:369

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 375 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PRE_FIX_DATE1 | if(adminAuth) |
| InitSpread |  | 376 | 표시/라벨 변경 | set:Width | Width = 100 | PRE_FIX_DATE1 | if(adminAuth) |
| InitSpread |  | 377 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PRE_FIX_DATE2 | if(adminAuth) |
| InitSpread |  | 378 | 표시/라벨 변경 | set:Width | Width = 100 | PRE_FIX_DATE2 | if(adminAuth) |
| InitSpread |  | 379 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PRE_FIX_TYPE1 | if(adminAuth) |
| InitSpread |  | 380 | 표시/라벨 변경 | set:Width | Width = 100 | PRE_FIX_TYPE1 | if(adminAuth) |
| InitSpread |  | 381 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PRE_FIX_TYPE2 | if(adminAuth) |
| InitSpread |  | 382 | 표시/라벨 변경 | set:Width | Width = 100 | PRE_FIX_TYPE2 | if(adminAuth) |
| InitializeComponent |  | 533 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 534 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 535 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 536 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) | 37 (?4) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 56 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 56건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
