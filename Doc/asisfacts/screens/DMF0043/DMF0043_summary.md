# DMF0043 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_Main\DMF0043_Contribute_Main.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_Main\DMF0043_Contribute_Main.csproj | 942 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_Main\DMF0043_Contribute_Main.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_Main\DMF0043_Contribute_Main.csproj | 504 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_Main\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_Main\DMF0043_Contribute_Main.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_Main\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_Main\DMF0043_Contribute_Main.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_Main\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_Main\DMF0043_Contribute_Main.csproj | 27 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_View\DMF0043_Contribute_View.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_View\DMF0043_Contribute_View.csproj | 538 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_View\DMF0043_Contribute_View.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_View\DMF0043_Contribute_View.csproj | 717 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_View\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_View\DMF0043_Contribute_View.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_View\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_View\DMF0043_Contribute_View.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_View\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0043_Contribute_View\DMF0043_Contribute_View.csproj | 27 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0043_ContributeRatePopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 396 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0043_ContributeRatePopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 363 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0043_VersionPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 389 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0043_VersionPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 536 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0043_Contribute_Main.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 904 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0043_Contribute_Main.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 500 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0043_Contribute_View.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 488 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0043_Contribute_View.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 713 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > InitSpread | 141 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:FindButton | FindButton > FindData > InitSpread | 145 | DM.DMF0043_GET_MAIN_SPREAD_TITLE | MATCH | SP DMF0043_GET_MAIN_SPREAD_TITLE |
| button:FindButton | FindButton > FindData > InitSpread | 146 | DM.DMF0043_GET_SALES_LIST_SPREAD_TITLE | MATCH | SP DMF0043_GET_SALES_LIST_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 209 | DM.DMF0043_GET_CONTRIBUTE_RATE_POPUP | MATCH | SP DMF0043_GET_CONTRIBUTE_RATE_POPUP |
| button:FindButton | FindButton > FindData | 234 | DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP | MATCH | SP DMF0043_GET_CONT_VIEW_VERSIONPOPUP |
| button:FindButton | FindButton > FindData | 289 | DM.DMF0043_GET_CONTRIBUTE_MAIN_DATA | MATCH | SP DMF0043_GET_CONTRIBUTE_MAIN_DATA |
| button:FindButton | FindButton > FindData | 358 | DM.DMF0043_GET_CONTRIBUTION_SALES_LIST | MATCH | SP DMF0043_GET_CONTRIBUTION_SALES_LIST |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread | 141 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread | 145 | DM.DMF0043_GET_MAIN_SPREAD_TITLE | MATCH | SP DMF0043_GET_MAIN_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 209 | DM.DMF0043_GET_CONTRIBUTE_RATE_POPUP | MATCH | SP DMF0043_GET_CONTRIBUTE_RATE_POPUP |
| button:SaveButton | SaveButton > SaveData | 279 | DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_VER | MATCH | SP DMF0043_SAVE_DM_MST_CONTRIBUTE_VER |
| button:SaveButton | SaveButton > SaveData > FindData | 289 | DM.DMF0043_GET_CONTRIBUTE_MAIN_DATA | MATCH | SP DMF0043_GET_CONTRIBUTE_MAIN_DATA |
| button:SaveButton | SaveButton > SaveData > GetYearData | 379 | DM.DMF0043_GET_CONTRIBUTE_YEAR_POPUP | MATCH | SP DMF0043_GET_CONTRIBUTE_YEAR_POPUP |
| button:SaveButton | SaveButton > SaveData | 435 | DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO | MATCH | SP DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData > InitSpread | 141 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 209 | DM.DMF0043_GET_CONTRIBUTE_RATE_POPUP | MATCH | SP DMF0043_GET_CONTRIBUTE_RATE_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 234 | DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP | MATCH | SP DMF0043_GET_CONT_VIEW_VERSIONPOPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 279 | DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_VER | MATCH | SP DMF0043_SAVE_DM_MST_CONTRIBUTE_VER |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > GetYearData | 379 | DM.DMF0043_GET_CONTRIBUTE_YEAR_POPUP | MATCH | SP DMF0043_GET_CONTRIBUTE_YEAR_POPUP |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread | 146 | DM.DMF0043_GET_SALES_LIST_SPREAD_TITLE | MATCH | SP DMF0043_GET_SALES_LIST_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 114 | biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP3] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 116 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 117 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > InitSpread | 141 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread | 145 | DM.DMF0043_GET_MAIN_SPREAD_TITLE | MATCH | SP DMF0043_GET_MAIN_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread | 146 | DM.DMF0043_GET_SALES_LIST_SPREAD_TITLE | MATCH | SP DMF0043_GET_SALES_LIST_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData | 209 | DM.DMF0043_GET_CONTRIBUTE_RATE_POPUP | MATCH | SP DMF0043_GET_CONTRIBUTE_RATE_POPUP |
| event:this.Load | Form_Load > FindData | 234 | DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP | MATCH | SP DMF0043_GET_CONT_VIEW_VERSIONPOPUP |
| event:this.Load | Form_Load > InitControls > GetLookupData | 376 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetYearData | 379 | DM.DMF0043_GET_CONTRIBUTE_YEAR_POPUP | MATCH | SP DMF0043_GET_CONTRIBUTE_YEAR_POPUP |
| event:this.Load | Form_Load > InitControls > GetVersionData | 716 | DM.DMF0043_GET_MAIN_VARSION_DATA | MATCH | SP DMF0043_GET_MAIN_VARSION_DATA |
| event:this.txtDes.KeyDown | txtItemID_KeyDown > FindButton > FindData | 234 | DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP | MATCH | SP DMF0043_GET_CONT_VIEW_VERSIONPOPUP |
| event:this.usrDiscard.Click | usrDiscard_Click > InitSpread | 145 | DM.DMF0043_GET_MAIN_SPREAD_TITLE | MATCH | SP DMF0043_GET_MAIN_SPREAD_TITLE |
| event:this.usrHis.CheckedChanged | usrHis_CheckedChanged > InitSpread | 145 | DM.DMF0043_GET_MAIN_SPREAD_TITLE | MATCH | SP DMF0043_GET_MAIN_SPREAD_TITLE |
| event:usrYear.SelectedIndexChanged | usrYear_SelectedIndexChanged > InitSpread | 145 | DM.DMF0043_GET_MAIN_SPREAD_TITLE | MATCH | SP DMF0043_GET_MAIN_SPREAD_TITLE |
| unreached:(진입점 미연결) | GetSpdTitle | 318 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| unreached:(진입점 미연결) | GetLookupData | 479 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| unreached:(진입점 미연결) | InsertRow | 494 | biz:CommonData.CommonDataList [code=DMF0005_DM_CONTRIBUTION_TYPE_CD] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetLookupData | 541 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DMF0005_DM_CONTRIBUTION_TYPE_CD] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP3] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DM0000_GET_COMMON_SPREAD_TITLE | EXEC:DM0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP | MATCH | 1 | SP DMF0043_GET_CONT_VIEW_VERSIONPOPUP | EXEC:DMF0043_GET_CONT_VIEW_VERSIONPOPUP, SELECT:DM_MDF_VERSION |  |
| DM.DMF0043_GET_CONTRIBUTE_MAIN_DATA | MATCH | 1 | SP DMF0043_GET_CONTRIBUTE_MAIN_DATA | EXEC:DMF0043_GET_CONTRIBUTE_MAIN_DATA, CREATE:#TITLE, INSERT:#TITLE, EXEC:DMF0043_GET_MAIN_SPREAD_TITLE, SELECT:#TITLE, INSERT:#TEMP, SELECT:DM_MST_CONTRIBUTE_RATIO_MST, SELECT:DM_MST_CONTRIBUTE_RATIO_DTL, INSERT:#TEMP2, SELECT:#TEMP, INSERT:#MASTER_LIST, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, INSERT:#TEMP_LIST, INSERT:#DATATABLE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TEMP3, SELECT:#DATATABLE, EXEC:SP_EXECUTESQL, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:#TEMP2 |  |
| DM.DMF0043_GET_CONTRIBUTE_RATE_POPUP | MATCH | 1 | SP DMF0043_GET_CONTRIBUTE_RATE_POPUP | EXEC:DMF0043_GET_CONTRIBUTE_RATE_POPUP, SELECT:DM_MST_CONTRIBUTE_VER |  |
| DM.DMF0043_GET_CONTRIBUTE_YEAR_POPUP | MATCH | 1 | SP DMF0043_GET_CONTRIBUTE_YEAR_POPUP | EXEC:DMF0043_GET_CONTRIBUTE_YEAR_POPUP, SELECT:DM_MST_CONTRIBUTE_VER |  |
| DM.DMF0043_GET_CONTRIBUTION_SALES_LIST | MATCH | 1 | SP DMF0043_GET_CONTRIBUTION_SALES_LIST | EXEC:DMF0043_GET_CONTRIBUTION_SALES_LIST, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, CREATE:#TMP_PLAN_REPORT_C, INSERT:#TMP_PLAN_REPORT_C, SELECT:DM_PLN_BP_FCST_REPORT_C, SELECT:SCM_MST_COMPANY_SN, SELECT:DM_MST_CONTRIBUTE_VER, SELECT:DM_PLN_SALES_PLAN_REPORT_C, INSERT:#TMP_SALES_LIST_C, SELECT:#TMP_PLAN_REPORT_C, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_SITE, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, SELECT:DM_MST_CONTRIBUTE_RATIO_MST, SELECT:DM_MST_CONTRIBUTE_RATIO_DTL, SELECT:#TMP_SALES_LIST_C, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |
| DM.DMF0043_GET_MAIN_SPREAD_TITLE | MATCH | 1 | SP DMF0043_GET_MAIN_SPREAD_TITLE | EXEC:DMF0043_GET_MAIN_SPREAD_TITLE, INSERT:#TEMP, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TEMP2, SELECT:#TEMP, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:#TEMP2 |  |
| DM.DMF0043_GET_MAIN_VARSION_DATA | MATCH | 1 | SP DMF0043_GET_MAIN_VARSION_DATA | EXEC:DMF0043_GET_MAIN_VARSION_DATA, SELECT:DM_MST_CONTRIBUTE_VER |  |
| DM.DMF0043_GET_SALES_LIST_SPREAD_TITLE | MATCH | 1 | SP DMF0043_GET_SALES_LIST_SPREAD_TITLE | EXEC:DMF0043_GET_SALES_LIST_SPREAD_TITLE, INSERT:#TEMP, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:#TEMP |  |
| DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO | MATCH | 1 | SP DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO | EXEC:DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO, CREATE:#RESULTS_MST, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#RESULTS_MST, SELECT:SCM_SYS_CALENDAR_M, SELECT:#RESULTS_MST, DELETE:DM_MST_CONTRIBUTE_RATIO_MST, INSERT:DM_MST_CONTRIBUTE_RATIO_MST, DELETE:DM_MST_CONTRIBUTE_RATIO_DTL, INSERT:DM_MST_CONTRIBUTE_RATIO_DTL, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_VER | MATCH | 1 | SP DMF0043_SAVE_DM_MST_CONTRIBUTE_VER | EXEC:DMF0043_SAVE_DM_MST_CONTRIBUTE_VER, CREATE:#RESULTS_MST, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#RESULTS_MST, SELECT:#RESULTS_MST, SELECT:DM_MST_CONTRIBUTE_VER, DELETE:DM_MST_CONTRIBUTE_VER, MERGE:DM_MST_CONTRIBUTE_VER, SELECT:DM_MST_CONTRIBUTE_RATIO_MST, INSERT:DM_MST_CONTRIBUTE_RATIO_DTL, SELECT:DM_MST_CONTRIBUTE_RATIO_DTL, INSERT:DM_MST_CONTRIBUTE_RATIO_MST, INSERT:SCM_SYS_LOG_BATCH |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 3 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnSPVer_Click | UserInfoContext.Current | TimeZone |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID |
| FindData | response.DataSet.Tables[2].Rows[0] | CNT |
| InitControls | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| CreateSheetHeaderColumn | InitSpread:154, InitSpread:152 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:213, SaveButton:278, SaveButton:187, btnButtonList_UsrButtonList_Click_Detected:347 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| LoadData | btnCutOff_Click:576, btnCutOff_Click:497 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |
| GetCheckedListValue | FindData:215 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.chkYear | CheckedChanged | chkYear_CheckedChanged | InitializeComponent:185 |
| this.usrDiscard | Click | usrDiscard_Click | InitializeComponent:223 |
| this.btnCutOff | Click | btnCutOff_Click | InitializeComponent:260 |
| this.usrHis | CheckedChanged | usrHis_CheckedChanged | InitializeComponent:298 |
| this | Load | Form_Load | .ctor:95 |
| usrYear | SelectedIndexChanged | usrYear_SelectedIndexChanged | DefineProperty:125 |
| dsdm | Changed | spdMain_Changed | DefineProperty:128 |
| dsdm | Changed | spdMain_Changed | FindData:308 |
| dsdm | Changed | spdMain_Changed | FindData:314 |
| dsdm | Changed | spdMain_Changed | spdMain_Changed:930 |
| dsdm | Changed | spdMain_Changed | spdMain_Changed:932 |
| this.btnSPVer | Click | btnSPVer_Click | InitializeComponent:199 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:412 |
| this | Load | Form_Load | .ctor:88 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:185 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:275 |
| this | Load | Form_Load | .ctor:73 |
| this.txtDes | KeyDown | txtItemID_KeyDown | InitializeComponent:131 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:172 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:227 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:431 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:432 |
| this | Load | Form_Load | .ctor:91 |

