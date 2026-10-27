# AS-IS 액션 대조표 — FPC0601

> 원천: `Doc/asisfacts/screens/FPC0601/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 42행 · 메서드 12 · 종류 FLAG 8 · GRID_INIT 8 · UI_MISC 7 · DATA_OP 5 · RETURN 3 · ENDPOINT 3 · UI_PROP 2 · POPUP 2 · MESSAGE 1 · GRID_BIND 1 · GRID_LOCK 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 0


## FPC0601_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7000c3bf | this.btnButtonList.UsrButtonList_Click_Detected | FPC0601_ItemPopup.cs:293 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-bb073c72 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0601_ItemPopup.cs:296 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-25252bf0 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0601_ItemPopup.cs:297 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0601_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60a7ca63 | this.Load | FPC0601_ItemPopup.cs:139 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4f5920a1 | this.Load | FPC0601_ItemPopup.cs:140 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9bd82194 | this.Load | FPC0601_ItemPopup.cs:141 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0601_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee569b62 | this.Load | FPC0601_ItemPopup.cs:134 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0601_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d0fd5c7 | Dispose | FPC0601_ItemPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0601_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad1e027e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:210 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f3eb0012 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:211 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9dee3d85 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:213 |  | DATA_OP | Filter["MODEL_ID"] | txtModel.Text | 행/컬럼 값 대입 |  |  |  |
| AC-3e1f50da | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:214 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-66d4689d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:215 |  | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-2cb951b8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:221 | if (string.IsNullOrWhiteSpace(chk)) | MESSAGE | MessageBox.Show | ("It is required at least one of these : Model, Item, Nick Name") | 메시지 표시 |  |  |  |
| AC-cbb1768f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:222 | if (string.IsNullOrWhiteSpace(chk)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9a11f471 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:223 | if (string.IsNullOrWhiteSpace(chk)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03067a22 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:227 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d5be5f6b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:229 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { //DataSet dtInstType = DataService.FP_ExecuteQuery("FP00601_LineAdd", "find_Insta… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3ebfdce1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:246 | lambda ▸ if (Filter["PRODUCTION_TYPE"] == "TEST" \|\| Filter["PRODUCTION_TYPE"] == "D-TEST" \|\| Filter["PRODUCTION_TYPE"]=="E-TEST") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SELECT", "ITEM_LIST_TES… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-13ae4b55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:250 | lambda ▸ else of (Filter["PRODUCTION_TYPE"] == "TEST" \|\| Filter["PRODUCTION_TYPE"] == "D-TEST" \|\| Filter["PRODUCTION_TYPE"]=="E-TEST") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SELECT", "ITEM_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0ce3ba05 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:252 | lambda | RETURN | return itemList; |  | 처리 중단/반환 |  |  |  |
| AC-40d0e8ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:256 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-18b274df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:259 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c0943f3a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:261 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-af510083 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0601_ItemPopup.cs:265 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0601_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11a154ff | this.Load | FPC0601_ItemPopup.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-69918760 | this.Load | FPC0601_ItemPopup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0601_ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45c965c7 | this.Load | FPC0601_ItemPopup.cs:128 |  | VALUE_SET | txtModel.Text | Filter["TOP_ITEM_ID"] | 컨트롤 값 설정 |  |  |  |

## FPC0601_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa4ec40d | this.Load | FPC0601_ItemPopup.cs:151 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9dd17948 | this.Load | FPC0601_ItemPopup.cs:152 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0601_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c87826b3 | (진입점 미연결) | FPC0601_ItemPopup.cs:171 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0601_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25c869d0 | this.Load | FPC0601_ItemPopup.cs:158 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-97154222 | this.Load | FPC0601_ItemPopup.cs:159 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-12b5b45b | this.Load | FPC0601_ItemPopup.cs:163 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0601_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f67bf98b | this.spdMain.CellClick | FPC0601_ItemPopup.cs:308 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-a9a3cafd | this.spdMain.CellClick | FPC0601_ItemPopup.cs:309 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e84b1c55 | this.spdMain.CellClick | FPC0601_ItemPopup.cs:312 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FPC0601_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-375b1948 | this.spdMain.CellDoubleClick | FPC0601_ItemPopup.cs:318 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-1bd375c4 | this.spdMain.CellDoubleClick | FPC0601_ItemPopup.cs:319 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-023fe241 | this.spdMain.CellDoubleClick | FPC0601_ItemPopup.cs:322 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-d992859b | this.spdMain.CellDoubleClick | FPC0601_ItemPopup.cs:325 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6aec756c | this.spdMain.CellDoubleClick | FPC0601_ItemPopup.cs:335 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

