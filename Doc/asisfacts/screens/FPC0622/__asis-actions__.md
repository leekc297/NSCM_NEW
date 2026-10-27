# AS-IS 액션 대조표 — FPC0622

> 원천: `Doc/asisfacts/screens/FPC0622/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 48행 · 메서드 13 · 종류 DATA_OP 9 · FLAG 8 · GRID_INIT 8 · UI_MISC 5 · RETURN 3 · VALUE_SET 3 · GRID_STYLE 3 · ENDPOINT 2 · UI_PROP 1 · CALL_BASE 1 · POPUP 1 · GRID_BIND 1 · LIST_BIND 1 · MESSAGE 1 · STATE 1 · ⚠ 의미 확인 필요 1


## FPC0622_LinePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8679882e | this.btnButtonList.UsrButtonList_Click_Detected | FPC0622_LinePopup.cs:448 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-a63435cf | this.btnButtonList.UsrButtonList_Click_Detected | FPC0622_LinePopup.cs:451 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1c16884c | this.btnButtonList.UsrButtonList_Click_Detected | FPC0622_LinePopup.cs:452 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0622_LinePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1033587 | this.Load | FPC0622_LinePopup.cs:140 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cc474f8a | this.Load | FPC0622_LinePopup.cs:141 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9bb39ed7 | this.Load | FPC0622_LinePopup.cs:142 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0622_LinePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-146e9f62 | this.Load | FPC0622_LinePopup.cs:135 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0622_LinePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d29a0a7 | Dispose | FPC0622_LinePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0622_LinePopup.Find_Data_Line

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcede537 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:264 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivisionID = Filter["DIVISION_ID"].SafeStr… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fefea544 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:288 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00100_LINE") ⇒ FP_Master.PR_UI_FP00100_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-f9a4bd03 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:290 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-a81cfb04 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:291 | try | DATA_OP | request.Parameters["p_sys_flag"] | "S" | 행/컬럼 값 대입 |  |  |  |
| AC-4c1609fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:294 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7c98452b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:300 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-7dc37ab2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:301 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-3339a6ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:302 | try | DATA_OP | request.Parameters["p_line_name"] | pLineID.Equals("ALL") ? "" : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-c9bb68fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:311 | try | DATA_OP | request.Parameters["p_active_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-3f9a75a1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:320 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d03b06ab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:322 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6653cc76 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:327 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0622_LinePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fccef8e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:215 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b60514de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:230 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c828afa8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-11652609 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:243 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-d2e27d2b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0622_LinePopup.cs:249 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FPC0622_LinePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6164cbd | this.Load | FPC0622_LinePopup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d725690 | this.Load | FPC0622_LinePopup.cs:109 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0622_LinePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-648ed18e | this.Load | FPC0622_LinePopup.cs:124 |  | VALUE_SET | txtFactory.Text | Filter["FACTORY_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-933082bf | this.Load | FPC0622_LinePopup.cs:125 |  | VALUE_SET | txtOperation.Text | Filter["OPERATION_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-3cb9484b | this.Load | FPC0622_LinePopup.cs:126 |  | VALUE_SET | txtLine.Text | Filter["LINE_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-d1ed6d4f | this.Load | FPC0622_LinePopup.cs:128 |  | STATE | txtFactory.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0622_LinePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d6ea42e | this.Load | FPC0622_LinePopup.cs:152 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-747e7777 | this.Load | FPC0622_LinePopup.cs:153 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0622_LinePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e4f89e6 | (진입점 미연결) | FPC0622_LinePopup.cs:174 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0622_LinePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13ff93b3 | this.Load | FPC0622_LinePopup.cs:159 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07af9240 | this.Load | FPC0622_LinePopup.cs:160 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-883bdfde | this.Load | FPC0622_LinePopup.cs:164 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-20af1dd8 | this.Load | FPC0622_LinePopup.cs:167 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-0155d144 | this.Load | FPC0622_LinePopup.cs:168 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.SITE_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-ad5770c7 | this.Load | FPC0622_LinePopup.cs:169 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.PLANT_ID), false) | 그리드 표시 설정 |  |  |  |

## FPC0622_LinePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-799b4198 | this.spdMain.CellClick | FPC0622_LinePopup.cs:463 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-bc421acf | this.spdMain.CellClick | FPC0622_LinePopup.cs:464 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-87fefac2 | this.spdMain.CellClick | FPC0622_LinePopup.cs:467 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FPC0622_LinePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbb5e8b9 | this.spdMain.CellDoubleClick | FPC0622_LinePopup.cs:473 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-fb68f5db | this.spdMain.CellDoubleClick | FPC0622_LinePopup.cs:474 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e9e15a39 | this.spdMain.CellDoubleClick | FPC0622_LinePopup.cs:477 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-61f503a1 | this.spdMain.CellDoubleClick | FPC0622_LinePopup.cs:480 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17bfc6db | this.spdMain.CellDoubleClick | FPC0622_LinePopup.cs:490 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

