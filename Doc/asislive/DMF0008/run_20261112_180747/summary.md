# AS-IS 실측 요약 — DMF0008

- 실행: 2026-11-12 18:07:47.614 ~ 2026-11-12 18:08:29.346 · 계정 jaeuk.shin · 상태 OK
- 화면: ERP EDI MASTER 정비 (GSCM.DM.Master.UIL.DMF0008_ErpEdiMaster)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:07:47.931 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.52 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:48.017 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0008 |
| 18:07:48.041 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.99 | USER_ID= |
| 18:07:48.138 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 20.48 | LOGTYPE=SpeedUp, NOTE=DMF0008
division_id_changed
start
, USER_ID=jaeuk.shin |
| 18:07:48.157 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.55 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:07:49.231 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 1060.2 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:07:49.431 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 63.53 | LOGTYPE=SpeedUp, NOTE=DMF0008
division_id_changed
end
, USER_ID=jaeuk.shin |
| 18:07:49.442 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 10.45 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 18:07:49.457 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 10.81 | p_created_by=jaeuk.shin, p_month=6 |
| 18:07:49.518 | load | GSCM.DM.Master.WSL | DMF0004_GET_SOLDTO_CUSTOMER_DATA | 716 | 51.34 | p_division_id=40, p_dept_id=ALL |
| 18:07:49.541 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.37 | Code=MyDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.589 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 5 | 39.82 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0008, p_sheet_name=SUMMARY, p_division_id=40 |
| 18:07:49.607 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 22 | 11.24 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0008, p_sheet_name=REPAIR, p_division_id=40 |
| 18:07:49.635 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 25 | 12.92 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0008, p_sheet_name=SALES_SITE, p_division_id=40 |
| 18:07:49.653 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1920 | 11.6 | Code=EndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.681 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1766 | 10.93 | Code=SoldCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.702 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 25 | 3.96 | Code=COMPANY_ID_INTERNAL_TXN, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.758 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 43 | 23.43 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0008, p_sheet_name=SSPM, p_division_id=40 |
| 18:07:49.850 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 77 | 84.54 | Code=TeambyDivision2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.859 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 37 | 3.49 | Code=CUST_GROUP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.875 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1920 | 12.54 | Code=EndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.903 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1350 | 13.75 | Code=ScmSitebyEndCustomer40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.919 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 4.24 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.927 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.41 | Code=PRODUCTION_PROCESS, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.936 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 17 | 3.95 | Code=SalesCompany, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.945 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 4.49 | Code=SalesPlant, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.958 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 7.8 | Code=SoldToCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.974 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 8.12 | Code=EndCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.984 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.25 | Code=CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:49.993 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.65 | Code=APPLICATION, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.006 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 8.75 | Code=ROUTE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.015 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.47 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.024 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.86 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.036 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.9 | Code=DMF0005_REPORT_GROUP1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.045 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 4.29 | Code=DMF0005_REPORT_GROUP2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.052 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.72 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.059 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.0 | Code=DMF0005_REPORT_GROUP4, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.066 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 3.67 | Code=DMF0005_REPORT_GROUP6, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.076 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.28 | Code=Auth_Dept, Param1=jaeuk.shin, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.085 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.47 | Code=Auth_Dept, Param1=jaeuk.shin, Param2=ADMIN, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:50.736 | load | GSCM.DM.Master.WSL | DMF0000_GET_UPDATE_HISTORY | 1 | 646.86 |  |
| 18:07:50.824 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 49.95 | MenuID=ERP EDI MASTER 정비, CnntCode=0104001, UserID=jaeuk.shin |
| 18:07:50.865 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.03 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0008 |
| 18:07:58.650 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 5 | 5.73 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0008, p_sheet_name=SUMMARY, p_division_id=40 |
| 18:07:58.676 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 43 | 20.07 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0008, p_sheet_name=SSPM, p_division_id=40 |
| 18:07:58.743 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 77 | 61.14 | Code=TeambyDivision2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.750 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 37 | 3.1 | Code=CUST_GROUP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.765 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1920 | 11.09 | Code=EndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.797 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1350 | 13.04 | Code=ScmSitebyEndCustomer40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.816 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.79 | Code=ItemType, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.825 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.99 | Code=PRODUCTION_PROCESS, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.832 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 17 | 3.75 | Code=SalesCompany, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.840 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 4.07 | Code=SalesPlant, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.853 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 7.45 | Code=SoldToCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.868 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 7.28 | Code=EndCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.879 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.79 | Code=CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.888 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.53 | Code=APPLICATION, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.896 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.5 | Code=ROUTE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.904 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.25 | Code=CURRENCY_LIST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.911 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 4.32 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.925 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.11 | Code=DMF0005_REPORT_GROUP1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.933 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 47 | 3.7 | Code=DMF0005_REPORT_GROUP2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.940 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.29 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.947 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.48 | Code=DMF0005_REPORT_GROUP4, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.955 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 3.4 | Code=DMF0005_REPORT_GROUP6, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:07:58.973 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 22 | 13.05 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0008, p_sheet_name=REPAIR, p_division_id=40 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem1 | lblRepair_Cnt |  |
| layoutControlItem2 | usrLabel1 |  |
| layoutControlItem3 | usrLabel2 |  |
| STATUS UPDATE | btnStatusUpdate |  |
| layoutControlItem5 | lblUpdateHistory |  |
| layoutControlItem6 | lblTitle |  |
| Div | clbDivision |  |
| Period* | drpPeriod | Y |

## 그리드

- spdRepair / REPAIR: 행 0 · 컬럼 23(보임 21) · 헤더 1단 · 고정 컬럼 0
- spdSummary / SUMMARY: 행 0 · 컬럼 6(보임 5) · 헤더 1단 · 고정 컬럼 0
- spdSub / SALES_SITE: 행 0 · 컬럼 26(보임 16) · 헤더 1단 · 고정 컬럼 0
- spdSub / SSPM: 행 0 · 컬럼 44(보임 37) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
