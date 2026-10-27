# AS-IS 액션 대조표 — FPC0104

> 원천: `Doc/asisfacts/screens/FPC0104/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 102행 · 메서드 16 · 종류 STATE 40 · FLAG 11 · UI_PROP 8 · DATA_OP 8 · POPUP 6 · GRID_INIT 6 · CALL_EXT 6 · UI_MISC 4 · GRID_LOCK 3 · ENDPOINT 2 · CALL_BASE 2 · RETURN 2 · FOCUS 1 · GRID_BIND 1 · MESSAGE 1 · THROW 1 · ⚠ 의미 확인 필요 8


## FPC0104_MemoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9409e00d | .ctor | FPC0104_MemoPopup.cs:167 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-f889bbc8 | .ctor | FPC0104_MemoPopup.cs:168 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0104_MemoPopup.btnAdd_Click

진입점: this.btnPlus.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09efd1b4 | this.btnPlus.Click | FPC0104_MemoPopup.cs:608 |  | POPUP | new FPC0608_MemoAddPopup | (Filter["MEMO_TYPE"].SafeString()) | 팝업/폼 생성 |  |  |  |
| AC-3b574405 | this.btnPlus.Click | FPC0104_MemoPopup.cs:609 |  | UI_PROP | memoPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-582a469e | this.btnPlus.Click | FPC0104_MemoPopup.cs:609 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c00ecb21 | this.btnPlus.Click | FPC0104_MemoPopup.cs:610 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-8a78fb4c | this.btnPlus.Click | FPC0104_MemoPopup.cs:611 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f537d7c3 | this.btnPlus.Click | FPC0104_MemoPopup.cs:615 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |

## FPC0104_MemoPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-921e4b94 | this.btnClose.Click | FPC0104_MemoPopup.cs:627 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0104_MemoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c47a50a7 | this.Load | FPC0104_MemoPopup.cs:229 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b9be6698 | this.Load | FPC0104_MemoPopup.cs:230 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ce726b7 | this.Load | FPC0104_MemoPopup.cs:231 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0104_MemoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-793a6099 | this.Load | FPC0104_MemoPopup.cs:224 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0104_MemoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73bbbbff | Dispose | FPC0104_MemoPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0104_MemoPopup.EnableButton

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e853fb3 | (진입점 미연결) | FPC0104_MemoPopup.cs:54 | switch (button) case MemoPopupButton.Add: | STATE | btnPlus.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-f7484e52 | (진입점 미연결) | FPC0104_MemoPopup.cs:55 | switch (button) case MemoPopupButton.Add: | FLAG | enableBtnPlus | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-4e2ae810 | (진입점 미연결) | FPC0104_MemoPopup.cs:58 | switch (button) case MemoPopupButton.Save: | STATE | btnSave.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-2f457e4d | (진입점 미연결) | FPC0104_MemoPopup.cs:59 | switch (button) case MemoPopupButton.Save: | FLAG | enableBtnSave | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-7967e485 | (진입점 미연결) | FPC0104_MemoPopup.cs:62 | switch (button) case MemoPopupButton.Find: | STATE | btnFind.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-3b88fb5c | (진입점 미연결) | FPC0104_MemoPopup.cs:63 | switch (button) case MemoPopupButton.Find: | FLAG | enableBtnFind | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-39c7d34c | (진입점 미연결) | FPC0104_MemoPopup.cs:66 | switch (button) case MemoPopupButton.Close: | STATE | btnClose.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-6758de44 | (진입점 미연결) | FPC0104_MemoPopup.cs:67 | switch (button) case MemoPopupButton.Close: | FLAG | enableBtnClose | t_f | 화면 필드/플래그 변경 |  |  |  |

## FPC0104_MemoPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0fac9e2 | FindButton | FPC0104_MemoPopup.cs:268 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b691e406 | FindButton | FPC0104_MemoPopup.cs:269 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f23b329f | FindButton | FPC0104_MemoPopup.cs:271 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0104_MemoPopup.FindData

진입점: this.Load / this.btnSave.Click / this.btnFind.Click / this.btnPlus.Click [if (memoPopup.ShowDialog() == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-325c765a | this.Load 외 4 | FPC0104_MemoPopup.cs:305 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-4a638465 | this.Load 외 4 | FPC0104_MemoPopup.cs:305 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e18291b0 | this.Load 외 4 | FPC0104_MemoPopup.cs:312 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-37ee6ea4 | this.Load 외 4 | FPC0104_MemoPopup.cs:313 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-90e9bb74 | this.Load 외 4 | FPC0104_MemoPopup.cs:314 |  | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-36ca1252 | this.Load 외 4 | FPC0104_MemoPopup.cs:315 |  | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1afe78d8 | this.Load 외 4 | FPC0104_MemoPopup.cs:316 |  | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-51daa66e | this.Load 외 4 | FPC0104_MemoPopup.cs:323 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6675b970 | this.Load 외 4 | FPC0104_MemoPopup.cs:327 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_PLANAMENDMEMOP_FIND_PLANAMENDMEMOP", Filter, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c995b37c | this.Load 외 4 | FPC0104_MemoPopup.cs:330 | try | CALL_BASE | this.Invoke | (new Action(delegate () { siMain.Query(set, true); siMain.LockColumn(0, siMain.GetMaxColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7df1374 | this.Load 외 4 | FPC0104_MemoPopup.cs:332 | try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f63c560b | this.Load 외 4 | FPC0104_MemoPopup.cs:333 | try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d6b3d53 | this.Load 외 4 | FPC0104_MemoPopup.cs:335 | try ▸ lambda ▸ if (canSave) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("MEMO"), siMain.GetColumnIndex("MEMO"), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab28580f | this.Load 외 4 | FPC0104_MemoPopup.cs:337 | try ▸ lambda ▸ else of (canSave) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("MEMO"), siMain.GetColumnIndex("MEMO"), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c34aee2 | this.Load 외 4 | FPC0104_MemoPopup.cs:346 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f392a080 | this.Load 외 4 | FPC0104_MemoPopup.cs:349 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7554a1b3 | this.Load 외 4 | FPC0104_MemoPopup.cs:350 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5e15b691 | this.Load 외 4 | FPC0104_MemoPopup.cs:351 | finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6ee7cc32 | this.Load 외 4 | FPC0104_MemoPopup.cs:354 | finally ▸ lambda ▸ if (canSave) | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72e480fe | this.Load 외 4 | FPC0104_MemoPopup.cs:356 | finally ▸ lambda ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f83df94b | this.Load 외 4 | FPC0104_MemoPopup.cs:357 | finally ▸ lambda ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bb7e6ffb | this.Load 외 4 | FPC0104_MemoPopup.cs:361 | finally ▸ lambda ▸ if (canSave) ▸ else of (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | this.btnPlus.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5f33b02b | this.Load 외 4 | FPC0104_MemoPopup.cs:362 | finally ▸ lambda ▸ if (canSave) ▸ else of (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-574111c3 | this.Load 외 4 | FPC0104_MemoPopup.cs:367 | finally ▸ lambda ▸ else of (canSave) | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5f6eadc6 | this.Load 외 4 | FPC0104_MemoPopup.cs:368 | finally ▸ lambda ▸ else of (canSave) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0104_MemoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d251f729 | this.Load | FPC0104_MemoPopup.cs:176 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8e2f1b9 | this.Load | FPC0104_MemoPopup.cs:178 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0104_MemoPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a41dd421 | (진입점 미연결) | FPC0104_MemoPopup.cs:559 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-0c981bc8 | (진입점 미연결) | FPC0104_MemoPopup.cs:560 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-4563edc1 | (진입점 미연결) | FPC0104_MemoPopup.cs:561 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-97ecd824 | (진입점 미연결) | FPC0104_MemoPopup.cs:562 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-76fb1f33 | (진입점 미연결) | FPC0104_MemoPopup.cs:563 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-e482489e | (진입점 미연결) | FPC0104_MemoPopup.cs:564 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-e2160fec | (진입점 미연결) | FPC0104_MemoPopup.cs:565 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-af512a2a | (진입점 미연결) | FPC0104_MemoPopup.cs:567 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-9f3cdc2e | (진입점 미연결) | FPC0104_MemoPopup.cs:568 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-2d480ed9 | (진입점 미연결) | FPC0104_MemoPopup.cs:572 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-20172fb6 | (진입점 미연결) | FPC0104_MemoPopup.cs:573 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FPC0104_MemoPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71c6d6c5 | this.Load | FPC0104_MemoPopup.cs:202 | if (canSave == true) | STATE | btnPlus.Enabled | enableBtnPlus | 컨트롤 상태 Enabled |  |  |  |
| AC-6121280e | this.Load | FPC0104_MemoPopup.cs:203 | if (canSave == true) | STATE | btnSave.Enabled | enableBtnSave | 컨트롤 상태 Enabled |  |  |  |
| AC-7d97a37a | this.Load | FPC0104_MemoPopup.cs:207 | else of (canSave == true) | STATE | btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-53f39e01 | this.Load | FPC0104_MemoPopup.cs:208 | else of (canSave == true) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c44fbb83 | this.Load | FPC0104_MemoPopup.cs:211 |  | STATE | btnFind.Enabled | enableBtnFind | 컨트롤 상태 Enabled |  |  |  |
| AC-65d59f44 | this.Load | FPC0104_MemoPopup.cs:212 |  | STATE | btnClose.Enabled | enableBtnClose | 컨트롤 상태 Enabled |  |  |  |
| AC-80215fa9 | this.Load | FPC0104_MemoPopup.cs:214 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad4d4b7a | this.Load | FPC0104_MemoPopup.cs:216 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-212b9af2 | this.Load | FPC0104_MemoPopup.cs:217 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0104_MemoPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-379ff8b2 | this.Load | FPC0104_MemoPopup.cs:240 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0104_MemoPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2accfe24 | (진입점 미연결) | FPC0104_MemoPopup.cs:259 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0104_MemoPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f398e9c | this.btnSave.Click | FPC0104_MemoPopup.cs:480 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-c8ad54e8 | this.btnSave.Click | FPC0104_MemoPopup.cs:480 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dcca790b | this.btnSave.Click | FPC0104_MemoPopup.cs:485 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9cc9e937 | this.btnSave.Click | FPC0104_MemoPopup.cs:486 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-263de116 | this.btnSave.Click | FPC0104_MemoPopup.cs:487 |  | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ff2fdf21 | this.btnSave.Click | FPC0104_MemoPopup.cs:488 |  | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f84f5bca | this.btnSave.Click | FPC0104_MemoPopup.cs:489 |  | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-96641486 | this.btnSave.Click | FPC0104_MemoPopup.cs:497 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-20dfeb54 | this.btnSave.Click | FPC0104_MemoPopup.cs:498 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("USER_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3146ce7 | this.btnSave.Click | FPC0104_MemoPopup.cs:499 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c0c3aca5 | this.btnSave.Click | FPC0104_MemoPopup.cs:502 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | ro["USER_ID"] | ctx.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-90de7304 | this.btnSave.Click | FPC0104_MemoPopup.cs:503 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | m2.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c44012f0 | this.btnSave.Click | FPC0104_MemoPopup.cs:507 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) ▸ foreach (DataColumn … | DATA_OP | nn[colname] | ro[colname] | 행/컬럼 값 대입 |  |  |  |
| AC-01d1cf53 | this.btnSave.Click | FPC0104_MemoPopup.cs:509 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | m2.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-8cfecbac | this.btnSave.Click | FPC0104_MemoPopup.cs:512 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("PlanAmendMemo", "saveAll_planAmendMemoP", m2) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_planAmendMemoP] \| FP\Co… | 엔드포인트 호출 |  |  |  |
| AC-14c6fdfc | this.btnSave.Click | FPC0104_MemoPopup.cs:523 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d5173e06 | this.btnSave.Click | FPC0104_MemoPopup.cs:527 | finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0a62a5d8 | this.btnSave.Click | FPC0104_MemoPopup.cs:528 | finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1f8a5f57 | this.btnSave.Click | FPC0104_MemoPopup.cs:529 | finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b125b984 | this.btnSave.Click | FPC0104_MemoPopup.cs:532 | finally ▸ if (canSave) | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-524a1682 | this.btnSave.Click | FPC0104_MemoPopup.cs:534 | finally ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b6a8321e | this.btnSave.Click | FPC0104_MemoPopup.cs:535 | finally ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c48a66d4 | this.btnSave.Click | FPC0104_MemoPopup.cs:540 | finally ▸ if (canSave) ▸ else of (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | this.btnPlus.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5d9ca1fe | this.btnSave.Click | FPC0104_MemoPopup.cs:541 | finally ▸ if (canSave) ▸ else of (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5420a6b5 | this.btnSave.Click | FPC0104_MemoPopup.cs:546 | finally ▸ else of (canSave) | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-635c697d | this.btnSave.Click | FPC0104_MemoPopup.cs:547 | finally ▸ else of (canSave) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0104_MemoPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d27c0714 | this.Load | FPC0104_MemoPopup.cs:251 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2bfb314a | this.Load | FPC0104_MemoPopup.cs:252 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

