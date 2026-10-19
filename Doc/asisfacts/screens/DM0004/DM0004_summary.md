# DM0004 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Master.UIL\DM0004_SalesSite.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 2329 |
| only | 06.UIL\GSCM.DM.Master.UIL\DM0004_SalesSite.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 685 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0004_SalesSiteTest99.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 2481 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0004_SalesSiteTest99.Designer.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 744 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 1860 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 1863 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > SetGridHeader | 1889 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 584 | DM.DM0004_GET_SALES_SITE_DATA | MATCH | SP DM0004_GET_SALES_SITE_DATA |
| button:FindButton | FindButton > FindData_Main | 612 | DM.DM0004_GET_SALES_SITE_DATA_40 | MATCH | SP DM0004_GET_SALES_SITE_DATA_40 |
| button:FindButton | FindButton > FindData_SubCustomer | 646 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:FindButton | FindButton > FindData_SubCustomer | 671 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA_40 | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA_40 |
| button:FindButton | FindButton > FindData_SubLocation | 705 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| button:FindButton | FindButton > FindData_SubLocation | 730 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| button:FindButton | FindButton > FindData_SubBucket | 761 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| button:FindButton | FindButton > FindData_SubBucket | 786 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| button:FindButton | FindButton > FindData_Main > SetGridHeader | 1889 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_SubBucket > InitSpread > GetSpdTitle | 2301 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_SubBucket > InitSpread > GetSpdTitle | 2454 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1524 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1527 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1586 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1589 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 584 | DM.DM0004_GET_SALES_SITE_DATA | MATCH | SP DM0004_GET_SALES_SITE_DATA |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 612 | DM.DM0004_GET_SALES_SITE_DATA_40 | MATCH | SP DM0004_GET_SALES_SITE_DATA_40 |
| button:SaveButton | SaveButton > SaveSubCustomerData > FindData_SubCustomer | 646 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubCustomerData > FindData_SubCustomer | 671 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA_40 | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA_40 |
| button:SaveButton | SaveButton > SaveSubLocationData > FindData_SubLocation | 705 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData > FindData_SubLocation | 730 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket | 761 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket | 786 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveData | 954 | DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData | 984 | biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 989 | biz:CommonData.CommonDataList [code=SiteByEndCustomer] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1016 | DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData | 1046 | biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1051 | biz:CommonData.CommonDataList [code=SiteByEndCustomer] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveSubCustomerData | 1138 | DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubCustomerData | 1200 | DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData | 1324 | DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubLocationData | 1386 | DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_LOCATION_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData | 1455 | DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveSubBucketData | 1517 | DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_SAVE_SALES_SITE_BUCKET_DATA |
| button:SaveButton | SaveButton > SaveData > FindData_Main > SetGridHeader | 1889 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket > InitSpread > GetSpdTitle | 2301 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveSubBucketData > FindData_SubBucket > InitSpread > GetSpdTitle | 2454 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1769 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 240 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 256 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 263 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 265 | biz:CommonData.CommonDataList [code=TeambyAll] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 276 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 281 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 283 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 286 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 288 | biz:CommonData.CommonDataList [code=TeambyAll] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 298 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 300 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged | 1860 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged | 1863 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged > SetGridHeader | 1889 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2301 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2454 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubCustomer | 646 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubCustomer | 671 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA_40 | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA_40 |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubLocation | 705 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubLocation | 730 | DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | SP DM0004_GET_SALES_SITE_LOCATION_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket | 761 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket | 786 | DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | SP DM0004_GET_SALES_SITE_BUCKET_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket > InitSpread > GetSpdTitle | 2301 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_SubBucket > InitSpread > GetSpdTitle | 2454 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1811 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1819 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1966 | biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1974 | biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 1853 | biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | spdSub_ComboSelChange | 2005 | biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncoterms> | 48 | biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 49 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncoterms> | 51 | biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 52 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetPlantbyDivision | 2313 | SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | SP SCM0001_GET_PLANT_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantbyDivision | 2466 | SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | SP SCM0001_GET_PLANT_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=EndCustomer] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList_SCP:SELECT:SCP_MST_BOD_V, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=SiteByEndCustomer] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:REF:STRING_SPLIT, UP_FX_GETCOMMONDATALIST_DM:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SoldCustomer] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| biz:CommonData.CommonDataList [code=TeambyAll] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| DM.DM0004_GET_SALES_SITE_BUCKET_DATA | MATCH | 2 | SP DM0004_GET_SALES_SITE_BUCKET_DATA | EXEC:DM0004_GET_SALES_SITE_BUCKET_DATA | ⚠ DB에 SP 없음 |
| DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | 1 | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA | EXEC:DM0004_GET_SALES_SITE_CUSTOMER_DATA, REF:FN_GET_DEPT_LIST, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE, SELECT:TB_FX_USER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA_40 | MATCH | 1 | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA_40 | EXEC:DM0004_GET_SALES_SITE_CUSTOMER_DATA_40 | ⚠ DB에 SP 없음 |
| DM.DM0004_GET_SALES_SITE_DATA | MATCH | 1 | SP DM0004_GET_SALES_SITE_DATA | EXEC:DM0004_GET_SALES_SITE_DATA, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |
| DM.DM0004_GET_SALES_SITE_DATA_40 | MATCH | 1 | SP DM0004_GET_SALES_SITE_DATA_40 | EXEC:DM0004_GET_SALES_SITE_DATA_40 | ⚠ DB에 SP 없음 |
| DM.DM0004_GET_SALES_SITE_LOCATION_DATA | MATCH | 2 | SP DM0004_GET_SALES_SITE_LOCATION_DATA | EXEC:DM0004_GET_SALES_SITE_LOCATION_DATA | ⚠ DB에 SP 없음 |
| DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | MATCH | 2 | SP DM0004_SAVE_SALES_SITE_BUCKET_DATA | EXEC:DM0004_SAVE_SALES_SITE_BUCKET_DATA | ⚠ DB에 SP 없음 |
| DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | MATCH | 2 | SP DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | EXEC:DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | ⚠ DB에 SP 없음 |
| DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY | 2 |  |  | DB에도 없음 (폐기/오타 가능) |
| DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | MATCH | 2 | SP DM0004_SAVE_SALES_SITE_LOCATION_DATA | EXEC:DM0004_SAVE_SALES_SITE_LOCATION_DATA | ⚠ DB에 SP 없음 |
| SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_PLANT_BY_DIVISION | EXEC:SCM0001_GET_PLANT_BY_DIVISION, SELECT:SCM_MST_PLANT_SN, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| cboDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbEndCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbSoldToCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| FindData_Main | UserInfoContext.Current | NowGroupID |
| FindData_SubBucket | UserInfoContext.Current | NowGroupID |
| FindData_SubCustomer | UserInfoContext.Current | NowGroupID |
| FindData_SubLocation | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| SaveData | UserInfoContext.Current | NowGroupID |
| SetGridHeader | dt.Rows[i] | ATTRIBUTE1 |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:243, InitControls:248, InitControls:254, FindData_Main:563, SaveData:980, SaveData:982, clbDivision_SelectedIndexChanged:1754, clbDivision_SelectedIndexChanged:1759 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:327, InitSpread:344 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:328, InitSpread:345 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:529, SaveButton:556 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:114 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:115 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:116 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:117 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:118 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:230 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:270 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:340 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:419 |
| this.spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitializeComponent:526 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:527 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:528 |
| this.spdSub | EditChange | spdSub_EditChange | InitializeComponent:529 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:530 |
| this | Load | DM0004_SalesSite_Load | InitializeComponent:626 |
| this | Load | Form_Load | .ctor:219 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:337 |
| dsdm2 | Changed | shtSubCustomerDataModel_Changed | InitEvent:340 |
| dsdm3 | Changed | shtSubBucketDataModel_Changed | InitEvent:343 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:118 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:119 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:120 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:121 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:122 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:235 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:275 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:346 |
| this.clbSoldToCustomer | SelectedIndexChanged | clbSoldToCustomer_SelectedIndexChanged | InitializeComponent:386 |
| this.spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitializeComponent:582 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:583 |
| this.spdSub | ComboSelChange | spdSub_ComboSelChange | InitializeComponent:584 |
| this.spdSub | EditChange | spdSub_EditChange | InitializeComponent:585 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:586 |
| this | Load | DM0004_SalesSiteTest99_Load | InitializeComponent:682 |
| this | Load | Form_Load | .ctor:219 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:352 |
| dsdm2 | Changed | shtSubCustomerDataModel_Changed | InitEvent:355 |
| dsdm3 | Changed | shtSubBucketDataModel_Changed | InitEvent:358 |
| cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:361 |

