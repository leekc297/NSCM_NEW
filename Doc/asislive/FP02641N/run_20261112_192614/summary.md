# AS-IS 실측 요약 — FP02641N

- 실행: 2026-11-12 19:26:14.121 ~ 2026-11-12 19:26:43.180 · 계정 jaeuk.shin · 상태 OK
- 화면: W/O Status (GSCM.FP.Master.UIL.FP02641_WO_Status)
- 조회 결과: Total :  · DB : 11.492s, UI : 0.005s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:26:14.398 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.71 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:26:14.458 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 52.45 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:26:14.461 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.23 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:26:14, END_TIME=2026-11-12 19:26:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192614_406, PA |
| 19:26:14.628 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.51 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02641 |
| 19:26:14.646 | load | GSCM.FP_Common | SELECT * | 351 | 10.47 | USER_ID= |
| 19:26:14.656 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 9.27 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:26:14.927 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 11.71 | code=CURRENT_DATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25 |
| 19:26:14.973 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 45.13 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:26:14, END_TIME=2026-11-12 19:26:14, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192614_915, PA |
| 19:26:15.346 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 37.05 | LOGTYPE=SpeedUp, NOTE=FP02641
division_id_changed
start
, USER_ID=jaeuk.shin |
| 19:26:15.416 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 69.41 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:26:15.573 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 125.85 | LOGTYPE=SpeedUp, NOTE=FP02641
division_id_changed
end
, USER_ID=jaeuk.shin |
| 19:26:15.626 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 51.45 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:26:15.715 | load | GSCM.FP_Common | UI_FP_COMMON | 56 | 49.1 | code=PRODUCTION_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 19:26:15.719 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.31 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:26:15, END_TIME=2026-11-12 19:26:15, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192615_666, PA |
| 19:26:16.077 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.29 | p_program_id=FP02641, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:26:16.135 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 46.93 | p_program_id=FP02641, p_sheet_name=Main |
| 19:26:16.146 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.18 | p_program_id=FP02641, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:26:16.155 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 4.03 | p_program_id=FP02641, p_sheet_name=Main |
| 19:26:16.415 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 202.84 | MenuID=W/O Status, CnntCode=0104001, UserID=jaeuk.shin |
| 19:26:16.612 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02641 |
| 19:26:25.620 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.1 | p_program_id=FP02641, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:26:25.628 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 3.91 | p_program_id=FP02641, p_sheet_name=Main |
| 19:26:25.635 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.99 | p_program_id=FP02641, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:26:25.642 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 4.38 | p_program_id=FP02641, p_sheet_name=Main |
| 19:26:37.074 | find | GSCM.FP_Common | PR_UI_FP02641_WO_STATUS | 0 | 11414.25 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=CN_E_POST, p_division_id=81, p_site_id=A002, p_plant_id=NA00, p_factory_id=EA, p_operation_id=E3000,E4000, p_line_id=EAD01, p_top_item_id=, p_item_id=, p_work_order_id=, p_from_date=20261105, p_to_date=20261119, p_ |
| 19:26:37.138 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 63.51 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP02641_WO_STATUS, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP02641_WO_STATUS @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'CN_E_POST',@p_division_id=N'81',@p |
| 19:26:37.169 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 19.84 | p_menu_id=FP02641, p_log_type=FIND, p_log_cnt=, p_db_time=11.492, p_ui_time=0.005, p_user_id=jaeuk.shin |
| 19:26:42.411 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.93 | MenuID=W/O Status, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Plan Group | cboInstance |  |
| Building | clbFactory |  |
| Status | cboStatus |  |
| Plan Period* | drpPeriod | Y |
| Div | clbDivision |  |
| Operation | cboOperation |  |
| Model | tbModel |  |
| Site | cboSite |  |
| Line | clbLine |  |
| Material | tbItemId |  |
| Plant | clbPlant |  |
| Prod. Type | cboProdType |  |
| W/O No. | txtWorkOrderID |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 27(보임 26) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
