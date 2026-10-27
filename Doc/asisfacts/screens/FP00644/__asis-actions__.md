# AS-IS 액션 대조표 — FP00644

> 원천: `Doc/asisfacts/screens/FP00644/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 191행 · 메서드 32 · 종류 FLAG 41 · RETURN 29 · UI_PROP 17 · GRID_STYLE 13 · GRID_INIT 11 · DATA_OP 10 · CALL_EXT 8 · GRID_SET 7 · POPUP 6 · UI_MISC 6 · GRID_LOCK 6 · MESSAGE 6 · COMBO_DATA 6 · LIST_REBIND 6 · STATE 4 · ENDPOINT 4 · VALIDATE 4 · THROW 3 · GRID_BIND 2 · EXCEL 1 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 8


## clsFP00644_Search_Cond.Clear

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7337fd70 | (진입점 미연결) | FP00644_Group_Cell_Mgmt.cs:1255 |  | FLAG | this.COMPANY_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-20f7ee81 | (진입점 미연결) | FP00644_Group_Cell_Mgmt.cs:1256 |  | FLAG | this.DIVISION_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-20b62b8b | (진입점 미연결) | FP00644_Group_Cell_Mgmt.cs:1257 |  | FLAG | this.SITE_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-ad2da3ae | (진입점 미연결) | FP00644_Group_Cell_Mgmt.cs:1258 |  | FLAG | this.PLANT_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-6af6873e | (진입점 미연결) | FP00644_Group_Cell_Mgmt.cs:1259 |  | FLAG | this.GROUP_CELL_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-99314c09 | (진입점 미연결) | FP00644_Group_Cell_Mgmt.cs:1260 |  | FLAG | this.EXCEL_VIEW | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## FP00644_Group_Cell_Mgmt.btnSearchAll_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90df3181 | (진입점 미연결) | FP00644_Group_Cell_Mgmt.cs:1223 |  | CALL_EXT | _search.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00644_Group_Cell_Mgmt.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef7bb62c | this.btnSql.Click | FP00644_Group_Cell_Mgmt.cs:530 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b9ace997 | this.btnSql.Click | FP00644_Group_Cell_Mgmt.cs:531 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fdbbd550 | this.btnSql.Click | FP00644_Group_Cell_Mgmt.cs:533 |  | DATA_OP | popSql.Services.Add | ("SELECT_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae2589da | this.btnSql.Click | FP00644_Group_Cell_Mgmt.cs:534 |  | DATA_OP | popSql.Services.Add | ("SELECT_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-af3fe185 | this.btnSql.Click | FP00644_Group_Cell_Mgmt.cs:535 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00644_Group_Cell_Mgmt.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d28b657 | this.Load | FP00644_Group_Cell_Mgmt.cs:286 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-081d25bd | this.Load | FP00644_Group_Cell_Mgmt.cs:287 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-84273d56 | this.Load | FP00644_Group_Cell_Mgmt.cs:291 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5ead1017 | this.Load | FP00644_Group_Cell_Mgmt.cs:292 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-4e05c715 | this.Load | FP00644_Group_Cell_Mgmt.cs:294 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c7c7c5d | this.Load | FP00644_Group_Cell_Mgmt.cs:297 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00644_Group_Cell_Mgmt.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad9679c5 | this.Load | FP00644_Group_Cell_Mgmt.cs:172 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-f44000d1 | this.Load | FP00644_Group_Cell_Mgmt.cs:174 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-69cc2bbf | this.Load | FP00644_Group_Cell_Mgmt.cs:175 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-06a7badf | this.Load | FP00644_Group_Cell_Mgmt.cs:176 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-67aa93ea | this.Load | FP00644_Group_Cell_Mgmt.cs:181 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e02fa60b | this.Load | FP00644_Group_Cell_Mgmt.cs:182 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-d2420578 | this.Load | FP00644_Group_Cell_Mgmt.cs:183 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-91ffb7ae | this.Load | FP00644_Group_Cell_Mgmt.cs:187 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ae43b6a3 | this.Load | FP00644_Group_Cell_Mgmt.cs:188 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-4c5bf819 | this.Load | FP00644_Group_Cell_Mgmt.cs:189 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00644_Group_Cell_Mgmt.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e067e24 | DeleteButton | FP00644_Group_Cell_Mgmt.cs:514 |  | RETURN | return ; |  | 처리 중단/반환 |  |  |  |

## FP00644_Group_Cell_Mgmt.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41a053b1 | Dispose | FP00644_Group_Cell_Mgmt.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00644_Group_Cell_Mgmt.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcc1d711 | EditButton | FP00644_Group_Cell_Mgmt.cs:374 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e8e1430 | EditButton | FP00644_Group_Cell_Mgmt.cs:380 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-551f1873 | EditButton | FP00644_Group_Cell_Mgmt.cs:383 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-eb37d4df | EditButton | FP00644_Group_Cell_Mgmt.cs:388 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.PLANT_ID),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-48ae8f25 | EditButton | FP00644_Group_Cell_Mgmt.cs:389 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.GROUP_CELL_NAME), siMain.GetColumnIndex(DefColumns.BASIS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4afbb7ae | EditButton | FP00644_Group_Cell_Mgmt.cs:390 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CELL_ID), siMain.GetColumnIndex(DefColumns.UPDATE_TIME),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-80354a49 | EditButton | FP00644_Group_Cell_Mgmt.cs:398 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1849fabd | EditButton | FP00644_Group_Cell_Mgmt.cs:403 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEd… | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-973b3721 | EditButton | FP00644_Group_Cell_Mgmt.cs:408 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEd… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-e9f23b0d | EditButton | FP00644_Group_Cell_Mgmt.cs:412 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEd… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-214ed6cb | EditButton | FP00644_Group_Cell_Mgmt.cs:421 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor2 | (i, siMain.GetColumnIndex(DefColumns.GROUP_CELL_ID), i, siMain.GetColumnIndex(DefColumns.G… | 그리드 표시 설정 |  |  |  |
| AC-61b9da43 | EditButton | FP00644_Group_Cell_Mgmt.cs:422 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor2 | (i, siMain.GetColumnIndex(DefColumns.USE_FLAG), i, siMain.GetColumnIndex(DefColumns.USE_FL… | 그리드 표시 설정 |  |  |  |
| AC-555ae3bc | EditButton | FP00644_Group_Cell_Mgmt.cs:426 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor2 | (i, siMain.GetColumnIndex(DefColumns.GROUP_CELL_ID), i, siMain.GetColumnIndex(DefColumns.G… | 그리드 표시 설정 |  |  |  |
| AC-0fc7ea12 | EditButton | FP00644_Group_Cell_Mgmt.cs:427 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor2 | (i, siMain.GetColumnIndex(DefColumns.USE_FLAG), i, siMain.GetColumnIndex(DefColumns.USE_FL… | 그리드 표시 설정 |  |  |  |
| AC-53c96d5d | EditButton | FP00644_Group_Cell_Mgmt.cs:434 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor2 | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(245, 245, 245)) | 그리드 표시 설정 |  |  |  |
| AC-d32c6c0c | EditButton | FP00644_Group_Cell_Mgmt.cs:439 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor2 | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(255, 255, 255)) | 그리드 표시 설정 |  |  |  |

## FP00644_Group_Cell_Mgmt.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb51dc40 | ExcelButton | FP00644_Group_Cell_Mgmt.cs:546 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00644_Group_Cell_Mgmt.Find_Data_Main

진입점: popSql.OnSql [if (programID == "SELECT_MAIN")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c71a1a7a | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP00644_Group_Cell_Mgmt.cs:699 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00644_GROUP_CELL_MGMT", Filter, p_sys_type, p_sys_flag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-42bb8f3c | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP00644_Group_Cell_Mgmt.cs:704 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-6cb8f466 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP00644_Group_Cell_Mgmt.cs:710 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00644_Group_Cell_Mgmt.Find_Data_Sub

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9b6156f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:718 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3760412f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:723 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-15bf9534 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:723 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc079ceb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:729 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2769317d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:740 | try | GRID_BIND | siSub.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a8df2954 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:741 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fe22be1c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:744 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-60182848 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:746 | try | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80663dae | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:764 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00644_Group_Cell_Mgmt.Find_Data_Sub_Execute

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB")] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-868f3211 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP00644_Group_Cell_Mgmt.cs:789 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00644_GROUP_CELL_MGMT", Filter, p_sys_type, p_sys_flag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c5723e7a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP00644_Group_Cell_Mgmt.cs:794 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-ec056775 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP00644_Group_Cell_Mgmt.cs:800 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00644_Group_Cell_Mgmt.Find_Main

진입점: FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fdef0c9 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:555 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9f8725d6 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:559 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca39e040 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:562 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-52387d82 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:562 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98cd821d | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:566 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6f9f7ae4 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:567 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a5277b4 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:570 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d1df4511 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:576 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a1b74fbb | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:581 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a384fb2 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:587 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4520cef2 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:588 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Main(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-93c0c0c3 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:600 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8ac4fea7 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:602 | try ▸ if (ds.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fd9324c | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:606 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4e18a52e | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:609 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8d790af1 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:612 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b53a461d | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:620 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-1828de79 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:629 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1effdcc0 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:630 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6a054f73 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:631 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-acbc6115 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:631 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5afa5e42 | FindButton 외 1 | FP00644_Group_Cell_Mgmt.cs:633 | finally | GRID_CLEAR | SpreadInfo.ClearDataSource | (siSub.SpreadObject) | 그리드 데이터/선택 비움 |  |  |  |

## FP00644_Group_Cell_Mgmt.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-beef8c74 | this.Load | FP00644_Group_Cell_Mgmt.cs:134 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00644_Group_Cell_Mgmt.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18e48ca0 | (진입점 미연결) | FP00644_Group_Cell_Mgmt.cs:812 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00644_Group_Cell_Mgmt.GetSearchCondition

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB")] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-856bbb2e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:1230 |  | DATA_OP | siMain.GetBindingRow | (row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f58a86a5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:1232 |  | CALL_EXT | _search.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4809531 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:1234 |  | UI_PROP | _search.COMPANY_ID | dRow["COMPANY_ID"] as string | 속성 COMPANY_ID 설정 |  |  |  |
| AC-5e64eae7 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:1235 |  | UI_PROP | _search.DIVISION_ID | dRow["DIVISION_ID"] as string | 속성 DIVISION_ID 설정 |  |  |  |
| AC-236b7efc | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:1236 |  | UI_PROP | _search.SITE_ID | dRow["SITE_ID"] as string | 속성 SITE_ID 설정 |  |  |  |
| AC-579370ec | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:1237 |  | UI_PROP | _search.PLANT_ID | dRow["PLANT_ID"] as string | 속성 PLANT_ID 설정 |  |  |  |
| AC-e4999388 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:1238 |  | UI_PROP | _search.GROUP_CELL_ID | dRow["GROUP_CELL_ID"] as string | 속성 GROUP_CELL_ID 설정 |  |  |  |
| AC-7b62ce9d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:1239 |  | UI_PROP | _search.EXCEL_VIEW | string.Empty | 속성 EXCEL_VIEW 설정 |  |  |  |
| AC-a4abb7d1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:1241 |  | RETURN | return _search; |  | 처리 중단/반환 |  |  |  |

## FP00644_Group_Cell_Mgmt.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ebf60f8 | this.Load | FP00644_Group_Cell_Mgmt.cs:199 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e083e21e | this.Load | FP00644_Group_Cell_Mgmt.cs:205 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b3c42478 | this.Load | FP00644_Group_Cell_Mgmt.cs:206 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-26ce9c9f | this.Load | FP00644_Group_Cell_Mgmt.cs:211 | try | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-22f9ee5a | this.Load | FP00644_Group_Cell_Mgmt.cs:211 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d21b487c | this.Load | FP00644_Group_Cell_Mgmt.cs:212 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0168c551 | this.Load | FP00644_Group_Cell_Mgmt.cs:214 | try | FLAG | dtYesNo | Data_FP.Common_FP(Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 화면 필드/플래그 변경 |  |  |  |
| AC-c0e15af8 | this.Load | FP00644_Group_Cell_Mgmt.cs:214 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b2e27506 | this.Load | FP00644_Group_Cell_Mgmt.cs:215 | try | LIST_REBIND | clsCtrl.setListBox | (dtYesNo, cboNewItem, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-775d8db1 | this.Load | FP00644_Group_Cell_Mgmt.cs:231 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00644_Group_Cell_Mgmt.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-643dd0d2 | this.Load | FP00644_Group_Cell_Mgmt.cs:150 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-c1b509f2 | this.Load | FP00644_Group_Cell_Mgmt.cs:151 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-8e1576ee | this.Load | FP00644_Group_Cell_Mgmt.cs:152 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00644_Group_Cell_Mgmt.InitSpread

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.Load / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ca04567 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP00644_Group_Cell_Mgmt.cs:308 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8dfacb99 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP00644_Group_Cell_Mgmt.cs:310 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-17f98ee2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP00644_Group_Cell_Mgmt.cs:316 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d4379c31 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP00644_Group_Cell_Mgmt.cs:318 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |

## FP00644_Group_Cell_Mgmt.Insert_Row_Sub

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5a9a650 | (진입점 미연결) | FP00644_Group_Cell_Mgmt.cs:540 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00644_Group_Cell_Mgmt.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-783ec7fe | InsertButton | FP00644_Group_Cell_Mgmt.cs:508 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00644_Group_Cell_Mgmt.lfn_SearchDetailGrid

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f18b37d9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | FP00644_Group_Cell_Mgmt.cs:1213 |  | FLAG | _searchRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-0a4bec6e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | FP00644_Group_Cell_Mgmt.cs:1214 |  | FLAG | _search | GetSearchCondition(row) | 화면 필드/플래그 변경 |  |  |  |
| AC-4b6b0597 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | FP00644_Group_Cell_Mgmt.cs:1216 | if (_search.GROUP_CELL_ID.SafeString().Equals("")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00644_Group_Cell_Mgmt.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09dc710d | popSql.OnSql | FP00644_Group_Cell_Mgmt.cs:1198 | if (programID == "SELECT_MAIN") | RETURN | return Find_Data_Main(false); |  | 처리 중단/반환 |  |  |  |
| AC-133c1cd9 | popSql.OnSql | FP00644_Group_Cell_Mgmt.cs:1202 | else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB") | FLAG | _search | GetSearchCondition(_searchRow) | 화면 필드/플래그 변경 |  |  |  |
| AC-ca6d56eb | popSql.OnSql | FP00644_Group_Cell_Mgmt.cs:1203 | else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB") | RETURN | return Find_Data_Sub_Execute(false, _search, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7c4f5225 | popSql.OnSql | FP00644_Group_Cell_Mgmt.cs:1208 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00644_Group_Cell_Mgmt.Save_Data_Execute

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6fe3757 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:905 | try | DATA_OP | dsSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f32175e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:908 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e3568ddb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:915 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: ▸ if (bindingRow.RowState !=… | CALL_EXT | bindingRow.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-00f790f9 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:919 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagM: ▸ if (bindingRow.RowState != DataRowState.Modified) | CALL_EXT | bindingRow.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e1f97fc | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:923 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagD: ▸ if (bindingRow.RowState != DataRowState.Deleted) | DATA_OP | bindingRow.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9446b434 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:933 | try | CALL_EXT | dsSave.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-09ad4fc5 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:937 | try ▸ if (iCount > 0) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00644_GroupCellMgmt", "merge_FP00644", dsSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00644] \| FP\Master\FP00… | 엔드포인트 호출 |  |  |  |
| AC-4d11a875 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:941 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-438e5cca | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:943 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | DATA_OP | set.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-3806b8e1 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:944 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-da11dc27 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:946 | try ▸ if (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-055965ca | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:950 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-82808382 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:956 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-a7b10037 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:957 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00644_Group_Cell_Mgmt.Save_Main

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c0133e0 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:817 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-6c925f0e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:817 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05020b78 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:819 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe598cdb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:821 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-221af383 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:826 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14fb3773 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:827 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d439472c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:830 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-055e68d8 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:837 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-0a67ce09 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:839 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c76d6061 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:840 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4ddd43b | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:845 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ced8f252 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:850 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67dcff5b | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:859 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-443e4417 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:863 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f313088f | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:867 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-545a1b98 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:868 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe68a7ec | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:873 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-66542681 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00644_Group_Cell_Mgmt.cs:874 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00644_Group_Cell_Mgmt.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-707481d0 | SaveButton | FP00644_Group_Cell_Mgmt.cs:487 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00644_Group_Cell_Mgmt.SetBackColor

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33a3ff98 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:655 | if (sheetType.Equals("MAIN")) ▸ for (iRow < spdMain.ActiveSheet.Rows.Count) ▸ if (sNewItemFlag.Equals("Y")) | GRID_STYLE | siMain.SetBGColor2 | (iRow, siMain.GetColumnIndex(DefColumns.NEW_ITEM_FLAG), iRow, siMain.GetColumnIndex(DefCol… | 그리드 표시 설정 |  |  |  |
| AC-ed472d2b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:666 | else of (sheetType.Equals("MAIN")) ▸ for (iRow < spdSub.ActiveSheet.Rows.Count) | DATA_OP | siSub.GetBindingRow | (iRow) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-441f182c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 3 | FP00644_Group_Cell_Mgmt.cs:672 | else of (sheetType.Equals("MAIN")) ▸ for (iRow < spdSub.ActiveSheet.Rows.Count) ▸ if (sSameYN.Equals("N")) | GRID_STYLE | siSub.SetBGColor2 | (iRow, siSub.GetColumnIndex(DefColumns.CELL_ID), iRow, siSub.GetColumnIndex(DefColumns.CEL… | 그리드 표시 설정 |  |  |  |

## FP00644_Group_Cell_Mgmt.SetChangedControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / cboNewItem.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ace97da3 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:241 | if (argType == "") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-7056f109 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:242 | if (argType == "") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-5cea9cd2 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:243 | if (argType == "") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-51eed499 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:243 | if (argType == "") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5c1eca81 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:244 | if (argType == "") | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e9f1228b | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:247 | if (argType == "") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4b892d3 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:248 | if (argType == "") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-91d32c2a | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:249 | if (argType == "") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-683a599c | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:249 | if (argType == "") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-028a894f | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:250 | if (argType == "") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-615f122a | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:258 | else of (argType == "") ▸ if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-dcd4a2f7 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:259 | else of (argType == "") ▸ if (argType == "DIVISION") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-a3cf8713 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:261 | else of (argType == "") ▸ if (argType == "DIVISION") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-71e40fdd | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:261 | else of (argType == "") ▸ if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d92f2ec | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:262 | else of (argType == "") ▸ if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3118d967 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:269 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-e7bcbd31 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:270 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-6c58f5ad | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:271 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-00eeba03 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:271 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ if (argType == "SITE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45f60538 | this.Load [try] 외 4 | FP00644_Group_Cell_Mgmt.cs:272 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ if (argType == "SITE") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00644_Group_Cell_Mgmt.SetFilter

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try ▸ try] / this.Load [try] / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / cboNewItem.SelectedIndexChanged / txtCell.TextChanged / txtCellName.TextChanged / txtGroupCell.TextChanged / txtGroupCellName.TextChanged / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB") ▸ try] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try ▸ try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bccf1622 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 13 | FP00644_Group_Cell_Mgmt.cs:807 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00644_Group_Cell_Mgmt.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd86b640 | this.spdMain.CellDoubleClick | FP00644_Group_Cell_Mgmt.cs:1099 | if (siMain.Sheet().Rows.Count <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-090c349f | this.spdMain.CellDoubleClick | FP00644_Group_Cell_Mgmt.cs:1100 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1631e1b7 | this.spdMain.CellDoubleClick | FP00644_Group_Cell_Mgmt.cs:1108 | if (IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50cce0d2 | this.spdMain.CellDoubleClick | FP00644_Group_Cell_Mgmt.cs:1117 | if (!e.ColumnHeader && e.Row >= 0) ▸ if (string.IsNullOrWhiteSpace(siMain.GetValue(e.Row, e.Column).ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22176d1f | this.spdMain.CellDoubleClick | FP00644_Group_Cell_Mgmt.cs:1122 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00644_Group_Cell_Mgmt.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93d122b6 | this.spdMain.Change | FP00644_Group_Cell_Mgmt.cs:1143 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("USE_FLAG")) ▸ if (sUseFlag.Equals("Y")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, group_cell_col].Value | siMain.ActiveSheet.Cells[e.Row, basic_id_col].Value | 그리드 속성/값 설정 |  |  |  |
| AC-afd2f20b | this.spdMain.Change | FP00644_Group_Cell_Mgmt.cs:1147 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("USE_FLAG")) ▸ if (sUseFlag.Equals("Y")) ▸ if (e.Row % 2 == 1) | GRID_STYLE | siMain.SetBGColor2 | (e.Row, siMain.GetColumnIndex(DefColumns.GROUP_CELL_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 표시 설정 |  |  |  |
| AC-027e1eb1 | this.spdMain.Change | FP00644_Group_Cell_Mgmt.cs:1151 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("USE_FLAG")) ▸ if (sUseFlag.Equals("Y")) ▸ else of (e.Row % 2 == 1) | GRID_STYLE | siMain.SetBGColor2 | (e.Row, siMain.GetColumnIndex(DefColumns.GROUP_CELL_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 표시 설정 |  |  |  |
| AC-5402d5b7 | this.spdMain.Change | FP00644_Group_Cell_Mgmt.cs:1156 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("USE_FLAG")) ▸ else of (sUseFlag.Equals("Y")) ▸ if (sUseFlag.Equals("N")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, group_cell_col].Value | siMain.ActiveSheet.Cells[e.Row, cell_col].Value | 그리드 속성/값 설정 |  |  |  |
| AC-a920d96a | this.spdMain.Change | FP00644_Group_Cell_Mgmt.cs:1158 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("USE_FLAG")) ▸ else of (sUseFlag.Equals("Y")) ▸ if (sUseFlag.Equals("N")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, group_cell_col].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-8ab10398 | this.spdMain.Change | FP00644_Group_Cell_Mgmt.cs:1164 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("USE_FLAG")) ▸ else of (sUseFlag.Equals("Y")) ▸ if (sUseFlag.Equals("N")) ▸ if (e.Row… | GRID_STYLE | siMain.SetBGColor2 | (e.Row, siMain.GetColumnIndex(DefColumns.GROUP_CELL_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 표시 설정 |  |  |  |
| AC-0637e2d0 | this.spdMain.Change | FP00644_Group_Cell_Mgmt.cs:1168 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("USE_FLAG")) ▸ else of (sUseFlag.Equals("Y")) ▸ if (sUseFlag.Equals("N")) ▸ else of (… | GRID_STYLE | siMain.SetBGColor2 | (e.Row, siMain.GetColumnIndex(DefColumns.GROUP_CELL_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 표시 설정 |  |  |  |

## FP00644_Group_Cell_Mgmt.spdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db98ddb5 | this.spdSub.CellClick | FP00644_Group_Cell_Mgmt.cs:1025 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

