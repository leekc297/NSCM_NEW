# AS-IS 실측 요약 — SCP0125

- 실행: 2026-11-13 00:38:40.528 ~ 2026-11-13 00:39:30.509 · 계정 jaeuk.shin · 상태 OK
- 화면: Workbench (GSCM.SCP.Master.UIL.SCP0125_Workbench)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:38:40.895 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.36 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:38:42.294 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 1389.32 | Code=OPMZ_DATE_WEEKLY, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:38:42.343 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 43.99 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:38:42.372 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 24.04 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:38:42.411 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 34.48 | Code=LookupCommon, Param1=STOCK_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:38:42.441 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 26.01 | Code=LookupCommon, Param1=OPMZ_DIVISION_GM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:38:42.449 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.55 | Code=LookupCommon, Param1=STOCK_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:38:47.409 | load | GSCM.SCP.Master.WSL | SCP0125_GET_SEARCH_INFO | 106 | 4938.66 |  |
| 00:38:50.022 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0125 |
| 00:38:50.044 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.38 | USER_ID= |
| 00:38:50.261 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 27.53 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=MKT FCST |
| 00:38:50.278 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 6.0 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Stock |
| 00:38:50.295 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 5.51 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Stock(Elec. Plant) |
| 00:38:50.316 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.93 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Elec. Demand |
| 00:38:50.326 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.41 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Stock(2nd OCV) |
| 00:38:50.467 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 123.32 | MenuID=Workbench, CnntCode=0104001, UserID=jaeuk.shin |
| 00:38:50.498 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0125 |
| 00:38:58.437 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.77 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=MKT FCST |
| 00:39:29.227 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.57 | MenuID=Workbench, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| MKT FCST Ver. | cboVersion |  |
| Plan Date | cboPlanDate |  |
| Div | cboDivision |  |
| Nick Name | txtNickName |  |
| Model | txtItem |  |
| Plan Date | dpPlanDate_Days |  |

## 그리드

- spdMain / MKT FCST: 행 0 · 컬럼 23(보임 22) · 헤더 1단 · 고정 컬럼 0
- spdMain / Stock: 행 0 · 컬럼 23(보임 22) · 헤더 1단 · 고정 컬럼 0
- spdMain / Stock(Elec. Plant): 행 0 · 컬럼 22(보임 21) · 헤더 1단 · 고정 컬럼 0
- spdMain / Elec. Demand: 행 0 · 컬럼 19(보임 18) · 헤더 1단 · 고정 컬럼 0
- spdMain / Stock(2nd OCV): 행 0 · 컬럼 20(보임 19) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
