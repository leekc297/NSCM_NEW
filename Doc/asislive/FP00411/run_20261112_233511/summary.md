# AS-IS 실측 요약 — FP00411

- 실행: 2026-11-12 23:35:11.400 ~ 2026-11-12 23:36:45.231 · 계정 jaeuk.shin · 상태 OK
- 화면: FCS Shorter Aging Routing (GSCM.FP.Master.UIL.FP00411_FCS_Shorter_Aging_Routing)
- 조회 결과: Total : 1,646 · DB : 75.499s, UI : 0.91s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:35:11.749 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 28.19 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 23:35:11.755 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.11 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:35:11, END_TIME=2026-11-12 23:35:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112233511_72, PAR |
| 23:35:11.797 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.6 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00411 |
| 23:35:11.812 | load | GSCM.FP_Common | SELECT * | 351 | 10.9 | USER_ID= |
| 23:35:11.817 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.88 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 23:35:12.089 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.69 | p_program_id=FP00411, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 23:35:12.125 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 32.03 | p_program_id=FP00411, p_sheet_name=Main |
| 23:35:12.134 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.88 | p_program_id=FP00411, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 23:35:12.142 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 5.54 | p_program_id=FP00411, p_sheet_name=Main |
| 23:35:12.260 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 90.65 | MenuID=FCS Shorter Aging Routing, CnntCode=0104001, UserID=jaeuk.shin |
| 23:35:12.300 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.56 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00411 |
| 23:36:36.652 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1646 | 75323.46 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00411_FIND_FP00411, opt_none=, in_columns=USER_ID^SITE_ID^PLANT_ID^FACTORY_ID^LINE_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^A001,A002,A003,A004,A007,A009^GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB |
| 23:36:36.712 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 58.36 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 23:35:21, END_TIME=2026-11-12 23:36:36, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112233521_327, PARAM_VAL |
| 23:36:36.718 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.4 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=1, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 23:35:21, END_TIME=2026-11-12 23:36:36, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112233521_327, PARAM_VAL |
| 23:36:36.770 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 52.47 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00411_FIND_FP |
| 23:36:36.776 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.2 | PROG_ID=PR_UI_FP00411_FIND_FP00411, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=7CF6_4,FP_M7CF6_5,FP_M7CF6_6,FP_M7CF6_7,FP_S3E01L-1,FP_S3E01L-2,M1C09,M1CF2,M1CP1,M2C06,M2C07,M2C08,M2C09,M2C10,M2C11,M4J61,M4J62,M4J63,M4JA2,M4K45,M4K46,M4K50,M4K69,M4K79,M4K80,M4K81, |
| 23:36:37.738 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.47 | p_menu_id=FP00411, p_log_type=FIND, p_log_cnt=1646, p_db_time=75.499, p_ui_time=0.91, p_user_id=jaeuk.shin |
| 23:36:44.191 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 50.64 | MenuID=FCS Shorter Aging Routing, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant | clbPlant |  |
| Building | clbFactory |  |
| Div | clbDivision |  |
| Line | clbLine |  |
| Site | clbSite |  |
| Material | txtItemId |  |
| Nick Name | txtNickName |  |
| lblSql | btnSql |  |
| layoutControlItem5 | btnExcel |  |

## 그리드

- spdMain / Main: 행 1646 · 컬럼 20(보임 19) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
