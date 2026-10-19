# DMF0008 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0008_ErpEdiMaster\DMF0008_ErpEdiMaster.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0008_ErpEdiMaster\DMF0008_ErpEdiMaster.csproj | 3371 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0008_ErpEdiMaster\DMF0008_ErpEdiMaster.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0008_ErpEdiMaster\DMF0008_ErpEdiMaster.csproj | 951 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0008_ErpEdiMaster\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0008_ErpEdiMaster\DMF0008_ErpEdiMaster.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0008_ErpEdiMaster\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0008_ErpEdiMaster\DMF0008_ErpEdiMaster.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0008_ErpEdiMaster\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0008_ErpEdiMaster\DMF0008_ErpEdiMaster.csproj | 27 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0008_ErpEdiMaster.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 2938 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0008_ErpEdiMaster.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 949 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2953 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:dsdm1.Changed | spdSub_Changed | 3244 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:dsdm1.Changed | spdSub_Changed | 3248 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:dsdm1.Changed | spdSub_Changed | 3259 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:dsdm1.Changed | spdSub_Changed | 3263 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:dsdm2.Changed | spdSub_Changed | 3244 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:dsdm2.Changed | spdSub_Changed | 3248 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:dsdm2.Changed | spdSub_Changed | 3259 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:dsdm2.Changed | spdSub_Changed | 3263 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 925 | DM.DMF0008_GET_EDI_MST_SUMMARY | MATCH | SP DMF0008_GET_EDI_MST_SUMMARY |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 2953 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveSSPM > FindData_SubSalesSiteProjectModel > FindData_SubSalesSite | 1194 | DM.DMF0008_GET_SALES_SITE | MATCH | SP DMF0008_GET_SALES_SITE |
| button:SaveButton | SaveButton > SaveSSPM > FindData_SubSalesSiteProjectModel | 1283 | DM.DMF0008_GET_SALES_SITE_PROJECT_MODEL | MATCH | SP DMF0008_GET_SALES_SITE_PROJECT_MODEL |
| button:SaveButton | SaveButton > SaveSSPM > FindData_SubSalesSiteProjectModel | 1334 | DM.DMF0008_GET_SALES_SITE | MATCH | SP DMF0008_GET_SALES_SITE |
| button:SaveButton | SaveButton > SaveSalesSite | 1517 | DM.DMF0008_SAVE_SALES_SITE_EDI_REPAIR | MATCH | SP DMF0008_SAVE_SALES_SITE_EDI_REPAIR |
| button:SaveButton | SaveButton > SaveSSPM | 1716 | DM.DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR | MATCH | SP DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR |
| button:SaveButton | SaveButton > SaveSSPM > FindData_SubSalesSiteProjectModel > FindData_SubSalesSite > InitSpread > GetSpdTitle | 2953 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnStatusUpdate.Click | btnStatusUpdate_Click > FindData_Main | 925 | DM.DMF0008_GET_EDI_MST_SUMMARY | MATCH | SP DMF0008_GET_EDI_MST_SUMMARY |
| event:this.btnStatusUpdate.Click | btnStatusUpdate_Click > FindData_Main > InitSpread > GetSpdTitle | 2953 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnStatusUpdate.Click | btnStatusUpdate_Click | 3027 | DM.PR_DM_DNM_EDI_CALLOFF_STATUS | MATCH | SP PR_DM_DNM_EDI_CALLOFF_STATUS |
| event:this.btnStatusUpdate.Click | btnStatusUpdate_Click > GetUpdateHistory | 3350 | DM.DMF0000_GET_UPDATE_HISTORY | MATCH | SP DMF0000_GET_UPDATE_HISTORY |
| event:this.Load | Form_Load > InitControls | 406 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 416 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 418 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 2936 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2953 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetSoldToCustomerData | 2987 | DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA | MATCH | SP DMF0004_GET_SOLDTO_CUSTOMER_DATA |
| event:this.Load | Form_Load > GetUpdateHistory | 3350 | DM.DMF0000_GET_UPDATE_HISTORY | MATCH | SP DMF0000_GET_UPDATE_HISTORY |
| event:this.spdRepair.CellDoubleClick | spdRepair_CellDoubleClick > FindData_SubSalesSiteProjectModel > FindData_SubSalesSite | 1194 | DM.DMF0008_GET_SALES_SITE | MATCH | SP DMF0008_GET_SALES_SITE |
| event:this.spdRepair.CellDoubleClick | spdRepair_CellDoubleClick > FindData_SubSalesSiteProjectModel | 1283 | DM.DMF0008_GET_SALES_SITE_PROJECT_MODEL | MATCH | SP DMF0008_GET_SALES_SITE_PROJECT_MODEL |
| event:this.spdRepair.CellDoubleClick | spdRepair_CellDoubleClick > FindData_SubSalesSiteProjectModel | 1334 | DM.DMF0008_GET_SALES_SITE | MATCH | SP DMF0008_GET_SALES_SITE |
| event:this.spdRepair.CellDoubleClick | spdRepair_CellDoubleClick > FindData_SubSalesSiteProjectModel > FindData_SubSalesSite > InitSpread > GetSpdTitle | 2953 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdSub.CellDoubleClick | spdSub_CellDoubleClick > FindData_SubCustomer > InitSpread > GetSpdTitle | 2953 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdSub.CellDoubleClick | spdSub_CellDoubleClick > FindData_SubCustomer | 3295 | DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DMF0004_GET_SALES_SITE_CUSTOMER_DATA |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 2102 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 2113 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange > GetScmSiteInfobyDivision | 2129 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| event:this.spdSub.SheetTabClick | spdSub_SheetTabClick > FindData_SubSalesSiteProjectModel > FindData_SubSalesSite | 1194 | DM.DMF0008_GET_SALES_SITE | MATCH | SP DMF0008_GET_SALES_SITE |
| event:this.spdSub.SheetTabClick | spdSub_SheetTabClick > FindData_SubSalesSiteProjectModel | 1283 | DM.DMF0008_GET_SALES_SITE_PROJECT_MODEL | MATCH | SP DMF0008_GET_SALES_SITE_PROJECT_MODEL |
| event:this.spdSub.SheetTabClick | spdSub_SheetTabClick > FindData_SubSalesSiteProjectModel | 1334 | DM.DMF0008_GET_SALES_SITE | MATCH | SP DMF0008_GET_SALES_SITE |
| event:this.spdSub.SheetTabClick | spdSub_SheetTabClick > FindData_SubSalesSiteProjectModel > FindData_SubSalesSite > InitSpread > GetSpdTitle | 2953 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdSummary.CellDoubleClick | spdSummary_CellDoubleClick > FindData_SubRepair_New | 1098 | DM.DMF0008_GET_EDI_MST_REPAIR | MATCH | SP DMF0008_GET_EDI_MST_REPAIR |
| event:this.spdSummary.CellDoubleClick | spdSummary_CellDoubleClick > FindData_SubRepair_New > InitSpread > GetSpdTitle | 2953 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdSummary.ComboSelChange | spdMain_ComboSelChange | 2022 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| event:this.spdSummary.ComboSelChange | spdMain_ComboSelChange | 2023 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncoterms> | 72 | biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 73 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FindData_SubRepair | 995 | DM.DMF0008_GET_EDI_MST_REPAIR | MATCH | SP DMF0008_GET_EDI_MST_REPAIR |
| unreached:(진입점 미연결) | SetGridHeader | 2007 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetPlantbyDivision | 2973 | SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | SP SCM0001_GET_PLANT_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList_SCP:SELECT:SCP_MST_BOD_V, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0000_GET_UPDATE_HISTORY | MATCH | 1 | SP DMF0000_GET_UPDATE_HISTORY | EXEC:DMF0000_GET_UPDATE_HISTORY, SELECT:SCM_SYS_LOG_BATCH |  |
| DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | 1 | SP DMF0004_GET_SALES_SITE_CUSTOMER_DATA | EXEC:DMF0004_GET_SALES_SITE_CUSTOMER_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_DEPT_LIST, REF:FN_GET_DEPT_LIST2, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE, SELECT:TB_FX_USER, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO |  |
| DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA | MATCH | 1 | SP DMF0004_GET_SOLDTO_CUSTOMER_DATA | EXEC:DMF0004_GET_SOLDTO_CUSTOMER_DATA, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:UF_FX_STRING_SPLITFORIN, SELECT:SPLIT |  |
| DM.DMF0008_GET_EDI_MST_REPAIR | MATCH | 2 | SP DMF0008_GET_EDI_MST_REPAIR | EXEC:DMF0008_GET_EDI_MST_REPAIR, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_MST_SITE |  |
| DM.DMF0008_GET_EDI_MST_SUMMARY | MATCH | 1 | SP DMF0008_GET_EDI_MST_SUMMARY | EXEC:DMF0008_GET_EDI_MST_SUMMARY, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_MST_SITE |  |
| DM.DMF0008_GET_SALES_SITE | MATCH | 2 | SP DMF0008_GET_SALES_SITE | EXEC:DMF0008_GET_SALES_SITE, INSERT:#TEMP_DMF0008_RESULT_TABLE_1, REF:FN_GET_DEPT_LIST, REF:FN_GET_DEPT_LIST2, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USER, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_CITY, INSERT:#TEMP_DMF0008_RESULT_TABLE_2, SELECT:#TEMP_DMF0008_RESULT_TABLE_1, SELECT:#TEMP_DMF0008_RESULT_TABLE_2, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO |  |
| DM.DMF0008_GET_SALES_SITE_PROJECT_MODEL | MATCH | 1 | SP DMF0008_GET_SALES_SITE_PROJECT_MODEL | EXEC:DMF0008_GET_SALES_SITE_PROJECT_MODEL, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, CREATE:#T_SINGLE, CREATE:#SCM_MST_SITE_ITEM, INSERT:#T_SINGLE, SELECT:SCM_MST_ITEM_SN, INSERT:#SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE_ITEM, SELECT:#T_SINGLE, REF:FN_GET_MULTI_OWNER_NAME, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, SELECT:DM_MST_CUSTOMER_MODEL |  |
| DM.DMF0008_SAVE_SALES_SITE_EDI_REPAIR | MATCH | 1 | SP DMF0008_SAVE_SALES_SITE_EDI_REPAIR | EXEC:DMF0008_SAVE_SALES_SITE_EDI_REPAIR, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SCM_MST_SITE_H, SELECT:SCM_MST_SITE, EXEC:PR_DM_MST_SITE_CUSTOMER_HIST, MERGE:SCM_MST_SITE_CUSTOMER, MERGE:SCM_MST_SITE, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_SITE_CUSTOMER_H, SELECT:SCM_MST_SITE_CUSTOMER |  |
| DM.DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR | MATCH | 1 | SP DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR | EXEC:DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SCM_MST_SITE_ITEM_H, SELECT:SCM_MST_SITE_ITEM, MERGE:SCM_MST_SITE_ITEM, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.PR_DM_DNM_EDI_CALLOFF_STATUS | MATCH | 1 | SP PR_DM_DNM_EDI_CALLOFF_STATUS | EXEC:PR_DM_DNM_EDI_CALLOFF_STATUS, EXEC:PR_SCM_SYS_LOG_BATCH, CREATE:#TEMP_EDI_INVALID_DATA, CREATE:#TEMP_SCM_MST_ITEM_SN, CREATE:#TEMP_SCM_MST_SITE_ITEM, INSERT:#TEMP_EDI_INVALID_DATA, SELECT:DM_DNM_EDI_CALLOFF_ITEM, INSERT:#TEMP_SCM_MST_ITEM_SN, SELECT:SCM_MST_ITEM_SN, SELECT:#TEMP_EDI_INVALID_DATA, INSERT:#TEMP_SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE_ITEM, UPDATE:A, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_SITE, SELECT:#TEMP_SCM_MST_SITE_ITEM, UPDATE:#TEMP_EDI_INVALID_DATA, UPDATE:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_PLANT_BY_DIVISION | EXEC:SCM0001_GET_PLANT_BY_DIVISION, SELECT:SCM_MST_PLANT_SN, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_INFO_BY_DIVISION | EXEC:SCM0001_GET_SITE_INFO_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, REF:STRING_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| DefineProperty | UserInfoContext.Current | NowGroupID |
| EditButton | UserInfoContext.Current | NowGroupID |
| FindData_SubCustomer | UserInfoContext.Current | NowGroupID |
| GetUpdateHistory | dt.Rows[0] | SDATE, EDATE, UPDATED_BY |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| spdSub_ComboSelChange | UserInfoContext.Current | NowGroupID |
| spdSub_ComboSelChange | dtSalesPlant.Rows[0] | CODE |
| spdSub_ComboSelChange | dtSalesCompany.Rows[0] | CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:311, SetChangeControl:318, SetChangeControl:326, SetChangeControl:335, SetChangeControl:340 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| FP_Log2 | InitControls:354, InitControls:398 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetCheckedListValue | InitControls:360, InitControls:368, InitControls:376, FindData_Main:884, FindData_Main:913, spdSub_SheetTabClick:2479, btnStatusUpdate_Click:3014 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:467 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:468 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdSummary | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:342 |
| this.spdSummary | EditChange | spdMain_EditChange | InitializeComponent:343 |
| this.spdSummary | TopChange | spdMain_TopChange | InitializeComponent:344 |
| this.btnStatusUpdate | Click | btnStatusUpdate_Click | InitializeComponent:511 |
| this.spdSub | SheetTabClick | spdSub_SheetTabClick | InitializeComponent:807 |
| this.spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitializeComponent:808 |
| this.spdSub | LeaveCell | spdSub_LeaveCell | InitializeComponent:809 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:810 |
| this.spdSub | EditChange | spdSub_EditChange | InitializeComponent:811 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:812 |
| this | Load | Form_Load | .ctor:274 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | .ctor:275 |
| dsdm1 | Changed | spdSub_Changed | DefineProperty:430 |
| dsdm2 | Changed | spdSub_Changed | DefineProperty:432 |
| dsdm1 | Changed | shtSALES_SITEDataModel_Changed | InitEvent:475 |
| dsdm2 | Changed | shtSSPMDataModel_Changed | InitEvent:478 |
| this.spdSummary | CellDoubleClick | spdSummary_CellDoubleClick | InitEvent:480 |
| this.spdRepair | CellDoubleClick | spdRepair_CellDoubleClick | InitEvent:481 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:483 |

