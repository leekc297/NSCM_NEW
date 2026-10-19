# FP01886 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_Authority_Request.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_Authority_Request.UIL.csproj | 2006 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_Authority_Request.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_Authority_Request.UIL.csproj | 2082 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_AuthorityRequestPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_Authority_Request.UIL.csproj | 1550 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_AuthorityRequestPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_Authority_Request.UIL.csproj | 1986 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_UserFindPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_Authority_Request.UIL.csproj | 477 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_UserFindPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_Authority_Request.UIL.csproj | 415 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01886_Authority_Request.UIL\FP01886_Authority_Request.UIL.csproj | 37 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP01886_Authority_Request.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1579 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP01886_Authority_Request.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1928 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP01886_AuthorityRequestPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1551 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP01886_AuthorityRequestPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1986 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP01886_UserFindPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 477 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP01886_UserFindPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 415 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 1316 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 1751 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged | 1432 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged | 1868 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbInstance.SelectedIndexChanged | ClbInstance_SelectedIndexChanged | 1406 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbInstance.SelectedIndexChanged | ClbInstance_SelectedIndexChanged | 1842 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 1344 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 1779 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbShopGroup.SelectedIndexChanged | ClbShopGroup_SelectedIndexChanged > ApplyPseudoInstance | 1092 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_company_instance] | BIZ_MATCH |  |
| event:clbShopGroup.SelectedIndexChanged | ClbShopGroup_SelectedIndexChanged > ApplyPseudoInstance | 1092 | FP\Admin\FP01886_Authority_Request#get_company_instance | MATCH | [sql] foxquery_sql\FP_Admin_FP01886_Authority_Request_get_company_instance.sql |
| event:clbShopGroup.SelectedIndexChanged | ClbShopGroup_SelectedIndexChanged | 1375 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbShopGroup.SelectedIndexChanged | ClbShopGroup_SelectedIndexChanged | 1810 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Main > SetChangedControl | 527 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Main > SetChangedControl | 533 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Main > SetChangedControl | 539 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Main > SetChangedControl | 546 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Main > SetChangedControl | 553 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Main > Find_Data_Main | 772 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| button:FindButton | FindButton > Find_Main | 1046 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:FindButton | FindButton > Find_Main | 1051 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_pseudo_division] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Main | 1051 | FP\Admin\FP01886_Authority_Request#get_pseudo_division | MATCH | [sql] foxquery_sql\FP_Admin_FP01886_Authority_Request_get_pseudo_division.sql |
| button:FindButton | FindButton > Find_Main > SetChangedControl > ApplyPseudoInstance | 1092 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_company_instance] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Main > SetChangedControl > ApplyPseudoInstance | 1092 | FP\Admin\FP01886_Authority_Request#get_company_instance | MATCH | [sql] foxquery_sql\FP_Admin_FP01886_Authority_Request_get_company_instance.sql |
| button:FindButton | FindButton > Find_Main > Find_Data_Main | 1174 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |
| event:popSql.OnSql | RunSqlSource > Find_Data_Main | 772 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| event:popSql.OnSql | RunSqlSource > Find_Data_Request | 1045 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| event:popSql.OnSql | RunSqlSource > Find_Data_Main | 1174 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |
| event:popSql.OnSql | RunSqlSource > Save_Data_Request | 1208 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Save_Data_Request | 1251 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| event:popSql.OnSql | RunSqlSource > Find_Data_Request | 1481 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |
| event:popSql.OnSql | RunSqlSource > Save_Data_Request | 1642 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Save_Data_Request | 1686 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |
| button:SaveButton | SaveButton > Save_Request > Find_Main > Find_Data_Main | 772 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| button:SaveButton | SaveButton > Save_Request > Save_Data_Request | 1208 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:SaveButton | SaveButton > Save_Request > Save_Data_Request | 1251 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| button:SaveButton | SaveButton > Save_Request > Find_Request > Find_Data_Request | 1481 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |
| button:SaveButton | SaveButton > Save_Request > Save_Data_Request | 1642 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:SaveButton | SaveButton > Save_Request > Save_Data_Request | 1686 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_User | 329 | FP_Master.PR_UI_FP01886_USER_POPUP | MATCH | SP PR_UI_FP01886_USER_POPUP |
| event:this.btnRequest.Click | btnRequest_Click | 609 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnRequest.Click | btnRequest_Click > Save_Request > Find_Main > Find_Data_Main | 772 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| event:this.btnRequest.Click | btnRequest_Click | 841 | biz:Authentication.SavePersonalSetting | BIZ_MATCH |  |
| event:this.btnRequest.Click | btnRequest_Click | 904 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnRequest.Click | btnRequest_Click > Save_Request > Save_Data_Request | 1208 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnRequest.Click | btnRequest_Click > Save_Request > Save_Data_Request | 1251 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| event:this.btnRequest.Click | btnRequest_Click > Save_Request > Find_Request > Find_Data_Request | 1481 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |
| event:this.btnRequest.Click | btnRequest_Click > Save_Request > Save_Data_Request | 1642 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnRequest.Click | btnRequest_Click > Save_Request > Save_Data_Request | 1686 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |
| event:this.btnSelect.Click | btnSelect_Click > Find_Request > Find_Data_Request | 1045 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| event:this.btnSelect.Click | btnSelect_Click > Find_Request > Find_Data_Request | 1481 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |
| event:this.btnUser.Click | btnUser_Click > Find_Main > SetChangedControl | 527 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnUser.Click | btnUser_Click > Find_Main > SetChangedControl | 533 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnUser.Click | btnUser_Click > Find_Main > SetChangedControl | 539 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnUser.Click | btnUser_Click > Find_Main > SetChangedControl | 546 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnUser.Click | btnUser_Click > Find_Main > SetChangedControl | 553 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnUser.Click | btnUser_Click > Find_Main > Find_Data_Main | 772 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| event:this.btnUser.Click | btnUser_Click > Find_Main | 1046 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnUser.Click | btnUser_Click > Find_Main | 1051 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_pseudo_division] | BIZ_MATCH |  |
| event:this.btnUser.Click | btnUser_Click > Find_Main | 1051 | FP\Admin\FP01886_Authority_Request#get_pseudo_division | MATCH | [sql] foxquery_sql\FP_Admin_FP01886_Authority_Request_get_pseudo_division.sql |
| event:this.btnUser.Click | btnUser_Click > Find_Main > SetChangedControl > ApplyPseudoInstance | 1092 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_company_instance] | BIZ_MATCH |  |
| event:this.btnUser.Click | btnUser_Click > Find_Main > SetChangedControl > ApplyPseudoInstance | 1092 | FP\Admin\FP01886_Authority_Request#get_company_instance | MATCH | [sql] foxquery_sql\FP_Admin_FP01886_Authority_Request_get_company_instance.sql |
| event:this.btnUser.Click | btnUser_Click > Find_Main > Find_Data_Main | 1174 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |
| event:this.Load | Form_Load | 156 | biz:CommonData.CommonDataList [code=Language] | BIZ_MATCH |  |
| event:this.Load | Form_Load | 159 | biz:CommonData.CommonDataList [code=TimeZone] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 207 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 226 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > GetInitUserInfo > GetInsertedUserInfo | 277 | SystemManager.UP_FX_GetReqAuthCurrentUser | MATCH | SP UP_FX_GetReqAuthCurrentUser |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 330 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 336 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 342 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 348 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 351 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 355 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 378 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > FindData_MyAddedAuthList | 490 | SystemManager.UP_FX_GetReqAuthMyListAdded | MATCH | SP UP_FX_GetReqAuthMyListAdded |
| event:this.Load | Form_Load > FindData_MyAddedAuthList | 493 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SystemManager.UP_FX_GetReqAuthMyListAdded")}#{?serviceUri} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Main > SetChangedControl | 527 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > Find_Main > SetChangedControl | 533 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > Find_Main > SetChangedControl | 539 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > Find_Main > SetChangedControl | 546 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > Find_Main > SetChangedControl | 553 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > Find_Main > Find_Data_Main | 772 | FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP |
| event:this.Load | Form_Load > Find_Main | 1046 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > Find_Main | 1051 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_pseudo_division] | BIZ_MATCH |  |
| event:this.Load | Form_Load > Find_Main | 1051 | FP\Admin\FP01886_Authority_Request#get_pseudo_division | MATCH | [sql] foxquery_sql\FP_Admin_FP01886_Authority_Request_get_pseudo_division.sql |
| event:this.Load | Form_Load > Find_Main > SetChangedControl > ApplyPseudoInstance | 1092 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_company_instance] | BIZ_MATCH |  |
| event:this.Load | Form_Load > Find_Main > SetChangedControl > ApplyPseudoInstance | 1092 | FP\Admin\FP01886_Authority_Request#get_company_instance | MATCH | [sql] foxquery_sql\FP_Admin_FP01886_Authority_Request_get_company_instance.sql |
| event:this.Load | Form_Load > Find_Main > Find_Data_Main | 1174 | FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | SP PR_UI_FP01886_AUTHORITY_REQUEST |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?new TheOne.ServiceModel.Data.FoxDataRequest("SystemManager.UP_FX_GetReqAuthMyListAdded")}#{?serviceUri} | UNRESOLVED | 1 |  |  |  |
| biz:Authentication.SavePersonalSetting | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=Language] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=TimeZone] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_company_instance] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_pseudo_division] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 29 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | MATCH | 3 | SP PR_UI_FP01886_AUTHORITY_REQUEST | EXEC:PR_UI_FP01886_AUTHORITY_REQUEST | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | MATCH | 3 | SP PR_UI_FP01886_AUTHORITYREQUESTPOPUP | EXEC:PR_UI_FP01886_AUTHORITYREQUESTPOPUP | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP01886_USER_POPUP | MATCH | 1 | SP PR_UI_FP01886_USER_POPUP | EXEC:PR_UI_FP01886_USER_POPUP | ⚠ DB에 SP 없음 |
| FP\Admin\FP01886_Authority_Request#get_company_instance | MATCH | 1 | [sql] foxquery_sql\FP_Admin_FP01886_Authority_Request_get_company_instance.sql | SELECT:TH_UIS_ROLE_INSTANCE_RELATE |  |
| FP\Admin\FP01886_Authority_Request#get_pseudo_division | MATCH | 1 | [sql] foxquery_sql\FP_Admin_FP01886_Authority_Request_get_pseudo_division.sql | SELECT:TH_UIS_USER_DETAIL, SELECT:SCM_PSEUDO_DIVISION_M |  |
| SystemManager.UP_FX_GetReqAuthCurrentUser | MATCH | 1 | SP UP_FX_GetReqAuthCurrentUser | EXEC:UP_FX_GETREQAUTHCURRENTUSER, SELECT:TB_FX_USER, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO |  |
| SystemManager.UP_FX_GetReqAuthMyListAdded | MATCH | 1 | SP UP_FX_GetReqAuthMyListAdded | EXEC:UP_FX_GETREQAUTHMYLISTADDED, SELECT:SCM_MST_AUTH_REQUEST, SELECT:TB_FX_GROUPINFO, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USER, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, SELECT:TB_FX_USERGROUPAUTHEXTENTION |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyPseudoDivision | divRow | CODE, MM |
| ApplyPseudoDivision | pRow | DIVISION_ID |
| ApplyPseudoInstance | row | COMPANY_ID |
| ApplyPseudoInstance | Filter | COMPANY_LT |
| ApplyPseudoInstance | divRow | CODE, MM |
| ApplyPseudoInstance | pRow | INSTANCE_ID |
| btnRequest_Click | UserInfoContext.Current | DefaultGroupID, NowGroupID, USER_ID |
| btnUser_Click | Application.OpenForms | FPC0002_OperationPopup |
| Find_Main | Filter | USER_ID |
| GetInitUserInfo | UserInfoContext.Current | NewUserID, USER_ID, NewUserName, NewUserNameE, NewDeptID, NewDeptNameK, NewDeptNameE, NewDeptNameC, NewUserExistYN |
| GetInsertedUserInfo | ds.Tables[0].Rows[0] | USERID, USERNAME, USERNAME_E, EMAIL, DEPT_ID, CELLPHONENUM, LANGUAGE, DEFAULTGROUPID, TIMEZONE, DEPT_NAME_KO, DEPT_NAME_EN, DEPT_NAME_CN |
| GetInsertedUserInfo | UserInfoContext.Current | NewUserExistYN |
| InitControls | dtUserInfo.Rows[0] | NEW_USER_ID, USER_NAME, DEPARTMENT |
| InitControls | UserInfoContext.Current | NewUserID, NewUserName, NewDeptName |
| SetUserinfo | dtMyAuthList.Rows[0] | Language, TimeZone |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:327, SetChangedControl:334, SetChangedControl:340, SetChangedControl:346, SetChangedControl:353, CheckValidationControl:828, CheckValidationControl:829, CheckValidationControl:830 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnClose | Click | btnClose_Click | InitializeComponent:292 |
| this.btnUser | Click | btnUser_Click | InitializeComponent:353 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:537 |
| this.layoutControlItem11 | Click | btnClose_Click | InitializeComponent:658 |
| this.btnRequest | Click | btnRequest_Click | InitializeComponent:826 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:904 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:905 |
| this.btnSelect | Click | btnSelect_Click | InitializeComponent:1132 |
| this | Load | Form_Load | .ctor:130 |
| this | Load | Form_Load | .ctor:142 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:165 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:166 |
| clbShopGroup | SelectedIndexChanged | ClbShopGroup_SelectedIndexChanged | InitEvent:167 |
| clbInstance | SelectedIndexChanged | ClbInstance_SelectedIndexChanged | InitEvent:168 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:169 |
| popSql | OnSql | RunSqlSource | btnSql_Click:643 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:301 |
| this.btnUser | Click | btnUser_Click | InitializeComponent:363 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:549 |
| this.layoutControlItem11 | Click | btnClose_Click | InitializeComponent:791 |
| this.btnRequest | Click | btnRequest_Click | InitializeComponent:964 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:1041 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:1042 |
| this.btnSelect | Click | btnSelect_Click | InitializeComponent:1230 |
| this | Load | Form_Load | .ctor:137 |
| this | Load | Form_Load | .ctor:146 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:252 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:253 |
| clbShopGroup | SelectedIndexChanged | ClbShopGroup_SelectedIndexChanged | InitEvent:254 |
| clbInstance | SelectedIndexChanged | ClbInstance_SelectedIndexChanged | InitEvent:255 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:256 |
| popSql | OnSql | RunSqlSource | btnSql_Click:939 |
| dsdmSub | Changed | DsdmSub_Changed | Find_Request:1313 |
| dsdmSub | Changed | DsdmSub_Changed | Find_Request:1314 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:239 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:320 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:321 |
| this | Load | Form_Load | .ctor:158 |

