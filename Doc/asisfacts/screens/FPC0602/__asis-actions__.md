# AS-IS 액션 대조표 — FPC0602

> 원천: `Doc/asisfacts/screens/FPC0602/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 41행 · 메서드 12 · 종류 FLAG 8 · GRID_INIT 8 · UI_MISC 6 · DATA_OP 5 · RETURN 3 · ENDPOINT 3 · UI_PROP 2 · POPUP 2 · MESSAGE 1 · GRID_BIND 1 · GRID_LOCK 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 0


## FPC0602_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24c1c006 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0602_ItemPopup.cs:294 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-38e4184e | this.btnButtonList.UsrButtonList_Click_Detected | FPC0602_ItemPopup.cs:297 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b8402540 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0602_ItemPopup.cs:298 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0602_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8df7f6de | this.Load | FPC0602_ItemPopup.cs:139 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6aa1902e | this.Load | FPC0602_ItemPopup.cs:140 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb687514 | this.Load | FPC0602_ItemPopup.cs:141 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0602_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3eb8564 | this.Load | FPC0602_ItemPopup.cs:134 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0602_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e36f2ac9 | Dispose | FPC0602_ItemPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0602_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d92af393 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:210 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e42d3ef3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:214 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fe0c7d27 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:218 |  | DATA_OP | Filter["MODEL_ID"] | txtModel.Text | 행/컬럼 값 대입 |  |  |  |
| AC-cdbc9d3c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:219 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-de950d40 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:220 |  | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-4be05cb8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:226 | if (string.IsNullOrWhiteSpace(Filter["MODEL_ID"]) && string.IsNullOrWhiteSpace(Filter["ITEM_ID"]) && string.IsNullOrWhiteSpa…) | MESSAGE | MessageBox.Show | ("It is required at least one of these : Model, Item, Nick Name") | 메시지 표시 |  |  |  |
| AC-ef10ed3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:227 | if (string.IsNullOrWhiteSpace(Filter["MODEL_ID"]) && string.IsNullOrWhiteSpace(Filter["ITEM_ID"]) && string.IsNullOrWhiteSpa…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6aec5f39 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:229 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f79b10d7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:230 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { //DataSet dtInstType = DataService.FP_ExecuteQuery("FP00602_LineAdd", "find_Insta… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9279485c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:247 | lambda ▸ if (Filter["PRODUCTION_TYPE"] == "TEST" \|\| Filter["PRODUCTION_TYPE"] == "D-TEST" \|\| Filter["PRODUCTION_TYPE"]=="E-TEST") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00602_ADDLINE_FIND_ITEMLIST_BYTEST", Filter, UserInfoContext.Current.UserId) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-265dbb4a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:251 | lambda ▸ else of (Filter["PRODUCTION_TYPE"] == "TEST" \|\| Filter["PRODUCTION_TYPE"] == "D-TEST" \|\| Filter["PRODUCTION_TYPE"]=="E-TEST") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00602_ADDLINE_FIND_ITEMLISTORG", Filter, UserInfoContext.Current.UserId, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-931d60a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:253 | lambda | RETURN | return itemList; |  | 처리 중단/반환 |  |  |  |
| AC-642aa080 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:257 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a7723ead | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:260 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec54bb36 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:262 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2286cd08 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0602_ItemPopup.cs:266 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0602_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c47abe9 | this.Load | FPC0602_ItemPopup.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ebf2d099 | this.Load | FPC0602_ItemPopup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0602_ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e97ffd32 | this.Load | FPC0602_ItemPopup.cs:128 |  | VALUE_SET | txtModel.Text | Filter["TOP_ITEM_ID"] | 컨트롤 값 설정 |  |  |  |

## FPC0602_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b420f581 | this.Load | FPC0602_ItemPopup.cs:151 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb6e5224 | this.Load | FPC0602_ItemPopup.cs:152 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0602_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-213c9b0a | (진입점 미연결) | FPC0602_ItemPopup.cs:171 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0602_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f5534c6 | this.Load | FPC0602_ItemPopup.cs:158 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a47ae8fc | this.Load | FPC0602_ItemPopup.cs:159 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-3cda2d95 | this.Load | FPC0602_ItemPopup.cs:163 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0602_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47d7f822 | this.spdMain.CellClick | FPC0602_ItemPopup.cs:309 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-5936cb05 | this.spdMain.CellClick | FPC0602_ItemPopup.cs:310 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-85d858e2 | this.spdMain.CellClick | FPC0602_ItemPopup.cs:313 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FPC0602_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b26679c | this.spdMain.CellDoubleClick | FPC0602_ItemPopup.cs:319 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-840bdc09 | this.spdMain.CellDoubleClick | FPC0602_ItemPopup.cs:320 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5b9758bb | this.spdMain.CellDoubleClick | FPC0602_ItemPopup.cs:323 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-d1d079bd | this.spdMain.CellDoubleClick | FPC0602_ItemPopup.cs:326 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50e22997 | this.spdMain.CellDoubleClick | FPC0602_ItemPopup.cs:336 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

