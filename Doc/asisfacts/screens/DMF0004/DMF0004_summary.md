# DMF0004 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0004_SalesSite\DMF0004_SalesSite.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0004_SalesSite\DMF0004_SalesSite.csproj | 2770 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0004_SalesSite\DMF0004_SalesSite.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0004_SalesSite\DMF0004_SalesSite.csproj | 752 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0004_SalesSite\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0004_SalesSite\DMF0004_SalesSite.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0004_SalesSite\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0004_SalesSite\DMF0004_SalesSite.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0004_SalesSite\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0004_SalesSite\DMF0004_SalesSite.csproj | 27 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0004_SalesSite.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 2716 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0004_SalesSite.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 744 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 2188 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2719 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > GetSoldToCustomerData | 2754 | DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA | MATCH | SP DMF0004_GET_SOLDTO_CUSTOMER_DATA |
| button:FindButton | FindButton > FindData_Main | 805 | DM.DMF0004_GET_SALES_SITE_DATA | MATCH | SP DMF0004_GET_SALES_SITE_DATA |
| button:FindButton | FindButton > FindData_SubCustomer | 863 | DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DMF0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:FindButton | FindButton > FindData_SubLocation | 917 | DM.DMF0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DMF0004_GET_SALES_SITE_LOCATION_DATA |
| button:FindButton | FindButton > FindData_SubBucket | 967 | DM.DMF0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DMF0004_GET_SALES_SITE_BUCKET_DATA |
| button:FindButton | FindButton > FindData_SubBucket > InitSpread > GetSpdTitle | 2719 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:InsertButton | InsertButton > InsertRow | 1891 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1895 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1901 | biz:CommonData.CommonDataList [code=COMPANY_ID_INTERNAL_TXN] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 805 | DM.DMF0004_GET_SALES_SITE_DATA | MATCH | SP DMF0004_GET_SALES_SITE_DATA |
| button:SaveButton | SaveButton > SaveSubCustomerData > FindData_SubCustomer | 863 | DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DMF0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData > FindData_SubLocation | 917 | DM.DMF0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DMF0004_GET_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket | 967 | DM.DMF0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DMF0004_GET_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveData | 1312 | DM.DMF0004_SAVE_SALES_SITE_DATA | MATCH | SP DMF0004_SAVE_SALES_SITE_DATA |
| button:SaveButton | SaveButton > SaveSubCustomerData | 1481 | DM.DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA | MATCH | SP DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData | 1678 | DM.DMF0004_SAVE_SALES_SITE_LOCATION_DATA | MATCH | SP DMF0004_SAVE_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData | 1809 | DM.DMF0004_SAVE_SALES_SITE_BUCKET_DATA | MATCH | SP DMF0004_SAVE_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket > InitSpread > GetSpdTitle | 2719 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged > GetSoldToCustomerData | 2754 | DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA | MATCH | SP DMF0004_GET_SOLDTO_CUSTOMER_DATA |
| event:this.Load | Form_Load > InitControls | 368 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 380 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 382 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2719 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetSoldToCustomerData | 2754 | DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA | MATCH | SP DMF0004_GET_SOLDTO_CUSTOMER_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubCustomer | 863 | DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DMF0004_GET_SALES_SITE_CUSTOMER_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubLocation | 917 | DM.DMF0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DMF0004_GET_SALES_SITE_LOCATION_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket | 967 | DM.DMF0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DMF0004_GET_SALES_SITE_BUCKET_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket > InitSpread > GetSpdTitle | 2719 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2282 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2286 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 2297 | biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncoterms> | 66 | biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 67 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetGridHeader | 2198 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetPlantbyDivision | 2740 | SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | SP SCM0001_GET_PLANT_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=COMPANY_ID_INTERNAL_TXN] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_COMPANY_SN |
| biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList_SCP:SELECT:SCP_MST_BOD_V, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0004_GET_SALES_SITE_BUCKET_DATA | MATCH | 1 | SP DMF0004_GET_SALES_SITE_BUCKET_DATA | EXEC:DMF0004_GET_SALES_SITE_BUCKET_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_DEPT_LIST, REF:FN_GET_DEPT_LIST2, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_SITE, SELECT:TB_FX_USER, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO |  |
| DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | 1 | SP DMF0004_GET_SALES_SITE_CUSTOMER_DATA | EXEC:DMF0004_GET_SALES_SITE_CUSTOMER_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_DEPT_LIST, REF:FN_GET_DEPT_LIST2, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE, SELECT:TB_FX_USER, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO |  |
| DM.DMF0004_GET_SALES_SITE_DATA | MATCH | 1 | SP DMF0004_GET_SALES_SITE_DATA | EXEC:DMF0004_GET_SALES_SITE_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |
| DM.DMF0004_GET_SALES_SITE_LOCATION_DATA | MATCH | 1 | SP DMF0004_GET_SALES_SITE_LOCATION_DATA | EXEC:DMF0004_GET_SALES_SITE_LOCATION_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SLOC, REF:FN_GET_DEPT_LIST, REF:FN_GET_DEPT_LIST2, SELECT:SCM_MST_LOCATION, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:TB_FX_USER, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO |  |
| DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA | MATCH | 1 | SP DMF0004_GET_SOLDTO_CUSTOMER_DATA | EXEC:DMF0004_GET_SOLDTO_CUSTOMER_DATA, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:UF_FX_STRING_SPLITFORIN, SELECT:SPLIT |  |
| DM.DMF0004_SAVE_SALES_SITE_BUCKET_DATA | MATCH | 1 | SP DMF0004_SAVE_SALES_SITE_BUCKET_DATA | EXEC:DMF0004_SAVE_SALES_SITE_BUCKET_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_DM_MST_BUCKET_CONVERSION_HIST, MERGE:DM_MST_BUCKET_CONVERSION, INSERT:SCM_SYS_LOG_BATCH, INSERT:DM_MST_BUCKET_CONVERSION_H |  |
| DM.DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA | MATCH | 1 | SP DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA | EXEC:DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_DM_MST_SITE_CUSTOMER_HIST, SELECT:SCM_MST_CUSTOMER, SELECT:NERP_CONV_MASTER, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_SITE, UPDATE:SCM_MST_SITE_CUSTOMER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:SCM_MST_SITE_CUSTOMER, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_SITE_CUSTOMER_H |  |
| DM.DMF0004_SAVE_SALES_SITE_DATA | MATCH | 1 | SP DMF0004_SAVE_SALES_SITE_DATA | EXEC:DMF0004_SAVE_SALES_SITE_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:DM_PLN_SALES_PLAN, SELECT:DM_PLN_SALES_PLAN_RESULT, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE, UPDATE:SCM_MST_SITE_CUSTOMER, EXEC:PR_DM_MST_SITE_CUSTOMER_HIST, EXEC:PR_DM_MST_SITE_HIST, MERGE:SCM_MST_SITE, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_SITE_CUSTOMER_H, SELECT:SCM_MST_SITE_CUSTOMER, INSERT:SCM_MST_SITE_H |  |
| DM.DMF0004_SAVE_SALES_SITE_LOCATION_DATA | MATCH | 1 | SP DMF0004_SAVE_SALES_SITE_LOCATION_DATA | EXEC:DMF0004_SAVE_SALES_SITE_LOCATION_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_MST_SLOC, SELECT:SCM_MST_LOCATION, SELECT:SCM_MST_SITE, EXEC:PR_DM_MST_SITE_SLOC_MAPPING_HIST, MERGE:SCM_MST_LOCATION, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_LOCATION_H |  |
| SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_PLANT_BY_DIVISION | EXEC:SCM0001_GET_PLANT_BY_DIVISION, SELECT:SCM_MST_PLANT_SN, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbSoldToCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| EditButton | UserInfoContext.Current | NowGroupID |
| FindData_Main | UserInfoContext.Current | NowGroupID, Dept_ID |
| FindData_SubBucket | UserInfoContext.Current | NowGroupID |
| FindData_SubCustomer | UserInfoContext.Current | NowGroupID |
| FindData_SubLocation | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| SetGridHeader | dt.Rows[i] | ATTRIBUTE1 |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:283, SetChangeControl:290, SetChangeControl:298, SetChangeControl:307, SetChangeControl:312 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:329, InitControls:335, InitControls:342, FindData_Main:785, cboDivision_SelectedIndexChanged:2142, cboDivision_SelectedIndexChanged:2151, cboDivision_SelectedIndexChanged:2158, clbTeam_SelectedIndexChanged:2231 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:426 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:427 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:711 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| FP_Log2 | cboDivision_SelectedIndexChanged:2141, cboDivision_SelectedIndexChanged:2183 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:122 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:123 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:124 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:125 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:126 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:239 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:279 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:350 |
| this.clbSoldToCustomer | SelectedIndexChanged | clbSoldToCustomer_SelectedIndexChanged | InitializeComponent:390 |
| this.spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitializeComponent:586 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:587 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:588 |
| this.spdSub | EditChange | spdSub_EditChange | InitializeComponent:589 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:590 |
| this | Load | DM0004_SalesSiteTest99_Load | InitializeComponent:686 |
| this | Load | Form_Load | .ctor:250 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:434 |
| dsdm2 | Changed | shtSubCustomerDataModel_Changed | InitEvent:437 |
| dsdm3 | Changed | shtSubBucketDataModel_Changed | InitEvent:440 |
| cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:443 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutControlItem1, lblActive, lblSoldToCustomer, lblEndCustomer, lblTeam, lblSalesSite, lblDivion |
| UsrCheckedList | 4 | clbTeam, clbEndCustomer, clbSoldToCustomer, clbSalesSite |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel2 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| UsrCombo | 2 | cboActive, cboDivision |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 2 | emptySpaceItem3, emptySpaceItem2 |
| SplitContainer | 1 | splitContainer1 |
| UsrCheckBox | 1 | chkDetail |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 90 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 2 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 13 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 66 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 88 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 14 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 1030 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0004 | CountryPopup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0004 | Sales Bucket | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0004 | Sales Customer | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0004 | Sales Location | 0/9 | 0/9 | 0/9 | 0/9 | 0/9 | 0/9 | 0/9 | 0/9 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0004 | Sales Site | 2/14 | 3/16 | 3/16 | 3/16 | 3/16 | 3/16 | 3/16 | 3/16 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 70개 시트×division 비교, 차이 824건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sales Site, Sales Customer, Sales Location, Sales Bucket
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:427

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetGridHeader |  | 2209 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(cboDivision.ControlValues == "40") ⟫ for(i < dt.Rows.Count - 1) ⟫ if(sDivGbn == "81,82") |
| SetGridHeader |  | 2210 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(cboDivision.ControlValues == "40") ⟫ for(i < dt.Rows.Count - 1) ⟫ if(sDivGbn == "81,82") |
| SetGridHeader |  | 2211 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(cboDivision.ControlValues == "40") ⟫ for(i < dt.Rows.Count - 1) ⟫ if(sDivGbn == "81,82") |
| SetGridHeader |  | 2220 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | else!(cboDivision.ControlValues == "40") |
| SetGridHeader |  | 2221 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | else!(cboDivision.ControlValues == "40") |
| SetGridHeader |  | 2222 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | else!(cboDivision.ControlValues == "40") |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 145 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 146 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 606 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 607 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 608 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 609 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| CountryPopup | 메타 정의만, 코드 미참조(미사용 가능) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | · | · | · | · | · | · |
| Sales Bucket | META+코드연결 | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| Sales Customer | META+코드연결 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | · | · | · | · | · | · |
| Sales Location | META+코드연결 | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| Sales Site | META+코드연결 | 2 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
