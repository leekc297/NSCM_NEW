# AS-IS 실측 요약 — SCP0101

- 실행: 2026-11-12 22:51:46.064 ~ 2026-11-12 22:52:33.502 · 계정 jaeuk.shin · 상태 OK
- 화면: Inventory Trend (GSCM.SCP.Report.UIL.SCP0101_InventoryTrend)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:51:46.450 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 23.02 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:51:46.835 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.55 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0101 |
| 22:51:46.861 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.8 | USER_ID= |
| 22:51:47.005 | load | GSCM.SCP.Analysis.WSL | SCP0084_GET_MONTH_RANGE | 1 | 3.9 | p_month=12 |
| 22:51:47.364 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 28 | 341.05 | Code=PlantByGroup, Param1=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:51:47.499 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 61.35 | p_program_id=SCP0101, p_user_id=jaeuk.shin, p_sheet_name=Inventory Trend |
| 22:51:47.920 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 256.04 | MenuID=Inventory Trend, CnntCode=0104001, UserID=jaeuk.shin |
| 22:51:48.304 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.97 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0101 |
| 22:51:57.917 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 6.08 | p_program_id=SCP0101, p_user_id=jaeuk.shin, p_sheet_name=Inventory Trend |

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

- spdMain / Inventory Trend: 행 0 · 컬럼 47(보임 20) · 헤더 2단 · 고정 컬럼 6

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
