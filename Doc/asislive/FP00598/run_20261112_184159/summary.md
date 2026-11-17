# AS-IS 실측 요약 — FP00598

- 실행: 2026-11-12 18:41:59.155 ~ 2026-11-12 18:42:49.005 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Amend by Model(Elec) (GSCM.FP.Planning.UIL.FP00598_Plan_Amend_Model_Elec)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:41:59.559 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.49 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00598 |
| 18:41:59.574 | load | GSCM.FP_Common | SELECT * | 351 | 9.82 | USER_ID= |
| 18:41:59.581 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.69 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:41:59.739 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 14.04 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:41:59.742 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.22 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:41:59, END_TIME=2026-11-12 18:41:59, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184159_724, PA |
| 18:41:59.776 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 49 | 4.18 | USER_ID=jaeuk.shin, MENU_ID=FP00598_Amend |
| 18:41:59.861 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 84.51 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 18:41:59.875 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.44 | p_program_id=FP00598, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:41:59.921 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 36.81 | p_program_id=FP00598, p_sheet_name=Amend |
| 18:42:00.046 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 31.27 | LOGTYPE=SpeedUp, NOTE=FP00598
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 18:42:00.064 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.34 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:42:00.084 | load | GSCM.FP_Common | SELECT DISTINCT A.USER_ID AS CODE_ID, ISNULL(B.USER_NAME,'-') + ' (' + A.USER_ID + ')' AS CODE_NAME | 0 | 3.21 | USER_ID=jaeuk.shin, INSTANCE_ID=KR_E_PRE_A |
| 18:42:00.106 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.52 | PROG_ID=findPlanner_List, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client |
| 18:42:00.161 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 32.75 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP00602_FINDFPPLAN_INFO, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^, in_row=LINE_AMEND_E_PRE^2 |
| 18:42:00.239 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 77.4 | PROG_ID=PR_UI_FP00602_FINDFPPLAN_INFO, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP00602_FINDFPPLAN |
| 18:42:00.269 | load | GSCM.FP_Common | SELECT ISNULL(A.ATTRIBUTE14,2) AS ROUND_POINT | 1 | 10.39 | INSTANCE_ID=KR_E_PRE_A |
| 18:42:00.307 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.99 | PROG_ID=find_getRoundPoint, QUERY_ID=FP\Planning\FP00595_ROW, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Check client parameter : AMEND_INSTANCE
---Check client parameter : PLAN_DATE
---Check client parameter : AMEND_FLAG
---Check client parameter : ALL_LINE
---Check |
| 18:42:00.391 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 70.31 | LOGTYPE=SpeedUp, NOTE=FP00598
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 18:42:00.429 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.72 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:42:00.469 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 1 | 17.14 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, opt_none=, in_columns=AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^AMEND_MAIN_FLAG^USER_ID^INSTANCE_ID^MASTER_ID^USE_WOW_STATUS^CONFIRM_AREA^IS_SAME_PLAN_ID^PLANNER_YN^AMEND_TABLE^AMEND_ |
| 18:42:00.496 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.5 | PROG_ID=PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_PR_AMEND_ |
| 18:42:00.578 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.99 | p_program_id=FP00598, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:42:00.587 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 3.57 | p_program_id=FP00598, p_sheet_name=Amend |
| 18:42:00.595 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.88 | p_program_id=FP00598, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:42:00.605 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 5.31 | p_program_id=FP00598, p_sheet_name=Amend |
| 18:42:00.783 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 121.91 | MenuID=Plan Amend by Model(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 18:42:00.993 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00598 |
| 18:42:48.276 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.55 | MenuID=Plan Amend by Model(Elec), CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / Amend: 행 0 · 컬럼 31(보임 30) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:42:11.728 [] You need to select one plan to proceed → default_button(id=1)
