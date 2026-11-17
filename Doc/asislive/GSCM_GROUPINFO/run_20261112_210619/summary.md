# AS-IS 실측 요약 — GSCM_GROUPINFO

- 실행: 2026-11-12 21:06:19.950 ~ 2026-11-12 21:07:04.052 · 계정 jaeuk.shin · 상태 OK
- 화면: Group (GSCM.SystemMgmt.UIL.GroupInfo)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:06:20.258 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.9 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0104 |
| 21:06:20.285 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.96 | USER_ID= |
| 21:06:20.504 | load | GSCM.SystemMgmt.WSL | UP_FX_GetGroupInfoList | 19 | 120.97 |  |
| 21:06:21.182 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 775.37 | MenuID=Group, CnntCode=0104001, UserID=jaeuk.shin |
| 21:06:21.359 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.89 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0104 |
| 21:06:26.771 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_SHIPMENT_REQUEST | 507 | 362948.32 | p_sheet_name=Pack Biz, p_division_id=81, p_team_id=, p_customer=, p_scm_site_id=, p_plant_site_id=, p_project_code=, p_item_id=, p_from_yyyymmdd=20261112, p_to_yyyymmdd=20270106, p_created_by=jaeuk.shin, debug_mode=F |
| 21:06:32.188 | find | GSCM.SystemMgmt.WSL | UP_FX_GetGroupInfoList | 19 | 4.05 |  |
| 21:07:03.382 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.48 | MenuID=Group, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Message | txtSearch |  |

## 그리드

- spdMain / GroupInfo: 행 19 · 컬럼 4(보임 3) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
