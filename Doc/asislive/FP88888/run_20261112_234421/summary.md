# AS-IS 실측 요약 — FP88888

- 실행: 2026-11-12 23:44:21.585 ~ 2026-11-12 23:45:42.102 · 계정 jaeuk.shin · 상태 OK
- 화면: Log Vue (GSCM.FP.Common.UIL.FP88888_FP_Log_Vue)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:44:22.262 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.73 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP88888 |
| 23:44:22.279 | load | GSCM.FP_Common | SELECT * | 351 | 11.39 | USER_ID= |
| 23:44:22.367 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 88.74 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 23:44:22.458 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 22.6 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 23:44:22.461 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.84 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 23:44:22, END_TIME=2026-11-12 23:44:22, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112234422_435, PA |
| 23:44:22.475 | load | GSCM.FP_Common | WITH M_TABLE AS ( | 33 | 4.74 | USER_ID=jaeuk.shin, MENU_ID=FP00611_Main |
| 23:44:22.546 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 71.79 | PROG_ID=select_measure, QUERY_ID=FP\Common\Measure, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1MENU_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : MENU_ID
---FOUND MENU_ID
- |
| 23:44:22.553 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00611, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 23:44:22.612 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 54.86 | p_program_id=FP00611, p_sheet_name=Main |
| 23:44:22.681 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.8 | p_program_id=FP88888, p_sheet_name=Log, p_user_id=jaeuk.shin |
| 23:44:22.728 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 20 | 44.03 | p_program_id=FP88888, p_sheet_name=Log |
| 23:44:22.886 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 115.96 | MenuID=Log Vue, CnntCode=0104001, UserID=jaeuk.shin |
| 23:44:22.995 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.67 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP88888 |
| 23:45:07.381 | find | GSCM.FP_Common | SELECT * FROM TH_UIS_SQL_LOG  WITH(NOLOCK) | 5006 | 34598.9 | INSERT_USER=jaeuk.shin, INSERT_FROM=20261111, INSERT_TO=20261113, PROG_ID=, JOB_TYPE=, LOG_TYPE= |
| 23:45:07.395 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 13.24 | PROG_ID=list_log, QUERY_ID=FP\Common\LogVue, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSERT_USER
---Service Parameter : 1INSERT_FROM
---Service Parameter : 2INSERT_TO
---Service Parameter : 3JOB_TYPE
---Service Parameter : 4LOG_TYPE
---Service Parameter : 5PROG_ID
---Check clien |
| 23:45:41.249 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 55.56 | MenuID=Log Vue, CnntCode=0104002, UserID=jaeuk.shin |

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
