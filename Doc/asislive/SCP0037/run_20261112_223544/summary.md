# AS-IS 실측 요약 — SCP0037

- 실행: 2026-11-12 22:35:44.810 ~ 2026-11-12 22:36:38.929 · 계정 jaeuk.shin · 상태 OK
- 화면: Operation LT (GSCM.SCP.Master.UIL.SCP0037_OperationLT)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:35:45.239 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.66 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:35:45.250 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.89 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:35:45.258 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 83 | 5.16 | Code=PlantSiteByDivision, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:35:45.266 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.0 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:35:46.446 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 1176.94 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:35:46.459 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 5.77 | Code=PlantByDivisionOperOsp21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:35:46.775 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 22:35:46.802 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.15 | USER_ID= |
| 22:35:48.288 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 1313.57 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 22:35:48.303 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 6.35 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:35:48.313 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.54 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:35:53.498 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5074.86 | MenuID=Operation LT, CnntCode=0104001, UserID=jaeuk.shin |
| 22:35:55.121 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 22:36:04.154 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.73 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 22:36:04.164 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 5.6 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:36:04.172 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.27 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| Div | cboDivision |  |
| Site Item Valid | cboValid |  |
| Material | txtItemId |  |
| layoutControlItem5 | btnItemId |  |
| LT Operation | cboLTOperation |  |

## 그리드

- spdMain / Operation LT: 행 0 · 컬럼 14(보임 12) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
