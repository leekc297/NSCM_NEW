# FP00521 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FP00521_Demand_WaterFall.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1793 |
| only | 06.UIL\GSCM.FP.Master.UIL\FP00521_Demand_WaterFall.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1317 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00521_MemoDownPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 958 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00521_MemoDownPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 437 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00521_MemoListPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 632 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00521_MemoListPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 491 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00521_MemoPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 412 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00521_MemoPopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 683 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetPlanID | 1566 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetPlant | 1586 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetFactory | 1611 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetOperation | 1642 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetLine | 1679 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl > SetProdType | 1692 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetStartEndDate | 1705 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:cboPlant.SelectedIndexChanged | CboPlant_SelectedIndexChanged > SetFactory | 1611 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetPlanGroup | 1552 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetOperation | 1642 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetLine | 1679 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Memo | 367 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMO |
| button:FindButton | FindButton > Find_Data > Find_Data_MemoDown | 504 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL |
| button:FindButton | FindButton > Find_Data > Find_Data_MemoData | 551 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL |
| button:FindButton | FindButton > Find_Data > Find_Data_WaterFall | 727 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL |
| button:FindButton | FindButton > Find_Data > Find_Data_Memo > ApplySearchCondition | 798 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Memo > ApplySearchCondition | 799 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Memo > ApplySearchCondition | 818 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Memo > ApplySearchCondition | 820 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Memo > ApplySearchCondition | 821 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Memo | 1052 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo | 139 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO |
| event:popSql.OnSql | RunSqlSource > Save_Data_Memo | 222 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Memo | 304 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo | 367 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMO |
| event:popSql.OnSql | RunSqlSource > Find_Data_MemoDown | 504 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL |
| event:popSql.OnSql | RunSqlSource > Save_Data_Memo | 509 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMO |
| event:popSql.OnSql | RunSqlSource > Find_Data_MemoData | 551 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL |
| event:popSql.OnSql | RunSqlSource > Find_Data_WaterFall | 727 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo > ApplySearchCondition | 798 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo > ApplySearchCondition | 799 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo > ApplySearchCondition | 818 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo > ApplySearchCondition | 820 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo > ApplySearchCondition | 821 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo | 1052 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo_Info | 1101 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Memo | 222 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Memo | 367 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMO |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Memo | 509 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMO |
| event:this.btnDelete.Click | btnDelete_Click > Delete_Data > Delete_Data_Memo | 304 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Memo | 367 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMO |
| event:this.btnMemo.Click | btnMemo_Click | 1203 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemo.Click | btnMemo_Click | 1211 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemoDown.Click | btnMemoDowm_Click > ApplySearchCondition | 798 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemoDown.Click | btnMemoDowm_Click > ApplySearchCondition | 799 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemoDown.Click | btnMemoDowm_Click > ApplySearchCondition | 818 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemoDown.Click | btnMemoDowm_Click > ApplySearchCondition | 820 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnMemoDown.Click | btnMemoDowm_Click > ApplySearchCondition | 821 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Memo | 222 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Memo | 367 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMO |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Memo | 509 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMO |
| event:this.dtpPlanDate.CloseUp | dtpPlanDate_CloseUp > SetPlanID | 1566 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 161 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > Find_Data > Find_Data_Memo | 367 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMO |
| event:this.Load | Form_Load > Find_Data > Find_Data_MemoDown | 504 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL |
| event:this.Load | Form_Load > Find_Data > Find_Data_MemoData | 551 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL |
| event:this.Load | Form_Load > InitControls > SetSite | 1538 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetSite > SetPlanGroup | 1552 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetPlanID | 1566 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetPlant | 1586 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetFactory | 1611 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetOperation | 1642 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetLine | 1679 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetProdType | 1692 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetStartEndDate | 1705 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > Find_Data_Memo_Info | 1101 | FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | MATCH | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 12 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | MATCH | 4 | SP PR_UI_FP00521_DEMAND_WATERFALL | EXEC:PR_UI_FP00521_DEMAND_WATERFALL | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | MATCH | 2 | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMO | EXEC:PR_UI_FP00521_DEMAND_WATERFALL_MEMO | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | MATCH | 4 | SP PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | EXEC:PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplySearchCondition | dtCurrWeek.Rows[0] | CURR_WEEK |
| ApplySearchCondition | dtBukWeekInfo.Rows[0] | BUCKET_FROM_WEEK, BUCKET_TO_WEEK |
| ApplySearchCondition | dtPlanWeekInfo.Rows[0] | PLAN_WEEK |
| ApplySearchCondition | dtPlanWeekInfo.Rows[4] | PLAN_WEEK |
| btnMemo_Click | dtBukWeek.Rows[0] | BUCKET_FROM_WEEK, BUCKET_TO_WEEK |
| btnMemo_Click | dtPlanWeek.Rows[0] | PLAN_WEEK |
| btnMemo_Click | dtPlanWeek.Rows[4] | PLAN_WEEK |
| btnMemo_Click | Application.OpenForms | FP00521_MemoListPopup |
| btnMemo_Click | memoPopup.Filter | p_company_id, p_division_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_item_id, p_category_id, p_market, p_plan_week, p_mfg_week, p_description, p_bucket_from_week, p_bucket_to_week, p_plan_from_week, p_plan_to_week |
| btnMemoDowm_Click | Application.OpenForms | FP00521_MemoDownPopup |
| btnMemoDowm_Click | DownPopup.Filter | p_instance_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_model_id, p_item_id, p_nick_name, p_chk_total_include, p_pp_option, p_curr_week, p_bucket_from_date, p_bucket_to_date, p_bucket_from_week, p_bucket_to_week, p_plan_from_week, p_plan_to_week, p_week_info, p_month_week_column, p_month_column_info, p_plan_week_Info |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | x | _MM_ |
| Delete_Data_Memo | Filter | p_company_id, p_division_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_item_id, p_category_id, p_model_id, p_market, p_plan_week, p_mfg_week |
| Find_Data_Memo | Filter | p_company_id, p_division_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_item_id, p_category_id, p_market, p_plan_week, p_mfg_week, p_description, p_bucket_from_week, p_bucket_to_week, p_plan_from_week, p_plan_to_week, p_model_id |
| Find_Data_Memo_Info | Filter | p_company_id, p_division_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_item_id, p_category_id, p_model_id, p_market, p_plan_week, p_mfg_week |
| Find_Data_MemoData | Filter | p_instance_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_model_id, p_item_id, p_nick_name, p_chk_total_include, p_pp_option, p_curr_week, p_bucket_from_date, p_bucket_to_date, p_bucket_from_week, p_bucket_to_week, p_plan_from_week, p_plan_to_week, p_week_info, p_month_week_column, p_month_column_info, p_plan_week_Info |
| Find_Data_MemoDown | Filter | p_instance_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_model_id, p_item_id, p_nick_name, p_chk_total_include, p_pp_option, p_curr_week, p_bucket_from_date, p_bucket_to_date, p_bucket_from_week, p_bucket_to_week, p_plan_from_week, p_plan_to_week, p_week_info, p_month_week_column, p_month_column_info, p_plan_week_Info |
| GetMakeMeasure | newrow | MEA_ID, MEA_NAME, MEA_VALUE, TYPE, FLAG, MENU_ID, USER_ID |
| GetMakeMeasure | row | MENU_ID, MEA_ID, MEA_NAME, MEA_VALUE, TYPE, FLAG, USER_ID |
| GetMakeMeasure | measure.Data | chk_week |
| InitControls | Filter | p_bucket_from_date, p_bucket_to_date |
| InitControls | this.Filter | p_creator, p_creation_date, p_description |
| Save_Data_Memo | Filter | p_company_id, p_division_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_item_id, p_category_id, p_model_id, p_market, p_plan_week, p_mfg_week |
| SetColumnChangeByMemo | dsResult.Tables[0].Rows[k] | DATA_TYPE, CATEGORY_DETAIL_ID |
| SetCombineMemo | row | DATA_TYPE, OPERATION_ID, CATEGORY_ID, CATEGORY_DETAIL_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, PRODUCTION_TYPE, PLAN_WEEK |
| SetCombineMemo | each_row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, PRODUCTION_TYPE, CATEGORY_ID, PLAN_WEEK |
| SetCombineMemo | dtMemo.Rows[i] | MFG_WEEK |
| SetSheetFontBoldByMemo | row | DATA_TYPE, OPERATION_ID, CATEGORY_ID, CATEGORY_DETAIL_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, PRODUCTION_TYPE, PLAN_WEEK |
| SetSheetFontBoldByMemo | each_row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, PRODUCTION_TYPE, CATEGORY_ID, PLAN_WEEK |
| SetSheetFontBoldByMemo | dtMemo.Rows[i] | MFG_WEEK |
| SetStartEndDate | dtResult.Rows[0] | START_DATE, END_DATE, PLAN_DATE |
| spdMain_CellDoubleClick | Application.OpenForms | FP00521_MemoDownPopup |
| spdMain_CellDoubleClick | Filter | p_company_id, p_division_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_category_id, p_market, p_model_id, p_item_id, p_plan_week, p_mfg_week |
| spdMain_CellDoubleClick | MemoPopup.Filter | p_company_id, p_division_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, p_line_id, p_prod_type, p_category_id, p_market, p_model_id, p_item_id, p_plan_week, p_mfg_week, p_description, p_creator, p_creation_date |
| spdMain_CellDoubleClick | dsMemo.Tables[0].Rows[0] | DESCRIPTION, UPDATE_ID, UPDATE_DATE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | Find_Data:460, Find_Data:514, Find_Data_WaterFall:699, Find_Data_WaterFall:700, Find_Data_WaterFall:701, Find_Data_WaterFall:702, Find_Data_WaterFall:703, Find_Data_WaterFall:704 | CString.GetCheckedListValue | CODE |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:656, CreateFilterDataSet:477 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| SetRowsUnVisible | CreateFilterDataSet:659, CreateFilterDataSet:480 | MeasureService.SetRowsUnVisible | _MM_ |
| HasMemoAuthority | InitControls:156, InitControls:102 | UserService.HasMemoAuthority | NowGroupID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.dtpPlanDate | CloseUp | dtpPlanDate_CloseUp | InitializeComponent:197 |
| this.dtpPlanDate | ValueChanged | dtpPlanDate_ValueChanged | InitializeComponent:198 |
| this.btnMemoDown | Click | btnMemoDowm_Click | InitializeComponent:211 |
| this.rdoGroup1 | SelectedIndexChanged | rdoGroup1_SelectedIndexChanged | InitializeComponent:297 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:511 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:810 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1177 |
| this | Load | Form_Load | .ctor:142 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:272 |
| cboPlanGroup | SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | InitEvent:273 |
| cboPlanID | SelectedIndexChanged | CboPlanID_SelectedIndexChanged | InitEvent:274 |
| cboPlant | SelectedIndexChanged | CboPlant_SelectedIndexChanged | InitEvent:275 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:276 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:277 |
| drpPeriod | Click | drpPeriod_Click | InitEvent:278 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1354 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:156 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:220 |
| this.btnExport | Click | btnExport_Click | InitializeComponent:259 |
| this | Load | Form_Load | .ctor:122 |
| popSql | OnSql | RunSqlSource | btnSql_Click:336 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:159 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:223 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:262 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:427 |
| this | Load | Form_Load | .ctor:107 |
| popSql | OnSql | RunSqlSource | btnSql_Click:584 |
| this | Load | Form_Load | .ctor:63 |
| popSql | OnSql | RunSqlSource | btnSql_Click:372 |
| this.btnDelete | Click | btnDelete_Click | InitializeComponent:179 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:386 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:425 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:464 |

