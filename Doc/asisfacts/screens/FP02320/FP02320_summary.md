# FP02320 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02320_Pancake_Master.UIL\FP02320_Pancake_Master.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02320_Pancake_Master.UIL\FP02320_Pancake_Master.UIL.csproj | 1594 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02320_Pancake_Master.UIL\FP02320_Pancake_Master.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02320_Pancake_Master.UIL\FP02320_Pancake_Master.UIL.csproj | 946 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02320_Pancake_Master.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02320_Pancake_Master.UIL\FP02320_Pancake_Master.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02320_Pancake_Master.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02320_Pancake_Master.UIL\FP02320_Pancake_Master.UIL.csproj | 84 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP02320_Pancake_Master.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1594 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP02320_Pancake_Master.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 946 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 1574 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 1574 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 1201 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 1201 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1574 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1574 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 1574 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 1574 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| button:FindButton | FindButton > Find_Data > Find_Data_Execute | 633 | FP_Master.PR_UI_FP02320_PANCAKE_MASTER | MATCH | SP PR_UI_FP02320_PANCAKE_MASTER |
| event:popSql.OnSql | RunSqlSource > Find_Data_Execute | 633 | FP_Master.PR_UI_FP02320_PANCAKE_MASTER | MATCH | SP PR_UI_FP02320_PANCAKE_MASTER |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Execute | 633 | FP_Master.PR_UI_FP02320_PANCAKE_MASTER | MATCH | SP PR_UI_FP02320_PANCAKE_MASTER |
| button:SaveButton | SaveButton > Save_Data | 820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_insertValid] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data | 820 | FP\Common\FP02320_Pancake_Master#find_insertValid | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP02320_Pancake_Master_find_insertValid.sql |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Execute | 977 | FP_Master.PR_UI_FP02320_SAVE | MATCH | SP PR_UI_FP02320_SAVE |
| event:this.Load | Form_Load > InitControls | 216 | biz:FPCommonDataBLL.YesNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 219 | biz:FPCommonDataBLL.FPCommonDataList [code=CONVERSION_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetProd_Version_Type | 233 | biz:FPCommonDataBLL.FPCommonDataList [code=PROD_VERSION_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetCountry | 243 | biz:FPCommonDataBLL.FPCommonDataList [code=COUNTRY_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 1201 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 1201 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > ClbFactpry_SelectedIndexChanged > SetChangeControl | 1574 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbFactpry_SelectedIndexChanged > SetChangeControl | 1574 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| unreached:(진입점 미연결) | Find_Data_Excel_Execute | 698 | FP_Master.PR_UI_FP02320_PANCAKE_MASTER | MATCH | SP PR_UI_FP02320_PANCAKE_MASTER |
| unreached:(진입점 미연결) | FP02320_SaveDataDelegate | 1071 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02320] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP02320_SaveDataDelegate | 1071 | FP\Common\FP02320_Pancake_Master#merge_FP02320 | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | FP02320_ValidateDataDelegate | 1085 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP02320_ValidateDataDelegate | 1085 | FP\Common\FP02320_Pancake_Master#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP02320_Pancake_Master_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | FP02320_ValidateDataDelegate | 1089 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP02320_ValidateDataDelegate | 1089 | FP\Common\FP02320_Pancake_Master#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | FP02320_ValidateDataDelegate | 1093 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP02320_ValidateDataDelegate | 1093 | FP\Common\FP02320_Pancake_Master#find_Excel_buffer_validation | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP02320_Pancake_Master_find_Excel_buffer_validation.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=CONVERSION_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=COUNTRY_ID] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PROD_VERSION_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_insertValid] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02320] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.YesNo | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP02320_PANCAKE_MASTER | MATCH | 2 | SP PR_UI_FP02320_PANCAKE_MASTER | EXEC:PR_UI_FP02320_PANCAKE_MASTER | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP02320_SAVE | MATCH | 1 | SP PR_UI_FP02320_SAVE | EXEC:PR_UI_FP02320_SAVE | ⚠ DB에 SP 없음 |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\FP02320_Pancake_Master#delete_Excel_buffer | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP02320_Pancake_Master_delete_Excel_buffer.sql | DELETE:BUF_ITEM_LANE_M |  |
| FP\Common\FP02320_Pancake_Master#find_Excel_buffer_validation | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP02320_Pancake_Master_find_Excel_buffer_validation.sql | SELECT:BUF_ITEM_LANE_M, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:SCM_FACTORY_M, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Common\FP02320_Pancake_Master#find_insertValid | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP02320_Pancake_Master_find_insertValid.sql | SELECT:SCM_ITEM_LANE_M |  |
| FP\Common\FP02320_Pancake_Master#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\FP02320_Pancake_Master#merge_FP02320 | MATCH_PATTERN | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcelImport_Click | p.Filter | division_id, site_id, plant_id, factory_id, item_id, nick_name, active_flag, user_id |
| btnExcelImport_Click | p.KeyColumns | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY, PROD_VERSION_TYPE |
| btnExcelImport_Click | p.ColumnTitle | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, NICK_NAME, LANE_QTY, SLIT_WIDTH, MAIN_LANE_QTY, SUB_LANE_QTY, HALF_SLIT_FLAG, ACTIVE_FLAG, PROD_VERSION_TYPE |
| btnExcelImport_Click | p.ColumnWidth | PATTERN_QTY, ITEM_NAME, LANE, COATED_LENGTH, UNCOATED_LENGTH, LENGTH_UOM, PC_ROLL_LENGTH, PC_ROLL_LENGTH_UOM, PROD_VERSION_TYPE_ORG, PROD_EDIT, UPDATE_ID, UPDATE_TIME, DESCRIPTION, EDIT_YN |
| btnExcelImport_Click | p.ColumnBgColor | HALF_SLIT_FLAG, ACTIVE_FLAG, PROD_VERSION_TYPE |
| Find_Data_Excel_Execute | sp | division_id, site_id, plant_id, factory_id, item_id, nick_name, active_flag |
| GetDivision | Filter | USER_ID |
| Save_Data | rtValid.Rows[0] | CNT |
| SetChangeControl | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| spdMain_CellClick | dRow | DIVISION_ID, SITE_ID, FACTORY_ID, CODE, NAME |
| SpdMain_Changed | row | LANE_QTY, SUB_LANE_QTY, PATTERN_QTY, MAIN_LANE_QTY |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | Find_Data_Execute:607, Find_Data_Execute:608, Find_Data_Execute:609, Find_Data_Execute:610, Find_Data_Execute:615, btnExcelImport_Click:1118, btnExcelImport_Click:1119, btnExcelImport_Click:1120 | CString.GetCheckedListValue | CODE |
| FP_PseudoBatch | FP02320_SaveDataDelegate:1071 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| FP_UpdateBatch | FP02320_ValidateDataDelegate:1089 | DataService.FP_UpdateBatch | COUNT, RESULT |
| GetInnerTable | GetDivision:1534, SetChangeControl:1545, SetChangeControl:1551, SetChangeControl:1563, SetChangeControl:1574 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:145 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:375 |
| clbSite | SelectedIndexChanged | ClbSite_SelectedIndexChanged | InitEvent:376 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:377 |
| dsdmMain | Changed | SpdMain_Changed | InitEvent:380 |
| popSql | OnSql | RunSqlSource | btnSql_Click:519 |
| dsdmMain | Changed | SpdMain_Changed | Insert_Row:1034 |
| dsdmMain | Changed | SpdMain_Changed | Insert_Row:1057 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:1243 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:1329 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:467 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:510 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:816 |

## 6. 컨트롤 (34개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 11 | lblSite, lblPlant, lblSql, lblExcelUpload, lblItemId, lblDivision, lblNickName, lblFactory, lblActive, layoutControlItem_cutDate, lblConversion |
| UsrCheckedList2 | 5 | clbFactory, clbDivision, clbSite, clbPlant, clbConversion |
| EmptySpaceItem | 4 | emptySpaceItem5, emptySpaceItem2, emptySpaceItem1, emptySpaceItem3 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrTextBox | 2 | tbItemId, tbNickName |
| UsrButton | 2 | btnSql, btnExcelImport |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cboActive |
| UsrDateRangePicker2 | 1 | dCalendar_planrange |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imgList |

## 7. 확인 필요 (5건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 820 | Save_Data | FP\{?default:part_service}\FP02320_PANCAKE_MASTER#find_insertValid | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1093 | FP02320_ValidateDataDelegate | FP\{?default:part_service}\FP02320_PANCAKE_MASTER#find_Excel_buffer_validation | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1085 | FP02320_ValidateDataDelegate | FP\{?default:part_service}\FP02320_PANCAKE_MASTER#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1089 | FP02320_ValidateDataDelegate | FP\{?default:part_service}\FP02320_PANCAKE_MASTER#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1071 | FP02320_SaveDataDelegate | FP\{?default:part_service}\FP02320_PANCAKE_MASTER#merge_FP02320 | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 28 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 11 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 40 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP02320 | Main | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:401

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 832 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 833 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 834 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 835 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
