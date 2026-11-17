# AS-IS 실측 요약 — SSP0046

- 실행: 2026-11-12 20:59:59.943 ~ 2026-11-12 21:00:54.984 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Request (GSCM.SSP.Plan.UIL.SSP0046_ShipmentRequest)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:00:02.784 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2084.42 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0046 |
| 21:00:02.812 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.17 | USER_ID= |
| 21:00:02.972 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.68 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:03.008 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.2 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:00:04.515 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 1493.86 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 21:00:04.864 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 320.47 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 21:00:04.948 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 38.09 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:00:04.993 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.65 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:00:05.126 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 120.62 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 21:00:05.486 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 338.39 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 21:00:05.577 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 23.42 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:00:05.622 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 30.33 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:00:05.741 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 107.76 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 21:00:06.076 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 312.66 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 21:00:06.146 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 22.22 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:00:06.183 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.4 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:00:06.216 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 29.89 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:00:06.339 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 111.39 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 21:00:06.675 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 314.83 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 21:00:06.772 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 23.01 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 21:00:07.028 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_BUCKET_TYPE_CODE | 3 | 224.89 |  |
| 21:00:07.557 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 22 | 517.89 | Code=Measure, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:09.675 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 2103.22 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261112, p_end_dt=20270106, p_sheet_name=Pack Biz |
| 21:00:09.686 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 6.8 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261112, p_end_dt=20270106, p_sheet_name=Pack Biz |
| 21:00:09.708 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.58 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:09.715 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.48 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:10.040 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 32 | 319.33 | Code=Measure, Param1=SSP0046, Param2=Pack Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:10.080 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 7.41 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261112, p_end_dt=20270106, p_sheet_name=Cell Biz |
| 21:00:10.091 | load | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 5.6 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261112, p_end_dt=20270106, p_sheet_name=Cell Biz |
| 21:00:10.101 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.25 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:10.107 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.51 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:10.114 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 34 | 3.46 | Code=Measure, Param1=SSP0046, Param2=Cell Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:14.364 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4147.38 | MenuID=Shipment Request, CnntCode=0104001, UserID=jaeuk.shin |
| 21:00:14.894 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 5.33 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0046 |
| 21:00:23.567 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 32 | 4.24 | Code=Measure, Param1=SSP0046, Param2=Pack Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:23.671 | find | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 5.92 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261112, p_end_dt=20270106, p_sheet_name=Pack Biz |
| 21:00:23.747 | find | GSCM.SSP.Plan.WSL | SSP0046_GET_SPREAD_TITLE | 86 | 5.86 | p_division_id=81, p_created_by=jaeuk.shin, p_start_dt=20261112, p_end_dt=20270106, p_sheet_name=Pack Biz |
| 21:00:23.766 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.38 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:23.775 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.8 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:00:23.784 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 32 | 4.0 | Code=Measure, Param1=SSP0046, Param2=Pack Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Team | clbTeam |  |
| End Customer | clbCustomer |  |
| Period | drpPeriod |  |
| Sales Site | clbSalesSite |  |
| Model | txtItemId |  |
| Project | txtProject |  |
| layoutControlItem3 | btnProject |  |
| layoutControlItem1 | btnItemId |  |
| Plant Site | clbPlantSite |  |
| Div | cboDivision |  |
| Bucket | cboBucketType |  |
| layoutControlItem4 | btnMeasure |  |
| layoutControlItem5 | chkSum |  |
| layoutControlItem2 | btnColumn |  |

## 그리드

- spdMain / Pack Biz: 행 0 · 컬럼 87(보임 72) · 헤더 3단 · 고정 컬럼 17
- spdMain / Cell Biz: 행 0 · 컬럼 87(보임 72) · 헤더 3단 · 고정 컬럼 17

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
