# AS-IS 실측 요약 — FP06969

- 실행: 2026-11-13 05:08:50.423 ~ 2026-11-13 05:10:15.004 · 계정 jaeuk.shin · 상태 OK
- 화면: File Manager (GSCM.FP.Admin.UIL.FP06969_Distribute)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:09:26.027 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 157.41 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 05:09:26.034 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.79 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 05:09:25, END_TIME=2026-11-13 05:09:26, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113050925_869, PA |
| 05:09:26.733 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=XP06969 |
| 05:09:26.761 | load | GSCM.FP_Common | SELECT * | 351 | 14.2 | USER_ID= |
| 05:09:26.769 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.06 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 05:09:26.961 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.36 | p_program_id=FP06969, p_sheet_name=spdMain, p_user_id=jaeuk.shin |
| 05:09:27.025 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 57.71 | p_program_id=FP06969, p_sheet_name=spdMain |
| 05:09:27.036 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.47 | p_program_id=FP06969, p_sheet_name=spdMain, p_user_id=jaeuk.shin |
| 05:09:27.052 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 10.07 | p_program_id=FP06969, p_sheet_name=spdMain |
| 05:09:27.324 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 125.71 | MenuID=File Manager, CnntCode=0104001, UserID=jaeuk.shin |
| 05:09:27.421 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.88 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=XP06969 |
| 05:10:14.327 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.03 | MenuID=File Manager, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Upload Base | txtBase |  |
| Target Type | cboDomain |  |
| Select Local Base | btnSelect |  |
| Upload | btnUpload |  |
| Download | btnDownload |  |

## 그리드

- spdMain / spdMain: 행 0 · 컬럼 0(보임 0) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-13 05:09:36.317 [] Please select valid base directory first → default_button(id=1)
