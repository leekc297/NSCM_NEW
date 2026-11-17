# AS-IS 실측 요약 — SSP0010

- 실행: 2026-11-12 20:47:39.682 ~ 2026-11-12 20:48:29.599 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Plan SEMI (SSP) (GSCM.SSP.Plan.UIL.SSP0010_Shipment_Plan_SEMI)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:47:39.993 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.67 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:47:40.007 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 10.49 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:47:40.043 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0010 |
| 20:47:40.067 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.6 | USER_ID= |
| 20:47:40.201 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.51 | Code=LookupCommon, Param1=OPERATION_GROUP_SEMI, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:47:40.875 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 664.14 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:47:41.005 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 125.41 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:47:41.134 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 124.08 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:47:41.149 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.12 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 20:47:41.156 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.84 |  |
| 20:47:41.179 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.72 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270106 |
| 20:47:41.220 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 24 | 37.46 | p_program_id=SSP0010, p_user_id=jaeuk.shin, p_sheet_name=Shipment Plan SEMI |
| 20:47:41.659 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 354.19 | MenuID=Shipment Plan SEMI (SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 20:47:41.724 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0010 |
| 20:48:28.954 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.28 | MenuID=Shipment Plan SEMI (SSP), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Operation Group* | cboOperGroup | Y |
| Model | txtItemId |  |
| layoutControlItem3 | btnMeasure |  |
| Bucket | cboBucketType |  |
| layoutControlItem4 | btnItem_Id |  |
| Plan date* | cboPlanDate | Y |
| Plan type* | cboPlanType | Y |
| Seq* | cboPlanSeq | Y |
| Period* | drpPeriod | Y |
| layoutControlItem2 | chkSum |  |
| Fix | btnFix |  |
| Unfix | btnUnfix |  |
| Electrode | clbElectrode |  |

## 그리드

- spdMain / Shipment Plan SEMI: 행 0 · 컬럼 95(보임 66) · 헤더 3단 · 고정 컬럼 15

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 20:47:50.575 [GSCM] Plan date 값은 필수 입력입니다 → default_button(id=1)
