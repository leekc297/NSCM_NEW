# AS-IS 실측 요약 — SCP0111

- 실행: 2026-11-12 20:34:58.646 ~ 2026-11-12 20:35:54.314 · 계정 jaeuk.shin · 상태 OK
- 화면: Integration PSI (GSCM.SCP.Analysis.UIL.SCP0111_IntegrationPSI)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:34:58.967 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.16 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:35:01.925 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 2950.71 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:35:04.324 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 2395.41 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:35:04.500 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 162.6 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:35:04.755 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 247.4 | Code=LookupCommon, Param1=INTEGRATION_PSI_DEFAULT_PERIOD, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:35:04.826 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1358 | 68.25 | Code=LineByOperationPlantId, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:35:05.188 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 20:35:05.214 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.32 | USER_ID= |
| 20:35:07.331 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 1895.14 | Code=SCPPlanPeriod, Param1=20260817, Param2=81, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:35:08.945 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 1605.01 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:35:08.958 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 20 | 4.18 | Code=CalendarMonth, Param1=202608, Param2=202803, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:35:09.006 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.61 |  |
| 20:35:09.503 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 482.16 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 20:35:09.547 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 3.34 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:35:11.204 | load | GSCM.SCP.Analysis.WSL | SCP0111_GET_ESS_PACK_LINE | 32 | 1594.75 |  |
| 20:35:13.141 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 3410.86 | MenuID=Integration PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 20:35:13.616 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.88 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0111 |
| 20:35:22.453 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 4.36 | p_program_id=SCP0111, p_user_id=jaeuk.shin, p_sheet_name=Integration PSI |
| 20:35:22.473 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 4.14 | Code=CalendarMonth, Param1=202608, Param2=202701, Param3=, Param4=, Param5=, TimeZone=AS054 |

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
