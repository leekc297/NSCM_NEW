# AS-IS 실측 요약 — FP02642N

- 실행: 2026-11-12 19:26:43.296 ~ 2026-11-12 19:27:10.748 · 계정 jaeuk.shin · 상태 OK
- 화면: W/O History (GSCM.FP.Master.UIL.FP02642_WO_History)
- 조회 결과: Total :  · DB : 8.03s, UI : 0.004s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:26:43.634 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.55 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:26:43.686 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 46.0 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:26:43.690 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.71 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:26:43, END_TIME=2026-11-12 19:26:43, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192643_64, PAR |
| 19:26:43.811 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02642 |
| 19:26:43.829 | load | GSCM.FP_Common | SELECT * | 351 | 9.67 | USER_ID= |
| 19:26:43.832 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.43 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:26:44.113 | load | GSCM.FP_Common | UI_FP_COMMON | 1 | 8.17 | code=CURRENT_DATE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25 |
| 19:26:44.116 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.97 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:26:44, END_TIME=2026-11-12 19:26:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192644_105, PA |
| 19:26:44.568 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 6.78 | LOGTYPE=SpeedUp, NOTE=FP02642
division_id_changed
start
, USER_ID=jaeuk.shin |
| 19:26:44.710 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 141.74 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:26:44.793 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 53.18 | LOGTYPE=SpeedUp, NOTE=FP02642
division_id_changed
end
, USER_ID=jaeuk.shin |
| 19:26:44.821 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.41 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:26:44.895 | load | GSCM.FP_Common | UI_FP_COMMON | 56 | 35.14 | code=PRODUCTION_TYPE, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, para |
| 19:26:44.899 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.36 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:26:44, END_TIME=2026-11-12 19:26:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192644_86, PAR |
| 19:26:45.335 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.31 | p_program_id=FP02642, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:26:45.374 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 28.92 | p_program_id=FP02642, p_sheet_name=Main |
| 19:26:45.384 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.12 | p_program_id=FP02642, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:26:45.392 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 3.93 | p_program_id=FP02642, p_sheet_name=Main |
| 19:26:45.776 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 322.7 | MenuID=W/O History, CnntCode=0104001, UserID=jaeuk.shin |
| 19:26:46.044 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02642 |
| 19:26:56.134 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.28 | p_program_id=FP02642, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:26:56.143 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 4.01 | p_program_id=FP02642, p_sheet_name=Main |
| 19:26:56.152 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.37 | p_program_id=FP02642, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:26:56.161 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 4.67 | p_program_id=FP02642, p_sheet_name=Main |
| 19:27:04.177 | find | GSCM.FP_Common | PR_UI_FP02642_WO_HISTORY | 0 | 7994.94 | p_sys_type=SELECT, p_sys_flag=MAIN, p_sys_gubun=, p_user_id=jaeuk.shin, p_instance_id=CN_E_POST, p_division_id=81, p_site_id=A002, p_plant_id=NA00, p_factory_id=EA, p_operation_id=E3000,E4000, p_line_id=EAD01, p_top_item_id=, p_item_id=, p_work_order_id=, p_from_date=20261105, p_to_date=20261119, p_ |
| 19:27:04.200 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.66 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP02642_WO_HISTORY, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP02642_WO_HISTORY @p_sys_type=N'SELECT',@p_sys_flag=N'MAIN',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_instance_id=N'CN_E_POST',@p_division_id=N'81', |
| 19:27:04.222 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 9.6 | p_menu_id=FP02642, p_log_type=FIND, p_log_cnt=, p_db_time=8.03, p_ui_time=0.004, p_user_id=jaeuk.shin |
| 19:27:09.893 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 12.72 | MenuID=W/O History, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Plan Group | cboInstance |  |
| Building | clbFactory |  |
| Model | tbModel |  |
| Plan Period* | drpPeriod | Y |
| Div | clbDivision |  |
| Operation | cboOperation |  |
| Site | cboSite |  |
| Plant | clbPlant |  |
| Material | tbItemId |  |
| Line | clbLine |  |
| Prod. Type | cboProdType |  |
| W/O No. | txtWorkOrderID |  |
| Update Date | drpUpdate |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 31(보임 30) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
