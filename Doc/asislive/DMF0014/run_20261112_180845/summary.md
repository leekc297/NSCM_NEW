# AS-IS 실측 요약 — DMF0014

- 실행: 2026-11-12 18:08:45.346 ~ 2026-11-12 18:09:05.121 · 계정 jaeuk.shin · 상태 OK
- 화면: Customer FCST Upload (GSCM.DM.Plan.UIL.DMF0014_CustFcstUpload)
- 조회 결과:  · DB : 1.797s, UI : 0.066s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:08:46.031 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.07 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0014 |
| 18:08:46.059 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.41 | USER_ID= |
| 18:08:46.295 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.41 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:08:47.051 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 744.95 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:08:47.380 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.1 | p_created_by=jaeuk.shin, p_month=6 |
| 18:08:47.389 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 4.27 | p_lookup_type=BUCKET_TYPE_CODE |
| 18:08:47.409 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.79 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:08:47.418 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 16 | 4.07 | p_lookup_type=INCOTERMS |
| 18:08:47.424 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 14 | 3.61 | p_lookup_type=SALES_TYPE_CODE |
| 18:08:47.433 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 5 | 5.26 | p_lookup_type=UPLOAD_UOM_TYPE_CODE |
| 18:08:47.451 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 15.54 | Code=CustomerMeasure, Param1=40, Param2=ALL, Param3=ALL, Param4=DAILY, Param5=CUST_FCST, TimeZone=AS054 |
| 18:08:47.502 | load | GSCM.DM.Master.WSL | DMF0014_GET_SPREAD_TITLE | 27 | 31.41 | p_start_yyyymmdd=20261109, p_end_yyyymmdd=20270516, p_bucket_type=WEEKLY |
| 18:08:48.087 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 488.17 | MenuID=Customer FCST Upload, CnntCode=0104001, UserID=jaeuk.shin |
| 18:08:48.196 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0014 |
| 18:08:57.174 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 16.05 | Code=CustomerMeasure, Param1=40, Param2=ALL, Param3=ALL, Param4=WEEKLY, Param5=CUST_FCST, TimeZone=AS054 |
| 18:08:57.224 | find | GSCM.DM.Master.WSL | DMF0014_GET_SPREAD_TITLE | 27 | 6.26 | p_start_yyyymmdd=20261109, p_end_yyyymmdd=20270516, p_bucket_type=WEEKLY |
| 18:08:59.037 | find | GSCM.DM.Master.WSL | DMF0014_GET_CUST_FCST_UPLOAD_DATA | 0 | 1790.48 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_plant_site_id=ALL, p_project_code=, p_item_id=, p_start_yyyymmdd=20261109, p_end_yyyymmdd=20270516, p_bucket_type=WEEKLY, p_dom_exp=ALL, p_created_by=jaeuk.shin, p_userinfo=ADMIN |
| 18:08:59.130 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 17.87 | p_menu_id=DMF0014, p_log_type=FIND, p_log_cnt=, p_db_time=1.797, p_ui_time=0.066, p_user_id=jaeuk.shin |
| 18:09:04.373 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.87 | MenuID=Customer FCST Upload, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Project | txtProject |  |
| End Customer | clbEndCustomer |  |
| Sales Site | clbScmSite |  |
| Div | cboDivision |  |
| Team | clbTeam |  |
| lblBtnProject | btnProject |  |
| Model / Nickname | txtItemId |  |
| lblBtnItemId | btmItem |  |
| Period | drpPeriod |  |
| Bucket Type | cboBucketType |  |
| Plant Site | clbPlantSite |  |
| Upload | btnExcelUpload |  |
| Customs Handbook | clbDomExp |  |

## 그리드

- spdMain / FCST Upload: 행 0 · 컬럼 42(보임 41) · 헤더 2단 · 고정 컬럼 14

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
