# FP00623 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_InvDetail_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 656 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_InvDetail_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 209 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 274 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 272 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 2877 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 4061 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_PlanInfoPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 304 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_PlanInfoPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 282 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_receipt_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 649 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_receipt_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 209 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00623_Pancake_Simulation_Elec.UIL\FP00623_Pancake_Simulation_Elec.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboUomType.SelectedIndexChanged | cboUomType_changed > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_dio] | BIZ_MATCH |  |
| event:cboUomType.SelectedIndexChanged | cboUomType_changed > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | FP\MASTER\DIO#list_dio | MATCH | [sql] foxquery_sql\FP_Master_DIO_list_dio.sql |
| button:FindButton | FindButton > FindData > Find_Data_Line | 265 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_intransit_Detail] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Line | 265 | FP\Planning\FP00623#find_intransit_Detail | MATCH | [sql] foxquery_sql\FP_Planning_FP00623_find_intransit_Detail.sql |
| button:FindButton | FindButton > FindData > Find_Data_Line | 267 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOH_Detail_Receipt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Line | 267 | FP\Planning\FP00623#find_BOH_Detail_Receipt | MATCH | [sql] foxquery_sql\FP_Planning_FP00623_find_BOH_Detail_Receipt.sql |
| button:FindButton | FindButton > FindData > Find_Data_Line | 271 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOH_Detail] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Line | 271 | FP\Planning\FP00623#find_BOH_Detail | MATCH | [sql] foxquery_sql\FP_Planning_FP00623_find_BOH_Detail.sql |
| button:FindButton | FindButton > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1371 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1371 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1372 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1373 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1373 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1374 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1374 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_dio] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | FP\MASTER\DIO#list_dio | MATCH | [sql] foxquery_sql\FP_Master_DIO_list_dio.sql |
| event:popSql.OnSql | RunSqlSource > FindSimulData > ApplyAmendCalendarCondition | 1371 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindSimulData > ApplyAmendCalendarCondition | 1371 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindSimulData > ApplyAmendCalendarCondition | 1372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindSimulData > ApplyAmendCalendarCondition | 1372 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindSimulData > ApplyAmendCalendarCondition | 1373 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindSimulData > ApplyAmendCalendarCondition | 1373 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindSimulData > ApplyAmendCalendarCondition | 1374 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindSimulData > ApplyAmendCalendarCondition | 1374 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1371 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1371 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1372 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1373 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1373 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1374 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1374 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_dio] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | FP\MASTER\DIO#list_dio | MATCH | [sql] foxquery_sql\FP_Master_DIO_list_dio.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1371 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1371 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1372 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1373 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1373 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1374 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindSimulData > ApplyAmendCalendarCondition | 1374 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:this.btn_category.Click | btnCatagory_Click > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_dio] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | FP\MASTER\DIO#list_dio | MATCH | [sql] foxquery_sql\FP_Master_DIO_list_dio.sql |
| event:this.btn_column.Click | btnSimulColumn_Click > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_dio] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnSimulColumn_Click > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | FP\MASTER\DIO#list_dio | MATCH | [sql] foxquery_sql\FP_Master_DIO_list_dio.sql |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 265 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_intransit_Detail] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 265 | FP\Planning\FP00623#find_intransit_Detail | MATCH | [sql] foxquery_sql\FP_Planning_FP00623_find_intransit_Detail.sql |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 267 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOH_Detail_Receipt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 267 | FP\Planning\FP00623#find_BOH_Detail_Receipt | MATCH | [sql] foxquery_sql\FP_Planning_FP00623_find_BOH_Detail_Receipt.sql |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 271 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOH_Detail] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 271 | FP\Planning\FP00623#find_BOH_Detail | MATCH | [sql] foxquery_sql\FP_Planning_FP00623_find_BOH_Detail.sql |
| event:this.spdMain.CellDoubleClick | spdSimul_CellDoubleClick > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_dio] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdSimul_CellDoubleClick > RefreshSpreadSheet_Simul > RefreshHeadAndBody_Simul > DrawSheet_Simul | 2233 | FP\MASTER\DIO#list_dio | MATCH | [sql] foxquery_sql\FP_Master_DIO_list_dio.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 82 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOH_Detail_Receipt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOH_Detail] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_intransit_Detail] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_dio] | BIZ_MATCH | 1 |  |  |  |
| FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\MASTER\DIO#list_dio | MATCH | 1 | [sql] foxquery_sql\FP_Master_DIO_list_dio.sql | SELECT:LOOK_UP, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00623#find_BOH_Detail | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00623_find_BOH_Detail.sql | INSERT:#COATER_SITE, SELECT:FP_INSTANCE_LINE_VA, INSERT:#ITEM_CALC, SELECT:SCM_ITEM_CONV_CALC_MA, SELECT:#COATER_SITEWW, INSERT:#FP_STOCH_H, SELECT:SCM_STOCK_H_VA, SELECT:#FP_STOCH_HA, SELECT:SCM_ITEM_MB, SELECT:SCM_SYS_LOOKUP_VALUEA |  |
| FP\Planning\FP00623#find_BOH_Detail_Receipt | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00623_find_BOH_Detail_Receipt.sql | INSERT:#COATER_SITE, SELECT:FP_INSTANCE_LINE_VA, INSERT:#FP_STOCH_H, SELECT:SCM_STOCK_H_VA, SELECT:#COATER_SITEWW, SELECT:#FP_STOCH_HA, SELECT:SCM_SYS_LOOKUP_VALUEA |  |
| FP\Planning\FP00623#find_intransit_Detail | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00623_find_intransit_Detail.sql | INSERT:#COATER_SITE, SELECT:FP_INSTANCE_LINE_V, INSERT:#ITEM_CALC, SELECT:SCM_ITEM_CONV_CALC_M, SELECT:#COATER_SITE, INSERT:#INS_PLANT, SELECT:FP_INSTANCE_INFO_V, SELECT:FP_WEEKLY_DEMAND_SHIPMENT_H, SELECT:#INS_PLANT, SELECT:FP_SCM_IN_TRANSIT_H, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:SCM_PLANT_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO, CATE_INFO |
| ApplySearchCondition_Simul | Filter | BUCKET_FROM, BUCKET_TO, TABLE_NAME, RELEASE_FLAG, PLAN_TYPE, MASTER_ID, INSTANCE_ID, CHK_PLAN_ID |
| btnPlanInfo_Click | Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, PLAN_DATE, RELEASE_FLAG, PLAN_ID |
| btnPlanInfo_Click | planInfoPopup.Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, USER_ID, PLAN_DATE, RELEASE_FLAG, PLAN_ID, PROG_ID |
| BuildStockVersion | x | COMPANY_ID, DIVISION_ID, SITE_ID, PROD_NAME, ITEM_ID |
| BuildStockVersion | group_rows | VERSION, WORK_REQUEST_MODEL_LT |
| BuildStockVersion | fRow | COMPANY_ID, DIVISION_ID, SITE_ID, PROD_NAME, ITEM_ID |
| BuildStockVersion | r | STOCK_VERSION_ALL, STOCK_VERSION_SEL, WM_VERSION_ALL |
| BuildStockVersion | eR | CATEGORY_ID |
| cboPlanId_changed | dtPlanId.Rows[cboPlanId.SelectedIndex] | PLAN_TYPE, DESCRIPTION, READ_ONLY, NAME |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| DrawSheet_Simul | row | STOCK_VERSION_SEL, WM_VERSION_ALL |
| DrawSheet_Simul | Filter2 | DIVISION_ID, SITE_ID, ITEM_ID |
| DrawSheet_Simul | cRow | CATEGORY_ID, DIVISION_ID, SITE_ID, ITEM_ID |
| DrawSheet_Simul | dio_pole_row | DIO |
| Find_Data_Line | Filter | POP_TYPE |
| FindData | Filter | USER_ID |
| GetPlanId | dtPlanId.Rows[cboPlanId.SelectedIndex] | PLAN_TYPE, DESCRIPTION, READ_ONLY, NAME |
| GetPlanPeriod | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO |
| GetPlanPeriod | dtPlanId.Rows[cboPlanId.SelectedIndex] | DEFAULT_START_DATE, DEFAULT_END_DATE, PLAN_TYPE, DESCRIPTION, READ_ONLY, NAME |
| InitControls | Filter | USER_ID, MASTER_ID, INSTANCE_ID |
| InitControls | dtInstance.Rows[0] | CONFIRM_AREA |
| InitControls | dtUomType.Rows[cboUomType.SelectedIndex] | CODE |
| InitControls | dtUnit.Rows[cboUnit.SelectedIndex] | CODE |
| InitSpread | Filter | CONFIRM_AREA |
| RefreshSpreadSheet_Simul | Filter | UOM_TYPE, PLAN_DATE |
| RefreshSpreadSheet_Simul | x | COMPANY_ID, DIVISION_ID, SITE_ID, PROD_NAME, ITEM_ID, CATEGORY_ID, VERSION |
| RefreshSpreadSheet_Simul | row | RECEIPT_GOOD_QTY_SUM, RECEIPT_GOOD_CELL_QTY, RECEIPT_HOLD_QTY_SUM, RECEIPT_HOLD_CELL_QTY, PANCAKE_GOOD_QTY_SUM2, RECEIPT_GOOD_QTY, RECEIPT_HOLD_QTY |
| RefreshSpreadSheet_Simul | fRow | STOCK_VERSION_SEL, COMPANY_ID, DIVISION_ID, SITE_ID, PROD_NAME, ITEM_ID, CATEGORY_ID |
| RefreshSpreadSheet_Simul | r | GOOD_STOCK_QTY_SUM, GOOD_REWORK_QTY_SUM, GOOD_BOFORE_NT_QTY_SUM, QMS_STOCK_QTY_SUM, QMS_REWORK_QTY_SUM, QMS_BOFORE_NT_QTY_SUM, GMES_STOCK_QTY_SUM, GMES_REWORK_QTY_SUM, GMES_BOFORE_NT_QTY_SUM, PANCAKE_GOOD_QTY_SUM, GOOD_STOCK_CELL_QTY, GOOD_REWORK_CELL_QTY, GOOD_BOFORE_NT_CELL_QTY, QMS_STOCK_CELL_QTY, QMS_REWORK_CELL_QTY, QMS_BOFORE_NT_CELL_QTY, GMES_STOCK_CELL_QTY, GMES_REWORK_CELL_QTY, GMES_BOFORE_NT_CELL_QTY, PANCAKE_GOOD_CELL_QTY, PANCAKE_GOOD_CELL_QTY2, GOOD_STOCK_QTY, GOOD_REWORK_QTY, GOOD_BOFORE_NT_QTY, QMS_STOCK_QTY, QMS_REWORK_QTY, QMS_BOFORE_NT_QTY, GMES_STOCK_QTY, GMES_REWORK_QTY, GMES_BOFORE_NT_QTY, PANCAKE_GOOD_QTY, PANCAKE_GOOD_QTY2 |
| RefreshSpreadSheet_Simul | c | COMPANY_ID, DIVISION_ID, SITE_ID, PROD_NAME, ITEM_ID, GOOD_STOCK_QTY_SUM, GOOD_REWORK_QTY_SUM, GOOD_BOFORE_NT_QTY_SUM, QMS_STOCK_QTY_SUM, QMS_REWORK_QTY_SUM, QMS_BOFORE_NT_QTY_SUM, GMES_STOCK_QTY_SUM, GMES_REWORK_QTY_SUM, GMES_BOFORE_NT_QTY_SUM, PANCAKE_GOOD_QTY_SUM, PANCAKE_GOOD_QTY_SUM2 |
| RefreshSpreadSheet_Simul | stock_row | CATEGORY_ID |
| RefreshSpreadSheet_Simul | Assy_Row | PANCAKE_GOOD_QTY_SUM2 |
| SetCurrentDate | dtIsPast.Rows[0] | CURR_DATE, PLAN_START_DATE, PLAN_END_DATE |
| SetCurrentDate | Filter | PLAN_DATE |
| SetInventory | row | DATA_TYPE, CATEGORY_ID, DIVISION_ID, SITE_ID, MODEL, ITEM_ID, POST_BOH_QTY, LT |
| SetInventory | x | DIVISION_ID, SITE_ID, MODEL, ITEM_ID |
| SetInventory | related_row | CATEGORY_ID |
| spdSimul_CellDoubleClick | fRow | STOCK_VERSION_ALL, STOCK_VERSION_SEL, COMPANY_ID, DIVISION_ID, SITE_ID, PROD_NAME, ITEM_ID |
| spdSimul_CellDoubleClick | x | COMPANY_ID, DIVISION_ID, SITE_ID, PROD_NAME, ITEM_ID |
| spdSimul_CellDoubleClick | r | STOCK_VERSION_SEL |
| spdSimul_CellDoubleClick | row | CATEGORY_ID, DIVISION_ID, SITE_ID, ITEM_ID |
| spdSimul_CellDoubleClick | inputFilter | INSTANCE_ID, PLAN_DATE, DIVISION_ID, SITE_ID, ITEM_ID, DAY_VALUE, POP_TYPE, CTRL_QTY_CONDITION_LT, CTRL_VERSION_LT |
| spdSimul_CellDoubleClick | Filter | INSTANCE_ID, PLAN_DATE |
| spdSimul_CellDoubleClick | clicked_row | DIVISION_ID, SITE_ID, ITEM_ID |
| UIFindData | Filter | PLAN_ID, POPUP_OPEN, RELEASE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:141, InitControl:171, CheckAndGetMeasure:640 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:172, InitControls:173, InitControls:174, InitControls:175, InitControls:177, InitControls:197, InitControls:198, InitControls:199 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | InitControls:196, GetPlanId:307, cboInstance_changed:411, cboInstance_changed:412, cboPlanId_changed:455, cboCellType_changed:535, cboPancakeType_changed:542, cboUnit_changed:559 | CString.GetCheckedListValue | CODE |
| FP_Log2 | cboInstance_changed:406, cboInstance_changed:448 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| SetManualCondition | spdSimul_CellDoubleClick:2706, spdSimul_CellDoubleClick:2707, spdSimul_CellDoubleClick:2708 | BaseForm.SetManualCondition | ControlName, ControlValue |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnClose | Click | btnClose_Click | InitializeComponent:137 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:192 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:193 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:122 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:123 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:124 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:125 |
| this.spdMain | EnabledChanged | spdMain_EnabledChanged | InitializeComponent:126 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:127 |
| this | Load | Form_Load | .ctor:109 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:122 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:123 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:124 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:125 |
| this.spdMain | EnabledChanged | spdMain_EnabledChanged | InitializeComponent:126 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:127 |
| this | Load | Form_Load | .ctor:109 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:193 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:231 |
| this | Load | MeasureSetForm_Load | InitializeComponent:245 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:246 |
| this | Load | Form_Load | .ctor:112 |
| cbo_plan_group | SelectedIndexChanged | cboInstance_changed | InitEvent:277 |
| cboPlanId | SelectedIndexChanged | cboPlanId_changed | InitEvent:278 |
| edtTopItemId | TextChanged | edt_topItem_TextChanged | InitEvent:280 |
| edtItem | TextChanged | edt_item_TextChanged | InitEvent:281 |
| edtNickName | TextChanged | edt_NickName_TextChanged | InitEvent:282 |
| edtModelNickName | TextChanged | edt_ModelNickName_TextChanged | InitEvent:283 |
| cboCellType | SelectedIndexChanged | cboCellType_changed | InitEvent:285 |
| cboPancakeType | SelectedIndexChanged | cboPancakeType_changed | InitEvent:286 |
| cboUomType | SelectedIndexChanged | cboUomType_changed | InitEvent:287 |
| cboUnit | SelectedIndexChanged | cboUnit_changed | InitEvent:288 |
| dCalendar_planrange | ValueChanged | drpPeriod_changed | InitEvent:290 |
| drpPlanDate | ValueChanged | drpPlanDate_changed | InitEvent:291 |
| chk_release | CheckedChanged | chk_release_CheckedChanged | InitEvent:293 |
| chkTotal | CheckedChanged | chkTotal_CheckedChanged | InitEvent:294 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1017 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:795 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:2148 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:2149 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:2150 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:2151 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:2152 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:2153 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:2154 |
| this.spdMain | CellDoubleClick | spdSimul_CellDoubleClick | InitializeComponent:2155 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:2156 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:2157 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:2158 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:2159 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:2160 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:2161 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:2162 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:2163 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:2164 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:2165 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:2166 |
| this.btnPlanInfo | Click | btnPlanInfo_Click | InitializeComponent:2420 |
| this.btn_bucket | Click | btnBucket_Click | InitializeComponent:2459 |
| this.btn_category | Click | btnCatagory_Click | InitializeComponent:2498 |
| this.btn_column | Click | btnSimulColumn_Click | InitializeComponent:2536 |
| this | Load | Form_Load | .ctor:121 |

