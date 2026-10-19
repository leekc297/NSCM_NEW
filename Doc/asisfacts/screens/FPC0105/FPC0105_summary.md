# FPC0105 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0105_ReportConfig_Popup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 630 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0105_ReportConfig_Popup.Designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 595 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| ctor:.ctor | .ctor > GetColumnSet | 224 | SCM.SCM0002_GET_TITLESET_POPUP | MATCH | SP SCM0002_GET_TITLESET_POPUP |
| event:this.usrButtonList1.UsrButtonList_Click_Detected | usrButtonList1_UsrButtonList_Click_Detected > SaveColumnSet | 342 | SCM.SCM0002_SET_TITLESET_POPUP | MATCH | SP SCM0002_SET_TITLESET_POPUP |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCM.SCM0002_GET_TITLESET_POPUP | MATCH | 1 | SP SCM0002_GET_TITLESET_POPUP | EXEC:SCM0002_GET_TITLESET_POPUP, EXEC:SCM0002_SET_DEFAULT_TITLESET_POPUP, REF:FN_SCM_SYS_NVL, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, INSERT:SCM_MST_TITLESET_USER |  |
| SCM.SCM0002_SET_TITLESET_POPUP | MATCH | 1 | SP SCM0002_SET_TITLESET_POPUP | EXEC:SCM0002_SET_TITLESET_POPUP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, DELETE:SCM_MST_TITLESET_USER, REF:SCM_ARR_SPL_VAL, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_MST_TITLESET_USER, UPDATE:SCM_MST_TITLESET_USER, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ColumnSetForm_Load | row | USER_SORT_ORDER_NO, USER_FLAG |
| ColumnSetForm_Load | spdDimension.Sheets[0].Columns | USER_FLAG |
| ColumnSetForm_Load | src_row | USER_SELECTABLE_FLAG |
| DoDimensionChange | sv.Columns | COLUMN_NAME, USER_FLAG |
| DoDimensionChange | colRow | USER_SORT_ORDER_NO, SORT_ORDER_NO |
| DoDimensionChange | row | USER_FLAG, VISIBLE_FLAG, VALID_YN |
| InitSheet | _dtColumnSet.Rows[0] | LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| InitSheet | spdMeasure.Sheets[0].Columns | COLUMN_LABEL_NAME, USER_SORT_METHOD_CODE, SUB_TOTAL_FLAG |
| SaveColumnSet | sv.Columns | USER_FLAG, COLUMN_NAME, USER_SORT_METHOD_CODE, SUB_TOTAL_FLAG |
| spdUser_ButtonClicked | sv.Columns | SUB_TOTAL_FLAG |
| spdUser_RowDragMove | sv.Columns | USER_SELECTABLE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | ColumnSetForm_Load:143 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.usrButtonList1 | UsrButtonList_Click_Detected | usrButtonList1_UsrButtonList_Click_Detected | InitializeComponent:195 |
| this.spdDimension | Change | spdDimension_Change | InitializeComponent:231 |
| this.spdDimension | RowDragMove | spdDimension_RowDragMove | InitializeComponent:232 |
| this.spdDimension | RowDragMoveCompleted | spdDimension_RowDragMoveCompleted | InitializeComponent:233 |
| this.spdDimension | CellClick | spdDimension_CellClick | InitializeComponent:234 |
| this.spdDimension | CellDoubleClick | spdDimension_CellDoubleClick | InitializeComponent:235 |
| this.spdDimension | ButtonClicked | spdDimension_ButtonClicked | InitializeComponent:236 |
| this.spdDimension | EditChange | spdDimension_EditChange | InitializeComponent:237 |
| this.spdDimension | EnabledChanged | spdDimension_EnabledChanged | InitializeComponent:238 |
| this.spdDimension | DragDrop | spdDimension_DragDrop | InitializeComponent:239 |
| this.pbBBDimension | Click | pbBBDimension_Click | InitializeComponent:274 |
| this.pbBDimension | Click | pbBDimension_Click | InitializeComponent:287 |
| this.pbTDimension | Click | pbTDimension_Click | InitializeComponent:300 |
| this.pbTTDimension | Click | pbTTDimension_Click | InitializeComponent:313 |
| this.spdMeasure | RowDragMove | spdUser_RowDragMove | InitializeComponent:346 |
| this.spdMeasure | RowDragMoveCompleted | spdUser_RowDragMoveCompleted | InitializeComponent:347 |
| this.spdMeasure | CellDoubleClick | spdUser_CellDoubleClick | InitializeComponent:348 |
| this.spdMeasure | ButtonClicked | spdUser_ButtonClicked | InitializeComponent:349 |
| this | Load | ColumnSetForm_Load | InitializeComponent:525 |
| this | SizeChanged | ColumnSetForm_SizeChanged | InitializeComponent:526 |
| ((CheckBoxCellType)(si.ActiveSheet.Columns[0, 0].CellType)) | EditorValueChanged | FPC0105_ReportConfig_Popup_EditorValueChanged | ColumnSetForm_Load:121 |

