# AS-IS 실측 요약 — DMF0068

- 실행: 2026-11-12 18:19:42.314 ~ 2026-11-12 18:20:37.796 · 계정 jaeuk.shin · 상태 OK
- 화면: Demand Manager  (GSCM.DM.Plan.UIL.DMF0068_DemandManager40)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:19:42.618 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.63 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:19:42.940 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.88 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0068 |
| 18:19:42.966 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.06 | USER_ID= |
| 18:19:43.621 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 156 | 428.88 | p_program_id=DMF0068, p_user_id=jaeuk.shin, p_sheet_name=ContributeSalesList |
| 18:19:47.098 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 3315.63 | MenuID=Demand Manager , CnntCode=0104001, UserID=jaeuk.shin |
| 18:19:47.932 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.9 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0068 |
| 18:19:54.474 | load | GSCM.DM.Master.WSL | DMF0053_GET_CUST_FCST_WATERFALL | 0 | 59395.97 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id=, p_item_type=ALL, p_from_yyyymmdd=20261101, p_to_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_plant_site_id=ALL, p_biz_type=ALL, p_owner=, p_version_no=, p_bucket=MONTHLY, p_user_dept_id=58183091, p_ |
| 18:20:37.127 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.07 | MenuID=Demand Manager , CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Version | txtVersion |  |
| layoutControlItem1 | btnSPVer |  |
| Period | drpPeriodMonth |  |

## 그리드

- spdMain / ContributeSalesList: 행 0 · 컬럼 157(보임 48) · 헤더 2단 · 고정 컬럼 11

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:19:59.525 [GSCM] Version을 선택하고 조회하세요. → default_button(id=1)
