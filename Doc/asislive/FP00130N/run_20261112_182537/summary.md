# AS-IS 실측 요약 — FP00130N

- 실행: 2026-11-12 18:25:37.291 ~ 2026-11-12 18:26:11.387 · 계정 jaeuk.shin · 상태 OK
- 화면: Equipment (GSCM.FP.Master.UIL.FP00130_Equipment)
- 조회 결과:  · DB : 18.91s, UI : 0.102s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:25:37.687 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.08 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00130 |
| 18:25:37.702 | load | GSCM.FP_Common | SELECT * | 351 | 9.82 | USER_ID= |
| 18:25:37.730 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.37 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:25:37.870 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 9.06 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:25:37.874 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.21 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:25:37, END_TIME=2026-11-12 18:25:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182537_861, PA |
| 18:25:38.552 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.57 | p_program_id=FP00130, p_sheet_name=Equipment, p_user_id=jaeuk.shin |
| 18:25:38.586 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 12 | 29.62 | p_program_id=FP00130, p_sheet_name=Equipment |
| 18:25:38.594 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.88 | p_program_id=FP00130, p_sheet_name=Equipment, p_user_id=jaeuk.shin |
| 18:25:38.604 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 12 | 5.78 | p_program_id=FP00130, p_sheet_name=Equipment |
| 18:25:38.617 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.19 | p_program_id=FP00130, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 18:25:38.629 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 5 | 8.24 | p_program_id=FP00130, p_sheet_name=Sub |
| 18:25:38.639 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.86 | p_program_id=FP00130, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 18:25:38.647 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 5 | 3.94 | p_program_id=FP00130, p_sheet_name=Sub |
| 18:25:38.752 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 79.83 | MenuID=Equipment, CnntCode=0104001, UserID=jaeuk.shin |
| 18:25:38.819 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 5.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00130 |
| 18:25:46.533 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.41 | p_program_id=FP00130, p_sheet_name=Equipment, p_user_id=jaeuk.shin |
| 18:25:46.542 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 12 | 4.08 | p_program_id=FP00130, p_sheet_name=Equipment |
| 18:25:46.550 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.48 | p_program_id=FP00130, p_sheet_name=Equipment, p_user_id=jaeuk.shin |
| 18:25:46.559 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 12 | 5.29 | p_program_id=FP00130, p_sheet_name=Equipment |
| 18:25:46.572 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.42 | p_program_id=FP00130, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 18:25:46.580 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 5 | 4.23 | p_program_id=FP00130, p_sheet_name=Sub |
| 18:25:46.589 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.75 | p_program_id=FP00130, p_sheet_name=Sub, p_user_id=jaeuk.shin |
| 18:25:46.598 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 5 | 4.47 | p_program_id=FP00130, p_sheet_name=Sub |
| 18:26:05.324 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 4711 | 18712.17 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR2_UI_FP00130_FIND_FP00130, opt_none=, in_columns=EQUIPMENT_TYPE^USER_ID^SITE_ID^PLANT_ID^FACTORY_ID^, in_row=M^mXlVW48SU1c3wPszIA83/w==^A001,A002,A003,A004,A007,A009^GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI |
| 18:26:05.340 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 15.41 | PROG_ID=PR2_UI_FP00130_FIND_FP00130, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR2_UI_FP00130_FIND_ |
| 18:26:05.624 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.62 | p_menu_id=FP00130, p_log_type=FIND, p_log_cnt=, p_db_time=18.91, p_ui_time=0.102, p_user_id=jaeuk.shin |
| 18:26:10.704 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.51 | MenuID=Equipment, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Division. | clbDivision |  |
| layoutControlItem2 | btnExcelImport |  |
| Site | clbSite |  |
| Plant | clbPlant |  |
| Building | clbFactory |  |
| lblSql | btnSql |  |
| Operation | clbOperation |  |
| Line | clbLine |  |
| Equipment | cbo_equip |  |
| Active | cbo_active |  |

## 그리드

- spdMain / Equipment: 행 4711 · 컬럼 13(보임 12) · 헤더 1단 · 고정 컬럼 0
- spdSub / Sub: 행 0 · 컬럼 6(보임 5) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
