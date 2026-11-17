# AS-IS 실측 요약 — SCP0040

- 실행: 2026-11-12 20:04:36.014 ~ 2026-11-12 20:04:56.007 · 계정 jaeuk.shin · 상태 OK
- 화면: Characteristic Capacity (GSCM.SCP.Master.UIL.SCP0040_CharacteristicCapacity)
- 조회 결과: Total : 2,087 · DB : 1.776s, UI : 0.088s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:04:36.371 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.98 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:04:36.662 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.16 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0040 |
| 20:04:36.688 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.89 | USER_ID= |
| 20:04:36.813 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 7 | 3.66 | Code=AllPlantByOperation, Param1=81, Param2=A, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:04:36.842 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 3.52 | p_program_id=SCP0040, p_user_id=jaeuk.shin, p_sheet_name=Characteristic Capacity |
| 20:04:39.778 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 2849.53 | MenuID=Characteristic Capacity, CnntCode=0104001, UserID=jaeuk.shin |
| 20:04:40.056 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0040 |
| 20:04:40.267 | load | GSCM.SCP.Master.WSL | SCP0039_GET_VALIDATION_YIELD | 0 | 29983.66 | p_division_id=81, p_search_type=, p_plan_group_id=, p_item_id= |
| 20:04:47.641 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 4.43 | p_program_id=SCP0040, p_user_id=jaeuk.shin, p_sheet_name=Characteristic Capacity |
| 20:04:49.399 | find | GSCM.SCP.Master.WSL | SCP0040_GET_CHARACTERISTIC_CAPA | 2087 | 1664.66 | p_division_id=81, p_plant_site_id=HQ07-A,HQ11-A,MI00-A,MI02-A,NA00-A,NB01-A,WA00-A, p_item_id= |
| 20:04:49.618 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 103.77 | p_menu_id=SCP0040, p_log_type=FIND, p_log_cnt=2087, p_db_time=1.776, p_ui_time=0.088, p_user_id=jaeuk.shin |
| 20:04:54.694 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.62 | MenuID=Characteristic Capacity, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Plant Site | clbPlantSite |  |
| Material | txtItemId |  |
| layoutControlItem4 | btnItemId |  |

## 그리드

- spdMain / Characteristic Capacity: 행 2087 · 컬럼 12(보임 11) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
