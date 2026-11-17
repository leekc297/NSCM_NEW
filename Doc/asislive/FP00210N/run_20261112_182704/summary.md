# AS-IS 실측 요약 — FP00210N

- 실행: 2026-11-12 18:27:04.599 ~ 2026-11-12 18:27:44.127 · 계정 jaeuk.shin · 상태 OK
- 화면: BOM (GSCM.FP.Master.UIL.FP00210_BOM)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:27:04.969 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 28.18 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:27:04.972 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.23 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:27:04, END_TIME=2026-11-12 18:27:04, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182704_94, PAR |
| 18:27:05.022 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00210 |
| 18:27:05.038 | load | GSCM.FP_Common | SELECT * | 351 | 11.19 | USER_ID= |
| 18:27:05.042 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.79 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:27:05.137 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP00210, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:27:05.161 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 19.44 | p_program_id=FP00210, p_sheet_name=Main |
| 18:27:05.168 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.77 | p_program_id=FP00210, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:27:05.174 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 3.88 | p_program_id=FP00210, p_sheet_name=Main |
| 18:27:05.188 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.17 | p_program_id=FP00210, p_sheet_name=Alternate BOM, p_user_id=jaeuk.shin |
| 18:27:05.199 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 15 | 7.77 | p_program_id=FP00210, p_sheet_name=Alternate BOM |
| 18:27:05.209 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.98 | p_program_id=FP00210, p_sheet_name=Alternate BOM, p_user_id=jaeuk.shin |
| 18:27:05.217 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 15 | 4.0 | p_program_id=FP00210, p_sheet_name=Alternate BOM |
| 18:27:05.318 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 79.68 | MenuID=BOM, CnntCode=0104001, UserID=jaeuk.shin |
| 18:27:05.359 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00210 |
| 18:27:13.540 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.89 | p_program_id=FP00210, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:27:13.548 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 5.16 | p_program_id=FP00210, p_sheet_name=Main |
| 18:27:13.556 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.7 | p_program_id=FP00210, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:27:13.563 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 17 | 4.06 | p_program_id=FP00210, p_sheet_name=Main |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| layoutControlItem10 | btnBom |  |
| Plant | clbPlant |  |
| Site | clbSite |  |
| Child Nick Name | txtChildNickName |  |
| Div | clbDivision |  |
| Child Material | txtChildItemId |  |
| Parent Nick Name | txtParentNickName |  |
| Parent Material | txtParentItemId |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 18(보임 17) · 헤더 1단 · 고정 컬럼 0
- spdSub / Alternate BOM: 행 0 · 컬럼 16(보임 15) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
