# AS-IS 액션 대조표 — FPC0105

> 원천: `Doc/asisfacts/screens/FPC0105/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 115행 · 메서드 13 · 종류 DATA_OP 53 · GRID_INIT 22 · FLAG 8 · GRID_SET 8 · UI_PROP 6 · ENDPOINT 4 · MESSAGE 4 · UI_MISC 3 · GRID_STYLE 2 · RETURN 2 · GRID_BIND 1 · CALL_EXT 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 2


## FPC0105_ReportConfig_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ee68d76 | .ctor | FPC0105_ReportConfig_Popup.cs:56 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-47cd5633 | .ctor | FPC0105_ReportConfig_Popup.cs:57 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-f6db0126 | .ctor | FPC0105_ReportConfig_Popup.cs:58 |  | FLAG | _sColumnSetType | "C" | 화면 필드/플래그 변경 |  |  |  |

## FPC0105_ReportConfig_Popup.ColumnSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b6c7c2c | this.Load | FPC0105_ReportConfig_Popup.cs:70 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e4b9e74e | this.Load | FPC0105_ReportConfig_Popup.cs:95 | foreach (DataRow row in _dtColumnSet.Rows) ▸ if (row["USER_FLAG"].ToString() == "Y") | DATA_OP | row["USER_FLAG"] | "True" | 행/컬럼 값 대입 |  |  |  |
| AC-a3479ea8 | this.Load | FPC0105_ReportConfig_Popup.cs:97 | foreach (DataRow row in _dtColumnSet.Rows) ▸ else of (row["USER_FLAG"].ToString() == "Y") | DATA_OP | row["USER_FLAG"] | "False" | 행/컬럼 값 대입 |  |  |  |
| AC-fa0eb6bd | this.Load | FPC0105_ReportConfig_Popup.cs:115 | foreach (DataRow row in _dtColumnSet.Rows) ▸ if (order_no == 0) | DATA_OP | row["USER_SORT_ORDER_NO"] | string.Format("{0}", max_order++) | 행/컬럼 값 대입 |  |  |  |
| AC-b89a803a | this.Load | FPC0105_ReportConfig_Popup.cs:117 |  | UI_PROP | _dtColumnSet.DefaultView.Sort | "USER_SORT_ORDER_NO ASC" | 속성 Sort 설정 |  |  |  |
| AC-7b40680c | this.Load | FPC0105_ReportConfig_Popup.cs:118 |  | DATA_OP | _dtColumnSet.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-29147755 | this.Load | FPC0105_ReportConfig_Popup.cs:120 |  | GRID_BIND | si.Query | (_dtColumnSet, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-dbd45e57 | this.Load | FPC0105_ReportConfig_Popup.cs:124 |  | GRID_SET | spdDimension.Sheets[0].Columns[spdDimension.Sheets[0].Columns["USER_FLAG"].Index].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-1664eca8 | this.Load | FPC0105_ReportConfig_Popup.cs:125 |  | GRID_SET | spdDimension.Sheets[0].Columns[spdDimension.Sheets[0].Columns["USER_FLAG"].Index].BackColo… | ControlColor.UnLockColor | 그리드 속성/값 설정 |  |  |  |
| AC-9acba3f7 | this.Load | FPC0105_ReportConfig_Popup.cs:133 | foreach (FarPoint.Win.Spread.Row row in spdDimension.Sheets[0].Rows) ▸ if (src_row["USER_SELECTABLE_FLAG"].ToString() == "N") | GRID_SET | spdDimension.Sheets[0].Cells[idx, spdDimension.Sheets[0].Columns["USER_FLAG"].Index].Locke… | true | 그리드 속성/값 설정 |  |  |  |
| AC-654ae609 | this.Load | FPC0105_ReportConfig_Popup.cs:134 | foreach (FarPoint.Win.Spread.Row row in spdDimension.Sheets[0].Rows) ▸ if (src_row["USER_SELECTABLE_FLAG"].ToString() == "N") | GRID_SET | spdDimension.Sheets[0].Cells[idx, spdDimension.Sheets[0].Columns["USER_FLAG"].Index].BackC… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-6f16605d | this.Load | FPC0105_ReportConfig_Popup.cs:139 |  | GRID_INIT | this.AddSheet | (spdSample, "Sample", "Sample", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ccbf84ce | this.Load | FPC0105_ReportConfig_Popup.cs:141 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-bcffb1a2 | this.Load | FPC0105_ReportConfig_Popup.cs:143 |  | CALL_EXT | si.GetSpdTitle | (_sProgramID, UserInfoContext.Current.UserId, _sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c076f347 | this.Load | FPC0105_ReportConfig_Popup.cs:144 |  | GRID_INIT | si.SetSheetHeaderColumn_FP | (dtSheetColumnConfig) | 그리드 재구성/초기화 |  |  |  |
| AC-7aee762c | this.Load | FPC0105_ReportConfig_Popup.cs:145 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0105_ReportConfig_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98f046b0 | Dispose | FPC0105_ReportConfig_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0105_ReportConfig_Popup.DoDimensionChange

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Confirm:] / this.spdDimension.RowDragMoveCompleted / ((CheckBoxCellType)(si.ActiveSheet.Columns[0, 0].CellType)).EditorValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-395eeaa0 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:416 | if (lastrow == 0 && lastcol == 0) | GRID_STYLE | spdDimension.ActiveSheet.SetActiveCell | (1, 0) | 그리드 표시 설정 |  |  |  |
| AC-1b3d3162 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:420 | else of (lastrow == 0 && lastcol == 0) | GRID_STYLE | spdDimension.ActiveSheet.SetActiveCell | (lastrow - 1, -1) | 그리드 표시 설정 |  |  |  |
| AC-bf4232d9 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:423 |  | DATA_OP | _dtColumnSet.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-36f610e4 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:424 |  | DATA_OP | _dtColumnSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0f029f43 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:437 | try ▸ for (i < sv.RowCount) | DATA_OP | sample.Select | ("COLUMN_NAME='" + colname+"'") | 데이터 객체 조작/조회 |  |  |  |
| AC-70dfc18c | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:442 | try ▸ for (i < sv.RowCount) ▸ if (colRow !=null) | DATA_OP | colRow["USER_SORT_ORDER_NO"] | string.Format("{0}", i) | 행/컬럼 값 대입 |  |  |  |
| AC-c33fe81d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:443 | try ▸ for (i < sv.RowCount) ▸ if (colRow !=null) | DATA_OP | colRow["SORT_ORDER_NO"] | string.Format("{0}", i) | 행/컬럼 값 대입 |  |  |  |
| AC-8b33e734 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:457 |  | DATA_OP | sample.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5be45231 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:464 | foreach (DataRow row in sample.Rows) ▸ if (row["USER_FLAG"].ToString() == "True" \|\| row["USER_FLAG"].ToString() == "Y") | DATA_OP | row["VISIBLE_FLAG"] | row["VALID_YN"] = "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-8b45d31d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:464 | foreach (DataRow row in sample.Rows) ▸ if (row["USER_FLAG"].ToString() == "True" \|\| row["USER_FLAG"].ToString() == "Y") | DATA_OP | row["VALID_YN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-0b48f531 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:468 | foreach (DataRow row in sample.Rows) ▸ else of (row["USER_FLAG"].ToString() == "True" \|\| row["USER_FLAG"].ToString() == "Y") | DATA_OP | row["VISIBLE_FLAG"] | row["VALID_YN"] = "N" | 행/컬럼 값 대입 |  |  |  |
| AC-6d5ce872 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:468 | foreach (DataRow row in sample.Rows) ▸ else of (row["USER_FLAG"].ToString() == "True" \|\| row["USER_FLAG"].ToString() == "Y") | DATA_OP | row["VALID_YN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-537cc51d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:472 |  | UI_PROP | sample.DefaultView.Sort | "USER_SORT_ORDER_NO ASC" | 속성 Sort 설정 |  |  |  |
| AC-65b5c9b7 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:473 |  | DATA_OP | sample.DefaultView.ToTable | (true) | 데이터 객체 조작/조회 |  |  |  |
| AC-9eec1ae2 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:474 |  | GRID_INIT | si.SetSheetHeaderColumn_FP | (sample) | 그리드 재구성/초기화 |  |  |  |
| AC-c2de0ac0 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:475 |  | FLAG | dtDimension | sample | 화면 필드/플래그 변경 |  |  |  |

## FPC0105_ReportConfig_Popup.FillToSampleSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Confirm:] / this.spdDimension.RowDragMoveCompleted / ((CheckBoxCellType)(si.ActiveSheet.Columns[0, 0].CellType)).EditorValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-997195aa | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:568 |  | DATA_OP | sample.Columns.Contains | ("DAY_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b36fc69 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:569 | if (!sample.Columns.Contains("DAY_CODE")) | DATA_OP | sample.Columns.Add | (new DataColumn("DAY_CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c5830d3 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:570 |  | DATA_OP | sample.Columns.Contains | ("FIXED_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d96f369 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:571 | if (!sample.Columns.Contains("FIXED_FLAG")) | DATA_OP | sample.Columns.Add | (new DataColumn("FIXED_FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-16128470 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:572 |  | DATA_OP | sample.Columns.Contains | ("CELL_CONTROL_OBJECT_TYPE_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a018ab3e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:573 | if (!sample.Columns.Contains("CELL_CONTROL_OBJECT_TYPE_CODE")) | DATA_OP | sample.Columns.Add | (new DataColumn("CELL_CONTROL_OBJECT_TYPE_CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b8e2258 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:574 |  | DATA_OP | sample.Columns.Contains | ("CELL_COMBO_DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ecf18acc | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:575 | if (!sample.Columns.Contains("CELL_COMBO_DATA_TYPE")) | DATA_OP | sample.Columns.Add | (new DataColumn("CELL_COMBO_DATA_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a554d824 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:576 |  | DATA_OP | sample.Columns.Contains | ("DATA_SCALE_NUMBER") | 데이터 객체 조작/조회 |  |  |  |
| AC-be17f3af | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:577 | if (!sample.Columns.Contains("DATA_SCALE_NUMBER")) | DATA_OP | sample.Columns.Add | (new DataColumn("DATA_SCALE_NUMBER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-18cbf200 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:578 |  | DATA_OP | sample.Columns.Contains | ("DATA_MAX_LENGTH") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1b438ea | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:579 | if (!sample.Columns.Contains("DATA_MAX_LENGTH")) | DATA_OP | sample.Columns.Add | (new DataColumn("DATA_MAX_LENGTH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-62e3d53e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:580 |  | DATA_OP | sample.Columns.Contains | ("HORIZONTAL_ALIGN_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-daca3115 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:581 | if (!sample.Columns.Contains("HORIZONTAL_ALIGN_CODE")) | DATA_OP | sample.Columns.Add | (new DataColumn("HORIZONTAL_ALIGN_CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f47e3b37 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:582 |  | DATA_OP | sample.Columns.Contains | ("UPPERCASE_APPLY_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c824915 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:583 | if (!sample.Columns.Contains("UPPERCASE_APPLY_FLAG")) | DATA_OP | sample.Columns.Add | (new DataColumn("UPPERCASE_APPLY_FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4024da1b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:584 |  | DATA_OP | sample.Columns.Contains | ("VISIBLE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-31a1ddc8 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:585 | if (!sample.Columns.Contains("VISIBLE_FLAG")) | DATA_OP | sample.Columns.Add | (new DataColumn("VISIBLE_FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d29a830b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:586 |  | DATA_OP | sample.Columns.Contains | ("VALID_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-59a20ece | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 2 | FPC0105_ReportConfig_Popup.cs:587 | if (!sample.Columns.Contains("VALID_YN")) | DATA_OP | sample.Columns.Add | (new DataColumn("VALID_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |

## FPC0105_ReportConfig_Popup.GetColumnSet

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86a0a3c2 | .ctor | FPC0105_ReportConfig_Popup.cs:224 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0002_GET_TITLESET_POPUP") ⇒ SCM.SCM0002_GET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-70735187 | .ctor | FPC0105_ReportConfig_Popup.cs:226 |  | DATA_OP | request.Parameters["p_program_id"] | _sProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-b1ea96d5 | .ctor | FPC0105_ReportConfig_Popup.cs:227 |  | DATA_OP | request.Parameters["p_sheet_name"] | _sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-7777a1ab | .ctor | FPC0105_ReportConfig_Popup.cs:228 |  | DATA_OP | request.Parameters["p_column_type"] | _sColumnSetType | 행/컬럼 값 대입 |  |  |  |
| AC-949d8cf0 | .ctor | FPC0105_ReportConfig_Popup.cs:229 |  | DATA_OP | request.Parameters["p_user_id"] | _sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-44bcd319 | .ctor | FPC0105_ReportConfig_Popup.cs:230 |  | DATA_OP | request.Parameters["p_division_id"] | _sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-f1f38282 | .ctor | FPC0105_ReportConfig_Popup.cs:231 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cf36bc4b | .ctor | FPC0105_ReportConfig_Popup.cs:232 |  | FLAG | _dtColumnSet | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FPC0105_ReportConfig_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff777ac0 | this.Load | FPC0105_ReportConfig_Popup.cs:150 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FPC0105_ReportConfig_Popup.InitSheet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4c23ad0 | this.Load | FPC0105_ReportConfig_Popup.cs:160 |  | DATA_OP | dt.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-11224ceb | this.Load | FPC0105_ReportConfig_Popup.cs:161 |  | DATA_OP | dt.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-711ab6cb | this.Load | FPC0105_ReportConfig_Popup.cs:162 |  | DATA_OP | dt.Rows.Add | (new object[] { "ASC", "ASC" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-0213d1e2 | this.Load | FPC0105_ReportConfig_Popup.cs:163 |  | DATA_OP | dt.Rows.Add | (new object[] { "DESC", "DESC" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4d0d457 | this.Load | FPC0105_ReportConfig_Popup.cs:179 |  | GRID_INIT | this.AddSheet | (spdDimension, "Dimension", "Dimension", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-23e64d4a | this.Load | FPC0105_ReportConfig_Popup.cs:181 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-188e27c7 | this.Load | FPC0105_ReportConfig_Popup.cs:183 |  | UI_PROP | si.IsRowMove | !_isBaseSort | 속성 IsRowMove 설정 |  |  |  |
| AC-89cf0e94 | this.Load | FPC0105_ReportConfig_Popup.cs:184 |  | GRID_INIT | si.AddCheckColumn | ("USE", "USER_FLAG", FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12da7e15 | this.Load | FPC0105_ReportConfig_Popup.cs:185 |  | GRID_INIT | si.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-108abc55 | this.Load | FPC0105_ReportConfig_Popup.cs:186 |  | GRID_INIT | si.AddTextColumn | ("Column Name", "COLUMN_LABEL_NAME", FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-561c7d9f | this.Load | FPC0105_ReportConfig_Popup.cs:187 |  | GRID_INIT | si.AddNumColumn | ("Seq", "SORT_ORDER_NO", FPMerge.None, 20, false, FPHAlign.Right, FPVAlign.Center, 2, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d91a4af | this.Load | FPC0105_ReportConfig_Popup.cs:188 |  | GRID_INIT | si.AddTextColumn | ("USER_SELECTABLE_FLAG", "USER_SELECTABLE_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b97e9645 | this.Load | FPC0105_ReportConfig_Popup.cs:189 |  | GRID_SET | spdDimension.Sheets[0].Columns[0, spdDimension.Sheets[0].ColumnCount - 1].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-f98a4f01 | this.Load | FPC0105_ReportConfig_Popup.cs:192 |  | GRID_INIT | this.AddSheet | (spdMeasure, "Measure", "Measure", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e30fc156 | this.Load | FPC0105_ReportConfig_Popup.cs:194 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-38df03dc | this.Load | FPC0105_ReportConfig_Popup.cs:195 |  | UI_PROP | si.IsRowMove | !_isBaseSort | 속성 IsRowMove 설정 |  |  |  |
| AC-2656e3e8 | this.Load | FPC0105_ReportConfig_Popup.cs:196 |  | GRID_INIT | si.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1dedddf3 | this.Load | FPC0105_ReportConfig_Popup.cs:198 |  | GRID_INIT | si.AddTextColumn | ("LargeClass", "LARGE_CLASS_LABEL_NAME", FPMerge.Always, 80, isLarge) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-67390b3b | this.Load | FPC0105_ReportConfig_Popup.cs:199 |  | GRID_INIT | si.AddTextColumn | ("SmallClass", "SMALL_CLASS_LABEL_NAME", FPMerge.Always, 80, isSmall) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8eb1e59 | this.Load | FPC0105_ReportConfig_Popup.cs:200 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a14fb74 | this.Load | FPC0105_ReportConfig_Popup.cs:201 |  | GRID_INIT | si.AddTextColumn | ("Sort", "SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b35716f6 | this.Load | FPC0105_ReportConfig_Popup.cs:202 |  | GRID_INIT | si.AddNumColumn | ("Seq", "SORT_ORDER_NO", FPMerge.None, 20, false, FPHAlign.Right, FPVAlign.Center, 2, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb9a01da | this.Load | FPC0105_ReportConfig_Popup.cs:203 |  | GRID_INIT | si.AddComboColumn | ("Sort", "USER_SORT_METHOD_CODE", FPMerge.None, 45, isColumn, dt) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f009aeff | this.Load | FPC0105_ReportConfig_Popup.cs:204 |  | GRID_INIT | si.AddCheckColumn | ("Sub Total", "SUB_TOTAL_FLAG", FPMerge.None, 40, _isSubTotal, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e68ff16d | this.Load | FPC0105_ReportConfig_Popup.cs:206 |  | GRID_INIT | si.AddTextColumn | ("USER_SELECTABLE_FLAG", "USER_SELECTABLE_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a740da7d | this.Load | FPC0105_ReportConfig_Popup.cs:208 |  | GRID_SET | spdMeasure.Sheets[0].Columns[0, spdMeasure.Sheets[0].Columns["COLUMN_LABEL_NAME"].Index].L… | true | 그리드 속성/값 설정 |  |  |  |
| AC-6444348c | this.Load | FPC0105_ReportConfig_Popup.cs:209 |  | GRID_SET | spdMeasure.Sheets[0].Columns[spdMeasure.Sheets[0].Columns["USER_SORT_METHOD_CODE"].Index, … | ControlColor.UnLockColor | 그리드 속성/값 설정 |  |  |  |

## FPC0105_ReportConfig_Popup.SaveColumnSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-447499c0 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:342 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ SCM.SCM0002_SET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-715535cc | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:343 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_program_id"] | sProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-97550df0 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:344 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sheet_name"] | sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-0f0de35d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:345 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_column_type"] | sTitleSetType | 행/컬럼 값 대입 |  |  |  |
| AC-3fcdc5de | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:346 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActive_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4c71c6e0 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:347 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_column_name"] | sColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-52f0b093 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:348 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sort_order_no"] | sSortOrderNo | 행/컬럼 값 대입 |  |  |  |
| AC-130f0fe2 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:349 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sub_total_flag"] | sSubTotalFlag | 행/컬럼 값 대입 |  |  |  |
| AC-5173addf | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:350 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sort_method_code"] | sSortMethod | 행/컬럼 값 대입 |  |  |  |
| AC-8405e9af | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:351 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-6d867802 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:353 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-19ace167 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:359 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c5e708e9 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:363 | try ▸ if (iCount > 0) ▸ finally | MESSAGE | MessageHelper.GMessageBox | ("MSG00020", new object[] { _sTitleSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-353f40ab | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:364 | try ▸ if (iCount > 0) ▸ finally | CALL_BASE | FindButton | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-66f058a7 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:377 | try ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { _sTitleSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-408cb623 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:378 | try ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a4ae412 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0105_ReportConfig_Popup.cs:398 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006", new object[] { _sTitleSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FPC0105_ReportConfig_Popup.spdDimension_CellClick

진입점: this.spdDimension.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6748680 | this.spdDimension.CellClick | FPC0105_ReportConfig_Popup.cs:611 |  | FLAG | lastcol | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-b7fae719 | this.spdDimension.CellClick | FPC0105_ReportConfig_Popup.cs:612 |  | FLAG | lastrow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0105_ReportConfig_Popup.spdUser_ButtonClicked

진입점: this.spdMeasure.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87e70fbc | this.spdMeasure.ButtonClicked | FPC0105_ReportConfig_Popup.cs:490 | if (e.Column != sv.Columns["SUB_TOTAL_FLAG"].Index) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd60c36a | this.spdMeasure.ButtonClicked | FPC0105_ReportConfig_Popup.cs:494 | for (i < sv.RowCount) | GRID_SET | sv.Cells[i, e.Column].Value | "false" | 그리드 속성/값 설정 |  |  |  |

## FPC0105_ReportConfig_Popup.spdUser_RowDragMove

진입점: this.spdMeasure.RowDragMove

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d968d870 | this.spdMeasure.RowDragMove | FPC0105_ReportConfig_Popup.cs:538 | if (sUserSelect != "Y") | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## FPC0105_ReportConfig_Popup.usrButtonList1_UsrButtonList_Click_Detected

진입점: this.usrButtonList1.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ae68d2c | this.usrButtonList1.UsrButtonList_Click_Detected | FPC0105_ReportConfig_Popup.cs:518 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

