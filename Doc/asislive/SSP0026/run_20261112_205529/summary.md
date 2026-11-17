# AS-IS 실측 요약 — SSP0026

- 실행: 2026-11-12 20:55:29.732 ~ 2026-11-12 20:56:15.467 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Request(Mobility & IT) (GSCM.SSP.Plan.UIL.SSP0026_ShipmentRequestPack)
- 조회 결과:  · DB : 20.289s, UI : 0.288s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:55:30.016 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 7.38 | Code=LookupCommon, Param1=PGM_AUTH_ID, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:30.092 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.93 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0026 |
| 20:55:30.119 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.73 | USER_ID= |
| 20:55:30.294 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.67 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:30.302 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 1 | 5.05 | Code=Plan_InforPacker, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:55:30.344 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.34 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:30.550 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 211 | 192.21 | Code=SoldToCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852 |
| 20:55:30.965 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 445 | 384.62 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,ATBS,ATL,Audi,audi as,Audi CKD,AW,BAE,Banglilai,BEDEO,BMW,BMW_NTG,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cum |
| 20:55:31.035 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 12.14 | Code=FromSiteByDivisionOspPack, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:31.104 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 55.12 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:31.147 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 211 | 30.79 | Code=SoldToCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852 |
| 20:55:31.568 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 445 | 393.97 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,ATBS,ATL,Audi,audi as,Audi CKD,AW,BAE,Banglilai,BEDEO,BMW,BMW_NTG,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cum |
| 20:55:31.634 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 10.3 | Code=FromSiteByDivisionOspPack, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:31.674 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.23 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:31.717 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 211 | 29.14 | Code=SoldToCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852 |
| 20:55:32.140 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 445 | 386.77 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,ATBS,ATL,Audi,audi as,Audi CKD,AW,BAE,Banglilai,BEDEO,BMW,BMW_NTG,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cum |
| 20:55:32.201 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 11.41 | Code=FromSiteByDivisionOspPack, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:33.535 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 17 | 1328.05 | Code=TeambyDivision, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:33.577 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 786 | 33.41 | Code=SoldToCustomerByDivisionDept, Param1=40, Param2=70021414,71059518,71067310,70090866,58124984,58260040,70090867,58099468,58666055,70618872,71060790,58520274,70021343,70318556,70000478,70267799,70174158, Param3=ADMIN, Param4=jaeuk.shin, Param5=, TimeZone=AS054 |
| 20:55:35.406 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1091 | 1744.78 | Code=SiteByEndCustomer, Param1=40, Param2=1X Technologies,ABS,Acculon Energy,ACE KR,Acell,Acell Electronic,acer,Acer BC,Acme,Aeon Motor,Aigo,Airbus,Airtek,Airwheel,AJ상사,Akasol,Akasol Inc,Akku,Alelion,All Good Energy,AllCell,Also,Alta Motors,Alte,Amara Raja Batteries,Amazon,Amazon Prime Air,Amazon Ro |
| 20:55:35.626 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 105.96 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:35.703 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 17 | 62.21 | Code=TeambyDivision, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:35.769 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 17 | 61.61 | Code=TeambyDivision, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:35.809 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 786 | 32.18 | Code=SoldToCustomerByDivisionDept, Param1=40, Param2=70021414,71059518,71067310,70090866,58124984,58260040,70090867,58099468,58666055,70618872,71060790,58520274,70021343,70318556,70000478,70267799,70174158, Param3=ADMIN, Param4=jaeuk.shin, Param5=, TimeZone=AS054 |
| 20:55:37.649 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1091 | 1751.09 | Code=SiteByEndCustomer, Param1=40, Param2=1X Technologies,ABS,Acculon Energy,ACE KR,Acell,Acell Electronic,acer,Acer BC,Acme,Aeon Motor,Aigo,Airbus,Airtek,Airwheel,AJ상사,Akasol,Akasol Inc,Akku,Alelion,All Good Energy,AllCell,Also,Alta Motors,Alte,Amara Raja Batteries,Amazon,Amazon Prime Air,Amazon Ro |
| 20:55:37.883 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 105.13 | Code=FromSiteByDivisionOspPack, Param1=40, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 20:55:37.904 | load | GSCM.SSP.Plan.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 6.05 |  |
| 20:55:37.945 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 22 | 22.0 | Code=Measure, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.182 | load | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 91 | 221.06 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Pack Biz |
| 20:55:38.195 | load | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 91 | 7.37 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Pack Biz |
| 20:55:38.209 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 5.29 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.217 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.81 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.225 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.05 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.235 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 5.17 | Code=Measure, Param1=SSP0026, Param2=Pack Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.277 | load | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 89 | 7.26 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Cell Biz |
| 20:55:38.286 | load | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 89 | 4.87 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Cell Biz |
| 20:55:38.297 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.8 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.310 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 8.79 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.320 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 6.27 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.329 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 32 | 3.78 | Code=Measure, Param1=SSP0026, Param2=Cell Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.357 | load | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 73 | 6.13 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Shipment Request Detail |
| 20:55:38.367 | load | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 73 | 5.87 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Shipment Request Detail |
| 20:55:38.376 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 35 | 4.32 | p_program_id=SSP0026, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail |
| 20:55:38.386 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 3.94 | Code=PlantSiteByDivisionOSP, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.396 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.5 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.405 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.24 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.415 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 6.19 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:38.431 | load | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 73 | 5.57 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Shipment Result Detail |
| 20:55:38.441 | load | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 73 | 4.77 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Shipment Result Detail |
| 20:55:38.451 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 12 | 5.03 | p_program_id=SSP0026, p_user_id=jaeuk.shin, p_sheet_name=Shipment Result Detail |
| 20:55:38.465 | load | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 73 | 6.19 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Shipment Request Detail Excel |
| 20:55:38.477 | load | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 73 | 5.63 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Shipment Request Detail Excel |
| 20:55:38.489 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 10 | 6.08 | p_program_id=SSP0026, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request Detail Excel |
| 20:55:38.599 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 83.76 | MenuID=Shipment Request(Mobility & IT), CnntCode=0104001, UserID=jaeuk.shin |
| 20:55:38.725 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.47 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0026 |
| 20:55:48.487 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 5.23 | Code=Measure, Param1=SSP0026, Param2=Pack Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:48.514 | find | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 91 | 6.01 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Pack Biz |
| 20:55:48.526 | find | GSCM.SSP.Plan.WSL | SSP0026_GET_SPREAD_TITLE | 91 | 6.47 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20261109, p_end_dt=20270106, p_sheet_name=Pack Biz |
| 20:55:48.540 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.42 | Code=TransportMode, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:48.551 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 6.97 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:48.559 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 4.33 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:55:48.570 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 6.02 | Code=Measure, Param1=SSP0026, Param2=Pack Biz, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:56:08.861 | find | GSCM.SSP.Plan.WSL | SSP0026_GET_SHIPMENT_REQUEST_PACK | 301 | 20262.21 | p_sheet_name=Pack Biz, p_division_id=40, p_team_id=, p_customer=, p_scm_site_id=, p_plant_site_id=CN00254300_40-P,CN00732500_40-P,CN02072800_40-P,IN00142000_40-P,KR00496300_40-P,KR00781800_40-P,KR00797800_40-P,KR00995200_40-P,KR01297200_40-P,KR02265100_40_KR-P,KR02265100_40-P,KR03346900_40-P,KR04595 |
| 20:56:09.127 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.36 | p_menu_id=SSP0026, p_log_type=FIND, p_log_cnt=, p_db_time=20.289, p_ui_time=0.235, p_user_id=jaeuk.shin |
| 20:56:09.180 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.89 | p_menu_id=SSP0026, p_log_type=FIND, p_log_cnt=, p_db_time=20.289, p_ui_time=0.288, p_user_id=jaeuk.shin |
| 20:56:14.703 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.75 | MenuID=Shipment Request(Mobility & IT), CnntCode=0104002, UserID=jaeuk.shin |
| 20:56:14.771 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 6 | 6.98 | Code=ShipmentRequestPlantSite, Param1=40, Param2=P, Param3=E, Param4=, Param5=, Param6=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem5 | btnItemID2 |  |
| layoutControlItem6 | btnSearch |  |
| Model | txtItemld2 |  |
| Lot ID | txtLotID |  |
| Nick Name | textNickName2 |  |
| Requestor | txtRequestor |  |
| Shipment Date | drpPeriod2 |  |
| layoutControlItem28 | btnRequestor |  |
| Team | clbTeam |  |
| End Customer | clbCustomer |  |
| Period | drpPeriod |  |
| Sales Site | clbSalesSite |  |
| Model | txtItemId |  |
| Project | txtProject |  |
| layoutControlItem3 | btnProject |  |
| layoutControlItem1 | btnItemId |  |
| Div | cboDivision |  |
| Bucket | cboBucketType |  |
| layoutControlItem4 | btnMeasure |  |
| layoutControlItem11 | chkPastPeriod |  |
| Excel Form | formDown |  |
| Upload | btnExcelUpload |  |
| Plant Site | clbPlantSite |  |
| layoutControlItem5 | chkSum |  |
| layoutControlItem2 | btnColumn |  |

## 그리드

- spdMain / Pack Biz: 행 301 · 컬럼 93(보임 77) · 헤더 3단 · 고정 컬럼 20
- spdMain / Cell Biz: 행 0 · 컬럼 90(보임 75) · 헤더 3단 · 고정 컬럼 17
- spdDetail / Shipment Request Detail: 행 0 · 컬럼 36(보임 35) · 헤더 1단 · 고정 컬럼 0
- spdDetail / Shipment Result Detail: 행 0 · 컬럼 13(보임 12) · 헤더 1단 · 고정 컬럼 0
- spdSub / Shipment Request Detail Excel: 행 0 · 컬럼 11(보임 10) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
