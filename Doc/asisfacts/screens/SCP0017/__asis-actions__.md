# AS-IS 액션 대조표 — SCP0017

> 원천: `Doc/asisfacts/screens/SCP0017/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 283행 · 메서드 67 · 종류 DATA_OP 75 · RETURN 38 · CALL_EXT 25 · GRID_SET 25 · GRID_INIT 24 · FLAG 17 · UI_PROP 15 · POPUP 9 · LIST_REBIND 9 · ENDPOINT 8 · UI_MISC 6 · VALUE_SET 6 · MESSAGE 5 · GRID_BIND 3 · GRID_LOCK 3 · GRID_STYLE 3 · VALIDATE 3 · COMBO_DATA 3 · STATE 2 · VALUE_CLEAR 1 · GRID_CLEAR 1 · STATE_RESET 1 · THROW 1 · ⚠ 의미 확인 필요 25


## SCP0017_WaterfallProductionPlan.AfterFindDataModel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7d8886b | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1334 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e6eebf1f | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1336 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e68ff931 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1338 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d47fe86c | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1340 |  | FLAG | this.dsModelAll | ds | 화면 필드/플래그 변경 |  |  |  |
| AC-a21b33ae | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1344 |  | UI_MISC | SetSearchCount | (this.dsModelAll) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a611bf39 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1359 | if (this.nSelRowOfMain >= 0 && _isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-9b602d65 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1360 | if (this.nSelRowOfMain >= 0 && _isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9918c988 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1366 |  | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0017_WaterfallProductionPlan.ApplyUOM

진입점: this.clbUOM.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6757883e | this.clbUOM.SelectedIndexChanged 외 1 | SCP0017_WaterfallProductionPlan.cs:2250 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f54ae51d | this.clbUOM.SelectedIndexChanged 외 1 | SCP0017_WaterfallProductionPlan.cs:2253 | if (this.dsModelAll == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78a41c1e | this.clbUOM.SelectedIndexChanged 외 1 | SCP0017_WaterfallProductionPlan.cs:2256 | if (this.dsModelAll.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fd54094 | this.clbUOM.SelectedIndexChanged 외 1 | SCP0017_WaterfallProductionPlan.cs:2258 |  | DATA_OP | this.dsModelAll.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cfa1c8ab | this.clbUOM.SelectedIndexChanged 외 1 | SCP0017_WaterfallProductionPlan.cs:2262 | if (dtModelAll == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb6c31c7 | this.clbUOM.SelectedIndexChanged 외 1 | SCP0017_WaterfallProductionPlan.cs:2266 | if ((this._uom == "") \|\| (this._uom.IndexOf(",") > -1)) | DATA_OP | dtModelAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c287e37e | this.clbUOM.SelectedIndexChanged 외 1 | SCP0017_WaterfallProductionPlan.cs:2271 | else of ((this._uom == "") \|\| (this._uom.IndexOf(",") > -1)) | DATA_OP | DBUtils.Filter | (dtModelAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b5e860c3 | this.clbUOM.SelectedIndexChanged 외 1 | SCP0017_WaterfallProductionPlan.cs:2276 |  | DATA_OP | ds.Tables.Add | (dtModelFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-45b82f16 | this.clbUOM.SelectedIndexChanged 외 1 | SCP0017_WaterfallProductionPlan.cs:2278 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |

## SCP0017_WaterfallProductionPlan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d412f2b6 | this.btnColumn.Click | SCP0017_WaterfallProductionPlan.cs:949 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0017", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-1f0a4d35 | this.btnColumn.Click | SCP0017_WaterfallProductionPlan.cs:950 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9a414be5 | this.btnColumn.Click | SCP0017_WaterfallProductionPlan.cs:951 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0017_WaterfallProductionPlan.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e2483eb | this.btnItemId.Click | SCP0017_WaterfallProductionPlan.cs:961 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-cd37a40d | this.btnItemId.Click | SCP0017_WaterfallProductionPlan.cs:963 |  | POPUP | pop.Form_Load | (true, this._division, this._operation_group, this._item_id, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-bcce6262 | this.btnItemId.Click | SCP0017_WaterfallProductionPlan.cs:964 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-46af05a0 | this.btnItemId.Click | SCP0017_WaterfallProductionPlan.cs:965 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b627a9a0 | this.btnItemId.Click | SCP0017_WaterfallProductionPlan.cs:971 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b19273f | this.btnMeasure.Click | SCP0017_WaterfallProductionPlan.cs:990 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdLine") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ba94a35 | this.btnMeasure.Click | SCP0017_WaterfallProductionPlan.cs:991 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdLine") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d2b989d | this.btnMeasure.Click | SCP0017_WaterfallProductionPlan.cs:996 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe3d94fc | this.btnMeasure.Click | SCP0017_WaterfallProductionPlan.cs:997 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5f9ef0f | this.btnMeasure.Click | SCP0017_WaterfallProductionPlan.cs:1000 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0017", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-6199c5df | this.btnMeasure.Click | SCP0017_WaterfallProductionPlan.cs:1001 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-13505891 | this.btnMeasure.Click | SCP0017_WaterfallProductionPlan.cs:1003 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-925379aa | this.btnMeasure.Click | SCP0017_WaterfallProductionPlan.cs:1007 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-4ed45fc4 | this.btnMeasure.Click | SCP0017_WaterfallProductionPlan.cs:1017 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.CalculateSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42c8077d | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1764 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c19cb58 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1774 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (dt.Columns[nCol].ColumnName.IndexOf("_ISO") =… | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-df628567 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1822 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0 && dt.Columns[nCol].Col… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-919db63f | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1826 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0 && dt.Columns[nCol].Col… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-82fcfc6b | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1840 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-527ab952 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1844 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-eb8d8ff0 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1853 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7b50209f | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2095 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-476f03cc | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2099 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-550fd705 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2162 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-30ad246f | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2166 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-bee1bba4 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2171 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-5537ccd3 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2189 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-f2be81c0 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2193 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-92313301 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2202 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0017_WaterfallProductionPlan.CalculateSumMain

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-163cde60 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1875 | for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(j).ToString().IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-54140be0 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1879 | for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(j).ToString().IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-300e6f5d | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1952 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (measure.Equals("FORMATION_YIELD")) ▸ if (iCol == s… | GRID_SET | siMain.SetValue | (iRow, nIdxWeek, weekSum / nCntDayOfWeek) | 그리드 값 설정 |  |  |  |
| AC-3b1fbe00 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1965 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (measure.Equals("FORMATION_YIELD")) ▸ if (iCol == s… | GRID_SET | siMain.SetValue | (iRow, nIdxMonth, monthSum / nCntDayOfMonth) | 그리드 값 설정 |  |  |  |
| AC-2cf57a88 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1981 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ if (meas… | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, siMain.GetValue(iRow, bef_day_idx)) | 그리드 값 설정 |  |  |  |
| AC-23a50b38 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1990 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ if (meas… | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, siMain.GetValue(iRow, bef_day_idx)) | 그리드 값 설정 |  |  |  |
| AC-ba67b9e4 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2003 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ if (meas… | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, siMain.GetValue(iRow, bef_day_idx)) | 그리드 값 설정 |  |  |  |
| AC-832c2c61 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2004 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ if (meas… | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, siMain.GetValue(iRow, bef_day_idx)) | 그리드 값 설정 |  |  |  |
| AC-5282f6fe | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2049 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ else of … | GRID_SET | siMain.SetValue | (iRow, nIdxWeek_D, weekSum_D) | 그리드 값 설정 |  |  |  |
| AC-ab757ec8 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2059 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ else of … | GRID_SET | siMain.SetValue | (iRow, nIdxMonth_D, monthSum_D) | 그리드 값 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db37f847 | this.cboBucketType.SelectedIndexChanged | SCP0017_WaterfallProductionPlan.cs:1036 | if (chkALL.Checked) ▸ if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO \|\| beforeBucketType == BucketType.Week… | GRID_INIT | siMain.SetSheetHeaderColumn2 | (siMain, 3, true, DefColumns.MEASURE_NAME) | 그리드 재구성/초기화 |  |  |  |
| AC-f91327ff | this.cboBucketType.SelectedIndexChanged | SCP0017_WaterfallProductionPlan.cs:1042 | if (chkALL.Checked) ▸ if (siMain != null) | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c371c82 | this.cboBucketType.SelectedIndexChanged | SCP0017_WaterfallProductionPlan.cs:1053 |  | FLAG | beforeBucketType | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |

## SCP0017_WaterfallProductionPlan.cboDivision_SelectedIndexChanged

진입점: this.Load / this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4655740 | this.Load 외 1 | SCP0017_WaterfallProductionPlan.cs:2238 | if (!this._division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | cboElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-27af43bc | this.Load 외 1 | SCP0017_WaterfallProductionPlan.cs:2239 | if (!this._division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bccbf116 | this.Load 외 1 | SCP0017_WaterfallProductionPlan.cs:2243 | else of (!this._division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0017_WaterfallProductionPlan.cboVersion_SelectedIndexChanged

진입점: this.clbVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3b1cc81 | this.clbVersion.SelectedIndexChanged | SCP0017_WaterfallProductionPlan.cs:1320 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.chkAll_CheckedChanged

진입점: this.chkALL.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4837ae06 | this.chkALL.CheckedChanged | SCP0017_WaterfallProductionPlan.cs:1109 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0017_WaterfallProductionPlan.ClearEventInvocations

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff61a54e | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2355 | if (fi == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1d4b4c0 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2357 |  | GRID_SET | fi.SetValue | (obj, null) | 그리드 값 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb0bc815 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:449 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1771e5b5 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:450 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9f37cc5 | this.Load | SCP0017_WaterfallProductionPlan.cs:541 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0d36296a | this.Load | SCP0017_WaterfallProductionPlan.cs:542 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fce1b71 | this.Load | SCP0017_WaterfallProductionPlan.cs:548 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d0039c3 | this.Load | SCP0017_WaterfallProductionPlan.cs:439 |  | UI_PROP | usrConditionPanel1.Height | 80 | 속성 Height 설정 |  |  |  |
| AC-5a455054 | this.Load | SCP0017_WaterfallProductionPlan.cs:440 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-3471a26a | this.Load | SCP0017_WaterfallProductionPlan.cs:441 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-acd0c7f5 | this.Load | SCP0017_WaterfallProductionPlan.cs:442 |  | VALUE_SET | chkGap.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8897016c | Dispose | SCP0017_WaterfallProductionPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0017_WaterfallProductionPlan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea8ef951 | EditButton | SCP0017_WaterfallProductionPlan.cs:935 | if (fps != null) ▸ if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8ec440b0 | EditButton | SCP0017_WaterfallProductionPlan.cs:936 | if (fps != null) ▸ if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8045c9f | EditButton | SCP0017_WaterfallProductionPlan.cs:941 | if (fps != null) ▸ if (fps.Name == "spdLine") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81fa4155 | EditButton | SCP0017_WaterfallProductionPlan.cs:942 | if (fps != null) ▸ if (fps.Name == "spdLine") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.FindData_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39afbb3e | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1495 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8bc6601 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1498 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL") ⇒ SCP.SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-0b56363b | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1499 | lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-572ebd6c | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1501 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-36dc8117 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1502 | lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-8322672a | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1503 | lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-fdad23f6 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1504 | lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d3c19fc6 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1505 | lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8d01feb8 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1506 | lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c29903fc | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1507 | lambda | DATA_OP | req.Parameters["p_version_no"] | p_version_no | 행/컬럼 값 대입 |  |  |  |
| AC-e8021f4e | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1508 | lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a647655 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1509 | lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-d1558323 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1510 | lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ae631dc | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1511 | lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-cca294f3 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1512 | lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-edff0a76 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1514 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd9ec881 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1515 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-20616a1f | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1528 |  | GRID_BIND | siLine.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9a594dcb | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1530 |  | GRID_LOCK | siLine.LockColumn | (0, siLine.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-46c4fac6 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1532 |  | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a7c78343 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1538 |  | CALL_EXT | siLine.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-133aec8e | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1548 | for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD") | CALL_EXT | siLine.SetDecimal | (i, nIdxStart, i, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6cddef33 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1569 | if (this.nSelRowOfLine >= 0 && isReload) | GRID_STYLE | siLine.ActiveSheet.SetActiveCell | (this.nSelRowOfLine, this.nSelColOfLine) | 그리드 표시 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.FindData_Model

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6f6f095 | FindButton | SCP0017_WaterfallProductionPlan.cs:1409 |  | ENDPOINT | this.ExecuteSQL | (siMain, DIC_SCP0017_MODEL_FIND, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fcfd7885 | FindButton | SCP0017_WaterfallProductionPlan.cs:1417 |  | FLAG | _isReload | isReload | 화면 필드/플래그 변경 |  |  |  |
| AC-82f5b858 | FindButton | SCP0017_WaterfallProductionPlan.cs:1419 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-0156a3ba | FindButton | SCP0017_WaterfallProductionPlan.cs:1420 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e655efea | FindButton | SCP0017_WaterfallProductionPlan.cs:1422 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-34b60beb | FindButton | SCP0017_WaterfallProductionPlan.cs:1423 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31cdba98 | FindButton | SCP0017_WaterfallProductionPlan.cs:1429 | if (chkGap.Checked) ▸ if (this._version.ToString().Length != 27) | MESSAGE | MessageHelper.GMessageBox | ("MSG00376", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-214fa028 | FindButton | SCP0017_WaterfallProductionPlan.cs:1430 | if (chkGap.Checked) ▸ if (this._version.ToString().Length != 27) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19f6e580 | this.Load | SCP0017_WaterfallProductionPlan.cs:422 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0017_WaterfallProductionPlan.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f96bb1d | this.Load | SCP0017_WaterfallProductionPlan.cs:1229 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BucketISO, false, "", "", "", "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b2fd59e | this.Load | SCP0017_WaterfallProductionPlan.cs:1231 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.GetDayRange

진입점: this.Load / this.clbVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a32b68a | this.Load 외 1 | SCP0017_WaterfallProductionPlan.cs:2552 |  | CALL_EXT | DateUtil.GetDayRange | (fromDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-002315f9 | this.Load 외 1 | SCP0017_WaterfallProductionPlan.cs:2554 |  | RETURN | return dayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0295c04e | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:68 |  | RETURN | return CString.GetCheckedListValue(dtMyDivision, cboDivision.ControlValues); |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe45caa3 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2441 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-f4656ba1 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2442 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-53f8bc0b | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2445 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7412b3db | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:206 |  | RETURN | return electrode_type; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.GetEventField

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78e3a15b | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2367 | while (type != null) | CALL_EXT | type.GetField | (eventName, BindingFlags.Static \| BindingFlags.Instance \| BindingFlags.NonPublic) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e59bede7 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2368 | while (type != null) | CALL_EXT | field.FieldType.IsSubclassOf | (typeof(MulticastDelegate)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b90b71e7 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2372 | while (type != null) | CALL_EXT | type.GetField | ("EVENT_" + eventName.ToUpper(), BindingFlags.Static \| BindingFlags.Instance \| BindingFl… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac6c73fb | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2377 |  | RETURN | return field; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getFromYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22a016ea | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:138 |  | RETURN | return dCalendar.Text1.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getGap

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e45f1543 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:244 |  | RETURN | return gap; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7814758b | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:124 |  | RETURN | return txtItemId.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31230fe4 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:187 |  | RETURN | return line; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getModel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-546111f8 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:110 |  | RETURN | return txtModelId.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getNickname

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2721bf0 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:220 |  | RETURN | return txtNickName.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getOperationGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d95e6c4 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:82 |  | RETURN | return CString.GetCheckedListValue(dtOperationGroup, cboOperationGroup.ControlVa… |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getPlantSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea5943b1 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:96 |  | RETURN | return CString.GetCheckedListValue(dtPlantSite, clbPlantSite.ControlValues, true… |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a7c153d | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2481 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96f64ac1 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2475 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00cc4c3e | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2487 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.GetSpdTitle

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboOperationGroup.SelectedIndexChanged / this.cboBucketType.SelectedIndexChanged [if (chkALL.Checked) ▸ if (siMain != null)] / this.chkALL.CheckedChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2813a6b | this.Load 외 7 | SCP0017_WaterfallProductionPlan.cs:2518 |  | ENDPOINT | new FoxDataRequest | (procName) ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO \| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-37089541 | this.Load 외 7 | SCP0017_WaterfallProductionPlan.cs:2520 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-de9c3e40 | this.Load 외 7 | SCP0017_WaterfallProductionPlan.cs:2521 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2ee79aa6 | this.Load 외 7 | SCP0017_WaterfallProductionPlan.cs:2523 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-da6f0cb4 | this.Load 외 7 | SCP0017_WaterfallProductionPlan.cs:2523 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0017_WaterfallProductionPlan.getToYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a9fbfa8 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:152 |  | RETURN | return dCalendar.Text2.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getUOM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-619bcc0c | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:260 |  | RETURN | return CString.GetCheckedListValue(dtUOM, clbUOM.TextList, true); |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.getVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ea3c262 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:166 |  | RETURN | return CString.GetCheckedListValue(dtVersion, clbVersion.ControlValues, true); |  | 처리 중단/반환 |  |  |  |

## SCP0017_WaterfallProductionPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1049b4d7 | this.Load | SCP0017_WaterfallProductionPlan.cs:516 |  | DATA_OP | this.ConditionNotUseList.Add | (clbVersion) | 데이터 객체 조작/조회 |  |  |  |
| AC-45c0b6e9 | this.Load | SCP0017_WaterfallProductionPlan.cs:518 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-002e2665 | this.Load | SCP0017_WaterfallProductionPlan.cs:522 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-9a85d3ac | this.Load | SCP0017_WaterfallProductionPlan.cs:524 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0297599 | this.Load | SCP0017_WaterfallProductionPlan.cs:532 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5964eb9 | this.Load | SCP0017_WaterfallProductionPlan.cs:417 |  | DATA_OP | QueryDics.Add | (DIC_SCP0017_MODEL_FIND, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0017_WaterfallProductionPlan.InitSpread

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboOperationGroup.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f563729 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0017_WaterfallProductionPlan.cs:576 | if (spdInfo == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3aa84be6 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0017_WaterfallProductionPlan.cs:620 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-c39b0538 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0017_WaterfallProductionPlan.cs:626 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spdInfo.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd1c5cbb | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0017_WaterfallProductionPlan.cs:632 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!this._division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c1e857d5 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0017_WaterfallProductionPlan.cs:633 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!this._division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0418f350 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0017_WaterfallProductionPlan.cs:637 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!this._division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1be01cf9 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0017_WaterfallProductionPlan.cs:638 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!this._division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.InitSpread_2

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkALL.Checked)] / this.chkALL.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d18874c | this.Load 외 2 | SCP0017_WaterfallProductionPlan.cs:559 |  | GRID_INIT | siMain.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-69b408c0 | this.Load 외 2 | SCP0017_WaterfallProductionPlan.cs:563 |  | GRID_INIT | siMain.SetSheetHeaderColumn2 | (spreadInfo, 3, chkAll, DefColumns.MEASURE_NAME) | 그리드 재구성/초기화 |  |  |  |
| AC-78a72efd | this.Load 외 2 | SCP0017_WaterfallProductionPlan.cs:570 |  | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0017_WaterfallProductionPlan.InitSpreadDateColumnISO

진입점: this.Load [if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (spdInfo.SheetName == SpdSheet.s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2860dc67 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 7 | SCP0017_WaterfallProductionPlan.cs:747 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | GRID_INIT | spdInfo.AddNumColumn | (cCOLUMN_LABEL_NAME, cCOLUMN_NAME, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ab4d8c6 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 7 | SCP0017_WaterfallProductionPlan.cs:749 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(cCOLUMN_NAME), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-394e46a2 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 7 | SCP0017_WaterfallProductionPlan.cs:751 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | CALL_EXT | Debug.Print | (string.Format("All Rows {0} : cCOLUMN_NAME : {1}", i, cCOLUMN_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a15c0f4 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 7 | SCP0017_WaterfallProductionPlan.cs:753 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iSmallStartCol + i, 1, 1, 20, cMMDD_LABEL_NAME, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4460e2df | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 7 | SCP0017_WaterfallProductionPlan.cs:754 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol + i, 1, 1, 20, cCOLUMN_LABEL_NAME, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6fa7ffcd | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 7 | SCP0017_WaterfallProductionPlan.cs:755 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol + i, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.InitSpreadDateColumnNotISO

진입점: this.Load [else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (spdInfo.SheetNam…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65634c0e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:823 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b98b7313 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:827 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-b6066e5a | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:834 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cba475f7 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:835 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34c399c2 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:841 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7d15fe0f | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:842 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a063c42 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:850 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e6b345e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:851 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-977ee7f1 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:861 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-370fec2f | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:862 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d92a30b6 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:863 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3e58d69 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0017_WaterfallProductionPlan.cs:864 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.InitSpreadMain

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-706e9f9e | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1327 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.InitUOM

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6537bba | this.Load | SCP0017_WaterfallProductionPlan.cs:456 |  | FLAG | dtUOM | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-f4923779 | this.Load | SCP0017_WaterfallProductionPlan.cs:457 |  | DATA_OP | dtUOM.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d06b57d | this.Load | SCP0017_WaterfallProductionPlan.cs:458 |  | DATA_OP | dtUOM.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-039426a1 | this.Load | SCP0017_WaterfallProductionPlan.cs:460 |  | DATA_OP | dtUOM.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ec1f762e | this.Load | SCP0017_WaterfallProductionPlan.cs:461 |  | DATA_OP | r1["CODE"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-236a1f30 | this.Load | SCP0017_WaterfallProductionPlan.cs:462 |  | DATA_OP | r1["NAME"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-472241b9 | this.Load | SCP0017_WaterfallProductionPlan.cs:464 |  | DATA_OP | dtUOM.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cf7626f9 | this.Load | SCP0017_WaterfallProductionPlan.cs:465 |  | DATA_OP | r2["CODE"] | "EA" | 행/컬럼 값 대입 |  |  |  |
| AC-fac42159 | this.Load | SCP0017_WaterfallProductionPlan.cs:466 |  | DATA_OP | r2["NAME"] | "EA" | 행/컬럼 값 대입 |  |  |  |
| AC-958e64a0 | this.Load | SCP0017_WaterfallProductionPlan.cs:468 |  | DATA_OP | dtUOM.Rows.Add | (r1) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd7f82db | this.Load | SCP0017_WaterfallProductionPlan.cs:469 |  | DATA_OP | dtUOM.Rows.Add | (r2) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ddba377 | this.Load | SCP0017_WaterfallProductionPlan.cs:471 |  | LIST_REBIND | clsCtrl.setListBox | (dtUOM, clbUOM, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.RefreshBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c279e91 | this.Load | SCP0017_WaterfallProductionPlan.cs:1310 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-dbff4ce0 | this.Load | SCP0017_WaterfallProductionPlan.cs:1311 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d97602e4 | this.Load | SCP0017_WaterfallProductionPlan.cs:1249 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.RefreshElectrodeType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5667686 | this.Load | SCP0017_WaterfallProductionPlan.cs:1306 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrodeType, cboElectrode, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.RefreshLine

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboOperationGroup.SelectedIndexChanged / this.clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-673dbaf6 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0017_WaterfallProductionPlan.cs:1285 | if (this._division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "OPERATION_GROUP", "SITE_ID" }, new List<string>() { … | ⚠ 의미 확인 필요 |  |  |  |
| AC-24f17db7 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0017_WaterfallProductionPlan.cs:1287 | if (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | DBUtils.Filter(dtLineEEAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a87d6b28 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0017_WaterfallProductionPlan.cs:1287 | if (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtLineEEAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-87b8af7d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0017_WaterfallProductionPlan.cs:1291 | else of (this._division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "SITE_ID" }, new List<string>() { this._division, thi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ee00fd4 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0017_WaterfallProductionPlan.cs:1293 | else of (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | DBUtils.Filter(dtLineAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c4c2d486 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0017_WaterfallProductionPlan.cs:1293 | else of (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtLineAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f1d7457d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0017_WaterfallProductionPlan.cs:1296 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.RefreshOperationGroup

진입점: this.Load / this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd0ff1f2 | this.Load 외 1 | SCP0017_WaterfallProductionPlan.cs:1256 | if (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | dtOperationGroupEEAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-7df7f2eb | this.Load 외 1 | SCP0017_WaterfallProductionPlan.cs:1256 | if (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | dtOperationGroupEEAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8aacdc55 | this.Load 외 1 | SCP0017_WaterfallProductionPlan.cs:1260 | else of (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | dtOperationGroupAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-b2081d65 | this.Load 외 1 | SCP0017_WaterfallProductionPlan.cs:1260 | else of (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | dtOperationGroupAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e8d15156 | this.Load 외 1 | SCP0017_WaterfallProductionPlan.cs:1263 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.RefreshPlantSite

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29fce7f8 | this.Load 외 2 | SCP0017_WaterfallProductionPlan.cs:1267 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "OPERATION_GROUP" }, new List<string>() { this._divis… | ⚠ 의미 확인 필요 |  |  |  |
| AC-50a7e8ba | this.Load 외 2 | SCP0017_WaterfallProductionPlan.cs:1271 | if (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSite | DBUtils.Filter(dtPlantSiteEEAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fa9ed69 | this.Load 외 2 | SCP0017_WaterfallProductionPlan.cs:1271 | if (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtPlantSiteEEAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9b0b4121 | this.Load 외 2 | SCP0017_WaterfallProductionPlan.cs:1276 | else of (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSite | DBUtils.Filter(dtPlantSiteAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a11b32f2 | this.Load 외 2 | SCP0017_WaterfallProductionPlan.cs:1276 | else of (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtPlantSiteAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-bc53c8c7 | this.Load 외 2 | SCP0017_WaterfallProductionPlan.cs:1279 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.RefreshUOM

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0540a00a | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0017_WaterfallProductionPlan.cs:483 | if ((this._division == "EE") && (this._operation_group == "E")) ▸ for (i <= clbUOM.Items.Count - 1) ▸ if (clbUOM.Items[i].ToString() == "M") | CALL_EXT | clbUOM.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1031b2fb | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0017_WaterfallProductionPlan.cs:487 | if ((this._division == "EE") && (this._operation_group == "E")) ▸ for (i <= clbUOM.Items.Count - 1) ▸ else of (clbUOM.Items[i].ToString() ==… | CALL_EXT | clbUOM.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f365a348 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0017_WaterfallProductionPlan.cs:491 | if ((this._division == "EE") && (this._operation_group == "E")) | UI_PROP | lciUOM.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d9d5bc13 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0017_WaterfallProductionPlan.cs:500 | else of ((this._division == "EE") && (this._operation_group == "E")) ▸ for (i <= clbUOM.Items.Count - 1) ▸ if (clbUOM.Items[i].ToString() ==… | CALL_EXT | clbUOM.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a8ead1f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0017_WaterfallProductionPlan.cs:504 | else of ((this._division == "EE") && (this._operation_group == "E")) ▸ for (i <= clbUOM.Items.Count - 1) ▸ else of (clbUOM.Items[i].ToString… | CALL_EXT | clbUOM.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38200f9d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0017_WaterfallProductionPlan.cs:508 | else of ((this._division == "EE") && (this._operation_group == "E")) | UI_PROP | lciUOM.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.RefreshVersion

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a7c15db | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0017_WaterfallProductionPlan.cs:1300 |  | FLAG | dtVersion | DBUtils.Filter(dtVersionAll, "DIVISION_ID = '" + this._division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-21fdd78f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0017_WaterfallProductionPlan.cs:1300 |  | DATA_OP | DBUtils.Filter | (dtVersionAll, "DIVISION_ID = '" + this._division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-345e40dc | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0017_WaterfallProductionPlan.cs:1302 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersion, clbVersion, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.Set_OnHandEOH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03655590 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1589 | if (this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27f6ddb3 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1600 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e328d95 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1615 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-eab5581e | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1625 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (dt.Columns[nCol].ColumnName.IndexOf("_I… | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-43634d4d | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1696 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxWeek] | objBOH | 그리드 속성/값 설정 |  |  |  |
| AC-f0692832 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1707 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxMonth] | objBOH | 그리드 속성/값 설정 |  |  |  |
| AC-94e69d68 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1720 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.ActiveSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99b82f59 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1722 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.SetDecimal | (viewRow, nIdxStart, viewRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c17b311 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1728 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-ab8bd203 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1732 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0017_WaterfallProductionPlan.Set_ProductResult

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e47f780b | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1441 | if (spdInfo.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86d2cf64 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1444 |  | CALL_EXT | Convert.ToInt16 | (this._version.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba91548c | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1454 | if (int.Parse(this._from_yyyymmdd) < int.Parse(this._version.Substring(5, 8))) ▸ if (resultIdx != -1) | GRID_STYLE | spdInfo.SetBGColor2 | (0, spdInfo.nIdxData + 1, spdInfo.ActiveSheet.RowCount - 1, resultIdx, Color.FromArgb(234,… | 그리드 표시 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49085a64 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2456 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a3660f7e | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2460 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c725a8e1 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2463 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4413c26 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2467 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-2c947b04 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2468 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.SetColumnModelVisible

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed05f3ff | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2305 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1a68bae3 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2306 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ec5bbeb7 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2314 | try ▸ switch (this._operation_group) case "A": | GRID_SET | siMain.ActiveSheet.Columns[col].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a662e94e | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2317 | try ▸ switch (this._operation_group) case "P": | GRID_SET | siMain.ActiveSheet.Columns[col].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b4a54427 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:2325 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0017_WaterfallProductionPlan.SetLockSumColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3692669 | (진입점 미연결) | SCP0017_WaterfallProductionPlan.cs:1242 | for (iCol <= spreadInfo.GetMaxColumnIndex()) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).Index… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0017_WaterfallProductionPlan.SetQueryInfoGetModel

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4736660b | FindButton | SCP0017_WaterfallProductionPlan.cs:1373 | if (this.QueryDics[DIC_SCP0017_MODEL_FIND].Count > 0) | CALL_EXT | this.QueryDics[DIC_SCP0017_MODEL_FIND].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7270b6e1 | FindButton | SCP0017_WaterfallProductionPlan.cs:1378 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.InitSpreadMain | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-6a2f46a5 | FindButton | SCP0017_WaterfallProductionPlan.cs:1379 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindDataModel | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-998cadf1 | FindButton | SCP0017_WaterfallProductionPlan.cs:1380 |  | UI_PROP | qi.ServiceUri | BLUtils.GSCM_SCP_ANALYSIS_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-145ffcb8 | FindButton | SCP0017_WaterfallProductionPlan.cs:1381 |  | UI_PROP | qi.QueryId | "SCP.SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL" | 속성 QueryId 설정 |  |  |  |
| AC-ed120cf6 | FindButton | SCP0017_WaterfallProductionPlan.cs:1383 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef60f187 | FindButton | SCP0017_WaterfallProductionPlan.cs:1384 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_group", this._operation_group)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7c00644 | FindButton | SCP0017_WaterfallProductionPlan.cs:1385 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_scm_site_id", this._plant_site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-99d8b2e3 | FindButton | SCP0017_WaterfallProductionPlan.cs:1386 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_model_id", this._model)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1507bdb8 | FindButton | SCP0017_WaterfallProductionPlan.cs:1387 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-670557b4 | FindButton | SCP0017_WaterfallProductionPlan.cs:1388 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymmdd", this._from_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c71410c0 | FindButton | SCP0017_WaterfallProductionPlan.cs:1389 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymmdd", this._to_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a3a7c96 | FindButton | SCP0017_WaterfallProductionPlan.cs:1390 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_no", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b9b94e1 | FindButton | SCP0017_WaterfallProductionPlan.cs:1391 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0017")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a3ff5e3 | FindButton | SCP0017_WaterfallProductionPlan.cs:1392 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", "MODEL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5c97c65 | FindButton | SCP0017_WaterfallProductionPlan.cs:1393 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-af84fd6f | FindButton | SCP0017_WaterfallProductionPlan.cs:1394 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", this._electrode_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f621e06 | FindButton | SCP0017_WaterfallProductionPlan.cs:1395 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", this._nickname)) | 데이터 객체 조작/조회 |  |  |  |
| AC-302ddcd3 | FindButton | SCP0017_WaterfallProductionPlan.cs:1396 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_gap", this._gap)) | 데이터 객체 조작/조회 |  |  |  |
| AC-48e9f858 | FindButton | SCP0017_WaterfallProductionPlan.cs:1397 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", this._line)) | 데이터 객체 조작/조회 |  |  |  |
| AC-796b19aa | FindButton | SCP0017_WaterfallProductionPlan.cs:1398 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a417c0e4 | FindButton | SCP0017_WaterfallProductionPlan.cs:1401 |  | DATA_OP | this.QueryDics[DIC_SCP0017_MODEL_FIND] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0017_WaterfallProductionPlan.SetSpreadColumn

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboOperationGroup.SelectedIndexChanged [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [if (chkALL.Checked) ▸ if (siMain !…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16cf70a8 | this.Load 외 8 | SCP0017_WaterfallProductionPlan.cs:1175 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (isDaily \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e8dd9110 | this.Load 외 8 | SCP0017_WaterfallProductionPlan.cs:1180 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (isMonthly \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-91ec70ba | this.Load 외 8 | SCP0017_WaterfallProductionPlan.cs:1189 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ if (isDaily) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-02d522f1 | this.Load 외 8 | SCP0017_WaterfallProductionPlan.cs:1193 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ else of (isDaily) ▸ if (isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d831ca23 | this.Load 외 8 | SCP0017_WaterfallProductionPlan.cs:1198 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ if (isMonthly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-afdb0fda | this.Load 외 8 | SCP0017_WaterfallProductionPlan.cs:1205 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.WeeklyISO: | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | isWeeklyISO | 그리드 속성/값 설정 |  |  |  |
| AC-cdd42d1e | this.Load 외 8 | SCP0017_WaterfallProductionPlan.cs:1211 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Monthly: | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | isMonthly | 그리드 속성/값 설정 |  |  |  |

## SCP0017_WaterfallProductionPlan.SetVisibleMontColumns

진입점: this.cboBucketType.SelectedIndexChanged [else of (chkALL.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7acde678 | this.cboBucketType.SelectedIndexChanged [else of (chkALL.Che… | SCP0017_WaterfallProductionPlan.cs:1058 |  | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0017_WaterfallProductionPlan.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bdc733e | this.spdMain.CellDoubleClick | SCP0017_WaterfallProductionPlan.cs:2331 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c774e4f9 | this.spdMain.CellDoubleClick | SCP0017_WaterfallProductionPlan.cs:2335 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-3eefc2d4 | this.spdMain.CellDoubleClick | SCP0017_WaterfallProductionPlan.cs:2336 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0017_WaterfallProductionPlan.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-506c52d2 | this.spdMain.TopChange | SCP0017_WaterfallProductionPlan.cs:905 |  | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |

