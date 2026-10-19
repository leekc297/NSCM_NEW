# SCP0055 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0055_Shipment_Allo_Report\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0055_Shipment_Allo_Report\SCP0055_Shipment_Allo_Report.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0055_Shipment_Allo_Report\SCP0055_Shipment_Allo_Report.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0055_Shipment_Allo_Report\SCP0055_Shipment_Allo_Report.csproj | 1516 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0055_Shipment_Allo_Report\SCP0055_Shipment_Allo_Report.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0055_Shipment_Allo_Report\SCP0055_Shipment_Allo_Report.csproj | 1448 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main > RefreshGrid | 779 | SCP.SCP0055_GET_SHIPMENT_ALLO_PLAN | MATCH | SP SCP0055_GET_SHIPMENT_ALLO_PLAN |
| button:FindButton | FindButton > FindData_Main > RefreshNote | 1049 | SCP.SCP0055_GET_SHIPMENT_ALLO_NOTE | MATCH | SP SCP0055_GET_SHIPMENT_ALLO_NOTE |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > RefreshGrid | 779 | SCP.SCP0055_GET_SHIPMENT_ALLO_PLAN | MATCH | SP SCP0055_GET_SHIPMENT_ALLO_PLAN |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > RefreshNote | 1049 | SCP.SCP0055_GET_SHIPMENT_ALLO_NOTE | MATCH | SP SCP0055_GET_SHIPMENT_ALLO_NOTE |
| button:SaveButton | SaveButton > SaveData_Main | 1274 | SCP.SCP0055_SAVE_SHIPMENT_ALLO_PLAN | MATCH | SP SCP0055_SAVE_SHIPMENT_ALLO_PLAN |
| event:this.Load | Form_Load > InitControls | 154 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 271 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| unreached:(진입점 미연결) | SCM_SYS_LOG_BATCH | 1431 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0055_GET_SHIPMENT_ALLO_NOTE | MATCH | 1 | SP SCP0055_GET_SHIPMENT_ALLO_NOTE | EXEC:SCP0055_GET_SHIPMENT_ALLO_NOTE, SELECT:SCM_SHIP_ALLO_REPORT |  |
| SCP.SCP0055_GET_SHIPMENT_ALLO_PLAN | MATCH | 1 | SP SCP0055_GET_SHIPMENT_ALLO_PLAN | EXEC:SCP0055_GET_SHIPMENT_ALLO_PLAN, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, SELECT:TEMP_PLAN, SELECT:SCP_PLAN_VERSION_V, INSERT:#TMP_SCP0055_PLAN_FG, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, INSERT:#TMP_SCP0055_PLAN_SEMI, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TMP_SCP0055_PLAN, SELECT:#TMP_SCP0055_PLAN_FG, SELECT:#TMP_SCP0055_PLAN_SEMI, INSERT:#TMP_SCP0055_PLAN_TOTAL, SELECT:#TMP_SCP0055_PLAN, SELECT:#TMP_SCP0055_PLAN_TOTAL, INSERT:#TMP_SCP0055_RESULT1, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SSP_ANL_SHIP_CONFIRM, INSERT:#TMP_SCP0055_RESULT2, INSERT:#TMP_SCP0055_RESULT11, SELECT:#TMP_SCP0055_RESULT1, INSERT:#TMP_SCP0055_RESULT22, SELECT:#TMP_SCP0055_RESULT2, INSERT:#TMP_SCP0055_RESULT3, SELECT:#TMP_SCP0055_RESULT11, SELECT:#TMP_SCP0055_RESULT22, INSERT:#TMP_SCP0055_PLAN_RESULT, SELECT:#TMP_SCP0055_RESULT3, SELECT:#TMP_SCP0055_PLAN_RESULT |  |
| SCP.SCP0055_SAVE_SHIPMENT_ALLO_PLAN | MATCH | 1 | SP SCP0055_SAVE_SHIPMENT_ALLO_PLAN | EXEC:SCP0055_SAVE_SHIPMENT_ALLO_PLAN, UPDATE:SCM_SHIP_ALLO_REPORT, INSERT:SCM_SHIP_ALLO_REPORT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| RefreshGrid | row | SITE_NAME, SITE_ID, EXTRA_SPEC, NICK_NAME, DEPT_ID, DEPT_NAME, YYYYMMDD, QTY |
| RefreshTeam | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpreadDateColumn:188, SetSpreadInit:401 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | RefreshOperationGroup:279, RefreshFromSite:295, RefreshFromSite:296, RefreshTeam:325, RefreshGapDate:337, RefreshPlanDate:346, CboPlanDate_SelectedIndexChanged:470, CboPlanType_SelectedIndexChanged:474 | CString.GetCheckedListValue | CODE |
| InitSpreadDateColumn | FindData_Main:579, FindData_Main:582 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| OnShown | OnShown:1458 | BaseForm.OnShown | NowGroupID, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:536 |
| this | Load | Form_Load | .ctor:123 |
| this.btnModel_ID | Click | btnModel_ID_Click | InitEvent:408 |
| this.btnNickName | Click | btnNickName_Click | InitEvent:409 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:410 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:411 |
| this.cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | InitEvent:412 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:414 |
| cboOperationGroup | SelectedIndexChanged | CboBizType_SelectedIndexChanged | InitEvent:415 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:416 |

