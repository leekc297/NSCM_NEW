# DMF0000 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0000_EOL_BasicMngPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 835 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0000_EOL_BasicMngPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 584 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0000_ExchangeRatePopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 650 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0000_ExchangeRatePopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 541 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0000_VersionByWaterfallPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 369 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0000_VersionByWaterfallPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 561 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > InitSpread | 169 | DM.DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 220 | DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| button:FindButton | FindButton > FindData | 319 | DM.DMF0000_GET_DM_MST_EOL_DATA | MATCH | SP DMF0000_GET_DM_MST_EOL_DATA |
| button:FindButton | FindButton > FindData | 320 | DM.DMF0000_GET_EXCHANGE_POPUP_DATA | MATCH | SP DMF0000_GET_EXCHANGE_POPUP_DATA |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 557 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:InsertButton | InsertButton > InsertRow | 514 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread | 169 | DM.DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 319 | DM.DMF0000_GET_DM_MST_EOL_DATA | MATCH | SP DMF0000_GET_DM_MST_EOL_DATA |
| button:SaveButton | SaveButton > SaveData > FindData | 320 | DM.DMF0000_GET_EXCHANGE_POPUP_DATA | MATCH | SP DMF0000_GET_EXCHANGE_POPUP_DATA |
| button:SaveButton | SaveButton > SaveData | 434 | DM.DMF0000_SAVE_DM_MST_EOL_MODEL | MATCH | SP DMF0000_SAVE_DM_MST_EOL_MODEL |
| button:SaveButton | SaveButton > SaveData | 440 | DM.DMF0000_SAVE_EXCHANGE_POPUP_DATA | MATCH | SP DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 557 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnBPS.Click | btnBPS_Click > FindData > InitSpread | 169 | DM.DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| event:this.btnBPS.Click | btnBPS_Click > FindData | 320 | DM.DMF0000_GET_EXCHANGE_POPUP_DATA | MATCH | SP DMF0000_GET_EXCHANGE_POPUP_DATA |
| event:this.btnBPS.Click | btnBPS_Click | 606 | DM.PR_SCM_MST_EXCHANGE_RATE | MATCH | SP PR_SCM_MST_EXCHANGE_RATE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData > InitSpread | 169 | DM.DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 220 | DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 319 | DM.DMF0000_GET_DM_MST_EOL_DATA | MATCH | SP DMF0000_GET_DM_MST_EOL_DATA |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 320 | DM.DMF0000_GET_EXCHANGE_POPUP_DATA | MATCH | SP DMF0000_GET_EXCHANGE_POPUP_DATA |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 434 | DM.DMF0000_SAVE_DM_MST_EOL_MODEL | MATCH | SP DMF0000_SAVE_DM_MST_EOL_MODEL |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 440 | DM.DMF0000_SAVE_EXCHANGE_POPUP_DATA | MATCH | SP DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData > InitSpread > GetSpdTitle | 557 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 105 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 108 | biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 109 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 115 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 144 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 154 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > InitSpread | 169 | DM.DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData | 220 | DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| event:this.Load | Form_Load > FindData | 319 | DM.DMF0000_GET_DM_MST_EOL_DATA | MATCH | SP DMF0000_GET_DM_MST_EOL_DATA |
| event:this.Load | Form_Load > FindData | 320 | DM.DMF0000_GET_EXCHANGE_POPUP_DATA | MATCH | SP DMF0000_GET_EXCHANGE_POPUP_DATA |
| event:this.Load | Form_Load > FindData > InitSpread > GetSpdTitle | 557 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetLookupValues | 577 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 612 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.txtDes.KeyDown | txtItemID_KeyDown > FindButton > FindData | 220 | DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| unreached:(진입점 미연결) | GetSpdTitle | 303 | DM.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| DM.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DM0000_GET_COMMON_SPREAD_TITLE | EXEC:DM0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0000_GET_DM_MST_EOL_DATA | MATCH | 1 | SP DMF0000_GET_DM_MST_EOL_DATA | EXEC:DMF0000_GET_DM_MST_EOL_DATA | ⚠ DB에 SP 없음 |
| DM.DMF0000_GET_EXCHANGE_POPUP_DATA | MATCH | 1 | SP DMF0000_GET_EXCHANGE_POPUP_DATA | EXEC:DMF0000_GET_EXCHANGE_POPUP_DATA, SELECT:DM_MST_EXCHANGE_RATE, REF:UF_FX_STRING_SPLITFORIN, DYNAMIC@DMF0000_GET_EXCHANGE_POPUP_DATA, SELECT:SPLIT |  |
| DM.DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE | EXEC:DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0000_SAVE_DM_MST_EOL_MODEL | MATCH | 1 | SP DMF0000_SAVE_DM_MST_EOL_MODEL | EXEC:DMF0000_SAVE_DM_MST_EOL_MODEL | ⚠ DB에 SP 없음 |
| DM.DMF0000_SAVE_EXCHANGE_POPUP_DATA | MATCH | 1 | SP DMF0000_SAVE_EXCHANGE_POPUP_DATA | EXEC:DMF0000_SAVE_EXCHANGE_POPUP_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_MST_DIVISION, SELECT:DM_MST_EXCHANGE_RATE, DELETE:DM_MST_EXCHANGE_RATE, MERGE:DM_MST_EXCHANGE_RATE, INSERT:DM_MST_EXCHANGE_RATE_H, EXEC:DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION, EXEC:PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW, INSERT:SCM_SYS_LOG_BATCH, INSERT:#FUTURE_PRICE_TEMP1, SELECT:SCM_MST_FUTURE_PRICE, REF:FN_NEXT_DAY, INSERT:#FUTURE_PRICE_TEMP2, SELECT:#FUTURE_PRICE_TEMP1, MERGE:SCM_MST_FUTURE_PRICE, SELECT:#FUTURE_PRICE_TEMP2, INSERT:#CFM_SELLING_PRICE_TEMP1, SELECT:DM_PLN_CFM_SELLING_PRICE, INSERT:#CFM_SELLING_PRICE_TEMP2, SELECT:#CFM_SELLING_PRICE_TEMP1, MERGE:DM_PLN_CFM_SELLING_PRICE, SELECT:#CFM_SELLING_PRICE_TEMP2, SELECT:DM_MST_VERSION, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, CREATE:#T2_PRICE, CREATE:#T2_MKT_FCST, CREATE:#SALES_PLAN_TEMP_LOC, CREATE:#T_RTF_EXCEPTION_ITEM, INSERT:#T_RTF_EXCEPTION_ITEM, SELECT:DM_PLN_SALES_PLAN, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN, SELECT:#T_RTF_EXCEPTION_ITEM, DELETE:DM_PLN_SALES_PLAN, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SITE_ITEM, INSERT:#T_PRICE, INSERT:#T2_PRICE, INSERT:#T2_MKT_FCST, SELECT:DM_PLN_MKT_FCST, INSERT:#SALES_PLAN_TEMP_LOC, SELECT:#T2_MKT_FCST, SELECT:#T2_PRICE, SELECT:SCM_SYS_CALENDAR_M, SELECT:#SALES_PLAN_TEMP_LOC, INSERT:DM_PLN_SALES_PLAN, DELETE:DM_PLN_SALES_ETC_PLAN, INSERT:DM_PLN_SALES_ETC_PLAN, SELECT:DM_PLN_SALES_ETC_PLAN, SELECT:#T_PRICE, MERGE:DM_PLN_CFM_MKT_DEMAND_PLAN, DELETE:DM_PLN_SALES_PLAN_RESULT, INSERT:DM_PLN_SALES_PLAN_RESULT, SELECT:DM_PLN_SALES_PLAN_RESULT |  |
| DM.PR_SCM_MST_EXCHANGE_RATE | MATCH | 1 | SP PR_SCM_MST_EXCHANGE_RATE | EXEC:PR_SCM_MST_EXCHANGE_RATE, EXEC:PR_SCM_SYS_LOG_BATCH, CREATE:#I_DIVISION, INSERT:#I_DIVISION, SELECT:SCM_MST_DIVISION, SELECT:XIF_GSC_MOVE_EXCHANGE_RATE_SN, SELECT:#I_DIVISION, MERGE:DM_MST_EXCHANGE_RATE, UPDATE:XIF_GSC_MOVE_EXCHANGE_RATE_SN, EXEC:DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION, EXEC:PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW, INSERT:SCM_SYS_LOG_BATCH, INSERT:#FUTURE_PRICE_TEMP1, SELECT:SCM_MST_FUTURE_PRICE, REF:FN_NEXT_DAY, INSERT:#FUTURE_PRICE_TEMP2, SELECT:#FUTURE_PRICE_TEMP1, SELECT:DM_MST_EXCHANGE_RATE, MERGE:SCM_MST_FUTURE_PRICE, SELECT:#FUTURE_PRICE_TEMP2, INSERT:#CFM_SELLING_PRICE_TEMP1, SELECT:DM_PLN_CFM_SELLING_PRICE, INSERT:#CFM_SELLING_PRICE_TEMP2, SELECT:#CFM_SELLING_PRICE_TEMP1, MERGE:DM_PLN_CFM_SELLING_PRICE, SELECT:#CFM_SELLING_PRICE_TEMP2, SELECT:DM_MST_VERSION, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, CREATE:#T2_PRICE, CREATE:#T2_MKT_FCST, CREATE:#SALES_PLAN_TEMP_LOC, CREATE:#T_RTF_EXCEPTION_ITEM, INSERT:#T_RTF_EXCEPTION_ITEM, SELECT:DM_PLN_SALES_PLAN, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN, SELECT:#T_RTF_EXCEPTION_ITEM, DELETE:DM_PLN_SALES_PLAN, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SITE_ITEM, INSERT:#T_PRICE, INSERT:#T2_PRICE, INSERT:#T2_MKT_FCST, SELECT:DM_PLN_MKT_FCST, INSERT:#SALES_PLAN_TEMP_LOC, SELECT:#T2_MKT_FCST, SELECT:#T2_PRICE, SELECT:SCM_SYS_CALENDAR_M, SELECT:#SALES_PLAN_TEMP_LOC, INSERT:DM_PLN_SALES_PLAN, DELETE:DM_PLN_SALES_ETC_PLAN, INSERT:DM_PLN_SALES_ETC_PLAN, SELECT:DM_PLN_SALES_ETC_PLAN, SELECT:#T_PRICE, MERGE:DM_PLN_CFM_MKT_DEMAND_PLAN, DELETE:DM_PLN_SALES_PLAN_RESULT, INSERT:DM_PLN_SALES_PLAN_RESULT, SELECT:DM_PLN_SALES_PLAN_RESULT |  |
| DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | 1 | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP | EXEC:SCM0002_GET_VERSIONBYWATERFALLPOPUP, SELECT:DM_MST_VERSION, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, REF:UF_FX_STRING_SPLIT, SELECT:SCP_PLN_INTERFACE_YN |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| DefineProperty | UserInfoContext.Current | NowGroupID |
| EditButton | UserInfoContext.Current | NowGroupID |
| FindData | nvc | p_division_id, p_from_yyyymmdd, p_to_yyyymmdd |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitSpread | dt.Rows[i] | CALENDAR_YYYY, CALENDAR_MONTH, BASIS_START_DATE |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SaveButton | UserInfoContext.Current | NowGroupID |
| SaveData | nvc | p_active_flag, p_division_id, p_YYYYMMDD, p_CURRENCY, p_UNIT_CURRENCY, p_EXCHANGE_PRICE, p_CREATED_BY, p_LAST_UPDATED_BY |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:211 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:212 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:293, btnButtonList_UsrButtonList_Click_Detected:593, SaveButton:297, btnButtonList_UsrButtonList_Click_Detected:567 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | FindData:313, FindData:202 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:179 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:472 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:473 |
| this | Load | Form_Load | .ctor:112 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:265 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:393 |
| this.btnBPS | Click | btnBPS_Click | InitializeComponent:480 |
| this | Load | Form_Load | .ctor:75 |
| this.txtDes | KeyDown | txtItemID_KeyDown | InitializeComponent:136 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:206 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:261 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:453 |
| this | Load | Form_Load | .ctor:90 |

