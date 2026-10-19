# DM0097 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0097_SalesSiteTest.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 2312 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0097_SalesSiteTest.Designer.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 1100 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0097_SalesSiteTest4.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 2338 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0097_SalesSiteTest4.Designer.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 1094 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0097_SalesSiteTestBak.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 2288 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0097_SalesSiteTestBak.Designer.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 686 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 559 | DM.DM0004_GET_SALES_SITE_DATA | MATCH | SP DM0004_GET_SALES_SITE_DATA |
| button:FindButton | FindButton > FindData_Main | 565 | DM.DM0004_GET_SALES_SITE_DATA | MATCH | SP DM0004_GET_SALES_SITE_DATA |
| button:FindButton | FindButton > FindData_Main | 565 | DM.DM0004_GET_SALES_SITE_DATA | MATCH | SP DM0004_GET_SALES_SITE_DATA |
| button:FindButton | FindButton > FindData_SubCustomer | 617 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:FindButton | FindButton > FindData_SubCustomer | 623 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:FindButton | FindButton > FindData_SubCustomer | 623 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:FindButton | FindButton > FindData_SubLocation | 673 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| button:FindButton | FindButton > FindData_SubLocation | 679 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| button:FindButton | FindButton > FindData_SubLocation | 679 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| button:FindButton | FindButton > FindData_SubBucket | 726 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| button:FindButton | FindButton > FindData_SubBucket | 732 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| button:FindButton | FindButton > FindData_SubBucket | 732 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| button:FindButton | FindButton > FindData_SubBucket > InitSpread > GetSpdTitle | 2260 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_SubBucket > InitSpread > GetSpdTitle | 2280 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_SubBucket > InitSpread > GetSpdTitle | 2306 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1483 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1486 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1489 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1489 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1492 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1492 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 559 | DM.DM0004_GET_SALES_SITE_DATA | MATCH | SP DM0004_GET_SALES_SITE_DATA |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 565 | DM.DM0004_GET_SALES_SITE_DATA | MATCH | SP DM0004_GET_SALES_SITE_DATA |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 565 | DM.DM0004_GET_SALES_SITE_DATA | MATCH | SP DM0004_GET_SALES_SITE_DATA |
| button:SaveButton | SaveButton > SaveSubCustomerData > FindData_SubCustomer | 617 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubCustomerData > FindData_SubCustomer | 623 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubCustomerData > FindData_SubCustomer | 623 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData > FindData_SubLocation | 673 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData > FindData_SubLocation | 679 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData > FindData_SubLocation | 679 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket | 726 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket | 732 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket | 732 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveData | 913 | DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData | 919 | DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData | 919 | DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData | 943 | biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 948 | biz:CommonData.CommonDataList [code=SiteByEndCustomer] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 949 | biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 949 | biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 954 | biz:CommonData.CommonDataList [code=SiteByEndCustomer] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 954 | biz:CommonData.CommonDataList [code=SiteByEndCustomer] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveSubCustomerData | 1097 | DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubCustomerData | 1103 | DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubCustomerData | 1103 | DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData | 1283 | DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData | 1289 | DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData | 1289 | DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData | 1414 | DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData | 1420 | DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData | 1420 | DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket > InitSpread > GetSpdTitle | 2260 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket > InitSpread > GetSpdTitle | 2280 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket > InitSpread > GetSpdTitle | 2306 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1728 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1734 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1736 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 236 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 239 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 239 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 259 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 261 | biz:CommonData.CommonDataList [code=TeambyAll] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 265 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 265 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 267 | biz:CommonData.CommonDataList [code=TeambyAll] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 267 | biz:CommonData.CommonDataList [code=TeambyAll] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 277 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 279 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 283 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 283 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 285 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 285 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2260 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2280 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2306 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubCustomer | 617 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubCustomer | 623 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubCustomer | 623 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubLocation | 673 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubLocation | 679 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubLocation | 679 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket | 726 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket | 732 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket | 732 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket > InitSpread > GetSpdTitle | 2260 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket > InitSpread > GetSpdTitle | 2280 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket > InitSpread > GetSpdTitle | 2306 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1770 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1778 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1790 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1798 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1816 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1824 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 1812 | biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 1832 | biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 1858 | biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncoterms> | 51 | biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncoterms> | 51 | biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncoterms> | 51 | biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 52 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 52 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 52 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetPlantbyDivision | 2272 | SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | SP SCM0001_GET_PLANT_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantbyDivision | 2292 | SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | SP SCM0001_GET_PLANT_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantbyDivision | 2318 | SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | SP SCM0001_GET_PLANT_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList_SCP:SELECT:SCP_MST_BOD_V, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 9 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=SiteByEndCustomer] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:REF:STRING_SPLIT, UP_FX_GETCOMMONDATALIST_DM:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| biz:CommonData.CommonDataList [code=TeambyAll] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO |
| biz:CommonData.YesOrNo | BIZ_MATCH | 3 |  |  |  |
| DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | 3 | SP DM0004_GET_SALES_SITE_BUCKET_DATA | EXEC:DM0004_GET_SALES_SITE_BUCKET_DATA | ⚠ DB에 SP 없음 |
| DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | 3 | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA | EXEC:DM0004_GET_SALES_SITE_CUSTOMER_DATA, REF:FN_GET_DEPT_LIST, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE, SELECT:TB_FX_USER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DM0004_GET_SALES_SITE_DATA | MATCH | 3 | SP DM0004_GET_SALES_SITE_DATA | EXEC:DM0004_GET_SALES_SITE_DATA, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |
| DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | 3 | SP DM0004_GET_SALES_SITE_LOCATION_DATA | EXEC:DM0004_GET_SALES_SITE_LOCATION_DATA | ⚠ DB에 SP 없음 |
| DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | MATCH | 3 | SP DM0004_SAVE_SALES_SITE_BUCKET_DATA | EXEC:DM0004_SAVE_SALES_SITE_BUCKET_DATA | ⚠ DB에 SP 없음 |
| DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | MATCH | 3 | SP DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | EXEC:DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | ⚠ DB에 SP 없음 |
| DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY | 3 |  |  | DB에도 없음 (폐기/오타 가능) |
| DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | MATCH | 3 | SP DM0004_SAVE_SALES_SITE_LOCATION_DATA | EXEC:DM0004_SAVE_SALES_SITE_LOCATION_DATA | ⚠ DB에 SP 없음 |
| SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | 3 | SP SCM0001_GET_PLANT_BY_DIVISION | EXEC:SCM0001_GET_PLANT_BY_DIVISION, SELECT:SCM_MST_PLANT_SN, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbEndCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| SaveData | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:245, InitControls:250, InitControls:256, FindData_Main:544, SaveData:945, SaveData:947, clbDivision_SelectedIndexChanged:1719, clbDivision_SelectedIndexChanged:1724 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:329, InitSpread:323 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:330, InitSpread:324 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:510, SaveButton:504 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.tabPane1 | SelectedPageChanged | tabPane1_SelectedPageChanged | InitializeComponent:150 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:190 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:191 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:192 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:193 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:305 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:345 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:415 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:494 |
| this.spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitializeComponent:601 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:602 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:603 |
| this.spdSub | EditChange | spdSub_EditChange | InitializeComponent:604 |
| this | Load | DM0004_SalesSite_Load | InitializeComponent:999 |
| this | Load | Form_Load | .ctor:215 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:339 |
| dsdm2 | Changed | shtSubCustomerDataModel_Changed | InitEvent:342 |
| dsdm3 | Changed | shtSubBucketDataModel_Changed | InitEvent:345 |
| this.xtraTabControl1 | SelectedPageChanged | xtraTabControl1_SelectedPageChanged | InitializeComponent:144 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:191 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:192 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:193 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:194 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:306 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:346 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:416 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:495 |
| this.spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitializeComponent:602 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:603 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:604 |
| this.spdSub | EditChange | spdSub_EditChange | InitializeComponent:605 |
| this | Load | DM0004_SalesSite_Load | InitializeComponent:993 |
| this | Load | Form_Load | .ctor:215 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:339 |
| dsdm2 | Changed | shtSubCustomerDataModel_Changed | InitEvent:342 |
| dsdm3 | Changed | shtSubBucketDataModel_Changed | InitEvent:345 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:115 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:116 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:117 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:118 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:119 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:231 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:271 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:341 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:420 |
| this.spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitializeComponent:527 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:528 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:529 |
| this.spdSub | EditChange | spdSub_EditChange | InitializeComponent:530 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:531 |
| this | Load | DM0004_SalesSite_Load | InitializeComponent:627 |
| this | Load | Form_Load | .ctor:215 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:333 |
| dsdm2 | Changed | shtSubCustomerDataModel_Changed | InitEvent:336 |
| dsdm3 | Changed | shtSubBucketDataModel_Changed | InitEvent:339 |

