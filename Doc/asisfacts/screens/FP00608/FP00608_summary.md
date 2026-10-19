# FP00608 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\FP00608_PlanAmend_Memo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\FP00608_PlanAmend_Memo.UIL.csproj | 3086 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\FP00608_PlanAmend_Memo.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\FP00608_PlanAmend_Memo.UIL.csproj | 1015 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\FP00608_RowExcelPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\FP00608_PlanAmend_Memo.UIL.csproj | 821 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\FP00608_RowExcelPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\FP00608_PlanAmend_Memo.UIL.csproj | 874 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\FP00608_PlanAmend_Memo.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00608_PlanAmend_Memo.UIL\FP00608_PlanAmend_Memo.UIL.csproj | 64 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00608_MemoAddPopup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 743 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00608_MemoAddPopup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1945 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00608_PlanAmend_Memo.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1191 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00608_PlanAmend_Memo.Designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 983 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 1555 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 1555 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 216 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 216 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 217 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 217 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 218 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 219 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Memo | 1021 | FP_Planning.PR_UI_FP00608_AMEND_MEMO | MATCH | SP PR_UI_FP00608_AMEND_MEMO |
| button:FindButton | FindButton > UIFindData > Find_Data_Memo | 1060 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Memo | 1060 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Memo > GetModelChangeTable | 2432 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P_ID] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Memo > GetModelChangeTable | 2432 | FP\Common\AmendMemo#find_SetupColor_P_ID | MATCH | [sql] foxquery_sql\FP_Common_AmendMemo_find_SetupColor_P_ID.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo | 1021 | FP_Planning.PR_UI_FP00608_AMEND_MEMO | MATCH | SP PR_UI_FP00608_AMEND_MEMO |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo | 1060 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo | 1060 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo > GetModelChangeTable | 2432 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P_ID] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo > GetModelChangeTable | 2432 | FP\Common\AmendMemo#find_SetupColor_P_ID | MATCH | [sql] foxquery_sql\FP_Common_AmendMemo_find_SetupColor_P_ID.sql |
| button:SaveButton | SaveButton > Save_Data > UIFindData > Find_Data_Memo | 1021 | FP_Planning.PR_UI_FP00608_AMEND_MEMO | MATCH | SP PR_UI_FP00608_AMEND_MEMO |
| button:SaveButton | SaveButton > Save_Data > UIFindData > Find_Data_Memo | 1060 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > UIFindData > Find_Data_Memo | 1060 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Momo | 1411 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_amend_memo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Momo | 1411 | FP\Common\AmendMemo#delete_amend_memo | MATCH_PATTERN | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Momo | 1416 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=fetch_amend_memo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Momo | 1416 | FP\Common\AmendMemo#fetch_amend_memo | MATCH_PATTERN | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Momo > GetCateTable | 2412 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Momo > GetCateTable | 2412 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:SaveButton | SaveButton > Save_Data > UIFindData > Find_Data_Memo > GetModelChangeTable | 2432 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P_ID] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > UIFindData > Find_Data_Memo > GetModelChangeTable | 2432 | FP\Common\AmendMemo#find_SetupColor_P_ID | MATCH | [sql] foxquery_sql\FP_Common_AmendMemo_find_SetupColor_P_ID.sql |
| event:this.btnExcel.Click | btnExcel_Click > UIFindData > Find_Data_Memo | 1021 | FP_Planning.PR_UI_FP00608_AMEND_MEMO | MATCH | SP PR_UI_FP00608_AMEND_MEMO |
| event:this.btnExcel.Click | btnExcel_Click > UIFindData > Find_Data_Memo | 1060 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnExcel.Click | btnExcel_Click > UIFindData > Find_Data_Memo | 1060 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnExcel.Click | btnExcel_Click > UIFindData > Find_Data_Memo > GetModelChangeTable | 2432 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P_ID] | BIZ_MATCH |  |
| event:this.btnExcel.Click | btnExcel_Click > UIFindData > Find_Data_Memo > GetModelChangeTable | 2432 | FP\Common\AmendMemo#find_SetupColor_P_ID | MATCH | [sql] foxquery_sql\FP_Common_AmendMemo_find_SetupColor_P_ID.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 216 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 216 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 217 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 217 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 218 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 219 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| event:this.btnMaterial.Click | btnMaterial_Click > SetValueByPopupData | 586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 251 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 261 | FP_Planning.PR_UI_FP00608_AMEND_MEMO | MATCH | SP PR_UI_FP00608_AMEND_MEMO |
| event:this.Load | Form_Load > InitControls | 127 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 131 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 152 | biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 216 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 216 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 217 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 217 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 218 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 219 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 1555 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 1555 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1746 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=operation_of_line] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1746 | FP\Common\Operation#operation_of_line | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_Operation_operation_of_line.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1918 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=equipment_of_line] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1918 | FP\Common\Equipment#equipment_of_line | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_Equipment_equipment_of_line.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick | 2147 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=operation_of_line] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick | 2147 | FP\Common\Operation#operation_of_line | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_Operation_operation_of_line.sql |
| unreached:(진입점 미연결) | Save_Data_Momo_Excel | 2817 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Data_Momo_Excel | 2817 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| unreached:(진입점 미연결) | Save_Data_Momo_Excel | 2899 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=fetch_amend_memo] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Data_Momo_Excel | 2899 | FP\Common\AmendMemo#fetch_amend_memo | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | Save_Data_Momo_Excel | 2904 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_amend_memo_excel] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Data_Momo_Excel | 2904 | FP\Common\AmendMemo#delete_amend_memo_excel | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2987 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2987 | FP\Common\MemoExcel#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2988 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2988 | FP\Common\MemoExcel#find_Excel_buffer_validation | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_MemoExcel_find_Excel_buffer_validation.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2998 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_validation_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2998 | FP\Common\MemoExcel#delete_validation_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_MemoExcel_delete_validation_buffer.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_validation_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=equipment_of_line] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P_ID] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=operation_of_line] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_amend_memo_excel] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_amend_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=fetch_amend_memo] | BIZ_MATCH | 2 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 3 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00608_AMEND_MEMO | MATCH | 2 | SP PR_UI_FP00608_AMEND_MEMO | EXEC:PR_UI_FP00608_AMEND_MEMO | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#delete_amend_memo | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\AmendMemo#delete_amend_memo_excel | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\AmendMemo#fetch_amend_memo | MATCH_PATTERN | 2 | [update-batch]  |  |  |
| FP\Common\AmendMemo#find_SetupColor_P_ID | MATCH | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_find_SetupColor_P_ID.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 1 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\Equipment#equipment_of_line | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_Equipment_equipment_of_line.sql | SELECT:SCM_LINE_M, SELECT:SCM_EQUIPMENT_M |  |
| FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\MemoExcel#delete_validation_buffer | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_MemoExcel_delete_validation_buffer.sql | DELETE:BUF_FP_AMEND_MEMO_VALIDATION |  |
| FP\Common\MemoExcel#find_Excel_buffer_validation | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_MemoExcel_find_Excel_buffer_validation.sql | SELECT:BUF_FP_AMEND_MEMO_VALIDATION, SELECT:FP_INSTANCE_INFO_V, SELECT:SCM_LINE_M, SELECT:SCM_ITEM_M, SELECT:SCM_FACTORY_M, SELECT:SCM_OPERATION_M |  |
| FP\Common\MemoExcel#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\Operation#operation_of_line | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_Operation_operation_of_line.sql | SELECT:SCM_LINE_M |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 3 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | DATE_INFO, MONTH_INFO, BUCKET, WEEK_INFO |
| btnEquipment_Click | Application.OpenForms | FP00595_EquipmentPopup |
| btnEquipment_Click | popup.Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| btnEquipment_Click | data | EQUIPMENT_ID |
| btnExcel_Click | Filter | PLAN_DATE, UI_END_DATE |
| btnExcel_Click | rowPopup.KeyColumns | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, MARKET, PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, PLAN_DATE |
| btnExcel_Click | rowPopup.ColumnTitle | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID, MARKET, PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, NICK_NAME, PLAN_DATE, MEMO_RANGE, MEMO_TYPE, MEMO, UPDATE_ID, UPDATE_TIME, MESSAGE, EDIT_FLAG |
| btnExcel_Click | rowPopup.ColumnWidth | DIVISION_ID, SITE_ID, LINE_NAME, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MEMO |
| btnFind_Click | Filter | PLAN_DATE, PLAN_TYPE, CURR_DATE |
| btnLine_Click | Application.OpenForms | FP00596_LinePopup |
| btnLine_Click | popup.Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, ITEM_ID |
| btnLine_Click | data | PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE |
| btnMaterial_Click | dRow | CODE, INSTANCE_TYPE |
| btnMaterial_Click | dtResult.Rows[0] | INSTANCE_TYPE |
| btnMaterial_Click | popup.Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, TOP_ITEM_ID, DATE, FORM_OPERATION_ID |
| btnMaterial_Click | Application.OpenForms | FP00602_ItemPopup, FP00601_ItemPopup, FP00621_LineCN2ItemPopup |
| call_Excel_Row_Search | Filter | PLAN_DATE, UI_END_DATE |
| call_Excel_Row_Search | r | ITEM_ID, MEMO_RANGE |
| call_Excel_Row_Validation | Filter | GUID |
| call_Excel_Row_Validation | row | GUID |
| cboInstance_changed | dRow | CODE, INSTANCE_TYPE |
| cboInstance_changed | dtResult.Rows[0] | INSTANCE_TYPE |
| CboSite_SelectedIndexChanged | Filter | SITE_ID |
| ClbDivision_SelectedIndexChanged | Filter | DIVISION_ID |
| ClbFactory_SelectedIndexChanged | Filter | FACTORY_ID |
| ClbLine_SelectedIndexChanged | Filter | LINE_ID |
| ClbOperation_SelectedIndexChanged | Filter | OPERATION_ID |
| ClbPlant_SelectedIndexChanged | Filter | PLANT_ID |
| dateRange_ValueChanged | Filter | BUCKET_FROM, BUCKET_TO |
| Find_Data_Memo | Filter | USER_ID |
| Find_Data_Memo | nn | LOOKUP_TYPE_CODE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, SORT_ORDER, ACTIVE_FLAG, VALUE_DESCRIPTION, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, PLANT_ID |
| Find_Data_Memo | r | ATTR2_TXT, ATTR2, ATTR1, ITEM_ID, INSTANCE_ID, ATTR1_TXT, EQUIPMENT_ID, MEMO_RANGE, EDIT_FLAG |
| GetCateId | rows[0] | SEGMENT1 |
| GetCateTable | Filter | USER_ID |
| GetCateTable | cate | CODE, SEGMENT1, NAME, ATTRIBUTE2 |
| GetCateText | rows[0] | ATTRIBUTE2 |
| GetModelChange | rows[0] | CODE |
| GetModelChangeTable | Filter | INSTANCE_ID |
| GetModelChangeTable | cate | CODE, COLOR_ID, NAME, UI_COLOR |
| GetModelChangeText | rows[0] | UI_DESC |
| InitControls | Filter | USER_ID, PLAN_TYPE, PLAN_DATE, UI_END_DATE, CURR_DATE, BUCKET_FROM, BUCKET_TO, MPP_WPP |
| Insert_Row_Dialog | Application.OpenForms | FP00608_MemoAddPopup |
| radioMPP_CheckedChanged | Filter | MPP_WPP |
| radioWPP_CheckedChanged | Filter | MPP_WPP |
| RefreshHeader | r | MEMO |
| Save_Data | dtRange.Rows[i] | _DATE |
| Save_Data_Momo | Filter | USER_ID |
| Save_Data_Momo | row | USER_ID |
| Save_Data_Momo_Excel | Filter | USER_ID |
| Save_Data_Momo_Excel | nn | LOOKUP_TYPE_CODE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, SORT_ORDER, ACTIVE_FLAG, VALUE_DESCRIPTION, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, PLANT_ID |
| Save_Data_Momo_Excel | r | ATTR1_TXT, ATTR2_TXT, ATTR2, INSTANCE_ID, ATTR1 |
| Save_Data_Momo_Excel | row | EDIT_FLAG |
| SaveExcelRows | BohSet | PLAN_DATE, MASTER_ID, PLAN_ID, AMEND_CUTOFF_BOH_TABLE |
| SaveExcelRows | popupFilter | PLAN_DATE, INSTANCE_ID, FP_PLAN_ID |
| SaveExcelRows | data.Tables[0].Rows[0] | FP_PLAN_ID |
| SaveToDB | main.Tables[0].Rows[i] | USER_ID, JOB_ORDER |
| SaveToDB | eachRow | _VALID |
| SaveToDB | dr | NEW_SEQ, INSTANCE_ID, FP_PLAN_ID |
| SaveToDB | validation.Tables[0].Rows[0] | NEW_SEQ |
| SaveToDB | Filter | INSTANCE_ID, PLAN_ID |
| SaveToDB | result.Tables[0].Rows[0] | RESULT, COUNT, EXCEPTION |
| SaveToDB | valrow | _VALID, _MSG |
| SaveToDB | xlsrow | MESSAGE |
| SelectLine | popup.Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID |
| SetValueByPopupData | data | DIVISION_ID, SITE_ID, ITEM_ID, MODEL_ID, PLANT_ID |
| SpdMain_CellClick | Filter | LINE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID |
| SpdMain_CellClick | dash | CODE, NAME |
| spdMain_CellDoubleClick | cRow | ATTR1, ATTR2 |
| spdMain_CellDoubleClick | Application.OpenForms | FPC0122_InstancePopup |
| spdMain_CellDoubleClick | Filter | LINE_ID |
| spdMain_CellDoubleClick | popup.Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, USER_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetInnerTable | InitControls:160, ClbDivision_SelectedIndexChanged:1538, CboSite_SelectedIndexChanged:1547, ClbPlant_SelectedIndexChanged:1555, ClbFactory_SelectedIndexChanged:1563, ClbOperation_SelectedIndexChanged:1571 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| HasMemoAuthority | InitControls:203 | UserService.HasMemoAuthority | NowGroupID |
| GetCheckedListValue | ClbLine_SelectedIndexChanged:273, Find_Data_Memo:1003, Find_Data_Memo:1004, Find_Data_Memo:1005, Find_Data_Memo:1006, Find_Data_Memo:1007, Find_Data_Memo:1008, ClbDivision_SelectedIndexChanged:1536 | CString.GetCheckedListValue | CODE |
| FP_UpdateBatch | Save_Data_Momo:1411, Save_Data_Momo:1416 | DataService.FP_UpdateBatch | COUNT, RESULT |
| ReadResult | Save_Data_Momo:1412, Save_Data_Momo:1417, Save_Data_Momo_Excel:2905, Save_Data_Momo_Excel:2906 | DataService.ReadResult | COUNT, EXCEPTION, RESULT |
| FP_Log2 | ClbDivision_SelectedIndexChanged:1533, ClbDivision_SelectedIndexChanged:1540 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| FP_UpdateBatch2 | Save_Data_Momo_Excel:2899, Save_Data_Momo_Excel:2904 | DataService.FP_UpdateBatch2 | COUNT, EXCEPTION, RESULT |
| FP_Log | SaveExcelRows:2964, SaveToDB:490, SaveToDB:492, SaveToDB:555, SaveToDB:557, SaveToDB:598, OpenAndLoadExcelData:719, btnSave_Click:788 | DataService.FP_Log | LOGTYPE, NOTE, USER_ID |
| FP_PseudoBatch | call_Excel_Row_Validation:2987 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| CommonDefaultLineCheck | DefaultLineCheck:731 | ExcelService.CommonDefaultLineCheck | BUCKET_FROM, BUCKET_TO, MESSAGE, QTY |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnExcel | Click | btnExcel_Click | InitializeComponent:192 |
| this.rdoGroup1 | SelectedIndexChanged | rdoGroup1_SelectedIndexChanged | InitializeComponent:226 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:651 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:889 |
| this.spdMain | ComboCloseUp | spdMain_ComboCloseUp | InitializeComponent:890 |
| this.spdMain | ComboDropDown | spdMain_ComboDropDown | InitializeComponent:891 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:892 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:893 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:894 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:895 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:896 |
| this | Load | Form_Load | .ctor:119 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:257 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:258 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:259 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:260 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:261 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:262 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:265 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitEvent:266 |
| defaultSheetDataModel | Changed | DefaultSheetDataModel_Changed | SetSpreadInit:339 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1470 |
| this | Load | Form_Load | .ctor:143 |
| dateRange | ValueChanged | dateRange_ValueChanged | Form_Load:158 |
| this.radioMPP | CheckedChanged | radioMPP_CheckedChanged | InitializeComponent:267 |
| this.radioWPP | CheckedChanged | radioWPP_CheckedChanged | InitializeComponent:305 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:379 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:429 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:468 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:507 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:546 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:759 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:760 |
| this | Load | Form_Load | .ctor:101 |
| cboInstance | SelectedIndexChanged | cboInstance_changed | InitEvent:169 |
| cboMarket | SelectedIndexChanged | cboMarket_changed | InitEvent:170 |
| cboProdType | SelectedIndexChanged | cboProdtype_changed | InitEvent:171 |
| this.drpPeriod | ValueChanged | drpPeriod_ValueChanged | InitializeComponent:282 |
| this.btnEquipment | Click | btnEquipment_Click | InitializeComponent:319 |
| this.btnLine | Click | btnLine_Click | InitializeComponent:547 |
| this.btnMaterial | Click | btnMaterial_Click | InitializeComponent:584 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:1259 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:1298 |

