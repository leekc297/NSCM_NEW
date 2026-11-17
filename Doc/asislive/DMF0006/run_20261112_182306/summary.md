# AS-IS 실측 요약 — DMF0006

- 실행: 2026-11-12 18:23:06.911 ~ 2026-11-12 18:24:01.644 · 계정 jaeuk.shin · 상태 OK
- 화면: Customer Model Mapping (GCSM.DM.Master.UIL.DMF0006_CustomerModelMapping)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:23:07.877 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 5.21 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF4001 |
| 18:23:07.910 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.96 | USER_ID= |
| 18:23:08.103 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 4.19 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:23:08.166 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 28.48 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 18:23:08.293 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 109.69 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 18:23:08.665 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 350.29 | Code=SiteByEndCustomer, Param1=81, Param2=,Aeonus,Alte,Ampere Electricity,Ampherr,ANDURIL,ANODE,Arpiem,AS,ATL,Audi,AW,BAE,Banglilai,BEDEO,BMW,Celltech,China Effort(A),Cling Systems,Club Car,CMC,COENSYS,Corvus Norway,CRR,CS Enertech,CS Enertech_KR_OSN,Cummins,Cummins EP,Cummins EP(OTS),Cummins(OTS),D |
| 18:23:08.795 | load | GSCM.DM.Master.WSL | DM0000_GET_COMMON_SPREAD_TITLE | 19 | 73.58 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0006, p_sheet_name=Customer Model Mapping |
| 18:23:08.809 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.16 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:23:08.855 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 41.93 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:23:08.934 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 507 | 73.21 | Code=EndCustomerByDivisionDept, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:23:09.026 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 84.8 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:23:09.207 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 67.37 | MenuID=Customer Model Mapping, CnntCode=0104001, UserID=jaeuk.shin |
| 18:23:09.305 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.75 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF4001 |
| 18:23:28.936 | find | GSCM.DM.Master.WSL | DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | 152 | 11167.98 | p_division_id=81, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id=, p_customer_project_code=, p_customer_model=, p_valid_yn=Y, p_created_by=jaeuk.shin, p_userinfo=ADMIN |
| 18:24:00.869 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.26 | MenuID=Customer Model Mapping, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivisions |  |
| Customer PJT | umltCustomerPJT |  |
| Customer Model | umltCustomerModel |  |
| Project | umltProject |  |
| Team | clbTeam |  |
| layoutControlItem6 | btnProject |  |
| Model / Nickname | umltModel |  |
| layoutControlItem5 | btnModelType |  |
| End Customer | clbEndCustomer |  |
| Active | cboActive |  |
| Sales Site | clbSalesSite |  |

## 그리드

- spdMain / Customer Model Mapping: 행 152 · 컬럼 21(보임 19) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
