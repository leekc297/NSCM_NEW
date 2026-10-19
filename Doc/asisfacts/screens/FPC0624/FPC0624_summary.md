# FPC0624 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0624_WorkCenterOperationByInstPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 559 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0624_WorkCenterOperationByInstPopup.Designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 516 |
| only | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FPC0624_ItemByInstancePopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FP00466_Item_Setup_Attr.UIL.csproj | 327 |
| only | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FPC0624_ItemByInstancePopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00466_Item_Setup_Attr.UIL\FP00466_Item_Setup_Attr.UIL.csproj | 342 |
| only | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00902_Item_Setup_Attr.UIL\FPC0624_ItemByInstancePopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00902_Item_Setup_Attr.UIL\FP00902_Item_Setup_Attr.UIL.csproj | 327 |
| only | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00902_Item_Setup_Attr.UIL\FPC0624_ItemByInstancePopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00902_Item_Setup_Attr.UIL\FP00902_Item_Setup_Attr.UIL.csproj | 342 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 442 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 410 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 418 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Item | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Item | 238 | FP\Master\FP00466_ItemSetupAttr#get_material_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_material_list.sql |
| button:FindButton | FindButton > FindData > Find_Data_Item | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Item | 238 | FP\Master\FP00902_ItemSetupAttr#get_material_list | MATCH | [sql] foxquery_sql\FP_Master_FP00902_ItemSetupAttr_get_material_list.sql |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Item | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Item | 238 | FP\Master\FP00466_ItemSetupAttr#get_material_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_material_list.sql |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Item | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Item | 238 | FP\Master\FP00902_ItemSetupAttr#get_material_list | MATCH | [sql] foxquery_sql\FP_Master_FP00902_ItemSetupAttr_get_material_list.sql |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 339 | FP_Common.PR_UI_COMMON_POPUP | MATCH | SP PR_UI_COMMON_POPUP |
| event:this.Load | Form_Load > InitControls | 232 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Item | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Item | 238 | FP\Master\FP00466_ItemSetupAttr#get_material_list | MATCH | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_material_list.sql |
| event:this.Load | Form_Load > FindData > Find_Data_Item | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Item | 238 | FP\Master\FP00902_ItemSetupAttr#get_material_list | MATCH | [sql] foxquery_sql\FP_Master_FP00902_ItemSetupAttr_get_material_list.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] | BIZ_MATCH | 2 |  |  |  |
| FP_Common.PR_UI_COMMON_POPUP | MATCH | 1 | SP PR_UI_COMMON_POPUP | EXEC:PR_UI_COMMON_POPUP | ⚠ DB에 SP 없음 |
| FP\Master\FP00466_ItemSetupAttr#get_material_list | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00466_ItemSetupAttr_get_material_list.sql | SELECT:SCM_ITEM_M, SELECT:FP_INSTANCE_LINE_V, SELECT:USER_SHOP, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Master\FP00902_ItemSetupAttr#get_material_list | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00902_ItemSetupAttr_get_material_list.sql | SELECT:SCM_ITEM_M, SELECT:FP_INSTANCE_LINE_V, SELECT:USER_SHOP, SELECT:FP_USER_ROLE_INFO_V |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| txtMaterial_TextChanged | Filter | ITEM_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | FindData:321, FindData:322, FindData:323, ClbDivision_SelectedIndexChanged:406, ClbDivision_SelectedIndexChanged:414, CboSite_SelectedIndexChanged:432, CboSite_SelectedIndexChanged:437 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.txtMaterial | TextChanged | txtMaterial_TextChanged | InitializeComponent:138 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:196 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:252 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:253 |
| this | Load | Form_Load | .ctor:94 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:320 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:417 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:418 |
| this | Load | Form_Load | .ctor:149 |
| this | Load | Form_Load | .ctor:168 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:251 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:252 |
| this.txtMaterial | TextChanged | txtMaterial_TextChanged | InitializeComponent:138 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:196 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:252 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:253 |
| this | Load | Form_Load | .ctor:94 |

## 6. 컨트롤 (42개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | layoutControlItem1, layoutControlItem4, layoutControlItem1, layoutControlItem2, lblFactory, layoutControlItem4, layoutControlItem3, layoutControlItem1, layoutControlItem4 |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrTextBox | 3 | txtMaterial, txtOperation, txtMaterial |
| UsrButtonList | 3 | btnButtonList, btnButtonList, btnButtonList |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem1 |
| FpSpread | 3 | spdMain, spdMain, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrCombo | 2 | cboFactory, cboSite |
| UsrCheckedList2 | 1 | clbDivision |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 3 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FPC0624 | ItemPopup | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ItemPopup, WorkCenterOperationPopup || {?pSheetName}
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:152, SetSheetHeaderColumn_FP@SetSpreadInit:296

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 434 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 435 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 436 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 437 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 269 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 270 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 271 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 272 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 269 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 270 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 271 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 272 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ItemPopup | META+코드연결 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
