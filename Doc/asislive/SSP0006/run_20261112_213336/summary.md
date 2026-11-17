# AS-IS 실측 요약 — SSP0006

- 실행: 2026-11-12 21:33:36.656 ~ 2026-11-12 21:34:08.718 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Problem (SSP) (GSCM.SSP.Plan.UIL.SSP0006_Plan_Problem)
- 조회 결과: Total :  · DB : 0.447s, UI : 0.027s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:33:36.949 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 7.89 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:33:36.956 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.61 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:37.022 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.18 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0006 |
| 21:33:37.046 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.72 | USER_ID= |
| 21:33:37.237 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.95 |  |
| 21:33:37.258 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 9.46 | Code=LookupCommon, Param1=PROBLEM_LIST, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:37.272 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 4.33 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:33:37.288 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1294 | 12.36 | Code=SaleSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:38.132 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 689.75 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:38.261 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 123.25 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:38.394 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 128.46 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:38.408 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.92 | p_from_date=, p_offset_day=112, p_timezone=AS054 |
| 21:33:38.426 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 3.63 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Demand |
| 21:33:38.449 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 137 | 10.89 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270304 |
| 21:33:38.513 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.87 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 21:33:38.526 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.73 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 21:33:38.618 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 72.37 | MenuID=Plan Problem (SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 21:33:38.708 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.2 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0006 |
| 21:33:47.677 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 28 | 3.89 | Code=PlantSiteByDivision, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:33:47.688 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 7.56 | Code=SaleSiteByDivision, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:48.444 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 657.48 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:48.475 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.5 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:48.504 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.1 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:33:48.512 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.96 | p_from_date=20261009, p_offset_day=112, p_timezone=AS054 |
| 21:33:48.540 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.23 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:48.570 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.79 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:33:48.600 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 25.18 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:33:51.534 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 5.92 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:33:51.554 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1294 | 15.37 | Code=SaleSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:52.477 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 671.81 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:52.609 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 128.12 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:52.741 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 128.64 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:56.023 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 28 | 36.0 | Code=PlantSiteByDivision, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 21:33:56.034 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 7.24 | Code=SaleSiteByDivision, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:56.847 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 726.39 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:56.890 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 38.22 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:56.918 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.81 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:33:56.925 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.8 | p_from_date=20261009, p_offset_day=112, p_timezone=AS054 |
| 21:33:56.972 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 42.47 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:33:57.118 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 141.79 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:33:57.263 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 140.78 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 21:34:01.533 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 4.34 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Demand |
| 21:34:01.553 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 137 | 11.51 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20270129 |
| 21:34:01.618 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.72 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 21:34:01.630 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.79 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 21:34:02.077 | find | GSCM.SSP.Plan.WSL | SSP0006_GET_PROBLEM_REPORT | 0 | 402.97 | p_division_id=81, p_plant_site_id=-,EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P, p_sales_site_id=Aeonus_KR_GUN,Alte_KR_SEL,Alte_US_SFJ |
| 21:34:02.124 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 13.2 | p_menu_id=SSP0006, p_log_type=FIND, p_log_cnt=, p_db_time=0.447, p_ui_time=0.027, p_user_id=jaeuk.shin |
| 21:34:07.937 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.22 | MenuID=Plan Problem (SSP), CnntCode=0104002, UserID=jaeuk.shin |

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
| Model | txtItemId |  |
| layoutControlItem2 | btnItem_Id |  |
| Plan type* | cboPlanType | Y |
| layoutControlItem4 | btnProject |  |
| Bucket | cboBucketType |  |
| Period* | drpPeriod | Y |
| Electrode | clbElectrode |  |
| layoutControlItem8 | chkSum |  |

## 그리드

- spdMain / Demand: 행 0 · 컬럼 157(보임 121) · 헤더 3단 · 고정 컬럼 20
- spdPeggingInfo / Pegging Info: 행 0 · 컬럼 17(보임 11) · 헤더 1단 · 고정 컬럼 0
- spdPlanProblem / Plan Problem: 행 0 · 컬럼 7(보임 6) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
