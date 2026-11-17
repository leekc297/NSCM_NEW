# AS-IS 실측 요약 — DMF0044

- 실행: 2026-11-12 23:27:40.702 ~ 2026-11-12 23:28:13.560 · 계정 jaeuk.shin · 상태 OK
- 화면: Sales Reports (GSCM.DM.Plan.UIL.DMF0044_Sales_Reports)
- 조회 결과:  · DB : 6.988s, UI : 0.069s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "txtSPVersion", "popup": "DMF0044_United_VersionPopup", "opener": "btnSPVer_Click"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:27:41.054 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0044 |
| 23:27:41.077 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.18 | USER_ID= |
| 23:27:41.193 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 29.5 | LOGTYPE=SpeedUp, NOTE=DMF0044
division_id_changed
start
, USER_ID=jaeuk.shin |
| 23:27:41.197 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.86 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:27:41.229 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 6.26 | LOGTYPE=SpeedUp, NOTE=DMF0044
division_id_changed
end
, USER_ID=jaeuk.shin |
| 23:27:41.234 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.13 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 23:27:41.242 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 3.52 | p_lookup_type=MDF_TYPE |
| 23:27:41.317 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 42 | 64.03 | CODE=CALENDAR_YYYY, PARAM1=, PARAM2=, PARAM3=, PARAM4=, PARAM5= |
| 23:27:41.422 | load | GSCM.DM.Master.WSL | DMF0044_GET_MEASURE | 2 | 27.3 | p_Data_Type= |
| 23:27:41.429 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 2.94 | p_lookup_type=MDF_TYPE2 |
| 23:27:41.442 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 11 | 3.06 | p_lookup_type=DM_COMPANY |
| 23:27:41.499 | load | GSCM.DM.Master.WSL | DMF0044_GET_SPREAD_TITLE | 43 | 48.55 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20260101, p_end_dt=20261231 |
| 23:27:41.514 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 4.32 | p_program_id=DMF0044, p_user_id=jaeuk.shin, p_sheet_name=MDF Reports |
| 23:27:41.604 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 84.2 | Code=EndCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.664 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 46.56 | Code=SoldToCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.694 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 21.44 | Code=CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.723 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 22.75 | Code=DMF0005_REPORT_GROUP4, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.733 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 4.41 | Code=DMF0005_REPORT_GROUP6, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.783 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 45.56 | Code=CURRENCY_LIST, Param1=, Param2=160, Param3=140, Param4=Y, Param5=Y, TimeZone=AS054 |
| 23:27:41.789 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 3.2 | Code=DM_COMPANY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.797 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.44 | Code=DM_LOOKUP_DIV, Param1=40, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 23:27:41.804 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.39 | Code=DM_BIZ_TYPE, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.810 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.32 | Code=DMF0005_REPORT_GROUP1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.854 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 40.93 | Code=APPLICATION, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.863 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 5.32 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.872 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.65 | Code=DMF0044_MDF_MEASURE, Param1=, Param2=600, Param3=600, Param4=Y, Param5=Y, TimeZone=AS054 |
| 23:27:41.880 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.89 | Code=FCST_TYPE, Param1=, Param2=60, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 23:27:41.895 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 6.76 | Code=DM_LOOKUP_DIV, Param1=DM_ITEM_USE, Param2=, Param3=40, Param4=, Param5=Y, TimeZone=AS054 |
| 23:27:41.916 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 7.5 | Code=EndCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.930 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 6.47 | Code=SoldToCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.941 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.39 | Code=CUST_GROUP_DTL, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.950 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.55 | Code=DMF0005_REPORT_GROUP4, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.959 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 4.98 | Code=DMF0005_REPORT_GROUP6, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.969 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.73 | Code=CURRENCY_LIST, Param1=40, Param2=, Param3=140, Param4=Y, Param5=Y, TimeZone=AS054 |
| 23:27:41.978 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 3.71 | Code=DM_COMPANY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.985 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.49 | Code=DM_LOOKUP_DIV, Param1=40, Param2=40, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 23:27:41.992 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.53 | Code=DM_BIZ_TYPE, Param1=40, Param2=40, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:41.999 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.65 | Code=DMF0005_REPORT_GROUP1, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:42.008 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.96 | Code=APPLICATION, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:42.017 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.55 | Code=COUNTRY_MST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:42.027 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 4.13 | Code=DMF0044_MDF_MEASURE, Param1=40, Param2=, Param3=600, Param4=Y, Param5=Y, TimeZone=AS054 |
| 23:27:42.163 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 115.72 | MenuID=Sales Reports, CnntCode=0104001, UserID=jaeuk.shin |
| 23:27:42.207 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0044 |
| 23:27:51.341 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.78 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:51.371 | load | GSCM.DM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 3 | 3.4 | p_lookup_type=MDF_TYPE_SP_POPUP |
| 23:27:51.422 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 12 | 8.17 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0044, p_sheet_name=MDFVerpopup, p_division_id=40 |
| 23:27:51.436 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 12 | 7.45 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0044, p_sheet_name=MDFVerpopup, p_division_id=40 |
| 23:27:51.620 | load | GSCM.DM.Master.WSL | DMF0044_GET_SALES_VERSION_POPUP | 1 | 175.91 | p_division_id=40, p_sdt=20261012, p_edt=20270412, p_version_type=REPORT_SP_W, p_Description= |
| 23:27:58.986 | find | GSCM.DM.Master.WSL | DMF0044_GET_SPREAD_TITLE | 43 | 11.89 | p_division_id=40, p_created_by=jaeuk.shin, p_start_dt=20260101, p_end_dt=20261231 |
| 23:27:58.998 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 4.13 | p_program_id=DMF0044, p_user_id=jaeuk.shin, p_sheet_name=MDF Reports |
| 23:27:59.015 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 7.02 | Code=EndCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.031 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 6.24 | Code=SoldToCustReport, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.043 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.32 | Code=CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.054 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.25 | Code=DMF0005_REPORT_GROUP4, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.063 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 3.78 | Code=DMF0005_REPORT_GROUP6, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.074 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.25 | Code=CURRENCY_LIST, Param1=, Param2=160, Param3=140, Param4=Y, Param5=Y, TimeZone=AS054 |
| 23:27:59.083 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 3.28 | Code=DM_COMPANY, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.091 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.32 | Code=DM_LOOKUP_DIV, Param1=40, Param2=, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 23:27:59.098 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.4 | Code=DM_BIZ_TYPE, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.106 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 3.72 | Code=DMF0005_REPORT_GROUP1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.115 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.6 | Code=APPLICATION, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.123 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.07 | Code=COUNTRY_MST, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.131 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.25 | Code=DMF0044_MDF_MEASURE, Param1=, Param2=600, Param3=600, Param4=Y, Param5=Y, TimeZone=AS054 |
| 23:27:59.138 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.09 | Code=FCST_TYPE, Param1=, Param2=60, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 23:27:59.147 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.78 | Code=DM_LOOKUP_DIV, Param1=DM_ITEM_USE, Param2=, Param3=40, Param4=, Param5=Y, TimeZone=AS054 |
| 23:27:59.171 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 923 | 6.59 | Code=EndCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.188 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 761 | 6.58 | Code=SoldToCustReport, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.202 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.22 | Code=CUST_GROUP_DTL, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.210 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 2.96 | Code=DMF0005_REPORT_GROUP4, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.220 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 144 | 3.39 | Code=DMF0005_REPORT_GROUP6, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.229 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.23 | Code=CURRENCY_LIST, Param1=40, Param2=, Param3=140, Param4=Y, Param5=Y, TimeZone=AS054 |
| 23:27:59.236 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 11 | 3.27 | Code=DM_COMPANY, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.244 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.43 | Code=DM_LOOKUP_DIV, Param1=40, Param2=40, Param3=, Param4=Y, Param5=, TimeZone=AS054 |
| 23:27:59.252 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.87 | Code=DM_BIZ_TYPE, Param1=40, Param2=40, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.262 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 31 | 4.42 | Code=DMF0005_REPORT_GROUP1, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.271 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 38 | 3.57 | Code=APPLICATION, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.280 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 249 | 4.83 | Code=COUNTRY_MST, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:27:59.289 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 15 | 3.63 | Code=DMF0044_MDF_MEASURE, Param1=40, Param2=, Param3=600, Param4=Y, Param5=Y, TimeZone=AS054 |
| 23:28:06.363 | find | GSCM.DM.Master.WSL | DMF0044_GET_SALES_REPORTS_DATA | 0 | 6977.15 | division_id=40, p_mdf_type=REPORT_SP_W, p_yyyy=2026, p_sp_version_no=R_S_20261028_V003, p_data_type=ALL, p_user_group=ADMIN, p_created_by=jaeuk.shin |
| 23:28:06.443 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.25 | p_menu_id=DMF0044, p_log_type=FIND, p_log_cnt=, p_db_time=6.988, p_ui_time=0.069, p_user_id=jaeuk.shin |
| 23:28:12.850 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.3 | MenuID=Sales Reports, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| SP Version | txtSPVersion |  |
| layoutControlItem1 | btnSPVer |  |
| Report Type | clbType |  |
| Year | usrYear |  |
| Data Type | usrDataType |  |
| layoutControlItem4 | btnMeasure |  |
| Exchange Rate | btnExchangeRate |  |
| Div | clbDivision |  |
| Text 입력 | btnTextbox |  |

## 그리드

- spdMain / MDF Reports: 행 0 · 컬럼 44(보임 43) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
