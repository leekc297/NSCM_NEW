# AS-IS 실측 요약 — SCP0027

- 실행: 2026-11-12 19:57:34.387 ~ 2026-11-12 19:58:25.709 · 계정 jaeuk.shin · 상태 OK
- 화면: ProjectRoute (Electrode) (GSCM.SCP.Master.UIL.SCP0027_ProjectRoute_Electrode)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:57:34.809 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.42 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:57:34.818 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 5.47 | Code=PlantSiteByDivision1Ex, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:57:35.272 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 6533 | 450.91 | Code=ElecRoutePlantByOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:57:35.342 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0027 |
| 19:57:35.364 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.08 | USER_ID= |
| 19:57:35.424 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.24 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:57:35.459 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 4.54 | Code=PERIOD_DEFAULT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:57:35.691 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 226.55 | p_program_id=SCP0027, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 19:57:37.614 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1887.91 | MenuID=ProjectRoute (Electrode), CnntCode=0104001, UserID=jaeuk.shin |
| 19:57:37.869 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.88 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0027 |
| 19:57:45.721 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 31 | 6.86 | p_program_id=SCP0027, p_user_id=jaeuk.shin, p_sheet_name=Main |
| 19:57:53.428 | find | GSCM.SCP.Analysis.WSL | SCP0010_GET_SHIPMENT_PLAN_SEMI | 0 | 900014.79 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=82, p_operation_group=P, p_item_id=, p_electype=, p_plan_start_yyyymmdd=20260824, p_plan_type=FN, p_seq=1, p_fromsite=, p_tosite=, p_program_id=SCP0010, p_sheet_name=ELECTRODE, p_user_id=jaeuk.shin, debug_mode=F |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| layoutControlItem11 | btnItemId |  |
| Valid | cboValid |  |
| Operation Group | cboOperationGroup |  |
| Model | txtItemId |  |
| Div | clbDivision |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 32(보임 14) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
