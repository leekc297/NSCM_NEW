# DMF0081 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0081_MktFcst_Auto\DMF0081_MktFcst_Auto.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0081_MktFcst_Auto\DMF0081_MktFcst_Auto.csproj | 6386 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0081_MktFcst_Auto\DMF0081_MktFcst_Auto.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0081_MktFcst_Auto\DMF0081_MktFcst_Auto.csproj | 3211 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0081_MktFcst_Auto\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0081_MktFcst_Auto\DMF0081_MktFcst_Auto.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0081_MktFcst_Auto\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0081_MktFcst_Auto\DMF0081_MktFcst_Auto.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0081_MktFcst_Auto\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0081_MktFcst_Auto\DMF0081_MktFcst_Auto.csproj | 31 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0081_CustDemandAnalysis.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1555 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0081_CustDemandAnalysis.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 423 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 2174 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 2183 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 4535 | DM.DMF0081_GET_SPREAD_TITLE | MATCH | SP DMF0081_GET_SPREAD_TITLE |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle_PSI | 4552 | DM.DMF0081_GET_SPREAD_TITLE_PSI | MATCH | SP DMF0081_GET_SPREAD_TITLE_PSI |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle_Car | 4571 | DM.DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD | MATCH | SP DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > GetBizTypebyDivision | 4653 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > GetEdiSender | 5218 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:dsdm.Changed | spdMain_Changed | 2691 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 2693 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 2705 | biz:CommonData.CommonDataList [code=DM_VMI_YN] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 2741 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 2750 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 1411 | DM.DMF0003_GET_MKT_FCST_DATA | MATCH | SP DMF0003_GET_MKT_FCST_DATA |
| button:FindButton | FindButton > FindData | 1560 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 4535 | DM.DMF0081_GET_SPREAD_TITLE | MATCH | SP DMF0081_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle_PSI | 4552 | DM.DMF0081_GET_SPREAD_TITLE_PSI | MATCH | SP DMF0081_GET_SPREAD_TITLE_PSI |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle_Car | 4571 | DM.DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD | MATCH | SP DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD |
| button:FindButton | FindButton > FindData > GetTitleSet | 6220 | DM.DMF0002_GET_TITLESET_POPUP | MATCH | SP DMF0002_GET_TITLESET_POPUP |
| button:InsertButton | InsertButton > InsertRow | 1843 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1860 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1883 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow > GetFcstType | 5089 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:InsertButton | InsertButton > InsertRow > GetCustomsHandbook | 5200 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:SaveButton | SaveButton > SaveData | 494 | DM.DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP | MATCH | SP DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP |
| button:SaveButton | SaveButton > SaveData | 556 | DM.DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP | MATCH | SP DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP |
| button:SaveButton | SaveButton > SaveData > GetDM_DEMAND_GAP_ANL_CD | 1193 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:SaveButton | SaveButton > SaveData > FindData | 1411 | DM.DMF0003_GET_MKT_FCST_DATA | MATCH | SP DMF0003_GET_MKT_FCST_DATA |
| button:SaveButton | SaveButton > SaveData > FindData | 1560 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1696 | DM.DMF0003_SAVE_MKT_FCST | MATCH | SP DMF0003_SAVE_MKT_FCST |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 4535 | DM.DMF0081_GET_SPREAD_TITLE | MATCH | SP DMF0081_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle_PSI | 4552 | DM.DMF0081_GET_SPREAD_TITLE_PSI | MATCH | SP DMF0081_GET_SPREAD_TITLE_PSI |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle_Car | 4571 | DM.DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD | MATCH | SP DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD |
| button:SaveButton | SaveButton > SaveData > FindData > GetTitleSet | 6220 | DM.DMF0002_GET_TITLESET_POPUP | MATCH | SP DMF0002_GET_TITLESET_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData | 494 | DM.DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP | MATCH | SP DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData | 556 | DM.DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP | MATCH | SP DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData > GetDM_DEMAND_GAP_ANL_CD | 1193 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.btnCalculation.Click | btnCalculation_Click > GET_DM_YEARLY_MKT_DMD_ANALYSIS > InitSpread_Car > GetSpdTitle_Car | 4571 | DM.DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD | MATCH | SP DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD |
| event:this.btnCalculation.Click | btnCalculation_Click > GET_DM_YEARLY_MKT_DMD_ANALYSIS | 5574 | DM.DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS | MATCH | SP DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 4535 | DM.DMF0081_GET_SPREAD_TITLE | MATCH | SP DMF0081_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle_PSI | 4552 | DM.DMF0081_GET_SPREAD_TITLE_PSI | MATCH | SP DMF0081_GET_SPREAD_TITLE_PSI |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle_Car | 4571 | DM.DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD | MATCH | SP DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 4535 | DM.DMF0081_GET_SPREAD_TITLE | MATCH | SP DMF0081_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle_PSI | 4552 | DM.DMF0081_GET_SPREAD_TITLE_PSI | MATCH | SP DMF0081_GET_SPREAD_TITLE_PSI |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle_Car | 4571 | DM.DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD | MATCH | SP DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD |
| event:this.cboAS.CheckedChanged | cboAS_CheckedChanged > GetSalesSite | 5133 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.cboAS.CheckedChanged | cboAS_CheckedChanged > GetSalesSite40 | 5155 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.clbCustomer.SelectedIndexChanged | clbCustomer_SelectedIndexChanged > GetSalesSite | 5133 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.clbCustomer.SelectedIndexChanged | clbCustomer_SelectedIndexChanged > GetSalesSite40 | 5155 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 2263 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 2266 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.cmbCarMaker.SelectedIndexChanged | cmbCarMaker_SelectedIndexChanged | 5808 | DM.DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | MATCH | SP DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD |
| event:this.cmbType.SelectedIndexChanged | cmbType_SelectedIndexChanged | 5780 | DM.DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | MATCH | SP DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD |
| event:this.Load | Form_Load | 331 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 362 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 377 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 380 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > Select_Data | 853 | DM.DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP | MATCH | SP DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP |
| event:this.Load | Form_Load > Select_Data > InitSpread > GetSpdTitle_PSI_POPUP | 1176 | DM.DMF0081_GET_SPREAD_TITLE_PSI_POPUP | MATCH | SP DMF0081_GET_SPREAD_TITLE_PSI_POPUP |
| event:this.Load | Form_Load > Select_Data > GetDM_DEMAND_GAP_ANL_CD | 1193 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.Load | Form_Load > InitControls > GetDayRange | 4519 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 4535 | DM.DMF0081_GET_SPREAD_TITLE | MATCH | SP DMF0081_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle_PSI | 4552 | DM.DMF0081_GET_SPREAD_TITLE_PSI | MATCH | SP DMF0081_GET_SPREAD_TITLE_PSI |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle_Car | 4571 | DM.DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD | MATCH | SP DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD |
| event:this.Load | Form_Load > InitControls > GetBucketType | 4588 | DM.DMF0003_GET_BUCKET_TYPE_CODE | MATCH | SP DMF0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 4600 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 4653 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetEdiSender | 5218 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.Load | Form_Load > InitControls > CAR_PROPERTY | 5758 | DM.DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | MATCH | SP DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD |
| event:this.spdMain.CellClick | spdMain_CellClick_1 > GetDM_DEMAND_GAP_ANL_CD | 1193 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.CellClick | spdMain_CellClick | 4770 | biz:CommonData.CommonDataList [code=PlantSiteByItem] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | spdMain_CellClick | 4784 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > spdSub1_DATA_BINDING | 5300 | DM.DMF0081_GET_DM_ANL_MKT_PSI_DATA | MATCH | SP DMF0081_GET_DM_ANL_MKT_PSI_DATA |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 4732 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted > GetIncotermsType | 5111 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2366 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2402 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2411 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2440 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2489 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2505 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetBizTypebyDivision | 4653 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetIncotermsType | 5111 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.EditChange | spdMain_EditChange > GetDM_DEMAND_GAP_ANL_CD | 1193 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.LeaveCell | spdMain_LeaveCell > GetDM_DEMAND_GAP_ANL_CD | 1193 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdSub1.CellClick | spdSub1_CellClick > spdSub1_DATA_BINDING | 5300 | DM.DMF0081_GET_DM_ANL_MKT_PSI_DATA | MATCH | SP DMF0081_GET_DM_ANL_MKT_PSI_DATA |
| unreached:(진입점 미연결) | GetSPlant | 656 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| unreached:(진입점 미연결) | GetSLOC | 674 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| unreached:(진입점 미연결) | GetDivision | 4475 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivision | 4489 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomer | 4504 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetItemType2 | 4613 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| unreached:(진입점 미연결) | GetTeambyDivision | 4626 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 4639 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | CAR_REF_DATA | 5659 | DM.DMF0003_GET_DM_ANL_CAR_REF | MATCH | SP DMF0003_GET_DM_ANL_CAR_REF |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DM_VMI_YN] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH | 11 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:DM_MST_CUSTOMER_FCST |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=PlantSiteByItem] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE_ITEM, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GETCOMMONDATALIST_DM:REF:STRING_SPLIT, UP_FX_GETCOMMONDATALIST_DM:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DMF0002_GET_TITLESET_POPUP | MATCH | 1 | SP DMF0002_GET_TITLESET_POPUP | EXEC:DMF0002_GET_TITLESET_POPUP, EXEC:SCM0002_SET_DEFAULT_TITLESET_POPUP, REF:FN_SCM_SYS_NVL, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, REF:STRING_SPLIT, INSERT:SCM_MST_TITLESET_USER |  |
| DM.DMF0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_BUCKET_TYPE_CODE | EXEC:DMF0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0003_GET_DM_ANL_CAR_REF | MATCH | 1 | SP DMF0003_GET_DM_ANL_CAR_REF | EXEC:DMF0003_GET_DM_ANL_CAR_REF, CREATE:#TEMP_DATA, SELECT:SCM_SYS_CALENDAR_M, SELECT:DM_ANL_CAR_FCST_REF, INSERT:#TEMP_DATA, DYNAMIC@DMF0003_GET_DM_ANL_CAR_REF |  |
| DM.DMF0003_GET_MKT_FCST_DATA | MATCH | 1 | SP DMF0003_GET_MKT_FCST_DATA | EXEC:DMF0003_GET_MKT_FCST_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_MST_SHEET_MEASURE, SELECT:TB_FX_USER, REF:FN_MULTY_TIME, CREATE:#T_SSP_SYNC, CREATE:#T_BNP, CREATE:#T_WS_SITE_PLANT, CREATE:#T_WS_FCST, INSERT:#T_WS_FCST, INSERT:#T_WS_SITE_PLANT, INSERT:#T_SSP_SYNC, SELECT:DM_PLN_MKT_FCST, SELECT:#T_WS_FCST, REF:STRING_SPLIT, INSERT:#T_BNP, SELECT:DM_PLN_PR_DETAIL, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, UPDATE:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, CREATE:#TEMPSELECTMEASURE, CREATE:#TEMPVMIDIO, INSERT:#TEMPVMIDIO, SELECT:SCP_MST_DIO, SELECT:SCM_MST_SITE, CREATE:#TEMPSITEITEMALL, CREATE:#TEMPMKTFCSTDATA, CREATE:#TEMPSHIPMENTPLAN, CREATE:#TEMPINTRANSITDATA, INSERT:#TEMPSELECTMEASURE, SELECT:DM_MST_CUSTOMER_FCST, SELECT:#TEMPSELECTMEASURE, DELETE:#TEMPSELECTMEASURE, UPDATE:#TEMPSELECTMEASURE, INSERT:#TEMPSITEITEMALL, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_CITY, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_SSO_DEPT_INFO, INSERT:#TEMPSITEITEM, SELECT:#TEMPSITEITEMALL, CREATE:#T_EDI_SENDER, INSERT:#T_EDI_SENDER, CREATE:#T_LAST_DATA_SETUP, INSERT:#T_LAST_DATA_SETUP, SELECT:DM_PLN_MKT_FCST_RESULT, CREATE:#TEMP_EDI_END_CUSTOMER |  |
| DM.DMF0003_SAVE_MKT_FCST | MATCH | 1 | SP DMF0003_SAVE_MKT_FCST | EXEC:DMF0003_SAVE_MKT_FCST, CREATE:#SEND_TARGET_DATA, CREATE:#T_PRICE, CREATE:#RESULTS, CREATE:#TMP_DM_PLN_MKT_FCST, CREATE:#INVENTORY_SITE, EXEC:PR_DM_SYS_LOG_BATCH, INSERT:#INVENTORY_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V_ALL, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, REF:FN_NEXT_DAY, SELECT:SCM_MST_SITE, INSERT:#RESULTS, SELECT:SCM_SYS_CALENDAR_M, SELECT:#RESULTS, INSERT:#T_PRICE, SELECT:SCM_MST_FUTURE_PRICE, UPDATE:A, SELECT:NERP_CONV_MASTER, SELECT:SCM_MST_PROJECT, INSERT:#MSHYCHU1, INSERT:#MSHYCHU2, INSERT:#ESS_PRICE_EXCEPT_MODEL, SELECT:#T_PRICE, SELECT:#MSHYCHU1, SELECT:#MSHYCHU2, SELECT:#ESS_PRICE_EXCEPT_MODEL, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V_ALL, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:DM_PLN_MKT_FCST, INSERT:#T_ERR, SELECT:#T_ERR, SELECT:SCM_MST_BOM_ENG_SN, SELECT:SCP_MST_BOD_V, SELECT:SCM_MST_SITE_CUSTOMER, INSERT:#T_ERR2, SELECT:DM_PLN_PR_DETAIL, SELECT:#T_ERR2, DELETE:DM_PLN_MKT_FCST, INSERT:DM_PLN_MKT_FCST, SELECT:SYSCURSORS, SELECT:DM_PLN_MKT_FCST_RESULT, DELETE:A, INSERT:DM_PLN_MKT_FCST_H, SELECT:DM_MST_CUSTOMER_FCST, INSERT:#TMP_DM_PLN_MKT_FCST, SELECT:#TMP_DM_PLN_MKT_FCST, INSERT:#SEND_TARGET_DATA, SELECT:#SEND_TARGET_DATA, EXEC:PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE, EXEC:DMF0003_MKT_FCST_SALES_PLAN_SYNC |  |
| DM.DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP | MATCH | 1 | SP DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP | EXEC:DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:DM_CUST_DEMAND_ANL_DETAIL |  |
| DM.DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | MATCH | 3 | SP DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | EXEC:DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD, SELECT:DM_YEARLY_MKT_DMD_ANALYSIS |  |
| DM.DMF0081_GET_DM_ANL_MKT_PSI_DATA | MATCH | 1 | SP DMF0081_GET_DM_ANL_MKT_PSI_DATA | EXEC:DMF0081_GET_DM_ANL_MKT_PSI_DATA, CREATE:#T1_RAW, INSERT:#T1_RAW, SELECT:DM_CUST_DEMAND_ANL_SUMMARY, SELECT:DM_CUST_DEMAND_ANL_DETAIL, SELECT:W_T4, SELECT:#T1_RAW |  |
| DM.DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS | MATCH | 1 | SP DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS | EXEC:DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS |  |
| DM.DMF0081_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0081_GET_SPREAD_TITLE | EXEC:DMF0081_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD | MATCH | 1 | SP DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD | EXEC:DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0081_GET_SPREAD_TITLE_PSI | MATCH | 1 | SP DMF0081_GET_SPREAD_TITLE_PSI | EXEC:DMF0081_GET_SPREAD_TITLE_PSI, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0081_GET_SPREAD_TITLE_PSI_POPUP | MATCH | 1 | SP DMF0081_GET_SPREAD_TITLE_PSI_POPUP | EXEC:DMF0081_GET_SPREAD_TITLE_PSI_POPUP, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP | MATCH | 2 | SP DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP | EXEC:DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP, EXEC:PR_SCM_SYS_LOG_BATCH, DELETE:DM_CUST_DEMAND_ANL_DETAIL, INSERT:DM_CUST_DEMAND_ANL_DETAIL, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 9 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 2 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 1 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| cboAS_CheckedChanged | UserInfoContext.Current | NowGroupID |
| cboDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| EditButton | dt8Week.Rows[0] | MONTH_NAME |
| FindData | UserInfoContext.Current | NowGroupID, Dept_ID |
| FindData | ds.Tables[2].Rows[0] | THIS_YYYYMMWW, ISO_WEEK |
| fnValidation | dr | Action |
| GetFcstType | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitSpread_Car | dtCarTitle.Rows[i] | PLAN_YYYYMM |
| InsertRow | UserInfoContext.Current | NowGroupID |
| InsertRow | dt8Week.Rows[0] | MONTH_NAME |
| OnShown | UserInfoContext.Current | NowGroupID |
| SaveData | dr[0] | CODE |
| SaveData | dtDL.Rows[0] | CNT |
| SetSaveData | drNew | Action |
| spdMain_CellClick_1 | dr[0] | CODE |
| spdMain_Changed | dt_VMI_YN.Rows[0] | VMI_VAL |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| spdMain_EditChange | dr[0] | CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| OnShown | OnShown:337 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetCheckedListValue | OnShown:345, InitControls:364, InitControls:369, InitControls:431, FindData:1364, FindData:1365, cboDivision_SelectedIndexChanged:2148, cboDivision_SelectedIndexChanged:2158 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:550 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:551, InitSpread:579, InitSpread:598, InitSpread_Car:5867, InitSpread:213 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:1284, SaveButton:266 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| LoadData | SaveData:1726 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |
| GetHelpServer | HelpButton:6249, HelpButton:1457 | GAppSettings.GetHelpServer | addr |
| GetHelpPort | HelpButton:6250, HelpButton:1458 | GAppSettings.GetHelpPort | port |
| GetHelpPath | HelpButton:6251, HelpButton:1459 | GAppSettings.GetHelpPath | path |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.chkColor | CheckedChanged | chkColor_CheckedChanged | InitializeComponent:419 |
| this.cboAS | CheckedChanged | cboAS_CheckedChanged | InitializeComponent:456 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:528 |
| this.btnIncotermsChg | Click | btnIncotermsChg_Click | InitializeComponent:565 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:641 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:717 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:754 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:790 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:860 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:1054 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:1094 |
| this.contextMenuStrip1 | ItemClicked | contextMenuStrip1_ItemClicked | InitializeComponent:1891 |
| this.spdSub1 | TextTipFetch | spdSub1_TextTipFetch | InitializeComponent:1975 |
| this.spdSub1 | CellClick | spdSub1_CellClick | InitializeComponent:1976 |
| this.spdSub1 | TopChange | spdSub1_TopChange | InitializeComponent:1977 |
| this.rdoSimulation1 | CheckedChanged | rdoSimulation_SelectedIndexChanged | InitializeComponent:2062 |
| this.rdoSimulation2 | CheckedChanged | rdoSimulation_SelectedIndexChanged | InitializeComponent:2074 |
| this.btnManual | Click | btnManual_Click | InitializeComponent:2087 |
| this.rdoSimulation3 | CheckedChanged | rdoSimulation_SelectedIndexChanged | InitializeComponent:2099 |
| this.btnReport | Click | btnReport_Click | InitializeComponent:2108 |
| this.btnToggle | Click | btnToggle_Click | InitializeComponent:2117 |
| this.btnGuide | Click | btnGuide_Click | InitializeComponent:2141 |
| this.cmbType | SelectedIndexChanged | cmbType_SelectedIndexChanged | InitializeComponent:2215 |
| this.btnExcelUpload | Click | btnExcelUpload_Click | InitializeComponent:2294 |
| this.txtMarketShare | Click | txtMarketShare_Click | InitializeComponent:2363 |
| this.txtMarketShare | KeyDown | txtMarketShare_KeyDown | InitializeComponent:2364 |
| this.cmbCarMaker | SelectedIndexChanged | cmbCarMaker_SelectedIndexChanged | InitializeComponent:2399 |
| this.btnCalculation | Click | btnCalculation_Click | InitializeComponent:2477 |
| this.btnUpDown | Click | btnUpDown_Click | InitializeComponent:2823 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:2876 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:2877 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:2878 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:2879 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:2880 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:2881 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:2882 |
| this.splitContainer2 | DoubleClick | splitContainer2_DoubleClick | InitializeComponent:2904 |
| this | Load | Form_Load | .ctor:313 |
| dsdm | Changed | spdMain_Changed | DefineProperty:524 |
| clbDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | DefineProperty:526 |
| cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | DefineProperty:527 |
| dsdm | Changed | spdMain_Changed | spdMain_Changed:3524 |
| dsdm | Changed | spdMain_Changed | spdMain_Changed:3527 |
| dsdm | Changed | spdMain_Changed | spdMain_Changed:3552 |
| dsdm | Changed | spdMain_Changed | spdMain_Changed:3554 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:134 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:146 |
| this.spdMain | CellClick | spdMain_CellClick_1 | InitializeComponent:147 |
| this.spdMain | ComboCloseUp | spdMain_ComboCloseUp | InitializeComponent:148 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:149 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:150 |
| this.btnManual | Click | btnManual_Click | InitializeComponent:237 |
| this | FormClosing | DMF0081_CustDemandAnalysis_FormClosing | InitializeComponent:376 |
| this | Load | Form_Load | .ctor:103 |
| dsdm | Changed | spdMain_Changed | DefineProperty:195 |

