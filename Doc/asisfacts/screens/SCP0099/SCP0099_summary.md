# SCP0099 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 64 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 1222 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 1073 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_CreatePlanPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 216 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_CreatePlanPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 419 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_ExcelUploadPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 1156 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_ExcelUploadPopup.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 289 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_PlanCopyPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 278 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_PlanCopyPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 503 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_PlanInfoPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 428 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_PlanInfoPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0099_Business_Plan_LongTerm\SCP0099_Business_Plan_LongTerm.csproj | 379 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnNew.Click | BtnNew_Click > setCboPlan | 284 | SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | SP SCP0099_GET_LONGTERM_PLAN |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > setCboPlan | 284 | SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | SP SCP0099_GET_LONGTERM_PLAN |
| button:FindButton | FindButton > FindData | 171 | SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | SP SCP0099_GET_LONGTERM_PLAN |
| button:FindButton | FindButton > FindData_Main | 990 | SCP.SCP0099_GET_LONGTERM_PLAN_DETAIL | MATCH | SP SCP0099_GET_LONGTERM_PLAN_DETAIL |
| button:SaveButton | SaveButton > SaveData | 639 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProdEdit] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 639 | SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanProdEdit | MATCH_PATTERN | SP SCP0099_SAVE_PLAN_PROD_EDIT |
| button:SaveButton | SaveButton > SaveData | 668 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProd] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 668 | SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanProd\|SCP\Analysis\SCP0099_ExcelUploadPopup#SavePlanProd | MATCH_PATTERN | SP SCP0099_SAVE_PLAN_PROD \| SP SCP0099_SAVE_PLAN_PROD |
| button:SaveButton | SaveButton > SaveData | 693 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProdDel] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 693 | SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanProdDel | MATCH_PATTERN | SP SCP0099_SAVE_PLAN_PROD_DEL |
| button:SaveButton | SaveButton > SaveData | 815 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtfEdit] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 815 | SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanRtfEdit | MATCH_PATTERN | SP SCP0099_SAVE_PLAN_RTF_EDIT |
| button:SaveButton | SaveButton > SaveData | 844 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtf] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 844 | SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanRtf\|SCP\Analysis\SCP0099_ExcelUploadPopup#SavePlanRtf | MATCH_PATTERN | SP SCP0099_SAVE_PLAN_RTF \| SP SCP0099_SAVE_PLAN_RTF |
| button:SaveButton | SaveButton > SaveData | 869 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtfDel] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 869 | SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanRtfDel | MATCH_PATTERN | SP SCP0099_SAVE_PLAN_RTF_DEL |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 990 | SCP.SCP0099_GET_LONGTERM_PLAN_DETAIL | MATCH | SP SCP0099_GET_LONGTERM_PLAN_DETAIL |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 160 | SCP.SCP0099_SAVE_LONGTERM_PLAN | MATCH | SP SCP0099_SAVE_LONGTERM_PLAN |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > OKButtonClick > FindData | 171 | SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | SP SCP0099_GET_LONGTERM_PLAN |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > OKButtonClick | 300 | SCP.SCP0099_DEL_LONGTERM_PLAN | MATCH | SP SCP0099_DEL_LONGTERM_PLAN |
| event:this.btnCopy.Click | btnCopy_Click | 244 | SCP.SCP0099_SAVE_LONGTERM_PLAN_COPY | MATCH | SP SCP0099_SAVE_LONGTERM_PLAN_COPY |
| event:this.btnOK.Click | btnOK_Click > SaveProd | 1034 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProd] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click > SaveProd | 1034 | SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanProd\|SCP\Analysis\SCP0099_ExcelUploadPopup#SavePlanProd | MATCH_PATTERN | SP SCP0099_SAVE_PLAN_PROD \| SP SCP0099_SAVE_PLAN_PROD |
| event:this.btnOK.Click | btnOK_Click > SaveRTF | 1131 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtf] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click > SaveRTF | 1131 | SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanRtf\|SCP\Analysis\SCP0099_ExcelUploadPopup#SavePlanRtf | MATCH_PATTERN | SP SCP0099_SAVE_PLAN_RTF \| SP SCP0099_SAVE_PLAN_RTF |
| event:this.btnPlanInfo.Click | btnPlanInfo_Click > setCboPlan | 284 | SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | SP SCP0099_GET_LONGTERM_PLAN |
| event:this.btnRelease.Click | btnRelease_Click > ReleasePlan > FindData | 171 | SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | SP SCP0099_GET_LONGTERM_PLAN |
| event:this.btnRelease.Click | btnRelease_Click > ReleasePlan | 383 | SCP.SCP0099_SAVE_LONGTERM_PLAN_RELEASE | MATCH | SP SCP0099_SAVE_LONGTERM_PLAN_RELEASE |
| event:this.btnRelease.Click | btnRelease_Click | 1129 | SCP.SCP0099_SAVE_LONGTERM_PLAN_RELEASE | MATCH | SP SCP0099_SAVE_LONGTERM_PLAN_RELEASE |
| event:this.cboPlan.SelectedIndexChanged | cboPlan_SelectedIndexChanged | 1182 | SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | SP SCP0099_GET_LONGTERM_PLAN |
| event:this.cboPlanDate.SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | 212 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > setCboPlan | 89 | SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | SP SCP0099_GET_LONGTERM_PLAN |
| event:this.Load | Form_Load > InitControls | 107 | SCP.SCP0099_GET_VERSION_INFO | MATCH | SP SCP0099_GET_VERSION_INFO |
| event:this.Load | Form_Load > setPlanDate | 115 | SCP.SCP0099_GET_LONGTERM_PLAN_DATE | MATCH | SP SCP0099_GET_LONGTERM_PLAN_DATE |
| event:this.Load | Form_Load > InitControls | 162 | SCP.SCP0099_GET_VERSION_INFO | MATCH | SP SCP0099_GET_VERSION_INFO |
| event:this.Load | Form_Load > FindData | 171 | SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | SP SCP0099_GET_LONGTERM_PLAN |
| event:this.Load | Form_Load > setCboPlan | 284 | SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | SP SCP0099_GET_LONGTERM_PLAN |
| unreached:(진입점 미연결) | DelPlan | 224 | SCP.SCP0099_DEL_LONGTERM_PLAN | MATCH | SP SCP0099_DEL_LONGTERM_PLAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProd] | BIZ_MATCH | 2 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProdDel] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProdEdit] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtf] | BIZ_MATCH | 2 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtfDel] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtfEdit] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| SCP.SCP0099_DEL_LONGTERM_PLAN | MATCH | 2 | SP SCP0099_DEL_LONGTERM_PLAN | EXEC:SCP0099_DEL_LONGTERM_PLAN, EXEC:PR_SCM_SYS_LOG_BATCH, UPDATE:SCP_ANL_BUSINESS_PLAN_INFO, REF:STRING_SPLIT, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0099_GET_LONGTERM_PLAN | MATCH | 4 | SP SCP0099_GET_LONGTERM_PLAN | EXEC:SCP0099_GET_LONGTERM_PLAN, SELECT:SCP_ANL_BUSINESS_PLAN_INFO |  |
| SCP.SCP0099_GET_LONGTERM_PLAN_DATE | MATCH | 1 | SP SCP0099_GET_LONGTERM_PLAN_DATE | EXEC:SCP0099_GET_LONGTERM_PLAN_DATE, REF:FN_CHAR_TO_DATE, SELECT:SCP_PLAN_VERSION_V, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCP_PLN_INTERFACE_YN |  |
| SCP.SCP0099_GET_LONGTERM_PLAN_DETAIL | MATCH | 1 | SP SCP0099_GET_LONGTERM_PLAN_DETAIL | EXEC:SCP0099_GET_LONGTERM_PLAN_DETAIL, SELECT:SCP_ANL_BUSINESS_PLAN_PROD, SELECT:SCP_ANL_BUSINESS_PLAN_RTF |  |
| SCP.SCP0099_GET_VERSION_INFO | MATCH | 2 | SP SCP0099_GET_VERSION_INFO | EXEC:SCP0099_GET_VERSION_INFO, SELECT:DM_MST_VERSION |  |
| SCP.SCP0099_SAVE_LONGTERM_PLAN | MATCH | 1 | SP SCP0099_SAVE_LONGTERM_PLAN | EXEC:SCP0099_SAVE_LONGTERM_PLAN, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCP_ANL_BUSINESS_PLAN_INFO, INSERT:SCP_ANL_BUSINESS_PLAN_INFO, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0099_SAVE_LONGTERM_PLAN_COPY | MATCH | 1 | SP SCP0099_SAVE_LONGTERM_PLAN_COPY | EXEC:SCP0099_SAVE_LONGTERM_PLAN_COPY, SELECT:SCM_MST_PLAN, SELECT:SCP_ANL_BUSINESS_PLAN_INFO, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:#TMP_DATE_LIST, SELECT:SCM_MST_BUCKET, INSERT:#TMP_ITEM_INFO, SELECT:SCM_MST_ITEM_SN, INSERT:#TMP_ELEC_ITEM_INFO, SELECT:SCM_MST_MODEL_FINAL_ITEM_BOM_V, INSERT:#TMP_ELEC_PROD_SITE, SELECT:ELEC_PLAN_INFO, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_MST_FINAL_ITEM_V, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_PLAN_DETAIL, INSERT:#TMP_MODEL_ALLOCATION, SELECT:SCP_MST_MODEL_ALLOCATION, INSERT:#TMP_SITE_ITEM_PRIORITY, SELECT:SITE_ITEM_PRIORITY, SELECT:SCM_MST_SITE_ITEM_PRIORITY, INSERT:#TMP_BOD, SELECT:SCP_MST_BOD, SELECT:SCM_MST_SITE, INSERT:#ENG_BOM_BASE_DATA, SELECT:TH_ENG_PLAN_BOM_SN, INSERT:#ENG_BOM_TREE_MODEL, SELECT:DISTINCT_TREE_MODEL, SELECT:SCP_MST_FINAL_ITEM, SELECT:#ENG_BOM_BASE_DATA, SELECT:#TMP_ITEM_INFO, SELECT:TH_ENG_NET_DEMAND_SN, INSERT:#TMP_ENG_DELIVERY_ORDER, SELECT:TH_EXP_PEGGING_INFO_SN, INSERT:#TMP_ALLOCATION_RAW, SELECT:SCP_PLN_RTF_ALLOCATION_V, SELECT:#TMP_DATE_LIST, SELECT:#TMP_ENG_DELIVERY_ORDER, INSERT:#TMP_ALLOCATION_INFO, SELECT:#TMP_ALLOCATION_RAW, SELECT:PROJECT_INFO, SELECT:SCM_MST_PROJECT, INSERT:#TMP_DEMAND_WORK_ORDER, INSERT:#TMP_PACK_DEMAND_CELL_PROD_SITE, SELECT:#TMP_DEMAND_WORK_ORDER, SELECT:#ENG_BOM_TREE_MODEL, INSERT:#TMP_PACK_DEMAND_CA1_SITE, INSERT:#TMP_RTF_FOR_CELL_SITE, SELECT:#TMP_ALLOCATION_INFO, SELECT:#TMP_PACK_DEMAND_CELL_PROD_SITE, SELECT:#TMP_PACK_DEMAND_CA1_SITE, SELECT:#TMP_ELEC_ITEM_INFO, INSERT:#TMP_RTF_FINAL, SELECT:#TMP_RTF_FOR_CELL_SITE, SELECT:#TMP_ELEC_PROD_SITE, SELECT:#TMP_MODEL_ALLOCATION, SELECT:#TMP_SITE_ITEM_PRIORITY, SELECT:#TMP_BOD, INSERT:#TMP_SCP_PROD_PLAN_AMEND, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0099_SAVE_LONGTERM_PLAN_RELEASE | MATCH | 2 | SP SCP0099_SAVE_LONGTERM_PLAN_RELEASE | EXEC:SCP0099_SAVE_LONGTERM_PLAN_RELEASE, EXEC:PR_SCM_SYS_LOG_BATCH, UPDATE:SCP_ANL_BUSINESS_PLAN_INFO, REF:STRING_SPLIT, SELECT:SCP_ANL_BUSINESS_PLAN_RTF_DM, INSERT:SCP_ANL_BUSINESS_PLAN_RTF_DM, SELECT:SCP_ANL_BUSINESS_PLAN_RTF, SELECT:XIF_BPS_PROD_PLAN_S_SN, INSERT:#TMP_CHGMODEL, SELECT:PROD_ASSY_MAP, SELECT:SCP_MST_CELL_PROD_ASSY_MAP, SELECT:SCP_MST_FINAL_ITEM, INSERT:#TMP_PRODPLAN_INFO, SELECT:SCM_MST_SITE, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_DIVISION, SELECT:#TMP_CHGMODEL, SELECT:SCP_ANL_BUSINESS_PLAN_PROD, SELECT:SCP_ANL_BUSINESS_PLAN_INFO, INSERT:#TMP_UPDATEQTY_INFO, SELECT:#TMP_PRODPLAN_INFO, UPDATE:#TMP_PRODPLAN_INFO, SELECT:#TMP_UPDATEQTY_INFO, DELETE:#TMP_PRODPLAN_INFO, INSERT:XIF_BPS_PROD_PLAN_S_SN, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanProd\|SCP\Analysis\SCP0099_ExcelUploadPopup#SavePlanProd | MATCH_PATTERN | 2 | SP SCP0099_SAVE_PLAN_PROD \| SP SCP0099_SAVE_PLAN_PROD | EXEC:SCP0099_SAVE_PLAN_PROD, EXEC:PR_SCM_SYS_LOG_BATCH, DELETE:SCP_ANL_BUSINESS_PLAN_PROD, INSERT:SCP_ANL_BUSINESS_PLAN_PROD, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanProdDel | MATCH_PATTERN | 1 | SP SCP0099_SAVE_PLAN_PROD_DEL | EXEC:SCP0099_SAVE_PLAN_PROD_DEL, EXEC:PR_SCM_SYS_LOG_BATCH, DELETE:SCP_ANL_BUSINESS_PLAN_PROD, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanProdEdit | MATCH_PATTERN | 1 | SP SCP0099_SAVE_PLAN_PROD_EDIT | EXEC:SCP0099_SAVE_PLAN_PROD_EDIT, EXEC:PR_SCM_SYS_LOG_BATCH, UPDATE:SCP_ANL_BUSINESS_PLAN_PROD, SELECT:SCP_ANL_BUSINESS_PLAN_PROD, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanRtf\|SCP\Analysis\SCP0099_ExcelUploadPopup#SavePlanRtf | MATCH_PATTERN | 2 | SP SCP0099_SAVE_PLAN_RTF \| SP SCP0099_SAVE_PLAN_RTF | EXEC:SCP0099_SAVE_PLAN_RTF, EXEC:PR_SCM_SYS_LOG_BATCH, DELETE:SCP_ANL_BUSINESS_PLAN_RTF, INSERT:SCP_ANL_BUSINESS_PLAN_RTF, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanRtfDel | MATCH_PATTERN | 1 | SP SCP0099_SAVE_PLAN_RTF_DEL | EXEC:SCP0099_SAVE_PLAN_RTF_DEL, EXEC:PR_SCM_SYS_LOG_BATCH, DELETE:SCP_ANL_BUSINESS_PLAN_RTF, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP\Analysis\SCP0099_Business_Plan_LongTerm#SavePlanRtfEdit | MATCH_PATTERN | 1 | SP SCP0099_SAVE_PLAN_RTF_EDIT | EXEC:SCP0099_SAVE_PLAN_RTF_EDIT, EXEC:PR_SCM_SYS_LOG_BATCH, UPDATE:SCP_ANL_BUSINESS_PLAN_RTF, SELECT:SCP_ANL_BUSINESS_PLAN_RTF, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnCopy_Click | result.Tables[0].Rows[0] | result_code, result_cnt |
| btnRelease_Click | result.Tables[0].Rows[0] | result_code |
| cboPlan_SelectedIndexChanged | result.Tables[0].Rows[0] | PLAN_START_DATE, PLAN_END_DATE |
| DelPlan | result.Tables[0].Rows[0] | result_code |
| Excel_TempUpload | xlBook.Worksheets | Production, RTF |
| OKButtonClick | result.Tables[0].Rows[0] | result_code |
| ReleasePlan | result.Tables[0].Rows[0] | result_code |
| SaveData | dr | UNIT, ELECTRODE, CELL, PACK |
| SaveData | dr_ins | OPERATION_GROUP, SITE_ID, BUILDING, LINE_ID, NICKNAME, MODEL, CUST, PROJECT, UNIT, MEASURE, SALES_SITE, BIZ_TYPE, PROJECT_DESC, MODEL_CODE, CELL_NICKNAME, CELL_CODE, ELECTRODE, CELL, PACK, INCOTERMS |
| SaveData | dr_del | UNIT |
| SaveData | result.Rows[0] | result_code, result_cnt |
| SaveData | result.Tables[0].Rows[0] | result_code, result_cnt |
| SaveProd | dr | OPERATION_GROUP, SITE_ID, BUILDING, LINE_ID, NICKNAME, MODEL, CUST, PROJECT, UNIT, MEASURE |
| SaveProd | result.Rows[0] | result_code, result_cnt |
| SaveRTF | dr | SALES_SITE, BIZ_TYPE, CUST, PROJECT, PROJECT_DESC, MODEL, MODEL_CODE, CELL_NICKNAME, CELL_CODE, ELECTRODE, CELL, PACK, UNIT, INCOTERMS, MEASURE |
| SaveRTF | result.Rows[0] | result_code, result_cnt |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:348, InitSpread:140 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:526, btnButtonList_UsrButtonList_Click_Detected:205 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | SetChangedControl:935, FindData_Main:974 | CString.GetCheckedListValue | CODE |
| OnOpen_Click | btnOpen_Click:924 | ExcelUploadForm.OnOpen_Click | error_count, success_count |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnTemplate | Click | btnTemplate_Click | InitializeComponent:313 |
| this.btnPlanInfo | Click | btnPlanInfo_Click | InitializeComponent:352 |
| this.btnRelease | Click | btnRelease_Click | InitializeComponent:390 |
| this.cboPlan | SelectedIndexChanged | cboPlan_SelectedIndexChanged | InitializeComponent:569 |
| this.btnExcelUpload | Click | btnExcelUpload_Click | InitializeComponent:612 |
| this.btnCopy | Click | btnCopy_Click | InitializeComponent:966 |
| this | Load | Form_Load | .ctor:260 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:355 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:356 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:358 |
| btnNew | Click | BtnNew_Click | InitEvent:360 |
| this.spdMain | ClipboardPasting | SpdMain_ClipboardPasting | InitEvent:363 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:364 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:235 |
| this | Load | Form_Load | .ctor:58 |
| this.btnCancel | Click | btnCancel_Click | InitializeComponent:81 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:94 |
| this.btnOpen | Click | btnOpen_Click | InitializeComponent:106 |
| this | Load | ExcelUpload2_Load | InitializeComponent:257 |
| this.cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | InitializeComponent:223 |
| this.btnCopy | Click | btnCopy_Click | InitializeComponent:333 |
| this | Load | Form_Load | .ctor:58 |
| this.btnRelease | Click | btnRelease_Click | InitializeComponent:145 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:201 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:290 |
| this | FormClosing | SCP0099_PlanInfoPopup_FormClosing | InitializeComponent:337 |
| this | Load | Form_Load | .ctor:93 |

