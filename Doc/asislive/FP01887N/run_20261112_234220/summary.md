# AS-IS 실측 요약 — FP01887N

- 실행: 2026-11-12 23:42:20.426 ~ 2026-11-12 23:43:06.810 · 계정 jaeuk.shin · 상태 OK
- 화면: FP Auth Approval (GSCM.FP.Master.UIL.FP01887_Authority_Approval)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:42:20.934 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 31.7 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 23:42:20.938 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.04 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:42:20, END_TIME=2026-11-12 23:42:20, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234220_901, PA |
| 23:42:20.951 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 4.75 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:42:21.015 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01887 |
| 23:42:21.030 | load | GSCM.FP_Common | SELECT * | 351 | 10.26 | USER_ID= |
| 23:42:21.057 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.61 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 23:42:21.338 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 41 | 55.77 | p_code=FP01887_find_newAuth_plangroup, p_user_id=jaeuk.shin, param1=AZ_CELL_M,AZ_E_PRE_M,CN_CELL,CN_CELL_AB,CN_CELL_E,CN_CELL_EB,CN_CELL_M,CN_CELL_M2,CN_CELL_M4,CN_CELL_M5,CN_E_POST,CN_E_POST_AB,CN_E_POST_M,CN_E_PRE,CN_E_PRE_AB,CN_E_PRE_M,CN_FORM_A,CN_FORM_AB,CN_FORM_E,CN_FORM_EB,CN_FORM_M,CN_FORM_T |
| 23:42:21.344 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.51 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01887_find_newAuth_plangroup',@p_user_id=N'jaeuk.shin',@param1=N'AZ_CELL_M,AZ_E_PRE_M,CN_CELL,CN_CELL_AB,CN_CELL_E,CN_C |
| 23:42:21.376 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.81 | p_program_id=FP01887, p_sheet_name=AuthorityApproval, p_user_id=jaeuk.shin |
| 23:42:21.411 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 31.24 | p_program_id=FP01887, p_sheet_name=AuthorityApproval |
| 23:42:21.427 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.7 | p_program_id=FP01887, p_sheet_name=AuthorityApproval, p_user_id=jaeuk.shin |
| 23:42:21.435 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 5.84 | p_program_id=FP01887, p_sheet_name=AuthorityApproval |
| 23:42:21.450 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 9.44 | code=MENU_AUTHORITY_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 23:42:21.468 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.81 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:42:21, END_TIME=2026-11-12 23:42:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234221_44, PAR |
| 23:42:21.488 | load | GSCM.FP_Common | UI_FP_COMMON | 4 | 9.59 | code=RELEASE_NOTIFIY_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, |
| 23:42:21.493 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.62 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:42:21, END_TIME=2026-11-12 23:42:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234221_477, PA |
| 23:42:21.509 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 7.61 | code=APPROVAL_FLAG, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param2 |
| 23:42:21.513 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.79 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:42:21, END_TIME=2026-11-12 23:42:21, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234221_501, PA |
| 23:42:21.564 | load | GSCM.BizService.WSL | UP_FX_GetReqAuthCurrentUser | 1 | 30.13 | p_UserID=jaeuk.shin |
| 23:42:21.623 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 55.72 | MenuID=FP Auth Approval, CnntCode=0104001, UserID=jaeuk.shin |
| 23:42:21.742 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 5.71 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01887 |
| 23:42:33.627 | find | GSCM.FP_Common | PR_UI_FP01887_AUTHORITY_APPROVAL | 0 | 1582.43 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_seq=, p_new_user_id=, p_new_user_name=, p_division_id=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, p_plant_id=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_G |
| 23:42:33.643 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 16.01 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP01887_AUTHORITY_APPROVAL @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_seq=N'',@p_new_user_id= |
| 23:43:05.905 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.87 | MenuID=FP Auth Approval, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblApproval | btnApproval |  |
| Building | clbFactory |  |
| Plan Group | clbPlanGroup |  |
| lblSql | btnSql |  |
| lblReject | btnReject |  |
| User ID | txtUserID |  |
| User Name | txtUserName |  |
| Div | clbDivision |  |
| Plant | clbPlant |  |
| Request ID | txtRequestID |  |
| Request Name | txtRequestName |  |
| Status | rdoGroup1 |  |
| Request Start/End Date | drpPeriod |  |
| Instance | clbInstance |  |
| Authority | comboAuthority |  |

## 그리드

- spdMain / AuthorityApproval: 행 0 · 컬럼 32(보임 23) · 헤더 1단 · 고정 컬럼 13

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
