# AS-IS 실측 요약 — SCP0125

- 실행: 2026-11-12 20:41:13.246 ~ 2026-11-12 20:42:02.786 · 계정 jaeuk.shin · 상태 OK
- 화면: Workbench (GSCM.SCP.Master.UIL.SCP0125_Workbench)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:41:13.613 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.47 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:41:14.867 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 1248.83 | Code=OPMZ_DATE_WEEKLY, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:41:14.938 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 66.12 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:41:14.983 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 40.86 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:41:15.000 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 13.07 | Code=LookupCommon, Param1=STOCK_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:41:15.007 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.2 | Code=LookupCommon, Param1=OPMZ_DIVISION_GM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:41:15.014 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.43 | Code=LookupCommon, Param1=STOCK_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:41:20.665 | load | GSCM.SCP.Master.WSL | SCP0125_GET_SEARCH_INFO | 106 | 5646.6 |  |
| 20:41:23.129 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.4 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0125 |
| 20:41:23.153 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.3 | USER_ID= |
| 20:41:23.367 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 24.32 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=MKT FCST |
| 20:41:23.388 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.96 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Stock |
| 20:41:23.404 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 3.87 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Stock(Elec. Plant) |
| 20:41:23.419 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.89 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Elec. Demand |
| 20:41:23.432 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 3.85 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Stock(2nd OCV) |
| 20:41:23.536 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 87.93 | MenuID=Workbench, CnntCode=0104001, UserID=jaeuk.shin |
| 20:41:23.584 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.26 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0125 |
| 20:41:31.194 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 20.72 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=MKT FCST |
| 20:42:02.126 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.36 | MenuID=Workbench, CnntCode=0104002, UserID=jaeuk.shin |

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
