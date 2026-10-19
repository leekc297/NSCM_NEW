# SSP0046 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0046_ShipmentRequest.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0046_ShipmentRequest.UIL\SSP0046_ShipmentRequest.UIL.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0046_ShipmentRequest.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0046_ShipmentRequest.UIL\SSP0046_ShipmentRequest.UIL.csproj | 64 |
| current(sln미등록) | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0046_ShipmentRequest.UIL\Properties\Settings.Designer.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0046_ShipmentRequest.UIL\SSP0046_ShipmentRequest.UIL.csproj | 27 |
| current(sln미등록) | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0046_ShipmentRequest.UIL\SSP0046_ShipmentRequest.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0046_ShipmentRequest.UIL\SSP0046_ShipmentRequest.UIL.csproj | 2358 |
| current(sln미등록) | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0046_ShipmentRequest.UIL\SSP0046_ShipmentRequest.Designer.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0046_ShipmentRequest.UIL\SSP0046_ShipmentRequest.UIL.csproj | 1133 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0046_GetBODItemPrjRoutePopup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 354 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0046_GetBODItemPrjRoutePopup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 289 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0046_ItembyDivisionPopupEx.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 622 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0046_ItembyDivisionPopupEx.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 608 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0046_ProjectbyDivisionPopupEx.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 600 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0046_ProjectbyDivisionPopupEx.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 629 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0046_TitleSetForm_Popup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 665 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0046_TitleSetForm_Popup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 303 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0046_ShipmentRequest.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 2350 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0046_ShipmentRequest.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1129 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| ctor:.ctor | .ctor > GetTitleSet | 243 | SSP.SSP0046_GET_TITLESET_POPUP | MATCH | SP SSP0046_GET_TITLESET_POPUP |
| event:dsdmCell.Changed | spdMain_Changed | 1771 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| event:dsdmCell.Changed | spdMain_Changed | 1833 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| event:dsdmPack.Changed | spdMain_Changed | 1771 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| event:dsdmPack.Changed | spdMain_Changed | 1833 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| button:EditButton | EditButton > GetSSPUserCheck | 2339 | SSP.SSP0002_GET_USER_INFO_LIST | MATCH | SP SSP0002_GET_USER_INFO_LIST |
| button:FindButton | FindButton > FindData | 297 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > FindData | 297 | SSP.SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP | MATCH | SP SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP |
| button:FindButton | FindButton > FindData | 368 | SSP.SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX | MATCH | SP SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX |
| button:FindButton | FindButton > FindData | 386 | SSP.SSP0046_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP SSP0046_GET_ITEM_BY_DIVISION_POPUPEx |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 452 | SSP.SSP0046_GET_COMMON_SPREAD_TITLE_EX | MATCH | SP SSP0046_GET_COMMON_SPREAD_TITLE_EX |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 481 | SSP.SSP0046_GET_COMMON_SPREAD_TITLE | MATCH | SP SSP0046_GET_COMMON_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 597 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 624 | SSP.SSP0046_GET_SHIPMENT_REQUEST | MATCH | SP SSP0046_GET_SHIPMENT_REQUEST |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 2276 | SSP.SSP0046_GET_SPREAD_TITLE | MATCH | SP SSP0046_GET_SPREAD_TITLE |
| button:InsertButton | InsertButton > InsertRow | 1018 | biz:CommonData.CommonDataList [code=FCST_TYPE] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1021 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData | 597 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData | 624 | SSP.SSP0046_GET_SHIPMENT_REQUEST | MATCH | SP SSP0046_GET_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData | 913 | SSP.SSP0046_SAVE_SHIPMENT_REQUEST | MATCH | SP SSP0046_SAVE_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 2276 | SSP.SSP0046_GET_SPREAD_TITLE | MATCH | SP SSP0046_GET_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 368 | SSP.SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX | MATCH | SP SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 386 | SSP.SSP0046_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP SSP0046_GET_ITEM_BY_DIVISION_POPUPEx |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > InitSpread > GetSpdTitle | 452 | SSP.SSP0046_GET_COMMON_SPREAD_TITLE_EX | MATCH | SP SSP0046_GET_COMMON_SPREAD_TITLE_EX |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > InitSpread > GetSpdTitle | 481 | SSP.SSP0046_GET_COMMON_SPREAD_TITLE | MATCH | SP SSP0046_GET_COMMON_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 2276 | SSP.SSP0046_GET_SPREAD_TITLE | MATCH | SP SSP0046_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 2276 | SSP.SSP0046_GET_SPREAD_TITLE | MATCH | SP SSP0046_GET_SPREAD_TITLE |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > EditButton > GetSSPUserCheck | 2339 | SSP.SSP0002_GET_USER_INFO_LIST | MATCH | SP SSP0002_GET_USER_INFO_LIST |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2276 | SSP.SSP0046_GET_SPREAD_TITLE | MATCH | SP SSP0046_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetDivisionbyScmSite | 573 | SSP.SSP0046_GET_SITE_BY_DIVISION | MATCH | SP SSP0046_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls | 201 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 219 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 223 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 232 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 241 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 297 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > FindData | 297 | SSP.SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP | MATCH | SP SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP |
| event:this.Load | Form_Load > FindData | 368 | SSP.SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX | MATCH | SP SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX |
| event:this.Load | Form_Load > FindData | 386 | SSP.SSP0046_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP SSP0046_GET_ITEM_BY_DIVISION_POPUPEx |
| event:this.Load | Form_Load > FindData > InitSpread > GetSpdTitle | 452 | SSP.SSP0046_GET_COMMON_SPREAD_TITLE_EX | MATCH | SP SSP0046_GET_COMMON_SPREAD_TITLE_EX |
| event:this.Load | Form_Load > FindData > InitSpread > GetSpdTitle | 481 | SSP.SSP0046_GET_COMMON_SPREAD_TITLE | MATCH | SP SSP0046_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2276 | SSP.SSP0046_GET_SPREAD_TITLE | MATCH | SP SSP0046_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 2293 | SSP.SSP0046_GET_BUCKET_TYPE_CODE | MATCH | SP SSP0046_GET_BUCKET_TYPE_CODE |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1211 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.txtItemID.KeyDown | txtItemID_KeyDown > FindButton > FindData | 386 | SSP.SSP0046_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP SSP0046_GET_ITEM_BY_DIVISION_POPUPEx |
| event:this.txtItemID.KeyDown | txtItemID_KeyDown > FindButton > FindData > InitSpread > GetSpdTitle | 481 | SSP.SSP0046_GET_COMMON_SPREAD_TITLE | MATCH | SP SSP0046_GET_COMMON_SPREAD_TITLE |
| event:this.txtProject.KeyDown | txtProject_KeyDown > FindButton > FindData | 368 | SSP.SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX | MATCH | SP SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX |
| event:this.txtProject.KeyDown | txtProject_KeyDown > FindButton > FindData > InitSpread > GetSpdTitle | 452 | SSP.SSP0046_GET_COMMON_SPREAD_TITLE_EX | MATCH | SP SSP0046_GET_COMMON_SPREAD_TITLE_EX |
| event:this.usrButtonList1.UsrButtonList_Click_Detected | usrButtonList1_UsrButtonList_Click_Detected > SaveTitleSet | 509 | SSP.SSP0046_SET_TITLESET_POPUP | MATCH | SP SSP0046_SET_TITLESET_POPUP |
| unreached:(진입점 미연결) | GetDivision | 534 | SSP.SSP0046_GET_DIVISION | MATCH | SP SSP0046_GET_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 547 | SSP.SSP0046_GET_TEAM_BY_DIVISION | MATCH | SP SSP0046_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetDivision | 559 | SSP.SSP0046_GET_DIVISION | MATCH | SP SSP0046_GET_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 561 | SSP.SSP0046_GET_CUSTOMER_BY_DIVISION | MATCH | SP SSP0046_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivision | 576 | SSP.SSP0046__GET_SITE_BY_DIVISION | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | GetTeambyDivision | 590 | SSP.SSP0046_GET_TEAM_BY_DIVISION | MATCH | SP SSP0046_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 604 | SSP.SSP0046_GET_CUSTOMER_BY_DIVISION | MATCH | SP SSP0046_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetBizTypebyDivision | 2305 | SSP.SSP0046_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SSP0046_GET_BIZ_TYPE_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?string.Empty} | UNRESOLVED | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=FCST_TYPE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_MEASURE, UP_FX_GetCommonDataList:SELECT:DM_MST_CUSTOMER_FCST |
| biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:DM_MST_CUSTOMER_FCST |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| SSP.SSP0002_GET_USER_INFO_LIST | MATCH | 1 | SP SSP0002_GET_USER_INFO_LIST | EXEC:SSP0002_GET_USER_INFO_LIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION |  |
| SSP.SSP0046__GET_SITE_BY_DIVISION | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| SSP.SSP0046_GET_BIZ_TYPE_BY_DIVISION | MATCH | 1 | SP SSP0046_GET_BIZ_TYPE_BY_DIVISION | EXEC:SSP0046_GET_BIZ_TYPE_BY_DIVISION | ⚠ DB에 SP 없음 |
| SSP.SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP | MATCH | 1 | SP SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP | EXEC:SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP, SELECT:SCP_MST_BOD_V, SELECT:SCP_MST_BOD_ITEM, SELECT:SCP_MST_BOD, SELECT:SCM_MST_SITE, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:SCM_MST_SSO_DEPT_INFO |  |
| SSP.SSP0046_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP SSP0046_GET_BUCKET_TYPE_CODE | EXEC:SSP0046_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SSP.SSP0046_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP SSP0046_GET_COMMON_SPREAD_TITLE | EXEC:SSP0046_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| SSP.SSP0046_GET_COMMON_SPREAD_TITLE_EX | MATCH | 1 | SP SSP0046_GET_COMMON_SPREAD_TITLE_EX | EXEC:SSP0046_GET_COMMON_SPREAD_TITLE_EX, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| SSP.SSP0046_GET_CUSTOMER_BY_DIVISION | MATCH | 2 | SP SSP0046_GET_CUSTOMER_BY_DIVISION | EXEC:SSP0046_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SSP.SSP0046_GET_DIVISION | MATCH | 2 | SP SSP0046_GET_DIVISION | EXEC:SSP0046_GET_DIVISION | ⚠ DB에 SP 없음 |
| SSP.SSP0046_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | 1 | SP SSP0046_GET_ITEM_BY_DIVISION_POPUPEx | EXEC:SSP0046_GET_ITEM_BY_DIVISION_POPUPEX, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_ITEM_SN, REF:UF_FX_STRING_SPLITFORIN, REF:UF_FX_STRING_SPLIT, SELECT:SPLIT |  |
| SSP.SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX | MATCH | 1 | SP SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX | EXEC:SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:UF_FX_STRING_SPLITFORIN, REF:UF_FX_STRING_SPLIT, SELECT:SPLIT |  |
| SSP.SSP0046_GET_SHIPMENT_REQUEST | MATCH | 1 | SP SSP0046_GET_SHIPMENT_REQUEST | EXEC:SSP0046_GET_SHIPMENT_REQUEST, SELECT:TB_FX_USER, CREATE:#TBL_LOC, INSERT:#TBL_LOC, CREATE:#TBLDYNAMIC_MEASURE, INSERT:#TBLDYNAMIC_MEASURE, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, UPDATE:A, SELECT:#TBLDYNAMIC_MEASURE, CREATE:#TBLDYNAMIC_SHIP_REQ, CREATE:#TBLDYNAMIC_PLAN, CREATE:#TBLDYNAMIC_SHIP_ROW, CREATE:#TBLDYNAMIC_CAL_QTY, INSERT:#TBLDYNAMIC_SHIP_REQ, SELECT:DM_PLN_SHIPMENT_REQ, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_PLAN_VERSION_V, INSERT:#TMP_SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_PLN_SHIPMENT_PLAN_PEGGING, SELECT:SCP_PLN_SHIPMENT_PLAN, INSERT:#TBLDYNAMIC_PLAN, SELECT:#TMP_SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCM_SYS_CALENDAR_M, REF:FN_GET_SSP_ETD_DATE, SELECT:SCP_MST_BOD_V, SELECT:DM_PLN_MKT_FCST, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_DNM_CELL_INHOUSE_PLAN_SN, SELECT:#TBLDYNAMIC_SHIP_REQ, REF:FN_GET_ANL_SHIP_FROZEN_DAY_CNT, SELECT:#TBLDYNAMIC_PLAN, SELECT:SSP_DNM_FP_PLAN_FROZEN, SELECT:SCP_ANL_PRODUCTION_PLAN, REF:FN_NEXT_DAY, INSERT:#TBLDYNAMIC_SHIP_ROW, SELECT:SSP_DNM_STOCK_C, SELECT:#TBLDYNAMIC_SHIP_ROW, SELECT:SCM_MST_LOCATION, SELECT:#TBL_LOC, SELECT:SCP_MST_FINAL_ITEM, SELECT:SSP_DNM_ESS_PACKER_STOCK_V, DELETE:A, INSERT:#TBLDYNAMIC_REQUESTOR, INSERT:#TBLDYNAMIC_SHIP_PIVOT, SELECT:#TBLDYNAMIC_SHIP_PIVOT, UPDATE:TOT, DYNAMIC@SSP0046_GET_SHIPMENT_REQUEST |  |
| SSP.SSP0046_GET_SITE_BY_DIVISION | MATCH | 1 | SP SSP0046_GET_SITE_BY_DIVISION | EXEC:SSP0046_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SSP.SSP0046_GET_SPREAD_TITLE | MATCH | 1 | SP SSP0046_GET_SPREAD_TITLE | EXEC:SSP0046_GET_SPREAD_TITLE, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0046_GET_TEAM_BY_DIVISION | MATCH | 2 | SP SSP0046_GET_TEAM_BY_DIVISION | EXEC:SSP0046_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SSP.SSP0046_GET_TITLESET_POPUP | MATCH | 1 | SP SSP0046_GET_TITLESET_POPUP | EXEC:SSP0046_GET_TITLESET_POPUP, EXEC:SCM0002_SET_DEFAULT_TITLESET_POPUP, REF:FN_SCM_SYS_NVL, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, REF:STRING_SPLIT, INSERT:SCM_MST_TITLESET_USER |  |
| SSP.SSP0046_SAVE_SHIPMENT_REQUEST | MATCH | 1 | SP SSP0046_SAVE_SHIPMENT_REQUEST | EXEC:SSP0046_SAVE_SHIPMENT_REQUEST, CREATE:#TBLDYNAMIC_SSP0046_SHPIMENTREQ, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMIC_SSP0046_SHPIMENTREQ, UPDATE:A, SELECT:#TBLDYNAMIC_SSP0046_SHPIMENTREQ, SELECT:SCP_MST_BOD_N_V, SELECT:DM_PLN_SHIPMENT_REQ, INSERT:DM_PLN_SHIPMENT_REQ, INSERT:DM_PLN_SHIPMENT_REQ_H, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0046_SET_TITLESET_POPUP | MATCH | 1 | SP SSP0046_SET_TITLESET_POPUP | EXEC:SSP0046_SET_TITLESET_POPUP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, DELETE:SCM_MST_TITLESET_USER, REF:SCM_ARR_SPL_VAL, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| cboDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | dtDivision.Rows[i] | CODE |
| InitSheet | _dtTitleSet.Rows[0] | LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| InitSheet | spdUser.Sheets[0].Columns | COLUMN_LABEL_NAME, USER_SORT_METHOD_CODE, SUB_TOTAL_FLAG |
| InsertRow | UserInfoContext.Current | NowGroupID |
| ResetWidth | spdUser.ActiveSheet.Columns | SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME |
| SaveTitleSet | sv.Columns | COLUMN_NAME, USER_SORT_METHOD_CODE, SUB_TOTAL_FLAG |
| Set_SumValues | dsBinding.Tables[0].Columns | MEASURE |
| SetTitleSet | svSource.Columns | SUB_TOTAL_FLAG, USER_SELECTABLE_FLAG, SORT_ORDER_NO, COLUMN_NAME, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME, COLUMN_LABEL_NAME, SORT_METHOD_CODE, USER_SORT_METHOD_CODE |
| SetTitleSet | svTarget.Columns | COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, SORT_METHOD_CODE, SORT_ORDER_NO, USER_SORT_METHOD_CODE, USER_SELECTABLE_FLAG |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| spdUser_ButtonClicked | sv.Columns | SUB_TOTAL_FLAG |
| spdUser_RowDragMove | sv.Columns | USER_SELECTABLE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| OnShown | OnShown:182 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetCheckedListValue | OnShown:184, InitControls:208, InitControls:214, InitControls:218, FindData:602, cboDivision_SelectedIndexChanged:1103, cboDivision_SelectedIndexChanged:1114, cboDivision_SelectedIndexChanged:1119 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:279, InitSpread:303, InitSpread:283 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:280, InitSpread:304, InitSpread:284 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:587 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:210 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitializeComponent:245 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:282 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:359 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:395 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:465 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:502 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:657 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:697 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:982 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:983 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:984 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:985 |
| this | Load | Form_Load | .ctor:166 |
| dsdmPack | Changed | spdMain_Changed | InitEvent:399 |
| dsdmCell | Changed | spdMain_Changed | InitEvent:402 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:147 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:203 |
| this | Load | Form_Load | .ctor:168 |
| this.txtItemID | KeyDown | txtItemID_KeyDown | InitializeComponent:130 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:170 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:264 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:506 |
| this | Load | Form_Load | .ctor:151 |
| this.txtProject | KeyDown | txtProject_KeyDown | InitializeComponent:135 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:228 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:475 |
| this | Load | Form_Load | .ctor:162 |
| this.usrButtonList1 | UsrButtonList_Click_Detected | usrButtonList1_UsrButtonList_Click_Detected | InitializeComponent:159 |
| this.spdBase | CellDoubleClick | spdBase_CellDoubleClick | InitializeComponent:190 |
| this.spdUser | RowDragMove | spdUser_RowDragMove | InitializeComponent:208 |
| this.spdUser | RowDragMoveCompleted | spdUser_RowDragMoveCompleted | InitializeComponent:209 |
| this.spdUser | CellDoubleClick | spdUser_CellDoubleClick | InitializeComponent:210 |
| this.spdUser | ButtonClicked | spdUser_ButtonClicked | InitializeComponent:211 |
| this.btnRight | Click | btnRight_Click | InitializeComponent:244 |
| this.btnLeft | Click | btnLeft_Click | InitializeComponent:254 |
| this | Load | TitleSetForm_Load | InitializeComponent:267 |
| this | SizeChanged | TitleSetForm_SizeChanged | InitializeComponent:268 |

