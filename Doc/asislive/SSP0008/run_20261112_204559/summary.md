# AS-IS 실측 요약 — SSP0008

- 실행: 2026-11-12 20:45:59.510 ~ 2026-11-12 20:46:49.165 · 계정 jaeuk.shin · 상태 OK
- 화면: Production Plan Line(SSP) (GSCM.SSP.Plan.UIL.SSP0008_ProductionPlanLine)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:45:59.806 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.42 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:45:59.812 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.28 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:45:59.852 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.28 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0008 |
| 20:45:59.876 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.25 | USER_ID= |
| 20:46:00.044 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.38 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:46:00.059 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 4.89 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:46:00.763 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 695.48 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:46:00.894 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 126.11 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:46:01.031 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 130.5 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:46:01.128 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 127 | 92.51 | Code=LineByOperation, Param1=40, Param2=, Param3=, Param4=, Param5=CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,HQ10-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02265100_40_KR-P,KR02265100_40-P,KR03346900_40-P,KR04595000_40-P,KR40408500_40-P |
| 20:46:01.160 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.78 |  |
| 20:46:01.176 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.51 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 20:46:01.243 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 57.17 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270106 |
| 20:46:01.278 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 30.84 | p_program_id=SSP0008, p_user_id=jaeuk.shin, p_sheet_name=Line |
| 20:46:01.640 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 308.97 | MenuID=Production Plan Line(SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 20:46:01.715 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.34 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0008 |
| 20:46:10.853 | find | GSCM.SSP.Plan.WSL | SSP0008_GET_PLAN_EDIT_INFO | 0 | 539.13 | p_division_id=40, p_operation_group=P, p_scm_site_id=, p_line_id=-,ELD13,FP_E7M01_A,FP_E7M01_C,FP_E7M02_A,FP_E7M02_C,FP_E7M03_A,FP_E7M03_C,FP_E7M04_A,FP_E7M04_C,FP_EED05_A,FP_EED05_C,FP_EED06_A,FP_EED06_C,FP_EED07_A,FP_EED07_C,FP_EHD08_A,FP_EHD08_C,FP_EHD09_A,FP_EHD09_C,FP_EHD10_A,FP_EHD10_C,FP_EKD1 |
| 20:46:48.441 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.53 | MenuID=Production Plan Line(SSP), CnntCode=0104002, UserID=jaeuk.shin |

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

## 대화상자

- 2026-11-12 20:46:10.833 [GSCM] Plan type* 값은 필수 입력입니다 → default_button(id=1)
