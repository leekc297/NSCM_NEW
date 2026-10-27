# SCP0122 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.csproj | 72 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\Properties\Settings.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.csproj | 31 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.csproj | 587 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.csproj | 336 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 321 | SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT | MATCH | SP SCP0122_GET_PLAN_ACTIVITY_MGMT |
| button:SaveButton | SaveButton > Save_Data > FindData_Main | 321 | SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT | MATCH | SP SCP0122_GET_PLAN_ACTIVITY_MGMT |
| button:SaveButton | SaveButton > Save_Data | 480 | SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT | MATCH | SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT |
| unreached:(진입점 미연결) | <field:dtProcessCdAll> | 47 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetPlanGroupByUserID | 155 | SCP.SCP0121_GET_SEARCH_INFO | MATCH | SP SCP0121_GET_SEARCH_INFO |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| SCP.SCP0121_GET_SEARCH_INFO | MATCH | 1 | SP SCP0121_GET_SEARCH_INFO | EXEC:SCP0121_GET_SEARCH_INFO, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, INSERT:#LINE_MASTER, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#OSP_PLANT_INFO, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:#LINE_MASTER, SELECT:#DIVISION_INFO, SELECT:SCP_MST_CAPA_LINE, SELECT:#OSP_PLANT_INFO, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_OPERATION_M_SN |  |
| SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT | MATCH | 1 | SP SCP0122_GET_PLAN_ACTIVITY_MGMT | EXEC:SCP0122_GET_PLAN_ACTIVITY_MGMT, SELECT:SCP_OPMZ_PLAN_GR_ACTV_M, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT | MATCH | 1 | SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT | EXEC:SCP0122_SAVE_PLAN_ACTIVITY_MGMT, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST, INSERT:SCP_OPMZ_PLAN_GR_ACTV_M, UPDATE:SCP_OPMZ_PLAN_GR_ACTV_M, DELETE:SCP_OPMZ_PLAN_GR_ACTV_M, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_OPMZ_PLAN_GR_ACTV_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetPlanGroupByUserID | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |
| SpdMain_ClipboardPasted | dtPlanGroup.Select().Where(c => c["NAME"].ToString() == siMain.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault() | CODE |
| SpdMain_ClipboardPasted | c | NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | RefreshPlanGroupByDivision:171, FindData_Main:308, FindData_Main:309, FindData_Main:310, Insert_Row:367 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumnSCP | SetSpreadInit:212 | SpreadInfo.SetSheetHeaderColumnSCP | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:98 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:217 |
| cboPlanGroup | SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | InitEvent:218 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:220 |
| this.spdMain | CellClick | spdMain_CellClick | InitEvent:221 |

## 6. 컨트롤 (15개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 3 | layoutControlItem2, layoutControlItem9, Division |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrComboBox | 2 | cboPlanGroup, cboProcess |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cboDivision |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 15 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 15 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 3 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0122 | Plan Activity Mgmt | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Plan Activity Mgmt
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumnSCP@SetSpreadInit:212

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 252 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 253 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 254 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 255 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Plan Activity Mgmt | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.


### FILE endpoints.csv (4 rows)
```csv
"variant","file","class","member","line","site_kind","kind","candidate","key","status","sp_or_sql","objects","via","detail"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","<field:dtProcessCdAll>","47","derived","biz","CommonData.CommonDataList [code=LookupCommon]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.LookupCommon:Type.LookupCommon] > Data.CallBizCommonData",""
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","GetPlanGroupByUserID","155","ctor","fox","SCP.SCP0121_GET_SEARCH_INFO","SCP.SCP0121_GET_SEARCH_INFO","MATCH","SP SCP0121_GET_SEARCH_INFO","EXEC:SCP0121_GET_SEARCH_INFO, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, INSERT:#LINE_MASTER, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#OSP_PLANT_INFO, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:#LINE_MASTER, SELECT:#DIVISION_INFO, SELECT:SCP_MST_CAPA_LINE, SELECT:#OSP_PLANT_INFO, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_OPERATION_M_SN","",""
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","FindData_Main","321","ctor","fox","SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT","SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT","MATCH","SP SCP0122_GET_PLAN_ACTIVITY_MGMT","EXEC:SCP0122_GET_PLAN_ACTIVITY_MGMT, SELECT:SCP_OPMZ_PLAN_GR_ACTV_M, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL","",""
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","Save_Data","480","ctor","fox","SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT","SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT","MATCH","SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT","EXEC:SCP0122_SAVE_PLAN_ACTIVITY_MGMT, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST, INSERT:SCP_OPMZ_PLAN_GR_ACTV_M, UPDATE:SCP_OPMZ_PLAN_GR_ACTV_M, DELETE:SCP_OPMZ_PLAN_GR_ACTV_M, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_OPMZ_PLAN_GR_ACTV_H","",""
```

### FILE flow.csv (5 rows)
```csv
"variant","file","class","entry_kind","entry","path","member","line","endpoint","status","sp_or_sql","objects"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","button","FindButton","FindButton > FindData_Main","FindData_Main","321","SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT","MATCH","SP SCP0122_GET_PLAN_ACTIVITY_MGMT","EXEC:SCP0122_GET_PLAN_ACTIVITY_MGMT, SELECT:SCP_OPMZ_PLAN_GR_ACTV_M, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","button","SaveButton","SaveButton > Save_Data","Save_Data","480","SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT","MATCH","SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT","EXEC:SCP0122_SAVE_PLAN_ACTIVITY_MGMT, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST, INSERT:SCP_OPMZ_PLAN_GR_ACTV_M, UPDATE:SCP_OPMZ_PLAN_GR_ACTV_M, DELETE:SCP_OPMZ_PLAN_GR_ACTV_M, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_OPMZ_PLAN_GR_ACTV_H"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","button","SaveButton","SaveButton > Save_Data > FindData_Main","FindData_Main","321","SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT","MATCH","SP SCP0122_GET_PLAN_ACTIVITY_MGMT","EXEC:SCP0122_GET_PLAN_ACTIVITY_MGMT, SELECT:SCP_OPMZ_PLAN_GR_ACTV_M, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","unreached","(진입점 미연결)","GetPlanGroupByUserID","GetPlanGroupByUserID","155","SCP.SCP0121_GET_SEARCH_INFO","MATCH","SP SCP0121_GET_SEARCH_INFO","EXEC:SCP0121_GET_SEARCH_INFO, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, INSERT:#LINE_MASTER, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#OSP_PLANT_INFO, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:#LINE_MASTER, SELECT:#DIVISION_INFO, SELECT:SCP_MST_CAPA_LINE, SELECT:#OSP_PLANT_INFO, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_OPERATION_M_SN"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","unreached","(진입점 미연결)","<field:dtProcessCdAll>","<field:dtProcessCdAll>","47","biz:CommonData.CommonDataList [code=LookupCommon]","BIZ_MATCH","",""
```

### FILE events.csv (5 rows)
```csv
"variant","file","class","member","line","target","event","handler","op"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt",".ctor","98","this","Load","Form_Load","+="
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","InitEvent","217","cboDivision","SelectedIndexChanged","ClbDivision_SelectedIndexChanged","+="
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","InitEvent","218","cboPlanGroup","SelectedIndexChanged","CboPlanGroup_SelectedIndexChanged","+="
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","InitEvent","220","this.spdMain","ComboSelChange","SpdMain_ComboSelChange","+="
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","InitEvent","221","this.spdMain","CellClick","spdMain_CellClick","+="
```

### FILE controls.csv (15 rows)
```csv
"variant","file","class","name","type","parent","line"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","usrLayoutControl1","GSCM.Windows.Forms.Controls.UsrLayoutControl","","33"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","layoutControlGroup1","DevExpress.XtraLayout.LayoutControlGroup","","34"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","usrConditionPanel1","GSCM.Windows.Forms.Controls.UsrConditionPanel","this","35"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","usrLayoutControl2","GSCM.Windows.Forms.Controls.UsrLayoutControl","usrConditionPanel1","36"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","cboPlanGroup","GSCM.Windows.Forms.Controls.UsrComboBox","usrLayoutControl2","37"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","cboProcess","GSCM.Windows.Forms.Controls.UsrComboBox","usrLayoutControl2","38"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","cboDivision","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","39"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","layoutControlGroup2","DevExpress.XtraLayout.LayoutControlGroup","","40"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","emptySpaceItem1","DevExpress.XtraLayout.EmptySpaceItem","","41"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","layoutControlItem2","DevExpress.XtraLayout.LayoutControlItem","","42"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","layoutControlItem9","DevExpress.XtraLayout.LayoutControlItem","","43"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","Division","DevExpress.XtraLayout.LayoutControlItem","","44"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","spdMain","FarPoint.Win.Spread.FpSpread","this","45"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","spdMain_Sheet1","FarPoint.Win.Spread.SheetView","","46"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","imageList1","System.Windows.Forms.ImageList","","47"
```

### FILE props.csv (25 rows)
```csv
"variant","file","class","member","line","target","prop","value"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","69","usrLayoutControl1","Dock","System.Windows.Forms.DockStyle.Fill"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","73","usrLayoutControl1","Size","new System.Drawing.Size(657, 184)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","82","layoutControlGroup1","Size","new System.Drawing.Size(657, 184)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","87","usrConditionPanel1","Dock","System.Windows.Forms.DockStyle.Top"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","91","usrConditionPanel1","Size","new System.Drawing.Size(1561, 98)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","93","usrConditionPanel1","UsrPanelType","GSCM.Windows.Forms.Controls.UsrConditionPanel.PanelType.HidePanel"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","102","usrLayoutControl2","Dock","System.Windows.Forms.DockStyle.Fill"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","107","usrLayoutControl2","Size","new System.Drawing.Size(1561, 98)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","109","usrLayoutControl2","Text","""usrLayoutControl2"""
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","119","cboPlanGroup","Size","new System.Drawing.Size(285, 26)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","130","cboProcess","Size","new System.Drawing.Size(332, 26)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","166","cboDivision","Size","new System.Drawing.Size(311, 26)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","181","layoutControlGroup2","Size","new System.Drawing.Size(1561, 98)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","189","emptySpaceItem1","Size","new System.Drawing.Size(383, 68)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","194","layoutControlItem2","Control","this.cboProcess"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","198","layoutControlItem2","Size","new System.Drawing.Size(382, 68)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","199","layoutControlItem2","Text","""Process"""
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","206","layoutControlItem9","Control","this.cboPlanGroup"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","209","layoutControlItem9","Size","new System.Drawing.Size(383, 68)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","210","layoutControlItem9","Text","""Plan Group"""
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","217","Division","Control","this.cboDivision"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","221","Division","Size","new System.Drawing.Size(383, 68)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","229","spdMain","Dock","System.Windows.Forms.DockStyle.Fill"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","235","spdMain","Size","new System.Drawing.Size(1561, 766)"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","293","this","Text","""SCP0122_PlanActivityMgmt"""
```

### FILE grid_effective.csv (15 rows)
```csv
"sheet","sheet_rule","column","label","source","40","81","81_HD","81_HG","81_HM","81_ST","81_UC","82","EE","EE_HD","EE_HG","EE_HM","EE_ST","EE_UC"
"Plan Activity Mgmt","META+코드연결","AUTO_YN","Auto Flag","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","CONFIRM_YN","Confirm Flag","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","DIVISION_ID","Div.","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","LINK_UI_TYPE","Link UI Type","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","OPMZ_ACTV_CD","Activity Code","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","OPMZ_ACTV_NAME","Activity Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","OPMZ_ACTV_SEQ","Act. Seq","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","OPMZ_PLAN_GR_ID","Plan Group ID","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","OPMZ_PLAN_GR_NAME","Plan Group","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","OPMZ_PRS_CD","Process CD","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","OPMZ_PRS_NAME","Process","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","OPTION_YN","Option Flag","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","PRE_OPMZ_ACTV_CD","PRE_OPMZ_ACTV_CD","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","PRE_OPMZ_ACTV_SEQ","PRE_OPMZ_ACTV_SEQ","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plan Activity Mgmt","META+코드연결","PROGRAM_NAME","Program Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
```

### FILE grid_code.csv (14 rows)
```csv
"variant","file","class","member","line","sheet_hint","kind","api","source","header","field","columns","args","arg_names","conditions","raw"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","CreateSpread","185","Plan Activity Mgmt","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Plan Activity Mgmt ¦ Plan Activity Mgmt ¦ 1 ¦ 1 ¦ 30","","","spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","CreateSpread","186","Plan Activity Mgmt","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?spdMain.ActiveSheetIndex}","","","spdMain.Name ¦ spdMain.ActiveSheetIndex"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","CreateSpread","188","Plan Activity Mgmt","SHEET","ChangeSheet","EXPR","","","","","","",""
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","InitSpread","197","0","SHEET","ChangeSheet","EXPR","","","","0","","","0"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","InitSpread","198","Plan Activity Mgmt","SHEET","ChangeActiveSheet","HARDCODED","","","","Plan Activity Mgmt","sSheetName","","SpdSheet.shtMain"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","SetSpreadInit","205","0","SHEET","ChangeSheet","EXPR","","","","0","","if(sheetName.Equals(""Plan Activity Mgmt""))","0"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","SetSpreadInit","206","0","SHEET","InitSheet","EXPR","","","","0","","if(sheetName.Equals(""Plan Activity Mgmt""))","0"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","SetSpreadInit","212","0","META_BUILD","SetSheetHeaderColumnSCP","EXPR","","","","{p:siObj} ¦ 1 ¦ {?false} ¦ ","siObj,iColumnHeaderRowCount,chkAll,datePreColumnName","","siObj ¦ 1 ¦ false ¦ """""
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","EditButton","275","","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?spdMain.ActiveSheetIndex}","","if(spdMain != null)","spdMain.Name ¦ spdMain.ActiveSheetIndex"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","FindData_Main","306","Plan Activity Mgmt","SHEET","ChangeSheet","HARDCODED","","","","Plan Activity Mgmt","","","SpdSheet.shtMain"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","252","","OVERRIDE","set:HorizontalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellHorizontalAlignment.General}","HorizontalAlignment","","FarPoint.Win.Spread.CellHorizontalAlignment.General"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","253","","OVERRIDE","set:NoteIndicatorColor","EXPR","","","","{?System.Drawing.Color.Red}","NoteIndicatorColor","","System.Drawing.Color.Red"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","254","","OVERRIDE","set:Parent","HARDCODED","","","","ColumnHeaderDefaultEnhanced","Parent","","""ColumnHeaderDefaultEnhanced"""
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.Designer.cs","SCP0122_PlanActivityMgmt","InitializeComponent","255","","OVERRIDE","set:VerticalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellVerticalAlignment.General}","VerticalAlignment","","FarPoint.Win.Spread.CellVerticalAlignment.General"
```

### FILE meta_reads.csv (3 rows)
```csv
"variant","file","class","member","line","receiver","column","via"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","GetPlanGroupByUserID","143","TheOne.Security.FoxUserInfoContext.Current","NowGroupID","[]"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","SpdMain_ClipboardPasted","574","dtPlanGroup.Select().Where(c => c[""NAME""].ToString() == siMain.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault()","CODE","[]"
"current(sln미등록)","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs","SCP0122_PlanActivityMgmt","SpdMain_ClipboardPasted","574","c","NAME","[]"
```

### FILE commented_calls.csv (0 rows)
```csv
"variant","file","line","kind","candidate","key","status"
```