## 6. 컨트롤 (159개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 38 | lblTeam, lblCustomer, lblBizType, lblSalesSite, lblModel, lblProject, layoutControlItem1, lblPlantSite, layoutControlItem5, lblItemType, lblDivion, layoutControlItem9, layoutControlItem10, lciASCheck, layoutControlItem6 … |
| SimpleLabelItem | 21 | lblCustomers, lblModels, lblBucketss, lblBizTypes, lblOwners, lblSenderCodes, lblPeriods, lblTeams, lblProjects, lblItemTypes, lblDivisions, lblSalesSites, lblPlantSites, lblTypes, lblmss … |
| EmptySpaceItem | 19 | emptySpaceItem4, emptySpaceItem8, emptySpaceItem1, emptySpaceItem2, emptySpaceItem10, emptySpaceItem11, emptySpaceItem17, emptySpaceItem18, emptySpaceItem19, emptySpaceItem6, emptySpaceItem5, emptySpaceItem9, emptySpaceItem13, emptySpaceItem7, emptySpaceItem12 … |
| UsrButton | 7 | btnOwner, btnIncotermsChg, btnMeasure, btnColumn, btnProject, btnItemId, btnExcelUpload |
| UsrCheckedList | 7 | clbItemType, clbPlantSite, clbSalesSite, clbBizType, clbCustomer, clbTeam, clbEDISender |
| UsrCombo | 6 | cboBucketType, clbDivision, cmbType, cmbCarMaker, cmbCarModel, cmbBizType |
| UsrLayoutControl | 5 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl1, usrLayoutControl3 |
| LayoutControlGroup | 5 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup3, layoutControlGroup1, layoutControlGroup3 |
| UsrCheckBox | 5 | chkColor, cboAS, cboQty, chkSum, cboCellQty |
| ToolStripMenuItem | 4 | Request_PR, View_PR, Add_History, View_History |
| FpSpread | 4 | spdSub1, spdSub2, spdMain, spdMain |
| SheetView | 4 | spdSub1_Sheet1, spdSub2_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| SimpleButton | 4 | btnReport, btnToggle, btnCalculation, btnUpDown |
| UsrMultiLineEditor | 3 | txtProject, txtItemId, txtOwner |
| TableLayoutPanel | 3 | tableLayoutPanel3, tableLayoutPanel4, tableLayoutPanel1 |
| RadioButton | 3 | rdoSimulation1, rdoSimulation2, rdoSimulation3 |
| Button | 3 | btnManual, btnGuide, btnManual |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| FlowLayoutPanel | 2 | flowLayoutPanel1, flowLayoutPanel2 |
| Panel | 2 | panelForRadioBtn, panel1 |
| UsrTextBox | 2 | txtBizPerCar, txtMarketShare |
| UsrLabel | 2 | usrLabel2, usrLabel1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker | 1 | drpPeriod |
| ContextMenuStrip | 1 | contextMenuStrip1 |
| ImageList | 1 | imageList1 |
| Label | 1 | lblSimulation |
| UsrMonthRangePicker | 1 | drpPeriod1 |
| UsrButtonList | 1 | btnButtonList |
| Splitter | 1 | splitter1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 58 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 1 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.SCM_ADM_LOOKUP_MASTER | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 42 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 38 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_H | 4 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 55 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 1 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 10 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 14 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1412 | DM.DMF0003_GET_MKT_FCST_DATA2 | commented:MATCH |
| 4476 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 5829 | DM.DMF0003_GET_DM_ANL_CAR_PROPERTY | commented:MATCH |
| 6219 | SCM.SCM0002_GET_TITLESET_POPUP | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0081 | Car Fcst | · | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0081 | Customer Demand Analysis | · | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0081 | PSI | · | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | · | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0081 | Car Fcst | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |

