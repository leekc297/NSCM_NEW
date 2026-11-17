# AS-IS 실측 요약 — SCP0125

- 실행: 2026-11-12 22:56:10.859 ~ 2026-11-12 22:57:22.138 · 계정 jaeuk.shin · 상태 OK
- 화면: Workbench (GSCM.SCP.Master.UIL.SCP0125_Workbench)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:56:11.192 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.35 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:56:12.555 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 1358.68 | Code=OPMZ_DATE_WEEKLY, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:56:12.781 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 212.97 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:56:12.788 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.31 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:56:13.332 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 539.7 | Code=LookupCommon, Param1=STOCK_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:56:13.412 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 69.32 | Code=LookupCommon, Param1=OPMZ_DIVISION_GM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:56:13.425 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.99 | Code=LookupCommon, Param1=STOCK_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:56:33.561 | load | GSCM.SCP.Master.WSL | SCP0125_GET_SEARCH_INFO | 106 | 20124.23 |  |
| 22:56:36.201 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0125 |
| 22:56:36.226 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.35 | USER_ID= |
| 22:56:36.558 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 185.8 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=MKT FCST |
| 22:56:36.577 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.62 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Stock |
| 22:56:36.591 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 4.21 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Stock(Elec. Plant) |
| 22:56:36.608 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.99 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Elec. Demand |
| 22:56:36.620 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.05 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=Stock(2nd OCV) |
| 22:56:36.986 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 350.23 | MenuID=Workbench, CnntCode=0104001, UserID=jaeuk.shin |
| 22:56:37.191 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.17 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0125 |
| 22:56:46.696 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.1 | p_program_id=SCP0125, p_user_id=jaeuk.shin, p_sheet_name=MKT FCST |
| 22:57:21.076 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.18 | MenuID=Workbench, CnntCode=0104002, UserID=jaeuk.shin |

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
