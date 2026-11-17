# AS-IS 실측 요약 — SCP0053

- 실행: 2026-11-12 20:07:59.364 ~ 2026-11-12 20:08:42.124 · 계정 jaeuk.shin · 상태 OK
- 화면: SCP BOM (Cell~Pack) (GSCM.SCP.Master.UIL.SCP0053_SCPBOM)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:07:59.730 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.83 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:08:00.049 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0053 |
| 20:08:00.078 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.3 | USER_ID= |
| 20:08:02.239 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 11 | 1990.0 | Code=PlantByDivisionAll, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:08:02.289 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 29.82 | p_program_id=SCP0053, p_user_id=jaeuk.shin, p_sheet_name=SCP BOM |
| 20:08:02.309 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 3.82 | Code=SEQ_NUMBER, Param1=20, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:08:02.730 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 326.3 | MenuID=SCP BOM (Cell~Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 20:08:02.817 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.67 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0053 |
| 20:08:10.968 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.54 | p_program_id=SCP0053, p_user_id=jaeuk.shin, p_sheet_name=SCP BOM |
| 20:08:10.989 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 3.34 | Code=SEQ_NUMBER, Param1=20, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |

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
