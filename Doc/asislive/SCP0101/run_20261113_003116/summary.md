# AS-IS 실측 요약 — SCP0101

- 실행: 2026-11-13 00:31:16.105 ~ 2026-11-13 00:38:21.297 · 계정 jaeuk.shin · 상태 OK
- 화면: Inventory Trend (GSCM.SCP.Report.UIL.SCP0101_InventoryTrend)
- 조회 결과: Total : 33,469 · DB : 408.286s, UI : 1.134s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:31:16.509 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.03 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:31:16.542 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0101 |
| 00:31:16.565 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.91 | USER_ID= |
| 00:31:16.915 | load | GSCM.SCP.Analysis.WSL | SCP0084_GET_MONTH_RANGE | 1 | 251.05 | p_month=12 |
| 00:31:17.293 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 28 | 324.82 | Code=PlantByGroup, Param1=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:31:17.379 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 26.61 | p_program_id=SCP0101, p_user_id=jaeuk.shin, p_sheet_name=Inventory Trend |
| 00:31:17.520 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 83.17 | MenuID=Inventory Trend, CnntCode=0104001, UserID=jaeuk.shin |
| 00:31:17.574 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0101 |
| 00:31:25.474 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 4.75 | p_program_id=SCP0101, p_user_id=jaeuk.shin, p_sheet_name=Inventory Trend |
| 00:38:12.404 | find | GSCM.SCP.Analysis.WSL | SCP0101_GET_INVENTORY_TREND | 33469 | 406897.29 | p_yyyymm=202609, p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_plant_id=, p_item_id=, debug_mode=F |
| 00:38:14.940 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.2 | p_menu_id=SCP0101, p_log_type=FIND, p_log_cnt=33469, p_db_time=408.286, p_ui_time=1.134, p_user_id=jaeuk.shin |
| 00:38:20.009 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 51.51 | MenuID=Inventory Trend, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Month | monthPicker |  |
| Plant | clbPlant |  |
| layoutBtnColumn | btnColumn |  |
| Material | txtItem_Id |  |
| layoutControlItem4 | btnItem_Id |  |
| layoutDetail | chkDetail |  |

## 그리드

- spdMain / Inventory Trend: 행 33469 · 컬럼 48(보임 20) · 헤더 2단 · 고정 컬럼 7

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
