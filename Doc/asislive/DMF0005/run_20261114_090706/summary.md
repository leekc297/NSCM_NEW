# AS-IS 실측 요약 — DMF0005

- 실행: 2026-11-14 09:07:06.996 ~ 2026-11-14 09:08:10.898 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Site Project Model (GSCM.DM.Master.UIL.DMF0005_SaleSite_PjtModelMapping)
- 조회 결과:  · DB : 23.859s, UI : 0.164s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 09:07:27.463 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.16 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0005 |
| 09:07:27.504 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.49 | USER_ID= |
| 09:07:28.612 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 685.67 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 09:07:29.468 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.0 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.585 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 50 | 21.04 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0005, p_sheet_name=Production, p_division_id=40 |
| 09:07:29.669 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 77 | 60.29 | Code=TeambyDivision2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.680 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 37 | 3.58 | Code=CUST_GROUP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.696 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1920 | 11.62 | Code=EndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.743 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1350 | 13.04 | Code=ScmSitebyEndCustomer40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.758 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.46 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.789 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.21 | Code=PRODUCTION_PROCESS, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.789 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.24 | Code=CompanySalesSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.805 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 78 | 3.71 | Code=PlantByDivisionCompany, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.821 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 6.27 | Code=SoldToCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.839 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 7.37 | Code=EndCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.854 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.13 | Code=CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.870 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 2.9 | Code=APPLICATION, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.870 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 2.74 | Code=ROUTE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.885 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 2.87 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.900 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 2.85 | Code=incotermsEdit, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.916 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.04 | Code=DMF0005_REPORT_GROUP1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.932 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 4.03 | Code=DMF0005_REPORT_GROUP2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.945 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.49 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.948 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.66 | Code=DMF0005_REPORT_GROUP4, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.964 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.51 | Code=DMF0005_REPORT_GROUP5, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.971 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 4.12 | Code=DMF0005_REPORT_GROUP6, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:29.980 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 35 | 4.03 | Code=PROJECT_MODEL_MAPPING, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:30.016 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 19 | 13.94 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0005, p_sheet_name=Purchase, p_division_id=40 |
| 09:07:30.039 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.83 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:30.049 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.98 | Code=CompanySalesSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:30.062 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 78 | 3.79 | Code=PlantByDivisionCompany, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:30.088 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.66 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:30.108 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.0 | Code=Auth_Dept, Param1=jaeuk.shin, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:30.108 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.46 | Code=Auth_Dept, Param1=jaeuk.shin, Param2=ADMIN, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:30.174 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 4.78 | p_lookup_type=INVENTORY_DAYS_SETUP_SITE |
| 09:07:30.454 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 73.63 | MenuID=Sales Site Project Model, CnntCode=0104001, UserID=jaeuk.shin |
| 09:07:30.621 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0005 |
| 09:07:40.214 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 50 | 20.64 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0005, p_sheet_name=Production, p_division_id=40 |
| 09:07:40.289 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 77 | 74.52 | Code=TeambyDivision2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.307 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 37 | 3.38 | Code=CUST_GROUP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.321 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1920 | 12.43 | Code=EndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.358 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1350 | 12.62 | Code=ScmSitebyEndCustomer40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.367 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.52 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.383 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.51 | Code=PRODUCTION_PROCESS, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.398 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.43 | Code=CompanySalesSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.399 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 78 | 4.12 | Code=PlantByDivisionCompany, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.414 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 6.08 | Code=SoldToCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.430 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 6.91 | Code=EndCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.451 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.67 | Code=CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.460 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.75 | Code=APPLICATION, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.461 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.15 | Code=ROUTE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.478 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.4 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.478 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.29 | Code=incotermsEdit, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.503 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.59 | Code=DMF0005_REPORT_GROUP1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.510 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 3.33 | Code=DMF0005_REPORT_GROUP2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.520 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.21 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.526 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.48 | Code=DMF0005_REPORT_GROUP4, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.536 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.14 | Code=DMF0005_REPORT_GROUP5, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.545 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 3.65 | Code=DMF0005_REPORT_GROUP6, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.556 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 35 | 4.7 | Code=PROJECT_MODEL_MAPPING, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.582 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 19 | 12.52 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0005, p_sheet_name=Purchase, p_division_id=40 |
| 09:07:40.602 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.66 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.612 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 5.43 | Code=CompanySalesSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.625 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 78 | 6.46 | Code=PlantByDivisionCompany, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:07:40.638 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.49 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:08:03.296 | find | GSCM.DM.Master.WSL | DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | 15657 | 22602.93 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id=, p_valid_yn=ALL, p_created_by=jaeuk.shin, p_userinfo=ADMIN, p_owner=, p_user_dept_id=58183091, p_end_cust_report_yn=N, p_project_info_yn=N |
| 09:08:04.683 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.5 | p_menu_id=DMF0005, p_log_type=FIND, p_log_cnt=, p_db_time=23.859, p_ui_time=0.164, p_user_id=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Sales Site | clbSalesSite |  |
| layoutControlItem1 | chkDetail |  |
| Team | clbTeam |  |
| End Customer | clbEndCustomer |  |
| Project | txtProject |  |
| Model / Nickname | txtItemId |  |
| Active | cboActive |  |
| layoutControlItem2 | btnProject |  |
| layoutControlItem3 | btnItemId |  |
| Div | clbDivision |  |
| Owner | txtOwner |  |
| layoutControlItem4 | btnOwner |  |
| Model Code change | btnModelChange |  |
| layoutControlItem5 | chkEndCust |  |
| layoutControlItem6 | chkProjectInfo |  |

## 그리드

- spdMain / Production: 행 15657 · 컬럼 52(보임 44) · 헤더 2단 · 고정 컬럼 1
- spdSub / Purchase: 행 0 · 컬럼 20(보임 18) · 헤더 1단 · 고정 컬럼 0
