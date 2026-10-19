# FPC0623 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| shared | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0623_OperationByInstPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 442 |
| shared | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0623_OperationByInstPopup.Designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 383 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FPC0623_DioEditPopup.UIL\FPC0623_DIOEditPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FPC0623_DioEditPopup.UIL\FPC0623_DioEditPopup.UIL.csproj | 1870 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FPC0623_DioEditPopup.UIL\FPC0623_DIOEditPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FPC0623_DioEditPopup.UIL\FPC0623_DioEditPopup.UIL.csproj | 692 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FPC0623_DioEditPopup.UIL\FPC0623_RowExcelPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FPC0623_DioEditPopup.UIL\FPC0623_DioEditPopup.UIL.csproj | 821 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FPC0623_DioEditPopup.UIL\FPC0623_RowExcelPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FPC0623_DioEditPopup.UIL\FPC0623_DioEditPopup.UIL.csproj | 874 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FPC0623_DioEditPopup.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FPC0623_DioEditPopup.UIL\FPC0623_DioEditPopup.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_division.SelectedIndexChanged | mcbo_division_changed > GetSite | 1843 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged | 236 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 216 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 216 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 217 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 217 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 218 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 219 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Memo | 728 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dio] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Memo | 728 | FP\MASTER\DIO#find_dio | MATCH | [sql] foxquery_sql\FP_Master_DIO_find_dio.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo | 728 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dio] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Memo | 728 | FP\MASTER\DIO#find_dio | MATCH | [sql] foxquery_sql\FP_Master_DIO_find_dio.sql |
| button:SaveButton | SaveButton > Save_Data > UIFindData > Find_Data_Memo | 728 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dio] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > UIFindData > Find_Data_Memo | 728 | FP\MASTER\DIO#find_dio | MATCH | [sql] foxquery_sql\FP_Master_DIO_find_dio.sql |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Momo | 903 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_dio] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Momo | 903 | FP\MASTER\DIO#save_dio | MATCH | [update-batch]  |
| event:this.btnExcel.Click | btnExcel_Click > UIFindData > Find_Data_Memo | 728 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dio] | BIZ_MATCH |  |
| event:this.btnExcel.Click | btnExcel_Click > UIFindData > Find_Data_Memo | 728 | FP\MASTER\DIO#find_dio | MATCH | [sql] foxquery_sql\FP_Master_DIO_find_dio.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 216 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 216 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 217 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 217 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 218 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 219 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| event:this.Load | Form_Load > InitControls | 188 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 216 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 216 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 217 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 217 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 218 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 219 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| event:this.Load | Form_Load > InitControls > GetDivision | 1828 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetSite | 1843 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetCateTable | 1204 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetCateTable | 1204 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| unreached:(진입점 미연결) | GetModelChangeTable | 1224 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P_ID] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetModelChangeTable | 1224 | FP\Common\AmendMemo#find_SetupColor_P_ID | MATCH | [sql] foxquery_sql\FP_Common_AmendMemo_find_SetupColor_P_ID.sql |
| unreached:(진입점 미연결) | Save_Data_Momo_Excel | 1624 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Data_Momo_Excel | 1624 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| unreached:(진입점 미연결) | Save_Data_Momo_Excel | 1645 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=fetch_amend_memo] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Data_Momo_Excel | 1645 | FP\Common\AmendMemo#fetch_amend_memo | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 1719 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 1719 | FP\Common\MemoExcel#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 1720 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 1720 | FP\Common\MemoExcel#find_Excel_buffer_validation | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_MemoExcel_find_Excel_buffer_validation.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 1730 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_validation_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 1730 | FP\Common\MemoExcel#delete_validation_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_MemoExcel_delete_validation_buffer.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_validation_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dio] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P_ID] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=fetch_amend_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_dio] | BIZ_MATCH | 1 |  |  |  |
| FP\Common\AmendMemo#fetch_amend_memo | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\AmendMemo#find_SetupColor_P_ID | MATCH | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_find_SetupColor_P_ID.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\MemoExcel#delete_validation_buffer | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_MemoExcel_delete_validation_buffer.sql | DELETE:BUF_FP_AMEND_MEMO_VALIDATION |  |
| FP\Common\MemoExcel#find_Excel_buffer_validation | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_MemoExcel_find_Excel_buffer_validation.sql | SELECT:BUF_FP_AMEND_MEMO_VALIDATION, SELECT:FP_INSTANCE_INFO_V, SELECT:SCM_LINE_M, SELECT:SCM_ITEM_M, SELECT:SCM_FACTORY_M, SELECT:SCM_OPERATION_M |  |
| FP\Common\MemoExcel#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\MASTER\DIO#find_dio | MATCH | 1 | [sql] foxquery_sql\FP_Master_DIO_find_dio.sql | SELECT:BASE_SCM, SELECT:LOOK_UP, SELECT:SCM_ITEM_M, SELECT:SCM_BOM_M, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\MASTER\DIO#save_dio | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | DATE_INFO, MONTH_INFO, BUCKET, WEEK_INFO |
| btnExcel_Click | rowPopup.KeyColumns | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, MARKET, PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, PLAN_DATE |
| btnExcel_Click | rowPopup.ColumnTitle | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID, MARKET, PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, NICK_NAME, PLAN_DATE, MEMO_RANGE, MEMO_TYPE, MEMO, UPDATE_ID, UPDATE_TIME, MESSAGE |
| btnExcel_Click | rowPopup.ColumnWidth | DIVISION_ID, SITE_ID, LINE_NAME, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MEMO |
| btnFind_Click | Filter | PLAN_DATE, PLAN_TYPE, CURR_DATE |
| call_Excel_Row_Search | r | ITEM_ID, MEMO_RANGE |
| call_Excel_Row_Validation | Filter | GUID |
| call_Excel_Row_Validation | row | GUID |
| dateRange_ValueChanged | Filter | BUCKET_FROM, BUCKET_TO |
| Find_Data_Memo | Filter | ITEM_ID, TOP_ITEM_ID, NICK_NAME |
| FindData | filter | USER_ID, INSTANCE_ID, OPERATION_ID |
| GetCateTable | Filter | USER_ID |
| GetCateTable | cate | CODE, SEGMENT1, NAME, ATTRIBUTE2 |
| GetDivision | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| GetModelChangeTable | Filter | INSTANCE_ID |
| GetModelChangeTable | cate | CODE, COLOR_ID, NAME, UI_COLOR |
| GetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| InitControls | Filter | DIVISION_ID, SITE_ID, PLAN_TYPE, PLAN_DATE, UI_END_DATE, CURR_DATE, BUCKET_FROM, BUCKET_TO, MPP_WPP |
| mcbo_division_changed | Filter | DIVISION_ID |
| mcbo_site_changed | Filter | SITE_ID |
| radioMPP_CheckedChanged | Filter | MPP_WPP |
| radioWPP_CheckedChanged | Filter | MPP_WPP |
| RefreshHeader | r | DEFAULT_YN |
| Save_Data_Momo | Filter | USER_ID |
| Save_Data_Momo | row | USER_ID |
| Save_Data_Momo_Excel | Filter | USER_ID |
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
| UIFindData | Filter | DIVISION_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| FP_UpdateBatch | Save_Data_Momo:903, Save_Data_Momo_Excel:1645 | DataService.FP_UpdateBatch | COUNT, RESULT |
| ReadResult | Save_Data_Momo:904, Save_Data_Momo_Excel:1646 | DataService.ReadResult | COUNT, EXCEPTION, RESULT |
| FP_PseudoBatch | call_Excel_Row_Validation:1719 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| FP_Log | SaveToDB:490, SaveToDB:492, SaveToDB:555, SaveToDB:557, SaveToDB:598, OpenAndLoadExcelData:719, btnSave_Click:788, btnSave_Click:790 | DataService.FP_Log | LOGTYPE, NOTE, USER_ID |
| CommonDefaultLineCheck | DefaultLineCheck:731 | ExcelService.CommonDefaultLineCheck | BUCKET_FROM, BUCKET_TO, MESSAGE, QTY |
| GetCheckedListValue | FindData:317, FindData:318 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.cbo_division | SelectedIndexChanged | cbo_division_SelectedIndexChanged | InitializeComponent:312 |
| this.btnExcel | Click | btnExcel_Click | InitializeComponent:349 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:413 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:582 |
| this.spdMain | ComboCloseUp | spdMain_ComboCloseUp | InitializeComponent:583 |
| this.spdMain | ComboDropDown | spdMain_ComboDropDown | InitializeComponent:584 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:585 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:586 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:587 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:588 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:589 |
| this | Load | Form_Load | .ctor:99 |
| cbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:292 |
| cbo_site | SelectedIndexChanged | mcbo_site_changed | InitEvent:293 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:295 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitEvent:296 |
| defaultSheetDataModel | Changed | DefaultSheetDataModel_Changed | SetSpreadInit:363 |
| popSql | OnSql | RunSqlSource | btnSql_Click:933 |
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
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:196 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:246 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:247 |
| this | Load | Form_Load | .ctor:125 |
| this | Load | Form_Load | .ctor:137 |
| this | Load | Form_Load | .ctor:149 |
| cboInstance | SelectedIndexChanged | CboInstance_SelectedIndexChanged | InitEvent:215 |