## 6. 컨트롤 (78개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 21 | lblYear, layoutControlItem5, layoutControlItem2, layoutControlItem6, layoutControlItem1, lblVersion, layoutControlItem1, lblYear, layoutControlItem5, lblBiz, lblVersion1, layoutControlItem2, layoutControlItem8, lblType, layoutControlItem2 … |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 8 | emptySpaceItem1, emptySpaceItem1, emptySpaceItem1, emptySpaceItem1, emptySpaceItem2, emptySpaceItem4, emptySpaceItem5, emptySpaceItem3 |
| UsrCombo | 6 | usrYear, usrYear, usrBiz, usrType, clbYear, clbType |
| UsrCheckBox | 5 | chkYear, usrDiscard, usrHis, chkM, usrChk |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 4 | spdMain, spdMain, spdMain, spdMain |
| SheetView | 4 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrButton | 3 | btnCutOff, btnSPVer, btnColumn |
| UsrMultiLineEditor | 2 | txtVersion, usrCust |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| TextBox | 1 | txtDes |
| UsrCheckedList | 1 | clbDivision |
| UsrDateRangePicker | 1 | drpPeriod |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 37 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 23 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 90 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_GroupMenuAuth | 9 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 13 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0043 | ContributeMain | 7/0 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0043 | ContributeRate | 5/0 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0043 | ContributeSalesList | 9/0 | · | · | · | · | · | · | · | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 29개 시트×division 비교, 차이 1878건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ContributeMain, ContributeSalesList, ContributeRate, VersionPopup
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:154, CreateSheetHeaderColumn@InitSpread:152
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeaderSpan |  | 617 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadColumn |  | 675 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkYear.Checked == true) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) |
| SetSpreadColumn |  | 679 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkYear.Checked == true) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) |
| SetSpreadColumn |  | 680 | 표시/라벨 변경 | set:BackColor | BackColor = {?Color.White} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkYear.Checked == true) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) |
| SetSpreadColumn |  | 687 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(chkYear.Checked == true) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) |
| SetSpreadColumn |  | 688 | 표시/라벨 변경 | set:BackColor | BackColor = {?Color.White} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(chkYear.Checked == true) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) |
| SetSpreadColumn |  | 693 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(chkYear.Checked == true) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) |
| InitializeComponent |  | 422 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 423 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 424 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 425 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadHeaderSpan |  | 193 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| InitializeComponent |  | 623 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 624 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 625 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 626 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 291 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 292 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 293 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 294 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread_X |  | 161 | 하드코딩 | AddTextColumn | Divison | DIVISION_ID |  |
| InitSpread_X |  | 162 | 하드코딩 | AddTextColumn | Version | VERSION_NO |  |
| InitSpread_X |  | 163 | 하드코딩 | AddTextColumn | Description | VERSION_DESCRIPTION |  |
| InitSpread_X |  | 164 | 하드코딩 | AddTextColumn | Type | VERSION_TYPE |  |
| InitSpread_X |  | 165 | 하드코딩 | AddTextColumn | Seq | VER_CRE_SEQ |  |
| InitSpread_X |  | 166 | 하드코딩 | AddTextColumn | Date | YYYYMMDD |  |
| InitSpread_X |  | 167 | 하드코딩 | AddTextColumn | Create By | CREATED_BY |  |
| InitSpread_X |  | 168 | 하드코딩 | AddTextColumn | Create Date | CREATION_DATE |  |
| InitializeComponent |  | 448 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 449 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 450 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 451 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ContributeMain | META+코드연결 | 7 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| ContributeRate | META+코드연결 | 5 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| ContributeSalesList | META+코드연결 | 9 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| VersionPopup | 코드 하드코딩 전용(메타 없음) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