실제 SP 실행 결과 대조: 18개 시트×division 비교, 차이 168건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Mkt Fcst, PSI, Car Fcst, Customer Demand Analysis
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:551, CreateSheetHeaderColumn@InitSpread:579, CreateSheetHeaderColumn@InitSpread:598, CreateSheetHeaderColumn@InitSpread_Car:5867, CreateSheetHeaderColumn@InitSpread:213
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn, SetSpreadHeaderSpan_SUB1, SetSpreadHeaderSpan_SUB2

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeaderSpan |  | 665 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 678 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| SetSpreadHeaderSpan_SUB1 |  | 756 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ if("0"<= 14) ⟫ switch(sColumnName)case "M3_CUST_FCST_QTY" |
| SetSpreadHeaderSpan_SUB1 |  | 760 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ if("0"<= 14) ⟫ switch(sColumnName)case "M3_MKT_FCST_QTY" |
| SetSpreadHeaderSpan_SUB1 |  | 765 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ if("0"<= 14) ⟫ switch(sColumnName)case "M2_CUST_FCST_QTY" |
| SetSpreadHeaderSpan_SUB1 |  | 769 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ if("0"<= 14) ⟫ switch(sColumnName)case "M2_MKT_FCST_QTY" |
| SetSpreadHeaderSpan_SUB1 |  | 774 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ if("0"<= 14) ⟫ switch(sColumnName)case "M1_CUST_FCST_QTY" |
| SetSpreadHeaderSpan_SUB1 |  | 778 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ if("0"<= 14) ⟫ switch(sColumnName)case "M1_MKT_FCST_QTY" |
| SetSpreadHeaderSpan_SUB1 |  | 791 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= 14) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan_SUB1 |  | 802 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= 14) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| SetSpreadHeaderSpan_SUB1 |  | 845 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= 14) ⟫ switch(sColumnName)case "SUM_06"/"SUM_12"/"PRODUCT_06"/"PRODUCT_12"/"SALE_06"/"SALE_12"/"INVENTORY_06"/"INVENTORY_12"/"TIME_ADJUST_06"/"TIME_ADJUST_12"/"MODEL_MIX_06"/"MODEL_MIX_12"/"SUPPLY_ISSUE_06"/"SUPPLY_ISSUE_12" |
| EditButton |  | 1211 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResultYYYYMMDD.Substring(0, 6)}{?ds.Tables[2].Rows[0]["ISO_WEEK"]} | if(this.fps != null) ⟫ for(iRow <= siMain.GetMaxRowIndex()) ⟫ if(siMain.GetValue("0", siMain.GetColumnIndex("EDIT_FLAG")).ToString() != CAppSetting.StringY) ⟫ else!(string.IsNullOrEmpty(siMain.GetText("0", siMain.GetColumnIndex(CAppSetting.StringAction)))) ⟫ if(siMain.GetText("0", siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI && IsEditMode == true) ⟫ if(iResultCol2 > iStartCol) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) |
| EditButton |  | 1215 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(this.fps != null) ⟫ for(iRow <= siMain.GetMaxRowIndex()) ⟫ if(siMain.GetValue("0", siMain.GetColumnIndex("EDIT_FLAG")).ToString() != CAppSetting.StringY) ⟫ else!(string.IsNullOrEmpty(siMain.GetText("0", siMain.GetColumnIndex(CAppSetting.StringAction)))) ⟫ if(siMain.GetText("0", siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI && IsEditMode == true) ⟫ if(iResultCol2 > iStartCol) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!("0">= 2) |
| EditButton |  | 1219 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?dateTime2.ToString("yyyyMMdd")} | if(this.fps != null) ⟫ for(iRow <= siMain.GetMaxRowIndex()) ⟫ if(siMain.GetValue("0", siMain.GetColumnIndex("EDIT_FLAG")).ToString() != CAppSetting.StringY) ⟫ else!(string.IsNullOrEmpty(siMain.GetText("0", siMain.GetColumnIndex(CAppSetting.StringAction)))) ⟫ if(siMain.GetText("0", siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI && IsEditMode == true) ⟫ if(iResultCol2 > iStartCol) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0) |
| EditButton |  | 1269 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResultYYYYMMDD.Substring(0, 6)}{?ds.Tables[2].Rows[0]["ISO_WEEK"]} | if(this.fps != null) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) |
| EditButton |  | 1273 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(this.fps != null) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!("0">= 2) |
| EditButton |  | 1277 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?dateTime2.ToString("yyyyMMdd")} | if(this.fps != null) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0) |
| FindData |  | 1509 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResultYYYYMMDD.Substring(0, 6)}{?ds.Tables[2].Rows[0]["ISO_WEEK"]} | if(siMain.GetMaxRowIndex() >= 0) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) |
| FindData |  | 1513 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(siMain.GetMaxRowIndex() >= 0) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!("0">= 2) |
| FindData |  | 1520 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?dateTime2.ToString("yyyyMMdd")} | if(siMain.GetMaxRowIndex() >= 0) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues != "DAILY") ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0) |
| InsertRow |  | 2000 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResultYYYYMMDD.Substring(0, 6)}{?ds.Tables[2].Rows[0]["ISO_WEEK"]} | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "Mkt Fcst") ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) |
| InsertRow |  | 2004 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "Mkt Fcst") ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!("0">= 2) |
| InsertRow |  | 2009 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?dateTime.ToString("yyyyMMdd")} | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "Mkt Fcst") ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0) |
| cboBucketType_SelectedIndexChanged |  | 2300 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?dateTime2.ToString("yyyyMMdd")} | if(siMain != null) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0) |
| cboBucketType_SelectedIndexChanged |  | 2310 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResultYYYYMMDD.Substring(0, 6)}{?ds.Tables[2].Rows[0]["ISO_WEEK"]} | if(siMain != null) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) |
| cboBucketType_SelectedIndexChanged |  | 2314 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(siMain != null) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!("0">= 2) |
| SetSpreadColumn |  | 4033 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") != -1) |
| SetSpreadColumn |  | 4036 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") != -1) |
| SetSpreadColumn |  | 4041 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 4043 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") != -1) |
| SetSpreadColumn |  | 4046 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 4051 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") != -1) |
| SetSpreadColumn |  | 4053 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") != -1) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 4062 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResultYYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 4063 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResultYYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 4064 | 표시/라벨 변경 | set:Width | Width = 60 |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResultYYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 4071 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(iso_week == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResultYYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 4072 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(iso_week == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResultYYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 4079 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| SetSpreadColumn |  | 4080 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| btnToggle_Click |  | 6034 | 표시/라벨 변경 | VisibleColumns | 1 |  | if(siSub1 != null) ⟫ for(i <= siSub1.GetMaxColumnIndex()) ⟫ switch(sColumnName)case "M3_CUST_FCST_QTY"/"M3_MKT_FCST_QTY"/"M2_CUST_FCST_QTY"/"M2_MKT_FCST_QTY"/"M1_CUST_FCST_QTY"/"M1_MKT_FCST_QTY" |
| rdoSimulation_SelectedIndexChanged |  | 6082 | 표시/라벨 변경 | VisibleColumns | 1 \|\| 0 |  | if(siSub1 != null) ⟫ switch(sCase)case "3" ⟫ for(i <= siSub1.GetMaxColumnIndex()) ⟫ switch(sColumnName)case "SUM_03"/"PRODUCT_03"/"SALE_03"/"INVENTORY_03"/"TIME_ADJUST_03"/"MODEL_MIX_03"/"SUPPLY_ISSUE_03" |
| rdoSimulation_SelectedIndexChanged |  | 6091 | 표시/라벨 변경 | VisibleColumns | 1 \|\| 0 |  | if(siSub1 != null) ⟫ switch(sCase)case "3" ⟫ for(i <= siSub1.GetMaxColumnIndex()) ⟫ switch(sColumnName)case "SUM_06"/"PRODUCT_06"/"SALE_06"/"INVENTORY_06"/"TIME_ADJUST_06"/"MODEL_MIX_06"/"SUPPLY_ISSUE_06" |
| rdoSimulation_SelectedIndexChanged |  | 6100 | 표시/라벨 변경 | VisibleColumns | 1 \|\| 0 |  | if(siSub1 != null) ⟫ switch(sCase)case "3" ⟫ for(i <= siSub1.GetMaxColumnIndex()) ⟫ switch(sColumnName)case "SUM_12"/"PRODUCT_12"/"SALE_12"/"INVENTORY_12"/"TIME_ADJUST_12"/"MODEL_MIX_12"/"SUPPLY_ISSUE_12" |
| rdoSimulation_SelectedIndexChanged |  | 6119 | 표시/라벨 변경 | VisibleColumns | 1 \|\| 0 |  | if(siSub1 != null) ⟫ switch(sCase)case "6" ⟫ for(i <= siSub1.GetMaxColumnIndex()) ⟫ switch(sColumnName)case "SUM_03"/"PRODUCT_03"/"SALE_03"/"INVENTORY_03"/"TIME_ADJUST_03"/"MODEL_MIX_03"/"SUPPLY_ISSUE_03" |
| rdoSimulation_SelectedIndexChanged |  | 6128 | 표시/라벨 변경 | VisibleColumns | 1 \|\| 0 |  | if(siSub1 != null) ⟫ switch(sCase)case "6" ⟫ for(i <= siSub1.GetMaxColumnIndex()) ⟫ switch(sColumnName)case "SUM_06"/"PRODUCT_06"/"SALE_06"/"INVENTORY_06"/"TIME_ADJUST_06"/"MODEL_MIX_06"/"SUPPLY_ISSUE_06" |
| rdoSimulation_SelectedIndexChanged |  | 6137 | 표시/라벨 변경 | VisibleColumns | 1 \|\| 0 |  | if(siSub1 != null) ⟫ switch(sCase)case "6" ⟫ for(i <= siSub1.GetMaxColumnIndex()) ⟫ switch(sColumnName)case "SUM_12"/"PRODUCT_12"/"SALE_12"/"INVENTORY_12"/"TIME_ADJUST_12"/"MODEL_MIX_12"/"SUPPLY_ISSUE_12" |
| rdoSimulation_SelectedIndexChanged |  | 6156 | 표시/라벨 변경 | VisibleColumns | 1 \|\| 0 |  | if(siSub1 != null) ⟫ switch(sCase)case "12" ⟫ for(i <= siSub1.GetMaxColumnIndex()) ⟫ switch(sColumnName)case "SUM_03"/"PRODUCT_03"/"SALE_03"/"INVENTORY_03"/"TIME_ADJUST_03"/"MODEL_MIX_03"/"SUPPLY_ISSUE_03" |
| rdoSimulation_SelectedIndexChanged |  | 6165 | 표시/라벨 변경 | VisibleColumns | 1 \|\| 0 |  | if(siSub1 != null) ⟫ switch(sCase)case "12" ⟫ for(i <= siSub1.GetMaxColumnIndex()) ⟫ switch(sColumnName)case "SUM_06"/"PRODUCT_06"/"SALE_06"/"INVENTORY_06"/"TIME_ADJUST_06"/"MODEL_MIX_06"/"SUPPLY_ISSUE_06" |
| rdoSimulation_SelectedIndexChanged |  | 6174 | 표시/라벨 변경 | VisibleColumns | 1 \|\| 0 |  | if(siSub1 != null) ⟫ switch(sCase)case "12" ⟫ for(i <= siSub1.GetMaxColumnIndex()) ⟫ switch(sColumnName)case "SUM_12"/"PRODUCT_12"/"SALE_12"/"INVENTORY_12"/"TIME_ADJUST_12"/"MODEL_MIX_12"/"SUPPLY_ISSUE_12" |
| InitializeComponent |  | 1948 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = 2 |  |  |
| InitializeComponent |  | 1993 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1994 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1995 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1996 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2146 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = 1 |  |  |
| InitializeComponent |  | 2787 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2788 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2789 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2790 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2839 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2840 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2841 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2842 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2908 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = 2 |  |  |
| InitializeComponent |  | 166 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 167 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 168 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 169 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Car Fcst | META+코드연결 | · | 2 | 2 | 2 | 2 | 2 | 2 | · | · | · | · | · | · | · |
| Customer Demand Analysis | META+코드연결 | · | 9 | 9 | 9 | 9 | 9 | 9 | · | · | · | · | · | · | · |
| PSI | META+코드연결 | · | 16 | 16 | 16 | 16 | 16 | 16 | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