## 6. 컨트롤 (63개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 20 | lblSql, lblExcel, layoutControlItem2, layoutControlItem5, layoutControlItem1, layoutControlItem3, layoutControlItem4, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem7, lciMpphead, lciWpp, lciMpp … |
| UsrButton | 7 | btnExcel, btnSql, btnSave, btnClose, btnFind, btnDownload, btnUpload |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 4 | cbo_site, cbo_division, cboOperation, cboInstance |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrTextBox | 3 | txtNickname, txtModel, txtItemID |
| FpSpread | 3 | spdMain, spdMain, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| ImageList | 2 | imageList1, imageList1 |
| UsrLabel | 2 | usrLabel2, usrLabel1 |
| UsrRadio | 2 | radioMPP, radioWPP |
| UsrDateRangePicker2 | 1 | dateRange |
| UsrButtonList | 1 | btnButtonList |

## 7. 확인 필요 (10건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1720 | call_Excel_Row_Validation | FP\{?default:part_service}\MemoExcel#find_Excel_buffer_validation | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 216 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 217 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 218 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 219 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1730 | call_Excel_Row_Validation | FP\{?default:part_service}\MemoExcel#delete_validation_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1204 | GetCateTable | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1624 | Save_Data_Momo_Excel | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1645 | Save_Data_Momo_Excel | FP\{?default:part_service}\AmendMemo#fetch_amend_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1719 | call_Excel_Row_Validation | FP\{?default:part_service}\MemoExcel#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 22 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
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
| SCM_MST_SHEET_COLUMNS | FPC0623 | Main | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |
| SCM_MST_SHEET_COLUMNS | FPC0623 | OperationByInstPopup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | FPC0623 | OperationPopup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, AutoExcelPopup, OperationByInstPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:353, SetSheetHeaderColumn_FP@SetSpreadInit:268

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 263 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 264 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 265 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 266 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| Find_Data_Old | Main | 645 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 605 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 606 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 607 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 608 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
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
| Main | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| OperationByInstPopup | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| OperationPopup | 메타 정의만, 코드 미참조(미사용 가능) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