## 6. 컨트롤 (27개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| PictureBox | 8 | pbBBDimension, pbBDimension, pbTDimension, pbTTDimension, pbBBMeasure, pbBMeasure, pbTMeasure, pbTTMeasure |
| Panel | 5 | pnlBottom, panel1, panel5, panel2, panel4 |
| FpSpread | 3 | spdDimension, spdMeasure, spdSample |
| SheetView | 3 | spdBase_Sheet1, spdUser_Sheet1, spdSample_Sheet1 |
| UsrButtonList | 2 | usrButtonList2, usrButtonList1 |
| SplitContainer | 2 | splMain, splitContainer1 |
| Label | 2 | label1, label2 |
| CheckBox | 1 | cbMoveToFront |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 225 | DM_H.DMF0002_GET_TITLESET_POPUP | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sample, Dimension, Measure
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@ColumnSetForm_Load:144, SetSheetHeaderColumn_FP@DoDimensionChange:474
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| ColumnSetForm_Load | 0 | 124 | 표시/라벨 변경 | set:Locked | Locked = {?false} | USER_FLAG |  |
| ColumnSetForm_Load | 0 | 125 | 표시/라벨 변경 | set:BackColor | BackColor = {?ControlColor.UnLockColor} | USER_FLAG |  |
| ColumnSetForm_Load | 0 | 133 | 표시/라벨 변경 | set:Locked | Locked = {?true} | USER_FLAG | foreach(row in spdDimension.Sheets[0].Rows) ⟫ if(src_row["USER_SELECTABLE_FLAG"].ToString() == "N") |
| ColumnSetForm_Load | 0 | 134 | 표시/라벨 변경 | set:BackColor | BackColor = {?ControlColor.LockColor} | USER_FLAG | foreach(row in spdDimension.Sheets[0].Rows) ⟫ if(src_row["USER_SELECTABLE_FLAG"].ToString() == "N") |
| InitSheet | 0 | 184 | 하드코딩 | AddCheckColumn | USE | USER_FLAG |  |
| InitSheet | 0 | 185 | 하드코딩 | AddTextColumn | ColumnName | COLUMN_NAME |  |
| InitSheet | 0 | 186 | 하드코딩 | AddTextColumn | Column Name | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 187 | 하드코딩 | AddNumColumn | Seq | SORT_ORDER_NO |  |
| InitSheet | 0 | 188 | 하드코딩 | AddTextColumn | USER_SELECTABLE_FLAG | USER_SELECTABLE_FLAG |  |
| InitSheet | 0 | 189 | 표시/라벨 변경 | set:Locked | Locked = {?true} |  |  |
| InitSheet | 0 | 196 | 하드코딩 | AddTextColumn | ColumnName | COLUMN_NAME |  |
| InitSheet | 0 | 198 | 하드코딩 | AddTextColumn | LargeClass | LARGE_CLASS_LABEL_NAME |  |
| InitSheet | 0 | 199 | 하드코딩 | AddTextColumn | SmallClass | SMALL_CLASS_LABEL_NAME |  |
| InitSheet | 0 | 200 | 하드코딩 | AddTextColumn | Column | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 201 | 하드코딩 | AddTextColumn | Sort | SORT_METHOD_CODE |  |
| InitSheet | 0 | 202 | 하드코딩 | AddNumColumn | Seq | SORT_ORDER_NO |  |
| InitSheet | 0 | 203 | 하드코딩 | AddComboColumn | Sort | USER_SORT_METHOD_CODE |  |
| InitSheet | 0 | 204 | 하드코딩 | AddCheckColumn | Sub Total | SUB_TOTAL_FLAG |  |
| InitSheet | 0 | 206 | 하드코딩 | AddTextColumn | USER_SELECTABLE_FLAG | USER_SELECTABLE_FLAG |  |
| InitSheet | 0 | 208 | 표시/라벨 변경 | set:Locked | Locked = {?true} | COLUMN_LABEL_NAME |  |
| InitSheet | 0 | 209 | 표시/라벨 변경 | set:BackColor | BackColor = {?ControlColor.UnLockColor} | USER_SORT_METHOD_CODE \|\| SUB_TOTAL_FLAG |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 하드코딩 전용(메타 없음) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