## 6. 컨트롤 (54개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 13 | lblDivision, layoutControlItem1, lblActive, lblSalesSite, lblEndCustomer, lblTeam, layoutControlItem1, lblActive, lblSoldToCustomer, lblEndCustomer, lblTeam, lblSalesSite, lblDivion |
| UsrCheckedList | 8 | clbTeam, clbEndCustomer, clbSalesSite, clbDivision, clbTeam, clbEndCustomer, clbSoldToCustomer, clbSalesSite |
| FpSpread | 4 | spdMain, spdSub, spdMain, spdSub |
| SheetView | 4 | spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1, spdSub_Sheet1 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel2, usrConditionPanel1, usrConditionPanel2 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 4 | emptySpaceItem3, emptySpaceItem2, emptySpaceItem3, emptySpaceItem2 |
| UsrCombo | 3 | cboActive, cboActive, cboDivision |
| SplitContainer | 2 | splitContainer1, splitContainer1 |
| UsrCheckBox | 2 | chkDetail, chkDetail |
| ImageList | 2 | imageList1, imageList1 |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 954 | SaveData | DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1016 | SaveData | DM.DM0004_SAVE_SALES_SITE_DATA | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 20 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 3 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 55 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DM0004 | Sales Bucket | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 | 0/12 |
| SCM_MST_SHEET_COLUMNS | DM0004 | Sales Customer | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 | 2/10 |
| SCM_MST_SHEET_COLUMNS | DM0004 | Sales Location | 0/10 | 0/10 | 0/10 | 0/10 | 0/10 | 0/10 | 0/10 | 0/10 | 0/10 | 0/10 | 0/10 | 0/10 | 0/10 | 0/10 |
| SCM_MST_SHEET_COLUMNS | DM0004 | Sales Site | 2/15 | 2/15 | 2/15 | 2/15 | 2/15 | 2/15 | 2/15 | 2/15 | 2/15 | 2/15 | 2/15 | 2/15 | 2/15 | 2/15 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sales Site, Sales Customer, Sales Location, Sales Bucket
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:328, CreateSheetHeaderColumn@InitSpread:345

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 135 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 136 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 137 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 138 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 546 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 547 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 548 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 549 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetGridHeader |  | 1900 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(cboDivision.ControlValues == "40") ⟫ for(i < dt.Rows.Count - 1) ⟫ if(sDivGbn == "81,82") |
| SetGridHeader |  | 1901 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(cboDivision.ControlValues == "40") ⟫ for(i < dt.Rows.Count - 1) ⟫ if(sDivGbn == "81,82") |
| SetGridHeader |  | 1902 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(cboDivision.ControlValues == "40") ⟫ for(i < dt.Rows.Count - 1) ⟫ if(sDivGbn == "81,82") |
| SetGridHeader |  | 1911 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | else!(cboDivision.ControlValues == "40") |
| SetGridHeader |  | 1912 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | else!(cboDivision.ControlValues == "40") |
| SetGridHeader |  | 1913 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | else!(cboDivision.ControlValues == "40") |
| InitializeComponent |  | 139 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 140 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 141 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 142 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 602 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 603 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 604 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 605 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Sales Bucket | META+코드연결 | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| Sales Customer | META+코드연결 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| Sales Location | META+코드연결 | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| Sales Site | META+코드연결 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
