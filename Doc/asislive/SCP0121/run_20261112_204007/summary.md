# AS-IS 실측 요약 — SCP0121

- 실행: 2026-11-12 20:40:07.884 ~ 2026-11-12 20:40:24.492 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Group Master (GSCM.SCP.Master.UIL.SCP0121_PlanGroupMaster)
- 조회 결과: Total : 241 · DB : 1.269s, UI : 0.007s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:40:08.235 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 25.73 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:08.286 | load | GSCM.SCP.Master.WSL | SCP0121_GET_SEARCH_INFO | 56 | 46.58 | p_user_id= |
| 20:40:08.323 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0121 |
| 20:40:08.347 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.01 | USER_ID= |
| 20:40:08.525 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 34.86 | p_program_id=SCP0121, p_user_id=jaeuk.shin, p_sheet_name=Plan Group Master |
| 20:40:08.536 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.36 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:08.871 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 311.56 | MenuID=Plan Group Master, CnntCode=0104001, UserID=jaeuk.shin |
| 20:40:08.913 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.31 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0121 |
| 20:40:16.921 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 11 | 3.8 | p_program_id=SCP0121, p_user_id=jaeuk.shin, p_sheet_name=Plan Group Master |
| 20:40:16.932 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.6 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:40:18.201 | find | GSCM.SCP.Master.WSL | SCP0121_GET_PLAN_GROUP_LINE | 241 | 1261.19 | p_division_id=81, p_operation_id=A9000,P5500,P9500, p_plant_id=, p_factory_id=, p_line_id=, p_plan_group_id= |
| 20:40:18.384 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 162.73 | p_menu_id=SCP0121, p_log_type=FIND, p_log_cnt=241, p_db_time=1.269, p_ui_time=0.007, p_user_id=jaeuk.shin |
| 20:40:23.842 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.61 | MenuID=Plan Group Master, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant | clbPlant |  |
| Line | clbLine |  |
| Plan Group | clbPlanGroup |  |
| Building | clbBuilding |  |
| Div | cboDivision |  |
| Plan Group Reg. | btnPlanGroupReg |  |
| Operation Group | clbOperation |  |

## 그리드

- spdMain / Plan Group Master: 행 241 · 컬럼 12(보임 11) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
