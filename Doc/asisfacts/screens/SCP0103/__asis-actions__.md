# AS-IS 액션 대조표 — SCP0103

> 원천: `Doc/asisfacts/screens/SCP0103/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 351행 · 메서드 94 · 종류 DATA_OP 67 · RETURN 57 · FLAG 51 · GRID_INIT 36 · CALL_EXT 29 · GRID_SET 21 · UI_PROP 15 · UI_MISC 13 · LIST_REBIND 13 · COMBO_DATA 13 · POPUP 10 · ENDPOINT 5 · GRID_BIND 3 · GRID_LOCK 3 · MESSAGE 3 · VALUE_SET 3 · VALIDATE 3 · GRID_STYLE 2 · GRID_CLEAR 2 · STATE_RESET 1 · THROW 1 · ⚠ 의미 확인 필요 29


## SCP0103_MaterialVisibility.AfterFindDataModel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e911a462 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1572 |  | FLAG | _tblSemiStockAll | ds.Tables[1].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-7f8ed2d1 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1572 |  | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2851f723 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1573 |  | FLAG | _tblRequirementAll | ds.Tables[2].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-19a7aa96 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1573 |  | DATA_OP | ds.Tables[2].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e371de00 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1575 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8382ab7d | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1577 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e3a2ef4 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1579 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-40c33204 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1581 |  | FLAG | this.dsModelAll | ds | 화면 필드/플래그 변경 |  |  |  |
| AC-f64d56ec | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1585 |  | UI_MISC | SetSearchCount | (this.dsModelAll) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d0054386 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1599 | if (this.nSelRowOfMain >= 0 && _isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-a09b128d | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1600 | if (this.nSelRowOfMain >= 0 && _isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-49ba52ba | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1603 |  | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0103_MaterialVisibility.ApplyUOM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fcde1bc | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2132 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aae97328 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2135 | if (this.dsModelAll == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f827e0f | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2138 | if (this.dsModelAll.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea027bad | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2140 |  | DATA_OP | this.dsModelAll.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-21aa18b4 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2144 | if (dtModelAll == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a35e5af1 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2148 | if ((this._uom == "") \|\| (this._uom.IndexOf(",") > -1)) | DATA_OP | dtModelAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cdaaf1dd | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2153 | else of ((this._uom == "") \|\| (this._uom.IndexOf(",") > -1)) | DATA_OP | DBUtils.Filter | (dtModelAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-414c6405 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2158 |  | DATA_OP | ds.Tables.Add | (dtModelFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-94bd21ea | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2160 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |

## SCP0103_MaterialVisibility.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-477b6f3d | this.btnColumn.Click | SCP0103_MaterialVisibility.cs:1068 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0103", SpdSheet.shtAll, true) | 팝업/폼 생성 |  |  |  |
| AC-136db891 | this.btnColumn.Click | SCP0103_MaterialVisibility.cs:1069 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-08c860bc | this.btnColumn.Click | SCP0103_MaterialVisibility.cs:1070 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0103_MaterialVisibility.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-805dafaf | this.btnMeasure.Click | SCP0103_MaterialVisibility.cs:1089 | if (fps != null) ▸ else of (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e467c40d | this.btnMeasure.Click | SCP0103_MaterialVisibility.cs:1090 | if (fps != null) ▸ else of (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af8bee5c | this.btnMeasure.Click | SCP0103_MaterialVisibility.cs:1095 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-915f16f8 | this.btnMeasure.Click | SCP0103_MaterialVisibility.cs:1096 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f18535a0 | this.btnMeasure.Click | SCP0103_MaterialVisibility.cs:1099 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0103", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-54c3ff35 | this.btnMeasure.Click | SCP0103_MaterialVisibility.cs:1100 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b7f508ff | this.btnMeasure.Click | SCP0103_MaterialVisibility.cs:1102 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-41ec1a43 | this.btnMeasure.Click | SCP0103_MaterialVisibility.cs:1106 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-337e8cfd | this.btnMeasure.Click | SCP0103_MaterialVisibility.cs:1110 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0103_MaterialVisibility.CalculateSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ad0e015 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1994 | for (col < dt.Columns.Count) ▸ if (dt.Columns[col].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (col) | 데이터 객체 조작/조회 |  |  |  |
| AC-802773a6 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1998 | for (col < dt.Columns.Count) ▸ if (dt.Columns[col].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (col) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9bf8d0b | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2061 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (col == dt.Columns.Count - 1 \|\| dt.Columns[col].ColumnName.IndexOf("W_") == … | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-648dc73c | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2065 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (col == dt.Columns.Count - 1 \|\| dt.Columns[col].ColumnName.IndexOf("W_") == … | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-62ff2a25 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2070 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (col == dt.Columns.Count - 1 \|\| dt.Columns[col].ColumnName.IndexOf("W_") == … | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-84ec29ff | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2088 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (col == dt.Columns.Count - 1 \|\| dt.Columns[col].ColumnName.IndexOf("M_") == … | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-a892cf3f | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2092 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (col == dt.Columns.Count - 1 \|\| dt.Columns[col].ColumnName.IndexOf("M_") == … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-5d6d0434 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2101 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0103_MaterialVisibility.CalculateSumMain

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cce796ac | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1787 | for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(j).ToString().IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e69e2b4 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1791 | for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(j).ToString().IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc307f73 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1864 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (measure.Equals("FORMATION_YIELD")) ▸ if (col == siM… | GRID_SET | siMain.SetValue | (iRow, nIdxWeek, weekSum / nCntDayOfWeek) | 그리드 값 설정 |  |  |  |
| AC-8d8a24b5 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1877 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (measure.Equals("FORMATION_YIELD")) ▸ if (col == siM… | GRID_SET | siMain.SetValue | (iRow, nIdxMonth, monthSum / nCntDayOfMonth) | 그리드 값 설정 |  |  |  |
| AC-a4a9977b | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1893 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ if (measu… | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, siMain.GetValue(iRow, bef_day_idx)) | 그리드 값 설정 |  |  |  |
| AC-9af95ff5 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1902 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ if (measu… | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, siMain.GetValue(iRow, bef_day_idx)) | 그리드 값 설정 |  |  |  |
| AC-15a0fca9 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1912 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ if (measu… | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, siMain.GetValue(iRow, bef_day_idx)) | 그리드 값 설정 |  |  |  |
| AC-2726c452 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1913 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ if (measu… | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, siMain.GetValue(iRow, bef_day_idx)) | 그리드 값 설정 |  |  |  |
| AC-d4df3547 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1957 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ else of (… | GRID_SET | siMain.SetValue | (iRow, nIdxWeek_D, weekSum_D) | 그리드 값 설정 |  |  |  |
| AC-bf77cca2 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1968 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ else of (measure.Equals("FORMATION_YIELD")) ▸ else of (… | GRID_SET | siMain.SetValue | (iRow, nIdxMonth_D, monthSum_D) | 그리드 값 설정 |  |  |  |

## SCP0103_MaterialVisibility.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85c09aac | this.cboBucketType.SelectedIndexChanged | SCP0103_MaterialVisibility.cs:1129 | if (chkALL.Checked) ▸ if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO \|\| beforeBucketType == BucketType.Week… | GRID_INIT | siMain.SetSheetHeaderColumn2 | (siMain, 3, true, DefColumns.BOH) | 그리드 재구성/초기화 |  |  |  |
| AC-c90848eb | this.cboBucketType.SelectedIndexChanged | SCP0103_MaterialVisibility.cs:1135 | if (chkALL.Checked) ▸ if (siMain != null) | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b92588e2 | this.cboBucketType.SelectedIndexChanged | SCP0103_MaterialVisibility.cs:1143 | else of (chkALL.Checked) | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-84006821 | this.cboBucketType.SelectedIndexChanged | SCP0103_MaterialVisibility.cs:1149 |  | FLAG | beforeBucketType | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |

## SCP0103_MaterialVisibility.cboOperationGroup_SelectedIndexChanged

진입점: this.cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f19b7c40 | this.cboOperationGroup.SelectedIndexChanged | SCP0103_MaterialVisibility.cs:2171 | if (_first) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.chkAll_CheckedChanged

진입점: this.chkALL.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2341d0b | this.chkALL.CheckedChanged | SCP0103_MaterialVisibility.cs:1191 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0103_MaterialVisibility.clbNickname_SelectedIndexChanged

진입점: this.clbNickname.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aff5b06e | this.clbNickname.SelectedIndexChanged | SCP0103_MaterialVisibility.cs:2184 | if (_first) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.ClearEventInvocations

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8aacd223 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2339 | if (fi == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af964345 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2341 |  | GRID_SET | fi.SetValue | (obj, null) | 그리드 값 설정 |  |  |  |

## SCP0103_MaterialVisibility.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-302fd8f1 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:712 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-57266e48 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:713 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.CreateSpread

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96cdc518 | this.Load [try] | SCP0103_MaterialVisibility.cs:825 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtAll, SpdSheet.shtAll, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-046f1b7b | this.Load [try] | SCP0103_MaterialVisibility.cs:827 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc105405 | this.Load [try] | SCP0103_MaterialVisibility.cs:829 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0103_MaterialVisibility.DefineProperty

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1294f459 | this.Load [try] | SCP0103_MaterialVisibility.cs:703 |  | UI_PROP | usrConditionPanel1.Height | 80 | 속성 Height 설정 |  |  |  |
| AC-088a517f | this.Load [try] | SCP0103_MaterialVisibility.cs:704 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-9cfdd4ff | this.Load [try] | SCP0103_MaterialVisibility.cs:705 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0103_MaterialVisibility.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc0d77b8 | Dispose | SCP0103_MaterialVisibility.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0103_MaterialVisibility.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11dc71f1 | EditButton | SCP0103_MaterialVisibility.cs:1061 | if (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38bfeccb | EditButton | SCP0103_MaterialVisibility.cs:1062 | if (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a28dc4e | FindButton | SCP0103_MaterialVisibility.cs:1649 |  | ENDPOINT | this.ExecuteSQL | (siMain, DIC_SCP0103_FIND, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-39bf5fb3 | FindButton | SCP0103_MaterialVisibility.cs:1657 |  | FLAG | _isReload | isReload | 화면 필드/플래그 변경 |  |  |  |
| AC-0ebde3a4 | FindButton | SCP0103_MaterialVisibility.cs:1659 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-f962d907 | FindButton | SCP0103_MaterialVisibility.cs:1660 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9592e0c1 | FindButton | SCP0103_MaterialVisibility.cs:1662 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-23ea10cd | FindButton | SCP0103_MaterialVisibility.cs:1663 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1d7010e | this.Load | SCP0103_MaterialVisibility.cs:676 | try | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c3575568 | this.Load | SCP0103_MaterialVisibility.cs:692 | finally | FLAG | _first | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0103_MaterialVisibility.GetBucketType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9db0a938 | this.Load [try] | SCP0103_MaterialVisibility.cs:1261 |  | COMBO_DATA | Data.Common | (Data.Type.BucketType, false, "", "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=BucketType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1f4b865 | this.Load [try] | SCP0103_MaterialVisibility.cs:1265 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getCellValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e928eac2 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:728 | try ▸ if (col > -1) | CALL_EXT | siMain.GetValue2 | (row, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60a843f8 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:735 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getCurrCellValue

진입점: this.spdMain.CellClick / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9b6ac02 | this.spdMain.CellClick 외 1 | SCP0103_MaterialVisibility.cs:304 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-213a8015 | this.spdMain.CellClick 외 1 | SCP0103_MaterialVisibility.cs:309 |  | RETURN | return getCurrCellValue(rowIndex, siMain.GetColumnIndex(columnName)); |  | 처리 중단/반환 |  |  |  |
| AC-62d65bcb | this.spdMain.CellClick 외 1 | SCP0103_MaterialVisibility.cs:314 |  | RETURN | return getCurrCellValue(_currSheetRow, columnName); |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getCurrDayColumnName

진입점: this.spdMain.CellClick [if (_curr_yyyymmdd != "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a75cbf5 | this.spdMain.CellClick [if (_curr_yyyymmdd != "")] | SCP0103_MaterialVisibility.cs:400 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getCurrDayColumnValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f97c17d9 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:412 | if (siMain.GetColumnTag(col).IndexOf("M_") != 0 && siMain.GetColumnTag(col).IndexOf("W_") != 0 && siMain.GetColumnTag(col).I…) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-2c2b2ebe | (진입점 미연결) | SCP0103_MaterialVisibility.cs:416 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetCurrMeasure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36277dec | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2505 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7caf107b | (진입점 미연결) | SCP0103_MaterialVisibility.cs:61 |  | RETURN | return CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues); |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a881eceb | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2371 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-f504d8db | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2372 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c5926565 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2375 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetEventField

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f74ab993 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2351 | while (type != null) | CALL_EXT | type.GetField | (eventName, BindingFlags.Static \| BindingFlags.Instance \| BindingFlags.NonPublic) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee12f653 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2352 | while (type != null) | CALL_EXT | field.FieldType.IsSubclassOf | (typeof(MulticastDelegate)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40179973 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2356 | while (type != null) | CALL_EXT | type.GetField | ("EVENT_" + eventName.ToUpper(), BindingFlags.Static \| BindingFlags.Instance \| BindingFl… | ⚠ 의미 확인 필요 |  |  |  |
| AC-716d70bc | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2361 |  | RETURN | return field; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetFilteredTable

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged / this.cboOperationGroup.SelectedIndexChanged / this.clbNickname.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5161ae61 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1288 |  | DATA_OP | tbl.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ed2ba020 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1294 | try ▸ if (res.Rows.Count > 0) | GRID_CLEAR | res.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-d5820ed6 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1297 | try | DATA_OP | DBUtils.Filter | (tbl, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-76eff7cf | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1301 | try | CALL_EXT | DBUtils.SelectColumns | (t1, cols) | ⚠ 의미 확인 필요 |  |  |  |
| AC-77717ada | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1303 | try | CALL_EXT | DBUtils.GetDistinctTable | (t2, cols) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a5c28715 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1309 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getFromYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7eba1136 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:230 |  | RETURN | return dCalendar.Text1.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getItemCategory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff13c676 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:126 |  | RETURN | return CString.GetCheckedListValue(dtItemCategory, clbItemCategory.ControlValues… |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e423acd | (진입점 미연결) | SCP0103_MaterialVisibility.cs:140 |  | RETURN | return CString.GetCheckedListValue(dtItemId, clbItemId.ControlValues, true); |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getMaterial

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d36352cc | (진입점 미연결) | SCP0103_MaterialVisibility.cs:168 |  | RETURN | return CString.GetCheckedListValue(dtMaterial, clbMaterial.ControlValues, true); |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getMRPPlanStartYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79e7d4c2 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:216 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetMRPPlanTemrs

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ try] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ try] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged [try] / this.cboMRPPlanStartYYYYMMDD.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4b18e55 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 3 | SCP0103_MaterialVisibility.cs:1524 | try | CALL_EXT | DateUtil.GetDayRangeToWeeks | (scp_plan_start_yyyymmdd, 16) | ⚠ 의미 확인 필요 |  |  |  |
| AC-edaa26d6 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 3 | SCP0103_MaterialVisibility.cs:1536 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getNickname

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93f6b1a2 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:154 |  | RETURN | return CString.GetCheckedListValue(dtNickname, clbNickname.ControlValues, true); |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getOperationGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-024a3cdd | (진입점 미연결) | SCP0103_MaterialVisibility.cs:98 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb25b898 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:75 |  | RETURN | return CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues, true); |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetQuotedValues

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (this._nickname != "")] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (this._nickname != "")] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged [if (this._nickname != "")] / this.cboOperationGroup.SelectedIndexChanged [if (this._nickname != "")] / this.clbNickname.SelectedIndexChanged [if (this._nickname != "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ccf39e9 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1365 | try ▸ for (i <= lst.Count-1) | DATA_OP | lst[i] | string.Format("'{0}'", lst[i]) | 행/컬럼 값 대입 |  |  |  |
| AC-2d0dd00e | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1374 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getRequirementFilter

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06f5f0ea | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2270 |  | RETURN | return filter; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getSCPPlanStartYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de3ce4a2 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:192 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getSemiStockFilter

진입점: this.spdMain.CellDoubleClick [if (isEEDivision && _operation_group == "A") ▸ if (_curr_measure_name.ToUpper().Equals("BALANCE") && (e.Column == siMain.GetColumnIndex(DefColumns.BOH)))] / this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f042319c | this.spdMain.CellDoubleClick [if (isEEDivision && _operation… 외 1 | SCP0103_MaterialVisibility.cs:2253 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32c2226d | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2411 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d973847b | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2405 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7aa26494 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2417 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetSpdTitle

진입점: this.Load [try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboBucketType.SelectedIndexChanged [if (chkALL.Checked) ▸ if (siMain != null)] / this.chkALL.CheckedChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e345951 | this.Load [try] 외 6 | SCP0103_MaterialVisibility.cs:2435 |  | ENDPOINT | new FoxDataRequest | (procName) ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO \| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-54696275 | this.Load [try] 외 6 | SCP0103_MaterialVisibility.cs:2437 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | this._from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-86255d9a | this.Load [try] 외 6 | SCP0103_MaterialVisibility.cs:2438 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | this._to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6fe4cdeb | this.Load [try] 외 6 | SCP0103_MaterialVisibility.cs:2440 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-568a7269 | this.Load [try] 외 6 | SCP0103_MaterialVisibility.cs:2440 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0103_MaterialVisibility.getSupplier

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1affd10 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:112 |  | RETURN | return CString.GetCheckedListValue(dtSupplier, clbSupplier.ControlValues, true); |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getToYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d5cb844 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:244 |  | RETURN | return dCalendar.Text2.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.getUOM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcb990ce | (진입점 미연결) | SCP0103_MaterialVisibility.cs:258 |  | RETURN | return CString.GetCheckedListValue(dtUOM, clbUOM.TextList, true); |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.GetUOM

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab1dfcd6 | this.Load [try] | SCP0103_MaterialVisibility.cs:741 |  | FLAG | dtUOM | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-c0804d38 | this.Load [try] | SCP0103_MaterialVisibility.cs:742 |  | DATA_OP | dtUOM.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cde3d051 | this.Load [try] | SCP0103_MaterialVisibility.cs:743 |  | DATA_OP | dtUOM.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1993ab6 | this.Load [try] | SCP0103_MaterialVisibility.cs:745 |  | DATA_OP | dtUOM.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-da87703b | this.Load [try] | SCP0103_MaterialVisibility.cs:746 |  | DATA_OP | r1["CODE"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-90dd933b | this.Load [try] | SCP0103_MaterialVisibility.cs:747 |  | DATA_OP | r1["NAME"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-150a7d28 | this.Load [try] | SCP0103_MaterialVisibility.cs:749 |  | DATA_OP | dtUOM.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25074aae | this.Load [try] | SCP0103_MaterialVisibility.cs:750 |  | DATA_OP | r2["CODE"] | "EA" | 행/컬럼 값 대입 |  |  |  |
| AC-8cedf9f7 | this.Load [try] | SCP0103_MaterialVisibility.cs:751 |  | DATA_OP | r2["NAME"] | "EA" | 행/컬럼 값 대입 |  |  |  |
| AC-5d92dd1f | this.Load [try] | SCP0103_MaterialVisibility.cs:753 |  | DATA_OP | dtUOM.Rows.Add | (r1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddb16f91 | this.Load [try] | SCP0103_MaterialVisibility.cs:754 |  | DATA_OP | dtUOM.Rows.Add | (r2) | 데이터 객체 조작/조회 |  |  |  |
| AC-20489a25 | this.Load [try] | SCP0103_MaterialVisibility.cs:756 |  | RETURN | return dtUOM; |  | 처리 중단/반환 |  |  |  |

## SCP0103_MaterialVisibility.InitControls

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2081693 | this.Load [try] | SCP0103_MaterialVisibility.cs:807 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtAll) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa1d152c | this.Load [try] | SCP0103_MaterialVisibility.cs:810 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-75d1ca25 | this.Load [try] | SCP0103_MaterialVisibility.cs:812 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SCP0103_MaterialVisibility.InitQueryDics

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17077e51 | this.Load [try] | SCP0103_MaterialVisibility.cs:601 |  | DATA_OP | QueryDics.Add | (DIC_SCP0103_FIND, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0103_MaterialVisibility.InitSearchConditionDatas

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dfeab19 | this.Load [try] | SCP0103_MaterialVisibility.cs:624 |  | FLAG | dtDivisionAll | BLUtils.GetDivision(false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-7237ef1e | this.Load [try] | SCP0103_MaterialVisibility.cs:624 |  | CALL_EXT | BLUtils.GetDivision | (false, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f6b0b97 | this.Load [try] | SCP0103_MaterialVisibility.cs:625 |  | FLAG | dtSCPPlanStartYYYYMMDDAll | Data_SCP.Common(Data_SCP.Type.SCP_PLAN_START_DATE, false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-ad865d16 | this.Load [try] | SCP0103_MaterialVisibility.cs:625 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SCP_PLAN_START_DATE, false, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3e6c41c7 | this.Load [try] | SCP0103_MaterialVisibility.cs:626 |  | FLAG | dtMRPPlanStartYYYYMMDDAll | Data_SCP.Common(Data_SCP.Type.MRP_PLAN_START_DATE, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-1d5e6b0a | this.Load [try] | SCP0103_MaterialVisibility.cs:626 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MRP_PLAN_START_DATE, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b8a5a57 | this.Load [try] | SCP0103_MaterialVisibility.cs:627 |  | FLAG | dtPlantAll | Data_SCP.Common(Data_SCP.Type.MRP_PLANT, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-ecbca09e | this.Load [try] | SCP0103_MaterialVisibility.cs:627 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MRP_PLANT, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-91254824 | this.Load [try] | SCP0103_MaterialVisibility.cs:628 |  | FLAG | dtSupplierAll | Data_SCP.Common(Data_SCP.Type.MRP_SUPPLIER, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-cc08fa8b | this.Load [try] | SCP0103_MaterialVisibility.cs:628 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MRP_SUPPLIER, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd1e0474 | this.Load [try] | SCP0103_MaterialVisibility.cs:629 |  | FLAG | dtOperationGroupAll | Data_SCP.Common(Data_SCP.Type.MRP_OPERATION, false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-02208aa9 | this.Load [try] | SCP0103_MaterialVisibility.cs:629 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MRP_OPERATION, false, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f6bf2fae | this.Load [try] | SCP0103_MaterialVisibility.cs:630 |  | FLAG | dtNicknameAll | Data_SCP.Common(Data_SCP.Type.MRP_NICKNAME, false, "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-b285ddb3 | this.Load [try] | SCP0103_MaterialVisibility.cs:630 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MRP_NICKNAME, false, "", "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c98e0a33 | this.Load [try] | SCP0103_MaterialVisibility.cs:631 |  | FLAG | dtItemIdAll | Data_SCP.Common(Data_SCP.Type.MRP_ITEM_ID, false, "", "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-211ab3fe | this.Load [try] | SCP0103_MaterialVisibility.cs:631 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MRP_ITEM_ID, false, "", "", "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-869e3f3a | this.Load [try] | SCP0103_MaterialVisibility.cs:632 |  | FLAG | dtMaterialAll | Data_SCP.Common(Data_SCP.Type.MRP_MATERIAL, false, "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-baf010c1 | this.Load [try] | SCP0103_MaterialVisibility.cs:632 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MRP_MATERIAL, false, "", "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-17b95b5e | this.Load [try] | SCP0103_MaterialVisibility.cs:633 |  | FLAG | dtItemCategoryAll | Data_SCP.Common(Data_SCP.Type.MRP_ITEM_CATEGORY, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-aa0eadcd | this.Load [try] | SCP0103_MaterialVisibility.cs:633 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MRP_ITEM_CATEGORY, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e4678b17 | this.Load [try] | SCP0103_MaterialVisibility.cs:635 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e1db8205 | this.Load [try] | SCP0103_MaterialVisibility.cs:636 |  | FLAG | dtUOM | GetUOM() | 화면 필드/플래그 변경 |  |  |  |
| AC-f69e09c1 | this.Load [try] | SCP0103_MaterialVisibility.cs:637 |  | FLAG | dtElectrodeType | Data.Common(Data.Type.LookupCommon, false, CConstVariable.ElectrodeType) ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-1fa990be | this.Load [try] | SCP0103_MaterialVisibility.cs:637 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, CConstVariable.ElectrodeType) ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0ee57775 | this.Load [try] | SCP0103_MaterialVisibility.cs:639 |  | FLAG | dtDivision | dtDivisionAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1229f11a | this.Load [try] | SCP0103_MaterialVisibility.cs:639 |  | DATA_OP | dtDivisionAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34b52191 | this.Load [try] | SCP0103_MaterialVisibility.cs:640 |  | FLAG | dtSCPPlanStartYYYYMMDD | dtSCPPlanStartYYYYMMDDAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-046dd0e7 | this.Load [try] | SCP0103_MaterialVisibility.cs:640 |  | DATA_OP | dtSCPPlanStartYYYYMMDDAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8b161193 | this.Load [try] | SCP0103_MaterialVisibility.cs:641 |  | FLAG | dtMRPPlanStartYYYYMMDD | dtMRPPlanStartYYYYMMDDAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a5512cb5 | this.Load [try] | SCP0103_MaterialVisibility.cs:641 |  | DATA_OP | dtMRPPlanStartYYYYMMDDAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b36f61c4 | this.Load [try] | SCP0103_MaterialVisibility.cs:642 |  | FLAG | dtPlant | dtPlantAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-86f4bd4a | this.Load [try] | SCP0103_MaterialVisibility.cs:642 |  | DATA_OP | dtPlantAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f4d2d26 | this.Load [try] | SCP0103_MaterialVisibility.cs:643 |  | FLAG | dtSupplier | dtSupplierAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-949a6bb6 | this.Load [try] | SCP0103_MaterialVisibility.cs:643 |  | DATA_OP | dtSupplierAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-65c278dc | this.Load [try] | SCP0103_MaterialVisibility.cs:644 |  | FLAG | dtOperationGroup | dtOperationGroupAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-cdb3b3f8 | this.Load [try] | SCP0103_MaterialVisibility.cs:644 |  | DATA_OP | dtOperationGroupAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-06e9b2ea | this.Load [try] | SCP0103_MaterialVisibility.cs:645 |  | FLAG | dtNickname | dtNicknameAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-2aa69da0 | this.Load [try] | SCP0103_MaterialVisibility.cs:645 |  | DATA_OP | dtNicknameAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7605c89c | this.Load [try] | SCP0103_MaterialVisibility.cs:646 |  | FLAG | dtItemId | dtItemIdAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c9d63164 | this.Load [try] | SCP0103_MaterialVisibility.cs:646 |  | DATA_OP | dtItemIdAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e7909ed4 | this.Load [try] | SCP0103_MaterialVisibility.cs:647 |  | FLAG | dtMaterial | dtMaterialAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-4ca110a1 | this.Load [try] | SCP0103_MaterialVisibility.cs:647 |  | DATA_OP | dtMaterialAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7e673ef7 | this.Load [try] | SCP0103_MaterialVisibility.cs:648 |  | FLAG | dtItemCategory | dtItemCategoryAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-57430d16 | this.Load [try] | SCP0103_MaterialVisibility.cs:648 |  | DATA_OP | dtItemCategoryAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0103_MaterialVisibility.InitSpread

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a25e2235 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:852 | if (spdInfo == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-486322ed | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:860 | if (spdInfo.SheetName == SpdSheet.shtAll) | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-52b9e109 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:868 | if (spdInfo.SheetName == SpdSheet.shtAll) | CALL_EXT | spdInfo.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0103_MaterialVisibility.InitSpread_2

진입점: this.Load [try] / this.cboBucketType.SelectedIndexChanged [else of (chkALL.Checked)] / this.chkALL.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-876e93d4 | this.Load [try] 외 2 | SCP0103_MaterialVisibility.cs:836 |  | GRID_INIT | siMain.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7656534d | this.Load [try] 외 2 | SCP0103_MaterialVisibility.cs:840 |  | GRID_INIT | siMain.SetSheetHeaderColumn2 | (spreadInfo, 3, chkAll, DefColumns.BOH) | 그리드 재구성/초기화 |  |  |  |
| AC-00f97a92 | this.Load [try] 외 2 | SCP0103_MaterialVisibility.cs:846 |  | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0103_MaterialVisibility.InitSpreadDateColumnISO

진입점: this.Load [try ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtAll) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtAll) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (spdInfo.SheetName == SpdSheet.shtAll) ▸ if (cboBucketTyp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd3b3f8e | this.Load [try ▸ if (cboBucketType.ControlValues == BucketTy… 외 6 | SCP0103_MaterialVisibility.cs:909 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | GRID_INIT | spdInfo.AddNumColumn | (COLUMN_LABEL_NAME, COLUMN_NAME, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25a567fe | this.Load [try ▸ if (cboBucketType.ControlValues == BucketTy… 외 6 | SCP0103_MaterialVisibility.cs:911 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(COLUMN_NAME), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-37f8d0e0 | this.Load [try ▸ if (cboBucketType.ControlValues == BucketTy… 외 6 | SCP0103_MaterialVisibility.cs:913 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | CALL_EXT | Debug.Print | (string.Format("All Rows {0} : cCOLUMN_NAME : {1}", i, COLUMN_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4f40daf | this.Load [try ▸ if (cboBucketType.ControlValues == BucketTy… 외 6 | SCP0103_MaterialVisibility.cs:915 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, smallStartCol + i, 1, 1, 20, MMDD_LABEL_NAME, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd9c22d8 | this.Load [try ▸ if (cboBucketType.ControlValues == BucketTy… 외 6 | SCP0103_MaterialVisibility.cs:916 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, smallStartCol + i, 1, 1, 20, COLUMN_LABEL_NAME, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71e4b411 | this.Load [try ▸ if (cboBucketType.ControlValues == BucketTy… 외 6 | SCP0103_MaterialVisibility.cs:917 | for (i <= dsSpdTitle.Tables[0].Rows.Count - 1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, smallStartCol + i, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0103_MaterialVisibility.InitSpreadDateColumnNotISO

진입점: this.Load [try ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtAll) ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtAll) ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (spdInfo.SheetName == SpdSheet.shtAll) ▸ e…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a1b0d4d | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:958 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (COLUMN_NAME.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (COLUMN_LABEL_NAME, COLUMN_NAME, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0ae5cb3 | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:962 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (COLUMN_NAME.IndexOf("B_") > 0) ▸ if (DAY_CODE == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | DAY_CODE == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-be89794e | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:969 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != LARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, largeStartCol, 1, largeSpanCnt, 20, largeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-695a85b4 | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:970 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != LARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, largeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae1a3399 | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:976 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != LARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, smallStartCol, 1, smallSpanCnt, 20, smallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-754f9482 | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:977 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != LARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, smallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d71c6ece | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:985 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (largeSpanName != LARGE_CLASS_LABEL_NAME) ▸ if (smallSpanName != SMALL_CLASS_LAB… | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, smallStartCol, 1, smallSpanCnt, 20, smallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51da9a82 | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:986 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (largeSpanName != LARGE_CLASS_LABEL_NAME) ▸ if (smallSpanName != SMALL_CLASS_LAB… | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, smallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0dc43b9e | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:996 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, smallStartCol, 1, smallSpanCnt, 20, smallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21a98607 | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:997 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, smallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-441e94e4 | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:998 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, largeStartCol, 1, largeSpanCnt, 20, largeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-622dc907 | this.Load [try ▸ else of (cboBucketType.ControlValues == Buc… 외 6 | SCP0103_MaterialVisibility.cs:999 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, largeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0103_MaterialVisibility.InitSpreadMain

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-886d4d79 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1559 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0103_MaterialVisibility.InitUOM

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf79838f | this.Load [try] | SCP0103_MaterialVisibility.cs:761 |  | LIST_REBIND | clsCtrl.setListBox | (dtUOM, clbUOM, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshBucketType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8157146 | this.Load [try] | SCP0103_MaterialVisibility.cs:1477 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c41b3ce9 | this.Load [try] | SCP0103_MaterialVisibility.cs:1283 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshItemCategory

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f84796a | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 2 | SCP0103_MaterialVisibility.cs:1441 |  | FLAG | dtItemCategory | GetFilteredTable(dtItemCategoryAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4ac18ee9 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 2 | SCP0103_MaterialVisibility.cs:1443 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemCategory, clbItemCategory, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshItemId

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged / this.cboOperationGroup.SelectedIndexChanged / this.clbNickname.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-434e5521 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1412 |  | FLAG | dtItemId | GetFilteredTable(dtItemIdAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f13ae1fe | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1414 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemId, clbItemId, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshMaterial

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged / this.cboOperationGroup.SelectedIndexChanged / this.clbNickname.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f553e370 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1432 |  | FLAG | dtMaterial | GetFilteredTable(dtMaterialAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3ae4dc03 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 4 | SCP0103_MaterialVisibility.cs:1434 |  | LIST_REBIND | clsCtrl.setListBox | (dtMaterial, clbMaterial, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshMRPPLanYYYYMMDD

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b21fb03 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 2 | SCP0103_MaterialVisibility.cs:1325 |  | FLAG | dtMRPPlanStartYYYYMMDD | GetFilteredTable(dtMRPPlanStartYYYYMMDDAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-411432d9 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 2 | SCP0103_MaterialVisibility.cs:1327 |  | LIST_REBIND | clsCtrl.setListBox | (dtMRPPlanStartYYYYMMDD, cboMRPPlanStartYYYYMMDD, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshNickname

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged / this.cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65d8ba0d | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 3 | SCP0103_MaterialVisibility.cs:1347 |  | FLAG | dtNickname | GetFilteredTable(dtNicknameAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5c177807 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 3 | SCP0103_MaterialVisibility.cs:1349 |  | LIST_REBIND | clsCtrl.setListBox | (dtNickname, clbNickname, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshOperationGroup

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cc35dba | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 2 | SCP0103_MaterialVisibility.cs:1336 | if (this._division != null) | FLAG | dtOperationGroup | GetFilteredTable(dtOperationGroupAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c438cdf0 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 2 | SCP0103_MaterialVisibility.cs:1338 | if (this._division != null) | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshPeriod

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged / this.cboMRPPlanStartYYYYMMDD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18611315 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 3 | SCP0103_MaterialVisibility.cs:1543 | try | VALUE_SET | dCalendar.InitValue | GetMRPPlanTemrs() | 컨트롤 값 설정 |  |  |  |

## SCP0103_MaterialVisibility.RefreshPlantSite

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69bf5908 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 2 | SCP0103_MaterialVisibility.cs:1470 |  | FLAG | dtPlant | GetFilteredTable(dtPlantAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-eae561fc | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 2 | SCP0103_MaterialVisibility.cs:1472 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshRequirement

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a8436d2 | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2287 |  | DATA_OP | DBUtils.Filter | (this._tblRequirementAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fc171ab4 | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2289 |  | FLAG | this._tblRequirementFiltered | DBUtils.SelectColumns(tbl1, _semiStockColNames) | 화면 필드/플래그 변경 |  |  |  |
| AC-7cd0fc20 | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2289 |  | CALL_EXT | DBUtils.SelectColumns | (tbl1, _semiStockColNames) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0103_MaterialVisibility.RefreshSCPPlanStartYYYYYMMDD

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a2ef888 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 1 | SCP0103_MaterialVisibility.cs:1316 |  | FLAG | dtSCPPlanStartYYYYMMDD | GetFilteredTable(dtSCPPlanStartYYYYMMDDAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-21f64dfb | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 1 | SCP0103_MaterialVisibility.cs:1318 |  | LIST_REBIND | clsCtrl.setListBox | (dtSCPPlanStartYYYYMMDD, cboSCPPlanStartYYYYMMDD, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshSemiStock

진입점: this.spdMain.CellDoubleClick [if (isEEDivision && _operation_group == "A") ▸ if (_curr_measure_name.ToUpper().Equals("BALANCE") && (e.Column == siMain.GetColumnIndex(DefColumns.BOH)))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcd0bed4 | this.spdMain.CellDoubleClick [if (isEEDivision && _operation… | SCP0103_MaterialVisibility.cs:2278 |  | DATA_OP | DBUtils.Filter | (this._tblSemiStockAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0aaa8dc3 | this.spdMain.CellDoubleClick [if (isEEDivision && _operation… | SCP0103_MaterialVisibility.cs:2280 |  | FLAG | this._tblSemiStockFiltered | DBUtils.SelectColumns(tbl1, _semiStockColNames) | 화면 필드/플래그 변경 |  |  |  |
| AC-da0fa15e | this.spdMain.CellDoubleClick [if (isEEDivision && _operation… | SCP0103_MaterialVisibility.cs:2280 |  | CALL_EXT | DBUtils.SelectColumns | (tbl1, _semiStockColNames) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0103_MaterialVisibility.RefreshSupplier

진입점: this.Load [try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboSCPPlanStartYYYYMMDD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a7f7f89 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 2 | SCP0103_MaterialVisibility.cs:1450 |  | FLAG | dtSupplier | GetFilteredTable(dtSupplierAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f8536a04 | this.Load [try ▸ if (cboDivision.ControlValues != null && !c… 외 2 | SCP0103_MaterialVisibility.cs:1452 |  | LIST_REBIND | clsCtrl.setListBox | (dtSupplier, clbSupplier, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0103_MaterialVisibility.RefreshUOM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-596494be | (진입점 미연결) | SCP0103_MaterialVisibility.cs:773 | if ((this._division == "EE") && (this._operation_group == "E")) ▸ for (i <= clbUOM.Items.Count - 1) ▸ if (clbUOM.Items[i].ToString() == "M") | CALL_EXT | clbUOM.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-64ccdd6a | (진입점 미연결) | SCP0103_MaterialVisibility.cs:777 | if ((this._division == "EE") && (this._operation_group == "E")) ▸ for (i <= clbUOM.Items.Count - 1) ▸ else of (clbUOM.Items[i].ToString() ==… | CALL_EXT | clbUOM.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e25cfab7 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:781 | if ((this._division == "EE") && (this._operation_group == "E")) | UI_PROP | lciUOM.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9dee4558 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:790 | else of ((this._division == "EE") && (this._operation_group == "E")) ▸ for (i <= clbUOM.Items.Count - 1) ▸ if (clbUOM.Items[i].ToString() ==… | CALL_EXT | clbUOM.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b169e1f | (진입점 미연결) | SCP0103_MaterialVisibility.cs:794 | else of ((this._division == "EE") && (this._operation_group == "E")) ▸ for (i <= clbUOM.Items.Count - 1) ▸ else of (clbUOM.Items[i].ToString… | CALL_EXT | clbUOM.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb077dda | (진입점 미연결) | SCP0103_MaterialVisibility.cs:798 | else of ((this._division == "EE") && (this._operation_group == "E")) | UI_PROP | lciUOM.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0103_MaterialVisibility.RrefreshProgressInitData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca65f274 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:609 |  | CALL_EXT | Task.Run | (() => { if (frm.InvokeRequired) { frm.Invoke(new System.Action(() => frm.Refresh())); } e… | ⚠ 의미 확인 필요 |  |  |  |
| AC-92a3c25a | (진입점 미연결) | SCP0103_MaterialVisibility.cs:613 | lambda ▸ if (frm.InvokeRequired) | CALL_EXT | frm.Invoke | (new System.Action(() => frm.Refresh())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72682548 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:613 | lambda ▸ if (frm.InvokeRequired) ▸ lambda | UI_MISC | frm.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-adb695d6 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:617 | lambda ▸ else of (frm.InvokeRequired) | UI_MISC | frm.Refresh | () | 화면 갱신/대기창 |  |  |  |

## SCP0103_MaterialVisibility.Set_FPOperationColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c87e7833 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2452 | for (nCol < siMain.ActiveSheet.Columns.Count) ▸ if (nCol == siMain.ActiveSheet.Columns.Count - 1) | GRID_STYLE | siMain.SetBGColor | (nRow, befCol, nRow, nCol, backColor) | 그리드 표시 설정 |  |  |  |
| AC-2a9795a5 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2458 |  | UI_MISC | this.siMain.SP.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-515e519a | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2484 | finally | UI_MISC | this.siMain.SP.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0103_MaterialVisibility.Set_OnHandEOH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a122cd1 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1671 | if (this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3bd508a | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1684 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-198075c3 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1699 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac4ff26a | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1703 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e8caf29 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1732 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "BALANCE") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Colum… | GRID_SET | dt.Rows[i][nIdxWeek] | objBOH | 그리드 속성/값 설정 |  |  |  |
| AC-d8b405d4 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1742 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "BALANCE") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Colum… | GRID_SET | dt.Rows[i][nIdxMonth] | objBOH | 그리드 속성/값 설정 |  |  |  |
| AC-db4b927b | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1763 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-565b1a9d | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1767 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0103_MaterialVisibility.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f17bda45 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2386 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4e0d5a4d | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2390 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c533ee45 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2393 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79166f51 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2397 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-67b185af | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2398 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0103_MaterialVisibility.SetColumnModelVisible

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d35f04a | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2194 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-21ce65cd | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2195 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-60f15f2e | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2203 | try ▸ switch (this._operation_group) case "A": | GRID_SET | siMain.ActiveSheet.Columns[col].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1b86130c | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2206 | try ▸ switch (this._operation_group) case "P": | GRID_SET | siMain.ActiveSheet.Columns[col].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7a2458ed | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2214 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0103_MaterialVisibility.SetLockSumColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee8d8dba | (진입점 미연결) | SCP0103_MaterialVisibility.cs:1276 | for (iCol <= spreadInfo.GetMaxColumnIndex()) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).Index… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0103_MaterialVisibility.SetQueryInfoGetModel

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7031cb5 | FindButton | SCP0103_MaterialVisibility.cs:1610 | if (this.QueryDics[DIC_SCP0103_FIND].Count > 0) | CALL_EXT | this.QueryDics[DIC_SCP0103_FIND].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-13ee7a8d | FindButton | SCP0103_MaterialVisibility.cs:1615 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.InitSpreadMain | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-18f79095 | FindButton | SCP0103_MaterialVisibility.cs:1616 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindDataModel | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-3ed044b9 | FindButton | SCP0103_MaterialVisibility.cs:1617 |  | UI_PROP | qi.ServiceUri | BLUtils.GSCM_SCP_ANALYSIS_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-be372212 | FindButton | SCP0103_MaterialVisibility.cs:1618 |  | UI_PROP | qi.QueryId | "SCP.SCP0103_GET_MATERIAL_VISIBILITY" | 속성 QueryId 설정 |  |  |  |
| AC-51617235 | FindButton | SCP0103_MaterialVisibility.cs:1622 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bac34ad2 | FindButton | SCP0103_MaterialVisibility.cs:1623 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plnat_id", this._plant)) | 데이터 객체 조작/조회 |  |  |  |
| AC-beb81f8b | FindButton | SCP0103_MaterialVisibility.cs:1624 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_supplier", this._supplier)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7d165e0 | FindButton | SCP0103_MaterialVisibility.cs:1625 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", this._operation_group)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9b47d68 | FindButton | SCP0103_MaterialVisibility.cs:1626 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_category", this._item_category)) | 데이터 객체 조작/조회 |  |  |  |
| AC-500158f3 | FindButton | SCP0103_MaterialVisibility.cs:1627 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7a91425 | FindButton | SCP0103_MaterialVisibility.cs:1628 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nickname", this._nickname)) | 데이터 객체 조작/조회 |  |  |  |
| AC-10dc1e93 | FindButton | SCP0103_MaterialVisibility.cs:1629 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_material", this._material)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3dfc041 | FindButton | SCP0103_MaterialVisibility.cs:1630 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_scp_plan_start_yyyymmdd", this._scp_plan_start_yyyymm… | 데이터 객체 조작/조회 |  |  |  |
| AC-eb16e158 | FindButton | SCP0103_MaterialVisibility.cs:1631 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_mrp_plan_start_yyyymmdd", this._mrp_plan_start_yyyymm… | 데이터 객체 조작/조회 |  |  |  |
| AC-35c6eb44 | FindButton | SCP0103_MaterialVisibility.cs:1632 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymmdd", this._from_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-07159e7c | FindButton | SCP0103_MaterialVisibility.cs:1633 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymmdd", this._to_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-09df5bde | FindButton | SCP0103_MaterialVisibility.cs:1634 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0103")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6228619 | FindButton | SCP0103_MaterialVisibility.cs:1635 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", "ALL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b25c8db5 | FindButton | SCP0103_MaterialVisibility.cs:1636 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4767d947 | FindButton | SCP0103_MaterialVisibility.cs:1637 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-af8be2d4 | FindButton | SCP0103_MaterialVisibility.cs:1641 |  | DATA_OP | this.QueryDics[DIC_SCP0103_FIND] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0103_MaterialVisibility.SetSpreadColumn

진입점: this.Load [try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtAll)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtAll)] / this.cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (spdInfo.SheetName == SpdSheet.shtAll)] / this.cboBucketType.SelectedIndexChanged [if (chkALL.Checked) ▸ if (siMain != null)] / this.chkSum.CheckedChanged [if (fps != null) ▸ if (fps.Name == "spdMain")] / this.chkALL.CheckedChanged / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-139096e7 | this.Load [try] 외 7 | SCP0103_MaterialVisibility.cs:1213 | for (col <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (isDaily \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c9c82357 | this.Load [try] 외 7 | SCP0103_MaterialVisibility.cs:1218 | for (col <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (isMonthly \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-0325ac27 | this.Load [try] 외 7 | SCP0103_MaterialVisibility.cs:1227 | for (col <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ if (isDaily) | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7f9dafef | this.Load [try] 외 7 | SCP0103_MaterialVisibility.cs:1231 | for (col <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ else of (isDaily) ▸ if (isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-89cfda40 | this.Load [try] 외 7 | SCP0103_MaterialVisibility.cs:1236 | for (col <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ if (isMonthly) | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-b8f7b7a6 | this.Load [try] 외 7 | SCP0103_MaterialVisibility.cs:1243 | for (col <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.WeeklyISO: | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | isWeeklyISO | 그리드 속성/값 설정 |  |  |  |
| AC-43488df7 | this.Load [try] 외 7 | SCP0103_MaterialVisibility.cs:1249 | for (col <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Monthly: | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | isMonthly | 그리드 속성/값 설정 |  |  |  |

## SCP0103_MaterialVisibility.SetVisibleMonthlyColumns

진입점: this.cboBucketType.SelectedIndexChanged [else of (chkALL.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17a1073e | this.cboBucketType.SelectedIndexChanged [else of (chkALL.Che… | SCP0103_MaterialVisibility.cs:1154 |  | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0103_MaterialVisibility.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83c7935b | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2556 |  | UI_MISC | tooltip.Hide | (spdMain) | 창 닫기/해제 |  |  |  |
| AC-ce427d1a | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2560 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3bc9d978 | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2563 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf9974ed | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2565 |  | FLAG | this._curr_row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-1578cffc | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2566 |  | FLAG | this._curr_col | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-01efed9c | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2571 | if (!measure.ToUpper().Equals("REQUIREMENT")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-483cece2 | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2574 | if (siMain.GetColumnTag(this._curr_col).IndexOf("M_") != 0 && siMain.GetColumnTag(this._curr_col).IndexOf("W_") != 0 && siMa…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7217c891 | this.spdMain.CellClick | SCP0103_MaterialVisibility.cs:2594 | if (_tblRequirementFiltered.Rows.Count > 0) | POPUP | tooltip.Show | (values, spdMain, 5000) | 팝업/폼 열기 |  |  |  |

## SCP0103_MaterialVisibility.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9262faaf | this.spdMain.CellDoubleClick | SCP0103_MaterialVisibility.cs:2310 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51d8fdac | this.spdMain.CellDoubleClick | SCP0103_MaterialVisibility.cs:2314 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-8f731349 | this.spdMain.CellDoubleClick | SCP0103_MaterialVisibility.cs:2315 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-0b4cbed6 | this.spdMain.CellDoubleClick | SCP0103_MaterialVisibility.cs:2325 | if (isEEDivision && _operation_group == "A") ▸ if (_curr_measure_name.ToUpper().Equals("BALANCE") && (e.Column == siMain.GetColumnIndex(DefC… | POPUP | new SCP0103_SemiStockPopup | (this._tblSemiStockFiltered) | 팝업/폼 생성 |  |  |  |
| AC-576841fe | this.spdMain.CellDoubleClick | SCP0103_MaterialVisibility.cs:2327 | if (isEEDivision && _operation_group == "A") ▸ if (_curr_measure_name.ToUpper().Equals("BALANCE") && (e.Column == siMain.GetColumnIndex(DefC… | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bfd44f32 | this.spdMain.CellDoubleClick | SCP0103_MaterialVisibility.cs:2329 | if (isEEDivision && _operation_group == "A") ▸ if (_curr_measure_name.ToUpper().Equals("BALANCE") && (e.Column == siMain.GetColumnIndex(DefC… | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0103_MaterialVisibility.spdMain_MouseHover

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ff52e90 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2511 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82f27d83 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2514 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9391fc6c | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2516 |  | CALL_EXT | spdMain.PointToClient | (Cursor.Position) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2f72379 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2518 |  | CALL_EXT | spdMain.GetCellFromPixel | (0, 0, pos.X, pos.Y) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70f03baa | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2526 | if (!measure.ToUpper().Equals("REQUIREMENT")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-768f6c5e | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2529 | if (siMain.GetColumnTag(col).IndexOf("M_") != 0 && siMain.GetColumnTag(col).IndexOf("W_") != 0 && siMain.GetColumnTag(col).I…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-791d4403 | (진입점 미연결) | SCP0103_MaterialVisibility.cs:2547 | if (_tblRequirementFiltered.Rows.Count > 0) | POPUP | tooltip.Show | (values, spdMain) | 팝업/폼 열기 |  |  |  |

## SCP0103_MaterialVisibility.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0c21f0f | this.spdMain.TopChange | SCP0103_MaterialVisibility.cs:1032 |  | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0103_SemiStockPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6da9ca5f | .ctor | SCP0103_SemiStockPopup.cs:119 |  | FLAG | _tblSemiStock | tblSemiStock.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-dc3003dd | .ctor | SCP0103_SemiStockPopup.cs:119 |  | DATA_OP | tblSemiStock.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0103_SemiStockPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-166d0a8c | this.btnButtonList.UsrButtonList_Click_Detected | SCP0103_SemiStockPopup.cs:190 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0103_SemiStockPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4064ad0 | this.Load | SCP0103_SemiStockPopup.cs:157 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ec774e13 | this.Load | SCP0103_SemiStockPopup.cs:158 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-53467de1 | this.Load | SCP0103_SemiStockPopup.cs:159 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eab840fb | this.Load | SCP0103_SemiStockPopup.cs:164 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0103_SemiStockPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c45eae3 | this.Load | SCP0103_SemiStockPopup.cs:152 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0103_SemiStockPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e183ac37 | Dispose | SCP0103_SemiStockPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0103_SemiStockPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a846187f | this.Load | SCP0103_SemiStockPopup.cs:134 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0f6fe0d | this.Load | SCP0103_SemiStockPopup.cs:135 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0103_SemiStockPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1a550d8 | this.Load | SCP0103_SemiStockPopup.cs:169 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-17c79062 | this.Load | SCP0103_SemiStockPopup.cs:171 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-99c89866 | this.Load | SCP0103_SemiStockPopup.cs:173 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.PLANT_ID, DefColumns.PLANT_ID, FPMerge.None, 150, true , FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ea4dfe0 | this.Load | SCP0103_SemiStockPopup.cs:174 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.MATERIAL, DefColumns.MATERIAL, FPMerge.None, 150, true , FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff0f7abc | this.Load | SCP0103_SemiStockPopup.cs:175 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.MATERIAL_UOM, DefColumns.MATERIAL_UOM, FPMerge.None, 40, true , FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb3412fc | this.Load | SCP0103_SemiStockPopup.cs:176 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ITEM_ID, DefColumns.ITEM_ID, FPMerge.None, 150, true , FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7cc202f4 | this.Load | SCP0103_SemiStockPopup.cs:177 |  | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabel.QTY, DefColumns.QTY, FPMerge.None, 100, true, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb7890a5 | this.Load | SCP0103_SemiStockPopup.cs:178 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.UOM, DefColumns.UOM, FPMerge.None, 40, true , FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-393b7f52 | this.Load | SCP0103_SemiStockPopup.cs:179 |  | CALL_EXT | siMain.AddNumColumnEx | (DefColumnsLabel.CELL_CF, DefColumns.CELL_CF, FPMerge.None, 100, true, true, 4) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1669036b | this.Load | SCP0103_SemiStockPopup.cs:180 |  | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabel.STOCK, DefColumns.STOCK, FPMerge.None, 100, true, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0103_SemiStockPopup.RefreshSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-330764ca | this.Load | SCP0103_SemiStockPopup.cs:126 |  | DATA_OP | ds.Tables.Add | (_tblSemiStock) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2dea622 | this.Load | SCP0103_SemiStockPopup.cs:128 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c332e983 | this.Load | SCP0103_SemiStockPopup.cs:129 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

