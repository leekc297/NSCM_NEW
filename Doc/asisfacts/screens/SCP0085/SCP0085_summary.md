# SCP0085 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0085_EndingInventory\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0085_EndingInventory\SCP0085_EndingInventory.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0085_EndingInventory\SCP0085_EndingInventory.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0085_EndingInventory\SCP0085_EndingInventory.csproj | 1148 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0085_EndingInventory\SCP0085_EndingInventory.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0085_EndingInventory\SCP0085_EndingInventory.csproj | 886 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:datePicker.ValueChanged | DatePicker_ValueChanged > GetSearchInfo | 238 | SCP.SCP0085_GET_SEARCH_INFO | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > Find_Data | 441 | SCP.SCP0085_GET_ENDING_INVENTORY | MATCH | SP SCP0085_GET_ENDING_INVENTORY |
| button:FindButton | FindButton > Find_Data | 441 | SCP.SCP0085_GET_ENDING_INVENTORY_DAILY | MATCH | SP SCP0085_GET_ENDING_INVENTORY_DAILY |
| event:monthPicker.ValueChanged | MonthPicker_ValueChanged > GetSearchInfo | 238 | SCP.SCP0085_GET_SEARCH_INFO | NOT_IN_FOXQUERY |  |
| event:RdoDate.CheckedChanged | rdButton_Changed > SetRadioControl > GetSearchInfo | 238 | SCP.SCP0085_GET_SEARCH_INFO | NOT_IN_FOXQUERY |  |
| event:RdoMonth.CheckedChanged | rdButton_Changed > SetRadioControl > GetSearchInfo | 238 | SCP.SCP0085_GET_SEARCH_INFO | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > SetRadioControl > GetSearchInfo | 238 | SCP.SCP0085_GET_SEARCH_INFO | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > InitControls > GetMonthRange | 498 | SCP.SCP0084_GET_MONTH_RANGE | MATCH | SP SCP0084_GET_MONTH_RANGE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCP.SCP0084_GET_MONTH_RANGE | MATCH | 1 | SP SCP0084_GET_MONTH_RANGE | EXEC:SCP0084_GET_MONTH_RANGE, SELECT:SCP_ANL_LONG_TERM_STOCK |  |
| SCP.SCP0085_GET_ENDING_INVENTORY | MATCH | 1 | SP SCP0085_GET_ENDING_INVENTORY | EXEC:SCP0085_GET_ENDING_INVENTORY, INSERT:#W_CELL_CF, SELECT:SCP_MST_ITEM_CELL_CF, INSERT:#W_CELL_CF_BOM, SELECT:SCM_MODEL_COMP_TEMP_SN, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_ITEM_CLASS_SN, INSERT:#W_SI, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_ITEM_CLASS_M, INSERT:#TMP_LAST, SELECT:#W_CELL_CF, SELECT:SCP_MST_FINAL_ITEM, SELECT:#W_CELL_CF_BOM, SELECT:W_SITE_LIST, SELECT:SCP_ANL_MONTH_END_STOCK_R, SELECT:#W_SI, REF:STRING_SPLIT, SELECT:W_ITEM_EE, SELECT:W_CELL_ASSY_SI, SELECT:SCM_PLANT_M_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_CELL_PROD_ASSY_MAP, SELECT:W_SCP_MST_CELL_PROD_ASSY_MAP, SELECT:#TMP_LAST |  |
| SCP.SCP0085_GET_ENDING_INVENTORY_DAILY | MATCH | 1 | SP SCP0085_GET_ENDING_INVENTORY_DAILY | EXEC:SCP0085_GET_ENDING_INVENTORY_DAILY, INSERT:#TMP_SCP_MST_CELL_PROD_ASSY_MAP, SELECT:SCP_MST_CELL_PROD_ASSY_MAP, INSERT:#W_CELL_CF, SELECT:SCP_MST_ITEM_CELL_CF, INSERT:#W_CELL_CF_BOM, SELECT:SCM_MODEL_COMP_TEMP_SN, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_ITEM_CLASS_SN, INSERT:#W_SI, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_ITEM_CLASS_M, SELECT:#TMP_SCP_MST_CELL_PROD_ASSY_MAP, SELECT:W_SITE_LIST, SELECT:#W_CELL_CF_BOM, SELECT:SCP_ANL_MONTH_END_STOCK_R_D, SELECT:#W_SI, SELECT:SCP_MST_FINAL_ITEM, SELECT:#W_CELL_CF, REF:STRING_SPLIT, SELECT:W_ITEM_EE, SELECT:W_CELL_ASSY_SI, SELECT:SCM_PLANT_M_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0085_GET_SEARCH_INFO | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCP_ANL_MONTH_END_STOCK_R, SELECT:SCP_ANL_MONTH_END_STOCK_R_D |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| SetMonthRange | dtMonthRange.Rows[0] | MAX_YYYYMM |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:252, RefreshProfitByDivisionPlant:269, RefreshProfitByDivisionPlant:273, Find_Data:413, Find_Data:414, Find_Data:415, Find_Data:417 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | SetSpreadInit:330 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:175 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:365 |
| clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | InitEvent:366 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:368 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:369 |
| RdoMonth | CheckedChanged | rdButton_Changed | InitEvent:371 |
| RdoDate | CheckedChanged | rdButton_Changed | InitEvent:372 |
| datePicker | ValueChanged | DatePicker_ValueChanged | InitEvent:373 |
| monthPicker | ValueChanged | MonthPicker_ValueChanged | InitEvent:374 |
| chkDetail | CheckedChanged | ChkDetail_CheckedChanged | InitEvent:375 |

