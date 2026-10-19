# FP02641 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02641_WO_Status.UIL\FP02641_WO_Status.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02641_WO_Status.UIL\FP02641_WO_Status.UIL.csproj | 1420 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02641_WO_Status.UIL\FP02641_WO_Status.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02641_WO_Status.UIL\FP02641_WO_Status.UIL.csproj | 1095 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02641_WO_Status.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02641_WO_Status.UIL\FP02641_WO_Status.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02641_WO_Status.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP02641_WO_Status.UIL\FP02641_WO_Status.UIL.csproj | 84 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP02641_WO_Status.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1277 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP02641_WO_Status.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1095 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 533 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 533 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged > SetChangeControl | 533 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged > SetChangeControl | 533 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangeControl | 533 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangeControl | 533 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 533 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 533 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 1106 | biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 533 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 533 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 533 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 533 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 533 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 533 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 1118 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 1118 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| button:FindButton | FindButton > FindData > Find_Data_Execute | 892 | FP_Master.PR_UI_FP02641_WO_STATUS | MATCH | SP PR_UI_FP02641_WO_STATUS |
| event:popSql.OnSql | RunSqlSource > Find_Data_Execute | 892 | FP_Master.PR_UI_FP02641_WO_STATUS | MATCH | SP PR_UI_FP02641_WO_STATUS |
| button:SaveButton | SaveButton > Save_Data > FindData > Find_Data_Execute | 892 | FP_Master.PR_UI_FP02641_WO_STATUS | MATCH | SP PR_UI_FP02641_WO_STATUS |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Execute | 1045 | FP_Master.PR_UI_FP02641_SAVE | MATCH | SP PR_UI_FP02641_SAVE |
| event:this.Load | Form_Load > InitControls | 183 | biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbLine_SelectedIndexChanged > SetChangeControl | 533 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbLine_SelectedIndexChanged > SetChangeControl | 533 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > ClbDivision_SelectedIndexChanged | 1106 | biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 1118 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 1118 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| unreached:(진입점 미연결) | <field:dtDayWeek> | 52 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| FP_Master.PR_UI_FP02641_SAVE | MATCH | 1 | SP PR_UI_FP02641_SAVE | EXEC:PR_UI_FP02641_SAVE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP02641_WO_STATUS | MATCH | 1 | SP PR_UI_FP02641_WO_STATUS | EXEC:PR_UI_FP02641_WO_STATUS | ⚠ DB에 SP 없음 |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| EditButton | row | EDIT_YN, IS_FIRST_TEST_WO, VD_FIRST_TEST_WO2, IS_VD_FIRST_TEST_WO, FIRST_TEST_WO2, WO_STATUS |
| GetPlanGroup | Filter | USER_ID, MASTER_ID, INSTANCE_ID, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GetPlanGroup | dtInstance.Rows[cboInstance.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| InitControls | dtCurDate.Rows[0] | CUR_DATE |
| Search_After | row | IS_FIRST_TEST_WO, VD_FIRST_TEST_WO2, IS_VD_FIRST_TEST_WO, FIRST_TEST_WO2, WO_STATUS |
| SetChangeControl | dtInstance.Rows[cboInstance.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetChangeControl | Filter | MASTER_ID, INSTANCE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| SpdMain_Changed | row | EDIT_YN, IS_FIRST_TEST_WO, VD_FIRST_TEST_WO2, IS_VD_FIRST_TEST_WO, FIRST_TEST_WO2, WO_STATUS, ITEM_ID |
| tbItemId_BeforeOpenSearch | tbItemId.Filter | division_lt, site_lt |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetInnerTable | GetPlanGroup:461, SetChangeControl:487, SetChangeControl:497, SetChangeControl:509, SetChangeControl:521, SetChangeControl:533, SetChangeControl:544, SetChangeControl:555 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | GetPlanGroup:469, SetChangeControl:491, SetChangeControl:508, SetChangeControl:520, SetChangeControl:532, SetChangeControl:543, SetChangeControl:554, SetChangeControl:565 | CString.GetCheckedListValue | CODE |
| SetFilter | SetChangeControl:492, SetChangeControl:493, SetChangeControl:494, SetChangeControl:495 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| FP_Log2 | CboInstance_SelectedIndexChanged:1097, CboInstance_SelectedIndexChanged:1100 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:138 |
| cboInstance | SelectedIndexChanged | CboInstance_SelectedIndexChanged | InitEvent:591 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:592 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:593 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:594 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:595 |
| cboOperation | SelectedIndexChanged | CboOperation_SelectedIndexChanged | InitEvent:596 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:597 |
| drpPeriod | ValueChanged | DrpPeriod_ValueChanged | InitEvent:598 |
| dsdmMain | Changed | SpdMain_Changed | InitEvent:602 |
| popSql | OnSql | RunSqlSource | btnSql_Click:759 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:1355 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:1412 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:536 |
| this.tbItemId | OnSearchConditionChanged | tbItemId_OnSearchConditionChanged | InitializeComponent:628 |
| this.tbItemId | BeforeOpenSearch | tbItemId_BeforeOpenSearch | InitializeComponent:629 |

## 6. 컨트롤 (39개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 14 | lblSql, lblInstance, lblFactory, lblStatus, lblPeriod, lblDivision, lblOperation, lblModel, lblSite, lblItem, lblPlant, lblProdType, lblWorkOrderID, lblLine |
| UsrCombo | 5 | cboStatus, cboProdType, cboOperation, cboSite, cboInstance |
| UsrCheckedList2 | 4 | clbFactory, clbPlant, clbDivision, clbLine |
| EmptySpaceItem | 4 | emptySpaceItem3, emptySpaceItem1, emptySpaceItem2, emptySpaceItem4 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrPopupTextBox | 2 | tbItemId, tbModel |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrTextBox | 1 | txtWorkOrderID |
| UsrButton | 1 | btnSql |
| UsrDateRangePicker2 | 1 | drpPeriod |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 26 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 54 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP02641 | Main | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:624

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 930 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 931 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 932 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 933 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
