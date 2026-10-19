# FPC0100 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0100_ExcelImportPopup_WIP.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1210 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0100_ExcelImportPopup_WIP.Designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 640 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0100_ExcelImportPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1173 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0100_ExcelImportPopup.Designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 648 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0100_QueryExcelPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 834 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0100_QueryExcelPopup.designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 573 |
| only | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\FPC0100_ExcelImportPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\FP00100_Line.UIL.csproj | 1226 |
| only | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\FPC0100_ExcelImportPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\FP00100_Line.UIL.csproj | 648 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 427 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 427 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 427 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 427 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 432 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 432 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 641 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 641 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 653 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 653 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 658 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 658 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 712 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 712 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 739 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 739 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 739 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 739 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 752 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 752 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 779 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 779 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 789 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 789 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 641 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 641 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 653 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 653 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 658 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 658 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 427 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 427 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 427 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 427 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 432 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 432 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 712 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 712 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 739 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 739 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 739 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 739 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 752 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 752 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 779 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 779 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 789 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 789 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 641 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 641 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 653 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 653 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 658 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 658 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 392 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 392 | {?pServiceCallName} | UNRESOLVED |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?pServiceCallName} | UNRESOLVED | 15 |  |  |  |
| {?string.Empty} | UNRESOLVED | 15 |  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnImport_Click | eR | ELECTRODE_TYPE |
| CheckNullDataTableValidation | dtSheetColumn.Rows[iRow] | COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO |
| CheckNullSpreadValidation | dtSheetColumn.Rows[iRow] | COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_NAME |
| DefaultKeyRowDataCheck | row | MESSAGE |
| SaveByImportData | dsMain.Tables[0].Rows[i] | USER_ID, JOB_ORDER |
| SaveByImportData | eachRow | _VALID |
| SaveByImportData | valrow | _VALID, _MSG |
| SaveByImportData | xlsrow | MESSAGE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | btnImport_Click:827, CheckNullSpreadValidation:959, CheckNullDataTableValidation:1005, btnImport_Click:862, CheckNullSpreadValidation:995, CheckNullDataTableValidation:1041, btnImport_Click:864, CheckNullSpreadValidation:1011 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnSql | Click | btnSql_Click | InitializeComponent:171 |
| this.btnExport | Click | btnExport_Click | InitializeComponent:222 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:295 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:334 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:373 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:412 |
| this | Load | Form_Load | .ctor:150 |
| popSql | OnSql | RunSqlSource | btnSql_Click:932 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:169 |
| this.btnExport | Click | btnExport_Click | InitializeComponent:219 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:291 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:329 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:367 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:405 |
| this | Load | Form_Load | .ctor:150 |
| popSql | OnSql | RunSqlSource | btnSql_Click:968 |
| this | Load | Form_Load | .ctor:128 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:160 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:213 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:254 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:295 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:336 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:421 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:422 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:171 |
| this.btnExport | Click | btnExport_Click | InitializeComponent:222 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:295 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:334 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:373 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:412 |
| this | Load | Form_Load | .ctor:150 |
| popSql | OnSql | RunSqlSource | btnSql_Click:984 |

## 6. 컨트롤 (87개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 27 | layoutControlItem5, layoutControlItem6, layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem3, lblSql, layoutControlItem5, layoutControlItem6, layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem3, lblSql, layoutControlItem2 … |
| UsrButton | 23 | btnSql, btnExport, btnClose, btnImport, btnSave, btnFind, btnSql, btnExport, btnClose, btnImport, btnSave, btnFind, btnSave, btnClose, btnFind … |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| ImageList | 4 | imageList1, imageList1, imageList1, imageList1 |
| UsrLabel | 4 | lblSheetName, lblSheetName, usrLabel2, lblSheetName |
| FpSpread | 4 | spdComExcel, spdComExcel, spdMain, spdComExcel |
| SheetView | 4 | spdComExcel_Sheet1, spdComExcel_Sheet1, spdMain_Sheet1, spdComExcel_Sheet1 |
| EmptySpaceItem | 1 | emptySpaceItem1 |