## 6. 컨트롤 (36개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | layoutControlItem1, layoutControlItem2, layoutControlItem3, layoutControlItem4, layoutControlItem5, layoutControlItem6, lbldivision, Period |
| UsrLabel | 5 | usrLabel1, lblRepair_Cnt, lblTitle, lblUpdateHistory, usrLabel2 |
| EmptySpaceItem | 4 | emptySpaceItem3, emptySpaceItem1, emptySpaceItem2, emptySpaceItem4 |
| FpSpread | 3 | spdRepair, spdSummary, spdSub |
| SheetView | 3 | spdRepair_Sheet1, spdSummary_Sheet1, spdSub_Sheet1 |
| UsrLayoutControl | 3 | usrLayoutControl2, usrLayoutControl3, usrLayoutControl1 |
| LayoutControlGroup | 3 | layoutControlGroup1, layoutControlGroup3, layoutControlGroup2 |
| SimpleLabelItem | 2 | simpleLabelItem2, simpleLabelItem1 |
| SplitContainer | 1 | splitContainer1 |
| UsrButton | 1 | btnStatusUpdate |
| UsrDateRangePickerWtWeek | 1 | drpPeriod |
| UsrCombo | 1 | clbDivision |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 28 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 121 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 4 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1577 | {?sProcedureName} | commented:UNRESOLVED |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0008 | REPAIR | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0008 | SALES_SITE | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0008 | SSPM | 13/29 | 10/30 | 10/30 | 10/30 | 10/30 | 10/30 | 10/30 | 7/26 | 2/3 | 2/3 | 2/3 | 2/3 | 2/3 | 2/3 |
| SCM_MST_SHEET_COLUMNS | DMF0008 | SUMMARY | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 32개 시트×division 비교, 차이 348건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: SUMMARY, REPAIR, SALES_SITE, SSPM
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:468

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 159 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 160 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 161 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 162 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 361 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 362 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 363 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 364 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 828 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 829 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 830 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 831 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| REPAIR | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | · | · | · | · | · | · |
| SALES_SITE | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | · | · | · | · | · | · |
| SSPM | META+코드연결 | 13 | 10 | 10 | 10 | 10 | 10 | 10 | 7 | 2 | 2 | 2 | 2 | 2 | 2 |
| SUMMARY | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
