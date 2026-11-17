# AS-IS 실측 요약 — SSP0005

- 실행: 2026-11-14 22:21:45.757 ~ 2026-11-14 22:22:30.493 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Working Day (GSCM.SSP.Plan.UIL.SSP0005_ShipmentWorkingDay)
- 조회 결과: Total :  · DB : 0.16s, UI : 0.102s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:22:02.729 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 82.66 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:02.847 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 106.9 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:03.036 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 182.66 | Code=LookupCommon, Param1=WEEK_WORK_TIME, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:03.852 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 41.98 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 22:22:03.965 | load | GSCM.BizService.WSL | SELECT * | 874 | 97.29 | USER_ID= |
| 22:22:04.561 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_PERIOD | 1 | 29.6 | p_from_date=, p_offset_month=, p_timezone=AS054 |
| 22:22:04.679 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 441 | 38.82 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20271114 |
| 22:22:04.754 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 50.64 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 22:22:04.787 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 21.35 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:04.915 | load | GSCM.DataService.WSL | UP_FX_GetGSCMAuthenticationMenuList | 273 | 6251.66 | UserID=jaeuk.shin, GroupID=ADMIN, ProgramId= |
| 22:22:05.286 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 67.54 | MenuID=Shipment Working Day, CnntCode=0104001, UserID=jaeuk.shin |
| 22:22:05.411 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.06 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0005 |
| 22:22:09.062 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.79 | Code=MyGroupID, Param1=jaeuk.shin, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:09.223 | load | GSCM.BizService.WSL | SELECT | 1 | 3.64 | USER_ID=jaeuk.shin |
| 22:22:09.239 | load | GSCM.BizService.WSL | DECLARE @v_time  NVARCHAR(10); | 0 | 4.68 | USER_ID=jaeuk.shin |
| 22:22:12.424 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.44 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0046 |
| 22:22:12.455 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.2 | USER_ID= |
| 22:22:12.667 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.49 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:12.738 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 64.24 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:22:12.850 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 105.65 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 22:22:13.275 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 363.81 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 22:22:13.361 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 21.85 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:22:13.406 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.09 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:22:13.517 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 106.99 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 22:22:13.853 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 302.55 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 22:22:13.934 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 21.38 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:22:13.986 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 27.94 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:22:14.105 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 104.76 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 22:22:14.442 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 300.83 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 22:22:14.531 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 21.5 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:22:14.569 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.06 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:22:14.610 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.56 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:22:14.723 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 106.31 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 22:22:15.084 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 318.27 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 22:22:15.161 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 21.42 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 22:22:15.198 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_BUCKET_TYPE_CODE | 3 | 20.46 |  |
| 22:22:15.240 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 22 | 23.01 | Code=Measure, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:15.286 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 35.85 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261114, p_end_dt=20270108, p_sheet_name=Pack Biz |
| 22:22:15.295 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 5.64 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261114, p_end_dt=20270108, p_sheet_name=Pack Biz |
| 22:22:15.317 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.35 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:15.327 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.47 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:15.359 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 32 | 31.07 | Code=Measure, Param1=SSP0046, Param2=Pack Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:15.407 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 6.11 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261114, p_end_dt=20270108, p_sheet_name=Cell Biz |
| 22:22:15.411 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 5.43 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261114, p_end_dt=20270108, p_sheet_name=Cell Biz |
| 22:22:15.422 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.61 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:15.442 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.72 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:15.442 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 34 | 4.16 | Code=Measure, Param1=SSP0046, Param2=Cell Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:15.723 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 145.18 | MenuID=Shipment Request, CnntCode=0104001, UserID=jaeuk.shin |
| 22:22:15.824 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.01 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0046 |
| 22:22:23.621 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 441 | 12.33 | p_start_yyyymmdd=20261114, p_end_yyyymmdd=20271114 |
| 22:22:23.644 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 2 | 4.25 | p_program_id=SSP0005, p_user_id=jaeuk.shin, p_sheet_name=Shipment Working Day |
| 22:22:23.648 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.63 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:23.895 | find | GSCM.SSP.Plan.WSL | SSP0005_GET_SHIPMENT_WORKING_DAY | 0 | 129.57 | p_from_yyyymmdd=20261114, p_to_yyyymmdd=20271114, p_division_id=81,40,82,81_UC,81_HM,81_HD,81_HG, p_company_id=AA00, debug_mode=F |
| 22:22:24.024 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 13.5 | p_menu_id=SSP0005, p_log_type=FIND, p_log_cnt=, p_db_time=0.16, p_ui_time=0.102, p_user_id=jaeuk.shin |
| 22:22:29.368 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 32 | 4.76 | Code=Measure, Param1=SSP0046, Param2=Pack Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:29.473 | find | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 7.06 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261114, p_end_dt=20270108, p_sheet_name=Pack Biz |
| 22:22:29.479 | find | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 6.0 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261114, p_end_dt=20270108, p_sheet_name=Pack Biz |
| 22:22:29.510 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 5.24 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:29.519 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.48 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:22:29.524 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 32 | 4.05 | Code=Measure, Param1=SSP0046, Param2=Pack Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Day of the week | cboDayWeek |  |
| Input | btnInput |  |
| Period* | drpPeriod | Y |
| Div | clbDivision |  |
| Input Value | cboInputValue |  |
| Company | cboCompany |  |

## 그리드

- spdMain / Shipment Working Day: 행 0 · 컬럼 369(보임 368) · 헤더 3단 · 고정 컬럼 3

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(AsisLive.Host.exe(34908)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
