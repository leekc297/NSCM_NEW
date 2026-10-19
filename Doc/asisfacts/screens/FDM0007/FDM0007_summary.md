# FDM0007 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FDM0007_Demand_WaterFall.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1434 |
| only | 06.UIL\GSCM.FP.Master.UIL\FDM0007_Demand_WaterFall.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1310 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FDM0007_MemoDownPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 898 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FDM0007_MemoDownPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 437 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetPlanID | 1226 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetPlant | 1246 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetFactory | 1264 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetOperation | 1295 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetLine | 1332 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetProdType | 1345 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetStartEndDate | 1358 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:cboPlant.SelectedIndexChanged | CboPlant_SelectedIndexChanged > SetFactory | 1264 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetPlanGroup | 1212 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetOperation | 1295 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetLine | 1332 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Data > Find_Data_MemoDown | 474 | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Memo | 521 | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Demend | 738 | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Demend > ApplySearchCondition | 809 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Demend > ApplySearchCondition | 810 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Demend > ApplySearchCondition | 823 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Demend > ApplySearchCondition | 825 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Demend > ApplySearchCondition | 826 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_MemoDown | 474 | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo | 521 | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Demend | 738 | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Demend > ApplySearchCondition | 809 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Demend > ApplySearchCondition | 810 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Demend > ApplySearchCondition | 823 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Demend > ApplySearchCondition | 825 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Demend > ApplySearchCondition | 826 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemoDown.Click | btnMemoDowm_Click > ApplySearchCondition | 809 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemoDown.Click | btnMemoDowm_Click > ApplySearchCondition | 810 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemoDown.Click | btnMemoDowm_Click > ApplySearchCondition | 823 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemoDown.Click | btnMemoDowm_Click > ApplySearchCondition | 825 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemoDown.Click | btnMemoDowm_Click > ApplySearchCondition | 826 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.dtpPlanDate.CloseUp | dtpPlanDate_CloseUp > SetPlanID | 1226 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 160 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > Find_Data > Find_Data_MemoDown | 474 | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Memo | 521 | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > InitControls > SetSite | 1198 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetSite > SetPlanGroup | 1212 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetPlanID | 1226 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetPlant | 1246 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetFactory | 1264 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetOperation | 1295 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetLine | 1332 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetProdType | 1345 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetStartEndDate | 1358 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY | 3 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 10 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplySearchCondition | dtCurrWeek.Rows[0] | CURR_WEEK |
| ApplySearchCondition | dtBukWeekInfo.Rows[0] | BUCKET_FROM_WEEK, BUCKET_TO_WEEK |
| ApplySearchCondition | dtPlanWeekInfo.Rows[0] | PLAN_WEEK |
| ApplySearchCondition | dtPlanWeekInfo.Rows[4] | PLAN_WEEK |
| btnMemo_Click | Application.OpenForms | FPC0104_MemoPopup |
| btnMemo_Click | memoPopup.Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, ITEM_ID, PLAN_ID, PLAN_DATE, USER_ID |
| btnMemoDowm_Click | Application.OpenForms | FDM0007_MemoDownPopup |
| btnMemoDowm_Click | DownPopup.Filter | p_instance_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_model_id, p_item_id, p_nick_name, p_chk_total_include, p_pp_option, p_curr_week, p_bucket_from_date, p_bucket_to_date, p_bucket_from_week, p_bucket_to_week, p_plan_from_week, p_plan_to_week, p_week_info, p_month_week_column, p_month_column_info, p_plan_week_Info |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | x | _MM_ |
| Find_Data_Memo | Filter | p_instance_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_model_id, p_item_id, p_nick_name, p_chk_total_include, p_pp_option, p_curr_week, p_bucket_from_date, p_bucket_to_date, p_bucket_from_week, p_bucket_to_week, p_plan_from_week, p_plan_to_week, p_week_info, p_month_week_column, p_month_column_info, p_plan_week_Info |
| Find_Data_MemoDown | Filter | p_instance_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_model_id, p_item_id, p_nick_name, p_chk_total_include, p_pp_option, p_curr_week, p_bucket_from_date, p_bucket_to_date, p_bucket_from_week, p_bucket_to_week, p_plan_from_week, p_plan_to_week, p_week_info, p_month_week_column, p_month_column_info, p_plan_week_Info |
| GetMakeMeasure | newrow | MEA_ID, MEA_NAME, MEA_VALUE, TYPE, FLAG, MENU_ID, USER_ID |
| GetMakeMeasure | row | MENU_ID, MEA_ID, MEA_NAME, MEA_VALUE, TYPE, FLAG, USER_ID |
| GetMakeMeasure | measure.Data | chk_week |
| InitControls | Filter | p_bucket_from_date, p_bucket_to_date |
| SetColumnChangeByMemo | dsResult.Tables[0].Rows[k] | DATA_TYPE, CATEGORY_DETAIL_ID |
| SetCombineMemo | row | DATA_TYPE, OPERATION_ID, CATEGORY_ID, CATEGORY_DETAIL_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, PRODUCTION_TYPE, PLAN_WEEK |
| SetCombineMemo | each_row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, PRODUCTION_TYPE, CATEGORY_ID, PLAN_WEEK |
| SetStartEndDate | dtResult.Rows[0] | START_DATE, END_DATE, PLAN_DATE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | btnMemo_Click:390, btnMemo_Click:391, btnMemo_Click:392, btnMemo_Click:393, btnMemo_Click:394, btnMemo_Click:395, btnMemo_Click:396, btnMemo_Click:397 | CString.GetCheckedListValue | CODE |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:667, CreateFilterDataSet:447 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| SetRowsUnVisible | CreateFilterDataSet:670, CreateFilterDataSet:450 | MeasureService.SetRowsUnVisible | _MM_ |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.dtpPlanDate | CloseUp | dtpPlanDate_CloseUp | InitializeComponent:196 |
| this.dtpPlanDate | ValueChanged | dtpPlanDate_ValueChanged | InitializeComponent:197 |
| this.btnMemoDown | Click | btnMemoDowm_Click | InitializeComponent:210 |
| this.rdoGroup1 | SelectedIndexChanged | rdoGroup1_SelectedIndexChanged | InitializeComponent:296 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:510 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:831 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1170 |
| this | Load | Form_Load | .ctor:135 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:254 |
| cboPlanGroup | SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | InitEvent:255 |
| cboPlanID | SelectedIndexChanged | CboPlanID_SelectedIndexChanged | InitEvent:256 |
| cboPlant | SelectedIndexChanged | CboPlant_SelectedIndexChanged | InitEvent:257 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:258 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:259 |
| popSql | OnSql | RunSqlSource | btnSql_Click:539 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:156 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:220 |
| this.btnExport | Click | btnExport_Click | InitializeComponent:259 |
| this | Load | Form_Load | .ctor:121 |
| popSql | OnSql | RunSqlSource | btnSql_Click:332 |

