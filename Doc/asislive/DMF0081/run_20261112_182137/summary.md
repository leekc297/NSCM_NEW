# AS-IS 실측 요약 — DMF0081

- 실행: 2026-11-12 18:21:37.833 ~ 2026-11-12 18:22:00.519 · 계정 jaeuk.shin · 상태 OK
- 화면: MKT FCST (Auto) (GSCM.DM.Plan.UIL.DMF0081_MktFcst_Auto)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:21:38.325 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.36 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0081 |
| 18:21:38.349 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.26 | USER_ID= |
| 18:21:38.808 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.63 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:21:38.884 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 29.13 | Code=TeambyDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 18:21:38.926 | load | GSCM.SCM.Master.WSL | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 12 | 13.18 | p_division_id=81 |
| 18:21:39.045 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 173 | 112.41 | Code=EndCustomerByDivisionDept, Param1=81, Param2=70021362,58570391,71059518,71059515,58684594,30277380,30303316,70000597,71060742,70000346,58558163,70055754,70055755,58127819,70021298,71060741,70000342,58183074,70618869,58124293,70000344,70000347,70000345,58665469,58611459,70094904,70618870,5852030 |
| 18:21:39.069 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 14 | 2.97 | CODE=EDI_SENDER_CODE, PARAM1=, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 18:21:39.137 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 447 | 31.78 | Code=SiteByEndCustomer, Param1=81, Param2=ALL, Param3=ADMIN, Param4=jaeuk.shin, Param5=, TimeZone=AS054 |
| 18:21:39.201 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 28 | 5.23 | Code=PlantSiteByEndCustomer, Param1=81, Param2=ALL, Param3=ADMIN, Param4=jaeuk.shin, Param5=, TimeZone=AS054 |
| 18:21:39.224 | load | GSCM.DM.Master.WSL | DMF0003_GET_BUCKET_TYPE_CODE | 3 | 4.01 |  |
| 18:21:39.261 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.6 | p_created_by=jaeuk.shin, p_month=6 |
| 18:21:39.281 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.02 | p_created_by=jaeuk.shin, p_month=6 |
| 18:21:39.296 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 3.36 | p_lookup_type=ITEM_TYPE_CODE |
| 18:21:39.696 | load | GSCM.DM.Master.WSL | DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 2 | 386.9 | p_EV_TP_CD=, p_CUST_CO_CD= |
| 18:21:39.710 | load | GSCM.DM.Master.WSL | DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 54 | 6.61 | p_EV_TP_CD=BEV, p_CUST_CO_CD= |
| 18:21:39.744 | load | GSCM.DM.Master.WSL | DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 4 | 3.57 | p_EV_TP_CD=BEV, p_CUST_CO_CD=Audi |
| 18:21:39.820 | load | GSCM.DM.Master.WSL | DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 4 | 3.17 | p_EV_TP_CD=BEV, p_CUST_CO_CD=Audi |
| 18:21:39.917 | load | GSCM.DM.Master.WSL | DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 4 | 3.22 | p_EV_TP_CD=BEV, p_CUST_CO_CD=Audi |
| 18:21:39.942 | load | GSCM.DM.Master.WSL | DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 54 | 6.74 | p_EV_TP_CD=BEV, p_CUST_CO_CD= |
| 18:21:39.979 | load | GSCM.DM.Master.WSL | DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 4 | 3.52 | p_EV_TP_CD=BEV, p_CUST_CO_CD=Audi |
| 18:21:40.001 | load | GSCM.DM.Master.WSL | DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 54 | 6.66 | p_EV_TP_CD=BEV, p_CUST_CO_CD= |
| 18:21:40.038 | load | GSCM.DM.Master.WSL | DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 4 | 3.27 | p_EV_TP_CD=BEV, p_CUST_CO_CD=Audi |
| 18:21:40.119 | load | GSCM.DM.Master.WSL | DMF0081_GET_SPREAD_TITLE | 0 | 27.3 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81 |
| 18:21:40.347 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 76.82 | MenuID=MKT FCST (Auto), CnntCode=0104001, UserID=jaeuk.shin |
| 18:21:48.626 | find | GSCM.SCM.Master.WSL | DMF0002_GET_TITLESET_POPUP | 30 | 84.48 | p_program_id=DMF0003, p_sheet_name=Mkt Fcst, p_column_type=C, p_user_id=jaeuk.shin, p_division_id=81 |
| 18:21:48.666 | find | GSCM.DM.Master.WSL | DMF0081_GET_SPREAD_TITLE | 0 | 4.83 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=81 |
| 18:21:59.812 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.18 | MenuID=MKT FCST (Auto), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| ▼ 당사 M/S(%): | txtMarketShare |  |
| ▼ BIZ수량 PER CAR: | txtBizPerCar |  |
| ▼ Type:  | cmbType |  |
| ▼ 모델명: | cmbCarModel |  |
| ▼ BIZ TYPE: | cmbBizType |  |
| layoutControlItem17 | btnExcelUpload |  |
| ▼ PERIOD: | drpPeriod1 |  |
| ▼ 제조사:  | cmbCarMaker |  |
| layoutControlItem20 | btnCalculation |  |
|   | clbTeam |  |
| End Customer | clbCustomer |  |
| Biz Type | clbBizType |  |
|   | clbSalesSite |  |
|   | txtItemId |  |
|   | txtProject |  |
| layoutControlItem1 | btnItemId |  |
|   | clbPlantSite |  |
| layoutControlItem5 | chkSum |  |
|   | clbItemType |  |
|   | clbDivision |  |
| . | cboQty |  |
| . | cboCellQty |  |
| lciASCheck | cboAS |  |
| layoutControlItem6 | chkColor |  |
| Sender Code | clbEDISender |  |
| layoutControlItem3 | btnProject |  |
| layoutControlItem2 | btnColumn |  |
| layoutControlItem4 | btnMeasure |  |
| Period | drpPeriod |  |
| layoutControlItem7 | btnIncotermsChg |  |
| layoutControlItem8 | btnOwner |  |
| Owner | txtOwner |  |
| layoutControlItem21 | cboBucketType |  |

## 그리드

- spdSub1 / PSI: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0
- spdSub2 / Car Fcst: 행 0 · 컬럼 0(보임 0) · 헤더 2단 · 고정 컬럼 0
- spdMain / Mkt Fcst: 행 0 · 컬럼 0(보임 0) · 헤더 3단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:21:49.057 [GSCM] 시스템 오류입니다. 담당자에게 화면 캡쳐해서 시스템 담당자에게 전달하세요. → default_button(id=1)
