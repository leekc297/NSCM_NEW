# AS-IS 액션 대조표 — FPC0113

> 원천: `Doc/asisfacts/screens/FPC0113/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 117행 · 메서드 14 · 종류 DATA_OP 34 · GRID_INIT 22 · UI_PROP 16 · GRID_SET 16 · FLAG 6 · CALL_EXT 5 · ENDPOINT 4 · MESSAGE 4 · UI_MISC 3 · RETURN 2 · GRID_BIND 2 · VALUE_SET 1 · CALL_BASE 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 6


## FPC0113_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21b4f9f5 | .ctor | FPC0113_MeasureSetForm_Popup.cs:76 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-958ccb7c | .ctor | FPC0113_MeasureSetForm_Popup.cs:77 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-caef2dd1 | .ctor | FPC0113_MeasureSetForm_Popup.cs:78 |  | FLAG | _sColumnSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-601e95b9 | .ctor | FPC0113_MeasureSetForm_Popup.cs:79 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FPC0113_MeasureSetForm_Popup.ColumnSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47bea1dc | this.Load | FPC0113_MeasureSetForm_Popup.cs:116 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-989f9517 | this.Load | FPC0113_MeasureSetForm_Popup.cs:124 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0113_MeasureSetForm_Popup.ColumnSetForm_SizeChanged

진입점: this.SizeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db077a35 | this.SizeChanged | FPC0113_MeasureSetForm_Popup.cs:603 |  | UI_PROP | pnlCenterButton.Top | (pnlCenter.Height - pnlCenterButton.Height) / 2 | 속성 Top 설정 |  |  |  |

## FPC0113_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7cb99d3 | Dispose | FPC0113_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0113_MeasureSetForm_Popup.GetColumnSet

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e187e3af | .ctor | FPC0113_MeasureSetForm_Popup.cs:243 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0002_GET_TITLESET_POPUP") ⇒ SCM.SCM0002_GET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-e93a8188 | .ctor | FPC0113_MeasureSetForm_Popup.cs:245 |  | DATA_OP | request.Parameters["p_program_id"] | _sProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-b2de54fd | .ctor | FPC0113_MeasureSetForm_Popup.cs:246 |  | DATA_OP | request.Parameters["p_sheet_name"] | _sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-91104f18 | .ctor | FPC0113_MeasureSetForm_Popup.cs:247 |  | DATA_OP | request.Parameters["p_column_type"] | _sColumnSetType | 행/컬럼 값 대입 |  |  |  |
| AC-05b2129d | .ctor | FPC0113_MeasureSetForm_Popup.cs:248 |  | DATA_OP | request.Parameters["p_user_id"] | _sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-850127aa | .ctor | FPC0113_MeasureSetForm_Popup.cs:249 |  | DATA_OP | request.Parameters["p_division_id"] | _sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-42d1b460 | .ctor | FPC0113_MeasureSetForm_Popup.cs:250 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d41118e | .ctor | FPC0113_MeasureSetForm_Popup.cs:251 |  | FLAG | _dtColumnSet | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FPC0113_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa8c7f6d | this.Load | FPC0113_MeasureSetForm_Popup.cs:129 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FPC0113_MeasureSetForm_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e31108e9 | this.Load | FPC0113_MeasureSetForm_Popup.cs:133 |  | UI_PROP | pnlBottom.Dock | DockStyle.Bottom | 속성 Dock 설정 |  |  |  |
| AC-ab2701dd | this.Load | FPC0113_MeasureSetForm_Popup.cs:135 |  | UI_PROP | pnlCenter.Dock | DockStyle.Left | 속성 Dock 설정 |  |  |  |
| AC-9cdc8279 | this.Load | FPC0113_MeasureSetForm_Popup.cs:137 |  | UI_PROP | spdBase.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-adbfaba5 | this.Load | FPC0113_MeasureSetForm_Popup.cs:138 |  | UI_PROP | spdUser.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-01937910 | this.Load | FPC0113_MeasureSetForm_Popup.cs:139 |  | UI_PROP | splMain.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-19bdbafe | this.Load | FPC0113_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | this.Text | _sColumnSetType == "C" ? "Column Setting" : "Measure Setting" | 컨트롤 값 설정 |  |  |  |
| AC-abf28a12 | this.Load | FPC0113_MeasureSetForm_Popup.cs:142 |  | UI_PROP | this.Size | new Size(440, 400) | 속성 Size 설정 |  |  |  |
| AC-56dfa266 | this.Load | FPC0113_MeasureSetForm_Popup.cs:145 |  | UI_PROP | this.Size | new Size(_sColumnSetType == "C" ? 600 : 600, 400) | 속성 Size 설정 |  |  |  |
| AC-58674cc4 | this.Load | FPC0113_MeasureSetForm_Popup.cs:148 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth)) | 속성 SplitterDistance 설정 |  |  |  |
| AC-419c439f | this.Load | FPC0113_MeasureSetForm_Popup.cs:149 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth) / 2) | 속성 SplitterDistance 설정 |  |  |  |

## FPC0113_MeasureSetForm_Popup.InitSheet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-883ae8e6 | this.Load | FPC0113_MeasureSetForm_Popup.cs:156 |  | DATA_OP | dt.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9eae9f18 | this.Load | FPC0113_MeasureSetForm_Popup.cs:157 |  | DATA_OP | dt.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7a1b9ec | this.Load | FPC0113_MeasureSetForm_Popup.cs:158 |  | DATA_OP | dt.Rows.Add | (new object[] { "ASC", "ASC" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-290e64ed | this.Load | FPC0113_MeasureSetForm_Popup.cs:159 |  | DATA_OP | dt.Rows.Add | (new object[] { "DESC", "DESC" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef886e18 | this.Load | FPC0113_MeasureSetForm_Popup.cs:175 |  | GRID_INIT | this.AddSheet | (spdBase, "Base", "Base", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a7f7ffdb | this.Load | FPC0113_MeasureSetForm_Popup.cs:177 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-d806a8e4 | this.Load | FPC0113_MeasureSetForm_Popup.cs:178 |  | UI_PROP | si.IsRowMove | !_isBaseSort | 속성 IsRowMove 설정 |  |  |  |
| AC-1532cd53 | this.Load | FPC0113_MeasureSetForm_Popup.cs:179 |  | GRID_INIT | si.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f689514 | this.Load | FPC0113_MeasureSetForm_Popup.cs:181 |  | GRID_INIT | si.AddTextColumn | ("LargeClass", "LARGE_CLASS_LABEL_NAME", FPMerge.Always, 80, isLarge) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94cddc39 | this.Load | FPC0113_MeasureSetForm_Popup.cs:182 |  | GRID_INIT | si.AddTextColumn | ("SmallClass", "SMALL_CLASS_LABEL_NAME", FPMerge.Always, 80, isSmall) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-053449d4 | this.Load | FPC0113_MeasureSetForm_Popup.cs:183 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc335e30 | this.Load | FPC0113_MeasureSetForm_Popup.cs:184 |  | GRID_INIT | si.AddTextColumn | ("Sort", "SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d0b6d70a | this.Load | FPC0113_MeasureSetForm_Popup.cs:185 |  | GRID_INIT | si.AddNumColumn | ("Seq", "SORT_ORDER_NO", FPMerge.None, 20, false, FPHAlign.Right, FPVAlign.Center, 2, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30133f82 | this.Load | FPC0113_MeasureSetForm_Popup.cs:186 |  | GRID_INIT | si.AddTextColumn | ("Sort", "USER_SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-362c2c62 | this.Load | FPC0113_MeasureSetForm_Popup.cs:187 |  | GRID_INIT | si.AddCheckColumn | ("Sub Total", "SUB_TOTAL_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c151bf61 | this.Load | FPC0113_MeasureSetForm_Popup.cs:188 |  | GRID_INIT | si.AddTextColumn | ("USER_SELECTABLE_FLAG", "USER_SELECTABLE_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06de7da8 | this.Load | FPC0113_MeasureSetForm_Popup.cs:190 |  | GRID_SET | spdBase.Sheets[0].Columns[0, spdBase.Sheets[0].ColumnCount - 1].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-dc2e97fe | this.Load | FPC0113_MeasureSetForm_Popup.cs:193 |  | GRID_INIT | this.AddSheet | (spdUser, "User", "User", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f77d0100 | this.Load | FPC0113_MeasureSetForm_Popup.cs:195 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-078f8de1 | this.Load | FPC0113_MeasureSetForm_Popup.cs:196 |  | UI_PROP | si.IsRowMove | !_isBaseSort | 속성 IsRowMove 설정 |  |  |  |
| AC-b062e967 | this.Load | FPC0113_MeasureSetForm_Popup.cs:197 |  | GRID_INIT | si.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f67cd4bc | this.Load | FPC0113_MeasureSetForm_Popup.cs:199 |  | GRID_INIT | si.AddTextColumn | ("LargeClass", "LARGE_CLASS_LABEL_NAME", FPMerge.Always, 80, isLarge) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8cdb94fd | this.Load | FPC0113_MeasureSetForm_Popup.cs:200 |  | GRID_INIT | si.AddTextColumn | ("SmallClass", "SMALL_CLASS_LABEL_NAME", FPMerge.Always, 80, isSmall) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c97180f2 | this.Load | FPC0113_MeasureSetForm_Popup.cs:201 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a146435 | this.Load | FPC0113_MeasureSetForm_Popup.cs:202 |  | GRID_INIT | si.AddTextColumn | ("Sort", "SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-340019e8 | this.Load | FPC0113_MeasureSetForm_Popup.cs:203 |  | GRID_INIT | si.AddNumColumn | ("Seq", "SORT_ORDER_NO", FPMerge.None, 20, false, FPHAlign.Right, FPVAlign.Center, 2, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8aabbb61 | this.Load | FPC0113_MeasureSetForm_Popup.cs:204 |  | GRID_INIT | si.AddComboColumn | ("Sort", "USER_SORT_METHOD_CODE", FPMerge.None, 45, isColumn, dt) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae2d2d1b | this.Load | FPC0113_MeasureSetForm_Popup.cs:205 |  | GRID_INIT | si.AddCheckColumn | ("Sub Total", "SUB_TOTAL_FLAG", FPMerge.None, 40, _isSubTotal, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8531d566 | this.Load | FPC0113_MeasureSetForm_Popup.cs:206 |  | GRID_INIT | si.AddTextColumn | ("USER_SELECTABLE_FLAG", "USER_SELECTABLE_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f8979e3 | this.Load | FPC0113_MeasureSetForm_Popup.cs:208 |  | GRID_SET | spdUser.Sheets[0].Columns[0, spdUser.Sheets[0].Columns["COLUMN_LABEL_NAME"].Index].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-8ed09a34 | this.Load | FPC0113_MeasureSetForm_Popup.cs:210 |  | GRID_SET | spdUser.Sheets[0].Columns[spdUser.Sheets[0].Columns["USER_SORT_METHOD_CODE"].Index, spdUse… | 0 | 그리드 속성/값 설정 |  |  |  |

## FPC0113_MeasureSetForm_Popup.ResetWidth

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-541c1423 | this.Load | FPC0113_MeasureSetForm_Popup.cs:232 |  | UI_PROP | this.Width | += iWidth | 속성 Width 설정 |  |  |  |
| AC-92feaf3b | this.Load | FPC0113_MeasureSetForm_Popup.cs:233 |  | UI_PROP | splMain.SplitterDistance | this.Width / 2 - iWidth2 | 속성 SplitterDistance 설정 |  |  |  |

## FPC0113_MeasureSetForm_Popup.SaveColumnSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01fa798f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:510 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ SCM.SCM0002_SET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-dbc9e081 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:511 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_program_id"] | sProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-a5be2555 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:512 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sheet_name"] | sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-d020c940 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:513 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_column_type"] | sColumnSetType | 행/컬럼 값 대입 |  |  |  |
| AC-913b535c | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:514 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActive_flag | 행/컬럼 값 대입 |  |  |  |
| AC-dd9b621c | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:515 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_column_name"] | sColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-7d5d1a86 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:516 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sort_order_no"] | sSortOrderNo | 행/컬럼 값 대입 |  |  |  |
| AC-f4e695be | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:517 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sub_total_flag"] | sSubTotalFlag | 행/컬럼 값 대입 |  |  |  |
| AC-2a79e807 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:518 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sort_method_code"] | sSortMethod | 행/컬럼 값 대입 |  |  |  |
| AC-e4e4511f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:519 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-98bd7ed5 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:521 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3d8af59d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:526 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b5b5693 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:530 | try ▸ if (iCount > 0) ▸ finally | MESSAGE | MessageHelper.GMessageBox | ("MSG00020", new object[] { _sColumnSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41036b12 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:531 | try ▸ if (iCount > 0) ▸ finally | CALL_BASE | FindButton | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-938f860c | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:544 | try ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { _sColumnSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57bf6111 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:545 | try ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4fcebca1 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | FPC0113_MeasureSetForm_Popup.cs:565 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006", new object[] { _sColumnSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FPC0113_MeasureSetForm_Popup.SetColumnSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Default:] / this.spdBase.CellDoubleClick / this.spdUser.CellDoubleClick / this.btnRight.Click / this.btnLeft.Click / this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25a8dd1f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:270 |  | DATA_OP | _dtColumnSet.Select | (sFilterColumn + " = 'N'", "SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-e63adf29 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:270 |  | DATA_OP | _dtColumnSet.Select(sFilterColumn + " = 'N'", "SORT_ORDER_NO").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5232ab02 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:270 |  | DATA_OP | _dtColumnSet.Select | (sFilterColumn + " = 'N'", "SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-64aabdb9 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:271 |  | DATA_OP | _dtColumnSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-63203819 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:271 |  | DATA_OP | _dtColumnSet.Select(sFilterColumn + " = 'Y'", sSortColumn).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-793b02f5 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:271 |  | DATA_OP | _dtColumnSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa755cae | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:275 | if (dtBase == null) | GRID_SET | spdBase.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-4c4309a8 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:277 | else of (dtBase == null) | GRID_BIND | si.Query | (dtBase, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f778cd2e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:281 | if (dtUser == null) | GRID_SET | spdUser.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-53467fa1 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:283 | else of (dtUser == null) | GRID_BIND | si.Query | (dtUser, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e6d4e305 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:292 | for (r < svSource.Rows.Count) ▸ if (svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Text == "Y") | GRID_SET | svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-986bbf83 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:296 | if (spdUser.Sheets[0].RowCount > 0) | GRID_SET | spdUser.Sheets[0].ActiveRowIndex | spdUser.Sheets[0].RowCount - 1 | 그리드 속성/값 설정 |  |  |  |
| AC-9b1de597 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:302 |  | CALL_EXT | svSource.GetSelections().GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-77077511 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:303 | if (svSource.GetSelections().GetLength(0) == 0) | CALL_EXT | svSource.AddSelection | (svSource.ActiveRowIndex, svSource.ActiveColumnIndex, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e3731c7 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:326 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-e73eea73 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:329 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-165f2952 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:331 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-70aefd16 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:332 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-3ad8304d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:343 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-0da33063 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:344 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-84b3d8b4 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:346 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc105883 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:347 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-d622b0f0 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:380 | foreach (int i in selectIndex.Keys) ▸ else of (activeRow + 1 >= svTarget.RowCount) | DATA_OP | svTarget.Rows.Add | (activeRow + 1, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddccd902 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:383 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["COLUMN_NAME"].Index].Text | sColumnName | 그리드 속성/값 설정 |  |  |  |
| AC-6537cc60 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:384 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["COLUMN_LABEL_NAME"].Index].Text | sLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-ec9732f8 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:385 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SMALL_CLASS_LABEL_NAME"].Index].Text | sSLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-18377ed9 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:386 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["LARGE_CLASS_LABEL_NAME"].Index].Text | sLLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-5a37b3dd | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:387 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SORT_METHOD_CODE"].Index].Text | sSortMethod | 그리드 속성/값 설정 |  |  |  |
| AC-cdde994a | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:388 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SORT_ORDER_NO"].Index].Text | sSortOrderNo | 그리드 속성/값 설정 |  |  |  |
| AC-f236e256 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:389 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["USER_SORT_METHOD_CODE"].Index].Text | sUSortMethod | 그리드 속성/값 설정 |  |  |  |
| AC-b8cf73f8 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:390 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["USER_SELECTABLE_FLAG"].Index].Text | sUserSelectedFlag | 그리드 속성/값 설정 |  |  |  |
| AC-68b581f4 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:396 |  | GRID_STYLE | svTarget.SetActiveCell | (activeRow, -1) | 그리드 표시 설정 |  |  |  |
| AC-19732cfd | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:401 | for (i >= 0) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-693e6789 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:403 | for (i >= 0) ▸ if (selectIndex.ContainsKey(i)) | CALL_EXT | svSource.RemoveRows | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81a97aa9 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:408 | if (_isBaseSort == true) | CALL_EXT | svTarget.SortRows | (svTarget.Columns["SORT_ORDER_NO"].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f83ba39 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | FPC0113_MeasureSetForm_Popup.cs:412 | else of (_isBaseSort == true) ▸ if (svTarget == spdBase.Sheets[0]) | CALL_EXT | svTarget.SortRows | (svTarget.Columns["SORT_ORDER_NO"].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0113_MeasureSetForm_Popup.spdUser_ButtonClicked

진입점: this.spdUser.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62faa8b6 | this.spdUser.ButtonClicked | FPC0113_MeasureSetForm_Popup.cs:593 | if (e.Column != sv.Columns["SUB_TOTAL_FLAG"].Index) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8cc7b00 | this.spdUser.ButtonClicked | FPC0113_MeasureSetForm_Popup.cs:597 | for (i < sv.RowCount) | GRID_SET | sv.Cells[i, e.Column].Value | "false" | 그리드 속성/값 설정 |  |  |  |

## FPC0113_MeasureSetForm_Popup.spdUser_RowDragMove

진입점: this.spdUser.RowDragMove

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1843a98b | this.spdUser.RowDragMove | FPC0113_MeasureSetForm_Popup.cs:633 | if (sUserSelect != "Y") | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## FPC0113_MeasureSetForm_Popup.usrButtonList1_UsrButtonList_Click_Detected

진입점: this.usrButtonList1.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0c93cb0 | this.usrButtonList1.UsrButtonList_Click_Detected | FPC0113_MeasureSetForm_Popup.cs:618 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

