# AS-IS 실측 요약 — SSP0009

- 실행: 2026-11-12 20:46:49.298 ~ 2026-11-12 20:47:39.552 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan FG(SSP) (GSCM.SSP.Plan.UIL.SSP0009_Shipment_Plan_FG)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:46:49.569 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.2 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:46:49.577 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.7 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:46:49.636 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0009 |
| 20:46:49.667 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.07 | USER_ID= |
| 20:46:49.817 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.23 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:46:50.481 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 655.68 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:46:50.616 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 128.39 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:46:50.773 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 128.39 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:46:50.786 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.91 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 20:46:50.794 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.26 |  |
| 20:46:50.822 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.85 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270106 |
| 20:46:50.856 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 29.24 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 20:46:50.894 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.71 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 20:46:50.905 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.8 | p_program_id=SSP0009, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 20:46:51.241 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 312.61 | MenuID=Shipment Plan FG(SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 20:46:51.328 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.1 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0009 |
| 20:47:38.849 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.35 | MenuID=Shipment Plan FG(SSP), CnntCode=0104002, UserID=jaeuk.shin |

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

## 대화상자

- 2026-11-12 20:47:00.938 [GSCM] Plan date 값은 필수 입력입니다 → default_button(id=1)
