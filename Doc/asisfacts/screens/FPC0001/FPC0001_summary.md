# FPC0001 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0001_BuildingPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 584 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0001_BuildingPopup.Designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 457 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0001_ExcelImportPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1010 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0001_ExcelImportPopup.Designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 648 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0001_NamePopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 384 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0001_NamePopup.Designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 426 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0001_SqlPopup.Designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 262 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 354 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 354 | {?pServiceCallName} | UNRESOLVED |  |
| button:FindButton | FindButton > FindData | 358 | FP_Common.PR_UI_COMMON_POPUP | MATCH | SP PR_UI_COMMON_POPUP |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 354 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 354 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 463 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 463 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Excel | 605 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Excel | 605 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 714 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 714 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 354 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 354 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Excel | 605 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Excel | 605 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 358 | FP_Common.PR_UI_COMMON_POPUP | MATCH | SP PR_UI_COMMON_POPUP |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 354 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 354 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Buffer > Find_Validation > Find_Data_Validation | 463 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Buffer > Find_Validation > Find_Data_Validation | 463 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Buffer > Save_Data_Buffer | 714 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Buffer > Save_Data_Buffer | 714 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 754 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 754 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 354 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 354 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Excel | 605 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Excel | 605 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.cboSite.SelectedIndexChanged | cboSite_SelectedIndexChanged | 471 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 437 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 445 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 214 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 218 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 229 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 238 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 354 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 354 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.Load | Form_Load > FindData | 358 | FP_Common.PR_UI_COMMON_POPUP | MATCH | SP PR_UI_COMMON_POPUP |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?pServiceCallName} | UNRESOLVED | 5 |  |  |  |
| {?string.Empty} | UNRESOLVED | 5 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 3 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 2 |  |  |  |
| FP_Common.PR_UI_COMMON_POPUP | MATCH | 1 | SP PR_UI_COMMON_POPUP | EXEC:PR_UI_COMMON_POPUP | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnSelect_Click | row | NAME |
| CheckNullSpreadValidation | dtSheetColumn.Rows[iRow] | COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_NAME |
| FindData | Filter | NICK_NAME, NICK_NAME_LIKE |
| FindData | row | NAME |
| FindData | dm | CHK |
| InitControls | Filter | NICK_NAME_LIKE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:224, InitControls:234, FindData:337, FindData:338, FindData:340, clbDivision_SelectedIndexChanged:433, clbDivision_SelectedIndexChanged:441, cboSite_SelectedIndexChanged:461 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | CheckNullSpreadValidation:887 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.cboSite | SelectedIndexChanged | cboSite_SelectedIndexChanged | InitializeComponent:144 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:185 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:241 |
| this.clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | InitializeComponent:282 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:363 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:364 |
| this | Load | Form_Load | .ctor:134 |
| this | Load | Form_Load | .ctor:145 |
| this | Load | Form_Load | .ctor:156 |
| this | Load | Form_Load | .ctor:170 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:171 |
| this.btnExport | Click | btnExport_Click | InitializeComponent:222 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:295 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:334 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:373 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:412 |
| this | Load | Form_Load | .ctor:132 |
| popSql | OnSql | RunSqlSource | btnSql_Click:861 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:144 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:231 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:232 |
| this.panelBottom | SizeChanged | panelBottom_SizeChanged | InitializeComponent:284 |
| this.btnClear | Click | btnClear_Click | InitializeComponent:332 |
| this.btnSelect | Click | btnSelect_Click | InitializeComponent:370 |
| this | Load | Form_Load | .ctor:105 |
| this | Load | Form_Load | .ctor:116 |
| this | Load | Form_Load | .ctor:127 |
| this | Load | Form_Load | .ctor:141 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:95 |
| this.panel1 | SizeChanged | panel1_SizeChanged | InitializeComponent:124 |
| this.comboService | SelectedIndexChanged | comboService_SelectedIndexChanged | InitializeComponent:188 |
| this | Load | FPC0001_SqlPopup_Load | InitializeComponent:228 |

## 6. 컨트롤 (63개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 14 | layoutControlItem1, lblDivision, lblPlant, layoutControlItem2, layoutControlItem5, layoutControlItem6, layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem3, lblSql, layoutControlItem1, lblNickName, layService |
| UsrButton | 10 | btnSql, btnExport, btnClose, btnImport, btnSave, btnFind, usrButton1, btnClear, btnSelect, btnClose |
| UsrLayoutControl | 7 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1 |
| LayoutControlGroup | 7 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1 |
| Panel | 4 | panelBottom, panelBtn, panel1, panel2 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 3 | spdMain, spdComExcel, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdComExcel_Sheet1, spdMain_Sheet1 |
| UsrCombo | 2 | cboSite, comboService |
| UsrCheckedList | 2 | clbDivision, clbPlant |
| UsrButtonList | 1 | btnButtonList |
| ImageList | 1 | imageList1 |
| UsrLabel | 1 | lblSheetName |
| UsrTextBox | 1 | tbNickNameLike |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| RichTextBox | 1 | rtxtSQL |
| GroupControl | 1 | groupControl1 |
| ContextMenuStrip | 1 | contextMenuStrip1 |

## 7. 확인 필요 (10건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 354 | Find_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 354 | Find_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 463 | Find_Data_Validation | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 463 | Find_Data_Validation | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 605 | Save_Data_Excel | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 605 | Save_Data_Excel | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 714 | Save_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 714 | Save_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 754 | Delete_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 754 | Delete_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 7 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FPC0001 | BuildingPopup | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: BuildingPopup, {?this.sSheetName}, NamePopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:288, SetSheetHeaderColumn_FP@SetSpreadInit:220

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 380 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 381 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 382 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 383 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSheetHeaderWidth |  | 955 | 표시/라벨 변경 | set:Width | Width = {?sz.Width} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(Convert.ToInt32(siComExcel.ActiveSheet.Columns["0"].Width) == 0) |
| InitializeComponent |  | 561 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 562 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 563 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 564 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| FindData |  | 255 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(init) |
| FindData |  | 256 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(init) |
| FindData |  | 257 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(init) |
| InitializeComponent |  | 248 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 249 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 250 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 251 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| BuildingPopup | META+코드연결 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
