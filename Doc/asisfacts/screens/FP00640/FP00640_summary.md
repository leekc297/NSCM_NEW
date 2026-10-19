# FP00640 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 260 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_BucketSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 194 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 7062 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 3286 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_InvDetail_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 650 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_InvDetail_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 209 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 401 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 468 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_planOptionSelect_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 146 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_planOptionSelect_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 97 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00640_ILT_MODULE\FP00640_ILT_MODULE.csproj | 64 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetDivision | 4033 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetSite | 4041 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetPlant | 4048 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1015 | FP_Planning.PR_UI_FP00640_ILT_MODULE | MATCH | SP PR_UI_FP00640_ILT_MODULE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1143 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1149 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1151 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1153 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1210 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetPlant | 4048 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetPlant | 4048 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1015 | FP_Planning.PR_UI_FP00640_ILT_MODULE | MATCH | SP PR_UI_FP00640_ILT_MODULE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1143 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1149 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1151 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1153 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > lfn_setReleaseProcess | 1210 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Save_Valid | 1869 | FP_Planning.PR_UI_FP00640_AMEND_LINE | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Amend | 1988 | FP_Planning.PR_UI_FP00640_AMEND_SAVE | MATCH | SP PR_UI_FP00640_AMEND_SAVE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5120 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5126 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5128 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5130 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5136 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Excel_Import | 5348 | FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend | 1015 | FP_Planning.PR_UI_FP00640_ILT_MODULE | MATCH | SP PR_UI_FP00640_ILT_MODULE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1143 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1149 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1151 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1153 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1210 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_PIn_Data | 1680 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_PIn_Data > Save_Data_Amend | 1988 | FP_Planning.PR_UI_FP00640_AMEND_SAVE | MATCH | SP PR_UI_FP00640_AMEND_SAVE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 1015 | FP_Planning.PR_UI_FP00640_ILT_MODULE | MATCH | SP PR_UI_FP00640_ILT_MODULE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1143 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1149 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1151 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1153 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1210 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 1015 | FP_Planning.PR_UI_FP00640_ILT_MODULE | MATCH | SP PR_UI_FP00640_ILT_MODULE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1143 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1149 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1151 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1153 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1210 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCopyDischarging.Click | btnCopyDischarging_Click > FindButton > UIFindData > Find_Data_Amend | 1015 | FP_Planning.PR_UI_FP00640_ILT_MODULE | MATCH | SP PR_UI_FP00640_ILT_MODULE |
| event:this.btnCopyDischarging.Click | btnCopyDischarging_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1143 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCopyDischarging.Click | btnCopyDischarging_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1149 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCopyDischarging.Click | btnCopyDischarging_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1151 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCopyDischarging.Click | btnCopyDischarging_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1153 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCopyDischarging.Click | btnCopyDischarging_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1210 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCopyDischarging.Click | btnCopyDischarging_Click | 3082 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=PR_SCM_PACK_FORM_PLAN_DCP_UPDATE] | BIZ_MATCH |  |
| event:this.btnCopyDischarging.Click | btnCopyDischarging_Click | 3082 | FP\Planning\FP00640#PR_SCM_PACK_FORM_PLAN_DCP_UPDATE | MATCH | SP PR_SCM_PACK_FORM_PLAN_DCP_UPDATE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan > FindButton > UIFindData > Find_Data_Amend | 1015 | FP_Planning.PR_UI_FP00640_ILT_MODULE | MATCH | SP PR_UI_FP00640_ILT_MODULE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1143 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1149 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1151 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1153 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1210 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click | 2575 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan | 2626 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=PR_SCM_PACK_FORM_PLAN] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan | 2626 | FP\Planning\FP00640#PR_SCM_PACK_FORM_PLAN | MATCH | SP PR_SCM_PACK_FORM_PLAN |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan > Save_Create_PlanData | 2902 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan > Save_Create_PlanData | 2949 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL | MATCH | SP PR_UI_FP00590_PLAN_CONTROL |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan > Save_Create_PlanData > SetDsinDataByControl | 2993 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > Save_Create_Plan > Save_Create_PlanData > SetDsinDataByControl | 2994 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click > Confirm_Plan | 2788 | FP_Planning.PR_UI_FP00640_AMEND_SAVE | MATCH | SP PR_UI_FP00640_AMEND_SAVE |
| event:this.btnRelease.Click | btnRelease_Click | 3045 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpdateSSP.Click | btnUpdateSSP_Click > FindButton > UIFindData > Find_Data_Amend | 1015 | FP_Planning.PR_UI_FP00640_ILT_MODULE | MATCH | SP PR_UI_FP00640_ILT_MODULE |
| event:this.btnUpdateSSP.Click | btnUpdateSSP_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1143 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpdateSSP.Click | btnUpdateSSP_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1149 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpdateSSP.Click | btnUpdateSSP_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1151 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpdateSSP.Click | btnUpdateSSP_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1153 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpdateSSP.Click | btnUpdateSSP_Click > FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1210 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpdateSSP.Click | btnUpdateSSP_Click | 2507 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=PR_SCM_PACK_FORM_PLAN_UPDATE] | BIZ_MATCH |  |
| event:this.btnUpdateSSP.Click | btnUpdateSSP_Click | 2507 | FP\Planning\FP00640#PR_SCM_PACK_FORM_PLAN_UPDATE | MATCH | SP PR_SCM_PACK_FORM_PLAN_UPDATE |
| event:this.Load | MeasureSetForm_Load > InitControl | 183 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetPlanDate | 4022 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetDivision | 4033 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetSite | 4041 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetPlant | 4048 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 179 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Exec_Procedure | 2041 | FP_Planning.PR_UI_FP00640_AMEND_LINE_SAVE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | ExcelPopup_CheckBeforSave | 5204 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 5693 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 5693 | FP\{?default:part_service}\FP00640_EXCELIMPORT#insert_Excel_buffer | UNRESOLVED |  |
| unreached:(진입점 미연결) | Find_Data_Excel_Buffer_Valid | 5736 | FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Save_Data_Excel_Column | 5795 | FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Save_Data_Excel_Row | 5854 | FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Delete_Data_Excel_Buffer | 5894 | FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=PR_SCM_PACK_FORM_PLAN_DCP_UPDATE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=PR_SCM_PACK_FORM_PLAN_UPDATE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=PR_SCM_PACK_FORM_PLAN] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 19 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00590_PLAN_CONTROL | MATCH | 1 | SP PR_UI_FP00590_PLAN_CONTROL | EXEC:PR_UI_FP00590_PLAN_CONTROL | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00640_AMEND_LINE | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY | 4 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP00640_AMEND_LINE_SAVE | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP00640_AMEND_SAVE | MATCH | 2 | SP PR_UI_FP00640_AMEND_SAVE | EXEC:PR_UI_FP00640_AMEND_SAVE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00640_ILT_MODULE | MATCH | 1 | SP PR_UI_FP00640_ILT_MODULE | EXEC:PR_UI_FP00640_ILT_MODULE | ⚠ DB에 SP 없음 |
| FP\{?default:part_service}\FP00640_EXCELIMPORT#insert_Excel_buffer | UNRESOLVED | 1 |  |  |  |
| FP\Planning\FP00640#PR_SCM_PACK_FORM_PLAN | MATCH | 1 | SP PR_SCM_PACK_FORM_PLAN | EXEC:PR_SCM_PACK_FORM_PLAN | ⚠ DB에 SP 없음 |
| FP\Planning\FP00640#PR_SCM_PACK_FORM_PLAN_DCP_UPDATE | MATCH | 1 | SP PR_SCM_PACK_FORM_PLAN_DCP_UPDATE | EXEC:PR_SCM_PACK_FORM_PLAN_DCP_UPDATE | ⚠ DB에 SP 없음 |
| FP\Planning\FP00640#PR_SCM_PACK_FORM_PLAN_UPDATE | MATCH | 1 | SP PR_SCM_PACK_FORM_PLAN_UPDATE | EXEC:PR_SCM_PACK_FORM_PLAN_UPDATE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO |
| ApplyAmendCalendarCondition_ForExcel | Filter | BUCKET_FROM, PLAN_DATE, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplySearchCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_ID, AMEND_TABLE, TOTAL_TABLE, PLAN_TYPE, MASTER_ID, INSTANCE_ID |
| btnBucket_Click | Application.OpenForms | FP00640_BucketSetForm_Popup |
| btnCatagory_Click | Application.OpenForms | FP00640_MeasureSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnCopyDischarging_Click | Filter | PLAN_ID, ILT_INSTANCE_ID |
| btnCopyDischarging_Click | input | P_MASTER_ID, P_PLAN_ID |
| btnCreatePlan_Click | Filter | SITE_ID, INSTANCE_ID, PLAN_DATE |
| btnCreatePlan_Click | dtSite.Rows[0] | CODE |
| btnCreatePlan_Click | dtRefInfo.Rows[0] | IS_ENABLE |
| btnRelease_Click | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| btnUpdateSSP_Click | Filter | PLAN_ID, ILT_INSTANCE_ID, FP_PLAN_ID |
| btnUpdateSSP_Click | input | P_MASTER_ID, P_PLAN_ID |
| cbo_fpplanid_changed | dtPlanId.Rows[selected] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE, INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| cbo_plan_group_changed | dtInstance.Rows[cbo_plan_group.SelectedIndex] | PACK_INSTNACE_ID |
| chk_confirmPlan_CheckedChanged | dtRef.Rows[0] | PLAN_DATE, PLAN_ID |
| Confirm_Plan | Filter | ILT_INSTANCE_ID, PLAN_ID |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_ssp, chk_sspResult, chk_cmaPkg, chk_dischargingPlan, chk_dischargingResult, chk_waitingDischarge, chk_estimatedAgingCompleted, chk_agingStock, chk_chargingPlan, chk_chargingResult, chk_waitingCharge, chk_InHouseInventory, chk_exWarehouse, chk_cmaAssyPlan |
| CreateFilterDataSet | x | _MM_ |
| Delete_Data_Excel_Buffer | Filter | INSTANCE_ID |
| DrawHeader | measure.Data | chk_day, chk_week, chk_month |
| DrawSheet | Filter | DONOTEDIT |
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
| Exec_Procedure | Filter | INSTANCE_ID, PLAN_ID |
| Find_Data_Amend | Filter | ILT_INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PLAN_TYPE, MODEL_ID, MODULE_ID, CELL_ID, NICK_NAME, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_TABLE, TOTAL_TABLE |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| Find_Save_Valid | Filter | INSTANCE_ID, MASTER_ID, PLAN_DATE, PLAN_ID |
| GoEditMode | row | DATA_TYPE, CATEGORY_ID, EDIT_YN |
| InitControls | Filter | USER_ID |
| Insert_Buffer_Data | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, QTY, SEQ, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY_KG, USER_ID, JOB_ORDER |
| Insert_Buffer_Data | Filter | INSTANCE_ID, PLAN_ID, COMPANY_ID |
| Insert_Buffer_Data | data.Rows[i] | PLAN_DATE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ADJUST_OUT_QTY_BATCH, SEQ, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY_KG |
| Insert_Data_Excel_Buffer | result.Rows[0] | RESULT, EXCEPTION |
| lfn_getYieldInfo_Excel | each_row | D_VALUE, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, START_DATE, END_DATE |
| lfn_getYieldInfo_Excel | Result.First() | _DATE |
| lfn_getYieldInfo_Excel | row | FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID |
| lfn_getYieldInfo_Excel | YieldResult.First() | YIELD |
| lfn_setExchangeBatch_Excel | each_row | D_VALUE, FACTORY_ID, OPERATION_ID, ITEM_ID, CATEGORY, LINE_ID, EQUIPMENT_ID, START_DATE, END_DATE |
| lfn_setExchangeBatch_Excel | Result.First() | _DATE |
| lfn_setExchangeBatch_Excel | row | FACTORY_ID, OPERATION_ID, ITEM_ID, LINE_ID, EQUIPMENT_ID |
| lfn_setExchangeBatch_Excel | UomResult.First() | VALUE |
| lfn_setExchangeBatch_Excel | YieldResult.First() | CHILD_YIELD |
| lfn_setReleaseProcess | Filter | INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA |
| lfn_setReleaseProcess | dtIsCurrWeek.Rows[0] | CURR_DATE |
| lfn_setReleaseProcess | row | _DATE, IS_PLAN |
| onMemoMenu | frm.Filter | INSTANCE_ID, MEMO_TYPE |
| onMemoMenu | Filter | INSTANCE_ID |
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
| planday_changed | Filter | PLAN_DATE |
| rdo_uom_SelectedIndexChanged | Filter | UOM |
| RunSqlSource | Filter | PLAN_TYPE |
| Save_Create_Plan | input | P_MASTER_ID, P_PLAN_ID, P_FIX_OPTION |
| Save_Create_Plan | Filter | ILT_INSTANCE_ID |
| Save_Create_PlanData | Filter | ILT_INSTANCE_ID, PLAN_DATE |
| Save_Create_PlanData | dtNewPlanID.Rows[0] | PLAN_ID |
| Save_Data_Amend | dtData.Rows[i] | INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ITEM_ID, MODULE_ITEM_ID, CELL_ITEM_ID, CATEGORY_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE, PLAN_DATE, QTY |
| Save_PIn_Data | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, PLAN_TYPE |
| Save_PIn_Data | dtCheckSave.Rows[0] | _TYPE |
| Set_ChargingPlan | dateMap.Tables[0].Rows[dateMap.Tables[0].Rows.Count - 1] | D_VALUE |
| Set_ChargingPlan | clicked_row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ITEM_ID, MODULE_ITEM_ID, CELL_ITEM_ID, CATEGORY_ID |
| Set_ChargingPlan | measure | chk_estimatedAgingCompleted, chk_agingStock, chk_waitingDischarge, chk_waitingCharge, chk_InHouseInventory, chk_exWarehouse, chk_chargingPlan, chk_cmaAssyPlan |
| Set_ChargingPlan | x | PLANT_ID, MODEL_ITEM_ID, MODULE_ITEM_ID, CELL_ITEM_ID, CATEGORY_ID, DATA_TYPE, PLAN_DATE |
| Set_ChargingPlan | Filter2 | PLAN_DATE, ILT_INSTANCE_ID, PLAN_ID |
| Set_ChargingPlan | dr_inHouse | GOOD_QTY, LONG_TERM_QTY |
| Set_ChargingPlan | dr_exWare | GOOD_QTY, LONG_TERM_QTY |
| Set_ChargingPlan | selected | QTY |
| Set_ChargingPlan | newrow | INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ITEM_ID, MODULE_ITEM_ID, CELL_ITEM_ID, CATEGORY_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE, PLAN_DATE, QTY |
| Set_ChargingPlan | dsListData.Tables | Table |
| Set_DischargingPlan | dateMap.Tables[0].Rows[dateMap.Tables[0].Rows.Count - 1] | D_VALUE |
| Set_DischargingPlan | clicked_row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ITEM_ID, MODULE_ITEM_ID, CELL_ITEM_ID, CATEGORY_ID |
| Set_DischargingPlan | measure | chk_cmaPkg, chk_waitingDischarge |
| Set_DischargingPlan | x | PLANT_ID, MODEL_ITEM_ID, MODULE_ITEM_ID, CELL_ITEM_ID, CATEGORY_ID, DATA_TYPE, PLAN_DATE |
| Set_DischargingPlan | selected | QTY |
| Set_DischargingPlan | newrow | INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ITEM_ID, MODULE_ITEM_ID, CELL_ITEM_ID, CATEGORY_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE, PLAN_DATE, QTY |
| Set_DischargingPlan | Filter2 | ILT_INSTANCE_ID, PLAN_ID |
| Set_DischargingPlan | dsListData.Tables | Table |
| SetBohTotalQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | each_row | _TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | result.First() | QTY |
| SetColMerge | row | VISIBLE_FLAG |
| SetColMerge | measure | chk_Shift_1, chk_Shift_2 |
| SetColMerge | dtTmp.Rows[j] | CATEGORY_ID |
| SetColumnChangeByText | dsResult.Tables[0].Rows[k] | DATA_TYPE, CATEGORY_ID |
| SetDesc2 | dtDesc2.Rows[0] | SSP_TIME, ASSY_TIME, ASSY_PLAN_ID |
| SetDivision | Filter | INSTANCE_ID |
| SetDsinDataByControl | dtLookupByInstance.Rows[0] | PLAN_HORIZON, DEMAND_HORIZON |
| SetDsinDataByControl | dtfixDateInfo.Rows[0] | ALLOWED_FIX_DATE_NULL |
| SetDsinDataByControl | dtSite.Rows[0] | CODE |
| SetFpPlanId | dtPlanId.Rows[iDx] | CODE, NAME, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, BASIS_PLAN_ID, DEMAND_PLAN_ID, SCP_PLAN_ID |
| SetFpPlanId | dtPlanId.Rows[0] | INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| setMeasualFormData | dtCategory.Rows[i] | MEA_ID, MEA_VALUE |
| SetPlanDate | Filter | INSTANCE_ID |
| SetPlanGroup | dtInstance.Rows[0] | PACK_INSTNACE_ID |
| SetPlanPeriod | dDefaultDatePeriod.Rows[0] | START_DATE, END_DATE |
| SetPlanPeriod | Filter | BUCKET_FROM, BUCKET_TO |
| SetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID |
| SetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID |
| SetTotalColor | row | DATA_TYPE |
| spdMain_CellClick2 | row | DATA_TYPE |
| spdMain_CellDoubleClick | clicked_row | CATEGORY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ITEM_ID, MODULE_ITEM_ID, CELL_ITEM_ID |
| spdMain_CellDoubleClick | inputFilter | PLAN_DATE, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, MODULE_ID, CELL_ID, CATEGORY_ID, ILT_INSTANCE_ID |
| spdMain_CellDoubleClick | Filter2 | PLAN_DATE, ILT_INSTANCE_ID |
| UIFindData | Filter | PLAN_ID, PLAN_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:129, InitControl:150, CheckAndGetMeasure:1431, RefreshSpreadSheet:6365, Measure:174, InitControl:214 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:344, InitControls:345, InitControls:346, UIFindData:692, ApplySearchCondition:1078, ApplySearchCondition:1089, ApplySearchCondition:1092, Save_PIn_Data:1754 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetSpdTitle | SetAmendHeaderColumn_FP_Local:450, SearchListInfoAll:5233 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetMenuColumn | SetAmendHeaderColumn_FP_Local:468, SetAmendHeaderColumn_FP_Local:489, SetAmendHeaderColumn_FP_Local:518 | MenuService.SetMenuColumn | CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, DATA_SORT_METHOD_CODE, DEFAULT_FLAG, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, SORT_ORDER_NO, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, VALID_YN |
| SetSheetHeaderColumn | SetAmendHeaderColumn_FP_Local:542 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | UIFindData:692, ApplySearchCondition:1078, cbo_plan_group_changed:2112, mcbo_division_changed:2245, mcbo_site_changed:2252, mcbo_plant_changed:2258, btnCreatePlan_Click:2576, SetDivision:4036 | CString.GetCheckedListValue | CODE |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1566 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| GetChanges | Save_PIn_Data:1697, RunSqlSource:5017 | FPExtensions.GetChanges | ROW_ID |
| FP_Log2 | cbo_plan_group_changed:2110, cbo_plan_group_changed:2127 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| FP_PseudoBatch | Insert_Data_Excel_Buffer:5693 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| LoadAmendColumn | DrawHeader:6487 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| EditQuery | DrawSheet:6514, DrawSheet:6522 | FPExtensions.EditQuery | ROW_ID |
| SetTotalColor | DrawSheet:6530 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btbSet | Click | btnSet_Click | InitializeComponent:120 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:157 |
| this | Load | MeasureSetForm_Load | InitializeComponent:172 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:173 |
| this | Load | Form_Load | .ctor:249 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:305 |
| drpPlanDate | DateTimeChanged | planday_changed | InitEvent:306 |
| cbo_fpplanid | SelectedIndexChanged | cbo_fpplanid_changed | InitEvent:307 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:309 |
| mcbo_site | SelectedIndexChanged | mcbo_site_changed | InitEvent:310 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:311 |
| txtModel | TextChanged | TxtModel_TextChanged | InitEvent:313 |
| txtModule | TextChanged | TxtModule_TextChanged | InitEvent:314 |
| txtCell | TextChanged | TxtCell_TextChanged | InitEvent:315 |
| txtNickName | TextChanged | TxtNickName_TextChanged | InitEvent:316 |
| drpPeriod | ValueChanged | dCalendarPlanrange_changed | InitEvent:318 |
| spdMain | CellClick | spdMain_CellClick2 | InitEvent:320 |
| dsdmAmend | Changed | SheetChanged | InitEvent:323 |
| popSql | OnSql | RunSqlSource | btnSql_Click:3310 |
| drpPlanDate | DateTimeChanged | planday_changed | chk_confirmPlan_CheckedChanged:6923 |
| cbo_fpplanid | SelectedIndexChanged | cbo_fpplanid_changed | chk_confirmPlan_CheckedChanged:6924 |
| drpPlanDate | DateTimeChanged | planday_changed | chk_confirmPlan_CheckedChanged:6935 |
| cbo_fpplanid | SelectedIndexChanged | cbo_fpplanid_changed | chk_confirmPlan_CheckedChanged:6936 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick2:6976 |
| this.btnModelCondition | Click | btnModelCondition_Click | InitializeComponent:340 |
| this.chk_confirmPlan | CheckedChanged | chk_confirmPlan_CheckedChanged | InitializeComponent:378 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:491 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:531 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:570 |
| this.chk_Info | CheckedChanged | chk_Info_CheckedChanged_1 | InitializeComponent:642 |
| this.cbo_fpplanid | DropDown | cbo_fpplanid_DropDown | InitializeComponent:807 |
| this.btnRelease | Click | btnRelease_Click | InitializeComponent:2232 |
| this.btnCreatePlan | Click | btnCreatePlan_Click | InitializeComponent:2271 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:2283 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:2284 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:2285 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:2286 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:2287 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:2288 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:2289 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:2290 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:2291 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:2292 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:2293 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:2294 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:2295 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:2296 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:2297 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:2298 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:2299 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:2300 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:2301 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:2302 |
| this.button2 | Click | button2_Click | InitializeComponent:2468 |
| this.button1 | Click | button1_Click | InitializeComponent:2518 |
| this.btnCopyDischarging | Click | btnCopyDischarging_Click | InitializeComponent:2712 |
| this.btnUpdateSSP | Click | btnUpdateSSP_Click | InitializeComponent:2751 |
| this.btnMenu | Click | btnMenu_Click | InitializeComponent:2764 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:2851 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:2889 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:2927 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:122 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:123 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:124 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:125 |
| this.spdMain | EnabledChanged | spdMain_EnabledChanged | InitializeComponent:126 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:127 |
| this | Load | Form_Load | .ctor:109 |
| this.btnSet | Click | btnSet_Click | InitializeComponent:360 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:397 |
| this | Load | MeasureSetForm_Load | InitializeComponent:426 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:427 |
| this | Load | MeasureSetForm_Load | InitializeComponent:80 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:81 |
| rbOpt1 | CheckedChanged | rbOpt1_Click | MeasureSetForm_Load:86 |
| rbOpt2 | CheckedChanged | rbOpt2_Click | MeasureSetForm_Load:87 |

