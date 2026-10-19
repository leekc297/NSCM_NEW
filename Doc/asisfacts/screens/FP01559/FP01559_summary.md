# FP01559 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Planning.UIL\FP01559_In_House_Request_Moving_Plan.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 3041 |
| only | 06.UIL\GSCM.FP.Planning.UIL\FP01559_In_House_Request_Moving_Plan.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1590 |
| only | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP01559_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 255 |
| only | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP01559_BucketSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 192 |
| only | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP01559_ItemPopup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 319 |
| only | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP01559_ItemPopup.Designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 396 |
| only | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP01559_LineAddPopup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 551 |
| only | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP01559_LineAddPopup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1304 |
| only | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP01559_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 286 |
| only | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP01559_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 362 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboFormInstance.SelectedIndexChanged | cboFormInstance_changed > GetDivision | 2746 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | cboInstance_changed > GetDivision | 2746 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_changed > GetSite | 2754 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1814 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1814 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1815 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1815 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1816 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1816 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1817 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1817 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_BukInfo.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1814 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1814 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_WeekCnt.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1815 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1815 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_DateMap.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1816 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1816 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_MonthCnt.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1817 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1817 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_BukInfo.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1814 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1814 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1815 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1815 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1816 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1816 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1817 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1817 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_BukInfo.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1084 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1084 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#merge_data | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1814 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1814 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_WeekCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1815 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1815 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_DateMap.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1816 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1816 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_MonthCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1817 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1817 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_BukInfo.sql |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 411 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_add] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 411 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#merge_add | MATCH | [update-batch]  |
| event:this.Load | Form_Load > InitControls > GetDivision | 2746 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetSite | 2754 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 83 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Confirm | 1150 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_confirm] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Confirm | 1150 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#execute_confirm | MATCH | SP PR_SCM_OF_PACK_REQUIRE_FIX |
| unreached:(진입점 미연결) | Save_Confirm | 1157 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_planSend] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Confirm | 1157 | FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#execute_planSend | MATCH | SP PR_SCM_INHOUSE_REQUEST_PLAN_SEND |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_confirm] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_planSend] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_add] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] | BIZ_MATCH | 1 |  |  |  |
| FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#execute_confirm | MATCH | 1 | SP PR_SCM_OF_PACK_REQUIRE_FIX | EXEC:PR_SCM_OF_PACK_REQUIRE_FIX | ⚠ DB에 SP 없음 |
| FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#execute_planSend | MATCH | 1 | SP PR_SCM_INHOUSE_REQUEST_PLAN_SEND | EXEC:PR_SCM_INHOUSE_REQUEST_PLAN_SEND | ⚠ DB에 SP 없음 |
| FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_BukInfo | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_DateMap | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_MonthCnt | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#find_WeekCnt | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#merge_add | MATCH | 1 | [update-batch]  |  |  |
| FP\Planning\FP01559_IN_HOUSE_REQUEST_MOVING_PLAN#merge_data | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO, CATE_INFO |
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, PLAN_DATE, PLAN_ID, MASTER_ID, INSTANCE_ID |
| btnCellItem_Click | popup.Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID, ITEM_ID, NICK_NAME, FORM_INSTANCE_ID |
| btnCellItem_Click | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID, CELL_NICK_NAME, FORM_INSTANCE_ID, COMPANY_ID |
| btnCellItem_Click | data | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, NICK_NAME, ITEM_ID |
| cboCellFactory_changed | Filter | CELL_FACTORY_ID |
| cboFormInstance_changed | dtInstance.Rows[cboInstance.SelectedIndex] | INSTANCE_ID |
| cboInstance_changed | dtInstance.Rows[cboInstance.SelectedIndex] | PACK_INSTANCE_ID |
| cboPackFactory_changed | Filter | PACK_FACTORY_ID |
| cboType_changed | Filter | CATEGORY_TYPE |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_request_p, chk_request_r, chk_request_eoh, chk_moving_p, chk_moving_do, chk_moving_ship, chk_moving_eoh, chk_total_r, chk_total_do, chk_total_meet, chk_total_eoh |
| CreateFilterDataSet | x | _MM_ |
| dpPlanDate_ValueChanged | Filter | PLAN_DATE |
| drpPlanDate_changed | dtPlanDate.Rows[0] | PLAN_START_DATE, PLAN_END_DATE |
| FindData | Filter | ITEM_ID, CELL_ITEM_ID, NICK_NAME |
| fn_columnChange | clicked_row | CATEGORY_ID, CATEGORY_TYPE |
| fn_columnChange | row | LV1, PACK_FACTORY_ID, CELL_FACTORY_ID |
| GetBasisTime | dtPeriod.Rows[0] | BASIS_TIME |
| GetCurrDate | Filter | PLAN_DATE, CURR_DATE, BUCKET_FROM, PLAN_START_DATE, BUCKET_TO, PLAN_END_DATE |
| GetCurrDate | dtCurrDate.Rows[0] | CURR_DATE, PLAN_START_DATE, PLAN_END_DATE |
| GetDivision | Filter | INSTANCE_ID |
| GetFpPlanId | dtInstance.Rows[cboInstance.SelectedIndex] | PACK_INSTANCE_ID |
| GetFpPlanId | Filter | PLAN_ID, FORM_PLAN_ID |
| GetFpPlanId | dtPlanId.Rows[0] | CODE |
| GetFpPlanId | dtFormInstance.Rows[cboFormInstance.SelectedIndex] | INSTANCE_ID |
| GetFpPlanId | dtFormPlanId.Rows[0] | CODE |
| GetPlantFactory | Filter | SEL_INSTANCE_ID, INSTANCE_ID, FORM_INSTANCE_ID, CATEGORY_TYPE, PACK_FACTORY_ID, CELL_FACTORY_ID, PACK_PLANT_ID, FORM_PLANT_ID, FORM_FACTORY_ID |
| GetPlantFactory | dtInstance.Rows[cboInstance.SelectedIndex] | PACK_INSTANCE_ID |
| GetPlantFactory | dtFormInstance.Rows[cboFormInstance.SelectedIndex] | INSTANCE_ID |
| GetPlantFactory | dtPlant.Rows[0] | CODE |
| GetPlantFactory | dtFormPlant.Rows[0] | CODE |
| GetPlantFactory | dtFactory.Rows[0] | CODE |
| GetPlantFactory | dtFormFactory.Rows[0] | CODE |
| GetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID |
| GoEditMode | row | DATA_TYPE, CATEGORY_ID, EDIT_YN |
| InitControls | Filter | PLAN_DATE, CATEGORY_TYPE, CELL_ITEM_ID, CELL_NICK_NAME, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PACK_INSTANCE_ID, INSTANCE_ID, MASTER_ID, FORM_INSTANCE_ID, BUCKET_FROM, BUCKET_TO |
| InitControls | InitRow | CELL_ITEM_ID, CELL_NICK_NAME, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| InitControls | dtInstance.Rows[cboInstance.SelectedIndex] | PACK_INSTANCE_ID |
| InitControls | dtFormInstance.Rows[cboFormInstance.SelectedIndex] | INSTANCE_ID |
| InitSpread | Filter | PROGRAM_ID, SHEET_NAME |
| InsertButton | popup.Filter | FORM_INSTANCE_ID, INSTANCE_ID |
| InsertButton | Filter | FORM_INSTANCE_ID, INSTANCE_ID |
| RefreshHeader | row | DATA_TYPE |
| Save_Data | Filter | PLAN_DATE, ITEM_ID, CELL_ITEM_ID, USER_ID, CATEGORY_TYPE, COMPANY_ID, INSTANCE_ID, PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, CELL_FACTORY_ID, PACK_FACTORY_ID, FP_PLAN_ID |
| Save_Data | dtDup.Rows[0] | CNT |
| Save_Data | dtAuth.Rows[0] | PACK_FAC, FORM_FAC |
| Save_Data | dtResult.Rows[0] | RESULT |
| Save_Data | enum_row_from_Saving | CATEGORY_ID, EQTY, EDATE, CATEGORY_TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID, CELL_FACTORY_ID, PACK_FACTORY_ID |
| Save_Data | x | CATEGORY_TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID, PLAN_DATE, CELL_FACTORY_ID, PACK_FACTORY_ID |
| Save_Data | selected | ORG_QTY, QTY, M |
| Save_Data | newrow | CATEGORY_TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID, PLAN_DATE, CELL_FACTORY_ID, PACK_FACTORY_ID, DESCRIPTION, INSTANCE_ID, QTY, ORG_QTY, M |
| Save_Data | dr | USER_ID |
| Save_Data | resultDT.Rows[0] | RESULT |
| SetBohQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | each_row | _TYPE, OPERATION_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | result.First() | QTY |
| SetTotalValue | row | DATA_TYPE, CATEGORY_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID |
| SetTotalValue | each_row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID, CATEGORY_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:128, InitControl:150, Measure:150, InitControl:182, CheckAndGetMeasure:327, RefreshSpreadSheet:1513 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| GetCheckedListValue | InitControls:179, GetPlantFactory:233, GetPlantFactory:234, cboType_changed:240, cboPackFactory_changed:255, cboCellFactory_changed:260, ApplySearchCondition:1839, clbDivision_changed:2549 | CString.GetCheckedListValue | CODE |
| FP_UpdateBatch2 | Save_Data:411 | DataService.FP_UpdateBatch2 | COUNT, EXCEPTION, RESULT |
| SetFilter | InitControls:179, InitControls:180, InitControls:181, InitControls:194, InitControls:195, InitControls:200, InitControls:201, Save_Data:1071 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| EditQuery | RefreshHeader:368, RefreshHeader:378 | FPExtensions.EditQuery | ROW_ID |
| GetChanges | Save_Data:947 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch | Save_Data:1084 | DataService.FP_UpdateBatch | COUNT, RESULT |
| SetRowVisibleOnMeasureDatatypeCategory | CreateFilterDataSet:1371 | MeasureService.SetRowVisibleOnMeasureDatatypeCategory | CATEGORY_ID, DATA_TYPE, MEASURE_ID, _MM_ |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1372 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:119 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:156 |
| this | Load | MeasureSetForm_Load | InitializeComponent:170 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:171 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:235 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:303 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:304 |
| this | Load | Form_Load | .ctor:95 |
| this | Load | Form_Load | .ctor:109 |
| cboType | SelectedIndexChanged | cboType_changed | InitEvent:206 |
| cboPackFactory | SelectedIndexChanged | cboPackFactory_changed | InitEvent:207 |
| cboCellFactory | SelectedIndexChanged | cboCellFactory_changed | InitEvent:208 |
| drpPlanDate | ValueChanged | dpPlanDate_ValueChanged | InitEvent:210 |
| drpPlanDate | ValueChanged | dpPlanDate_ValueChanged | dpPlanDate_ValueChanged:451 |
| drpPlanDate | ValueChanged | dpPlanDate_ValueChanged | dpPlanDate_ValueChanged:480 |
| this.btnCellItem | Click | btnCellItem_Click | InitializeComponent:553 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:826 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:865 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:176 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:213 |
| this | Load | MeasureSetForm_Load | InitializeComponent:321 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:322 |
| this.cboFormPlanId | DropDown | cboFormPlanId_DropDown | InitializeComponent:480 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:627 |
| this.cboPlanId | DropDown | cboPlanId_DropDown | InitializeComponent:740 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:815 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1052 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1053 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1054 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:1055 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1056 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1057 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1058 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1059 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1060 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1061 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1062 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1063 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1064 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1065 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1066 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1067 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1068 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1069 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1070 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1071 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1072 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:1233 |
| this.btnCategory | Click | btnCatagory_Click | InitializeComponent:1271 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:1309 |
| this | Load | Form_Load | .ctor:114 |
| cboInstance | SelectedIndexChanged | cboInstance_changed | InitEvent:242 |
| drpPlanDate | DateTimeChanged | drpPlanDate_changed | InitEvent:243 |
| cboPlanId | SelectedIndexChanged | cboPlanId_changed | InitEvent:244 |
| cboFormInstance | SelectedIndexChanged | cboFormInstance_changed | InitEvent:246 |
| cboFormPlanId | SelectedIndexChanged | cboFormPlanId_changed | InitEvent:247 |
| clbDivision | SelectedIndexChanged | clbDivision_changed | InitEvent:249 |
| cboSite | SelectedIndexChanged | cboSite_changed | InitEvent:250 |
| txtGroupName | TextChanged | txtGroupName_TextChanged | InitEvent:253 |
| txtCellCode | TextChanged | txtCellCode_TextChanged | InitEvent:254 |
| txtNickName | TextChanged | txtNickName_TextChanged | InitEvent:255 |
| drpPeriod | ValueChanged | drpPeriod_changed | InitEvent:257 |
| chkRelPack | CheckedChanged | chkRelPack_CheckedChanged | InitEvent:259 |
| chkRelForm | CheckedChanged | chkRelForm_CheckedChanged | InitEvent:260 |
| chkLineAssign | CheckedChanged | chkLineAssign_CheckedChanged | InitEvent:261 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1179 |
| drpPlanDate | DateTimeChanged | drpPlanDate_changed | drpPlanDate_changed:2563 |
| drpPlanDate | DateTimeChanged | drpPlanDate_changed | drpPlanDate_changed:2579 |

