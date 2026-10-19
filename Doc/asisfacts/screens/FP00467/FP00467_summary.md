# FP00467 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00467_Setup_Matrix.UIL\FP00467_Setup_Matrix.UIL.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00467_Setup_Matrix.UIL\FP00467_Setup_Matrix.UIL.csproj | 1795 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00467_Setup_Matrix.UIL\FP00467_Setup_Matrix.UIL.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00467_Setup_Matrix.UIL\FP00467_Setup_Matrix.UIL.csproj | 677 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00467_Setup_Matrix.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00467_Setup_Matrix.UIL\FP00467_Setup_Matrix.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboCategory.SelectedIndexChanged | CboCategory_SelectedIndexChanged > SetAttributeCombo | 240 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list2] | BIZ_MATCH |  |
| event:cboCategory.SelectedIndexChanged | CboCategory_SelectedIndexChanged > SetAttributeCombo | 240 | FP\MASTER\FP00466_itemSetupAttr#get_item_list2 | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_list2.sql |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged | 332 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged | 332 | FP\MASTER\FP00460_SetupGroup#find_line_setup_group | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_line_setup_group.sql |
| event:cboLineSetup.SelectedIndexChanged | CboLineSetup_SelectedIndexChanged > SetAttributeCombo | 240 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list2] | BIZ_MATCH |  |
| event:cboLineSetup.SelectedIndexChanged | CboLineSetup_SelectedIndexChanged > SetAttributeCombo | 240 | FP\MASTER\FP00466_itemSetupAttr#get_item_list2 | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_list2.sql |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged | 226 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] | BIZ_MATCH |  |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged | 226 | FP\MASTER\FP00460_SetupGroup#find_line_setup_group | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_line_setup_group.sql |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged > SetAttributeCombo | 240 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list2] | BIZ_MATCH |  |
| event:cboOperation.SelectedIndexChanged | CboOperation_SelectedIndexChanged > SetAttributeCombo | 240 | FP\MASTER\FP00466_itemSetupAttr#get_item_list2 | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_list2.sql |
| button:FindButton | FindButton > UIFindData > FindMainMatrix | 1039 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_setup_matrix] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainMatrix | 1039 | FP\Master\FP00466_ItemSetupAttr#get_setup_matrix | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_setup_matrix.sql |
| button:FindButton | FindButton > UIFindData > FindMainMatrix | 1040 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_recent_item_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainMatrix | 1040 | FP\Master\FP00466_ItemSetupAttr#get_recent_item_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_recent_item_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainMatrix | 1041 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainMatrix | 1041 | FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql |
| button:SaveButton | SaveButton > SaveDataAttrType | 987 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_setup_matrix] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveDataAttrType | 987 | FP\Master\FP00466_ItemSetupAttr#save_setup_matrix | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveDataAttrType > UIFindData > FindMainMatrix | 1039 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_setup_matrix] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveDataAttrType > UIFindData > FindMainMatrix | 1039 | FP\Master\FP00466_ItemSetupAttr#get_setup_matrix | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_setup_matrix.sql |
| button:SaveButton | SaveButton > SaveDataAttrType > UIFindData > FindMainMatrix | 1040 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_recent_item_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveDataAttrType > UIFindData > FindMainMatrix | 1040 | FP\Master\FP00466_ItemSetupAttr#get_recent_item_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_recent_item_list.sql |
| button:SaveButton | SaveButton > SaveDataAttrType > UIFindData > FindMainMatrix | 1041 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveDataAttrType > UIFindData > FindMainMatrix | 1041 | FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql |
| event:this.Load | Form_Load > InitControls > CboOperation_SelectedIndexChanged | 226 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > CboOperation_SelectedIndexChanged | 226 | FP\MASTER\FP00460_SetupGroup#find_line_setup_group | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_line_setup_group.sql |
| event:this.Load | Form_Load > InitControls > CboCategory_SelectedIndexChanged > SetAttributeCombo | 240 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list2] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > CboCategory_SelectedIndexChanged > SetAttributeCombo | 240 | FP\MASTER\FP00466_itemSetupAttr#get_item_list2 | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_list2.sql |
| event:this.Load | Form_Load > InitControls | 402 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 429 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 433 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 433 | FP\MASTER\FP00460_SetupGroup#find_category | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_category.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 39 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FindAttrValue | 1593 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FindAttrValue | 1593 | FP\Master\FP00466_ItemSetupAttr#get_item_values | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_values.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list2] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_recent_item_list] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_setup_matrix] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_setup_matrix] | BIZ_MATCH | 1 |  |  |  |
| FP\MASTER\FP00460_SetupGroup#find_category | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\MASTER\FP00460_SetupGroup#find_line_setup_group | MATCH | 2 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_line_setup_group.sql | SELECT:FP_LINE_SETUP_GROUP_M |  |
| FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql | SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_LIST_M, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_TYPE_M |  |
| FP\MASTER\FP00466_itemSetupAttr#get_item_list2 | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_list2.sql | SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_TYPE_M |  |
| FP\Master\FP00466_ItemSetupAttr#get_item_values | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_values.sql | SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_VALUE_M, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Master\FP00466_ItemSetupAttr#get_recent_item_list | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_recent_item_list.sql | SELECT:FP_WEEKLY_DEMAND_PRODUCT_H, SELECT:FP_INSTANCE_LINE_V, SELECT:SCM_DAILY_PRODUCT_RESULT_H, SELECT:FP_SETUP_MATRIX_M |  |
| FP\Master\FP00466_ItemSetupAttr#get_setup_matrix | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_setup_matrix.sql | SELECT:FP_SETUP_MATRIX_M |  |
| FP\Master\FP00466_ItemSetupAttr#save_setup_matrix | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| BuildAttrMatrix | dRow | ATTRIBUTE_TYPE, ACTIVE_FLAG, ATTRIBUTE_LIST |
| CboAttribute_SelectedIndexChanged | Filter | USER_ID, CATEGORY_ID |
| CboCategory_SelectedIndexChanged | Filter | USER_ID, CATEGORY_ID |
| CboInstance_SelectedIndexChanged | Filter | USER_ID |
| CboLineSetup_SelectedIndexChanged | Filter | USER_ID, CATEGORY_ID |
| CboOperation_SelectedIndexChanged | Filter | USER_ID |
| FindAttrValue | Filter | LOOKUP_TYPE_CODE, USER_ID |
| FindMainMatrix | Filter | ACTIVE_FLAG, SETUP_KEY_ID |
| InitControls | Filter | USER_ID |
| SetAttributeCombo | Filter | CATEGORY_ID |
| SetAttributeCombo | row | CODE, NAME |
| UIFindData | Filter | USER_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | CboAttribute_SelectedIndexChanged:178, CboAttribute_SelectedIndexChanged:179, CboAttribute_SelectedIndexChanged:180, CboAttribute_SelectedIndexChanged:181, CboAttribute_SelectedIndexChanged:193, CboOperation_SelectedIndexChanged:212, CboOperation_SelectedIndexChanged:213, CboLineSetup_SelectedIndexChanged:280 | CString.GetCheckedListValue | CODE |
| DataBind | InitControls:402 | UsrComboBox.DataBind | CODE, NAME |
| EditQuery | RefreshSpreadSheet:671 | FPExtensions.EditQuery | ROW_ID |
| FP_PseudoBatch | SaveDataAttrType:987 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| ReadResult | SaveDataAttrType:988 | DataService.ReadResult | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:107 |
| this | Load | Form_Load | .ctor:152 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:160 |
| this.spdMain.ActiveSheet | CellChanged | ActiveSheet_CellChanged | InitEvent:161 |
| cboInstance | SelectedIndexChanged | CboInstance_SelectedIndexChanged | InitEvent:163 |
| cboLineSetup | SelectedIndexChanged | CboLineSetup_SelectedIndexChanged | InitEvent:164 |
| cboOperation | SelectedIndexChanged | CboOperation_SelectedIndexChanged | InitEvent:165 |
| cboCategory | SelectedIndexChanged | CboCategory_SelectedIndexChanged | InitEvent:167 |
| cboAttribute | SelectedIndexChanged | CboAttribute_SelectedIndexChanged | InitEvent:168 |
| mcboFrom | SelectedIndexChanged | McboFrom_SelectedIndexChanged | InitEvent:170 |
| mcboTo | SelectedIndexChanged | McboTo_SelectedIndexChanged | InitEvent:171 |
| mcboFrom | SelectedIndexChanged | McboFrom_SelectedIndexChanged | FindMainMatrix:1045 |
| mcboTo | SelectedIndexChanged | McboTo_SelectedIndexChanged | FindMainMatrix:1046 |
| mcboFrom | SelectedIndexChanged | McboFrom_SelectedIndexChanged | FindMainMatrix:1051 |
| mcboTo | SelectedIndexChanged | McboTo_SelectedIndexChanged | FindMainMatrix:1052 |

