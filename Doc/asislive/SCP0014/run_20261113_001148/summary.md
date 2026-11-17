# AS-IS 실측 요약 — SCP0014

- 실행: 2026-11-13 00:11:48.996 ~ 2026-11-13 00:12:23.586 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Problem (GSCM.SCP.Analysis.UIL.SCP0014_Problem_Report)
- 조회 결과: Total :  · DB : 17.723s, UI : 0.184s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:11:49.393 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 25.3 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:11:49.408 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 62 | 6.66 | Code=PlantSitePlanProblem1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:11:49.419 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 98 | 5.72 | Code=PlantSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:11:49.431 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 67 | 5.42 | Code=SalesSitePlanProblem1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:11:49.463 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2559 | 25.99 | Code=SaleSiteByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:11:49.495 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.22 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:11:49.681 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 182.27 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:11:49.825 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 137.06 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:11:49.986 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 138.35 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:11:50.053 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.46 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0014 |
| 00:11:50.081 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.16 | USER_ID= |
| 00:11:50.339 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.78 |  |
| 00:11:50.393 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 40.16 | Code=LookupCommon, Param1=PROBLEM_LIST, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:11:50.562 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 7.06 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 00:11:50.589 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 12.7 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 00:11:50.630 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 16.87 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Demand |
| 00:11:50.781 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 5.39 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 00:11:50.797 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 4.99 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 00:11:50.915 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 95.64 | MenuID=Plan Problem, CnntCode=0104001, UserID=jaeuk.shin |
| 00:11:51.072 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0014 |
| 00:11:59.771 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 15.76 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 00:11:59.792 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.47 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Demand |
| 00:11:59.929 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 4.63 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 00:11:59.940 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.61 | p_program_id=SCP0014, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 00:12:17.663 | find | GSCM.SCP.Analysis.WSL | SCP0014_GET_PROBLEM_REPORT | 0 | 17627.39 | p_division_id=81, p_plant_site_id=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P, p_sales_site_id=Aeonus_KR_GUN,Alte_KR_SEL,Alte_US_SFJ,A |
| 00:12:17.862 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.02 | p_menu_id=SCP0014, p_log_type=FIND, p_log_cnt=, p_db_time=17.723, p_ui_time=0.184, p_user_id=jaeuk.shin |
| 00:12:22.633 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.28 | MenuID=Plan Problem, CnntCode=0104002, UserID=jaeuk.shin |

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
