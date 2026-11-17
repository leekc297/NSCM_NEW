# AS-IS 실측 요약 — DMF0005

- 실행: 2026-11-12 18:06:32.331 ~ 2026-11-12 18:07:13.023 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Site Project Model (GSCM.DM.Master.UIL.DMF0005_SaleSite_PjtModelMapping)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:06:32.782 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.67 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0005 |
| 18:06:32.807 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.19 | USER_ID= |
| 18:06:33.191 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.14 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.229 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 50 | 21.6 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0005, p_sheet_name=Production, p_division_id=40 |
| 18:06:33.304 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 77 | 57.77 | Code=TeambyDivision2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.341 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 37 | 32.27 | Code=CUST_GROUP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.357 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1920 | 10.69 | Code=EndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.388 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1350 | 13.73 | Code=ScmSitebyEndCustomer40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.403 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.64 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.438 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 28.25 | Code=PRODUCTION_PROCESS, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.446 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 4.14 | Code=CompanySalesSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.456 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 78 | 4.93 | Code=PlantByDivisionCompany, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.482 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 20.21 | Code=SoldToCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.515 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 24.42 | Code=EndCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.529 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 4.06 | Code=CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.560 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 25.38 | Code=APPLICATION, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.568 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.47 | Code=ROUTE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.601 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 25.99 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.609 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.81 | Code=incotermsEdit, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.640 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 22.11 | Code=DMF0005_REPORT_GROUP1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.665 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 21.29 | Code=DMF0005_REPORT_GROUP2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.673 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.17 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.681 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.73 | Code=DMF0005_REPORT_GROUP4, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.690 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.25 | Code=DMF0005_REPORT_GROUP5, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.699 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 4.23 | Code=DMF0005_REPORT_GROUP6, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.751 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 35 | 47.46 | Code=PROJECT_MODEL_MAPPING, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.778 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 19 | 11.75 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0005, p_sheet_name=Purchase, p_division_id=40 |
| 18:06:33.790 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.61 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.800 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.47 | Code=CompanySalesSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.807 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 78 | 3.56 | Code=PlantByDivisionCompany, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.825 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.86 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.843 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.42 | Code=Auth_Dept, Param1=jaeuk.shin, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.850 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.36 | Code=Auth_Dept, Param1=jaeuk.shin, Param2=ADMIN, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:33.876 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 12.14 | p_lookup_type=INVENTORY_DAYS_SETUP_SITE |
| 18:06:33.996 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 98.12 | MenuID=Sales Site Project Model, CnntCode=0104001, UserID=jaeuk.shin |
| 18:06:34.062 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0005 |
| 18:06:42.139 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 50 | 23.8 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0005, p_sheet_name=Production, p_division_id=40 |
| 18:06:42.208 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 77 | 60.1 | Code=TeambyDivision2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.215 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 37 | 3.32 | Code=CUST_GROUP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.230 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1920 | 10.98 | Code=EndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.258 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1350 | 12.94 | Code=ScmSitebyEndCustomer40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.272 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.57 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.282 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 5.15 | Code=PRODUCTION_PROCESS, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.323 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 7.01 | Code=CompanySalesSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.331 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 78 | 4.49 | Code=PlantByDivisionCompany, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.343 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 6.76 | Code=SoldToCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.360 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 10.05 | Code=EndCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.371 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.86 | Code=CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.380 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.92 | Code=APPLICATION, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.388 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.57 | Code=ROUTE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.399 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.5 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.407 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.66 | Code=incotermsEdit, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.417 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.18 | Code=DMF0005_REPORT_GROUP1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.431 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 4.39 | Code=DMF0005_REPORT_GROUP2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.439 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.53 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.446 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.53 | Code=DMF0005_REPORT_GROUP4, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.454 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.69 | Code=DMF0005_REPORT_GROUP5, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.462 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 4.17 | Code=DMF0005_REPORT_GROUP6, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.470 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 35 | 3.33 | Code=PROJECT_MODEL_MAPPING, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.492 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 19 | 12.22 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0005, p_sheet_name=Purchase, p_division_id=40 |
| 18:06:42.505 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.49 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.513 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.79 | Code=CompanySalesSite, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.520 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 78 | 3.85 | Code=PlantByDivisionCompany, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:42.534 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 4.25 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Sales Site | clbSalesSite |  |
| layoutControlItem1 | chkDetail |  |
| Team | clbTeam |  |
| End Customer | clbEndCustomer |  |
| Project | txtProject |  |
| Model / Nickname | txtItemId |  |
| Active | cboActive |  |
| layoutControlItem2 | btnProject |  |
| layoutControlItem3 | btnItemId |  |
| Div | clbDivision |  |
| Owner | txtOwner |  |
| layoutControlItem4 | btnOwner |  |
| Model Code change | btnModelChange |  |
| layoutControlItem5 | chkEndCust |  |
| layoutControlItem6 | chkProjectInfo |  |

## 그리드

- spdMain / Production: 행 0 · 컬럼 51(보임 44) · 헤더 2단 · 고정 컬럼 0
- spdSub / Purchase: 행 0 · 컬럼 20(보임 18) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
