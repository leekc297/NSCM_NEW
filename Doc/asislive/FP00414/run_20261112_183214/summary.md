# AS-IS 실측 요약 — FP00414

- 실행: 2026-11-12 18:32:14.251 ~ 2026-11-12 18:32:35.641 · 계정 jaeuk.shin · 상태 OK
- 화면: Formation Tray for Model (GSCM.FP.Master.UIL.FP00414_Formation_Tray_4Model)
- 조회 결과: Total : 561 · DB : 4.447s, UI : 0.362s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:32:14.685 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 147.48 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:32:14.688 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.91 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:32:14, END_TIME=2026-11-12 18:32:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183214_537, PA |
| 18:32:14.734 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.9 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00414 |
| 18:32:14.749 | load | GSCM.FP_Common | SELECT * | 351 | 9.31 | USER_ID= |
| 18:32:14.839 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 89.31 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:32:15.104 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 191.62 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 18:32:15.152 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.43 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:32:14, END_TIME=2026-11-12 18:32:15, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183214_912, PA |
| 18:32:16.040 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 831.68 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 18:32:16.339 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 299.05 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:32:15, END_TIME=2026-11-12 18:32:16, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183215_206, PA |
| 18:32:16.984 | load | GSCM.FP_Common | UI_FP_COMMON | 19 | 530.79 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, par |
| 18:32:16.988 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.54 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:32:16, END_TIME=2026-11-12 18:32:16, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183216_453, PA |
| 18:32:17.089 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.92 | p_program_id=FP00414, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:32:17.142 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 14 | 48.22 | p_program_id=FP00414, p_sheet_name=Main |
| 18:32:17.150 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.27 | p_program_id=FP00414, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:32:17.159 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 14 | 6.77 | p_program_id=FP00414, p_sheet_name=Main |
| 18:32:17.422 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 220.78 | MenuID=Formation Tray for Model, CnntCode=0104001, UserID=jaeuk.shin |
| 18:32:17.521 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 6.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00414 |
| 18:32:29.563 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 561 | 4327.77 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00414_FIND_FP00414, opt_none=, in_columns=DIVISION_ID^SITE_ID^PLANT_ID^, in_row=40,81,81_HD,81_HM,81_ST,81_UC,82^A001,A002,A003,A004,A007,A009^GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02 |
| 18:32:29.660 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 96.24 | PROG_ID=PR_UI_FP00414_FIND_FP00414, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00414_FIND_FP |
| 18:32:30.088 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 50.72 | p_menu_id=FP00414, p_log_type=FIND, p_log_cnt=561, p_db_time=4.447, p_ui_time=0.362, p_user_id=jaeuk.shin |
| 18:32:34.948 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.16 | MenuID=Formation Tray for Model, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| layoutControlItem5 | btnExcel |  |
| Div | clbDivision |  |
| Plant | clbPlant |  |
| Site | cboSite |  |
| FCS Model | txtFcsModelId |  |
| layoutControlItem9 | radioActiveN |  |
| layoutControlItem8 | radioActiveY |  |
| layoutControlItem7 | radioActiveAll |  |
| layoutControlItem10 | usrLabel1 |  |
| Material | txtItemId |  |
| Nick Name | txtNickName |  |

## 그리드

- spdMain / Main: 행 561 · 컬럼 15(보임 15) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
