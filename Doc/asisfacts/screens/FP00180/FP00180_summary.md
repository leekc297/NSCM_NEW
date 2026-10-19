# FP00180 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00180_Material.UIL\FP00180_Material.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00180_Material.UIL\FP00180_Material.UIL.csproj | 1114 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00180_Material.UIL\FP00180_Material.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00180_Material.UIL\FP00180_Material.UIL.csproj | 1111 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00180_Material.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00180_Material.UIL\FP00180_Material.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00180_Material.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00180_Material.UIL\FP00180_Material.UIL.csproj | 84 |
| shared | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00180_MaterialImportPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 980 |
| shared | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00180_MaterialImportPopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 526 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00180_Material.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1017 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00180_Material.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1017 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_class1.SelectedIndexChanged | cbo_class1_SelectedIndexChanged | 771 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:cbo_class1.SelectedIndexChanged | cbo_class1_SelectedIndexChanged | 771 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| event:cbo_class1.SelectedIndexChanged | cbo_class1_SelectedIndexChanged > SetChangeControl | 1064 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:cbo_class1.SelectedIndexChanged | cbo_class1_SelectedIndexChanged > SetChangeControl | 1064 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| event:cbo_class1.SelectedIndexChanged | cbo_class1_SelectedIndexChanged > SetChangeControl | 1079 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:cbo_class1.SelectedIndexChanged | cbo_class1_SelectedIndexChanged > SetChangeControl | 1079 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| event:cbo_class2.SelectedIndexChanged | cbo_class2_SelectedIndexChanged > SetChangeControl | 1064 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:cbo_class2.SelectedIndexChanged | cbo_class2_SelectedIndexChanged > SetChangeControl | 1064 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| event:cbo_class2.SelectedIndexChanged | cbo_class2_SelectedIndexChanged > SetChangeControl | 1079 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:cbo_class2.SelectedIndexChanged | cbo_class2_SelectedIndexChanged > SetChangeControl | 1079 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| event:clbDivision.SelectedIndexChanged | mcbo_division_SelectedIndexChanged > SetChangeControl | 1064 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | mcbo_division_SelectedIndexChanged > SetChangeControl | 1064 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| event:clbDivision.SelectedIndexChanged | mcbo_division_SelectedIndexChanged > SetChangeControl | 1079 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | mcbo_division_SelectedIndexChanged > SetChangeControl | 1079 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| button:FindButton | FindButton > Find_Data | 376 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data | 376 | {?pServiceCallName} | UNRESOLVED |  |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_SelectedIndexChanged > SetChangeControl | 1064 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_SelectedIndexChanged > SetChangeControl | 1064 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_SelectedIndexChanged > SetChangeControl | 1079 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_SelectedIndexChanged > SetChangeControl | 1079 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| button:SaveButton | SaveButton > Save_Data > Find_Data | 376 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data | 376 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 461 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00180] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 461 | FP\MASTER\FP00180_Material#saveAll_FP00180 | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data | 607 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data | 607 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data | 376 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data | 376 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer > Find_Data_Validation | 457 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer > Find_Data_Validation | 457 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 752 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 752 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 831 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 831 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data | 376 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data | 376 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 607 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 607 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data | 376 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data | 376 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.Load | Form_Load > InitControls > GetItemType | 660 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetItemType | 660 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| event:this.Load | Form_Load > InitControls > cbo_class1_SelectedIndexChanged | 771 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cbo_class1_SelectedIndexChanged | 771 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| event:this.Load | Form_Load > InitControls > cbo_class2_SelectedIndexChanged > SetChangeControl | 1064 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cbo_class2_SelectedIndexChanged > SetChangeControl | 1064 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| event:this.Load | Form_Load > InitControls > cbo_class2_SelectedIndexChanged > SetChangeControl | 1079 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cbo_class2_SelectedIndexChanged > SetChangeControl | 1079 | FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 71 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetSite | 640 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_SaveDataDelegate | 819 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=FP00180_MATERIAL_EXCEL_UPDATE_BATCH] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_SaveDataDelegate | 819 | FP\Common\FP00180_Material#FP00180_MATERIAL_EXCEL_UPDATE_BATCH | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 836 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 836 | FP\Common\FP00180_Material#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00180_Material_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 840 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 840 | FP\Common\FP00180_Material#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 844 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 844 | FP\Common\FP00180_Material#find_Excel_buffer_validation | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00180_Material_find_Excel_buffer_validation.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?pServiceCallName} | UNRESOLVED | 5 |  |  |  |
| {?string.Empty} | UNRESOLVED | 5 |  |  |  |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=FP00180_MATERIAL_EXCEL_UPDATE_BATCH] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00180] | BIZ_MATCH | 1 |  |  |  |
| FP\COMMON\BigFilter_FP#list_material_class2 | MATCH | 4 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_material_class2.sql | SELECT:SCM_ITEM_CLASS_M |  |
| FP\Common\FP00180_Material#delete_Excel_buffer | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00180_Material_delete_Excel_buffer.sql | DELETE:BUF_ITEM_M |  |
| FP\Common\FP00180_Material#find_Excel_buffer_validation | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00180_Material_find_Excel_buffer_validation.sql | SELECT:BUF_ITEM_M, SELECT:SCM_SITE_M, SELECT:SCM_DIVISION_M, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Common\FP00180_Material#FP00180_MATERIAL_EXCEL_UPDATE_BATCH | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\FP00180_Material#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\MASTER\FP00180_Material#saveAll_FP00180 | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcelImport_Click | p.KeyColumns | Company_id, DIVISION_ID, site_id, ITEM_ID |
| cbo_active_SelectedIndexChanged | Filter | ACTIVE_FLAG |
| cbo_itemType_SelectedIndexChanged | Filter | ITEM_TYPE |
| FindAttribute | Filter | LOOKUP_TYPE_CODE |
| FindDataMaterialAsync | Filter | DIVISION_ID |
| GetDivision | Filter | USER_ID |
| GetSite | Filter | DIVISION_ID |
| InitControls | Filter | USER_ID, ACTIVE_FLAG |
| SetChangeControl | Filter | DIVISION_ID, SITE_ID, ITEM_CLASS_LEVEL_1, ITEM_CLASS_LEVEL_CODE, ITEM_CLASS_LEVEL_2 |
| spdMain_CellClick | cRow | LEVEL_2_CODE |
| spdMain_CellClick | dRow | CLASS_LEVEL_2_CODE, CODE, NAME |
| spdMain_CellClick | bindingRow | OPERATION_ID |
| tbClass_TextChanged | Filter | ITEM_CLASS |
| tbMaterial_TextChanged | Filter | ITEM_ID |
| tbModel_TextChanged | Filter | MODEL_ID |
| tbNickName_OnSearchConditionChanged | Filter | NICK_NAME, NICK_NAME_LT |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| LockColumnFP | EditButton:308, EditButton:309, EditButton:310, EditButton:311, EditButton:312 | FPExtensions.LockColumnFP | EDIT_YN |
| GetChanges | Save_Data_Line:457 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch | Save_Data_Line:461, FP00180_SaveDataDelegate:819, FP00180_ValidateDataDelegate:840 | DataService.FP_UpdateBatch | COUNT, RESULT |
| GetInnerTable | GetItemType:660, SetChangeControl:1040, SetChangeControl:1049, SetChangeControl:1064, SetChangeControl:1079, GetDivision:1108 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | cbo_itemType_SelectedIndexChanged:759, cbo_active_SelectedIndexChanged:793, SetChangeControl:1044, SetChangeControl:1059, SetChangeControl:1067, SetChangeControl:1089 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:126 |
| clbDivision | SelectedIndexChanged | mcbo_division_SelectedIndexChanged | InitEvent:253 |
| mcbo_site | SelectedIndexChanged | mcbo_site_SelectedIndexChanged | InitEvent:254 |
| cbo_class1 | SelectedIndexChanged | cbo_class1_SelectedIndexChanged | InitEvent:255 |
| cbo_class2 | SelectedIndexChanged | cbo_class2_SelectedIndexChanged | InitEvent:256 |
| cbo_itemType | SelectedIndexChanged | cbo_itemType_SelectedIndexChanged | InitEvent:257 |
| tbClass | TextChanged | tbClass_TextChanged | InitEvent:259 |
| tbModel | TextChanged | tbModel_TextChanged | InitEvent:260 |
| tbMaterial | TextChanged | tbMaterial_TextChanged | InitEvent:261 |
| cbo_active | SelectedIndexChanged | cbo_active_SelectedIndexChanged | InitEvent:262 |
| tbNickName | BeforeOpenSearch | tbNickName_BeforeOpenSearch | InitEvent:263 |
| tbNickName | OnSearchConditionChanged | tbNickName_OnSearchConditionChanged | InitEvent:264 |
| popSql | OnSql | RunSqlSource | btnSql_Click:489 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:197 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:238 |
| this.tbNickName | TextChanged | tbNickName_TextChanged | InitializeComponent:548 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:866 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:867 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:868 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:869 |
| this | Load | Form_Load | .ctor:154 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:194 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:243 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:282 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:321 |

