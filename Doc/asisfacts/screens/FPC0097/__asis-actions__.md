# AS-IS 액션 대조표 — FPC0097

> 원천: `Doc/asisfacts/screens/FPC0097/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 117행 · 메서드 14 · 종류 DATA_OP 34 · GRID_INIT 22 · UI_PROP 16 · GRID_SET 16 · FLAG 6 · CALL_EXT 5 · ENDPOINT 4 · MESSAGE 4 · UI_MISC 3 · RETURN 2 · GRID_BIND 2 · VALUE_SET 1 · CALL_BASE 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 6


## FPC0097_ColumnSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71408fc1 | .ctor | FPC0097_ColumnSetForm_Popup.cs:76 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-3435e6c0 | .ctor | FPC0097_ColumnSetForm_Popup.cs:77 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-f4faedb9 | .ctor | FPC0097_ColumnSetForm_Popup.cs:78 |  | FLAG | _sColumnSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-03a729c0 | .ctor | FPC0097_ColumnSetForm_Popup.cs:79 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FPC0097_ColumnSetForm_Popup.ColumnSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3295e03c | this.Load | FPC0097_ColumnSetForm_Popup.cs:116 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8f8ed21f | this.Load | FPC0097_ColumnSetForm_Popup.cs:124 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0097_ColumnSetForm_Popup.ColumnSetForm_SizeChanged

진입점: this.SizeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d10a4019 | this.SizeChanged | FPC0097_ColumnSetForm_Popup.cs:603 |  | UI_PROP | pnlCenterButton.Top | (pnlCenter.Height - pnlCenterButton.Height) / 2 | 속성 Top 설정 |  |  |  |

## FPC0097_ColumnSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-490e5945 | Dispose | FPC0097_ColumnSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0097_ColumnSetForm_Popup.GetColumnSet

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8829670 | .ctor | FPC0097_ColumnSetForm_Popup.cs:243 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0002_GET_TITLESET_POPUP") ⇒ SCM.SCM0002_GET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-bec2f8f8 | .ctor | FPC0097_ColumnSetForm_Popup.cs:245 |  | DATA_OP | request.Parameters["p_program_id"] | _sProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-b9893a6d | .ctor | FPC0097_ColumnSetForm_Popup.cs:246 |  | DATA_OP | request.Parameters["p_sheet_name"] | _sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-af9d2897 | .ctor | FPC0097_ColumnSetForm_Popup.cs:247 |  | DATA_OP | request.Parameters["p_column_type"] | _sColumnSetType | 행/컬럼 값 대입 |  |  |  |
| AC-b51f242a | .ctor | FPC0097_ColumnSetForm_Popup.cs:248 |  | DATA_OP | request.Parameters["p_user_id"] | _sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-9cd7c7bf | .ctor | FPC0097_ColumnSetForm_Popup.cs:249 |  | DATA_OP | request.Parameters["p_division_id"] | _sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-c5b2ae7b | .ctor | FPC0097_ColumnSetForm_Popup.cs:250 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ff7944eb | .ctor | FPC0097_ColumnSetForm_Popup.cs:251 |  | FLAG | _dtColumnSet | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FPC0097_ColumnSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81f38465 | this.Load | FPC0097_ColumnSetForm_Popup.cs:129 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FPC0097_ColumnSetForm_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b95dda14 | this.Load | FPC0097_ColumnSetForm_Popup.cs:133 |  | UI_PROP | pnlBottom.Dock | DockStyle.Bottom | 속성 Dock 설정 |  |  |  |
| AC-ca0cb401 | this.Load | FPC0097_ColumnSetForm_Popup.cs:135 |  | UI_PROP | pnlCenter.Dock | DockStyle.Left | 속성 Dock 설정 |  |  |  |
| AC-64de3937 | this.Load | FPC0097_ColumnSetForm_Popup.cs:137 |  | UI_PROP | spdBase.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-3de47412 | this.Load | FPC0097_ColumnSetForm_Popup.cs:138 |  | UI_PROP | spdUser.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-c47bc110 | this.Load | FPC0097_ColumnSetForm_Popup.cs:139 |  | UI_PROP | splMain.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-60e74bdd | this.Load | FPC0097_ColumnSetForm_Popup.cs:141 |  | VALUE_SET | this.Text | _sColumnSetType == "C" ? "Column Setting" : "Measure Setting" | 컨트롤 값 설정 |  |  |  |
| AC-2f8b2641 | this.Load | FPC0097_ColumnSetForm_Popup.cs:142 |  | UI_PROP | this.Size | new Size(440, 400) | 속성 Size 설정 |  |  |  |
| AC-28fdcfeb | this.Load | FPC0097_ColumnSetForm_Popup.cs:145 |  | UI_PROP | this.Size | new Size(_sColumnSetType == "C" ? 600 : 600, 400) | 속성 Size 설정 |  |  |  |
| AC-da6196ba | this.Load | FPC0097_ColumnSetForm_Popup.cs:148 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth)) | 속성 SplitterDistance 설정 |  |  |  |
| AC-e17a74fc | this.Load | FPC0097_ColumnSetForm_Popup.cs:149 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth) / 2) | 속성 SplitterDistance 설정 |  |  |  |

## FPC0097_ColumnSetForm_Popup.InitSheet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-790c0e7e | this.Load | FPC0097_ColumnSetForm_Popup.cs:156 |  | DATA_OP | dt.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-57d8861f | this.Load | FPC0097_ColumnSetForm_Popup.cs:157 |  | DATA_OP | dt.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ee973ca | this.Load | FPC0097_ColumnSetForm_Popup.cs:158 |  | DATA_OP | dt.Rows.Add | (new object[] { "ASC", "ASC" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-4046e272 | this.Load | FPC0097_ColumnSetForm_Popup.cs:159 |  | DATA_OP | dt.Rows.Add | (new object[] { "DESC", "DESC" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed4685e2 | this.Load | FPC0097_ColumnSetForm_Popup.cs:175 |  | GRID_INIT | this.AddSheet | (spdBase, "Base", "Base", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-16d5e207 | this.Load | FPC0097_ColumnSetForm_Popup.cs:177 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-8834bf73 | this.Load | FPC0097_ColumnSetForm_Popup.cs:178 |  | UI_PROP | si.IsRowMove | !_isBaseSort | 속성 IsRowMove 설정 |  |  |  |
| AC-3800dd2b | this.Load | FPC0097_ColumnSetForm_Popup.cs:179 |  | GRID_INIT | si.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9df79ebb | this.Load | FPC0097_ColumnSetForm_Popup.cs:181 |  | GRID_INIT | si.AddTextColumn | ("LargeClass", "LARGE_CLASS_LABEL_NAME", FPMerge.Always, 80, isLarge) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e48af4b | this.Load | FPC0097_ColumnSetForm_Popup.cs:182 |  | GRID_INIT | si.AddTextColumn | ("SmallClass", "SMALL_CLASS_LABEL_NAME", FPMerge.Always, 80, isSmall) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-062b6a38 | this.Load | FPC0097_ColumnSetForm_Popup.cs:183 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a38b445 | this.Load | FPC0097_ColumnSetForm_Popup.cs:184 |  | GRID_INIT | si.AddTextColumn | ("Sort", "SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16c853cf | this.Load | FPC0097_ColumnSetForm_Popup.cs:185 |  | GRID_INIT | si.AddNumColumn | ("Seq", "SORT_ORDER_NO", FPMerge.None, 20, false, FPHAlign.Right, FPVAlign.Center, 2, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-58499756 | this.Load | FPC0097_ColumnSetForm_Popup.cs:186 |  | GRID_INIT | si.AddTextColumn | ("Sort", "USER_SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e5f194b0 | this.Load | FPC0097_ColumnSetForm_Popup.cs:187 |  | GRID_INIT | si.AddCheckColumn | ("Sub Total", "SUB_TOTAL_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1fc950d0 | this.Load | FPC0097_ColumnSetForm_Popup.cs:188 |  | GRID_INIT | si.AddTextColumn | ("USER_SELECTABLE_FLAG", "USER_SELECTABLE_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b7fd4b6 | this.Load | FPC0097_ColumnSetForm_Popup.cs:190 |  | GRID_SET | spdBase.Sheets[0].Columns[0, spdBase.Sheets[0].ColumnCount - 1].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-0f9c182d | this.Load | FPC0097_ColumnSetForm_Popup.cs:193 |  | GRID_INIT | this.AddSheet | (spdUser, "User", "User", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ce9abda3 | this.Load | FPC0097_ColumnSetForm_Popup.cs:195 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-adca5da1 | this.Load | FPC0097_ColumnSetForm_Popup.cs:196 |  | UI_PROP | si.IsRowMove | !_isBaseSort | 속성 IsRowMove 설정 |  |  |  |
| AC-d432c092 | this.Load | FPC0097_ColumnSetForm_Popup.cs:197 |  | GRID_INIT | si.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09673ec5 | this.Load | FPC0097_ColumnSetForm_Popup.cs:199 |  | GRID_INIT | si.AddTextColumn | ("LargeClass", "LARGE_CLASS_LABEL_NAME", FPMerge.Always, 80, isLarge) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-021ab46f | this.Load | FPC0097_ColumnSetForm_Popup.cs:200 |  | GRID_INIT | si.AddTextColumn | ("SmallClass", "SMALL_CLASS_LABEL_NAME", FPMerge.Always, 80, isSmall) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9bd34989 | this.Load | FPC0097_ColumnSetForm_Popup.cs:201 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5dbb1623 | this.Load | FPC0097_ColumnSetForm_Popup.cs:202 |  | GRID_INIT | si.AddTextColumn | ("Sort", "SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-acb09b04 | this.Load | FPC0097_ColumnSetForm_Popup.cs:203 |  | GRID_INIT | si.AddNumColumn | ("Seq", "SORT_ORDER_NO", FPMerge.None, 20, false, FPHAlign.Right, FPVAlign.Center, 2, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ece285aa | this.Load | FPC0097_ColumnSetForm_Popup.cs:204 |  | GRID_INIT | si.AddComboColumn | ("Sort", "USER_SORT_METHOD_CODE", FPMerge.None, 45, isColumn, dt) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f654c9d8 | this.Load | FPC0097_ColumnSetForm_Popup.cs:205 |  | GRID_INIT | si.AddCheckColumn | ("Sub Total", "SUB_TOTAL_FLAG", FPMerge.None, 40, _isSubTotal, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-973d2f6b | this.Load | FPC0097_ColumnSetForm_Popup.cs:206 |  | GRID_INIT | si.AddTextColumn | ("USER_SELECTABLE_FLAG", "USER_SELECTABLE_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b89abf5 | this.Load | FPC0097_ColumnSetForm_Popup.cs:208 |  | GRID_SET | spdUser.Sheets[0].Columns[0, spdUser.Sheets[0].Columns["COLUMN_LABEL_NAME"].Index].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-b9c7e35d | this.Load | FPC0097_ColumnSetForm_Popup.cs:210 |  | GRID_SET | spdUser.Sheets[0].Columns[spdUser.Sheets[0].Columns["USER_SORT_METHOD_CODE"].Index, spdUse… | 0 | 그리드 속성/값 설정 |  |  |  |

## FPC0097_ColumnSetForm_Popup.ResetWidth

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ae02088 | this.Load | FPC0097_ColumnSetForm_Popup.cs:232 |  | UI_PROP | this.Width | += iWidth | 속성 Width 설정 |  |  |  |
| AC-0d47eb12 | this.Load | FPC0097_ColumnSetForm_Popup.cs:233 |  | UI_PROP | splMain.SplitterDistance | this.Width / 2 - iWidth2 | 속성 SplitterDistance 설정 |  |  |  |

## FPC0097_ColumnSetForm_Popup.SaveColumnSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69b1d18f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:510 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ SCM.SCM0002_SET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-5e4dac79 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:511 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_program_id"] | sProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-e917c42a | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:512 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sheet_name"] | sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-d0cb241f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:513 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_column_type"] | sColumnSetType | 행/컬럼 값 대입 |  |  |  |
| AC-40e40754 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:514 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActive_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3342be4b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:515 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_column_name"] | sColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-c0188feb | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:516 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sort_order_no"] | sSortOrderNo | 행/컬럼 값 대입 |  |  |  |
| AC-b39337fe | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:517 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sub_total_flag"] | sSubTotalFlag | 행/컬럼 값 대입 |  |  |  |
| AC-30fab5c3 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:518 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sort_method_code"] | sSortMethod | 행/컬럼 값 대입 |  |  |  |
| AC-d2c66d2e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:519 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-9044057d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:521 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-94430b57 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:526 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dda18da5 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:530 | try ▸ if (iCount > 0) ▸ finally | MESSAGE | MessageHelper.GMessageBox | ("MSG00020", new object[] { _sColumnSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12c3d6b4 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:531 | try ▸ if (iCount > 0) ▸ finally | CALL_BASE | FindButton | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-30da8f18 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:544 | try ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { _sColumnSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c789ab1 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:545 | try ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2d5eb96 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0097_ColumnSetForm_Popup.cs:565 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006", new object[] { _sColumnSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FPC0097_ColumnSetForm_Popup.SetColumnSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Default:] / this.spdBase.CellDoubleClick / this.spdUser.CellDoubleClick / this.btnRight.Click / this.btnLeft.Click / this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2eba1a6b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:270 |  | DATA_OP | _dtColumnSet.Select | (sFilterColumn + " = 'N'", "SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a6c2702 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:270 |  | DATA_OP | _dtColumnSet.Select(sFilterColumn + " = 'N'", "SORT_ORDER_NO").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f45ba3c3 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:270 |  | DATA_OP | _dtColumnSet.Select | (sFilterColumn + " = 'N'", "SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-e817d0eb | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:271 |  | DATA_OP | _dtColumnSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-6452bd06 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:271 |  | DATA_OP | _dtColumnSet.Select(sFilterColumn + " = 'Y'", sSortColumn).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3f97a773 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:271 |  | DATA_OP | _dtColumnSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-83e73104 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:275 | if (dtBase == null) | GRID_SET | spdBase.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-aa83c630 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:277 | else of (dtBase == null) | GRID_BIND | si.Query | (dtBase, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ac61961b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:281 | if (dtUser == null) | GRID_SET | spdUser.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-dd9c5148 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:283 | else of (dtUser == null) | GRID_BIND | si.Query | (dtUser, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b822af6c | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:292 | for (r < svSource.Rows.Count) ▸ if (svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Text == "Y") | GRID_SET | svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-1f5750f3 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:296 | if (spdUser.Sheets[0].RowCount > 0) | GRID_SET | spdUser.Sheets[0].ActiveRowIndex | spdUser.Sheets[0].RowCount - 1 | 그리드 속성/값 설정 |  |  |  |
| AC-e199e8de | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:302 |  | CALL_EXT | svSource.GetSelections().GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c540c9d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:303 | if (svSource.GetSelections().GetLength(0) == 0) | CALL_EXT | svSource.AddSelection | (svSource.ActiveRowIndex, svSource.ActiveColumnIndex, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d27b6d2 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:326 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd655237 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:329 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-a409bece | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:331 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bee829b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:332 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-f64e9368 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:343 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-12d7e5f3 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:344 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-145120f6 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:346 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6e9f641 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:347 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-4a7cfee8 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:380 | foreach (int i in selectIndex.Keys) ▸ else of (activeRow + 1 >= svTarget.RowCount) | DATA_OP | svTarget.Rows.Add | (activeRow + 1, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9e0ea02 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:383 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["COLUMN_NAME"].Index].Text | sColumnName | 그리드 속성/값 설정 |  |  |  |
| AC-54f0462c | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:384 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["COLUMN_LABEL_NAME"].Index].Text | sLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-4a3ec55e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:385 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SMALL_CLASS_LABEL_NAME"].Index].Text | sSLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-6da205f4 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:386 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["LARGE_CLASS_LABEL_NAME"].Index].Text | sLLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-e84ef66d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:387 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SORT_METHOD_CODE"].Index].Text | sSortMethod | 그리드 속성/값 설정 |  |  |  |
| AC-7c42f0e7 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:388 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SORT_ORDER_NO"].Index].Text | sSortOrderNo | 그리드 속성/값 설정 |  |  |  |
| AC-46caeb1d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:389 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["USER_SORT_METHOD_CODE"].Index].Text | sUSortMethod | 그리드 속성/값 설정 |  |  |  |
| AC-17f6b066 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:390 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["USER_SELECTABLE_FLAG"].Index].Text | sUserSelectedFlag | 그리드 속성/값 설정 |  |  |  |
| AC-2ad1c0a6 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:396 |  | GRID_STYLE | svTarget.SetActiveCell | (activeRow, -1) | 그리드 표시 설정 |  |  |  |
| AC-64e958ba | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:401 | for (i >= 0) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-501222d8 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:403 | for (i >= 0) ▸ if (selectIndex.ContainsKey(i)) | CALL_EXT | svSource.RemoveRows | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f82933f8 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:408 | if (_isBaseSort == true) | CALL_EXT | svTarget.SortRows | (svTarget.Columns["SORT_ORDER_NO"].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fadd69e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0097_ColumnSetForm_Popup.cs:412 | else of (_isBaseSort == true) ▸ if (svTarget == spdBase.Sheets[0]) | CALL_EXT | svTarget.SortRows | (svTarget.Columns["SORT_ORDER_NO"].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0097_ColumnSetForm_Popup.spdUser_ButtonClicked

진입점: this.spdUser.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2d844e8 | this.spdUser.ButtonClicked | FPC0097_ColumnSetForm_Popup.cs:593 | if (e.Column != sv.Columns["SUB_TOTAL_FLAG"].Index) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07550ea4 | this.spdUser.ButtonClicked | FPC0097_ColumnSetForm_Popup.cs:597 | for (i < sv.RowCount) | GRID_SET | sv.Cells[i, e.Column].Value | "false" | 그리드 속성/값 설정 |  |  |  |

## FPC0097_ColumnSetForm_Popup.spdUser_RowDragMove

진입점: this.spdUser.RowDragMove

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f1b6507 | this.spdUser.RowDragMove | FPC0097_ColumnSetForm_Popup.cs:633 | if (sUserSelect != "Y") | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## FPC0097_ColumnSetForm_Popup.usrButtonList1_UsrButtonList_Click_Detected

진입점: this.usrButtonList1.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-382b968e | this.usrButtonList1.UsrButtonList_Click_Detected | FPC0097_ColumnSetForm_Popup.cs:618 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

