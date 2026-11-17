# AS-IS 실측 요약 — SCP0014

- 실행: 2026-11-12 19:46:29.391 ~ 2026-11-12 19:47:13.409 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Problem (GSCM.SCP.Analysis.UIL.SCP0014_Problem_Report)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:46:29.834 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.32 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:46:30.093 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 62 | 254.01 | Code=PlantSitePlanProblem1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:46:30.105 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 98 | 6.98 | Code=PlantSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:46:30.116 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 67 | 5.86 | Code=SalesSitePlanProblem1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:46:30.144 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 24.05 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:46:30.169 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.49 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:46:30.387 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 214.6 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:46:30.552 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 152.56 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:46:30.724 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 154.34 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:46:31.139 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.68 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0014 |
| 19:46:31.472 | load | GSCM.BizService.WSL | SELECT * | 874 | 324.33 | USER_ID= |
| 19:46:31.687 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.24 |  |
| 19:46:31.698 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.35 | Code=LookupCommon, Param1=PROBLEM_LIST, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:46:31.822 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.21 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 19:46:31.874 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 27.94 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:46:31.949 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 63.54 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Demand |
| 19:46:32.115 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.16 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 19:46:32.129 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 4.67 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 19:46:33.102 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 882.09 | MenuID=Plan Problem, CnntCode=0104001, UserID=jaeuk.shin |
| 19:46:33.313 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0014 |
| 19:46:41.725 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.86 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 19:46:41.736 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.29 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Demand |
| 19:46:41.861 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.77 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 19:46:41.873 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.62 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Seq* | cboPlanSeq | Y |
| Plant Site | clbPlantSite |  |
| Sales Site | clbSalesSite |  |
| Problem | clbProblem |  |
| Plan date* | cboPlanDate | Y |
| Project | txtProject |  |
| Material | txtItemId |  |
| layoutControlItem2 | btnItem_Id |  |
| Plan type* | cboPlanType | Y |
| layoutControlItem4 | btnProject |  |
| Bucket | cboBucketType |  |
| layoutControlItem8 | chkSum |  |
| Electrode | cboElectrode |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / Demand: 행 0 · 컬럼 459(보임 322) · 헤더 3단 · 고정 컬럼 20
- spdPeggingInfo / Pegging Info: 행 0 · 컬럼 17(보임 11) · 헤더 1단 · 고정 컬럼 0
- spdPlanProblem / Plan Problem: 행 0 · 컬럼 7(보임 6) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