## 6. 컨트롤 (184개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 56 | layoutControlItem2, layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem10, layoutControlItem16, layoutControlItem18, layoutControlItem22, layoutControlItem23, layoutControlItem24, layoutControlItem25, layoutControlItem26, layoutControlItem27, layoutControlItem28 … |
| UsrCheckedList2 | 16 | mcbo_line, mcbo_division, mcbo_prodtype, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_planner, mcbo_site, usrCheckedList21, usrCheckedList22, usrCheckedList23, usrCheckedList24, usrCheckedList25, usrCheckedList26, usrCheckedList27 … |
| UsrButton | 15 | btnClose, usrButton1, usrButton2, btnSql, btnToggleSave, usrButton1, btnExcelImport, usrButton2, btnPlanInfo, btn_bucket, btn_category, btn_column, usrButton3, usrButton4, usrButton5 |
| UsrLayoutControl | 10 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl4 |
| LayoutControlGroup | 10 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup4, layoutControlGroup2, layoutControlGroup5 |
| EmptySpaceItem | 10 | emptySpaceItem1, emptySpaceItem1, emptySpaceItem1, emptySpaceItem7, emptySpaceItem8, emptySpaceItem4, emptySpaceItem5, emptySpaceItem2, emptySpaceItem6, emptySpaceItem9 |
| UsrTextBox | 10 | edtModelNickName, edtNickName, edtItem, edtTopItemId, edt_pjtGroup, usrTextBox1, usrTextBox2, usrTextBox5, usrTextBox6, usrTextBox7 |
| UsrCombo | 9 | cboUnit, cboUomType, cboPancakeType, cboCellType, cboPlanId, cbo_plan_group, cbo_fpplanid, usrCombo1, usrCombo2 |
| CheckBox | 7 | chk_total, chk_inv, chk_shipment, chk_coater_yield, chk_shipment_in, chk_coater, chk_assy |
| FpSpread | 6 | spdMain, spdMain, spdMain, spdMain, spdEdit, spdInfo |
| SheetView | 6 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1 |
| UsrCheckBox | 6 | chkTotal, chk_release, chk_Info, usrCheckBox1, usrCheckBox2, usrCheckBox3 |
| Panel | 5 | panel1, panel2, panel3, panel4, panel1 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| ImageList | 2 | imageList1, imageList1 |
| Label | 2 | label1, label1 |
| UsrPopupTextBox | 2 | usrPopupTextBox1, usrPopupTextBox2 |
| UsrDateRangePicker2 | 2 | dCalendar_planrange, usrDateRangePicker22 |
| UsrLabel | 2 | txtPlanId, usrLabel2 |
| UsrDatePicker2 | 1 | drpPlanDate |
| SplitContainer | 1 | splitter |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (4건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1371 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1372 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1373 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1374 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 54 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 6 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 47 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00623 | Amend | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | FP00623 | intransit | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |
| SCM_MST_SHEET_COLUMNS | FP00623 | InvDetail | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |
| SCM_MST_SHEET_COLUMNS | FP00623 | PlanInfoPopup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: intransit, InvDetail, Amend, PlanInfoPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:167, SetSheetHeaderColumn_FP@InitSpread:614, SetSheetHeaderColumn_FP@DrawHeader_Simul:2378, SetSheetHeaderColumn_FP@InitSpread:166
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 145 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 146 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| DrawSheet_Simul |  | 2188 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsSimulFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| DrawSheet_Simul |  | 2194 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsSimulFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| InitializeComponent |  | 2182 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2183 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2184 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2185 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2580 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2581 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2582 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2583 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2631 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2632 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2633 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2634 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 169 | 표시/라벨 변경 | SetColumnHeader | 0 |  | if(Filter["CONFIRM_AREA"].ToString() != "BUILDING") |
| InitializeComponent |  | 209 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 210 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 211 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 212 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 145 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 146 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |
| intransit | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |
| InvDetail | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |
| PlanInfoPopup | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
