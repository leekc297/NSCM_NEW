# FP88888 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Common\FP88888_FP_Log_Vue.UIL\FP88888_FP_Log_Vue.cs | 06.UIL\GSCM.FP.Forms.UIL\Common\FP88888_FP_Log_Vue.UIL\FP88888_FP_Log_Vue.UIL.csproj | 2496 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Common\FP88888_FP_Log_Vue.UIL\FP88888_FP_Log_Vue.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Common\FP88888_FP_Log_Vue.UIL\FP88888_FP_Log_Vue.UIL.csproj | 889 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Common\FP88888_FP_Log_Vue.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Common\FP88888_FP_Log_Vue.UIL\FP88888_FP_Log_Vue.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > UIFindData | 1876 | biz:FPCommonDataBLL.RunProcedureCustomTable [procedure=test_of_custom_table] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData | 1876 | LogVue#test_of_custom_table | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > UIFindData | 1876 | biz:FPCommonDataBLL.GeneralRunProcedureCustomTable [procedure=test_of_custom_table] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData | 1876 | FP\Common\LogVue#test_of_custom_table | MATCH_PATTERN | SP FP00TEST_FIND_TEST |
| button:FindButton | FindButton > UIFindData > FindMainData | 2072 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_menu_log] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 2072 | FP\Common\LogVue#list_menu_log | MATCH | [sql] foxquery_sql\FP_Common_LogVue_list_menu_log.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 2157 | MenuContainer.UP_FX_GetMenuExecutionLog | MATCH | [statement] foxquery_sql\MenuContainer.UP_FX_GetMenuExecutionLog.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 2217 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_log] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 2217 | FP\Common\LogVue#list_log | MATCH | [sql] foxquery_sql\FP_Common_LogVue_list_log.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2072 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_menu_log] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2072 | FP\Common\LogVue#list_menu_log | MATCH | [sql] foxquery_sql\FP_Common_LogVue_list_menu_log.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2157 | MenuContainer.UP_FX_GetMenuExecutionLog | MATCH | [statement] foxquery_sql\MenuContainer.UP_FX_GetMenuExecutionLog.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2217 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_log] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2217 | FP\Common\LogVue#list_log | MATCH | [sql] foxquery_sql\FP_Common_LogVue_list_log.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 85 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ApplyAmendCalendarCondition | 2447 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ApplyAmendCalendarCondition | 2447 | FP\Common\AmendCommon#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_WeekCnt.sql |
| unreached:(진입점 미연결) | ApplyAmendCalendarCondition | 2448 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ApplyAmendCalendarCondition | 2448 | FP\Common\AmendCommon#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_DateMap.sql |
| unreached:(진입점 미연결) | ApplyAmendCalendarCondition | 2449 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ApplyAmendCalendarCondition | 2449 | FP\Common\AmendCommon#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_MonthCnt.sql |
| unreached:(진입점 미연결) | ApplyAmendCalendarCondition | 2450 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ApplyAmendCalendarCondition | 2450 | FP\Common\AmendCommon#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_BukInfo.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_log] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_menu_log] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedureCustomTable [procedure=test_of_custom_table] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.RunProcedureCustomTable [procedure=test_of_custom_table] | BIZ_MATCH | 1 |  |  |  |
| FP\Common\AmendCommon#find_BukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendCommon_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\AmendCommon#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendCommon_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\AmendCommon#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendCommon_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\AmendCommon#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendCommon_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\LogVue#list_log | MATCH | 1 | [sql] foxquery_sql\FP_Common_LogVue_list_log.sql | SELECT:TH_UIS_SQL_LOG |  |
| FP\Common\LogVue#list_menu_log | MATCH | 1 | [sql] foxquery_sql\FP_Common_LogVue_list_menu_log.sql | SELECT:TB_FX_MENUCONNECT, SELECT:TB_FX_MENUITEMINFO, SELECT:TB_FX_PROGRAMINFO, SELECT:MENU |  |
| FP\Common\LogVue#test_of_custom_table | MATCH_PATTERN | 1 | SP FP00TEST_FIND_TEST | EXEC:FP00TEST_FIND_TEST | ⚠ DB에 SP 없음 |
| LogVue#test_of_custom_table | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| MenuContainer.UP_FX_GetMenuExecutionLog | MATCH | 1 | [statement] foxquery_sql\MenuContainer.UP_FX_GetMenuExecutionLog.sql | SELECT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO, CATE_INFO, DAY2_WEEK_MONTH, CURR_DATE_COL |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_uom, chk_inqty, chk_outqty, chk_mpp_inqty, chk_mpp_outqty, chk_wpp_inqty, chk_wpp_outqty, chk_result, chk_gap, chk_cut, chk_cell, chk_memo, chk_offtime, chk_total, chk_wpp_inqty_tot, chk_wpp_outqty_tot, chk_mpp_inqty_tot, chk_mpp_outqty_tot, chk_inqty_tot, chk_outqty_tot, chk_result_tot, chk_gap_tot, chk_cut_tot, chk_subTotal |
| CreateFilterDataSet | x | _MM_ |
| FindMainData | param | FROM_DATE, TO_DATE, INSERT_USER, INSERT_FROM, INSERT_TO, PROG_ID, JOB_TYPE, LOG_TYPE |
| GetBasisTime | dtPeriod.Rows[0] | BASIS_TIME |
| InitControls | dr | CODE, NAME |
| InitSpread | row | COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE |
| RefreshHeader | row | DATA_TYPE, OPERATION_ID, CATEGORY_ID |
| SetInitMemo | row | CATEGORY_ID, DATA_TYPE, OPERATION_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE |
| SetInitMemo | each_row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE |
| Sheet_SelectionRangeChanging | selected | LOG_TYPE, JOB_TYPE, PROG_ID, ATTRIBUTE1, QUERY_ID, QUERY_VALUE, PARAM_VALUE, INST_SEQ, QUERY_SEQ, SESSION_ID, INSERT_TIME |
| Sheet_SelectionRangeChanging | query_set[i] | QUERY_VALUE |
| Sheet_SelectionRangeChanging | rel_rows[i] | QUERY_VALUE |
| Sheet_SelectionRangeChanging | param_set[i] | PARAM_VALUE |
| Sheet_SelectionRangeChanging | ParamValue2 | in_columns : , in_row :  |
| Sheet_SelectionRangeChanging | ParamValue | in_columns, in_row |
| UIFindData | row | p_division_id |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetFilter | GetBasisTime:861 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetMeasure | CheckAndGetMeasure:970 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetRowVisibleOnMeasureDatatypeCategory | CreateFilterDataSet:1835 | MeasureService.SetRowVisibleOnMeasureDatatypeCategory | CATEGORY_ID, DATA_TYPE, MEASURE_ID, _MM_ |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1836 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| GetCheckedListValue | FindMainData:2207, FindMainData:2208 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:114 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1483 |
| sheet | CellDataChanged | Sheet_CellDataChanged | FindMainData:2082 |
| sheet | BeforeCellEdit | Sheet_BeforeCellEdit | FindMainData:2083 |
| sheet | BeforeCellKeyDown | Sheet_BeforeCellKeyDown | FindMainData:2084 |
| sheet | CellMouseDown | Sheet_CellMouseDown | FindMainData:2085 |
| sheet | CellDataChanged | Sheet_CellDataChanged | FindMainData:2087 |
| sheet | BeforeCellEdit | Sheet_BeforeCellEdit | FindMainData:2088 |
| sheet | BeforeCellKeyDown | Sheet_BeforeCellKeyDown | FindMainData:2089 |
| sheet | CellMouseDown | Sheet_CellMouseDown | FindMainData:2090 |
| sheet | CellDataChanged | Sheet_CellDataChanged | FindMainData:2239 |
| sheet | SelectionRangeChanged | Sheet_SelectionRangeChanging | FindMainData:2240 |
| sheet | BeforeCellEdit | Sheet_BeforeCellEdit | FindMainData:2241 |
| sheet | BeforeCellKeyDown | Sheet_BeforeCellKeyDown | FindMainData:2242 |
| sheet | CellMouseDown | Sheet_CellMouseDown | FindMainData:2243 |
| sheet | CellDataChanged | Sheet_CellDataChanged | FindMainData:2245 |
| sheet | SelectionRangeChanged | Sheet_SelectionRangeChanging | FindMainData:2246 |
| sheet | BeforeCellEdit | Sheet_BeforeCellEdit | FindMainData:2247 |
| sheet | BeforeCellKeyDown | Sheet_BeforeCellKeyDown | FindMainData:2248 |
| sheet | CellMouseDown | Sheet_CellMouseDown | FindMainData:2249 |
| this.rgFpLog | ActionPerformed | rgFpLog_ActionPerformed | InitializeComponent:513 |
| this.rgFpLog | BindingContextChanged | rgFpLog_BindingContextChanged | InitializeComponent:514 |
| this.rgFpLog | Click | rgFpLog_Click | InitializeComponent:515 |

