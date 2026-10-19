# FPC0103 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0103_DWSubmit.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 671 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0103_DWSubmit.designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 708 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbMpp.CheckedChanged | Mpp_CheckedChanged > FindData | 331 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:cbMpp.CheckedChanged | Mpp_CheckedChanged > FindData | 331 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:cbMpp.CheckedChanged | Mpp_CheckedChanged > FindData | 332 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:cbMpp.CheckedChanged | Mpp_CheckedChanged > FindData | 332 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:cbMpp.CheckedChanged | Mpp_CheckedChanged > FindData | 333 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:cbMpp.CheckedChanged | Mpp_CheckedChanged > FindData | 333 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:cbMpp.CheckedChanged | Mpp_CheckedChanged > FindData | 334 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:cbMpp.CheckedChanged | Mpp_CheckedChanged > FindData | 334 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:cbMpp.CheckedChanged | Mpp_CheckedChanged | 605 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPeriod_DWSubmit] | BIZ_MATCH |  |
| event:cbMpp.CheckedChanged | Mpp_CheckedChanged | 605 | FP\Common\XpCommonAmend#findPeriod_DWSubmit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_findPeriod_DWSubmit.sql |
| event:cbWpp.CheckedChanged | Wpp_CheckedChanged > FindData | 331 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:cbWpp.CheckedChanged | Wpp_CheckedChanged > FindData | 331 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:cbWpp.CheckedChanged | Wpp_CheckedChanged > FindData | 332 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:cbWpp.CheckedChanged | Wpp_CheckedChanged > FindData | 332 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:cbWpp.CheckedChanged | Wpp_CheckedChanged > FindData | 333 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:cbWpp.CheckedChanged | Wpp_CheckedChanged > FindData | 333 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:cbWpp.CheckedChanged | Wpp_CheckedChanged > FindData | 334 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:cbWpp.CheckedChanged | Wpp_CheckedChanged > FindData | 334 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:cbWpp.CheckedChanged | Wpp_CheckedChanged | 578 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPeriod_DWSubmit] | BIZ_MATCH |  |
| event:cbWpp.CheckedChanged | Wpp_CheckedChanged | 578 | FP\Common\XpCommonAmend#findPeriod_DWSubmit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_findPeriod_DWSubmit.sql |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > GetLine > FindData | 331 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > GetLine > FindData | 331 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > GetLine > FindData | 332 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > GetLine > FindData | 332 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > GetLine > FindData | 333 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > GetLine > FindData | 333 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > GetLine > FindData | 334 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > GetLine > FindData | 334 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 331 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 331 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 332 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 332 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 333 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 333 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 334 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 334 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:FindButton | FindButton > FindData | 331 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 331 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:FindButton | FindButton > FindData | 332 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 332 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:FindButton | FindButton > FindData | 333 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 333 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:FindButton | FindButton > FindData | 334 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 334 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 401 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 401 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 418 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveAuth] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 418 | FP\Common\XpCommonAmend#find_saveAuth | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_saveAuth.sql |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 449 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_DWSubmit] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 449 | FP\Common\XpCommonAmend#insert_DWSubmit | MATCH_PATTERN | [update-batch]  |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 458 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeSubmit] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 458 | FP\Common\XpCommonAmend#executeSubmit | MATCH_PATTERN | SP PR_SCM_MPP_WPP_CONVERT |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 458 | biz:AppService.GeneralRunProcedureCustomTable [procedure=executeSubmit] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 458 | XpCommonAmend#executeSubmit | NOT_IN_FOXQUERY |  |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 467 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=update_Submit_Flag] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click_1 > SaveData | 467 | FP\Common\XpCommonAmend#update_Submit_Flag | MATCH_PATTERN | [update-batch]  |
| event:this.Load | Form_Load > InitControls | 178 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 178 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.Load | Form_Load > InitControls | 190 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 207 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPeriod_DWSubmit] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 207 | FP\Common\XpCommonAmend#findPeriod_DWSubmit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_findPeriod_DWSubmit.sql |
| event:this.Load | Form_Load > FindData | 331 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 331 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:this.Load | Form_Load > FindData | 332 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 332 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:this.Load | Form_Load > FindData | 333 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 333 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:this.Load | Form_Load > FindData | 334 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 334 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=executeSubmit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=update_Submit_Flag] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveAuth] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPeriod_DWSubmit] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeSubmit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_DWSubmit] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 1 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\XpCommonAmend#executeSubmit | MATCH_PATTERN | 1 | SP PR_SCM_MPP_WPP_CONVERT | EXEC:PR_SCM_MPP_WPP_CONVERT | ⚠ DB에 SP 없음 |
| FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql | REF:FN_SITE_TIME, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\XpCommonAmend#find_saveAuth | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_saveAuth.sql | SELECT:FP_RELEASE_PLAN_INFO_H, SELECT:FP_USER_ROLE_INFO_V, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#findPeriod_DWSubmit | MATCH_PATTERN | 3 | [sql] foxquery_sql\FP_Common_XpCommonAmend_findPeriod_DWSubmit.sql | SELECT:TH_UIS_CALENDAR, SELECT:TH_UIS_CAL, REF:FN_SITE_TIME, SELECT:FP_INSTANCE_INFO_V, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#insert_DWSubmit | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\XpCommonAmend#update_Submit_Flag | MATCH_PATTERN | 1 | [update-batch]  | UPDATE:A, SELECT:SCM_FP_PLAN_H, REF:FN_SITE_TIME |  |
| XpCommonAmend#executeSubmit | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbOperation_SelectedIndexChanged | Filter | OPERATION_ID |
| FindData | Filter | BUCKET |
| GetLine | Filter | LINE_ID |
| InitControls | Filter | SUBMIT_TYPE, OPERATION_ID, CURR_DATE, MASTER_ID, MPP_WPP, START_DATE, BUCKET_FROM, END_DATE, BUCKET_TO |
| InitControls | ds_isCurrWeek.Tables[0].Rows[0] | CURR_DATE |
| InitControls | dtControl.Rows[0] | AMEND_LIMIT_YN, AMEND_LIMIT_DATE2 |
| Mpp_CheckedChanged | Filter | MPP_WPP, START_DATE, BUCKET_FROM, END_DATE, BUCKET_TO |
| period_ValueChanged | Filter | CURR_DATE, BUCKET_FROM, BUCKET_TO |
| SaveData | Filter | PLAN_TYPE, _SEQ, CALL_SEQUENCE, FP_SITE_ID, SITE_ID |
| SaveData | dtDWSubmitData.Rows[i] | CALL_SEQUENCE |
| Wpp_CheckedChanged | Filter | MPP_WPP, START_DATE, BUCKET_FROM, END_DATE, BUCKET_TO |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:176, clbOperation_SelectedIndexChanged:534, GetLine:544 | CString.GetCheckedListValue | CODE |
| FP_UpdateBatch2 | SaveData:449 | DataService.FP_UpdateBatch2 | COUNT, EXCEPTION, RESULT |
| ParamDictionaryToTable | SaveData:461 | FoxDataClient.ParamDictionaryToTable | EMPTYSAMPLE |
| SaveData | btnOK_Click_1:665 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:123 |
| this | Load | Form_Load | .ctor:136 |
| drPeriod | ValueChanged | period_ValueChanged | Form_Load:153 |
| cbWpp | CheckedChanged | Wpp_CheckedChanged | Form_Load:154 |
| cbMpp | CheckedChanged | Mpp_CheckedChanged | Form_Load:155 |
| clbOperation | SelectedIndexChanged | clbOperation_SelectedIndexChanged | Form_Load:156 |
| cbMpp | CheckedChanged | Mpp_CheckedChanged | Wpp_CheckedChanged:575 |
| cbMpp | CheckedChanged | Mpp_CheckedChanged | Wpp_CheckedChanged:577 |
| drPeriod | ValueChanged | period_ValueChanged | Wpp_CheckedChanged:581 |
| drPeriod | ValueChanged | period_ValueChanged | Wpp_CheckedChanged:591 |
| cbWpp | CheckedChanged | Wpp_CheckedChanged | Mpp_CheckedChanged:602 |
| cbWpp | CheckedChanged | Wpp_CheckedChanged | Mpp_CheckedChanged:604 |
| drPeriod | ValueChanged | period_ValueChanged | Mpp_CheckedChanged:608 |
| drPeriod | ValueChanged | period_ValueChanged | Mpp_CheckedChanged:618 |
| drPeriod | ValueChanged | period_ValueChanged | period_ValueChanged:624 |
| drPeriod | ValueChanged | period_ValueChanged | period_ValueChanged:651 |
| this.btnOK | Click | btnOK_Click_1 | InitializeComponent:176 |

