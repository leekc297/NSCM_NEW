# SCP0038 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0038_GlobalPSI_small\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0038_GlobalPSI_small\SCP0038_GlobalPSI_small.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0038_GlobalPSI_small\SCP0038_GlobalPSI_small.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0038_GlobalPSI_small\SCP0038_GlobalPSI_small.csproj | 907 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0038_GlobalPSI_small\SCP0038_GlobalPSI_small.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0038_GlobalPSI_small\SCP0038_GlobalPSI_small.csproj | 1074 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 529 | SCP.SCP0038_GET_GLOBAL_PSI_SMALL | MATCH | SP SCP0038_GET_GLOBAL_PSI_SMALL |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 806 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 806 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 764 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetEm0101 | 789 | SCP.SCP0038_GET_CELLTYPE_EM0101 | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 806 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0038_GET_CELLTYPE_EM0101 | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_MST_ITEM_CLASS_SN |
| SCP.SCP0038_GET_GLOBAL_PSI_SMALL | MATCH | 1 | SP SCP0038_GET_GLOBAL_PSI_SMALL | EXEC:SCP0038_GET_GLOBAL_PSI_SMALL, REF:STRING_SPLIT, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TBLDYNAMICPIVOT_SCP0038_NICKITEM, SELECT:SCM_MST_ITEM_SN, INSERT:#TBL_ITEM_ID_CELL_ITEM_ID, SELECT:SCP_ANL_PSI_GLOBAL_SMALL, REF:FN_SPLITSTRING, INSERT:#PACK, SELECT:#TBL_ITEM_ID_CELL_ITEM_ID, INSERT:#TCOCELL, REF:FN_GET_SCP_CELL_TYPE_SORT, SELECT:#PACK, SELECT:SCP_MST_FINAL_ITEM_V, INSERT:#CELL, SELECT:#TCOCELL, INSERT:#TBLDYNAMICPIVOT_SCP0038_ITEM_ORDER, SELECT:#CELL, INSERT:#TBLDYNAMICPIVOT_SCP0038_CELLITEM, SELECT:#TBLDYNAMICPIVOT_SCP0038_ITEM_ORDER, SELECT:#TBLDYNAMICPIVOT_SCP0038_NICKITEM, INSERT:#TBLDYNAMICPIVOT_SCP0038_ITEM, SELECT:#TBLDYNAMICPIVOT_SCP0038_CELLITEM, INSERT:#TBLDYNAMICPIVOT_SCP0038_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, CREATE:#TBLDYNAMICPIVOT_SCP0038, CREATE:#TBLDYNAMICPIVOT_SCP0038_RESULT, DYNAMIC@SCP0038_GET_GLOBAL_PSI_SMALL, INSERT:#TBLDYNAMICPIVOT_SCP0038_LINE, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TBLDYNAMICPIVOT_SCP0038_LINE_LOAD, SELECT:SCP_ANL_WORKING_TIME, SELECT:SCP_ANL_TACT_TIME, SELECT:#TBLDYNAMICPIVOT_SCP0038_LINE, INSERT:#TBLDYNAMICPIVOT_SCP0038_RESULT, SELECT:#TBLDYNAMICPIVOT_SCP0038, INSERT:#TBLDYNAMICPIVOT_SCP0038_LINE_LOAD_BASE, SELECT:#TBLDYNAMICPIVOT_SCP0038_LINE_LOAD, SELECT:#TBLDYNAMICPIVOT_SCP0038_MEASURE, INSERT:#TBLDYNAMICPIVOT_SCP0038, SELECT:#TBLDYNAMICPIVOT_SCP0038_LINE_LOAD_BASE, SELECT:SCM_DNM_PRODUCT_RESULT_V, SELECT:SCP_MST_FINAL_ITEM, SELECT:#TBLDYNAMICPIVOT_SCP0038_RESULT, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:DM_PLN_SALES_PLAN_RESULT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtFromSiteAll> | UserInfoContext.Current | NowGroupID |
| <field:dtToSiteAll> | UserInfoContext.Current | NowGroupID |
| Set_SumValues | dsBinding.Tables[0].Columns | measure, measure_color |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:225 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:227 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:228 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | RefreshPlanDate:398, RefreshPlanType:406, RefreshPlanType:407, RefreshPlanSeq:418, RefreshPlanSeq:419, RefreshPlanSeq:420, FindData_Main:487, FindData_Main:488 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:292 |
| this | Load | Form_Load | .ctor:150 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:312 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:313 |
| this.chkSum | CheckedChanged | ChkSum_CheckedChanged | InitEvent:314 |
| this.cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:315 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:317 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:319 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:320 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:321 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:322 |
| clbFromSite | SelectedIndexChanged | clbFromSite_SelectedIndexChanged | InitEvent:323 |

## 6. 컨트롤 (38개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 15 | lblCombo1, layoutControlItem3, layoutControlItem4, PlanDate, PlanType, SEQ, layoutControlItem2, lblBucket, lblFromSite, layoutControlItem13, lblFromSite1, layoutControlItem5, lblItemId, lcOperationGroup, lcCellTypeGr |
| UsrCombo | 5 | cboDivision, cboBucketType, cboPlanDate, cboPlanType, cboPlanSeq |
| UsrCheckedList | 4 | clbToSite, clbFromSite, cboOperationGroup, cboCellTypeGr |
| UsrButton | 3 | usrButton1, btnMeasure, btnItem_Id |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem3 |
| UsrConditionPanel | 1 | pnlCondition |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrCheckBox | 1 | chkSum |
| UsrMultiLineEditor | 1 | txtItemId |
| TextBox | 1 | txtNickName |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 789 | GetEm0101 | SCP.SCP0038_GET_CELLTYPE_EM0101 | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_MST_ITEM_CLASS_SN · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 173 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 18 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 15 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 29 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 33 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 12 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 176 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0038 | Global PSI | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |
| SCM_MST_SHEET_MEASURE | SCP0038 | Global PSI | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Global PSI
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:227
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 264 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 268 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 272 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 351 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 355 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 360 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 363 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 367 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 372 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 376 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 954 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 955 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 956 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 957 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Global PSI | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
