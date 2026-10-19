# DM0022 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Plan.UIL\DM0022_SalesPlanWaterfall.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1977 |
| only | 06.UIL\GSCM.DM.Plan.UIL\DM0022_SalesPlanWaterfall.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1518 |
| only | 06.UIL\GSCM.DM.Shipment.UIL\DM0022_SalesPlanWaterfall.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 2043 |
| only | 06.UIL\GSCM.DM.Shipment.UIL\DM0022_SalesPlanWaterfall.Designer.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 1518 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > GetBizTypebyDivision | 1571 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > GetBizTypebyDivision | 1601 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| button:FindButton | FindButton > FindData > InitSpread > InitSpread_X | 460 | DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | SP DM0022_GET_SPREAD_TITLE_DATE |
| button:FindButton | FindButton > FindData > InitSpread > InitSpread_X | 463 | DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | SP DM0022_GET_SPREAD_TITLE_DATE |
| button:FindButton | FindButton > FindData | 700 | DM_H.DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL | MATCH | SP DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL |
| button:FindButton | FindButton > FindData | 703 | DM_H.DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL | MATCH | SP DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1455 | DM_H.DM0022_GET_SPREAD_TITLE | MATCH | SP DM0022_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1485 | DM_H.DM0022_GET_SPREAD_TITLE | MATCH | SP DM0022_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > InitSpread_X | 460 | DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | SP DM0022_GET_SPREAD_TITLE_DATE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > InitSpread_X | 463 | DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | SP DM0022_GET_SPREAD_TITLE_DATE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 1455 | DM_H.DM0022_GET_SPREAD_TITLE | MATCH | SP DM0022_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 1485 | DM_H.DM0022_GET_SPREAD_TITLE | MATCH | SP DM0022_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > InitSpread_X | 460 | DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | SP DM0022_GET_SPREAD_TITLE_DATE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > InitSpread_X | 463 | DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | SP DM0022_GET_SPREAD_TITLE_DATE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 1455 | DM_H.DM0022_GET_SPREAD_TITLE | MATCH | SP DM0022_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 1485 | DM_H.DM0022_GET_SPREAD_TITLE | MATCH | SP DM0022_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 248 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 251 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 300 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 302 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 303 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 304 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 305 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 307 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > InitSpread_X | 460 | DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | SP DM0022_GET_SPREAD_TITLE_DATE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > InitSpread_X | 463 | DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | SP DM0022_GET_SPREAD_TITLE_DATE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1455 | DM_H.DM0022_GET_SPREAD_TITLE | MATCH | SP DM0022_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1473 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1485 | DM_H.DM0022_GET_SPREAD_TITLE | MATCH | SP DM0022_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetItemType | 1486 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1503 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 1516 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 1571 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 1601 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSitebyDivision | 1340 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSitebyDivision | 1370 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetPlantSitebyEndCustomer | 1380 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetPlantSitebyEndCustomer | 1410 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 1356 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 1386 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomerAsync | 1396 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomerAsync | 1426 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetTeambyDivision | 1501 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 1515 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 1531 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 1534 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 1545 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 1549 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 1564 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 1579 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetBizTypebyDivisionAsync | 1585 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | GetBizTypebyDivisionAsync | 1615 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM_H.DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL | MATCH | 2 | SP DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL | EXEC:DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL | ⚠ DB에 SP 없음 |
| DM_H.DM0022_GET_SPREAD_TITLE | MATCH | 2 | SP DM0022_GET_SPREAD_TITLE | EXEC:DM0022_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | 2 | SP DM0022_GET_SPREAD_TITLE_DATE | EXEC:DM0022_GET_SPREAD_TITLE_DATE, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 2 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 2 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 4 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| ClbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| FindData | ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1] | MEASURE |
| GetDayRange | UserInfoContext.Current | TimeZone |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitSpread_X | nvc | p_start_yyyymmdd, p_end_yyyymmdd, p_created_by |
| InitSpread_X | dt.Rows[i] | BASIS_YYYYMM, COL_WEEK_NAME, CALENDAR_DAY, BASIS_YYYYMMDD, DAYOFWEEK, WEEK_NAME |
| InitSpread_X | dt.Rows[i - 1] | WEEK_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:285, InitControls:286, InitControls:287, FindData:664, ClbDivision_SelectedIndexChanged:1019, ClbDivision_SelectedIndexChanged:1024, ClbDivision_SelectedIndexChanged:1029, ClbDivision_SelectedIndexChanged:1040 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:395, InitSpread:398 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:396, InitSpread:399 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnVersion | Click | btnVersion_Click | InitializeComponent:254 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:292 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:368 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:405 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:441 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:511 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:548 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:741 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:781 |
| this.cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | InitializeComponent:857 |
| this.cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | InitializeComponent:894 |
| this.cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | InitializeComponent:931 |
| this.txtVersion | KeyDown | txtVersion_KeyDown | InitializeComponent:966 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1363 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1364 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:1365 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:1366 |
| this | FormClosed | DM0022_SalesPlanWaterfall_FormClosed | InitializeComponent:1417 |
| this | Load | Form_Load | .ctor:169 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:332 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:333 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:572 |
| clbSalesSite | SelectedIndexChanged | ClbSalesSite_SelectedIndexChanged | InitEvent:573 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:574 |
| cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | FindData:941 |
| cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | FindData:942 |
| cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | FindData:943 |
| cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | FindData:949 |
| cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | FindData:950 |
| cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | FindData:951 |
| this.btnVersion | Click | btnVersion_Click | InitializeComponent:254 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:292 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:368 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:405 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:441 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:511 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:548 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:741 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:781 |
| this.cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | InitializeComponent:857 |
| this.cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | InitializeComponent:894 |
| this.cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | InitializeComponent:931 |
| this.txtVersion | KeyDown | txtVersion_KeyDown | InitializeComponent:966 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1363 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1364 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:1365 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:1366 |
| this | FormClosed | DM0022_SalesPlanWaterfall_FormClosed | InitializeComponent:1417 |
| this | Load | Form_Load | .ctor:172 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:335 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:336 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:575 |
| clbSalesSite | SelectedIndexChanged | ClbSalesSite_SelectedIndexChanged | InitEvent:576 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:577 |
| cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | FindData:911 |
| cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | FindData:912 |
| cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | FindData:913 |
| cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | FindData:919 |
| cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | FindData:920 |
| cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | FindData:921 |

