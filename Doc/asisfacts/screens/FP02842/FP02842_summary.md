# FP02842 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 266 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_BucketSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 250 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_ExcelPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 1376 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_ExcelPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 668 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 369 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 323 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 7011 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 3456 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_RowExcelPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 1083 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_RowExcelPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 589 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02842_PlanAmend_Elec_Post_Shift\FP02842_PlanAmend_Elec_Post_Shift.UIL.csproj | 64 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > SetFactory | 4000 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetBasisTime | 3790 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetDivision | 3800 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetPlanner | 3813 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId | 3903 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetSite | 3982 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetPlant | 3989 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetFactory | 4000 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetOperation | 4010 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetLine | 4034 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetLine | 4034 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.DateTimeChanged | planday_changed > SetFpPlanId > SetBasisTime | 3790 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:drpPlanDate.DateTimeChanged | planday_changed > SetFpPlanId | 3903 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data | 407 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data | 409 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data | 411 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1049 | FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1189 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1195 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1197 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1199 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1256 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetPlant | 3989 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetOperation | 4010 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetLine | 4034 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:mcbo_planner.SelectedIndexChanged | mcbo_planner_changed > SetLine | 4034 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetFactory | 4000 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetPlant | 3989 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > GetOperation | 7005 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1049 | FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1189 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1195 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1197 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1199 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > lfn_setReleaseProcess | 1256 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Save_Valid | 2019 | FP_Planning.PR_UI_FP02842_AMEND_LINE | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Amend | 2139 | FP_Planning.PR_UI_FP02842_AMEND_SAVE | MATCH | SP PR_UI_FP02842_AMEND_SAVE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 4884 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 4890 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 4892 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 4894 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 4900 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Excel_Import | 5108 | FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend | 1049 | FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1189 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1195 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1197 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1199 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1256 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_PIn_Data | 1829 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_PIn_Data > Save_Data_Amend | 2139 | FP_Planning.PR_UI_FP02842_AMEND_SAVE | MATCH | SP PR_UI_FP02842_AMEND_SAVE |
| button:SaveButton | SaveButton > Save_PIn_Data > SetPlanGroup | 3874 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 1049 | FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1189 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1195 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1197 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1199 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1256 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 1049 | FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1189 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1195 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1197 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1199 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1256 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend | 1049 | FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1189 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1195 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1197 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1199 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1256 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > Exec_Procedure | 2192 | FP_Planning.PR_UI_FP02842_AMEND_LINE_SAVE | NOT_IN_FOXQUERY |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click | 2969 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnFind.Click | btnFind_Click > Find_Data | 407 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnFind.Click | btnFind_Click > Find_Data | 409 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnFind.Click | btnFind_Click > Find_Data | 411 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpload.Click | btnUpload_Click > SearchListInfoAll | 925 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpload.Click | btnUpload_Click > SearchListInfoAll | 932 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpload.Click | btnUpload_Click > SearchListInfoAll | 935 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpload.Click | btnUpload_Click > OpenAndLoadExcelData > SearchListInfoAll | 972 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpload.Click | btnUpload_Click > OpenAndLoadExcelData > SearchListInfoAll | 979 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpload.Click | btnUpload_Click > OpenAndLoadExcelData > SearchListInfoAll | 982 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.cbo_fpplanid.DropDown | cbo_fpplanid_DropDown > SetFpPlanId > SetBasisTime | 3790 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.cbo_fpplanid.DropDown | cbo_fpplanid_DropDown > SetFpPlanId | 3903 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.chk_includeSubOp.CheckedChanged | chk_includeSubOp_onchanged > SetOperation | 4010 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | MeasureSetForm_Load > InitControl | 160 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > Find_Data | 407 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > Find_Data | 409 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > Find_Data | 411 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetBasisTime | 3790 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetDivision | 3800 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetPlanner | 3813 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetPlanGroup | 3874 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetFpPlanId | 3903 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetSite | 3982 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetPlant | 3989 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetFactory | 4000 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetOperation | 4010 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetLine | 4034 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > GetOperation | 7005 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton5.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend | 1049 | FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT |
| event:this.usrButton5.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1189 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton5.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1195 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton5.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1197 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton5.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1199 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton5.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1256 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton5.Click | btnCreatePlan_Click | 2713 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton5.Click | btnCreatePlan_Click > SetFpPlanId > SetBasisTime | 3790 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton5.Click | btnCreatePlan_Click > SetFpPlanId | 3903 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton6.Click | btnRelease_Click > FindButton > UIFindData > Find_Data_Amend | 1049 | FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT |
| event:this.usrButton6.Click | btnRelease_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1189 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton6.Click | btnRelease_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1195 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton6.Click | btnRelease_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1197 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton6.Click | btnRelease_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1199 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton6.Click | btnRelease_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1256 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton6.Click | btnRelease_Click | 2796 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.usrButton6.Click | btnRelease_Click | 2796 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.usrButton6.Click | btnRelease_Click | 2834 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] | BIZ_MATCH |  |
| event:this.usrButton6.Click | btnRelease_Click | 2834 | FP\Common\XpCommonAmend#find_instanceInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_instanceInfo.sql |
| event:this.usrButton6.Click | btnRelease_Click | 2835 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] | BIZ_MATCH |  |
| event:this.usrButton6.Click | btnRelease_Click | 2835 | FP\Common\XpCommonAmend#find_planInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_planInfo.sql |
| event:this.usrButton6.Click | btnRelease_Click | 2849 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton6.Click | btnRelease_Click | 2869 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton6.Click | btnRelease_Click | 2872 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton6.Click | btnRelease_Click > SetFpPlanId > SetBasisTime | 3790 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton6.Click | btnRelease_Click > SetFpPlanId | 3903 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 144 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Exec_Procedure | 763 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| unreached:(진입점 미연결) | ExcelPopup_CheckBeforSave | 4968 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 5453 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 5453 | FP\{?default:part_service}\FP02842_EXCELIMPORT#insert_Excel_buffer | UNRESOLVED |  |
| unreached:(진입점 미연결) | Find_Data_Excel_Buffer_Valid | 5496 | FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Save_Data_Excel_Column | 5555 | FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Save_Data_Excel_Row | 5614 | FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Delete_Data_Excel_Buffer | 5654 | FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Query | 6320 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Query | 6320 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| unreached:(진입점 미연결) | Query | 6321 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Query | 6321 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| unreached:(진입점 미연결) | Query | 6355 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Query | 6355 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| unreached:(진입점 미연결) | Query | 6356 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Query | 6356 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 33 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | 1 | SP PR_UI_FP00622_AMEND_LINE_SAVE | EXEC:PR_UI_FP00622_AMEND_LINE_SAVE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP02842_AMEND_LINE | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY | 4 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP02842_AMEND_LINE_SAVE | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP02842_AMEND_SAVE | MATCH | 1 | SP PR_UI_FP02842_AMEND_SAVE | EXEC:PR_UI_FP02842_AMEND_SAVE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | MATCH | 1 | SP PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | EXEC:PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | ⚠ DB에 SP 없음 |
| FP\{?default:part_service}\FP02842_EXCELIMPORT#insert_Excel_buffer | UNRESOLVED | 1 |  |  |  |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql | SELECT:FP_AMEND_MEMO_M, SELECT:FP_AMEND_SETUP_COLOR_M |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#find_instanceInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_instanceInfo.sql | SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M |  |
| FP\Common\XpCommonAmend#find_planInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_planInfo.sql | SELECT:SCM_FP_PLAN_H |  |
| FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql | SELECT:FP_USER_ROLE_INFO_V |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO |
| ApplyAmendCalendarCondition_ForExcel | Filter | BUCKET_FROM, PLAN_DATE, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplySearchCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_ID, AMEND_TABLE, TOTAL_TABLE, PLAN_TYPE, MASTER_ID, INSTANCE_ID |
| btnBucket_Click | Application.OpenForms | FP02842_BucketSetForm_Popup |
| btnCatagory_Click | Application.OpenForms | FP02842_MeasureSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnCreatePlan_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, PLAN_ID |
| btnCreatePlan_Click | dtSite.Rows[0] | CODE |
| btnCreatePlan_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnCreatePlan_Click | Application.OpenForms | FP00590_PlanTotalPopup |
| btnExcelImport_Click | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_DATE |
| btnExcelImport_Click | Application.OpenForms | FPC0095_ExcelSelect_Popup |
| btnExcelImport_Click | colPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID |
| btnExcelImport_Click | colPopup.ColumnTitle | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, NICK_NAME |
| btnExcelImport_Click | rowPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PLAN_DATE, QTY |
| btnExcelImport_Click | rowPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, NICK_NAME, PLAN_DATE, PC_OUT_QTY, JR_OUTQTY |
| btnRelease_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_ID, PLAN_DATE, DESCRIPTION |
| btnRelease_Click | dtPlanInfo.Rows[0] | DESCRIPTION, PLAN_TYPE |
| btnRelease_Click | dtEngineFlag.Rows[0] | INBOUND, ENGINE, OUTBOUND |
| btnRelease_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnRelease_Click | dtParam2.Rows[0] | CONFIRM_AREA, IS_SAME_PLAN_ID, USE_WOW_STATUS |
| btnRelease_Click | Application.OpenForms | FP00590_GroupReleaseTotalPopup |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| btnUpload_Click | each_row | DIVISION_ID, ITEM_ID |
| btnUpload_Click | row | DIVISION_ID, ITEM_ID, APPLIED_MODEL |
| btnUpload_Click | UomResult.First() | VALUE |
| btnUpload_Click | dsSource.Tables[0].Rows[iRow] | PLAN_DATE, QTY, ADJUST_IN_QTY_KG |
| cbo_fpplanid_changed | dtPlanId.Rows[selected] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE, INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| cbo_plan_group_changed | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| chk_includeSubOp_onchanged | Filter | AMEND_MAIN_FLAG |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_total_d, chk_roll, chk_outqty, chk_result, chk_load, chk_remain |
| CreateFilterDataSet | x | _MM_ |
| Delete_Data_Excel_Buffer | Filter | INSTANCE_ID |
| DrawSheet | Filter | DONOTEDIT |
| dtpPeriod_ValueChanged | Filter | PLAN_TYPE, CURR_DATE |
| EditCommon | clicked_row | CATEGORY_ID |
| ExcelPopup_BufferValidation_Column | filter | MPP_WPP |
| ExcelPopup_BufferValidation_Column | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, COMPANY_ID, PLAN_DATE, SITE_ID |
| ExcelPopup_BufferValidation_Column | dateMap.Tables[0].Rows[j] | _DATE |
| ExcelPopup_BufferValidation_Column | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, QTY, SEQ, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY_KG, USER_ID, JOB_ORDER |
| ExcelPopup_BufferValidation_Column | data.Tables[0].Rows[i] | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET |
| ExcelPopup_BufferValidation_Column | each_row | _VALID |
| ExcelPopup_BufferValidation_Row | filter | MPP_WPP |
| ExcelPopup_BufferValidation_Row | data.Tables[0].Rows[i] | QTY, PLAN_DATE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, SEQ |
| ExcelPopup_BufferValidation_Row | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, QTY, SEQ, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY_KG, USER_ID, JOB_ORDER |
| ExcelPopup_BufferValidation_Row | Filter | INSTANCE_ID, PLAN_ID, COMPANY_ID, PLAN_DATE, SITE_ID |
| ExcelPopup_BufferValidation_Row | each_row | _VALID |
| ExcelPopup_CheckBeforSave | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, PLAN_DATE |
| ExcelPopup_CheckBeforSave | dtChk.Rows[0] | _TYPE |
| ExcelPopup_SaveExcel_Column | filter | MPP_WPP, INSTANCE_ID, SITE_ID |
| ExcelPopup_SaveExcel_Column | Filter | MPP_WPP |
| ExcelPopup_SaveExcel_Row | filter | MPP_WPP, INSTANCE_ID, SITE_ID |
| ExcelPopup_SaveExcel_Row | Filter | MPP_WPP |
| ExcelPopup_Search_Column | Filter | BUCKET_FROM, BUCKET_TO |
| ExcelPopup_Search_Column | filter | MPP_WPP |
| ExcelPopup_Search_Row | Filter | BUCKET_FROM, BUCKET_TO |
| ExcelPopup_Search_Row | filter | MPP_WPP |
| Exec_Procedure | Filter | INSTANCE_ID, PLAN_ID |
| Exec_Procedure | this.Filter | INSTANCE_ID, PLAN_ID |
| Find_Data | Filter | BUCKET_FROM, BUCKET_TO, MPP_WPP, PLAN_DATE |
| Find_Data | this.Filter | PLAN_TYPE |
| Find_Data_Amend | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PLAN_TYPE, PROD_TYPE, TOP_ITEM_ID, ITEM_ID, NICK_NAME, UOM, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_TABLE, TOTAL_TABLE, PRODUCTION_TYPE |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| Find_Save_Valid | Filter | INSTANCE_ID, MASTER_ID, PLAN_DATE, PLAN_ID |
| GetOperation | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, AMEND_MAIN_FLAG, OPERATION_ID |
| GoEditMode | Filter | PLAN_ID, PLAN_TYPE, UOM |
| GoEditMode | row | DATA_TYPE, CATEGORY_ID, EDIT_YN, INSERT_START_DATE, INSERT_END_DATE |
| InitControls | Filter | BUCKET_TO, BUCKET_FROM, CURR_DATE, MPP_WPP, USER_ID, MASTER_ID, INSTANCE_ID, UI_END_DATE |
| InitControls | this.Filter | PLAN_TYPE, BUCKET_FROM, CURR_DATE, BUCKET_TO |
| Insert_Buffer_Data | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, QTY, SEQ, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY_KG, USER_ID, JOB_ORDER |
| Insert_Buffer_Data | Filter | INSTANCE_ID, PLAN_ID, COMPANY_ID |
| Insert_Buffer_Data | data.Rows[i] | PLAN_DATE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ADJUST_OUT_QTY_BATCH, SEQ, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY_KG |
| Insert_Data_Excel_Buffer | result.Rows[0] | RESULT, EXCEPTION |
| lfn_getYieldInfo_Excel | each_row | D_VALUE, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, START_DATE, END_DATE |
| lfn_getYieldInfo_Excel | Result.First() | _DATE |
| lfn_getYieldInfo_Excel | row | FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID |
| lfn_getYieldInfo_Excel | YieldResult.First() | YIELD |
| lfn_setExchangeBatch | x | FACTORY_ID, ITEM_ID |
| lfn_setExchangeBatch | row | FACTORY_ID, ITEM_ID |
| lfn_setExchangeBatch | selected | LANE_QTY |
| lfn_setExchangeBatch_Excel | each_row | D_VALUE, FACTORY_ID, OPERATION_ID, ITEM_ID, CATEGORY, LINE_ID, EQUIPMENT_ID, START_DATE, END_DATE |
| lfn_setExchangeBatch_Excel | Result.First() | _DATE |
| lfn_setExchangeBatch_Excel | row | FACTORY_ID, OPERATION_ID, ITEM_ID, LINE_ID, EQUIPMENT_ID |
| lfn_setExchangeBatch_Excel | UomResult.First() | VALUE |
| lfn_setExchangeBatch_Excel | YieldResult.First() | CHILD_YIELD |
| lfn_setExchangeLoad | x | FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, ITEM_ID, PLAN_DT, SHIFT |
| lfn_setExchangeLoad | row | FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, ITEM_ID |
| lfn_setExchangeLoad | selected | JR_OUT_QTY, YIELD, TACT_TIME, UTILIZATION, WORK_TIME, LOAD |
| lfn_setExchangeLoad | related_row | LOAD |
| lfn_setExchangeRoll | x | FACTORY_ID, ITEM_ID |
| lfn_setExchangeRoll | row | FACTORY_ID, ITEM_ID |
| lfn_setExchangeRoll | selected | JR_M_ROLL |
| lfn_setReleaseProcess | Filter | INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA |
| lfn_setReleaseProcess | dtIsCurrWeek.Rows[0] | CURR_DATE |
| lfn_setReleaseProcess | row | _DATE, IS_PLAN |
| MakeMemoFontBold | dsMainFiltered.Tables[0].Rows[i] | CATEGORY_ID |
| MakeMemoFontBold | Filter | PLAN_TYPE |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID, DATA_TYPE |
| onZeroBucketMenu | Filter | PLAN_TYPE |
| onZeroLineMenu | Filter | PLAN_ID, PLAN_TYPE |
| onZeroLineMenu | row | LINE_ID, DIVISION_ID, SITE_ID, FACTORY_ID |
| onZeroLineMenu | dsMainFiltered.Tables[0].Rows[i] | DATA_TYPE, LINE_ID, DIVISION_ID, SITE_ID, FACTORY_ID |
| onZeroLineMenu | row_to_test | CATEGORY_ID, DATA_TYPE |
| onZeroMaterialMenu | Filter | PLAN_ID, PLAN_TYPE |
| onZeroMaterialMenu | row | LINE_ID, ITEM_ID |
| onZeroMaterialMenu | dsMainFiltered.Tables[0].Rows[i] | DATA_TYPE, LINE_ID, ITEM_ID |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID, DATA_TYPE |
| OpenAlarmMemo | row | PRODUCTION_TYPE |
| OpenAlarmMemo | frm.Filter | MEMO_TYPE |
| OpenAndLoadExcelData | each_row | DIVISION_ID, ITEM_ID |
| OpenAndLoadExcelData | row | DIVISION_ID, ITEM_ID, APPLIED_MODEL |
| OpenAndLoadExcelData | UomResult.First() | VALUE |
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| planday_changed | Filter | PLAN_DATE |
| Query | d | DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, MARKET, PLAN_DATE, PRODUCTION_TYPE, SETUP_COLOR_CODE |
| Query | m | ATTR1 |
| Query | rCate | SEGMENT1, ATTRIBUTE2 |
| rdo_uom_SelectedIndexChanged | Filter | UOM |
| RunSqlSource | Filter | PLAN_TYPE |
| Save_Data_Amend | dtData.Rows[i] | INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, SHIFT, JR_OUT_QTY, PC_OUT_QTY, PRODUCTION_TYPE |
| Save_PIn_Data | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, PLAN_TYPE |
| Save_PIn_Data | dtCheckSave.Rows[0] | _TYPE |
| SaveToDB | dsMain.Tables[0].Rows[i] | MESSAGE, USER_ID, JOB_ORDER |
| SaveToDB | this.Filter | PLAN_TYPE, MPP_WPP |
| SaveToDB | Filter | MPP_WPP |
| SaveToDB | eachRow | _VALID |
| SaveToDB | Application.OpenForms | FP02842_InValidationExcelPopup |
| SaveToDB | valrow | _VALID, _MSG |
| SaveToDB | xlsrow | MESSAGE |
| SearchListInfoAll | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, INSTANCE_ID, PLAN_ID, AMEND_BOR_TABLE |
| SetAmendHeaderColumn_FP_Local | row | COLUMN_NAME, COLUMN_LABEL_NAME |
| SetBasisTime | dtBaseTime.Rows[0] | BASIS_TIME |
| SetBohTotalQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | each_row | _TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | result.First() | QTY |
| SetColMerge | row | VISIBLE_FLAG |
| SetColMerge | measure | chk_Shift_1, chk_Shift_2 |
| SetColMerge | dtTmp.Rows[j] | CATEGORY_ID |
| SetColumnChangeByText | dsResult.Tables[0].Rows[k] | DATA_TYPE, CATEGORY_ID |
| SetDivision | Filter | INSTANCE_ID |
| SetFactory | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, CONFIRM_AREA, DIVISION_ID, SITE_ID, PLANT_ID |
| SetFpPlanId | dtPlanId.Rows[iDx] | CODE, NAME, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, BASIS_PLAN_ID, DEMAND_PLAN_ID, SCP_PLAN_ID |
| SetFpPlanId | dtPlanId.Rows[0] | INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| SetLine | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID |
| setMeasualFormData | dtCategory.Rows[i] | MEA_ID, MEA_VALUE |
| SetOperation | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| SetPlanGroup | dtInstance.Rows[0] | CODE, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetPlanInBatch_DataSet | dateMap.Tables[0].Rows[dateMap.Tables[0].Rows.Count - 1] | D_VALUE |
| SetPlanInBatch_DataSet | clicked_row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, ELECTRODE_TYPE, CATEGORY_ID |
| SetPlanInBatch_DataSet | measure | chk_roll, chk_load, chk_total_d, chk_remain, chk_Shift_1, chk_Shift_2 |
| SetPlanInBatch_DataSet | x | FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, ITEM_ID, PRODUCTION_TYPE, CATEGORY_ID, DATA_TYPE, EQUIPMENT_ID, PLAN_DATE, SHIFT |
| SetPlanInBatch_DataSet | selected | JR_OUT_QTY, PC_OUT_QTY |
| SetPlanInBatch_DataSet | newrow | INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, SHIFT, PRODUCTION_TYPE, JR_OUT_QTY, PC_OUT_QTY |
| SetPlanInBatch_DataSet | Filter | INSTANCE_ID, PLAN_ID |
| SetPlanInBatch_DataSet | row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, PRODUCTION_TYPE |
| SetPlanInBatch_DataSet | dsListData.Tables | Table |
| SetPlanner | row | NAME, DEFAULT_CHECK, CODE |
| SetPlanner | Filter | ALL_LINE |
| SetPlanPeriod | dDefaultDatePeriod.Rows[0] | START_DATE, END_DATE |
| SetPlanPeriod | Filter | BUCKET_FROM, BUCKET_TO |
| SetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID |
| SetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID |
| SetTotalColor | row | DATA_TYPE |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE, FACTORY_ID |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | PRODUCTION_TYPE, ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| SwitchMemo | materialRow | PRODUCTION_TYPE |
| UIFindData | Filter | PLAN_ID, PLAN_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:132, InitControl:156, Measure:151, InitControl:182, CheckAndGetMeasure:1612, RefreshSpreadSheet:6125 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| GetSpdTitle | SetAmendHeaderColumn_FP_Local:609, SearchListInfoAll:976, SetAmendHeaderColumn_FP_Local:491, SearchListInfoAll:4997, SearchListInfoAll:929 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetMenuColumn | SetAmendHeaderColumn_FP_Local:632, SetAmendHeaderColumn_FP_Local:653, SetAmendHeaderColumn_FP_Local:515, SetAmendHeaderColumn_FP_Local:540, SetAmendHeaderColumn_FP_Local:574 | MenuService.SetMenuColumn | CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, DATA_SORT_METHOD_CODE, DEFAULT_FLAG, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, SORT_ORDER_NO, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, VALID_YN |
| SetSheetHeaderColumn | SetAmendHeaderColumn_FP_Local:673, SetAmendHeaderColumn_FP_Local:599 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| FP_Log | OpenAndLoadExcelData:1000, OpenAndLoadExcelData:720 | DataService.FP_Log | LOGTYPE, NOTE, USER_ID |
| CommonDefaultLineCheck | DefaultLineCheck:1243, DefaultLineCheck:747 | ExcelService.CommonDefaultLineCheck | BUCKET_FROM, BUCKET_TO, MESSAGE, QTY |
| SetFilter | InitControls:337, InitControls:338, InitControls:339, InitControls:340, InitControls:342, InitControls:344, InitControls:354, InitControls:355 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | InitControls:389, UIFindData:750, ApplySearchCondition:1129, cbo_plan_group_changed:2263, mcbo_planner_changed:2287, mcbo_division_changed:2450, mcbo_site_changed:2458, mcbo_plant_changed:2464 | CString.GetCheckedListValue | CODE |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1715 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| GetChanges | Save_PIn_Data:1846, RunSqlSource:4781 | FPExtensions.GetChanges | ROW_ID |
| FP_Log2 | cbo_plan_group_changed:2261, cbo_plan_group_changed:2282 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| FP_PseudoBatch | Insert_Data_Excel_Buffer:5453 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| LoadAmendColumn | DrawHeader:6249 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| EditQuery | DrawSheet:6287, Query:6372 | FPExtensions.EditQuery | ROW_ID |
| SetTotalColor | DrawSheet:6296 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btbSet | Click | btnSet_Click | InitializeComponent:145 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:182 |
| this | Load | MeasureSetForm_Load | InitializeComponent:219 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:220 |
| this | Load | Form_Load | .ctor:174 |
| this.dtpPeriod | ValueChanged | dtpPeriod_ValueChanged | InitializeComponent:189 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:265 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:317 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:358 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:399 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:440 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:556 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:557 |
| this.btnSet | Click | btnSet_Click | InitializeComponent:224 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:261 |
| this | Load | MeasureSetForm_Load | InitializeComponent:290 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:291 |
| this | Load | Form_Load | .ctor:222 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:283 |
| mcbo_planner | SelectedIndexChanged | mcbo_planner_changed | InitEvent:284 |
| drpPlanDate | DateTimeChanged | planday_changed | InitEvent:285 |
| cbo_fpplanid | SelectedIndexChanged | cbo_fpplanid_changed | InitEvent:286 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:288 |
| mcbo_site | SelectedIndexChanged | mcbo_site_changed | InitEvent:289 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:290 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:291 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:292 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:293 |
| mcbo_prodtype | SelectedIndexChanged | mcbo_prodtype_changed | InitEvent:294 |
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:297 |
| drpPeriod | ValueChanged | dCalendarPlanrange_changed | InitEvent:300 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:302 |
| dsdmAmend | Changed | SheetChanged | InitEvent:306 |
| popSql | OnSql | RunSqlSource | btnSql_Click:3149 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:4722 |
| this.chk_includeSubOp | CheckedChanged | chk_includeSubOp_onchanged | InitializeComponent:354 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:429 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:469 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:508 |
| this.chk_Info | CheckedChanged | chk_Info_CheckedChanged | InitializeComponent:746 |
| this.cbo_fpplanid | DropDown | cbo_fpplanid_DropDown | InitializeComponent:955 |
| this.rdo_uom | SelectedIndexChanged | rdo_uom_SelectedIndexChanged | InitializeComponent:1044 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:2531 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:2532 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:2533 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:2534 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:2535 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:2536 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:2537 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:2538 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:2539 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:2540 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:2541 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:2542 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:2543 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:2544 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:2545 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:2546 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:2547 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:2548 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:2549 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:2550 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:2551 |
| this.button1 | Click | button1_Click | InitializeComponent:2680 |
| this.usrButton6 | Click | btnRelease_Click | InitializeComponent:2921 |
| this.usrButton5 | Click | btnCreatePlan_Click | InitializeComponent:2960 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:2998 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:3036 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:3074 |
| this | Load | Form_Load | .ctor:168 |
| this.dtpPeriod | ValueChanged | dtpPeriod_ValueChanged | InitializeComponent:172 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:213 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:265 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:306 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:347 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:388 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:476 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:477 |

