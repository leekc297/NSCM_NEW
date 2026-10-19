# SCM0004 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\SCM0004MOD_UI_Category_Setup.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\SCM0004MOD_UI_Category_Setup.UIL\SCM0004MOD_UI_Category_Setup.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\SCM0004MOD_UI_Category_Setup.UIL\SCM0004MOD_UI_Category_Setup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\SCM0004MOD_UI_Category_Setup.UIL\SCM0004MOD_UI_Category_Setup.UIL.csproj | 749 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\SCM0004MOD_UI_Category_Setup.UIL\SCM0004MOD_UI_Category_Setup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\SCM0004MOD_UI_Category_Setup.UIL\SCM0004MOD_UI_Category_Setup.UIL.csproj | 456 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\SCM0004MOD_UI_Category_Setup.UIL\TestCode.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\SCM0004MOD_UI_Category_Setup.UIL\SCM0004MOD_UI_Category_Setup.UIL.csproj | 48 |
| shared | 06.UIL\GSCM.SCM.Master.UIL\SCM0004_UICategorySetup.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 806 |
| shared | 06.UIL\GSCM.SCM.Master.UIL\SCM0004_UICategorySetup.Designer.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 456 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > Find_Data > Find_Column | 345 | SCM.GET_UI_CATEGORY_SETUP_COLUMN_EX | MATCH | [statement] foxquery_sql\SCM.GET_UI_CATEGORY_SETUP_COLUMN_EX.sql |
| button:FindButton | FindButton > Find_Data > Find_Column | 361 | SCM.SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | MATCH | SP SCM0004_GET_UI_CATEGORY_SETUP_COLUMN |
| button:FindButton | FindButton > Find_Data > Find_Measure | 385 | SCM.SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | MATCH | SP SCM0004_GET_UI_CATEGORY_SETUP_MEASURE |
| button:FindButton | FindButton > Find_Data > Find_Measure | 401 | SCM.SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | MATCH | SP SCM0004_GET_UI_CATEGORY_SETUP_MEASURE |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Column | 345 | SCM.GET_UI_CATEGORY_SETUP_COLUMN_EX | MATCH | [statement] foxquery_sql\SCM.GET_UI_CATEGORY_SETUP_COLUMN_EX.sql |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Column | 361 | SCM.SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | MATCH | SP SCM0004_GET_UI_CATEGORY_SETUP_COLUMN |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Measure | 385 | SCM.SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | MATCH | SP SCM0004_GET_UI_CATEGORY_SETUP_MEASURE |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Measure | 401 | SCM.SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | MATCH | SP SCM0004_GET_UI_CATEGORY_SETUP_MEASURE |
| button:SaveButton | SaveButton > Save_Data | 546 | SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN | MATCH | SP SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN |
| button:SaveButton | SaveButton > Save_Data | 558 | SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN | MATCH | SP SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN |
| button:SaveButton | SaveButton > Save_Data | 681 | SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE | MATCH | SP SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE |
| button:SaveButton | SaveButton > Save_Data | 726 | SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE | MATCH | SP SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE |
| event:this.Load | Form_Load > InitControls | 151 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 154 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 156 | biz:CommonData.CommonDataList [code=DATA_SORT_METHOD] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 157 | biz:CommonData.CommonDataList [code=DEFAULT_FLAG] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 159 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 159 | biz:CommonData.CommonDataList [code=CELL_CONTROL_OBJECT_TYPE_CODE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 160 | biz:CommonData.CommonDataList [code=HORIZONTAL_ALIGN_CODE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 162 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 164 | biz:CommonData.CommonDataList [code=DATA_SORT_METHOD] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 165 | biz:CommonData.CommonDataList [code=DEFAULT_FLAG] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 167 | biz:CommonData.CommonDataList [code=CELL_CONTROL_OBJECT_TYPE_CODE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 168 | biz:CommonData.CommonDataList [code=HORIZONTAL_ALIGN_CODE] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CELL_CONTROL_OBJECT_TYPE_CODE] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DATA_SORT_METHOD] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DEFAULT_FLAG] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=HORIZONTAL_ALIGN_CODE] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 4 |  |  |  |
| SCM.GET_UI_CATEGORY_SETUP_COLUMN_EX | MATCH | 1 | [statement] foxquery_sql\SCM.GET_UI_CATEGORY_SETUP_COLUMN_EX.sql | SELECT:SCM_MST_SHEET_COLUMNS |  |
| SCM.SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | MATCH | 1 | SP SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | EXEC:SCM0004_GET_UI_CATEGORY_SETUP_COLUMN, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:TB_FX_MENUITEMINFO |  |
| SCM.SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | MATCH | 2 | SP SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | EXEC:SCM0004_GET_UI_CATEGORY_SETUP_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, SELECT:TB_FX_MENUITEMINFO |  |
| SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN | MATCH | 2 | SP SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN | EXEC:SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCM_MST_SHEET_COLUMNS, INSERT:SCM_SYS_LOG_BATCH |  |
| SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE | MATCH | 2 | SP SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE | EXEC:SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCM_MST_SHEET_MEASURE, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:162, InitControls:154 | UsrComboBox.DataBind | CODE, NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:140 |
| this | Load | Form_Load | .ctor:132 |

