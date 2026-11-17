# AS-IS 실측 요약 — SCP0097

- 실행: 2026-11-12 22:48:13.483 ~ 2026-11-12 22:48:50.321 · 계정 jaeuk.shin · 상태 OK
- 화면: SCP BOM(Elec) (GSCM.SCP.Master.UIL.SCP0097_SCP_BOM_Elec)
- 조회 결과: Total : 8,926 · DB : 17.095s, UI : 0.102s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:48:13.833 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.38 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:48:13.866 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0097 |
| 22:48:13.889 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.41 | USER_ID= |
| 22:48:13.976 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.4 | p_program_id=SCP0097, p_user_id=jaeuk.shin, p_sheet_name=SCP BOM Elec |
| 22:48:14.128 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 0 | 300017.59 | Code=GLOBAL_PSI_ELEC_DATE1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:48:16.492 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 2479.81 | MenuID=SCP BOM(Elec), CnntCode=0104001, UserID=jaeuk.shin |
| 22:48:16.582 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.05 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0097 |
| 22:48:25.623 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.15 | p_program_id=SCP0097, p_user_id=jaeuk.shin, p_sheet_name=SCP BOM Elec |
| 22:48:42.596 | find | GSCM.SCP.Master.WSL | SCP0097_GET_SCP_BOM_ELEC | 8926 | 16953.21 | p_division_id=81, p_parent_id=, p_child_id=, debug_mode=F |
| 22:48:42.900 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 59.23 | p_menu_id=SCP0097, p_log_type=FIND, p_log_cnt=8926, p_db_time=17.095, p_ui_time=0.102, p_user_id=jaeuk.shin |
| 22:48:49.482 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.63 | MenuID=SCP BOM(Elec), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Parent Item | txtParentID |  |
| Child Item | txtChildID |  |

## 그리드

- spdMain / SCP BOM Elec: 행 8926 · 컬럼 15(보임 13) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
