# FP02602 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02602_Production_Result.UIL\FP02602_Production_Result.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02602_Production_Result.UIL\FP02602_Production_Result.UIL.csproj | 992 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02602_Production_Result.UIL\FP02602_Production_Result.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02602_Production_Result.UIL\FP02602_Production_Result.UIL.csproj | 939 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02602_Production_Result.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02602_Production_Result.UIL\FP02602_Production_Result.UIL.csproj | 37 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP02602_Production_Result.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 982 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP02602_Production_Result.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 939 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboLine.SelectedIndexChanged | cboLine_changed > SetChangeControl | 951 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboLine.SelectedIndexChanged | cboLine_changed > SetChangeControl | 951 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboOperation.SelectedIndexChanged | cboOperation_changed > SetChangeControl | 951 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboOperation.SelectedIndexChanged | cboOperation_changed > SetChangeControl | 951 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboSite.SelectedIndexChanged | cboSite_changed > SetChangeControl | 951 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | cboSite_changed > SetChangeControl | 951 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbDivision.SelectedIndexChanged | clbDivision_changed > SetChangeControl | 951 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_changed > SetChangeControl | 951 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbFactory.SelectedIndexChanged | clbBuilding_changed > SetChangeControl | 951 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | clbBuilding_changed > SetChangeControl | 951 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | cblPlant_changed | 863 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | cblPlant_changed | 863 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | cblPlant_changed > SetChangeControl | 951 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | cblPlant_changed > SetChangeControl | 951 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > InitComponents > cblPlant_changed | 863 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > cblPlant_changed | 863 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > InitComponents > cboLine_changed > SetChangeControl | 951 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > cboLine_changed > SetChangeControl | 951 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 73 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FindAttribute | 557 | FP_Master.PR_UI_FP00180_FINDATTRIBUTE | MATCH | SP PR_UI_FP00180_FINDATTRIBUTE |
| unreached:(진입점 미연결) | FindFormAttribute | 577 | FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE | MATCH | SP PR_UI_FP00180_FINDFORMATTRIBUTE |
| unreached:(진입점 미연결) | FP00180_SaveDataDelegate | 634 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=FP02602_Production_Result_EXCEL_UPDATE_BATCH] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_SaveDataDelegate | 634 | FP\{?default:part_service}\FP02602_Production_Result#FP02602_Production_Result_EXCEL_UPDATE_BATCH | UNRESOLVED |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 645 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 645 | FP\{?default:part_service}\FP02602_Production_Result#delete_Excel_buffer | UNRESOLVED |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 649 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 649 | FP\{?default:part_service}\FP02602_Production_Result#insert_Excel_buffer | UNRESOLVED |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 653 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 653 | FP\{?default:part_service}\FP02602_Production_Result#find_Excel_buffer_validation | UNRESOLVED |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=FP02602_Production_Result_EXCEL_UPDATE_BATCH] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP00180_FINDATTRIBUTE | MATCH | 1 | SP PR_UI_FP00180_FINDATTRIBUTE | EXEC:PR_UI_FP00180_FINDATTRIBUTE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE | MATCH | 1 | SP PR_UI_FP00180_FINDFORMATTRIBUTE | EXEC:PR_UI_FP00180_FINDFORMATTRIBUTE | ⚠ DB에 SP 없음 |
| FP\{?default:part_service}\FP02602_Production_Result#delete_Excel_buffer | UNRESOLVED | 1 |  |  |  |
| FP\{?default:part_service}\FP02602_Production_Result#find_Excel_buffer_validation | UNRESOLVED | 1 |  |  |  |
| FP\{?default:part_service}\FP02602_Production_Result#FP02602_Production_Result_EXCEL_UPDATE_BATCH | UNRESOLVED | 1 |  |  |  |
| FP\{?default:part_service}\FP02602_Production_Result#insert_Excel_buffer | UNRESOLVED | 1 |  |  |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcelImport_Click | p.KeyColumns | Company_id, DIVISION_ID, site_id, ITEM_ID |
| cbo_active_SelectedIndexChanged | Filter | ACTIVE_FLAG |
| drpPeriod_changed | Filter | BUCKET_FROM, DUE_FROM_DATE, BUCKET_TO, DUE_TO_DATE |
| FilterValidation | Filter | DIVISION_ID, PLANT_ID, DUE_FROM_DATE |
| GetDivision | Filter | USER_ID |
| GetPeriod | Filter | DUE_FROM_DATE, DUE_TO_DATE |
| InitComponents | Filter | CUTOFF_DATE, BUCKET_FROM, BUCKET_TO |
| InitControls | Filter | USER_ID |
| SetChangeControl | Filter | SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| spdMain_CellClick | dRow | CODE, NAME |
| spdMain_CellClick | bindingRow | OPERATION_ID |
| tbNickName_OnSearchConditionChanged | Filter | NICK_NAME, NICK_NAME_LT |
| txtMaterial_changed | Filter | ITEM_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetInnerTable | GetDivision:215, SetChangeControl:923, SetChangeControl:935, SetChangeControl:943, SetChangeControl:951, SetChangeControl:960, SetChangeControl:968 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | cbo_active_SelectedIndexChanged:618, SetChangeControl:927, SetChangeControl:942, SetChangeControl:950, SetChangeControl:959, SetChangeControl:967, SetChangeControl:975 | CString.GetCheckedListValue | CODE |
| FP_UpdateBatch | FP00180_SaveDataDelegate:634, FP00180_ValidateDataDelegate:649 | DataService.FP_UpdateBatch | COUNT, RESULT |
| SetFilter | SetChangeControl:931 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:139 |
| clbDivision | SelectedIndexChanged | clbDivision_changed | InitEvent:303 |
| cboSite | SelectedIndexChanged | cboSite_changed | InitEvent:304 |
| clbPlant | SelectedIndexChanged | cblPlant_changed | InitEvent:305 |
| clbFactory | SelectedIndexChanged | clbBuilding_changed | InitEvent:306 |
| cboOperation | SelectedIndexChanged | cboOperation_changed | InitEvent:308 |
| cboLine | SelectedIndexChanged | cboLine_changed | InitEvent:309 |
| txtMaterial | TextChanged | txtMaterial_changed | InitEvent:311 |
| drpPeriod | ValueChanged | drpPeriod_changed | InitEvent:313 |
| tbNickName | BeforeOpenSearch | tbNickName_BeforeOpenSearch | InitEvent:315 |
| tbNickName | OnSearchConditionChanged | tbNickName_OnSearchConditionChanged | InitEvent:316 |
| popSql | OnSql | RunSqlSource | btnSql_Click:390 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:470 |
| this.tbNickName | TextChanged | tbNickName_TextChanged | InitializeComponent:571 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:750 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:751 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:752 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:753 |