## 6. 컨트롤 (116개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 32 | lblItemType, layoutControlItem5, layoutControlItem6, layoutControlItem2, layoutControlItem7, lblTeam, lblCustomer, Period, lblSalesSite, lblModel, lblProject, layoutControlItem3, layoutControlItem1, lblPlantSite, clbDivision … |
| EmptySpaceItem | 13 | emptySpaceItem8, emptySpaceItem1, emptySpaceItem12, emptySpaceItem2, emptySpaceItem3, emptySpaceItem6, emptySpaceItem1, emptySpaceItem2, emptySpaceItem1, emptySpaceItem1, emptySpaceItem4, emptySpaceItem5, emptySpaceItem2 |
| UsrCheckedList | 12 | clbPlantSite, clbSalesSite, clbCustomer, clbTeam, clbDivision, clbScmSite, clbTeam, clbEndCustomer, clbDivision, clbTeam, clbEndCustomer, clbSalesSite |
| LayoutControlGroup | 9 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, Root, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| FpSpread | 6 | spdMain, spdMain, spdMain, spdMain, spdBase, spdUser |
| SheetView | 6 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdBase_Sheet1, spdUser_Sheet1 |
| UsrButtonList | 5 | btnButtonList, btnButtonList, btnButtonList, usrButtonList2, usrButtonList1 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrButton | 4 | btnMeasure, btnColumn, btnProject, btnItemId |
| UsrMultiLineEditor | 3 | txtProject, txtItemId, txtProject |
| Panel | 3 | pnlBottom, pnlCenter, pnlCenterButton |
| UsrCombo | 2 | cboDivision, cboBucketType |
| UsrCheckBox | 2 | chkSum, chkETC |
| TextBox | 2 | txtItemID, txtProject |
| Button | 2 | btnRight, btnLeft |
| UsrDateRangePicker | 1 | drpPeriod |
| ImageList | 1 | imageList1 |
| SplitContainer | 1 | splMain |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 297 | FindData | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 576 | GetScmSitebyDivision | SSP.SSP0046__GET_SITE_BY_DIVISION | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 113 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 61 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 23 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 304 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 22 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 91 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (5건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 385 | DM_H.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx | commented:MATCH |
| 480 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | commented:MATCH |
| 560 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 535 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 242 | SCM.SCM0002_GET_TITLESET_POPUP | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0046 | Cell Biz | · | 13/0 | 13/0 | · | 13/0 | 13/0 | 13/0 | 13/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | SSP0046 | ItemPopup | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |
| SCM_MST_SHEET_COLUMNS | SSP0046 | Pack Biz | · | 13/0 | 13/0 | · | 13/0 | 13/0 | 13/0 | 13/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | SSP0046 | ProjectPopup | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_MEASURE | SSP0046 | Cell Biz | · | 12/0 | · | · | 12/0 | 12/0 | 12/0 | 12/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | SSP0046 | Pack Biz | · | 10/0 | · | · | 10/0 | 10/0 | 10/0 | 10/0 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 56개 시트×division 비교, 차이 1478건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Pack Biz, Cell Biz, BOD Item Master, ItemPopup, ProjectPopup, Base, User
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:280, CreateSheetHeaderColumn@InitSpread:304, CreateSheetHeaderColumn@InitSpread:284
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn, InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeaderSpan |  | 343 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 354 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| spdMain_CellDoubleClick |  | 1228 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 1234 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1250 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 2179 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2184 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2191 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 2195 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2200 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 2207 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2211 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1001 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1002 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1003 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1004 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 208 | 하드코딩 | AddTextColumn | LOCK | LOCK |  |
| InitSpread |  | 209 | 하드코딩 | AddTextColumn | FROM_SITE | FROM_SITE |  |
| InitSpread |  | 210 | 하드코딩 | AddTextColumn | FROM_DIVISION_ID | FROM_DIVISION_ID |  |
| InitSpread |  | 211 | 하드코딩 | AddTextColumn | From Site | FROM_SITE_NAME |  |
| InitSpread |  | 212 | 하드코딩 | AddTextColumn | TO_SITE | TO_SITE |  |
| InitSpread |  | 213 | 하드코딩 | AddTextColumn | TO_DIVISION_ID | TO_DIVISION_ID |  |
| InitSpread |  | 214 | 하드코딩 | AddTextColumn | To Site | TO_SITE_NAME |  |
| InitSpread |  | 215 | 하드코딩 | AddTextColumn | Model | ITEM_ID |  |
| InitSpread |  | 216 | 하드코딩 | AddTextColumn | Priority | PRIORITY |  |
| InitSpread |  | 217 | 하드코딩 | AddTextColumn | BOD_ID | BOD_ID |  |
| InitSpread |  | 218 | 하드코딩 | AddTextColumn | FROZEN_YYYYMMDD | FROZEN_YYYYMMDD |  |
| InitSpread |  | 219 | 하드코딩 | AddTextColumn | Incoterms | INCOTERMS |  |
| InitSpread |  | 220 | 하드코딩 | AddTextColumn | Trans Mode | TRANSPORT_MODE |  |
| InitSpread |  | 221 | 하드코딩 | AddTextColumn | BOD Item Valid | BOD_ITEM_VALID |  |
| InitSpread |  | 222 | 하드코딩 | AddTextColumn | Mon | DAYS_MON |  |
| InitSpread |  | 223 | 하드코딩 | AddTextColumn | Tue | DAYS_TUE |  |
| InitSpread |  | 224 | 하드코딩 | AddTextColumn | Wed | DAYS_WED |  |
| InitSpread |  | 225 | 하드코딩 | AddTextColumn | Thu | DAYS_THU |  |
| InitSpread |  | 226 | 하드코딩 | AddTextColumn | Fri | DAYS_FRI |  |
| InitSpread |  | 227 | 하드코딩 | AddTextColumn | Sat | DAYS_SAT |  |
| InitSpread |  | 228 | 하드코딩 | AddTextColumn | Sun | DAYS_SUN |  |
| InitSpread |  | 229 | 하드코딩 | AddTextColumn | L/T(Day) | LEAD_TIME |  |
| InitSpread |  | 230 | 하드코딩 | AddTextColumn | END_CUSTOMER | END_CUSTOMER |  |
| InitSpread |  | 231 | 하드코딩 | AddTextColumn | DEPT_NAME_KO | DEPT_NAME_KO |  |
| InitializeComponent |  | 219 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 220 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 221 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 222 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 522 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 523 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 524 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 525 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 491 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 492 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 493 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 494 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSheet | 0 | 179 | 하드코딩 | AddTextColumn | ColumnName | COLUMN_NAME |  |
| InitSheet | 0 | 181 | 하드코딩 | AddTextColumn | LargeClass | LARGE_CLASS_LABEL_NAME |  |
| InitSheet | 0 | 182 | 하드코딩 | AddTextColumn | SmallClass | SMALL_CLASS_LABEL_NAME |  |
| InitSheet | 0 | 183 | 하드코딩 | AddTextColumn | Column \|\| Measure | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 184 | 하드코딩 | AddTextColumn | Sort | SORT_METHOD_CODE |  |
| InitSheet | 0 | 185 | 하드코딩 | AddNumColumn | Seq | SORT_ORDER_NO |  |
| InitSheet | 0 | 186 | 하드코딩 | AddTextColumn | Sort | USER_SORT_METHOD_CODE |  |
| InitSheet | 0 | 187 | 하드코딩 | AddCheckColumn | Sub Total | SUB_TOTAL_FLAG |  |
| InitSheet | 0 | 188 | 하드코딩 | AddTextColumn | USER_SELECTABLE_FLAG | USER_SELECTABLE_FLAG |  |
| InitSheet | 0 | 190 | 표시/라벨 변경 | set:Locked | Locked = {?true} |  |  |
| InitSheet | 0 | 197 | 하드코딩 | AddTextColumn | ColumnName | COLUMN_NAME |  |
| InitSheet | 0 | 199 | 하드코딩 | AddTextColumn | LargeClass | LARGE_CLASS_LABEL_NAME |  |
| InitSheet | 0 | 200 | 하드코딩 | AddTextColumn | SmallClass | SMALL_CLASS_LABEL_NAME |  |
| InitSheet | 0 | 201 | 하드코딩 | AddTextColumn | Column \|\| Measure | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 202 | 하드코딩 | AddTextColumn | Sort | SORT_METHOD_CODE |  |
| InitSheet | 0 | 203 | 하드코딩 | AddNumColumn | Seq | SORT_ORDER_NO |  |
| InitSheet | 0 | 204 | 하드코딩 | AddComboColumn | Sort | USER_SORT_METHOD_CODE |  |
| InitSheet | 0 | 205 | 하드코딩 | AddCheckColumn | Sub Total | SUB_TOTAL_FLAG |  |
| InitSheet | 0 | 206 | 하드코딩 | AddTextColumn | USER_SELECTABLE_FLAG | USER_SELECTABLE_FLAG |  |
| InitSheet | 0 | 208 | 표시/라벨 변경 | set:Locked | Locked = {?true} | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 209 | 표시/라벨 변경 | set:BackColor | BackColor = {?ControlColor.UnLockColor} | USER_SORT_METHOD_CODE \|\| SUB_TOTAL_FLAG |  |
| SetTitleSet | 0 | 291 | 표시/라벨 변경 | set:Value | Value = {?true} | SUB_TOTAL_FLAG | for(r < svSource.Rows.Count) ⟫ if(svSource.Cells["0", svSource.Columns["SUB_TOTAL_FLAG"].Index].Text == "Y") |
| SetTitleSet | 0 | 382 | 표시/라벨 변경 | set:Text | Text = {?sColumnName} | COLUMN_NAME | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 383 | 표시/라벨 변경 | set:Text | Text = {?sLabelName} | COLUMN_LABEL_NAME | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 384 | 표시/라벨 변경 | set:Text | Text = {?sSLabelName} | SMALL_CLASS_LABEL_NAME | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 385 | 표시/라벨 변경 | set:Text | Text = {?sLLabelName} | LARGE_CLASS_LABEL_NAME | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 386 | 표시/라벨 변경 | set:Text | Text = {?sSortMethod} | SORT_METHOD_CODE | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 387 | 표시/라벨 변경 | set:Text | Text = {?sSortOrderNo} | SORT_ORDER_NO | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 388 | 표시/라벨 변경 | set:Text | Text = {?sUSortMethod} | USER_SORT_METHOD_CODE | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 389 | 표시/라벨 변경 | set:Text | Text = {?sUserSelectedFlag} | USER_SELECTABLE_FLAG | foreach(i in selectIndex.Keys) |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 하드코딩 전용(메타 없음) | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |
| BOD Item Master | 코드 하드코딩 전용(메타 없음) | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 |
| Cell Biz | META+코드연결 | · | 13 | 13 | · | 13 | 13 | 13 | 13 | · | · | · | · | · | · |
| ItemPopup | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |
| Pack Biz | META+코드연결 | · | 13 | 13 | · | 13 | 13 | 13 | 13 | · | · | · | · | · | · |
| ProjectPopup | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
