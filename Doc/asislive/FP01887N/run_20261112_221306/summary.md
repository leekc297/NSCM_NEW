# AS-IS 실측 요약 — FP01887N

- 실행: 2026-11-12 22:13:06.408 ~ 2026-11-12 22:13:54.511 · 계정 jaeuk.shin · 상태 OK
- 화면: FP Auth Approval (GSCM.FP.Master.UIL.FP01887_Authority_Approval)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:13:06.813 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 32.19 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:13:06.816 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.53 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:13:06, END_TIME=2026-11-12 22:13:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221306_78, PAR |
| 22:13:06.832 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 6.15 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:13:07.048 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.37 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01887 |
| 22:13:07.063 | load | GSCM.FP_Common | SELECT * | 351 | 10.07 | USER_ID= |
| 22:13:07.067 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.58 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:13:07.622 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 41 | 103.84 | p_code=FP01887_find_newAuth_plangroup, p_user_id=jaeuk.shin, param1=AZ_CELL_M,AZ_E_PRE_M,CN_CELL,CN_CELL_AB,CN_CELL_E,CN_CELL_EB,CN_CELL_M,CN_CELL_M2,CN_CELL_M4,CN_CELL_M5,CN_E_POST,CN_E_POST_AB,CN_E_POST_M,CN_E_PRE,CN_E_PRE_AB,CN_E_PRE_M,CN_FORM_A,CN_FORM_AB,CN_FORM_E,CN_FORM_EB,CN_FORM_M,CN_FORM_T |
| 22:13:07.627 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.18 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01887_find_newAuth_plangroup',@p_user_id=N'jaeuk.shin',@param1=N'AZ_CELL_M,AZ_E_PRE_M,CN_CELL,CN_CELL_AB,CN_CELL_E,CN_C |
| 22:13:07.696 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.19 | p_program_id=FP01887, p_sheet_name=AuthorityApproval, p_user_id=jaeuk.shin |
| 22:13:07.706 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 4.81 | p_program_id=FP01887, p_sheet_name=AuthorityApproval |
| 22:13:07.724 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.98 | p_program_id=FP01887, p_sheet_name=AuthorityApproval, p_user_id=jaeuk.shin |
| 22:13:07.733 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 4.81 | p_program_id=FP01887, p_sheet_name=AuthorityApproval |
| 22:13:07.753 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 7.6 | code=MENU_AUTHORITY_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 22:13:07.775 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.26 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:13:07, END_TIME=2026-11-12 22:13:07, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221307_745, PA |
| 22:13:07.794 | load | GSCM.FP_Common | UI_FP_COMMON | 4 | 6.98 | code=RELEASE_NOTIFIY_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, |
| 22:13:07.798 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.87 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:13:07, END_TIME=2026-11-12 22:13:07, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221307_786, PA |
| 22:13:07.815 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 6.8 | code=APPROVAL_FLAG, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param2 |
| 22:13:07.818 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.13 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:13:07, END_TIME=2026-11-12 22:13:07, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221307_807, PA |
| 22:13:08.092 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 197.19 | MenuID=FP Auth Approval, CnntCode=0104001, UserID=jaeuk.shin |
| 22:13:08.174 | load | GSCM.BizService.WSL | UP_FX_GetReqAuthCurrentUser | 1 | 301.42 | p_UserID=jaeuk.shin |
| 22:13:08.298 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.66 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01887 |
| 22:13:22.162 | find | GSCM.FP_Common | PR_UI_FP01887_AUTHORITY_APPROVAL | 0 | 1988.91 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_seq=, p_new_user_id=, p_new_user_name=, p_division_id=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, p_plant_id=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_G |
| 22:13:22.167 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.25 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP01887_AUTHORITY_APPROVAL @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_seq=N'',@p_new_user_id= |
| 22:13:53.769 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 9.28 | MenuID=FP Auth Approval, CnntCode=0104002, UserID=jaeuk.shin |

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