## 6. 컨트롤 (60개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 22 | layoutControlItem12, layoutControlItem7, lblPlan, layoutControlItem2, layoutControlItem6, layoutControlItem3, layoutControlItem13, layoutControlItem11, layoutControlItem14, layoutControlItem4, layoutControlItem8, layoutControlItem15, layoutControlItem16, layoutControlItem9, layoutControlItem5 … |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList2 | 4 | clbProdType, clbOperation, clbLine, clbFactory |
| UsrCombo | 4 | cboPlant, cboPlanID, cboPlanGroup, cboSite |
| UsrButton | 4 | btnSql, btnClose, btnSql, btnExport |
| UsrMultiLineEditor | 3 | txtModel, txtNickName, txtItemID |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| SimpleButton | 2 | btnMemoDown, btnMemo |
| ImageList | 2 | imageList1, imageList1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| DateTimePicker | 1 | dtpPlanDate |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrLabel | 1 | lblPlanID |
| RadioGroup | 1 | rdoGroup1 |
| UsrCheckBox | 1 | chkTotInclude |

## 7. 확인 필요 (3건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 738 | Find_Data_Demend | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 474 | Find_Data_MemoDown | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 521 | Find_Data_Memo | FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: WaterFall, WaterFallPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:308, SetSheetHeaderColumn_FP@SetSpreadInit:236

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetHiddenColmn |  | 326 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetHiddenColmn |  | 327 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID |  |
| SetHiddenColmn |  | 328 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID |  |
| SetHiddenColmn |  | 329 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_ID |  |
| SetHiddenColmn |  | 330 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_ORDER |  |
| SetHiddenColmn |  | 331 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_WEEK_ORDER |  |
| SetHiddenColmn |  | 332 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DATA_TYPE |  |
| SetHiddenColmn |  | 333 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_DETAIL_ID |  |
| InitializeComponent |  | 1186 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1187 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1188 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1189 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetHiddenColmn |  | 254 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetHiddenColmn |  | 255 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID |  |
| SetHiddenColmn |  | 256 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID |  |
| SetHiddenColmn |  | 257 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_ID |  |
| SetHiddenColmn |  | 258 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_ORDER |  |
| SetHiddenColmn |  | 259 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_WEEK |  |
| SetHiddenColmn |  | 260 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_WEEK_ORDER |  |
| SetHiddenColmn |  | 261 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DATA_TYPE |  |
| SetHiddenColmn |  | 262 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_DETAIL_ID |  |
| InitializeComponent |  | 362 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 363 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 364 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 365 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| WaterFall | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| WaterFallPopup | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
