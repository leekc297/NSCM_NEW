# SCP0050 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.UIL.csproj | 1192 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.UIL.csproj | 864 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPAPICUserInfoPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.UIL.csproj | 280 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPAPICUserInfoPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.UIL.csproj | 294 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_ColumnSet_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.UIL.csproj | 672 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_ColumnSet_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.UIL.csproj | 307 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_ExcelPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.UIL.csproj | 864 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_ExcelPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.UIL.csproj | 719 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\TestCode.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0050_CAPA_PIC.UIL\SCP0050_CAPA_PIC.UIL.csproj | 48 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0050_CAPA_PIC\POPUP\SCP0050_CAPAPICUserInfoPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0050_CAPA_PIC\SCP0050_CAPA_PIC.csproj | 280 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0050_CAPA_PIC\POPUP\SCP0050_CAPAPICUserInfoPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0050_CAPA_PIC\SCP0050_CAPA_PIC.csproj | 294 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0050_CAPA_PIC\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0050_CAPA_PIC\SCP0050_CAPA_PIC.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0050_CAPA_PIC\SCP0050_CAPA_PIC.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0050_CAPA_PIC\SCP0050_CAPA_PIC.csproj | 1136 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0050_CAPA_PIC\SCP0050_CAPA_PIC.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0050_CAPA_PIC\SCP0050_CAPA_PIC.csproj | 771 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 214 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 224 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | 817 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | 827 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbGroup.SelectedIndexChanged | ClbGroup_SelectedIndexChanged | 782 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbGroup.SelectedIndexChanged | ClbGroup_SelectedIndexChanged | 792 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged | 829 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged | 839 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 801 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 811 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 157 | SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP |
| button:FindButton | FindButton > FindData | 157 | SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP |
| button:FindButton | FindButton > FindData_Main | 397 | SCP.SCP0050_GET_CAPA_PIC | MATCH | SP SCP0050_GET_CAPA_PIC |
| button:FindButton | FindButton > FindData_Main | 407 | SCP.SCP0050_GET_CAPA_PIC | MATCH | SP SCP0050_GET_CAPA_PIC |
| button:SaveButton | SaveButton > SaveData_Main | 558 | SCP.SCP0050_SAVE_CAPA_PIC | MATCH | SP SCP0050_SAVE_CAPA_PIC |
| button:SaveButton | SaveButton > SaveData_Main | 568 | SCP.SCP0050_SAVE_CAPA_PIC | MATCH | SP SCP0050_SAVE_CAPA_PIC |
| button:SaveButton | SaveButton > SaveData_Main > GetUserIDChk | 647 | SCP.SCP0050_GET_USER_ID_CHECK | MATCH | SP SCP0050_GET_USER_ID_CHECK |
| button:SaveButton | SaveButton > SaveData_Main > GetUserIDChk | 657 | SCP.SCP0050_GET_USER_ID_CHECK | MATCH | SP SCP0050_GET_USER_ID_CHECK |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > FindButton > FindData | 157 | SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > FindButton > FindData | 157 | SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP |
| event:this.btnSave.Click | btnSave_Click > SaveToDB | 288 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_tmp_capa_pic] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > SaveToDB | 288 | FP\Capa\CAPA_PIC#delete_tmp_capa_pic | MATCH | [sql] foxquery_sql\FP_Capa_CAPA_PIC_delete_tmp_capa_pic.sql |
| event:this.btnSave.Click | btnSave_Click > SaveToDB | 289 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=upload_pic] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > SaveToDB | 289 | FP\Capa\CAPA_PIC#upload_pic | MATCH | [update-batch]  |
| event:this.btnSave.Click | btnSave_Click > SaveToDB | 290 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=fill_capa_pic] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > SaveToDB | 290 | FP\Capa\CAPA_PIC#fill_capa_pic | MATCH | [sql] foxquery_sql\FP_Capa_CAPA_PIC_fill_capa_pic.sql |
| event:this.btnSave.Click | btnSave_Click > SaveToDB | 291 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=merge_capa_pic] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > SaveToDB | 291 | FP\Capa\CAPA_PIC#merge_capa_pic | MATCH | [sql] foxquery_sql\FP_Capa_CAPA_PIC_merge_capa_pic.sql |
| event:this.Load | Form_Load > FindData | 157 | SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP |
| event:this.Load | Form_Load > FindData | 157 | SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 214 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 224 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:txtManager.KeyDown | TxtManager_KeyDown > FindButton > FindData_Main | 397 | SCP.SCP0050_GET_CAPA_PIC | MATCH | SP SCP0050_GET_CAPA_PIC |
| event:txtManager.KeyDown | TxtManager_KeyDown > FindButton > FindData_Main | 407 | SCP.SCP0050_GET_CAPA_PIC | MATCH | SP SCP0050_GET_CAPA_PIC |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 44 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtMDMCategoryId> | 51 | biz:CommonData.CommonDataList [code=MDMCategoryId] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtMDMCategoryId> | 51 | biz:CommonData.CommonDataList [code=MDMCategoryId] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtSiteFP> | 53 | biz:CommonData.CommonDataList [code=SiteFP] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtSiteFP> | 53 | biz:CommonData.CommonDataList [code=SiteFP] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtElectrodeType> | 54 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtElectrodeType> | 54 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MDMCategoryId] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH | 10 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_LINE_HIERARCHY_V_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_OPERATION_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_LINE_HIERARCHY_CPS_V_SN, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_MST_OPERATION_SN |
| biz:CommonData.CommonDataList [code=SiteFP] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_SN |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_tmp_capa_pic] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=fill_capa_pic] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=merge_capa_pic] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=upload_pic] | BIZ_MATCH | 1 |  |  |  |
| FP\Capa\CAPA_PIC#delete_tmp_capa_pic | MATCH | 1 | [sql] foxquery_sql\FP_Capa_CAPA_PIC_delete_tmp_capa_pic.sql | DELETE:TEMP_CAPA_PIC |  |
| FP\Capa\CAPA_PIC#fill_capa_pic | MATCH | 1 | [sql] foxquery_sql\FP_Capa_CAPA_PIC_fill_capa_pic.sql | UPDATE:X, SELECT:TEMP_CAPA_PIC, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:SCM_SYS_LOOKUP_VALUE_SN |  |
| FP\Capa\CAPA_PIC#merge_capa_pic | MATCH | 1 | [sql] foxquery_sql\FP_Capa_CAPA_PIC_merge_capa_pic.sql | MERGE:SCM_MASTER_MANAGER_M, SELECT:TEMP_CAPA_PIC |  |
| FP\Capa\CAPA_PIC#upload_pic | MATCH | 1 | [update-batch]  |  |  |
| SCP.SCP0050_GET_CAPA_PIC | MATCH | 2 | SP SCP0050_GET_CAPA_PIC | EXEC:SCP0050_GET_CAPA_PIC, SELECT:MAIN, SELECT:SCM_MASTER_MANAGER_M_SN, SELECT:SCM_OPERATION_M_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_SITE_M_SN, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_LINE_M_SN, REF:STRING_SPLIT, SELECT:SCM_SYS_LOOKUP_VALUE_SN |  |
| SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | 2 | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP | EXEC:SCP0050_GET_CAPA_PIC_USERINFO_POPUP, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO |  |
| SCP.SCP0050_GET_USER_ID_CHECK | MATCH | 2 | SP SCP0050_GET_USER_ID_CHECK | EXEC:SCP0050_GET_USER_ID_CHECK, SELECT:SCM_MST_SSO_USER_INFO, REF:STRING_SPLIT |  |
| SCP.SCP0050_SAVE_CAPA_PIC | MATCH | 2 | SP SCP0050_SAVE_CAPA_PIC | EXEC:SCP0050_SAVE_CAPA_PIC, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCM_MASTER_MANAGER_M_SN, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| btnExcelImport_Click | poup.KeyColumns | SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, Level1, Level2, USER_ID_1, USER_ID_2, USER_ID_3, USER_ID_4, USER_ID_5, USER_ID_6, USER_ID_7, USER_ID_8, USER_ID_9, USER_ID_10 |
| btnExcelImport_Click | poup.ColumnTitle | SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, Level1, Level2, USER_ID_1, USER_ID_2, USER_ID_3, USER_ID_4, USER_ID_5, USER_ID_6, USER_ID_7, USER_ID_8, USER_ID_9, USER_ID_10 |
| btnFind_Click | Filter | PLAN_DATE, PLAN_TYPE, CURR_DATE |
| InitControls | dataRow | CODE, NAME, SORT_ORDER |
| InitControls | dr | CODE, NAME |
| OpenAndLoadExcelData | r | SELECT |
| SaveToDB | Filter | USER_ID |
| SetChangedControl | drRow | CODE, NAME |
| SetChangedControl | dr | CODE |
| SpdMain_ComboSelChange | c | CATEGORY_ID |
| spdUser_ButtonClicked | sv.Columns | SUB_TOTAL_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:206, SetChangedControl:210, SetChangedControl:214, SetChangedControl:218, SetChangedControl:222, FindData_Main:387, FindData_Main:388, FindData_Main:389 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:269, InitSpread:259 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| FP_PseudoBatch2 | SaveToDB:289 | DataService.FP_PseudoBatch2 | COUNT, EXCEPTION, RESULT |
| FP_Log | OpenAndLoadExcelData:366, OpenAndLoadExcelData:412, OpenAndLoadExcelData:415, OpenAndLoadExcelData:434, OpenAndLoadExcelData:684 | DataService.FP_Log | LOGTYPE, NOTE, USER_ID |
| CommonDefaultLineCheck | DefaultLineCheck:774 | ExcelService.CommonDefaultLineCheck | BUCKET_FROM, BUCKET_TO, MESSAGE, QTY |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:76 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:77 |
| this.btnButtonList | UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected | Form_Load:92 |
| this.spdMain | CellClick | SpdMain_CellClick | Form_Load:93 |
| this | Load | Form_Load | .ctor:134 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:286 |
| clbGroup | SelectedIndexChanged | ClbGroup_SelectedIndexChanged | InitEvent:287 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:288 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:289 |
| cboCategoryId | SelectedIndexChanged | ClbCategoryId_SelectedIndexChanged | InitEvent:290 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:291 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:293 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:294 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:295 |
| txtManager | KeyDown | TxtManager_KeyDown | InitEvent:297 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:177 |
| this.usrButtonList1 | UsrButtonList_Click_Detected | usrButtonList1_UsrButtonList_Click_Detected | InitializeComponent:161 |
| this.spdBase | CellDoubleClick | spdBase_CellDoubleClick | InitializeComponent:192 |
| this.spdUser | RowDragMove | spdUser_RowDragMove | InitializeComponent:210 |
| this.spdUser | RowDragMoveCompleted | spdUser_RowDragMoveCompleted | InitializeComponent:211 |
| this.spdUser | CellDoubleClick | spdUser_CellDoubleClick | InitializeComponent:212 |
| this.spdUser | ButtonClicked | spdUser_ButtonClicked | InitializeComponent:213 |
| this.btnRight | Click | btnRight_Click | InitializeComponent:246 |
| this.btnLeft | Click | btnLeft_Click | InitializeComponent:256 |
| this | Load | ColumnSetForm_Load | InitializeComponent:269 |
| this | SizeChanged | ColumnSetForm_SizeChanged | InitializeComponent:270 |
| this | Load | Form_Load | .ctor:138 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:178 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:228 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:267 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:306 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:434 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:435 |
| this.btnCheckAll | Click | btnCheckAll_Click | InitializeComponent:511 |
| this.btnUncheckAll | Click | btnUncheckAll_Click | InitializeComponent:642 |
| this | Load | Form_Load | .ctor:76 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:77 |
| this.btnButtonList | UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected | Form_Load:92 |
| this.spdMain | CellClick | SpdMain_CellClick | Form_Load:93 |
| this | Load | Form_Load | .ctor:134 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:276 |
| clbGroup | SelectedIndexChanged | ClbGroup_SelectedIndexChanged | InitEvent:277 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:278 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:279 |
| cboCategoryId | SelectedIndexChanged | ClbCategoryId_SelectedIndexChanged | InitEvent:280 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:281 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:283 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:284 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:285 |
| txtManager | KeyDown | TxtManager_KeyDown | InitEvent:287 |

