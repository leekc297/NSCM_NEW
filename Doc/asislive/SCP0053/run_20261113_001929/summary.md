# AS-IS 실측 요약 — SCP0053

- 실행: 2026-11-13 00:19:29.780 ~ 2026-11-13 00:21:27.857 · 계정 jaeuk.shin · 상태 OK
- 화면: SCP BOM (Cell~Pack) (GSCM.SCP.Master.UIL.SCP0053_SCPBOM)
- 조회 결과: Total : 24,551 · DB : 100.755s, UI : 0.191s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:19:30.063 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.76 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:19:30.098 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.75 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0053 |
| 00:19:30.121 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.17 | USER_ID= |
| 00:19:32.110 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 11 | 1892.15 | Code=PlantByDivisionAll, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:19:32.156 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 34.38 | p_program_id=SCP0053, p_user_id=jaeuk.shin, p_sheet_name=SCP BOM |
| 00:19:32.172 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 4.1 | Code=SEQ_NUMBER, Param1=20, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:19:32.442 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 248.03 | MenuID=SCP BOM (Cell~Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 00:19:32.602 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 89.74 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0053 |
| 00:19:40.902 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.07 | p_program_id=SCP0053, p_user_id=jaeuk.shin, p_sheet_name=SCP BOM |
| 00:19:40.935 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 3.84 | Code=SEQ_NUMBER, Param1=20, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:21:21.190 | find | GSCM.SCP.Master.WSL | SCP0053_GET_SCP_BOM | 24551 | 100237.75 | p_division_id=81, p_plant_site_id=, p_model_id=, p_parent_id=, p_child_id=, p_alter_bom=ALL, debug_mode=F |
| 00:21:21.900 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.48 | p_menu_id=SCP0053, p_log_type=FIND, p_log_cnt=24551, p_db_time=100.755, p_ui_time=0.191, p_user_id=jaeuk.shin |
| 00:21:26.751 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.59 | MenuID=SCP BOM (Cell~Pack), CnntCode=0104002, UserID=jaeuk.shin |

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

- spdMain / SCP BOM: 행 24551 · 컬럼 20(보임 18) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
