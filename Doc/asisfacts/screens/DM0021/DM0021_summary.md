# DM0021 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Plan.UIL\DM0021_SalesPlan.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 3229 |
| only | 06.UIL\GSCM.DM.Plan.UIL\DM0021_SalesPlan.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1243 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0021_SalesPlanVersionCutOffPopUp.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 441 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0021_SalesPlanVersionCutOffPopUp.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 481 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 269 | DM_H.DM0021_GET_DM_MST_VERSION | MATCH | SP DM0021_GET_DM_MST_VERSION |
| button:FindButton | FindButton > FindData > InitSpread > InitSpread_X | 446 | DM_H.DM0021_GET_SPREAD_TITLE_DATE | MATCH | SP DM0021_GET_SPREAD_TITLE_DATE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 559 | DM_H.DM0021_GET_SPREAD_TITLE | MATCH | SP DM0021_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 768 | DM.DM0021_GET_DM_PLN_SALES_PLAN_DATAEx | MATCH | SP DM0021_GET_DM_PLN_SALES_PLAN_DATAEx |
| button:SaveButton | SaveButton > SaveData > FindData | 269 | DM_H.DM0021_GET_DM_MST_VERSION | MATCH | SP DM0021_GET_DM_MST_VERSION |
| button:SaveButton | SaveButton > SaveData | 327 | DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF | MATCH | SP PR_DM_PLN_SALES_PLAN_CUTOFF |
| button:SaveButton | SaveButton > SaveData | 327 | {?DM0021_SalesPlanVersionCutOffPopUp.sFoxData} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > InitSpread_X | 446 | DM_H.DM0021_GET_SPREAD_TITLE_DATE | MATCH | SP DM0021_GET_SPREAD_TITLE_DATE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 559 | DM_H.DM0021_GET_SPREAD_TITLE | MATCH | SP DM0021_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 768 | DM.DM0021_GET_DM_PLN_SALES_PLAN_DATAEx | MATCH | SP DM0021_GET_DM_PLN_SALES_PLAN_DATAEx |
| button:SaveButton | SaveButton > SaveData | 1509 | DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | MATCH | SP DM0021_SAVE_DM_PLN_SALES_PLAN_ALL |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 269 | DM_H.DM0021_GET_DM_MST_VERSION | MATCH | SP DM0021_GET_DM_MST_VERSION |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 327 | DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF | MATCH | SP PR_DM_PLN_SALES_PLAN_CUTOFF |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 327 | {?DM0021_SalesPlanVersionCutOffPopUp.sFoxData} | UNRESOLVED |  |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > InitSpread_X | 446 | DM_H.DM0021_GET_SPREAD_TITLE_DATE | MATCH | SP DM0021_GET_SPREAD_TITLE_DATE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 559 | DM_H.DM0021_GET_SPREAD_TITLE | MATCH | SP DM0021_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > InitSpread_X | 446 | DM_H.DM0021_GET_SPREAD_TITLE_DATE | MATCH | SP DM0021_GET_SPREAD_TITLE_DATE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 559 | DM_H.DM0021_GET_SPREAD_TITLE | MATCH | SP DM0021_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetBizTypebyDivision | 1853 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls | 141 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 221 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 269 | DM_H.DM0021_GET_DM_MST_VERSION | MATCH | SP DM0021_GET_DM_MST_VERSION |
| event:this.Load | Form_Load > InitControls | 272 | biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 275 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > InitSpread_X | 446 | DM_H.DM0021_GET_SPREAD_TITLE_DATE | MATCH | SP DM0021_GET_SPREAD_TITLE_DATE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 559 | DM_H.DM0021_GET_SPREAD_TITLE | MATCH | SP DM0021_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1767 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1796 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 1809 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 1853 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | SaveData_All | 1115 | DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | MATCH | SP DM0021_SAVE_DM_PLN_SALES_PLAN_ALL |
| unreached:(진입점 미연결) | GetDivision | 1737 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivision | 1751 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 1824 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 1838 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 1867 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomer | 2615 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetBizTypebyDivisionAsync | 3009 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 3029 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 3048 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomerAsync | 3070 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 3093 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?DM0021_SalesPlanVersionCutOffPopUp.sFoxData} | UNRESOLVED | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM_H.DM0021_GET_DM_MST_VERSION | MATCH | 1 | SP DM0021_GET_DM_MST_VERSION | EXEC:DM0021_GET_DM_MST_VERSION, SELECT:DM_MST_VERSION, REF:UF_FX_STRING_SPLITFORIN, SELECT:SPLIT |  |
| DM_H.DM0021_GET_SPREAD_TITLE | MATCH | 1 | SP DM0021_GET_SPREAD_TITLE | EXEC:DM0021_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| DM_H.DM0021_GET_SPREAD_TITLE_DATE | MATCH | 1 | SP DM0021_GET_SPREAD_TITLE_DATE | EXEC:DM0021_GET_SPREAD_TITLE_DATE, SELECT:SCM_SYS_CALENDAR_M |  |
| DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | MATCH | 2 | SP DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | EXEC:DM0021_SAVE_DM_PLN_SALES_PLAN_ALL, CREATE:TEMP_SALES_PLAN$, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:TEMP_SALES_PLAN$, SELECT:TEMP_SALES_PLAN$, SELECT:SCM_MST_PROJECT, DELETE:DM_PLN_SALES_PLAN, SELECT:DM_MST_EXCHANGE_RATE, INSERT:DM_PLN_SALES_PLAN, INSERT:DM_PLN_SALES_PLAN_H, INSERT:SCM_SYS_LOG_BATCH |  |
| DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF | MATCH | 1 | SP PR_DM_PLN_SALES_PLAN_CUTOFF | EXEC:PR_DM_PLN_SALES_PLAN_CUTOFF, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:PR_DM_PLN_VERSION_CREATE, INSERT:DM_PLN_SALES_PLAN_C, SELECT:DM_PLN_SALES_PLAN, REF:FN_NEXT_DAY, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:DM_PLN_SALES_ETC_PLAN_C, SELECT:DM_PLN_SALES_ETC_PLAN, INSERT:DM_PLN_SALES_PLAN_RESULT_C, SELECT:DM_PLN_SALES_PLAN_RESULT, EXEC:PR_SCM_MST_FUTURE_PRICE_CUTOFF, EXEC:PR_DM_MST_EXCHANGE_RATE_CUTOFF, INSERT:SCM_SYS_LOG_BATCH, SELECT:DM_MST_VERSION, INSERT:DM_MST_VERSION, INSERT:#TEMP_USE_MEASURE, DELETE:SCM_MST_FUTURE_PRICE_C, DELETE:DM_PLN_CFM_SELLING_PRICE_C, INSERT:#TEMP_MKT_FCST_DATA, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN_C, SELECT:#TEMP_USE_MEASURE, SELECT:DM_PLN_MKT_FCST_C, SELECT:#TEMP_MKT_FCST_DATA, INSERT:SCM_MST_FUTURE_PRICE_C, SELECT:SCM_MST_FUTURE_PRICE, INSERT:DM_PLN_CFM_SELLING_PRICE_C, SELECT:DM_PLN_CFM_SELLING_PRICE, DELETE:DM_MST_EXCHANGE_RATE_C, INSERT:DM_MST_EXCHANGE_RATE_C, SELECT:DM_MST_EXCHANGE_RATE |  |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DM0021_GET_DM_PLN_SALES_PLAN_DATAEx | MATCH | 1 | SP DM0021_GET_DM_PLN_SALES_PLAN_DATAEx | EXEC:DM0021_GET_DM_PLN_SALES_PLAN_DATAEX | ⚠ DB에 SP 없음 |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 3 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 2 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID |
| FindData | ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1] | MEASURE |
| FindData | nvc | p_division_id, p_version_description, p_version_type, p_from_yyyymmdd, p_to_yyyymmdd, p_created_by |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitSpread_X | nvc | p_start_yyyymmdd, p_end_yyyymmdd, p_created_by |
| InitSpread_X | dt.Rows[i] | BASIS_YYYYMM, COL_WEEK_NAME, CALENDAR_DAY, BASIS_YYYYMMDD, DAYOFWEEK, WEEK_NAME |
| InitSpread_X | dt.Rows[i-1] | WEEK_NAME |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SaveData | dr | ACTION, DIVISION_ID, PROJECT_CODE, ITEM_ID, CURRENCY, MEASURE |
| SaveData | nvc | p_active_flag, p_DIVISION_ID, p_PROJECT_CODE, p_SCM_SITE_ID, p_PLANT_SITE_ID, p_ITEM_ID, p_DOM_EXP, p_FCST_TYPE, p_INCOTERMS, p_MEASURE, p_YYYYMMDD, p_QTY, p_CURRENCY, p_CREATED_BY, p_LAST_UPDATED_BY |
| SaveData_All | nvc | p_active_flag, p_DIVISION_ID, p_PROJECT_CODE, p_SCM_SITE_ID, p_PLANT_SITE_ID, p_ITEM_ID, p_DOM_EXP, p_FCST_TYPE, p_INCOTERMS, p_MEASURE, p_YYYYMMDD, p_QTY, p_CREATED_BY, p_CREATION_DATE, p_LAST_UPDATED_BY |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | drs[0] | NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:381 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:382 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:681, SaveButton:238, btnButtonList_UsrButtonList_Click_Detected:423 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | FindData:733, btnProject_Click:1907, btnItemId_Click:1923, clbDivision_SelectedIndexChanged:2972, clbDivision_SelectedIndexChanged:2977, clbDivision_SelectedIndexChanged:2982, clbTeam_SelectedIndexChanged:3113, clbTeam_SelectedIndexChanged:3114 | CString.GetCheckedListValue | CODE |
| LoadData | btnCutOff_Click:2928 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | EditModeStarting | spdMain_EditModeStarting | InitializeComponent:138 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:139 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:140 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:141 |
| this.spdMain | EnterCell | spdMain_EnterCell | InitializeComponent:142 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:143 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:144 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:145 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:146 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:147 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:148 |
| this.btnCutOff | Click | btnCutOff_Click | InitializeComponent:263 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:299 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:337 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:374 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:411 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:447 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:516 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:709 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:749 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:789 |
| this.layoutControlItem3 | Click | btnProject_Click | InitializeComponent:995 |
| this.layoutControlItem7 | Click | btnCutOff_Click | InitializeComponent:1073 |
| this | Load | Form_Load | .ctor:185 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:329 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:330 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:359 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:177 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:382 |
| this | Load | Form_Load | .ctor:96 |