## 6. 컨트롤 (38개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem6 |
| UsrTextBox | 8 | txtColumnLavelName, txtColumnName, txtSheetName, txtProgramID, txtColumnLavelName, txtColumnName, txtSheetName, txtProgramID |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem1, emptySpaceItem2 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrComboBox | 2 | cboValid, cboValid |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 28 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Column, Measure

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 212 | 하드코딩 | AddTextColumn | ProgramID*  | Program_ID | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 213 | 하드코딩 | AddTextColumn | Sheet Name* | Sheet_Name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 214 | 하드코딩 | AddTextColumn | Column Name*  | Column_Name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 215 | 하드코딩 | AddTextColumn | Column Label Name* | column_label_name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 217 | 하드코딩 | AddTextColumn | Column param7 | attribute7 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 218 | 하드코딩 | AddTextColumn | Column param8 | attribute8 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 219 | 하드코딩 | AddTextColumn | Column param9 | attribute9 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 221 | 하드코딩 | AddTextColumn | Sort Order No* | sort_order_no | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 222 | 하드코딩 | AddComboColumn | Data Sort Method | data_sort_method_code | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 223 | 하드코딩 | AddTextColumn | Small Label | small_class_label_name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 224 | 하드코딩 | AddTextColumn | Large Label | large_class_label_name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 225 | 하드코딩 | AddTextColumn | Fixed | fixed_flag | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 226 | 하드코딩 | AddTextColumn | Column Width* | column_width | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 227 | 하드코딩 | AddComboColumn | Cell Object | cell_control_object_type_code | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 228 | 하드코딩 | AddTextColumn | Cell Combo Data Type | CELL_COMBO_DATA_TYPE | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 229 | 하드코딩 | AddTextColumn | Data Scale Num | data_scale_number | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 230 | 하드코딩 | AddTextColumn | Data Max Length | data_max_length | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 231 | 하드코딩 | AddComboColumn | Horizontal Align* | horizontal_align_code | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 232 | 하드코딩 | AddTextColumn | Uppercase Apply | uppercase_apply_flag | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 233 | 하드코딩 | AddComboColumn | Visible* | visible_flag | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 234 | 하드코딩 | AddComboColumn | User Visible Flag | attribute6 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 235 | 하드코딩 | AddComboColumn | Default | default_flag | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 236 | 하드코딩 | AddComboColumn | User Selected Flag | USER_SELECTABLE_FLAG | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 237 | 하드코딩 | AddTextColumn | Division | DIVISION_ID | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 238 | 하드코딩 | AddComboColumn | Valid* | valid_yn | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 239 | 하드코딩 | AddTextColumn | Column param1 | attribute1 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 240 | 하드코딩 | AddTextColumn | Column param2 | attribute2 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 241 | 하드코딩 | AddTextColumn | Column param3 | attribute3 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 242 | 하드코딩 | AddTextColumn | Column param4 | attribute4 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 243 | 하드코딩 | AddTextColumn | Column param5 | attribute5 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 246 | 하드코딩 | AddTextColumn | Created By | Created_By | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 247 | 하드코딩 | AddDateTimeColumn | Creation Date | Creation_Date | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 248 | 하드코딩 | AddTextColumn | Last Updated By | Last_Updated_By | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 249 | 하드코딩 | AddDateTimeColumn | Last Update Date | Last_Update_Date | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 258 | 하드코딩 | AddTextColumn | ProgramID*  | program_id | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 259 | 하드코딩 | AddTextColumn | Sheet Name* | sheet_name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 260 | 하드코딩 | AddTextColumn | Column Name*  | Column_Name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 261 | 하드코딩 | AddTextColumn | Column Label Name* | column_label_name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 262 | 하드코딩 | AddTextColumn | Sort Order No* | sort_order_no | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 263 | 하드코딩 | AddTextColumn | Small Label | small_class_label_name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 264 | 하드코딩 | AddTextColumn | Large Label | large_class_label_name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 266 | 하드코딩 | AddTextColumn | Measure Color | MEASURE_COLOR | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 268 | 하드코딩 | AddComboColumn | Default Flag | default_flag | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 269 | 하드코딩 | AddComboColumn | User Selected Flag | USER_SELECTABLE_FLAG | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 271 | 하드코딩 | AddTextColumn | Division | DIVISION_ID | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 272 | 하드코딩 | AddComboColumn | Valid* | valid_yn | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 273 | 하드코딩 | AddTextColumn | Created By | created_by | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 274 | 하드코딩 | AddDateTimeColumn | Creation Date | creation_date | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 275 | 하드코딩 | AddTextColumn | Last Updated By | last_updated_by | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 276 | 하드코딩 | AddDateTimeColumn | Last Update Date | last_update_date | if(spreadInfo.SheetName == "Measure") |
| InitializeComponent |  | 375 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 376 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 377 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 378 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 220 | 하드코딩 | AddTextColumn | ProgramID*  | Program_ID | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 221 | 하드코딩 | AddTextColumn | Program Name  | Program_Name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 222 | 하드코딩 | AddTextColumn | Sheet Name* | Sheet_Name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 223 | 하드코딩 | AddTextColumn | Column Name*  | Column_Name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 224 | 하드코딩 | AddTextColumn | Column Label Name* | column_label_name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 225 | 하드코딩 | AddTextColumn | Sort Order No* | sort_order_no | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 226 | 하드코딩 | AddComboColumn | Data Sort Method | data_sort_method_code | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 227 | 하드코딩 | AddTextColumn | Small Label | small_class_label_name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 228 | 하드코딩 | AddTextColumn | Large Label | large_class_label_name | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 229 | 하드코딩 | AddTextColumn | Fixed | fixed_flag | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 230 | 하드코딩 | AddTextColumn | Column Width* | column_width | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 231 | 하드코딩 | AddComboColumn | Cell Object | cell_control_object_type_code | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 232 | 하드코딩 | AddTextColumn | Cell Combo Data Type | CELL_COMBO_DATA_TYPE | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 233 | 하드코딩 | AddTextColumn | Data Scale Num | data_scale_number | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 234 | 하드코딩 | AddTextColumn | Data Max Length | data_max_length | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 235 | 하드코딩 | AddComboColumn | Horizontal Align* | horizontal_align_code | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 236 | 하드코딩 | AddTextColumn | Uppercase Apply | uppercase_apply_flag | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 237 | 하드코딩 | AddComboColumn | Visible* | visible_flag | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 238 | 하드코딩 | AddComboColumn | User Visible Flag | attribute6 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 239 | 하드코딩 | AddComboColumn | Default | default_flag | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 240 | 하드코딩 | AddComboColumn | User Selected Flag | USER_SELECTABLE_FLAG | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 241 | 하드코딩 | AddTextColumn | Division | DIVISION_ID | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 242 | 하드코딩 | AddComboColumn | Valid* | valid_yn | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 243 | 하드코딩 | AddTextColumn | Column param1 | attribute1 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 244 | 하드코딩 | AddTextColumn | Column param2 | attribute2 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 245 | 하드코딩 | AddTextColumn | Column param3 | attribute3 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 246 | 하드코딩 | AddTextColumn | Column param4 | attribute4 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 247 | 하드코딩 | AddTextColumn | Column param5 | attribute5 | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 248 | 하드코딩 | AddTextColumn | Created By | Created_By | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 249 | 하드코딩 | AddDateTimeColumn | Creation Date | Creation_Date | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 250 | 하드코딩 | AddTextColumn | Last Updated By | Last_Updated_By | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 251 | 하드코딩 | AddDateTimeColumn | Last Update Date | Last_Update_Date | if(spreadInfo.SheetName == "Column") |
| InitSpread |  | 260 | 하드코딩 | AddTextColumn | ProgramID*  | program_id | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 261 | 하드코딩 | AddTextColumn | Program Name  | Program_Name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 262 | 하드코딩 | AddTextColumn | Sheet Name* | sheet_name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 263 | 하드코딩 | AddTextColumn | Column Name*  | Column_Name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 264 | 하드코딩 | AddTextColumn | Column Label Name* | column_label_name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 265 | 하드코딩 | AddTextColumn | Sort Order No* | sort_order_no | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 266 | 하드코딩 | AddTextColumn | Small Label | small_class_label_name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 267 | 하드코딩 | AddTextColumn | Large Label | large_class_label_name | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 269 | 하드코딩 | AddTextColumn | Measure Color | MEASURE_COLOR | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 271 | 하드코딩 | AddComboColumn | Default Flag | default_flag | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 272 | 하드코딩 | AddComboColumn | User Selected Flag | USER_SELECTABLE_FLAG | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 274 | 하드코딩 | AddTextColumn | Division | DIVISION_ID | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 275 | 하드코딩 | AddComboColumn | Valid* | valid_yn | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 278 | 하드코딩 | AddTextColumn | ATTRIBUTE1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 279 | 하드코딩 | AddTextColumn | ATTRIBUTE2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 280 | 하드코딩 | AddTextColumn | ATTRIBUTE4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 281 | 하드코딩 | AddTextColumn | Result Mapping (ATTRIBUTE5) | ATTRIBUTE5 | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 282 | 하드코딩 | AddTextColumn | Plan Mapping (ATTRIBUTE6) | ATTRIBUTE6 | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 283 | 하드코딩 | AddComboColumn | Section Create YN (ATTRIBUTE7) | ATTRIBUTE7 | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 284 | 하드코딩 | AddTextColumn | ATTRIBUTE8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 285 | 하드코딩 | AddTextColumn | ATTRIBUTE9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 286 | 하드코딩 | AddTextColumn | ATTRIBUTE10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 289 | 하드코딩 | AddTextColumn | Created By | created_by | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 290 | 하드코딩 | AddDateTimeColumn | Creation Date | creation_date | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 291 | 하드코딩 | AddTextColumn | Last Updated By | last_updated_by | if(spreadInfo.SheetName == "Measure") |
| InitSpread |  | 292 | 하드코딩 | AddDateTimeColumn | Last Update Date | last_update_date | if(spreadInfo.SheetName == "Measure") |
| InitializeComponent |  | 375 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 376 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 377 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 378 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Column | 코드 하드코딩 전용(메타 없음) | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 |
| Measure | 코드 하드코딩 전용(메타 없음) | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
