# FM0023 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FM0023_Setup_Group.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1313 |
| only | 06.UIL\GSCM.FP.Master.UIL\FM0023_Setup_Group.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 928 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FM0023_SetupGroupAddPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 628 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FM0023_SetupGroupAddPopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1414 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 1150 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 198 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 205 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Main > Find_Data_Main | 647 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > Find_Main > Find_Sub > Find_Data_Sub | 750 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Main | 647 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Sub | 750 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Main | 905 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Sub | 1082 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > Save_Main > Find_Main > Find_Data_Main | 647 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > Save_Sub > Find_Sub > Find_Data_Sub | 750 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > Save_Main > Save_Data_Main | 905 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > Save_Sub > Save_Data_Sub | 1082 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| event:this.btnRefreshSetup.Click | btnRefreshSetup_Click | 417 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| event:this.btnRefreshSetup.Click | btnRefreshSetup_Click > Find_Main > Find_Data_Main | 647 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| event:this.btnRefreshSetup.Click | btnRefreshSetup_Click > Find_Main > Find_Sub > Find_Data_Sub | 750 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Add | 374 | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY |  |
| event:this.btnSearchOperation.Click | btnSearchOperation_Click | 203 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 116 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 121 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 126 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 131 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 156 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 160 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 198 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 205 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY | 6 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 6 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnSearchOperation_Click | dRow | OPERATION_GROUP_ID, CODE, NAME, LEVEL, OPERATION_GROUP_NAME, DIVISION_ID, SITE_ID, OPERATION_ID |
| btnSubImport_Click | Application.OpenForms | FPC0100_ExcelImportPopup |
| cboCategory_SelectionChangeCommitted | dRow | OPERATION_GROUP_ID, CODE, NAME, LEVEL, OPERATION_GROUP_NAME, DIVISION_ID, SITE_ID, OPERATION_ID |
| InsertButton | Application.OpenForms | FM0023_SetupGroupAddPopup |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:195, SetChangedControl:202, InsertButton:327, InsertButton:328, InsertButton:329, btnRefreshSetup_Click:403, btnRefreshSetup_Click:404, btnRefreshSetup_Click:405 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitializeComponent:122 |
| this.btnRefreshSetup | Click | btnRefreshSetup_Click | InitializeComponent:338 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:379 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:629 |
| this.btnSubImport | Click | btnSubImport_Click | InitializeComponent:762 |
| this | Load | Form_Load | .ctor:105 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:126 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:127 |
| popSql | OnSql | RunSqlSource | btnSql_Click:514 |
| this | Load | Form_Load | .ctor:87 |
| popSql | OnSql | RunSqlSource | btnSql_Click:277 |
| this.btnSearchOperation | Click | btnSearchOperation_Click | InitializeComponent:305 |
| this.cboCategory | SelectionChangeCommitted | cboCategory_SelectionChangeCommitted | InitializeComponent:398 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:768 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:910 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:948 |

## 6. 컨트롤 (79개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 30 | layoutControlItem5, lblSql, layoutControlItem1, layoutControlItem3, layoutControlItem8, Site, layoutControlItem9, layoutControlItem11, layoutControlItem10, lblSql, layoutControlItem9, lbltxtRefOperation, layoutControlItem7, layoutControlItem13, layoutControlItem15 … |
| UsrLabel | 10 | usrLabel3, usrLabel1, usrLabel10, usrLabel9, usrLabel7, usrLabel4, usrLabel2, usrLabel1, usrLabel3, usrLabel5 |
| UsrCombo | 7 | cboCategory, cboOperation, cboSite, cboRefOperation, cboClass, cboCalculation, cboCategory |
| UsrButton | 6 | btnSql, btnSubImport, btnSearchOperation, btnSql, btnClose, btnSave |
| UsrTextBox | 5 | txtOperation, txtSite, txtRefOperation, txtClass, txtDivision |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup3, layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| ImageList | 2 | imageList1, imageList1 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrCheckedList2 | 1 | clbDivision |
| SimpleButton | 1 | btnRefreshSetup |
| EmptySpaceItem | 1 | emptySpaceItem7 |
| Panel | 1 | StockPanel |
| Splitter | 1 | splitter1 |

## 7. 확인 필요 (6건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 417 | btnRefreshSetup_Click | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 647 | Find_Data_Main | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 750 | Find_Data_Sub | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 905 | Save_Data_Main | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1082 | Save_Data_Sub | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 374 | Save_Data_Add | FP_Master.PR_UI_FM0023_SETUP_GROUP | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: spdMain, spdSub
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:238, SetSheetHeaderColumn_FP@InitSpread:255

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 246 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID | if(spreadInfo.SheetName == "spdMain") |
| InitSpread |  | 247 | 표시/라벨 변경 | set:Visible | Visible = {?false} | VALID_YN | if(spreadInfo.SheetName == "spdMain") |
| InitSpread |  | 260 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID | else!(spreadInfo.SheetName == "spdMain") ⟫ if(spreadInfo.SheetName == "spdSub") |
| InitSpread |  | 261 | 표시/라벨 변경 | set:Visible | Visible = {?false} | VALID_YN | else!(spreadInfo.SheetName == "spdMain") ⟫ if(spreadInfo.SheetName == "spdSub") |
| Find_Main | spdMain | 622 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| Find_Sub | spdSub | 737 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 138 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 139 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 140 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 141 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 645 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 646 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 647 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 648 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| spdMain | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| spdSub | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