## 6. 컨트롤 (31개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 11 | layoutDivision1, layMonth, layoutPlant1, lblItemId, layoutControlItem4, layoutRdoMonth, layoutRdoDate, layDate, layoutControlItem1, layoutProfit, layItemType |
| UsrCheckedList2 | 4 | cboDivision, clbPlant, clbItemType, cboProfit |
| EmptySpaceItem | 4 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem3, emptySpaceItem6 |
| UsrRadio | 2 | RdoMonth, RdoDate |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkDetail |
| UsrMonthPicker | 1 | monthPicker |
| UsrMultiLineEditor | 1 | txtItem_Id |
| UsrButton | 1 | btnItem_Id |
| UsrDatePicker | 1 | datePicker |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 238 | GetSearchInfo | SCP.SCP0085_GET_SEARCH_INFO | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCP_ANL_MONTH_END_STOCK_R, SELECT:SCP_ANL_MONTH_END_STOCK_R_D · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 133 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 99 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 37 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 10 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 64 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0085 | Ending Inventory Main | 56/0 | 56/0 | 56/0 | 56/0 | 56/0 | 56/0 | 56/0 | 56/0 | 56/0 | 56/0 | 56/0 | 56/0 | 56/0 | 56/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Ending Inventory Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:330
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetHeaderViewDetail |  | 591 | 표시/라벨 변경 | set:Visible | Visible = {?true} | UNRESTRICTED_QTY | if(isHeaderViewDetail) |
| SetHeaderViewDetail |  | 592 | 표시/라벨 변경 | set:Visible | Visible = {?true} | BLOCKED_STOCK | if(isHeaderViewDetail) |
| SetHeaderViewDetail |  | 593 | 표시/라벨 변경 | set:Visible | Visible = {?true} | IN_TRANSIT | if(isHeaderViewDetail) |
| SetHeaderViewDetail |  | 597 | 표시/라벨 변경 | set:Visible | Visible = {?false} | UNRESTRICTED_QTY | else!(isHeaderViewDetail) |
| SetHeaderViewDetail |  | 598 | 표시/라벨 변경 | set:Visible | Visible = {?false} | BLOCKED_STOCK | else!(isHeaderViewDetail) |
| SetHeaderViewDetail |  | 599 | 표시/라벨 변경 | set:Visible | Visible = {?false} | IN_TRANSIT | else!(isHeaderViewDetail) |
| SetHeaderDaily |  | 704 | 표시/라벨 변경 | set:Visible | Visible = {?false} | YYYYMMDD | if(siMain != null) ⟫ if(RdoMonth.Checked) |
| SetHeaderDaily |  | 705 | 표시/라벨 변경 | set:Visible | Visible = {?true} | VALUATION_TYPE | if(siMain != null) ⟫ if(RdoMonth.Checked) |
| SetHeaderDaily |  | 709 | 표시/라벨 변경 | set:Visible | Visible = {?true} | YYYYMMDD | if(siMain != null) ⟫ else!(RdoMonth.Checked) |
| SetHeaderDaily |  | 710 | 표시/라벨 변경 | set:Visible | Visible = {?false} | VALUATION_TYPE | if(siMain != null) ⟫ else!(RdoMonth.Checked) |
| SetHeaderDivision |  | 724 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CELL_TYPE_GR | if(div.Contains("40")) |
| SetHeaderDivision |  | 728 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_TYPE_GR | else!(div.Contains("40")) |
| SetLayout |  | 746 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M1_QUANTITY)} | M1_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 747 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M2_QUANTITY)} | M2_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 748 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M3_QUANTITY)} | M3_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 749 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M4_QUANTITY)} | M4_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 750 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M5_QUANTITY)} | M5_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 751 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M6_QUANTITY)} | M6_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 752 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M7_QUANTITY)} | M7_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 753 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M8_QUANTITY)} | M8_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 754 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M9_QUANTITY)} | M9_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 755 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M10_QUANTITY)} | M10_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 756 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M11_QUANTITY)} | M11_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 757 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M12_QUANTITY)} | M12_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 758 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M13_QUANTITY)} | M13_QUANTITY | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 759 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M1_AMOUNT)} | M1_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 760 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M2_AMOUNT)} | M2_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 761 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M3_AMOUNT)} | M3_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 762 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M4_AMOUNT)} | M4_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 763 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M5_AMOUNT)} | M5_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 764 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M6_AMOUNT)} | M6_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 765 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M7_AMOUNT)} | M7_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 766 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M8_AMOUNT)} | M8_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 767 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M9_AMOUNT)} | M9_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 768 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M10_AMOUNT)} | M10_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 769 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M11_AMOUNT)} | M11_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 770 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M12_AMOUNT)} | M12_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 771 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M13_AMOUNT)} | M13_AMOUNT | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 772 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M1_AMOUNT_KRW)} | M1_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 773 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M2_AMOUNT_KRW)} | M2_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 774 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M3_AMOUNT_KRW)} | M3_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 775 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M4_AMOUNT_KRW)} | M4_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 776 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M5_AMOUNT_KRW)} | M5_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 777 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M6_AMOUNT_KRW)} | M6_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 778 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M7_AMOUNT_KRW)} | M7_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 779 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M8_AMOUNT_KRW)} | M8_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 780 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M9_AMOUNT_KRW)} | M9_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 781 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M10_AMOUNT_KRW)} | M10_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 782 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M11_AMOUNT_KRW)} | M11_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 783 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M12_AMOUNT_KRW)} | M12_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetLayout |  | 784 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.M13_AMOUNT_KRW)} | M13_AMOUNT_KRW | if(siMain.ActiveSheet.SheetName.Equals("Ending Inventory Main")) |
| SetSheetVisible |  | 843 | 표시/라벨 변경 | set:Visible | Visible = {?isVisible_Sheet} |  | for(i >= 0) ⟫ switch(columnName)case "CELL_CONVER_FACTOR"/"CELL_CONVER_QUANTITY" |
| SetSheetVisible |  | 847 | 표시/라벨 변경 | set:Visible | Visible = {?isVisible_Excel} |  | for(i >= 0) ⟫ switch(columnName)case "CELL_CONVER_FACTOR_XLS"/"CELL_CONVER_QUANTITY_XLS" |
| ExportExcelData |  | 938 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ switch(columnName)case "CELL_CONVER_FACTOR"/"CELL_CONVER_QUANTITY"/"QUANTITY"/"AMOUNT"/"AMOUNT_KRW"/"UNIT_PRICE"/"UNIT_PRICE_KRW" |
| ExportExcelData |  | 950 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ switch(columnName)case "CELL_CONVER_FACTOR_XLS"/"CELL_CONVER_QUANTITY_XLS"/"CELL_CF"/"CELL_CF_BOM"/"USE_CELL_CF_BOM"/"QUANTITY_XLS"/"AMOUNT_XLS"/"AMOUNT_KRW_XLS"/"UNIT_PRICE_XLS"/"UNIT_PRICE_KRW_XLS" |
| ExportExcelData |  | 1013 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcelData |  | 1054 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 773 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 774 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 775 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 776 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Ending Inventory Main | META+코드연결 | 78 (?44) | 77 (?44) | 77 (?44) | 77 (?44) | 77 (?44) | 77 (?44) | 77 (?44) | 77 (?44) | 77 (?44) | 77 (?44) | 77 (?44) | 77 (?44) | 77 (?44) | 77 (?44) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 84, 런타임:화면컨트롤값 56 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 140건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