## 6. 컨트롤 (103개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 28 | Division, layoutControlItem5, layoutControlItem9, layoutControlItem12, Division1, layoutControlItem1, layoutControlItem6, layoutControlItem8, layoutControlItem4, layoutControlItem10, layoutControlItem11, layoutControlItem2, layoutControlItem3, layoutControlItem7, layoutControlItem3 … |
| UsrCombo | 10 | cboOperationGroup, cboDivision, cboPlan, clbSaleVer, cboDivision, cboPlan, cboDivision, cboPlanDate, cboPlanType, cboPlanSeq |
| LayoutControlGroup | 10 | layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, Root, layoutControlGroup1, layoutControlGroup2, Root, layoutControlGroup1, layoutControlGroup2, Root |
| EmptySpaceItem | 10 | emptySpaceItem3, emptySpaceItem1, emptySpaceItem7, emptySpaceItem4, emptySpaceItem5, emptySpaceItem6, emptySpaceItem8, emptySpaceItem5, emptySpaceItem5, emptySpaceItem1 |
| UsrButton | 9 | usrButton1, btnTemplate, btnPlanInfo, btnRelease, btnNew, btnExcelUpload, btnCopy, btnCopy, btnRelease |
| UsrLayoutControl | 7 | usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 4 | spdMain, sprdResult, sprdDetail, spdMain |
| SheetView | 4 | spdMain_Sheet1, sprdResult_Sheet1, sprdDetail_Sheet1, spdMain_Sheet1 |
| UsrTextBox | 3 | txtLine, txtSite, txtItemId |
| Button | 3 | btnCancel, btnOK, btnOpen |
| UsrLabel | 2 | lblPeriod, lblExcelFile |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| TextBox | 2 | txtDesc, txtFileName |
| UsrMonthRangePicker | 1 | drpPeriodMonth |
| Panel | 1 | pnlFindControl |
| ImageList | 1 | imageList1 |
| ToolTip | 1 | toolTip |
| Label | 1 | lblDivision |

