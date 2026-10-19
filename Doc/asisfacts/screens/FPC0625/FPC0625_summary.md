# FPC0625 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FPC0625_AttrOptionEditPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.UIL.csproj | 327 |
| only | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FPC0625_AttrOptionEditPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.UIL.csproj | 342 |
| only | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FPC0625_AttrOptionEditPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FP00466_Item_Setup_Attr.UIL.csproj | 772 |
| only | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FPC0625_AttrOptionEditPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FP00466_Item_Setup_Attr.UIL.csproj | 474 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > Find_Data_Item | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Item | 238 | FP\Master\FP00466_ItemSetupAttr#get_material_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_material_list.sql |
| button:SaveButton | SaveButton > GoSave > FindDataAttrList > FindAttrList | 420 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > FindDataAttrList > FindAttrList | 420 | FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql |
| button:SaveButton | SaveButton > GoSave > SaveAttrList | 539 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > SaveAttrList | 539 | FP\Master\FP00466_ItemSetupAttr#save_item_group_list | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > GoSave > SaveAttrList | 540 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > GoSave > SaveAttrList | 540 | FP\Master\FP00466_ItemSetupAttr#delete_item_group_list | MATCH | [update-batch]  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Item | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Item | 238 | FP\Master\FP00466_ItemSetupAttr#get_material_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_material_list.sql |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > GoSave > FindDataAttrList > FindAttrList | 420 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > GoSave > FindDataAttrList > FindAttrList | 420 | FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > GoSave > SaveAttrList | 539 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_list] | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > GoSave > SaveAttrList | 539 | FP\Master\FP00466_ItemSetupAttr#save_item_group_list | MATCH | [update-batch]  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > GoSave > SaveAttrList | 540 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_list] | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > GoSave > SaveAttrList | 540 | FP\Master\FP00466_ItemSetupAttr#delete_item_group_list | MATCH | [update-batch]  |
| event:this.Load | Form_Load > FindData > Find_Data_Item | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Item | 238 | FP\Master\FP00466_ItemSetupAttr#get_material_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_material_list.sql |
| event:this.Load | Form_Load > FindDataAttrList > FindAttrList | 420 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindDataAttrList > FindAttrList | 420 | FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 34 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_list] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_list] | BIZ_MATCH | 1 |  |  |  |
| FP\Master\FP00466_ItemSetupAttr#delete_item_group_list | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00466_ItemSetupAttr#get_attr_list | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_attr_list.sql | SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_LIST_M, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_TYPE_M |  |
| FP\Master\FP00466_ItemSetupAttr#get_material_list | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_material_list.sql | SELECT:SCM_ITEM_M, SELECT:FP_INSTANCE_LINE_V, SELECT:USER_SHOP, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Master\FP00466_ItemSetupAttr#save_item_group_list | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| FindAttrList | Filter | LOOKUP_TYPE_CODE, USER_ID |
| FindAttrList | s | ATTRIBUTE_TYPE |
| InitSpread | eachAttr | CODE, NAME |
| SaveAttrList | rSave.Rows[0] | COUNT |
| SaveAttrList | rRemove.Rows[0] | COUNT |
| SaveAttrList | rRow | RESULT, COUNT |
| txtMaterial_TextChanged | Filter | ITEM_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetFilter | FindDataAttrList:343 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| FP_PseudoBatch | SaveAttrList:539, SaveAttrList:540 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:94 |
| this.txtMaterial | TextChanged | txtMaterial_TextChanged | InitializeComponent:138 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:196 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:252 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:253 |
| this.txtInstance | TextChanged | txtMaterial_TextChanged | InitializeComponent:151 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:227 |
| this.spdList | CellClick | spdMain_CellClick | InitializeComponent:378 |
| this.spdList | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:379 |
| this | Load | Form_Load | .ctor:145 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 6 | layoutControlItem1, layoutControlItem4, layoutControlItem1, Instance, layoutControlItem2, layoutControlItem5 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrTextBox | 4 | txtMaterial, txtInstance, txtOperation, txtName |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem1 |
| FpSpread | 2 | spdMain, spdList |
| SheetView | 2 | spdMain_Sheet1, spdList_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ItemPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:152, SetSheetHeaderColumn_FP@SetSpreadInit:205

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 269 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 270 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 271 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 272 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread | ItemPopup | 283 | 하드코딩 | AddTextColumn | Instance* | INSTANCE_NAME |  |
| InitSpread | ItemPopup | 284 | 하드코딩 | AddTextColumn | Operation* | OPERATION_ID |  |
| InitSpread | ItemPopup | 292 | 하드코딩 | AddComboColumn | Attribute Type | ATTRIBUTE_TYPE |  |
| InitSpread | ItemPopup | 293 | 하드코딩 | AddTextColumn | Name | ATTRIBUTE_NAME |  |
| InitSpread | ItemPopup | 294 | 하드코딩 | AddTextColumn | Attribute Option | ATTRIBUTE_LIST |  |
| InitSpread | ItemPopup | 295 | 하드코딩 | AddTextColumn | Description | DESCRIPTION |  |
| InitSpread | ItemPopup | 297 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG |  |
| InitSpread | ItemPopup | 299 | 하드코딩 | AddTextColumn | UPDATE ID | UPDATE_ID |  |
| InitSpread | ItemPopup | 300 | 하드코딩 | AddDateTimeColumn | UPDATE TIME | UPDATE_TIME |  |
| InitSpread | ItemPopup | 301 | 하드코딩 | AddTextColumn | INSERT ID | INSERT_ID |  |
| InitSpread | ItemPopup | 302 | 하드코딩 | AddDateTimeColumn | INSERT TIME | INSERT_TIME |  |
| InitializeComponent |  | 395 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 396 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 397 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 398 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ItemPopup | 코드 하드코딩 전용(메타 없음) | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
