# AS-IS 액션 대조표 — FP02003

> 원천: `Doc/asisfacts/screens/FP02003/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 279행 · 메서드 23 · 종류 DATA_OP 96 · GRID_INIT 54 · UI_PROP 19 · ENDPOINT 17 · FLAG 14 · MESSAGE 14 · RETURN 14 · GRID_LOCK 13 · CALL_EXT 9 · UI_MISC 7 · POPUP 4 · LIST_REBIND 4 · GRID_BIND 3 · THROW 3 · STATE_RESET 2 · GRID_SET 2 · LIST_CLEAR 1 · VALUE_SET 1 · VALIDATE 1 · STATE 1 · ⚠ 의미 확인 필요 9


## FP02003_SMS_MAIL_SEND..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2944a1f9 | .ctor | FP02003_SMS_MAIL_SEND.cs:155 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP02003_SMS_MAIL_SEND.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dc73105 | this.btnSql.Click | FP02003_SMS_MAIL_SEND.cs:1238 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-2595b3ad | this.btnSql.Click | FP02003_SMS_MAIL_SEND.cs:1241 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0d508a0c | this.btnSql.Click | FP02003_SMS_MAIL_SEND.cs:1242 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b9f74eca | this.btnSql.Click | FP02003_SMS_MAIL_SEND.cs:1244 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02003_SMS_MAIL_SEND") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1f77282 | this.btnSql.Click | FP02003_SMS_MAIL_SEND.cs:1246 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02003_SMS_MAIL_SEND.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40f77a1f | this.Load | FP02003_SMS_MAIL_SEND.cs:401 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31f254d3 | this.Load | FP02003_SMS_MAIL_SEND.cs:402 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4df87af | this.Load | FP02003_SMS_MAIL_SEND.cs:408 |  | GRID_INIT | this.AddSheet | (spdSMS, SpdSheet.shtSMS, SpdSheet.shtSMS, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fe6469d4 | this.Load | FP02003_SMS_MAIL_SEND.cs:409 |  | FLAG | siSub_S | GetSheetInfo(spdSMS.Name, spdSMS.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8381d2d8 | this.Load | FP02003_SMS_MAIL_SEND.cs:414 |  | GRID_INIT | siSub_S.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6037ca07 | this.Load | FP02003_SMS_MAIL_SEND.cs:417 |  | GRID_INIT | this.AddSheet | (spdMail, SpdSheet.shtMail, SpdSheet.shtMail, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e671235f | this.Load | FP02003_SMS_MAIL_SEND.cs:418 |  | FLAG | siSub_M | GetSheetInfo(spdMail.Name, spdMail.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-af965b18 | this.Load | FP02003_SMS_MAIL_SEND.cs:423 |  | GRID_INIT | siSub_M.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02003_SMS_MAIL_SEND.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d5332ab | DeleteButton | FP02003_SMS_MAIL_SEND.cs:664 |  | MESSAGE | MessageBox.Show | ("Please Insert in Look_up(DEV Message)") | 메시지 표시 |  |  |  |

## FP02003_SMS_MAIL_SEND.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b47a2e9 | Dispose | FP02003_SMS_MAIL_SEND.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02003_SMS_MAIL_SEND.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21c2cf11 | EditButton | FP02003_SMS_MAIL_SEND.cs:674 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d5096792 | EditButton | FP02003_SMS_MAIL_SEND.cs:675 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-3478c417 | EditButton | FP02003_SMS_MAIL_SEND.cs:677 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex("VALID_YN") - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-baf3225e | EditButton | FP02003_SMS_MAIL_SEND.cs:678 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("VALID_YN") + 1, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e304cdfc | EditButton | FP02003_SMS_MAIL_SEND.cs:685 | if (fps != null) ▸ if (fps.Name == "spdSMS") | FLAG | siSub_S | GetSheetInfo(spdSMS.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-79de8d54 | EditButton | FP02003_SMS_MAIL_SEND.cs:686 | if (fps != null) ▸ if (fps.Name == "spdSMS") | GRID_LOCK | siSub_S.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-3cc80b43 | EditButton | FP02003_SMS_MAIL_SEND.cs:695 | if (fps != null) ▸ if (fps.Name == "spdSMS") | GRID_LOCK | siSub_S.LockColumn | (0, siSub_S.GetColumnIndex("ACTIVE_FLAG") - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-855075fc | EditButton | FP02003_SMS_MAIL_SEND.cs:696 | if (fps != null) ▸ if (fps.Name == "spdSMS") | GRID_LOCK | siSub_S.LockColumn | (siSub_S.GetColumnIndex("ACTIVE_FLAG") + 1, siSub_S.GetColumnIndex("SEND_TIME_TEXT"), true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0d5301ae | EditButton | FP02003_SMS_MAIL_SEND.cs:703 | if (fps != null) ▸ if (fps.Name == "spdMail") | FLAG | siSub_M | GetSheetInfo(spdMail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cfbdb3bb | EditButton | FP02003_SMS_MAIL_SEND.cs:704 | if (fps != null) ▸ if (fps.Name == "spdMail") | GRID_LOCK | siSub_M.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-cb10ef00 | EditButton | FP02003_SMS_MAIL_SEND.cs:706 | if (fps != null) ▸ if (fps.Name == "spdMail") | GRID_LOCK | siSub_M.LockColumn | (0, siSub_M.GetColumnIndex("ACTIVE_FLAG") - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-14e9e8f9 | EditButton | FP02003_SMS_MAIL_SEND.cs:707 | if (fps != null) ▸ if (fps.Name == "spdMail") | GRID_LOCK | siSub_M.LockColumn | (siSub_M.GetColumnIndex("ACTIVE_FLAG") + 1, siSub_M.GetColumnIndex("VIEW"), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP02003_SMS_MAIL_SEND.Find_Data_Main

진입점: FindButton [else of (fps != null && fps.Name == SpdSheet.shtSMS) ▸ else of (fps != null && fps.Name == SpdSheet.shtMail)] / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3267513a | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1068 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new TheOne.ServiceModel.Data.FoxDataClient("GSCM", "GSCM.SCM.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c64e817e | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1072 | lambda | ENDPOINT | new TheOne.ServiceModel.Data.FoxDataRequest | ("SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL") ⇒ SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-04ad6da2 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1073 | lambda | DATA_OP | request.Parameters["p_lookup_type"] | mainLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-42833d2c | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1074 | lambda | ENDPOINT | client.ExecuteDataSet | (request) ⇒ {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0003_GET_LOOKUP_MASTER_DET… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb27a51c | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1076 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b8104963 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1090 | if (usrTextBox_Seg.Text.Trim().Length > 0) | DATA_OP | ds.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-765780c3 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1094 | if (usrTextBox_Seg.Text.Trim().Length > 0) ▸ for (i < ds.Tables[0].Rows.Count) | DATA_OP | ds.Tables[0].Rows[i][indexofCol].ToString().ToUpper().Contains | (usrTextBox_Seg.Text.ToUpper()) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbe12019 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1096 | if (usrTextBox_Seg.Text.Trim().Length > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (ds.Tables[0].Rows[i][indexofCol].ToString().ToUpper().C… | DATA_OP | dt_where.ImportRow | (ds.Tables[0].Rows[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc2889a3 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1100 | if (usrTextBox_Seg.Text.Trim().Length > 0) | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1a051f27 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1101 | if (usrTextBox_Seg.Text.Trim().Length > 0) | DATA_OP | ds.Tables.Add | (dt_where) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5c8cd1c | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1111 | if (cboActive.Text != "ALL") | DATA_OP | ds.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e7a8e75 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1117 | if (cboActive.Text != "ALL") ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (ds.Tables[0].Rows[i]["VALID_YN"].ToString() == segActive) | DATA_OP | dt_where.ImportRow | (ds.Tables[0].Rows[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-87803980 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1121 | if (cboActive.Text != "ALL") | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c14c9ae3 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1122 | if (cboActive.Text != "ALL") | DATA_OP | ds.Tables.Add | (dt_where) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d70e221 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1128 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1de6c2bc | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1129 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-91af596b | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1132 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cb7258cf | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:1135 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02003_SMS_MAIL_SEND.Find_Data_Sub_Mail

진입점: spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_CellClk)] / FindButton [else of (fps != null && fps.Name == SpdSheet.shtSMS) ▸ if (fps != null && fps.Name == SpdSheet.shtMail)] / SaveButton [if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-403e9838 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1185 |  | CALL_EXT | CString.GetComboBoxValue | (cboActive.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b6a6050 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1189 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new TheOne.ServiceModel.Data.FoxDataClient("GSCM", "GSCM.SCM.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-309a93bb | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1193 | lambda | ENDPOINT | new TheOne.ServiceModel.Data.FoxDataRequest | ("SCM.SCM0006_GET_RECIPIENT_MASTER") ⇒ SCM.SCM0006_GET_RECIPIENT_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-08d04dab | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1194 | lambda | DATA_OP | request.Parameters["p_use_type"] | "MAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-1b73c449 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1195 | lambda | DATA_OP | request.Parameters["p_module"] | _seg3 | 행/컬럼 값 대입 |  |  |  |
| AC-b36e8759 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1196 | lambda | DATA_OP | request.Parameters["p_submodule"] | _seg4 | 행/컬럼 값 대입 |  |  |  |
| AC-dea7b072 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1197 | lambda | DATA_OP | request.Parameters["p_active"] | Active | 행/컬럼 값 대입 |  |  |  |
| AC-ca9b0acd | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1199 | lambda | ENDPOINT | client.ExecuteDataSet | (request) ⇒ {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER"… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-231f3278 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1201 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e6c4361c | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1205 |  | GRID_BIND | siSub_M.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-da9490cb | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1206 |  | GRID_LOCK | siSub_M.LockColumn | (0, siSub_M.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ee24605 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1208 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b18888d0 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1211 |  | GRID_INIT | siSub_M.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02003_SMS_MAIL_SEND.Find_Data_Sub_SMS

진입점: spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_CellClk)] / FindButton [if (fps != null && fps.Name == SpdSheet.shtSMS)] / SaveButton [if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a86c779 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1146 |  | CALL_EXT | CString.GetComboBoxValue | (cboActive.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a64dd578 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1150 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new TheOne.ServiceModel.Data.FoxDataClient("GSCM", "GSCM.SCM.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e064e9c6 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1154 | lambda | ENDPOINT | new TheOne.ServiceModel.Data.FoxDataRequest | ("SCM.SCM0006_GET_RECIPIENT_MASTER") ⇒ SCM.SCM0006_GET_RECIPIENT_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-8cc8f9d7 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1155 | lambda | DATA_OP | request.Parameters["p_use_type"] | "SMS" | 행/컬럼 값 대입 |  |  |  |
| AC-fb21cfee | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1156 | lambda | DATA_OP | request.Parameters["p_module"] | _seg3 | 행/컬럼 값 대입 |  |  |  |
| AC-14d8f1b0 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1157 | lambda | DATA_OP | request.Parameters["p_submodule"] | _seg4 | 행/컬럼 값 대입 |  |  |  |
| AC-62af9cd2 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1158 | lambda | DATA_OP | request.Parameters["p_active"] | Active | 행/컬럼 값 대입 |  |  |  |
| AC-9fe58773 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1160 | lambda | ENDPOINT | client.ExecuteDataSet | (request) ⇒ {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER"… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8c92d21 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1162 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-cf956c3b | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1166 |  | GRID_BIND | siSub_S.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7c03d7d6 | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1167 |  | GRID_LOCK | siSub_S.LockColumn | (0, siSub_S.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-04e85c4a | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1169 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-10a8ef7f | spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_Cell… 외 2 | FP02003_SMS_MAIL_SEND.cs:1172 |  | GRID_INIT | siSub_S.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02003_SMS_MAIL_SEND.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80870167 | this.Load | FP02003_SMS_MAIL_SEND.cs:164 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02003_SMS_MAIL_SEND.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ae3d3e8 | this.Load | FP02003_SMS_MAIL_SEND.cs:386 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-51663838 | this.Load | FP02003_SMS_MAIL_SEND.cs:388 |  | LIST_REBIND | cboActive.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-c36b413c | this.Load | FP02003_SMS_MAIL_SEND.cs:390 |  | LIST_CLEAR | usrComboBox_Seg.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-aa71fdb4 | this.Load | FP02003_SMS_MAIL_SEND.cs:391 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT 1") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f598481 | this.Load | FP02003_SMS_MAIL_SEND.cs:392 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT 2") | 데이터 객체 조작/조회 |  |  |  |
| AC-72fa8e9a | this.Load | FP02003_SMS_MAIL_SEND.cs:393 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT 3") | 데이터 객체 조작/조회 |  |  |  |
| AC-20ea9c6a | this.Load | FP02003_SMS_MAIL_SEND.cs:394 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT 4") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b4b72d0 | this.Load | FP02003_SMS_MAIL_SEND.cs:395 |  | VALUE_SET | usrComboBox_Seg.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP02003_SMS_MAIL_SEND.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cff2d293 | this.Load | FP02003_SMS_MAIL_SEND.cs:435 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ed75323 | this.Load | FP02003_SMS_MAIL_SEND.cs:436 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0239ee0f | this.Load | FP02003_SMS_MAIL_SEND.cs:437 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2fe97a85 | this.Load | FP02003_SMS_MAIL_SEND.cs:441 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP02003_SMS_MAIL_SEND.InitSpread_M

진입점: this.Load / spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_CellClk)] / FindButton [else of (fps != null && fps.Name == SpdSheet.shtSMS) ▸ if (fps != null && fps.Name == SpdSheet.shtMail)] / SaveButton [if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdaaf3b3 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:496 | try | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8266aeb9 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:500 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6bd01555 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:501 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddComboColumn | ("USE_TYPE_CODE", DefColumns.USE_TYPE_CODE, FPMerge.None, 100, false, dtModule, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec3c31de | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:502 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddComboColumn | ("Module*", DefColumns.MODULE_CODE, FPMerge.Restricted, 100, true, dtModule, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f75e7515 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:503 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub Module*", DefColumns.SUB_MODULE_CODE, FPMerge.Restricted, 100, true, dtSubModule, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3510ecaf | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:504 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5110f6fc | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:505 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddTextColumn | ("Category*", DefColumns.CATEGORY_DESC, FPMerge.Restricted, 250, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ef51b45e | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:506 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.Restricted, 80, true, dtYesOrNo, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a44cebdb | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:508 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddComboColumn | ("Main*", DefColumns.CYCLE_CLASS_CODE, FPMerge.Restricted, 80, true, dtCycle, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c6b3a242 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:509 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub1", DefColumns.DETAIL_CLASS_CODE, FPMerge.Restricted, 80, true, dtCycleSub1, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b7ce4b0 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:510 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub2", DefColumns.SEND_TIME_TEXT, FPMerge.Restricted, 80, true, dtCycleSub2, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ed275dca | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:511 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub3", DefColumns.SEND_MIN_TIME_TEXT, FPMerge.Restricted, 80, true, dtCycleSub3, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ff85c41 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:513 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.AddButtonColumn | ("SQL VIEW", DefColumns.VIEW, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f28fee2 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:517 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.USE_TYPE_CODE), 2, 1, 25, "USE_TYPE_CODE", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aac663f6 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:518 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.MODULE_CODE), 2, 1, 25, "Module*", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2fd8e205 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:519 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.SUB_MODULE_CODE), 2, 1, 25, "Sub Module*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89b3e253 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:520 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.CATEGORY_DESC), 2, 1, 25, "Category*", FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66ec3e8f | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:521 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.ACTIVE_FLAG), 2, 1, 25, "Active", FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b3eacc2 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:523 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | CALL_EXT | clsCtrl.HeaderSpan | (spreadInfo, 0, DefColumns.CYCLE_CLASS_CODE, 1, 4, "Period") | ⚠ 의미 확인 필요 |  |  |  |
| AC-69358974 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:525 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.VIEW), 2, 1, 25, "SQL VIEW", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0df8ad72 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:527 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMail) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d30531d1 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:535 | try | GRID_INIT | siSub_M.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c640325 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:536 | try | GRID_INIT | siSub_M.ChangeActiveSheet | (SpdSheet.shtMail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8c034191 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:541 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP02003_SMS_MAIL_SEND.InitSpread_S

진입점: this.Load / spdMain.CellClick [if (!IsEditMode) ▸ if (!bool_SpdMain_CellClk)] / FindButton [if (fps != null && fps.Name == SpdSheet.shtSMS)] / SaveButton [if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7527f39 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:450 | try | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-009a7bd5 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:454 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-200f280b | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:455 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.AddComboColumn | ("USE_TYPE_CODE", DefColumns.USE_TYPE_CODE, FPMerge.None, 100, false, dtModule, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-880dd5f3 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:456 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.AddComboColumn | ("Module*", DefColumns.MODULE_CODE, FPMerge.Restricted, 100, true, dtModule, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-38635208 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:457 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub Module*", DefColumns.SUB_MODULE_CODE, FPMerge.Restricted, 100, true, dtSubModule, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b433ce38 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:458 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d1ccb5c2 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:459 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.AddTextColumn | ("Category*", DefColumns.CATEGORY_DESC, FPMerge.Restricted, 250, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b64a4742 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:460 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.Restricted, 80, true, dtYesOrNo, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f306512f | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:462 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.AddComboColumn | ("Main*", DefColumns.CYCLE_CLASS_CODE, FPMerge.Restricted, 80, true, dtCycle, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec7ce54e | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:463 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub1", DefColumns.DETAIL_CLASS_CODE, FPMerge.Restricted, 80, true, dtCycleSub1, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e765c36b | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:464 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub2", DefColumns.SEND_TIME_TEXT, FPMerge.Restricted, 80, true, dtCycleSub2, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12c1bec3 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:467 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.USE_TYPE_CODE), 2, 1, 25, "USE_TYPE_CODE", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e5844138 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:468 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.MODULE_CODE), 2, 1, 25, "Module*", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c584584e | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:469 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.SUB_MODULE_CODE), 2, 1, 25, "Sub Module*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f2879be | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:470 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.CATEGORY_DESC), 2, 1, 25, "Category*", FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f1d9b30 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:471 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.ACTIVE_FLAG), 2, 1, 25, "Active", FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb44d0e8 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:472 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | CALL_EXT | clsCtrl.HeaderSpan | (spreadInfo, 0, DefColumns.CYCLE_CLASS_CODE, 1, 3, "Period") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2be31ac0 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:473 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSMS) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-321d9017 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:481 | try | GRID_INIT | siSub_S.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0cae9fa5 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:482 | try | GRID_INIT | siSub_S.ChangeActiveSheet | (SpdSheet.shtSMS) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-19b2de23 | this.Load 외 3 | FP02003_SMS_MAIL_SEND.cs:487 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP02003_SMS_MAIL_SEND.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0dad30e | InsertButton | FP02003_SMS_MAIL_SEND.cs:655 |  | MESSAGE | MessageBox.Show | ("Please Insert in Look_up(DEV Message)") | 메시지 표시 |  |  |  |

## FP02003_SMS_MAIL_SEND.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b073e3a | popSql.OnSql | FP02003_SMS_MAIL_SEND.cs:1256 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02003_SMS_MAIL_SEND.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c652cc2 | SaveButton | FP02003_SMS_MAIL_SEND.cs:729 | if (fps.Name == "spdMain") | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-517691a1 | SaveButton | FP02003_SMS_MAIL_SEND.cs:730 | if (fps.Name == "spdMain") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4233ab8a | SaveButton | FP02003_SMS_MAIL_SEND.cs:733 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-e7b7d753 | SaveButton | FP02003_SMS_MAIL_SEND.cs:733 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee8f875b | SaveButton | FP02003_SMS_MAIL_SEND.cs:744 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c599c814 | SaveButton | FP02003_SMS_MAIL_SEND.cs:754 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[CAppSetting.StringAction] | action | 행/컬럼 값 대입 |  |  |  |
| AC-884d239b | SaveButton | FP02003_SMS_MAIL_SEND.cs:755 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LOOKUP_TYPE] | "SMS_MAIL_SEND_SYSTEM" | 행/컬럼 값 대입 |  |  |  |
| AC-90d3e232 | SaveButton | FP02003_SMS_MAIL_SEND.cs:756 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.DESCRIPTION] | SP_DataSource.Tables[0].Rows[i][DefColumns.DESCRIPTION].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bb3f3ec0 | SaveButton | FP02003_SMS_MAIL_SEND.cs:757 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT1] | SP_DataSource.Tables[0].Rows[i][DefColumns.SEGMENT1].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bfae93e8 | SaveButton | FP02003_SMS_MAIL_SEND.cs:758 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT2] | SP_DataSource.Tables[0].Rows[i][DefColumns.SEGMENT2].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b7ca237e | SaveButton | FP02003_SMS_MAIL_SEND.cs:759 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT3] | SP_DataSource.Tables[0].Rows[i][DefColumns.SEGMENT3].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-92829d4b | SaveButton | FP02003_SMS_MAIL_SEND.cs:760 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT4] | SP_DataSource.Tables[0].Rows[i][DefColumns.SEGMENT4].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6959cbc | SaveButton | FP02003_SMS_MAIL_SEND.cs:761 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT5] | SP_DataSource.Tables[0].Rows[i][DefColumns.SEGMENT5].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4e6419f2 | SaveButton | FP02003_SMS_MAIL_SEND.cs:762 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT1_KEY] | SP_DataSource.Tables[0].Rows[i][DefColumns.SEGMENT1_KEY].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-23d24bc7 | SaveButton | FP02003_SMS_MAIL_SEND.cs:763 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT2_KEY] | SP_DataSource.Tables[0].Rows[i][DefColumns.SEGMENT2_KEY].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ec8535b | SaveButton | FP02003_SMS_MAIL_SEND.cs:764 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT3_KEY] | SP_DataSource.Tables[0].Rows[i][DefColumns.SEGMENT3_KEY].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d5d61bc5 | SaveButton | FP02003_SMS_MAIL_SEND.cs:765 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT4_KEY] | SP_DataSource.Tables[0].Rows[i][DefColumns.SEGMENT4_KEY].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-76655200 | SaveButton | FP02003_SMS_MAIL_SEND.cs:766 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT5_KEY] | SP_DataSource.Tables[0].Rows[i][DefColumns.SEGMENT5_KEY].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05ccfe97 | SaveButton | FP02003_SMS_MAIL_SEND.cs:767 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.DISPLAY_SEQ] | sDisplaySeq | 행/컬럼 값 대입 |  |  |  |
| AC-bddbb4ae | SaveButton | FP02003_SMS_MAIL_SEND.cs:768 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.VALID_YN] | SP_DataSource.Tables[0].Rows[i][DefColumns.VALID_YN].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9e298d2f | SaveButton | FP02003_SMS_MAIL_SEND.cs:769 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE1] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE1].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5786118f | SaveButton | FP02003_SMS_MAIL_SEND.cs:770 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE2] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE2].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-291ca343 | SaveButton | FP02003_SMS_MAIL_SEND.cs:771 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE3] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE3].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fe959323 | SaveButton | FP02003_SMS_MAIL_SEND.cs:772 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE4] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE4].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-797f6422 | SaveButton | FP02003_SMS_MAIL_SEND.cs:773 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE5] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE5].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-11070749 | SaveButton | FP02003_SMS_MAIL_SEND.cs:774 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE6] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE6].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9c1a440f | SaveButton | FP02003_SMS_MAIL_SEND.cs:775 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE7] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE7].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-847ac737 | SaveButton | FP02003_SMS_MAIL_SEND.cs:776 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE8] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE8].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-befe51c8 | SaveButton | FP02003_SMS_MAIL_SEND.cs:777 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE9] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE9].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b8f0b6cf | SaveButton | FP02003_SMS_MAIL_SEND.cs:778 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE10] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE10].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b193721 | SaveButton | FP02003_SMS_MAIL_SEND.cs:779 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE11] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE11].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54b64965 | SaveButton | FP02003_SMS_MAIL_SEND.cs:780 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE12] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE12].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1325a413 | SaveButton | FP02003_SMS_MAIL_SEND.cs:781 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE13] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE13].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8d96ca1 | SaveButton | FP02003_SMS_MAIL_SEND.cs:782 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE14] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE14].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-702751ed | SaveButton | FP02003_SMS_MAIL_SEND.cs:783 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE15] | SP_DataSource.Tables[0].Rows[i][DefColumns.ATTRIBUTE15].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b6e19e01 | SaveButton | FP02003_SMS_MAIL_SEND.cs:787 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATED_BY] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bc6995cb | SaveButton | FP02003_SMS_MAIL_SEND.cs:788 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATION_DATE] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-07a5b276 | SaveButton | FP02003_SMS_MAIL_SEND.cs:792 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATED_BY] | SP_DataSource.Tables[0].Rows[i][DefColumns.CREATED_BY].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c7b9520 | SaveButton | FP02003_SMS_MAIL_SEND.cs:793 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATION_DATE] | Convert.ToDateTime(SP_DataSource.Tables[0].Rows[i][DefColumns.CREATION_DATE].ToString()).T… | 행/컬럼 값 대입 |  |  |  |
| AC-2794c620 | SaveButton | FP02003_SMS_MAIL_SEND.cs:795 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LAST_UPDATED_BY] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a9dba5ff | SaveButton | FP02003_SMS_MAIL_SEND.cs:797 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-093ac9ef | SaveButton | FP02003_SMS_MAIL_SEND.cs:800 | if (fps.Name == "spdMain") | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-073696e4 | SaveButton | FP02003_SMS_MAIL_SEND.cs:808 | if (fps.Name == "spdMain") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.StringAction].ToString()) case CAppSet… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-84ab28ff | SaveButton | FP02003_SMS_MAIL_SEND.cs:809 | if (fps.Name == "spdMain") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.StringAction].ToString()) case CAppSet… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b246608 | SaveButton | FP02003_SMS_MAIL_SEND.cs:810 | if (fps.Name == "spdMain") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.StringAction].ToString()) case CAppSet… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7c66dc22 | SaveButton | FP02003_SMS_MAIL_SEND.cs:816 | if (fps.Name == "spdMain") | UI_PROP | request.UpdateQueryId | "SCM.SCM0003_SAVE_LOOKUP_MASTER_DETAIL" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-7bec530e | SaveButton | FP02003_SMS_MAIL_SEND.cs:818 | if (fps.Name == "spdMain") | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-96e4c9f3 | SaveButton | FP02003_SMS_MAIL_SEND.cs:818 | if (fps.Name == "spdMain") | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc89a0c1 | SaveButton | FP02003_SMS_MAIL_SEND.cs:822 | if (fps.Name == "spdMain") | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new TheOne.ServiceModel.Data.FoxDataClient("GSCM", "GSCM.SCM.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-107f3002 | SaveButton | FP02003_SMS_MAIL_SEND.cs:826 | if (fps.Name == "spdMain") ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9fb3f4f4 | SaveButton | FP02003_SMS_MAIL_SEND.cs:826 | if (fps.Name == "spdMain") ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-1a7c669d | SaveButton | FP02003_SMS_MAIL_SEND.cs:831 | if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-586db87f | SaveButton | FP02003_SMS_MAIL_SEND.cs:894 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ if (isDelete) | MESSAGE | MessageHelper.GMessageBox | ("MSG00121") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb747740 | SaveButton | FP02003_SMS_MAIL_SEND.cs:894 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ if (isDelete) ▸ if (MessageHelper.GMessageBox("MSG00121") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-feef17ec | SaveButton | FP02003_SMS_MAIL_SEND.cs:896 | if (fps.Name == "SMS") ▸ if (iCount > 0) | ENDPOINT | new TheOne.ServiceModel.Data.FoxDataRequest | ("SCM.SCM0006_SAVE_RECIPIENT_MASTER") ⇒ SCM.SCM0006_SAVE_RECIPIENT_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-557a94b4 | SaveButton | FP02003_SMS_MAIL_SEND.cs:901 | if (fps.Name == "SMS") ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new TheOne.ServiceModel.Data.FoxDataClient("GSCM", "GSCM.SCM.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11ae525e | SaveButton | FP02003_SMS_MAIL_SEND.cs:905 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-957dccf5 | SaveButton | FP02003_SMS_MAIL_SEND.cs:906 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_use_type"] | p_use_type | 행/컬럼 값 대입 |  |  |  |
| AC-5d23264e | SaveButton | FP02003_SMS_MAIL_SEND.cs:907 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_module"] | p_module | 행/컬럼 값 대입 |  |  |  |
| AC-8b339d3f | SaveButton | FP02003_SMS_MAIL_SEND.cs:908 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_submodule"] | p_submodule | 행/컬럼 값 대입 |  |  |  |
| AC-8ca03685 | SaveButton | FP02003_SMS_MAIL_SEND.cs:909 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-b535b822 | SaveButton | FP02003_SMS_MAIL_SEND.cs:910 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_category_desc"] | p_category_desc | 행/컬럼 값 대입 |  |  |  |
| AC-ea4f65cc | SaveButton | FP02003_SMS_MAIL_SEND.cs:911 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_cycle_class_code"] | p_cycle_class_code | 행/컬럼 값 대입 |  |  |  |
| AC-0e53edae | SaveButton | FP02003_SMS_MAIL_SEND.cs:912 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_detail_class_code"] | p_detail_class_code | 행/컬럼 값 대입 |  |  |  |
| AC-6f41cb4b | SaveButton | FP02003_SMS_MAIL_SEND.cs:913 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_send_time_text"] | p_send_time_text | 행/컬럼 값 대입 |  |  |  |
| AC-e680cbc1 | SaveButton | FP02003_SMS_MAIL_SEND.cs:914 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_send_min_time_text"] | p_send_min_time_text | 행/컬럼 값 대입 |  |  |  |
| AC-92d72ed5 | SaveButton | FP02003_SMS_MAIL_SEND.cs:915 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active"] | p_active | 행/컬럼 값 대입 |  |  |  |
| AC-ff3d013b | SaveButton | FP02003_SMS_MAIL_SEND.cs:916 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-ea63235b | SaveButton | FP02003_SMS_MAIL_SEND.cs:917 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-b4f2f977 | SaveButton | FP02003_SMS_MAIL_SEND.cs:918 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-acbc8f9e | SaveButton | FP02003_SMS_MAIL_SEND.cs:920 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) ⇒ {?new TheOne.ServiceModel.Data.FoxDataRequest(null)}#{?serviceUri} \| {?new TheO… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a3b19d54 | SaveButton | FP02003_SMS_MAIL_SEND.cs:920 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-63f0748e | SaveButton | FP02003_SMS_MAIL_SEND.cs:929 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be9d34c7 | SaveButton | FP02003_SMS_MAIL_SEND.cs:938 | if (fps.Name == "SMS") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d4076e45 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1004 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ if (isDelete) | MESSAGE | MessageHelper.GMessageBox | ("MSG00121") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f991f99 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1004 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ if (isDelete) ▸ if (MessageHelper.GMessageBox("MSG00121") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbadbba5 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1006 | if (fps.Name == "Mail") ▸ if (iCount > 0) | ENDPOINT | new TheOne.ServiceModel.Data.FoxDataRequest | ("SCM.SCM0006_SAVE_RECIPIENT_MASTER") ⇒ SCM.SCM0006_SAVE_RECIPIENT_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-a64ca10e | SaveButton | FP02003_SMS_MAIL_SEND.cs:1011 | if (fps.Name == "Mail") ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new TheOne.ServiceModel.Data.FoxDataClient("GSCM", "GSCM.SCM.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-392c5210 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1015 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-485608a8 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1016 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_use_type"] | p_use_type | 행/컬럼 값 대입 |  |  |  |
| AC-71a0a98b | SaveButton | FP02003_SMS_MAIL_SEND.cs:1017 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_module"] | p_module | 행/컬럼 값 대입 |  |  |  |
| AC-47a1f261 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1018 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_submodule"] | p_submodule | 행/컬럼 값 대입 |  |  |  |
| AC-5acc1b9d | SaveButton | FP02003_SMS_MAIL_SEND.cs:1019 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-44eb9c70 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1020 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_category_desc"] | p_category_desc | 행/컬럼 값 대입 |  |  |  |
| AC-b0ccee15 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1021 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_cycle_class_code"] | p_cycle_class_code | 행/컬럼 값 대입 |  |  |  |
| AC-f4bef4ce | SaveButton | FP02003_SMS_MAIL_SEND.cs:1022 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_detail_class_code"] | p_detail_class_code | 행/컬럼 값 대입 |  |  |  |
| AC-7a2f8a03 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1023 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_send_time_text"] | p_send_time_text | 행/컬럼 값 대입 |  |  |  |
| AC-1fd75dc8 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1024 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_send_min_time_text"] | p_send_min_time_text | 행/컬럼 값 대입 |  |  |  |
| AC-332a2fac | SaveButton | FP02003_SMS_MAIL_SEND.cs:1025 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active"] | p_active | 행/컬럼 값 대입 |  |  |  |
| AC-5d27dca6 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1026 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-316a03c0 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1027 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-888540c3 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1028 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-61d84fa2 | SaveButton | FP02003_SMS_MAIL_SEND.cs:1030 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) ⇒ {?new TheOne.ServiceModel.Data.FoxDataRequest(null)}#{?serviceUri} \| {?new TheO… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c09e1dbe | SaveButton | FP02003_SMS_MAIL_SEND.cs:1030 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-97a43b9a | SaveButton | FP02003_SMS_MAIL_SEND.cs:1039 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-435653ad | SaveButton | FP02003_SMS_MAIL_SEND.cs:1048 | if (fps.Name == "Mail") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02003_SMS_MAIL_SEND.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b621a062 | this.Load | FP02003_SMS_MAIL_SEND.cs:377 |  | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP02003_SMS_MAIL_SEND.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4efa2aab | this.Load [try] | FP02003_SMS_MAIL_SEND.cs:549 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab982cec | this.Load [try] | FP02003_SMS_MAIL_SEND.cs:550 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-47d3dd76 | this.Load [try] | FP02003_SMS_MAIL_SEND.cs:553 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP02003_SMS_MAIL_SEND.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cc37894 | spdMain.CellClick | FP02003_SMS_MAIL_SEND.cs:360 | if (!IsEditMode) ▸ if (!bool_SpdMain_CellClk) | FLAG | _seg1 | row[idx_seg1].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a0d28b35 | spdMain.CellClick | FP02003_SMS_MAIL_SEND.cs:361 | if (!IsEditMode) ▸ if (!bool_SpdMain_CellClk) | FLAG | _seg2 | row[idx_seg2].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-aa778667 | spdMain.CellClick | FP02003_SMS_MAIL_SEND.cs:362 | if (!IsEditMode) ▸ if (!bool_SpdMain_CellClk) | FLAG | _seg3 | row[idx_seg3].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-acb20cbe | spdMain.CellClick | FP02003_SMS_MAIL_SEND.cs:363 | if (!IsEditMode) ▸ if (!bool_SpdMain_CellClk) | FLAG | _seg4 | row[idx_seg4].ToString() | 화면 필드/플래그 변경 |  |  |  |

## FP02003_SMS_MAIL_SEND.SpdMain_MouseMove

진입점: spdMain.MouseMove

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2cd3835 | spdMain.MouseMove | FP02003_SMS_MAIL_SEND.cs:342 |  | FLAG | bool_SpdMain_CellClk | false | 화면 필드/플래그 변경 |  |  |  |

## FP02003_SMS_MAIL_SEND.SprCategory_CellClick

진입점: spdMail.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a6a5233 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:182 | if (this.siSub_M.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef158edb | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:189 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siSub_M.GetColumnIndex(DefColumns.VIEW)) | POPUP | new GSCM.SCM.Master.UIL.POPUP.SCM0006_PopSQL | () | 팝업/폼 생성 |  |  |  |
| AC-72d534b8 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:190 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siSub_M.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.UseTypeCode | siSub_M.GetValue(e.Row, siSub_M.GetColumnIndex(DefColumns.USE_TYPE_CODE)).ToString() | 속성 UseTypeCode 설정 |  |  |  |
| AC-9b043286 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:191 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siSub_M.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.ModuleCode | siSub_M.GetValue(e.Row, siSub_M.GetColumnIndex(DefColumns.MODULE_CODE)).ToString() | 속성 ModuleCode 설정 |  |  |  |
| AC-d6469709 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:192 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siSub_M.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.SubModuleCode | siSub_M.GetValue(e.Row, siSub_M.GetColumnIndex(DefColumns.SUB_MODULE_CODE)).ToString() | 속성 SubModuleCode 설정 |  |  |  |
| AC-5f49fd1d | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:193 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siSub_M.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.CategoryID | strCategoryID | 속성 CategoryID 설정 |  |  |  |
| AC-d5445112 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:194 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siSub_M.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.CategoryDESC | siSub_M.GetValue(e.Row, siSub_M.GetColumnIndex(DefColumns.CATEGORY_DESC)).ToString() | 속성 CategoryDESC 설정 |  |  |  |
| AC-51c9968e | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:195 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siSub_M.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.LastUpdateBy | UserInfo.UserId | 속성 LastUpdateBy 설정 |  |  |  |
| AC-3830c34d | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:197 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siSub_M.GetColumnIndex(DefColumns.VIEW)) | POPUP | popSQL.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |
| AC-7cd0e45c | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:207 | if (siSub_M.IsLock(siSub_M.SheetName) == false) | CALL_EXT | siSub_M.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e21c4fbb | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:209 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (siSub_M.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction) == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee001925 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:212 | if (siSub_M.IsLock(siSub_M.SheetName) == false) | CALL_EXT | siSub_M.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-95df3979 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:228 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.IsNullOrE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00111", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15003522 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:229 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.IsNullOrE… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-952706b8 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:234 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (String.IsNu… | DATA_OP | dtSubModule.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b0352649 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:236 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (String.IsNu… | UI_PROP | dvNewSubModule.RowFilter | string.Format("SYSTEM_CODE = '{0}'", strModule) | 속성 RowFilter 설정 |  |  |  |
| AC-34f48a4e | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:238 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (String.IsNu… | LIST_REBIND | siSub_M.LoadCombo | (e.Row, e.Column, dvNewSubModule.ToTable(), strSubModule, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-a0a270ac | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:238 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (String.IsNu… | DATA_OP | dvNewSubModule.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-10ab8d85 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:253 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullOrEmpty(st… | MESSAGE | MessageHelper.GMessageBox | ("MSG00112", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f4c8d8d1 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:254 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullOrEmpty(st… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-ee0fbc82 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:259 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.IsNullOrEmp… | DATA_OP | dtCycleSub1.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-834773a7 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:261 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.IsNullOrEmp… | UI_PROP | dvNewSub1.RowFilter | string.Format("CYCLE_CODE = '{0}'", strMain) | 속성 RowFilter 설정 |  |  |  |
| AC-625ee675 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:263 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.IsNullOrEmp… | LIST_REBIND | siSub_M.LoadCombo | (e.Row, e.Column, dvNewSub1.ToTable(), strCurr, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-0ef66080 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:263 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.IsNullOrEmp… | DATA_OP | dvNewSub1.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a1107197 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:274 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (strMain == "RT") | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-d0eab54b | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:275 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (strMain == "RT") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0fabc63 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:285 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (String.IsNullOrEmpty(strMa… | MESSAGE | MessageHelper.GMessageBox | ("MSG00112", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e0089c6 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:286 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (String.IsNullOrEmpty(strMa… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-f10f729f | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:291 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNullOrEmpty(… | DATA_OP | dtCycleSub2.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-22ae00d6 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:295 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNullOrEmpty(… | UI_PROP | dvNewSub2.RowFilter | string.Format("CYCLE_CODE = '{0}'", "DAY") | 속성 RowFilter 설정 |  |  |  |
| AC-88919edb | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:299 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNullOrEmpty(… | UI_PROP | dvNewSub2.RowFilter | string.Format("CYCLE_CODE = '{0}'", "HOUR") | 속성 RowFilter 설정 |  |  |  |
| AC-833a2d7f | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:302 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNullOrEmpty(… | LIST_REBIND | siSub_M.LoadCombo | (e.Row, e.Column, dvNewSub2.ToTable(), strCurr, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-8d346db4 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:302 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNullOrEmpty(… | DATA_OP | dvNewSub2.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7899ed71 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:315 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (e.Column == siSub_M.GetColumnIndex("SEND_MIN_TIME_TEXT")) ▸ if (strMain == "DAY" \|\| … | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-30049580 | spdMail.CellClick | FP02003_SMS_MAIL_SEND.cs:330 | if (siSub_M.IsLock(siSub_M.SheetName) == false) ▸ if (String.IsNullOrEmpty(strState) \|\| strState == "M" \|\| strState == "D") ▸ if (e.Colu… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## FP02003_SMS_MAIL_SEND.UIFindData

진입점: FindButton [else of (fps != null && fps.Name == SpdSheet.shtSMS) ▸ else of (fps != null && fps.Name == SpdSheet.shtMail)] / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f5613c9 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:586 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5477b59 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:593 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f11ede8a | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:614 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cd3c2990 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:615 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-1f2dd19f | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:620 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-9ad05b26 | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:621 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-dea269ab | FindButton [else of (fps != null && fps.Name == SpdSheet.sht… 외 1 | FP02003_SMS_MAIL_SEND.cs:639 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