## 6. 컨트롤 (23개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lblDivision, layoutControlItem2, layoutControlItem5, layoutControlItem7, layoutControlItem8, layoutControlItem10, lblLine, layoutControlItem1, layoutControlItem4 |
| UsrLabel | 3 | usrLabel4, usrLabel3, usrLabel2 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckBox | 2 | cbMpp, cbWpp |
| UsrCheckedList2 | 2 | clbOperation, clbLine |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrButton | 1 | btnOK |
| UsrDateRangePicker2 | 1 | drPeriod |

## 7. 확인 필요 (14건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 178 | InitControls | FP\{?default:part_service}\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 331 | FindData | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 332 | FindData | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 333 | FindData | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 334 | FindData | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 401 | SaveData | FP\{?default:part_service}\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 458 | SaveData | FP\{?default:part_service}\XpCommonAmend#executeSubmit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 449 | SaveData | FP\{?default:part_service}\XpCommonAmend#insert_DWSubmit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 467 | SaveData | FP\{?default:part_service}\XpCommonAmend#update_Submit_Flag | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 458 | SaveData | XpCommonAmend#executeSubmit | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |
| 207 | InitControls | FP\{?default:part_service}\XPCommonAmend#findPeriod_DWSubmit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 418 | SaveData | FP\{?default:part_service}\XpCommonAmend#find_saveAuth | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 578 | Wpp_CheckedChanged | FP\{?default:part_service}\XPCommonAmend#findPeriod_DWSubmit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 605 | Mpp_CheckedChanged | FP\{?default:part_service}\XPCommonAmend#findPeriod_DWSubmit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:282

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
