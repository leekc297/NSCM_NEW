# DM0006 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Master.UIL\DM0006_CustomerModelMapping.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1504 |
| only | 06.UIL\GSCM.DM.Master.UIL\DM0006_CustomerModelMapping.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 880 |
| only | 06.UIL\GSCM.DM.Mst.UIL\COMMON\DM0006_POPUP_01.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 286 |
| only | 06.UIL\GSCM.DM.Mst.UIL\COMMON\DM0006_POPUP_01.Designer.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 390 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0006_CustomerModelMapping.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 1014 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0006_CustomerModelMapping.Designer.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 665 |
| only | 06.UIL\GSCM.DM.Shipment.UIL\POPUP\DM0006_POPUP_01.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 712 |
| only | 06.UIL\GSCM.DM.Shipment.UIL\POPUP\DM0006_POPUP_01.Designer.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 662 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:EditButton | EditButton > FindData | 154 | xxxx.xxxx | NOT_IN_FOXQUERY |  |
| button:EditButton | EditButton > FindData | 320 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST |
| button:EditButton | EditButton > FindData > GroupData | 396 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS |
| button:EditButton | EditButton > FindData > ParameterData | 411 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS |
| button:FindButton | FindButton > FindData | 154 | xxxx.xxxx | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > FindData | 306 | DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA |
| button:FindButton | FindButton > FindData | 320 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST |
| button:FindButton | FindButton > FindData > GroupData | 396 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS |
| button:FindButton | FindButton > FindData | 404 | DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA |
| button:FindButton | FindButton > FindData > ParameterData | 411 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1362 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 154 | xxxx.xxxx | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData_DataService > FindData | 306 | DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA |
| button:SaveButton | SaveButton > SaveData > FindData | 320 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST |
| button:SaveButton | SaveButton > SaveData > FindData > GroupData | 396 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS |
| button:SaveButton | SaveButton > SaveData_DataService > FindData | 404 | DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA |
| button:SaveButton | SaveButton > SaveData > FindData > ParameterData | 411 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS |
| button:SaveButton | SaveButton > SaveData_DataService | 418 | DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA |
| button:SaveButton | SaveButton > SaveData_DataService | 635 | DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA |
| button:SaveButton | SaveButton > SaveData_DataService > FindData > InitSpread > GetSpdTitle | 1362 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > EditButton > FindData | 154 | xxxx.xxxx | NOT_IN_FOXQUERY |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > EditButton > FindData | 320 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > EditButton > FindData > GroupData | 396 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > EditButton > FindData > ParameterData | 411 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS |
| event:this.clbDivisions.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetScmSitebyDivision | 144 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.clbDivisions.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetScmSitebyDivision | 1277 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetDivision | 130 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| event:this.Load | Form_Load > InitControls | 136 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetScmSitebyDivision | 144 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > FindData | 154 | xxxx.xxxx | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > InitControls | 155 | biz:CommonData.CommonDataList [code=UpperDeptId] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 320 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST |
| event:this.Load | Form_Load > FindData > GroupData | 396 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS |
| event:this.Load | Form_Load > FindData > ParameterData | 411 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS |
| event:this.Load | Form_Load > InitControls > GetDivision | 1263 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| event:this.Load | Form_Load > InitControls > GetScmSitebyDivision | 1277 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetLookupValues | 1337 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1362 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSitebyDivision | 144 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSitebyDivision | 1277 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 44 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 171 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 221 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | mSave | 477 | DM.PR_DM_ADM_DQ_CREATE | MATCH | SP PR_DM_ADM_DQ_CREATE |
| unreached:(진입점 미연결) | SaveDataBiz | 575 | biz:GSCM_DM_Mst_BLL.mSet_DM0006_CustomerModelMapping_INT | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveData_BizService | 602 | biz:GSCM_DM_Mst_BLL.mSetTestList | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveData_BizServiceCollection | 625 | biz:GSCM_DM_Mst_BLL.mSetTestListCollection | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveData_BizServiceCollection2 | 650 | biz:GSCM_DM_Mst_BLL.mSetTestListCollection2 | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveData_BizServiceCollection3 | 694 | biz:GSCM_DM_Mst_BLL.mSetTestListCollection3 | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetScmSiteInfobyDivision | 1293 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 1308 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 1322 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 1381 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 1403 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 1441 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=UpperDeptId] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO |
| biz:CommonData.YesOrNo | BIZ_MATCH | 3 |  |  |  |
| biz:GSCM_DM_Mst_BLL.mSet_DM0006_CustomerModelMapping_INT | BIZ_MATCH | 1 |  |  |  |
| biz:GSCM_DM_Mst_BLL.mSetTestList | BIZ_MATCH | 1 |  |  |  |
| biz:GSCM_DM_Mst_BLL.mSetTestListCollection | BIZ_MATCH | 1 |  |  |  |
| biz:GSCM_DM_Mst_BLL.mSetTestListCollection2 | BIZ_MATCH | 1 |  |  |  |
| biz:GSCM_DM_Mst_BLL.mSetTestListCollection3 | BIZ_MATCH | 1 |  |  |  |
| DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DM0000_GET_COMMON_SPREAD_TITLE | EXEC:DM0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | 1 | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | EXEC:DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS, SELECT:SCM_ADM_DQ_COLUMN |  |
| DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | 1 | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | EXEC:DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST, SELECT:TMPDQ, REF:UF_FX_STRING_SPLIT, SELECT:SCM_ADM_DQ_USER_GROUP, SELECT:TB_FX_GROUPINFO, SELECT:SCM_ADM_DQ_LIST |  |
| DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | 1 | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | EXEC:DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS, SELECT:SCM_ADM_DQ_PARAMETER |  |
| DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | 2 | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | EXEC:DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_DEPT_LIST, SELECT:DM_MST_CUSTOMER_MODEL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_PROJECT, REF:UF_FX_STRING_SPLITFORIN, REF:UF_FX_STRING_SPLIT, SELECT:TB_FX_USER, SELECT:SPLIT |  |
| DM.PR_DM_ADM_DQ_CREATE | MATCH | 1 | SP PR_DM_ADM_DQ_CREATE | EXEC:PR_DM_ADM_DQ_CREATE, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:PR_DM_ADM_DQ_CREATE_HIST, INSERT:SCM_ADM_DQ_LIST, UPDATE:SCM_ADM_DQ_LIST, DELETE:SCM_ADM_DQ_LIST, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:SCM_ADM_DQ_LIST_H |  |
| DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | MATCH | 2 | SP PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | EXEC:PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, DELETE:DM_MST_CUSTOMER_MODEL, INSERT:DM_MST_CUSTOMER_MODEL, UPDATE:DM_MST_CUSTOMER_MODEL, EXEC:PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST, INSERT:SCM_SYS_LOG_BATCH, INSERT:DM_MST_CUSTOMER_MODEL_H |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 2 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 3 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_INFO_BY_DIVISION | EXEC:SCM0001_GET_SITE_INFO_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, REF:STRING_SPLIT |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| xxxx.xxxx | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbEndCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| FindData | ds.Tables[0].Rows[0] | DQ_NAME, DESCRIPTION, DQ_TEXT |
| FindData | ds.Tables[0].Rows[i] | GROUP_ID |
| FindData | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SaveData | dr | A, RegtUserID |
| SaveData | saveDS.Tables[0].Rows[i] | A |
| SaveData_BizServiceCollection2 | nvcCol | search |
| SaveData_BizServiceCollection3 | row | Col1, Col2, Col3 |
| SaveData_DataService | nvcCols | A |
| SaveDataBiz | dr | A |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:147, FindData:379, btnModelType_Click:778, btnProject_Click:797, clbDivision_SelectedIndexChanged:836, clbDivision_SelectedIndexChanged:841, clbDivision_SelectedIndexChanged:846, clbTeam_SelectedIndexChanged:1423 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:215 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:216 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:136 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetChanges | SaveData:237, SaveData:770 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:123 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:332 |
| this.rtxtSQL | TextChanged | rtxtSQL_TextChanged | InitializeComponent:500 |
| this.fpWhere | CellDoubleClick | fpWhere_CellDoubleClick | InitializeComponent:543 |
| this.fpWhere | ComboSelChange | fpWhere_ComboSelChange | InitializeComponent:544 |
| this | Load | Form_Load | .ctor:99 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:171 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:122 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:123 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:124 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:125 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:234 |
| this.clbDivisions | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:449 |
| this.btnModelType | Click | btnModelType_Click | InitializeComponent:486 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:526 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:566 |
| this.layoutControlItem6 | Click | btnProject_Click | InitializeComponent:717 |
| this | Load | Form_Load | .ctor:119 |
| this.umltProject | KeyDown | umltProject_KeyDown | DefineProperty:176 |
| this.umltModel | KeyDown | umltModel_KeyDown | DefineProperty:177 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:209 |
| dsdm | Changed | Dsdm_Changed | Dsdm_Changed:1472 |
| dsdm | Changed | Dsdm_Changed | Dsdm_Changed:1499 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:209 |
| this | Load | Form_Load | .ctor:63 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:108 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:109 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:110 |
| this.clbDivisions | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:394 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:431 |
| this.btnModelType | Click | btnModelType_Click | InitializeComponent:468 |
| this | Load | Form_Load | .ctor:95 |

