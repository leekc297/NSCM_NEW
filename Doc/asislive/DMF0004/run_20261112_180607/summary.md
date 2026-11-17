# AS-IS 실측 요약 — DMF0004

- 실행: 2026-11-12 18:06:07.696 ~ 2026-11-12 18:06:32.166 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Site (GSCM.DM.Master.UIL.DMF0004_SalesSite)
- 조회 결과:  · DB : 0.652s, UI : 0.059s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:06:11.736 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.33 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:11.876 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.26 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0004 |
| 18:06:11.900 | load | GSCM.BizService.WSL | SELECT * | 874 | 17.96 | USER_ID= |
| 18:06:12.612 | load | GSCM.DM.Master.WSL | DMF0004_GET_SOLDTO_CUSTOMER_DATA | 716 | 42.83 | p_division_id=40, p_dept_id=ALL |
| 18:06:12.746 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.38 | Code=MyDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:12.817 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 18 | 37.47 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0004, p_sheet_name=Sales Site, p_division_id=40 |
| 18:06:12.884 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1766 | 57.16 | Code=SoldCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:12.922 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 16.46 | Code=COMPANY_ID_INTERNAL_TXN, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:12.988 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 13 | 7.12 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0004, p_sheet_name=Sales Customer, p_division_id=40 |
| 18:06:13.068 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 75.69 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:13.115 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 11 | 6.44 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0004, p_sheet_name=Sales Location, p_division_id=40 |
| 18:06:13.123 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.54 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:13.203 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 74.18 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:13.239 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 13 | 7.41 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0004, p_sheet_name=Sales Bucket, p_division_id=40 |
| 18:06:13.306 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 61.68 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:13.333 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.39 | Code=incotermsEdit, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:13.383 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.01 | Code=Auth_Dept, Param1=jaeuk.shin, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:13.391 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.2 | Code=Auth_Dept, Param1=jaeuk.shin, Param2=ADMIN, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:13.508 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 86.41 | MenuID=Sales Site, CnntCode=0104001, UserID=jaeuk.shin |
| 18:06:13.634 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0004 |
| 18:06:24.570 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 18 | 10.18 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0004, p_sheet_name=Sales Site, p_division_id=40 |
| 18:06:24.588 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1766 | 11.38 | Code=SoldCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:24.607 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 4.0 | Code=COMPANY_ID_INTERNAL_TXN, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:24.629 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 13 | 8.08 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0004, p_sheet_name=Sales Customer, p_division_id=40 |
| 18:06:24.701 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 66.25 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:25.347 | find | GSCM.DM.Master.WSL | DMF0004_GET_SALES_SITE_DATA | 1350 | 620.39 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_active_flag=ALL, p_created_by=jaeuk.shin, p_userinfo=ADMIN, p_soldto_customer=ALL, p_user_dept_id=58183091 |
| 18:06:25.450 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.55 | p_menu_id=DMF0004, p_log_type=FIND, p_log_cnt=, p_db_time=0.652, p_ui_time=0.059, p_user_id=jaeuk.shin |
| 18:06:31.313 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.27 | MenuID=Sales Site, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem1 | chkDetail |  |
| Active | cboActive |  |
| Sold-To Customer | clbSoldToCustomer |  |
| End Customer | clbEndCustomer |  |
| Team | clbTeam |  |
| Sales Site | clbSalesSite |  |
| Div | cboDivision |  |

## 그리드

- spdMain / Sales Site: 행 1350 · 컬럼 20(보임 16) · 헤더 1단 · 고정 컬럼 1
- spdSub / Sales Customer: 행 0 · 컬럼 14(보임 12) · 헤더 1단 · 고정 컬럼 0
- spdSub / Sales Location: 행 0 · 컬럼 12(보임 9) · 헤더 1단 · 고정 컬럼 0
- spdSub / Sales Bucket: 행 0 · 컬럼 14(보임 12) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
