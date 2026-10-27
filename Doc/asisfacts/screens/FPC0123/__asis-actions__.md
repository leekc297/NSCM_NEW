# AS-IS 액션 대조표 — FPC0123

> 원천: `Doc/asisfacts/screens/FPC0123/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 41행 · 메서드 13 · 종류 FLAG 8 · GRID_INIT 8 · UI_MISC 5 · DATA_OP 3 · RETURN 3 · VALUE_SET 3 · GRID_STYLE 3 · UI_PROP 1 · CALL_BASE 1 · ENDPOINT 1 · POPUP 1 · GRID_BIND 1 · LIST_BIND 1 · MESSAGE 1 · STATE 1 · ⚠ 의미 확인 필요 1


## FPC0123_LinePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeb07305 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0123_LinePopup.cs:450 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-7e9cc434 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0123_LinePopup.cs:453 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9570e827 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0123_LinePopup.cs:454 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0123_LinePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86763a3a | this.Load | FPC0123_LinePopup.cs:140 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9d80341b | this.Load | FPC0123_LinePopup.cs:141 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b56aa7c | this.Load | FPC0123_LinePopup.cs:142 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0123_LinePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75802bcc | this.Load | FPC0123_LinePopup.cs:135 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0123_LinePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5b3dce2 | Dispose | FPC0123_LinePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0123_LinePopup.Find_Data_Line

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e58fa20e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0123_LinePopup.cs:264 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivisionID = Filter["DIVISION_ID"].SafeStr… | ⚠ 의미 확인 필요 |  |  |  |
| AC-71900a76 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0123_LinePopup.cs:286 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0cd418b3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0123_LinePopup.cs:287 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("Line", "list_line", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_line] \| FP\Common\Line#li… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-87e15099 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0123_LinePopup.cs:287 | try | RETURN | return DataService.FP_ExecuteQuery("Line", "list_line", Filter.Dictionary); |  | 처리 중단/반환 |  |  |  |
| AC-84bacbbc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0123_LinePopup.cs:329 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0123_LinePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f17df7c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0123_LinePopup.cs:215 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-defd25d2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0123_LinePopup.cs:230 | try ▸ if (dsMain.Good()) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f7fa64e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0123_LinePopup.cs:235 | try ▸ if (dsMain.Good()) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-e40b5530 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0123_LinePopup.cs:243 | try ▸ else of (dsMain.Good()) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-06a1b6d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0123_LinePopup.cs:249 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FPC0123_LinePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cccab5b | this.Load | FPC0123_LinePopup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8581633b | this.Load | FPC0123_LinePopup.cs:109 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0123_LinePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33bd7d98 | this.Load | FPC0123_LinePopup.cs:124 |  | VALUE_SET | txtFactory.Text | Filter["FACTORY_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-45117a8f | this.Load | FPC0123_LinePopup.cs:125 |  | VALUE_SET | txtOperation.Text | Filter["OPERATION_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-d8c60d1b | this.Load | FPC0123_LinePopup.cs:126 |  | VALUE_SET | txtLine.Text | Filter["LINE_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-213fe0b8 | this.Load | FPC0123_LinePopup.cs:128 |  | STATE | txtFactory.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0123_LinePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80b998e5 | this.Load | FPC0123_LinePopup.cs:152 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d9e5793 | this.Load | FPC0123_LinePopup.cs:153 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0123_LinePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58a4b42a | (진입점 미연결) | FPC0123_LinePopup.cs:174 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0123_LinePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1aa99c4 | this.Load | FPC0123_LinePopup.cs:159 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad27bbbc | this.Load | FPC0123_LinePopup.cs:160 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-7eb18824 | this.Load | FPC0123_LinePopup.cs:164 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-89b3ef10 | this.Load | FPC0123_LinePopup.cs:167 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-b9dae144 | this.Load | FPC0123_LinePopup.cs:168 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.SITE_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-401db414 | this.Load | FPC0123_LinePopup.cs:169 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.PLANT_ID), false) | 그리드 표시 설정 |  |  |  |

## FPC0123_LinePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ab6d8d3 | this.spdMain.CellClick | FPC0123_LinePopup.cs:465 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-97c9b6e4 | this.spdMain.CellClick | FPC0123_LinePopup.cs:466 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-69491cd4 | this.spdMain.CellClick | FPC0123_LinePopup.cs:469 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FPC0123_LinePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd625bb0 | this.spdMain.CellDoubleClick | FPC0123_LinePopup.cs:475 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-4d084791 | this.spdMain.CellDoubleClick | FPC0123_LinePopup.cs:476 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-571cf0de | this.spdMain.CellDoubleClick | FPC0123_LinePopup.cs:479 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-37d0c9fe | this.spdMain.CellDoubleClick | FPC0123_LinePopup.cs:482 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-017f1eaa | this.spdMain.CellDoubleClick | FPC0123_LinePopup.cs:492 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