## 6. 컨트롤 (103개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 28 | layoutControlItem1, layoutControlItem2, layoutControlItem3, layoutControlItem5, layoutControlItem1, layoutControlItem4, layoutControlItem3, layoutControlItem9, layoutControlItem21, layoutControlItem6, layoutControlItem10, layoutControlItem5, layoutControlItem22, lblActive, layoutControlItem25 … |
| EmptySpaceItem | 12 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem1, emptySpaceItem5, emptySpaceItem1, emptySpaceItem2, emptySpaceItem4, emptySpaceItem5, emptySpaceItem1, emptySpaceItem1, emptySpaceItem2 |
| UsrMultiLineEditor | 10 | umltCustomerPJT, umltCustomerModel, umltModel, umltProject, txtCity, txtCountry, umltCustomerPJT, umltCustomerModel, umltModel, umltProject |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList | 7 | clbRole, clbSalesSite, clbDivisions, clbTeam, clbEndCustomer, clbSalesSite, clbDivisions |
| FpSpread | 5 | spdMain, fpWhere, spdMain, spdMain, spdMain |
| SheetView | 5 | spdMain_Sheet1, fpWhere_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrButton | 4 | btnProject, btnModelType, btnProject, btnModelType |
| UsrTextBox | 2 | txtReportName, txtDescription |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| Label | 2 | lbl_DQ_ID, label1 |
| RichTextBox | 1 | rtxtSQL |
| UsrCombo | 1 | cboActive |
| ImageList | 1 | imageList1 |
| Panel | 1 | panel1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 154 | FindData | xxxx.xxxx | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 21 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1264 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 131 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 559 | GSCM_DM_Mst_BLL.mSet_DM0006_CustomerModelMapping_INT | commented:BIZ_MATCH |
| 140 | DM.DMF0027_GET_DM_DYNAMIC_QUERYS | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DM0006 | Customer Model Mapping | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 56건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: XXXX, XXXX2, Customer Model Mapping, shtMain Customer Model Mapping
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:216

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 141 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 142 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 97 | 하드코딩 | AddTextColumn | Column1 | Column1 |  |
| InitSpread |  | 98 | 하드코딩 | AddTextColumn | Column2 | Column2 |  |
| InitSpread |  | 99 | 하드코딩 | AddTextColumn | Column3 | Column3 |  |
| InitializeComponent |  | 108 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 109 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 110 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 111 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 181 | 하드코딩 | AddComboColumn | Division | DIVISION_ID |  |
| InitSpread |  | 186 | 하드코딩 | AddTextColumn | End Customer | END_CUSTOMER |  |
| InitSpread |  | 187 | 하드코딩 | AddComboColumn | Site | SCM_SITE_ID |  |
| InitSpread |  | 189 | 하드코딩 | AddTextColumn | Project Code | PROJECT_CODE |  |
| InitSpread |  | 190 | 하드코딩 | AddTextColumn | Project | PROJECT_NAME |  |
| InitSpread |  | 192 | 하드코딩 | AddTextColumn | Customer PJT | CUSTOMER_PROJECT_CODE |  |
| InitSpread |  | 193 | 하드코딩 | AddTextColumn | Customer Model | CUSTOMER_MODEL |  |
| InitSpread |  | 196 | 하드코딩 | AddTextColumn | Model | ITEM_ID |  |
| InitSpread |  | 197 | 하드코딩 | AddTextColumn | Model Type | ITEM_CLASS_NAME |  |
| InitSpread |  | 199 | 하드코딩 | AddNumColumn | KW/h | CAPACITY |  |
| InitSpread |  | 201 | 하드코딩 | AddNumColumn | Convert Qty(Pack) | CONVERT_QTY_PACK |  |
| InitSpread |  | 203 | 하드코딩 | AddNumColumn | Convert Qty(Module) | CONVERT_QTY_MODULE |  |
| InitSpread |  | 205 | 하드코딩 | AddNumColumn | Convert Qty(Cell) | CONVERT_QTY_CELL |  |
| InitSpread |  | 206 | 하드코딩 | AddComboColumn | Acvite | VALID_YN |  |
| InitSpread |  | 208 | 하드코딩 | AddTextColumn | Update Date | LAST_UPDATE_DATE |  |
| InitSpread |  | 209 | 하드코딩 | AddTextColumn | Update User | LAST_UPDATED_BY |  |
| InitializeComponent |  | 126 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 127 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 128 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 129 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread_Group |  | 634 | 하드코딩 | AddTextColumn | Column | COLUMN_NAME |  |
| InitSpread_Group |  | 635 | 하드코딩 | AddTextColumn | Type | VALUE_TYPE |  |
| InitSpread_Group |  | 636 | 하드코딩 | AddComboColumn | Vaild | VALID_YN |  |
| InitSpread_Where |  | 646 | 하드코딩 | AddComboColumn | Type | PARAMETER_TYPE |  |
| InitSpread_Where |  | 647 | 하드코딩 | AddTextColumn | Column | PARAMETER_ID |  |
| InitSpread_Where |  | 648 | 하드코딩 | AddComboColumn | Vaild | VALID_YN |  |
| InitializeComponent |  | 139 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 140 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 141 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 142 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 560 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 561 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 562 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 563 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Customer Model Mapping | META+코드연결 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |
| shtMain Customer Model Mapping | 코드 하드코딩 전용(메타 없음) | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |
| XXXX | 코드 하드코딩 전용(메타 없음) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| XXXX2 | 코드 하드코딩 전용(메타 없음) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
