# AS-IS 실측 요약 — SSP0017

- 실행: 2026-11-12 20:51:52.842 ~ 2026-11-12 20:52:41.224 · 계정 jaeuk.shin · 상태 OK
- 화면: Inventory Raw(Mobility  & IT) (GSCM.SSP.Plan.UIL.SSP0017_InventoryRaw)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:51:53.093 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.69 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:51:53.101 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 3.46 | Code=OWMS_STOCK_STATUS, Param1=OWMS_STOCK_STATUS, Param2=KO, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:53.139 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0017 |
| 20:51:53.163 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.33 | USER_ID= |
| 20:51:53.277 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 25.0 | Code=LookupCommon, Param1=INV_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:53.296 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 4.22 | Code=ShipmentRequestPlantSite, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:51:53.952 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 647.5 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:53.964 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 4.54 | p_program_id=SSP0017, p_user_id=jaeuk.shin, p_sheet_name=Inventory Raw(Mobility & IT) |
| 20:51:53.973 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.34 | Code=LookupCommon, Param1=INV_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:54.000 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 20.37 | Code=OWMS_STOCK_STATUS, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:51:54.099 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 74.39 | MenuID=Inventory Raw(Mobility  & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 20:51:54.153 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.65 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0017 |
| 20:52:40.484 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.73 | MenuID=Inventory Raw(Mobility  & IT), CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 20:52:02.528 [GSCM] Plan date* 값은 필수 입력입니다 → default_button(id=1)