## 6. 컨트롤 (56개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | lblSite, lblDivision, lblClass, layoutControlItem2, lblMaterialType, lblClass1, lblClass2, lblModel, lblMaterial, lblNickName, lblActive, lblSql, layoutControlItem4, layoutControlItem5, layoutControlItem6 … |
| UsrButton | 7 | btnSql, btnExcelImport, usrButton2, btnClose, btnImport, btnSave, btnFind |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 4 | cbo_itemType, cbo_class2, cbo_class1, cbo_active |
| UsrTextBox | 3 | tbClass, tbMaterial, tbModel |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| FpSpread | 3 | spdMain, spdSub, spdComExcel |
| SheetView | 3 | spdMain_Sheet1, spdSub_Sheet1, spdComExcel_Sheet1 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrCheckedList2 | 2 | clbDivision, mcbo_site |
| UsrPopupTextBox | 1 | tbNickName |
| SplitContainer | 1 | splitContainer1 |
| UsrLabel | 1 | lblSheetName |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (14건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 376 | Find_Data | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 376 | Find_Data | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 457 | Find_Data_Validation | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 457 | Find_Data_Validation | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 607 | Save_Data | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 607 | Save_Data | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 752 | Save_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 752 | Save_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 831 | Delete_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 831 | Delete_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 844 | FP00180_ValidateDataDelegate | FP\{?default:part_service}\FP00180_Material#find_Excel_buffer_validation | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 836 | FP00180_ValidateDataDelegate | FP\{?default:part_service}\FP00180_Material#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 819 | FP00180_SaveDataDelegate | FP\{?default:part_service}\FP00180_Material#FP00180_MATERIAL_EXCEL_UPDATE_BATCH | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 840 | FP00180_ValidateDataDelegate | FP\{?default:part_service}\FP00180_Material#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 31 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 10 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 18 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00180 | Main | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, {?this.sSheetName}
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:242, SetSheetHeaderColumn_FP@SetSpreadInit:231

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 885 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 886 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 887 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 888 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 993 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 994 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 995 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 996 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSheetHeaderWidth |  | 936 | 표시/라벨 변경 | set:Width | Width = {?sz.Width} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(Convert.ToInt32(siComExcel.ActiveSheet.Columns["0"].Width) == 0) |
| InitializeComponent |  | 445 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 446 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 447 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 448 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
