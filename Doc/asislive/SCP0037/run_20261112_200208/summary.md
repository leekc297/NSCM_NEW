# AS-IS 실측 요약 — SCP0037

- 실행: 2026-11-12 20:02:08.613 ~ 2026-11-12 20:02:51.230 · 계정 jaeuk.shin · 상태 OK
- 화면: Operation LT (GSCM.SCP.Master.UIL.SCP0037_OperationLT)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:02:08.959 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.26 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:02:08.971 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.46 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:02:08.979 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 83 | 4.2 | Code=PlantSiteByDivision, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:08.987 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.13 | Code=PlantByDivisionOperNonOsp1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:02:08.994 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.18 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:09.004 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 29 | 4.31 | Code=PlantByDivisionOperOsp21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:02:09.038 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 20:02:09.061 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.31 | USER_ID= |
| 20:02:09.247 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 91.35 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 20:02:09.262 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 6.01 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:09.270 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.12 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:11.038 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1739.25 | MenuID=Operation LT, CnntCode=0104001, UserID=jaeuk.shin |
| 20:02:11.395 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.73 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0037 |
| 20:02:19.191 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.24 | p_program_id=SCP0037, p_user_id=jaeuk.shin, p_sheet_name=Operation LT |
| 20:02:19.203 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 6.85 | Code=PlantByDivisionOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:02:19.213 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.2 | Code=LookupCommon, Param1=OPERATION_LT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |

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
