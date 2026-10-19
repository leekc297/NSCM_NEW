# SCP0046 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0046_ModelAllocation\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0046_ModelAllocation\SCP0046_ModelAllocation.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0046_ModelAllocation\SCP0046_ModelAllocation.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0046_ModelAllocation\SCP0046_ModelAllocation.csproj | 1392 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0046_ModelAllocation\SCP0046_ModelAllocation.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0046_ModelAllocation\SCP0046_ModelAllocation.csproj | 696 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > GetAllPrjRouteModelDivision | 381 | SCP.SCP0046_GET_AllInputModelAllocation_EX | MATCH | SP SCP0046_GET_AllInputModelAllocation_EX |
| button:FindButton | FindButton > FindData_Main | 729 | SCP.SCP0046_GET_MODEL_ALLOCATION | MATCH | SP SCP0046_GET_MODEL_ALLOCATION |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 1005 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:InsertButton | InsertButton > GetAllPrjRouteModelDivision | 381 | SCP.SCP0046_GET_AllInputModelAllocation_EX | MATCH | SP SCP0046_GET_AllInputModelAllocation_EX |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 729 | SCP.SCP0046_GET_MODEL_ALLOCATION | MATCH | SP SCP0046_GET_MODEL_ALLOCATION |
| button:SaveButton | SaveButton > SaveData_Main | 877 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveModelAllocation] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Main | 877 | SCP\Master\SCP0046_ModelAllocation#SaveModelAllocation | MATCH_PATTERN | SP SCP0046_SAVE_MODEL_ALLOCATION_DATASET |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle | 1005 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > SCM_SYS_LOG_BATCH | 1022 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.Load | Form_Load > CreateSpread > GetDayRange | 988 | SCM.SCM0001_GET_WEEK_MONDAY_PERIOD | MATCH | SP SCM0001_GET_WEEK_MONDAY_PERIOD |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1005 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | <field:dtValidYN> | 68 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetAllPrjRouteModel | 342 | SCP.SCP0046_GET_AllInputModelAllocation | MATCH | SP SCP0046_GET_AllInputModelAllocation |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveModelAllocation] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| SCM.SCM0001_GET_WEEK_MONDAY_PERIOD | MATCH | 1 | SP SCM0001_GET_WEEK_MONDAY_PERIOD | EXEC:SCM0001_GET_WEEK_MONDAY_PERIOD, REF:FN_NEXT_DAY, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0046_GET_AllInputModelAllocation | MATCH | 1 | SP SCP0046_GET_AllInputModelAllocation | EXEC:SCP0046_GET_ALLINPUTMODELALLOCATION, INSERT:#TMP_LIST, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_SITE, SELECT:#TMP_LIST, SELECT:SCM_MST_LINE_SN |  |
| SCP.SCP0046_GET_AllInputModelAllocation_EX | MATCH | 1 | SP SCP0046_GET_AllInputModelAllocation_EX | EXEC:SCP0046_GET_ALLINPUTMODELALLOCATION_EX, INSERT:#TMP_LIST, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_SITE, INSERT:#TMP_LINE, SELECT:SCM_MST_LINE_SN, SELECT:#TMP_LIST, SELECT:#TMP_LINE |  |
| SCP.SCP0046_GET_MODEL_ALLOCATION | MATCH | 1 | SP SCP0046_GET_MODEL_ALLOCATION | EXEC:SCP0046_GET_MODEL_ALLOCATION, INSERT:#TBLDYNAMIC_BASE_ROW, SELECT:SCP_MST_MODEL_ALLOCATION, SELECT:SCM_MST_ITEM_SN, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0046_GET_MODEL_ALLOCATION |  |
| SCP\Master\SCP0046_ModelAllocation#SaveModelAllocation | MATCH_PATTERN | 1 | SP SCP0046_SAVE_MODEL_ALLOCATION_DATASET | EXEC:SCP0046_SAVE_MODEL_ALLOCATION_DATASET, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SELECT:SCP_MST_MODEL_ALLOCATION, UPDATE:A, INSERT:SCP_MST_MODEL_ALLOCATION, INSERT:SCP_MST_MODEL_ALLOCATION_H, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetDTitem | drRow | CODE, NAME |
| GetDTitem | dr | ITEM_ID |
| SaveData_Main | dr | p_active_flag, p_division_id, p_cell_plant_site_id, p_cell_item_id, p_cell_line_id, p_elec_item_id, p_elec_plant_site_id, p_elec_line_id, p_tr_mode, p_yyyymmdd, p_valid_yn, p_user_id |
| SaveData_Main | result.Rows[0] | result_code, err_message |
| SpdMain_ClipboardPasted | drRow | CODE, NAME |
| SpdMain_ClipboardPasted | dr | PLANT_SITE_ID, SITE_DESCRIPTION, LINE_ID |
| SpdMain_ClipboardPasted | drPlant | CODE |
| SpdMain_ComboSelChange | drRow | CODE, NAME |
| SpdMain_ComboSelChange | dr | PLANT_SITE_ID, SITE_DESCRIPTION, LINE_ID |
| SpdMain_ComboSelChange | drPlant | CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | _supplyPlantSite:280, _pkgPlantSite:289, GetAllPrjRouteModelDivision:373, InsertRow:572, FindData_Main:704, FindData_Main:705, FindData_Main:707, FindData_Main:708 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:502 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:504 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:506 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:138 |
| clbDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:240 |
| clbSupplySite | SelectedIndexChanged | cboSupplySite_SelectedIndexChanged | InitEvent:241 |
| clbPKGSite | SelectedIndexChanged | cboPKGSite_SelectedIndexChanged | InitEvent:242 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:244 |
| btnItemId | Click | btnItemId_Click | InitEvent:246 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:252 |
| this.spdMain | ClipboardPasting | SpdMain_ClipboardPasting | InitEvent:253 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:254 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ClipboardPasted:1172 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ClipboardPasted:1187 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ClipboardPasted:1209 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ClipboardPasted:1220 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ComboSelChange:1278 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ComboSelChange:1293 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ComboSelChange:1315 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ComboSelChange:1328 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ComboSelChange:1363 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ComboSelChange:1375 |

## 6. 컨트롤 (26개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | layoutControlItem7, layoutControlItem1, layoutControlItem5, layoutControlItem6, layoutControlItem3, Division, layoutControlItem10, layoutControlItem2 |
| UsrCheckedList | 4 | clbPKGSite, clbSupplySite, clbPKGLine, clbSupplyLine |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem3 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrMultiLineEditor | 1 | txtCellItemId |
| UsrButton | 1 | btnItemId |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrCombo | 1 | clbDivision |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 877 | SaveData_Main | {?definition_path}#SaveModelAllocation | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 7 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 9 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 7 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 7 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 55 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0046 | Model Allocation | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Model Allocation
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:504
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 188 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 193 | DB루프 | AddComboColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 199 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 1053 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1058 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| InitializeComponent |  | 598 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 599 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 600 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 601 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Model Allocation | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
