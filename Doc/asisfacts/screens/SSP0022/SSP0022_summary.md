# SSP0022 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0022_ShipmentRequestElectrode.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0022_ShipmentRequestElectrode.UIL\SSP0022_ShipmentRequestElectrode.UIL.csproj | 37 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0022_ShipmentRequestElectrode.UIL\SSP0022_ShipmentRequestElectrode.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0022_ShipmentRequestElectrode.UIL\SSP0022_ShipmentRequestElectrode.UIL.csproj | 4792 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0022_ShipmentRequestElectrode.UIL\SSP0022_ShipmentRequestElectrode.Designer.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0022_ShipmentRequestElectrode.UIL\SSP0022_ShipmentRequestElectrode.UIL.csproj | 2286 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0022_BodItemPopup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 423 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0022_BodItemPopup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 512 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0022_ShipmentRequestPopup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1347 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0022_ShipmentRequestPopup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 353 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0022_ShipmentRequestElectrode.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 4463 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0022_ShipmentRequestElectrode.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 2286 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanDate.SelectedIndexChanged | cboPlanDate_SelectedIndexChanged > GetSpdTitle | 3869 | SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0022_GET_SHEET_CALENDAR_3SPAN |
| event:clbCompany_ID.SelectedIndexChanged | clbCompanyID_SelectedIndexChanged | 3664 | biz:CommonData.CommonDataList [code=PlantEE] | BIZ_MATCH |  |
| event:clbCompany_ID.SelectedIndexChanged | clbCompanyID_SelectedIndexChanged > InitSpread > GetSpdTitle | 3869 | SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0022_GET_SHEET_CALENDAR_3SPAN |
| button:EditButton | EditButton > GetSSPUserCheck | 4448 | SSP.SSP0002_GET_USER_INFO_LIST | MATCH | SP SSP0002_GET_USER_INFO_LIST |
| button:FindButton | FindButton > FindData | 258 | SSP.SSP0022_GET_ITEM_POPUP | MATCH | SP SSP0022_GET_ITEM_POPUP |
| button:FindButton | FindButton > FindData_Main | 2185 | SSP.SSP0022_GET_SHIPMENT_PSI | MATCH | SP SSP0022_GET_SHIPMENT_PSI |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 3869 | SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0022_GET_SHEET_CALENDAR_3SPAN |
| button:InsertButton | InsertButton > InsertRow | 1476 | biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1477 | biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 539 | SSP.SSP0022_SAVE_SHIPMENT_REQUEST | MATCH | SP SSP0022_SAVE_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 2185 | SSP.SSP0022_GET_SHIPMENT_PSI | MATCH | SP SSP0022_GET_SHIPMENT_PSI |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Request_Detail | 2339 | SSP.SSP0022_GET_REQUEST_DETAIL | MATCH | SP SSP0022_GET_REQUEST_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail | 2671 | SSP.SSP0022_SAVE_SHIPMENT_REQUEST | MATCH | SP SSP0022_SAVE_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData | 2863 | SSP.SSP0022_SAVE_SHIPMENT_REQUEST | MATCH | SP SSP0022_SAVE_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Request_Detail > InitSpread > GetSpdTitle | 3869 | SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0022_GET_SHEET_CALENDAR_3SPAN |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange > FindData | 362 | SSP.SSP0022_GET_ITEM_POPUP | MATCH | SP SSP0022_GET_ITEM_POPUP |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange | 943 | biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | BIZ_MATCH |  |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange | 945 | biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 258 | SSP.SSP0022_GET_ITEM_POPUP | MATCH | SP SSP0022_GET_ITEM_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 539 | SSP.SSP0022_SAVE_SHIPMENT_REQUEST | MATCH | SP SSP0022_SAVE_SHIPMENT_REQUEST |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Main | 2185 | SSP.SSP0022_GET_SHIPMENT_PSI | MATCH | SP SSP0022_GET_SHIPMENT_PSI |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Request_Detail | 2339 | SSP.SSP0022_GET_REQUEST_DETAIL | MATCH | SP SSP0022_GET_REQUEST_DETAIL |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Main > InitSpread > GetSpdTitle | 3869 | SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0022_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > GetSpdTitle | 3869 | SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0022_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Request_Detail | 2339 | SSP.SSP0022_GET_REQUEST_DETAIL | MATCH | SP SSP0022_GET_REQUEST_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Detail | 2484 | SSP.SSP0022_GET_STOCK_DETAIL | MATCH | SP SSP0022_GET_STOCK_DETAIL |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Request_Detail > InitSpread > GetSpdTitle | 3869 | SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0022_GET_SHEET_CALENDAR_3SPAN |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > FindData | 362 | SSP.SSP0022_GET_ITEM_POPUP | MATCH | SP SSP0022_GET_ITEM_POPUP |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1240 | biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1242 | biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1246 | biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1247 | biz:CommonData.CommonDataList [code=TransportMode] | BIZ_MATCH |  |
| event:this.formDown.Click | btnExcelFormDownload_Click > FindData_Request_Detail_DownLoad | 3043 | SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN | MATCH | SP SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN |
| event:this.Load | Form_Load > InitControls | 173 | biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 174 | biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 258 | SSP.SSP0022_GET_ITEM_POPUP | MATCH | SP SSP0022_GET_ITEM_POPUP |
| event:this.Load | Form_Load > InitControls > GetDivision | 395 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| event:this.Load | Form_Load > InitControls > GetDivisionbyScmSite | 409 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1225 | SCP.GET_DATE_RANGE_1MONTH | MATCH | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql |
| event:this.Load | Form_Load > InitControls > GetBucketType | 2096 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 3869 | SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0022_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdDetail.CellDoubleClick | SpdDetail_CellDoubleClick > FindData_BOD | 3907 | SSP.SSP0022_GET_ITEM_POPUP | MATCH | SP SSP0022_GET_ITEM_POPUP |
| event:this.spdDetail.ClipboardPasted | SpdDetail_ClipboardPasted > FindData_BOD | 3907 | SSP.SSP0022_GET_ITEM_POPUP | MATCH | SP SSP0022_GET_ITEM_POPUP |
| event:this.spdDetail.ComboSelChange | SpdDetail_ComboSelChange > FindData_BOD | 3907 | SSP.SSP0022_GET_ITEM_POPUP | MATCH | SP SSP0022_GET_ITEM_POPUP |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Main | 2185 | SSP.SSP0022_GET_SHIPMENT_PSI | MATCH | SP SSP0022_GET_SHIPMENT_PSI |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Main > InitSpread > GetSpdTitle | 3869 | SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SSP0022_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | <field:dtFcstType> | 43 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtOperationGroup> | 44 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncoterms> | 46 | biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtTransMode> | 47 | biz:CommonData.CommonDataList [code=TransportMode] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtBaseDay> | 49 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | BodValidChk | 663 | SSP.SSP0002_GET_BOD_VALID_CHECK | MATCH | SP SSP0002_GET_BOD_VALID_CHECK |
| unreached:(진입점 미연결) | BodItemValidChk | 770 | SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK | MATCH | SP SSP0022_GET_BOD_ITEM_VALID_CHECK |
| unreached:(진입점 미연결) | BodItemValidChk_main | 4094 | SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK | MATCH | SP SSP0022_GET_BOD_ITEM_VALID_CHECK |
| unreached:(진입점 미연결) | BodItemValidChk | 4143 | SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK | MATCH | SP SSP0022_GET_BOD_ITEM_VALID_CHECK |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList_SCP:SELECT:SCP_MST_BOD_V, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlantEE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE |
| biz:CommonData.CommonDataList [code=TransportMode] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCP.GET_DATE_RANGE_1MONTH | MATCH | 1 | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql | SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0002_GET_BOD_VALID_CHECK | MATCH | 1 | SP SSP0002_GET_BOD_VALID_CHECK | EXEC:SSP0002_GET_BOD_VALID_CHECK, SELECT:SCP_MST_BOD_N_V |  |
| SSP.SSP0002_GET_USER_INFO_LIST | MATCH | 1 | SP SSP0002_GET_USER_INFO_LIST | EXEC:SSP0002_GET_USER_INFO_LIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION |  |
| SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK | MATCH | 3 | SP SSP0022_GET_BOD_ITEM_VALID_CHECK | EXEC:SSP0022_GET_BOD_ITEM_VALID_CHECK, SELECT:SCP_MST_BOD_ITEM, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SSP.SSP0022_GET_ITEM_POPUP | MATCH | 3 | SP SSP0022_GET_ITEM_POPUP | EXEC:SSP0022_GET_ITEM_POPUP, SELECT:SCM_MST_SITE, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCP_MST_BOD_ITEM, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_SITE_ITEM_EE_V |  |
| SSP.SSP0022_GET_REQUEST_DETAIL | MATCH | 1 | SP SSP0022_GET_REQUEST_DETAIL | EXEC:SSP0022_GET_REQUEST_DETAIL, DYNAMIC@SSP0022_GET_REQUEST_DETAIL |  |
| SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN | MATCH | 1 | SP SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN | EXEC:SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN, REF:FN_GET_SSP_ETA_DATE, SELECT:SSP_MST_SHIP_CALENDAR, SELECT:SSP_ANL_SHIP_REQ_EE, REF:STRING_SPLIT, SELECT:SCP_MST_BOD_N_V, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SSP0022_GET_SHEET_CALENDAR_3SPAN | EXEC:SSP0022_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0022_GET_SHIPMENT_PSI | MATCH | 1 | SP SSP0022_GET_SHIPMENT_PSI | EXEC:SSP0022_GET_SHIPMENT_PSI, REF:FN_GET_LOOKUP_VALUE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TBLDYNAMICTITLEST_SSP0022, CREATE:#TMP_RESULT_TABLE, INSERT:#TMP_PLAN_ITEM_CUTOFF, SELECT:SSP_ANL_SHIP_PLAN_EE, SELECT:SSP_MST_MODEL_USER_EE, SELECT:SSP_MST_DELEGATE, INSERT:#TMP_BOH_CUTOFF_EE, SELECT:SSP_ANL_BOH_CUTOFF_EE, REF:UF_FX_STRING_SPLIT, REF:STRING_SPLIT, INSERT:#TMP_SHIP_PLAN_ETD, SELECT:SSP_DNM_SHIP_RESULT_OWMS_V, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:#TMP_PLAN_ITEM_CUTOFF, SELECT:SSP_ANL_SHIP_CONFIRM, REF:FN_GET_SSP_ANL_SHIP_FROZEN, SELECT:SSP_ANL_SHIP_REQ_EE, INSERT:#TMP_INTRANSIT_ETA, SELECT:SSP_DNM_FP_MRP_INTRANSIT_SN, SELECT:SCP_MST_FINAL_ITEM, REF:FN_GET_SSP_SITE_INFO, INSERT:#TMP_ROWDATA, SELECT:#TMP_SHIP_PLAN_ETD, SELECT:#TMP_INTRANSIT_ETA, INSERT:#TMP_INV_REQ, SELECT:#TMP_ROWDATA, SELECT:#TMP_BOH_CUTOFF_EE, SELECT:#TMP_INV_REQ, INSERT:#TMP_PLAN_INV, SELECT:#TMP_PLAN_INV, INSERT:#TMP_RESULT_TABLE, REF:FN_GET_SSP_ETA_DATE, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SSP_MST_SHIP_MASTER_EE, SELECT:SCP_MST_BOD_N_V, INSERT:#TBLDYNAMIC_REQUESTOR, INSERT:#TMP_RESULT_PIVOT_TABLE, SELECT:#TMP_RESULT_TABLE, DYNAMIC@SSP0022_GET_SHIPMENT_PSI, INSERT:#TMP_ROWDATA_OLD, INSERT:#TMP_RESULT_TABLE_0LD, SELECT:#TMP_ROWDATA_OLD, INSERT:#TMP_RESULT_PIVOT_TABLE_OLD, SELECT:#TMP_RESULT_TABLE_0LD, SELECT:SCM_CODE_LOOKUP_VALUE, SELECT:SCM_MST_SITE_CUSTOMER |  |
| SSP.SSP0022_GET_STOCK_DETAIL | MATCH | 1 | SP SSP0022_GET_STOCK_DETAIL | EXEC:SSP0022_GET_STOCK_DETAIL, DYNAMIC@SSP0022_GET_STOCK_DETAIL |  |
| SSP.SSP0022_SAVE_SHIPMENT_REQUEST | MATCH | 3 | SP SSP0022_SAVE_SHIPMENT_REQUEST | EXEC:SSP0022_SAVE_SHIPMENT_REQUEST, CREATE:#TBLDYNAMIC_SSP0022_SHPIMENTREQ, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, INSERT:#TBLDYNAMIC_SSP0022_SHPIMENTREQ, SELECT:SCM_MST_SITE, REF:FN_GET_SSP_ETD_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:#TBLDYNAMIC_SSP0022_SHPIMENTREQ, UPDATE:A, SELECT:SSP_ANL_SHIP_REQ_EE, INSERT:SSP_ANL_SHIP_REQ_EE, INSERT:#TBLDYNAMIC_SSP0022_SHPIMENTREQ_H, INSERT:SSP_ANL_SHIP_REQ_EE_H, SELECT:#TBLDYNAMIC_SSP0022_SHPIMENTREQ_H, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_SYS_CALENDAR_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtDivision> | UserInfoContext.Current | NowGroupID |
| cboPlanDate_SelectedIndexChanged | row | CODE |
| cboPlanDate_SelectedIndexChanged | dr | CODE, FROM_DATE, TO_DATE |
| clbDivision_ID_SelectedIndexChanged | c | DIVISION_ID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE, NAME |
| InitControls | dtShipmentInputPeriod.Rows[0] | VALUE, Diff_VALUE |
| InitControls | dtShipmentInputPeriod.Rows[1] | VALUE, Diff_VALUE |
| InitControls | dtCompany.Rows[0] | CODE |
| Plan_Current_Check | Tmp_dtPlanDate.Rows[0] | CODE, NAME, FROM_DATE, TO_DATE |
| SetChangeControl | Filter | GROUP_ID, USER_ID |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| SetChangedControl | c | CODE, DIVISION_ID |
| SetChangedControl | dtMyCompany.Rows[0] | NAME |
| SpdDetail_ClipboardPasted | c | CODE |
| SpdDetail_ClipboardPasted | dr | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSSPInnerTable | SetChangeControl:386, SetChangeControl:391, SetChangeControl:396, SetChangeControl:401, SetChangeControl:406, SetChangeControl:411, SetChangeControl:416, SetChangeControl:421 | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| FP_Log2 | InitControls:444, InitControls:453 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetCheckedListValue | SetChangedControl:541, SetChangedControl:542, SpdDetail_ClipboardPasted:888, SpdDetail_CellDoubleClick:1034, SpdMain_CellDoubleClick:1405, SpdMain_CellDoubleClick:1406, SpdMain_CellDoubleClick:1407, InsertRow:1476 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:603, cboPlanDate_SelectedIndexChanged:3719 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:609, InitSpread:671, InitSpread:694, InitSpread:707 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:614 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| SaveData | SaveButton:1799, SaveButton:312, btnButtonList_UsrButtonList_Click_Detected:816 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.formDown | Click | btnExcelFormDownload_Click | InitializeComponent:264 |
| this.btnExcelUpload | Click | btnExcelUpload_Click | InitializeComponent:306 |
| this.chkPastPeriod | CheckedChanged | chkPastPeriod_CheckedChanged_1 | InitializeComponent:489 |
| this.spdMain | CellClick | spdMain_CellClick_1 | InitializeComponent:1459 |
| this | Load | Form_Load | .ctor:347 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:815 |
| this.spdDetail | TopChange | SpdDetail_TopChange | InitEvent:816 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:818 |
| this.rdButton1 | CheckedChanged | rdButton_Changed | InitEvent:819 |
| this.rdButton2 | CheckedChanged | rdButton_Changed | InitEvent:820 |
| this.rdButton3 | CheckedChanged | rdButton_Changed | InitEvent:821 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:822 |
| this.chkPastPeriod | CheckedChanged | chkPastPeriod_CheckedChanged | InitEvent:823 |
| this.btnMeasure | Click | BtnMeasure_Click | InitEvent:824 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:825 |
| this.btnItemID2 | Click | BtnItemID2_Click | InitEvent:826 |
| this.btnSearch | Click | BtnSearch_Click | InitEvent:827 |
| this.btnRequestor | Click | BtnRequestor_Click | InitEvent:828 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:830 |
| this.spdDetail | ActiveSheetChanged | SpdDetail_ActiveSheetChanged | InitEvent:831 |
| this.spdDetail | SheetTabClick | SpdDetail_SheetTabClick | InitEvent:833 |
| this.spdDetail | ActiveSheetChanged | SpdDetail_ActiveSheetChanged | InitEvent:834 |
| this.spdDetail | CellClick | SpdDetail_CellClick | InitEvent:836 |
| this.spdDetail | ComboSelChange | SpdDetail_ComboSelChange | InitEvent:837 |
| this.spdDetail | CellDoubleClick | SpdDetail_CellDoubleClick | InitEvent:838 |
| this.spdDetail | ClipboardPasted | SpdDetail_ClipboardPasted | InitEvent:839 |
| this.spdDetail | EditChange | SpdDetail_EditChange | InitEvent:840 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:841 |
| this.spdMain | Change | SpdMain_Change | InitEvent:842 |
| clbDivision_ID | SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged | InitEvent:846 |
| clbCompany_ID | SelectedIndexChanged | clbCompanyID_SelectedIndexChanged | InitEvent:847 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | InitEvent:848 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | clbCompanyID_SelectedIndexChanged:3669 |
| cboPlanDate | SelectedIndexChanged | cboPlanDate_SelectedIndexChanged | clbCompanyID_SelectedIndexChanged:3673 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:189 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:282 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:416 |
| this | Load | Form_Load | .ctor:137 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:144 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:192 |
| this | Load | Form_Load | .ctor:143 |
| spdMain | CellClick | SpdMain_CellClick | Form_Load:160 |
| spdMain | EditChange | SpdMain_EditChange | Form_Load:162 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | Form_Load:163 |
| spdMain | TextChanged | SpdMain_TextChanged | Form_Load:164 |

