# AS-IS 액션 대조표 — SCP0121

> 원천: `Doc/asisfacts/screens/SCP0121/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 291행 · 메서드 60 · 종류 DATA_OP 67 · FLAG 45 · UI_PROP 29 · RETURN 20 · GRID_INIT 19 · ENDPOINT 17 · UI_MISC 16 · GRID_LOCK 13 · GRID_SET 13 · POPUP 13 · MESSAGE 11 · LIST_REBIND 8 · CALL_EXT 6 · GRID_CLEAR 5 · GRID_BIND 4 · VALIDATE 3 · GRID_STYLE 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 6


## SCP0121_OwnerPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6eaf76d | .ctor | SCP0121_OwnerPopup.cs:115 |  | FLAG | _Division | sDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-4d5d7356 | .ctor | SCP0121_OwnerPopup.cs:116 |  | FLAG | _Owner | sOwner | 화면 필드/플래그 변경 |  |  |  |

## SCP0121_OwnerPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ef1cbcd | this.Load | SCP0121_OwnerPopup.cs:152 |  | GRID_INIT | this.AddSheet | (spdBase, SpdSheet.shtBase, SpdSheet.shtBase, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-38b53cc3 | this.Load | SCP0121_OwnerPopup.cs:153 |  | FLAG | siBase | GetSheetInfo(spdBase.Name, spdBase.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8240e07 | this.Load | SCP0121_OwnerPopup.cs:155 |  | GRID_INIT | this.AddSheet | (spdUser, SpdSheet.shtUser, SpdSheet.shtUser, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f4b45d82 | this.Load | SCP0121_OwnerPopup.cs:156 |  | FLAG | siUser | GetSheetInfo(spdUser.Name, spdUser.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-965590e7 | this.Load | SCP0121_OwnerPopup.cs:158 |  | GRID_INIT | siBase.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0121_OwnerPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf0e28a0 | Dispose | SCP0121_OwnerPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0121_OwnerPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5ad7939 | this.Load | SCP0121_OwnerPopup.cs:124 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf037b26 | this.Load | SCP0121_OwnerPopup.cs:126 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9bbf1f3f | this.Load | SCP0121_OwnerPopup.cs:134 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-6049e365 | this.Load | SCP0121_OwnerPopup.cs:139 |  | FLAG | _Division | sDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-28c561f9 | this.Load | SCP0121_OwnerPopup.cs:140 |  | FLAG | _Owner | sOwner | 화면 필드/플래그 변경 |  |  |  |

## SCP0121_OwnerPopup.GetOwnerData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-940a38e9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:263 | if (!Flag) | FLAG | _Owner | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-14e89890 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:267 | if (!Flag) ▸ for (iRow <= siUser.GetMaxRowIndex()) ▸ if (iRow == 0) | FLAG | _Owner | siUser.GetValue(iRow, siUser.GetColumnIndex(DefColumns.UserID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ec1dcf23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:269 | if (!Flag) ▸ for (iRow <= siUser.GetMaxRowIndex()) ▸ else of (iRow == 0) | FLAG | _Owner | _Owner + "," + siUser.GetValue(iRow, siUser.GetColumnIndex(DefColumns.UserID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a7cbaac4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:283 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_GET_OWNER_DATA_POPUP") ⇒ SCP.SCP0121_GET_OWNER_DATA_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-cbf726f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:284 |  | DATA_OP | request.Parameters["p_division_id"] | _Division | 행/컬럼 값 대입 |  |  |  |
| AC-cc4c7967 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:285 |  | DATA_OP | request.Parameters["p_search"] | sSearch | 행/컬럼 값 대입 |  |  |  |
| AC-ffa70c22 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:286 |  | DATA_OP | request.Parameters["p_owner_id"] | _Owner | 행/컬럼 값 대입 |  |  |  |
| AC-ec07d8db | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:290 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aa469ecc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:298 | if ((ds != null)) | GRID_BIND | siBase.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-29339064 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:303 | if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[1].Rows.Count > 0) && (Flag == true)) | GRID_BIND | siUser.Query | (ds.Tables[1]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2198b4ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:306 |  | GRID_LOCK | siBase.LockColumn | (0, siBase.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d8b8098 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_OwnerPopup.cs:307 |  | GRID_LOCK | siUser.LockColumn | (0, siUser.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0121_OwnerPopup.GetSpdTitle

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79013bdc | this.Load | SCP0121_OwnerPopup.cs:226 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-4b301f7d | this.Load | SCP0121_OwnerPopup.cs:227 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0b3c8364 | this.Load | SCP0121_OwnerPopup.cs:228 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-116e739f | this.Load | SCP0121_OwnerPopup.cs:229 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9b80e8e2 | this.Load | SCP0121_OwnerPopup.cs:230 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF000" | 행/컬럼 값 대입 |  |  |  |
| AC-5bc39ac0 | this.Load | SCP0121_OwnerPopup.cs:231 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-d803f122 | this.Load | SCP0121_OwnerPopup.cs:232 |  | DATA_OP | request.Parameters["p_division_id"] | _Division | 행/컬럼 값 대입 |  |  |  |
| AC-b9a88693 | this.Load | SCP0121_OwnerPopup.cs:234 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f330c01 | this.Load | SCP0121_OwnerPopup.cs:236 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0121_OwnerPopup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f12de75 | this.Load | SCP0121_OwnerPopup.cs:174 |  | UI_PROP | pnlBottom.Dock | DockStyle.Bottom | 속성 Dock 설정 |  |  |  |
| AC-fa3c3c87 | this.Load | SCP0121_OwnerPopup.cs:176 |  | UI_PROP | pnlCenter.Dock | DockStyle.Left | 속성 Dock 설정 |  |  |  |
| AC-772cdcb4 | this.Load | SCP0121_OwnerPopup.cs:178 |  | UI_PROP | pnlSearch.Dock | DockStyle.Top | 속성 Dock 설정 |  |  |  |
| AC-c4b32ba8 | this.Load | SCP0121_OwnerPopup.cs:180 |  | UI_PROP | spdBase.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-98460ccb | this.Load | SCP0121_OwnerPopup.cs:181 |  | UI_PROP | spdUser.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-21b983d5 | this.Load | SCP0121_OwnerPopup.cs:182 |  | UI_PROP | splMain.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-f6ab70e2 | this.Load | SCP0121_OwnerPopup.cs:184 |  | UI_PROP | this.Size | new Size(850, 400) | 속성 Size 설정 |  |  |  |
| AC-b3d9067c | this.Load | SCP0121_OwnerPopup.cs:188 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth)) | 속성 SplitterDistance 설정 |  |  |  |
| AC-f5c64a95 | this.Load | SCP0121_OwnerPopup.cs:189 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth) / 2) | 속성 SplitterDistance 설정 |  |  |  |

## SCP0121_OwnerPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68d4f364 | this.Load | SCP0121_OwnerPopup.cs:168 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4285bd0 | this.Load | SCP0121_OwnerPopup.cs:169 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## SCP0121_OwnerPopup.ResetWidth

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecb3cfd7 | this.Load | SCP0121_OwnerPopup.cs:255 |  | UI_PROP | this.Width | += iWidth | 속성 Width 설정 |  |  |  |
| AC-114b9b31 | this.Load | SCP0121_OwnerPopup.cs:256 |  | UI_PROP | splMain.SplitterDistance | this.Width / 2 - iWidth2 | 속성 SplitterDistance 설정 |  |  |  |

## SCP0121_OwnerPopup.SaveTitleSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ea69e96 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SCP0121_OwnerPopup.cs:470 | if (siUser.GetMaxRowIndex() != -1) ▸ for (i <= siUser.GetMaxRowIndex()) ▸ if (owner == "") | FLAG | owner | siUser.GetValue(i, siUser.GetColumnIndex(DefColumns.UserID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4444ae1b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SCP0121_OwnerPopup.cs:471 | if (siUser.GetMaxRowIndex() != -1) ▸ for (i <= siUser.GetMaxRowIndex()) ▸ if (owner == "") | FLAG | userNameEn | siUser.GetValue(i, siUser.GetColumnIndex(DefColumns.USER_NAME_EN)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f52f1f6a | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SCP0121_OwnerPopup.cs:476 | if (siUser.GetMaxRowIndex() != -1) ▸ for (i <= siUser.GetMaxRowIndex()) ▸ else of (owner == "") | FLAG | owner | owner + "," + siUser.GetValue(i, siUser.GetColumnIndex(DefColumns.UserID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d1672f50 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SCP0121_OwnerPopup.cs:477 | if (siUser.GetMaxRowIndex() != -1) ▸ for (i <= siUser.GetMaxRowIndex()) ▸ else of (owner == "") | FLAG | userNameEn | userNameEn + "," + siUser.GetValue(i, siUser.GetColumnIndex(DefColumns.USER_NAME_EN)).ToSt… | 화면 필드/플래그 변경 |  |  |  |
| AC-3c5f09a2 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SCP0121_OwnerPopup.cs:484 | else of (siUser.GetMaxRowIndex() != -1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6db338e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SCP0121_OwnerPopup.cs:485 | else of (siUser.GetMaxRowIndex() != -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0121_OwnerPopup.setBaseSort

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de7afbc4 | (진입점 미연결) | SCP0121_OwnerPopup.cs:96 |  | FLAG | _isBaseSort | isBool | 화면 필드/플래그 변경 |  |  |  |

## SCP0121_OwnerPopup.SetTitleSet

진입점: this.spdBase.CellDoubleClick / this.spdUser.CellDoubleClick / this.btnRight.Click / this.btnLeft.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02641a1b | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:355 |  | CALL_EXT | svSource.GetSelections().GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ade5f231 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:356 | if (svSource.GetSelections().GetLength(0) == 0) | CALL_EXT | svSource.AddSelection | (svSource.ActiveRowIndex, svSource.ActiveColumnIndex, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6c86cfe | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:368 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4898a6d | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:372 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns[DefColumns.SORT_ORDER_NO].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-de8da877 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:374 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-5267ca7c | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:375 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns[DefColumns.SORT_ORDER_NO].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-e9960ab5 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:386 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-19b5c95d | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:387 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns[DefColumns.SORT_ORDER_NO].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-23d9b695 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:389 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd95d669 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:390 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns[DefColumns.SORT_ORDER_NO].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-8feee1dc | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:417 | foreach (int i in selectIndex.Keys) ▸ else of (activeRow + 1 >= svTarget.RowCount) | DATA_OP | svTarget.Rows.Add | (activeRow + 1, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed366d03 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:420 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns[DefColumns.UserID].Index].Text | sUserID | 그리드 속성/값 설정 |  |  |  |
| AC-f7525cc4 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:421 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns[DefColumns.UserName].Index].Text | sUserName | 그리드 속성/값 설정 |  |  |  |
| AC-35b90197 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:422 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns[DefColumns.DEPT_NAME_KO].Index].Text | sDEPT_NAME_KO | 그리드 속성/값 설정 |  |  |  |
| AC-5bb2512d | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:423 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns[DefColumns.SORT_ORDER_NO].Index].Text | sSortOrderNo | 그리드 속성/값 설정 |  |  |  |
| AC-d22b9a25 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:424 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns[DefColumns.USER_SELECTABLE_FLAG].Index].Text | sUserSelectedFlag | 그리드 속성/값 설정 |  |  |  |
| AC-840a8604 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:425 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns[DefColumns.USER_NAME_EN].Index].Text | sUSER_NAME_EN | 그리드 속성/값 설정 |  |  |  |
| AC-0e9dcf77 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:429 |  | GRID_STYLE | svTarget.SetActiveCell | (activeRow, -1) | 그리드 표시 설정 |  |  |  |
| AC-b81f9048 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:434 | for (i >= 0) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-da28b468 | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:436 | for (i >= 0) ▸ if (selectIndex.ContainsKey(i)) | CALL_EXT | svSource.RemoveRows | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0bf75ef | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:441 | if (_isBaseSort == true) | CALL_EXT | svTarget.SortRows | (svTarget.Columns[DefColumns.SORT_ORDER_NO].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d11450f | this.spdBase.CellDoubleClick 외 3 | SCP0121_OwnerPopup.cs:445 | else of (_isBaseSort == true) ▸ if (svTarget == spdBase.Sheets[0]) | CALL_EXT | svTarget.SortRows | (svTarget.Columns[DefColumns.SORT_ORDER_NO].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0121_OwnerPopup.spdUser_ButtonClicked

진입점: this.spdUser.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a34eaa15 | this.spdUser.ButtonClicked | SCP0121_OwnerPopup.cs:521 | if (e.Column != sv.Columns["SUB_TOTAL_FLAG"].Index) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6288f65 | this.spdUser.ButtonClicked | SCP0121_OwnerPopup.cs:525 | for (i < sv.RowCount) | GRID_SET | sv.Cells[i, e.Column].Value | "false" | 그리드 속성/값 설정 |  |  |  |

## SCP0121_OwnerPopup.spdUser_RowDragMove

진입점: this.spdUser.RowDragMove

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3affc47c | this.spdUser.RowDragMove | SCP0121_OwnerPopup.cs:544 | if (sUserSelect != "Y") | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## SCP0121_OwnerPopup.TitleSetForm_SizeChanged

진입점: this.SizeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea2de098 | this.SizeChanged | SCP0121_OwnerPopup.cs:531 |  | UI_PROP | pnlCenterButton.Top | (pnlCenter.Height - pnlCenterButton.Height) / 2 | 속성 Top 설정 |  |  |  |

## SCP0121_OwnerPopup.usrButtonList1_UsrButtonList_Click_Detected

진입점: this.usrButtonList1.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d47ce87 | this.usrButtonList1.UsrButtonList_Click_Detected | SCP0121_OwnerPopup.cs:212 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0121_PlanGroupInfoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69edc836 | .ctor | SCP0121_PlanGroupInfoPopup.cs:82 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-3d72ec11 | .ctor | SCP0121_PlanGroupInfoPopup.cs:85 |  | FLAG | p_division_id | pDivId | 화면 필드/플래그 변경 |  |  |  |
| AC-8e4c407c | .ctor | SCP0121_PlanGroupInfoPopup.cs:86 |  | VALUE_SET | this.lblDivision.Text | pDiVTxt | 컨트롤 값 설정 |  |  |  |
| AC-94b3e77e | .ctor | SCP0121_PlanGroupInfoPopup.cs:87 |  | FLAG | dtType | _dtType | 화면 필드/플래그 변경 |  |  |  |

## SCP0121_PlanGroupInfoPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec4bf952 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0121_PlanGroupInfoPopup.cs:393 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0121_PlanGroupInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97877aea | this.Load | SCP0121_PlanGroupInfoPopup.cs:141 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31322937 | this.Load | SCP0121_PlanGroupInfoPopup.cs:142 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea2660ce | this.Load | SCP0121_PlanGroupInfoPopup.cs:143 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0121_PlanGroupInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72301874 | Dispose | SCP0121_PlanGroupInfoPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0121_PlanGroupInfoPopup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0539596d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:178 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fe062d35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:179 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ec5011d3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:181 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), siMain.GetColumnIndex(DefColumns.OPMZ_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e75999df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:182 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.OWNER_NAME), siMain.GetColumnIndex(DefColumns.OWNER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3d993af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:183 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.CREATED_BY… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0121_PlanGroupInfoPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / this.Load / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-208662db | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_PlanGroupInfoPopup.cs:225 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_GET_PLAN_GROUP_POPUP") ⇒ SCP.SCP0121_GET_PLAN_GROUP_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-5130c034 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_PlanGroupInfoPopup.cs:229 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a9ae2a89 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_PlanGroupInfoPopup.cs:230 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8b8180bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_PlanGroupInfoPopup.cs:232 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc251bd2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_PlanGroupInfoPopup.cs:235 |  | GRID_BIND | siMain.Query | (result) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-daa21e5c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_PlanGroupInfoPopup.cs:236 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7d1a94d0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0121_PlanGroupInfoPopup.cs:241 |  | FLAG | strSelectedPlanID | "" | 화면 필드/플래그 변경 |  |  |  |

## SCP0121_PlanGroupInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a663136d | this.Load | SCP0121_PlanGroupInfoPopup.cs:95 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0121_PlanGroupInfoPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d741e4ee | this.Load | SCP0121_PlanGroupInfoPopup.cs:115 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SCP0121_PlanGroupInfoPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf854e71 | this.Load | SCP0121_PlanGroupInfoPopup.cs:150 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-ae07c729 | this.Load | SCP0121_PlanGroupInfoPopup.cs:153 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon", dtType) | 목록 컨트롤 재구성 |  |  |  |
| AC-dee55deb | this.Load | SCP0121_PlanGroupInfoPopup.cs:155 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-11d18a99 | this.Load | SCP0121_PlanGroupInfoPopup.cs:156 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0121_PlanGroupInfoPopup.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69b3fdb2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:206 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8a35812c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:209 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-688db9ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:211 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-5702eb7f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:213 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd897d74 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:214 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.C… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0121_PlanGroupInfoPopup.SaveButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-587caa75 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:193 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0121_PlanGroupInfoPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72f89e89 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:246 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a094787d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:248 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bae31c35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:251 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-d48d9a38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:251 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-160f3d19 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:309 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-97feb2b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:310 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-93778739 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:314 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_SAVE_PLAN_GROUP_POPUP") ⇒ SCP.SCP0121_SAVE_PLAN_GROUP_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-6c988ae0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:317 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", BLUtils.GSCM_SCP_MASTER_SVC)) { req… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7f8cc2a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:321 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5b52accd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:323 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f635097e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:324 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-78244b02 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:325 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plan_gr_id"] | p_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-355dbfa9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:326 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plan_gr_name"] | p_plan_gr_name | 행/컬럼 값 대입 |  |  |  |
| AC-3a462dfa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:327 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plan_gr_desc"] | p_plan_gr_desc | 행/컬럼 값 대입 |  |  |  |
| AC-0e204373 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:328 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_tgt_divs_cd"] | p_tgt_divs_cd | 행/컬럼 값 대입 |  |  |  |
| AC-db694ec9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:329 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-1fdc5b6c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:330 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_owner_name"] | p_owner_name | 행/컬럼 값 대입 |  |  |  |
| AC-e2e2097c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:331 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-0d5c1277 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:332 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c262f8ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:334 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52f6174b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:334 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-f0e52f23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:338 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3d62cd1b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:344 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | isEdit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9c018d66 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:346 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7dc08e8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:355 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0c05f97 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:362 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-eeac8bd4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:363 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef4f14cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0121_PlanGroupInfoPopup.cs:367 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0121_PlanGroupInfoPopup.SCP0121_PlanGroupInfoPopup_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18bfd070 | this.FormClosing | SCP0121_PlanGroupInfoPopup.cs:430 | if (isEdit) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## SCP0121_PlanGroupInfoPopup.spdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d36debf1 | (진입점 미연결) | SCP0121_PlanGroupInfoPopup.cs:425 |  | FLAG | strSelectedPlanID | siMain.GetValue(e.Row, siMain.GetColumnIndex("PLAN_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |

## SCP0121_PlanGroupInfoPopup.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91ee16df | this.spdMain.CellDoubleClick | SCP0121_PlanGroupInfoPopup.cs:409 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.OWNER))) | POPUP | new SCP0121_OwnerPopup | (p_division_id, sOwner) | 팝업/폼 생성 |  |  |  |
| AC-6f2caf40 | this.spdMain.CellDoubleClick | SCP0121_PlanGroupInfoPopup.cs:411 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.OWNER))) | UI_PROP | popOwner.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5995a949 | this.spdMain.CellDoubleClick | SCP0121_PlanGroupInfoPopup.cs:412 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.OWNER))) | POPUP | popOwner.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-064fbbdb | this.spdMain.CellDoubleClick | SCP0121_PlanGroupInfoPopup.cs:416 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.OWNER))) ▸… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.OWNER_NAME), popOwner.userNameEn) | 그리드 값 설정 |  |  |  |
| AC-c09508a7 | this.spdMain.CellDoubleClick | SCP0121_PlanGroupInfoPopup.cs:417 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.OWNER))) ▸… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.OWNER), popOwner.owner) | 그리드 값 설정 |  |  |  |

## SCP0121_PlanGroupMaster.BtnPlanGroupReg_Click

진입점: this.btnPlanGroupReg.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88eb4e83 | this.btnPlanGroupReg.Click | SCP0121_PlanGroupMaster.cs:890 |  | POPUP | new SCP0121_PlanGroupInfoPopup | (cboDivision.ControlValues, cboDivision.Text, dtType) | 팝업/폼 생성 |  |  |  |
| AC-f9f304cb | this.btnPlanGroupReg.Click | SCP0121_PlanGroupMaster.cs:891 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d4e0c87f | this.btnPlanGroupReg.Click | SCP0121_PlanGroupMaster.cs:892 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-858e216c | this.btnPlanGroupReg.Click | SCP0121_PlanGroupMaster.cs:895 | if (popup.ShowDialog() == DialogResult.OK) | FLAG | dsSearchInfo | GetSearchInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-7431689b | this.btnPlanGroupReg.Click | SCP0121_PlanGroupMaster.cs:896 | if (popup.ShowDialog() == DialogResult.OK) | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |

## SCP0121_PlanGroupMaster.ClbBuilding_SelectedIndexChanged

진입점: clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46651142 | clbBuilding.SelectedIndexChanged | SCP0121_PlanGroupMaster.cs:873 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0121_PlanGroupMaster.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43d9c65e | cboDivision.SelectedIndexChanged | SCP0121_PlanGroupMaster.cs:858 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0121_PlanGroupMaster.ClbOperation_SelectedIndexChanged

진입점: clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66f395e8 | clbOperation.SelectedIndexChanged | SCP0121_PlanGroupMaster.cs:880 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0121_PlanGroupMaster.ClbPlanGroup_SelectedIndexChanged

진입점: clbPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-572412fc | clbPlanGroup.SelectedIndexChanged | SCP0121_PlanGroupMaster.cs:885 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0121_PlanGroupMaster.ClbPlantSite_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec12c1cf | clbPlant.SelectedIndexChanged | SCP0121_PlanGroupMaster.cs:865 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0121_PlanGroupMaster.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1874e34 | this.Load | SCP0121_PlanGroupMaster.cs:279 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bd93fb98 | this.Load | SCP0121_PlanGroupMaster.cs:280 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-09a64d0d | this.Load | SCP0121_PlanGroupMaster.cs:282 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0121_PlanGroupMaster.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a88a16cd | Dispose | SCP0121_PlanGroupMaster.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0121_PlanGroupMaster.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9239e537 | EditButton | SCP0121_PlanGroupMaster.cs:373 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c3e93e06 | EditButton | SCP0121_PlanGroupMaster.cs:374 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f312800a | EditButton | SCP0121_PlanGroupMaster.cs:375 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.OPERATION… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0121_PlanGroupMaster.FindData_PlanGroup

진입점: FindButton / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81230837 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:392 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-55f1b1e2 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:395 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-36a80207 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:395 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28dbd331 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:399 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1c1c1728 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:403 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad07ec48 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:416 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1b46baa7 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:417 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-94ea7b6f | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:421 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_GET_PLAN_GROUP_LINE") ⇒ SCP.SCP0121_GET_PLAN_GROUP_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-5b6209c5 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:422 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fb760a32 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:423 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-27da1bbd | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:424 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-9c9389eb | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:425 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-95229d19 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:426 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-bd0e17d8 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:427 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-d86f88d9 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:428 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-968115ec | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:430 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fd8691b3 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:432 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1b2a2de9 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:441 | try ▸ if (ds.Tables.Count > 0) | FLAG | this.dtPlanGroupLineAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a605b295 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:441 | try ▸ if (ds.Tables.Count > 0) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fae9be87 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:444 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-339b3c4f | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:445 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b3fc27a7 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:448 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-634903d5 | FindButton 외 1 | SCP0121_PlanGroupMaster.cs:461 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0121_PlanGroupMaster.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f690ffe | this.Load | SCP0121_PlanGroupMaster.cs:109 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0121_PlanGroupMaster.GetSearchInfo

진입점: this.btnPlanGroupReg.Click [if (popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c943303a | this.btnPlanGroupReg.Click [if (popup.ShowDialog() == Dialog… | SCP0121_PlanGroupMaster.cs:169 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_GET_SEARCH_INFO") ⇒ SCP.SCP0121_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-afe3afd9 | this.btnPlanGroupReg.Click [if (popup.ShowDialog() == Dialog… | SCP0121_PlanGroupMaster.cs:171 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0de021ce | this.btnPlanGroupReg.Click [if (popup.ShowDialog() == Dialog… | SCP0121_PlanGroupMaster.cs:172 |  | DATA_OP | request.Parameters["p_user_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84a4d39e | this.btnPlanGroupReg.Click [if (popup.ShowDialog() == Dialog… | SCP0121_PlanGroupMaster.cs:175 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f3009924 | this.btnPlanGroupReg.Click [if (popup.ShowDialog() == Dialog… | SCP0121_PlanGroupMaster.cs:179 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0121_PlanGroupMaster.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-958c4df1 | this.Load | SCP0121_PlanGroupMaster.cs:127 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-68bee659 | this.Load | SCP0121_PlanGroupMaster.cs:130 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-a5c250bc | this.Load | SCP0121_PlanGroupMaster.cs:132 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bcc2c2d4 | this.Load | SCP0121_PlanGroupMaster.cs:135 |  | FLAG | dtPlantIdAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-af7fb1b9 | this.Load | SCP0121_PlanGroupMaster.cs:136 |  | FLAG | dtBuildingByDivisionAll | dsSearchInfo.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-e5e2999e | this.Load | SCP0121_PlanGroupMaster.cs:137 |  | FLAG | dtLineAll | dsSearchInfo.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-8de97b8f | this.Load | SCP0121_PlanGroupMaster.cs:138 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-ffd83d75 | this.Load | SCP0121_PlanGroupMaster.cs:139 |  | FLAG | dtTypeAll | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-67f7d4a2 | this.Load | SCP0121_PlanGroupMaster.cs:140 |  | FLAG | dtOperationAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-b88d9bde | this.Load | SCP0121_PlanGroupMaster.cs:152 | if (!string.IsNullOrEmpty(nowGroupID) && (nowGroupID != "ADMIN" && nowGroupID != "SCM PI Admin")) | UI_PROP | lciBtnPlanGroupReg.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0121_PlanGroupMaster.InitSpread

진입점: this.Load / this.btnPlanGroupReg.Click [if (popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18af7002 | this.Load 외 1 | SCP0121_PlanGroupMaster.cs:291 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b35746d | this.Load 외 1 | SCP0121_PlanGroupMaster.cs:292 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0121_PlanGroupMaster.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27092bc7 | InsertButton | SCP0121_PlanGroupMaster.cs:470 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a096f412 | InsertButton | SCP0121_PlanGroupMaster.cs:493 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-33df73e9 | InsertButton | SCP0121_PlanGroupMaster.cs:494 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.PLANT_ID, plant_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d88ef9d | InsertButton | SCP0121_PlanGroupMaster.cs:495 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.FACTORY_ID, factory_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb58174f | InsertButton | SCP0121_PlanGroupMaster.cs:496 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.FACTORY_NAME, factory_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a008899 | InsertButton | SCP0121_PlanGroupMaster.cs:497 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.LINE_ID, line_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc8e7bb | InsertButton | SCP0121_PlanGroupMaster.cs:498 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.LINE_NAME, line_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-2112bfa6 | InsertButton | SCP0121_PlanGroupMaster.cs:499 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.OPERATION_ID, operation_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f3b31e7 | InsertButton | SCP0121_PlanGroupMaster.cs:501 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-7fd018f6 | InsertButton | SCP0121_PlanGroupMaster.cs:503 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0121_PlanGroupMaster.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5242394 | InsertButton | SCP0121_PlanGroupMaster.cs:364 |  | FLAG | this._currRowIdx | this._currRowIdx + 1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0121_PlanGroupMaster.RefreshBuildingByPlantId

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d07ba96 | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:218 |  | FLAG | dtBuildingByDivision | DBUtils.Filter(dtBuildingByDivisionAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-78a38b59 | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:218 |  | DATA_OP | DBUtils.Filter | (dtBuildingByDivisionAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-33e797bd | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByDivision, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0121_PlanGroupMaster.RefreshLine

진입점: this.Load / cboDivision.SelectedIndexChanged / clbOperation.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbBuilding.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-300d34b8 | this.Load 외 5 | SCP0121_PlanGroupMaster.cs:239 |  | FLAG | dtLine | DBUtils.Filter(dtLineAll, "DIVISION_ID = '" + division + "'" + filterOperation + filterPla… | 화면 필드/플래그 변경 |  |  |  |
| AC-e8baec0d | this.Load 외 5 | SCP0121_PlanGroupMaster.cs:239 |  | DATA_OP | DBUtils.Filter | (dtLineAll, "DIVISION_ID = '" + division + "'" + filterOperation + filterPlantId + filterB… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e767b0ed | this.Load 외 5 | SCP0121_PlanGroupMaster.cs:241 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0121_PlanGroupMaster.RefreshOperationByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10aae1e9 | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:200 |  | FLAG | dtOperation | DBUtils.Filter(dtOperationAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-8bd00fa0 | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:200 |  | DATA_OP | DBUtils.Filter | (dtOperationAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fe5e0f04 | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:201 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0121_PlanGroupMaster.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / this.btnPlanGroupReg.Click [if (popup.ShowDialog() == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-658b64df | this.Load 외 3 | SCP0121_PlanGroupMaster.cs:248 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-73701928 | this.Load 외 3 | SCP0121_PlanGroupMaster.cs:248 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-25688a63 | this.Load 외 3 | SCP0121_PlanGroupMaster.cs:250 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0121_PlanGroupMaster.RefreshPlantIdByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98021d30 | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:209 |  | FLAG | dtPlantId | DBUtils.Filter(dtPlantIdAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-44ac3596 | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:209 |  | DATA_OP | DBUtils.Filter | (dtPlantIdAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1dbf66ba | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:210 |  | FLAG | dtPlantId | DBUtils.GetDistinctTable(dtPlantId , "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-278f0743 | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:210 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtPlantId , "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa58c99b | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:212 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantId, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0121_PlanGroupMaster.RefreshTypeByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08e18cc4 | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:257 |  | FLAG | dtType | DBUtils.Filter(dtTypeAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-be8db3f7 | this.Load 외 2 | SCP0121_PlanGroupMaster.cs:257 |  | DATA_OP | DBUtils.Filter | (dtTypeAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0121_PlanGroupMaster.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20bf7735 | SaveButton | SCP0121_PlanGroupMaster.cs:511 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-385f3435 | SaveButton | SCP0121_PlanGroupMaster.cs:513 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef7b27a9 | SaveButton | SCP0121_PlanGroupMaster.cs:577 | for (i <= siMain.GetMaxRowIndex()) ▸ if (pre_plan_gr_id == string.Empty && pre_item_id == string.Empty) ▸ if (plan_gr_id == string.Empty) | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aabb2fa9 | SaveButton | SCP0121_PlanGroupMaster.cs:578 | for (i <= siMain.GetMaxRowIndex()) ▸ if (pre_plan_gr_id == string.Empty && pre_item_id == string.Empty) ▸ if (plan_gr_id == string.Empty) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-661ef435 | SaveButton | SCP0121_PlanGroupMaster.cs:600 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagD) ▸ if (dsMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d25b1cc2 | SaveButton | SCP0121_PlanGroupMaster.cs:689 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagD) | UI_PROP | dv.RowFilter | sb.ToString() | 속성 RowFilter 설정 |  |  |  |
| AC-e63e8bbc | SaveButton | SCP0121_PlanGroupMaster.cs:693 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagD) ▸ if (dv.Count > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00443") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c439fe16 | SaveButton | SCP0121_PlanGroupMaster.cs:694 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagD) ▸ if (dv.Count > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20092d7e | SaveButton | SCP0121_PlanGroupMaster.cs:706 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagD) | DATA_OP | DBUtils.Filter | (dtmain, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-818261c7 | SaveButton | SCP0121_PlanGroupMaster.cs:717 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagD) ▸ if (dtPlanGroupLine.Rows.Count > 1) ▸ for (k < dtPlanGroupLine.Rows.… | MESSAGE | MessageHelper.GMessageBox | ("동일 Line에 동일Plan Group에 All(-)과 모델을 같이 지정할 수 없습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dfe5daa6 | SaveButton | SCP0121_PlanGroupMaster.cs:718 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagD) ▸ if (dtPlanGroupLine.Rows.Count > 1) ▸ for (k < dtPlanGroupLine.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b49fc81a | SaveButton | SCP0121_PlanGroupMaster.cs:731 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagD) | DATA_OP | DBUtils.Filter | (dtmain, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-418255c7 | SaveButton | SCP0121_PlanGroupMaster.cs:741 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagD) ▸ if (dtPlanGroupLine.Rows.Count > 1) ▸ for (k < dtPlanGroupLine.Rows.… | MESSAGE | MessageHelper.GMessageBox | ("동일 Line에 2개 이상의 Plan Group을 지정할 경우, All(-)을 사용할 수 없다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae803084 | SaveButton | SCP0121_PlanGroupMaster.cs:742 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagD) ▸ if (dtPlanGroupLine.Rows.Count > 1) ▸ for (k < dtPlanGroupLine.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7324a834 | SaveButton | SCP0121_PlanGroupMaster.cs:786 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7c28e83e | SaveButton | SCP0121_PlanGroupMaster.cs:787 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-392855ae | SaveButton | SCP0121_PlanGroupMaster.cs:791 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_SAVE_PLAN_GROUP_LINE") ⇒ SCP.SCP0121_SAVE_PLAN_GROUP_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-48a612b5 | SaveButton | SCP0121_PlanGroupMaster.cs:794 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-310e7c81 | SaveButton | SCP0121_PlanGroupMaster.cs:798 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c4f48919 | SaveButton | SCP0121_PlanGroupMaster.cs:800 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a2690ed0 | SaveButton | SCP0121_PlanGroupMaster.cs:801 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-7095a82b | SaveButton | SCP0121_PlanGroupMaster.cs:802 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-9b40905b | SaveButton | SCP0121_PlanGroupMaster.cs:803 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-224b410d | SaveButton | SCP0121_PlanGroupMaster.cs:804 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-beec99ec | SaveButton | SCP0121_PlanGroupMaster.cs:805 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plan_gr_id"] | p_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-6b4d50fd | SaveButton | SCP0121_PlanGroupMaster.cs:806 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e04cb6d2 | SaveButton | SCP0121_PlanGroupMaster.cs:807 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plan_gr_id"] | p_pre_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-65f1345e | SaveButton | SCP0121_PlanGroupMaster.cs:808 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c7dba832 | SaveButton | SCP0121_PlanGroupMaster.cs:809 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0f39e90f | SaveButton | SCP0121_PlanGroupMaster.cs:811 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-625e01e8 | SaveButton | SCP0121_PlanGroupMaster.cs:811 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-ecf0bf70 | SaveButton | SCP0121_PlanGroupMaster.cs:815 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a53e0600 | SaveButton | SCP0121_PlanGroupMaster.cs:822 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb76670a | SaveButton | SCP0121_PlanGroupMaster.cs:831 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-03c6afd0 | SaveButton | SCP0121_PlanGroupMaster.cs:838 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e2384e95 | SaveButton | SCP0121_PlanGroupMaster.cs:839 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-96f5c313 | SaveButton | SCP0121_PlanGroupMaster.cs:843 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0121_PlanGroupMaster.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31d5835f | SaveButton | SCP0121_PlanGroupMaster.cs:381 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0121_PlanGroupMaster.SetSpreadInit

진입점: this.Load / this.btnPlanGroupReg.Click [if (popup.ShowDialog() == DialogResult.OK)] / FindButton [try] / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67951256 | this.Load 외 3 | SCP0121_PlanGroupMaster.cs:299 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-baae84d0 | this.Load 외 3 | SCP0121_PlanGroupMaster.cs:300 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-01dea573 | this.Load 외 3 | SCP0121_PlanGroupMaster.cs:304 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanGroup", dtPlanGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-fbcba957 | this.Load 외 3 | SCP0121_PlanGroupMaster.cs:306 |  | GRID_INIT | siObj.SetSheetHeaderColumnSCP | (siObj, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

## SCP0121_PlanGroupMaster.SpdMain_ActiveSheetChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82a63050 | (진입점 미연결) | SCP0121_PlanGroupMaster.cs:331 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1e9edaf4 | (진입점 미연결) | SCP0121_PlanGroupMaster.cs:332 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4acf560b | (진입점 미연결) | SCP0121_PlanGroupMaster.cs:334 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b48ef992 | (진입점 미연결) | SCP0121_PlanGroupMaster.cs:335 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0121_PlanGroupMaster.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-442b4981 | this.spdMain.CellClick | SCP0121_PlanGroupMaster.cs:908 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |

## SCP0121_PlanGroupMaster.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9055f3c | this.spdMain.CellDoubleClick | SCP0121_PlanGroupMaster.cs:923 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_… | POPUP | new GSCM.SCM.Popup.UIL.SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c2252ef1 | this.spdMain.CellDoubleClick | SCP0121_PlanGroupMaster.cs:924 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_… | POPUP | popItem.Form_Load | (true, division, "", "", "") | 팝업 초기화(인자 전달) |  |  |  |
| AC-076da1e5 | this.spdMain.CellDoubleClick | SCP0121_PlanGroupMaster.cs:925 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_… | UI_PROP | popItem.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-265912c0 | this.spdMain.CellDoubleClick | SCP0121_PlanGroupMaster.cs:926 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9d32f9de | this.spdMain.CellDoubleClick | SCP0121_PlanGroupMaster.cs:932 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |

## SCP0121_PlanGroupMaster.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b72afb88 | this.spdMain.ClipboardPasted | SCP0121_PlanGroupMaster.cs:958 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | DATA_OP | dtPlanGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3dd292d0 | this.spdMain.ClipboardPasted | SCP0121_PlanGroupMaster.cs:960 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), codeVal) | 그리드 값 설정 |  |  |  |

