# DM0002 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_ItembyDivisionPopupEx.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 660 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_ItembyDivisionPopupEx.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 608 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_ItembySmallDivPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 602 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_ItembySmallDivPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 432 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_MatsterChgPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1009 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_MatsterChgPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 563 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_OwnerInfoPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 302 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_OwnerInfoPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 290 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_TitleSetForm_Popup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 666 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_TitleSetForm_Popup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 303 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| ctor:.ctor | .ctor > GetTitleSet | 244 | DM.DMF0002_GET_TITLESET_POPUP | MATCH | SP DMF0002_GET_TITLESET_POPUP |
| button:FindButton | FindButton > FindData > InitSpread | 146 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 174 | DM.DMF0005_GET_OWNERINFO | MATCH | SP DMF0005_GET_OWNERINFO |
| button:FindButton | FindButton > FindData | 364 | DM.DMF0000_GET_MASTER_CHG_POPUP | MATCH | SP DMF0000_GET_MASTER_CHG_POPUP |
| button:FindButton | FindButton > FindData | 371 | DM.DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx | MATCH | SP DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx |
| button:FindButton | FindButton > FindData | 418 | DM.DMF0002_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP DMF0002_GET_ITEM_BY_DIVISION_POPUPEx |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 459 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 808 | DM_H.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 364 | DM.DMF0000_GET_MASTER_CHG_POPUP | MATCH | SP DMF0000_GET_MASTER_CHG_POPUP |
| button:SaveButton | SaveButton > SaveData | 643 | DM.DM0003_SAVE_MKT_FCST_PK_DATA_UPDATE | MATCH | SP DM0003_SAVE_MKT_FCST_PK_DATA_UPDATE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 808 | DM_H.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > FindButton > FindData > InitSpread | 146 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > FindButton > FindData | 174 | DM.DMF0005_GET_OWNERINFO | MATCH | SP DMF0005_GET_OWNERINFO |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 364 | DM.DMF0000_GET_MASTER_CHG_POPUP | MATCH | SP DMF0000_GET_MASTER_CHG_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 371 | DM.DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx | MATCH | SP DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 418 | DM.DMF0002_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP DMF0002_GET_ITEM_BY_DIVISION_POPUPEx |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > InitSpread > GetSpdTitle | 459 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 643 | DM.DM0003_SAVE_MKT_FCST_PK_DATA_UPDATE | MATCH | SP DM0003_SAVE_MKT_FCST_PK_DATA_UPDATE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData > InitSpread > GetSpdTitle | 808 | DM_H.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetDivisionbyScmSite | 611 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > FindData > InitSpread | 146 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 174 | DM.DMF0005_GET_OWNERINFO | MATCH | SP DMF0005_GET_OWNERINFO |
| event:this.Load | Form_Load > InitControls | 191 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 211 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 214 | biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 262 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 280 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 364 | DM.DMF0000_GET_MASTER_CHG_POPUP | MATCH | SP DMF0000_GET_MASTER_CHG_POPUP |
| event:this.Load | Form_Load > FindData | 371 | DM.DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx | MATCH | SP DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx |
| event:this.Load | Form_Load > FindData | 418 | DM.DMF0002_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP DMF0002_GET_ITEM_BY_DIVISION_POPUPEx |
| event:this.Load | Form_Load > FindData > InitSpread > GetSpdTitle | 459 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 510 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData > InitSpread > GetSpdTitle | 808 | DM_H.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetLookupValues | 828 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.spdMain.CellClick | spdMain_CellClick | 1001 | biz:CommonData.CommonDataList [code=PlantSiteByItem] | BIZ_MATCH |  |
| event:this.txtItemID.KeyDown | txtItemID_KeyDown > FindButton > FindData | 371 | DM.DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx | MATCH | SP DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx |
| event:this.txtItemID.KeyDown | txtItemID_KeyDown > FindButton > FindData | 418 | DM.DMF0002_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP DMF0002_GET_ITEM_BY_DIVISION_POPUPEx |
| event:this.txtItemID.KeyDown | txtItemID_KeyDown > FindButton > FindData > InitSpread > GetSpdTitle | 459 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.usrButtonList1.UsrButtonList_Click_Detected | usrButtonList1_UsrButtonList_Click_Detected > SaveTitleSet | 510 | SCM.SCM0002_SET_TITLESET_POPUP | MATCH | SP SCM0002_SET_TITLESET_POPUP |
| unreached:(진입점 미연결) | GetDivision | 539 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetDivisionbyScmSite | 553 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 570 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 584 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetDivision | 597 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 628 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 642 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:EXEC:SCM0001_GET_LOOKUP_VALUES |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=PlantSiteByItem] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM_H.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DM0003_SAVE_MKT_FCST_PK_DATA_UPDATE | MATCH | 1 | SP DM0003_SAVE_MKT_FCST_PK_DATA_UPDATE | EXEC:DM0003_SAVE_MKT_FCST_PK_DATA_UPDATE, CREATE:#RESULTS, CREATE:#VALID_RESULTS, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#RESULTS, SELECT:DM_PLN_MKT_FCST, SELECT:#RESULTS, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, DELETE:#VALID_RESULTS, SELECT:SYSCURSORS, DELETE:DM_PLN_MKT_FCST, REF:FN_NEXT_DAY, DELETE:SCM_MST_FUTURE_PRICE, DELETE:DM_PLN_SALES_PLAN, INSERT:#VALID_RESULTS, SELECT:#VALID_RESULTS, MERGE:DM_PLN_MKT_FCST, MERGE:DM_PLN_SALES_PLAN, INSERT:DM_PLN_SALES_PLAN, SELECT:SCM_MST_FUTURE_PRICE, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SITE_ITEM, SELECT:DM_PLN_SALES_PLAN, INSERT:SCM_MST_FUTURE_PRICE, INSERT:DM_PLN_MKT_FCST_PK_DATA_UPDATE_H, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 2 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0000_GET_MASTER_CHG_POPUP | MATCH | 1 | SP DMF0000_GET_MASTER_CHG_POPUP | EXEC:DMF0000_GET_MASTER_CHG_POPUP, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USER, REF:FN_GET_DEPT_LIST, SELECT:DM_PLN_MKT_FCST, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:DM_MST_ITEM_SINGLE_V, REF:UF_FX_STRING_SPLITFORIN, REF:UF_FX_STRING_SPLIT, REF:FN_NEXT_DAY, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SPLIT |  |
| DM.DMF0002_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | 1 | SP DMF0002_GET_ITEM_BY_DIVISION_POPUPEx | EXEC:DMF0002_GET_ITEM_BY_DIVISION_POPUPEX, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TMP_81_UC_EXCEPTION, REF:UF_FX_STRING_SPLITFORIN, REF:UF_FX_STRING_SPLIT, SELECT:SCM_MST_ITEM_SN, SELECT:SPLIT |  |
| DM.DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx | MATCH | 1 | SP DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx | EXEC:DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEX, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:UF_FX_STRING_SPLITFORIN, REF:UF_FX_STRING_SPLIT, SELECT:SPLIT |  |
| DM.DMF0002_GET_TITLESET_POPUP | MATCH | 1 | SP DMF0002_GET_TITLESET_POPUP | EXEC:DMF0002_GET_TITLESET_POPUP, EXEC:SCM0002_SET_DEFAULT_TITLESET_POPUP, REF:FN_SCM_SYS_NVL, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, REF:STRING_SPLIT, INSERT:SCM_MST_TITLESET_USER |  |
| DM.DMF0005_GET_OWNERINFO | MATCH | 1 | SP DMF0005_GET_OWNERINFO | EXEC:DMF0005_GET_OWNERINFO, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_USER |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 2 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0002_SET_TITLESET_POPUP | MATCH | 1 | SP SCM0002_SET_TITLESET_POPUP | EXEC:SCM0002_SET_TITLESET_POPUP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, DELETE:SCM_MST_TITLESET_USER, REF:SCM_ARR_SPL_VAL, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_MST_TITLESET_USER, UPDATE:SCM_MST_TITLESET_USER, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| FindData | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID, Dept_ID |
| InitSheet | _dtTitleSet.Rows[0] | LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| InitSheet | spdUser.Sheets[0].Columns | COLUMN_LABEL_NAME, USER_SORT_METHOD_CODE, SUB_TOTAL_FLAG |
| ResetWidth | spdUser.ActiveSheet.Columns | SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME |
| SaveTitleSet | sv.Columns | COLUMN_NAME, USER_SORT_METHOD_CODE, SUB_TOTAL_FLAG |
| SetTitleSet | svSource.Columns | SUB_TOTAL_FLAG, USER_SELECTABLE_FLAG, SORT_ORDER_NO, COLUMN_NAME, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME, COLUMN_LABEL_NAME, SORT_METHOD_CODE, USER_SORT_METHOD_CODE |
| SetTitleSet | svTarget.Columns | COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, SORT_METHOD_CODE, SORT_ORDER_NO, USER_SORT_METHOD_CODE, USER_SELECTABLE_FLAG |
| spdUser_ButtonClicked | sv.Columns | SUB_TOTAL_FLAG |
| spdUser_RowDragMove | sv.Columns | USER_SELECTABLE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:272, InitSpread:296, InitSpread:342 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:273, InitSpread:297, InitSpread:343 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| GetCheckedListValue | InitControls:197, InitControls:202, FindData:365, FindData:366, GetSpdTitle:814, InitControls:275, InitControls:292 | CString.GetCheckedListValue | CODE |
| SaveData | SaveButton:335, btnButtonList_UsrButtonList_Click_Detected:796 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:156 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:222 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:459 |
| this | Load | Form_Load | .ctor:147 |
| dsdm | Changed | spdMain_Changed | InitEvent:246 |
| this | Load | Form_Load | .ctor:86 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:87 |
| this.btnButtonList | UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected | Form_Load:98 |
| this.spdMain | CellClick | SpdMain_CellClick | Form_Load:99 |
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
| this.txtItemID | KeyDown | txtItemID_KeyDown | InitializeComponent:130 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:170 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:264 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:506 |
| this | Load | Form_Load | .ctor:160 |
| this.txtItemID | KeyDown | txtItemID_KeyDown | InitializeComponent:118 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:158 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:213 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:339 |

## 6. 컨트롤 (84개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 19 | layoutControlItem4, lblDivision, Team, lblEndCustomer, lblSalesSite, layoutControlItem1, layoutControlItem1, layoutControlItem3, layoutControlItem1, lblDivision, Team, lblDivision2, lblScmSite, lblProject, layoutControlItem2 … |
| UsrCheckedList | 10 | clbDivision, clbTeam, clbSalesSite, clbEndCustomer, clbDivision, clbScmSite, clbTeam, clbEndCustomer, clbDivision, clbItemType |
| EmptySpaceItem | 8 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem4, emptySpaceItem2, emptySpaceItem2, emptySpaceItem1, emptySpaceItem1, emptySpaceItem3 |
| UsrLayoutControl | 7 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 7 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrButtonList | 6 | btnButtonList, btnButtonList, usrButtonList2, usrButtonList1, btnButtonList, btnButtonList |
| FpSpread | 6 | spdMain, spdMain, spdBase, spdUser, spdMain, spdMain |
| SheetView | 6 | spdMain_Sheet1, spdMain_Sheet1, spdBase_Sheet1, spdUser_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| TextBox | 3 | txtProject, txtItemID, txtItemID |
| Panel | 3 | pnlBottom, pnlCenter, pnlCenterButton |
| Button | 2 | btnRight, btnLeft |
| UsrTextBox | 1 | txtSearch |
| SplitContainer | 1 | splMain |
| UsrMultiLineEditor | 1 | txtProject |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (6건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 417 | DM_H.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx | commented:MATCH |
| 509 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | commented:MATCH |
| 598 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 375 | DM.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx_40 | commented:MATCH |
| 540 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 243 | SCM.SCM0002_GET_TITLESET_POPUP | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ItemPopup, MasterChg Popup, OwnerInfo, Base, User
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:273, CreateSheetHeaderColumn@InitSpread:297, CreateSheetHeaderColumn@InitSpread:343
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 522 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 523 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 524 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 525 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 278 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siMain.GetColumnIndex("DEPT_ID") != -1) |
| InitSpread |  | 280 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siMain.GetColumnIndex("DEPT_NAME_KO") != -1) |
| InitSpread |  | 282 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siMain.GetColumnIndex("END_CUSTOMER") != -1) |
| InitSpread |  | 284 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siMain.GetColumnIndex("END_CUSTOMER40") != -1) |
| InitSpread |  | 286 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siMain.GetColumnIndex("PROJECT_CODE") != -1) |
| InitSpread |  | 288 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siMain.GetColumnIndex("PROJECT_NAME") != -1) |
| InitSpread |  | 290 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siMain.GetColumnIndex("SCM_SITE_ID") != -1) |
| InitSpread |  | 292 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siMain.GetColumnIndex("SITE_DESCRIPTION") != -1) |
| InitSpread |  | 294 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siMain.GetColumnIndex("CURRENCY") != -1) |
| InitializeComponent |  | 355 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 356 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 357 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 358 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 475 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 476 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 477 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 478 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 138 | 하드코딩 | AddTextColumn | UserID | UserID |  |
| InitSpread |  | 139 | 하드코딩 | AddTextColumn | UserName | UserName |  |
| InitSpread |  | 140 | 하드코딩 | AddTextColumn | EnglishName | UserName_E |  |
| InitSpread |  | 142 | 하드코딩 | AddTextColumn | Email | Email | if(!SSOUserYN && !SingleSelectYn) |
| InitSpread |  | 143 | 하드코딩 | AddTextColumn | Dept_ID | Dept_ID |  |
| InitSpread |  | 144 | 하드코딩 | AddTextColumn | Dept_Name | Dept_Name |  |
| InitSpread |  | 146 | 하드코딩 | AddComboColumn | UseYN | UseYN | if(!SSOUserYN && !SingleSelectYn) |
| SpdMain_CellClick |  | 220 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| SpdMain_CellClick |  | 225 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| InitializeComponent |  | 226 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 227 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 228 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 229 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSheet | 0 | 180 | 하드코딩 | AddTextColumn | ColumnName | COLUMN_NAME |  |
| InitSheet | 0 | 182 | 하드코딩 | AddTextColumn | LargeClass | LARGE_CLASS_LABEL_NAME |  |
| InitSheet | 0 | 183 | 하드코딩 | AddTextColumn | SmallClass | SMALL_CLASS_LABEL_NAME |  |
| InitSheet | 0 | 184 | 하드코딩 | AddTextColumn | Column \|\| Measure | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 185 | 하드코딩 | AddTextColumn | Sort | SORT_METHOD_CODE |  |
| InitSheet | 0 | 186 | 하드코딩 | AddNumColumn | Seq | SORT_ORDER_NO |  |
| InitSheet | 0 | 187 | 하드코딩 | AddTextColumn | Sort | USER_SORT_METHOD_CODE |  |
| InitSheet | 0 | 188 | 하드코딩 | AddCheckColumn | Sub Total | SUB_TOTAL_FLAG |  |
| InitSheet | 0 | 189 | 하드코딩 | AddTextColumn | USER_SELECTABLE_FLAG | USER_SELECTABLE_FLAG |  |
| InitSheet | 0 | 191 | 표시/라벨 변경 | set:Locked | Locked = {?true} |  |  |
| InitSheet | 0 | 198 | 하드코딩 | AddTextColumn | ColumnName | COLUMN_NAME |  |
| InitSheet | 0 | 200 | 하드코딩 | AddTextColumn | LargeClass | LARGE_CLASS_LABEL_NAME |  |
| InitSheet | 0 | 201 | 하드코딩 | AddTextColumn | SmallClass | SMALL_CLASS_LABEL_NAME |  |
| InitSheet | 0 | 202 | 하드코딩 | AddTextColumn | Column \|\| Measure | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 203 | 하드코딩 | AddTextColumn | Sort | SORT_METHOD_CODE |  |
| InitSheet | 0 | 204 | 하드코딩 | AddNumColumn | Seq | SORT_ORDER_NO |  |
| InitSheet | 0 | 205 | 하드코딩 | AddComboColumn | Sort | USER_SORT_METHOD_CODE |  |
| InitSheet | 0 | 206 | 하드코딩 | AddCheckColumn | Sub Total | SUB_TOTAL_FLAG |  |
| InitSheet | 0 | 207 | 하드코딩 | AddTextColumn | USER_SELECTABLE_FLAG | USER_SELECTABLE_FLAG |  |
| InitSheet | 0 | 209 | 표시/라벨 변경 | set:Locked | Locked = {?true} | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 210 | 표시/라벨 변경 | set:BackColor | BackColor = {?ControlColor.UnLockColor} | USER_SORT_METHOD_CODE \|\| SUB_TOTAL_FLAG |  |
| SetTitleSet | 0 | 292 | 표시/라벨 변경 | set:Value | Value = {?true} | SUB_TOTAL_FLAG | for(r < svSource.Rows.Count) ⟫ if(svSource.Cells["0", svSource.Columns["SUB_TOTAL_FLAG"].Index].Text == "Y") |
| SetTitleSet | 0 | 383 | 표시/라벨 변경 | set:Text | Text = {?sColumnName} | COLUMN_NAME | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 384 | 표시/라벨 변경 | set:Text | Text = {?sLabelName} | COLUMN_LABEL_NAME | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 385 | 표시/라벨 변경 | set:Text | Text = {?sSLabelName} | SMALL_CLASS_LABEL_NAME | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 386 | 표시/라벨 변경 | set:Text | Text = {?sLLabelName} | LARGE_CLASS_LABEL_NAME | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 387 | 표시/라벨 변경 | set:Text | Text = {?sSortMethod} | SORT_METHOD_CODE | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 388 | 표시/라벨 변경 | set:Text | Text = {?sSortOrderNo} | SORT_ORDER_NO | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 389 | 표시/라벨 변경 | set:Text | Text = {?sUSortMethod} | USER_SORT_METHOD_CODE | foreach(i in selectIndex.Keys) |
| SetTitleSet | 0 | 390 | 표시/라벨 변경 | set:Text | Text = {?sUserSelectedFlag} | USER_SELECTABLE_FLAG | foreach(i in selectIndex.Keys) |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 하드코딩 전용(메타 없음) | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |
| OwnerInfo | 코드 하드코딩 전용(메타 없음) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 28 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 28건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