## 6. 컨트롤 (127개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 53 | layoutControlItem3, layoutControlItem2, lblFactory, layoutControlItem5, layoutControlItem8, layoutControlItem9, layoutControlItem4, layoutControlItem7, layoutControlItem1, lblSql, layoutControlItem6, layoutControlItem11, layoutControlItem2, layoutControlItem4, layoutControlItem5 … |
| UsrLabel | 15 | usrLabel2, usrLabel1, usrLabel7, usrLabel6, usrLabel16, usrLabel15, usrLabel14, usrLabel13, usrLabel11, usrLabel10, usrLabel4, usrLabel2, usrLabel1, usrLabel3, usrLabel5 |
| UsrButton | 12 | btnExcel, btnSql, btnSave, btnClose, btnFind, btnDownload, btnUpload, btnEquipment, btnLine, btnMaterial, btnClose, btnSave |
| UsrTextBox | 8 | txtItem, txtElectrodType, txtBuilding, txtModel, txtOperation, txtEquipment, txtMemo, txtLine |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList2 | 5 | clbLine, clbOperation, clbFactory, clbPlant, clbDivision |
| UsrCombo | 4 | cboSite, cboInstance, cboProdType, cboMarket |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| ImageList | 3 | imageList1, imageList1, imageList1 |
| UsrMultiLineEditor | 2 | txtModel, txtItemID |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrDateRangePicker2 | 2 | dateRange, drpPeriod |
| UsrRadio | 2 | radioMPP, radioWPP |
| RadioGroup | 1 | rdoGroup1 |
| UsrDateRangePickerWtWeek | 1 | drpPeriod |

