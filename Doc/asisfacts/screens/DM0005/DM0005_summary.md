# DM0005 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Master.UIL\DM0005_SaleSite_PjtModelMapping.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1464 |
| only | 06.UIL\GSCM.DM.Master.UIL\DM0005_SaleSite_PjtModelMapping.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 869 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0005_SaleSite_PjtModelMappingTest98_BAK.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 1457 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0005_SaleSite_PjtModelMappingTest98_BAK.Designer.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 869 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0005_SaleSite_PjtModelMappingTest98.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 2757 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0005_SaleSite_PjtModelMappingTest98.Designer.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 1825 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 2581 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 2613 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:cboDivision40.SelectedIndexChanged | cboDivision40_SelectedIndexChanged | 2671 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:cboDivision40.SelectedIndexChanged | cboDivision40_SelectedIndexChanged | 2675 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 406 | DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PRODUCTION |
| button:FindButton | FindButton > FindData_Main | 406 | DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PRODUCTION |
| button:FindButton | FindButton > FindData_Main | 642 | DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 |
| button:FindButton | FindButton > FindData_Main2 | 714 | DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 1408 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 1415 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main2 > InitSpread > GetSpdTitle | 2332 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main2 > InitSpread40 > GetSpdTitle40 | 2344 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 406 | DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PRODUCTION |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 406 | DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PRODUCTION |
| button:SaveButton | SaveButton > SaveData > FindData_Sub | 465 | DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PURCHASE |
| button:SaveButton | SaveButton > SaveData > FindData_Sub | 465 | DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PURCHASE |
| button:SaveButton | SaveButton > SaveData > SaveData1 > FindData_Main | 642 | DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 |
| button:SaveButton | SaveButton > SaveData | 698 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData | 698 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData > SaveData2 > FindData_Main2 | 714 | DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 |
| button:SaveButton | SaveButton > SaveData > SaveData1 > FindData_Sub | 775 | DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PURCHASE |
| button:SaveButton | SaveButton > SaveData | 827 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData | 834 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData > SaveData1 | 1022 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 | MATCH | SP DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 |
| button:SaveButton | SaveButton > SaveData > SaveData1 | 1022 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData > SaveData1 | 1160 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 | MATCH | SP DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 |
| button:SaveButton | SaveButton > SaveData > SaveData1 | 1160 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData > SaveData1 | 1279 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 | MATCH | SP DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 |
| button:SaveButton | SaveButton > SaveData > SaveData1 | 1279 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData > FindData_Sub > InitSpread > GetSpdTitle | 1408 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData_Sub > InitSpread > GetSpdTitle | 1415 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > SaveData2 | 1595 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 | MATCH | SP DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 |
| button:SaveButton | SaveButton > SaveData > SaveData2 > FindData_Main2 > InitSpread > GetSpdTitle | 2332 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > SaveData2 > FindData_Main2 > InitSpread40 > GetSpdTitle40 | 2344 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.clbEndCustomer40.SelectedIndexChanged | clbEndCustomer40_SelectedIndexChanged | 2701 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.clbTeam.SelectedIndexChanged | ClbTeam_SelectedIndexChanged | 2636 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbTeam40.SelectedIndexChanged | clbTeam40_SelectedIndexChanged | 2686 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbTeam40.SelectedIndexChanged | clbTeam40_SelectedIndexChanged | 2691 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 181 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 181 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 199 | biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 199 | biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 208 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 208 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 210 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 210 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 278 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 316 | biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 343 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 345 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1408 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1415 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2332 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread40 > GetSpdTitle40 | 2344 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cboDivision_SelectedIndexChanged | 2581 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cboDivision_SelectedIndexChanged | 2613 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Sub | 465 | DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PURCHASE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Sub | 465 | DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PURCHASE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Sub | 775 | DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | SP DM0005_GET_SALES_SITE_MODEL_PURCHASE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Sub > InitSpread > GetSpdTitle | 1408 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Sub > InitSpread > GetSpdTitle | 1415 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Sub > InitSpread > GetSpdTitle | 2332 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSiteInfobyDivision | 1392 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSiteInfobyDivision | 1399 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSiteInfobyDivision | 2316 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| event:this.spdMain40.ComboSelChange | spdMain40_ComboSelChange > GetScmSiteInfobyDivision | 2316 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 49 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 49 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 54 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:EXEC:SCM0001_GET_LOOKUP_VALUES |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE_ITEM, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GETCOMMONDATALIST_DM:REF:STRING_SPLIT, UP_FX_GETCOMMONDATALIST_DM:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| biz:CommonData.YesOrNo | BIZ_MATCH | 3 |  |  |  |
| DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION | MATCH | 2 | SP DM0005_GET_SALES_SITE_MODEL_PRODUCTION | EXEC:DM0005_GET_SALES_SITE_MODEL_PRODUCTION | ⚠ DB에 SP 없음 |
| DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 | MATCH | 2 | SP DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 | EXEC:DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 | ⚠ DB에 SP 없음 |
| DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | MATCH | 3 | SP DM0005_GET_SALES_SITE_MODEL_PURCHASE | EXEC:DM0005_GET_SALES_SITE_MODEL_PURCHASE | ⚠ DB에 SP 없음 |
| DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY | 7 |  |  | DB에도 없음 (폐기/오타 가능) |
| DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 | MATCH | 4 | SP DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 | EXEC:DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 | ⚠ DB에 SP 없음 |
| SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | 3 | SP SCM0001_GET_SITE_INFO_BY_DIVISION | EXEC:SCM0001_GET_SITE_INFO_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, REF:STRING_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| cboDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| cboDivision40_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbEndCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbEndCustomer40_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| ClbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam40_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| FindData_Main | UserInfoContext.Current | NowGroupID |
| FindData_Main2 | UserInfoContext.Current | NowGroupID |
| FindData_Sub | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| InsertRow1 | UserInfoContext.Current | NowGroupID |
| InsertRow2 | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| spdMain40_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:184, InitControls:189, InitControls:194, FindData_Main:384, clbDivision_SelectedIndexChanged:1178, clbDivision_SelectedIndexChanged:1183, clbDivision_SelectedIndexChanged:1188, ClbTeam_SelectedIndexChanged:1196 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:238, InitSpread:393 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:239, InitSpread:394, InitSpread40:400 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:371, SaveButton:610 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:122 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:123 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:124 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:125 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:232 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:268 |
| this.txtProject | KeyDown | txtProject_KeyDown | InitializeComponent:337 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:377 |
| this.clbTeam | SelectedIndexChanged | ClbTeam_SelectedIndexChanged | InitializeComponent:417 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:496 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:533 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:746 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:747 |
| this | Load | Form_Load | .ctor:160 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:245 |
| dsdm2 | Changed | shtSubDataModel_Changed | InitEvent:248 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:239 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:240 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:241 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:242 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:351 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:387 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:423 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:531 |
| this.clbTeam | SelectedIndexChanged | ClbTeam_SelectedIndexChanged | InitializeComponent:571 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:647 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:947 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:948 |
| this.spdMain40 | LeaveCell | spdMain40_LeaveCell | InitializeComponent:1053 |
| this.spdMain40 | CellDoubleClick | spdMain40_CellDoubleClick | InitializeComponent:1054 |
| this.spdMain40 | ComboSelChange | spdMain40_ComboSelChange | InitializeComponent:1055 |
| this.spdMain40 | TopChange | spdMain40_TopChange | InitializeComponent:1056 |
| this.btnOwner40 | Click | btnOwner40_Click | InitializeComponent:1162 |
| this.btnItemId40 | Click | btnItemId40_Click | InitializeComponent:1198 |
| this.clbEndCustomer40 | SelectedIndexChanged | clbEndCustomer40_SelectedIndexChanged | InitializeComponent:1272 |
| this.clbTeam40 | SelectedIndexChanged | clbTeam40_SelectedIndexChanged | InitializeComponent:1312 |
| this | Load | Form_Load | .ctor:257 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:406 |
| dsdm2 | Changed | shtSubDataModel_Changed | InitEvent:409 |
| dsdm40 | Changed | shtMain40DataModel_Changed | InitEvent:413 |
| dsdm2_40 | Changed | shtSub40DataModel_Changed | InitEvent:416 |
| cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:418 |
| cboDivision40 | SelectedIndexChanged | cboDivision40_SelectedIndexChanged | InitEvent:419 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:122 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:123 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:124 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:125 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:232 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:268 |
| this.txtProject | KeyDown | txtProject_KeyDown | InitializeComponent:337 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:377 |
| this.clbTeam | SelectedIndexChanged | ClbTeam_SelectedIndexChanged | InitializeComponent:417 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:496 |
| this.chkDetail | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:533 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:746 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:747 |
| this | Load | Form_Load | .ctor:160 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:245 |
| dsdm2 | Changed | shtSubDataModel_Changed | InitEvent:248 |

