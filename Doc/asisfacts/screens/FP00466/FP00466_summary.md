# FP00466 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FP00466_Item_Setup_Attr.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FP00466_Item_Setup_Attr.UIL.csproj | 2221 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FP00466_Item_Setup_Attr.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FP00466_Item_Setup_Attr.UIL.csproj | 682 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FP00466_Item_Setup_Attr.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged | 168 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindAttrType | 1643 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindAttrType | 1643 | FP\Master\FP00466_ItemSetupAttr#get_item_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_list.sql |
| button:FindButton | FindButton > UIFindData > FindAttrValue | 1822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindAttrValue | 1822 | FP\Master\FP00466_ItemSetupAttr#get_item_values | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_values.sql |
| button:FindButton | FindButton > UIFindData > FindAttrList | 1852 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindAttrList | 1852 | FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql |
| button:SaveButton | SaveButton > GoSave > UIFindData > FindAttrType | 1643 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > UIFindData > FindAttrType | 1643 | FP\Master\FP00466_ItemSetupAttr#get_item_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_list.sql |
| button:SaveButton | SaveButton > GoSave > SaveAttrType | 1664 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_type] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > SaveAttrType | 1664 | FP\Master\FP00466_ItemSetupAttr#save_item_group_type | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > GoSave > SaveAttrType | 1665 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_type] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > SaveAttrType | 1665 | FP\Master\FP00466_ItemSetupAttr#delete_item_group_type | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > GoSave > SaveAttrValue | 1726 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_value] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > SaveAttrValue | 1726 | FP\Master\FP00466_ItemSetupAttr#save_item_group_value | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > GoSave > SaveAttrValue | 1727 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_value] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > SaveAttrValue | 1727 | FP\Master\FP00466_ItemSetupAttr#delete_item_group_value | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > GoSave > SaveAttrList | 1767 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > SaveAttrList | 1767 | FP\Master\FP00466_ItemSetupAttr#save_item_group_list | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > GoSave > SaveAttrList | 1768 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > SaveAttrList | 1768 | FP\Master\FP00466_ItemSetupAttr#delete_item_group_list | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > GoSave > FindDataAttrValue > FindAttrValue | 1822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > FindDataAttrValue > FindAttrValue | 1822 | FP\Master\FP00466_ItemSetupAttr#get_item_values | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_values.sql |
| button:SaveButton | SaveButton > GoSave > FindDataAttrList > FindAttrList | 1852 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > FindDataAttrList > FindAttrList | 1852 | FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql |
| event:this.Load | Form_Load > InitControls | 355 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 358 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindAttrValue | 1822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindAttrValue | 1822 | FP\Master\FP00466_ItemSetupAttr#get_item_values | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_values.sql |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindAttrList | 1852 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindAttrList | 1852 | FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindAttrValue | 1822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindAttrValue | 1822 | FP\Master\FP00466_ItemSetupAttr#get_item_values | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_values.sql |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindAttrValue | 1822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindAttrValue | 1822 | FP\Master\FP00466_ItemSetupAttr#get_item_values | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_values.sql |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindAttrList | 1852 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindAttrList | 1852 | FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindAttrValue | 1822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] | BIZ_MATCH |  |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindAttrValue | 1822 | FP\Master\FP00466_ItemSetupAttr#get_item_values | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_values.sql |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindAttrList | 1852 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH |  |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindAttrList | 1852 | FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 39 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_list] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_type] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_value] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_list] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_type] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_value] | BIZ_MATCH | 1 |  |  |  |
| FP\Master\FP00466_ItemSetupAttr#delete_item_group_list | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00466_ItemSetupAttr#delete_item_group_type | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00466_ItemSetupAttr#delete_item_group_value | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql | SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_LIST_M, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_TYPE_M |  |
| FP\Master\FP00466_ItemSetupAttr#get_item_list | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_list.sql | SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_TYPE_M, SELECT:FP_USER_ROLE_INFO_V, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Master\FP00466_ItemSetupAttr#get_item_values | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_item_values.sql | SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_VALUE_M, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Master\FP00466_ItemSetupAttr#save_item_group_list | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00466_ItemSetupAttr#save_item_group_type | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00466_ItemSetupAttr#save_item_group_value | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ActiveSheet_CellChanged | Filter | ACTIVE_FLAG |
| CboInstance_SelectedIndexChanged | Filter | USER_ID |
| FindAttrList | Filter | LOOKUP_TYPE_CODE, USER_ID |
| FindAttrType | Filter | ACTIVE_FLAG, USER_ID, INSTANCE_ID, OPERATION_ID, ITEM_NAME |
| FindAttrValue | Filter | LOOKUP_TYPE_CODE, USER_ID |
| GoSave | cRow | ACTIVE_FLAG, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15 |
| InitControls | Filter | USER_ID |
| InitSpread | eachAttr | CODE, NAME |
| SaveAttrList | rSave.Rows[0] | COUNT |
| SaveAttrList | rRemove.Rows[0] | COUNT |
| SaveAttrList | rRow | RESULT, COUNT |
| SaveAttrType | rSave.Rows[0] | COUNT |
| SaveAttrType | rRemove.Rows[0] | COUNT |
| SaveAttrType | rRow | RESULT, COUNT |
| SaveAttrValue | rSave.Rows[0] | COUNT |
| SaveAttrValue | rRemove.Rows[0] | COUNT |
| SaveAttrValue | rRow | RESULT, COUNT |
| SpdMain_CellClick | Filter | ACTIVE_FLAG |
| SpdMain_CellDoubleClick | Filter | ACTIVE_FLAG |
| spdMain_KeyUp | Filter | ACTIVE_FLAG |
| SpdSub_CellClick | Filter | ITEM_NAME |
| SpdSub_CellClick | data | ITEM_ID |
| SpdSub_CellClick | dRow | ATTRIBUTE_TYPE, ACTIVE_FLAG, INSTANCE_ID, OPERATION_ID, ATTRIBUTE_LIST |
| UIFindData | Filter | ACTIVE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | CboInstance_SelectedIndexChanged:166, InitControls:353, GoSave:1365, FindAttrType:1623, FindAttrType:1631 | CString.GetCheckedListValue | CODE |
| DataBind | InitControls:358 | UsrComboBox.DataBind | CODE, NAME |
| EditQuery | RefreshSpreadSheet:635, RefreshSpreadSheet:640, RefreshSpreadSheet:645 | FPExtensions.EditQuery | ROW_ID |
| SetFilter | FindDataAttrList:1150 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| FP_PseudoBatch | SaveAttrType:1664, SaveAttrType:1665, SaveAttrValue:1726, SaveAttrValue:1727, SaveAttrList:1767, SaveAttrList:1768 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:144 |
| this.usrTextBox_Att | KeyUp | usrTextBox_Att_KeyUp | InitializeComponent:299 |
| this.simpleButton1 | Click | simpleButton1_Click | InitializeComponent:330 |
| this | Load | Form_Load | .ctor:146 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:154 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:155 |
| this.spdMain.ActiveSheet | CellChanged | ActiveSheet_CellChanged | InitEvent:156 |
| this.spdSub | CellClick | SpdSub_CellClick | InitEvent:157 |
| cboInstance | SelectedIndexChanged | CboInstance_SelectedIndexChanged | InitEvent:159 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 6 | layoutControlItem5, layoutControlItem6, layoutControlItem8, layoutControlItem7, lblInstance, layoutControlItem3 |
| EmptySpaceItem | 5 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem4, emptySpaceItem6, emptySpaceItem2 |
| FpSpread | 3 | spdMain, spdList, spdSub |
| SheetView | 3 | spdMain_Sheet1, spdList_Sheet1, spdSub_Sheet1 |
| SplitContainer | 2 | splitContainer1, mainSplitter |
| UsrComboBox | 2 | cboValid, SubComboBox_param |
| UsrCombo | 2 | cboOperation, cboInstance |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrTextBox | 1 | usrTextBox_Att |
| SimpleButton | 1 | simpleButton1 |
| LayoutControlGroup | 1 | layoutControlGroup1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 773 | SCM.SCM0003_GET_LOOKUP_MASTER | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Item Setup Attribute Type Definition, Item Setup Attribute Type Option List, Item Setup Attribute Values

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 396 | 하드코딩 | AddTextColumn | Instance* | INSTANCE_NAME | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 397 | 하드코딩 | AddTextColumn | Operation* | OPERATION_ID | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 398 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 399 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 400 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 401 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 402 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 403 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 404 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 405 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 406 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 407 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 408 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 409 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 410 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 411 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 412 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 414 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 416 | 하드코딩 | AddTextColumn | UPDATE_ID ID | UPDATE_ID | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 417 | 하드코딩 | AddDateTimeColumn | UPDATE_TIME | UPDATE_TIME | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 418 | 하드코딩 | AddTextColumn | INSERT_ID | INSERT_ID | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 419 | 하드코딩 | AddDateTimeColumn | INSERT_TIME | INSERT_TIME | if(spreadInfo.SheetName == "Item Setup Attribute Type Definition") |
| InitSpread |  | 431 | 하드코딩 | AddTextColumn | Instance* | INSTANCE_NAME | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 432 | 하드코딩 | AddTextColumn | Operation* | OPERATION_ID | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 433 | 하드코딩 | AddTextColumn | Material* | ITEM_ID | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 434 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 435 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 436 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 437 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 438 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 439 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 440 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 441 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 442 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 443 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 444 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 445 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 446 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 447 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 448 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 450 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 452 | 하드코딩 | AddTextColumn | UPDATE ID | UPDATE_ID | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 453 | 하드코딩 | AddDateTimeColumn | UPDATE TIME | UPDATE_TIME | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 454 | 하드코딩 | AddTextColumn | INSERT ID | INSERT_ID | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 455 | 하드코딩 | AddDateTimeColumn | INSERT TIME | INSERT_TIME | if(spreadInfo.SheetName == "Item Setup Attribute Values") |
| InitSpread |  | 467 | 하드코딩 | AddTextColumn | Instance* | INSTANCE_NAME | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitSpread |  | 468 | 하드코딩 | AddTextColumn | Operation* | OPERATION_ID | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitSpread |  | 476 | 하드코딩 | AddComboColumn | Attribute Type | ATTRIBUTE_TYPE | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitSpread |  | 477 | 하드코딩 | AddTextColumn | Name | ATTRIBUTE_NAME | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitSpread |  | 478 | 하드코딩 | AddTextColumn | Attribute Option | ATTRIBUTE_LIST | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitSpread |  | 479 | 하드코딩 | AddTextColumn | Description | DESCRIPTION | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitSpread |  | 481 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitSpread |  | 483 | 하드코딩 | AddTextColumn | UPDATE ID | UPDATE_ID | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitSpread |  | 484 | 하드코딩 | AddDateTimeColumn | UPDATE TIME | UPDATE_TIME | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitSpread |  | 485 | 하드코딩 | AddTextColumn | INSERT ID | INSERT_ID | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitSpread |  | 486 | 하드코딩 | AddDateTimeColumn | INSERT TIME | INSERT_TIME | if(spreadInfo.SheetName == "Item Setup Attribute Type Option List") |
| InitializeComponent |  | 160 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 161 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 162 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 163 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 212 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 213 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 214 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 215 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 579 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 580 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 581 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 582 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Item Setup Attribute Type Definition | 코드 하드코딩 전용(메타 없음) | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |
| Item Setup Attribute Type Option List | 코드 하드코딩 전용(메타 없음) | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| Item Setup Attribute Values | 코드 하드코딩 전용(메타 없음) | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
