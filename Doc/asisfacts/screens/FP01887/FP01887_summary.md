# FP01887 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_Authority_Approval.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_Authority_Approval.UIL.csproj | 2908 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_Authority_Approval.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_Authority_Approval.UIL.csproj | 1152 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_DescriptionPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_Authority_Approval.UIL.csproj | 129 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_DescriptionPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_Authority_Approval.UIL.csproj | 278 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_InstancePopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_Authority_Approval.UIL.csproj | 465 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_InstancePopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_Authority_Approval.UIL.csproj | 301 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_Authority_Approval.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP01887_Authority_Approval.UIL\FP01887_Authority_Approval.UIL.csproj | 84 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP01887_Authority_Approval.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 2901 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP01887_Authority_Approval.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1155 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP01887_DescriptionPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 129 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP01887_DescriptionPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 278 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP01887_InstancePopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 465 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP01887_InstancePopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 301 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 2861 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 2861 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged | 2500 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 2861 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 2861 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbInstance.SelectedIndexChanged | ClbInstance_SelectedIndexChanged | 2481 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbInstance.SelectedIndexChanged | ClbInstance_SelectedIndexChanged | 2481 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbInstance.SelectedIndexChanged | ClbInstance_SelectedIndexChanged > SetChangeControl | 2861 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbInstance.SelectedIndexChanged | ClbInstance_SelectedIndexChanged > SetChangeControl | 2861 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlanGroup.SelectedIndexChanged | ClbPlanGroup_SelectedIndexChanged > SetChangeControl | 2861 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlanGroup.SelectedIndexChanged | ClbPlanGroup_SelectedIndexChanged > SetChangeControl | 2861 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 2861 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 2861 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| button:FindButton | FindButton > Find_Data > Find_Data_User | 835 | SystemManager.UP_FX_GetUserInfoSearchList | MATCH | SP UP_FX_GetUserInfoSearchList |
| button:FindButton | FindButton > Find_Data > Find_Data_Approval | 1054 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| event:popSql.OnSql | RunSqlSource > Find_Data_Approval | 1054 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| event:popSql.OnSql | RunSqlSource > Save_Data_Reject | 2199 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| button:SaveButton | SaveButton > Save_Edit > Find_Data > Find_Data_User | 835 | SystemManager.UP_FX_GetUserInfoSearchList | MATCH | SP UP_FX_GetUserInfoSearchList |
| button:SaveButton | SaveButton > Save_Edit > Find_Data > Find_Data_Approval | 1054 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| button:SaveButton | SaveButton > Save_Edit > Save_Data_Edit | 2389 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| event:this.btnApproval.Click | btnApproval_Click > Save_Approval > AddMyAuthList > RequestAuthList > SaveAuthList > FindButton > Find_Data > Find_Data_User | 835 | SystemManager.UP_FX_GetUserInfoSearchList | MATCH | SP UP_FX_GetUserInfoSearchList |
| event:this.btnApproval.Click | btnApproval_Click > Save_Approval > AddMyAuthList > RequestAuthList > SaveAuthList > FindButton > Find_Data > Find_Data_Approval | 1054 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| event:this.btnApproval.Click | btnApproval_Click > Save_Approval > AddMyAuthList | 1473 | SystemManager.UP_FX_SaveReqAuthAddMyList | MATCH | SP UP_FX_SaveReqAuthAddMyList |
| event:this.btnApproval.Click | btnApproval_Click > Save_Approval > AddMyAuthList > RequestAuthList | 1560 | SystemManager.UP_FX_SaveReqAuthRequestMyList | MATCH | SP UP_FX_SaveReqAuthRequestMyList |
| event:this.btnApproval.Click | btnApproval_Click > Save_Approval > AddMyAuthList > RequestAuthList > SaveAuthList | 1644 | SystemManager.UP_FX_SaveApprovalAuthRequest | MATCH | SP UP_FX_SaveApprovalAuthRequest |
| event:this.btnApproval.Click | btnApproval_Click > Save_Approval > Save_Data_Approval | 1725 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_approval] | BIZ_MATCH |  |
| event:this.btnApproval.Click | btnApproval_Click > Save_Approval > Save_Data_Approval | 1725 | FP\Common\FP01887_Authority_Approval#insert_approval | MATCH_PATTERN | [update-batch]  |
| event:this.btnApproval.Click | btnApproval_Click > Save_Approval > Save_Data_Approval_Menu | 1763 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_approval_menu] | BIZ_MATCH |  |
| event:this.btnApproval.Click | btnApproval_Click > Save_Approval > Save_Data_Approval_Menu | 1763 | FP\Common\FP01887_Authority_Approval#insert_approval_menu | MATCH_PATTERN | [update-batch]  |
| event:this.btnApproval.Click | btnApproval_Click > Save_Approval > AddMyAuthList > FindData_MyAddedAuthList | 2748 | SystemManager.UP_FX_GetReqAuthMyListAdded | MATCH | SP UP_FX_GetReqAuthMyListAdded |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Instance | 303 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| event:this.btnReject.Click | btnReject_Click > Save_Reject > Find_Data > Find_Data_User | 835 | SystemManager.UP_FX_GetUserInfoSearchList | MATCH | SP UP_FX_GetUserInfoSearchList |
| event:this.btnReject.Click | btnReject_Click > Save_Reject > Find_Data > Find_Data_Approval | 1054 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| event:this.btnReject.Click | btnReject_Click > Save_Reject > Save_Data_Reject | 2199 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| event:this.Load | Form_Load > FindData > Find_Data_Instance | 303 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| event:this.Load | Form_Load > DefineProperty > GetInsertedUserInfo | 325 | SystemManager.UP_FX_GetReqAuthCurrentUser | MATCH | SP UP_FX_GetReqAuthCurrentUser |
| event:this.Load | Form_Load > InitControls > ClbInstance_SelectedIndexChanged | 2481 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbInstance_SelectedIndexChanged | 2481 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > ClbFactory_SelectedIndexChanged | 2500 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > ClbFactory_SelectedIndexChanged > SetChangeControl | 2861 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbFactory_SelectedIndexChanged > SetChangeControl | 2861 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| unreached:(진입점 미연결) | <field:dtCompany_ID> | 86 | biz:CommonData.CommonDataList [code=Company] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ClbPlanGroup_Click | 422 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| unreached:(진입점 미연결) | Save_Data_Approval_Old | 1875 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| unreached:(진입점 미연결) | Save_Data_Approval_Menu_Old | 2002 | FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | SP PR_UI_FP01887_AUTHORITY_APPROVAL |
| unreached:(진입점 미연결) | SetPlanGroup | 2710 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Company] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_COMPANY_SN, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_MST_COMPANY_SN |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_approval_menu] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_approval] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 3 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | MATCH | 6 | SP PR_UI_FP01887_AUTHORITY_APPROVAL | EXEC:PR_UI_FP01887_AUTHORITY_APPROVAL | ⚠ DB에 SP 없음 |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\FP01887_Authority_Approval#insert_approval | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\FP01887_Authority_Approval#insert_approval_menu | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| SystemManager.UP_FX_GetReqAuthCurrentUser | MATCH | 1 | SP UP_FX_GetReqAuthCurrentUser | EXEC:UP_FX_GETREQAUTHCURRENTUSER, SELECT:TB_FX_USER, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO |  |
| SystemManager.UP_FX_GetReqAuthMyListAdded | MATCH | 1 | SP UP_FX_GetReqAuthMyListAdded | EXEC:UP_FX_GETREQAUTHMYLISTADDED, SELECT:SCM_MST_AUTH_REQUEST, SELECT:TB_FX_GROUPINFO, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USER, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, SELECT:TB_FX_USERGROUPAUTHEXTENTION |  |
| SystemManager.UP_FX_GetUserInfoSearchList | MATCH | 1 | SP UP_FX_GetUserInfoSearchList | EXEC:UP_FX_GETUSERINFOSEARCHLIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPINFO |  |
| SystemManager.UP_FX_SaveApprovalAuthRequest | MATCH | 1 | SP UP_FX_SaveApprovalAuthRequest | EXEC:UP_FX_SAVEAPPROVALAUTHREQUEST, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SCM_MST_AUTH_REQUEST, DELETE:TB_FX_USERGROUPAUTHEXTENTION, UPDATE:T, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:TB_FX_USER, EXEC:UP_FX_SAVEUSERINFO, EXEC:UP_FX_SAVEUSERGROUPINFO, EXEC:UP_FX_SAVEUSERGROUPAUTHEXTENTION, INSERT:SCM_SYS_LOG_BATCH, MERGE:TB_FX_USER, SELECT:SCM_MST_SSO_USER_INFO, UPDATE:TB_FX_USER, MERGE:TB_FX_USERGROUPINFO, MERGE:TB_FX_USERGROUPAUTHEXTENTION |  |
| SystemManager.UP_FX_SaveReqAuthAddMyList | MATCH | 1 | SP UP_FX_SaveReqAuthAddMyList | EXEC:UP_FX_SAVEREQAUTHADDMYLIST, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCM_MST_AUTH_REQUEST, INSERT:SCM_SYS_LOG_BATCH |  |
| SystemManager.UP_FX_SaveReqAuthRequestMyList | MATCH | 1 | SP UP_FX_SaveReqAuthRequestMyList | EXEC:UP_FX_SAVEREQAUTHREQUESTMYLIST, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SCM_MST_AUTH_REQUEST, EXEC:UP_FX_SAVEUSERINFO, SELECT:TB_FX_USERLOCKLIST, UPDATE:TB_FX_USERLOCKLIST, EXEC:SCM_AUTH_REQ_MAIL_SEND, INSERT:SCM_SYS_LOG_BATCH, SELECT:TB_FX_USER, MERGE:TB_FX_USER, SELECT:SCM_MST_SSO_USER_INFO, EXEC:UP_FX_SAVEUSERGROUPINFO, UPDATE:TB_FX_USER, INSERT:#TBLSCMAUTHREQMAILSEND, SELECT:SCM_MST_AUTH_REQUEST, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_ADM_RECIPIENT_LIST, SELECT:SCM_ADM_RECIPIENT_MESSAGE, SELECT:SCM_ADM_RECIPIENT_ASSIGN, SELECT:#TBLSCMAUTHREQMAILSEND, EXEC:SCM_ADM_MAIL_SEND, MERGE:TB_FX_USERGROUPINFO, EXEC:SP_SEND_DBMAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| AddMyAuthList | SP_DataSource.Tables[0].Rows[_p] | NEW_USER_ID, DIVISION_ID, NEW_USER_NAME, NEW_USER_DEPARTMENT, MENU_AUTHORITY_ID |
| AddMyAuthList | s | user_id, group_id, approval_result, division_id |
| AddMyAuthList | _dtUserInfo.Rows[i] | UserID, Language, TimeZone, UserName_E, Dept_ID, DefaultGroupID |
| DefineProperty | UserInfoContext.Current | NewUserID, USER_ID, NewUserName, NewUserNameE, NewDeptID, NewDeptNameK, NewDeptNameE, NewDeptNameC, NewUserExistYN |
| FilterData | x | MENU_AUTHORITY_ID |
| Find_Data | dsMainQuery.Tables[0].Columns | NEW_USER_ID |
| Find_Data | r | NEW_USER_ID |
| Find_Data_User | row | UserID, UserName, UserName_E, Dept_ID, Language, DefaultGroupID, TimeZone |
| Find_Data_User | response.DataSet.Tables[0].Rows[0] | UserID, UserName, UserName_E, Dept_ID, Language, DefaultGroupID, TimeZone |
| GetDivision | Filter | USER_ID |
| GetInsertedUserInfo | ds.Tables[0].Rows[0] | USERID, USERNAME, USERNAME_E, EMAIL, DEPT_ID, CELLPHONENUM, LANGUAGE, DEFAULTGROUPID, TIMEZONE, DEPT_NAME_KO, DEPT_NAME_EN, DEPT_NAME_CN |
| GetInsertedUserInfo | UserInfoContext.Current | NewUserExistYN |
| InitControls | Filter | SCREEN_EXCEPTION |
| Save_Approval | newrow | SEQ, NEW_USER_ID, NEW_USER_NAME, DIVISION_ID, PLANT_ID, FACTORY_ID, INSTANCE_ID, PLAN_GROUP_ID, MENU_AUTHORITY_ID, RELEASE_NOTIFIY_TYPE, DESCRIPTION, ORG_DIVISION_ID, ORG_PLANT_ID, ORG_FACTORY_ID, ORG_INSTANCE_ID, ORG_PLAN_GROUP_ID, USER_ID |
| Save_Data_Approval | result.Rows[0] | RESULT, EXCEPTION |
| Save_Data_Approval_Menu | result.Rows[0] | RESULT, EXCEPTION |
| SetChangeControl | Filter | DIVISION_ID, PLANT_ID, INSTANCE_ID, FACTORY_ID, PLAN_GROUP_ID |
| spdMain_CellClick | Application.OpenForms | FP01887_InstancePopup |
| SpdSub_TextTipFetch | dtCompany_ID.Rows[i] | CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | ClbPlanGroup_Click:416, ClbPlanGroup_Click:419, Find_Data_Approval:1036, Find_Data_Approval:1037, Find_Data_Approval:1038, Find_Data_Approval:1039, Find_Data_Approval:1040, ClbFactory_SelectedIndexChanged:2495 | CString.GetCheckedListValue | CODE |
| FP_PseudoBatch | Save_Data_Approval:1725, Save_Data_Approval_Menu:1763 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| GetInnerTable | SetChangeControl:2828, SetChangeControl:2837, SetChangeControl:2849, SetChangeControl:2861, GetDivision:2902 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnReject | Click | btnReject_Click | InitializeComponent:385 |
| this.drpPeriod | ValueChanged | drpPeriod_ValueChanged | InitializeComponent:438 |
| this.rdoGroup1 | SelectedIndexChanged | rdoGroup1_SelectedIndexChanged | InitializeComponent:448 |
| this.btnApproval | Click | btnApproval_Click | InitializeComponent:539 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:693 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1022 |
| this | Load | Form_Load | .ctor:144 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:394 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:395 |
| clbInstance | SelectedIndexChanged | ClbInstance_SelectedIndexChanged | InitEvent:397 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:398 |
| clbPlanGroup | SelectedIndexChanged | ClbPlanGroup_SelectedIndexChanged | InitEvent:400 |
| comboAuthority | SelectedIndexChanged | ComboAuthority_SelectedIndexChanged | InitEvent:403 |
| spdMain | TextTipFetch | SpdSub_TextTipFetch | InitEvent:404 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:406 |
| popSql | OnSql | RunSqlSource | btnSql_Click:707 |
| this | Load | Form_Load | .ctor:49 |
| this | Load | Form_Load | .ctor:58 |
| this.btnButtonList | UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected | Form_Load:72 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:159 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:212 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:213 |
| this | Load | Form_Load | .ctor:147 |

