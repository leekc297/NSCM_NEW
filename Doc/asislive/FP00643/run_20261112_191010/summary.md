# AS-IS 실측 요약 — FP00643

- 실행: 2026-11-12 19:10:10.929 ~ 2026-11-12 19:11:05.514 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line, PSI(Elec) (GSCM.FP.Planning.UIL.FP00643_Plan_Amend_Line_PSI_Elec)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:10:12.345 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00643 |
| 19:10:12.377 | load | GSCM.FP_Common | SELECT * | 351 | 9.74 | USER_ID= |
| 19:10:12.381 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.9 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:10:12.942 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 9.18 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:10:12.945 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.18 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:10:12, END_TIME=2026-11-12 19:10:12, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191012_932, PA |
| 19:10:13.024 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 37 | 4.09 | USER_ID=jaeuk.shin, MENU_ID=FP00643_Amend |
| 19:10:13.048 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.77 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 19:10:13.060 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.92 | p_program_id=FP00643, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:10:13.118 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 43 | 51.89 | p_program_id=FP00643, p_sheet_name=Amend |
| 19:10:13.702 | load | GSCM.FP_Common | UI_FP_COMMON | 13 | 368.75 | code=AMEND_INSTANCE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=LINE_AMEND_E_PRE, param22=, param23=, |
| 19:10:13.746 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 43.84 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:10:13, END_TIME=2026-11-12 19:10:13, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191013_332, PA |
| 19:10:13.885 | load | GSCM.FP_Common | SELECT DISTINCT A.USER_ID AS CODE_ID, ISNULL(B.USER_NAME,'-') + ' (' + A.USER_ID + ')' AS CODE_NAME | 0 | 5.87 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 19:10:13.907 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.21 | PROG_ID=findPlanner_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client |
| 19:10:13.944 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 7.16 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^UOM_TYPE^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^, in_row=LINE_AMEN |
| 19:10:13.971 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.08 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 19:10:13.994 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 6.51 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^UOM_TYPE^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^AMEND_TAB |
| 19:10:14.027 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.68 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_ |
| 19:10:14.043 | load | GSCM.FP_Common | SELECT ISNULL(A.ATTRIBUTE14,2) AS ROUND_POINT | 1 | 5.97 | INSTANCE_ID=KR_E_PRE_A |
| 19:10:14.047 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.13 | PROG_ID=find_getRoundPoint, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check |
| 19:10:14.161 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 104.82 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:10:14.164 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.43 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:10:14, END_TIME=2026-11-12 19:10:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191014_056, PA |
| 19:10:14.451 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 272.24 | code=PLANT, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, pa |
| 19:10:14.454 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.99 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:10:14, END_TIME=2026-11-12 19:10:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191014_179, PA |
| 19:10:14.718 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 237.92 | code=FACTORY_CODE_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=HQ07, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=BUILDIN |
| 19:10:14.741 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.79 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:10:14, END_TIME=2026-11-12 19:10:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191014_48, PAR |
| 19:10:15.011 | load | GSCM.FP_Common | SELECT A.LINE_ID AS CODE | 10 | 240.81 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 19:10:15.016 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.42 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-12 19:10:14, END_TIME=2026-11-12 19:10:15, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191014_77, PARAM_VALUE={AMEND_INSTANCE  |
| 19:10:15.037 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.88 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Service Parameter : 2CTRL_COMPANY_LT
---Service Parameter : 3CTRL_LINE_LT
---Service Parameter : 4CTRL_DIVISION_LT
---Service Param |
| 19:10:15.043 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=findLineCode_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=ND		A.ACTIVE_FLAG = 'Y'
          ) C
          WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID
      )
   |
| 19:10:15.168 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 111.01 | code=SITE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_E_PRE_A, param2=, param3=, param4=, param5=81, param6=, param7=, param8=, param9=HQ07, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, |
| 19:10:15.179 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.73 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:10:15, END_TIME=2026-11-12 19:10:15, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191015_057, PA |
| 19:10:15.258 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 11 | 60.86 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00599_FIND_FPPRODTYPE, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^UOM_TYPE^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^AMEND_TABLE^AMEND_ |
| 19:10:15.262 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.33 | PROG_ID=PR_UI_FP00599_FIND_FPPRODTYPE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00599_FIND_FPPRO |
| 19:10:15.301 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.24 | p_program_id=FP00643, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:10:15.312 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 43 | 5.17 | p_program_id=FP00643, p_sheet_name=Amend |
| 19:10:15.338 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.37 | p_program_id=FP00643, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:10:15.347 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 43 | 4.63 | p_program_id=FP00643, p_sheet_name=Amend |
| 19:10:15.717 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 71.36 | MenuID=Plan Amend by Line, PSI(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 19:10:16.090 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.32 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00643 |
| 19:11:04.686 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.96 | MenuID=Plan Amend by Line, PSI(Elec), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Planner | mcbo_planner |  |
| FP Plan Id | cbo_fpplanid |  |
| lblSql | btnSql |  |
| layoutControlItem2 | btnExcelImport |  |
| Plan Group | cbo_plan_group |  |
| Plan Date | sCalendar_planday |  |
| Data | btnToggleSave |  |
| Division. | mcbo_division |  |
| Site | mcbo_site |  |
| Operation | mcbo_operation |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| layoutControlItem13 | chk_Info |  |
| Plan Period | dCalendar_planrange |  |
| Material | edt_item |  |
| layoutControlItem3 | usrCheckBox1 |  |
| Line | mcbo_line |  |
| layoutControlItem12 | chk_all_line |  |
| Nick Name | tbNickName |  |
| Prod.Type | mcbo_prodtype |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 44(보임 43) · 헤더 2단 · 고정 컬럼 0
- spdSimul / Simul: 행 0 · 컬럼 0(보임 0) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:10:27.035 [] You need to select one plan to proceed → default_button(id=1)