## 6. 컨트롤 (59개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | lblCombo, lblCombo1, lblItemId, PlanDate, layoutControlItem4, lblBucket, layoutControlItem2, layoutControlItem8, layoutControlItem12, layoutControlItem3, layoutControlItem1, layoutControlItem5, layoutControlItem7, layoutControlItem6, layoutControlItem10 … |
| EmptySpaceItem | 14 | emptySpaceItem4, emptySpaceItem8, emptySpaceItem9, emptySpaceItem2, emptySpaceItem1, emptySpaceItem10, emptySpaceItem11, emptySpaceItem15, emptySpaceItem16, emptySpaceItem5, emptySpaceItem3, emptySpaceItem6, emptySpaceItem7, emptySpaceItem13 |
| UsrCombo | 6 | cboGapDate, cboCellTypeGr, cboOperationGroup, cboPlanDate, cboDivision, cboBucketType |
| UsrButton | 3 | usrButton1, btnModel_ID, btnNickName |
| UsrLabel | 2 | ulPlanType_Seq2, ulPlanType_Seq1 |
| UsrMonthPicker | 2 | umpMonthTo, umpMonthFrom |
| UsrMultiLineEditor | 2 | txtNickName, txtModel_ID |
| UsrCheckedList2 | 2 | clbFromSite, clbTeam |
| FpSpread | 2 | spdMain, spdGap |
| SheetView | 2 | spdMain_Sheet1, spdGap_Sheet1 |
| TabPage | 2 | tabPage1, tabPage2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| TabControl | 1 | tabControl1 |
| UsrCheckBox | 1 | chkFCST |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 22 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 6 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 36 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 190 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0055 | Shipment(Allo) Report | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment(Allo) Report
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpreadDateColumn:188, SetSheetHeaderColumn@SetSpreadInit:401
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 200 | 식 | AddNumColumn | {?dtCurrent.ToString("yy/MM")} | {?dtCurrent.ToString("yyMM")} | while(dtCurrent <= dtTo) ⟫ if((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) |
| InitSpreadDateColumn |  | 203 | 표시/라벨 변경 | SetColumnHeader | 0 |  | while(dtCurrent <= dtTo) ⟫ if((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) |
| InitSpreadDateColumn |  | 204 | 표시/라벨 변경 | SetColumnHeader | 1 |  | while(dtCurrent <= dtTo) ⟫ if((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) |
| InitSpreadDateColumn |  | 209 | 식 | AddNumColumn | {?dtCurrent.ToString("yy/MM")} | {?dtCurrent.ToString("yyMM")} | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ if((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 212 | 표시/라벨 변경 | SetColumnHeader | 0 |  | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ if((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 213 | 표시/라벨 변경 | SetColumnHeader | 1 |  | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ if((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 218 | 식 | AddNumColumn | {?dtCurrent.ToString("yy/MM")} | {?dtCurrent.ToString("yyMM")} | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ else!((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 221 | 표시/라벨 변경 | SetColumnHeader | 0 |  | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ else!((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 222 | 표시/라벨 변경 | SetColumnHeader | 1 |  | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ else!((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 225 | 식 | AddNumColumn | {?dtCurrent.ToString("yy/MM")} | {?dtCurrent.ToString("yyMM")} | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ else!((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 228 | 표시/라벨 변경 | SetColumnHeader | 0 |  | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ else!((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 229 | 표시/라벨 변경 | SetColumnHeader | 1 |  | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ else!((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 232 | 식 | AddNumColumn | {?dtCurrent.ToString("yy/MM")} | {?dtCurrent.ToString("yyMM")} | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ else!((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 235 | 표시/라벨 변경 | SetColumnHeader | 0 |  | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ else!((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 236 | 표시/라벨 변경 | SetColumnHeader | 1 |  | while(dtCurrent <= dtTo) ⟫ else!((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) ⟫ else!((dtCurrent.Year > dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month > dtBase.Month))) |
| InitSpreadDateColumn |  | 247 | 하드코딩 | AddNumColumn | SUBTOTAL | SUBTOTAL |  |
| InitSpreadDateColumn |  | 249 | 표시/라벨 변경 | SetColumnHeader | 0 |  |  |
| InitSpreadDateColumn |  | 254 | 하드코딩 | AddNumColumn | GAP | GAP |  |
| InitSpreadDateColumn |  | 256 | 표시/라벨 변경 | SetColumnHeader | 0 |  |  |
| InitSpreadDateColumn |  | 261 | 하드코딩 | AddTextColumn | 비고 | 비고 |  |
| InitSpreadDateColumn |  | 262 | 표시/라벨 변경 | SetColumnHeader | 0 |  |  |
| MergeGrid |  | 726 | 표시/라벨 변경 | set:Width | Width = {?svMain.Columns["0"].GetPreferredWidth() + 10} |  | for(i <= iColIdx_DEPT_NAME) |
| MergeGrid |  | 727 | 표시/라벨 변경 | set:Width | Width = {?svGap.Columns["0"].GetPreferredWidth() + 10} |  | for(i <= iColIdx_DEPT_NAME) |
| RefreshGrid |  | 983 | 표시/라벨 변경 | set:Width | Width = {?svView.Columns[iColIdx_SUB_TOTAL].GetPreferredWidth() + 10} |  | if(dsResult.Tables.Count >= 4) |
| RefreshGridGAP |  | 1136 | 표시/라벨 변경 | set:Width | Width = {?svMain.Columns[iColIdx_GAP].GetPreferredWidth() + 10} |  |  |
| InitializeComponent |  | 1139 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1140 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1141 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1142 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1255 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1256 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1257 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1258 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment(Allo) Report | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
