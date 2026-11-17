# AS-IS 실측 요약 — FP00603

- 실행: 2026-11-12 18:47:10.259 ~ 2026-11-12 18:47:52.472 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan By Model(Assy) (GSCM.FP.Planning.UIL.FP00603_PlanByModel_Assy)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:47:10.679 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 10.91 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:47:10.683 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.99 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:47:10, END_TIME=2026-11-12 18:47:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184710_669, PA |
| 18:47:10.778 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00603 |
| 18:47:10.794 | load | GSCM.FP_Common | SELECT * | 351 | 9.82 | USER_ID= |
| 18:47:10.798 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.92 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:47:10.992 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.12 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:47:10.996 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.41 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:47:10, END_TIME=2026-11-12 18:47:10, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184710_984, PA |
| 18:47:11.145 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.55 | LOGTYPE=SpeedUp, NOTE=FP00603
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 18:47:11.173 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.04 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:47:11.448 | load | GSCM.FP_Common | UI_FP_COMMON | 2 | 246.57 | code=PLAN_PERIOD_PLAN_RESULT_AMEND, user_id=jaeuk.shin, non_auth=, save_auth=, param1=KR_CELL, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, par |
| 18:47:11.454 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.05 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:47:11, END_TIME=2026-11-12 18:47:11, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112184711_202, PA |
| 18:47:11.501 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 35.51 | LOGTYPE=SpeedUp, NOTE=FP00603
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 18:47:11.506 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.23 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:47:11.626 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.09 | p_program_id=FP00603, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:47:11.636 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 5.92 | p_program_id=FP00603, p_sheet_name=Amend |
| 18:47:11.648 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 6.31 | p_program_id=FP00603, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:47:11.659 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 5.81 | p_program_id=FP00603, p_sheet_name=Amend |
| 18:47:11.811 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 93.55 | MenuID=Plan By Model(Assy), CnntCode=0104001, UserID=jaeuk.shin |
| 18:47:12.010 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.5 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00603 |
| 18:47:21.055 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.09 | p_program_id=FP00603, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:47:21.064 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 5.04 | p_program_id=FP00603, p_sheet_name=Amend |
| 18:47:21.070 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.02 | p_program_id=FP00603, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 18:47:21.076 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 3.72 | p_program_id=FP00603, p_sheet_name=Amend |
| 18:47:21.339 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 5.73 | p_code=FP00603_find_day2WeekAndMonth, p_user_id=jaeuk.shin, param1=20260914, param2=20261108, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:47:21.369 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.24 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_day2WeekAndMonth',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261108',@param3=N'',@param4=N'',@ |
| 18:47:21.400 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 0 | 20.34 | p_code=FP00603_find_currDateCol, p_user_id=jaeuk.shin, param1=KR_CELL, param2=20260914, param3=20261108, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:47:21.427 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.47 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'FP00603_find_currDateCol',@p_user_id=N'jaeuk.shin',@param1=N'KR_CELL',@param2=N'20260914',@param3=N'20261108',@param4=N'' |
| 18:47:21.444 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 56 | 7.03 | p_code=find_DateMap, p_user_id=jaeuk.shin, param1=20261112, param2=20260914, param3=20261108, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:47:21.488 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 44.28 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_DateMap',@p_user_id=N'jaeuk.shin',@param1=N'20261112',@param2=N'20260914',@param3=N'20261108',@param4=N'',@param5=N' |
| 18:47:21.534 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 8 | 33.36 | p_code=find_WeekCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261108, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:47:21.571 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 35.97 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_WeekCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261108',@param3=N'',@param4=N'',@param5=N'',@param |
| 18:47:21.638 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 3 | 59.85 | p_code=find_MonthCnt, p_user_id=jaeuk.shin, param1=20260914, param2=20261108, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:47:21.662 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.63 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_MonthCnt',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261108',@param3=N'',@param4=N'',@param5=N'',@para |
| 18:47:21.680 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 64 | 8.5 | p_code=find_bukInfo, p_user_id=jaeuk.shin, param1=20260914, param2=20261108, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:47:21.684 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.95 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'find_bukInfo',@p_user_id=N'jaeuk.shin',@param1=N'20260914',@param2=N'20261108',@param3=N'',@param4=N'',@param5=N'',@param |
| 18:47:21.753 | find | GSCM.FP_Common | PR_UI_FP_PLAN_FORM_CODE | 38 | 58.3 | p_code=select_measure, p_user_id=jaeuk.shin, param1=FP00603_Main, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20= |
| 18:47:21.784 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 30.5 | PROG_ID=error, QUERY_ID=FP_Planning.PR_UI_FP_PLAN_FORM_CODE, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Planning.WSL/FoxDataService.svc
EXEC PR_UI_FP_PLAN_FORM_CODE @p_code=N'select_measure',@p_user_id=N'jaeuk.shin',@param1=N'FP00603_Main',@param2=N'',@param3=N'',@param4=N'',@param5=N'',@param6= |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan Period | dCalendar_planrange |  |
| lblSql | btnSql |  |
| Div | mcbo_division |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Operation | clb_operation |  |
| Line | mcbo_line |  |
| layoutControlItem2 | chkInAct |  |
| layoutControlItem11 | chk_allLine |  |
| Model | txtModel |  |
| Material | txtItem |  |
| Plan Group | cboInstance |  |
| Pjt Group Nm | txtPjtGroupName |  |
| Nick Name | txtNickName |  |
| Prod Type | mcbo_prodtype |  |
| Site | cbo_site |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 21(보임 20) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
