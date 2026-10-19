# FP00413 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00413_Formation_Tray_Master.UIL\FP00413_Formation_Tray_Master.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00413_Formation_Tray_Master.UIL\FP00413_Formation_Tray_Master.UIL.csproj | 968 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00413_Formation_Tray_Master.UIL\FP00413_Formation_Tray_Master.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00413_Formation_Tray_Master.UIL\FP00413_Formation_Tray_Master.UIL.csproj | 909 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00413_Formation_Tray_Master.UIL\FP00413Service.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00413_Formation_Tray_Master.UIL\FP00413_Formation_Tray_Master.UIL.csproj | 39 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00413_Formation_Tray_Master.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00413_Formation_Tray_Master.UIL\FP00413_Formation_Tray_Master.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 439 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP00413] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 439 | FP\MASTER\FP00413_FormationTrayMaster#update_FP00413 | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | findTray | 35 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Tray] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | findTray | 35 | FP\Master\FP00413_FormationTrayMaster#find_Tray | MATCH | [sql] foxquery_sql\FP_Master_FP00413_FormationTrayMaster_find_Tray.sql |
| unreached:(진입점 미연결) | Excel_Save | 848 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00413] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_Save | 848 | FP\MASTER\FP00413_FormationTrayMaster#merge_FP00413 | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 878 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 878 | FP\MASTER\FP00413_FormationTrayMaster#delete_Excel_buffer | MATCH | [sql] foxquery_sql\FP_Master_FP00413_FormationTrayMaster_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | Excel_CheckValidation | 882 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 882 | FP\MASTER\FP00413_FormationTrayMaster#insert_Excel_buffer | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 887 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 887 | FP\MASTER\FP00413_FormationTrayMaster#find_Excel_buffer_validation | MATCH | [sql] foxquery_sql\FP_Master_FP00413_FormationTrayMaster_find_Excel_buffer_validation.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Tray] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00413] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP00413] | BIZ_MATCH | 1 |  |  |  |
| FP\MASTER\FP00413_FormationTrayMaster#delete_Excel_buffer | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00413_FormationTrayMaster_delete_Excel_buffer.sql | DELETE:BUF_FCS_TRAY_M |  |
| FP\MASTER\FP00413_FormationTrayMaster#find_Excel_buffer_validation | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00413_FormationTrayMaster_find_Excel_buffer_validation.sql | SELECT:BUF_FCS_TRAY_M, SELECT:SCM_FCS_TRAY_M, SELECT:FP_USER_ROLE_INFO_V, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Master\FP00413_FormationTrayMaster#find_Tray | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00413_FormationTrayMaster_find_Tray.sql | SELECT:SCM_FCS_TRAY_MA |  |
| FP\MASTER\FP00413_FormationTrayMaster#insert_Excel_buffer | MATCH | 1 | [update-batch]  |  |  |
| FP\MASTER\FP00413_FormationTrayMaster#merge_FP00413 | MATCH | 1 | [update-batch]  |  |  |
| FP\MASTER\FP00413_FormationTrayMaster#update_FP00413 | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcel_Click | p.KeyColumns | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, TRAY_ID |
| btnExcel_Click | p.ColumnTitle | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, TRAY_ID, GROUP_TRAY_ID, TRAY_NAME, TRAY_TYPE, CELL_CNT, LOAD_YIELD, BUFFER_DAY, INVENTORY_CNT, INTRANSIT_CNT, DESCRIPTION, ACTIVE_FLAG |
| btnExcel_Click | p.ColumnWidth | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, TRAY_ID, GROUP_TRAY_ID, TRAY_NAME, TRAY_TYPE, CELL_CNT, LOAD_YIELD, BUFFER_DAY, INVENTORY_CNT, INTRANSIT_CNT, DESCRIPTION, ACTIVE_FLAG, MESSAGE |
| btnExcel_Click | p.ColumnBgColor | LOAD_YIELD, BUFFER_DAY, INVENTORY_CNT, INTRANSIT_CNT, DESCRIPTION |
| Cb_EditorValueChanged | dtTrayGroup.Rows[buf_Index] | CODE |
| CboTray_SelectedIndexChanged | Filter | TRAY_TYPE |
| CreateTrayTypeTable | dt.Rows[0] | CODE, NAME |
| CreateTrayTypeTable | dt.Rows[1] | CODE, NAME |
| CreateTrayTypeTable | dt.Rows[2] | CODE, NAME |
| CreateTrayTypeTable | dt.Rows[3] | CODE, NAME |
| Find_Data_Execute | Filter | TRAY_ID, ACTIVE_FLAG, GROUP_TRAY_CNT, TRAY_TYPE_CODE |
| FindData | siMain.ActiveSheet.Columns | GROUP_TRAY_ID |
| findTray | Filter | DIVISION_ID, SITE_ID, PLANT_ID, CTRL_DIVISION_ID, CTRL_SITE_ID, CTRL_PLANT_ID |
| findTray | FilterSrc | DIVISION_ID, SITE_ID, PLANT_ID |
| GetDivision | Filter | USER_ID |
| InitControls | Filter | TRAY_TYPE, ACTIVE, ONLY_GROUP_TRAY |
| SetChangeControl | Filter | PLANT_ID |
| SetEditMode | dbrow | EDIT_YN |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:160, SetChangeControl:183, SetChangeControl:192, SetChangeControl:201, CboTray_SelectedIndexChanged:272 | CString.GetCheckedListValue | CODE |
| GetInnerTable | SetChangeControl:179, SetChangeControl:185, SetChangeControl:193, GetDivision:227 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| SetFilter | SetChangeControl:184 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetChanges | Save_Data_Line:435 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch | Save_Data_Line:439, Excel_Save:848, Excel_CheckValidation:882 | DataService.FP_UpdateBatch | COUNT, RESULT |
| LockColumnFP | SetEditMode:522, SetEditMode:523, SetEditMode:524, SetEditMode:525, SetEditMode:526, SetEditMode:527, SetEditMode:559 | FPExtensions.LockColumnFP | EDIT_YN |
| LoadCombo | FindData:649 | SpreadInfo.LoadCombo | CODE, NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:104 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:215 |
| cboSite | SelectedIndexChanged | ClbSite_SelectedIndexChanged | InitEvent:216 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:217 |
| cboTray | SelectedIndexChanged | CboTray_SelectedIndexChanged | InitEvent:218 |
| popSql | OnSql | RunSqlSource | btnSql_Click:485 |
| cb | EditorValueChanged | Cb_EditorValueChanged | FindData:647 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:558 |
| this.btnExcel | Click | btnExcel_Click | InitializeComponent:598 |
| this.spdMain | ComboCloseUp | spdMain_ComboCloseUp | InitializeComponent:785 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:786 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:787 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:788 |

## 6. 컨트롤 (34개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 12 | lblSql, layoutControlItem5, layoutControlItem1, layoutControlItem3, layoutControlItem10, layoutControlItem7, layoutControlItem8, layoutControlItem9, layoutControlItem4, layoutControlItem6, layoutControlItem2, layoutControlItem11 |
| UsrRadio | 3 | radioActiveN, radioActiveY, radioActiveAll |
| EmptySpaceItem | 3 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem4 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 2 | cboTray, cboSite |
| UsrCheckedList2 | 2 | clbPlant, clbDivision |
| UsrButton | 2 | btnSql, btnExcel |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCheckBox | 1 | cbOnlyGroupTray |
| UsrLabel | 1 | usrLabel1 |
| UsrTextBox | 1 | textTrayId |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 15 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 4 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00413 | Main | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:297

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 804 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 805 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 806 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 807 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