## 6. 컨트롤 (69개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 19 | layoutControlItem4, Team, lblEndCustomer, lblSalesSite, layoutControlItem1, lblDivion, layoutControlItem2, layoutControlItem2, layoutControlItem1, layoutControlItem3, lblDivion, layoutControlItem4, layoutControlItem1, lblDivision, Period … |
| EmptySpaceItem | 9 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem1, emptySpaceItem2, emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem5 |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList | 4 | clbTeam, clbEndCustomer, clbSalesSite, clbDivision |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrButtonList | 3 | btnButtonList, btnButtonList, btnButtonList |
| TextBox | 3 | txtProject, txtItem, txtDes |
| FpSpread | 3 | spdMain, spdMain, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| CheckBox | 3 | chkMonth, chkWeek, chkDay |
| UsrCombo | 2 | cboDivision, clbDivision |
| UsrMonthPicker | 2 | usrMonthTo, usrMonthFrom |
| ImageList | 1 | imageList1 |
| UsrButton | 1 | btnBPS |
| UsrDateRangePickerWtWeek | 1 | drpPeriod |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 75 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 168 | DM.DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: EOL BasicInfo Popup, Exchange Rate POPUP, VersionPopup
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:212

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 489 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 490 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 491 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 492 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 158 | 하드코딩 | AddComboColumn | Division | DIVISION_ID |  |
| InitSpread |  | 159 | 하드코딩 | AddTextColumn | Currency | CURRENCY |  |
| InitSpread |  | 160 | 하드코딩 | AddComboColumn | Unit | UNIT_CURRENCY |  |
| InitSpread |  | 161 | 하드코딩 | AddTextColumn | Last Update Date | LAST_UPDATE_DATE |  |
| InitSpread |  | 162 | 하드코딩 | AddTextColumn | Last Updated By | LAST_UPDATED_BY |  |
| InitSpread |  | 186 | DB루프 | AddNumColumn | {?dt.Rows[i]["CALENDAR_MONTH"]} | D{?dt.Rows[i]["BASIS_START_DATE"]} | for(i < dt.Rows.Count) |
| InitializeComponent |  | 409 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 410 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 411 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 412 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread_X |  | 152 | 하드코딩 | AddTextColumn | Divison | DIVISION_ID |  |
| InitSpread_X |  | 153 | 하드코딩 | AddTextColumn | Version | VERSION_NO |  |
| InitSpread_X |  | 154 | 하드코딩 | AddTextColumn | Description | VERSION_DESCRIPTION |  |
| InitSpread_X |  | 155 | 하드코딩 | AddTextColumn | Type | VERSION_TYPE |  |
| InitSpread_X |  | 156 | 하드코딩 | AddTextColumn | Seq | VER_CRE_SEQ |  |
| InitSpread_X |  | 157 | 하드코딩 | AddTextColumn | Date | YYYYMMDD |  |
| InitSpread_X |  | 158 | 하드코딩 | AddTextColumn | Create By | CREATED_BY |  |
| InitSpread_X |  | 159 | 하드코딩 | AddTextColumn | Create Date | CREATION_DATE |  |
| InitializeComponent |  | 469 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 470 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 471 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 472 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Exchange Rate POPUP | 코드 하드코딩 전용(메타 없음) | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| VersionPopup | 코드 하드코딩 전용(메타 없음) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
