# AS-IS 실측 요약 — SCP0085

- 실행: 2026-11-12 20:13:05.752 ~ 2026-11-12 20:13:44.100 · 계정 jaeuk.shin · 상태 OK
- 화면: Ending Inventory (GSCM.SCP.Report.UIL.SCP0085_EndingInventory)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:13:06.129 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.55 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:13:06.569 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 28 | 437.09 | Code=PlantByGroup1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:13:06.623 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0085 |
| 20:13:06.647 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.38 | USER_ID= |
| 20:13:06.773 | load | GSCM.SCP.Analysis.WSL | SCP0084_GET_MONTH_RANGE | 1 | 3.46 | p_month=12 |
| 20:13:21.543 | load | GSCM.SCP.Master.WSL | SCP0085_GET_SEARCH_INFO | 41 | 14759.77 | P_YYYYMMDD=202609 |
| 20:13:21.567 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 7 | 3.6 | p_lookup_type=ITEM_TYPE |
| 20:13:21.611 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 73 | 35.91 | p_program_id=SCP0085, p_user_id=jaeuk.shin, p_sheet_name=Ending Inventory Main |
| 20:13:21.869 | load | GSCM.SCP.Master.WSL | SCP0085_GET_SEARCH_INFO | 41 | 216.76 | P_YYYYMMDD=202609 |
| 20:13:22.227 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 332.28 | MenuID=Ending Inventory, CnntCode=0104001, UserID=jaeuk.shin |
| 20:13:22.272 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0085 |
| 20:13:30.206 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 73 | 4.96 | p_program_id=SCP0085, p_user_id=jaeuk.shin, p_sheet_name=Ending Inventory Main |
| 20:13:30.650 | find | GSCM.SCP.Analysis.WSL | SCP0085_GET_ENDING_INVENTORY | 0 | 411.94 | p_yyyymm=202609, p_division_id=, p_plant_id=, p_item_type=, p_item_id=, debug_mode=F |
| 20:13:43.386 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.0 | MenuID=Ending Inventory, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Month | monthPicker |  |
| Plant | clbPlant |  |
| Material | txtItem_Id |  |
| layoutControlItem4 | btnItem_Id |  |
| layoutRdoMonth | RdoMonth |  |
| layoutControlItem1 | RdoDate |  |
| Date | datePicker |  |
| layoutControlItem1 | chkDetail |  |
| Profit Center | cboProfit |  |
| Item Type | clbItemType |  |

## 그리드

- spdMain / Ending Inventory Main: 행 0 · 컬럼 74(보임 39) · 헤더 1단 · 고정 컬럼 11

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 20:13:31.174 [GSCM] 시스템 오류입니다. 담당자에게 화면 캡쳐해서 시스템 담당자에게 전달하세요. → default_button(id=1)
