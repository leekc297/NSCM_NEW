# AS-IS 실측 요약 — FP06969

- 실행: 2026-11-12 21:14:53.805 ~ 2026-11-12 21:15:44.067 · 계정 jaeuk.shin · 상태 ERROR
- 화면: File Manager (GSCM.FP.Admin.UIL.FP06969_Distribute)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:14:54.402 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 231.62 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 21:14:54.408 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.86 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 21:14:54, END_TIME=2026-11-12 21:14:54, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112211454_17, PAR |
| 21:14:54.674 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.9 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=XP06969 |
| 21:14:54.841 | load | GSCM.FP_Common | SELECT * | 351 | 159.21 | USER_ID= |
| 21:14:54.875 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.14 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 21:14:55.043 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.07 | p_program_id=FP06969, p_sheet_name=spdMain, p_user_id=jaeuk.shin |
| 21:14:55.051 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 3.56 | p_program_id=FP06969, p_sheet_name=spdMain |
| 21:14:55.061 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.13 | p_program_id=FP06969, p_sheet_name=spdMain, p_user_id=jaeuk.shin |
| 21:14:55.069 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 0 | 3.66 | p_program_id=FP06969, p_sheet_name=spdMain |
| 21:14:56.458 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1349.31 | MenuID=File Manager, CnntCode=0104001, UserID=jaeuk.shin |
| 21:14:56.529 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=XP06969 |
| 21:15:43.196 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.26 | MenuID=File Manager, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 21:15:05.406 [] Please select valid base directory first → default_button(id=1)
