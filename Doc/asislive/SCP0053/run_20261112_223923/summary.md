# AS-IS 실측 요약 — SCP0053

- 실행: 2026-11-12 22:39:23.628 ~ 2026-11-12 22:40:46.303 · 계정 jaeuk.shin · 상태 OK
- 화면: SCP BOM (Cell~Pack) (GSCM.SCP.Master.UIL.SCP0053_SCPBOM)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:39:23.950 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.44 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:39:24.308 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0053 |
| 22:39:24.337 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.5 | USER_ID= |
| 22:39:27.642 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 11 | 3168.28 | Code=PlantByDivisionAll, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:39:27.784 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 109.22 | p_program_id=SCP0053, p_user_id=jaeuk.shin, p_sheet_name=SCP BOM |
| 22:39:27.811 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 3.81 | Code=SEQ_NUMBER, Param1=20, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:39:29.022 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1074.98 | MenuID=SCP BOM (Cell~Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 22:39:29.199 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.81 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0053 |
| 22:39:38.795 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.86 | p_program_id=SCP0053, p_user_id=jaeuk.shin, p_sheet_name=SCP BOM |
| 22:39:38.811 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 3.46 | Code=SEQ_NUMBER, Param1=20, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:39:40.356 | find | GSCM.SCM.Master.WSL | SCP0006_GET_PROJECT_ROUTE_SITE | 163 | 1184369.48 | p_division_id=81, p_scm_site_id=, p_project_code=, p_item_id=, p_from_yyyymm=202611, p_to_yyyymm=202710, p_status=None, debug_mode=F |
| 22:39:55.916 | find | GSCM.SCP.Master.WSL | SCP0050_GET_CAPA_PIC | 39547 | 83551.0 | p_division_id=81, p_plant_id=, p_group_id=A,E,F,B,P, p_factory_id=, p_line_id=A1A02,A1A02-1,A1A02-2,A1A03,A1A04,A1A05,A1A06,A1A07,A1A08,A1AP1,A1AP2,A1AP3,A1AV1,A1AZ1,A1J04,A1J05,A1J06,A1J07,A1J08,A1J2A,A2A10,A2A11,A2A13,A2A14,A2AP1,A2AP3,A2AP4,A2AP5,A2AP5,A2AV1,A2AZ1,A2J10,A2J11,A2J13,A2J14,A2JP1,A3 |
| 22:40:13.826 | find | GSCM.SCP.Analysis.WSL | SCP0010_GET_SHIPMENT_PLAN_SEMI | 0 | 900016.62 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=82, p_operation_group=P, p_item_id=, p_electype=, p_plan_start_yyyymmdd=20260824, p_plan_type=FN, p_seq=1, p_fromsite=, p_tosite=, p_program_id=SCP0010, p_sheet_name=ELECTRODE, p_user_id=jaeuk.shin, debug_mode=F |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| Div* | cboDivision | Y |
| Model | txtModelID |  |
| layoutControlItem4 | btnItemId |  |
| Parent Item | txtParentID |  |
| Child Item | txtChildID |  |
| layoutControlItem7 | ucbAltBOM |  |

## 그리드

- spdMain / SCP BOM: 행 0 · 컬럼 19(보임 18) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
