# AS-IS 실측 요약 — SSP0011

- 실행: 2026-11-12 20:48:29.752 ~ 2026-11-12 20:49:19.246 · 계정 jaeuk.shin · 상태 OK
- 화면: PSI (SSP) (GSCM.SSP.Plan.UIL.SSP0011_PSI)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:48:30.077 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.3 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:48:30.084 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 2.99 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:48:30.117 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0011 |
| 20:48:30.140 | load | GSCM.BizService.WSL | SELECT * | 874 | 17.92 | USER_ID= |
| 20:48:30.317 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.19 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:48:30.326 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 29 | 4.86 | Code=PlantByDivisionOperation, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:48:31.051 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 703.5 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:48:31.180 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 123.45 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:48:31.307 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 123.41 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:48:31.320 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.63 |  |
| 20:48:31.335 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.76 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 20:48:31.359 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.0 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270106 |
| 20:48:31.368 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.72 | p_program_id=SSP0011, p_user_id=jaeuk.shin, p_sheet_name=PSI |
| 20:48:31.386 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.37 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270106 |
| 20:48:31.559 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 136.7 | MenuID=PSI (SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 20:48:31.630 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.47 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0011 |
| 20:49:18.552 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.66 | MenuID=PSI (SSP), CnntCode=0104002, UserID=jaeuk.shin |

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

## 대화상자

- 2026-11-12 20:48:40.459 [GSCM] Plan date* 값은 필수 입력입니다 → default_button(id=1)
