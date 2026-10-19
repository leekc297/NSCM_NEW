# DMF0044 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.csproj | 1484 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.csproj | 708 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.csproj | 31 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_MDFVersionPopUp.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 441 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_MDFVersionPopUp.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 481 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_Sales_VersionCopyPopUp.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 452 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_Sales_VersionCopyPopUp.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 519 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_Sales_VersionPopUp.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 445 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_Sales_VersionPopUp.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 530 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_SalesReport_TextboxPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 454 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_SalesReport_TextboxPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 299 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_SalesReportExchangePopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 722 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_SalesReportExchangePopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 416 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_United_VersionPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 728 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_United_VersionPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1203 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0044_Sales_Reports.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1406 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0044_Sales_Reports.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 717 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbType.SelectedIndexChanged | clbType_SelectedIndexChanged > InitSpread | 225 | DM.DMF0044_GET_SPREAD_TITLE | MATCH | SP DMF0044_GET_SPREAD_TITLE |
| event:clbType.SelectedIndexChanged | clbType_SelectedIndexChanged > InitSpread > GetSpdTitle | 274 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:dsdm.Changed | spdMain_Changed > GetLookupData | 1046 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:dsdm.Changed | spdMain_Changed | 1180 | biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 1195 | biz:CommonData.CommonDataList [code=DMF0044_ETC_SALE_RESULT_TYPE_40] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 1224 | biz:CommonData.CommonDataList [code=DMF0044_MDF_ENDCUST_REPORT] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 1244 | biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP2] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > InitSpread | 161 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:FindButton | FindButton > FindData > InitSpread | 167 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 208 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| button:FindButton | FindButton > FindData | 210 | DM.DMF0044_GET_COPY_VERSION_POPUP | MATCH | SP DMF0044_GET_COPY_VERSION_POPUP |
| button:FindButton | FindButton > FindData > InitSpread | 225 | DM.DMF0044_GET_SPREAD_TITLE | MATCH | SP DMF0044_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 233 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| button:FindButton | FindButton > FindData > InitSpread | 263 | DM.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 269 | DM_H.DM0021_GET_DM_MST_VERSION | MATCH | SP DM0021_GET_DM_MST_VERSION |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 274 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 426 | DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP | MATCH | SP DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP |
| button:FindButton | FindButton > FindData | 441 | DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA | MATCH | SP DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA |
| button:FindButton | FindButton > FindData | 458 | DM.DMF0044_GET_SALES_REPORTS_DATA | MATCH | SP DMF0044_GET_SALES_REPORTS_DATA |
| button:InsertButton | InsertButton > InsertRow | 990 | biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM2] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread | 225 | DM.DMF0044_GET_SPREAD_TITLE | MATCH | SP DMF0044_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 247 | DM.DMF0044_GET_TEXTBOX | MATCH | SP DMF0044_GET_TEXTBOX |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread | 263 | DM.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 269 | DM_H.DM0021_GET_DM_MST_VERSION | MATCH | SP DM0021_GET_DM_MST_VERSION |
| button:SaveButton | SaveButton > SaveData | 325 | DM.DMF0044_SAVE_TEXTBOX | MATCH | SP DMF0044_SAVE_TEXTBOX |
| button:SaveButton | SaveButton > SaveData | 327 | DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF | MATCH | SP PR_DM_PLN_SALES_PLAN_CUTOFF |
| button:SaveButton | SaveButton > SaveData | 327 | {?DMF0044_MDFVersionPopUp.sFoxData} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData > FindData | 426 | DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP | MATCH | SP DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP |
| button:SaveButton | SaveButton > SaveData > FindData | 441 | DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA | MATCH | SP DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA |
| button:SaveButton | SaveButton > SaveData > FindData | 458 | DM.DMF0044_GET_SALES_REPORTS_DATA | MATCH | SP DMF0044_GET_SALES_REPORTS_DATA |
| button:SaveButton | SaveButton > SaveData | 579 | DM.DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT | MATCH | SP DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT |
| button:SaveButton | SaveButton > SaveData | 656 | DM.DMF0044_SAVE_SALES_PLAN_REPORT_C | MATCH | SP DMF0044_SAVE_SALES_PLAN_REPORT_C |
| button:SaveButton | SaveButton > SaveData | 904 | DM.DMF0044_SAVE_SALES_PLAN_REPORT_C_CF | MATCH | SP DMF0044_SAVE_SALES_PLAN_REPORT_C_CF |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindButton > FindData > InitSpread | 161 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindButton > FindData > InitSpread | 167 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindButton > FindData | 208 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindButton > FindData | 210 | DM.DMF0044_GET_COPY_VERSION_POPUP | MATCH | SP DMF0044_GET_COPY_VERSION_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 247 | DM.DMF0044_GET_TEXTBOX | MATCH | SP DMF0044_GET_TEXTBOX |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData > InitSpread | 263 | DM.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 269 | DM_H.DM0021_GET_DM_MST_VERSION | MATCH | SP DM0021_GET_DM_MST_VERSION |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 306 | DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY | MATCH | SP DMF0044_SAVE_SALES_PLAN_VERSION_COPY |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 306 | DM.DMF0044_SAVE_BIZ_PLAN_VERSION_COPY | MATCH | SP DMF0044_SAVE_BIZ_PLAN_VERSION_COPY |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 325 | DM.DMF0044_SAVE_TEXTBOX | MATCH | SP DMF0044_SAVE_TEXTBOX |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 327 | DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF | MATCH | SP PR_DM_PLN_SALES_PLAN_CUTOFF |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 327 | {?DMF0044_MDFVersionPopUp.sFoxData} | UNRESOLVED |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 426 | DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP | MATCH | SP DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 441 | DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA | MATCH | SP DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 579 | DM.DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT | MATCH | SP DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT |
| event:this.btnCopy.Click | btnCopy_Click > FindData > InitSpread | 167 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnCopy.Click | btnCopy_Click > FindData | 208 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread | 225 | DM.DMF0044_GET_SPREAD_TITLE | MATCH | SP DMF0044_GET_SPREAD_TITLE |
| event:this.btnTranCancel.Click | btnTranCancel_Click > DMF0044_MOBILE_REPORT_CREATE > FindData | 233 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| event:this.btnTranCancel.Click | btnTranCancel_Click > DMF0044_MOBILE_REPORT_CREATE > FindData > InitSpread > GetSpdTitle | 274 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnTranCancel.Click | btnTranCancel_Click > DMF0044_MOBILE_REPORT_CREATE | 595 | DM.DMF0044_MOBILE_REPORT_CREATE | MATCH | SP DMF0044_MOBILE_REPORT_CREATE |
| event:this.btnTransfer.Click | btnTransfer_Click > DMF0044_MOBILE_REPORT_CREATE > FindData | 233 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| event:this.btnTransfer.Click | btnTransfer_Click > DMF0044_MOBILE_REPORT_CREATE > FindData > InitSpread > GetSpdTitle | 274 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnTransfer.Click | btnTransfer_Click | 406 | DM.DMF0044_MOBILE_REPORT_CREATE | MATCH | SP DMF0044_MOBILE_REPORT_CREATE |
| event:this.btnTransfer.Click | btnTransfer_Click | 411 | DM.DMF0044_MOBILE_REPORT_CREATE | MATCH | SP DMF0044_MOBILE_REPORT_CREATE |
| event:this.btnTransfer.Click | btnTransfer_Click > DMF0044_MOBILE_REPORT_CREATE | 595 | DM.DMF0044_MOBILE_REPORT_CREATE | MATCH | SP DMF0044_MOBILE_REPORT_CREATE |
| event:this.btnVerCopy.Click | btnVerCopy_Click > DMF0044_SAVE_SALES_PLAN_VERSION_COPY > FindData | 233 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| event:this.btnVerCopy.Click | btnVerCopy_Click > DMF0044_SAVE_SALES_PLAN_VERSION_COPY > FindData > InitSpread > GetSpdTitle | 274 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnVerCopy.Click | btnVerCopy_Click > DMF0044_SAVE_SALES_PLAN_VERSION_COPY | 647 | DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY | MATCH | SP DMF0044_SAVE_SALES_PLAN_VERSION_COPY |
| event:this.btnVerCre.Click | btnVerCre_Click > DMF0044_SAVE_SALES_PLAN_VERSION_COPY > FindData | 233 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| event:this.btnVerCre.Click | btnVerCre_Click > DMF0044_SAVE_SALES_PLAN_VERSION_COPY > FindData > InitSpread > GetSpdTitle | 274 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnVerCre.Click | btnVerCre_Click > DMF0044_SAVE_SALES_PLAN_VERSION_COPY | 647 | DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY | MATCH | SP DMF0044_SAVE_SALES_PLAN_VERSION_COPY |
| event:this.btnVerDel.Click | btnVerDel_Click > DMF0044_SAVE_SALES_PLAN_VERSION_COPY > FindData | 233 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| event:this.btnVerDel.Click | btnVerDel_Click > DMF0044_SAVE_SALES_PLAN_VERSION_COPY > FindData > InitSpread > GetSpdTitle | 274 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnVerDel.Click | btnVerDel_Click > DMF0044_SAVE_SALES_PLAN_VERSION_COPY | 647 | DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY | MATCH | SP DMF0044_SAVE_SALES_PLAN_VERSION_COPY |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread | 225 | DM.DMF0044_GET_SPREAD_TITLE | MATCH | SP DMF0044_GET_SPREAD_TITLE |
| event:this.clbType.SelectedIndexChanged | clbType_SelectedIndexChanged > InitSpread | 225 | DM.DMF0044_GET_SPREAD_TITLE | MATCH | SP DMF0044_GET_SPREAD_TITLE |
| event:this.clbType.SelectedIndexChanged | clbType_SelectedIndexChanged > InitSpread > GetSpdTitle | 274 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 117 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 130 | biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 132 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 133 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 135 | biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 135 | biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 136 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 136 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 141 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > InitSpread | 161 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData > InitSpread | 167 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData | 208 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| event:this.Load | Form_Load > FindData | 210 | DM.DMF0044_GET_COPY_VERSION_POPUP | MATCH | SP DMF0044_GET_COPY_VERSION_POPUP |
| event:this.Load | Form_Load > CreateSpread > InitSpread | 225 | DM.DMF0044_GET_SPREAD_TITLE | MATCH | SP DMF0044_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData | 233 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| event:this.Load | Form_Load > FindData | 247 | DM.DMF0044_GET_TEXTBOX | MATCH | SP DMF0044_GET_TEXTBOX |
| event:this.Load | Form_Load > FindData > InitSpread | 263 | DM.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData | 269 | DM_H.DM0021_GET_DM_MST_VERSION | MATCH | SP DM0021_GET_DM_MST_VERSION |
| event:this.Load | Form_Load > FindData > InitSpread > GetSpdTitle | 274 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetLookupData | 364 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > FindData | 426 | DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP | MATCH | SP DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP |
| event:this.Load | Form_Load > FindData | 441 | DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA | MATCH | SP DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA |
| event:this.Load | Form_Load > InitControls > GetLookupData | 1046 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetMeasure | 1060 | DM.DMF0044_GET_MEASURE | MATCH | SP DMF0044_GET_MEASURE |
| event:this.Load | Form_Load > InitControls > YearSet > GetCalendarYYYY | 1098 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.usrButton1.Click | usrButton1_Click > FindData | 233 | DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | SP DMF0044_GET_SALES_VERSION_POPUP |
| event:this.usrButton1.Click | usrButton1_Click > FindData > InitSpread > GetSpdTitle | 274 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| unreached:(진입점 미연결) | GetLookupValues | 294 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?DMF0044_MDFVersionPopUp.sFoxData} | UNRESOLVED | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP2] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO |
| biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM2] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DMF0044_ETC_SALE_RESULT_TYPE_40] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DMF0044_MDF_ENDCUST_REPORT] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:DM_MST_ITEM_SINGLE_V |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| DM_H.DM0021_GET_DM_MST_VERSION | MATCH | 1 | SP DM0021_GET_DM_MST_VERSION | EXEC:DM0021_GET_DM_MST_VERSION, SELECT:DM_MST_VERSION, REF:UF_FX_STRING_SPLITFORIN, SELECT:SPLIT |  |
| DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF | MATCH | 1 | SP PR_DM_PLN_SALES_PLAN_CUTOFF | EXEC:PR_DM_PLN_SALES_PLAN_CUTOFF, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:PR_DM_PLN_VERSION_CREATE, INSERT:DM_PLN_SALES_PLAN_C, SELECT:DM_PLN_SALES_PLAN, REF:FN_NEXT_DAY, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:DM_PLN_SALES_ETC_PLAN_C, SELECT:DM_PLN_SALES_ETC_PLAN, INSERT:DM_PLN_SALES_PLAN_RESULT_C, SELECT:DM_PLN_SALES_PLAN_RESULT, EXEC:PR_SCM_MST_FUTURE_PRICE_CUTOFF, EXEC:PR_DM_MST_EXCHANGE_RATE_CUTOFF, INSERT:SCM_SYS_LOG_BATCH, SELECT:DM_MST_VERSION, INSERT:DM_MST_VERSION, INSERT:#TEMP_USE_MEASURE, DELETE:SCM_MST_FUTURE_PRICE_C, DELETE:DM_PLN_CFM_SELLING_PRICE_C, INSERT:#TEMP_MKT_FCST_DATA, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN_C, SELECT:#TEMP_USE_MEASURE, SELECT:DM_PLN_MKT_FCST_C, SELECT:#TEMP_MKT_FCST_DATA, INSERT:SCM_MST_FUTURE_PRICE_C, SELECT:SCM_MST_FUTURE_PRICE, INSERT:DM_PLN_CFM_SELLING_PRICE_C, SELECT:DM_PLN_CFM_SELLING_PRICE, DELETE:DM_MST_EXCHANGE_RATE_C, INSERT:DM_MST_EXCHANGE_RATE_C, SELECT:DM_MST_EXCHANGE_RATE |  |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 3 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0044_GET_COPY_VERSION_POPUP | MATCH | 1 | SP DMF0044_GET_COPY_VERSION_POPUP | EXEC:DMF0044_GET_COPY_VERSION_POPUP, SELECT:DM_MST_VERSION, REF:STRING_SPLIT, REF:UF_FX_STRING_SPLIT |  |
| DM.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | 1 | SP DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE | EXEC:DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0044_GET_MEASURE | MATCH | 1 | SP DMF0044_GET_MEASURE | EXEC:DMF0044_GET_MEASURE, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0044_GET_SALES_REPORTS_DATA | MATCH | 1 | SP DMF0044_GET_SALES_REPORTS_DATA | EXEC:DMF0044_GET_SALES_REPORTS_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USER, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#SELECT_MEASURE, CREATE:#T, INSERT:#PJT, SELECT:SCM_MST_PROJECT, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#DM_MST_ITEM_SINGLE_V_BEFORE, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#DM_MST_ITEM_SINGLE_V_BEFORE, INSERT:#T, SELECT:DM_PLN_SALES_PLAN_REPORT_C, SELECT:SCM_MST_SITE_ITEM, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:#PJT, SELECT:DM_PLN_SALES_ETC_REPORT_C, SELECT:SCM_SYS_CALENDAR_M, EXEC:SP_EXECUTESQL |  |
| DM.DMF0044_GET_SALES_VERSION_POPUP | MATCH | 2 | SP DMF0044_GET_SALES_VERSION_POPUP | EXEC:DMF0044_GET_SALES_VERSION_POPUP, SELECT:DM_MDF_VERSION, REF:FN_CHAR_TO_DATE, SELECT:DM_MST_VERSION, REF:UF_FX_STRING_SPLIT |  |
| DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP | MATCH | 1 | SP DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP | EXEC:DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP, SELECT:DM_PLN_SALES_REPORT_EXCHANGE_C, REF:UF_FX_STRING_SPLITFORIN, SELECT:SPLIT |  |
| DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA | MATCH | 1 | SP DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA | EXEC:DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA, SELECT:DM_PLN_SALES_REPORT_EXCHANGE_C, REF:UF_FX_STRING_SPLITFORIN, SELECT:SPLIT |  |
| DM.DMF0044_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0044_GET_SPREAD_TITLE | EXEC:DMF0044_GET_SPREAD_TITLE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0044_GET_TEXTBOX | MATCH | 1 | SP DMF0044_GET_TEXTBOX | EXEC:DMF0044_GET_TEXTBOX, SELECT:DM_MDF_VERSION, REF:FN_NEXT_DAY |  |
| DM.DMF0044_MOBILE_REPORT_CREATE | MATCH | 3 | SP DMF0044_MOBILE_REPORT_CREATE | EXEC:DMF0044_MOBILE_REPORT_CREATE, SELECT:DM_MDF_VERSION, EXEC:PR_DM_SYS_LOG_BATCH, SELECT:SCM_MST_DIVISION, SELECT:DM_PLN_SALES_ETC_REPORT_C, REF:FN_GET_COUNTRY_KR_NAME, UPDATE:DM_MDF_VERSION, DELETE:DM_PLN_SALES_PLAN_REPORT_C, INSERT:DM_PLN_SALES_PLAN_REPORT_C, EXEC:DMF0044_SALES_REPORT_PRODUCT_CREATE, EXEC:DMF0044_SALES_REPORT_DEPT_CREATE, EXEC:DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_COUNTRY, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:DM_MOBILE_REPORT_PRODUCT, DELETE:DM_MOBILE_REPORT_PRODUCT, INSERT:#TEMP_REPORT_C, SELECT:DM_PLN_SALES_PLAN_REPORT_C, SELECT:DM_MST_ITEM_SINGLE_V, INSERT:DM_MOBILE_REPORT_PRODUCT, SELECT:#TEMP_REPORT_C, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:DM_MOBILE_REPORT_DEPT, DELETE:DM_MOBILE_REPORT_DEPT, UPDATE:A, INSERT:DM_MOBILE_REPORT_DEPT, SELECT:DM_MOBILE_REPORT_EXCHANGE_RATE, DELETE:DM_MOBILE_REPORT_EXCHANGE_RATE, INSERT:#TEMP_EXCHANGE_C, SELECT:DM_PLN_SALES_REPORT_EXCHANGE_C, INSERT:DM_MOBILE_REPORT_EXCHANGE_RATE, SELECT:#TEMP_EXCHANGE_C |  |
| DM.DMF0044_SAVE_BIZ_PLAN_VERSION_COPY | MATCH | 1 | SP DMF0044_SAVE_BIZ_PLAN_VERSION_COPY | EXEC:DMF0044_SAVE_BIZ_PLAN_VERSION_COPY, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_MST_DIVISION, SELECT:DM_MDF_VERSION, SELECT:DM_MST_VERSION, INSERT:DM_MDF_VERSION, INSERT:DM_PLN_SALES_REPORT_EXCHANGE_C, SELECT:DM_BP_EXCHANGE_RATE_C, SELECT:DM_PLN_SALES_REPORT_EXCHANGE_C, UPDATE:DM_MDF_VERSION, DELETE:DM_PLN_BP_FCST_REPORT_C, DELETE:DM_PLN_SALES_REPORT_EXCHANGE_C, INSERT:#TEMP_BP_FCST_01, REF:STRING_SPLIT, SELECT:SCM_MST_SITE_ITEM, SELECT:DM_PLN_BP_FCST_C, INSERT:#TEMP_BP_FCST_02, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SSO_USER_INFO, SELECT:#TEMP_BP_FCST_01, SELECT:SCM_MST_SITE, DELETE:#TEMP_BP_FCST_02, INSERT:DM_PLN_BP_FCST_REPORT_C, SELECT:#TEMP_BP_FCST_02, SELECT:DM_PLN_BP_FCST_REPORT_C, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT | MATCH | 1 | SP DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT | EXEC:DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT, CREATE:#RESULTS, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#RESULTS, SELECT:SCM_MST_DIVISION, SELECT:DM_PLN_SALES_PLAN_REPORT_C, UPDATE:#RESULTS, DELETE:DM_PLN_SALES_REPORT_EXCHANGE_C, SELECT:#RESULTS, MERGE:DM_PLN_SALES_REPORT_EXCHANGE_C, UPDATE:A, SELECT:DM_PLN_SALES_REPORT_EXCHANGE_C, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.DMF0044_SAVE_SALES_PLAN_REPORT_C | MATCH | 1 | SP DMF0044_SAVE_SALES_PLAN_REPORT_C | EXEC:DMF0044_SAVE_SALES_PLAN_REPORT_C, CREATE:#RESULTS_MST, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:DM_MDF_VERSION, SELECT:DM_MST_VERSION, SELECT:SCM_SYS_CALENDAR_M, INSERT:#RESULTS_MST, SELECT:#RESULTS_MST, SELECT:NERP_CONV_MASTER, SELECT:DM_PLN_SALES_PLAN_REPORT_C, DELETE:A, MERGE:DM_PLN_SALES_PLAN_REPORT_C, UPDATE:A, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, EXEC:DMF0044_MOBILE_REPORT_CREATE, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_DM_SYS_LOG_BATCH, SELECT:SCM_MST_DIVISION, SELECT:DM_PLN_SALES_ETC_REPORT_C, REF:FN_GET_COUNTRY_KR_NAME, UPDATE:DM_MDF_VERSION, DELETE:DM_PLN_SALES_PLAN_REPORT_C, INSERT:DM_PLN_SALES_PLAN_REPORT_C, EXEC:DMF0044_SALES_REPORT_PRODUCT_CREATE, EXEC:DMF0044_SALES_REPORT_DEPT_CREATE, EXEC:DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE, SELECT:SCM_MST_COUNTRY, SELECT:DM_MOBILE_REPORT_PRODUCT, DELETE:DM_MOBILE_REPORT_PRODUCT, INSERT:#TEMP_REPORT_C, SELECT:DM_MST_ITEM_SINGLE_V, INSERT:DM_MOBILE_REPORT_PRODUCT, SELECT:#TEMP_REPORT_C, SELECT:DM_MOBILE_REPORT_DEPT, DELETE:DM_MOBILE_REPORT_DEPT, INSERT:DM_MOBILE_REPORT_DEPT, SELECT:DM_MOBILE_REPORT_EXCHANGE_RATE, DELETE:DM_MOBILE_REPORT_EXCHANGE_RATE, INSERT:#TEMP_EXCHANGE_C, SELECT:DM_PLN_SALES_REPORT_EXCHANGE_C, INSERT:DM_MOBILE_REPORT_EXCHANGE_RATE, SELECT:#TEMP_EXCHANGE_C |  |
| DM.DMF0044_SAVE_SALES_PLAN_REPORT_C_CF | MATCH | 1 | SP DMF0044_SAVE_SALES_PLAN_REPORT_C_CF | EXEC:DMF0044_SAVE_SALES_PLAN_REPORT_C_CF, CREATE:#RESULTS_MST, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#RESULTS_MST, SELECT:#RESULTS_MST, SELECT:NERP_CONV_MASTER, SELECT:DM_MDF_VERSION, UPDATE:A, UPDATE:#RESULTS_MST, SELECT:DM_PLN_SALES_PLAN_REPORT_C, INSERT:DM_PLN_SALES_PLAN_REPORT_C, SELECT:DM_PLN_SALES_REPORT_EXCHANGE_C, DELETE:A, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:DM_PLN_SALES_PLAN_REPORT_H, EXEC:DMF0044_MOBILE_REPORT_CREATE, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_DM_SYS_LOG_BATCH, SELECT:SCM_MST_DIVISION, SELECT:DM_PLN_SALES_ETC_REPORT_C, REF:FN_GET_COUNTRY_KR_NAME, UPDATE:DM_MDF_VERSION, DELETE:DM_PLN_SALES_PLAN_REPORT_C, EXEC:DMF0044_SALES_REPORT_PRODUCT_CREATE, EXEC:DMF0044_SALES_REPORT_DEPT_CREATE, EXEC:DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE, SELECT:SCM_MST_COUNTRY, SELECT:DM_MOBILE_REPORT_PRODUCT, DELETE:DM_MOBILE_REPORT_PRODUCT, INSERT:#TEMP_REPORT_C, SELECT:DM_MST_ITEM_SINGLE_V, INSERT:DM_MOBILE_REPORT_PRODUCT, SELECT:#TEMP_REPORT_C, SELECT:DM_MOBILE_REPORT_DEPT, DELETE:DM_MOBILE_REPORT_DEPT, INSERT:DM_MOBILE_REPORT_DEPT, SELECT:DM_MOBILE_REPORT_EXCHANGE_RATE, DELETE:DM_MOBILE_REPORT_EXCHANGE_RATE, INSERT:#TEMP_EXCHANGE_C, INSERT:DM_MOBILE_REPORT_EXCHANGE_RATE, SELECT:#TEMP_EXCHANGE_C |  |
| DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY | MATCH | 2 | SP DMF0044_SAVE_SALES_PLAN_VERSION_COPY | EXEC:DMF0044_SAVE_SALES_PLAN_VERSION_COPY, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:DM_MDF_VERSION, SELECT:DM_MST_VERSION, EXEC:PR_DM_SYS_LOG_BATCH, CREATE:#TEMP_VERSION_COPY, CREATE:#TEMP_REPORT, CREATE:#T_MEASURE, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE_ITEM, REF:FN_NEXT_DAY, SELECT:SCM_MST_DIVISION, INSERT:#TEMP_PLAN_C_CATCHUP, SELECT:DM_PLN_SALES_ETC_PLAN_C, INSERT:DM_MDF_VERSION, INSERT:DM_PLN_SALES_REPORT_EXCHANGE_C, SELECT:DM_MST_EXCHANGE_RATE_C, SELECT:DM_BP_EXCHANGE_RATE_C, SELECT:DM_PLN_SALES_REPORT_EXCHANGE_C, UPDATE:DM_MDF_VERSION, DELETE:DM_PLN_SALES_PLAN_REPORT_C, DELETE:DM_PLN_BP_FCST_REPORT_C, DELETE:DM_PLN_SALES_REPORT_EXCHANGE_C, INSERT:#T_MEASURE, INSERT:#TEMP_VERSION_COPY, SELECT:DM_PLN_SALES_PLAN_C, SELECT:SCM_MST_COMPANY_SN, SELECT:SCM_MST_SITE, SELECT:#T_MEASURE, SELECT:DM_PLN_SALES_PLAN_RESULT_C, DELETE:A, SELECT:#TEMP_VERSION_COPY, SELECT:DM_PLN_MKT_FCST_RESULT_C, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN_C, UPDATE:A, SELECT:DM_PLN_BP_FCST_C, SELECT:DM_PLN_SALES_PLAN_REPORT_C, INSERT:DM_PLN_SALES_PLAN_REPORT_C, REF:FN_GET_DM_MKT_OWNER_NAME, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_COUNTRY, SELECT:DM_PLN_SALES_PLAN_RESULT, MERGE:#TEMP_VERSION_COPY, SELECT:#TEMP_PLAN_C_CATCHUP, UPDATE:#TEMP_VERSION_COPY, SELECT:DM_PLN_CFM_SELLING_PRICE, INSERT:#TEMP_REPORT, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:#TEMP_REPORT, REF:FN_SCM_SPLIT, SELECT:#TEMP_SCM_MST_SITE_ITEM, INSERT:DM_PLN_SALES_ETC_REPORT_C, SELECT:DM_PLN_SALES_ETC_REPORT_C, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.DMF0044_SAVE_TEXTBOX | MATCH | 1 | SP DMF0044_SAVE_TEXTBOX | EXEC:DMF0044_SAVE_TEXTBOX, EXEC:PR_DM_SYS_LOG_BATCH, UPDATE:DM_MDF_VERSION, SELECT:DM_MDF_VERSION, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 1 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 3 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| DefineProperty | UserInfoContext.Current | NowGroupID |
| EditButton | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID |
| FindData | nvc | p_division_id, p_version_description, p_version_type, p_from_yyyymmdd, p_to_yyyymmdd, p_created_by, p_year, p_version_no |
| FindData | dt.Rows[i] | DIVISION_ID, CURRENCY, UNIT_CURRENCY, YYYYMMDD, EXCHANGE_PRICE |
| FindData | ds.Tables[1].Rows[0] | MONDAY |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitSpread | dt.Rows[i] | CALENDAR_YYYY, CALENDAR_MONTH, BASIS_START_DATE |
| InitSpread_X | dt.Rows[i] | CALENDAR_YYYY, WEEK_NAME, BASIS_START_DATE, CALENDAR_MONTH |
| InsertRow | dtMeasure.Rows[i] | CODE |
| SaveButton | UserInfoContext.Current | NowGroupID |
| SaveData | nvc | p_active_flag, p_division_id, p_version_no, p_YYYYMMDD, p_CURRENCY, p_UNIT_CURRENCY, p_EXCHANGE_PRICE, p_CREATED_BY, p_LAST_UPDATED_BY |
| SetChangeControl | Filter | GROUP_ID, USER_ID |
| SetChangeControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:160 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| FP_Log2 | InitControls:172, InitControls:184 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetCheckedListValue | InitControls:180, clbDivision_SelectedIndexChanged:1463, SaveData:245, GetSpdTitle:280, FindData:250, SaveData:305, FindData:418, FindData:198 | CString.GetCheckedListValue | CODE |
| GetMeasure | InitControls:191 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetSheetHeaderColumn | InitSpread:235 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| CreateSheetHeaderColumnDtDiv | InitSpread:236 | SpreadInfo.CreateSheetHeaderColumnDtDiv | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:376, SaveButton:213, SaveButton:238, btnButtonList_UsrButtonList_Click_Detected:423, SaveButton:406, btnButtonList_UsrButtonList_Click_Detected:694, SaveButton:226, btnButtonList_UsrButtonList_Click_Detected:400 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| LoadData | btnExchangeRate_Click:1442, btnTextbox_Click:1477, btnCopy_Click:365 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |
| CreateSheetHeaderColumn | InitSpread:178, InitSpread:175, InitSpread:172 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| GetSpdTitle | InitSpread:174 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnTextbox | Click | btnTextbox_Click | InitializeComponent:167 |
| this.btnExchangeRate | Click | btnExchangeRate_Click | InitializeComponent:205 |
| this.btnSPVer | Click | btnSPVer_Click | InitializeComponent:275 |
| this.clbType | SelectedIndexChanged | clbType_SelectedIndexChanged | InitializeComponent:310 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:415 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:450 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:637 |
| this | Load | Form_Load | .ctor:127 |
| clbType | SelectedIndexChanged | clbType_SelectedIndexChanged | InitControls:186 |
| clbType | SelectedIndexChanged | clbType_SelectedIndexChanged | InitControls:198 |
| dsdm | Changed | spdMain_Changed | DefineProperty:207 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | DefineProperty:208 |
| this | Load | Form_Load | .ctor:85 |
| this.btnVerCopy | Click | btnVerCopy_Click | InitializeComponent:272 |
| this.btnVerDel | Click | btnVerDel_Click | InitializeComponent:309 |
| this.btnTranCancel | Click | btnTranCancel_Click | InitializeComponent:346 |
| this.btnTransfer | Click | btnTransfer_Click | InitializeComponent:383 |
| this.chkResult | CheckedChanged | chkResult_CheckedChanged | InitializeComponent:533 |
| this.clbType | SelectedIndexChanged | clbType_SelectedIndexChanged | InitializeComponent:602 |
| this.btnVerCre | Click | btnVerCre_Click | InitializeComponent:639 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:676 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:713 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:750 |
| this.chkMV | CheckedChanged | chkMV_CheckedChanged | InitializeComponent:788 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1066 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1067 |
| this | Load | Form_Load | .ctor:89 |
| clbType | SelectedIndexChanged | clbType_SelectedIndexChanged | InitControls:129 |
| clbType | SelectedIndexChanged | clbType_SelectedIndexChanged | InitControls:138 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:177 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:382 |
| this | Load | Form_Load | .ctor:96 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:187 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:278 |
| this | Load | Form_Load | .ctor:78 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:169 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:213 |
| this | Load | Form_Load | .ctor:80 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:175 |
| this.btnTransfer | Click | btnTransfer_Click | InitializeComponent:302 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:417 |
| this | Load | Form_Load | .ctor:84 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:171 |
| this.btnCopy | Click | btnCopy_Click | InitializeComponent:283 |
| this.btnTransfer | Click | btnTransfer_Click | InitializeComponent:320 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:430 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:431 |