## 6. 컨트롤 (117개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 31 | layoutControlItem1, layoutControlItem3, layoutDivision, layoutCategoryId, layoutManager, layoutKeyId, layoutGroup, layoutPlant, layoutBuilding, layoutLine, layoutOperation, lcExportExcel, layoutControlItem2, layoutControlItem4, layoutControlItem6 … |
| UsrCheckedList2 | 14 | clbOperation, clbLine, clbBuilding, clbPlant, clbGroup, cboKeyId, cboCategoryId, clbOperation, clbLine, clbBuilding, clbPlant, clbGroup, cboKeyId, cboCategoryId |
| EmptySpaceItem | 9 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem5, emptySpaceItem3, emptySpaceItem2, emptySpaceItem4, emptySpaceItem2, emptySpaceItem1, emptySpaceItem5 |
| UsrButton | 9 | btnExcelImport, btnSave, btnClose, btnDownload, btnUpload, btnCheckAll, usrButton2, usrButton3, btnUncheckAll |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 7 | spdMain, spdMain, spdBase, spdUser, spdMain, spdMain, spdMain |
| SheetView | 7 | spdMain_Sheet1, spdMain_Sheet1, spdBase_Sheet1, spdUser_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 5 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrButtonList | 4 | btnButtonList, usrButtonList2, usrButtonList1, btnButtonList |
| ImageList | 3 | imageList1, imageList1, imageList1 |
| Panel | 3 | pnlBottom, pnlCenter, pnlCenterButton |
| UsrTextBox | 2 | txtSearch, txtSearch |
| UsrMultiLineEditor | 2 | txtManager, txtManager |
| UsrCombo | 2 | cboDivision, cboDivision |
| Button | 2 | btnRight, btnLeft |
| SplitContainer | 1 | splMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 8 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 35 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 7 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 56 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 253 | SCM.SCM0002_GET_TITLESET_POPUP | commented:MATCH |
| 254 | DM_H.DMF0002_GET_TITLESET_POPUP | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0050 | MDM Auth Management | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: UserInfo, MDM Auth Management, Base, User, AutoExcelPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:269, SetSheetHeaderColumn@InitSpread:259
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | MDM Auth Management | 271 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 272 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 273 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 274 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 275 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 276 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 277 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 278 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 279 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 280 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitializeComponent |  | 754 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 755 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 756 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 757 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 126 | 하드코딩 | AddTextColumn | UserID | USER_ID |  |
| InitSpread |  | 127 | 하드코딩 | AddTextColumn | UserName | USER_NAME |  |
| InitSpread |  | 128 | 하드코딩 | AddTextColumn | EnglishName | USER_NAME_EN |  |
| InitSpread |  | 129 | 하드코딩 | AddTextColumn | Dept_ID | DEPT_ID |  |
| InitSpread |  | 130 | 하드코딩 | AddTextColumn | Dept_Name | DEPT_NAME |  |
| SpdMain_CellClick |  | 201 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| SpdMain_CellClick |  | 206 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| InitializeComponent |  | 228 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 229 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 230 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 231 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSheet | 0 | 188 | 하드코딩 | AddTextColumn | Column | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 189 | 하드코딩 | AddTextColumn | Matching Column | MATCHING |  |
| InitSheet | 0 | 190 | 하드코딩 | AddNumColumn | Matching Column Order | MATCHING |  |
| InitSheet | 0 | 198 | 표시/라벨 변경 | set:Locked | Locked = {?true} |  |  |
| InitSheet | 0 | 209 | 하드코딩 | AddTextColumn | Column | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 210 | 하드코딩 | AddNumColumn | Matching Column Order | MATCHING |  |
| InitSheet | 0 | 220 | 표시/라벨 변경 | set:Locked | Locked = {?true} |  |  |
| CreateSpread | AutoExcelPopup | 175 | 하드코딩 | AddCheckColumn |  | SELECT |  |
| CreateSpread | AutoExcelPopup | 179 | 식 | AddTextColumn | {?kvp.Key} | {?kvp.Key} | foreach(kvp in KeyColumns.Data) |
| InitializeComponent |  | 451 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 452 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 453 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 454 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 126 | 하드코딩 | AddTextColumn | UserID | USER_ID |  |
| InitSpread |  | 127 | 하드코딩 | AddTextColumn | UserName | USER_NAME |  |
| InitSpread |  | 128 | 하드코딩 | AddTextColumn | EnglishName | USER_NAME_EN |  |
| InitSpread |  | 129 | 하드코딩 | AddTextColumn | Dept_ID | DEPT_ID |  |
| InitSpread |  | 130 | 하드코딩 | AddTextColumn | Dept_Name | DEPT_NAME |  |
| SpdMain_CellClick |  | 201 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| SpdMain_CellClick |  | 206 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| InitializeComponent |  | 228 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 229 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 230 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 231 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread | MDM Auth Management | 261 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 262 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 263 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 264 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 265 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 266 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 267 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 268 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 269 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread | MDM Auth Management | 270 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitializeComponent |  | 670 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 671 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 672 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 673 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 하드코딩 전용(메타 없음) | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| AutoExcelPopup | 코드 하드코딩 전용(메타 없음) | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| MDM Auth Management | META+코드연결 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 |
| UserInfo | 코드 하드코딩 전용(메타 없음) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
