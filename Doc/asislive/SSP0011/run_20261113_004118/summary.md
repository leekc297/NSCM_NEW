# AS-IS 실측 요약 — SSP0011

- 실행: 2026-11-13 00:41:18.870 ~ 2026-11-13 00:41:47.485 · 계정 jaeuk.shin · 상태 OK
- 화면: PSI (SSP) (GSCM.SSP.Plan.UIL.SSP0011_PSI)
- 조회 결과: Total :  · DB : 0.652s, UI : 0.117s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:41:19.100 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.51 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:41:19.107 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.33 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:19.144 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.98 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0011 |
| 00:41:19.165 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.59 | USER_ID= |
| 00:41:19.322 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.03 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:41:19.331 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 29 | 6.46 | Code=PlantByDivisionOperation, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:20.004 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 655.8 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:20.152 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 130.19 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:20.296 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 124.59 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:20.328 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.13 |  |
| 00:41:20.385 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.13 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 00:41:20.410 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.29 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20270107 |
| 00:41:20.419 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.89 | p_program_id=SSP0011, p_user_id=jaeuk.shin, p_sheet_name=PSI |
| 00:41:20.460 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 10.02 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20270107 |
| 00:41:20.694 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 193.58 | MenuID=PSI (SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 00:41:20.792 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.81 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0011 |
| 00:41:28.648 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.35 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:41:28.657 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.51 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:28.669 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.69 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:29.398 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 713.55 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:29.436 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.29 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:29.474 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 25.17 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:41:29.485 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.84 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 00:41:29.515 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.54 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:29.546 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.32 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:41:29.577 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.85 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:41:32.065 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.8 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:41:32.080 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 5.69 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:32.102 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 5.82 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:32.826 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 660.58 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:32.967 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 126.42 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:33.107 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 127.21 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:35.703 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.2 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:41:35.712 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.84 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:35.724 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.79 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:36.396 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 656.3 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:36.427 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.68 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:36.457 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.24 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:41:36.466 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.93 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 00:41:36.493 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.26 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:41:36.529 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.08 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:41:36.563 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.63 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:41:40.481 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.28 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261203 |
| 00:41:40.489 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.57 | p_program_id=SSP0011, p_user_id=jaeuk.shin, p_sheet_name=PSI |
| 00:41:40.507 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.27 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261203 |
| 00:41:41.171 | find | GSCM.SSP.Plan.WSL | SSP0011_GET_PSI | 0 | 533.85 | p_from_yyyymmdd=20261009, p_to_yyyymmdd=20261203, p_division_id=81, p_operation_group=P, p_From_Site=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, p_item_id=, p_program_id=None, p_plan_start_yyyymmdd=20261009, p_plan_type=SP, p_seq=1, p_user_id=None, p_electrode_type= |
| 00:41:41.351 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 38.81 | p_menu_id=SSP0011, p_log_type=FIND, p_log_cnt=, p_db_time=0.652, p_ui_time=0.117, p_user_id=jaeuk.shin |
| 00:41:46.350 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.63 | MenuID=PSI (SSP), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan date* | cboPlanDate | Y |
| Operation Group | cboOperGroup |  |
| Model | txtItemId |  |
| layoutControlItem2 | btnItemId |  |
| From Site | clbFromSite |  |
| Div* | cboDivision | Y |
| Plan type* | cboPlanType | Y |
| Seq* | cboPlanSeq | Y |
| layoutControlItem1 | chkSum |  |
| Period* | drpPeriod | Y |
| Bucket | cboBucketType |  |
| Electrode | clbElectrode |  |

## 그리드

- spdMain / PSI: 행 0 · 컬럼 89(보임 64) · 헤더 3단 · 고정 컬럼 12

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