## 6. 컨트롤 (161개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 33 | layoutControlItem18, layoutControlItem19, layoutControlItem20, layoutControlItem21, layoutControlItem23, layoutControlItem24, layoutControlItem25, layoutControlItem26, layoutControlItem27, layoutControlItem28, layoutControlItem29, layoutControlItem30, layoutControlItem31, layoutControlItem32, layoutControlItem33 … |
| CheckBox | 23 | chk_week, chk_month, chk_day, chk_waitChar, chk_cma, chk_ref, chk_exWarehouse, chk_cmaAssyPlan, chk_InHouseInventory, chk_waitingCharge, chk_chargingResult, chk_chargingPlan, chk_agingStock, chk_estimatedAgingCompleted, chk_dischargedCma … |
| UsrButton | 19 | btbSet, btnOK, btnModelCondition, btnSql, btnExcelImport, btnToggleSave, usrButton1, usrButton3, usrButton4, btnRelease, btnCreatePlan, usrButton2, btnCopyDischarging, btnUpdateSSP, btnBucket … |
| Label | 15 | label8, label3, txtDesc2, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label2, label1, label1, label2 |
| Panel | 10 | panel1, modelPanel, infoPanel, menuPanel, btn_updateSSP, panel4, panel1, panel1, panel3, panel1 |
| UsrCheckedList2 | 8 | mcbo_plant, mcbo_site, mcbo_division, clbDivision, clbProdType, clbFactory, clbPlant, cboSite |
| UsrLayoutControl | 5 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 5 | layoutControlGroup1, layoutControlGroup4, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrTextBox | 5 | txtNickName, txtModel, usrTextBox1, txtModule, txtCell |
| UsrCombo | 5 | cbo_fpplanid, cbo_plan_group, cboUom, cboInstance, cboPlanId |
| UsrCheckBox | 4 | chk_confirmPlan, chk_refModel, chk_Info, usrCheckBox1 |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem1 |
| FpSpread | 4 | spdMain, spdEdit, spdInfo, spdMain |
| SheetView | 4 | spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1, spdMain_Sheet1 |
| Button | 3 | button2, button1, btnMenu |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| ImageList | 2 | imageList2, imageList1 |
| RadioButton | 2 | rbOpt2, rbOpt1 |
| UsrDatePickerWtWeek | 1 | drpPlanDate |
| UsrPopupTextBox | 1 | tbNickName |
| UsrDateRangePickerWtWeek | 1 | drpPeriod |
| SplitContainer | 1 | splitter |
| GroupBox | 1 | groupBox1 |
| UsrLabel | 1 | lblPlanID |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (8건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1869 | Find_Save_Valid | FP_Planning.PR_UI_FP00640_AMEND_LINE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 2041 | Exec_Procedure | FP_Planning.PR_UI_FP00640_AMEND_LINE_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5348 | Find_Data_Excel_Import | FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5736 | Find_Data_Excel_Buffer_Valid | FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5795 | Save_Data_Excel_Column | FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5854 | Save_Data_Excel_Row | FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5894 | Delete_Data_Excel_Buffer | FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5693 | Insert_Data_Excel_Buffer | FP\{?default:part_service}\FP00640_EXCELIMPORT#insert_Excel_buffer | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 42 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 22 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00640 | Amend | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |
| SCM_MST_SHEET_COLUMNS | FP00640 | InvDetail | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend, InvDetail
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetAmendHeaderColumn_FP_Local:542, SetSheetHeaderColumn_FP@DrawHeader:6430, SetSheetHeaderColumn_FP@SetSpreadInit:167
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetCalenderColor |  | 6641 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 6647 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| InitializeComponent |  | 2318 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2319 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2320 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2321 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2971 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2972 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2973 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2974 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 3022 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 3023 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 3024 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 3025 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 145 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 146 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| InvDetail | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
