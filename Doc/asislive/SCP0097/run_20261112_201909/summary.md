# AS-IS 실측 요약 — SCP0097

- 실행: 2026-11-12 20:19:09.510 ~ 2026-11-12 20:19:50.806 · 계정 jaeuk.shin · 상태 OK
- 화면: SCP BOM(Elec) (GSCM.SCP.Master.UIL.SCP0097_SCP_BOM_Elec)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:19:09.950 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.28 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:19:10.241 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.99 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0097 |
| 20:19:10.267 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.62 | USER_ID= |
| 20:19:10.409 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.05 | p_program_id=SCP0097, p_user_id=jaeuk.shin, p_sheet_name=SCP BOM Elec |
| 20:19:10.899 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 387.14 | MenuID=SCP BOM(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 20:19:10.999 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.53 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0097 |
| 20:19:19.021 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.89 | p_program_id=SCP0097, p_user_id=jaeuk.shin, p_sheet_name=SCP BOM Elec |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Parent Item | txtParentID |  |
| Child Item | txtChildID |  |

## 그리드

- spdMain / SCP BOM Elec: 행 0 · 컬럼 14(보임 13) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