## 6. 컨트롤 (194개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 53 | layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem3, layoutControlItem7, layoutControlItem1, lblMPPWPP, layoutControlItem18, layoutControlItem19, layoutControlItem20, layoutControlItem21, layoutControlItem23, layoutControlItem24, layoutControlItem25 … |
| UsrButton | 26 | btbSet, btnOK, btnSave, btnClose, btnFind, btnDownload, btnUpload, btnSet, btnOK, btnSql, btnExcelImport, btnToggleSave, usrButton1, usrButton3, usrButton4 … |
| Label | 15 | label2, label1, label2, label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label2, label1 |
| CheckBox | 13 | chk_week, chk_month, chk_day, chk_Shift_2, chk_Shift_1, chk_roll, chk_remain, chk_load, chk_outqty, chk_total_d, chk_total, chk_subTotal, chk_result |
| UsrCheckedList2 | 13 | mcbo_line, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_site, mcbo_division, mcbo_planner, clbDivision, clbProdType, clbFactory, clbPlant, cboSite, mcbo_prodtype |
| Panel | 9 | panel1, panel2, panel1, panel3, infoPanel, panel2, panel3, panel4, panel1 |
| UsrLayoutControl | 7 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 7 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup4, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 6 | cbo_fpplanid, cbo_plan_group, cboUom, cboInstance, cboPlanId, cbo_RoundPoint |
| EmptySpaceItem | 5 | emptySpaceItem1, emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem1 |
| FpSpread | 5 | spdMain, spdMain, spdEdit, spdInfo, spdMain |
| SheetView | 5 | spdMain_Sheet1, spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1, spdMain_Sheet1 |
| UsrCheckBox | 5 | chk_includeSubOp, chk_plannedline, chk_allLine, chk_Info, usrCheckBox1 |
| ImageList | 4 | imageList1, imageList2, imageList1, imageList1 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| RadioGroup | 3 | rdoGroup1, rdo_uom, rdo_Unit |
| UsrTextBox | 3 | txtNickName, txtItem, usrTextBox1 |
| UsrDateRangePicker2 | 2 | dtpPeriod, dtpPeriod |
| UsrLabel | 2 | usrLabel1, lblPlanID |
| UsrDatePickerWtWeek | 1 | drpPlanDate |
| UsrPopupTextBox | 1 | tbNickName |
| UsrDateRangePickerWtWeek | 1 | drpPeriod |
| SplitContainer | 1 | splitter |
| Button | 1 | button1 |
| GroupBox | 1 | groupBox1 |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (15건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2019 | Find_Save_Valid | FP_Planning.PR_UI_FP02842_AMEND_LINE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 2192 | Exec_Procedure | FP_Planning.PR_UI_FP02842_AMEND_LINE_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5108 | Find_Data_Excel_Import | FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5496 | Find_Data_Excel_Buffer_Valid | FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5555 | Save_Data_Excel_Column | FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5614 | Save_Data_Excel_Row | FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5654 | Delete_Data_Excel_Buffer | FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 6320 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 6321 | Query | FP\{?default:part_service}\AmendMemo#list_setup_color_code | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2796 | btnRelease_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2834 | btnRelease_Click | FP\{?default:part_service}\XpCommonAmend#find_instanceInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2835 | btnRelease_Click | FP\{?default:part_service}\XpCommonAmend#find_planInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 6355 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 6356 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5453 | Insert_Data_Excel_Buffer | FP\{?default:part_service}\FP02842_EXCELIMPORT#insert_Excel_buffer | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 19 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 65 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP02842 | Amend | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ExcelColumnPopup, Amend, AutoExcelPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetAmendHeaderColumn_FP_Local:673, SetSheetHeaderColumn@SetAmendHeaderColumn_FP_Local:599, SetSheetHeaderColumn_FP@DrawHeader:6190
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| Find_Data |  | 468 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(OnSearchData != null) ⟫ if(Calendar != null && set.Good()) ⟫ foreach(date_item in Calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| Find_Data |  | 473 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(OnSearchData != null) ⟫ if(Calendar != null && set.Good()) ⟫ foreach(date_item in Calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| Find_Data |  | 489 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(OnSearchData != null) ⟫ if(Calendar != null && set.Good()) ⟫ foreach(date_item in Calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| Find_Data |  | 494 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(OnSearchData != null) ⟫ if(Calendar != null && set.Good()) ⟫ foreach(date_item in Calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| SetSheetHeadColor |  | 562 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.FromArgb(0, 113, 0)} |  | for(idx < siMain.ActiveSheet.Columns.Count) ⟫ if(sHeadName.IndexOf("*") >= 0) |
| InitializeComponent |  | 573 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 574 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 575 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 576 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetCalenderColor |  | 6487 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day != null) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 6491 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day != null) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 6498 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day != null) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 6501 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day != null) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| spdMain_CellDoubleClick |  | 6792 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx < iWeekCount) |
| InitializeComponent |  | 2567 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2568 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2569 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2570 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 3118 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 3119 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 3120 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 3121 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 3169 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 3170 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 3171 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 3172 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| Find_Data |  | 392 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| Find_Data |  | 393 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| Find_Data |  | 394 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 493 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 494 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 495 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 496 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
