# FP01620 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01620_WO_Create.UIL\FP01620_WO_Create.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01620_WO_Create.UIL\FP01620_WO_Create.UIL.csproj | 1140 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01620_WO_Create.UIL\FP01620_WO_Create.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01620_WO_Create.UIL\FP01620_WO_Create.UIL.csproj | 1127 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01620_WO_Create.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01620_WO_Create.UIL\FP01620_WO_Create.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01620_WO_Create.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01620_WO_Create.UIL\FP01620_WO_Create.UIL.csproj | 84 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP01620_WO_Create.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1133 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP01620_WO_Create.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1087 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged | 739 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged | 739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged | 739 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged | 743 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 1002 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 1002 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 1052 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 1052 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 1101 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged > SetChangeControl | 1002 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged > SetChangeControl | 1002 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged > SetChangeControl | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged > SetChangeControl | 1052 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged > SetChangeControl | 1052 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged > SetChangeControl | 1101 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CoPlanID_SelectedIndexChanged > SetChangeControl | 1002 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CoPlanID_SelectedIndexChanged > SetChangeControl | 1002 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:cboPlanID.SelectedIndexChanged | CoPlanID_SelectedIndexChanged > SetChangeControl | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cboPlanID.SelectedIndexChanged | CoPlanID_SelectedIndexChanged > SetChangeControl | 1052 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CoPlanID_SelectedIndexChanged > SetChangeControl | 1052 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboPlanID.SelectedIndexChanged | CoPlanID_SelectedIndexChanged > SetChangeControl | 1101 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangeControl | 1002 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangeControl | 1002 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangeControl | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangeControl | 1052 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangeControl | 1052 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangeControl | 1101 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 1002 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 1002 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 1052 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 1052 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 1101 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 1002 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 1002 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 1052 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 1052 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 1101 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 1002 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 1002 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 1052 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 1052 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 1101 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 822 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1002 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1002 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1052 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1052 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1101 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged | 775 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangeControl | 1002 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangeControl | 1002 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangeControl | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangeControl | 1052 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangeControl | 1052 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangeControl | 1101 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Execute | 698 | FP_Master.PR_UI_FP01620_WO_CREATE | MATCH | SP PR_UI_FP01620_WO_CREATE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Execute | 698 | FP_Master.PR_UI_FP01620_WO_CREATE | MATCH | SP PR_UI_FP01620_WO_CREATE |
| event:this.Load | Form_Load > InitControls | 210 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 212 | biz:FPCommonDataBLL.YesNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > CboInstance_SelectedIndexChanged | 739 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > CboInstance_SelectedIndexChanged | 739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > CboInstance_SelectedIndexChanged | 739 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:this.Load | Form_Load > InitControls > CboInstance_SelectedIndexChanged | 743 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > DrpPlanDate_ValueChanged | 775 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 822 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > DrpPlanDate_ValueChanged > SetChangeControl | 1002 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > DrpPlanDate_ValueChanged > SetChangeControl | 1002 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| event:this.Load | Form_Load > InitControls > DrpPlanDate_ValueChanged > SetChangeControl | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > DrpPlanDate_ValueChanged > SetChangeControl | 1052 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > DrpPlanDate_ValueChanged > SetChangeControl | 1052 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > DrpPlanDate_ValueChanged > SetChangeControl | 1101 | biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlanGroup | 1131 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlanGroup | 1131 | FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql |
| unreached:(진입점 미연결) | <field:dtDayWeek> | 52 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.YesNo | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP01620_WO_CREATE | MATCH | 1 | SP PR_UI_FP01620_WO_CREATE | EXEC:PR_UI_FP01620_WO_CREATE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 3 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\BigFilter_FP#get_instance_id_except_post | MATCH | 3 | [sql] foxquery_sql\FP_Common_BigFilter_FP_get_instance_id_except_post.sql | SELECT:FP_USER_ROLE_INFO_V, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetPlanGroup | Filter | USER_ID |
| InitControls | dtCurDate.Rows[0] | CURR_DATE |
| Search_After | row | RETURN_STATUS |
| SetChangeControl | Filter | INSTANCE_ID, MASTER_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| SetChangeControl | dtCurDate.Rows[0] | CURR_DATE |
| tbItemId_BeforeOpenSearch | tbItemId.Filter | division_lt, site_lt |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:209, Find_Data_Execute:667, Find_Data_Execute:668, Find_Data_Execute:669, Find_Data_Execute:670, Find_Data_Execute:671, Find_Data_Execute:672, Find_Data_Execute:673 | CString.GetCheckedListValue | CODE |
| GetInnerTable | SetChangeControl:1002, SetChangeControl:1012, SetChangeControl:1028, SetChangeControl:1040, SetChangeControl:1052, SetChangeControl:1063, SetChangeControl:1074, GetPlanGroup:1131 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:139 |
| cboInstance | SelectedIndexChanged | CboInstance_SelectedIndexChanged | InitEvent:493 |
| drpPlanDate | ValueChanged | DrpPlanDate_ValueChanged | InitEvent:494 |
| cboPlanID | SelectedIndexChanged | CoPlanID_SelectedIndexChanged | InitEvent:495 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:496 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:497 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:498 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:499 |
| cboOperation | SelectedIndexChanged | CboOperation_SelectedIndexChanged | InitEvent:500 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:501 |
| drpPeriod | ValueChanged | DrpPeriod_ValueChanged | InitEvent:502 |
| popSql | OnSql | RunSqlSource | btnSql_Click:567 |
| drpPlanDate | ValueChanged | DrpPlanDate_ValueChanged | DrpPlanDate_ValueChanged:765 |
| drpPlanDate | ValueChanged | DrpPlanDate_ValueChanged | DrpPlanDate_ValueChanged:767 |
| drpPlanDate | ValueChanged | DrpPlanDate_ValueChanged | DrpPlanDate_ValueChanged:773 |
| drpPlanDate | ValueChanged | DrpPlanDate_ValueChanged | DrpPlanDate_ValueChanged:776 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:518 |
| this.tbItemId | OnSearchConditionChanged | tbItemId_OnSearchConditionChanged | InitializeComponent:743 |
| this.tbItemId | BeforeOpenSearch | tbItemId_BeforeOpenSearch | InitializeComponent:744 |

## 6. 컨트롤 (39개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 14 | lblSql, lblInstance, lblSite, lblPeriod, lblPlanDate, lblPlant, lblPlanID, lblFactory, lblDivision, lblOperation, lblLine, lblItem, lblWorkOrderID, lblTarget |
| UsrCombo | 5 | cboOperation, cboPlanID, cboSite, cboInstance, cboTarget |
| UsrCheckedList2 | 4 | clbLine, clbDivision, clbPlant, clbFactory |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrButton | 1 | btnSql |
| UsrDatePicker2 | 1 | drpPlanDate |
| UsrTextBox | 1 | txtWorkOrderID |
| UsrDateRangePicker2 | 1 | drpPeriod |
| UsrPopupTextBox | 1 | tbItemId |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 30 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 17 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP01620 | Main | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:523

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 1012 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1013 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1014 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1015 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
