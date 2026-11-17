# AS-IS 실측 요약 — FP01886

- 실행: 2026-11-12 19:20:41.768 ~ 2026-11-12 19:21:14.082 · 계정 jaeuk.shin · 상태 OK
- 화면: FP Auth Request (GSCM.FP.Master.UIL.FP01886_Authority_Request)
- 조회 결과: Total : 292 · DB : 0.096s, UI : 0.12s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:20:42.144 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 6.81 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:20:42.147 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.02 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:20:42, END_TIME=2026-11-12 19:20:42, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192042_137, PA |
| 19:20:42.334 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.37 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01886 |
| 19:20:42.351 | load | GSCM.FP_Common | SELECT * | 351 | 10.7 | USER_ID= |
| 19:20:42.373 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.91 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:20:42.928 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 1 | 184.17 | p_code=FP01886_find_userInfo, p_user_id=jaeuk.shin, param1=jaeuk.shin, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:20:42.970 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 42.05 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_userInfo',@p_user_id=N'jaeuk.shin',@param1=N'jaeuk.shin',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@pa |
| 19:20:42.992 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 8 | 8.75 | p_code=FP01886_find_newAuth_div, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:20:43.028 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.78 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_div',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 19:20:43.056 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 29 | 10.97 | p_code=FP01886_find_newAuth_plant, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:20:43.083 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.1 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_plant',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'',@param |
| 19:20:43.138 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 4 | 12.62 | p_code=FP01886_find_newAuth_shop, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_GM01,VP_HD00,VP_MI02,VP_ST00,VT00,WA00,WA01, param3=, param4=, param5=, param |
| 19:20:43.180 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.7 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_shop',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'AZ00,GM00 |
| 19:20:43.259 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 85 | 61.09 | p_code=FP01886_find_newAuth_instance, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_GM01,VP_HD00,VP_MI02,VP_ST00,VT00,WA00,WA01, param3=A,E,F,P, param4=, par |
| 19:20:43.299 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 40.01 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_instance',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'AZ00, |
| 19:20:43.744 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 97 | 395.57 | p_code=FP01886_find_newAuth_factory, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_GM01,VP_HD00,VP_MI02,VP_ST00,VT00,WA00,WA01, param3=A,E,F,P, param4=CN_E_P |
| 19:20:43.748 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.74 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_factory',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'AZ00,G |
| 19:20:43.841 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 42 | 51.74 | p_code=FP01886_find_newAuth_plangroup, p_user_id=jaeuk.shin, param1=CN_E_POST,CN_E_POST_AB,CN_E_POST_M,KR_E_POST_A,KR_E_POST_M,PL_E_POST,US_E_POST,KR_E_PRE_A,KR_E_PRE_A2,KR_E_PRE_M,KR_E_PRE_M2,KR_E_PMIX,CN_E_PRE,CN_E_PRE_AB,CN_E_PRE_M,US_E_PRE,US_E_PRE_A2,UC_E_PRE_A,UC_E_PRE_A2,PL_E_PRE,ID_E_PRE_A,S |
| 19:20:43.845 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.11 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_plangroup',@p_user_id=N'jaeuk.shin',@param1=N'CN_E_POST,CN_E_POST_AB,CN_E_POST_M,KR_E_POST_A,KR_E_PO |
| 19:20:43.934 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP01886, p_sheet_name=Authority, p_user_id=jaeuk.shin |
| 19:20:43.959 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 20.82 | p_program_id=FP01886, p_sheet_name=Authority |
| 19:20:43.968 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.88 | p_program_id=FP01886, p_sheet_name=Authority, p_user_id=jaeuk.shin |
| 19:20:43.977 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 23 | 4.27 | p_program_id=FP01886, p_sheet_name=Authority |
| 19:20:43.998 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.22 | p_program_id=FP01886, p_sheet_name=AuthorityRequest, p_user_id=jaeuk.shin |
| 19:20:44.012 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 8.04 | p_program_id=FP01886, p_sheet_name=AuthorityRequest |
| 19:20:44.025 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.52 | p_program_id=FP01886, p_sheet_name=AuthorityRequest, p_user_id=jaeuk.shin |
| 19:20:44.043 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 22 | 4.9 | p_program_id=FP01886, p_sheet_name=AuthorityRequest |
| 19:20:44.081 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 28.93 | code=MENU_AUTHORITY_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 19:20:44.085 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.24 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:20:44, END_TIME=2026-11-12 19:20:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192044_052, PA |
| 19:20:44.104 | load | GSCM.FP_Common | UI_FP_COMMON | 4 | 6.81 | code=RELEASE_NOTIFIY_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, |
| 19:20:44.108 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.29 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:20:44, END_TIME=2026-11-12 19:20:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192044_096, PA |
| 19:20:44.149 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 23.75 | Code=Language, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:20:44.215 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 32.65 | Code=TimeZone, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:20:57.409 | load | GSCM.SystemMgmt.WSL | UP_FX_GetReqAuthMyListAdded | 71 | 13114.59 | p_UserID=jaeuk.shin |
| 19:20:57.911 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 250.18 | MenuID=FP Auth Request, CnntCode=0104001, UserID=jaeuk.shin |
| 19:20:57.959 | load | GSCM.BizService.WSL | UP_FX_GetReqAuthCurrentUser | 1 | 368.28 | p_UserID=jaeuk.shin |
| 19:20:58.427 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.34 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01886 |
| 19:20:58.682 | load | GSCM.FP_Common | PR_UI_FP01886_AUTHORITY_REQUEST | 292 | 252.28 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_alt_user_id=jaeuk.shin, p_alt_user_name=신재욱, p_company_id=, p_division_id=, p_site_id=, p_plant_id=, p_factory_id=, p_instance_id=, p_shop_group=, p_plan_group=, p_menu_authority_id=, p_request_id=, p_release_notifiy=,  |
| 19:20:58.727 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.72 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP01886_AUTHORITY_REQUEST @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_alt_user_id=N'jaeuk.shin' |
| 19:20:58.777 | load | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 7.97 | p_menu_id=FP01886, p_log_type=FIND, p_log_cnt=292, p_db_time=1.209, p_ui_time=0.013, p_user_id=jaeuk.shin |
| 19:20:58.802 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 8 | 4.37 | p_code=FP01886_find_newAuth_div, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:20:58.807 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.42 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_div',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 19:20:59.255 | load | GSCM.FP_Common | SELECT US.USER_ID, PD.COMPANY_ID, PD.PSEUDO_DIVISION_ID AS DIVISION_ID FROM TH_UIS_USER_DETAIL US (NOLOCK) | 0 | 433.95 | USER_ID=jaeuk.shin |
| 19:20:59.261 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.04 | PROG_ID=get_pseudo_division, QUERY_ID=FP\Admin\FP01886_Authority_Request, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT US.USER_ID, PD.COMPANY_ID, PD.PSEUDO_DIVISION_ID AS DIV |
| 19:20:59.287 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 29 | 5.75 | p_code=FP01886_find_newAuth_plant, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:20:59.313 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.66 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_plant',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'',@param |
| 19:20:59.367 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 4 | 8.03 | p_code=FP01886_find_newAuth_shop, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_GM01,VP_HD00,VP_MI02,VP_ST00,VT00,WA00,WA01, param3=, param4=, param5=, param |
| 19:20:59.407 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.59 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_shop',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'AZ00,GM00 |
| 19:20:59.434 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 85 | 7.55 | p_code=FP01886_find_newAuth_instance, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_GM01,VP_HD00,VP_MI02,VP_ST00,VT00,WA00,WA01, param3=A,E,F,P, param4=, par |
| 19:20:59.466 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.13 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_instance',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'AZ00, |
| 19:20:59.753 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 97 | 223.56 | p_code=FP01886_find_newAuth_factory, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_GM01,VP_HD00,VP_MI02,VP_ST00,VT00,WA00,WA01, param3=A,E,F,P, param4=CN_E_P |
| 19:20:59.758 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_factory',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'AZ00,G |
| 19:20:59.881 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 42 | 33.08 | p_code=FP01886_find_newAuth_plangroup, p_user_id=jaeuk.shin, param1=CN_E_POST,CN_E_POST_AB,CN_E_POST_M,KR_E_POST_A,KR_E_POST_M,PL_E_POST,US_E_POST,KR_E_PRE_A,KR_E_PRE_A2,KR_E_PRE_M,KR_E_PRE_M2,KR_E_PMIX,CN_E_PRE,CN_E_PRE_AB,CN_E_PRE_M,US_E_PRE,US_E_PRE_A2,UC_E_PRE_A,UC_E_PRE_A2,PL_E_PRE,ID_E_PRE_A,S |
| 19:20:59.886 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.48 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_plangroup',@p_user_id=N'jaeuk.shin',@param1=N'CN_E_POST,CN_E_POST_AB,CN_E_POST_M,KR_E_POST_A,KR_E_PO |
| 19:21:07.162 | find | GSCM.FP_Common | PR_UI_FP01886_AUTHORITY_REQUEST | 292 | 33.97 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_alt_user_id=jaeuk.shin, p_alt_user_name=신재욱, p_company_id=, p_division_id=, p_site_id=, p_plant_id=, p_factory_id=, p_instance_id=, p_shop_group=, p_plan_group=, p_menu_authority_id=, p_request_id=, p_release_notifiy=,  |
| 19:21:07.203 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.28 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP01886_AUTHORITY_REQUEST @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_alt_user_id=N'jaeuk.shin' |
| 19:21:07.344 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.22 | p_menu_id=FP01886, p_log_type=FIND, p_log_cnt=292, p_db_time=0.096, p_ui_time=0.12, p_user_id=jaeuk.shin |
| 19:21:07.373 | find | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 8 | 6.86 | p_code=FP01886_find_newAuth_div, p_user_id=jaeuk.shin, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:21:07.415 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.18 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_div',@p_user_id=N'jaeuk.shin',@param1=N'',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6=N' |
| 19:21:07.425 | find | GSCM.FP_Common | SELECT US.USER_ID, PD.COMPANY_ID, PD.PSEUDO_DIVISION_ID AS DIVISION_ID FROM TH_UIS_USER_DETAIL US (NOLOCK) | 0 | 2.9 | USER_ID=jaeuk.shin |
| 19:21:07.429 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.44 | PROG_ID=get_pseudo_division, QUERY_ID=FP\Admin\FP01886_Authority_Request, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT US.USER_ID, PD.COMPANY_ID, PD.PSEUDO_DIVISION_ID AS DIV |
| 19:21:07.452 | find | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 29 | 5.52 | p_code=FP01886_find_newAuth_plant, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:21:07.482 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.98 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_plant',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'',@param |
| 19:21:07.525 | find | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 4 | 6.55 | p_code=FP01886_find_newAuth_shop, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_GM01,VP_HD00,VP_MI02,VP_ST00,VT00,WA00,WA01, param3=, param4=, param5=, param |
| 19:21:07.560 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.06 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_shop',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'AZ00,GM00 |
| 19:21:07.589 | find | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 85 | 7.52 | p_code=FP01886_find_newAuth_instance, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_GM01,VP_HD00,VP_MI02,VP_ST00,VT00,WA00,WA01, param3=A,E,F,P, param4=, par |
| 19:21:07.628 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.46 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_instance',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'AZ00, |
| 19:21:07.934 | find | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 97 | 222.54 | p_code=FP01886_find_newAuth_factory, p_user_id=jaeuk.shin, param1=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, param2=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_GM01,VP_HD00,VP_MI02,VP_ST00,VT00,WA00,WA01, param3=A,E,F,P, param4=CN_E_P |
| 19:21:07.940 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.77 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_factory',@p_user_id=N'jaeuk.shin',@param1=N'40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82',@param2=N'AZ00,G |
| 19:21:08.042 | find | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 42 | 32.77 | p_code=FP01886_find_newAuth_plangroup, p_user_id=jaeuk.shin, param1=CN_E_POST,CN_E_POST_AB,CN_E_POST_M,KR_E_POST_A,KR_E_POST_M,PL_E_POST,US_E_POST,KR_E_PRE_A,KR_E_PRE_A2,KR_E_PRE_M,KR_E_PRE_M2,KR_E_PMIX,CN_E_PRE,CN_E_PRE_AB,CN_E_PRE_M,US_E_PRE,US_E_PRE_A2,UC_E_PRE_A,UC_E_PRE_A2,PL_E_PRE,ID_E_PRE_A,S |
| 19:21:08.047 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.29 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01886_find_newAuth_plangroup',@p_user_id=N'jaeuk.shin',@param1=N'CN_E_POST,CN_E_POST_AB,CN_E_POST_M,KR_E_POST_A,KR_E_PO |
| 19:21:13.375 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.37 | MenuID=FP Auth Request, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Save | btnRequest |  |
| layoutControlItem10 | usrLabel1 |  |
| layoutControlItem9 | usrLabel3 |  |
| Department | txtDepartment |  |
| User Name | txtUserName |  |
| lblUser | btnUser |  |
| User ID | txtUserID |  |
| Language* | cboLanguage_FP | Y |
| lblSql | btnSql |  |
| Time Zone* | cboTimeZone_FP | Y |
| Close | btnClose |  |
| layoutControlItem1 | clbDivision |  |
| layoutControlItem6 | clbPlant |  |
| layoutControlItem7 | clbShopGroup |  |
| layoutControlItem12 | clbInstance |  |
| layoutControlItem13 | clbFactory |  |
| layoutControlItem14 | clbPlanGroup |  |
| *Division | usrLabel2 |  |
| layoutControlItem16 | usrLabel5 |  |
| *Shop Group | usrLabel6 |  |
| layoutControlItem18 | usrLabel7 |  |
| layoutControlItem19 | usrLabel8 |  |
| layoutControlItem20 | usrLabel9 |  |
| layoutControlItem4 | usrLabel4 |  |
| lblAuth | cboAuth |  |
| Select | btnSelect |  |

## 그리드

- spdSub / AuthorityRequest: 행 0 · 컬럼 23(보임 14) · 헤더 1단 · 고정 컬럼 0
- spdMain / Authority: 행 292 · 컬럼 24(보임 12) · 헤더 1단 · 고정 컬럼 2

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
