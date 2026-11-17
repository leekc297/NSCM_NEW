# AS-IS 실측 요약 — SCP0111

- 실행: 2026-11-12 22:54:00.829 ~ 2026-11-12 22:54:50.963 · 계정 jaeuk.shin · 상태 OK
- 화면: Integration PSI (GSCM.SCP.Analysis.UIL.SCP0111_IntegrationPSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:54:01.236 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.66 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:54:01.434 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 193.06 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:54:01.575 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 132.72 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:54:01.723 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 139.89 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:54:01.736 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.47 | Code=LookupCommon, Param1=INTEGRATION_PSI_DEFAULT_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:54:01.806 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1358 | 65.34 | Code=LineByOperationPlantId, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:54:01.908 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.32 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 22:54:01.932 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.19 | USER_ID= |
| 22:54:02.640 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 583.11 | Code=SCPPlanPeriod, Param1=20260817, Param2=81, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:54:02.791 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 147.68 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:54:02.805 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 4.66 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:54:02.897 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.87 |  |
| 22:54:02.915 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.17 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 22:54:02.946 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 4.47 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:54:04.990 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1977.64 | MenuID=Integration PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 22:54:05.019 | load | GSCM.SCP.Analysis.WSL | SCP0111_GET_ESS_PACK_LINE | 32 | 2013.76 |  |
| 22:54:05.427 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.32 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 22:54:15.697 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.12 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 22:54:15.730 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 4.36 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Cell Model | txtCellItemId |  |
| Plan date* | cboPlanDate | Y |
| layoutControlItem3 | btnNickName |  |
| Model | txtItemId |  |
| layoutControlItem1 | btnItemId |  |
| layoutControlItem4 | btnCellItem_Id |  |
| Nick Name | txtNickName |  |
| Period | cmbFromMonth |  |
| Plan type | cboPlanType |  |
| ~ | cmbToMonth |  |
| layoutControlItem6 | chkQty |  |

## 그리드

- spdMain / Integration PSI: 행 0 · 컬럼 29(보임 28) · 헤더 1단 · 고정 컬럼 19

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
