# AS-IS 실측 요약 — SSP0006

- 실행: 2026-11-12 22:57:22.582 ~ 2026-11-12 22:58:03.104 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Problem (SSP) (GSCM.SSP.Plan.UIL.SSP0006_Plan_Problem)
- 조회 결과: Total :  · DB : 0.109s, UI : 0.028s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:57:22.914 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 4.35 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:57:22.923 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.37 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:22.983 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0006 |
| 22:57:23.006 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.65 | USER_ID= |
| 22:57:23.140 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.08 |  |
| 22:57:23.153 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 2.96 | Code=LookupCommon, Param1=PROBLEM_LIST, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:23.164 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 3.76 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:57:23.179 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1294 | 13.06 | Code=SaleSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:26.035 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 2731.81 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:26.180 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 138.06 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:26.325 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 137.87 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:26.385 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 37.99 | p_from_date=, p_offset_day=112, p_timezone=AS054 |
| 22:57:26.926 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 519.85 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Demand |
| 22:57:27.002 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 137 | 50.13 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270304 |
| 22:57:27.134 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 21.32 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 22:57:27.202 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 40.38 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 22:57:28.889 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1668.67 | MenuID=Plan Problem (SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 22:57:29.492 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.85 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0006 |
| 22:57:39.344 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 28 | 5.0 | Code=PlantSiteByDivision, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:57:39.363 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 9.52 | Code=SaleSiteByDivision, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:40.198 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 678.73 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:40.237 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 26.06 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:40.281 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 31.23 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:57:40.306 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.59 | p_from_date=20261009, p_offset_day=112, p_timezone=AS054 |
| 22:57:40.346 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 27.14 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:40.381 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.11 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:57:40.420 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 27.27 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:57:44.112 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 7.88 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:57:44.132 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1294 | 12.55 | Code=SaleSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:44.997 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 668.18 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:45.133 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 126.98 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:45.275 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 128.41 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:48.859 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 28 | 4.3 | Code=PlantSiteByDivision, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:57:48.872 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 6.97 | Code=SaleSiteByDivision, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:49.738 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 715.45 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:49.775 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 25.63 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:49.812 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.92 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:57:49.827 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.14 | p_from_date=20261009, p_offset_day=112, p_timezone=AS054 |
| 22:57:49.860 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.12 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:57:49.895 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.16 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:57:49.929 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.62 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:57:55.083 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 3.88 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Demand |
| 22:57:55.101 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 137 | 9.2 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20270129 |
| 22:57:55.162 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.86 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 22:57:55.174 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.79 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 22:57:55.276 | find | GSCM.SSP.Plan.WSL | SSP0006_GET_PROBLEM_REPORT | 0 | 61.54 | p_division_id=81, p_plant_site_id=-,EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P, p_sales_site_id=Aeonus_KR_GUN,Alte_KR_SEL,Alte_US_SFJ |
| 22:57:55.508 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 187.1 | p_menu_id=SSP0006, p_log_type=FIND, p_log_cnt=, p_db_time=0.109, p_ui_time=0.028, p_user_id=jaeuk.shin |
| 22:58:01.934 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.54 | MenuID=Plan Problem (SSP), CnntCode=0104002, UserID=jaeuk.shin |

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