## 6. 컨트롤 (110개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 44 | lblDivision, lblTeam, lblCustomer, lblBizType, lblSalesSite, lblModel, layoutControlItem3, layoutControlItem1, layoutControlItem2, layoutControlItem4, Period, lblProject, lblPlantSite, lblVersion, layoutControlItem6 … |
| UsrCheckedList | 14 | clbPlantSite, clbSalesSite, clbBizType, clbCustomer, clbTeam, clbDivision, clbItemType, clbPlantSite, clbSalesSite, clbBizType, clbCustomer, clbTeam, clbDivision, clbItemType |
| UsrButton | 10 | btnVersion, btnMeasure, btnColumn, btnProject, btnItemId, btnVersion, btnMeasure, btnColumn, btnProject, btnItemId |
| UsrCombo | 8 | cboBucketType, cboLOC, cboKRW, cboUSD, cboBucketType, cboLOC, cboKRW, cboUSD |
| EmptySpaceItem | 8 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem4, emptySpaceItem3, emptySpaceItem1, emptySpaceItem2, emptySpaceItem4, emptySpaceItem3 |
| UsrMultiLineEditor | 6 | txtProject, txtItemId, txtVersion, txtProject, txtItemId, txtVersion |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCheckBox | 4 | chkMem, chkSum, chkMem, chkSum |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrDateRangePicker | 2 | drpPeriod, drpPeriod |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 59 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 25 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 19 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 13 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (6건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 701 | DM_H.DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL_TEST | commented:MATCH |
| 1449 | DM.PR_GET_DAY_RANGE | commented:MATCH |
| 1470 | DM_H.DM0022_GET_SPREAD_TITLE | commented:MATCH |
| 704 | DM_H.DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL_TEST | commented:MATCH |
| 1419 | DM.PR_GET_DAY_RANGE | commented:MATCH |
| 1440 | DM_H.DM0022_GET_SPREAD_TITLE | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DM0022 | Sales Plan Waterfall | 12/9 | 12/9 | 12/9 | 12/9 | 12/9 | 12/9 | 12/9 | 12/9 | 12/9 | 12/9 | 12/9 | 12/9 | 12/9 | 12/9 |
| SCM_MST_SHEET_MEASURE | DM0022 | Sales Plan Waterfall | 11/3 | 11/3 | 11/3 | 11/3 | 11/3 | 11/3 | 11/3 | 11/3 | 11/3 | 11/3 | 11/3 | 11/3 | 11/3 | 11/3 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 42건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sales Plan Waterfall
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:396, CreateSheetHeaderColumn@InitSpread:399
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_X |  | 482 | DB루프 | AddNumColumn | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | for(i < dt.Rows.Count) ⟫ if("0"== 0) |
| InitSpread_X |  | 496 | DB루프 | AddNumColumn | SUM | W_{?dt.Rows[i]["COL_WEEK_NAME"]} | for(i < dt.Rows.Count) ⟫ if("0"== 0) |
| InitSpread_X |  | 512 | DB루프 | AddNumColumn | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | for(i < dt.Rows.Count) ⟫ if(sFYear != dt.Rows["0"]["BASIS_YYYYMM"].ToString()) |
| InitSpread_X |  | 529 | DB루프 | AddNumColumn | SUM | W_{?dt.Rows[i]["COL_WEEK_NAME"]} | for(i < dt.Rows.Count) ⟫ if(sFWeek != dt.Rows["0"]["COL_WEEK_NAME"].ToString()) |
| InitSpread_X |  | 537 | DB루프 | AddNumColumn | {?dt.Rows[i]["CALENDAR_DAY"]} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) |
| InitSpread_X |  | 539 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) ⟫ if(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SAT") |
| InitSpread_X |  | 541 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) ⟫ else!(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SAT") ⟫ if(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SUN") |
| spdMain_CellDoubleClick |  | 1146 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 1152 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1168 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1326 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1331 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1338 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1342 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1347 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1354 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1358 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1382 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1383 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1384 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1385 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread_X |  | 485 | DB루프 | AddNumColumn | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | for(i < dt.Rows.Count) ⟫ if("0"== 0) |
| InitSpread_X |  | 499 | DB루프 | AddNumColumn | SUM | W_{?dt.Rows[i]["COL_WEEK_NAME"]} | for(i < dt.Rows.Count) ⟫ if("0"== 0) |
| InitSpread_X |  | 515 | DB루프 | AddNumColumn | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | for(i < dt.Rows.Count) ⟫ if(sFYear != dt.Rows["0"]["BASIS_YYYYMM"].ToString()) |
| InitSpread_X |  | 532 | DB루프 | AddNumColumn | SUM | W_{?dt.Rows[i]["COL_WEEK_NAME"]} | for(i < dt.Rows.Count) ⟫ if(sFWeek != dt.Rows["0"]["COL_WEEK_NAME"].ToString()) |
| InitSpread_X |  | 540 | DB루프 | AddNumColumn | {?dt.Rows[i]["CALENDAR_DAY"]} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) |
| InitSpread_X |  | 542 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) ⟫ if(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SAT") |
| InitSpread_X |  | 544 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) ⟫ else!(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SAT") ⟫ if(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SUN") |
| spdMain_CellDoubleClick |  | 1116 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 1122 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1138 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1296 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1301 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1308 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1312 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1317 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1324 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1328 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1382 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1383 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1384 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1385 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Sales Plan Waterfall | META+코드연결 | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) | 14 (?2) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:조회데이터 112 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 112건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