## 6. 컨트롤 (24개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | lblInstance, layoutControlItem4, layoutControlItem9, lcAttr, layoutControlItem2, layoutControlItem5, lcFrom, lcTo |
| UsrCombo | 5 | cboOperation, cboCategory, cboInstance, cboAttribute, cboLineSetup |
| UsrCheckedList2 | 2 | mcboTo, mcboFrom |
| EmptySpaceItem | 2 | emptySpaceItem5, emptySpaceItem1 |
| SplitContainer | 1 | splitContainer1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrComboBox | 1 | cboValid |
| LayoutControlGroup | 1 | layoutControlGroup1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Setup Matrix

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 459 | 하드코딩 | AddTextColumn | Plan Group* | INSTANCE_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 460 | 하드코딩 | AddTextColumn | Operation* | OPERATION_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 461 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 462 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 463 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 464 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 465 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 466 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 467 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 468 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 469 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 470 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 471 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 472 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 473 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 474 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 475 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 477 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 479 | 하드코딩 | AddTextColumn | UPDATE_ID ID | UPDATE_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 480 | 하드코딩 | AddDateTimeColumn | UPDATE_TIME | UPDATE_TIME | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 481 | 하드코딩 | AddTextColumn | INSERT_ID | INSERT_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 482 | 하드코딩 | AddDateTimeColumn | INSERT_TIME | INSERT_TIME | if(spreadInfo.SheetName == "Setup Matrix") |
| RefreshMatrix |  | 1502 | 하드코딩 | AddTextColumn | Plan Group | INSTANCE_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| RefreshMatrix |  | 1503 | 하드코딩 | AddTextColumn | Operation | OPERATION_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| RefreshMatrix |  | 1504 | 하드코딩 | AddTextColumn | Line Setup | LINE_SETUP_GROUP_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| RefreshMatrix |  | 1505 | 하드코딩 | AddTextColumn | Setup Category | SETUP_CATEGORY_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| RefreshMatrix |  | 1506 | 하드코딩 | AddTextColumn | Setup Key | SETUP_KEY_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| RefreshMatrix |  | 1507 | 하드코딩 | AddTextColumn | .              To From              . | FROM_ITEM_SETUP_GROUP_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| RefreshMatrix |  | 1512 | 식 | AddTextColumn | {?kvp.Key} | {?kvp.Key} | if(spreadInfo.SheetName == "Setup Matrix") ⟫ foreach(kvp in Matrix) |
| InitializeComponent |  | 123 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 124 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 125 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 126 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Setup Matrix | 코드 하드코딩 전용(메타 없음) | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
