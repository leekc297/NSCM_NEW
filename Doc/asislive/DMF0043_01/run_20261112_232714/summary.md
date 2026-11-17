# AS-IS 실측 요약 — DMF0043_01

- 실행: 2026-11-12 23:27:14.219 ~ 2026-11-12 23:27:40.317 · 계정 jaeuk.shin · 상태 OK
- 화면: 해외법인 기여매출 (GSCM.DM.Master.UIL.DMF0043_Contribute_View)
- 조회 결과:  · DB : 1.669s, UI : 0.077s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "txtVersion", "popup": "DMF0043_VersionPopup", "opener": "btnSPVer_Click"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:27:14.810 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0043_01 |
| 23:27:14.835 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.24 | USER_ID= |
| 23:27:15.009 | load | GSCM.DM.Master.WSL | DMF0043_GET_MAIN_VARSION_DATA | 8 | 71.05 |  |
| 23:27:15.057 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 22.36 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:15.081 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.12 | Code=DM_BIZ_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:15.138 | load | GSCM.DM.Master.WSL | DMF0043_GET_SALES_LIST_SPREAD_TITLE | 27 | 36.85 | p_division_id=40, p_created_by=jaeuk.shin |
| 23:27:15.252 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 69.83 | MenuID=해외법인 기여매출, CnntCode=0104001, UserID=jaeuk.shin |
| 23:27:15.303 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.75 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0043_01 |
| 23:27:23.972 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.38 | Code=MULTITIMEZONECODE, Param1=AS054, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:24.087 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.41 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:24.127 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 31.39 | p_lookup_type=MDF_TYPE |
| 23:27:24.485 | load | GSCM.DM.Master.WSL | DMF0043_GET_CONT_VIEW_VERSIONPOPUP | 30 | 232.5 | p_start_yyyymmdd=20260812, p_end_yyyymmdd=20270212, p_division_id=40, p_version_type=REPORT_SP_W, p_description= |
| 23:27:31.544 | find | GSCM.DM.Master.WSL | DMF0043_GET_SALES_LIST_SPREAD_TITLE | 27 | 5.17 | p_division_id=40, p_created_by=jaeuk.shin |
| 23:27:33.301 | find | GSCM.DM.Master.WSL | DMF0043_GET_CONTRIBUTION_SALES_LIST | 1 | 1661.02 | p_division_id=40, p_ver_seq=15, p_version_no=R_S_20261028_V003, p_end_cust_report=, p_product_group=ALL, p_biz_type=ALL, p_million_yn=N, p_compatibility_yn=N, p_created_by=jaeuk.shin |
| 23:27:33.390 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.42 | p_menu_id=DMF0043_01, p_log_type=FIND, p_log_cnt=, p_db_time=1.669, p_ui_time=0.077, p_user_id=jaeuk.shin |
| 23:27:39.621 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.94 | MenuID=해외법인 기여매출, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Version | txtVersion |  |
| layoutControlItem1 | btnSPVer |  |
| Year | usrYear |  |
| layoutControlItem5 | chkM |  |
| Biz | usrBiz |  |
| 고객군 | usrCust |  |
| tst | usrChk |  |
| layoutControlItem8 | btnColumn |  |
| 제품군 | usrType |  |

## 그리드

- spdMain / ContributeSalesList: 행 1 · 컬럼 29(보임 27) · 헤더 2단 · 고정 컬럼 11

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