## 6. 컨트롤 (118개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 22 | lblDivision, layoutControlItem1, lblActive, lblSalesSite, lblEndCustomer, lblTeam, layoutControlItem2, layoutControlItem3, lblDivision, layoutControlItem1, lblActive, lblSalesSite, lblEndCustomer, lblTeam, layoutControlItem2 … |
| UsrCheckedList | 14 | clbTeam, clbEndCustomer, clbSalesSite, clbDivision, clbDivision2, clbTeam, clbEndCustomer, clbSalesSite, clbDivision, clbDivision2, clbTeam, clbEndCustomer, clbSalesSite, clbDivision |
| FpSpread | 10 | spdMain, spdSub, spdMain2, spdSub2, spdMain, spdSub, spdMain2, spdSub2, spdMain, spdSub |
| SheetView | 10 | spdMain_Sheet1, spdSub_Sheet1, spdMain2_Sheet1, spdSub2_Sheet1, spdMain_Sheet1, spdSub_Sheet1, spdMain2_Sheet1, spdSub2_Sheet1, spdMain_Sheet1, spdSub_Sheet1 |
| UsrConditionPanel | 10 | usrConditionPanel1, usrConditionPanel2, usrConditionPanel3, usrConditionPanel4, usrConditionPanel1, usrConditionPanel2, usrConditionPanel3, usrConditionPanel4, usrConditionPanel1, usrConditionPanel2 |
| UsrLayoutControl | 10 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl4, usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl4, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 10 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup3, layoutControlGroup4, layoutControlGroup1, layoutControlGroup2, layoutControlGroup3, layoutControlGroup4, layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 10 | emptySpaceItem3, emptySpaceItem2, emptySpaceItem1, emptySpaceItem4, emptySpaceItem3, emptySpaceItem2, emptySpaceItem1, emptySpaceItem4, emptySpaceItem3, emptySpaceItem2 |
| SplitContainer | 5 | splitContainer1, splitContainer2, splitContainer1, splitContainer2, splitContainer1 |
| UsrCombo | 5 | cboActive, cmbActive2, cboActive, cmbActive2, cboActive |
| ImageList | 3 | imageList1, imageList1, imageList1 |
| UsrCheckBox | 3 | chkDetail, chkDetail, chkDetail |
| TabNavigationPage | 2 | tnbSalesSite, tnbSalesSite2 |
| XtraTabPage | 2 | xtraTabPage1, xtraTabPage2 |
| TabPane | 1 | tabPane1 |
| XtraTabControl | 1 | xtraTabControl1 |

## 7. 확인 필요 (3건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 919 | SaveData | DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 919 | SaveData | DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 913 | SaveData | DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sales Site, Sales Customer, Sales Location, Sales Bucket
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:330, CreateSheetHeaderColumn@InitSpread:324

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 210 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 211 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 212 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 213 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 620 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 621 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 622 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 623 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 739 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 740 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 741 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 742 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 925 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 926 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 927 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 928 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 211 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 212 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 213 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 214 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 621 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 622 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 623 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 624 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 733 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 734 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 735 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 736 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 919 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 920 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 921 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 922 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 136 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 137 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 138 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 139 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 547 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 548 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 549 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 550 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
