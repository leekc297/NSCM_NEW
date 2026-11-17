# AS-IS 실측 요약 — FP00960

- 실행: 2026-11-12 19:13:27.873 ~ 2026-11-12 19:14:11.194 · 계정 jaeuk.shin · 상태 OK
- 화면: Aging Inventory (GSCM.FP.Master.UIL.FP00960_Aging_Inventory)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:13:28.196 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.25 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:13:28.200 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.28 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:13:28, END_TIME=2026-11-12 19:13:28, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112191328_189, PA |
| 19:13:28.313 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00960 |
| 19:13:28.335 | load | GSCM.FP_Common | SELECT * | 351 | 12.07 | USER_ID= |
| 19:13:28.338 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.27 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:13:28.621 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.37 | LOGTYPE=SpeedUp, NOTE=FP00960
division_id_changed
start
, USER_ID=jaeuk.shin |
| 19:13:28.647 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.25 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:13:28.765 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 27.6 | LOGTYPE=SpeedUp, NOTE=FP00960
division_id_changed
end
, USER_ID=jaeuk.shin |
| 19:13:28.769 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.14 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:13:28.930 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.97 | p_program_id=FP00960, p_sheet_name=AgingInventory, p_user_id=jaeuk.shin |
| 19:13:28.973 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 37.09 | p_program_id=FP00960, p_sheet_name=AgingInventory |
| 19:13:28.984 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.87 | p_program_id=FP00960, p_sheet_name=AgingInventory, p_user_id=jaeuk.shin |
| 19:13:28.993 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 26 | 4.66 | p_program_id=FP00960, p_sheet_name=AgingInventory |
| 19:13:29.165 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 65.3 | MenuID=Aging Inventory, CnntCode=0104001, UserID=jaeuk.shin |
| 19:13:29.268 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.36 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00960 |

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
