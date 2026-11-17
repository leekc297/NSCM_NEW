# AS-IS 실측 요약 — SSP0017

- 실행: 2026-11-13 00:44:14.941 ~ 2026-11-13 00:45:04.407 · 계정 jaeuk.shin · 상태 OK
- 화면: Inventory Raw(Mobility  & IT) (GSCM.SSP.Plan.UIL.SSP0017_InventoryRaw)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:44:15.275 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.58 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:44:15.284 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 3.43 | Code=OWMS_STOCK_STATUS, Param1=OWMS_STOCK_STATUS, Param2=KO, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:15.346 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0017 |
| 00:44:15.373 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.04 | USER_ID= |
| 00:44:15.512 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 22.41 | Code=LookupCommon, Param1=INV_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:15.532 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 4.36 | Code=ShipmentRequestPlantSite, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:44:16.185 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 642.93 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:16.240 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 34.8 | p_program_id=SSP0017, p_user_id=jaeuk.shin, p_sheet_name=Inventory Raw(Mobility & IT) |
| 00:44:16.257 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.95 | Code=LookupCommon, Param1=INV_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:16.306 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 33.2 | Code=OWMS_STOCK_STATUS, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:44:16.554 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 207.46 | MenuID=Inventory Raw(Mobility  & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 00:44:16.675 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.18 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0017 |
| 00:45:03.432 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.57 | MenuID=Inventory Raw(Mobility  & IT), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| Model | txtItemId |  |
| layoutControlItem2 | btnItemId |  |
| Plan date* | cboPlanDate | Y |
| layoutControlItem10 | btnMeasure |  |
| Div | clbDivision |  |
| Inventory Type | cboInventoryType |  |

## 그리드

- spdMain / Inventory Raw(Mobility & IT): 행 0 · 컬럼 28(보임 27) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-13 00:44:25.822 [GSCM] Plan date* 값은 필수 입력입니다 → default_button(id=1)
