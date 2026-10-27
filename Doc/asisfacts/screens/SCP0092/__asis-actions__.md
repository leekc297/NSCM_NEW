# AS-IS 액션 대조표 — SCP0092

> 원천: `Doc/asisfacts/screens/SCP0092/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 490행 · 메서드 117 · 종류 DATA_OP 107 · FLAG 56 · UI_PROP 53 · RETURN 40 · ENDPOINT 29 · GRID_INIT 26 · POPUP 26 · CALL_EXT 24 · GRID_SET 24 · VALUE_SET 21 · LIST_REBIND 21 · COMBO_DATA 15 · STATE 13 · UI_MISC 9 · GRID_CLEAR 5 · VALUE_CLEAR 4 · LIST_BIND 4 · GRID_BIND 3 · GRID_LOCK 3 · STATE_RESET 2 · GRID_STYLE 2 · MESSAGE 1 · VALIDATE 1 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 24


## SCP0092_PICPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3dc1573 | this.Load | SCP0092_PICPopup.cs:132 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-896b6edc | this.Load | SCP0092_PICPopup.cs:133 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-84b4b73a | this.Load | SCP0092_PICPopup.cs:134 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0092_PICPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd97f7d8 | this.Load | SCP0092_PICPopup.cs:120 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-6292e187 | this.Load | SCP0092_PICPopup.cs:125 |  | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |
| AC-01b5d725 | this.Load | SCP0092_PICPopup.cs:127 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0092_PICPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09e58d98 | Dispose | SCP0092_PICPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0092_PICPopup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98a8ef65 | this.Load 외 2 | SCP0092_PICPopup.cs:171 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1840fab1 | this.Load 외 2 | SCP0092_PICPopup.cs:175 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0092_GET_PIC_USERINFO_POPUP") ⇒ SCP.SCP0092_GET_PIC_USERINFO_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-56dd6197 | this.Load 외 2 | SCP0092_PICPopup.cs:177 | lambda | DATA_OP | request.Parameters["p_division_id"] | this.Division | 행/컬럼 값 대입 |  |  |  |
| AC-44040631 | this.Load 외 2 | SCP0092_PICPopup.cs:178 | lambda | DATA_OP | request.Parameters["p_item_id"] | this.ItemId | 행/컬럼 값 대입 |  |  |  |
| AC-6c24f27d | this.Load 외 2 | SCP0092_PICPopup.cs:179 | lambda | DATA_OP | request.Parameters["p_user"] | this.txtSearch.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d9bc62e6 | this.Load 외 2 | SCP0092_PICPopup.cs:180 | lambda | DATA_OP | request.Parameters["p_language"] | this.Language | 행/컬럼 값 대입 |  |  |  |
| AC-eb598bfe | this.Load 외 2 | SCP0092_PICPopup.cs:182 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-21e91830 | this.Load 외 2 | SCP0092_PICPopup.cs:184 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9ec18946 | this.Load 외 2 | SCP0092_PICPopup.cs:188 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-604c0439 | this.Load 외 2 | SCP0092_PICPopup.cs:189 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-06a962ed | this.Load 외 2 | SCP0092_PICPopup.cs:192 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0092_PICPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e846246 | this.Load | SCP0092_PICPopup.cs:96 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9b8312cd | this.Load | SCP0092_PICPopup.cs:100 |  | UI_PROP | this.Width | GetSpreadWidth() + 100 | 속성 Width 설정 |  |  |  |
| AC-bd42a582 | this.Load | SCP0092_PICPopup.cs:101 |  | UI_PROP | this.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-f4b3da44 | this.Load | SCP0092_PICPopup.cs:105 |  | VALUE_SET | this.txtSearch.Text | this.User | 컨트롤 값 설정 |  |  |  |

## SCP0092_PICPopup.GetSpreadWidth

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9937032 | this.Load | SCP0092_PICPopup.cs:92 |  | RETURN | return int.Parse(res.ToString()); |  | 처리 중단/반환 |  |  |  |

## SCP0092_PICPopup.InitSpread

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-223e526c | this.Load 외 2 | SCP0092_PICPopup.cs:141 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-5ba8a924 | this.Load 외 2 | SCP0092_PICPopup.cs:143 |  | GRID_INIT | siMain.AddTextColumn | ("UserID", DefColumns.USER_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c6b5b3a2 | this.Load 외 2 | SCP0092_PICPopup.cs:144 |  | GRID_INIT | siMain.AddTextColumn | ("UserName", DefColumns.USER_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6da02022 | this.Load 외 2 | SCP0092_PICPopup.cs:145 |  | GRID_INIT | siMain.AddTextColumn | ("EnglishName", DefColumns.USER_NAME_EN, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ae34b07 | this.Load 외 2 | SCP0092_PICPopup.cs:146 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_ID", DefColumns.DEPT_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d55760f2 | this.Load 외 2 | SCP0092_PICPopup.cs:147 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_Name", DefColumns.DEPT_NAME, FPMerge.None, 240, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2283b7d3 | this.Load 외 2 | SCP0092_PICPopup.cs:149 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.USER_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0092_PICPopup.OkButtonClick

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0b471f4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0092_PICPopup.cs:250 | for (i <= siMain.GetMaxRowIndex()) ▸ if (chk.Equals("SCP0092_PICPopup")) | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { USER_ID = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.USE… | 데이터 객체 조작/조회 |  |  |  |
| AC-6b1cc5fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0092_PICPopup.cs:261 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-92e23b9a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0092_PICPopup.cs:264 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0092_PICPopup.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eec843b | this.spdMain.CellClick | SCP0092_PICPopup.cs:227 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-70f9fe9f | this.spdMain.CellClick | SCP0092_PICPopup.cs:228 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-59c58e21 | this.spdMain.CellClick | SCP0092_PICPopup.cs:232 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-c14dbb2b | this.spdMain.CellClick | SCP0092_PICPopup.cs:233 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |

## SCP0092_PICPopup.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d003b69 | spdMain.CellDoubleClick | SCP0092_PICPopup.cs:271 |  | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { USER_ID = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns… | 데이터 객체 조작/조회 |  |  |  |
| AC-338778ed | spdMain.CellDoubleClick | SCP0092_PICPopup.cs:280 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-0ec1fd7f | spdMain.CellDoubleClick | SCP0092_PICPopup.cs:284 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0092_RTF_ArcheivementRate.AfterFindDataSummary

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-044dcd5a | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1962 |  | GRID_BIND | _siSummary.Query | (this._dsSummary) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-26309bbe | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1964 |  | GRID_LOCK | _siSummary.LockColumn | (0, _siSummary.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dc8bbee4 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1968 |  | FLAG | this.dsOldSummary | (_siSummary.SpreadObject.DataSource as DataSet).Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-10f651ba | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1968 |  | DATA_OP | (_siSummary.SpreadObject.DataSource as DataSet).Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6f3c3ee5 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1972 |  | FLAG | this._elapsedColumns | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7cdf78d6 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1975 |  | UI_MISC | SetSearchCount | (this._dsSummary) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0092_RTF_ArcheivementRate.AfterFindDataWeekly

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94c9c1d3 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1981 | if (lst.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db7f260f | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1996 | if (ds.Tables[0] != null) | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-03d54a20 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1998 | if (ds.Tables[0] != null) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-36213c14 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1998 | if (ds.Tables[0] != null) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b9f8ea56 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2000 | if (ds.Tables[0] != null) | GRID_BIND | this._weeklys[this._weeklyDivision].SpreadInfo.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-26b7b0ce | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2005 | if (ds.Tables[0] != null) ▸ try | GRID_LOCK | this._weeklys[this._weeklyDivision].SpreadInfo.LockColumn | (0, this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-732d0fdb | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2015 | if (ds.Tables[0] != null) ▸ if (dsOldWeekly != null) | UI_MISC | dsOldWeekly.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-fc665102 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2016 | if (ds.Tables[0] != null) ▸ if (dsOldWeekly != null) | FLAG | dsOldWeekly | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2109be23 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2024 | if (this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxRowIndex() > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-51d663d4 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2027 |  | FLAG | this_YYYYMMWW | "W_" + DateTime.Today.ToString("yyyyMM") + ds.Tables[3].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2f803117 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2028 |  | FLAG | iso_week | ds.Tables[3].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-560a20bb | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2031 |  | FLAG | this.dtDEF_Weekly | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-4903bbd9 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2032 |  | FLAG | this.dtTotal_Weekly | ds.Tables[2] | 화면 필드/플래그 변경 |  |  |  |

## SCP0092_RTF_ArcheivementRate.btnSummaryColumn_Click

진입점: btnSummaryColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb16eeb1 | btnSummaryColumn.Click | SCP0092_RTF_ArcheivementRate.cs:2575 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0092", this._currSheetName, true, new string[]{"RTF", "RESULT", "RESULT_WITH_RTF", "R… | 팝업/폼 생성 |  |  |  |
| AC-6767b88f | btnSummaryColumn.Click | SCP0092_RTF_ArcheivementRate.cs:2590 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6c93ff87 | btnSummaryColumn.Click | SCP0092_RTF_ArcheivementRate.cs:2591 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0092_RTF_ArcheivementRate.btnSummaryItemId_Click

진입점: btnSummaryItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cd88379 | btnSummaryItemId.Click | SCP0092_RTF_ArcheivementRate.cs:2533 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-40a4d0b4 | btnSummaryItemId.Click | SCP0092_RTF_ArcheivementRate.cs:2535 |  | POPUP | popItem.Form_Load | (true, this._summaryDivision, "", this._summaryProject, this._summaryModel) | 팝업 초기화(인자 전달) |  |  |  |
| AC-49c586e9 | btnSummaryItemId.Click | SCP0092_RTF_ArcheivementRate.cs:2536 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-771c5a4b | btnSummaryItemId.Click | SCP0092_RTF_ArcheivementRate.cs:2537 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bab737bb | btnSummaryItemId.Click | SCP0092_RTF_ArcheivementRate.cs:2543 | if (popItem.ItemID != "") | VALUE_SET | txtSummaryItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.btnSummaryProject_Click

진입점: btnSummaryProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-881df1e7 | btnSummaryProject.Click | SCP0092_RTF_ArcheivementRate.cs:2499 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c9bc93e9 | btnSummaryProject.Click | SCP0092_RTF_ArcheivementRate.cs:2501 |  | POPUP | popProject.Form_Load | (true, division, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-bc88750d | btnSummaryProject.Click | SCP0092_RTF_ArcheivementRate.cs:2503 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9ba925cc | btnSummaryProject.Click | SCP0092_RTF_ArcheivementRate.cs:2505 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-369f5903 | btnSummaryProject.Click | SCP0092_RTF_ArcheivementRate.cs:2511 | if (popProject.ProjectCode != "") | VALUE_SET | txtSummaryProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.btnWeeklyColumn_Click

진입점: btnWeeklyColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54be5309 | btnWeeklyColumn.Click | SCP0092_RTF_ArcheivementRate.cs:2549 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0092", this._currSheetName, true, new string[]{"RTF", "RESULT", "RESULT_WITH_RTF", "R… | 팝업/폼 생성 |  |  |  |
| AC-22d35baf | btnWeeklyColumn.Click | SCP0092_RTF_ArcheivementRate.cs:2564 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d067b7dd | btnWeeklyColumn.Click | SCP0092_RTF_ArcheivementRate.cs:2565 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0092_RTF_ArcheivementRate.btnWeeklyItemId_Click

진입점: btnWeeklyItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ccdce0e | btnWeeklyItemId.Click | SCP0092_RTF_ArcheivementRate.cs:2517 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c9f745fb | btnWeeklyItemId.Click | SCP0092_RTF_ArcheivementRate.cs:2519 |  | POPUP | popItem.Form_Load | (true, this._weeklyDivision, "", this._weeklyProject, this._weeklyModel) | 팝업 초기화(인자 전달) |  |  |  |
| AC-32bb8bfd | btnWeeklyItemId.Click | SCP0092_RTF_ArcheivementRate.cs:2520 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7ca5a503 | btnWeeklyItemId.Click | SCP0092_RTF_ArcheivementRate.cs:2521 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-55ca5f32 | btnWeeklyItemId.Click | SCP0092_RTF_ArcheivementRate.cs:2527 | if (popItem.ItemID != "") | VALUE_SET | txtWeeklyItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.btnWeeklyProject_Click

진입점: btnWeeklyProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55c0942b | btnWeeklyProject.Click | SCP0092_RTF_ArcheivementRate.cs:2474 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-dbcf24de | btnWeeklyProject.Click | SCP0092_RTF_ArcheivementRate.cs:2476 |  | POPUP | popProject.Form_Load | (true, division, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9fd123b4 | btnWeeklyProject.Click | SCP0092_RTF_ArcheivementRate.cs:2478 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2be857bb | btnWeeklyProject.Click | SCP0092_RTF_ArcheivementRate.cs:2480 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0111a822 | btnWeeklyProject.Click | SCP0092_RTF_ArcheivementRate.cs:2486 | if (popProject.ProjectCode != "") | VALUE_SET | txtWeeklyProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.cboSummaryQTY_SelectedIndexChanged

진입점: cboSummaryQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc5c0ff2 | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2967 | if (_siSummary == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.cboWeeklyQTY_SelectedIndexChanged

진입점: cboWeeklyQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e63e790 | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2960 | if (this._weeklys[this._weeklyDivision].SpreadInfo == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.cboWeeklyWeek_SelectedIndexChanged

진입점: cboWeeklyWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf87a8fd | cboWeeklyWeek.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2287 | try | VALUE_CLEAR | this.txtWeeklyProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3feb592c | cboWeeklyWeek.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2288 | try | VALUE_CLEAR | this.txtWeeklyItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-083b88e1 | cboWeeklyWeek.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2289 | try | VALUE_CLEAR | this.txtWeeklyOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## SCP0092_RTF_ArcheivementRate.CheckItemType

진입점: this.Load [if (clb.Items.Count > 0) ▸ if (this._currSheetName.Equals(this.SHEET_NAME_SUMMARY))] / cboWeeklyDivision.SelectedIndexChanged [try ▸ if (clb.Items.Count > 0) ▸ if (this._currSheetName.Equals(this.SHEET_NAME_SUMMARY))] / cboSummaryDivision.SelectedIndexChanged [try ▸ if (clb.Items.Count > 0) ▸ if (this._currSheetName.Equals(this.SHEET_NAME_SUMMARY))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5d445bd | this.Load [if (clb.Items.Count > 0) ▸ if (this._currSheetNam… 외 2 | SCP0092_RTF_ArcheivementRate.cs:325 | if (selectAll) ▸ for (i <= clb.Items.Count - 1) | CALL_EXT | clb.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ec22c07 | this.Load [if (clb.Items.Count > 0) ▸ if (this._currSheetNam… 외 2 | SCP0092_RTF_ArcheivementRate.cs:336 | else of (selectAll) ▸ if (idx >= 0) | CALL_EXT | clb.SetItemChecked | (idx, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0092_RTF_ArcheivementRate.CreateSpreadSummary

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb0d8b12 | this.Load | SCP0092_RTF_ArcheivementRate.cs:1084 |  | GRID_INIT | this.AddSheet | (spdSummary, this.SHEET_NAME_SUMMARY, this.SHEET_NAME_SUMMARY, 2, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ce0b35c7 | this.Load | SCP0092_RTF_ArcheivementRate.cs:1085 |  | FLAG | _siSummary | GetSheetInfo(spdSummary.Name, spdSummary.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-64983cd3 | this.Load | SCP0092_RTF_ArcheivementRate.cs:1086 |  | GRID_INIT | _siSummary.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.CreateSpreadWeekly

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24893838 | this.Load | SCP0092_RTF_ArcheivementRate.cs:1095 | if (_weeklys.Count > 0) | CALL_EXT | _weeklys.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d29c156 | this.Load | SCP0092_RTF_ArcheivementRate.cs:1098 |  | DATA_OP | _weeklys.Add | ("81", new WeeklySheet(this, this.tbcSheet, this.pnlWeekly, spdWeekly81, "81")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4642b049 | this.Load | SCP0092_RTF_ArcheivementRate.cs:1099 |  | DATA_OP | _weeklys.Add | ("82", new WeeklySheet(this, this.tbcSheet, this.pnlWeekly, spdWeekly82, "82")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c8dd4f6 | this.Load | SCP0092_RTF_ArcheivementRate.cs:1100 |  | DATA_OP | _weeklys.Add | ("40", new WeeklySheet(this, this.tbcSheet, this.pnlWeekly, spdWeekly40, "40")) | 데이터 객체 조작/조회 |  |  |  |

## SCP0092_RTF_ArcheivementRate.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5156488e | Dispose | SCP0092_RTF_ArcheivementRate.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0092_RTF_ArcheivementRate.DrawResultSummary

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae417d7c | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1860 | foreach (Column c in this.spdSummary.Sheets[0].Columns) ▸ if (!c.DataField.Substring(0, 2).Equals("W_")) | DATA_OP | colIdxes.Add | (c.Index) | 데이터 객체 조작/조회 |  |  |  |
| AC-db093b6f | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1870 | foreach (int colIdx in colIdxes) ▸ foreach (Row r in this.spdSummary.Sheets[0].Rows) | GRID_SET | this.spdSummary.Sheets[0].Cells[rowIdx, colIdx].BackColor | Color.WhiteSmoke | 그리드 속성/값 설정 |  |  |  |
| AC-c7023d9c | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1880 | if (string.IsNullOrEmpty(this._weeklyDivision)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36d8c843 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1890 | if (totalCnt == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ffc3430 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1900 | if (!this._summaryDivision.Equals("")) | GRID_SET | this.spdSummary.Sheets[0].Cells[mergedRowIdx, mergedColIdx].Border | new FarPoint.Win.LineBorder(Color.Black, 2, false, false, false, true) | 그리드 속성/값 설정 |  |  |  |
| AC-5d822610 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1901 | if (!this._summaryDivision.Equals("")) | GRID_SET | this.spdSummary.Sheets[0].Rows[commonRowidx - 1].Border | new FarPoint.Win.LineBorder(Color.Black, 2, false, false, false, true) | 그리드 속성/값 설정 |  |  |  |
| AC-b687dfaf | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1909 | for (i <= this._rowCountSummarys.Count - 1) | GRID_SET | this.spdSummary.Sheets[0].Cells[mergedRowIdx, mergedColIdx].Border | new FarPoint.Win.LineBorder(Color.Black, 2, false, false, false, true) | 그리드 속성/값 설정 |  |  |  |
| AC-43e99688 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1911 | for (i <= this._rowCountSummarys.Count - 1) | GRID_SET | this.spdSummary.Sheets[0].Rows[commonRowidx - 1].Border | new FarPoint.Win.LineBorder(Color.Black, 2, false, false, false, true) | 그리드 속성/값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-993b10e2 | EditButton | SCP0092_RTF_ArcheivementRate.cs:1733 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4375c950 | EditButton | SCP0092_RTF_ArcheivementRate.cs:1734 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.ElapseOrCollapseAllSheetWeekColumns

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged / btnSummaryColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ac174e7 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:3187 | foreach (Column c in sv.Columns) ▸ if (c.DataField.Substring(0, 2).Equals("W_")) | STATE | c.Visible | visible | 컨트롤 상태 Visible |  |  |  |

## SCP0092_RTF_ArcheivementRate.ElapseOrCollapseColumns

진입점: spdSummary.CellDoubleClick [if (e.ColumnHeader)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df99ebb7 | spdSummary.CellDoubleClick [if (e.ColumnHeader)] | SCP0092_RTF_ArcheivementRate.cs:3142 | if (isAllColumn) | FLAG | this._elapsedColumns | !this._elapsedColumns | 화면 필드/플래그 변경 |  |  |  |
| AC-56f16c6c | spdSummary.CellDoubleClick [if (e.ColumnHeader)] | SCP0092_RTF_ArcheivementRate.cs:3152 | if (isAllColumn) ▸ for (i <= endIdx) | GRID_SET | sv.Columns[i].Visible | this._elapsedColumns | 그리드 속성/값 설정 |  |  |  |
| AC-5791fabb | spdSummary.CellDoubleClick [if (e.ColumnHeader)] | SCP0092_RTF_ArcheivementRate.cs:3159 | else of (isAllColumn) ▸ for (i <= endIdx) | GRID_SET | sv.Columns[i].Visible | !sv.Columns[i].Visible | 그리드 속성/값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4dc50b9 | FindButton | SCP0092_RTF_ArcheivementRate.cs:2113 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-69177ae4 | FindButton | SCP0092_RTF_ArcheivementRate.cs:2113 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.FindDataSummary

진입점: FindButton [if (this.tbcSheet.SelectedTab == tabSummary)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-517f5932 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2043 | if (this.QueryDics[DIC_RTF_ARCH_RATE_SUMMARY].Count > 0) | CALL_EXT | this.QueryDics[DIC_RTF_ARCH_RATE_SUMMARY].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-20ba7a9b | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2048 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.InitSpreadSummary | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-2a1784f4 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2049 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindDataSummary | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-54ca2fd7 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2050 |  | UI_PROP | qi.ServiceUri | "GSCM.SCP.Analysis.WSL/FoxDataService.svc" | 속성 ServiceUri 설정 |  |  |  |
| AC-da747483 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2051 |  | UI_PROP | qi.QueryId | "SCP.SCP0092_GET_RTF_ARCHEIVEMENT_RATE_SUMMARY" | 속성 QueryId 설정 |  |  |  |
| AC-25e1ec0e | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2053 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._summaryDivision)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6bcf6537 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2054 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_category_code", this._summaryCategory)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88250703 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2055 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_year", this._summaryYear)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfd9716d | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2056 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_dept_id", this._summaryTeam)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6296eb9f | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2057 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_end_customer", this._summaryEndCustomer)) | 데이터 객체 조작/조회 |  |  |  |
| AC-41333064 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2058 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_project_code", this._summaryProject)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aafc3135 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2059 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._summaryItemId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f33a8d56 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2060 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_type", this._summaryItemType)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f68c270d | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2061 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_created_by", base.UserInfo.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-48bf1d9b | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2062 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_biz_type", this._summaryOperationGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7daf595 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2063 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_fcst_type", this._summaryFcstType)) | 데이터 객체 조작/조회 |  |  |  |
| AC-95278df0 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2064 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_owner", this._summaryOwner)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e35047d4 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2065 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_dept_id", UserInfoContext.Current["Dept_ID"].ToS… | 데이터 객체 조작/조회 |  |  |  |
| AC-a64ec9e3 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2066 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_id", UserInfoContext.Current["NowGroupID"].ToSt… | 데이터 객체 조작/조회 |  |  |  |
| AC-b61680d8 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2067 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_is_pre_week", this._isSummaryPreWeek)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34ae6c02 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2069 |  | DATA_OP | this.QueryDics[DIC_RTF_ARCH_RATE_SUMMARY] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |
| AC-4a97b496 | FindButton [if (this.tbcSheet.SelectedTab == tabSummary)] | SCP0092_RTF_ArcheivementRate.cs:2072 |  | ENDPOINT | this.ExecuteSQL | (_siSummary, DIC_RTF_ARCH_RATE_SUMMARY, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0092_RTF_ArcheivementRate.FindDataWeekly

진입점: FindButton [else of (this.tbcSheet.SelectedTab == tabSummary) ▸ if (!this._weeklyDivision.Equals(""))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92a42b36 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2080 | if (this.QueryDics[DIC_RTF_ARCH_RATE_WEEKLY].Count > 0) | CALL_EXT | this.QueryDics[DIC_RTF_ARCH_RATE_WEEKLY].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ac2b9ad | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2085 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-5007cc54 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2086 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindDataWeekly | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-f6e79859 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2087 |  | UI_PROP | qi.ServiceUri | "GSCM.SCP.Analysis.WSL/FoxDataService.svc" | 속성 ServiceUri 설정 |  |  |  |
| AC-0b4fdb1b | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2088 |  | UI_PROP | qi.QueryId | "SCP.SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY" | 속성 QueryId 설정 |  |  |  |
| AC-1fe72e15 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2090 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._weeklyDivision)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f87ee85 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2091 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_dept_id", this._weeklyTeam)) | 데이터 객체 조작/조회 |  |  |  |
| AC-28f53609 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2092 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_end_customer", this._weeklyEndCustomer)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ee127d3 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2093 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_project_code", this._weeklyProject)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc69e605 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2094 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._weeklyItemId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-244a14b1 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2095 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_type", this._weeklyItemType)) | 데이터 객체 조작/조회 |  |  |  |
| AC-43545b53 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2096 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_week", this._weeklyWeek)) | 데이터 객체 조작/조회 |  |  |  |
| AC-95b37fa6 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2097 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_created_by", base.UserInfo.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c5f60ca | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2098 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_biz_type", this._weeklyOperationGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-525965bd | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2099 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_fcst_type", this._weeklyFcstType)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfb31330 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2100 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_owner", this._weeklyOwner)) | 데이터 객체 조작/조회 |  |  |  |
| AC-042e46fd | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2101 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_dept_id", UserInfoContext.Current["Dept_ID"].ToS… | 데이터 객체 조작/조회 |  |  |  |
| AC-f7645806 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2102 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_id", UserInfoContext.Current["NowGroupID"].ToSt… | 데이터 객체 조작/조회 |  |  |  |
| AC-053866a8 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2103 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_is_pre_week", this._isWeeklyPreWeek)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa15eae9 | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2105 |  | DATA_OP | this.QueryDics[DIC_RTF_ARCH_RATE_WEEKLY] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |
| AC-e0a59ded | FindButton [else of (this.tbcSheet.SelectedTab == tabSummary… | SCP0092_RTF_ArcheivementRate.cs:2108 |  | ENDPOINT | this.ExecuteSQL | (this._weeklys[this._weeklyDivision].SpreadInfo, DIC_RTF_ARCH_RATE_WEEKLY, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0092_RTF_ArcheivementRate.fnValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2b1cabd | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2659 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f12fc61 | this.Load | SCP0092_RTF_ArcheivementRate.cs:273 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1b0143d9 | this.Load | SCP0092_RTF_ArcheivementRate.cs:275 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd7628a7 | this.Load | SCP0092_RTF_ArcheivementRate.cs:282 |  | DATA_OP | ReadOnlySheetList.Add | (this.SHEET_NAME_SUMMARY) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fbbc2df | this.Load | SCP0092_RTF_ArcheivementRate.cs:283 |  | DATA_OP | ReadOnlySheetList.Add | (this._weeklys["81"].SheetName) | 데이터 객체 조작/조회 |  |  |  |
| AC-5837170a | this.Load | SCP0092_RTF_ArcheivementRate.cs:284 |  | DATA_OP | ReadOnlySheetList.Add | (this._weeklys["82"].SheetName) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5d25812 | this.Load | SCP0092_RTF_ArcheivementRate.cs:285 |  | DATA_OP | ReadOnlySheetList.Add | (this._weeklys["40"].SheetName) | 데이터 객체 조작/조회 |  |  |  |
| AC-7183ba35 | this.Load | SCP0092_RTF_ArcheivementRate.cs:287 |  | UI_PROP | this.DisplayFooter | true | 속성 DisplayFooter 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetBucketType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3324810c | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:541 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-b2623d1d | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:542 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bc275a0e | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:545 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ceb29a4 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1791 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.getCurrSheetName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10d4b0bd | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:199 | try ▸ if (this.tbcSheet.SelectedTab == tabSummary) | RETURN | return SHEET_NAME_SUMMARY; |  | 처리 중단/반환 |  |  |  |
| AC-fbd66e25 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:210 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aff78541 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2806 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-08701a79 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2807 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-857df60a | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2808 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-aa33e624 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2810 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11e7fdc0 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2813 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f589e4b5 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2716 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-5bcc8d64 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2717 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-06cf0d06 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2718 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-a7c455ad | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2720 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c884da4 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2723 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be961c5e | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2668 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-1ef22ddb | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2670 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a373aee4 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2673 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetFcstType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e495d67 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2759 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-3d0cf472 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2760 |  | DATA_OP | request.Parameters["CODE"] | "FCST_TYPE" | 행/컬럼 값 대입 |  |  |  |
| AC-cacc19f6 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2761 |  | DATA_OP | request.Parameters["PARAM1"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a577bf6 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2762 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-57f47ce9 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2763 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b2c81fc6 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2764 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b68c1fb8 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2765 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5404f7a9 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2766 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ce3f55f0 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2768 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetIsSummaryPreWeek

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f665e6a6 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:785 |  | RETURN | return rgrpSummaryIsPreWeek.SelectedIndex == 0 ? "T" : "F"; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetIsWeeklyPreWeek

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab357c30 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:781 |  | RETURN | return rgrpWeeklyIsPreWeek.SelectedIndex == 0 ? "T" : "F"; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetItemType

진입점: this.Load [if (this._weeklyDivision.Equals("81"))] / cboWeeklyDivision.SelectedIndexChanged [try ▸ if (this._weeklyDivision.Equals("81"))] / cboSummaryDivision.SelectedIndexChanged [try ▸ if (this._summaryDivision.Equals("81"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d8a03c4 | this.Load [if (this._weeklyDivision.Equals("81"))] 외 2 | SCP0092_RTF_ArcheivementRate.cs:2777 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-df40180f | this.Load [if (this._weeklyDivision.Equals("81"))] 외 2 | SCP0092_RTF_ArcheivementRate.cs:2778 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-91bbf2da | this.Load [if (this._weeklyDivision.Equals("81"))] 외 2 | SCP0092_RTF_ArcheivementRate.cs:2779 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-baec3d58 | this.Load [if (this._weeklyDivision.Equals("81"))] 외 2 | SCP0092_RTF_ArcheivementRate.cs:2782 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetLastWeekSunDayByDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82bc6f5f | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2873 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetPlantSitebyEndCustomer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85c67cc2 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2699 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-ba7cc29a | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2700 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-bca4d73f | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2701 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-54ef79bd | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2702 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-95b91b95 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2704 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-22957efb | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2707 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetQtyData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1155a099 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2746 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_QTY_TYPE_CODE") ⇒ DM.DMF0003_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-569be97d | this.Load | SCP0092_RTF_ArcheivementRate.cs:2747 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-584d5cd3 | this.Load | SCP0092_RTF_ArcheivementRate.cs:2750 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed8f0575 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2682 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4a93a3bd | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2683 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-015ff99c | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2684 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-4b54af04 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2685 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-f12293fa | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2687 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b8646579 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2690 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.getSummaryCategory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc5c8fcd | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:809 |  | RETURN | return cboSummaryCategory.ControlValues == "ALL" ? "" : cboSummaryCategory.Contr… |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.getSummaryDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80d1beb6 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:704 |  | RETURN | return cboSummaryDivision.ControlValues == "ALL" ? "" : cboSummaryDivision.Contr… |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-936bfa6e | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2792 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-8445e053 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2793 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-e5a92ed8 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2794 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3d4be55c | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2797 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetThisWeekMonday

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86b2e45c | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2849 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.getWeeklyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-668a2b7f | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:700 |  | RETURN | return cboWeeklyDivision.ControlValues == "ALL" ? "" : cboWeeklyDivision.Control… |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.GetYearTable

진입점: this.Load / cboWeeklyDivision.SelectedIndexChanged [try] / cboSummaryDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11260fc5 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:419 |  | DATA_OP | tblAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0d2c1af6 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:425 |  | DATA_OP | tblAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-12f27abe | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:426 |  | DATA_OP | tblAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-af15b377 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:428 |  | GRID_CLEAR | tblTo.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-6392baef | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:432 | foreach (DataRow r in tblFrom.Rows) | DATA_OP | tblTo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cfe4e2e0 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:434 | foreach (DataRow r in tblFrom.Rows) | DATA_OP | newR["CODE"] | r["NAME"].ToString().Substring(0, 4) | 행/컬럼 값 대입 |  |  |  |
| AC-62b30658 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:435 | foreach (DataRow r in tblFrom.Rows) | DATA_OP | newR["NAME"] | r["NAME"].ToString().Substring(0, 4) | 행/컬럼 값 대입 |  |  |  |
| AC-74dc4ba6 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:437 | foreach (DataRow r in tblFrom.Rows) | DATA_OP | tblTo.Rows.Add | (newR) | 데이터 객체 조작/조회 |  |  |  |
| AC-07d0aa23 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:441 |  | UI_PROP | view.Sort | "NAME DESC" | 속성 Sort 설정 |  |  |  |
| AC-4d05db8f | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:442 |  | DATA_OP | view.ToTable | (true, "CODE", "NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-12845efc | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:445 |  | DATA_OP | tbl.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bc2110a0 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:451 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-976f3bd0 | this.Load | SCP0092_RTF_ArcheivementRate.cs:1073 |  | CALL_EXT | toolTip1.SetToolTip | (btnWeeklyColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a6e4742 | this.Load | SCP0092_RTF_ArcheivementRate.cs:267 |  | DATA_OP | QueryDics.Add | (DIC_RTF_ARCH_RATE_SUMMARY, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8874e61 | this.Load | SCP0092_RTF_ArcheivementRate.cs:268 |  | DATA_OP | QueryDics.Add | (DIC_RTF_ARCH_RATE_WEEKLY, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSheet

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged / btnSummaryColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9581c2a1 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1108 | if (sv.DataSource != null) | LIST_CLEAR | sv.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-46d2db35 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1111 | if (sv.Columns.Count > 0) | CALL_EXT | sv.Columns.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f6221c3 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1114 | if (sv.Rows.Count > 0) | GRID_CLEAR | sv.Rows.Clear | () | 그리드 행 비움 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSpreadDateColumnSummary

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged / btnSummaryColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1264994 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1181 | for (i <= dtWeeklyTitle.Rows.Count - 1) | GRID_INIT | spdInfo.AddNumColumn | (smallLabel, columnName, FPMerge.None, 90, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7660e852 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1187 | for (i <= dtWeeklyTitle.Rows.Count - 1) ▸ if (columnName.Substring(0, 2).Equals("M_")) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, monthStartCol, 1, weekPerMonthCnt, 20, largeLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4aaac91e | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1194 | for (i <= dtWeeklyTitle.Rows.Count - 1) ▸ else of (columnName.Substring(0, 2).Equals("M_")) ▸ if (columnName.Substring(0, 2).Equals("W_")) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, startDateCol + i, 1, 1, 20, smallLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4423386c | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1198 |  | GRID_SET | this.spdSummary.Sheets[0].ColumnHeader.Rows[0].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSpreadFooterSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c8f93c0 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1406 | if (iStCol < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2b4068d | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1408 |  | GRID_SET | this._weeklys[this._weeklyDivision].SpreadInfo.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-677910f8 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1409 |  | GRID_SET | this._weeklys[this._weeklyDivision].SpreadInfo.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-c9d5e5f5 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1419 | for (iCol <= this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxColumnIndex()) ▸ if (Array.IndexOf(weeklyNumericCols, tag) > -1) | GRID_SET | this._weeklys[this._weeklyDivision].SpreadInfo.ActiveSheet.ColumnFooter.Cells[0, iCol].Bac… | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-28581fae | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1420 | for (iCol <= this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxColumnIndex()) ▸ if (Array.IndexOf(weeklyNumericCols, tag) > -1) | GRID_SET | this._weeklys[this._weeklyDivision].SpreadInfo.ActiveSheet.ColumnFooter.Cells[0, iCol].Bor… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-8eb940b0 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1422 | for (iCol <= this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxColumnIndex()) ▸ if (Array.IndexOf(weeklyNumericCols, tag) > -1) | CALL_EXT | this._weeklys[this._weeklyDivision].SpreadInfo.ActiveSheet.ColumnFooter.SetAggregationForm… | (0, iCol, "{0:#,##0}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-49a42632 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1429 | for (iCol <= this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxColumnIndex()) ▸ if (Array.IndexOf(weeklyNumericCols, tag) > -1) ▸ if (tag… | CALL_EXT | this._weeklys[this._weeklyDivision].SpreadInfo.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.Custom) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53cbab17 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1464 | for (iCol <= this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxColumnIndex()) ▸ if (Array.IndexOf(weeklyNumericCols, tag) > -1) ▸ if (tag… | GRID_SET | this._weeklys[this._weeklyDivision].SpreadInfo.ActiveSheet.ColumnFooter.Cells[0, iCol].Val… | rate | 그리드 속성/값 설정 |  |  |  |
| AC-5a787aa8 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1476 | for (iCol <= this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxColumnIndex()) ▸ if (Array.IndexOf(weeklyNumericCols, tag) > -1) ▸ else of… | CALL_EXT | this._weeklys[this._weeklyDivision].SpreadInfo.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.Custom) | ⚠ 의미 확인 필요 |  |  |  |
| AC-08156804 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1482 | for (iCol <= this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxColumnIndex()) ▸ if (Array.IndexOf(weeklyNumericCols, tag) > -1) ▸ else of… | GRID_SET | this._weeklys[this._weeklyDivision].SpreadInfo.ActiveSheet.ColumnFooter.Cells[0, iCol].Val… | sumRESULT_WITH_RTF | 그리드 속성/값 설정 |  |  |  |
| AC-4e778fa7 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1486 | for (iCol <= this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxColumnIndex()) ▸ if (Array.IndexOf(weeklyNumericCols, tag) > -1) ▸ else of… | CALL_EXT | this._weeklys[this._weeklyDivision].SpreadInfo.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSpreadSummary

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged / btnSummaryColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba1cabab | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1122 |  | GRID_INIT | _siSummary.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-205f786c | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1123 |  | GRID_INIT | _siSummary.ChangeActiveSheet | (this.SHEET_NAME_SUMMARY) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSpreadWeekly

진입점: this.Load / cboWeeklyDivision.SelectedIndexChanged / btnWeeklyColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfd6930f | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1134 | try | GRID_CLEAR | _weeklys[this._weeklyDivision].ClearDataSource | () | 그리드 데이터/선택 비움 |  |  |  |
| AC-a23c9e96 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1136 | try | GRID_INIT | _weeklys[this._weeklyDivision].SetSheetHeaderColumn | () | 그리드 재구성/초기화 |  |  |  |
| AC-41f71aff | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1138 | try | CALL_EXT | _weeklys.ShowSpread | (this._weeklyDivision) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSummaryCategory

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged [try] / cboSummaryYear.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae4335b6 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:525 | if (this._summaryDivision.Equals("")) | FLAG | dtSummaryCategory | Data_SCP.Common(Data_SCP.Type.RTFGubun, false, "X") | 화면 필드/플래그 변경 |  |  |  |
| AC-4065ffeb | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:525 | if (this._summaryDivision.Equals("")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.RTFGubun, false, "X") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-05f16474 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:529 | else of (this._summaryDivision.Equals("")) | FLAG | dtSummaryCategory | Data_SCP.Common(Data_SCP.Type.RTFGubun, false, this._summaryDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-75d57dde | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:529 | else of (this._summaryDivision.Equals("")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.RTFGubun, false, this._summaryDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7fa77680 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:532 |  | LIST_REBIND | clsCtrl.setListBox | (dtSummaryCategory, cboSummaryCategory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSummaryDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b72da3b | this.Load | SCP0092_RTF_ArcheivementRate.cs:404 |  | FLAG | dtSummaryDivision | BLUtils.GetDivisionWithoutEE(false, "LG") | 화면 필드/플래그 변경 |  |  |  |
| AC-fe8cd686 | this.Load | SCP0092_RTF_ArcheivementRate.cs:404 |  | CALL_EXT | BLUtils.GetDivisionWithoutEE | (false, "LG") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSummaryEndCustomer

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged [try] / clbSummaryTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a325b91 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:611 | if ((this._summaryDivision == "81") \|\| (this._summaryDivision == "82")) | FLAG | dtSummaryCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0cfd70f4 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:611 | if ((this._summaryDivision == "81") \|\| (this._summaryDivision == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._summaryDivis… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dc1329b1 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:612 | if ((this._summaryDivision == "81") \|\| (this._summaryDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSummaryCustomer, clbSummaryCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6353b496 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:616 | else of ((this._summaryDivision == "81") \|\| (this._summaryDivision == "82")) | FLAG | dtSummaryCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, this._summaryDivision, this._summary… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-dd8a56c9 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:616 | else of ((this._summaryDivision == "81") \|\| (this._summaryDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, this._summaryDivision, this._summaryTeam, UserI… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9b303ee5 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:617 | else of ((this._summaryDivision == "81") \|\| (this._summaryDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSummaryCustomer, clbSummaryCustomer, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSummaryFcstType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1acd16d | this.Load | SCP0092_RTF_ArcheivementRate.cs:663 |  | FLAG | dtSummaryFcstType | GetFcstType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e79eeeef | this.Load | SCP0092_RTF_ArcheivementRate.cs:664 |  | LIST_REBIND | clsCtrl.setListBox | (dtSummaryFcstType, clbSummaryFcstType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSummaryItemType

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72fbb622 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:684 | if (this._summaryDivision.Equals("81")) | FLAG | dtSummaryItemType | GetItemType().AsEnumerable().Where(r => r.Field<string>("CODE").Equals("P")).CopyToDataTab… | 화면 필드/플래그 변경 |  |  |  |
| AC-c9355fdb | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:684 | if (this._summaryDivision.Equals("81")) | DATA_OP | GetItemType().AsEnumerable().Where(r => r.Field<string>("CODE").Equals("P")).CopyToDataTab… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a7005b08 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:684 | if (this._summaryDivision.Equals("81")) ▸ lambda | DATA_OP | r.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5ec57a8 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:688 | else of (this._summaryDivision.Equals("81")) | FLAG | dtSummaryItemType | GetItemType().AsEnumerable().Where(r => r.Field<string>("CODE").Equals("P") \|\| r.Field<s… | 화면 필드/플래그 변경 |  |  |  |
| AC-90bab660 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:688 | else of (this._summaryDivision.Equals("81")) | DATA_OP | GetItemType().AsEnumerable().Where(r => r.Field<string>("CODE").Equals("P") \|\| r.Field<s… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b1f1fc82 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:688 | else of (this._summaryDivision.Equals("81")) ▸ lambda | DATA_OP | r.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0eaa31ad | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:688 | else of (this._summaryDivision.Equals("81")) ▸ lambda | DATA_OP | r.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e58791c | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:691 |  | LIST_REBIND | clsCtrl.setListBox | (dtSummaryItemType, clbSummaryItemType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSummaryOperationGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f894e85c | this.Load | SCP0092_RTF_ArcheivementRate.cs:651 |  | FLAG | dtSummaryOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-abd975e7 | this.Load | SCP0092_RTF_ArcheivementRate.cs:651 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8362f9a6 | this.Load | SCP0092_RTF_ArcheivementRate.cs:652 |  | LIST_REBIND | clsCtrl.setListBox | (dtSummaryOperationGroup, clbSummaryOperationGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSummaryQty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c980a16a | this.Load | SCP0092_RTF_ArcheivementRate.cs:555 |  | FLAG | dtSummaryQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-4087b329 | this.Load | SCP0092_RTF_ArcheivementRate.cs:556 |  | LIST_REBIND | clsCtrl.setListBox | (dtSummaryQty, cboSummaryQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSummaryTeam

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c191fa5 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:576 | if (this._weeklyDivision.Equals("81")) | FLAG | dtSummaryTeam | Data_SCP.Common(Data_SCP.Type.SCMTeambyDivision, false, this._summaryDivision, UserInfoCon… | 화면 필드/플래그 변경 |  |  |  |
| AC-16a27b80 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:576 | if (this._weeklyDivision.Equals("81")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SCMTeambyDivision, false, this._summaryDivision, UserInfoContext.Current.Us… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f9026025 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:580 | else of (this._weeklyDivision.Equals("81")) | FLAG | dtSummaryTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-65cf6a51 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:580 | else of (this._weeklyDivision.Equals("81")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._summaryDivis… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ba1b09b8 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:583 |  | LIST_REBIND | clsCtrl.setListBox | (dtSummaryTeam, clbSummaryTeam, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSummaryWeekAll

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f301067a | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:415 |  | FLAG | dtSummaryWeekAll | Data_SCP.Common(Data_SCP.Type.RTFWeek, false, this._summaryDivision, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-da7f08b2 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:415 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.RTFWeek, false, this._summaryDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitSummaryYear

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71152285 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:469 |  | FLAG | dtSummaryYear | GetYearTable(dtSummaryWeekAll) | 화면 필드/플래그 변경 |  |  |  |
| AC-2b4dd17c | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:471 |  | LIST_REBIND | clsCtrl.setListBox | (dtSummaryYear, cboSummaryYear, false, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |
| AC-32d93f2e | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:475 | if (this.cboSummaryYear.Items.Count > 0) | VALUE_SET | this.cboSummaryYear.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitWeeklyDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c3da8c6 | this.Load | SCP0092_RTF_ArcheivementRate.cs:398 |  | FLAG | dtWeeklyDivision | BLUtils.GetDivisionWithoutEE(false, "LG") | 화면 필드/플래그 변경 |  |  |  |
| AC-982c5d76 | this.Load | SCP0092_RTF_ArcheivementRate.cs:398 |  | CALL_EXT | BLUtils.GetDivisionWithoutEE | (false, "LG") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitWeeklyEndCustomer

진입점: this.Load / cboWeeklyDivision.SelectedIndexChanged [try] / cboWeeklyWeek.SelectedIndexChanged [try] / clbWeeklyTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8f3dbc2 | this.Load 외 3 | SCP0092_RTF_ArcheivementRate.cs:591 | if (this._weeklyDivision == "82") | FLAG | dtWeeklyCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-2317dd2d | this.Load 외 3 | SCP0092_RTF_ArcheivementRate.cs:591 | if (this._weeklyDivision == "82") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._weeklyDivisi… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e3595d9 | this.Load 외 3 | SCP0092_RTF_ArcheivementRate.cs:592 | if (this._weeklyDivision == "82") | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyCustomer, clbWeeklyCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-af3435d7 | this.Load 외 3 | SCP0092_RTF_ArcheivementRate.cs:596 | else of (this._weeklyDivision == "82") ▸ if (this._weeklyDivision == "81") | FLAG | dtWeeklyCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-041218c5 | this.Load 외 3 | SCP0092_RTF_ArcheivementRate.cs:596 | else of (this._weeklyDivision == "82") ▸ if (this._weeklyDivision == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._weeklyDivisi… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-038491f2 | this.Load 외 3 | SCP0092_RTF_ArcheivementRate.cs:597 | else of (this._weeklyDivision == "82") ▸ if (this._weeklyDivision == "81") | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyCustomer, clbWeeklyCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-748bcd0c | this.Load 외 3 | SCP0092_RTF_ArcheivementRate.cs:601 | else of (this._weeklyDivision == "82") ▸ else of (this._weeklyDivision == "81") | FLAG | dtWeeklyCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, this._weeklyDivision, this._weeklyTe… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-1bea2ffb | this.Load 외 3 | SCP0092_RTF_ArcheivementRate.cs:601 | else of (this._weeklyDivision == "82") ▸ else of (this._weeklyDivision == "81") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, this._weeklyDivision, this._weeklyTeam, UserInf… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d8b8321 | this.Load 외 3 | SCP0092_RTF_ArcheivementRate.cs:602 | else of (this._weeklyDivision == "82") ▸ else of (this._weeklyDivision == "81") | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyCustomer, clbWeeklyCustomer, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitWeeklyFcstType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-847d1149 | this.Load | SCP0092_RTF_ArcheivementRate.cs:657 |  | FLAG | dtWeeklyFcstType | GetFcstType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9f0886f0 | this.Load | SCP0092_RTF_ArcheivementRate.cs:658 |  | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyFcstType, clbWeeklyFcstType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitWeeklyItemType

진입점: this.Load / cboWeeklyDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ac36d00 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:671 | if (this._weeklyDivision.Equals("81")) | FLAG | dtWeeklyItemType | GetItemType().AsEnumerable().Where(r => r.Field<string>("CODE").Equals("P")).CopyToDataTab… | 화면 필드/플래그 변경 |  |  |  |
| AC-f47e093d | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:671 | if (this._weeklyDivision.Equals("81")) | DATA_OP | GetItemType().AsEnumerable().Where(r => r.Field<string>("CODE").Equals("P")).CopyToDataTab… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9bbcbdb8 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:671 | if (this._weeklyDivision.Equals("81")) ▸ lambda | DATA_OP | r.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7510b9e1 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:675 | else of (this._weeklyDivision.Equals("81")) | FLAG | dtWeeklyItemType | GetItemType().AsEnumerable().Where(r => r.Field<string>("CODE").Equals("P") \|\| r.Field<s… | 화면 필드/플래그 변경 |  |  |  |
| AC-5b6ef01f | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:675 | else of (this._weeklyDivision.Equals("81")) | DATA_OP | GetItemType().AsEnumerable().Where(r => r.Field<string>("CODE").Equals("P") \|\| r.Field<s… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7596ae1f | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:675 | else of (this._weeklyDivision.Equals("81")) ▸ lambda | DATA_OP | r.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9143ad6 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:675 | else of (this._weeklyDivision.Equals("81")) ▸ lambda | DATA_OP | r.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-88bf8732 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:678 |  | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyItemType, clbWeeklyItemType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitWeeklyOperationGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d2fa693 | this.Load | SCP0092_RTF_ArcheivementRate.cs:645 |  | FLAG | dtWeeklyOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-87a81980 | this.Load | SCP0092_RTF_ArcheivementRate.cs:645 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e0c3a9a | this.Load | SCP0092_RTF_ArcheivementRate.cs:646 |  | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyOperationGroup, clbWeeklyOperationGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitWeeklyQty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-068fcf84 | this.Load | SCP0092_RTF_ArcheivementRate.cs:549 |  | FLAG | dtWeeklyQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-115297cd | this.Load | SCP0092_RTF_ArcheivementRate.cs:550 |  | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyQty, cboWeeklyQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitWeeklyTeam

진입점: this.Load / cboWeeklyDivision.SelectedIndexChanged [try] / cboWeeklyWeek.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0c77d07 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:563 | if (this._weeklyDivision.Equals("81")) | FLAG | dtWeeklyTeam | Data_SCP.Common(Data_SCP.Type.SCMTeambyDivision, false, this._weeklyDivision, UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-4a1d5e86 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:563 | if (this._weeklyDivision.Equals("81")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SCMTeambyDivision, false, this._weeklyDivision, UserInfoContext.Current.Use… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9499251c | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:567 | else of (this._weeklyDivision.Equals("81")) | FLAG | dtWeeklyTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-c09510aa | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:567 | else of (this._weeklyDivision.Equals("81")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._weeklyDivisi… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f9576fd8 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:570 |  | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyTeam, clbWeeklyTeam, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitWeeklyWeek

진입점: this.Load / cboWeeklyYear.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b0d8750 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:481 |  | DATA_OP | dtWeeklyWeekAll.Select | ("NAME LIKE '" + this._weeklyYear + "*'", "NAME DESC") | 데이터 객체 조작/조회 |  |  |  |
| AC-89685ab5 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:485 | if (rows.Length > 0) | FLAG | dtWeeklyWeek | rows.CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-f92d3b25 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:485 | if (rows.Length > 0) | DATA_OP | rows.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6f40cabf | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:489 | else of (rows.Length > 0) | GRID_CLEAR | dtWeeklyWeek.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-04b3643a | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:492 |  | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyWeek, cboWeeklyWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f12c1a64 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:496 | if (this.cboWeeklyWeek.Items.Count > 0) | VALUE_SET | this.cboWeeklyWeek.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitWeeklyWeekAll

진입점: this.Load / cboWeeklyDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef70f8e3 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:411 |  | FLAG | dtWeeklyWeekAll | Data_SCP.Common(Data_SCP.Type.RTFWeek, false, this._weeklyDivision, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-f1bbcd22 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:411 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.RTFWeek, false, this._weeklyDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0092_RTF_ArcheivementRate.InitWeeklyYear

진입점: this.Load / cboWeeklyDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e681a99 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:456 |  | FLAG | dtWeeklyYear | GetYearTable(dtWeeklyWeekAll) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ac6e335 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:458 |  | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyYear, cboWeeklyYear, false, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |
| AC-e43a8c78 | this.Load 외 1 | SCP0092_RTF_ArcheivementRate.cs:462 | if (this.cboWeeklyYear.Items.Count > 0) | VALUE_SET | this.cboWeeklyYear.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.IsPartialRight

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cead1e5 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1280 |  | RETURN | return s.Substring(s.Length - sub.Length, sub.Length).Equals(sub); |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.IsVisibleCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af025211 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1304 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0092_RTF_ArcheivementRate.MergeToOneTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c90dc79b | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1919 |  | CALL_EXT | this._rowCountSummarys.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-54bcb1ea | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1923 | if (this._rowCountSummarys.Count > 0) | CALL_EXT | this._rowCountSummarys.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a5163da | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1930 | if (this._dsSummary.Tables.Count > 0) ▸ for (i <= this._dsSummary.Tables.Count - 1) | STATE_RESET | this._dsSummary.Tables[i].Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-2928502d | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1933 | if (this._dsSummary.Tables.Count > 0) | STATE_RESET | this._dsSummary.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-82a4c92f | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1939 | if (ds.Tables.Count > 0) | DATA_OP | this._dsSummary.Tables.Add | (ds.Tables[0].Copy()) | 데이터 객체 조작/조회 |  |  |  |
| AC-891c42aa | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1939 | if (ds.Tables.Count > 0) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-02d1735e | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1941 | if (ds.Tables.Count > 0) | DATA_OP | this._rowCountSummarys.Add | (ds.Tables[0].Rows.Count) | 데이터 객체 조작/조회 |  |  |  |
| AC-07d9ceb0 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1948 | if (ds.Tables.Count > 1) ▸ for (i <= ds.Tables.Count - 1) | DATA_OP | this._dsSummary.Tables[0].Merge | (ds.Tables[i].Copy()) | 데이터 객체 조작/조회 |  |  |  |
| AC-076513f2 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1948 | if (ds.Tables.Count > 1) ▸ for (i <= ds.Tables.Count - 1) | DATA_OP | ds.Tables[i].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-23f40ea0 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1950 | if (ds.Tables.Count > 1) ▸ for (i <= ds.Tables.Count - 1) | DATA_OP | this._rowCountSummarys.Add | (ds.Tables[i].Rows.Count) | 데이터 객체 조작/조회 |  |  |  |

## SCP0092_RTF_ArcheivementRate.RefreshSummaryDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea17fa98 | this.Load | SCP0092_RTF_ArcheivementRate.cs:393 |  | LIST_REBIND | clsCtrl.setListBox | (dtSummaryDivision, cboSummaryDivision, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.RefreshWeeklyDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6e791d4 | this.Load | SCP0092_RTF_ArcheivementRate.cs:388 |  | LIST_REBIND | clsCtrl.setListBox | (dtWeeklyDivision, cboWeeklyDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.rgrpWeeklyIsPreWeek_SelectedIndexChanged

진입점: cboWeeklyWeek.SelectedIndexChanged [try] / rgrpWeeklyIsPreWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd2df5b9 | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3263 | if (this._planWeek.Length == 6) | VALUE_SET | this.txtWeeklyPlanPreWeek.Text | string.Format("{0}-W{1}", this._planWeek.Substring(0, 4), this._planWeek.Substring(4, 2)) | 컨트롤 값 설정 |  |  |  |
| AC-640ef5bf | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3267 | else of (this._planWeek.Length == 6) | VALUE_CLEAR | this.txtWeeklyPlanPreWeek.Text | "" | 컨트롤 값 비움 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetAmountCalculatingSummary

진입점: cboSummaryQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e2e34e7 | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2977 | if (_siSummary.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32b2fb42 | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2981 | if (this.dsOldSummary == null) | FLAG | this.dsOldSummary | (_siSummary.SpreadObject.DataSource as DataSet).Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-f30c9cb4 | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2981 | if (this.dsOldSummary == null) | DATA_OP | (_siSummary.SpreadObject.DataSource as DataSet).Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea47c453 | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2987 | if (cboSummaryQTY.SelectedIndex == 0) | LIST_BIND | _siSummary.SpreadObject.DataSource | dsOldSummary | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-83b27baa | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2988 | if (cboSummaryQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-629742ec | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2991 |  | DATA_OP | dsOldSummary.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fded9ea3 | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2993 |  | DATA_OP | dsNew.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b9ab07a3 | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2995 |  | CALL_EXT | UIUtils.GetQtyScale | (cboSummaryQTY) | ⚠ 의미 확인 필요 |  |  |  |
| AC-609b5e5f | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3017 | for (i <= dsOldSummary.Tables[0].Rows.Count - 1) ▸ for (j <= dsNew.Tables[0].Columns.Count - 1) ▸ if (dsNew.Tables[0].Columns[j].ColumnName.… | GRID_SET | dsNew.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(val) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-47092d9c | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3023 |  | DATA_OP | dsNew.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-49879141 | cboSummaryQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3033 |  | LIST_BIND | _siSummary.SpreadObject.DataSource | dsNew | 목록/그리드 데이터 원천 연결 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetAmountCalculatingWeekly

진입점: cboWeeklyQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86bd6fef | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3049 | if (this._weeklys[this._weeklyDivision].SpreadInfo.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-840f920f | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3053 | if (dsOldWeekly == null) | FLAG | dsOldWeekly | (this._weeklys[this._weeklyDivision].SpreadInfo.SpreadObject.DataSource as DataSet).Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6c0b8532 | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3053 | if (dsOldWeekly == null) | DATA_OP | (this._weeklys[this._weeklyDivision].SpreadInfo.SpreadObject.DataSource as DataSet).Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f14a8038 | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3059 | if (cboWeeklyQTY.SelectedIndex == 0) | LIST_BIND | this._weeklys[this._weeklyDivision].SpreadInfo.SpreadObject.DataSource | dsOldWeekly | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-84ec75ae | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3060 | if (cboWeeklyQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10f1edad | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3063 |  | DATA_OP | dsOldWeekly.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-78775104 | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3065 |  | DATA_OP | dsNew.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5ae8eb76 | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3067 |  | CALL_EXT | UIUtils.GetQtyScale | (cboWeeklyQTY) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1966f7f5 | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3083 | for (i < dsOldWeekly.Tables[0].Rows.Count - 1) ▸ for (j < dsNew.Tables[0].Columns.Count - 1) ▸ if (Array.IndexOf(weeklyNumericCols, dsNew.Ta… | GRID_SET | dsNew.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(val) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-5c8e3f37 | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3089 |  | DATA_OP | dsNew.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7e13c0a6 | cboWeeklyQTY.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:3099 |  | LIST_BIND | this._weeklys[this._weeklyDivision].SpreadInfo.SpreadObject.DataSource | dsNew | 목록/그리드 데이터 원천 연결 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetDefaultValues

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3b8447b | this.Load | SCP0092_RTF_ArcheivementRate.cs:362 | if (this.cboWeeklyYear.Items.Count > 0) | VALUE_SET | this.cboWeeklyYear.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e3e9a2d3 | this.Load | SCP0092_RTF_ArcheivementRate.cs:367 | if (this.cboWeeklyWeek.Items.Count > 0) | VALUE_SET | this.cboWeeklyWeek.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-a281d25b | this.Load | SCP0092_RTF_ArcheivementRate.cs:370 |  | VALUE_SET | rgrpWeeklyIsPreWeek.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-f5256a0e | this.Load | SCP0092_RTF_ArcheivementRate.cs:375 | if (this.cboSummaryCategory.Items.Count > 0) | VALUE_SET | this.cboSummaryCategory.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-930d3d42 | this.Load | SCP0092_RTF_ArcheivementRate.cs:378 |  | VALUE_SET | rgrpSummaryIsPreWeek.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-9ea1bb77 | this.Load | SCP0092_RTF_ArcheivementRate.cs:383 |  | UI_PROP | this.tbcSheet.SelectedTab | tabWeekly | 속성 SelectedTab 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetDefaultValuesDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06ce3b7d | this.Load | SCP0092_RTF_ArcheivementRate.cs:307 | if (cmb.Items.Count > 1) | CALL_EXT | UIUtils.GetIndexByCode | (cmb, "82") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa3355f2 | this.Load | SCP0092_RTF_ArcheivementRate.cs:314 | if (cmb.Items.Count > 1) | VALUE_SET | cmb.SelectedIndex | idx | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetPlanWeek

진입점: cboWeeklyWeek.SelectedIndexChanged [try] / rgrpWeeklyIsPreWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56b25a0f | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3232 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_TERM") ⇒ SCP.SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_TERM | 엔드포인트 요청 생성 |  |  |  |
| AC-56ee4893 | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3234 | try | DATA_OP | request.Parameters["p_division_id"] | this._weeklyDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fdfe1a0d | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3235 | try | DATA_OP | request.Parameters["p_week"] | this._weeklyWeek | 행/컬럼 값 대입 |  |  |  |
| AC-f0947309 | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3237 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f24dc4d8 | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3241 | try | FLAG | this._planPreWeek | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e7fef6e9 | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3242 | try | FLAG | this._planThisWeek | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a22e058a | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3246 | try ▸ if (dt.Rows.Count >= 1) | FLAG | this._planThisWeek | dt.Rows[0]["THIS_ISO_YYYYWW"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-51d8547c | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3247 | try ▸ if (dt.Rows.Count >= 1) | FLAG | this._planPreWeek | dt.Rows[0]["PRE_ISO_YYYYWW"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e74f030f | cboWeeklyWeek.SelectedIndexChanged [try] 외 1 | SCP0092_RTF_ArcheivementRate.cs:3251 | try | FLAG | this._planWeek | this._isWeeklyPreWeek.Equals("T") ? this._planPreWeek : this._planThisWeek | 화면 필드/플래그 변경 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetSheetColumnMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15fb044a | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1760 | for (i <= sv.Columns.Count - 1) | GRID_STYLE | sv.SetColumnMerge | (i, FarPoint.Win.Spread.Model.MergePolicy.None) | 그리드 표시 설정 |  |  |  |
| AC-6cda24b8 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1799 | if (idx != -1) | GRID_STYLE | sv.SetColumnMerge | (idx, FarPoint.Win.Spread.Model.MergePolicy.Always) | 그리드 표시 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetSheetColumnNumericFormat

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d70efd2d | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1377 |  | UI_PROP | numCellType.FixedPoint | false | 속성 FixedPoint 설정 |  |  |  |
| AC-901672a3 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1383 | for (i <= sv.Columns.Count - 1) ▸ if (sv.Columns[i].DataField.IndexOf("W_") == 0 \|\| sv.Columns[i].DataField.IndexOf("M_") == 0 \|\| sv.Col… | GRID_SET | sv.Columns[i].CellType | numCellType | 그리드 속성/값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetSpdTitleSummary

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged / btnSummaryColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd1026f0 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:2733 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK") ⇒ SCP.SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK | 엔드포인트 요청 생성 |  |  |  |
| AC-2e790bc1 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:2734 |  | DATA_OP | request.Parameters["p_year"] | this._summaryYear | 행/컬럼 값 대입 |  |  |  |
| AC-9c2e155f | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:2736 |  | FLAG | dtWeeklyTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-441edce7 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:2736 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetSpreadInitSummary

진입점: this.Load / cboSummaryDivision.SelectedIndexChanged / btnSummaryColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2859aa8 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1327 |  | GRID_INIT | si.SetSheetHeaderColumn | (si, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-0cca0b29 | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1330 |  | FLAG | _idxDataSummary | si.GetMaxColumnIndex() + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-372070ca | this.Load 외 2 | SCP0092_RTF_ArcheivementRate.cs:1331 |  | UI_PROP | si.nIdxData | _idxDataSummary | 속성 nIdxData 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetSpreadInitWeekly

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-630bab63 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:1360 |  | GRID_INIT | si.SetSheetHeaderColumn | (si, 2) | 그리드 재구성/초기화 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetSummaryQtyUnit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-898c1143 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3220 |  | VALUE_SET | cboSummaryQTY.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetSummaryVisibleControlCategory

진입점: cboSummaryDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-589fd17d | cboSummaryDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2199 | if (this._summaryDivision.Equals("82")) | UI_PROP | this.lciSummaryCategory.ContentVisible | true | 속성 ContentVisible 설정 |  |  |  |
| AC-4a1380a1 | cboSummaryDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2203 | else of (this._summaryDivision.Equals("82")) | UI_PROP | this.lciSummaryCategory.ContentVisible | false | 속성 ContentVisible 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetSummaryVisibleControlOwner

진입점: cboSummaryDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f277b416 | cboSummaryDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2178 | if (this._summaryDivision.Equals("81") \|\| this._summaryDivision.Equals("40") \|\| this._summaryDivision.Equals("ALL") \|\| this.…) | UI_PROP | this.lciSummaryOwner.ContentVisible | true | 속성 ContentVisible 설정 |  |  |  |
| AC-e932291d | cboSummaryDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2179 | if (this._summaryDivision.Equals("81") \|\| this._summaryDivision.Equals("40") \|\| this._summaryDivision.Equals("ALL") \|\| this.…) | UI_PROP | this.lciSummaryOwnerButton.ContentVisible | true | 속성 ContentVisible 설정 |  |  |  |
| AC-7d0eba2e | cboSummaryDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2183 | else of (this._summaryDivision.Equals("81") \|\| this._summaryDivision.Equals("40") \|\| this._summaryDivision.Equals("ALL") \|\| this.…) | UI_PROP | this.lciSummaryOwner.ContentVisible | false | 속성 ContentVisible 설정 |  |  |  |
| AC-a6d85c30 | cboSummaryDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2184 | else of (this._summaryDivision.Equals("81") \|\| this._summaryDivision.Equals("40") \|\| this._summaryDivision.Equals("ALL") \|\| this.…) | UI_PROP | this.lciSummaryOwnerButton.ContentVisible | false | 속성 ContentVisible 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetSummaryVisibleControlProject

진입점: cboSummaryDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e23b249 | cboSummaryDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2164 | if (this._summaryDivision.Equals("40")) | UI_PROP | lciSummaryProject.ContentVisible | false | 속성 ContentVisible 설정 |  |  |  |
| AC-15dd3df7 | cboSummaryDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2165 | if (this._summaryDivision.Equals("40")) | UI_PROP | lciSummaryProjectButton.ContentVisible | false | 속성 ContentVisible 설정 |  |  |  |
| AC-35d80d69 | cboSummaryDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2169 | else of (this._summaryDivision.Equals("40")) | UI_PROP | lciSummaryProject.ContentVisible | true | 속성 ContentVisible 설정 |  |  |  |
| AC-9fa0bb26 | cboSummaryDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2170 | else of (this._summaryDivision.Equals("40")) | UI_PROP | lciSummaryProjectButton.ContentVisible | true | 속성 ContentVisible 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetWeeklyQtyUnit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a556c46 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3215 |  | VALUE_SET | cboWeeklyQTY.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetWeeklyVisibleControlOwner

진입점: cboWeeklyDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7287fac | cboWeeklyDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2150 | if (this._weeklyDivision.Equals("81") \|\| this._weeklyDivision.Equals("40")) | UI_PROP | lciWeeklyOwner.ContentVisible | true | 속성 ContentVisible 설정 |  |  |  |
| AC-0dabb4d7 | cboWeeklyDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2151 | if (this._weeklyDivision.Equals("81") \|\| this._weeklyDivision.Equals("40")) | UI_PROP | lciWeeklyOwnerButton.ContentVisible | true | 속성 ContentVisible 설정 |  |  |  |
| AC-cd0b169e | cboWeeklyDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2155 | else of (this._weeklyDivision.Equals("81") \|\| this._weeklyDivision.Equals("40")) | UI_PROP | lciWeeklyOwner.ContentVisible | false | 속성 ContentVisible 설정 |  |  |  |
| AC-ffc711e3 | cboWeeklyDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2156 | else of (this._weeklyDivision.Equals("81") \|\| this._weeklyDivision.Equals("40")) | UI_PROP | lciWeeklyOwnerButton.ContentVisible | false | 속성 ContentVisible 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.SetWeeklyVisibleControlProject

진입점: cboWeeklyDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7a3df3c | cboWeeklyDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2136 | if (this._weeklyDivision.Equals("40")) | UI_PROP | lciWeeklyProject.ContentVisible | false | 속성 ContentVisible 설정 |  |  |  |
| AC-32e696a3 | cboWeeklyDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2137 | if (this._weeklyDivision.Equals("40")) | UI_PROP | lciWeeklyProjectButton.ContentVisible | false | 속성 ContentVisible 설정 |  |  |  |
| AC-9afe27f1 | cboWeeklyDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2141 | else of (this._weeklyDivision.Equals("40")) | UI_PROP | lciWeeklyProject.ContentVisible | true | 속성 ContentVisible 설정 |  |  |  |
| AC-287f2eed | cboWeeklyDivision.SelectedIndexChanged | SCP0092_RTF_ArcheivementRate.cs:2142 | else of (this._weeklyDivision.Equals("40")) | UI_PROP | lciWeeklyProjectButton.ContentVisible | true | 속성 ContentVisible 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.ShowSummaryOwnerESS

진입점: btnSummaryOwner.Click [else of (this._summaryDivision.Equals("81") \|\| this._summaryDivision.Equals("40"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0ec80d9 | btnSummaryOwner.Click [else of (this._summaryDivision.Equals… | SCP0092_RTF_ArcheivementRate.cs:2889 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ee96484c | btnSummaryOwner.Click [else of (this._summaryDivision.Equals… | SCP0092_RTF_ArcheivementRate.cs:2892 |  | POPUP | pop.Form_Load | (true, this._summaryDivision, this._summaryTeam, this._summaryEndCustomer, "", this._summa… | 팝업 초기화(인자 전달) |  |  |  |
| AC-f0f93bba | btnSummaryOwner.Click [else of (this._summaryDivision.Equals… | SCP0092_RTF_ArcheivementRate.cs:2893 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-701451e2 | btnSummaryOwner.Click [else of (this._summaryDivision.Equals… | SCP0092_RTF_ArcheivementRate.cs:2894 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-590baccc | btnSummaryOwner.Click [else of (this._summaryDivision.Equals… | SCP0092_RTF_ArcheivementRate.cs:2896 |  | VALUE_SET | txtSummaryOwner.Text | pop.OwnerID | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.ShowSummaryOwnerEtc

진입점: btnSummaryOwner.Click [if (this._summaryDivision.Equals("81") \|\| this._summaryDivision.Equals("40"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c59c1c3a | btnSummaryOwner.Click [if (this._summaryDivision.Equals("81"… | SCP0092_RTF_ArcheivementRate.cs:2917 |  | POPUP | new SCP0092_PICPopup | () | 팝업/폼 생성 |  |  |  |
| AC-04b6a4c8 | btnSummaryOwner.Click [if (this._summaryDivision.Equals("81"… | SCP0092_RTF_ArcheivementRate.cs:2918 |  | UI_PROP | pop.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-67eb7d88 | btnSummaryOwner.Click [if (this._summaryDivision.Equals("81"… | SCP0092_RTF_ArcheivementRate.cs:2919 |  | UI_PROP | pop.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-ccb0c860 | btnSummaryOwner.Click [if (this._summaryDivision.Equals("81"… | SCP0092_RTF_ArcheivementRate.cs:2920 |  | UI_PROP | pop.Division | this._summaryDivision | 속성 Division 설정 |  |  |  |
| AC-82dc4e1b | btnSummaryOwner.Click [if (this._summaryDivision.Equals("81"… | SCP0092_RTF_ArcheivementRate.cs:2921 |  | UI_PROP | pop.ItemId | this._summaryItemId | 속성 ItemId 설정 |  |  |  |
| AC-e533c63f | btnSummaryOwner.Click [if (this._summaryDivision.Equals("81"… | SCP0092_RTF_ArcheivementRate.cs:2922 |  | UI_PROP | pop.User | this._summaryOwner | 속성 User 설정 |  |  |  |
| AC-a9c9bae7 | btnSummaryOwner.Click [if (this._summaryDivision.Equals("81"… | SCP0092_RTF_ArcheivementRate.cs:2924 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6b4a9b34 | btnSummaryOwner.Click [if (this._summaryDivision.Equals("81"… | SCP0092_RTF_ArcheivementRate.cs:2928 | if (pop.ShowDialog() == DialogResult.OK) ▸ if (pop.SelectedUserInfoList.Count > 0) | VALUE_SET | txtSummaryOwner.Text | pop.SelectedUserInfoList[0].USER_ID | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.ShowWeeklyOwnerESS

진입점: btnWeeklyOwner.Click [else of (this._weeklyDivision.Equals("81") \|\| this._weeklyDivision.Equals("40"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e31b5a1 | btnWeeklyOwner.Click [else of (this._weeklyDivision.Equals("… | SCP0092_RTF_ArcheivementRate.cs:2878 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c0e8a194 | btnWeeklyOwner.Click [else of (this._weeklyDivision.Equals("… | SCP0092_RTF_ArcheivementRate.cs:2881 |  | POPUP | pop.Form_Load | (true, this._weeklyDivision, this._weeklyTeam, this._weeklyEndCustomer, "", this._weeklyPr… | 팝업 초기화(인자 전달) |  |  |  |
| AC-abafde7d | btnWeeklyOwner.Click [else of (this._weeklyDivision.Equals("… | SCP0092_RTF_ArcheivementRate.cs:2882 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9504c786 | btnWeeklyOwner.Click [else of (this._weeklyDivision.Equals("… | SCP0092_RTF_ArcheivementRate.cs:2883 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f678d16a | btnWeeklyOwner.Click [else of (this._weeklyDivision.Equals("… | SCP0092_RTF_ArcheivementRate.cs:2885 |  | VALUE_SET | txtWeeklyOwner.Text | pop.OwnerID | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.ShowWeeklyOwnerEtc

진입점: btnWeeklyOwner.Click [if (this._weeklyDivision.Equals("81") \|\| this._weeklyDivision.Equals("40"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7c9eaff | btnWeeklyOwner.Click [if (this._weeklyDivision.Equals("81") … | SCP0092_RTF_ArcheivementRate.cs:2900 |  | POPUP | new SCP0092_PICPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6bb3325f | btnWeeklyOwner.Click [if (this._weeklyDivision.Equals("81") … | SCP0092_RTF_ArcheivementRate.cs:2901 |  | UI_PROP | pop.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8050e587 | btnWeeklyOwner.Click [if (this._weeklyDivision.Equals("81") … | SCP0092_RTF_ArcheivementRate.cs:2902 |  | UI_PROP | pop.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-5649f2d5 | btnWeeklyOwner.Click [if (this._weeklyDivision.Equals("81") … | SCP0092_RTF_ArcheivementRate.cs:2903 |  | UI_PROP | pop.Division | this._weeklyDivision | 속성 Division 설정 |  |  |  |
| AC-581a264f | btnWeeklyOwner.Click [if (this._weeklyDivision.Equals("81") … | SCP0092_RTF_ArcheivementRate.cs:2904 |  | UI_PROP | pop.ItemId | this._weeklyItemId | 속성 ItemId 설정 |  |  |  |
| AC-0ed8e9cf | btnWeeklyOwner.Click [if (this._weeklyDivision.Equals("81") … | SCP0092_RTF_ArcheivementRate.cs:2905 |  | UI_PROP | pop.User | this._weeklyOwner | 속성 User 설정 |  |  |  |
| AC-bf970869 | btnWeeklyOwner.Click [if (this._weeklyDivision.Equals("81") … | SCP0092_RTF_ArcheivementRate.cs:2907 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-558693de | btnWeeklyOwner.Click [if (this._weeklyDivision.Equals("81") … | SCP0092_RTF_ArcheivementRate.cs:2911 | if (pop.ShowDialog() == DialogResult.OK) ▸ if (pop.SelectedUserInfoList.Count > 0) | VALUE_SET | txtWeeklyOwner.Text | pop.SelectedUserInfoList[0].USER_ID | 컨트롤 값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.spdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc0792da | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2395 | if (e.ColumnHeader) ▸ if (_siSummary.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= _siSummary.GetMaxColumnIndex()) ▸ if (_siSumm… | GRID_SET | _siSummary.ActiveSheet.Columns[iCol].Visible | !_siSummary.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-797b14cc | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2410 | if (e.ColumnHeader) ▸ if (_siSummary.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= _siSummary.GetMaxColumnIndex()) ▸ else of (_s… | GRID_SET | _siSummary.ActiveSheet.Columns[iCol].Visible | !_siSummary.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |

## SCP0092_RTF_ArcheivementRate.spdMain_KeyUp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d4549f3 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2448 | if (_siSummary.GetColumnIndex("QTY_TYPE") >= _siSummary.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4168bc18 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2452 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdSummary.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0d15285c | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2458 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1852f51 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2459 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdSummary.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0092_RTF_ArcheivementRate.spdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90283eb8 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:2441 |  | GRID_INIT | _siSummary.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0092_RTF_ArcheivementRate.spdSummary_CellDoubleClick

진입점: spdSummary.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddab7c6d | spdSummary.CellDoubleClick | SCP0092_RTF_ArcheivementRate.cs:3199 | if (e.ColumnHeader) ▸ if (!colName.Substring(0, 2).Equals("M_") && !isAllColumn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## WeeklySheet..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eed2c28f | .ctor | SCP0092_RTF_ArcheivementRate.cs:3419 |  | FLAG | this._ownerControl | ownerControl | 화면 필드/플래그 변경 |  |  |  |
| AC-4f4f1965 | .ctor | SCP0092_RTF_ArcheivementRate.cs:3420 |  | FLAG | this._tabControl | tabControl | 화면 필드/플래그 변경 |  |  |  |
| AC-cc04c830 | .ctor | SCP0092_RTF_ArcheivementRate.cs:3421 |  | FLAG | this._pnl | pnl | 화면 필드/플래그 변경 |  |  |  |
| AC-00ae9488 | .ctor | SCP0092_RTF_ArcheivementRate.cs:3422 |  | FLAG | this._spread | spread | 화면 필드/플래그 변경 |  |  |  |
| AC-4993d478 | .ctor | SCP0092_RTF_ArcheivementRate.cs:3423 |  | FLAG | this._divisionId | divisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-52becd5d | .ctor | SCP0092_RTF_ArcheivementRate.cs:3425 |  | GRID_INIT | this._ownerControl.AddSheet | (spread, this.SheetName, this.SheetName, 2, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7667bb91 | .ctor | SCP0092_RTF_ArcheivementRate.cs:3427 |  | FLAG | this.SpreadInfo | ownerControl.GetSheetInfo(spread.Name, spread.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-88ce5fbc | .ctor | SCP0092_RTF_ArcheivementRate.cs:3429 |  | GRID_INIT | this.SpreadInfo.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## WeeklySheet.ClearDataSource

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e614937d | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3435 | if (this._spread.Sheets[0].DataSource != null) | GRID_SET | this._spread.Sheets[0].DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-18802bb3 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3438 | if (this._spread.Sheets[0].Columns.Count > 0) | CALL_EXT | this._spread.Sheets[0].Columns.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba189b3c | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3441 | if (this._spread.Sheets[0].Rows.Count > 0) | GRID_CLEAR | this._spread.Sheets[0].Rows.Clear | () | 그리드 행 비움 |  |  |  |

## WeeklySheet.SetSheetHeaderColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfb1039e | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3446 |  | GRID_INIT | this._spreadInfo.SetSheetHeaderColumn | (this._spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-69d925db | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3448 |  | GRID_INIT | this._spreadInfo.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-167b81d8 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3449 |  | GRID_INIT | this._spreadInfo.ChangeActiveSheet | (this.SheetName) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## WeeklySheetsType.HideAllSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e97d2a0c | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3277 |  | STATE | this["81"].Spread.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-018c560a | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3278 |  | STATE | this["82"].Spread.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-17544727 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3279 |  | STATE | this["40"].Spread.Visible | false | 컨트롤 상태 Visible |  |  |  |

## WeeklySheetsType.ShowSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2a909b7 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3295 | switch (divisionId) case "81": | STATE | this["81"].Spread.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-f29bb423 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3296 | switch (divisionId) case "81": | STATE | this["82"].Spread.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f9b97a8b | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3297 | switch (divisionId) case "81": | STATE | this["40"].Spread.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-9886a94b | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3305 | switch (divisionId) case "40": | STATE | this["81"].Spread.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-988be08e | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3306 | switch (divisionId) case "40": | STATE | this["82"].Spread.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-cca0dff3 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3307 | switch (divisionId) case "40": | STATE | this["40"].Spread.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-24297ab1 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3315 | switch (divisionId) default: | STATE | this["81"].Spread.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-870167e0 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3316 | switch (divisionId) default: | STATE | this["82"].Spread.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-43c4ba97 | (진입점 미연결) | SCP0092_RTF_ArcheivementRate.cs:3317 | switch (divisionId) default: | STATE | this["40"].Spread.Visible | false | 컨트롤 상태 Visible |  |  |  |

