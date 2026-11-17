# AS-IS 실측 요약 — SCP0110

- 실행: 2026-11-12 22:52:54.902 ~ 2026-11-12 22:54:00.384 · 계정 jaeuk.shin · 상태 OK
- 화면: Demand Group Master (GSCM.SCP.Master.UIL.SCP0110_GroupModelMapping)
- 조회 결과: Total : 2,774 · DB : 0.12s, UI : 0.027s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:52:55.279 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 24.12 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:52:55.344 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1724 | 56.1 | Code=LineByOperation2, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:53:02.226 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 353 | 6846.51 | Code=GroupMaster, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:53:02.859 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.38 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0110 |
| 22:53:02.887 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.15 | USER_ID= |
| 22:53:03.182 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.37 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:53:16.515 | load | GSCM.SCP.Master.WSL | SCP0110_GET_MODEL_LIST | 7528 | 13286.99 | p_division_id=81, p_operation_group=, p_group_name=, p_project_id=, p_item_id=, p_group_id= |
| 22:53:24.405 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 5 | 7795.0 | p_program_id=SCP0110, p_user_id=jaeuk.shin, p_sheet_name=Group Name |
| 22:53:24.432 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.87 | Code=LookupCommon, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:53:24.484 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 5 | 4.36 | p_program_id=SCP0110, p_user_id=jaeuk.shin, p_sheet_name=Model List |
| 22:53:24.526 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 353 | 11.4 | Code=GroupMaster, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:53:24.637 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 966 | 88.23 | Code=LineByOperation, Param1=81, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:53:40.572 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 15646.15 | MenuID=Demand Group Master, CnntCode=0104001, UserID=jaeuk.shin |
| 22:53:40.890 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.58 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0110 |
| 22:53:50.788 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 5 | 3.86 | p_program_id=SCP0110, p_user_id=jaeuk.shin, p_sheet_name=Group Name |
| 22:53:50.796 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.31 | Code=LookupCommon, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:53:52.472 | find | GSCM.SCP.Master.WSL | SCP0110_GET_GROUP_MASTER | 79 | 1648.06 | p_division_id=81, p_group_name=, p_operation_group=P |
| 22:53:52.587 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 5 | 4.24 | p_program_id=SCP0110, p_user_id=jaeuk.shin, p_sheet_name=Model List |
| 22:53:52.600 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 353 | 5.88 | Code=GroupMaster, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:53:52.700 | find | GSCM.SCP.Master.WSL | SCP0110_GET_MODEL_LIST | 2774 | 91.86 | p_division_id=81, p_operation_group=P, p_group_name=, p_project_id=, p_item_id=, p_group_id= |
| 22:53:52.822 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 61.01 | p_menu_id=SCP0110, p_log_type=FIND, p_log_cnt=2774, p_db_time=0.12, p_ui_time=0.027, p_user_id=jaeuk.shin |
| 22:53:59.408 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.57 | MenuID=Demand Group Master, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Operation Group | cboOperationGroup |  |
| Group Name | txtGroupName |  |
| Project | txtProject |  |
| Model | txtItemId |  |
| layoutControlItem6 | btnProject |  |
| layoutControlItem9 | btnItemId |  |

## 그리드

- spdMain / Group Name: 행 79 · 컬럼 6(보임 5) · 헤더 1단 · 고정 컬럼 0
- spdSub / Model List: 행 2774 · 컬럼 6(보임 5) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