## 6. 컨트롤 (100개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 35 | layoutControlItem12, layoutControlItem7, lblPlan, layoutControlItem2, layoutControlItem6, layoutControlItem3, layoutControlItem13, layoutControlItem11, layoutControlItem14, layoutControlItem4, layoutControlItem8, layoutControlItem15, layoutControlItem16, layoutControlItem9, layoutControlItem5 … |
| UsrButton | 12 | btnSql, btnClose, btnSql, btnExport, btnClose, btnSql, btnSave, btnFind, btnDelete, btnSql, btnClose, btnSave |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCheckedList2 | 4 | clbProdType, clbOperation, clbLine, clbFactory |
| UsrCombo | 4 | cboPlant, cboPlanID, cboPlanGroup, cboSite |
| ImageList | 4 | imageList1, imageList1, imageList1, imageList1 |
| UsrLabel | 3 | lblPlanID, usrLabel2, usrLabel1 |
| UsrMultiLineEditor | 3 | txtModel, txtNickName, txtItemID |
| FpSpread | 3 | spdMain, spdMain, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| SimpleButton | 2 | btnMemoDown, btnMemo |
| UsrTextBox | 2 | txtCreationDate, txtCreator |
| DateTimePicker | 1 | dtpPlanDate |
| UsrDateRangePicker2 | 1 | drpPeriod |
| RadioGroup | 1 | rdoGroup1 |
| UsrCheckBox | 1 | chkTotInclude |
| TextBox | 1 | txtMemo |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 60 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
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
| SCM_MST_SHEET_COLUMNS | FP00521 | WaterFall | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | FP00521 | WaterFallMemoDownPopup | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | FP00521 | WaterFallMemoPopup | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: WaterFall, WaterFallMemoDownPopup, WaterFallMemoPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:327, SetSheetHeaderColumn_FP@SetSpreadInit:239, SetSheetHeaderColumn_FP@SetSpreadInit:220

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetHiddenColmn |  | 345 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetHiddenColmn |  | 346 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID |  |
| SetHiddenColmn |  | 347 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID |  |
| SetHiddenColmn |  | 348 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_ID |  |
| SetHiddenColmn |  | 349 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_ORDER |  |
| SetHiddenColmn |  | 350 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_WEEK_ORDER |  |
| SetHiddenColmn |  | 351 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DATA_TYPE |  |
| SetHiddenColmn |  | 352 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_DETAIL_ID |  |
| InitializeComponent |  | 1193 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1194 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1195 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1196 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetHiddenColmn |  | 257 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetHiddenColmn |  | 258 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID |  |
| SetHiddenColmn |  | 259 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID |  |
| SetHiddenColmn |  | 260 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_ID |  |
| SetHiddenColmn |  | 261 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_ORDER |  |
| SetHiddenColmn |  | 262 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_WEEK |  |
| SetHiddenColmn |  | 263 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_WEEK_ORDER |  |
| SetHiddenColmn |  | 264 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DATA_TYPE |  |
| SetHiddenColmn |  | 265 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_DETAIL_ID |  |
| InitializeComponent |  | 362 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 363 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 364 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 365 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetHiddenColmn |  | 238 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| InitializeComponent |  | 366 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 367 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 368 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 369 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| WaterFall | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| WaterFallMemoDownPopup | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |
| WaterFallMemoPopup | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
