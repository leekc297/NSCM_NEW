# AS-IS 실측 요약 — FP02800N

- 실행: 2026-11-12 19:27:37.196 ~ 2026-11-12 19:28:26.450 · 계정 jaeuk.shin · 상태 OK
- 화면: BOM Explosion (GSCM.FP.Master.UIL.FP02800_BOM_Explosion)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:27:37.638 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 63.69 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:27:37.642 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.24 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:27:37, END_TIME=2026-11-12 19:27:37, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192737_574, PA |
| 19:27:37.741 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02800 |
| 19:27:37.758 | load | GSCM.FP_Common | SELECT * | 351 | 9.9 | USER_ID= |
| 19:27:37.813 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 54.25 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:27:38.140 | load | GSCM.FP_Common | UI_FP_COMMON | 7 | 145.44 | code=DIVISION, user_id=jaeuk.shin, non_auth=, save_auth=, param1=, param2=, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, param25=, p |
| 19:27:38.145 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:27:37, END_TIME=2026-11-12 19:27:38, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112192737_995, PA |
| 19:27:38.338 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.23 | p_program_id=FP02800, p_sheet_name=Parent-Child, p_user_id=jaeuk.shin |
| 19:27:38.523 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 179.27 | p_program_id=FP02800, p_sheet_name=Parent-Child |
| 19:27:38.534 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.71 | p_program_id=FP02800, p_sheet_name=Parent-Child, p_user_id=jaeuk.shin |
| 19:27:38.542 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 18 | 3.93 | p_program_id=FP02800, p_sheet_name=Parent-Child |
| 19:27:38.560 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.5 | p_program_id=FP02800, p_sheet_name=Material Class, p_user_id=jaeuk.shin |
| 19:27:38.570 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 4.08 | p_program_id=FP02800, p_sheet_name=Material Class |
| 19:27:38.585 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.45 | p_program_id=FP02800, p_sheet_name=Material Class, p_user_id=jaeuk.shin |
| 19:27:38.594 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 30 | 4.45 | p_program_id=FP02800, p_sheet_name=Material Class |
| 19:27:39.142 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 479.92 | MenuID=BOM Explosion, CnntCode=0104001, UserID=jaeuk.shin |
| 19:27:39.274 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.32 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP02800 |
| 19:28:25.688 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.56 | MenuID=BOM Explosion, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 19:27:48.240 [GSCM] Material 검색 조건은 5글자 이상입니다. → default_button(id=1)