## 7. 확인 필요 (8건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 639 | SaveData | {?definition_path}#SavePlanProdEdit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 668 | SaveData | {?definition_path}#SavePlanProd | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=2 |
| 693 | SaveData | {?definition_path}#SavePlanProdDel | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 815 | SaveData | {?definition_path}#SavePlanRtfEdit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 844 | SaveData | {?definition_path}#SavePlanRtf | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=2 |
| 869 | SaveData | {?definition_path}#SavePlanRtfDel | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1034 | SaveProd | {?definition_path}#SavePlanProd | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=2 |
| 1131 | SaveRTF | {?definition_path}#SavePlanRtf | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=2 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 48 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 161 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0099 | LongtermPlanInfoPopup | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |
| SCM_MST_SHEET_COLUMNS | SCP0099 | PRODUCTION | 72/0 | 72/0 | 72/0 | 72/0 | 72/0 | 72/0 | 72/0 | 72/0 | 72/0 | 72/0 | 72/0 | 72/0 | 72/0 | 72/0 |
| SCM_MST_SHEET_COLUMNS | SCP0099 | RTF | 78/0 | 78/0 | 78/0 | 78/0 | 78/0 | 78/0 | 78/0 | 78/0 | 78/0 | 78/0 | 78/0 | 78/0 | 78/0 | 78/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: PRODUCTION, RTF, Upload Result, LongtermPlanInfoPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:348, SetSheetHeaderColumn@InitSpread:140
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| FindData_Main | 0 | 1023 | 표시/라벨 변경 | set:Text | Text = {?dt.AddMonths("0").ToString("yyyy.MM")} | M1_QTY | for(i <= 60) |
| FindData_Main | 1 | 1050 | 표시/라벨 변경 | set:Text | Text = {?dt.AddMonths("0").ToString("yyyy.MM")} | M1_QTY | for(i <= 60) |
| InitializeComponent |  | 897 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 898 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 899 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 900 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSheet | 0 | 116 | 하드코딩 | AddTextColumnHash | {?this.GetSheetInfo(sprdResult.Name, 0)} | Success |  |
| InitSheet | 0 | 117 | 하드코딩 | AddNumColumnHash | {?this.GetSheetInfo(sprdResult.Name, 0)} | Success Count |  |
| InitSheet | 0 | 118 | 하드코딩 | AddTextColumnHash | {?this.GetSheetInfo(sprdResult.Name, 0)} | Error |  |
| InitSheet | 0 | 119 | 하드코딩 | AddNumColumnHash | {?this.GetSheetInfo(sprdResult.Name, 0)} | Error Count |  |
| InitSheet | 0 | 120 | 하드코딩 | AddTextColumnHash | {?this.GetSheetInfo(sprdResult.Name, 0)} | Total |  |
| InitSheet | 0 | 121 | 하드코딩 | AddNumColumnHash | {?this.GetSheetInfo(sprdResult.Name, 0)} | Total Count |  |
| InitSheet | 0 | 130 | 표시/라벨 변경 | set:BackColor | BackColor = {?Color.LightGray} |  |  |
| InitSheet | 0 | 131 | 표시/라벨 변경 | set:BackColor | BackColor = {?Color.LightGray} |  |  |
| InitSheet | 0 | 132 | 표시/라벨 변경 | set:BackColor | BackColor = {?Color.LightGray} |  |  |
| Excel_TempUpload |  | 367 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = {?iCCnt} |  |  |
| Excel_TempUpload |  | 390 | 표시/라벨 변경 | set:Value | Value = {?obj.GetValue(i, "1").ToString().Trim().ToUpper().Replace("\n", "").Replace(" ", "")} |  | for(i < iRCnt + 1) ⟫ if(sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Replace(" ", "")) ⟫ for(j < iCCnt + 1) ⟫ else!(obj.GetValue(i, "1") == null) |
| Excel_TempUpload |  | 554 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = {?iCCnt} |  |  |
| Excel_TempUpload |  | 577 | 표시/라벨 변경 | set:Value | Value = {?obj.GetValue(i, "1").ToString().Trim().ToUpper().Replace("\n", "").Replace(" ", "")} |  | for(i < iRCnt + 1) ⟫ if(sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Replace(" ", "")) ⟫ for(j < iCCnt + 1) ⟫ else!(obj.GetValue(i, "1") == null) |
| InitializeComponent |  | 217 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 218 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 219 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 220 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 306 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 307 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 308 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 309 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 하드코딩 전용(메타 없음) | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| LongtermPlanInfoPopup | META+코드연결 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |
| PRODUCTION | META+코드연결 | 72 | 72 | 72 | 72 | 72 | 72 | 72 | 72 | 72 | 72 | 72 | 72 | 72 | 72 |
| RTF | META+코드연결 | 78 | 78 | 78 | 78 | 78 | 78 | 78 | 78 | 78 | 78 | 78 | 78 | 78 | 78 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
