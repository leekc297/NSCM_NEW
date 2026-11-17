# AS-IS 실측 요약 — SCP0131

- 실행: 2026-11-14 19:37:20.957 ~ 2026-11-14 19:37:41.580 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Site Priority (GSCM.SCP.Master.UIL.SCP0131_SalesSitePriority)
- 조회 결과: Total : 61 · DB : 0.048s, UI : 0.085s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:37:21.473 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.64 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:37:22.063 | load | GSCM.SCP.Master.WSL | SCP0128_GET_SEARCH_INFO | 46 | 562.49 | p_division_id=81, p_site_id= |
| 19:37:23.884 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.53 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0131 |
| 19:37:23.913 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.97 | USER_ID= |
| 19:37:24.113 | load | GSCM.SSP.Plan.WSL | SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN | 1835 | 338.75 | P_DIVISION_ID=40, P_COMPANY_ID=HQ00, P_PLAN_START_YYYYMMDD=20261006, P_FROM_YYYYMMDD=20261006, P_TO_YYYYMMDD=20261130, P_PLANT_ID=HQ10,HQ06, P_CELL_TYPE=, P_LOT_ID=, P_ITEM_ID=, P_MODEL_ID=, P_NICK_NAME=, P_USER_ID=jaeuk.shin, P_REQUESTOR_ID=, P_PROGRAM_ID=SSP0022, P_SHEET_NAME=Shipment Request Deta |
| 19:37:24.622 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 32.15 | p_program_id=SCP0131, p_user_id=jaeuk.shin, p_sheet_name=Sales Site Priority |
| 19:37:24.649 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.85 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:37:25.035 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 104.99 | MenuID=Sales Site Priority, CnntCode=0104001, UserID=jaeuk.shin |
| 19:37:25.211 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.88 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0131 |
| 19:37:34.886 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 4.21 | p_program_id=SCP0131, p_user_id=jaeuk.shin, p_sheet_name=Sales Site Priority |
| 19:37:34.900 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 46 | 3.86 | Code=PlanGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:37:34.926 | find | GSCM.SCP.Master.WSL | SCP0131_GET_SALES_SITE_PRIORITY | 61 | 7.91 | p_division_id=81, p_plan_group_id=, p_scm_site_id=, p_item_id=, p_valid_yn=, p_period_from=20261109, p_period_to=20271108 |
| 19:37:35.044 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.47 | p_menu_id=SCP0131, p_log_type=FIND, p_log_cnt=61, p_db_time=0.048, p_ui_time=0.085, p_user_id=jaeuk.shin |
| 19:37:40.872 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.67 | MenuID=Sales Site Priority, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Model | txtItemId |  |
| lblItemIdButton | btnItemId |  |
| Valid | cboValid |  |
| Period* | dCalendar | Y |
| Plan Group | clbPlanGroup |  |
| SCM Site | clbSite |  |

## 그리드

- spdMain / Sales Site Priority: 행 61 · 컬럼 15(보임 14) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(14428)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
