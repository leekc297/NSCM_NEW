# AS-IS 실측 요약 — DMF0007

- 실행: 2026-11-12 18:07:28.632 ~ 2026-11-12 18:07:47.521 · 계정 jaeuk.shin · 상태 OK
- 화면: Customer FCST Master (GSCM.DM.Master.UIL.DMF0007_CustFcstMaster)
- 조회 결과:  · DB : 0.773s, UI : 0.081s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:07:29.138 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 128.94 | Code=EndCustomerByDivision40, Param1=40, Param2=ALL, Param3=ADMIN, Param4=jaeuk.shin, Param5=, TimeZone=AS054 |
| 18:07:29.519 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.87 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0007 |
| 18:07:29.547 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.41 | USER_ID= |
| 18:07:29.684 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.91 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:29.748 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 37.76 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 18:07:29.915 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 149.24 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 18:07:30.323 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 385.71 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 18:07:30.364 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.8 | Code=BucketType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:30.421 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 35.53 | Code=UploadUOM, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:30.430 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.93 | Code=Auth_Dept, Param1=jaeuk.shin, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:30.437 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.26 | Code=Auth_Dept, Param1=jaeuk.shin, Param2=ADMIN, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:30.958 | load | GSCM.DM.Master.WSL | DMF0007_GET_SPREAD_TITLE | 144 | 484.07 | p_plan_week=, p_bucket_type=WEEKLY, p_created_by=jaeuk.shin |
| 18:07:30.975 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.71 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.046 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 66.96 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.141 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 85.55 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.165 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.8 | Code=BucketType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.178 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.04 | Code=UploadUOM, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.185 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.05 | Code=BucketType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.612 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 10.15 | Code=SpreadTitle, Param1=DMF0007, Param2=Customer PSI, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.621 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.21 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.697 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 60 | 72.77 | Code=TeambyDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.782 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 81.48 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.865 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 77.51 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.885 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.79 | Code=BucketType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.895 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.77 | Code=CustomerPSI, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.904 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.18 | Code=UploadUOM, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:31.905 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.55 | Code=BucketType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:32.364 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 350.05 | MenuID=Customer FCST Master, CnntCode=0104001, UserID=jaeuk.shin |
| 18:07:32.415 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0007 |
| 18:07:40.296 | find | GSCM.DM.Master.WSL | DMF0007_GET_SPREAD_TITLE | 144 | 15.23 | p_plan_week=, p_bucket_type=WEEKLY, p_created_by=jaeuk.shin |
| 18:07:40.310 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.59 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:40.388 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 73.57 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:40.491 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 91.8 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:40.512 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.41 | Code=BucketType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:40.524 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.08 | Code=UploadUOM, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:40.531 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.18 | Code=BucketType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:41.720 | find | GSCM.DM.Master.WSL | DMF0007_GET_CUST_FCST_DATA | 0 | 766.02 | p_plan_week=, p_division_id=81, p_dept_id=, p_end_customer=ALL, p_scm_site_id=ALL, p_bucket_type=WEEKLY, p_valid_yn=ALL, p_created_by=jaeuk.shin, p_user_group=ADMIN |
| 18:07:41.820 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 9.07 | p_menu_id=DMF0007, p_log_type=FIND, p_log_cnt=, p_db_time=0.773, p_ui_time=0.081, p_user_id=jaeuk.shin |
| 18:07:46.797 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.31 | MenuID=Customer FCST Master, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Team | clbTeam |  |
| End Customer | clbEndCustomer |  |
| Sales Site | clbSalesSite |  |
| Active | cboActive |  |
| Div | clbDivisions |  |
| Bucket Type | cboBucketType |  |

## 그리드

- spdMain / Customer FCST: 행 0 · 컬럼 145(보임 144) · 헤더 2단 · 고정 컬럼 13
- spdMain / Customer PSI: 행 0 · 컬럼 17(보임 15) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