## 6. 컨트롤 (63개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 18 | lblApproval, layoutControlItem6, layoutControlItem13, lblSql, lblReject, layoutControlItem4, layoutControlItem8, layoutControlItem3, layoutControlItem2, layoutControlItem14, layoutControlItem9, layoutControlItem16, layoutControlItem1, layoutControlItem5, layoutControlItem7 … |
| UsrLayoutControl | 7 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 7 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup3, layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList2 | 5 | clbInstance, clbDivision, clbPlant, clbPlanGroup, clbFactory |
| EmptySpaceItem | 5 | emptySpaceItem1, emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem1 |
| UsrMultiLineEditor | 4 | txtRequestName, txtRequestID, txtUserName, txtUserID |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| SimpleButton | 2 | btnReject, btnApproval |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| UsrCombo | 1 | comboAuthority |
| UsrDateRangePicker2 | 1 | drpPeriod |
| RadioGroup | 1 | rdoGroup1 |
| UsrButton | 1 | btnSql |
| ImageList | 1 | imageList1 |
| TextBox | 1 | txtReason |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1725 | Save_Data_Approval | FP\{?default:part_service}\FP01887_AUTHORITY_APPROVAL#insert_approval | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1763 | Save_Data_Approval_Menu | FP\{?default:part_service}\FP01887_AUTHORITY_APPROVAL#insert_approval_menu | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 40 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 4 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 7 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP01887 | AuthorityApproval | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 |
| SCM_MST_SHEET_COLUMNS | FP01887 | InstancePopup | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: AuthorityApproval, InstancePopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:514, SetSheetHeaderColumn_FP@SetSpreadInit:207

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 526 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK |  |
| InitSpread |  | 527 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK |  |
| InitSpread |  | 528 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK |  |
| SetHiddenColmn |  | 541 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SEQ |  |
| SetHiddenColmn |  | 542 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID |  |
| SetHiddenColmn |  | 543 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORG_PLANT_ID |  |
| SetHiddenColmn |  | 544 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORG_SHOP_GROUP_ID |  |
| SetHiddenColmn |  | 545 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORG_FACTORY_ID |  |
| SetHiddenColmn |  | 546 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORG_INSTANCE_ID |  |
| SetHiddenColmn |  | 547 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORG_PLAN_GROUP_ID |  |
| SetHiddenColmn |  | 548 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORG_SITE_ID |  |
| Find_Data | AuthorityApproval | 818 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| ReLoad_Data | AuthorityApproval | 941 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| SetSheetColorAndChkeck |  | 981 | 표시/라벨 변경 | set:Value | Value = {?true} | CHK | if(siMain.GetMaxRowIndex() > 0) |
| InitializeComponent |  | 1038 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1039 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1040 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1041 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit | 0 | 210 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.SHOP_GROUP_ID)} | SHOP_GROUP_ID |  |
| SetSpreadInit | 0 | 211 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.ROLE_NAME)} | ROLE_NAME |  |
| FindData | InstancePopup | 292 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 229 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 230 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 231 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 232 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| AuthorityApproval | META+코드연결 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |
| InstancePopup | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
