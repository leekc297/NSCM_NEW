# AS-IS 실측 요약 — SCP0110

- 실행: 2026-11-12 20:32:02.017 ~ 2026-11-12 20:34:42.584 · 계정 jaeuk.shin · 상태 ERROR
- 화면: Demand Group Master (GSCM.SCP.Master.UIL.SCP0110_GroupModelMapping)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:32:02.409 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.66 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:32:02.469 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1724 | 55.34 | Code=LineByOperation2, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:32:03.484 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 353 | 992.7 | Code=GroupMaster, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:32:03.589 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.17 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0110 |
| 20:32:03.614 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.12 | USER_ID= |
| 20:32:03.688 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.64 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:32:33.721 | load | GSCM.SCP.Master.WSL | SCP0110_GET_MODEL_LIST | 0 | 30021.94 | p_division_id=81, p_operation_group=, p_group_name=, p_project_id=, p_item_id=, p_group_id= |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Division | cboDivision |  |
| Operation Group | cboOperationGroup |  |
| Group Name | txtGroupName |  |
| Project | txtProject |  |
| Model | txtItemId |  |
| layoutControlItem4 | btnProject |  |
| layoutControlItem4 | btnItemId |  |

## 그리드


> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
