# AS-IS 실측 요약 — SSP0008

- 실행: 2026-11-13 00:39:30.548 ~ 2026-11-13 00:40:16.722 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Plan Line(SSP) (GSCM.SSP.Plan.UIL.SSP0008_ProductionPlanLine)
- 조회 결과: Total :  · DB : 17.355s, UI : 0.112s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:39:30.825 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.33 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:39:30.833 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.96 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:30.876 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.44 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0008 |
| 00:39:30.900 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.06 | USER_ID= |
| 00:39:31.064 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.26 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:39:31.079 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 4.94 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:31.905 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 813.48 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:32.041 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 122.82 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:32.183 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 127.29 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:32.283 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 127 | 92.7 | Code=LineByOperation, Param1=40, Param2=, Param3=, Param4=, Param5=CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02265100_40_KR-P,KR02265100_40-P,KR03346900_40-P,KR04595000_40-P,KR40408500_40-P |
| 00:39:32.348 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.59 |  |
| 00:39:32.366 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.11 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 00:39:32.390 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.64 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20270107 |
| 00:39:32.414 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 17.51 | p_program_id=SSP0008, p_user_id=jaeuk.shin, p_sheet_name=Line |
| 00:39:32.577 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 98.92 | MenuID=Production Plan Line(SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 00:39:32.701 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.25 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0008 |
| 00:39:40.400 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.61 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:39:40.417 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 5.09 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:40.529 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 266 | 92.42 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, TimeZone=AS054 |
| 00:39:40.591 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 5.0 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:41.295 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 697.43 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:41.335 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.23 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:41.393 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 48.48 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:39:41.408 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.53 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 00:39:41.441 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.17 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:41.476 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.15 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:39:41.517 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.3 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:39:41.618 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 266 | 91.53 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, TimeZone=AS054 |
| 00:39:43.900 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.14 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:39:43.911 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 4.84 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:44.017 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 127 | 91.09 | Code=LineByOperation, Param1=40, Param2=, Param3=, Param4=, Param5=CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02265100_40_KR-P,KR02265100_40-P,KR03346900_40-P,KR04595000_40-P,KR40408500_40-P |
| 00:39:44.066 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 5.02 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:44.773 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 693.83 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:44.910 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 131.71 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:45.044 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 129.33 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:45.143 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 127 | 93.59 | Code=LineByOperation, Param1=40, Param2=, Param3=, Param4=, Param5=CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02265100_40_KR-P,KR02265100_40-P,KR03346900_40-P,KR04595000_40-P,KR40408500_40-P |
| 00:39:47.676 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.49 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:39:47.689 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.89 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:47.791 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 266 | 89.88 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, TimeZone=AS054 |
| 00:39:47.894 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.78 | Code=PlantByDivisionOperation, Param1=81, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:48.566 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 662.64 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:48.595 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.6 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:48.623 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 22.4 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:39:48.631 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.11 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 00:39:48.659 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.24 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:39:48.686 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 22.66 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:39:48.715 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 25.08 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 00:39:48.821 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 266 | 99.39 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, TimeZone=AS054 |
| 00:39:52.814 | find | GSCM.SSP.Plan.WSL | SSP0008_GET_PLAN_EDIT_INFO | 0 | 11.4 | p_division_id=81, p_operation_group=P, p_scm_site_id=, p_line_id=-,A1A02,A1A03,A1A04,A1A05,A1A07,A1A08,A1AP1,A1AP2,A1AP3,A2A10,A2A11,A2A13,A2A14,A2AP1,A2AP3,A2AP4,A2AP5,A3A01,A3A02,A3A03,A3A04,A3A05,A3A06,A3A07,A3A08,A4A01,A4A02,A4A03,A4A04,A4A05,A4A06,A4A07,A5A01,A5A02,A5A03,A6A04,A6A05,A6A06,A6A07 |
| 00:39:52.868 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.54 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261203 |
| 00:39:52.879 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 3.6 | p_program_id=SSP0008, p_user_id=jaeuk.shin, p_sheet_name=Line |
| 00:40:10.192 | find | GSCM.SSP.Plan.WSL | SSP0008_GET_PRODUCTION_PLAN_LINEBY | 0 | 17247.59 | p_division_id=81, p_operation_group=P, p_scm_site_id=, p_line_id=-,A1A02,A1A03,A1A04,A1A05,A1A07,A1A08,A1AP1,A1AP2,A1AP3,A2A10,A2A11,A2A13,A2A14,A2AP1,A2AP3,A2AP4,A2AP5,A3A01,A3A02,A3A03,A3A04,A3A05,A3A06,A3A07,A3A08,A4A01,A4A02,A4A03,A4A04,A4A05,A4A06,A4A07,A5A01,A5A02,A5A03,A6A04,A6A05,A6A06,A6A07 |
| 00:40:10.416 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.56 | p_menu_id=SSP0008, p_log_type=FIND, p_log_cnt=, p_db_time=17.355, p_ui_time=0.112, p_user_id=jaeuk.shin |
| 00:40:15.591 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.66 | MenuID=Production Plan Line(SSP), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan type* | cboPlanType | Y |
| Plan date* | cboPlanDate | Y |
| Div* | cboDivision | Y |
| Operation Group* | cboOperationGroup | Y |
| Period* | drpPeriod | Y |
| Seq* | cboPlanSeq | Y |
| Plant Site | clbPlantSite |  |
| Bucket | cboBucketType |  |
| Line | clbLine |  |
| Model | txtItemId |  |
| layoutControlItem4 | btnItemId |  |
| Fix | btnFix |  |
| Unfix | btnUnfix |  |
| Electrode | clbElectrode |  |
| Nick Name | txtNickName |  |
| layoutControlItem8 | chkSum |  |
| layoutControlItem14 | btnMeasure |  |

## 그리드

- spdMain / Line: 행 0 · 컬럼 93(보임 19) · 헤더 3단 · 고정 컬럼 23

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
