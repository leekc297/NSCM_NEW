# AS-IS 실측 요약 — FP00960

- 실행: 2026-11-12 23:39:47.969 ~ 2026-11-12 23:41:09.511 · 계정 jaeuk.shin · 상태 OK
- 화면: Aging Inventory (GSCM.FP.Master.UIL.FP00960_Aging_Inventory)
- 조회 결과: Total :  · DB : 62.846s, UI : 0.007s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:39:48.407 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 34.66 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 23:39:48.413 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.69 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:39:48, END_TIME=2026-11-12 23:39:48, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112233948_372, PA |
| 23:39:48.478 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.2 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00960 |
| 23:39:48.494 | load | GSCM.FP_Common | SELECT * | 351 | 10.4 | USER_ID= |
| 23:39:48.500 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.61 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 23:39:48.649 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.48 | LOGTYPE=SpeedUp, NOTE=FP00960
division_id_changed
start
, USER_ID=jaeuk.shin |
| 23:39:48.699 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 50.11 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:39:48.766 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 38.24 | LOGTYPE=SpeedUp, NOTE=FP00960
division_id_changed
end
, USER_ID=jaeuk.shin |
| 23:39:48.769 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:39:48.850 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.09 | p_program_id=FP00960, p_sheet_name=AgingInventory, p_user_id=jaeuk.shin |
| 23:39:48.894 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 40.54 | p_program_id=FP00960, p_sheet_name=AgingInventory |
| 23:39:48.904 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.24 | p_program_id=FP00960, p_sheet_name=AgingInventory, p_user_id=jaeuk.shin |
| 23:39:48.912 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 4.47 | p_program_id=FP00960, p_sheet_name=AgingInventory |
| 23:39:48.989 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 47.24 | MenuID=Aging Inventory, CnntCode=0104001, UserID=jaeuk.shin |
| 23:39:49.041 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00960 |
| 23:41:01.916 | find | GSCM.FP_Common | PR_UI_FP00960_AGING_INVENTORY | 0 | 62683.08 | p_sys_type=SELECT, p_sys_flag=SELECT, p_sys_gubun=, p_user_id=jaeuk.shin, p_division_id=40,81,81_HD,81_HM,81_ST,81_UC,82, p_site_id=, p_plant_id=GM00,GM01,HD00,HM00,HQ06,HQ07,HQ08,HQ10,HQ11,MI00,MI03,NA00,NB01,NB02,NJ01,NJ02,ST00,WA00,WA01, p_factory_id=A1,A2,A3,A4,A5,A6,A7,A8,A9,AA,AB,AC,AD,AE,AF,A |
| 23:41:01.931 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 14.78 | PROG_ID=error, QUERY_ID=FP_Master.PR_UI_FP00960_AGING_INVENTORY, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Master.WSL/FoxDataService.svc
EXEC PR_UI_FP00960_AGING_INVENTORY @p_sys_type=N'SELECT',@p_sys_flag=N'SELECT',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_division_id=N'40,81,81_HD,81_HM,81 |
| 23:41:01.967 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.41 | p_menu_id=FP00960, p_log_type=FIND, p_log_cnt=, p_db_time=62.846, p_ui_time=0.007, p_user_id=jaeuk.shin |
| 23:41:08.554 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 35.37 | MenuID=Aging Inventory, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Div | clbDivision |  |
| Route | txtRoute |  |
| Site | cboSite |  |
| Operation | txtOperation |  |
| Plant | clbPlant |  |
| Line | txtLine |  |
| Building | clbFactory |  |
| Material | txtItemID |  |
| Cut Off Date | dtpCurOffDate |  |

## 그리드

- spdMain / AgingInventory: 행 0 · 컬럼 27(보임 26) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