## 6. 컨트롤 (131개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 41 | lblDivision, lblSalesSite, layoutControlItem1, lblTeam, lblEndCustomer, lblProject, lblItemId, lblActive, layoutControlItem2, layoutControlItem3, lblSalesSite, layoutControlItem1, lblTeam, lblEndCustomer, lblProject … |
| UsrCheckedList | 14 | clbEndCustomer, clbTeam, clbSalesSite, clbDivision, clbEndCustomer, clbTeam, clbSalesSite, clbEndCustomer40, clbTeam40, clbSalesSite40, clbEndCustomer, clbTeam, clbSalesSite, clbDivision |
| UsrButton | 10 | btnItemId, btnProject, btnOwner, btnItemId, btnProject, btnOwner40, btnItemId40, usrButton1, btnItemId, btnProject |
| EmptySpaceItem | 10 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem2, emptySpaceItem7, emptySpaceItem5, emptySpaceItem6, emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| UsrMultiLineEditor | 9 | txtItemId, txtProject, txtItemId, txtProject, txtOwner, txtItemId40, txtOwner40, txtItemId, txtProject |
| FpSpread | 8 | spdMain, spdSub, spdMain, spdSub, spdMain40, spdSub40, spdMain, spdSub |
| SheetView | 8 | spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1, spdSub_Sheet1, spdMain40_Sheet1, spdSub40_Sheet1, spdMain_Sheet1, spdSub_Sheet1 |
| UsrCombo | 6 | cboActive, cboActive, cboDivision, cboActive40, cboDivision40, cboActive |
| SplitContainer | 4 | splitContainer1, splitContainer1, splitContainer2, splitContainer1 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel2, usrConditionPanel1 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1 |
| UsrCheckBox | 3 | chkDetail, chkDetail, chkDetail |
| ImageList | 3 | imageList1, imageList1, imageList1 |
| XtraTabPage | 2 | xtraTabPage1, xtraTabPage2 |
| XtraTabControl | 1 | xtraTabControl1 |

## 7. 확인 필요 (7건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 698 | SaveData | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 834 | SaveData | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1022 | SaveData1 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1160 | SaveData1 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1279 | SaveData1 | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 698 | SaveData | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 827 | SaveData | DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 47 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 6 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DM0005 | Production | 2/24 | 2/24 | 2/24 | 2/24 | 2/24 | 2/24 | 2/24 | 2/24 | 2/24 | 2/24 | 2/24 | 2/24 | 2/24 | 2/24 |
| SCM_MST_SHEET_COLUMNS | DM0005 | Purchase | 0/17 | 0/17 | 0/17 | 0/17 | 0/17 | 0/17 | 0/17 | 0/17 | 0/17 | 0/17 | 0/17 | 0/17 | 0/17 | 0/17 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Production, Purchase, Production_40
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:239, CreateSheetHeaderColumn@InitSpread:394, CreateSheetHeaderColumn@InitSpread40:400

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 141 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 142 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 763 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 764 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 765 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 766 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 141 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 142 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 763 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 764 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 765 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 766 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 258 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 259 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 260 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 261 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 964 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 965 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 966 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 967 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1072 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1073 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1074 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1075 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1628 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1629 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1630 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1631 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Production | META+코드연결 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| Purchase | META+코드연결 | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
