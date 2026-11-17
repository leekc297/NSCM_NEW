# AS-IS 실측 요약 — FP02600

- 실행: 2026-11-12 19:25:06.099 ~ 2026-11-12 19:25:22.990 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Result WO MES (GSCM.FP.Planning.UIL.FP02600_Prod_Result_WO_MES)
- 조회 결과:  · DB : 0.296s, UI : 0.047s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:25:06.610 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.22 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02600 |
| 19:25:06.628 | load | GSCM.FP_Common | SELECT * | 351 | 9.41 | USER_ID= |
| 19:25:06.632 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.06 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:25:06.906 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.22 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:25:06.911 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.29 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:25:06, END_TIME=2026-11-12 19:25:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192506_899, PA |
| 19:25:06.999 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.87 | LOGTYPE=SpeedUp, NOTE=FP02600
division_id_changed
start
, USER_ID=jaeuk.shin |
| 19:25:07.024 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.58 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:25:07.089 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 31.08 | LOGTYPE=SpeedUp, NOTE=FP02600
division_id_changed
end
, USER_ID=jaeuk.shin |
| 19:25:07.093 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.9 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:25:07.472 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.11 | p_program_id=FP02600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:25:07.484 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 6.42 | p_program_id=FP02600, p_sheet_name=Amend |
| 19:25:07.493 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.89 | p_program_id=FP02600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:25:07.503 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 5.01 | p_program_id=FP02600, p_sheet_name=Amend |
| 19:25:07.653 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 93.6 | MenuID=Production Result WO MES, CnntCode=0104001, UserID=jaeuk.shin |
| 19:25:07.816 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.62 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02600 |
| 19:25:16.760 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 272.81 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR_UI_FP02600_FIND_FP02600, opt_none=, in_columns=USER_ID^DIVISION_ID^SITE_ID^PLANT_ID^FACTORY_ID^START_DATE^, in_row=mXlVW48SU1c3wPszIA83/w==^40,81,81_HD,81_HM,81_ST,81_UC,82^A001,A002,A003,A004,A007,A009^GM00,GM01,HD00 |
| 19:25:16.773 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 12.0 | PROG_ID=PR_UI_FP02600_FIND_FP02600, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR_UI_FP02600_FIND_FP |
| 19:25:16.783 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.02 | p_program_id=FP02600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:25:16.791 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 3.78 | p_program_id=FP02600, p_sheet_name=Amend |
| 19:25:16.801 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.99 | p_program_id=FP02600, p_sheet_name=Amend, p_user_id=jaeuk.shin |
| 19:25:16.809 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 3.65 | p_program_id=FP02600, p_sheet_name=Amend |
| 19:25:16.833 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.45 | p_menu_id=FP02600, p_log_type=FIND, p_log_cnt=, p_db_time=0.296, p_ui_time=0.047, p_user_id=jaeuk.shin |
| 19:25:22.240 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.03 | MenuID=Production Result WO MES, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| layoutControlItem2 | btnExcelImport |  |
| Data | btnToggleSave |  |
| Division. | mcbo_division |  |
| Site | mcbo_site |  |
| Plant | mcbo_plant |  |
| Building | mcbo_factory |  |
| Operation | mcbo_operation |  |
| Line | mcbo_line |  |
| Material | edt_item |  |
| Plan Date | sCalendar_planday |  |

## 그리드

- spdMain / Amend: 행 0 · 컬럼 27(보임 26) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