## 6. 컨트롤 (42개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 5 | layoutControlItem17, layoutControlItem11, layoutControlItem1, layoutControlItem2, layoutControlItem3 |
| Panel | 5 | menuPanel, panel2, panel4, panel3, panel1 |
| TabPage | 4 | tabPage1, tabPage3, pageMenu, tabPage2 |
| ReoGridControl | 3 | rgFpLog, rgScmLog, rgMenuUsage |
| TextBox | 3 | txtInfoC, txtInfoB, txtInfoA |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 2 | cmbLog, cmbJob |
| UsrTextBox | 2 | txtProgID, edt_user_name |
| SplitContainer | 2 | splitter, splitContainer1 |
| RichTextBox | 2 | txtSqlLog, txtParamLog |
| FpSpread | 2 | spdEdit, fpSpread1 |
| SheetView | 2 | spdEdit_Sheet1, fpSpread1_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker2 | 1 | drpPeriod |
| UsrButton | 1 | usrButton2 |
| TabControl | 1 | tabSpread |
| Label | 1 | label1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (6건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1876 | UIFindData | LogVue#test_of_custom_table | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |
| 2447 | ApplyAmendCalendarCondition | FP\{?default:part_service}\AmendCommon#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2448 | ApplyAmendCalendarCondition | FP\{?default:part_service}\AmendCommon#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2449 | ApplyAmendCalendarCondition | FP\{?default:part_service}\AmendCommon#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2450 | ApplyAmendCalendarCondition | FP\{?default:part_service}\AmendCommon#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1876 | UIFindData | FP\{?default:part_service}\LogVue#test_of_custom_table | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 20 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 4 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2369 | MenuContainer.UP_FX_GetMenuExecutionLog | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP88888 | Log | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(행 존재, 생성 호출 미발견)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 912 | 표시/라벨 변경 | set:DataColumn | DataColumn = {?row["COLUMN_NAME"].SafeString()} |  | if(dtColumns.Good()) ⟫ foreach(row in dtColumns.Rows) |
| InitSpread |  | 913 | 표시/라벨 변경 | set:Text | Text = {?row["COLUMN_LABEL_NAME"].SafeString()} |  | if(dtColumns.Good()) ⟫ foreach(row in dtColumns.Rows) |
| InitSpread |  | 914 | 표시/라벨 변경 | set:Width | Width = {?(ushort)row["COLUMN_WIDTH"].SafeZeroInt()} |  | if(dtColumns.Good()) ⟫ foreach(row in dtColumns.Rows) |
| InitSpread |  | 915 | 표시/라벨 변경 | set:IsAutoWidth | IsAutoWidth = {?false} |  | if(dtColumns.Good()) ⟫ foreach(row in dtColumns.Rows) |
| InitSpread |  | 920 | 표시/라벨 변경 | set:DataType | DataType = {?FPDataType.FPDate} |  | if(dtColumns.Good()) ⟫ foreach(row in dtColumns.Rows) ⟫ switch(type_string.ToUpper())case "FPDATE" |
| InitSpread |  | 923 | 표시/라벨 변경 | set:DataType | DataType = {?FPDataType.FPDateTime} |  | if(dtColumns.Good()) ⟫ foreach(row in dtColumns.Rows) ⟫ switch(type_string.ToUpper())case "FPDATETIME" |
| InitSpread |  | 927 | 표시/라벨 변경 | set:DataType | DataType = {?FPDataType.FPText} |  | if(dtColumns.Good()) ⟫ foreach(row in dtColumns.Rows) ⟫ switch(type_string.ToUpper())case "FPTEXTBOX" |
| InitSpread |  | 933 | 표시/라벨 변경 | set:IsDataSourceColumn | IsDataSourceColumn = {?true} |  | if(dtColumns.Good()) |
| InitializeComponent |  | 713 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 714 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 715 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 716 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Log | 메타 정의만, 코드 미참조(미사용 가능) | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