## 7. 확인 필요 (30건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 392 | Find_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 392 | Find_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 427 | Find_Data_Validation | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 427 | Find_Data_Validation | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 641 | Save_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 641 | Save_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 712 | Save_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 712 | Save_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 752 | Delete_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 752 | Delete_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 392 | Find_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 392 | Find_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 432 | Find_Data_Validation | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 432 | Find_Data_Validation | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 653 | Save_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 653 | Save_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 739 | Save_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 739 | Save_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 779 | Delete_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 779 | Delete_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 392 | Find_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 392 | Find_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 427 | Find_Data_Validation | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 427 | Find_Data_Validation | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 658 | Save_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 658 | Save_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 739 | Save_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 739 | Save_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 789 | Delete_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 789 | Delete_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 140 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FPC0100 | BuildingBODImport | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |
| SCM_MST_SHEET_COLUMNS | FPC0100 | LineExcelPopup | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |
| SCM_MST_SHEET_COLUMNS | FPC0100 | LineExcelPopup_WIP | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |
| SCM_MST_SHEET_COLUMNS | FPC0100 | LineImportExcelPopup | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |
| SCM_MST_SHEET_COLUMNS | FPC0100 | SCPTargetImport | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_COLUMNS | FPC0100 | SetupGroupImport | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | FPC0100 | ShippingPlanImportPopup | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: {?this.sSheetName}, ImportExcelPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:241

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit | 0 | 249 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(_arrHiddenColumns != null) ⟫ if(_arrHiddenColumns.Length > 0) ⟫ for(i < _arrHiddenColumns.Length) |
| SetSheetHeadColor |  | 1141 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.FromArgb(0, 113, 0)} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(sHeadName.IndexOf("*") >= 0) |
| SetSheetHeaderWidth |  | 1162 | 표시/라벨 변경 | set:Width | Width = {?sz.Width} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(Convert.ToInt32(siComExcel.ActiveSheet.Columns["0"].Width) == 0) |
| InitializeComponent |  | 553 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 554 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 555 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 556 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit | 0 | 249 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(_arrHiddenColumns != null) ⟫ if(_arrHiddenColumns.Length > 0) ⟫ for(i < _arrHiddenColumns.Length) |
| SetSheetHeadColor |  | 1105 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.FromArgb(0, 113, 0)} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(sHeadName.IndexOf("*") >= 0) |
| SetSheetHeaderWidth |  | 1125 | 표시/라벨 변경 | set:Width | Width = {?sz.Width} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(Convert.ToInt32(siComExcel.ActiveSheet.Columns["0"].Width) == 0) |
| InitializeComponent |  | 561 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 562 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 563 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 564 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| Find_Data_Import |  | 312 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(OnSearchData != null) ⟫ else!(dsSet == null) ⟫ if(AutoCHK) |
| Find_Data_Import |  | 313 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(OnSearchData != null) ⟫ else!(dsSet == null) ⟫ if(AutoCHK) |
| Find_Data_Import |  | 314 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(OnSearchData != null) ⟫ else!(dsSet == null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 438 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 439 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 440 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 441 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit | 0 | 249 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(_arrHiddenColumns != null) ⟫ if(_arrHiddenColumns.Length > 0) ⟫ for(i < _arrHiddenColumns.Length) |
| SetSheetHeadColor |  | 1157 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.FromArgb(0, 113, 0)} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(sHeadName.IndexOf("*") >= 0) |
| SetSheetHeaderWidth |  | 1178 | 표시/라벨 변경 | set:Width | Width = {?sz.Width} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(Convert.ToInt32(siComExcel.ActiveSheet.Columns["0"].Width) == 0) |
| InitializeComponent |  | 561 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 562 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 563 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 564 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| BuildingBODImport | 메타 정의만, 코드 미참조(미사용 가능) | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |
| LineExcelPopup | 메타 정의만, 코드 미참조(미사용 가능) | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |
| LineExcelPopup_WIP | 메타 정의만, 코드 미참조(미사용 가능) | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |
| LineImportExcelPopup | 메타 정의만, 코드 미참조(미사용 가능) | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 |
| SCPTargetImport | 메타 정의만, 코드 미참조(미사용 가능) | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |
| SetupGroupImport | 메타 정의만, 코드 미참조(미사용 가능) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| ShippingPlanImportPopup | 메타 정의만, 코드 미참조(미사용 가능) | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