## 6. 컨트롤 (66개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 22 | lblDivision, lblTeam, lblCustomer, lblBizType, lblSalesSite, lblModel, lblProject, layoutControlItem3, layoutControlItem1, layoutControlItem4, lblPlantSite, layoutControlItem5, layoutControlItem2, layoutControlItem7, lblBucket … |
| UsrCheckedList | 8 | clbSalesSite, clbBizType, clbCustomer, clbTeam, clbDivision, clbPlantSite, clbItemType, clbDivisions |
| EmptySpaceItem | 7 | emptySpaceItem7, emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem1, emptySpaceItem3, emptySpaceItem2 |
| UsrButton | 5 | btnCutOff, btnItemId, btnMeasure, btnColumn, btnProject |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup3, layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 2 | usrConditionPanel2, usrConditionPanel1 |
| UsrMultiLineEditor | 2 | txtProject, txtItemId |
| UsrDateRangePicker | 2 | drpPeriod, drpPeriod |
| TextBox | 2 | txtDes, txtType |
| UsrCheckBox | 1 | chkSum |
| UsrCombo | 1 | cboBucketType |
| ImageList | 1 | imageList1 |
| UsrButtonList | 1 | btnButtonList |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 327 | SaveData | {?DM0021_SalesPlanVersionCutOffPopUp.sFoxData} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 76 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER | 2 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1738 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 1783 | DM.DM0003_GET_SPREAD_TITLE | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sales Plan, Cut-Off PopUp
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:382
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_X |  | 468 | DB루프 | AddNumColumn | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | for(i < dt.Rows.Count) ⟫ if("0"== 0) |
| InitSpread_X |  | 482 | DB루프 | AddNumColumn | SUM | W_{?dt.Rows[i]["COL_WEEK_NAME"]} | for(i < dt.Rows.Count) ⟫ if("0"== 0) |
| InitSpread_X |  | 498 | DB루프 | AddNumColumn | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | for(i < dt.Rows.Count) ⟫ if(sFYear != dt.Rows["0"]["BASIS_YYYYMM"].ToString()) |
| InitSpread_X |  | 515 | DB루프 | AddNumColumn | SUM | W_{?dt.Rows[i]["COL_WEEK_NAME"]} | for(i < dt.Rows.Count) ⟫ if(sFWeek != dt.Rows["0"]["COL_WEEK_NAME"].ToString()) |
| InitSpread_X |  | 523 | DB루프 | AddNumColumn | {?dt.Rows[i]["CALENDAR_DAY"]} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) |
| InitSpread_X |  | 525 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) ⟫ if(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SAT") |
| InitSpread_X |  | 527 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) ⟫ else!(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SAT") ⟫ if(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SUN") |
| SetSpreadColumn |  | 1970 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1975 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1982 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1986 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1991 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1998 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2002 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| spdMain_CellDoubleClick |  | 2018 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 2024 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 2040 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn2 |  | 2551 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn2 |  | 2556 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn2 |  | 2563 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn2 |  | 2567 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn2 |  | 2572 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn2 |  | 2579 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| InitializeComponent |  | 164 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 165 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 166 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 167 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
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

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Cut-Off PopUp | 코드 하드코딩 전용(메타 없음) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Sales Plan | 코드 하드코딩 전용(메타 없음) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:조회데이터 56 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 56건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
