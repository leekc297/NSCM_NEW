# DMF0005 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0005_SaleSite_PjtModelMapping\DMF0005_SaleSite_PjtModelMapping.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0005_SaleSite_PjtModelMapping\DMF0005_SaleSite_PjtModelMapping.csproj | 4668 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0005_SaleSite_PjtModelMapping\DMF0005_SaleSite_PjtModelMapping.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0005_SaleSite_PjtModelMapping\DMF0005_SaleSite_PjtModelMapping.csproj | 1152 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0005_SaleSite_PjtModelMapping\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0005_SaleSite_PjtModelMapping\DMF0005_SaleSite_PjtModelMapping.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0005_SaleSite_PjtModelMapping\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0005_SaleSite_PjtModelMapping\DMF0005_SaleSite_PjtModelMapping.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0005_SaleSite_PjtModelMapping\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0005_SaleSite_PjtModelMapping\DMF0005_SaleSite_PjtModelMapping.csproj | 27 |
| shared | 06.UIL\GSCM.DM.Master.UIL\DMF0005_T_SaleSite_PjtModelMapping.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 4143 |
| shared | 06.UIL\GSCM.DM.Master.UIL\DMF0005_T_SaleSite_PjtModelMapping.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1108 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0005_ModelCodeChange.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 329 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0005_ModelCodeChange.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 313 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0005_SaleSite_PjtModelMapping.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 4037 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0005_SaleSite_PjtModelMapping.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1091 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:dsdm.Changed | spdMain_Changed | 2915 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 2919 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 2930 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 2934 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 3201 | biz:CommonData.CommonDataList [code=CompanySalesSite] | BIZ_MATCH |  |
| event:dsdm2.Changed | spdSub_Changed | 2964 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:dsdm2.Changed | spdSub_Changed | 2968 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:dsdm2.Changed | spdSub_Changed | 2979 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:dsdm2.Changed | spdSub_Changed | 2983 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:dsdm2.Changed | spdSub_Changed | 3278 | biz:CommonData.CommonDataList [code=CompanySalesSite] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 918 | DM.DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DMF0005_GET_SALES_SITE_MODEL_PRODUCTION |
| button:FindButton | FindButton > FindData_Main | 996 | DM.DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DMF0005_GET_SALES_SITE_MODEL_PRODUCTION |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 3790 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 4167 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:InsertButton | InsertButton > InsertRow | 2478 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 2479 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 2569 | biz:CommonData.CommonDataList [code=DMF0005_DM_OS_CORP_CD] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 2571 | biz:CommonData.CommonDataList [code=DMF0005_DM_CONTRIBUTION_TYPE_CD] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 2688 | biz:CommonData.CommonDataList [code=CompanySalesSite] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 2693 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:InsertButton | InsertButton > InsertRow | 2806 | biz:CommonData.CommonDataList [code=DMF0005_DM_OS_CORP_CD] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 2808 | biz:CommonData.CommonDataList [code=DMF0005_DM_CONTRIBUTION_TYPE_CD] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow > GetItemType | 3882 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| button:InsertButton | InsertButton > InsertRow > GetItemType | 4259 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| button:InsertButton | InsertButton > InsertRow > Get_DDL_SSPM_CRGE_ORG_NM | 4617 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:InsertButton | InsertButton > InsertRow > Get_DDL_SSPM_CUST_ENG_NM | 4635 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:InsertButton | InsertButton > InsertRow > GetCommonDataList_DM | 4655 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:SaveButton | SaveButton > SaveData | 217 | DM.DMF0005_SAVE_MODEL_CHANGE_POPUP | MATCH | SP DMF0005_SAVE_MODEL_CHANGE_POPUP |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 918 | DM.DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DMF0005_GET_SALES_SITE_MODEL_PRODUCTION |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 996 | DM.DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DMF0005_GET_SALES_SITE_MODEL_PRODUCTION |
| button:SaveButton | SaveButton > SaveData > FindData_Sub | 1022 | DM.DMF0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | SP DMF0005_GET_SALES_SITE_MODEL_PURCHASE |
| button:SaveButton | SaveButton > SaveData > FindData_Sub | 1099 | DM.DMF0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | SP DMF0005_GET_SALES_SITE_MODEL_PURCHASE |
| button:SaveButton | SaveButton > SaveData | 1960 | DM.DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION |
| button:SaveButton | SaveButton > SaveData | 2139 | DM.DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION |
| button:SaveButton | SaveButton > SaveData | 2369 | DM.DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION |
| button:SaveButton | SaveButton > SaveData | 2553 | DM.DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION |
| button:SaveButton | SaveButton > SaveData > FindData_Sub > InitSpread > GetSpdTitle | 3790 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData_Sub > InitSpread > GetSpdTitle | 4167 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 217 | DM.DMF0005_SAVE_MODEL_CHANGE_POPUP | MATCH | SP DMF0005_SAVE_MODEL_CHANGE_POPUP |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData_Main | 918 | DM.DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DMF0005_GET_SALES_SITE_MODEL_PRODUCTION |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData_Main | 996 | DM.DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DMF0005_GET_SALES_SITE_MODEL_PRODUCTION |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData_Main > InitSpread > GetSpdTitle | 3790 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData_Main > InitSpread > GetSpdTitle | 4167 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 3790 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 4167 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetCombo | 314 | DM.UP_FX_GetComboDataList | MATCH | SP UP_FX_GetComboDataList |
| event:this.Load | Form_Load > InitControls | 431 | biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 442 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 444 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > ActiveCell | 475 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls | 479 | biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 494 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 496 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > ActiveCell | 529 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 3790 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 4167 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdMain.CellClick | spdMain_CellClick | 3908 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | spdMain_CellClick | 3920 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | spdMain_CellClick | 4301 | biz:CommonData.CommonDataList [code=CompanySalesSite] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | spdMain_CellClick | 4324 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.CellClick | spdMain_CellClick > Get_DDL_SSPM_CRGE_ORG_NM | 4617 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.CellClick | spdMain_CellClick > Get_DDL_SSPM_CUST_ENG_NM | 4635 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.CellClick | spdMain_CellClick > GetCommonDataList_DM | 4655 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Sub | 1022 | DM.DMF0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | SP DMF0005_GET_SALES_SITE_MODEL_PURCHASE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Sub | 1099 | DM.DMF0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | SP DMF0005_GET_SALES_SITE_MODEL_PURCHASE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Sub > InitSpread > GetSpdTitle | 3790 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Sub > InitSpread > GetSpdTitle | 4167 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 3987 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 3998 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 4442 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted > GetCommonDataList_DM | 4655 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2823 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2836 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 3091 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSiteInfobyDivision | 3747 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSiteInfobyDivision | 4124 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetCommonDataList_DM | 4655 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdSub.CellClick | spdSub_CellClick | 3946 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdSub.CellClick | spdSub_CellClick | 3958 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdSub.CellClick | spdSub_CellClick | 4382 | biz:CommonData.CommonDataList [code=CompanySalesSite] | BIZ_MATCH |  |
| event:this.spdSub.CellClick | spdSub_CellClick | 4401 | biz:CommonData.CommonDataList [code=PlantByDivisionCompany] | BIZ_MATCH |  |
| event:this.spdSub.ClipboardPasted | spdSub_ClipboardPasted | 4027 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdSub.ClipboardPasted | spdSub_ClipboardPasted | 4038 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdSub.ClipboardPasted | spdSub_ClipboardPasted | 4500 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdSub.ClipboardPasted | spdSub_ClipboardPasted > GetCommonDataList_DM | 4655 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 2868 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 2880 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 3147 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange > GetCommonDataList_DM | 4655 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 51 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 97 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=CompanySalesSite] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_COMPANY_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE |
| biz:CommonData.CommonDataList [code=DMF0005_DM_CONTRIBUTION_TYPE_CD] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DMF0005_DM_OS_CORP_CD] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:EXEC:SCM0001_GET_LOOKUP_VALUES |
| biz:CommonData.CommonDataList [code=PlantByDivisionCompany] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN |
| biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH | 11 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH | 11 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 2 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | 2 | SP DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | EXEC:DMF0005_GET_SALES_SITE_MODEL_PRODUCTION, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, CREATE:#T_SINGLE, CREATE:#SCM_MST_SITE_ITEM, CREATE:#INVENTORY_SITE, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#DM_MST_ITEM_SINGLE_V_BEFORE, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#DM_MST_ITEM_SINGLE_V, SELECT:#DM_MST_ITEM_SINGLE_V_BEFORE, INSERT:#INVENTORY_SITE, SELECT:SCM_MST_SITE_ITEM, INSERT:#T_SINGLE, INSERT:#SCM_MST_SITE_ITEM, SELECT:#T_SINGLE, CREATE:#ITEM_ACTIVE_FLAG_INFO, CREATE:#TMP_81_UC_EXCEPTION, INSERT:#ITEM_ACTIVE_FLAG_INFO, SELECT:#DM_MST_ITEM_SINGLE_V, INSERT:#TMP_81_UC_EXCEPTION, REF:FN_GET_DEPT_LIST, REF:FN_GET_MULTI_OWNER_NAME, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, SELECT:#ITEM_ACTIVE_FLAG_INFO, SELECT:DM_MST_CUSTOMER_MODEL, SELECT:#INVENTORY_SITE, SELECT:#SCM_MST_SITE_ITEM, SELECT:#TMP_81_UC_EXCEPTION, SELECT:TB_FX_USER |  |
| DM.DMF0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | 2 | SP DMF0005_GET_SALES_SITE_MODEL_PURCHASE | EXEC:DMF0005_GET_SALES_SITE_MODEL_PURCHASE, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_MULTI_OWNER_NAME, REF:FN_GET_DEPT_LIST, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:#DM_MST_ITEM_SINGLE_V, SELECT:DM_MST_CUSTOMER_MODEL, SELECT:SCM_MST_SSO_USER_INFO, SELECT:TB_FX_USER |  |
| DM.DMF0005_SAVE_MODEL_CHANGE_POPUP | MATCH | 1 | SP DMF0005_SAVE_MODEL_CHANGE_POPUP | EXEC:DMF0005_SAVE_MODEL_CHANGE_POPUP, CREATE:#RESULTS_MST, CREATE:#RESULTS_INSERT, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#RESULTS_MST, UPDATE:A, SELECT:#RESULTS_MST, SELECT:DM_DNM_ITEM_CODE_CHANGE_HISTORY, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:DM_ANL_KPI_RTF_DEMAND, INSERT:#RESULTS_INSERT, SELECT:DM_ANL_KPI_RTF_SALES, SELECT:DM_ANL_KPI_SALES_ACCURACY, SELECT:DM_ANL_KPI_SUMMARY, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:DM_DNM_SALES_RESULT_IF, SELECT:DM_HI_CUST_FCST_INPUT, SELECT:DM_HI_MKT_FCST_CHANGE, SELECT:DM_HI_SALES_INPUT, SELECT:DM_HI_SITE_ITEM_MAPPING, SELECT:DM_HI_SITE_ITEM_MAPPING_ROWDATA, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:DM_MST_BUCKET_CONVERSION_H, SELECT:DM_MST_CAPACITY_ALLOCATION, SELECT:DM_MST_CAPACITY_ALLOCATION_H, SELECT:DM_MST_CUSTOMER_MODEL, SELECT:DM_MST_CUSTOMER_MODEL_H, SELECT:DM_MST_EDI_CUST_MATERIAL_INFO, SELECT:DM_PLN_BP_FCST, SELECT:DM_PLN_BP_FCST_H, SELECT:DM_PLN_CUSTOMER_PSI, SELECT:DM_PLN_CUSTOMER_PSI_H, SELECT:DM_PLN_MKT_FCST, SELECT:DM_PLN_MKT_FCST_CONFIRM, SELECT:DM_PLN_MKT_FCST_H, SELECT:DM_PLN_MKT_FCST_PK_DATA_UPDATE_H, SELECT:DM_PLN_MKT_FCST_RESULT, SELECT:DM_PLN_PR_DETAIL, SELECT:DM_PLN_SALES_PLAN, SELECT:DM_PLN_SALES_PLAN_H, SELECT:DM_PLN_SALES_PLAN_REPORT_H, SELECT:DM_PLN_SALES_PLAN_RESULT, SELECT:SCM_MST_FUTURE_PRICE, SELECT:SCM_MST_FUTURE_PRICE_H, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE_ITEM_H, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_SITE_ITEM_PRIORITY_H, INSERT:DM_DNM_ITEM_CODE_CHANGE_HISTORY, SELECT:#RESULTS_INSERT, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION | MATCH | 4 | SP DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION | EXEC:DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION, CREATE:#RESULTS_MST, CREATE:#TEMP_RESULT_MST, CREATE:#XIF_ERP_SITE_ITEM, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#TEMP_EDI_LT, SELECT:SCM_MST_SITE_ITEM, REF:FN_NEXT_DAY, INSERT:#RESULTS_MST, SELECT:SYSCURSORS, SELECT:#RESULTS_MST, SELECT:DM_PLN_MKT_FCST, SELECT:DM_PLN_BP_FCST, REF:STRING_SPLIT, SELECT:TB_FX_USER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SITE, INSERT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_PROJECT_ITEM, DELETE:#TEMP_RESULT_MST, INSERT:#TEMP_RESULT_MST, SELECT:#TEMP_RESULT_MST, INSERT:#XIF_ERP_SITE_ITEM, MERGE:SCM_MST_SITE_ITEM, UPDATE:SCM_MST_SITE_ITEM, INSERT:SCM_MST_SITE_ITEM_H, EXEC:PR_DM_XIF_ERP_SITE_ITEM_S, INSERT:#TEMP_EDI_TRGT, SELECT:#TEMP_EDI_LT, SELECT:#TEMP_EDI_TRGT, INSERT:#TEMP_EDI_FCST_TABLE, REF:FN_NEXT_WORK_DAY, DELETE:DM_PLN_MKT_FCST, SELECT:#TEMP_EDI_FCST_TABLE, INSERT:DM_PLN_MKT_FCST, INSERT:DM_PLN_MKT_FCST_H, INSERT:SCM_SYS_LOG_BATCH, SELECT:#XIF_ERP_SITE_ITEM, INSERT:XIF_ERP_SITE_ITEM_S_SN, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.UP_FX_GetComboDataList | MATCH | 1 | SP UP_FX_GetComboDataList | EXEC:UP_FX_GETCOMBODATALIST, SELECT:TB_FX_USER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, REF:STRING_SPLIT, SELECT:SCM_MST_PROJECT |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 9 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 4 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_SITE_INFO_BY_DIVISION | EXEC:SCM0001_GET_SITE_INFO_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, REF:STRING_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| EditButton | UserInfoContext.Current | NowGroupID |
| FindData_Main | UserInfoContext.Current | NowGroupID, Dept_ID |
| FindData_Sub | UserInfoContext.Current | NowGroupID |
| GetCombo | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertButton | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| InsertRowLockRangeMain40 | UserInfoContext.Current | NowGroupID |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| spdMain_ClipboardPasted | dtSalesPlant.Rows[0] | CODE |
| spdMain_ClipboardPasted | dtSalesCompany.Rows[0] | CODE |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | dtSalesPlant.Rows[0] | CODE |
| spdMain_ComboSelChange | dtSalesCompany.Rows[0] | CODE |
| spdSub_ClipboardPasted | dtSalesPlant.Rows[0] | CODE |
| spdSub_ClipboardPasted | dtSalesCompany.Rows[0] | CODE |
| spdSub_ComboSelChange | dtSalesPlant.Rows[0] | CODE |
| spdSub_ComboSelChange | dtSalesCompany.Rows[0] | CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:375, SetChangeControl:382, SetChangeControl:390, SetChangeControl:399 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:421, InitControls:428, InitControls:471, EditButton:617, FindData_Main:963, clbDivision_SelectedIndexChanged:3766, clbDivision_SelectedIndexChanged:3775, clbDivision_SelectedIndexChanged:3832 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:553, InitSpread:500 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:556, InitSpread:561, InitSpread:503, InitSpread:508 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:911, SaveButton:810, SaveButton:160, btnButtonList_UsrButtonList_Click_Detected:306 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| FP_Log2 | clbDivision_SelectedIndexChanged:3764, clbDivision_SelectedIndexChanged:3842 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| LoadData | btnModelChange_Click:4528, btnModelChange_Click:4049 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:137 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:138 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:139 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:140 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:141 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:142 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:293 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:329 |
| this.txtProject | KeyDown | txtProject_KeyDown | InitializeComponent:398 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:438 |
| this.clbTeam | SelectedIndexChanged | ClbTeam_SelectedIndexChanged | InitializeComponent:478 |
| this.chkEndCust | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:555 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:592 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:696 |
| this.btnModelChange | Click | btnModelChange_Click | InitializeComponent:769 |
| this.spdSub | ClipboardPasted | spdSub_ClipboardPasted | InitializeComponent:1010 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:1011 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:1012 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:1013 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:1014 |
| this | Load | Form_Load | .ctor:341 |
| dsdm | Changed | spdMain_Changed | DefineProperty:522 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:573 |
| dsdm2 | Changed | shtSubDataModel_Changed | InitEvent:576 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:578 |
| dsdm2 | Changed | spdSub_Changed | FindData_Sub:1136 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:151 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:152 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:153 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:154 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:155 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:156 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:268 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:304 |
| this.txtProject | KeyDown | txtProject_KeyDown | InitializeComponent:373 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:413 |
| this.clbTeam | SelectedIndexChanged | ClbTeam_SelectedIndexChanged | InitializeComponent:453 |
| this.chkEndCust | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:530 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:567 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:671 |
| this.btnModelChange | Click | btnModelChange_Click | InitializeComponent:744 |
| this.spdSub | ClipboardPasted | spdSub_ClipboardPasted | InitializeComponent:969 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:970 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:971 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:972 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:973 |
| this | Load | Form_Load | .ctor:267 |
| dsdm | Changed | spdMain_Changed | DefineProperty:468 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:521 |
| dsdm2 | Changed | shtSubDataModel_Changed | InitEvent:524 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:526 |
| dsdm2 | Changed | spdSub_Changed | FindData_Sub:1059 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:183 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:227 |
| this | Load | Form_Load | .ctor:71 |