## 6. 컨트롤 (152개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 46 | lblSPVersion, layoutControlItem1, lblType, lblYear, lblDataType, layoutControlItem4, layoutControlItem2, lblDivision, lci_btnTextBox, lblDivion, Period, LayoutControl_Result, LayoutControl_Transfer, LayoutControl_Cancel, LayoutControl_VersionDelete … |
| UsrButton | 15 | btnTextbox, btnExchangeRate, btnSPVer, btnMeasure, btnVerCopy, btnVerDel, btnTranCancel, btnTransfer, btnVerCre, btnOK, btnClose, usrButton1, btnTransfer, btnCopy, btnTransfer |
| UsrLayoutControl | 14 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 14 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 11 | emptySpaceItem1, emptySpaceItem1, emptySpaceItem1, emptySpaceItem3, emptySpaceItem2, emptySpaceItem1, emptySpaceItem1, emptySpaceItem2, emptySpaceItem1, emptySpaceItem2, emptySpaceItem1 |
| UsrCombo | 10 | clbType, usrYear, usrDataType, clbDivision, clbDivision, clbType, clbDivision, usrYear, clbDivision, clbDivision |
| UsrConditionPanel | 7 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| SheetView | 7 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| FpSpread | 7 | spdMain, spdMain, spdMain, spdMain, spdMain, spdMain, spdMain |
| UsrButtonList | 5 | btnButtonList, btnButtonList, btnButtonList, btnButtonList, btnButtonList |
| UsrDateRangePicker | 4 | drpPeriod, drpPeriod, drpPeriod, drpPeriod |
| TextBox | 4 | txtDes, txtType, txtDes, txtType |
| UsrCheckBox | 3 | chkUpdate, chkResult, chkMV |
| UsrMultiLineEditor | 2 | txtSPVersion, txtDesc |
| UsrMonthPicker | 1 | MvMonth |
| UsrDatePicker | 1 | BasicDate |
| UsrCheckedList | 1 | clbDivisions |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 327 | SaveData | {?DMF0044_MDFVersionPopUp.sFoxData} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 1895 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER | 5 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 70 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 63 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 61 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 15 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 189 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 15 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 267 | {?sFoxData} | commented:UNRESOLVED |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0044 | MDF Reports | 25/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 16/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0044 | MDFVerpopup | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0044 | MDF Reports | 7/2 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 7/0 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 22개 시트×division 비교, 차이 62건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: MDF Reports, MDFVerpopup2, MDFVerpopup, Cut-Off PopUp, Sales Price PopUp, Textbox Popup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:235, CreateSheetHeaderColumnDtDiv@InitSpread:236, CreateSheetHeaderColumn@InitSpread:178, CreateSheetHeaderColumn@InitSpread:175, CreateSheetHeaderColumn@InitSpread:172

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 601 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 602 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 603 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 604 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 168 | 하드코딩 | AddComboColumn | Division | DIVISION_ID |  |
| InitSpread |  | 169 | 하드코딩 | AddTextColumn | Version NO | VERSION_NO |  |
| InitSpread |  | 170 | 하드코딩 | AddTextColumn | Type | VERSION_TYPE |  |
| InitSpread |  | 172 | 하드코딩 | AddTextColumn | Description | VERSION_DESCRIPTION |  |
| InitSpread |  | 173 | 하드코딩 | AddTextColumn | yyyyMMdd | YYYYMMDD |  |
| InitSpread |  | 175 | 하드코딩 | AddTextColumn | Ver Seq | VER_CRE_SEQ |  |
| InitSpread |  | 176 | 하드코딩 | AddTextColumn | Update By | LAST_UPDATED_BY |  |
| InitSpread |  | 177 | 하드코딩 | AddTextColumn | Update Date | LAST_UPDATE_DATE |  |
| InitializeComponent |  | 398 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 399 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 400 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 401 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 433 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 434 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 435 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 436 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 447 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 448 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 449 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 450 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 162 | 하드코딩 | AddTextColumn | {?sMonday.AddMonths(i).ToString("yyyy-MM")} | DESCRIPTION01 | for(i < 13) |
| InitializeComponent |  | 229 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 230 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 231 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 232 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread_X |  | 181 | 하드코딩 | AddTextColumn | Currency | CURRENCY |  |
| InitSpread_X |  | 208 | DB루프 | AddNumColumn | {?dt.Rows[i]["WEEK_NAME"]} | {?dt.Rows[i]["BASIS_START_DATE"]} | for(i < dt.Rows.Count) |
| InitSpread |  | 253 | 하드코딩 | AddComboColumn | Division | DIVISION_ID |  |
| InitSpread |  | 254 | 하드코딩 | AddTextColumn | Currency | CURRENCY |  |
| InitSpread |  | 255 | 하드코딩 | AddComboColumn | Unit | UNIT_CURRENCY |  |
| InitSpread |  | 256 | 하드코딩 | AddTextColumn | Currency | CURRENCY_UNITCURRENCY |  |
| InitSpread |  | 279 | DB루프 | AddNumColumn | {?dt.Rows[i]["CALENDAR_MONTH"]} | D{?dt.Rows[i]["BASIS_START_DATE"]} | for(i < dt.Rows.Count) |
| InitializeComponent |  | 294 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 295 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 296 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 297 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1083 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1084 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1085 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1086 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Cut-Off PopUp | 코드 하드코딩 전용(메타 없음) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| MDF Reports | META+코드연결 | 25 | 17 | 17 | 17 | 17 | 17 | 17 | 16 | · | · | · | · | · | · |
| MDFVerpopup | META+코드연결 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | · | · | · | · | · | · |
| Sales Price PopUp | 코드 하드코딩 전용(메타 없음) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| Textbox Popup | 코드 하드코딩 전용(메타 없음) | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
