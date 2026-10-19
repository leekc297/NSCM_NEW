# SCP0132 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0132_ConstraintOfShipmentQty\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0132_ConstraintOfShipmentQty\SCP0132_ConstraintOfShipmentQty.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0132_ConstraintOfShipmentQty\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0132_ConstraintOfShipmentQty\SCP0132_ConstraintOfShipmentQty.csproj | 64 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0132_ConstraintOfShipmentQty\Properties\Settings.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0132_ConstraintOfShipmentQty\SCP0132_ConstraintOfShipmentQty.csproj | 27 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0132_ConstraintOfShipmentQty\SCP0132_ConstraintOfShipmentQty.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0132_ConstraintOfShipmentQty\SCP0132_ConstraintOfShipmentQty.csproj | 1125 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0132_ConstraintOfShipmentQty\SCP0132_ConstraintOfShipmentQty.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0132_ConstraintOfShipmentQty\SCP0132_ConstraintOfShipmentQty.csproj | 872 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 464 | SCP.SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY | MATCH | SP SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 464 | SCP.SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY | MATCH | SP SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY |
| button:SaveButton | SaveButton > SaveData | 814 | SCP.SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY | MATCH | SP SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY |
| event:this.Load | Form_Load > InitControls | 171 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtValidYn> | 50 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetSearchInfo | 217 | SCP.SCP0132_GET_SEARCH_INFO | MATCH | SP SCP0132_GET_SEARCH_INFO |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY | MATCH | 1 | SP SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY | EXEC:SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY, SELECT:SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY, REF:STRING_SPLIT |  |
| SCP.SCP0132_GET_SEARCH_INFO | MATCH | 1 | SP SCP0132_GET_SEARCH_INFO | EXEC:SCP0132_GET_SEARCH_INFO, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY, SELECT:SCP_MST_FINAL_ITEM |  |
| SCP.SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY | MATCH | 1 | SP SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY | EXEC:SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY, INSERT:SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY, UPDATE:SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY, DELETE:SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| SpdMain_ClipboardPasted | dtPlanGroup.Select().Where(c => c["NAME"].ToString() == siMain.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault() | CODE |
| SpdMain_ClipboardPasted | c | NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:171 | UsrComboBox.DataBind | CODE, NAME |
| GetCheckedListValue | RefreshPlanGroupByDivision:267, RefreshSiteByDivision:274, RefreshStageByDivision:294, RefreshStageByModelGroup:302, RefreshItemByDivision:310, FindData_Main:440, FindData_Main:441, FindData_Main:442 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumnSCP | InitSpread:344 | SpreadInfo.SetSheetHeaderColumnSCP | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:415 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:141 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:350 |
| this.spdMain | CellClick | spdMain_CellClick | InitEvent:351 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:352 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:353 |
| this.spdMain | EditChange | SpdMain_EditChange | InitEvent:354 |
| this.spdMain | KeyDown | SpdMain_KeyDown | InitEvent:355 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:356 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:358 |

## 6. 컨트롤 (32개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | lblCombo1, lblItemId, lblItemIdButton, lblPeriod, lblModelGroup, lblValid, lblStage, lblPlanGroup, lblFromSite, lblToSite |
| EmptySpaceItem | 5 | emptySpaceItem1, emptySpaceItem6, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4 |
| UsrCheckedList | 3 | clbPlanGroup, clbFromSite, clbToSite |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList2 | 2 | clbModelGroup, clbStage |
| UsrConditionPanel | 1 | pnlCondition |
| UsrCombo | 1 | cboDivision |
| UsrMultiLineEditor | 1 | txtItemId |
| UsrButton | 1 | btnItemId |
| UsrComboBox | 1 | cboValid |
| UsrDateRangePicker3 | 1 | dCalendar |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 27 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 23 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0132 | CONSTRAINT OF SHIPMENT QTY | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Constraint Of Shipment Qty
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumnSCP@InitSpread:344

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 604 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 605 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 606 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 607 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| CONSTRAINT OF SHIPMENT QTY | META+코드연결 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