## 6. 컨트롤 (141개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 38 | layoutControlItem1, layoutControlItem4, layoutControlItem2, layoutControlItem20, layoutControlItem10, layoutControlItem33, layoutControlItem6, layoutControlItem7, layoutControlItem14, layoutControlItem18, layoutControlItem1, layoutControlItem19, layoutControlItem28, layoutControlItem31, layoutControlItem3 … |
| CheckBox | 14 | chk_month, chk_week, chk_day, chk_request_eoh, chk_request_r, chk_request_p, chk_total_r, chk_moving_eoh, chk_moving_ship, chk_moving_do, chk_moving_p, chk_total_do, chk_total_meet, chk_total_eoh |
| UsrButton | 13 | usrButton1, usrButton2, btnCellItem, btnClose, btnSave, usrButton1, usrButton2, btnToggleSave, btnSql, usrButton2, btnBucket, btnCategory, btnColumn |
| UsrLabel | 9 | usrLabel6, lblType, usrLabel2, usrLabel16, usrLabel13, usrLabel7, usrLabel1, usrLabel3, usrLabel5 |
| UsrTextBox | 8 | txtNickName, txtItem, txtNickName, txtItem, txtQty, txtGroupName, txtNickName, txtCellCode |
| UsrCombo | 8 | cboCellFactory, cboPackFactory, cboType, cboSite, cboFormPlanId, cboFormInstance, cboInstance, cboPlanId |
| Panel | 7 | panel1, panel1, panel3, panel2, panel2, panel4, panel1 |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem4, emptySpaceItem5, emptySpaceItem2 |
| FpSpread | 4 | spdMain, spdMain, spdEdit, spdInfo |
| SheetView | 4 | spdMain_Sheet1, spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1 |
| Label | 4 | label1, label2, label3, label1 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCheckBox | 3 | chkRelForm, chkLineAssign, chkRelPack |
| UsrDatePicker2 | 2 | drpPlanDate, drpPlanDate |
| ImageList | 2 | imageList1, imageList1 |
| UsrButtonList | 1 | btnButtonList |
| UsrDateRangePicker2 | 1 | drpPeriod |
| UsrCheckedList2 | 1 | clbDivision |
| SplitContainer | 1 | splitter |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ItemPopup, Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:160, SetSheetHeaderColumn_FP@InitSpread:301, SetSheetHeaderColumn_FP@RefreshHeaderOnly:490
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| RefreshHeader |  | 441 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 447 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| InitializeComponent |  | 1088 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1089 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1090 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1091 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1353 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1354 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1355 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1356 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1404 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1405 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1406 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1407 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 320 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 321 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 322 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 323 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
