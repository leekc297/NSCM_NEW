# AS-IS 실측 요약 — FP88888

- 실행: 2026-11-12 22:17:34.928 ~ 2026-11-12 22:18:44.538 · 계정 jaeuk.shin · 상태 OK
- 화면: Log Vue (GSCM.FP.Common.UIL.FP88888_FP_Log_Vue)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:17:35.718 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.1 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP88888 |
| 22:17:35.737 | load | GSCM.FP_Common | SELECT * | 351 | 10.85 | USER_ID= |
| 22:17:35.765 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 27.64 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:17:35.877 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 7.03 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:17:35.883 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.95 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:17:35, END_TIME=2026-11-12 22:17:35, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221735_87, PAR |
| 22:17:35.896 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 33 | 4.46 | USER_ID=jaeuk.shin, MENU_ID=FP00611_Main |
| 22:17:35.916 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.53 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 22:17:35.927 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.65 | p_program_id=FP00611, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:17:35.968 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 32.4 | p_program_id=FP00611, p_sheet_name=Main |
| 22:17:36.026 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.96 | p_program_id=FP88888, p_sheet_name=Log, p_user_id=jaeuk.shin |
| 22:17:36.040 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 10.99 | p_program_id=FP88888, p_sheet_name=Log |
| 22:17:36.213 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 73.12 | MenuID=Log Vue, CnntCode=0104001, UserID=jaeuk.shin |
| 22:17:36.326 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.06 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP88888 |
| 22:18:07.439 | find | GSCM.FP_Common | SELECT * FROM TH_UIS_SQL_LOG  WITH(NOLOCK) | 4606 | 20979.21 | INSERT_USER=jaeuk.shin, INSERT_FROM=20261111, INSERT_TO=20261113, PROG_ID=, JOB_TYPE=, LOG_TYPE= |
| 22:18:07.443 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.84 | PROG_ID=list_log, QUERY_ID=FP\Common\LogVue, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSERT_USER
---Service Parameter : 1INSERT_FROM
---Service Parameter : 2INSERT_TO
---Service Parameter : 3JOB_TYPE
---Service Parameter : 4LOG_TYPE
---Service Parameter : 5PROG_ID
---Check clien |
| 22:18:43.712 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 59.77 | MenuID=Log Vue, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| User | edt_user_name |  |
| Plan Period | drpPeriod |  |
| Prog ID | txtProgID |  |
| Job Type | cmbJob |  |
| Log Type | cmbLog |  |

## 그리드


> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
