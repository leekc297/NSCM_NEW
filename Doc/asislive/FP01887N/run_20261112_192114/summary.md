# AS-IS 실측 요약 — FP01887N

- 실행: 2026-11-12 19:21:14.225 ~ 2026-11-12 19:22:03.017 · 계정 jaeuk.shin · 상태 OK
- 화면: FP Auth Approval (GSCM.FP.Master.UIL.FP01887_Authority_Approval)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:21:14.576 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 25.45 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:21:14.618 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 41.2 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:21:14, END_TIME=2026-11-12 19:21:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192114_55, PAR |
| 19:21:14.649 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.35 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:21:14.799 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.33 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01887 |
| 19:21:14.814 | load | GSCM.FP_Common | SELECT * | 351 | 9.55 | USER_ID= |
| 19:21:14.912 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 97.03 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:21:15.882 | load | GSCM.FP_Common | PR_UI_FP_MASTER_FORM_CODE | 41 | 355.57 | p_code=FP01887_find_newAuth_plangroup, p_user_id=jaeuk.shin, param1=AZ_CELL_M,AZ_E_PRE_M,CN_CELL,CN_CELL_AB,CN_CELL_E,CN_CELL_EB,CN_CELL_M,CN_CELL_M2,CN_CELL_M4,CN_CELL_M5,CN_E_POST,CN_E_POST_AB,CN_E_POST_M,CN_E_PRE,CN_E_PRE_AB,CN_E_PRE_M,CN_FORM_A,CN_FORM_AB,CN_FORM_E,CN_FORM_EB,CN_FORM_M,CN_FORM_T |
| 19:21:15.890 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.38 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP_MASTER_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP_MASTER_FORM_CODE @p_code=N'FP01887_find_newAuth_plangroup',@p_user_id=N'jaeuk.shin',@param1=N'AZ_CELL_M,AZ_E_PRE_M,CN_CELL,CN_CELL_AB,CN_CELL_E,CN_C |
| 19:21:15.975 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.98 | p_program_id=FP01887, p_sheet_name=AuthorityApproval, p_user_id=jaeuk.shin |
| 19:21:16.013 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 32.89 | p_program_id=FP01887, p_sheet_name=AuthorityApproval |
| 19:21:16.029 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.79 | p_program_id=FP01887, p_sheet_name=AuthorityApproval, p_user_id=jaeuk.shin |
| 19:21:16.040 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 4.62 | p_program_id=FP01887, p_sheet_name=AuthorityApproval |
| 19:21:16.058 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 8.83 | code=MENU_AUTHORITY_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=,  |
| 19:21:16.063 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.55 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:21:16, END_TIME=2026-11-12 19:21:16, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192116_049, PA |
| 19:21:16.107 | load | GSCM.FP_Common | UI_FP_COMMON | 4 | 33.77 | code=RELEASE_NOTIFIY_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, |
| 19:21:16.111 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.33 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:21:16, END_TIME=2026-11-12 19:21:16, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192116_073, PA |
| 19:21:16.129 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 7.74 | code=APPROVAL_FLAG, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param2 |
| 19:21:16.132 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.05 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:21:16, END_TIME=2026-11-12 19:21:16, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192116_121, PA |
| 19:21:16.171 | load | GSCM.BizService.WSL | UP_FX_GetReqAuthCurrentUser | 1 | 2.91 | p_UserID=jaeuk.shin |
| 19:21:16.305 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 64.8 | MenuID=FP Auth Approval, CnntCode=0104001, UserID=jaeuk.shin |
| 19:21:17.031 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.13 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01887 |
| 19:21:32.825 | find | GSCM.FP_Common | PR_UI_FP01887_AUTHORITY_APPROVAL | 0 | 1658.9 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_seq=, p_new_user_id=, p_new_user_name=, p_division_id=40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82, p_plant_id=AZ00,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI01,MI02,MI03,MI04,NA00,NB01,NB02,NJ01,NJ02,ST00,VP_G |
| 19:21:32.830 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.65 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP01887_AUTHORITY_APPROVAL @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_seq=N'',@p_new_user_id= |
| 19:22:02.141 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 13.24 | MenuID=FP Auth Approval, CnntCode=0104002, UserID=jaeuk.shin |

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
