# AS-IS 액션 대조표 — FPC0621

> 원천: `Doc/asisfacts/screens/FPC0621/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 35행 · 메서드 12 · 종류 FLAG 8 · GRID_INIT 8 · UI_MISC 6 · DATA_OP 5 · ENDPOINT 2 · UI_PROP 1 · POPUP 1 · GRID_BIND 1 · GRID_LOCK 1 · VALUE_SET 1 · RETURN 1 · ⚠ 의미 확인 필요 0


## FPC0621_LineCN2ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1679a825 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0621_LineCN2ItemPopup.cs:255 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-835ebf66 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0621_LineCN2ItemPopup.cs:258 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-955ffd2a | this.btnButtonList.UsrButtonList_Click_Detected | FPC0621_LineCN2ItemPopup.cs:259 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0621_LineCN2ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b215eed | this.Load | FPC0621_LineCN2ItemPopup.cs:131 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4225710f | this.Load | FPC0621_LineCN2ItemPopup.cs:132 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-61318011 | this.Load | FPC0621_LineCN2ItemPopup.cs:133 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0621_LineCN2ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5375830 | this.Load | FPC0621_LineCN2ItemPopup.cs:126 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0621_LineCN2ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b38083c9 | Dispose | FPC0621_LineCN2ItemPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0621_LineCN2ItemPopup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28d9dd9c | this.Load 외 2 | FPC0621_LineCN2ItemPopup.cs:202 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-325d97d3 | this.Load 외 2 | FPC0621_LineCN2ItemPopup.cs:205 |  | DATA_OP | Filter["CELL_GROUP_CODE"] | txtCellGroup.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c7dfa489 | this.Load 외 2 | FPC0621_LineCN2ItemPopup.cs:206 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-3977b0d3 | this.Load 외 2 | FPC0621_LineCN2ItemPopup.cs:207 |  | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-26545b44 | this.Load 외 2 | FPC0621_LineCN2ItemPopup.cs:210 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => Data_FP.CallGeneralProcedure("PR_UI_FP00621_LINE_CN2_ITEM", Filter, UserInfoContext… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-074c495d | this.Load 외 2 | FPC0621_LineCN2ItemPopup.cs:211 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00621_LINE_CN2_ITEM", Filter, UserInfoContext.Current.UserId, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2bd18794 | this.Load 외 2 | FPC0621_LineCN2ItemPopup.cs:218 | if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fac7a70f | this.Load 외 2 | FPC0621_LineCN2ItemPopup.cs:221 | if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9f18de03 | this.Load 외 2 | FPC0621_LineCN2ItemPopup.cs:223 | if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-67ff2f3e | this.Load 외 2 | FPC0621_LineCN2ItemPopup.cs:227 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0621_LineCN2ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d39b989 | this.Load | FPC0621_LineCN2ItemPopup.cs:102 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d883cd11 | this.Load | FPC0621_LineCN2ItemPopup.cs:104 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0621_LineCN2ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84c681bb | this.Load | FPC0621_LineCN2ItemPopup.cs:120 |  | VALUE_SET | txtCellGroup.Text | Filter["CELL_GROUP_CODE"] | 컨트롤 값 설정 |  |  |  |

## FPC0621_LineCN2ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bcad2d9 | this.Load | FPC0621_LineCN2ItemPopup.cs:143 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbdf8167 | this.Load | FPC0621_LineCN2ItemPopup.cs:144 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0621_LineCN2ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95af8fd6 | (진입점 미연결) | FPC0621_LineCN2ItemPopup.cs:163 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0621_LineCN2ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb18ccf7 | this.Load | FPC0621_LineCN2ItemPopup.cs:150 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e0f4383 | this.Load | FPC0621_LineCN2ItemPopup.cs:151 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-d30731ed | this.Load | FPC0621_LineCN2ItemPopup.cs:155 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0621_LineCN2ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1ea142b | this.spdMain.CellClick | FPC0621_LineCN2ItemPopup.cs:270 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-2b96c967 | this.spdMain.CellClick | FPC0621_LineCN2ItemPopup.cs:271 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2adaf7c3 | this.spdMain.CellClick | FPC0621_LineCN2ItemPopup.cs:274 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FPC0621_LineCN2ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-038bd7e9 | this.spdMain.CellDoubleClick | FPC0621_LineCN2ItemPopup.cs:280 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-0f63c61e | this.spdMain.CellDoubleClick | FPC0621_LineCN2ItemPopup.cs:281 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-491ad475 | this.spdMain.CellDoubleClick | FPC0621_LineCN2ItemPopup.cs:284 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-3784c51c | this.spdMain.CellDoubleClick | FPC0621_LineCN2ItemPopup.cs:287 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8775a863 | this.spdMain.CellDoubleClick | FPC0621_LineCN2ItemPopup.cs:297 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

