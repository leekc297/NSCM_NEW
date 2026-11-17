# AS-IS 실측 요약 — FP06969

- 실행: 2026-11-13 00:53:44.526 ~ 2026-11-13 00:54:31.728 · 계정 jaeuk.shin · 상태 OK
- 화면: File Manager (GSCM.FP.Admin.UIL.FP06969_Distribute)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:53:44.910 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 71.46 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 00:53:44.915 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.73 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 00:53:44, END_TIME=2026-11-13 00:53:44, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113005344_838, PA |
| 00:53:44.970 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.36 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=XP06969 |
| 00:53:45.045 | load | GSCM.FP_Common | SELECT * | 351 | 70.93 | USER_ID= |
| 00:53:45.052 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 7.5 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 00:53:45.178 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.52 | p_program_id=FP06969, p_sheet_name=spdMain, p_user_id=jaeuk.shin |
| 00:53:45.242 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 61.52 | p_program_id=FP06969, p_sheet_name=spdMain |
| 00:53:45.250 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.09 | p_program_id=FP06969, p_sheet_name=spdMain, p_user_id=jaeuk.shin |
| 00:53:45.257 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 3.7 | p_program_id=FP06969, p_sheet_name=spdMain |
| 00:53:45.397 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 124.18 | MenuID=File Manager, CnntCode=0104001, UserID=jaeuk.shin |
| 00:53:45.450 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.85 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=XP06969 |
| 00:54:30.825 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.35 | MenuID=File Manager, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-13 00:53:53.597 [] Please select valid base directory first → default_button(id=1)
