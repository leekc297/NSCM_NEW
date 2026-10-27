# AS-IS 액션 대조표 — SCP0093

> 원천: `Doc/asisfacts/screens/SCP0093/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 941행 · 메서드 104 · 종류 DATA_OP 192 · FLAG 167 · UI_PROP 124 · CALL_EXT 82 · RETURN 76 · GRID_INIT 65 · GRID_SET 40 · ENDPOINT 33 · POPUP 30 · UI_MISC 23 · MESSAGE 22 · VALUE_SET 19 · STATE 18 · GRID_LOCK 16 · LIST_REBIND 11 · VALIDATE 8 · GRID_BIND 5 · LIST_BIND 5 · LIST_CLEAR 3 · GRID_CLEAR 1 · THROW 1 · ⚠ 의미 확인 필요 82


## SCP0093_Chart.GetChart_Title

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a141e4c | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:3045 |  | RETURN | return chartTitle; |  | 처리 중단/반환 |  |  |  |

## SCP0093_Chart.SecondaryAxisY_RemoveAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d6c94f8 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:3069 | try ▸ for (i < cnt) | DATA_OP | ((XYDiagram)chart.Diagram).SecondaryAxesY.RemoveAt | (0) | 데이터 객체 조작/조회 |  |  |  |

## SCP0093_Chart.Series_Remove

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a08ab32 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:3056 | try ▸ if (series != null) | DATA_OP | chart.Series.Remove | (series) | 데이터 객체 조작/조회 |  |  |  |

## SCP0093_Chart.SetChart_AxisY

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9914604f | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:3032 | try | CALL_EXT | ((XYDiagram)chart.Diagram).AxisY.WholeRange.SetMinMaxValues | (AxisY_RangeMin, AxisY_RangeMax) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a06b759 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:3033 | try | UI_PROP | ((XYDiagram)chart.Diagram).AxisY.NumericScaleOptions.GridSpacing | AxisY_gridSpacing | 속성 GridSpacing 설정 |  |  |  |
| AC-fe83d956 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:3034 | try | STATE | ((XYDiagram)chart.Diagram).AxisY.GridLines.Visible | AxisY_gridLineVisible | 컨트롤 상태 Visible |  |  |  |
| AC-4db2eb14 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:3035 | try | STATE | ((XYDiagram)chart.Diagram).AxisY.Label.Visible | AxisY_labelVisible | 컨트롤 상태 Visible |  |  |  |

## SCP0093_Chart.SetChart_Title

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0278f96 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:3049 |  | FLAG | chartTitle | title | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.BtnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95ed3921 | this.btnItemId.Click | SCP0093_DIO_Trend_Report.cs:2876 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d53f500e | this.btnItemId.Click | SCP0093_DIO_Trend_Report.cs:2877 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-fab1ba8a | this.btnItemId.Click | SCP0093_DIO_Trend_Report.cs:2878 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1f537642 | this.btnItemId.Click | SCP0093_DIO_Trend_Report.cs:2879 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d35c1594 | this.btnItemId.Click | SCP0093_DIO_Trend_Report.cs:2885 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77cd6a7c | this.btnMeasure.Click | SCP0093_DIO_Trend_Report.cs:2892 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0093", measure, false) | 팝업/폼 생성 |  |  |  |
| AC-a563a178 | this.btnMeasure.Click | SCP0093_DIO_Trend_Report.cs:2893 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9876d099 | this.btnMeasure.Click | SCP0093_DIO_Trend_Report.cs:2894 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d2581aaa | this.btnMeasure.Click | SCP0093_DIO_Trend_Report.cs:2898 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-11860674 | this.btnMeasure.Click | SCP0093_DIO_Trend_Report.cs:2901 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.CalculateYield

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0)] / FindButton [if (this.spdMain.Visible) ▸ finally ▸ if (ScpUtils.CheckDataEmpty(ds) == false) ▸ if (ds.Tables[0].Rows.Count > 0)] / EditButton [if (IsEditMode == false) ▸ try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-931fb1e0 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 3 | SCP0093_DIO_Trend_Report.cs:1752 | for (i < siMain.ActiveSheet.RowCount) ▸ if (ScpUtils.CheckDataEmpty(cell_yield) == false && ScpUtils.GetValue(cell_yield.Value) != chkVal) | CALL_EXT | ScpUtils.GetValueDecimal | (cell_yield.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a8317de | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 3 | SCP0093_DIO_Trend_Report.cs:1753 | for (i < siMain.ActiveSheet.RowCount) ▸ if (ScpUtils.CheckDataEmpty(cell_yield) == false && ScpUtils.GetValue(cell_yield.Value) != chkVal) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefMainColumns.YIELD)].Value | dVal * 100 | 그리드 속성/값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.CboBucketType_SelectedIndexChanged

진입점: cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1eeed7f3 | cboBucketType.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2710 | if (siMain != null) | FLAG | sBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.CboDisplay_SelectedIndexChanged

진입점: cboDisplay.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05e109b6 | cboDisplay.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2729 | if (cboDisplay.SelectedIndex == 2) | UI_PROP | this.splitContainer1.Panel1MinSize | 0 | 속성 Panel1MinSize 설정 |  |  |  |
| AC-57b67f5e | cboDisplay.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2730 | if (cboDisplay.SelectedIndex == 2) | UI_PROP | splitContainer1.SplitterDistance | 0 | 속성 SplitterDistance 설정 |  |  |  |
| AC-16384519 | cboDisplay.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2737 | else of (cboDisplay.SelectedIndex == 2) ▸ if (cboDisplay.SelectedIndex == 1) | UI_PROP | this.splitContainer1.Panel1MinSize | 100 | 속성 Panel1MinSize 설정 |  |  |  |
| AC-9dd3ae89 | cboDisplay.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2738 | else of (cboDisplay.SelectedIndex == 2) ▸ if (cboDisplay.SelectedIndex == 1) | UI_PROP | splitContainer1.SplitterDistance | 750 | 속성 SplitterDistance 설정 |  |  |  |
| AC-d3d23b46 | cboDisplay.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2745 | else of (cboDisplay.SelectedIndex == 2) ▸ else of (cboDisplay.SelectedIndex == 1) | UI_PROP | this.splitContainer1.Panel1MinSize | 100 | 속성 Panel1MinSize 설정 |  |  |  |
| AC-ea86cb41 | cboDisplay.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2746 | else of (cboDisplay.SelectedIndex == 2) ▸ else of (cboDisplay.SelectedIndex == 1) | UI_PROP | splitContainer1.SplitterDistance | 270 | 속성 SplitterDistance 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d16d28da | cboDivision.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2665 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0093_DIO_Trend_Report.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08b18be5 | cboPlanDate.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2701 |  | FLAG | PLAN_DATE | cboPlanDate.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-21056d31 | cboPlanDate.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2702 |  | FLAG | PLAN_DATE_YYYYMM | ScpUtils.GetPlanDateYearMonth(cboPlanDate) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a51cdf2 | cboPlanDate.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2702 |  | CALL_EXT | ScpUtils.GetPlanDateYearMonth | (cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0093_DIO_Trend_Report.CboSearchType_SelectedIndexChanged

진입점: cboSearchType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b25aaac6 | cboSearchType.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2685 | if (cboSearchType.ControlValues.Equals("CG")) | STATE | txtItemId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d55fb559 | cboSearchType.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2687 | else of (cboSearchType.ControlValues.Equals("CG")) | STATE | txtItemId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0093_DIO_Trend_Report.CboUnitAmount_SelectedIndexChanged

진입점: cboUnitAmount.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c57211d0 | cboUnitAmount.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2753 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.CboUnitQty_SelectedIndexChanged

진입점: cboUnitQty.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f635615a | cboUnitQty.SelectedIndexChanged | SCP0093_DIO_Trend_Report.cs:2763 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.ChartDataPivot

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (measure.aggr_dv.Equals("ET")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49bd2c02 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2370 | try ▸ if (ScpUtils.CheckDataEmpty(dtChartData) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b8fba02 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2372 | try | DATA_OP | dtChartData.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fa8dd94e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2383 | try ▸ for (i < dtCopy.Rows.Count) ▸ for (j < dtCopy.Columns.Count) | CALL_EXT | ScpUtils.GetColumnName | (dtCopy, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5023f8b3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2390 | try ▸ for (i < dtCopy.Rows.Count) ▸ for (j < dtCopy.Columns.Count) ▸ if (ColumnName.StartsWith("M_") == true \|\| ColumnName.StartsWith("W_"… | DATA_OP | dtReturn.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e317969a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2391 | try ▸ for (i < dtCopy.Rows.Count) ▸ for (j < dtCopy.Columns.Count) ▸ if (ColumnName.StartsWith("M_") == true \|\| ColumnName.StartsWith("W_"… | DATA_OP | row["yyyymm"] | ReturnColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-76f45ac2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2392 | try ▸ for (i < dtCopy.Rows.Count) ▸ for (j < dtCopy.Columns.Count) ▸ if (ColumnName.StartsWith("M_") == true \|\| ColumnName.StartsWith("W_"… | DATA_OP | row["value"] | CellValue | 행/컬럼 값 대입 |  |  |  |
| AC-1e4d7395 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2393 | try ▸ for (i < dtCopy.Rows.Count) ▸ for (j < dtCopy.Columns.Count) ▸ if (ColumnName.StartsWith("M_") == true \|\| ColumnName.StartsWith("W_"… | DATA_OP | row["DATA_TYPE"] | measure | 행/컬럼 값 대입 |  |  |  |
| AC-5d51bfe6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2394 | try ▸ for (i < dtCopy.Rows.Count) ▸ for (j < dtCopy.Columns.Count) ▸ if (ColumnName.StartsWith("M_") == true \|\| ColumnName.StartsWith("W_"… | DATA_OP | dtReturn.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5f60e91 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2400 | try | FLAG | dtRange | dtRangeNew | 화면 필드/플래그 변경 |  |  |  |
| AC-80eea74b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2402 | try | CALL_EXT | ScpUtils.DataClear | (dtCopy) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb822d08 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2403 | try | CALL_EXT | ScpUtils.DataClear | (dtReturn) | ⚠ 의미 확인 필요 |  |  |  |
| AC-476354f5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2404 | try | CALL_EXT | ScpUtils.DataClear | (dtRangeNew) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0093_DIO_Trend_Report.ChartReset

진입점: cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.measure_call == "MEASURE_NAME") ▸ try] / cboUnitQty.SelectedIndexChanged [try ▸ if (measure_unit.measure_call == "MEASURE_NAME") ▸ try] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (measure.aggr_dv.Equals("ET")) ▸ try ▸ else of (ScpUtils.CheckDataEmpty(dsChartMeasure) == false)] / FindButton [if (this.spdMain.Visible) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-727faf25 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:887 | try | UI_MISC | chartMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-9c778115 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:891 | try ▸ try | CALL_EXT | ((XYDiagram)chartMain.Diagram).SecondaryAxesY.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b8472ee | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:892 | try ▸ try | CALL_EXT | SCP0093_Chart.SecondaryAxisY_RemoveAll | (chartMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0db09f3 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:899 | try ▸ if (seriesDIO != null) | DATA_OP | chartMain.Series.Remove | (seriesDIO) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fa10a01 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:900 | try ▸ if (seriesBASEDIO != null) | DATA_OP | chartMain.Series.Remove | (seriesBASEDIO) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5f0fdd2 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:901 | try ▸ if (seriesASSEMBLY != null) | DATA_OP | chartMain.Series.Remove | (seriesASSEMBLY) | 데이터 객체 조작/조회 |  |  |  |
| AC-21238feb | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:902 | try ▸ if (seriesStock != null) | DATA_OP | chartMain.Series.Remove | (seriesStock) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b882190 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:903 | try ▸ if (seriesRTF != null) | DATA_OP | chartMain.Series.Remove | (seriesRTF) | 데이터 객체 조작/조회 |  |  |  |
| AC-255bfc77 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:904 | try | CALL_EXT | SCP0093_Chart.Series_Remove | (chartMain, seriesMeasure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-477b2c18 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:907 | try | CALL_EXT | ((XYDiagram)chartMain.Diagram).AxisY.WholeRange.SetMinMaxValues | (baseY_start, baseY_end) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd06fbf8 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:908 | try | UI_PROP | ((XYDiagram)chartMain.Diagram).AxisY.NumericScaleOptions.GridSpacing | baseY_spacing | 속성 GridSpacing 설정 |  |  |  |
| AC-859a6212 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:909 | try | STATE | ((XYDiagram)chartMain.Diagram).AxisY.GridLines.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-04c3da2e | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 4 | SCP0093_DIO_Trend_Report.cs:910 | try | STATE | ((XYDiagram)chartMain.Diagram).AxisY.Label.Visible | false | 컨트롤 상태 Visible |  |  |  |

## SCP0093_DIO_Trend_Report.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0d4c35f | this.Load | SCP0093_DIO_Trend_Report.cs:401 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-59127490 | this.Load | SCP0093_DIO_Trend_Report.cs:402 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b45d0cb3 | this.Load | SCP0093_DIO_Trend_Report.cs:404 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0093_DIO_Trend_Report.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b7e3866 | Dispose | SCP0093_DIO_Trend_Report.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0093_DIO_Trend_Report.EditButton

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1303524f | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1206 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-baa84300 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1208 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f697da85 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1209 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5464125b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1210 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5b8e35b9 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1234 |  | GRID_LOCK | siMain.LockRange | (iRowStart, iColStart, iRowEnd, iColEnd, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e08abe6 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1238 | if (IsEditMode == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9085f1bd | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1242 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e8c105db | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1243 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4079c107 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1249 | for (iCol < siMain.ActiveSheet.ColumnCount) | CALL_EXT | ScpUtils.GetColumnName | (siMain, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2735e7d3 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1274 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (measure_db.Equals("INV")) ▸ if (aggr_dv.Equals("ET") \|\| category.Equals("기타충당금")) | GRID_LOCK | siMain.LockRange | (iRow, SearchStart, iRow, SearchEnd, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7d7e27cb | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1284 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DIO_Trend_Report.Find_Chart_measure

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (measure.aggr_dv.Equals("ET"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9048513d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1673 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2afa3f44 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1674 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-37a13347 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1686 | try | FLAG | dsOrigianlCopy | ScpUtils.GetDataSource(siMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0b29df9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1686 | try | ENDPOINT | ScpUtils.GetDataSource | (siMain) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ae08dd0b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1689 | try ▸ if (ScpUtils.CheckDataEmpty(dsOrigianlCopy)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b6e6d00 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1692 | try | FLAG | dtChart | dsOrigianlCopy.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-319ebc36 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1702 | try | ENDPOINT | ScpUtils.FindData | (dtChart, condition) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6abcd349 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1705 | try ▸ if (dRows == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a00ccb9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1707 | try | FLAG | dtChart | dRows.CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-d2dd1e0f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1707 | try | DATA_OP | dRows.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-401a0151 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1712 | try | DATA_OP | dsChartMeasure.Tables.Add | (dtChart) | 데이터 객체 조작/조회 |  |  |  |
| AC-06d785b5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1717 | try | DATA_OP | dsChartMeasure.Tables.Add | (dtRangeNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1b29694 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1734 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d1d63ac7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1738 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DIO_Trend_Report.Find_Chart_Model

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58b2cb71 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1546 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7f2796d8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1547 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2a7a2a96 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1551 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-1a357b4b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1551 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2287c7a4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1553 | try | CALL_EXT | ScpUtils.DataClear | (ref dsOrigianlChartCopy) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8ece6cf | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1565 | try | CALL_EXT | ScpUtils.GetQtyValue | (cboUnitQty) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c6ed970 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1566 | try | CALL_EXT | ScpUtils.GetAmountValue | (cboUnitAmount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d58249eb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1600 | try ▸ if (ScpUtils.CheckDataEmpty(ScpUtils.GetValue(P_CATEGORY))) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { layCategoryCC.Text }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8bfee5ed | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1601 | try ▸ if (ScpUtils.CheckDataEmpty(ScpUtils.GetValue(P_CATEGORY))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8f6be89 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1615 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ecc8e285 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1616 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { var request… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ed6e2357 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1620 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (strQryName) ⇒ SCP.SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-8e48795f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1621 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bb33a96f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1622 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e7d00164 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1623 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e31d06e6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1624 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | measure.model | 행/컬럼 값 대입 |  |  |  |
| AC-adf4edde | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1625 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | p_from_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-fdb4aec2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1626 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | p_to_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-5bcc1cc9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1627 | try ▸ lambda | DATA_OP | request.Parameters["P_AGGR_DV"] | measure.aggr_dv | 행/컬럼 값 대입 |  |  |  |
| AC-bae4200a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1628 | try ▸ lambda | DATA_OP | request.Parameters["p_category_dv"] | measure.category_dv | 행/컬럼 값 대입 |  |  |  |
| AC-a77b766d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1629 | try ▸ lambda | DATA_OP | request.Parameters["P_UNIT_QTY"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-ad4680c2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1630 | try ▸ lambda | DATA_OP | request.Parameters["P_UNIT_AMOUNT"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-9975b756 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1631 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_group"] | measure.cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-512e87c2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1632 | try ▸ lambda | DATA_OP | request.Parameters["p_graph_type"] | p_graph_type | 행/컬럼 값 대입 |  |  |  |
| AC-215a05ba | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1633 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket_type"] | p_bucket_type | 행/컬럼 값 대입 |  |  |  |
| AC-0bd4afdc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1634 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7f1ace8b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1635 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-06b9bdb0 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1636 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-24c64851 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1646 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false) ▸ if (cboSearchType.ControlValues.Equals("CG")) | CALL_EXT | SCP0093_Chart.SetChart_Title | (measure.cell_group) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3fd26446 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1648 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false) ▸ else of (cboSearchType.ControlValues.Equals("CG")) | CALL_EXT | SCP0093_Chart.SetChart_Title | (measure.model) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c0ae3a3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1663 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-153744ca | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1667 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DIO_Trend_Report.Find_Data

진입점: FindButton [if (this.spdMain.Visible)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ab45f01 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1368 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d99a546f | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1372 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-69c041c8 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1372 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7b675ee | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1376 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bb2c7047 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1395 | try | CALL_EXT | ScpUtils.GetQtyValue | (cboUnitQty) | ⚠ 의미 확인 필요 |  |  |  |
| AC-16ba2f38 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1396 | try | CALL_EXT | ScpUtils.GetAmountValue | (cboUnitAmount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-065f10d1 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1407 | try ▸ if (ScpUtils.CheckDataEmpty(ScpUtils.GetValue(P_CATEGORY))) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { layCategoryCC.Text }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5da984b6 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1408 | try ▸ if (ScpUtils.CheckDataEmpty(ScpUtils.GetValue(P_CATEGORY))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8ab5623 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1417 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-41fd3fd2 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1418 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { var request… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ddc8657 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1422 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (strQryName) ⇒ SCP.SCP0093_GET_DIO_TREND_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-bf87e67b | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1423 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9f4899b0 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1424 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fcd0e990 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1425 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b432d4d0 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1426 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-1a2db275 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1427 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | p_from_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-80e88ea2 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1428 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | p_to_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-ed878e6f | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1429 | try ▸ lambda | DATA_OP | request.Parameters["P_AGGR_DV"] | P_AGGR_DV | 행/컬럼 값 대입 |  |  |  |
| AC-064c6238 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1430 | try ▸ lambda | DATA_OP | request.Parameters["P_CATEGORY"] | P_CATEGORY | 행/컬럼 값 대입 |  |  |  |
| AC-53bd14d8 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1431 | try ▸ lambda | DATA_OP | request.Parameters["P_UNIT_QTY"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-b06c3490 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1432 | try ▸ lambda | DATA_OP | request.Parameters["P_UNIT_AMOUNT"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-981b300d | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1433 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-31d44369 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1434 | try ▸ lambda | DATA_OP | request.Parameters["p_graph_type"] | p_graph_type | 행/컬럼 값 대입 |  |  |  |
| AC-76a832e3 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1435 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket_type"] | p_bucket_type | 행/컬럼 값 대입 |  |  |  |
| AC-64cc6810 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1436 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5c65e0d1 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1437 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9a134eea | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1438 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e35c868 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1439 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ea082371 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1446 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a47696d1 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1448 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9c9c6001 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1451 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0ca7025c | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1454 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81156d94 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1464 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-6814fe8d | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1465 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e4bab05b | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1472 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c32b8d4 | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1476 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-333a1e5e | FindButton [if (this.spdMain.Visible)] 외 1 | SCP0093_DIO_Trend_Report.cs:1488 | finally ▸ if (ScpUtils.CheckDataEmpty(ds) == false) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.Columns[DefMainColumns.CELL_GROUP].MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.Find_Data_Reset

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false)] / EditButton [if (IsEditMode == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e047f9e5 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1505 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-22562a4a | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1509 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e85de8e8 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1514 | try | GRID_BIND | siMain.Query | (dsOrigianlCopy) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-744f5985 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1516 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-70d35c09 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1518 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-978a7e99 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1530 | try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.Columns[DefMainColumns.CELL_GROUP].MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-a3ab6a80 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1535 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-01d45b03 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1536 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c26d9b0 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | SCP0093_DIO_Trend_Report.cs:1540 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DIO_Trend_Report.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d14baa99 | this.Load | SCP0093_DIO_Trend_Report.cs:291 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0093_DIO_Trend_Report.GetCellValue

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca32781a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2636 |  | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.GetChartPivotRange

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (measure.aggr_dv.Equals("ET")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbb8bb5a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2423 | try ▸ if (ScpUtils.CheckDataEmpty(dtPivot)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f82b0a2b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2435 | try ▸ for (i < dtPivot.Rows.Count) | CALL_EXT | ScpUtils.GetValueLong | (CellValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a518011f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2460 | try | DATA_OP | dtRange.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e269498d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2461 | try | DATA_OP | row2["GUBUN"] | gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a0f9c2ca | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2462 | try | DATA_OP | row2["DATA_MIN"] | dMinValue | 행/컬럼 값 대입 |  |  |  |
| AC-d95e5034 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2463 | try | DATA_OP | row2["DATA_MAX"] | dMaxValue | 행/컬럼 값 대입 |  |  |  |
| AC-6821a019 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2464 | try | DATA_OP | row2["SPACING"] | dSpacing | 행/컬럼 값 대입 |  |  |  |
| AC-013fddc6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2465 | try | DATA_OP | dtRange.Rows.Add | (row2) | 데이터 객체 조작/조회 |  |  |  |

## SCP0093_DIO_Trend_Report.GetColumnNameReason

진입점: this.Load [try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_") == 0 \|\| ColName.IndexOf("Q_") == 0) ▸ if (ColName.IndexOf("M_") == 0) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows)] / FindButton [if (this.spdMain.Visible) ▸ try ▸ try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows)] / EditButton [if (Is…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47137ca7 | this.Load [try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0]… 외 5 | SCP0093_DIO_Trend_Report.cs:536 |  | RETURN | return colName; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46615c3b | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:2602 | try | CALL_EXT | ScpUtils.GetPlanDateYear | (cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d3659a1 | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:2603 | try | CALL_EXT | ScpUtils.GetPlanDateYearMonth | (cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d7b3600 | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:2604 | try | CALL_EXT | ScpUtils.GetPlanDateMonth | (cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-792b31d3 | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:2606 | try | CALL_EXT | ScpUtils.GetYearFirstDay | (plan_YYYY) | ⚠ 의미 확인 필요 |  |  |  |
| AC-968dc6e9 | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:2608 | try | CALL_EXT | ScpUtils.GetAddYearMonthLastDay | (dateStart, 1, "06") | ⚠ 의미 확인 필요 |  |  |  |
| AC-95f90508 | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:2611 | try ▸ if (plan_MM.Equals("09")) | CALL_EXT | ScpUtils.GetAddYearMonthLastDay | (dateStart, 1, "12") | ⚠ 의미 확인 필요 |  |  |  |
| AC-677df72d | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:2621 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.GetMonthFromTo

진입점: this.Load / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (e.ColumnHeader)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (this.spdMain.Visible) ▸ try] / EditButton [if (IsEditMode == false) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ba8993e | this.Load 외 6 | SCP0093_DIO_Trend_Report.cs:1356 | if (fromto.Equals("FROM")) | RETURN | return dCalendar.Text1.Replace("-", "").ToString().Substring(0, 6); |  | 처리 중단/반환 |  |  |  |
| AC-2ae3d6eb | this.Load 외 6 | SCP0093_DIO_Trend_Report.cs:1358 | else of (fromto.Equals("FROM")) | RETURN | return dCalendar.Text2.Replace("-", "").ToString().Substring(0, 6); |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.GetParamCategory

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (e.ColumnHeader)] / FindButton [if (this.spdMain.Visible) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81e8d918 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… 외 2 | SCP0093_DIO_Trend_Report.cs:1350 |  | RETURN | return P_CATEGORY; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.GetSelectDivisionList

진입점: this.Load / cboDivision.SelectedIndexChanged / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (arrMonth.Length > 0) ▸ for (x < arrMonth.Length) ▸ if (ScpUtils.CheckDataEmpty(row_yyyymm) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-596faea7 | this.Load 외 2 | SCP0093_DIO_Trend_Report.cs:2650 |  | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.GetSpdTitle

진입점: this.Load / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (this.spdMain.Visible) ▸ try] / EditButton [if (IsEditMode == false) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ed35a6c | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:2583 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-a1649270 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:2584 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | GetMonthFromTo(dCalendar, "FROM") | 행/컬럼 값 대입 |  |  |  |
| AC-4c50e9bd | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:2585 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | GetMonthFromTo(dCalendar, "TO") | 행/컬럼 값 대입 |  |  |  |
| AC-1326703a | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:2587 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-42fd5629 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:2587 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0093_DIO_Trend_Report.GetUnitDivide

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0) ▸ for (i < dsOrigianlCopy.Tables[0].Rows.Count)] / cboUnitAmount.SelectedIndexChanged [for (i < dsOrigianlCopy.Tables[0].Rows.Count)] / cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tables[0].Rows.Count)] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ try ▸ if (ScpUti…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28ea5472 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2134 | if (ScpUtils.CheckDataEmpty(measure_type) == false) ▸ else of (measure_type.ToUpper().Equals("QTY")) ▸ else of (measure_type.ToUpper().Equal… | DATA_OP | measure_type.Contains | ("DIO") | 데이터 객체 조작/조회 |  |  |  |

## SCP0093_DIO_Trend_Report.GetValueMultiply

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (arrMonth.Length > 0) ▸ for (x < arrMonth.Length) ▸ if (ScpUtils.CheckDataEmpty(row_yyyymm) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a6e226f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1764 |  | CALL_EXT | ScpUtils.GetValueDouble | (value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44dfac31 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1768 |  | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3419b119 | this.Load | SCP0093_DIO_Trend_Report.cs:333 |  | CALL_EXT | ScpUtils.GetCurrentTimeZone | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-84d7f968 | this.Load | SCP0093_DIO_Trend_Report.cs:334 |  | CALL_EXT | ScpUtils.GetDefaultTimeZone | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0d71313 | this.Load | SCP0093_DIO_Trend_Report.cs:336 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-77f5dc5e | this.Load | SCP0093_DIO_Trend_Report.cs:340 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-3185644f | this.Load | SCP0093_DIO_Trend_Report.cs:342 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-267ec70c | this.Load | SCP0093_DIO_Trend_Report.cs:347 |  | FLAG | dtBucketType | ScpUtils.GetBucketType("CODE = 'DAILY'") | 화면 필드/플래그 변경 |  |  |  |
| AC-e2f87358 | this.Load | SCP0093_DIO_Trend_Report.cs:347 |  | CALL_EXT | ScpUtils.GetBucketType | ("CODE = 'DAILY'") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3cfd375b | this.Load | SCP0093_DIO_Trend_Report.cs:349 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0ce0da27 | this.Load | SCP0093_DIO_Trend_Report.cs:351 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-7531420a | this.Load | SCP0093_DIO_Trend_Report.cs:358 |  | FLAG | dtGraphType | ScpUtils.GetLookupValues("STOCK_TREND_GRAPH") | 화면 필드/플래그 변경 |  |  |  |
| AC-2cc1b415 | this.Load | SCP0093_DIO_Trend_Report.cs:358 |  | CALL_EXT | ScpUtils.GetLookupValues | ("STOCK_TREND_GRAPH") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a239e605 | this.Load | SCP0093_DIO_Trend_Report.cs:360 |  | LIST_REBIND | clsCtrl.setListBox | (dtGraphType, cboGraphType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a2f24f7e | this.Load | SCP0093_DIO_Trend_Report.cs:363 |  | FLAG | dtAggrDV | ScpUtils.GetLookupValues("STOCK_TREND_SEARCH") | 화면 필드/플래그 변경 |  |  |  |
| AC-1b404b17 | this.Load | SCP0093_DIO_Trend_Report.cs:363 |  | CALL_EXT | ScpUtils.GetLookupValues | ("STOCK_TREND_SEARCH") | ⚠ 의미 확인 필요 |  |  |  |
| AC-90dc92b2 | this.Load | SCP0093_DIO_Trend_Report.cs:365 |  | LIST_REBIND | clsCtrl.setListBox | (dtAggrDV, cboSearchType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-104a340c | this.Load | SCP0093_DIO_Trend_Report.cs:368 |  | FLAG | dtDisplay | ScpUtils.GetLookupValues("STOCK_TREND_DISPLAY") | 화면 필드/플래그 변경 |  |  |  |
| AC-7bad7421 | this.Load | SCP0093_DIO_Trend_Report.cs:368 |  | CALL_EXT | ScpUtils.GetLookupValues | ("STOCK_TREND_DISPLAY") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7d719fb | this.Load | SCP0093_DIO_Trend_Report.cs:370 |  | LIST_REBIND | clsCtrl.setListBox | (dtDisplay, cboDisplay, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-78b72024 | this.Load | SCP0093_DIO_Trend_Report.cs:375 |  | FLAG | dtUnitQty | ScpUtils.GetUnitQty() | 화면 필드/플래그 변경 |  |  |  |
| AC-4b4ebeb8 | this.Load | SCP0093_DIO_Trend_Report.cs:375 |  | CALL_EXT | ScpUtils.GetUnitQty | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-650c8f82 | this.Load | SCP0093_DIO_Trend_Report.cs:377 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnitQty, cboUnitQty, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a6f41d60 | this.Load | SCP0093_DIO_Trend_Report.cs:379 |  | VALUE_SET | cboUnitQty.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-366775e8 | this.Load | SCP0093_DIO_Trend_Report.cs:381 |  | FLAG | dtUnitAmount | ScpUtils.GetAmountData(Data.Type.SALES_PLAN_AMOUNT_KRW, UserInfoContext.Current["NowGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-d21e2768 | this.Load | SCP0093_DIO_Trend_Report.cs:381 |  | CALL_EXT | ScpUtils.GetAmountData | (Data.Type.SALES_PLAN_AMOUNT_KRW, UserInfoContext.Current["NowGroupID"], UserInfoContext.C… | ⚠ 의미 확인 필요 |  |  |  |
| AC-075e2186 | this.Load | SCP0093_DIO_Trend_Report.cs:383 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnitAmount, cboUnitAmount, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d44f43da | this.Load | SCP0093_DIO_Trend_Report.cs:385 |  | VALUE_SET | cboUnitAmount.SelectedIndex | 3 | 컨트롤 값 설정 |  |  |  |
| AC-e0470d88 | this.Load | SCP0093_DIO_Trend_Report.cs:396 |  | UI_PROP | lblBucket.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.InitSpread

진입점: this.Load / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (this.spdMain.Visible) ▸ try] / EditButton [if (IsEditMode == false) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d69d4d67 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:411 |  | GRID_INIT | siMain.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-641b2fd3 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:414 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-b05ccbc9 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:418 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0093_DIO_Trend_Report.InitSpreadAddColumn

진입점: this.Load [try] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try] / FindButton [if (this.spdMain.Visible) ▸ try ▸ try] / EditButton [if (IsEditMode == false) ▸ try ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-491d8596 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:656 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainColumnsLabel.CELL_CF, "CELL_CF", FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34f727fd | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:656 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumnsLabel.CELL_CF, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7561fe45 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:656 |  | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetMaxColumnIndex(), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bbbe8da8 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:657 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainColumnsLabel.DEPT_NAME_KO, "DEPT_NAME_KO", FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3278f438 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:657 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumnsLabel.DEPT_NAME_KO, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b411ad3 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:658 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainColumnsLabel.PROJECT_NAME, "PROJECT_NAME", FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1799c79 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:658 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumnsLabel.PROJECT_NAME, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aebe26cf | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:659 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainColumnsLabel.UNIT_PRICE_LAST, "UNIT_PRICE_LAST", FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad061cfd | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:659 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumnsLabel.UNIT_PRICE_LAST, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02803cbf | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:659 |  | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetMaxColumnIndex(), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-59dbfd06 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:660 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainColumnsLabel.PRODUCTION_CYCLE, "PRODUCTION_CYCLE", FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb05e27b | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:660 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumnsLabel.PRODUCTION_CYCLE, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-651a67a1 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:660 |  | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetMaxColumnIndex(), -9999999999, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5be7caec | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:661 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainColumnsLabel.SAFETY_STOCK, "SAFETY_STOCK", FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9fe1659 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:661 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumnsLabel.SAFETY_STOCK, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50f8018a | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:661 |  | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetMaxColumnIndex(), -9999999999, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-847cb676 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:662 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainColumnsLabel.PRE_INSPECTION, "PRE_INSPECTION", FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbd07c36 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:662 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumnsLabel.PRE_INSPECTION, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49598ede | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:662 |  | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetMaxColumnIndex(), -9999999999, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-86ef2520 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:663 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainColumnsLabel.PIC_NAME, "PIC_NAME", FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ccdbfd04 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:663 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumnsLabel.PIC_NAME, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8fc47143 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:664 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainColumnsLabel.PRE_INSPECTION, "YIELD", FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f12e6e54 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:664 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumnsLabel.YIELD, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-656ab91f | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:664 |  | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetMaxColumnIndex(), -9999999999, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-001f2b94 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:665 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainColumnsLabel.TARGET_CELL, "TARGET_CELL", FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6464a1c | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:665 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumnsLabel.TARGET_CELL, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53362bc4 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:670 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainColumns.AGGR_DV, DefMainColumns.AGGR_DV, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a99b078 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:670 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumns.AGGR_DV, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f49a2a8d | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:671 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainColumns.CELL_CONVERT_YN, DefMainColumns.CELL_CONVERT_YN, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7639cbca | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:671 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumns.CELL_CONVERT_YN, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11e1531e | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:672 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainColumns.OPERATION_GROUP, DefMainColumns.OPERATION_GROUP, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-366008e4 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:672 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumns.OPERATION_GROUP, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9168ecd8 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:673 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainColumns.CATEGORY_DV, DefMainColumns.CATEGORY_DV, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10481075 | this.Load [try] 외 5 | SCP0093_DIO_Trend_Report.cs:673 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, DefMainColumns.CATEGORY_DV, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0093_DIO_Trend_Report.InitSpreadDateColumn

진입점: this.Load / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (this.spdMain.Visible) ▸ try] / EditButton [if (IsEditMode == false) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff0e7c9b | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:442 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iColIndex, 1, 1, 20, DefMainColumnsLabel.MEASURE_NAME_MONTH_DAY_COUNT, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5808df0f | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:443 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iColIndex, 2, 1, 20, DefMainColumnsLabel.MEASURE_NAME, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5aeae187 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:474 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | FLAG | useReason | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-7768642c | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:477 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | DATA_OP | sColumnName.Contains | ("M_") | 데이터 객체 조작/조회 |  |  |  |
| AC-897cf963 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:494 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4bdc9d6 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:497 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | FLAG | useReasonColName | GetColumnNameReason(sColumnName) | 화면 필드/플래그 변경 |  |  |  |
| AC-277296f6 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:498 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddTextColumn | (useReasonColName, useReasonColName, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c81e625f | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:498 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetMaxColumnIndex(), 3, 1, 20, useReasonColName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5dc1a5b2 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:501 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, iColIndex, -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5ae58e59 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:504 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | CALL_EXT | ScpUtils.GetMonthLastDay | (sLargeLabelName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f486708b | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:505 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iColIndex, 1, 1, 20, MonthLastDay, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f5266f7 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:506 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iColIndex, 2, 1, 20, sLargeLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8c1be1d | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:520 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[1, iColIndex].ForeColor | headerColor | 그리드 속성/값 설정 |  |  |  |
| AC-42dabce4 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:521 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[1, iColIndex].Font | fontCellBold | 그리드 속성/값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.IsEditColumn

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7164f860 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2109 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b768a515 | OnShown | SCP0093_DIO_Trend_Report.cs:302 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, 0) | 목록 컨트롤 재구성 |  |  |  |

## SCP0093_DIO_Trend_Report.openPopup

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (e.ColumnHeader)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c864085b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2552 |  | POPUP | new SCP0093_DioTrendReportPopup | () | 팝업/폼 생성 |  |  |  |
| AC-12d11879 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2553 |  | UI_PROP | popup.category_dv | GetParamCategory().ToString() | 속성 category_dv 설정 |  |  |  |
| AC-b0d6122a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2554 |  | UI_PROP | popup.plan_start_yyyymmdd | ScpUtils.GetValue(p_plan_start_yyyymmdd) | 속성 plan_start_yyyymmdd 설정 |  |  |  |
| AC-193f91a2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2555 |  | UI_PROP | popup.Division | ScpUtils.GetValue(p_division_id) | 속성 Division 설정 |  |  |  |
| AC-d105d53d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2556 |  | UI_PROP | popup.yyyymm | yyyymm | 속성 yyyymm 설정 |  |  |  |
| AC-548aae67 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2557 |  | UI_PROP | popup.item_id | p_item_id | 속성 item_id 설정 |  |  |  |
| AC-0ed8d778 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2558 |  | UI_PROP | popup.aggr_dv | ScpUtils.GetValue(P_AGGR_DV) | 속성 aggr_dv 설정 |  |  |  |
| AC-36eda3ee | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2559 |  | UI_PROP | popup.cell_group | ScpUtils.GetValue(p_cell_group) | 속성 cell_group 설정 |  |  |  |
| AC-deddd713 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2560 |  | UI_PROP | popup.PopUserId | base.UserInfo.UserId | 속성 PopUserId 설정 |  |  |  |
| AC-32871d7d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2561 |  | UI_PROP | popup.yyyymm_from | GetMonthFromTo(dCalendar, "FROM") | 속성 yyyymm_from 설정 |  |  |  |
| AC-d1e6c887 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2562 |  | UI_PROP | popup.yyyymm_to | GetMonthFromTo(dCalendar, "TO") | 속성 yyyymm_to 설정 |  |  |  |
| AC-9a1ba284 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2566 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-472e14fb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2568 | if (popup.ShowDialog() == DialogResult.OK) | ENDPOINT | FindData | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0093_DIO_Trend_Report.RefreshPlanDate

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51ab7284 | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:320 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-5561b97e | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:320 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3730fab7 | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:324 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | dtPlanDateAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ba3b1a37 | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:324 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dtPlanDateAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e35d9e53 | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:327 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0093_DIO_Trend_Report.Save_Data

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23639598 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1777 | try ▸ if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab6c8fe9 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1779 | try ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0daadf63 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1784 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-0a3dd0b3 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1786 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-730e5146 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1827 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (j < siMain.ActiveSheet.ColumnCount) | CALL_EXT | ScpUtils.GetColumnName | (siMain, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1928c409 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1838 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (j < siMain.ActiveSheet.ColumnCount) | CALL_EXT | ScpUtils.GetColumnName | (siMain, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9c96f1e | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1841 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (ColumnName.StartsWith("M_") == true \|\| Co… | DATA_OP | arrMonth[ColumnCount] | ColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-131b1f07 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1904 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0093_SAVE_DIO_TREND_DATA") ⇒ SCP.SCP0093_SAVE_DIO_TREND_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-0d2de51c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1907 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { req.Command… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35b30834 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1911 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9df9aa18 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1912 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-988b179e | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1913 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-01f84342 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1914 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c8378210 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1915 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_aggr_dv"] | p_aggr_dv | 행/컬럼 값 대입 |  |  |  |
| AC-6be155b3 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1916 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5584ff5b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1917 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_cell_convert_yn"] | p_cell_convert_yn | 행/컬럼 값 대입 |  |  |  |
| AC-2fd99af6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1918 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-8d6da6da | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1919 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_category_dv"] | p_category_dv | 행/컬럼 값 대입 |  |  |  |
| AC-220aeabe | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1920 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-364259db | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1921 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_yyyymm"] | p_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-88b8e094 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1922 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_yyyymmValue"] | p_yyyymmValue | 행/컬럼 값 대입 |  |  |  |
| AC-ed417798 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1923 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_request_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3d5302d1 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1925 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3f022da0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1925 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-84b33c14 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1936 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe811d63 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1947 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ else of (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11d93bfe | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1954 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a2e3fb2f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1961 | catch ((Exception ex)) | MESSAGE | System.Windows.Forms.MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## SCP0093_DIO_Trend_Report.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ee96e10 | SaveButton | SCP0093_DIO_Trend_Report.cs:1290 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1cbc960e | SaveButton | SCP0093_DIO_Trend_Report.cs:1292 |  | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00012", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0db68d2f | SaveButton | SCP0093_DIO_Trend_Report.cs:1295 |  | MESSAGE | MessageHelper.GMessageBox | (message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93618249 | SaveButton | SCP0093_DIO_Trend_Report.cs:1298 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2c46f0b1 | SaveButton | SCP0093_DIO_Trend_Report.cs:1303 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (save_status == DefSaveMode.RUN) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cad79780 | SaveButton | SCP0093_DIO_Trend_Report.cs:1304 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (save_status == DefSaveMode.RUN) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DIO_Trend_Report.SetAxisY_Title

진입점: cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.measure_call == "MEASURE_NAME") ▸ try] / cboUnitQty.SelectedIndexChanged [try ▸ if (measure_unit.measure_call == "MEASURE_NAME") ▸ try] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (measure.aggr_dv.Equals("ET")) ▸ try ▸ if (ScpUtils.CheckDataEmpty(dsChartMeasure) == false) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f2927b5 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1010 |  | DATA_OP | ((XYDiagram)chart.Diagram).SecondaryAxesY.Add | (y) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3d805e8 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1011 |  | VALUE_SET | y.Title.Text | Title | 컨트롤 값 설정 |  |  |  |
| AC-b97d8a11 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1012 |  | CALL_EXT | y.WholeRange.SetMinMaxValues | (start, end) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc428884 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1013 |  | UI_PROP | y.NumericScaleOptions.GridSpacing | spacing | 속성 GridSpacing 설정 |  |  |  |
| AC-952c479e | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1014 |  | STATE | y.GridLines.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a14e5b12 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1015 |  | STATE | y.Label.Visible | false | 컨트롤 상태 Visible |  |  |  |

## SCP0093_DIO_Trend_Report.SetCalculating

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0)] / cboUnitAmount.SelectedIndexChanged / cboUnitQty.SelectedIndexChanged / FindButton [if (this.spdMain.Visible) ▸ finally ▸ if (ScpUtils.CheckDataEmpty(ds) == false) ▸ if (ds.Tables[0].Rows.Count > 0)] / EditButton [if (IsEditMode == false) ▸ try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b066ec2b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2169 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7398d911 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2174 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-45575cd0 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2179 | if (cboUnitAmount.SelectedIndex == 0 && cboUnitQty.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-5011b3a7 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2180 | if (cboUnitAmount.SelectedIndex == 0 && cboUnitQty.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d8fcb33 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2183 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c2922839 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2185 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d06fbd73 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2193 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) | CALL_EXT | SCP0093_Measure.GetMeasureDataType | (sMeasure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e3aca6a | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2212 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbDivide, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-e07f8d43 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2216 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b494dab3 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2222 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-2ac7acd2 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2226 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-7e853b65 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2230 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-a2983484 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 5 | SCP0093_DIO_Trend_Report.cs:2233 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0093_DIO_Trend_Report.SetCalculating_chart

진입점: cboUnitAmount.SelectedIndexChanged / cboUnitQty.SelectedIndexChanged / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dec2088 | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2249 | try ▸ if (measure_unit == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-196f7600 | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2252 | try ▸ if (ScpUtils.CheckDataEmpty(ds_unit) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d31b6ae | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2256 | try ▸ if (dsOrigianlChartCopy == null) | FLAG | dsOrigianlChartCopy | ds_unit.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d17aff23 | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2256 | try ▸ if (dsOrigianlChartCopy == null) | DATA_OP | ds_unit.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0be28470 | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2259 | try | DATA_OP | dsOrigianlChartCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b1b187ef | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2260 | try | DATA_OP | dsKrwChart.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-301b8056 | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2270 | try ▸ for (x < tableCnt) ▸ for (i < dsKrwChart.Tables[x].Rows.Count) ▸ if (x == tableCnt - 1) | CALL_EXT | SCP0093_Measure.GetMeasureDataType | (sMeasure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4883540 | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2278 | try ▸ for (x < tableCnt) ▸ for (i < dsKrwChart.Tables[x].Rows.Count) ▸ else of (x == tableCnt - 1) | CALL_EXT | SCP0093_Measure.GetMeasureDataType | (sMeasure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-917b1150 | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2284 | try ▸ for (x < tableCnt) ▸ for (i < dsKrwChart.Tables[x].Rows.Count) ▸ for (j < dsKrwChart.Tables[x].Columns.Count) | CALL_EXT | ScpUtils.GetColumnName | (dsKrwChart.Tables[x], j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5780f4a | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2294 | try ▸ for (x < tableCnt) ▸ for (i < dsKrwChart.Tables[x].Rows.Count) ▸ for (j < dsKrwChart.Tables[x].Columns.Count) ▸ switch (ColumnName) ca… | GRID_SET | dsKrwChart.Tables[x].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbDivide, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-583adb08 | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2306 | try ▸ for (x < tableCnt) ▸ for (i < dsKrwChart.Tables[x].Rows.Count) ▸ for (j < dsKrwChart.Tables[x].Columns.Count) ▸ switch (ColumnName) ca… | GRID_SET | dsKrwChart.Tables[x].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbDivide, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-874c042b | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2317 | try | DATA_OP | dsKrwChart.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9d2b2e6f | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2327 | try | FLAG | ds_unit | dsKrwChart | 화면 필드/플래그 변경 |  |  |  |
| AC-efba2f7f | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2331 | try ▸ if (dsKrwChart != null) | UI_MISC | dsKrwChart.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-8efef56f | cboUnitAmount.SelectedIndexChanged 외 2 | SCP0093_DIO_Trend_Report.cs:2337 | try ▸ if (measure_unit.measure_call == "MEASURE_NAME") | CALL_EXT | SCP0093_Chart.SetChart_Title | (measure_unit.measure) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0093_DIO_Trend_Report.SetCalendar

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b417aa0 | this.Load 외 1 | SCP0093_DIO_Trend_Report.cs:2059 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.SetCellForeColor

진입점: this.Load [for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount)] / FindButton [if (this.spdMain.Visible) ▸ finally ▸ if (ScpUtils.CheckDataEmpty(ds) == false) ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.Acti…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-525dd598 | this.Load [for (iRow < siMain.ActiveSheet.RowCount) ▸ for (i… 외 5 | SCP0093_DIO_Trend_Report.cs:619 | if (focusValue.StartsWith("+")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | DefGridColor.PLUS | 그리드 속성/값 설정 |  |  |  |
| AC-d3921b5e | this.Load [for (iRow < siMain.ActiveSheet.RowCount) ▸ for (i… 외 5 | SCP0093_DIO_Trend_Report.cs:623 | else of (focusValue.StartsWith("+")) ▸ if (focusValue.StartsWith("-")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | DefGridColor.MINUS | 그리드 속성/값 설정 |  |  |  |
| AC-529c1996 | this.Load [for (iRow < siMain.ActiveSheet.RowCount) ▸ for (i… 외 5 | SCP0093_DIO_Trend_Report.cs:627 | else of (focusValue.StartsWith("+")) ▸ else of (focusValue.StartsWith("-")) ▸ if (focusValue.StartsWith("△")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | DefGridColor.UP | 그리드 속성/값 설정 |  |  |  |
| AC-fdae72fc | this.Load [for (iRow < siMain.ActiveSheet.RowCount) ▸ for (i… 외 5 | SCP0093_DIO_Trend_Report.cs:631 | else of (focusValue.StartsWith("+")) ▸ else of (focusValue.StartsWith("-")) ▸ else of (focusValue.StartsWith("△")) ▸ if (focusValue == DefCh… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | DefGridColor.MEASURE | 그리드 속성/값 설정 |  |  |  |
| AC-194b285d | this.Load [for (iRow < siMain.ActiveSheet.RowCount) ▸ for (i… 외 5 | SCP0093_DIO_Trend_Report.cs:635 | else of (focusValue.StartsWith("+")) ▸ else of (focusValue.StartsWith("-")) ▸ else of (focusValue.StartsWith("△")) ▸ else of (focusValue == … | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | DefGridColor.MEASURE | 그리드 속성/값 설정 |  |  |  |
| AC-385193c5 | this.Load [for (iRow < siMain.ActiveSheet.RowCount) ▸ for (i… 외 5 | SCP0093_DIO_Trend_Report.cs:639 | else of (focusValue.StartsWith("+")) ▸ else of (focusValue.StartsWith("-")) ▸ else of (focusValue.StartsWith("△")) ▸ else of (focusValue == … | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | DefGridColor.MEASURE | 그리드 속성/값 설정 |  |  |  |
| AC-01bb8479 | this.Load [for (iRow < siMain.ActiveSheet.RowCount) ▸ for (i… 외 5 | SCP0093_DIO_Trend_Report.cs:643 | else of (focusValue.StartsWith("+")) ▸ else of (focusValue.StartsWith("-")) ▸ else of (focusValue.StartsWith("△")) ▸ else of (focusValue == … | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | DefGridColor.MEASURE | 그리드 속성/값 설정 |  |  |  |
| AC-c53ca9f5 | this.Load [for (iRow < siMain.ActiveSheet.RowCount) ▸ for (i… 외 5 | SCP0093_DIO_Trend_Report.cs:647 | else of (focusValue.StartsWith("+")) ▸ else of (focusValue.StartsWith("-")) ▸ else of (focusValue.StartsWith("△")) ▸ else of (focusValue == … | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | DefGridColor.MEASURE | 그리드 속성/값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.SetCellFormat

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0)] / FindButton [if (this.spdMain.Visible) ▸ finally ▸ if (ScpUtils.CheckDataEmpty(ds) == false) ▸ if (ds.Tables[0].Rows.Count > 0)] / EditButton [if (IsEditMode == false) ▸ try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06096467 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 3 | SCP0093_DIO_Trend_Report.cs:2499 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b6c22b6e | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 3 | SCP0093_DIO_Trend_Report.cs:2500 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5f343ddd | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 3 | SCP0093_DIO_Trend_Report.cs:2510 | try ▸ if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a5167af | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 3 | SCP0093_DIO_Trend_Report.cs:2516 | try ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | SCP0093_Measure.GetMeasureDataType | (sMeasure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff474f4b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 3 | SCP0093_DIO_Trend_Report.cs:2521 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) | CALL_EXT | ScpUtils.GetColumnName | (siMain, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9f0f2ab | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 3 | SCP0093_DIO_Trend_Report.cs:2529 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (ColumnName.StartsWith("M_") == true \|\| ColumnNam… | GRID_INIT | siMain.SetReNumerCellType | (siMain, i, j, -99999999999999, 1, 99999999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-340108fd | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 3 | SCP0093_DIO_Trend_Report.cs:2540 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DIO_Trend_Report.SetChart

진입점: cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_unit.measure_call == "MEASURE_NAME")] / cboUnitQty.SelectedIndexChanged [try ▸ else of (measure_unit.measure_call == "MEASURE_NAME")] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false) ▸ try ▸ else of (measure_unit.measure_call == "MEASURE_NAME")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e707fe87 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:782 | try ▸ if (ScpUtils.CheckDataEmpty(ds)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c9337e0 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:786 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) | FLAG | dtRange | ds.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-381fabbf | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:793 | try | DATA_OP | ((XYDiagram)chartMain.Diagram).SecondaryAxesY.Add | (firstY) | 데이터 객체 조작/조회 |  |  |  |
| AC-3823c8e3 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:794 | try | DATA_OP | ((XYDiagram)chartMain.Diagram).SecondaryAxesY.Add | (secondY) | 데이터 객체 조작/조회 |  |  |  |
| AC-7017d8f3 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:796 | try | UI_PROP | chartMain.Series[0].LegendText | SCP0093_Chart.GetChart_Title() | 속성 LegendText 설정 |  |  |  |
| AC-54c99022 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:796 | try | CALL_EXT | SCP0093_Chart.GetChart_Title | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f8766c7 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:797 | try | UI_PROP | ((XYDiagram)chartMain.Diagram).AxisX.DateTimeScaleOptions.MeasureUnit | DateTimeMeasureUnit.Month | 속성 MeasureUnit 설정 |  |  |  |
| AC-666c6a49 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:798 | try | UI_PROP | ((XYDiagram)chartMain.Diagram).AxisX.GridSpacingAuto | false | 속성 GridSpacingAuto 설정 |  |  |  |
| AC-66167146 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:799 | try | UI_PROP | ((XYDiagram)chartMain.Diagram).AxisX.WholeRange.MinValue | true | 속성 MinValue 설정 |  |  |  |
| AC-0b9c83de | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:804 | try ▸ if (secondY.Title.Text != DefChartLabel.DIO) | DATA_OP | ((XYDiagram)chartMain.Diagram).SecondaryAxesY.Add | (secondY) | 데이터 객체 조작/조회 |  |  |  |
| AC-7af8edc1 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:805 | try ▸ if (secondY.Title.Text != DefChartLabel.DIO) | VALUE_SET | secondY.Title.Text | DefChartLabel.DIO | 컨트롤 값 설정 |  |  |  |
| AC-46c05503 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:806 | try ▸ if (secondY.Title.Text != DefChartLabel.DIO) | CALL_EXT | secondY.WholeRange.SetMinMaxValues | (secondY_start, secondY_end) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9aacf8dc | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:807 | try ▸ if (secondY.Title.Text != DefChartLabel.DIO) | UI_PROP | secondY.NumericScaleOptions.GridSpacing | secondY_spacing | 속성 GridSpacing 설정 |  |  |  |
| AC-95b601ac | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:808 | try ▸ if (secondY.Title.Text != DefChartLabel.DIO) | STATE | secondY.GridLines.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a5733f32 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:809 | try ▸ if (secondY.Title.Text != DefChartLabel.DIO) | STATE | secondY.Label.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-d3228632 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:814 | try | UI_PROP | secondY.Color | DefChartColor.DIO | 속성 Color 설정 |  |  |  |
| AC-74b5f79b | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:815 | try | UI_PROP | firstY.Color | DefChartColor.PROD | 속성 Color 설정 |  |  |  |
| AC-79e4f8a6 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:816 | try | UI_PROP | ((XYDiagram)chartMain.Diagram).SecondaryAxesY[0].Color | DefChartColor.STOCK | 속성 Color 설정 |  |  |  |
| AC-c65021b6 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:817 | try | UI_PROP | ((XYDiagram)chartMain.Diagram).SecondaryAxesY[1].Color | DefChartColor.BASE_DIO | 속성 Color 설정 |  |  |  |
| AC-df8177b8 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:827 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false) | CALL_EXT | ScpUtils.SetDataEmpty | (ref dtChart) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb0fe728 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:828 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false) | FLAG | dtChart | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-f6c1dcee | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:835 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[1]) == false) | CALL_EXT | ScpUtils.SetDataEmpty | (ref dtChart) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6f93a6b | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:836 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[1]) == false) | FLAG | dtChart | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-b240d165 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:843 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[2]) == false) | CALL_EXT | ScpUtils.SetDataEmpty | (ref dtChart) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fae2d7c | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:844 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[2]) == false) | FLAG | dtChart | ds.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-995759b8 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:850 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[2]) == false) | FLAG | lineView2 | (LineSeriesView)seriesRTF.View | 화면 필드/플래그 변경 |  |  |  |
| AC-0bb70007 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:851 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[2]) == false) | UI_PROP | lineView2.AxisY | ((XYDiagram)chartMain.Diagram).AxisY | 속성 AxisY 설정 |  |  |  |
| AC-4a6ed52e | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:852 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[2]) == false) | UI_PROP | lineView2.LineMarkerOptions.BorderVisible | false | 속성 BorderVisible 설정 |  |  |  |
| AC-3f82f082 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:853 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[2]) == false) | UI_PROP | lineView2.LineMarkerOptions.Color | DefChartColor.RTF | 속성 Color 설정 |  |  |  |
| AC-a880942e | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:854 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[2]) == false) | UI_PROP | lineView2.LineMarkerOptions.Kind | MarkerKind.Circle | 속성 Kind 설정 |  |  |  |
| AC-28467d27 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:855 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[2]) == false) | UI_PROP | lineView2.LineStyle.Thickness | 2 | 속성 Thickness 설정 |  |  |  |
| AC-2e665693 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:856 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[2]) == false) | UI_PROP | lineView2.MarkerVisibility | DevExpress.Utils.DefaultBoolean.True | 속성 MarkerVisibility 설정 |  |  |  |
| AC-aae93b4d | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:857 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[2]) == false) | STATE | lineView2.Shadow.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-de46ae14 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:863 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[3]) == false) | CALL_EXT | ScpUtils.SetDataEmpty | (ref dtChart) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09c25acb | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:864 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[3]) == false) | FLAG | dtChart | ds.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-b574d587 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:871 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[4]) == false) | CALL_EXT | ScpUtils.SetDataEmpty | (ref dtChart) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4343f327 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:872 | try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[4]) == false) | FLAG | dtChart | ds.Tables[4] | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.SetChart_Measure

진입점: cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.measure_call == "MEASURE_NAME")] / cboUnitQty.SelectedIndexChanged [try ▸ if (measure_unit.measure_call == "MEASURE_NAME")] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (measure.aggr_dv.Equals("ET")) ▸ try ▸ if (ScpUtils.CheckDataEmpty(dsChartMeasure) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-327d538d | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1099 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-433fbbad | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1100 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-417a7c76 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1104 | try | DATA_OP | ((XYDiagram)chartMain.Diagram).SecondaryAxesY.Add | (firstY) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bcb7b3a | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1110 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[1]) == false) | FLAG | dtChart | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-07273db0 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1111 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[1]) == false) | FLAG | dtRange | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-86fadad1 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1113 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[1]) == false) | FLAG | firstY_start | ScpUtils.GetValueLong(dtRange.Rows[0]["data_min"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-af476578 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1113 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[1]) == false) | CALL_EXT | ScpUtils.GetValueLong | (dtRange.Rows[0]["data_min"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-af7e0c5f | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1114 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[1]) == false) | FLAG | firstY_end | ScpUtils.GetValueLong(dtRange.Rows[0]["data_max"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-cb2d412e | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1114 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[1]) == false) | CALL_EXT | ScpUtils.GetValueLong | (dtRange.Rows[0]["data_max"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f7ba35b | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1115 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[1]) == false) | FLAG | firstY_spacing | ScpUtils.GetValueLong(dtRange.Rows[0]["spacing"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-858cf9cf | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1115 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[1]) == false) | CALL_EXT | ScpUtils.GetValueLong | (dtRange.Rows[0]["spacing"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-24fdafa0 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1125 | try | UI_PROP | chartMain.Series[0].LegendText | chartTitle | 속성 LegendText 설정 |  |  |  |
| AC-8e380057 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1127 | try | DATA_OP | ((XYDiagram)chartMain.Diagram).SecondaryAxesY.Add | (firstY) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8b497af | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1128 | try | VALUE_SET | firstY.Title.Text | chartLabel | 컨트롤 값 설정 |  |  |  |
| AC-b309efa6 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1129 | try | CALL_EXT | firstY.WholeRange.SetMinMaxValues | (firstY_start, firstY_end) | ⚠ 의미 확인 필요 |  |  |  |
| AC-29704748 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1130 | try | UI_PROP | firstY.NumericScaleOptions.GridSpacing | firstY_spacing | 속성 GridSpacing 설정 |  |  |  |
| AC-5dc38fd2 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1131 | try | STATE | firstY.GridLines.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-203ff373 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1132 | try | STATE | firstY.Label.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-7fb70ad4 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1135 | try | UI_PROP | seriesMeasure.Name | chartLabel | 속성 Name 설정 |  |  |  |
| AC-ef8e664d | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1136 | try | UI_PROP | seriesMeasure.LegendText | chartLabel | 속성 LegendText 설정 |  |  |  |
| AC-4fd28a78 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1137 | try | DATA_OP | chartMain.Series.Add | (seriesMeasure) | 데이터 객체 조작/조회 |  |  |  |
| AC-2717051e | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1138 | try | LIST_CLEAR | seriesMeasure.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-0114a3c6 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1139 | try | LIST_BIND | seriesMeasure.DataSource | dtChart | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-86fa83b0 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1140 | try | UI_PROP | seriesMeasure.ArgumentDataMember | dtChart.Columns[1].ColumnName | 속성 ArgumentDataMember 설정 |  |  |  |
| AC-d12e1f55 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1141 | try | DATA_OP | seriesMeasure.ValueDataMembers.AddRange | (new string[] { dtChart.Columns[2].ColumnName }) | 데이터 객체 조작/조회 |  |  |  |
| AC-5088426c | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1143 | try | UI_PROP | seriesMeasure.LabelsVisibility | DevExpress.Utils.DefaultBoolean.True | 속성 LabelsVisibility 설정 |  |  |  |
| AC-4a1670c1 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1144 | try | UI_PROP | seriesMeasure.Label.Border.Visibility | DevExpress.Utils.DefaultBoolean.False | 속성 Visibility 설정 |  |  |  |
| AC-a6e0fc06 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1153 | try ▸ if (label != null) | UI_PROP | label.Position | BarSeriesLabelPosition.Center | 속성 Position 설정 |  |  |  |
| AC-e01862c9 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1154 | try ▸ if (label != null) | UI_PROP | label.TextColor | fontColor | 속성 TextColor 설정 |  |  |  |
| AC-faa8343e | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1155 | try ▸ if (label != null) | UI_PROP | label.BackColor | DefChartColor.Transparent | 속성 BackColor 설정 |  |  |  |
| AC-3d1da1b3 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1156 | try ▸ if (label != null) | UI_PROP | label.Font | fontChartBold_12 | 속성 Font 설정 |  |  |  |
| AC-4098524b | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1161 | try | FLAG | lineView1 | (LineSeriesView)seriesMeasure.View | 화면 필드/플래그 변경 |  |  |  |
| AC-75b444c1 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1162 | try | UI_PROP | lineView1.AxisY | firstY | 속성 AxisY 설정 |  |  |  |
| AC-8f92cbe2 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1163 | try | UI_PROP | lineView1.LineMarkerOptions.BorderVisible | false | 속성 BorderVisible 설정 |  |  |  |
| AC-68242051 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1164 | try | UI_PROP | lineView1.LineMarkerOptions.Color | ChartColor | 속성 Color 설정 |  |  |  |
| AC-2d93296f | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1165 | try | UI_PROP | lineView1.LineStyle.Thickness | 2 | 속성 Thickness 설정 |  |  |  |
| AC-732a2388 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1166 | try | UI_PROP | lineView1.MarkerVisibility | DevExpress.Utils.DefaultBoolean.True | 속성 MarkerVisibility 설정 |  |  |  |
| AC-5456eb41 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1167 | try | STATE | lineView1.Shadow.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-2604a728 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1168 | try | UI_PROP | lineView1.Color | ChartColor | 속성 Color 설정 |  |  |  |
| AC-ea4e68a7 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1169 | try | UI_PROP | lineView1.Shadow.Color | DefChartColor.Transparent | 속성 Color 설정 |  |  |  |
| AC-7ac0b1bc | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1171 | try | UI_PROP | lineView1.LineMarkerOptions.Kind | MarkerKind.Circle | 속성 Kind 설정 |  |  |  |
| AC-2d7cecdb | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1173 | try | UI_PROP | SCP0093_Chart.AxisY_RangeMin | firstY_start | 속성 AxisY_RangeMin 설정 |  |  |  |
| AC-6a9c3d12 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1174 | try | UI_PROP | SCP0093_Chart.AxisY_RangeMax | firstY_end | 속성 AxisY_RangeMax 설정 |  |  |  |
| AC-634bdecf | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1175 | try | UI_PROP | SCP0093_Chart.AxisY_gridSpacing | firstY_spacing | 속성 AxisY_gridSpacing 설정 |  |  |  |
| AC-b87c8e3d | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1176 | try | UI_PROP | SCP0093_Chart.AxisY_gridLineVisible | false | 속성 AxisY_gridLineVisible 설정 |  |  |  |
| AC-01ac1afb | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1177 | try | UI_PROP | SCP0093_Chart.AxisY_labelVisible | false | 속성 AxisY_labelVisible 설정 |  |  |  |
| AC-61484a76 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1178 | try | CALL_EXT | SCP0093_Chart.SetChart_AxisY | (chartMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9272d883 | cboUnitAmount.SelectedIndexChanged [try ▸ if (measure_unit.m… 외 2 | SCP0093_DIO_Trend_Report.cs:1187 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DIO_Trend_Report.SetChartBar

진입점: cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_unit.measure_call == "MEASURE_NAME") ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[3]) == false)] / cboUnitQty.SelectedIndexChanged [try ▸ else of (measure_unit.measure_call == "MEASURE_NAME") ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[3]) == false)] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false) ▸ try ▸ else of (measure_unit.measure_call == "MEASURE_NAME") ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccc2befa | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1065 | try | UI_PROP | series.Name | chartName | 속성 Name 설정 |  |  |  |
| AC-9dbe2ab0 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1066 | try | UI_PROP | series.LegendText | chartName | 속성 LegendText 설정 |  |  |  |
| AC-6fc1db2e | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1067 | try | DATA_OP | chartMain.Series.Add | (series) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1d76148 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1068 | try | LIST_CLEAR | series.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-ae3c38ae | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1069 | try | LIST_BIND | series.DataSource | dtChart | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-811bd888 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1070 | try | UI_PROP | series.ArgumentDataMember | dtChart.Columns[1].ColumnName | 속성 ArgumentDataMember 설정 |  |  |  |
| AC-f64cb127 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1071 | try | DATA_OP | series.ValueDataMembers.AddRange | (new string[] { dtChart.Columns[2].ColumnName }) | 데이터 객체 조작/조회 |  |  |  |
| AC-f75468d3 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1072 | try | UI_PROP | series.View.Color | color | 속성 Color 설정 |  |  |  |
| AC-8aba1812 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1075 | try | UI_PROP | series.LabelsVisibility | DevExpress.Utils.DefaultBoolean.True | 속성 LabelsVisibility 설정 |  |  |  |
| AC-bb4586c0 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1076 | try | UI_PROP | series.Label.Border.Visibility | DevExpress.Utils.DefaultBoolean.False | 속성 Visibility 설정 |  |  |  |
| AC-962455c2 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1080 | try ▸ if (label != null) | UI_PROP | label.Position | position | 속성 Position 설정 |  |  |  |
| AC-d6504512 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1081 | try ▸ if (label != null) | UI_PROP | label.TextColor | fontColor | 속성 TextColor 설정 |  |  |  |
| AC-4ddf9a2d | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1082 | try ▸ if (label != null) | UI_PROP | label.BackColor | DefChartColor.Transparent | 속성 BackColor 설정 |  |  |  |
| AC-5cbc1ad9 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1083 | try ▸ if (label != null) | UI_PROP | label.Font | fontChartBold_9 | 속성 Font 설정 |  |  |  |
| AC-b5e8b1a3 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1087 | try | UI_PROP | barSeriesView.FillStyle.FillMode | FillMode.Solid | 속성 FillMode 설정 |  |  |  |
| AC-0e752bd6 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1088 | try | UI_PROP | barSeriesView.Color | color | 속성 Color 설정 |  |  |  |
| AC-a49ef388 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1089 | try | UI_PROP | barSeriesView.Transparency | 80 | 속성 Transparency 설정 |  |  |  |
| AC-dd02d61e | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1090 | try | UI_PROP | barSeriesView.AxisY | axisY | 속성 AxisY 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.SetChartLine

진입점: cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_unit.measure_call == "MEASURE_NAME") ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false)] / cboUnitQty.SelectedIndexChanged [try ▸ else of (measure_unit.measure_call == "MEASURE_NAME") ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false)] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false) ▸ try ▸ else of (measure_unit.measure_call == "MEASURE_NAME") ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b5429b3 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1022 | try | UI_PROP | series.Name | chartName | 속성 Name 설정 |  |  |  |
| AC-82fb014f | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1023 | try | UI_PROP | series.LegendText | chartName | 속성 LegendText 설정 |  |  |  |
| AC-fbae6b4f | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1024 | try | DATA_OP | chartMain.Series.Add | (series) | 데이터 객체 조작/조회 |  |  |  |
| AC-29237c82 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1025 | try | LIST_CLEAR | series.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-5602c5e2 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1026 | try | LIST_BIND | series.DataSource | dtChart | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-515571bb | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1027 | try | UI_PROP | series.ArgumentDataMember | dtChart.Columns[1].ColumnName | 속성 ArgumentDataMember 설정 |  |  |  |
| AC-21064c81 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1028 | try | DATA_OP | series.ValueDataMembers.AddRange | (new string[] { dtChart.Columns[2].ColumnName }) | 데이터 객체 조작/조회 |  |  |  |
| AC-177073a4 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1030 | try | UI_PROP | series.LabelsVisibility | DevExpress.Utils.DefaultBoolean.True | 속성 LabelsVisibility 설정 |  |  |  |
| AC-ea942443 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1031 | try | UI_PROP | series.Label.Border.Visibility | DevExpress.Utils.DefaultBoolean.False | 속성 Visibility 설정 |  |  |  |
| AC-22bdf5da | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1036 | try ▸ if (label != null) | UI_PROP | label.Position | position | 속성 Position 설정 |  |  |  |
| AC-3beb08aa | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1037 | try ▸ if (label != null) | UI_PROP | label.TextColor | fontColor | 속성 TextColor 설정 |  |  |  |
| AC-dd23baa4 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1038 | try ▸ if (label != null) | UI_PROP | label.BackColor | System.Drawing.Color.Transparent | 속성 BackColor 설정 |  |  |  |
| AC-bdfb4468 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1039 | try ▸ if (label != null) | UI_PROP | label.Font | fontChartBold_12 | 속성 Font 설정 |  |  |  |
| AC-a86da2f2 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1046 | try | UI_PROP | lineview.AxisY | axisY | 속성 AxisY 설정 |  |  |  |
| AC-0cc0c13c | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1047 | try | UI_PROP | lineview.LineMarkerOptions.BorderVisible | false | 속성 BorderVisible 설정 |  |  |  |
| AC-afdae4f9 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1048 | try | UI_PROP | lineview.LineMarkerOptions.Color | color | 속성 Color 설정 |  |  |  |
| AC-01efecc7 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1049 | try | UI_PROP | lineview.LineStyle.Thickness | 2 | 속성 Thickness 설정 |  |  |  |
| AC-4cd8e8e0 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1050 | try | UI_PROP | lineview.MarkerVisibility | DevExpress.Utils.DefaultBoolean.True | 속성 MarkerVisibility 설정 |  |  |  |
| AC-783a519a | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1051 | try | STATE | lineview.Shadow.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-21de6fa8 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1052 | try | UI_PROP | lineview.Color | color | 속성 Color 설정 |  |  |  |
| AC-cef8ebc7 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1053 | try | UI_PROP | lineview.Shadow.Color | DefChartColor.Transparent | 속성 Color 설정 |  |  |  |
| AC-f2a77c08 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1054 | try | UI_PROP | lineview.LineMarkerOptions.Kind | MarkerKind.Circle | 속성 Kind 설정 |  |  |  |
| AC-1f61f81e | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1055 | try | UI_PROP | lineview.LineStyle.Thickness | 1 | 속성 Thickness 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.SetChartRange

진입점: cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_unit.measure_call == "MEASURE_NAME") ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[5]) == false)] / cboUnitQty.SelectedIndexChanged [try ▸ else of (measure_unit.measure_call == "MEASURE_NAME") ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[5]) == false)] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds.Tables[0]) == false) ▸ try ▸ else of (measure_unit.measure_call == "MEASURE_NAME") ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2537ee3 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:937 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | FLAG | baseY_start | ScpUtils.GetValueLong(ds.Tables[5].Rows[0]["data_min"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-818e0cc2 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:937 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | CALL_EXT | ScpUtils.GetValueLong | (ds.Tables[5].Rows[0]["data_min"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb73a60d | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:938 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | FLAG | baseY_end | ScpUtils.GetValueLong(ds.Tables[5].Rows[0]["data_max"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c8b0928 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:938 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | CALL_EXT | ScpUtils.GetValueLong | (ds.Tables[5].Rows[0]["data_max"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51652833 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:939 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | FLAG | baseY_spacing | ScpUtils.GetValueLong(ds.Tables[5].Rows[0]["spacing"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-a428be7f | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:939 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | CALL_EXT | ScpUtils.GetValueLong | (ds.Tables[5].Rows[0]["spacing"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5539a26d | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:941 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | FLAG | firstY_start | baseY_start | 화면 필드/플래그 변경 |  |  |  |
| AC-e83e0ffb | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:942 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | FLAG | firstY_end | baseY_end | 화면 필드/플래그 변경 |  |  |  |
| AC-800aab3e | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:943 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | FLAG | firstY_spacing | baseY_spacing | 화면 필드/플래그 변경 |  |  |  |
| AC-02a485cb | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:945 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | FLAG | secondY_start | baseY_start | 화면 필드/플래그 변경 |  |  |  |
| AC-d35ef929 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:946 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | FLAG | secondY_end | baseY_end | 화면 필드/플래그 변경 |  |  |  |
| AC-771b7396 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:947 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 0) | FLAG | secondY_spacing | baseY_spacing | 화면 필드/플래그 변경 |  |  |  |
| AC-480ffbdc | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:954 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 1) | FLAG | firstY_start | ScpUtils.GetValueLong(ds.Tables[5].Rows[1]["data_min"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-473a0ddf | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:954 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 1) | CALL_EXT | ScpUtils.GetValueLong | (ds.Tables[5].Rows[1]["data_min"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffe76fc8 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:955 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 1) | FLAG | firstY_end | ScpUtils.GetValueLong(ds.Tables[5].Rows[1]["data_max"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-8b4ec5a0 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:955 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 1) | CALL_EXT | ScpUtils.GetValueLong | (ds.Tables[5].Rows[1]["data_max"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e849e688 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:956 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 1) | FLAG | firstY_spacing | ScpUtils.GetValueLong(ds.Tables[5].Rows[1]["spacing"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-8bcd1aa3 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:956 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 1) | CALL_EXT | ScpUtils.GetValueLong | (ds.Tables[5].Rows[1]["spacing"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d37763d6 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:963 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 2) | FLAG | secondY_start | ScpUtils.GetValueLong(ds.Tables[5].Rows[2]["data_min"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf28f656 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:963 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 2) | CALL_EXT | ScpUtils.GetValueLong | (ds.Tables[5].Rows[2]["data_min"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-29377732 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:964 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 2) | FLAG | secondY_end | ScpUtils.GetValueLong(ds.Tables[5].Rows[2]["data_max"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-2d0de1b9 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:964 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 2) | CALL_EXT | ScpUtils.GetValueLong | (ds.Tables[5].Rows[2]["data_max"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-be170ac6 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:965 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 2) | FLAG | secondY_spacing | ScpUtils.GetValueLong(ds.Tables[5].Rows[2]["spacing"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-baddede7 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:965 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false && ScpUtils.CheckDataEmpty(ds.Tables[5]) == false) ▸ if (ds.Tables[5].Rows.Count > 2) | CALL_EXT | ScpUtils.GetValueLong | (ds.Tables[5].Rows[2]["spacing"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-42129a94 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:976 | catch ((Exception ex)) ▸ switch (GraphType) case "AMOUNT": | FLAG | baseY_start | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-98786f3c | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:977 | catch ((Exception ex)) ▸ switch (GraphType) case "AMOUNT": | FLAG | baseY_end | 80000 * 1000 | 화면 필드/플래그 변경 |  |  |  |
| AC-71aeaf0a | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:978 | catch ((Exception ex)) ▸ switch (GraphType) case "AMOUNT": | FLAG | baseY_spacing | 8000 * 1000 | 화면 필드/플래그 변경 |  |  |  |
| AC-d4a32bf0 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:980 | catch ((Exception ex)) ▸ switch (GraphType) case "AMOUNT": | FLAG | firstY_start | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-abd713a9 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:981 | catch ((Exception ex)) ▸ switch (GraphType) case "AMOUNT": | FLAG | firstY_end | 1500000000 | 화면 필드/플래그 변경 |  |  |  |
| AC-4c991b35 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:982 | catch ((Exception ex)) ▸ switch (GraphType) case "AMOUNT": | FLAG | firstY_spacing | 1500000 * 1000 | 화면 필드/플래그 변경 |  |  |  |
| AC-1003c63e | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:984 | catch ((Exception ex)) ▸ switch (GraphType) case "AMOUNT": | FLAG | secondY_start | -120 | 화면 필드/플래그 변경 |  |  |  |
| AC-47f8965f | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:985 | catch ((Exception ex)) ▸ switch (GraphType) case "AMOUNT": | FLAG | secondY_end | 120 | 화면 필드/플래그 변경 |  |  |  |
| AC-62560f12 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:986 | catch ((Exception ex)) ▸ switch (GraphType) case "AMOUNT": | FLAG | secondY_spacing | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-a9130611 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:991 | catch ((Exception ex)) ▸ switch (GraphType) case "COUNT": default: | FLAG | baseY_start | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-77d0a050 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:992 | catch ((Exception ex)) ▸ switch (GraphType) case "COUNT": default: | FLAG | baseY_end | 80000 | 화면 필드/플래그 변경 |  |  |  |
| AC-9a493b62 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:993 | catch ((Exception ex)) ▸ switch (GraphType) case "COUNT": default: | FLAG | baseY_spacing | 8000 | 화면 필드/플래그 변경 |  |  |  |
| AC-31adedd6 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:995 | catch ((Exception ex)) ▸ switch (GraphType) case "COUNT": default: | FLAG | firstY_start | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-1e779837 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:996 | catch ((Exception ex)) ▸ switch (GraphType) case "COUNT": default: | FLAG | firstY_end | 1500000000 | 화면 필드/플래그 변경 |  |  |  |
| AC-1b078a8c | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:997 | catch ((Exception ex)) ▸ switch (GraphType) case "COUNT": default: | FLAG | firstY_spacing | 1500000 | 화면 필드/플래그 변경 |  |  |  |
| AC-d5d719b4 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:999 | catch ((Exception ex)) ▸ switch (GraphType) case "COUNT": default: | FLAG | secondY_start | -120 | 화면 필드/플래그 변경 |  |  |  |
| AC-7e93c317 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1000 | catch ((Exception ex)) ▸ switch (GraphType) case "COUNT": default: | FLAG | secondY_end | 120 | 화면 필드/플래그 변경 |  |  |  |
| AC-d9174112 | cboUnitAmount.SelectedIndexChanged [try ▸ else of (measure_u… 외 2 | SCP0093_DIO_Trend_Report.cs:1001 | catch ((Exception ex)) ▸ switch (GraphType) case "COUNT": default: | FLAG | secondY_spacing | 1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.SetCheckCategory

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a22ff952 | this.Load | SCP0093_DIO_Trend_Report.cs:2017 |  | VALUE_SET | chkCategoryCC.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-88d31e9c | this.Load | SCP0093_DIO_Trend_Report.cs:2018 |  | VALUE_SET | chkCategoryPack.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-492d7a5e | this.Load | SCP0093_DIO_Trend_Report.cs:2019 |  | VALUE_SET | chkCategoryCell.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.SetClearMeasureData

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26f09ab8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1976 |  | FLAG | measure_unit | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d4b07bc1 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1977 |  | FLAG | ds_unit | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.SetColumnSearchType

진입점: this.Load / cboSearchType.SelectedIndexChanged / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (this.spdMain.Visible) ▸ try] / EditButton [if (IsEditMode == false) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26d26f8d | this.Load 외 6 | SCP0093_DIO_Trend_Report.cs:2050 | try | GRID_SET | siMain.ActiveSheet.Columns[DefMainColumns.MODEL].Visible | isVisible | 그리드 속성/값 설정 |  |  |  |
| AC-3a0bff90 | this.Load 외 6 | SCP0093_DIO_Trend_Report.cs:2051 | try | GRID_SET | siMain.ActiveSheet.Columns[DefMainColumns.NICK_NAME].Visible | isVisible | 그리드 속성/값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.SetHeaderColor

진입점: this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_") == 0 \|\| ColName.IndexOf("Q_") == 0) ▸ if (ColName.IndexOf("M_") == 0)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_") == 0 \|\| ColName.IndexOf("Q_") == 0) ▸ if (ColName.IndexOf("M_") == 0)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ for (iCol < siMain.ActiveShee…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acbc5d9a | this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ e… 외 5 | SCP0093_DIO_Trend_Report.cs:550 | if (useReason.Equals("Y")) | FLAG | headerColor | DefGridColor.REASON | 화면 필드/플래그 변경 |  |  |  |
| AC-88555f20 | this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ e… 외 5 | SCP0093_DIO_Trend_Report.cs:584 | try ▸ if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e6a3597 | this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ e… 외 5 | SCP0093_DIO_Trend_Report.cs:587 | try ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d9bb4a5 | this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ e… 외 5 | SCP0093_DIO_Trend_Report.cs:589 | try | FLAG | useReason | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-33e69f72 | this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ e… 외 5 | SCP0093_DIO_Trend_Report.cs:591 | try | FLAG | useReasonColName | GetColumnNameReason(sColumnName) | 화면 필드/플래그 변경 |  |  |  |
| AC-f620be75 | this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ e… 외 5 | SCP0093_DIO_Trend_Report.cs:592 | try | FLAG | useReason | ScpUtils.GetCellValue(siMain, 0, useReasonColName) | 화면 필드/플래그 변경 |  |  |  |
| AC-160006a2 | this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ e… 외 5 | SCP0093_DIO_Trend_Report.cs:596 | try ▸ if (useReason.Equals("Y")) | GRID_SET | siMain.Sheet().ColumnHeader.Cells[1, iCol].ForeColor | DefGridColor.REASON | 그리드 속성/값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.SetHeaderColorOld

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d34e609 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:563 |  | CALL_EXT | ScpUtils.checkAfterNowMonth | (sColumnMonth, cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e90aa55 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:566 | if (iAfterNowMonth > 0) | FLAG | headerColor | DefGridColor.FUTURE | 화면 필드/플래그 변경 |  |  |  |
| AC-4883abfc | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:570 | else of (iAfterNowMonth > 0) ▸ if (iAfterNowMonth == 0) | FLAG | headerColor | DefGridColor.PRESENT | 화면 필드/플래그 변경 |  |  |  |
| AC-749708ce | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:574 | else of (iAfterNowMonth > 0) ▸ else of (iAfterNowMonth == 0) | FLAG | headerColor | DefGridColor.PAST | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.SetMeasureData

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (measure.aggr_dv.Equals("ET")) ▸ try ▸ if (ScpUtils.CheckDataEmpty(dsChartMeasure) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-828fe744 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1982 |  | FLAG | measure_unit | measure | 화면 필드/플래그 변경 |  |  |  |
| AC-16767274 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:1983 |  | FLAG | ds_unit | ds | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.SetPastColumnColor

진입점: this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_") == 0 \|\| ColName.IndexOf("Q_") == 0) ▸ if (ColName.IndexOf("M_") == 0)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_") == 0 \|\| ColName.IndexOf("Q_") == 0) ▸ if (ColName.IndexOf("M_") == 0)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ for (iCol < siMain.ActiveShee…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eac7905e | this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ e… 외 5 | SCP0093_DIO_Trend_Report.cs:608 | if (ColName.IndexOf("M_") == 0) | CALL_EXT | ScpUtils.CheckDiffMonth | (ColName, PLAN_DATE_YYYYMM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc24afbe | this.Load [for (iCol < siMain.ActiveSheet.Columns.Count) ▸ e… 외 5 | SCP0093_DIO_Trend_Report.cs:610 | if (ColName.IndexOf("M_") == 0) ▸ if (!string.IsNullOrWhiteSpace(PLAN_DATE_YYYYMM) && ScpUtils.CheckDiffMonth(ColName, PLAN_DATE_YYYYMM) < 0… | GRID_SET | siMain.ActiveSheet.Columns[iCol].BackColor | DefGridColor.CELL_PAST | 그리드 속성/값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.SetSaveStatus

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16be88ed | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0093_DIO_Trend_Report.cs:1970 |  | FLAG | save_status | status | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.SetSpreadColumn

진입점: this.Load / cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (this.spdMain.Visible) ▸ finally ▸ if (ScpUtils.CheckDataEmpty(ds) == false) ▸ if (ds.Tables[0].Rows.Count > 0)] / EditButton [if (IsEditMode == false) ▸ try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ finally ▸ if (ScpUtils.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d62621da | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:712 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_") ==… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c41312e0 | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:716 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c53a5c4e | this.Load 외 5 | SCP0093_DIO_Trend_Report.cs:727 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0093_DIO_Trend_Report.SetTableSchema_Chart

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (measure.aggr_dv.Equals("ET")) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bcee44b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2474 |  | DATA_OP | dtReturn.Columns.Add | ("DATA_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cbfcd0f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2475 |  | DATA_OP | dtReturn.Columns.Add | ("yyyymm", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d72ac6ae | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2476 |  | DATA_OP | dtReturn.Columns.Add | ("value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3852e79a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2478 |  | FLAG | dtChart | dtReturn | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.SetTableSchema_ChartRange

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (measure.aggr_dv.Equals("ET")) ▸ try ▸ try ▸ if (dtRange == null \|\| dtRange.Columns.Count == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-397d2961 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2485 |  | DATA_OP | dtReturn.Columns.Add | ("GUBUN", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f16f2fb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2486 |  | DATA_OP | dtReturn.Columns.Add | ("DATA_MIN", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-47e66458 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2487 |  | DATA_OP | dtReturn.Columns.Add | ("DATA_MAX", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab9233da | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0093_DIO_Trend_Report.cs:2488 |  | DATA_OP | dtReturn.Columns.Add | ("SPACING", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |

## SCP0093_DIO_Trend_Report.SetUnitAmount

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0) ▸ for (i < dsOrigianlCopy.Tables[0].Rows.Count)] / cboUnitAmount.SelectedIndexChanged [for (i < dsOrigianlCopy.Tables[0].Rows.Count)] / cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tables[0].Rows.Count)] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ try ▸ if (ScpUti…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-128285f9 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2069 | switch (cboUnitAmount.SelectedIndex) case 0: | FLAG | dbKrwDivideAmount | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-c013bea3 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2072 | switch (cboUnitAmount.SelectedIndex) case 1: | FLAG | dbKrwDivideAmount | 1000 | 화면 필드/플래그 변경 |  |  |  |
| AC-3512d69c | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2075 | switch (cboUnitAmount.SelectedIndex) case 2: | FLAG | dbKrwDivideAmount | 1000000 | 화면 필드/플래그 변경 |  |  |  |
| AC-5f31153e | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2078 | switch (cboUnitAmount.SelectedIndex) case 3: | FLAG | dbKrwDivideAmount | 100000000 | 화면 필드/플래그 변경 |  |  |  |
| AC-aa9fafd1 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2081 | switch (cboUnitAmount.SelectedIndex) default: | FLAG | dbKrwDivideAmount | 1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.SetUnitQty

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try ▸ if (dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0) ▸ for (i < dsOrigianlCopy.Tables[0].Rows.Count)] / cboUnitAmount.SelectedIndexChanged [for (i < dsOrigianlCopy.Tables[0].Rows.Count)] / cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tables[0].Rows.Count)] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ try ▸ if (ScpUti…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0caf3db4 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2090 | switch (cboUnitQty.SelectedIndex) case 0: | FLAG | dbDivideQty | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-51616942 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2093 | switch (cboUnitQty.SelectedIndex) case 1: | FLAG | dbDivideQty | 1000 | 화면 필드/플래그 변경 |  |  |  |
| AC-84711bdd | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2096 | switch (cboUnitQty.SelectedIndex) case 2: | FLAG | dbDivideQty | 1000000 | 화면 필드/플래그 변경 |  |  |  |
| AC-c594dd77 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2099 | switch (cboUnitQty.SelectedIndex) case 3: | FLAG | dbDivideQty | 100000000 | 화면 필드/플래그 변경 |  |  |  |
| AC-1543dcb9 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 6 | SCP0093_DIO_Trend_Report.cs:2102 | switch (cboUnitQty.SelectedIndex) default: | FLAG | dbDivideQty | 1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DIO_Trend_Report.SetVisibleColumnCycle

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5013efbe | this.Load | SCP0093_DIO_Trend_Report.cs:2000 | try ▸ for (i < siMain.ActiveSheet.ColumnCount) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(day), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0093_DIO_Trend_Report.SetVisibleTargetCell

진입점: this.Load [try] / cboSearchType.SelectedIndexChanged / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (IsEditMode == false) ▸ try ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try] / FindButton [if (this.spdMain.Visible) ▸ try ▸ try] / EditButton [if (IsEditMode == false) ▸ try ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-967d40fb | this.Load [try] 외 6 | SCP0093_DIO_Trend_Report.cs:689 |  | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefMainColumns.TARGET_CELL), isVisible) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0093_DIO_Trend_Report.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6853a94 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2783 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (e.ColumnHeader) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4903b9d9 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2795 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (!iseditcolumn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe1acac9 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2802 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | UI_PROP | measure.measure_call | selCol | 속성 measure_call 설정 |  |  |  |
| AC-985f0850 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2803 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | UI_PROP | measure.category | GetCellValue(e.Row, DefMainColumns.CATEGORY) | 속성 category 설정 |  |  |  |
| AC-0c880ac5 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2804 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | UI_PROP | measure.category_dv | GetCellValue(e.Row, DefMainColumns.CATEGORY_DV) | 속성 category_dv 설정 |  |  |  |
| AC-fb2fef41 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2805 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | UI_PROP | measure.aggr_dv | GetCellValue(e.Row, DefMainColumns.AGGR_DV) | 속성 aggr_dv 설정 |  |  |  |
| AC-d96cafa8 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2806 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | UI_PROP | measure.model | GetCellValue(e.Row, DefMainColumns.MODEL) | 속성 model 설정 |  |  |  |
| AC-57c56eab | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2807 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | UI_PROP | measure.cell_group | GetCellValue(e.Row, DefMainColumns.CELL_GROUP) | 속성 cell_group 설정 |  |  |  |
| AC-9b8f0bb5 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2808 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | UI_PROP | measure.measure | GetCellValue(e.Row, DefMainColumns.MEASURE_NAME) | 속성 measure 설정 |  |  |  |
| AC-eb0c6609 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2809 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | UI_PROP | measure.measure_type | measure.GetMeasureType(measure.measure) | 속성 measure_type 설정 |  |  |  |
| AC-a12a4ae3 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2809 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | CALL_EXT | measure.GetMeasureType | (measure.measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8666157 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2812 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | DATA_OP | selCol.Contains | ("_AUTO") | 데이터 객체 조작/조회 |  |  |  |
| AC-246c0a17 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2820 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (me… | UI_PROP | measure.measure_call | "MEASURE_NAME" | 속성 measure_call 설정 |  |  |  |
| AC-07648461 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2822 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ if (selCol.IndexOf("MODEL") == 0) ▸ if (me… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2396b9f8 | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2831 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ else of (selCol.IndexOf("MODEL") == 0) ▸ i… | UI_PROP | measure.measure_call | "MEASURE_NAME" | 속성 measure_call 설정 |  |  |  |
| AC-db93a5eb | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2833 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ else of (selCol.IndexOf("MODEL") == 0) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f38d8f1e | this.spdMain.CellDoubleClick | SCP0093_DIO_Trend_Report.cs:2846 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.Contains("_AUTO")) ▸ else of (selCol.IndexOf("MODEL") == 0) ▸ e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DioTrendReportPopup.ActiveSheet_CellChanged

진입점: spdMain.ActiveSheet.CellChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b7325fb | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:997 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d74dffc6 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1000 | if (siMain.ActiveSheet.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c1a0dc0 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1002 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d120f20b | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1007 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | cellValue | ScpUtils.GetCellValue(siMain, e.Row, e.Column) | 화면 필드/플래그 변경 |  |  |  |
| AC-b64b5729 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1008 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | REASON_ID | ScpUtils.GetCellValue(siMain, e.Row, iCol_REASON_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac4a6bb1 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1010 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (REASON_ID.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16998e0d | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1015 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (LastChange… | FLAG | Change_Value | ScpUtils.GetCellValue(siMain, e.Row, e.Column) | 화면 필드/플래그 변경 |  |  |  |
| AC-11bcfffc | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1018 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (LastChange… | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95a1d33d | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1019 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (LastChange… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d56a477 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1021 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (LastChange… | FLAG | LastChange_Value | ScpUtils.GetCellValue(siMain, e.Row, e.Column) | 화면 필드/플래그 변경 |  |  |  |
| AC-667a3872 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1024 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | LastChange_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-28b1bcd9 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1025 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | LastChange_Col | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-085c3e11 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1026 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | iCol_CELL_GROUP | siMain.GetColumnIndex(DefColumns.CELL_GROUP) | 화면 필드/플래그 변경 |  |  |  |
| AC-2616a266 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1027 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | iCol_REASON_ID | siMain.GetColumnIndex(DefColumns.REASON_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-9770410b | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1028 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | iCol_ITEM_ID | siMain.GetColumnIndex(DefColumns.ITEM_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-3cca221f | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1029 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | iCol_QUANTITY | siMain.GetColumnIndex(DefColumns.QUANTITY) | 화면 필드/플래그 변경 |  |  |  |
| AC-e836cba2 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1030 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | iCol_AMOUNT | siMain.GetColumnIndex(DefColumns.AMOUNT) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d45e14c | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1031 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | ITEM_ID | ScpUtils.GetCellValue(siMain, e.Row, iCol_ITEM_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-2dad8f70 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1032 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | cell_group | ScpUtils.GetCellValue(siMain, e.Row, iCol_CELL_GROUP) | 화면 필드/플래그 변경 |  |  |  |
| AC-be22b745 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1033 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | Row_Start | e.Row - 20 | 화면 필드/플래그 변경 |  |  |  |
| AC-9adc69e8 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1034 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | Row_End | e.Row + 20 | 화면 필드/플래그 변경 |  |  |  |
| AC-e98ac03f | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1035 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | iRow_SUM | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-c7842c13 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1036 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | iRow_GAP | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-d1b8de1a | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1039 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (Row_Start … | FLAG | Row_Start | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-13cba8d6 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1041 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (Row_End > … | FLAG | Row_End | siMain.ActiveSheet.RowCount | 화면 필드/플래그 변경 |  |  |  |
| AC-01971da0 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1046 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (e.Column =… | FLAG | iCol_ChangeColumn | iCol_QUANTITY | 화면 필드/플래그 변경 |  |  |  |
| AC-12d5a7fe | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1048 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ else of (e.Col… | FLAG | iCol_ChangeColumn | iCol_AMOUNT | 화면 필드/플래그 변경 |  |  |  |
| AC-a029e298 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1055 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | cell_group | ScpUtils.GetCellValue(siMain, e.Row, iCol_CELL_GROUP) | 화면 필드/플래그 변경 |  |  |  |
| AC-da33fc39 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1058 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (string.IsN… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88bdabbb | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1063 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow < Ro… | FLAG | ROW_CELL_Group | ScpUtils.GetCellValue(siMain, iRow, iCol_CELL_GROUP) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b07558a | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1064 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow < Ro… | FLAG | ROW_REASON_ID | ScpUtils.GetCellValue(siMain, iRow, iCol_REASON_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-668b6ed9 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1067 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow < Ro… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d87f28b | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1071 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow < Ro… | FLAG | gRow_End | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-1017bab1 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1073 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow < Ro… | FLAG | gRow_Start | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-157ca00f | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1078 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | Row_Start | gRow_Start | 화면 필드/플래그 변경 |  |  |  |
| AC-540ba741 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1079 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | Row_End | gRow_End | 화면 필드/플래그 변경 |  |  |  |
| AC-af55fe1a | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1085 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow <= R… | FLAG | ROW_ITEM_ID | ScpUtils.GetCellValue(siMain, iRow, iCol_ITEM_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-8f68a3ce | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1086 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow <= R… | FLAG | ROW_CELL_Group | ScpUtils.GetCellValue(siMain, iRow, iCol_CELL_GROUP) | 화면 필드/플래그 변경 |  |  |  |
| AC-e065a7d9 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1087 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow <= R… | FLAG | ROW_REASON_ID | ScpUtils.GetCellValue(siMain, iRow, iCol_REASON_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-90f0b972 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1090 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow <= R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93f147ca | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1098 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow <= R… | FLAG | iRow_SUM | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-037e5021 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1101 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow <= R… | FLAG | iRow_GAP | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-5cee975d | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1113 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9f2c0416 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1115 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (iRow_SUM <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7c5d334b | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1116 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (iRow_GAP <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0fd8de41 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1118 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | SUM_VALUE_BEFORE_CHANGE | ScpUtils.GetValueDecimal(dtOriginal.Rows[iRow_SUM][iCol_ChangeColumn - 1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-9b48bbf0 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1118 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | CALL_EXT | ScpUtils.GetValueDecimal | (dtOriginal.Rows[iRow_SUM][iCol_ChangeColumn - 1]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d192ac4 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1119 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | SUM_VALUE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b86ee495 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1123 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | GAP_VALUE_BEFORE_CHANGE | ScpUtils.GetValueDecimal(dtOriginal.Rows[iRow_GAP][iCol_ChangeColumn - 1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-7de3ab02 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1123 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | CALL_EXT | ScpUtils.GetValueDecimal | (dtOriginal.Rows[iRow_GAP][iCol_ChangeColumn - 1]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f08b91ea | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1124 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | GAP_VALUE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-af9393da | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1131 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow < Ro… | FLAG | ROW_ITEM_ID | ScpUtils.GetCellValue(siMain, iRow, iCol_ITEM_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-02446e3a | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1132 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow < Ro… | FLAG | ROW_REASON_ID | ScpUtils.GetCellValue(siMain, iRow, iCol_REASON_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-67cc6091 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1133 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow < Ro… | FLAG | ROW_VALUE | ScpUtils.GetValueDecimal(ScpUtils.GetCellValue(siMain, iRow, iCol_ChangeColumn)) | 화면 필드/플래그 변경 |  |  |  |
| AC-1152ee91 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1133 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow < Ro… | CALL_EXT | ScpUtils.GetValueDecimal | (ScpUtils.GetCellValue(siMain, iRow, iCol_ChangeColumn)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-383e583c | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1144 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ for (iRow < Ro… | FLAG | SUM_VALUE | += ROW_VALUE | 화면 필드/플래그 변경 |  |  |  |
| AC-41072c20 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1153 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, 0].Text | "M" | 그리드 속성/값 설정 |  |  |  |
| AC-c894bbfa | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1155 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | GRID_SET | siMain.ActiveSheet.Cells[iRow_SUM, 0].Text | "M" | 그리드 속성/값 설정 |  |  |  |
| AC-7513e440 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1156 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | GRID_SET | siMain.ActiveSheet.Cells[iRow_SUM, iCol_ChangeColumn].Value | SUM_VALUE | 그리드 속성/값 설정 |  |  |  |
| AC-318b0fc7 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1157 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | GRID_SET | siMain.ActiveSheet.Cells[iRow_SUM, iCol_ChangeColumn].ForeColor | DefGridColor.Red | 그리드 속성/값 설정 |  |  |  |
| AC-0e87e272 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1159 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | FLAG | GAP_VALUE | GAP_VALUE_BEFORE_CHANGE - SUM_VALUE | 화면 필드/플래그 변경 |  |  |  |
| AC-a67ba949 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1160 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | GRID_SET | siMain.ActiveSheet.Cells[iRow_GAP, 0].Text | "M" | 그리드 속성/값 설정 |  |  |  |
| AC-bee3c010 | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1161 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | GRID_SET | siMain.ActiveSheet.Cells[iRow_GAP, iCol_ChangeColumn].Value | GAP_VALUE | 그리드 속성/값 설정 |  |  |  |
| AC-cacafb9b | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1162 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) | GRID_SET | siMain.ActiveSheet.Cells[iRow_GAP, iCol_ChangeColumn].ForeColor | DefGridColor.Red | 그리드 속성/값 설정 |  |  |  |
| AC-f2959b3b | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1175 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-302dea4c | spdMain.ActiveSheet.CellChanged | SCP0093_DioTrendReportPopup.cs:1179 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DioTrendReportPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab1bae01 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0093_DioTrendReportPopup.cs:907 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DioTrendReportPopup.BtnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bad8fa7c | this.btnItemId.Click | SCP0093_DioTrendReportPopup.cs:940 |  | POPUP | new GSCM.SCM.Popup.UIL.SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9f857a9e | this.btnItemId.Click | SCP0093_DioTrendReportPopup.cs:941 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-dcc033f9 | this.btnItemId.Click | SCP0093_DioTrendReportPopup.cs:942 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-51765499 | this.btnItemId.Click | SCP0093_DioTrendReportPopup.cs:943 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-649e6a61 | this.btnItemId.Click | SCP0093_DioTrendReportPopup.cs:949 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0093_DioTrendReportPopup.ChangeGridQuantityAmount

진입점: spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-719ced8c | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1188 | try | FLAG | LastChange_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-f37acd0b | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1189 | try | FLAG | LastChange_Col | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-96ed3f96 | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1191 | try | FLAG | iCol_QUANTITY | siMain.GetColumnIndex(DefColumns.QUANTITY) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b1267fe | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1192 | try | FLAG | iCol_AMOUNT | siMain.GetColumnIndex(DefColumns.AMOUNT) | 화면 필드/플래그 변경 |  |  |  |
| AC-767d567e | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1199 | try | CALL_EXT | ScpUtils.GetValueDecimal | (ScpUtils.GetCellValue(siMain, e.Row, iCol_QUANTITY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f841f09d | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1204 | try ▸ if (row_quantity == 0) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, iCol_AMOUNT].Value | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-26e8c5d2 | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1205 | try ▸ if (row_quantity == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df96ce7d | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1216 | try | GRID_SET | siMain.ActiveSheet.Cells[e.Row, iCol_AMOUNT].Value | row_amount | 그리드 속성/값 설정 |  |  |  |
| AC-96a9934f | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1220 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCP0093_DioTrendReportPopup.CloseButton

진입점: CloseButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16e87fe4 | CloseButton | SCP0093_DioTrendReportPopup.cs:359 | if (isChange) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-e05c568e | CloseButton | SCP0093_DioTrendReportPopup.cs:361 | else of (isChange) | UI_PROP | this.DialogResult | DialogResult.None | 속성 DialogResult 설정 |  |  |  |
| AC-24bb7056 | CloseButton | SCP0093_DioTrendReportPopup.cs:363 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DioTrendReportPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-205243ca | this.Load | SCP0093_DioTrendReportPopup.cs:222 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-453e9e66 | this.Load | SCP0093_DioTrendReportPopup.cs:223 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a535b64a | this.Load | SCP0093_DioTrendReportPopup.cs:225 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPrice, SpdSheet.shtPrice, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d83af785 | this.Load | SCP0093_DioTrendReportPopup.cs:226 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-df72fa69 | this.Load | SCP0093_DioTrendReportPopup.cs:228 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0093_DioTrendReportPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d1cd2ca | this.Load | SCP0093_DioTrendReportPopup.cs:196 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0093_DioTrendReportPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3c3319c | Dispose | SCP0093_DioTrendReportPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0093_DioTrendReportPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28cc7adf | FindButton | SCP0093_DioTrendReportPopup.cs:271 | if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (ScpUtils.CheckDataEmpty(dtUnitPrice)) | UI_PROP | siMain.ActiveSheetIndex | 1 | 속성 ActiveSheetIndex 설정 |  |  |  |
| AC-de887a08 | FindButton | SCP0093_DioTrendReportPopup.cs:272 | if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (ScpUtils.CheckDataEmpty(dtUnitPrice)) | CALL_EXT | Thread.Sleep | (10000) | ⚠ 의미 확인 필요 |  |  |  |
| AC-799592ef | FindButton | SCP0093_DioTrendReportPopup.cs:274 | if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (ScpUtils.CheckDataEmpty(dtUnitPrice)) | UI_PROP | siMain.ActiveSheetIndex | 0 | 속성 ActiveSheetIndex 설정 |  |  |  |

## SCP0093_DioTrendReportPopup.FindCopyData

진입점: btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d97ab48 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:538 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-fc784d79 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:538 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b0e7071 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:549 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c2b5719 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:553 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0093_GET_DIO_TREND_DATA_REASON") ⇒ SCP.SCP0093_GET_DIO_TREND_DATA_REASON | 엔드포인트 요청 생성 |  |  |  |
| AC-d108f6cf | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:554 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-956140e9 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:555 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-58a2ffa1 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:556 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyymm"] | yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-bc7bb4c1 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:557 | try ▸ lambda | DATA_OP | request.Parameters["p_category_dv"] | category_dv | 행/컬럼 값 대입 |  |  |  |
| AC-5eba0869 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:558 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7458b173 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:559 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ddc24ffe | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:560 | try ▸ lambda | DATA_OP | request.Parameters["P_AGGR_DV"] | aggr_dv | 행/컬럼 값 대입 |  |  |  |
| AC-f7759e05 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:561 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_group"] | cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-06a1a910 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:562 | try ▸ lambda | DATA_OP | request.Parameters["p_dio_reason"] | p_dio_reason | 행/컬럼 값 대입 |  |  |  |
| AC-6e1e8f0f | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:563 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-b9181bfc | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:565 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9fa195ac | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:566 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-28582ba2 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:570 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-533a3bf4 | btnSearch.Click | SCP0093_DioTrendReportPopup.cs:571 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0093_DioTrendReportPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9ea1d6a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:372 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-742c2f3b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:372 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0dc6a81b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:376 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94e728c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:388 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b870d76f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:392 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0093_GET_DIO_TREND_DATA_REASON") ⇒ SCP.SCP0093_GET_DIO_TREND_DATA_REASON | 엔드포인트 요청 생성 |  |  |  |
| AC-7a4de7e9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:393 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-84559b74 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:394 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-570c7aae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:395 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyymm"] | yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-1df70bd2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:396 | try ▸ lambda | DATA_OP | request.Parameters["p_category_dv"] | category_dv | 행/컬럼 값 대입 |  |  |  |
| AC-742638a3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:397 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fb68dbbb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:398 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-22014da4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:399 | try ▸ lambda | DATA_OP | request.Parameters["P_AGGR_DV"] | aggr_dv | 행/컬럼 값 대입 |  |  |  |
| AC-263c0bbe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:400 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-d5cb2985 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:401 | try ▸ lambda | DATA_OP | request.Parameters["p_dio_reason"] | p_dio_reason | 행/컬럼 값 대입 |  |  |  |
| AC-47054505 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:402 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a66d433d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:404 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5347bb63 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:405 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4f7d515a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:409 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5809fae6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:410 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8d39bd8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:415 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false) | FLAG | dtOriginal | null | 화면 필드/플래그 변경 |  |  |  |
| AC-667fd1f4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:416 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false) | FLAG | dtOriginal | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-fb3e69b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:416 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ff91450 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:427 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DioTrendReportPopup.FindPrice

진입점: spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1)] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (ScpUtils.CheckDataEmpty(dtUnitPrice))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82b40ff5 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:434 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-83132ba6 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:434 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4023733a | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:438 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPrice) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1985299 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:444 | try | FLAG | aggr_dv | "CG" | 화면 필드/플래그 변경 |  |  |  |
| AC-d67d3b2d | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:448 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f8917b2e | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:452 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0093_GET_DIO_TREND_DATA_PRICE") ⇒ SCP.SCP0093_GET_DIO_TREND_DATA_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-14872287 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:453 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-47cfa7e5 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:454 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c57d4cb3 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:455 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyymm"] | yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-5db48877 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:456 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a508f370 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:457 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5abdfc72 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:458 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-806e9e40 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:459 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-7dea5076 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:460 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-28b2bf67 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:461 | try ▸ lambda | DATA_OP | request.Parameters["P_AGGR_DV"] | aggr_dv | 행/컬럼 값 대입 |  |  |  |
| AC-39d8928b | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:462 | try ▸ lambda | DATA_OP | request.Parameters["P_CATEGORY"] | category_dv | 행/컬럼 값 대입 |  |  |  |
| AC-ed4d371f | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:463 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | PopUserId | 행/컬럼 값 대입 |  |  |  |
| AC-11b411d9 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:464 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-11f3dced | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:465 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cac67a41 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:466 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-cd7ec743 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:470 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ade0d818 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:471 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a9b89cb9 | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:476 | try ▸ if (ScpUtils.CheckDataEmpty(ds) == false) | FLAG | dtUnitPrice | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-c0840e5b | spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1… 외 1 | SCP0093_DioTrendReportPopup.cs:485 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DioTrendReportPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdcaa87d | this.Load | SCP0093_DioTrendReportPopup.cs:156 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-292a6db8 | this.Load | SCP0093_DioTrendReportPopup.cs:157 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0093_DioTrendReportPopup.GetCalcAmount

진입점: spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-750c2e0e | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1249 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DioTrendReportPopup.GetListPrice

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds) == false)] / this.Load [try ▸ if (ScpUtils.CheckDataEmpty(ds) == false)] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds) == false)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ if (ScpUtils.CheckDataEmpty(ds) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5d3a75d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:494 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-a06a7773 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:494 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c773e943 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:501 | try | FLAG | aggr_dv | "CG" | 화면 필드/플래그 변경 |  |  |  |
| AC-0395db32 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:506 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0093_GET_DIO_TREND_DATA_PRICE") ⇒ SCP.SCP0093_GET_DIO_TREND_DATA_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-06f83517 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:507 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-75a9c168 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:508 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-05207d15 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:509 | try | DATA_OP | request.Parameters["p_yyyymm"] | yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-3bab50dc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:510 | try | DATA_OP | request.Parameters["p_from_yyyymm"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f6196f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:511 | try | DATA_OP | request.Parameters["p_to_yyyymm"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e6ff246f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:512 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2f59910 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:513 | try | DATA_OP | request.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-791f9daf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:514 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-139ec1b8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:515 | try | DATA_OP | request.Parameters["P_AGGR_DV"] | aggr_dv | 행/컬럼 값 대입 |  |  |  |
| AC-661e8fd8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:516 | try | DATA_OP | request.Parameters["P_CATEGORY"] | category_dv | 행/컬럼 값 대입 |  |  |  |
| AC-61abd242 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:517 | try | DATA_OP | request.Parameters["p_user_id"] | PopUserId | 행/컬럼 값 대입 |  |  |  |
| AC-2f78d69b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:518 | try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-d190ee08 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:520 | try | FLAG | dsUnitPrice | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8afdd148 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:520 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba2e5284 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0093_DioTrendReportPopup.cs:523 | try ▸ if (ScpUtils.CheckDataEmpty(dsUnitPrice) == false) | FLAG | dtUnitPrice | dsUnitPrice.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DioTrendReportPopup.GetMonthRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b27f05e3 | this.Load | SCP0093_DioTrendReportPopup.cs:839 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0084_GET_MONTH_RANGE") ⇒ SCP.SCP0084_GET_MONTH_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-6e75a19f | this.Load | SCP0093_DioTrendReportPopup.cs:840 |  | DATA_OP | request.Parameters["p_month"] | 12 | 행/컬럼 값 대입 |  |  |  |
| AC-8754981b | this.Load | SCP0093_DioTrendReportPopup.cs:842 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dc54f73c | this.Load | SCP0093_DioTrendReportPopup.cs:842 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DioTrendReportPopup.GetPrice

진입점: spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY)) ▸ try ▸ try ▸ if (price == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dac3f4a3 | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1268 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |
| AC-6d058099 | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1277 | try | ENDPOINT | ScpUtils.FindDataValue | (dtUnitPrice, "CELL_GROUP", cell_group, "UNIT_PRICE_LAST") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-339e9858 | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1279 | try ▸ if (string.IsNullOrEmpty(sValue) == false) | CALL_EXT | ScpUtils.GetValueDecimal | (sValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5aaf329e | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1284 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |
| AC-6f7261b9 | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1295 |  | CALL_EXT | ScpUtils.GetValueDecimal | (txtPrice.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c82af2cd | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1297 |  | RETURN | return dValue; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DioTrendReportPopup.GetSaveDataSchema

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66cc7a5b | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:852 |  | DATA_OP | dt.Columns.Add | ("ACTIVE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-32e193f7 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:853 |  | DATA_OP | dt.Columns.Add | ("YYYYMM") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1345baa | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:854 |  | DATA_OP | dt.Columns.Add | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4ed43f5 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:855 |  | DATA_OP | dt.Columns.Add | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-14fc8043 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:856 |  | DATA_OP | dt.Columns.Add | ("CELL_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb62255f | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:857 |  | DATA_OP | dt.Columns.Add | ("AGGR_DV") | 데이터 객체 조작/조회 |  |  |  |
| AC-89d0978d | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:858 |  | DATA_OP | dt.Columns.Add | ("DIO_REASON") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6e65bcc | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:859 |  | DATA_OP | dt.Columns.Add | ("QUANTITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-494aa787 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:860 |  | DATA_OP | dt.Columns.Add | ("AMOUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a41a5fb | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:861 |  | DATA_OP | dt.Columns.Add | ("REMARK") | 데이터 객체 조작/조회 |  |  |  |
| AC-93f879a0 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:862 |  | DATA_OP | dt.Columns.Add | ("WEEK_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-69b13bcb | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:863 |  | DATA_OP | dt.Columns.Add | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9498530b | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:864 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-af0313e3 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:865 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE2") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2896ce5 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:866 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE3") | 데이터 객체 조작/조회 |  |  |  |
| AC-027f4fc9 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:867 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE4") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c813155 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:868 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE5") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2b800fa | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:869 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE6") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7944f8c | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:870 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE7") | 데이터 객체 조작/조회 |  |  |  |
| AC-35d888ee | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:871 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE8") | 데이터 객체 조작/조회 |  |  |  |
| AC-51583673 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:872 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE9") | 데이터 객체 조작/조회 |  |  |  |
| AC-59c0f674 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:873 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE10") | 데이터 객체 조작/조회 |  |  |  |
| AC-7cbbdab8 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:874 |  | DATA_OP | dt.Columns.Add | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6dc6f66c | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:875 |  | DATA_OP | dt.Columns.Add | ("PROGRAM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-70ee0cec | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:876 |  | DATA_OP | dt.Columns.Add | ("DEBUG_MODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8bee1f06 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:878 |  | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-094434c3 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:879 |  | RETURN | return dsInput; |  | 처리 중단/반환 |  |  |  |

## SCP0093_DioTrendReportPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0e08a82 | this.Load | SCP0093_DioTrendReportPopup.cs:171 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-b81ca331 | this.Load | SCP0093_DioTrendReportPopup.cs:173 |  | FLAG | dtMyDivision | BLUtils.GetDivisionWithoutEE(false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-073c7f50 | this.Load | SCP0093_DioTrendReportPopup.cs:173 |  | CALL_EXT | BLUtils.GetDivisionWithoutEE | (false, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b37a81c7 | this.Load | SCP0093_DioTrendReportPopup.cs:174 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-32c6af88 | this.Load | SCP0093_DioTrendReportPopup.cs:175 |  | VALUE_SET | cboDivision.ControlValues | Division | 컨트롤 값 설정 |  |  |  |
| AC-243b6c57 | this.Load | SCP0093_DioTrendReportPopup.cs:176 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7dd12837 | this.Load | SCP0093_DioTrendReportPopup.cs:178 |  | FLAG | dtDioReason | ScpUtils.GetLookupValues("STOCK_TREND_DIO_REASON") | 화면 필드/플래그 변경 |  |  |  |
| AC-91e0681e | this.Load | SCP0093_DioTrendReportPopup.cs:178 |  | CALL_EXT | ScpUtils.GetLookupValues | ("STOCK_TREND_DIO_REASON") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a82d92c8 | this.Load | SCP0093_DioTrendReportPopup.cs:179 |  | LIST_REBIND | clsCtrl.setListBox | (dtDioReason, cboDioReason, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4bc8a0c4 | this.Load | SCP0093_DioTrendReportPopup.cs:181 |  | FLAG | dtMonthRange | GetMonthRange() | 화면 필드/플래그 변경 |  |  |  |
| AC-b666ba4b | this.Load | SCP0093_DioTrendReportPopup.cs:184 |  | VALUE_SET | txtYYYYMM.ControlValues | yyyymm | 컨트롤 값 설정 |  |  |  |
| AC-76c91112 | this.Load | SCP0093_DioTrendReportPopup.cs:185 |  | STATE | txtYYYYMM.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3352bb4c | this.Load | SCP0093_DioTrendReportPopup.cs:186 |  | VALUE_SET | txtItemId.Text | item_id | 컨트롤 값 설정 |  |  |  |
| AC-5abc578b | this.Load | SCP0093_DioTrendReportPopup.cs:187 |  | VALUE_SET | txtCellGroup.Text | cell_group | 컨트롤 값 설정 |  |  |  |
| AC-5725e43f | this.Load | SCP0093_DioTrendReportPopup.cs:189 |  | VALUE_SET | txtPlanStartYYYYMMDD.Text | plan_start_yyyymmdd | 컨트롤 값 설정 |  |  |  |
| AC-279ffa4e | this.Load | SCP0093_DioTrendReportPopup.cs:190 |  | STATE | txtPlanStartYYYYMMDD.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0093_DioTrendReportPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / btnSearch.Click [try] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31090542 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0093_DioTrendReportPopup.cs:239 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-df6d0798 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0093_DioTrendReportPopup.cs:240 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0093_DioTrendReportPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18878e7e | SaveButton | SCP0093_DioTrendReportPopup.cs:347 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f8d85a0 | SaveButton | SCP0093_DioTrendReportPopup.cs:349 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0093_DioTrendReportPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49145d1c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:579 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f120800 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:637 | try ▸ if (iCount > 0) ▸ if (flagCopy == false) ▸ if (p_save_yyyymm.Equals(yyyymm) == false) | MESSAGE | MessageHelper.GMessageBox | (checkMessage_001) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af0377f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:638 | try ▸ if (iCount > 0) ▸ if (flagCopy == false) ▸ if (p_save_yyyymm.Equals(yyyymm) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-207e2995 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:643 | try ▸ if (iCount > 0) ▸ else of (flagCopy == false) | MESSAGE | MessageBox.Show | (checkMessage_copy, this.Text, MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-a348c709 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:645 | try ▸ if (iCount > 0) ▸ else of (flagCopy == false) ▸ if (MessageBox.Show(checkMessage_copy, this.Text, MessageBoxButtons.YesNo) == DialogRe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb9e1fbb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:650 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0093_SAVE_DIO_REPORT_REASON") ⇒ SCP.SCP0093_SAVE_DIO_REPORT_REASON | 엔드포인트 요청 생성 |  |  |  |
| AC-e16e1e6e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:653 | try ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", ScpUtils.GSCM_SCP_MASTER_SVC)) { re… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e37599ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:657 | try ▸ if (iCount > 0) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-15b68d83 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:658 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-96fef984 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:659 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d8a819b7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:660 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_yyyymm"] | p_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-3b885e33 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:661 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_category_dv"] | p_category_dv | 행/컬럼 값 대입 |  |  |  |
| AC-ca321304 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:662 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2c8780ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:663 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-b02ca335 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:664 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_aggr_dv"] | p_aggr_dv | 행/컬럼 값 대입 |  |  |  |
| AC-e54ccc3c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:665 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5f72cb0f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:666 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_dio_reason"] | p_dio_reason | 행/컬럼 값 대입 |  |  |  |
| AC-7b90b347 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:667 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_quantity"] | p_quantity | 행/컬럼 값 대입 |  |  |  |
| AC-104cba0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:668 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_amount"] | p_amount | 행/컬럼 값 대입 |  |  |  |
| AC-9df1bd05 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:669 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_remark"] | p_remark | 행/컬럼 값 대입 |  |  |  |
| AC-8fa30ed0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:670 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | PopUserId | 행/컬럼 값 대입 |  |  |  |
| AC-e6717828 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:672 | try ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7a804038 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:672 | try ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-e1d88502 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:683 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-61f92aac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:684 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") | FLAG | isChange | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f6e10bc2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:685 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-2a7856bb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:695 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ else of (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5443c209 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0093_DioTrendReportPopup.cs:702 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0093_DioTrendReportPopup.SCM_SYS_LOG_BATCH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce714759 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:717 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-fcead252 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:718 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-dcdcb8b6 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:719 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-8f128921 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:720 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-79b3db2c | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:721 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-1585505b | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:722 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-f45dab3d | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:723 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-94c54194 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:725 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0093_DioTrendReportPopup.SetCellForeColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8f19b16 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:886 | if (focusValue.StartsWith("SUM")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | DefGridColor.MEASURE_SUM | 그리드 속성/값 설정 |  |  |  |
| AC-dd3d7477 | (진입점 미연결) | SCP0093_DioTrendReportPopup.cs:890 | else of (focusValue.StartsWith("SUM")) ▸ if (focusValue.StartsWith("GAP")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | DefGridColor.MEASURE_SUM | 그리드 속성/값 설정 |  |  |  |

## SCP0093_DioTrendReportPopup.SetCopyData

진입점: btnCopy.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c59a8ec5 | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:737 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-479f0dad | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:739 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d8c09d2f | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:742 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9044fa85 | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:753 | try | FLAG | checkMessage_copy | string.Format("{0} 데이터를 Copy 해 {1} 데이터를 생성합니다.\r\n{1} 데이터가 있을 경우 Copy 데이터로 업데이트 됩니다.", yyy… | 화면 필드/플래그 변경 |  |  |  |
| AC-95af2351 | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:765 | try ▸ for (iRow < spdMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) | CALL_EXT | ScpUtils.GetColumnName | (siMain, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a09f6f9d | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:773 | try ▸ for (iRow < spdMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (columnName.Equals(DefColumns.YYYYMM)) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].Value | changeValue | 그리드 속성/값 설정 |  |  |  |
| AC-e1e1df11 | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:777 | try ▸ for (iRow < spdMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (columnName.Equals(DefColumns.YYYYMM)) | GRID_SET | siMain.ActiveSheet.Cells[iRow, 0].Value | action_flag | 그리드 속성/값 설정 |  |  |  |
| AC-ffd82427 | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:790 | try ▸ for (iRow < spdMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (columnName.Equals(DefColumns.YYYYMM)) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[iRow, 0].Value | CAppSetting.FlagM | 그리드 속성/값 설정 |  |  |  |
| AC-740951bc | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:797 | try ▸ for (iRow < spdMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (columnName.Equals(DefColumns.YYYYMM)) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[iRow, ScpUtils.GetColumnIndex(siMain, DefColumns.QUANTITY)].ForeC… | DefGridColor.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-8e77b10d | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:801 | try ▸ for (iRow < spdMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (columnName.Equals(DefColumns.YYYYMM)) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[iRow, ScpUtils.GetColumnIndex(siMain, DefColumns.AMOUNT)].ForeCol… | DefGridColor.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-3f1b58e9 | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:805 | try ▸ for (iRow < spdMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (columnName.Equals(DefColumns.YYYYMM)) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[iRow, ScpUtils.GetColumnIndex(siMain, DefColumns.REMARK)].ForeCol… | DefGridColor.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-e46a5ea6 | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:814 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-61e8b055 | btnCopy.Click | SCP0093_DioTrendReportPopup.cs:818 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DioTrendReportPopup.SetCopyFlag

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [try] / btnCopy.Click / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (iCount > 0) ▸ else of (flagCopy == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22638d5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0093_DioTrendReportPopup.cs:920 |  | FLAG | flagCopy | flag | 화면 필드/플래그 변경 |  |  |  |
| AC-f9b9f165 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0093_DioTrendReportPopup.cs:923 | if (flag == false) | FLAG | checkMessage_copy | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SCP0093_DioTrendReportPopup.SetEditGrid

진입점: btnCopy.Click [try] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fc4942d | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:291 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c4760097 | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:296 | try ▸ if (fps.Name == "spdMain") | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ad6229f5 | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:298 | try ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ae291c4 | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:299 | try ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5ecd8126 | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:301 | try ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.YYYYMM), siMain.GetColumnIndex(DefColumns.YYYYMM), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9f6c07a4 | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:302 | try ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.DIVISION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-acbb37ea | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:303 | try ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION), siMain.GetColumnIndex(DefColumns.DIVISION), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8dea7c58 | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:304 | try ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ITEM_ID), siMain.GetColumnIndex(DefColumns.ITEM_ID), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e9f92fff | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:305 | try ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CELL_GROUP), siMain.GetColumnIndex(DefColumns.CELL_GROUP… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a7ad6f7 | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:306 | try ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.REASON), siMain.GetColumnIndex(DefColumns.REASON), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c645289f | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:310 | try ▸ if (fps.Name == "spdMain") ▸ if (IsEditMode == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9418d7b7 | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:331 | try ▸ if (fps.Name == "spdMain") ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ switch (reason_id) case "SUM": case "GAP": | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8b92523 | btnCopy.Click [try] 외 1 | SCP0093_DioTrendReportPopup.cs:341 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0093_DioTrendReportPopup.SetMonthRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ab12eb8 | this.Load | SCP0093_DioTrendReportPopup.cs:831 |  | VALUE_SET | monthPicker.InitValue | yyyymm | 컨트롤 값 설정 |  |  |  |
| AC-130e6393 | this.Load | SCP0093_DioTrendReportPopup.cs:832 |  | UI_PROP | monthPicker.MonthMin | yyyymm_from | 속성 MonthMin 설정 |  |  |  |
| AC-16c0456a | this.Load | SCP0093_DioTrendReportPopup.cs:833 |  | UI_PROP | monthPicker.MonthMax | yyyymm_to | 속성 MonthMax 설정 |  |  |  |

## SCP0093_DioTrendReportPopup.SetPrice

진입점: spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.AMOUNT)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.QUANTITY)) ▸ try ▸ try ▸ if (price == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-366c1ecb | spdMain.ActiveSheet.CellChanged [try ▸ if (e.Column == siMai… | SCP0093_DioTrendReportPopup.cs:1302 |  | VALUE_SET | txtPrice.Text | ScpUtils.GetValue(value) | 컨트롤 값 설정 |  |  |  |

## SCP0093_DioTrendReportPopup.SetSpreadInit

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [try] / btnSearch.Click [try] / spdMain.ActiveSheetChanged [if (siMain.ActiveSheetIndex == 1) ▸ try] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-140963e3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0093_DioTrendReportPopup.cs:247 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06a3f1ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0093_DioTrendReportPopup.cs:248 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-b8dc3cab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0093_DioTrendReportPopup.cs:252 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52cbbe1e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0093_DioTrendReportPopup.cs:253 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-c80047a5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0093_DioTrendReportPopup.cs:255 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-48ee12c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0093_DioTrendReportPopup.cs:256 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0093_Measure.GetMeasureDataType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a91baf5d | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2932 |  | DATA_OP | sMeasure.ToUpper().Contains | ("QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-c11263ae | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2934 | if (sMeasure.ToUpper().Contains("QTY")) | FLAG | measure_type | "QTY" | 화면 필드/플래그 변경 |  |  |  |
| AC-d45453c9 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2936 | else of (sMeasure.ToUpper().Contains("QTY")) | DATA_OP | sMeasure.ToUpper().Contains | ("AMOUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f9fe458 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2938 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ if (sMeasure.ToUpper().Contains("AMOUNT")) | FLAG | measure_type | "AMOUNT" | 화면 필드/플래그 변경 |  |  |  |
| AC-07457888 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2940 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ else of (sMeasure.ToUpper().Contains("AMOUNT")) | DATA_OP | sMeasure.ToUpper().Contains | ("AMT") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb9af77d | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2942 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ else of (sMeasure.ToUpper().Contains("AMOUNT")) ▸ if (sMeasure.ToUpper().Contains("AMT")) | FLAG | measure_type | "AMOUNT" | 화면 필드/플래그 변경 |  |  |  |
| AC-e8d02f6d | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2944 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ else of (sMeasure.ToUpper().Contains("AMOUNT")) ▸ else of (sMeasure.ToUpper().Contains("AMT")… | DATA_OP | sMeasure.ToUpper().Contains | ("DIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff595005 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2946 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ else of (sMeasure.ToUpper().Contains("AMOUNT")) ▸ else of (sMeasure.ToUpper().Contains("AMT")… | FLAG | measure_type | "DIO" | 화면 필드/플래그 변경 |  |  |  |
| AC-fa91c4fc | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2959 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ else of (sMeasure.ToUpper().Contains("AMOUNT")) ▸ else of (sMeasure.ToUpper().Contains("AMT")… | FLAG | measure_type | "QTY" | 화면 필드/플래그 변경 |  |  |  |
| AC-3ea93dec | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2963 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ else of (sMeasure.ToUpper().Contains("AMOUNT")) ▸ else of (sMeasure.ToUpper().Contains("AMT")… | FLAG | measure_type | "DIO" | 화면 필드/플래그 변경 |  |  |  |
| AC-503a82fa | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2968 |  | RETURN | return measure_type; |  | 처리 중단/반환 |  |  |  |

## SCP0093_Measure.GetMeasureType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f81e0ce | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2976 | try | DATA_OP | measure.Contains | ("Standard DIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-11d0051a | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2978 | try ▸ else of (measure.Contains("Standard DIO")) | DATA_OP | measure.Contains | ("DIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-61bee688 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2980 | try ▸ else of (measure.Contains("Standard DIO")) ▸ else of (measure.Contains("DIO")) | DATA_OP | measure.Contains | ("RTF") | 데이터 객체 조작/조회 |  |  |  |
| AC-5193c592 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2982 | try ▸ else of (measure.Contains("Standard DIO")) ▸ else of (measure.Contains("DIO")) ▸ else of (measure.Contains("RTF")) | DATA_OP | measure.Contains | ("Prod") | 데이터 객체 조작/조회 |  |  |  |
| AC-66fa4ab5 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:2984 | try ▸ else of (measure.Contains("Standard DIO")) ▸ else of (measure.Contains("DIO")) ▸ else of (measure.Contains("RTF")) ▸ else of (measure.… | DATA_OP | measure.Contains | ("Inv. Qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-294760b5 | (진입점 미연결) | SCP0093_DIO_Trend_Report.cs:3013 |  | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |

