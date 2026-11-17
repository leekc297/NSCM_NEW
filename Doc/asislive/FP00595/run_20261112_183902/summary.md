# AS-IS 실측 요약 — FP00595

- 실행: 2026-11-12 18:39:02.921 ~ 2026-11-12 18:39:56.567 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Line(Elec) (GSCM.FP.Planning.UIL.FP00595_Plan_Amend_Line_Elec)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:39:03.368 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.13 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00595 |
| 18:39:03.387 | load | GSCM.FP_Common | SELECT * | 351 | 11.84 | USER_ID= |
| 18:39:03.467 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 79.63 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:39:03.754 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 18.29 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:39:03.838 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 83.3 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:39:03, END_TIME=2026-11-12 18:39:03, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112183903_735, PA |
| 18:39:04.057 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 37 | 122.0 | USER_ID=jaeuk.shin, MENU_ID=FP00595_Amend |
| 18:39:04.258 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 200.14 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:39:04.266 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.33 | p_program_id=FP00595, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:39:04.323 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 52.23 | p_program_id=FP00595, p_sheet_name=Amend |
| 18:39:05.354 | load | GSCM.FP_Common | SELECT DISTINCT A.USER_ID AS CODE_ID, ISNULL(B.USER_NAME,'-') + ' (' + A.USER_ID + ')' AS CODE_NAME | 0 | 859.45 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 18:39:05.417 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 63.21 | PROG_ID=findPlanner_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client |
| 18:39:05.443 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 10.55 | LOGTYPE=SpeedUp, NOTE=FP00595
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 18:39:05.596 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 152.65 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:39:06.896 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 1284.35 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^, in_row=LINE_AMEND_E_PRE^20261112^Y^Y |
| 18:39:06.960 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 63.15 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 18:39:06.972 | load | GSCM.FP_Common | SELECT DISTINCT A.USER_ID AS CODE_ID, ISNULL(B.USER_NAME,'-') + ' (' + A.USER_ID + ')' AS CODE_NAME | 0 | 3.86 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 18:39:07.078 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 106.6 | PROG_ID=findPlanner_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client |
| 18:39:07.168 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 79.45 | LOGTYPE=SpeedUp, NOTE=FP00595
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 18:39:07.269 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 99.71 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:39:07.342 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 31.24 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^BUCKET_FROM^BUCKET |
| 18:39:07.514 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 171.49 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_ |
| 18:39:07.529 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.14 | p_program_id=FP00595, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:39:07.541 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 6.85 | p_program_id=FP00595, p_sheet_name=Amend |
| 18:39:07.549 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00595, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:39:07.559 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 28 | 4.26 | p_program_id=FP00595, p_sheet_name=Amend |
| 18:39:08.066 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 446.92 | MenuID=Plan Amend by Line(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 18:39:08.276 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.97 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00595 |
| 18:39:15.104 | load | GSCM.FP_Common | PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL | 199410 | 656041.72 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_lt=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_lt=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_model=, p_nick_name= |
| 18:39:15.164 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 60.17 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_lt=N'40,81, |
| 18:39:55.704 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.6 | MenuID=Plan Amend by Line(Elec), CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Amend: 행 0 · 컬럼 29(보임 28) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:39:17.535 [] You need to select one plan to proceed → default_button(id=1)
