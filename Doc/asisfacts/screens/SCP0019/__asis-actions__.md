# AS-IS 액션 대조표 — SCP0019

> 원천: `Doc/asisfacts/screens/SCP0019/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 214행 · 메서드 33 · 종류 DATA_OP 65 · RETURN 24 · GRID_SET 17 · GRID_INIT 15 · UI_MISC 11 · ENDPOINT 11 · CALL_EXT 10 · UI_PROP 10 · MESSAGE 9 · LIST_REBIND 8 · FLAG 8 · VALUE_SET 5 · GRID_LOCK 5 · POPUP 4 · VALIDATE 3 · STATE 2 · GRID_STYLE 2 · FOCUS 1 · VALUE_CLEAR 1 · STATE_RESET 1 · GRID_BIND 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 10


## SCP0019_WorkingTime.BtnInput_Click

진입점: btnInput.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36c0a08c | btnInput.Click | SCP0019_WorkingTime.cs:1220 |  | CALL_EXT | siMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e4ca4dc | btnInput.Click | SCP0019_WorkingTime.cs:1223 | if (siMain.ActiveSheet.Columns.Get(0).Visible == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00135", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd0eff62 | btnInput.Click | SCP0019_WorkingTime.cs:1224 | if (siMain.ActiveSheet.Columns.Get(0).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe9de3ce | btnInput.Click | SCP0019_WorkingTime.cs:1228 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2888d5d2 | btnInput.Click | SCP0019_WorkingTime.cs:1237 | if (pDayWeekCode == "SelectDay") ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d9394ad7 | btnInput.Click | SCP0019_WorkingTime.cs:1238 | if (pDayWeekCode == "SelectDay") ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-161863c4 | btnInput.Click | SCP0019_WorkingTime.cs:1243 | if (string.IsNullOrEmpty(pDayWeekCode)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6cbdd4f | btnInput.Click | SCP0019_WorkingTime.cs:1253 | catch ((FormatException fe)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { strValue }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4322c4e | btnInput.Click | SCP0019_WorkingTime.cs:1254 | catch ((FormatException fe)) | FOCUS | txtInpuValue.Focus | () | 포커스 이동 |  |  |  |
| AC-2e649585 | btnInput.Click | SCP0019_WorkingTime.cs:1255 | catch ((FormatException fe)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8339c02 | btnInput.Click | SCP0019_WorkingTime.cs:1259 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97a42a63 | btnInput.Click | SCP0019_WorkingTime.cs:1269 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60f47abc | btnInput.Click | SCP0019_WorkingTime.cs:1281 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) | CALL_EXT | spdMain.ActiveSheet.GetModelColumnFromViewColumn | (row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7685cddd | btnInput.Click | SCP0019_WorkingTime.cs:1282 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) | CALL_EXT | spdMain.ActiveSheet.GetModelColumnFromViewColumn | (col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44f0f2f5 | btnInput.Click | SCP0019_WorkingTime.cs:1291 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ if (row >= 0 && col < 0) ▸ for (i < row + rowCnt) ▸ for (j < siMa… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-70ee97ce | btnInput.Click | SCP0019_WorkingTime.cs:1305 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && col < 0) ▸ if (row < 0 && col >= 0) ▸ for (i… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-c426a559 | btnInput.Click | SCP0019_WorkingTime.cs:1319 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && col < 0) ▸ else of (row < 0 && col >= 0) ▸ i… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-c41d97a5 | btnInput.Click | SCP0019_WorkingTime.cs:1341 | else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (siMain.Ac… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-42abb884 | btnInput.Click | SCP0019_WorkingTime.cs:1349 | else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (siMain.Ac… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-5cfbb0ac | btnInput.Click | SCP0019_WorkingTime.cs:1361 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0019_WorkingTime.CalculateBindingDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d498214 | (진입점 미연결) | SCP0019_WorkingTime.cs:994 | if (dsResult.Tables.Count > 0) ▸ if (! (dt.Rows.Count > 0)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-adc2ab81 | (진입점 미연결) | SCP0019_WorkingTime.cs:997 | else of (dsResult.Tables.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0019_WorkingTime.CalculateSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6821726 | (진입점 미연결) | SCP0019_WorkingTime.cs:1018 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-625d2bde | (진입점 미연결) | SCP0019_WorkingTime.cs:1022 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ada7291 | (진입점 미연결) | SCP0019_WorkingTime.cs:1056 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count-1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (weekSum != 0) | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-43549d98 | (진입점 미연결) | SCP0019_WorkingTime.cs:1067 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (monthSum != 0) | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-0f19e862 | (진입점 미연결) | SCP0019_WorkingTime.cs:1088 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-eeb8fe1e | (진입점 미연결) | SCP0019_WorkingTime.cs:1092 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-37053c58 | (진입점 미연결) | SCP0019_WorkingTime.cs:1134 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9aa5f81e | (진입점 미연결) | SCP0019_WorkingTime.cs:1137 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-8a7cead2 | (진입점 미연결) | SCP0019_WorkingTime.cs:1150 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-77828d8f | (진입점 미연결) | SCP0019_WorkingTime.cs:1153 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |

## SCP0019_WorkingTime.CboDayWeek_SelectedIndexChanged

진입점: cboDayWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85213bc3 | cboDayWeek.SelectedIndexChanged | SCP0019_WorkingTime.cs:1210 | if (string.IsNullOrEmpty(pDayWeek)) | STATE | txtInpuValue.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2b14a220 | cboDayWeek.SelectedIndexChanged | SCP0019_WorkingTime.cs:1213 | else of (string.IsNullOrEmpty(pDayWeek)) | STATE | txtInpuValue.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-24e37c40 | cboDayWeek.SelectedIndexChanged | SCP0019_WorkingTime.cs:1216 |  | VALUE_CLEAR | txtInpuValue.Text | "" | 컨트롤 값 비움 |  |  |  |

## SCP0019_WorkingTime.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-320068bd | (진입점 미연결) | SCP0019_WorkingTime.cs:187 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ce77f317 | (진입점 미연결) | SCP0019_WorkingTime.cs:188 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0019_WorkingTime.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6506f192 | this.Load | SCP0019_WorkingTime.cs:229 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c037cb9f | this.Load | SCP0019_WorkingTime.cs:230 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1dadd06 | this.Load | SCP0019_WorkingTime.cs:236 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0019_WorkingTime.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75b5a1ca | this.Load | SCP0019_WorkingTime.cs:176 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-7798104c | this.Load | SCP0019_WorkingTime.cs:177 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-23680ad2 | this.Load | SCP0019_WorkingTime.cs:178 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0019_WorkingTime.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e41616b | Dispose | SCP0019_WorkingTime.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0019_WorkingTime.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7403421 | EditButton | SCP0019_WorkingTime.cs:430 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b621016 | EditButton | SCP0019_WorkingTime.cs:431 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-2f2eba82 | EditButton | SCP0019_WorkingTime.cs:434 | if (fps != null) ▸ if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-84e0550e | EditButton | SCP0019_WorkingTime.cs:435 | if (fps != null) ▸ if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-319383ae | EditButton | SCP0019_WorkingTime.cs:436 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-436fb307 | EditButton | SCP0019_WorkingTime.cs:442 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.LINE_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1683cd19 | EditButton | SCP0019_WorkingTime.cs:443 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_INPUT_DATE), siMain.GetColumnIndex(DefColumns.OSP_Y… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0019_WorkingTime.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20ef6971 | FindButton 외 1 | SCP0019_WorkingTime.cs:674 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7a2dc672 | FindButton 외 1 | SCP0019_WorkingTime.cs:678 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-0ddc4ca3 | FindButton 외 1 | SCP0019_WorkingTime.cs:678 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70c3c03b | FindButton 외 1 | SCP0019_WorkingTime.cs:679 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bdc070af | FindButton 외 1 | SCP0019_WorkingTime.cs:707 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2be216b8 | FindButton 외 1 | SCP0019_WorkingTime.cs:709 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_MASTER… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5747e5f2 | FindButton 외 1 | SCP0019_WorkingTime.cs:713 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0019_GET_WORKING_TIME") ⇒ SCP.SCP0019_GET_WORKING_TIME | 엔드포인트 요청 생성 |  |  |  |
| AC-e346e554 | FindButton 외 1 | SCP0019_WorkingTime.cs:714 | try ▸ lambda | UI_PROP | req.CommandTimeout | 60 * 10 | 속성 CommandTimeout 설정 |  |  |  |
| AC-99869c07 | FindButton 외 1 | SCP0019_WorkingTime.cs:715 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d2ebebd | FindButton 외 1 | SCP0019_WorkingTime.cs:716 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6ebd7df4 | FindButton 외 1 | SCP0019_WorkingTime.cs:717 | try ▸ lambda | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-3a3ae7f3 | FindButton 외 1 | SCP0019_WorkingTime.cs:718 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-5d320b9d | FindButton 외 1 | SCP0019_WorkingTime.cs:719 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-d8346802 | FindButton 외 1 | SCP0019_WorkingTime.cs:720 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0d553a6f | FindButton 외 1 | SCP0019_WorkingTime.cs:721 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-383849e2 | FindButton 외 1 | SCP0019_WorkingTime.cs:722 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-3266e178 | FindButton 외 1 | SCP0019_WorkingTime.cs:723 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-65952cf7 | FindButton 외 1 | SCP0019_WorkingTime.cs:724 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9e0c6131 | FindButton 외 1 | SCP0019_WorkingTime.cs:739 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-78cc1b4b | FindButton 외 1 | SCP0019_WorkingTime.cs:741 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d05dc74 | FindButton 외 1 | SCP0019_WorkingTime.cs:743 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ea4cfc62 | FindButton 외 1 | SCP0019_WorkingTime.cs:746 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c282296 | FindButton 외 1 | SCP0019_WorkingTime.cs:761 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a0701544 | FindButton 외 1 | SCP0019_WorkingTime.cs:769 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e9d2c5a | FindButton 외 1 | SCP0019_WorkingTime.cs:773 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0019_WorkingTime.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-829fa2dd | this.Load | SCP0019_WorkingTime.cs:161 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0019_WorkingTime.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-115f1740 | this.Load | SCP0019_WorkingTime.cs:574 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-700e84a6 | this.Load | SCP0019_WorkingTime.cs:575 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a9a497a1 | this.Load | SCP0019_WorkingTime.cs:578 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0019_WorkingTime.GetDayOfWeek

진입점: btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (siMain.ActiveSheet.Columns[j].Tag.ToString().IndexOf("D_") == 0) ▸ else of (pDayWeekCode == "EveryDay")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea02930c | btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for … | SCP0019_WorkingTime.cs:1368 |  | DATA_OP | dt.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-75eb4885 | btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for … | SCP0019_WorkingTime.cs:1368 | lambda | DATA_OP | row.Field | ("COLUMN_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f3c28ce | btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for … | SCP0019_WorkingTime.cs:1370 |  | RETURN | return returnDay; |  | 처리 중단/반환 |  |  |  |

## SCP0019_WorkingTime.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cddc130 | this.Load | SCP0019_WorkingTime.cs:1520 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3bd94897 | this.Load | SCP0019_WorkingTime.cs:1522 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0019_WorkingTime.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8136ce1 | (진입점 미연결) | SCP0019_WorkingTime.cs:1456 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-2a8b27cf | (진입점 미연결) | SCP0019_WorkingTime.cs:1457 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-702b482f | (진입점 미연결) | SCP0019_WorkingTime.cs:1460 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0019_WorkingTime.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c69950ba | (진입점 미연결) | SCP0019_WorkingTime.cs:1482 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0019_WorkingTime.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36d30497 | (진입점 미연결) | SCP0019_WorkingTime.cs:1477 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0019_WorkingTime.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e47a14ad | (진입점 미연결) | SCP0019_WorkingTime.cs:1487 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0019_WorkingTime.GetSpdTitle

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cc6a7f4 | this.Load 외 2 | SCP0019_WorkingTime.cs:1494 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-b8435165 | this.Load 외 2 | SCP0019_WorkingTime.cs:1499 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-351198f1 | this.Load 외 2 | SCP0019_WorkingTime.cs:1500 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-9afc7550 | this.Load 외 2 | SCP0019_WorkingTime.cs:1502 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-74d6ed4f | this.Load 외 2 | SCP0019_WorkingTime.cs:1502 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0019_WorkingTime.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e18a904a | this.Load | SCP0019_WorkingTime.cs:195 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-d9fd77ef | this.Load | SCP0019_WorkingTime.cs:197 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d407f43d | this.Load | SCP0019_WorkingTime.cs:204 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1a52a871 | this.Load | SCP0019_WorkingTime.cs:216 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-578ff068 | this.Load | SCP0019_WorkingTime.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-27b94671 | this.Load | SCP0019_WorkingTime.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtDayWeek, cboDayWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-59386196 | this.Load | SCP0019_WorkingTime.cs:222 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0019_WorkingTime.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a28f7816 | this.Load 외 2 | SCP0019_WorkingTime.cs:248 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-59905327 | this.Load 외 2 | SCP0019_WorkingTime.cs:283 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-ae9278f5 | this.Load 외 2 | SCP0019_WorkingTime.cs:290 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.WORKING_TIME_DEFAULT), 0, 2, 7) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ce88b65c | this.Load 외 2 | SCP0019_WorkingTime.cs:292 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0019_WorkingTime.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87bf9772 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0019_WorkingTime.cs:336 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cb180dd | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0019_WorkingTime.cs:337 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(sColumnName), 0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2f86c329 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0019_WorkingTime.cs:340 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-821849ba | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0019_WorkingTime.cs:347 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbb4b30d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0019_WorkingTime.cs:353 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c43507c8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0019_WorkingTime.cs:363 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName && i… | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11d331bc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0019_WorkingTime.cs:374 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3866964b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0019_WorkingTime.cs:376 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0019_WorkingTime.RefreshBuilding

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb7c1a3c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0019_WorkingTime.cs:605 |  | FLAG | dtBuilding | DBUtils.Filter(dtBuildingAll, "DIVISION_ID ='" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-a314c25b | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0019_WorkingTime.cs:605 |  | DATA_OP | DBUtils.Filter | (dtBuildingAll, "DIVISION_ID ='" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-33be885c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0019_WorkingTime.cs:607 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuilding, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0019_WorkingTime.RefreshLine

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / clbPlantSite.SelectedIndexChanged / clbBuilding.SelectedIndexChanged / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f668026d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 4 | SCP0019_WorkingTime.cs:653 |  | FLAG | dtLine | DBUtils.Filter(dtLineAll, "DIVISION_ID = '" + division + "'" + filterBuilding + filterOper… | 화면 필드/플래그 변경 |  |  |  |
| AC-6c89c0dc | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 4 | SCP0019_WorkingTime.cs:653 |  | DATA_OP | DBUtils.Filter | (dtLineAll, "DIVISION_ID = '" + division + "'" + filterBuilding + filterOperation + filter… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4ea5ef54 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 4 | SCP0019_WorkingTime.cs:655 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0019_WorkingTime.RefreshOperation

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / clbPlantSite.SelectedIndexChanged / clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-818614ee | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0019_WorkingTime.cs:612 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0019_WorkingTime.RefreshPlantSiteByDivision

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3061b6fe | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0019_WorkingTime.cs:596 |  | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID ='" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c5f6bce3 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0019_WorkingTime.cs:596 |  | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID ='" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-bb07ee57 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0019_WorkingTime.cs:598 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0019_WorkingTime.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07c8fa2d | SaveButton | SCP0019_WorkingTime.cs:781 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9857f58e | SaveButton | SCP0019_WorkingTime.cs:789 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e289d56 | SaveButton | SCP0019_WorkingTime.cs:791 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bccd195d | SaveButton | SCP0019_WorkingTime.cs:794 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-5d8586e4 | SaveButton | SCP0019_WorkingTime.cs:794 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-59b28566 | SaveButton | SCP0019_WorkingTime.cs:801 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3200306c | SaveButton | SCP0019_WorkingTime.cs:802 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7099fe0 | SaveButton | SCP0019_WorkingTime.cs:803 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d76f7c4 | SaveButton | SCP0019_WorkingTime.cs:804 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plant_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-c13780ba | SaveButton | SCP0019_WorkingTime.cs:805 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_factory_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-9767f1a2 | SaveButton | SCP0019_WorkingTime.cs:806 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-4af1ea77 | SaveButton | SCP0019_WorkingTime.cs:807 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d436b177 | SaveButton | SCP0019_WorkingTime.cs:808 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-3447b8fa | SaveButton | SCP0019_WorkingTime.cs:809 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_working_time") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2c39ed3 | SaveButton | SCP0019_WorkingTime.cs:810 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-16ff6009 | SaveButton | SCP0019_WorkingTime.cs:811 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-2aa22511 | SaveButton | SCP0019_WorkingTime.cs:812 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-01c4fb80 | SaveButton | SCP0019_WorkingTime.cs:813 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_is_save_defalut") | 데이터 객체 조작/조회 |  |  |  |
| AC-53db56f9 | SaveButton | SCP0019_WorkingTime.cs:814 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_working_time_default") | 데이터 객체 조작/조회 |  |  |  |
| AC-f01e5f6e | SaveButton | SCP0019_WorkingTime.cs:815 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-12e1cdad | SaveButton | SCP0019_WorkingTime.cs:816 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6c16af0 | SaveButton | SCP0019_WorkingTime.cs:837 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-10c5d798 | SaveButton | SCP0019_WorkingTime.cs:843 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-38dd6177 | SaveButton | SCP0019_WorkingTime.cs:844 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-812c7599 | SaveButton | SCP0019_WorkingTime.cs:845 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cbaea284 | SaveButton | SCP0019_WorkingTime.cs:846 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plant_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-422d2199 | SaveButton | SCP0019_WorkingTime.cs:847 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_factory_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c5f1012 | SaveButton | SCP0019_WorkingTime.cs:848 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6691ae26 | SaveButton | SCP0019_WorkingTime.cs:849 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_line_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LINE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3c826547 | SaveButton | SCP0019_WorkingTime.cs:852 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-07323586 | SaveButton | SCP0019_WorkingTime.cs:853 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-71da0caf | SaveButton | SCP0019_WorkingTime.cs:854 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_loc_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b488c7e6 | SaveButton | SCP0019_WorkingTime.cs:861 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0ff4fd2c | SaveButton | SCP0019_WorkingTime.cs:862 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_working_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3732869d | SaveButton | SCP0019_WorkingTime.cs:863 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_is_save_defalut"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-84ae0ebc | SaveButton | SCP0019_WorkingTime.cs:864 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_working_time_default"] | workingTimeDefault | 행/컬럼 값 대입 |  |  |  |
| AC-b6cabbb0 | SaveButton | SCP0019_WorkingTime.cs:869 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | strDayName | 행/컬럼 값 대입 |  |  |  |
| AC-757e926b | SaveButton | SCP0019_WorkingTime.cs:870 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_working_time"] | strDayQty | 행/컬럼 값 대입 |  |  |  |
| AC-692b1669 | SaveButton | SCP0019_WorkingTime.cs:871 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_is_save_defalut"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-fe143f78 | SaveButton | SCP0019_WorkingTime.cs:872 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_working_time_default"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-69927ffe | SaveButton | SCP0019_WorkingTime.cs:874 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-aa7bfdd4 | SaveButton | SCP0019_WorkingTime.cs:875 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf81cd13 | SaveButton | SCP0019_WorkingTime.cs:883 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e8d69d13 | SaveButton | SCP0019_WorkingTime.cs:884 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-f53b7519 | SaveButton | SCP0019_WorkingTime.cs:885 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { "0","7.0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0f51f4a9 | SaveButton | SCP0019_WorkingTime.cs:886 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49a92ce1 | SaveButton | SCP0019_WorkingTime.cs:892 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dd04ea33 | SaveButton | SCP0019_WorkingTime.cs:893 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-f5b967ac | SaveButton | SCP0019_WorkingTime.cs:894 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { "0", "1440" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-013c7b5d | SaveButton | SCP0019_WorkingTime.cs:895 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-496de826 | SaveButton | SCP0019_WorkingTime.cs:906 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | dsInput.Tables[0].Rows[0]["p_loc_flag"] | "F" | 그리드 속성/값 설정 |  |  |  |
| AC-1a7b8dd8 | SaveButton | SCP0019_WorkingTime.cs:907 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | dsInput.Tables[0].Rows[nRowCnt - 1]["p_loc_flag"] | "L" | 그리드 속성/값 설정 |  |  |  |
| AC-3ec3b67a | SaveButton | SCP0019_WorkingTime.cs:909 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-634ecca2 | SaveButton | SCP0019_WorkingTime.cs:923 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f5f8a8a | SaveButton | SCP0019_WorkingTime.cs:924 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-052a6ec3 | SaveButton | SCP0019_WorkingTime.cs:925 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cb0bb5f4 | SaveButton | SCP0019_WorkingTime.cs:929 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.InsertQueryId | "SCP.SCP0019_SAVE_WORKING_TIME_ROW" | 속성 InsertQueryId 설정 |  |  |  |
| AC-19dba7ea | SaveButton | SCP0019_WorkingTime.cs:930 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.DeleteQueryId | "SCP.SCP0019_SAVE_WORKING_TIME_ROW" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-62ae6a9b | SaveButton | SCP0019_WorkingTime.cs:931 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.UpdateQueryId | "SCP.SCP0019_SAVE_WORKING_TIME_ROW" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-f1880cce | SaveButton | SCP0019_WorkingTime.cs:932 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.DataSet | dsInput.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-8f683bfd | SaveButton | SCP0019_WorkingTime.cs:932 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | dsInput.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d686304 | SaveButton | SCP0019_WorkingTime.cs:935 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-13919a34 | SaveButton | SCP0019_WorkingTime.cs:936 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_MASTER… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d68ecd9 | SaveButton | SCP0019_WorkingTime.cs:941 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-286bd2b8 | SaveButton | SCP0019_WorkingTime.cs:941 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-00c35165 | SaveButton | SCP0019_WorkingTime.cs:944 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-716fc35e | SaveButton | SCP0019_WorkingTime.cs:949 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0f177539 | SaveButton | SCP0019_WorkingTime.cs:961 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53cc3994 | SaveButton | SCP0019_WorkingTime.cs:965 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9cac30f3 | SaveButton | SCP0019_WorkingTime.cs:978 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a4db4491 | SaveButton | SCP0019_WorkingTime.cs:982 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-28dd18af | SaveButton | SCP0019_WorkingTime.cs:984 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0019_WorkingTime.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c49c5b2d | (진입점 미연결) | SCP0019_WorkingTime.cs:1464 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8b2a0e33 | (진입점 미연결) | SCP0019_WorkingTime.cs:1467 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2de2c146 | (진입점 미연결) | SCP0019_WorkingTime.cs:1470 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-edefeef1 | (진입점 미연결) | SCP0019_WorkingTime.cs:1471 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0019_WorkingTime.SetLockSumColumn

진입점: EditButton [if (fps != null) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5ab5438 | EditButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0019_WorkingTime.cs:587 | for (iCol <= spreadInfo.GetMaxColumnIndex()) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).Index… | GRID_LOCK | spreadInfo.LockColumn | (iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0019_WorkingTime.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / cboBucketType.SelectedIndexChanged [if (fps != null) ▸ if (fps.Name == "spdMain")] / chkSum.CheckedChanged [if (fps != null) ▸ if (fps.Name == "spdMain")] / FindButton [try ▸ if (siMain.GetMaxRowIndex() > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d647e88 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0019_WorkingTime.cs:522 |  | VALUE_SET | chkSum.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-f8016643 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0019_WorkingTime.cs:530 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-14e32e2b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0019_WorkingTime.cs:535 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-2a82ef1a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0019_WorkingTime.cs:542 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dc06d93a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0019_WorkingTime.cs:546 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-bdf4ab7f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0019_WorkingTime.cs:551 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-3c8b4b41 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0019_WorkingTime.cs:558 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-708a5bc3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0019_WorkingTime.cs:562 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0019_WorkingTime.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0daf7322 | spdMain.CellDoubleClick | SCP0019_WorkingTime.cs:1376 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0019_WorkingTime.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57fa6b67 | spdMain.TopChange | SCP0019_WorkingTime.cs:403 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0019_WorkingTime.UnLockOnlyOSP

진입점: EditButton [if (fps != null) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b4b5b70 | EditButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0019_WorkingTime.cs:468 | try ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (sTemp.ToUpper() != "Y") | GRID_SET | siMain.ActiveSheet.Rows[iRow].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-0c5aaa42 | EditButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0019_WorkingTime.cs:469 | try ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (sTemp.ToUpper() != "Y") | GRID_SET | siMain.ActiveSheet.Rows[iRow].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |

