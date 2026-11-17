# AS-IS 실측 요약 — GSCM_BASECODE

- 실행: 2026-11-12 21:08:28.394 ~ 2026-11-12 21:09:10.813 · 계정 jaeuk.shin · 상태 OK
- 화면: Code (GSCM.SystemMgmt.UIL.BaseCode)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:08:28.828 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.44 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0107 |
| 21:08:28.851 | load | GSCM.BizService.WSL | SELECT * | 874 | 17.93 | USER_ID= |
| 21:08:29.792 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 733.39 | MenuID=Code, CnntCode=0104001, UserID=jaeuk.shin |
| 21:08:30.273 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.75 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0107 |
| 21:08:30.447 | load | GSCM.SystemMgmt.WSL | UP_FX_GetBaseCodeList | 2 | 1432.88 | Level=1, BaseCode= |
| 21:08:38.716 | find | GSCM.SystemMgmt.WSL | UP_FX_GetBaseCodeList | 2 | 2.92 | Level=1, BaseCode= |
| 21:09:09.757 | find | GSCM.SSP.Plan.WSL | SSP0045_GET_SHIPMENT_REQUEST | 0 | 597541.98 | p_division_id=40, p_operation_group=P, p_scm_site_id=, p_item_id=, p_from_yyyymmdd=20261112, p_to_yyyymmdd=20270106, p_program_id=SSP0045, p_sheet_name=Shipment Request, p_user_id=jaeuk.shin, debug_mode=F |
| 21:09:09.938 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.28 | MenuID=Code, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| BaseCode(CodeName) | txtSearch |  |

## 그리드

- spdLevel1 / Level1: 행 2 · 컬럼 9(보임 5) · 헤더 1단 · 고정 컬럼 1
- spdLevel2 / Level2: 행 0 · 컬럼 9(보임 5) · 헤더 1단 · 고정 컬럼 1
- spdLevel3 / Level3: 행 0 · 컬럼 9(보임 5) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