## 6. 컨트롤 (118개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 42 | layoutControlItem7, layoutControlItem10, layoutControlItem8, lblCombo1, lblItemId, layoutControlItem1, layoutControlItem6, PlanDate, lblBucket, layoutControlItem15, layoutControlItem16, layoutControlItem23, layoutControlItem18, layoutControlItem22, layoutControlItem9 … |
| UsrMultiLineEditor | 8 | txtModelId, txtItemId, txtModelId2, txtRequestor, txtItemld2, txtLotID, usrMultiLineEditor1, txtItemID |
| UsrButton | 7 | formDown, btnExcelUpload, btnModelId, btnMeasure, btnItemId, btnRequestor, btnItemID2 |
| LayoutControlGroup | 7 | layoutControlGroup2, layoutControlGroup3, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, Root |
| UsrLayoutControl | 6 | usrLayoutControl2, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| UsrCheckBox | 6 | chkDelegateModel, chkTeamLeader, chkPartLeader, chkPastPeriod, chkSum, chkMyModel |
| UsrCheckedList | 6 | clbCellType, clbPlantSite, clbDivision, clbFromSite, clbToSite, clbDivision |
| FpSpread | 5 | spdMain, spdDetail, spdSub, spdMain, spdMain |
| SheetView | 5 | spdMain_Sheet1, spdDetail_Sheet1, spdSub_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| EmptySpaceItem | 5 | emptySpaceItem2, emptySpaceItem5, emptySpaceItem4, emptySpaceItem1, emptySpaceItem1 |
| UsrCombo | 4 | clbCompany_ID, clbDivision_ID, cboPlanDate, cboBucketType |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrRadio | 3 | rdButton3, rdButton1, rdButton2 |
| TextBox | 2 | textNickName, textNickName2 |
| UsrDateRangePicker | 2 | drpPeriod, drpPeriod2 |
| ImageList | 2 | imageList1, imageList1 |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| UsrLabel | 1 | lblUOMType |
| SplitContainer | 1 | splitContainer1 |
| SimpleButton | 1 | btnSearch |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 207 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 1 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 3 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 103 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 10 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 4 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 9 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 141 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (3건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 4003 | SSP.SSP0002_GET_BOD_VALID_CHECK | commented:MATCH |
| 396 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 1226 | SCP.SCM0001_GET_SCP_DAY_PERIOD | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0022 | Shipment Request Detail | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |
| SCM_MST_SHEET_COLUMNS | SSP0022 | Shipment Request Detail Excel | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |
| SCM_MST_SHEET_COLUMNS | SSP0022 | Shipment Request(Electrode) | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 |
| SCM_MST_SHEET_COLUMNS | SSP0022 | Stock Detail | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 |
| SCM_MST_SHEET_MEASURE | SSP0022 | Shipment Request(Electrode) | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Request(Electrode), Stock Detail, Shipment Request Detail, Shipment Request Detail Excel, Project, Shipment Reqeust(Electrode)
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:609, SetSheetHeaderColumn@InitSpread:671, SetSheetHeaderColumn@InitSpread:694, SetSheetHeaderColumn@InitSpread:707
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Shipment Request(Electrode) | 628 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 629 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 630 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 631 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 632 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 633 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 634 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 635 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 636 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton1.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 642 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 643 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 644 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 645 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 646 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 647 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 648 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 649 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 650 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton2.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 655 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 656 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 657 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY_PCM | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 658 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 659 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 660 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_CELL | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 661 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 662 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpread | Shipment Request(Electrode) | 663 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY | if(spdInfo.SheetName == "Shipment Request(Electrode)") ⟫ if(rdButton3.Checked == true) |
| InitSpreadDateColumn |  | 753 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 759 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 763 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| rdButton_Changed |  | 1823 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_PCM | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 1824 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_PCM | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 1825 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_PCM | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 1826 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_CELL | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 1827 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_CELL | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 1828 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_CELL | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 1829 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 1830 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 1831 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY | if(rdButton1.Checked == true) |
| rdButton_Changed |  | 1837 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_PCM | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 1838 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_PCM | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 1839 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_PCM | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 1840 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY_CELL | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 1841 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY_CELL | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 1842 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY_CELL | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 1843 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 1844 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 1845 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY | if(rdButton2.Checked == true) |
| rdButton_Changed |  | 1850 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TOT_BOH_QTY_PCM | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 1851 | 표시/라벨 변경 | set:Visible | Visible = {?true} | JR_BOH_QTY_PCM | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 1852 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PC_BOH_QTY_PCM | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 1853 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY_CELL | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 1854 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY_CELL | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 1855 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY_CELL | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 1856 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TOT_BOH_QTY | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 1857 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY | if(rdButton3.Checked == true) |
| rdButton_Changed |  | 1858 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY | if(rdButton3.Checked == true) |
| SetSpreadColumn |  | 1904 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_") == 0) |
| SetSpreadColumn |  | 1909 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_") == 0) |
| SetSpreadColumn |  | 1917 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("X_W_") == 0) |
| SetSpreadColumn |  | 1922 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("X_W_") == 0) |
| SetSpreadColumn |  | 1930 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_D_") == 0) |
| SetSpreadColumn |  | 1934 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("X_D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_W_") == 0) |
| SetSpreadColumn |  | 1938 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_M_") == 0) |
| SetSpreadColumn |  | 1946 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("X_W_") == 0) |
| SetSpreadColumn |  | 1950 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdButton1.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("X_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("X_W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_M_") == 0) |
| SetSpreadColumn |  | 1961 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_") == 0) |
| SetSpreadColumn |  | 1965 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("X_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 1973 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_W_") == 0) |
| SetSpreadColumn |  | 1978 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_W_") == 0) |
| SetSpreadColumn |  | 1986 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_D_") == 0) |
| SetSpreadColumn |  | 1990 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Y_D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_W_") == 0) |
| SetSpreadColumn |  | 1995 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_M_") == 0) |
| SetSpreadColumn |  | 2003 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_W_") == 0) |
| SetSpreadColumn |  | 2007 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ if(rdButton2.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Y_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_M_") == 0) |
| SetSpreadColumn |  | 2017 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("X_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 2021 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("X_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_") == 0) |
| SetSpreadColumn |  | 2029 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_W_") == 0) |
| SetSpreadColumn |  | 2034 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_W_") == 0) |
| SetSpreadColumn |  | 2042 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_D_") == 0) |
| SetSpreadColumn |  | 2046 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Z_D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_W_") == 0) |
| SetSpreadColumn |  | 2051 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_M_") == 0) |
| SetSpreadColumn |  | 2059 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_W_") == 0) |
| SetSpreadColumn |  | 2063 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdButton1.Checked == true) ⟫ else!(rdButton2.Checked == true) ⟫ if(rdButton3.Checked == true) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Z_D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Z_W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Z_M_") == 0) |
| SetSpreadColumn |  | 2081 | 표시/라벨 변경 | set:Visible | Visible = {?chkPastPeriod.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(!chkPastPeriod.Checked) ⟫ else!(siMain.ActiveSheet.ColumnHeader.Cells[2, iCol].Value.ToString() == "SUM") ⟫ if(date > colDate) |
| ExportExcel |  | 4338 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcel |  | 4380 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 1475 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1476 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1477 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1478 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1548 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1549 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1550 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1551 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2030 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2031 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2032 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2033 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 208 | 하드코딩 | AddTextColumn | Division | DIVISION_ID |  |
| InitSpread |  | 209 | 하드코딩 | AddTextColumn | Division | DIVISION_NAME |  |
| InitSpread |  | 210 | 하드코딩 | AddTextColumn | Model | MODEL_ID |  |
| InitSpread |  | 211 | 하드코딩 | AddTextColumn | Material | ITEM_ID |  |
| InitSpread |  | 212 | 하드코딩 | AddTextColumn | Incoterms | INCOTERMS |  |
| InitSpread |  | 213 | 하드코딩 | AddTextColumn | Transport Mode | TRANSPORT_MODE |  |
| InitSpread |  | 214 | 하드코딩 | AddTextColumn | BOD ID | BOD_ID |  |
| InitSpread |  | 215 | 하드코딩 | AddTextColumn | Confirm Day | CONFIRM_DAY |  |
| InitializeComponent |  | 432 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 433 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 434 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 435 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 257 | 하드코딩 | AddComboColumn | Div* | DIVISION_ID |  |
| InitSpread |  | 259 | 하드코딩 | AddComboColumn | SCM Site* | SCM_SITE_ID |  |
| InitSpread |  | 260 | 하드코딩 | AddComboColumn | Plant | PLANT_ID |  |
| InitSpread |  | 261 | 하드코딩 | AddComboColumn | From Site* | FROM_SITE |  |
| InitSpread |  | 262 | 하드코딩 | AddComboColumn | To Site* | TO_SITE |  |
| InitSpread |  | 263 | 하드코딩 | AddTextColumn | Model* | MODEL_ID |  |
| InitSpread |  | 264 | 하드코딩 | AddTextColumn | Material* | ITEM_ID |  |
| InitSpread |  | 265 | 하드코딩 | AddTextColumn | Nick Name | NICK_NAME |  |
| InitSpread |  | 266 | 하드코딩 | AddDateColumn | Shipment Date* | SHIPMENT_DATE |  |
| InitSpread |  | 267 | 하드코딩 | AddNumColumn | Qty*  | SHIPMENT_QTY |  |
| InitSpread |  | 268 | 하드코딩 | AddComboColumn | Incoterms* | INCOTERMS |  |
| InitSpread |  | 269 | 하드코딩 | AddComboColumn | Trans Mode*  | TRANSPORT_MODE |  |
| InitSpread |  | 270 | 하드코딩 | AddNumColumn | L/T(Day) | LT |  |
| InitSpread |  | 271 | 하드코딩 | AddDateColumn | ETD | ETD |  |
| InitSpread |  | 272 | 하드코딩 | AddDateColumn | ETA | ETA |  |
| InitSpread |  | 274 | 하드코딩 | AddTextColumn | ROUTE_ID | ROUTE_ID |  |
| InitSpread |  | 275 | 하드코딩 | AddTextColumn | BOD_ID | BOD_ID |  |
| InitSpread |  | 276 | 하드코딩 | AddTextColumn | CONFIRM_DAY | CONFIRM_DAY |  |
| InitSpread |  | 277 | 하드코딩 | AddTextColumn | D_COUNTRY | D_COUNTRY |  |
| InitSpread |  | 278 | 하드코딩 | AddTextColumn | D_PORT_CODE | D_PORT_CODE |  |
| InitSpread |  | 279 | 하드코딩 | AddTextColumn | A_COUNTRY | A_COUNTRY |  |
| InitSpread |  | 280 | 하드코딩 | AddTextColumn | A_PORT_CODE | A_PORT_CODE |  |
| InitSpread |  | 281 | 하드코딩 | AddTextColumn | TO_COUNTRY | TO_COUNTRY |  |
| InitSpread |  | 282 | 하드코딩 | AddTextColumn | TO_CITY | TO_CITY |  |
| InitSpread |  | 284 | 하드코딩 | AddTextColumn | ELECTRODE_YN | ELECTRODE_YN |  |
| InitSpread |  | 285 | 하드코딩 | AddTextColumn | ORIGIN_FROM_DIVISION_ID | ORIGIN_FROM_DIVISION_ID |  |
| InitializeComponent |  | 277 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 278 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 279 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 280 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Project | 코드 하드코딩 전용(메타 없음) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Shipment Reqeust(Electrode) | 코드 하드코딩 전용(메타 없음) | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 |
| Shipment Request Detail | META+코드연결 | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) | 19 (?9) |
| Shipment Request Detail Excel | META+코드연결 | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) | 12 (?9) |
| Shipment Request(Electrode) | META+코드연결 | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) | 22 (?9) |
| Stock Detail | META+코드연결 | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) | 31 (?9) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:화면컨트롤값 1890 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 1890건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
