# AS-IS 실측 요약 — SSP0009

- 실행: 2026-11-12 22:59:24.572 ~ 2026-11-12 23:03:25.452 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG(SSP) (GSCM.SSP.Plan.UIL.SSP0009_Shipment_Plan_FG)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "index": "1"}, {"name": "cboDivision", "index": "0"}, {"name": "cboDivision", "index": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:59:24.823 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.28 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:59:24.829 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.22 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:25.194 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.29 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0009 |
| 22:59:25.221 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.26 | USER_ID= |
| 22:59:25.447 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.09 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:59:26.158 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 702.62 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:26.296 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 131.86 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:26.432 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 132.66 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:26.446 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.69 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 22:59:26.452 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.65 |  |
| 22:59:26.491 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.12 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270106 |
| 22:59:26.673 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 170.65 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 22:59:26.721 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.37 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 22:59:26.733 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.24 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 22:59:28.302 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1476.6 | MenuID=Shipment Plan FG(SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 22:59:28.887 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.59 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0009 |
| 22:59:38.552 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.61 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:59:39.241 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 685.03 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:39.272 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.54 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:39.301 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.42 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:59:39.313 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.18 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 22:59:39.339 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.64 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:39.367 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 23.1 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:59:39.393 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 22.81 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:59:42.774 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.65 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:59:43.456 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 676.95 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:43.587 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 128.22 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:43.717 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 126.83 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:47.277 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 4.94 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:59:47.951 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 667.99 | Code=PlanDateShip, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:47.981 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 25.03 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:48.010 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.12 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:59:48.017 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.73 | p_from_date=20261009, p_offset_day=55, p_timezone=AS054 |
| 22:59:48.044 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.33 | Code=PlanTypeShip, Param1=81, Param2=20261009, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:59:48.073 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 24.6 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:59:48.104 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 26.37 | Code=PlanSeqShip, Param1=81, Param2=20261009, Param3=SP, Param4=, Param5=, TimeZone=AS054 |
| 22:59:53.283 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.61 | p_start_yyyymmdd=20261009, p_end_yyyymmdd=20261203 |
| 22:59:53.295 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 5.97 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 22:59:53.331 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.56 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 22:59:53.343 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.42 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 23:01:06.709 | find | GSCM.SSP.Plan.WSL | SSP0008_GET_PRODUCTION_PLAN_LINEBY | 0 | 152069.96 | p_division_id=81, p_operation_group=P, p_scm_site_id=, p_line_id=-,A1A02,A1A03,A1A04,A1A05,A1A07,A1A08,A1AP1,A1AP2,A1AP3,A2A10,A2A11,A2A13,A2A14,A2AP1,A2AP3,A2AP4,A2AP5,A3A01,A3A02,A3A03,A3A04,A3A05,A3A06,A3A07,A3A08,A4A01,A4A02,A4A03,A4A04,A4A05,A4A06,A4A07,A5A01,A5A02,A5A03,A6A04,A6A05,A6A06,A6A07 |
| 23:03:04.135 | find | GSCM.SCP.Analysis.WSL | SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL | 0 | 1800022.37 | p_division_id=81, p_operation_group=P, p_scm_site_id=, p_model_id=, p_item_id=, p_from_yyyymmdd=20260101, p_to_yyyymmdd=20261231, p_version_no=PP_W_20260817, p_program_id=SCP0017, p_sheet_name=MODEL, p_user_id=jaeuk.shin, p_electrode_type=, debug_mode=F, p_nick_name=, p_gap=N, p_line_id= |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Project | txtProject |  |
| layoutControlItem9 | chkSum |  |
| Operation Group* | cboBizType | Y |
| Div* | cboDivision | Y |
| layoutControlItem2 | btnProject |  |
| Model | txtItem_Id |  |
| Plan date* | cboPlanDate | Y |
| Plan type* | cboPlanType | Y |
| layoutControlItem4 | btnItem_Id |  |
| layoutControlItem1 | btnMeasure |  |
| Seq* | cboPlanSeq | Y |
| Period* | drpPeriod | Y |
| Unfix | btnUnfix |  |
| Fix | btnFix |  |
| layoutControlItem7 | btnColumn |  |
| Electrode | clbElectrode |  |
| Bucket | cboBucketType |  |

## 그리드

- spdMain / Shipment Request: 행 0 · 컬럼 102(보임 72) · 헤더 3단 · 고정 컬럼 32
- spdPeggingInfo / Pegging Info: 행 0 · 컬럼 17(보임 11) · 헤더 1단 · 고정 컬럼 0
- spdPlanProblem / Plan Problem: 행 0 · 컬럼 7(보임 6) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