## 7. 확인 필요 (17건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2988 | call_Excel_Row_Validation | FP\{?default:part_service}\MemoExcel#find_Excel_buffer_validation | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 216 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 217 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 218 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 219 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2899 | Save_Data_Momo_Excel | FP\{?default:part_service}\AmendMemo#fetch_amend_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2904 | Save_Data_Momo_Excel | FP\{?default:part_service}\AmendMemo#delete_amend_memo_excel | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2998 | call_Excel_Row_Validation | FP\{?default:part_service}\MemoExcel#delete_validation_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1060 | Find_Data_Memo | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1746 | SpdMain_CellClick | FP\{?default:part_service}\OPERATION#operation_of_line | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1918 | SpdMain_CellClick | FP\{?default:part_service}\EQUIPMENT#equipment_of_line | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2147 | spdMain_CellDoubleClick | FP\{?default:part_service}\OPERATION#operation_of_line | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2412 | GetCateTable | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2817 | Save_Data_Momo_Excel | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1411 | Save_Data_Momo | FP\{?default:part_service}\AmendMemo#delete_amend_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1416 | Save_Data_Momo | FP\{?default:part_service}\AmendMemo#fetch_amend_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2987 | call_Excel_Row_Validation | FP\{?default:part_service}\MemoExcel#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 28 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 16 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 42 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00608 | AmendMemo | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: AmendMemo, AutoExcelPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:329

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit | 0 | 333 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetSpreadInit | 0 | 334 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MEMO_TYPE |  |
| SetSpreadInit | 0 | 335 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID |  |
| SetSpreadInit | 0 | 336 | 표시/라벨 변경 | set:Visible | Visible = {?false} | VALID_YN |  |
| Find_Data_Old | AmendMemo | 922 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 912 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 913 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 914 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 915 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| FindData |  | 385 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 386 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 387 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 776 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 777 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 778 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 779 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| AmendMemo | META+코드연결 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