## 6. 컨트롤 (90개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 30 | lblSalesSite, layoutControlItem1, lblTeam, lblEndCustomer, lblProject, lblItemId, lblActive, layoutControlItem2, layoutControlItem3, lblDivision, lblOwner, layoutControlItem4, layoutControlItem11, layoutControlItem5, layoutControlItem6 … |
| UsrButton | 8 | btnItemId, btnProject, btnOwner, btnModelChange, btnItemId, btnProject, btnOwner, btnModelChange |
| UsrMultiLineEditor | 6 | txtItemId, txtProject, txtOwner, txtItemId, txtProject, txtOwner |
| UsrCheckedList | 6 | clbEndCustomer, clbTeam, clbSalesSite, clbEndCustomer, clbTeam, clbSalesSite |
| FpSpread | 5 | spdMain, spdSub, spdMain, spdSub, spdMain |
| SheetView | 5 | spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1 |
| UsrCheckBox | 5 | chkProjectInfo, chkEndCust, chkDetail, chkEndCust, chkDetail |
| EmptySpaceItem | 5 | emptySpaceItem3, emptySpaceItem1, emptySpaceItem3, emptySpaceItem1, emptySpaceItem1 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl1, usrLayoutControl1, usrLayoutControl2 |
| UsrCombo | 4 | cboActive, clbDivision, cboActive, clbDivision |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup1, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| SplitContainer | 2 | splitContainer1, splitContainer1 |
| ImageList | 2 | imageList1, imageList1 |
| UsrButtonList | 1 | btnButtonList |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 400 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 150 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 124 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 15 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 1027 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (11건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1098 | DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | commented:MATCH |
| 4139 | DM_H.DMF0000_GET_COMMON_SPREAD_TITLE | commented:MATCH |
| 4138 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | commented:MATCH |
| 4166 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | commented:MATCH |
| 823 | DM.UP_FX_GetComboDataList | commented:MATCH |
| 887 | DM.UP_FX_GetComboDataList | commented:MATCH |
| 886 | UP_FX_GetComboDataList | commented:MATCH_BARE |
| 1021 | DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | commented:MATCH |
| 3762 | DM_H.DMF0000_GET_COMMON_SPREAD_TITLE | commented:MATCH |
| 3761 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | commented:MATCH |
| 3789 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0005 | Production | 16/30 | 9/35 | 9/35 | 9/35 | 9/35 | 9/35 | 9/35 | 13/30 | 0/2 | 0/2 | 0/2 | 0/2 | 0/2 | 0/2 |
| SCM_MST_SHEET_COLUMNS | DMF0005 | Purchase | 0/18 | 7/23 | 7/23 | 7/23 | 7/23 | 7/23 | 7/23 | 3/19 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 16개 시트×division 비교, 차이 464건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Production, Purchase, Sales Site Project Model Popup
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:556, CreateSheetHeaderColumn@InitSpread:561, CreateSheetHeaderColumn@InitSpread:503, CreateSheetHeaderColumn@InitSpread:508
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeaderSpan |  | 4572 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= 20) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| InitializeComponent |  | 158 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 159 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 160 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 161 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1030 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1031 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1032 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1033 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadHeaderSpan |  | 4094 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= 20) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| InitializeComponent |  | 172 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 173 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 174 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 175 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 989 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 990 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 991 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 992 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 130 | 하드코딩 | AddTextColumn | BEFORE | ITEM_ID_BEFORE |  |
| InitSpread |  | 131 | 하드코딩 | AddTextColumn | AFTER | ITEM_ID_AFTER |  |
| InitializeComponent |  | 243 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 244 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 245 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 246 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Production | META+코드연결 | 16 | 9 | 9 | 9 | 9 | 9 | 9 | 13 | · | · | · | · | · | · |
| Purchase | META+코드연결 | · | 7 | 7 | 7 | 7 | 7 | 7 | 3 | · | · | · | · | · | · |
| Sales Site Project Model Popup | 코드 하드코딩 전용(메타 없음) | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
