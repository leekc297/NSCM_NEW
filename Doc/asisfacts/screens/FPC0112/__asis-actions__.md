# AS-IS 액션 대조표 — FPC0112

> 원천: `Doc/asisfacts/screens/FPC0112/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 154행 · 메서드 18 · 종류 STATE 38 · DATA_OP 23 · FLAG 13 · GRID_INIT 11 · UI_PROP 9 · GRID_SET 9 · CALL_EXT 8 · GRID_LOCK 8 · POPUP 6 · VALUE_SET 6 · UI_MISC 5 · GRID_STYLE 4 · RETURN 3 · ENDPOINT 3 · CALL_BASE 2 · GRID_BIND 2 · GRID_CLEAR 2 · MESSAGE 1 · THROW 1 · ⚠ 의미 확인 필요 10


## FPC0112_AlarmPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94e25d1e | .ctor | FPC0112_AlarmPopup.cs:211 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-546b9ca8 | .ctor | FPC0112_AlarmPopup.cs:212 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0112_AlarmPopup.btnAdd_Click

진입점: this.btnPlus.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b52c1a1 | this.btnPlus.Click | FPC0112_AlarmPopup.cs:912 |  | POPUP | new FPC0608_MemoAddPopup | (Filter["MEMO_TYPE"].SafeString()) | 팝업/폼 생성 |  |  |  |
| AC-81a02309 | this.btnPlus.Click | FPC0112_AlarmPopup.cs:913 |  | UI_PROP | memoPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-71888846 | this.btnPlus.Click | FPC0112_AlarmPopup.cs:913 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-99d54f30 | this.btnPlus.Click | FPC0112_AlarmPopup.cs:914 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-778eaf08 | this.btnPlus.Click | FPC0112_AlarmPopup.cs:915 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FPC0112_AlarmPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-718b7247 | this.btnClose.Click | FPC0112_AlarmPopup.cs:937 | if (IsRef == true) ▸ if (s.Good()) | DATA_OP | s.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c42de7a7 | this.btnClose.Click | FPC0112_AlarmPopup.cs:938 | if (IsRef == true) ▸ if (s.Good()) | FLAG | Selected | s.Tables[0].Select("CHK=true").ToList<DataRow>() | 화면 필드/플래그 변경 |  |  |  |
| AC-a091bb8a | this.btnClose.Click | FPC0112_AlarmPopup.cs:938 | if (IsRef == true) ▸ if (s.Good()) | DATA_OP | s.Tables[0].Select | ("CHK=true") | 데이터 객체 조작/조회 |  |  |  |
| AC-091f177c | this.btnClose.Click | FPC0112_AlarmPopup.cs:941 | if (IsRef == true) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f75f21be | this.btnClose.Click | FPC0112_AlarmPopup.cs:942 | if (IsRef == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1cdec058 | this.btnClose.Click | FPC0112_AlarmPopup.cs:944 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0112_AlarmPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a3a3f71 | this.Load | FPC0112_AlarmPopup.cs:267 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-98d8d05c | this.Load | FPC0112_AlarmPopup.cs:268 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-62465b18 | this.Load | FPC0112_AlarmPopup.cs:271 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4a7ce3dd | this.Load | FPC0112_AlarmPopup.cs:272 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-73148d9b | this.Load | FPC0112_AlarmPopup.cs:275 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90812b45 | this.Load | FPC0112_AlarmPopup.cs:279 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0112_AlarmPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7691fb04 | this.Load | FPC0112_AlarmPopup.cs:262 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0112_AlarmPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb5ba489 | Dispose | FPC0112_AlarmPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0112_AlarmPopup.dtPicker_ValueChanged

진입점: this.dtPicker.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7be8f01b | this.dtPicker.ValueChanged | FPC0112_AlarmPopup.cs:964 | if (row >= 0) ▸ if (col >= 0) | GRID_SET | spdMain.ActiveSheet.Cells[row, col].Value | date | 그리드 속성/값 설정 |  |  |  |

## FPC0112_AlarmPopup.EnableButton

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ebb9419 | (진입점 미연결) | FPC0112_AlarmPopup.cs:58 | switch (button) case MemoPopupButton.Add: | STATE | btnPlus.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-8a4bd5af | (진입점 미연결) | FPC0112_AlarmPopup.cs:59 | switch (button) case MemoPopupButton.Add: | FLAG | enableBtnPlus | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-75a3fc49 | (진입점 미연결) | FPC0112_AlarmPopup.cs:62 | switch (button) case MemoPopupButton.Save: | STATE | btnSave.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-1f4bf1f5 | (진입점 미연결) | FPC0112_AlarmPopup.cs:63 | switch (button) case MemoPopupButton.Save: | FLAG | enableBtnSave | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-85d8e271 | (진입점 미연결) | FPC0112_AlarmPopup.cs:66 | switch (button) case MemoPopupButton.Find: | STATE | btnFind.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-03de6292 | (진입점 미연결) | FPC0112_AlarmPopup.cs:67 | switch (button) case MemoPopupButton.Find: | FLAG | enableBtnFind | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-c6a36e89 | (진입점 미연결) | FPC0112_AlarmPopup.cs:70 | switch (button) case MemoPopupButton.Close: | STATE | btnClose.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-3dc6bf39 | (진입점 미연결) | FPC0112_AlarmPopup.cs:71 | switch (button) case MemoPopupButton.Close: | FLAG | enableBtnClose | t_f | 화면 필드/플래그 변경 |  |  |  |

## FPC0112_AlarmPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5bf50e0 | FindButton | FPC0112_AlarmPopup.cs:385 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-60383aca | FindButton | FPC0112_AlarmPopup.cs:386 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-49424401 | FindButton | FPC0112_AlarmPopup.cs:388 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0112_AlarmPopup.FindData

진입점: this.Load / this.btnSave.Click / this.btnFind.Click / this.btnPlus.Click [if (memoPopup.ShowDialog() == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23c9d192 | this.Load 외 4 | FPC0112_AlarmPopup.cs:423 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-43ba7436 | this.Load 외 4 | FPC0112_AlarmPopup.cs:423 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f8a9a38 | this.Load 외 4 | FPC0112_AlarmPopup.cs:428 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-80fca328 | this.Load 외 4 | FPC0112_AlarmPopup.cs:429 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-75193594 | this.Load 외 4 | FPC0112_AlarmPopup.cs:430 |  | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-468b1758 | this.Load 외 4 | FPC0112_AlarmPopup.cs:431 |  | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c5a6c0c9 | this.Load 외 4 | FPC0112_AlarmPopup.cs:432 |  | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a17eea18 | this.Load 외 4 | FPC0112_AlarmPopup.cs:439 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-de5f6222 | this.Load 외 4 | FPC0112_AlarmPopup.cs:443 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_PLANAMENDMEMOP_FIND_PLANAMENDMEMOP", Filter, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6b10368d | this.Load 외 4 | FPC0112_AlarmPopup.cs:446 | try | CALL_BASE | this.Invoke | (new Action(delegate () { if (set.Good()) { set.Tables[0].Columns.SafeAdd("CHK", typeof(bo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f141d856 | this.Load 외 4 | FPC0112_AlarmPopup.cs:450 | try ▸ lambda ▸ if (set.Good()) | DATA_OP | set.Tables[0].Columns.SafeAdd | ("CHK", typeof(bool)) | 데이터 객체 조작/조회 |  |  |  |
| AC-701b19fc | this.Load 외 4 | FPC0112_AlarmPopup.cs:462 | try ▸ lambda ▸ if (set.Good()) ▸ if (set.Good()) ▸ foreach (DataRow er in set.Tables[0].Rows) ▸ if (item_id == "-" \|\| string.IsNullOrWhite… | DATA_OP | er["ALARM_TIME"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fdb06a17 | this.Load 외 4 | FPC0112_AlarmPopup.cs:472 | try ▸ lambda ▸ if (set.Good()) ▸ if (set.Good()) ▸ foreach (DataRow er in set.Tables[0].Rows) ▸ else of (item_id == "-" \|\| string.IsNullOr… | DATA_OP | er["ALARM_TIME"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f8a28f18 | this.Load 외 4 | FPC0112_AlarmPopup.cs:476 | try ▸ lambda ▸ if (set.Good()) ▸ if (set.Good()) ▸ foreach (DataRow er in set.Tables[0].Rows) ▸ else of (item_id == "-" \|\| string.IsNullOr… | DATA_OP | er["ALARM_TIME"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7e677541 | this.Load 외 4 | FPC0112_AlarmPopup.cs:481 | try ▸ lambda ▸ if (set.Good()) ▸ if (set.Good()) ▸ foreach (DataRow er in set.Tables[0].Rows) ▸ else of (item_id == "-" \|\| string.IsNullOr… | DATA_OP | er["ALARM_TIME"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d8e7e849 | this.Load 외 4 | FPC0112_AlarmPopup.cs:488 | try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e68c37a1 | this.Load 외 4 | FPC0112_AlarmPopup.cs:489 | try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-15e30b44 | this.Load 외 4 | FPC0112_AlarmPopup.cs:492 | try ▸ lambda ▸ if (canSave) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("CHK"), siMain.GetColumnIndex("CHK"), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d99d9216 | this.Load 외 4 | FPC0112_AlarmPopup.cs:493 | try ▸ lambda ▸ if (canSave) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("MEMO"), siMain.GetColumnIndex("MEMO"), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-90721241 | this.Load 외 4 | FPC0112_AlarmPopup.cs:494 | try ▸ lambda ▸ if (canSave) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("ALARM_TIME"), siMain.GetColumnIndex("ALARM_TIME"), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eeff5503 | this.Load 외 4 | FPC0112_AlarmPopup.cs:498 | try ▸ lambda ▸ else of (canSave) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("CHK"), siMain.GetColumnIndex("CHK"), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c83d4fbf | this.Load 외 4 | FPC0112_AlarmPopup.cs:499 | try ▸ lambda ▸ else of (canSave) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("MEMO"), siMain.GetColumnIndex("MEMO"), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-06d6b582 | this.Load 외 4 | FPC0112_AlarmPopup.cs:500 | try ▸ lambda ▸ else of (canSave) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("ALARM_TIME"), siMain.GetColumnIndex("ALARM_TIME"), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-495d7c7d | this.Load 외 4 | FPC0112_AlarmPopup.cs:512 | try ▸ lambda ▸ foreach (DataRow er in set.Tables[0].Rows) | CALL_EXT | DateTime.TryParseExact | (er["PLAN_DATE"].SafeString(), "yyyyMMdd",null, System.Globalization.DateTimeStyles.None, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-55ed363f | this.Load 외 4 | FPC0112_AlarmPopup.cs:536 | try ▸ lambda ▸ foreach (DataRow er in set.Tables[0].Rows) ▸ if ((item_id == "-" \|\| string.IsNullOrWhiteSpace(item_id)) && canSave) | GRID_LOCK | siMain.LockRange2 | (row_idx, alarm_idx, row_idx, alarm_idx, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-3c04feab | this.Load 외 4 | FPC0112_AlarmPopup.cs:548 | try ▸ lambda ▸ foreach (DataRow er in set.Tables[0].Rows) ▸ if (plan_date !=null && alert_date !=null) ▸ if (timediff.TotalHours > (24*3)) ▸… | GRID_STYLE | siMain.SetBGColor2 | (row_idx, 0, row_idx, memo_idx, Color.FromArgb(255, 0, 0)) | 그리드 표시 설정 |  |  |  |
| AC-724676fc | this.Load 외 4 | FPC0112_AlarmPopup.cs:553 | try ▸ lambda ▸ foreach (DataRow er in set.Tables[0].Rows) ▸ if (plan_date !=null && alert_date !=null) ▸ if (timediff.TotalHours > (24*3)) ▸… | GRID_STYLE | siMain.SetBGColor2 | (row_idx, 0, row_idx, memo_idx, Color.FromArgb(255, 150, 150)) | 그리드 표시 설정 |  |  |  |
| AC-1a70d773 | this.Load 외 4 | FPC0112_AlarmPopup.cs:558 | try ▸ lambda ▸ foreach (DataRow er in set.Tables[0].Rows) ▸ if (plan_date !=null && alert_date !=null) ▸ if (timediff.TotalHours > (24*3)) ▸… | GRID_STYLE | siMain.SetBGColor2 | (row_idx, 0, row_idx, memo_idx, Color.FromArgb(255, 208, 208)) | 그리드 표시 설정 |  |  |  |
| AC-c18ddd4c | this.Load 외 4 | FPC0112_AlarmPopup.cs:576 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c7184b3 | this.Load 외 4 | FPC0112_AlarmPopup.cs:579 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-053d0405 | this.Load 외 4 | FPC0112_AlarmPopup.cs:580 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-393ede39 | this.Load 외 4 | FPC0112_AlarmPopup.cs:581 | finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-838ef692 | this.Load 외 4 | FPC0112_AlarmPopup.cs:584 | finally ▸ lambda ▸ if (canSave) | STATE | this.btnPlus.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2eb75d0b | this.Load 외 4 | FPC0112_AlarmPopup.cs:585 | finally ▸ lambda ▸ if (canSave) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7c126ec3 | this.Load 외 4 | FPC0112_AlarmPopup.cs:586 | finally ▸ lambda ▸ if (canSave) | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d3c7413 | this.Load 외 4 | FPC0112_AlarmPopup.cs:588 | finally ▸ lambda ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2a252f3f | this.Load 외 4 | FPC0112_AlarmPopup.cs:589 | finally ▸ lambda ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1df7d3b1 | this.Load 외 4 | FPC0112_AlarmPopup.cs:595 | finally ▸ lambda ▸ else of (canSave) | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b93006ed | this.Load 외 4 | FPC0112_AlarmPopup.cs:596 | finally ▸ lambda ▸ else of (canSave) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0112_AlarmPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61c12721 | this.Load | FPC0112_AlarmPopup.cs:220 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-26bbb8df | this.Load | FPC0112_AlarmPopup.cs:222 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0112_AlarmPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d37d529 | (진입점 미연결) | FPC0112_AlarmPopup.cs:804 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-0eaf065f | (진입점 미연결) | FPC0112_AlarmPopup.cs:805 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-272dac12 | (진입점 미연결) | FPC0112_AlarmPopup.cs:806 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-9e5b3e5e | (진입점 미연결) | FPC0112_AlarmPopup.cs:807 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-eeeb65a9 | (진입점 미연결) | FPC0112_AlarmPopup.cs:808 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-3c0a0da7 | (진입점 미연결) | FPC0112_AlarmPopup.cs:809 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-3bacc5dc | (진입점 미연결) | FPC0112_AlarmPopup.cs:810 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b59ee5c2 | (진입점 미연결) | FPC0112_AlarmPopup.cs:812 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-fe80139c | (진입점 미연결) | FPC0112_AlarmPopup.cs:813 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-0ec4a8b1 | (진입점 미연결) | FPC0112_AlarmPopup.cs:817 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-8aa07c22 | (진입점 미연결) | FPC0112_AlarmPopup.cs:818 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FPC0112_AlarmPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b210972c | this.Load | FPC0112_AlarmPopup.cs:246 | if (IsRef == true) | VALUE_SET | btnClose.Text | "Select" | 컨트롤 값 설정 |  |  |  |
| AC-04f0799a | this.Load | FPC0112_AlarmPopup.cs:249 |  | STATE | btnFind.Enabled | enableBtnFind | 컨트롤 상태 Enabled |  |  |  |
| AC-aa173581 | this.Load | FPC0112_AlarmPopup.cs:250 |  | STATE | btnClose.Enabled | enableBtnClose | 컨트롤 상태 Enabled |  |  |  |
| AC-a99fadbc | this.Load | FPC0112_AlarmPopup.cs:252 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2580b1a1 | this.Load | FPC0112_AlarmPopup.cs:254 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7fc2b160 | this.Load | FPC0112_AlarmPopup.cs:255 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0112_AlarmPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ab8e360 | this.Load | FPC0112_AlarmPopup.cs:284 |  | UI_PROP | spdMain.SelectionBlockOptions | FarPoint.Win.Spread.SelectionBlockOptions.None | 속성 SelectionBlockOptions 설정 |  |  |  |
| AC-c5b0652f | this.Load | FPC0112_AlarmPopup.cs:287 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8c0ccda7 | this.Load | FPC0112_AlarmPopup.cs:290 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-031735d0 | this.Load | FPC0112_AlarmPopup.cs:301 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("HASALARM")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-089094fb | this.Load | FPC0112_AlarmPopup.cs:303 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (IsRef==true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CHK")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0c89d737 | this.Load | FPC0112_AlarmPopup.cs:318 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-3a42811f | this.Load | FPC0112_AlarmPopup.cs:319 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-a08d4ad5 | this.Load | FPC0112_AlarmPopup.cs:320 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-0067a3c0 | this.Load | FPC0112_AlarmPopup.cs:325 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2f0dc9d8 | this.Load | FPC0112_AlarmPopup.cs:328 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0112_AlarmPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7d418d4 | (진입점 미연결) | FPC0112_AlarmPopup.cs:376 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0112_AlarmPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fdcc8bc | this.btnSave.Click | FPC0112_AlarmPopup.cs:708 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-5aa5bfcc | this.btnSave.Click | FPC0112_AlarmPopup.cs:708 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfed684a | this.btnSave.Click | FPC0112_AlarmPopup.cs:713 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-500c8fac | this.btnSave.Click | FPC0112_AlarmPopup.cs:714 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-62b1633f | this.btnSave.Click | FPC0112_AlarmPopup.cs:715 |  | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3596b6db | this.btnSave.Click | FPC0112_AlarmPopup.cs:716 |  | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f94c377f | this.btnSave.Click | FPC0112_AlarmPopup.cs:717 |  | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-45535bdf | this.btnSave.Click | FPC0112_AlarmPopup.cs:725 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-21c3e484 | this.btnSave.Click | FPC0112_AlarmPopup.cs:726 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("USER_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f84644a | this.btnSave.Click | FPC0112_AlarmPopup.cs:727 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a34a9654 | this.btnSave.Click | FPC0112_AlarmPopup.cs:728 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | CALL_EXT | m2.Columns["ALARM_TIME"].ChangeType | (typeof(string)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4667d7e2 | this.btnSave.Click | FPC0112_AlarmPopup.cs:731 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | ro["USER_ID"] | ctx.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5350d605 | this.btnSave.Click | FPC0112_AlarmPopup.cs:732 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | m2.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e926acd | this.btnSave.Click | FPC0112_AlarmPopup.cs:747 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) ▸ foreach (DataColumn … | DATA_OP | nn[colname] | n.Value.ToString("yyyy-MM-dd HHH:mm:ss") | 행/컬럼 값 대입 |  |  |  |
| AC-dd9f9a45 | this.btnSave.Click | FPC0112_AlarmPopup.cs:751 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) ▸ foreach (DataColumn … | DATA_OP | nn[colname] | ro[colname] | 행/컬럼 값 대입 |  |  |  |
| AC-5bfe4c05 | this.btnSave.Click | FPC0112_AlarmPopup.cs:756 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) ▸ foreach (DataColumn … | DATA_OP | nn[colname] | ro[colname] | 행/컬럼 값 대입 |  |  |  |
| AC-64000d42 | this.btnSave.Click | FPC0112_AlarmPopup.cs:759 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | m2.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8a30ffe | this.btnSave.Click | FPC0112_AlarmPopup.cs:762 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | ENDPOINT | DataService.FP_PseudoBatch2 | ("PlanAmendMemo", "saveAll_planAmendAlarmMemoP", m2) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=saveAll_planAmendAlarmMemoP] \| … | 엔드포인트 호출 |  |  |  |
| AC-57a3446b | this.btnSave.Click | FPC0112_AlarmPopup.cs:772 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f2d48dc3 | this.btnSave.Click | FPC0112_AlarmPopup.cs:776 | finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7732295a | this.btnSave.Click | FPC0112_AlarmPopup.cs:777 | finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cf8bcec6 | this.btnSave.Click | FPC0112_AlarmPopup.cs:778 | finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7d860535 | this.btnSave.Click | FPC0112_AlarmPopup.cs:781 | finally ▸ if (canSave) | STATE | this.btnPlus.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a887d6ff | this.btnSave.Click | FPC0112_AlarmPopup.cs:782 | finally ▸ if (canSave) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a76988d6 | this.btnSave.Click | FPC0112_AlarmPopup.cs:783 | finally ▸ if (canSave) | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-173860a3 | this.btnSave.Click | FPC0112_AlarmPopup.cs:785 | finally ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0cba2658 | this.btnSave.Click | FPC0112_AlarmPopup.cs:786 | finally ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4dd88c68 | this.btnSave.Click | FPC0112_AlarmPopup.cs:791 | finally ▸ else of (canSave) | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d79dade2 | this.btnSave.Click | FPC0112_AlarmPopup.cs:792 | finally ▸ else of (canSave) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0112_AlarmPopup.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d62f8e84 | (진입점 미연결) | FPC0112_AlarmPopup.cs:368 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27d1b837 | (진입점 미연결) | FPC0112_AlarmPopup.cs:369 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FPC0112_AlarmPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-650c2d12 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:835 |  | GRID_SET | spdMain.ActiveSheet.SelectionPolicy | FarPoint.Win.Spread.Model.SelectionPolicy.Single | 그리드 속성/값 설정 |  |  |  |
| AC-baec2c0b | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:836 |  | GRID_STYLE | spdMain.ActiveSheet.SetActiveCell | (e.Row, e.Column) | 그리드 표시 설정 |  |  |  |
| AC-3e56c642 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:839 |  | VALUE_SET | txtMemo.Text | text | 컨트롤 값 설정 |  |  |  |
| AC-35942080 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:848 | if (row != null) ▸ if (item_id == "-" \|\| string.IsNullOrWhiteSpace(item_id)) | STATE | dtPicker.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1515e9a2 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:852 | if (row != null) ▸ else of (item_id == "-" \|\| string.IsNullOrWhiteSpace(item_id)) | STATE | dtPicker.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-47d37715 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:856 | if (row != null) ▸ else of (item_id == "-" \|\| string.IsNullOrWhiteSpace(item_id)) ▸ if (alarmTime != null && alarmTime.Value.Year > 1901) | VALUE_SET | dtPicker.Value | alarmTime.Value | 컨트롤 값 설정 |  |  |  |
| AC-3b5b0601 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:861 | if (row != null) ▸ else of (item_id == "-" \|\| string.IsNullOrWhiteSpace(item_id)) ▸ else of (alarmTime != null && alarmTime.Value.Year > 1… | VALUE_SET | dtPicker.Value | DateTime.ParseExact("19000101", "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-f99f093f | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:867 | if (row != null) | DATA_OP | Filter["OLD_PIC_REF"] | Filter["PIC_REF"] = pic_ref | 행/컬럼 값 대입 |  |  |  |
| AC-89627c5a | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:867 | if (row != null) | DATA_OP | Filter["PIC_REF"] | pic_ref | 행/컬럼 값 대입 |  |  |  |
| AC-c9f44b68 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:868 | if (row != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "find_alarm", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] \| FP\Common\PICAla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-99363c47 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:871 | if (row != null) ▸ if (alarmInfo.Good()) | VALUE_SET | label1.Text | "ALARM" | 컨트롤 값 설정 |  |  |  |
| AC-d684d775 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:872 | if (row != null) ▸ if (alarmInfo.Good()) | DATA_OP | alarmInfo.Tables[0].Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c121c653 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:873 | if (row != null) ▸ if (alarmInfo.Good()) | DATA_OP | alarmInfo.Tables[0].Columns.SafeAdd | ("TEAM_NAME",typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a41eb1e | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:877 | if (row != null) ▸ if (alarmInfo.Good()) ▸ foreach (DataRow r in alarmInfo.Tables[0].Rows) | DATA_OP | r["USER_ID"] | r["USERID"] | 행/컬럼 값 대입 |  |  |  |
| AC-50d06593 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:878 | if (row != null) ▸ if (alarmInfo.Good()) ▸ foreach (DataRow r in alarmInfo.Tables[0].Rows) | DATA_OP | r["TEAM_NAME"] | r["DEPT_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-2c79dff5 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:880 | if (row != null) ▸ if (alarmInfo.Good()) | GRID_BIND | siSub.Query | (alarmInfo, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a34e2fae | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:885 | if (row != null) ▸ else of (alarmInfo.Good()) | VALUE_SET | label1.Text | "MEMO" | 컨트롤 값 설정 |  |  |  |
| AC-35c28523 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:886 | if (row != null) ▸ else of (alarmInfo.Good()) | GRID_SET | siSub.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-e4c5d183 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:887 | if (row != null) ▸ else of (alarmInfo.Good()) | GRID_CLEAR | siSub.ActiveSheet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-c44bf1c4 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:892 | else of (row != null) | GRID_SET | siSub.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-250614b7 | this.spdMain.CellClick | FPC0112_AlarmPopup.cs:893 | else of (row != null) | GRID_CLEAR | siSub.ActiveSheet.Rows.Clear | () | 그리드 행 비움 |  |  |  |

