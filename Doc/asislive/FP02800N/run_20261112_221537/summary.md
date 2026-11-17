# AS-IS 실측 요약 — FP02800N

- 실행: 2026-11-12 22:15:37.572 ~ 2026-11-12 22:16:28.243 · 계정 jaeuk.shin · 상태 OK
- 화면: BOM Explosion (GSCM.FP.Master.UIL.FP02800_BOM_Explosion)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:15:37.998 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 10.7 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:15:38.000 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 2.76 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:15:37, END_TIME=2026-11-12 22:15:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221537_987, PA |
| 22:15:38.087 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.58 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02800 |
| 22:15:38.103 | load | GSCM.FP_Common | SELECT * | 351 | 10.33 | USER_ID= |
| 22:15:38.109 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.24 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:15:38.414 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 164.57 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 22:15:38.434 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.09 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:15:38, END_TIME=2026-11-12 22:15:38, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112221538_25, PAR |
| 22:15:38.563 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.81 | p_program_id=FP02800, p_sheet_name=Parent-Child, p_user_id=jaeuk.shin |
| 22:15:38.596 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 28.62 | p_program_id=FP02800, p_sheet_name=Parent-Child |
| 22:15:38.605 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.81 | p_program_id=FP02800, p_sheet_name=Parent-Child, p_user_id=jaeuk.shin |
| 22:15:38.613 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 3.99 | p_program_id=FP02800, p_sheet_name=Parent-Child |
| 22:15:38.629 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.22 | p_program_id=FP02800, p_sheet_name=Material Class, p_user_id=jaeuk.shin |
| 22:15:38.649 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 15.9 | p_program_id=FP02800, p_sheet_name=Material Class |
| 22:15:38.664 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.79 | p_program_id=FP02800, p_sheet_name=Material Class, p_user_id=jaeuk.shin |
| 22:15:38.672 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 4.1 | p_program_id=FP02800, p_sheet_name=Material Class |
| 22:15:38.801 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 87.41 | MenuID=BOM Explosion, CnntCode=0104001, UserID=jaeuk.shin |
| 22:15:38.865 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02800 |
| 22:16:27.479 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.11 | MenuID=BOM Explosion, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Site | cboSite |  |
| Plant | clbPlant |  |
| Material | txtItemId |  |
| Explosion Type | cboExplosionType |  |
| lblSql | btnSql |  |
| Div | clbDivision |  |

## 그리드

- spdMain / Parent-Child: 행 0 · 컬럼 19(보임 18) · 헤더 1단 · 고정 컬럼 0
- spdMain / Material Class: 행 0 · 컬럼 31(보임 30) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 22:15:49.067 [GSCM] Material 검색 조건은 5글자 이상입니다. → default_button(id=1)
