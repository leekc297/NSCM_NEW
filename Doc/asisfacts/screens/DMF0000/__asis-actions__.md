# AS-IS 액션 대조표 — DMF0000

> 원천: `Doc/asisfacts/screens/DMF0000/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 383행 · 메서드 46 · 종류 DATA_OP 66 · FLAG 52 · GRID_INIT 33 · RETURN 31 · GRID_LOCK 29 · ENDPOINT 23 · MESSAGE 23 · UI_PROP 21 · COMBO_DATA 20 · UI_MISC 18 · GRID_COMBO 12 · VALUE_SET 11 · GRID_SET 11 · POPUP 8 · LIST_REBIND 7 · STATE 5 · CALL_EXT 5 · GRID_BIND 3 · GRID_STYLE 3 · STATE_RESET 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 6


## DMF0000_EOL_BasicMngPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eb660de | this.btnButtonList.UsrButtonList_Click_Detected | DMF0000_EOL_BasicMngPopup.cs:596 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0000_EOL_BasicMngPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-812bebb2 | this.Load | DMF0000_EOL_BasicMngPopup.cs:202 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-43be980f | this.Load | DMF0000_EOL_BasicMngPopup.cs:203 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-59145ed7 | this.Load | DMF0000_EOL_BasicMngPopup.cs:204 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0000_EOL_BasicMngPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4192b4d | this.Load | DMF0000_EOL_BasicMngPopup.cs:192 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-47322092 | this.Load | DMF0000_EOL_BasicMngPopup.cs:194 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a3dc8bc5 | this.Load | DMF0000_EOL_BasicMngPopup.cs:195 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-d7244a23 | this.Load | DMF0000_EOL_BasicMngPopup.cs:196 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-3e55d66a | this.Load | DMF0000_EOL_BasicMngPopup.cs:197 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0000_EOL_BasicMngPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23d54806 | Dispose | DMF0000_EOL_BasicMngPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0000_EOL_BasicMngPopup.DoubleCheck

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33068b93 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:769 | if ((iValidation > 1) && bValidation == true) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-03b137aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:771 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0000_EOL_BasicMngPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d153004 | EditButton | DMF0000_EOL_BasicMngPopup.cs:238 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-dcfa2275 | EditButton | DMF0000_EOL_BasicMngPopup.cs:239 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-92693316 | EditButton | DMF0000_EOL_BasicMngPopup.cs:242 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.Division) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Division), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-43048439 | EditButton | DMF0000_EOL_BasicMngPopup.cs:244 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.Team) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Team), siMain.GetMaxRowIndex(), siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4ddc56d6 | EditButton | DMF0000_EOL_BasicMngPopup.cs:246 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.Customer) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Customer), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a6b9165 | EditButton | DMF0000_EOL_BasicMngPopup.cs:248 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.Customer40) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Customer40), siMain.GetMaxRowIndex(), siMain.GetColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-15de530e | EditButton | DMF0000_EOL_BasicMngPopup.cs:250 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ScmSiteId), siMain.GetMaxRowIndex(), siMain.GetColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-abeabf11 | EditButton | DMF0000_EOL_BasicMngPopup.cs:252 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.Project) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Project), siMain.GetMaxRowIndex(), siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dc40a809 | EditButton | DMF0000_EOL_BasicMngPopup.cs:254 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.ProjectName) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ProjectName), siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ed10c25f | EditButton | DMF0000_EOL_BasicMngPopup.cs:256 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.ProjectStatus) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.GetMaxRowIndex(), siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d2ccdd11 | EditButton | DMF0000_EOL_BasicMngPopup.cs:258 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.ItemId) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ItemId), siMain.GetMaxRowIndex(), siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7ff7cd61 | EditButton | DMF0000_EOL_BasicMngPopup.cs:260 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.ItemName) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ItemName), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c43bb1d3 | EditButton | DMF0000_EOL_BasicMngPopup.cs:262 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.GetMaxRowIndex(), siMain.Ge… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a71a674 | EditButton | DMF0000_EOL_BasicMngPopup.cs:264 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY) > 0) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetMaxRowIndex(), siMain.Get… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5543e57f | EditButton | DMF0000_EOL_BasicMngPopup.cs:268 | if (this.fps != null) | UI_PROP | dInfo.BackColor | Color.Lavender | 속성 BackColor 설정 |  |  |  |
| AC-bb132dbf | EditButton | DMF0000_EOL_BasicMngPopup.cs:270 | if (this.fps != null) | UI_PROP | mInfo.BackColor | Color.Azure | 속성 BackColor 설정 |  |  |  |
| AC-ae6fca79 | EditButton | DMF0000_EOL_BasicMngPopup.cs:272 | if (this.fps != null) | UI_PROP | yInfo.BackColor | Color.Crimson | 속성 BackColor 설정 |  |  |  |
| AC-1ea3c58a | EditButton | DMF0000_EOL_BasicMngPopup.cs:274 | if (this.fps != null) | VALUE_SET | lInfo.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-1af6e75e | EditButton | DMF0000_EOL_BasicMngPopup.cs:277 | if (this.fps != null) | STATE_RESET | gcdateCellFields.Fields.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b870f978 | EditButton | DMF0000_EOL_BasicMngPopup.cs:278 | if (this.fps != null) | DATA_OP | gcdateCellFields.Fields.Add | (yInfo) | 데이터 객체 조작/조회 |  |  |  |
| AC-daceb19a | EditButton | DMF0000_EOL_BasicMngPopup.cs:279 | if (this.fps != null) | DATA_OP | gcdateCellFields.Fields.Add | (lInfo) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa59a9a9 | EditButton | DMF0000_EOL_BasicMngPopup.cs:280 | if (this.fps != null) | DATA_OP | gcdateCellFields.Fields.Add | (mInfo) | 데이터 객체 조작/조회 |  |  |  |
| AC-542792c5 | EditButton | DMF0000_EOL_BasicMngPopup.cs:281 | if (this.fps != null) | DATA_OP | gcdateCellFields.Fields.Add | (lInfo) | 데이터 객체 조작/조회 |  |  |  |
| AC-51a57e1a | EditButton | DMF0000_EOL_BasicMngPopup.cs:282 | if (this.fps != null) | DATA_OP | gcdateCellFields.Fields.Add | (dInfo) | 데이터 객체 조작/조회 |  |  |  |
| AC-af7eba95 | EditButton | DMF0000_EOL_BasicMngPopup.cs:286 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.EOL_BASE_DATE)].CellType | gcdateCellFields | 그리드 속성/값 설정 |  |  |  |

## DMF0000_EOL_BasicMngPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-597d717c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:302 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-377fcf19 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:303 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-091cf512 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:305 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c3bf45f1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:319 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_DM_MST_EOL_DATA") ⇒ DM.DMF0000_GET_DM_MST_EOL_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-70af8a80 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:323 |  | DATA_OP | request.Parameters["p_Division_id"] | p_Division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2be1ae15 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:324 |  | DATA_OP | request.Parameters["p_TeamId"] | p_TeamId | 행/컬럼 값 대입 |  |  |  |
| AC-b0858a38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:325 |  | DATA_OP | request.Parameters["p_Customer"] | p_Customer | 행/컬럼 값 대입 |  |  |  |
| AC-c605f51a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:326 |  | DATA_OP | request.Parameters["p_SalesSite"] | p_SalesSite | 행/컬럼 값 대입 |  |  |  |
| AC-aa229131 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:327 |  | DATA_OP | request.Parameters["p_Project"] | p_Project | 행/컬럼 값 대입 |  |  |  |
| AC-ccaf1a63 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:328 |  | DATA_OP | request.Parameters["p_ItemId"] | p_ItemId | 행/컬럼 값 대입 |  |  |  |
| AC-9d6bb1c0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:330 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a9ba88a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:336 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3cfbeb54 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:337 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a482923b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:339 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1b5e910f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:340 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2cc3d4b1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:343 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0000_EOL_BasicMngPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d4c0864 | this.Load | DMF0000_EOL_BasicMngPopup.cs:117 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f705084 | this.Load | DMF0000_EOL_BasicMngPopup.cs:119 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c2f8c754 | this.Load | DMF0000_EOL_BasicMngPopup.cs:124 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-942ca0dd | this.Load | DMF0000_EOL_BasicMngPopup.cs:125 |  | UI_PROP | this.IsPopupEditCheck | false | 속성 IsPopupEditCheck 설정 |  |  |  |
| AC-223e4e03 | this.Load | DMF0000_EOL_BasicMngPopup.cs:132 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-ef03b3ab | this.Load | DMF0000_EOL_BasicMngPopup.cs:133 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-077269fe | this.Load | DMF0000_EOL_BasicMngPopup.cs:134 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-d89a172f | this.Load | DMF0000_EOL_BasicMngPopup.cs:135 |  | FLAG | sDeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-5f144e5a | this.Load | DMF0000_EOL_BasicMngPopup.cs:136 |  | FLAG | sEndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-103ac4f9 | this.Load | DMF0000_EOL_BasicMngPopup.cs:137 |  | FLAG | sSCM_SITE_ID | _SCM_SITE_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-13ebb000 | this.Load | DMF0000_EOL_BasicMngPopup.cs:138 |  | FLAG | sItemid | _ItemID | 화면 필드/플래그 변경 |  |  |  |

## DMF0000_EOL_BasicMngPopup.GetLookupValues

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-543b25bd | this.Load | DMF0000_EOL_BasicMngPopup.cs:577 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-689377b6 | this.Load | DMF0000_EOL_BasicMngPopup.cs:578 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-45005197 | this.Load | DMF0000_EOL_BasicMngPopup.cs:579 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d073c8af | this.Load | DMF0000_EOL_BasicMngPopup.cs:582 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0000_EOL_BasicMngPopup.GetSpdTitle

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae8110df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:557 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-24914baf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:558 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-95f38a66 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:559 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5d1868ff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:560 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5c956e16 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:561 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF000" | 행/컬럼 값 대입 |  |  |  |
| AC-c4fd0443 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:562 |  | DATA_OP | request.Parameters["p_sheet_name"] | "EOL BasicInfo Popup" | 행/컬럼 값 대입 |  |  |  |
| AC-de6af087 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:563 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6d2014b9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:565 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-211bd126 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:565 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-97a7aca2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:568 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0000_EOL_BasicMngPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-460e65e5 | this.Load | DMF0000_EOL_BasicMngPopup.cs:144 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-842afedc | this.Load | DMF0000_EOL_BasicMngPopup.cs:144 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66f0f3d7 | this.Load | DMF0000_EOL_BasicMngPopup.cs:145 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5f736659 | this.Load | DMF0000_EOL_BasicMngPopup.cs:146 |  | VALUE_SET | cboDivision.Text | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-d19b113b | this.Load | DMF0000_EOL_BasicMngPopup.cs:148 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-7851ef74 | this.Load | DMF0000_EOL_BasicMngPopup.cs:148 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f472cdcb | this.Load | DMF0000_EOL_BasicMngPopup.cs:149 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1d79c104 | this.Load | DMF0000_EOL_BasicMngPopup.cs:150 |  | VALUE_SET | clbTeam.ControlValues | sDeptID | 컨트롤 값 설정 |  |  |  |
| AC-f4e7e491 | this.Load | DMF0000_EOL_BasicMngPopup.cs:154 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-d71f8d81 | this.Load | DMF0000_EOL_BasicMngPopup.cs:154 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9ac07f70 | this.Load | DMF0000_EOL_BasicMngPopup.cs:155 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-36438355 | this.Load | DMF0000_EOL_BasicMngPopup.cs:159 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-44a12ce7 | this.Load | DMF0000_EOL_BasicMngPopup.cs:159 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sDeptID… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8e2929e7 | this.Load | DMF0000_EOL_BasicMngPopup.cs:160 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5c8eeb02 | this.Load | DMF0000_EOL_BasicMngPopup.cs:163 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-515588c7 | this.Load | DMF0000_EOL_BasicMngPopup.cs:163 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-76ccd6bf | this.Load | DMF0000_EOL_BasicMngPopup.cs:164 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-767dc93c | this.Load | DMF0000_EOL_BasicMngPopup.cs:166 |  | VALUE_SET | txtProject.Text | sProject | 컨트롤 값 설정 |  |  |  |
| AC-c655dc41 | this.Load | DMF0000_EOL_BasicMngPopup.cs:167 |  | VALUE_SET | txtItem.Text | sItemid | 컨트롤 값 설정 |  |  |  |
| AC-2ed124fe | this.Load | DMF0000_EOL_BasicMngPopup.cs:168 |  | VALUE_SET | clbEndCustomer.ControlValues | sEndCustomer | 컨트롤 값 설정 |  |  |  |
| AC-b5a35eed | this.Load | DMF0000_EOL_BasicMngPopup.cs:169 |  | VALUE_SET | clbSalesSite.ControlValues | sSCM_SITE_ID | 컨트롤 값 설정 |  |  |  |
| AC-7d526db5 | this.Load | DMF0000_EOL_BasicMngPopup.cs:172 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-01f84a7f | this.Load | DMF0000_EOL_BasicMngPopup.cs:173 |  | STATE | clbTeam.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cbf1fd9c | this.Load | DMF0000_EOL_BasicMngPopup.cs:174 |  | STATE | clbEndCustomer.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e7a15b8b | this.Load | DMF0000_EOL_BasicMngPopup.cs:175 |  | STATE | clbSalesSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d94f73a7 | this.Load | DMF0000_EOL_BasicMngPopup.cs:179 |  | FLAG | dtIncoterms | GetLookupValues("INCOTERMS") | 화면 필드/플래그 변경 |  |  |  |
| AC-59688b7e | this.Load | DMF0000_EOL_BasicMngPopup.cs:180 |  | FLAG | dtFcstType | GetLookupValues("SALES_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-15fe985b | this.Load | DMF0000_EOL_BasicMngPopup.cs:182 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-e52d5db0 | this.Load | DMF0000_EOL_BasicMngPopup.cs:182 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f45844fc | this.Load | DMF0000_EOL_BasicMngPopup.cs:183 |  | FLAG | dtDomExp | GetLookupValues("DOM/EXP") | 화면 필드/플래그 변경 |  |  |  |

## DMF0000_EOL_BasicMngPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56121fff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0000_EOL_BasicMngPopup.cs:212 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0000_EOL_BasicMngPopup.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9bfec46 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:482 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4823ad58 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:483 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8ea3c520 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:485 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), sDivision) | 그리드 값 설정 |  |  |  |
| AC-a8aefc94 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:490 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") ▸ if (s… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)].… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-43ef80af | InsertButton | DMF0000_EOL_BasicMngPopup.cs:495 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") ▸ … | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8f31c599 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:497 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") ▸ … | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)].… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8ba29627 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:499 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectName), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d390c5e9 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:502 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f598d40 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:503 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemName), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2fca0870 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:504 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-36796bd8 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:505 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c0844a37 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:506 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-38bb61fb | InsertButton | DMF0000_EOL_BasicMngPopup.cs:508 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33138126 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:509 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Team), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c713f47f | InsertButton | DMF0000_EOL_BasicMngPopup.cs:514 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-5bbe81c9 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:514 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aaec05de | InsertButton | DMF0000_EOL_BasicMngPopup.cs:515 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Customer40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b1360b0f | InsertButton | DMF0000_EOL_BasicMngPopup.cs:519 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-e7d2a9c7 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:519 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sDeptID… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-793e7b07 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:520 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Customer), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1abde3a3 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:523 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc389c34 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:524 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2fe8ac84 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:528 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | day.ShowLeadingZero | true | 속성 ShowLeadingZero 설정 |  |  |  |
| AC-b0cfca62 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:530 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | month.ShowLeadingZero | true | 속성 ShowLeadingZero 설정 |  |  |  |
| AC-282498fc | InsertButton | DMF0000_EOL_BasicMngPopup.cs:532 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | year.ShowLeadingZero | true | 속성 ShowLeadingZero 설정 |  |  |  |
| AC-a3962ee9 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:534 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALUE_SET | lday.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-da9d563f | InsertButton | DMF0000_EOL_BasicMngPopup.cs:537 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | gcdateCellDisplayFields.DisplayFields.Add | (year) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b00f736 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:538 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | gcdateCellDisplayFields.DisplayFields.Add | (lday) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a5921e6 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:539 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | gcdateCellDisplayFields.DisplayFields.Add | (month) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a17022f | InsertButton | DMF0000_EOL_BasicMngPopup.cs:540 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | gcdateCellDisplayFields.DisplayFields.Add | (lday) | 데이터 객체 조작/조회 |  |  |  |
| AC-fadc0562 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:541 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | gcdateCellDisplayFields.DisplayFields.Add | (day) | 데이터 객체 조작/조회 |  |  |  |
| AC-c20bd39a | InsertButton | DMF0000_EOL_BasicMngPopup.cs:543 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.EOL_BASE_… | gcdateCellDisplayFields | 그리드 속성/값 설정 |  |  |  |
| AC-0495c495 | InsertButton | DMF0000_EOL_BasicMngPopup.cs:545 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0000_EOL_BasicMngPopup.NullCheck

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de91563b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:794 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (String.IsNullOrEmpty(SalesSite1) == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4b95b459 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:796 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (String.IsNullOrEmpty(SalesSite1) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0ee8baa9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:801 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((String.IsNullOrEmpty(ProjectCode1) == true) && (sDivision != "40")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3eaef010 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:803 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((String.IsNullOrEmpty(ProjectCode1) == true) && (sDivision != "40")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-111dea2b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:808 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (String.IsNullOrEmpty(Model1) == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b8cb229 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:810 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (String.IsNullOrEmpty(Model1) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-84c74e18 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:815 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (String.IsNullOrEmpty(ValidYN1) == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a122d4c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:817 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (String.IsNullOrEmpty(ValidYN1) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dbdb74ad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:822 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (String.IsNullOrEmpty(BaseDate1) == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f9cc37e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:824 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (String.IsNullOrEmpty(BaseDate1) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-419816d5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:827 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0000_EOL_BasicMngPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71821e4c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:354 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (NullCheck() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80b66f46 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:359 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (DoubleCheck() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-efb18d23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:360 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (DoubleCheck() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48545145 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:434 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_SAVE_DM_MST_EOL_MODEL") ⇒ DM.DMF0000_SAVE_DM_MST_EOL_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-7303db38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:435 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a720a88a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:436 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | pProject | 행/컬럼 값 대입 |  |  |  |
| AC-89d7cea1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | pSalesSite | 행/컬럼 값 대입 |  |  |  |
| AC-ccb0fe4e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:438 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | pModel | 행/컬럼 값 대입 |  |  |  |
| AC-5d6747a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:439 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | pValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-205e4d7e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:440 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_eol_base_date"] | pBaseDate | 행/컬럼 값 대입 |  |  |  |
| AC-1d477767 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:443 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | pUserId | 행/컬럼 값 대입 |  |  |  |
| AC-7d4b9da8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:445 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0b451c11 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:449 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb98e197 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:453 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d033a878 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:461 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6f7ff30e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_EOL_BasicMngPopup.cs:470 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0000_EOL_BasicMngPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81dccaa7 | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:651 | if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6809c75d | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:666 | if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-4b582fe7 | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:667 | if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, strDivision, strTeam, strEndCustomer, strScmSite, strProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-96e73b67 | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:668 | if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-119959dd | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:669 | if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2c0a22d7 | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:679 | if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (strProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, strProject) | 그리드 값 설정 |  |  |  |
| AC-cae34ea0 | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:680 | if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (strProject != "") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), strProjectName) | 그리드 값 설정 |  |  |  |
| AC-959ec7cb | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:705 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-10b4933c | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:706 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) | POPUP | popItem.Form_Load | (false, strDivision, strTeam, strEndCustomer, strScmSite, strProject, strItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-fea604bc | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:707 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6bdd731d | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:708 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-761790a0 | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:717 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if (strItemId … | GRID_SET | siMain.SetText | (e.Row, e.Column, strItemId) | 그리드 값 설정 |  |  |  |
| AC-f187e795 | this.spdMain.CellDoubleClick | DMF0000_EOL_BasicMngPopup.cs:718 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if (strItemId … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemName), strItemName) | 그리드 값 설정 |  |  |  |

## DMF0000_EOL_BasicMngPopup.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7996739 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:612 | if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", strTeam, UserInfoContext.Current["NowGroupI… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-afb3948c | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:614 | if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ddf45719 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:617 | if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (sDivision == "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-3a70d9ed | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:617 | if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, strCust… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e0106912 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:618 | if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-af46fdd6 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:623 | if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, strTeam… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a8911722 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:624 | if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-972278d8 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:627 | if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (sDivision == "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-de9c715a | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:627 | if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, strCust… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5bf44808 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:628 | if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-23ba4e77 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:635 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-28ae7168 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:635 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, strEndC… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37f27e2c | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:636 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dffb1da6 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:642 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Colu… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1a32c9ec | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:642 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Colu… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, strEndC… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ed3fc198 | this.spdMain.ComboSelChange | DMF0000_EOL_BasicMngPopup.cs:643 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Colu… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0000_ExchangeRatePopup.btnBPS_Click

진입점: this.btnBPS.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de3b7d5c | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:596 |  | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b227f7a | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:602 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-14b0f1ce | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:606 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.PR_SCM_MST_EXCHANGE_RATE") ⇒ DM.PR_SCM_MST_EXCHANGE_RATE | 엔드포인트 요청 생성 |  |  |  |
| AC-e16299df | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:607 | try ▸ lambda | DATA_OP | request.Parameters["p_batch_yn"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-556a96d4 | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:608 | try ▸ lambda | UI_PROP | request.CommandTimeout | 90 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5de81bcd | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:610 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7717dfba | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:612 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0d751adb | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:622 | try ▸ if (sResultMsg != "success") ▸ if (ds.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("Fail!", "Error!") | 메시지 표시 |  |  |  |
| AC-43485f0a | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:623 | try ▸ if (sResultMsg != "success") ▸ if (ds.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b7c0dd2 | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:628 | try ▸ if (sResultMsg != "success") ▸ else of (ds.Tables.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00455") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62fb70e6 | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:630 | try ▸ if (sResultMsg != "success") ▸ else of (ds.Tables.Count == 0) | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-7273c872 | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:631 | try ▸ if (sResultMsg != "success") ▸ else of (ds.Tables.Count == 0) | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3bb1cb9f | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:633 | try ▸ if (sResultMsg != "success") ▸ else of (ds.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad612ebf | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:638 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00454") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e524682 | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:640 | try | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-8d31a8c9 | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:641 | try | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4ebc9666 | this.btnBPS.Click | DMF0000_ExchangeRatePopup.cs:645 | catch ((Exception exc)) | MESSAGE | MessageBox.Show | (exc.Message, "Error!") | 메시지 표시 |  |  |  |

## DMF0000_ExchangeRatePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e9269bb | this.btnButtonList.UsrButtonList_Click_Detected | DMF0000_ExchangeRatePopup.cs:574 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-3f131126 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0000_ExchangeRatePopup.cs:577 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0000_ExchangeRatePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04600c8b | this.Load | DMF0000_ExchangeRatePopup.cs:146 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a49d4ae4 | this.Load | DMF0000_ExchangeRatePopup.cs:147 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-186c7e13 | this.Load | DMF0000_ExchangeRatePopup.cs:148 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0000_ExchangeRatePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9363421 | this.Load | DMF0000_ExchangeRatePopup.cs:115 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-6dde24d7 | this.Load | DMF0000_ExchangeRatePopup.cs:126 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Edit) | 데이터 객체 조작/조회 |  |  |  |
| AC-75dc800a | this.Load | DMF0000_ExchangeRatePopup.cs:127 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Insert) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ab304c2 | this.Load | DMF0000_ExchangeRatePopup.cs:128 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Save) | 데이터 객체 조작/조회 |  |  |  |
| AC-60ef5dc3 | this.Load | DMF0000_ExchangeRatePopup.cs:129 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_MISC | btnBPS.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-74eedfe3 | this.Load | DMF0000_ExchangeRatePopup.cs:136 | if (_division != "40" && list.Count == 0) | DATA_OP | list.Add | (ButtonListType.Edit) | 데이터 객체 조작/조회 |  |  |  |
| AC-00c119d8 | this.Load | DMF0000_ExchangeRatePopup.cs:137 | if (_division != "40" && list.Count == 0) | DATA_OP | list.Add | (ButtonListType.Insert) | 데이터 객체 조작/조회 |  |  |  |
| AC-67278a5b | this.Load | DMF0000_ExchangeRatePopup.cs:138 | if (_division != "40" && list.Count == 0) | DATA_OP | list.Add | (ButtonListType.Save) | 데이터 객체 조작/조회 |  |  |  |
| AC-4673933e | this.Load | DMF0000_ExchangeRatePopup.cs:139 | if (_division != "40" && list.Count == 0) | UI_MISC | btnBPS.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-2de4c53c | this.Load | DMF0000_ExchangeRatePopup.cs:142 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0000_ExchangeRatePopup.DeleteButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete:] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd5a74cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:226 | if (vAction1 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d455b8c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:228 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0000_ExchangeRatePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54bc4e01 | Dispose | DMF0000_ExchangeRatePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0000_ExchangeRatePopup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5a31b88 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:241 | if (this.fps != null) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageBox.Show | (" You don't have the permissions to access it", "Information.") | 메시지 표시 |  |  |  |
| AC-1f51bd98 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:242 | if (this.fps != null) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9bfecff6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:245 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6be6c75 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:246 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5017ea72 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:275 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(sColName) > 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(sColName) - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-66fb43b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:279 | if (this.fps != null) ▸ else of (siMain.GetColumnIndex(sColName) > 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0000_ExchangeRatePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Default:] / this.btnBPS.Click [try ▸ if (sResultMsg != "success") ▸ else of (ds.Tables.Count == 0)] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb16a13e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:310 |  | VALUE_SET | clbDivision.ControlValues | _division | 컨트롤 값 설정 |  |  |  |
| AC-2a694ee2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:311 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1cab5c1e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:316 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7701ce7f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:317 |  | DATA_OP | nvc["p_from_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-b4847710 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:318 |  | DATA_OP | nvc["p_to_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-165e821e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:320 |  | FLAG | dsMain | (new CUIControl()).GetDataUsingByDBEx("DM.DMF0000_GET_EXCHANGE_POPUP_DATA", nvc) ⇒ DM.DMF0000_GET_EXCHANGE_POPUP_DATA | 화면 필드/플래그 변경 |  |  |  |
| AC-a12aaf79 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:320 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM.DMF0000_GET_EXCHANGE_POPUP_DATA", nvc) ⇒ DM.DMF0000_GET_EXCHANGE_POPUP_DATA | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7f220db5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:320 |  | ENDPOINT | new CUIControl | () ⇒ DM.DMF0000_GET_EXCHANGE_POPUP_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-33ff5fc1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:322 |  | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6eeb6f3a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:323 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e059f34f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:324 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc332578 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:326 |  | CALL_EXT | (new CUIControl()).SetPreferredWidth | (siMain.SpreadObject, 3, true) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0000_ExchangeRatePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4684ae8c | this.Load | DMF0000_ExchangeRatePopup.cs:80 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-326f2951 | this.Load | DMF0000_ExchangeRatePopup.cs:82 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0000_ExchangeRatePopup.GetCellColor

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a1301a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:539 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0000_ExchangeRatePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a7d202c | this.Load | DMF0000_ExchangeRatePopup.cs:104 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-db1831c3 | this.Load | DMF0000_ExchangeRatePopup.cs:105 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-154cd4b9 | this.Load | DMF0000_ExchangeRatePopup.cs:105 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3d1e2c00 | this.Load | DMF0000_ExchangeRatePopup.cs:106 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-abe48c99 | this.Load | DMF0000_ExchangeRatePopup.cs:108 |  | FLAG | dtDivision2 | Data.Common(Data.Type.Division) ⇒ biz:CommonData.CommonDataList [code=Division] | 화면 필드/플래그 변경 |  |  |  |
| AC-5185c87a | this.Load | DMF0000_ExchangeRatePopup.cs:108 |  | COMBO_DATA | Data.Common | (Data.Type.Division) ⇒ biz:CommonData.CommonDataList [code=Division] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ce3d34ce | this.Load | DMF0000_ExchangeRatePopup.cs:109 |  | FLAG | dtCurrency | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-1bc268ab | this.Load | DMF0000_ExchangeRatePopup.cs:109 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0000_ExchangeRatePopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Default:] / this.btnBPS.Click [try ▸ if (sResultMsg != "success") ▸ else of (ds.Tables.Count == 0)] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41a2037b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:155 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-4b6ff2f2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:157 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-68df1ab8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:158 |  | GRID_INIT | siMain.AddComboColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.Restricted, 35, true, dtDivision2, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-203fc524 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:159 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY, FPMerge.Restricted, 60, true, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e9e2bbbd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:160 |  | GRID_INIT | siMain.AddComboColumn | ("Unit", DefColumns.UNIT_CURRENCY, FPMerge.None, 45, true, dtCurrency, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b6c6123 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:161 |  | GRID_INIT | siMain.AddTextColumn | ("Last Update Date", DefColumns.LAST_UPDATE_DATE, FPMerge.Restricted, 45, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fafde71a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:162 |  | GRID_INIT | siMain.AddTextColumn | ("Last Updated By", DefColumns.LAST_UPDATED_BY, FPMerge.Restricted, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e9aa15cc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:163 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-146dbdfe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:169 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE") ⇒ DM.DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-0d2defb4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:170 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-29f44bd0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:171 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-eb788b4d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:172 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5d5a1e2b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:186 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_MONTH"].ToString(), "D" + dt.Rows[i]["BASIS_START_DATE"].ToString(),… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8923f3b9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:191 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["CALENDAR_YYYY"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, sFYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94f1b4b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:198 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sFYear , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c7dcd414 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:203 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-891c5dc4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0000_ExchangeRatePopup.cs:204 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY) +1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0000_ExchangeRatePopup.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6ecd847 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:496 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-08864849 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:499 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, clbDivision.ControlValues) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a060bd3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:500 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-579ba4d0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:502 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrency) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-15dfdaf6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:503 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UNIT_CURRENCY), dtCurrency) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3165eef3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:505 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5087f929 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:506 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6aa9e81a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:507 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-97bd1a87 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:521 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iMonth < iTime) ▸ for (i <… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0000_ExchangeRatePopup.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63efb43e | (진입점 미연결) | DMF0000_ExchangeRatePopup.cs:93 |  | UI_PROP | usrMonthFrom.MonthText | sFromYYYYMM | 속성 MonthText 설정 |  |  |  |
| AC-682d3262 | (진입점 미연결) | DMF0000_ExchangeRatePopup.cs:94 |  | UI_PROP | usrMonthTo.MonthText | sToYYYYMM | 속성 MonthText 설정 |  |  |  |
| AC-9b4c3e54 | (진입점 미연결) | DMF0000_ExchangeRatePopup.cs:95 |  | FLAG | _division | sDivision | 화면 필드/플래그 변경 |  |  |  |

## DMF0000_ExchangeRatePopup.mOK

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6032f83 | (진입점 미연결) | DMF0000_ExchangeRatePopup.cs:584 |  | FLAG | blnOK | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0000_ExchangeRatePopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d5849cc | SaveButton | DMF0000_ExchangeRatePopup.cs:293 | switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0f2338fc | SaveButton | DMF0000_ExchangeRatePopup.cs:294 | switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0000_ExchangeRatePopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-847b2a2f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:367 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-88639f77 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:370 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-092ce3e2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:372 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c431bb8e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:408 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], action, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-5efc0bf9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:409 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_division_id"] | CString.AppendStringEx(nvc["p_division_id"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-4416aa1b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:410 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-bc3b45f1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:411 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-32d17a00 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:412 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_UNIT_CURRENCY"] | CString.AppendStringEx(nvc["p_UNIT_CURRENCY"], sUNIT_CURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-7655ec1b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:413 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_EXCHANGE_PRICE"] | CString.AppendStringEx(nvc["p_EXCHANGE_PRICE"], sEXCHANGE_PRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-35996162 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:414 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8af7fff8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:415 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8e8e76b7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[EXCHANGE_PRICE]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e21d4a83 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:429 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35cd8195 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:436 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b6116ad7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:440 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_SAVE_EXCHANGE_POPUP_DATA") ⇒ DM.DMF0000_SAVE_EXCHANGE_POPUP_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-13732b0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:441 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda | UI_PROP | request.CommandTimeout | 90 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5cfad588 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:444 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda ▸ for (i < nvc.Co… | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-1afcf1fa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:444 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda ▸ for (i < nvc.Co… | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0119f40 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:446 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-251f855c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:448 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ed03aacd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:458 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (sResultMsg != "succe… | MESSAGE | MessageBox.Show | ("Fail!", "Error!") | 메시지 표시 |  |  |  |
| AC-0e13d145 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:459 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (sResultMsg != "succe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee33fd18 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:469 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (sResultMsg != "succe… | MESSAGE | MessageBox.Show | (sErrMsg, "Error!") | 메시지 표시 |  |  |  |
| AC-1fd84fb5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:470 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (sResultMsg != "succe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd9bcca6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:478 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | MESSAGE | MessageHelper.GMessageBox | ("MSG00456") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cd053f60 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_ExchangeRatePopup.cs:484 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.Message, "Error!") | 메시지 표시 |  |  |  |

## DMF0000_ExchangeRatePopup.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a67202a5 | this.spdMain.TopChange | DMF0000_ExchangeRatePopup.cs:590 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0000_VersionByWaterfallPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff0deb31 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0000_VersionByWaterfallPopup.cs:276 | switch (buttonItem.UserType) case ButtonListType.OK: ▸ if (bGo == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6853472c | this.btnButtonList.UsrButtonList_Click_Detected | DMF0000_VersionByWaterfallPopup.cs:277 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e5928101 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0000_VersionByWaterfallPopup.cs:280 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0000_VersionByWaterfallPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5018654 | this.Load | DMF0000_VersionByWaterfallPopup.cs:131 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4c302bd5 | this.Load | DMF0000_VersionByWaterfallPopup.cs:132 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8b02206f | this.Load | DMF0000_VersionByWaterfallPopup.cs:133 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0000_VersionByWaterfallPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-687b547e | this.Load | DMF0000_VersionByWaterfallPopup.cs:123 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-fedee5af | this.Load | DMF0000_VersionByWaterfallPopup.cs:126 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0000_VersionByWaterfallPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-242f0a04 | Dispose | DMF0000_VersionByWaterfallPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0000_VersionByWaterfallPopup.FindData

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e7919e7 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:216 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-640453bf | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:220 | lambda | ENDPOINT | new FoxDataRequest | ("DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP") ⇒ DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-9ce76284 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:221 | lambda | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-e9d38280 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:222 | lambda | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-de210b19 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:223 | lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-dfefc6b4 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:224 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-16823764 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:225 | lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-e30ef09b | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:226 | lambda | DATA_OP | request.Parameters["p_version_no"] | p_version_no | 행/컬럼 값 대입 |  |  |  |
| AC-69380142 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:227 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc70a1ce | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:229 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0bd2c892 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:233 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e2012e53 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:234 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-843eb415 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:241 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## DMF0000_VersionByWaterfallPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3973f39b | this.Load | DMF0000_VersionByWaterfallPopup.cs:95 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0314770e | this.Load | DMF0000_VersionByWaterfallPopup.cs:96 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4f4cad24 | this.Load | DMF0000_VersionByWaterfallPopup.cs:104 |  | FLAG | sCode | _Code | 화면 필드/플래그 변경 |  |  |  |
| AC-f58e3258 | this.Load | DMF0000_VersionByWaterfallPopup.cs:105 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-58114286 | this.Load | DMF0000_VersionByWaterfallPopup.cs:106 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-af3ad1d4 | this.Load | DMF0000_VersionByWaterfallPopup.cs:107 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |

## DMF0000_VersionByWaterfallPopup.GetSpdTitle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebd3cfe9 | (진입점 미연결) | DMF0000_VersionByWaterfallPopup.cs:303 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DM0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-b2818193 | (진입점 미연결) | DMF0000_VersionByWaterfallPopup.cs:304 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f62c9278 | (진입점 미연결) | DMF0000_VersionByWaterfallPopup.cs:305 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d55362b | (진입점 미연결) | DMF0000_VersionByWaterfallPopup.cs:306 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8c815e3d | (진입점 미연결) | DMF0000_VersionByWaterfallPopup.cs:307 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002" | 행/컬럼 값 대입 |  |  |  |
| AC-8d218c6d | (진입점 미연결) | DMF0000_VersionByWaterfallPopup.cs:308 |  | DATA_OP | request.Parameters["p_sheet_name"] | "VersionPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-3ee031bd | (진입점 미연결) | DMF0000_VersionByWaterfallPopup.cs:310 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8d61c936 | (진입점 미연결) | DMF0000_VersionByWaterfallPopup.cs:310 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c6f60a6 | (진입점 미연결) | DMF0000_VersionByWaterfallPopup.cs:313 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0000_VersionByWaterfallPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8898a16 | this.Load | DMF0000_VersionByWaterfallPopup.cs:115 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-67c6e8d8 | this.Load | DMF0000_VersionByWaterfallPopup.cs:115 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-97699c6c | this.Load | DMF0000_VersionByWaterfallPopup.cs:116 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c0d12484 | this.Load | DMF0000_VersionByWaterfallPopup.cs:118 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |

## DMF0000_VersionByWaterfallPopup.InitSpread_X

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b7f0972 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:149 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2e147d75 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:151 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-13504840 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:152 |  | GRID_INIT | siMain.AddTextColumn | ("Divison", DefColumns.DIVISION_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bdae2fd8 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:153 |  | GRID_INIT | siMain.AddTextColumn | ("Version", DefColumns.VERSION_NO, FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d349dfe | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:154 |  | GRID_INIT | siMain.AddTextColumn | ("Description", DefColumns.VERSION_DESCRIPTION, FPMerge.None, 300, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a152569 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:155 |  | GRID_INIT | siMain.AddTextColumn | ("Type", DefColumns.VERSION_TYPE, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-515d3d61 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:156 |  | GRID_INIT | siMain.AddTextColumn | ("Seq", DefColumns.VER_CRE_SEQ, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7708bc46 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:157 |  | GRID_INIT | siMain.AddTextColumn | ("Date", DefColumns.YYYYMMDD, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c27a1649 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:158 |  | GRID_INIT | siMain.AddTextColumn | ("Create By", DefColumns.CREATED_BY, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2a42ae81 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:159 |  | GRID_INIT | siMain.AddTextColumn | ("Create Date", DefColumns.CREATION_DATE, FPMerge.None, 150, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fcf3d1ac | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0000_VersionByWaterfallPopup.cs:161 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0000_VersionByWaterfallPopup.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-525af339 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_VersionByWaterfallPopup.cs:318 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-0b8b9ae0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_VersionByWaterfallPopup.cs:320 |  | FLAG | sPeriod | drpPeriod.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-c56ec4b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_VersionByWaterfallPopup.cs:335 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | sVersions | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-a13e8b78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_VersionByWaterfallPopup.cs:339 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | sVersions | sVersions + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-05da7a87 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_VersionByWaterfallPopup.cs:346 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ if (iCnt > 2) | FLAG | sVersions | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2851d1ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_VersionByWaterfallPopup.cs:347 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ if (iCnt > 2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00255", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b827df96 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_VersionByWaterfallPopup.cs:348 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ if (iCnt > 2) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-851b1c9a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_VersionByWaterfallPopup.cs:354 | else of (bMulltiSelect) | FLAG | sVersions | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-79599585 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0000_VersionByWaterfallPopup.cs:357 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0000_VersionByWaterfallPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f570dc1 | this.spdMain.CellDoubleClick | DMF0000_VersionByWaterfallPopup.cs:294 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