## 6. 컨트롤 (152개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 54 | lblSql, layoutControlItem9, layoutControlItem5, layoutControlItem8, lblUser, layoutControlItem11, layoutControlItem3, lblRequest, layoutControlItem10, layoutControlItem1, layoutControlItem6, layoutControlItem7, layoutControlItem12, layoutControlItem13, layoutControlItem14 … |
| UsrLabel | 19 | usrLabel3, usrLabel1, usrLabel10, usrLabel9, usrLabel8, usrLabel7, usrLabel6, usrLabel5, usrLabel2, usrLabel4, usrLabel3, usrLabel1, usrLabel9, usrLabel8, usrLabel7 … |
| UsrCheckedList2 | 12 | clbDivision, clbPlanGroup, clbFactory, clbInstance, clbShopGroup, clbPlant, clbDivision, clbPlanGroup, clbFactory, clbInstance, clbShopGroup, clbPlant |
| UsrButton | 10 | btnClose, btnUser, btnSql, btnRequest, btnSelect, btnClose, btnUser, btnSql, btnRequest, btnSelect |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl3, usrLayoutControl2, usrLayoutControl1, usrLayoutControl3, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| UsrTextBox | 8 | txtUserName, txtDepartment, txtUserID, txtUserName, txtDepartment, txtUserID, txtUserID, txtUserName |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup3, layoutControlGroup2, layoutControlGroup1, layoutControlGroup3, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 7 | emptySpaceItem7, emptySpaceItem2, emptySpaceItem3, emptySpaceItem1, emptySpaceItem7, emptySpaceItem3, emptySpaceItem1 |
| FpSpread | 5 | spdMain, spdSub, spdMain, spdSub, spdMain |
| SheetView | 5 | spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1 |
| Panel | 4 | BotomPanel, MiddlePanel, BotomPanel, MiddlePanel |
| UsrCombo | 4 | cboAuth, cboLanguage_FP, cboTimeZone_FP, cboAuth |
| UsrConditionPanel | 3 | TopPanel, TopPanel, usrConditionPanel1 |
| ImageList | 2 | imageList1, imageList1 |
| TableLayoutPanel | 2 | tableLayoutPanel1, tableLayoutPanel1 |
| UsrButtonList | 1 | btnButtonList |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 493 | FindData_MyAddedAuthList | {?new TheOne.ServiceModel.Data.FoxDataRequest("SystemManager.UP_FX_GetReqAuthMyListAdded")}#{?serviceUri} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 56 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 4 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 15 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 14 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP01886 | Authority | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_COLUMNS | FP01886 | AuthorityRequest | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | FP01886 | UserFindPopup | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Authority, AuthorityRequest, UserFindPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:389, SetSheetHeaderColumn_FP@InitSpread:417, SetSheetHeaderColumn_FP@InitSpread:587, SetSheetHeaderColumn_FP@InitSpread:618, SetSheetHeaderColumn_FP@SetSpreadInit:218

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 598 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 599 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 600 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLANT_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 601 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FACTORY_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 602 | 표시/라벨 변경 | set:Visible | Visible = {?false} | INSTANCE_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 603 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SHOP_GROUP_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 605 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MENU_AUTHORITY_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 606 | 표시/라벨 변경 | set:Visible | Visible = {?false} | APPROVAL_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 607 | 표시/라벨 변경 | set:Visible | Visible = {?false} | APPROVAL_TIME | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 608 | 표시/라벨 변경 | set:Visible | Visible = {?false} | RELEASE_APPLY_FLAG | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 609 | 표시/라벨 변경 | set:Visible | Visible = {?false} | REQUEST_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 610 | 표시/라벨 변경 | set:Visible | Visible = {?false} | REQUEST_TIME | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 626 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 627 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 628 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLANT_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 629 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FACTORY_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 630 | 표시/라벨 변경 | set:Visible | Visible = {?false} | INSTANCE_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 631 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SHOP_GROUP_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 633 | 표시/라벨 변경 | set:Visible | Visible = {?false} | REQUEST_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 634 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORG_MENU_AUTHORITY_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 642 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 643 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 644 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| Find_Main | Authority | 1043 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| Find_Request | AuthorityRequest | 1376 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 218 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 219 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 220 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 221 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1058 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1059 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1060 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1061 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1096 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = 1 |  |  |
| InitSpread |  | 397 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 398 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 399 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLANT_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 400 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FACTORY_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 401 | 표시/라벨 변경 | set:Visible | Visible = {?false} | INSTANCE_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 402 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SHOP_GROUP_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 403 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_GROUP_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 404 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MENU_AUTHORITY_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 405 | 표시/라벨 변경 | set:Visible | Visible = {?false} | APPROVAL_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 406 | 표시/라벨 변경 | set:Visible | Visible = {?false} | APPROVAL_TIME | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 407 | 표시/라벨 변경 | set:Visible | Visible = {?false} | RELEASE_APPLY_FLAG | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 408 | 표시/라벨 변경 | set:Visible | Visible = {?false} | REQUEST_ID | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 409 | 표시/라벨 변경 | set:Visible | Visible = {?false} | REQUEST_TIME | if(spreadInfo.SheetName == "Authority") |
| InitSpread |  | 422 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 423 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 424 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLANT_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 425 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FACTORY_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 426 | 표시/라벨 변경 | set:Visible | Visible = {?false} | INSTANCE_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 427 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SHOP_GROUP_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 428 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_GROUP_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 429 | 표시/라벨 변경 | set:Visible | Visible = {?false} | REQUEST_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 430 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORG_MENU_AUTHORITY_ID | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 438 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 439 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| InitSpread |  | 440 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | else!(spreadInfo.SheetName == "Authority") ⟫ if(spreadInfo.SheetName == "AuthorityRequest") |
| Find_Main | Authority | 750 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| Find_Request | AuthorityRequest | 965 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 209 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 210 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 211 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 212 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 921 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 922 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 923 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 924 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 960 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = 1 |  |  |
| SetSpreadInit | 0 | 221 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.COMPANY)} | COMPANY |  |
| SetSpreadInit | 0 | 222 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.DIVISION)} | DIVISION |  |
| SetSpreadInit | 0 | 223 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.CORPORATION)} | CORPORATION |  |
| SetSpreadInit | 0 | 224 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.DEPARTMENT)} | DEPARTMENT |  |
| SetSpreadInit | 0 | 225 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.USER_GRAD_CODE)} | USER_GRAD_CODE |  |
| SetSpreadInit | 0 | 226 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.IP_ADRESS)} | IP_ADRESS |  |
| SetSpreadInit | 0 | 227 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.PASS_CODE)} | PASS_CODE |  |
| FindData | UserFindPopup | 307 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 337 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 338 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 339 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 340 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| Authority | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| AuthorityRequest | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |
| UserFindPopup | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