## 6. 컨트롤 (35개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | Factory, layoutControlItem6, layoutControlItem7, layoutControlItem3, layoutControlItem4, lblNickName, layoutControlItem8, layoutControlItem5, lblClass2, lblSql |
| EmptySpaceItem | 6 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem6, emptySpaceItem7, emptySpaceItem1 |
| UsrCheckedList2 | 3 | clbPlant, clbDivision, clbFactory |
| UsrCombo | 3 | cboLine, cboSite, cboOperation |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnSql, usrButton2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrTextBox | 1 | txtMaterial |
| UsrDateRangePicker2 | 1 | drpPeriod |
| ImageList | 1 | imageList1 |
| UsrPopupTextBox | 1 | tbNickName |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (4건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 653 | FP00180_ValidateDataDelegate | FP\{?default:part_service}\FP02602_Production_Result#find_Excel_buffer_validation | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 645 | FP00180_ValidateDataDelegate | FP\{?default:part_service}\FP02602_Production_Result#delete_Excel_buffer | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 634 | FP00180_SaveDataDelegate | FP\{?default:part_service}\FP02602_Production_Result#FP02602_Production_Result_EXCEL_UPDATE_BATCH | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 649 | FP00180_ValidateDataDelegate | FP\{?default:part_service}\FP02602_Production_Result#insert_Excel_buffer | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 25 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 5 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 72 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP02602 | Main | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:295

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 769 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 770 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 771 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 772 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
