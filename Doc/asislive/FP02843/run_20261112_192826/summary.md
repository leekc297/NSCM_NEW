# AS-IS 실측 요약 — FP02843

- 실행: 2026-11-12 19:28:26.576 ~ 2026-11-12 19:28:55.731 · 계정 jaeuk.shin · 상태 OK
- 화면: Electrode WH CAPA (GSCM.FP.Planning.UIL.FP02843_UI_WH_CAPA)
- 조회 결과:  · DB : 11.431s, UI : 0.314s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:28:26.915 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 34.49 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:28:26.929 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.18 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:26, END_TIME=2026-11-12 19:28:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192826_88, PAR |
| 19:28:27.062 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02843 |
| 19:28:27.078 | load | GSCM.FP_Common | SELECT * | 351 | 9.06 | USER_ID= |
| 19:28:27.096 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.52 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:28:27.302 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 26.63 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:28:27.307 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.01 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:27, END_TIME=2026-11-12 19:28:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192827_275, PA |
| 19:28:27.361 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 34 | 5.0 | USER_ID=jaeuk.shin, MENU_ID=FP00606_Amend |
| 19:28:27.501 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 139.45 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:28:27.511 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.31 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:28:27.584 | load | GSCM.SCM.Master.WSL | SELECT U.PROGRAM_ID | 23 | 67.6 | p_program_id=FP00606, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:28:27.656 | load | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 18 | 36.5 | p_code=WH_LOOK_UP, p_user_id=jaeuk.shin, param1=E_POST_WH_CAPA_DEFINIT, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 19:28:27.700 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.32 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'WH_LOOK_UP',@p_user_id=N'jaeuk.shin',@param1=N'E_POST_WH_CAPA_DEFINIT',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@p |
| 19:28:27.894 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 174.35 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:28:27.897 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.75 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:27, END_TIME=2026-11-12 19:28:27, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192827_719, PA |
| 19:28:28.104 | load | GSCM.FP_Common | UI_FP_COMMON | 6 | 172.29 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 19:28:28.151 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 47.4 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:27, END_TIME=2026-11-12 19:28:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192827_931, PA |
| 19:28:28.382 | load | GSCM.FP_Common | UI_FP_COMMON | 19 | 148.71 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, par |
| 19:28:28.386 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.93 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:28, END_TIME=2026-11-12 19:28:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192828_233, PA |
| 19:28:28.556 | load | GSCM.FP_Common | UI_FP_COMMON | 78 | 141.11 | code=FACTORY, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=40,81,81_HD,81_HM,81_ST,81_UC,82, param6=, param7=A001,A002,A003,A004,A007,A009, param8=, param9=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, param10 |
| 19:28:28.561 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.65 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:28, END_TIME=2026-11-12 19:28:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192828_415, PA |
| 19:28:28.615 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 18.47 | code=ATTR_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=,  |
| 19:28:28.618 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.77 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:28, END_TIME=2026-11-12 19:28:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192828_595, PA |
| 19:28:28.653 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.99 | p_program_id=FP02843, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:28:28.701 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 12 | 42.45 | p_program_id=FP02843, p_sheet_name=Amend |
| 19:28:28.709 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.89 | p_program_id=FP02843, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:28:28.716 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 12 | 3.62 | p_program_id=FP02843, p_sheet_name=Amend |
| 19:28:28.733 | load | GSCM.FP_Common | UI_FP_COMMON | 3 | 6.91 | code=ATTR_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=,  |
| 19:28:28.736 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.05 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:28:28, END_TIME=2026-11-12 19:28:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192828_726, PA |
| 19:28:28.994 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 179.4 | MenuID=Electrode WH CAPA, CnntCode=0104001, UserID=jaeuk.shin |
| 19:28:29.079 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.71 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02843 |
| 19:28:49.161 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND | 189 | 11382.13 | p_sys_type=SELECT, p_sys_flag=SELECT_MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP02843_WH_CAPA, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^LOOKUP^BUCKET_FROM^BUCKET_TO^DIVISION_ID^SITE_ID^PLANT_ID^, in_row=LINE_AMEND_E_PRE^20261112^Y^Y^mXlVW48SU1c3wP |
| 19:28:49.180 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.48 | PROG_ID=PR_UI_FP02843_WH_CAPA, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT_MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP02843_WH_ |
| 19:28:49.530 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.44 | p_menu_id=FP02843, p_log_type=FIND, p_log_cnt=, p_db_time=11.431, p_ui_time=0.314, p_user_id=jaeuk.shin |
| 19:28:54.770 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.65 | MenuID=Electrode WH CAPA, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | mcbo_division |  |
| Roll Type | mcbo_prod_type |  |
| Site | cbo_site |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Electrode type | mcbo_Electrode |  |
| Plan Period | dCalendar_planrange |  |

## 그리드

- spdMain / Amend: 행 189 · 컬럼 14(보임 12) · 헤더 2단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:28:50.152 [GSCM] 개체 참조가 개체의 인스턴스로 설정되지 않았습니다. → default_button(id=1)
