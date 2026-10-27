# AS-IS 액션 대조표 — SCM0006

> 원천: `Doc/asisfacts/screens/SCM0006/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 404행 · 메서드 41 · 종류 DATA_OP 80 · GRID_INIT 56 · UI_PROP 49 · RETURN 41 · MESSAGE 29 · ENDPOINT 27 · GRID_SET 25 · FLAG 18 · CALL_EXT 17 · GRID_LOCK 15 · UI_MISC 12 · LIST_REBIND 10 · VALUE_SET 9 · POPUP 8 · GRID_BIND 4 · STATE_RESET 2 · VALIDATE 2 · ⚠ 의미 확인 필요 17


## SCM0006_Mail_Setup.BtnRAdd_Click

진입점: this.btnRAdd.Click / All_Receiver.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68f4360d | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1510 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9cb83268 | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1511 | if (siAllReceiver.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ab80f05 | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1514 | if (dtAllReceiver != null) | STATE_RESET | dtAllReceiver.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-521ce88a | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1516 |  | FLAG | dtAllReceiver | (siAllReceiver.SpreadObject.DataSource as DataSet).Tables[0].Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-64b8b61c | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1516 |  | DATA_OP | (siAllReceiver.SpreadObject.DataSource as DataSet).Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |

## SCM0006_Mail_Setup.BtnRDel_Click

진입점: this.btnRDel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a86b8647 | this.btnRDel.Click | SCM0006_Mail_Setup.cs:1530 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4bb71355 | this.btnRDel.Click | SCM0006_Mail_Setup.cs:1531 | if (siSelReceiver.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72bbe701 | this.btnRDel.Click | SCM0006_Mail_Setup.cs:1533 |  | DATA_OP | siSelReceiver.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-69b8ff20 | this.btnRDel.Click | SCM0006_Mail_Setup.cs:1542 | if (dtAllReceiver.Rows.Count > 0) ▸ foreach (DataRow dr in dtAllReceiver.Rows) | DATA_OP | dt.ImportRow | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fe937d5 | this.btnRDel.Click | SCM0006_Mail_Setup.cs:1547 | if (dtAllReceiver.Rows.Count > 0) | STATE_RESET | dtAllReceiver.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## SCM0006_Mail_Setup.CboModule_SelectedIndexChanged

진입점: cboModule.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97691a8d | cboModule.SelectedIndexChanged | SCM0006_Mail_Setup.cs:1638 |  | LIST_REBIND | cboSubModule.DataBind | (Data.Type.SubModule, true, CConstVariable.SMS_MAIL_SEND_SYSTEM, cboModule.SelectedValue.T… ⇒ biz:CommonData.CommonDataList [code=SubModule] | 목록 컨트롤 재구성 |  |  |  |

## SCM0006_Mail_Setup.ChkCategoryValidation

진입점: SaveButton [if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f710c04 | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0006_Mail_Setup.cs:1428 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (!string.IsNullOrEmpty(strMain)) ▸ if (strMain == "MONTH" \|\| strMain == "… | MESSAGE | MessageHelper.GMessageBox | ("MSG00122", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-90734152 | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0006_Mail_Setup.cs:1440 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (!string.IsNullOrEmpty(strMain)) ▸ else of (strMain == "MONTH" \|\| strMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00123", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fccf6ff | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0006_Mail_Setup.cs:1449 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ else of (!string.IsNullOrEmpty(strMain)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00124", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36ef68ef | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0006_Mail_Setup.cs:1486 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (cntDuplicate > 1) | CALL_EXT | siCategory.GetColumnText | (0, siCategory.GetColumnIndex(DefColumns.CATEGORY_DESC)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a5c5336 | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0006_Mail_Setup.cs:1489 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (cntDuplicate > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a520ee4f | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0006_Mail_Setup.cs:1504 |  | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |

## SCM0006_Mail_Setup.ChkMsgValidation

진입점: SaveButton [if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c3dbbc2 | SaveButton [if (siMessage != null && siMessage.IsLock(siMess… | SCM0006_Mail_Setup.cs:1257 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-854f7004 | SaveButton [if (siMessage != null && siMessage.IsLock(siMess… | SCM0006_Mail_Setup.cs:1258 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c38be1f1 | SaveButton [if (siMessage != null && siMessage.IsLock(siMess… | SCM0006_Mail_Setup.cs:1297 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (cntDuplicate > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dcd7ed89 | SaveButton [if (siMessage != null && siMessage.IsLock(siMess… | SCM0006_Mail_Setup.cs:1311 |  | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |

## SCM0006_Mail_Setup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b68a3636 | this.Load | SCM0006_Mail_Setup.cs:189 |  | GRID_INIT | this.AddSheet | (Category, SpdSheet.siCategory, SpdSheet.siCategory, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ddc32af2 | this.Load | SCM0006_Mail_Setup.cs:190 |  | FLAG | siCategory | GetSheetInfo(Category.Name, Category.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d011821 | this.Load | SCM0006_Mail_Setup.cs:192 |  | GRID_INIT | this.AddSheet | (Message, SpdSheet.siMessage, SpdSheet.siMessage, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-97eef842 | this.Load | SCM0006_Mail_Setup.cs:193 |  | FLAG | siMessage | GetSheetInfo(Message.Name, Message.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c371dba0 | this.Load | SCM0006_Mail_Setup.cs:195 |  | GRID_INIT | this.AddSheet | (All_Receiver, SpdSheet.siAllReceiver, SpdSheet.siAllReceiver, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-09fbe70e | this.Load | SCM0006_Mail_Setup.cs:196 |  | FLAG | siAllReceiver | GetSheetInfo(All_Receiver.Name, All_Receiver.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4a87143d | this.Load | SCM0006_Mail_Setup.cs:198 |  | GRID_INIT | this.AddSheet | (Sel_Receiver, SpdSheet.siSelReceiver, SpdSheet.siSelReceiver, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-83eb2dc2 | this.Load | SCM0006_Mail_Setup.cs:199 |  | FLAG | siSelReceiver | GetSheetInfo(Sel_Receiver.Name, Sel_Receiver.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1618ebc | this.Load | SCM0006_Mail_Setup.cs:201 |  | GRID_INIT | siCategory.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0006_Mail_Setup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c250a800 | this.Load | SCM0006_Mail_Setup.cs:166 |  | VALUE_SET | lcDepartment.Text | MessageHelper.GetTerm(lcDepartment.Text) | 컨트롤 값 설정 |  |  |  |
| AC-a41ca2f3 | this.Load | SCM0006_Mail_Setup.cs:167 |  | VALUE_SET | lcUserID.Text | MessageHelper.GetTerm(lcUserID.Text) | 컨트롤 값 설정 |  |  |  |

## SCM0006_Mail_Setup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1eeeb94 | DeleteButton | SCM0006_Mail_Setup.cs:313 | if (fps != null) ▸ if (fps.Name == SpdSheet.siCategory) | DATA_OP | siCategory.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c030518f | DeleteButton | SCM0006_Mail_Setup.cs:316 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | siMessage.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3fbfdcd2 | DeleteButton | SCM0006_Mail_Setup.cs:318 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ else of (fps.Name == SpdSheet.siMessage) ▸ if (fps.Name == SpdSheet.siSelRece… | DATA_OP | siSelReceiver.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCM0006_Mail_Setup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b843a4d | Dispose | SCM0006_Mail_Setup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0006_Mail_Setup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc4e532f | EditButton | SCM0006_Mail_Setup.cs:328 | if (fps != null) ▸ if (fps.Name == SpdSheet.siCategory) | GRID_LOCK | siCategory.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-3077d6d1 | EditButton | SCM0006_Mail_Setup.cs:329 | if (fps != null) ▸ if (fps.Name == SpdSheet.siCategory) | GRID_LOCK | siCategory.LockColumn | (siCategory.GetColumnIndex(DefColumns.MODULE_CODE), siCategory.GetColumnIndex(DefColumns.S… | 그리드 편집 잠금/해제 |  |  |  |
| AC-785431c3 | EditButton | SCM0006_Mail_Setup.cs:333 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_LOCK | siMessage.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c72e7c4e | EditButton | SCM0006_Mail_Setup.cs:334 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_LOCK | siMessage.LockColumn | (siMessage.GetColumnIndex(DefColumns.CATEGORY_ID), siMessage.GetColumnIndex(DefColumns.LAN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-411824bf | EditButton | SCM0006_Mail_Setup.cs:338 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ else of (fps.Name == SpdSheet.siMessage) ▸ if (fps.Name == SpdSheet.siSelRece… | GRID_LOCK | siSelReceiver.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-9f6aadba | EditButton | SCM0006_Mail_Setup.cs:339 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ else of (fps.Name == SpdSheet.siMessage) ▸ if (fps.Name == SpdSheet.siSelRece… | GRID_LOCK | siSelReceiver.LockColumn | (siSelReceiver.GetColumnIndex(DefColumns.CATEGORY_ID), siSelReceiver.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0006_Mail_Setup.FindData_AllReceiver

진입점: FindButton [if (fps != null && fps.Name == SpdSheet.siAllReceiver)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e364e7bc | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:404 | if (deptTxt.ToString()=="" && useridTxt.ToString() == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00083", new object[] { lcDepartment.Text+","+ lcUserID.Text }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5548d16f | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:405 | if (deptTxt.ToString()=="" && useridTxt.ToString() == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13733029 | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:413 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e08f0f2 | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:417 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_GET_USERINFO_LIST") ⇒ SCM.SCM0006_GET_USERINFO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-9e2677b2 | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:418 | lambda | DATA_OP | request.Parameters["p_user"] | this.txtUser.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d17714ff | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:419 | lambda | DATA_OP | request.Parameters["p_dept"] | this.txtDept.Text | 행/컬럼 값 대입 |  |  |  |
| AC-eb0a1d39 | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:420 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e5fbb417 | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:422 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d7337135 | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:427 |  | GRID_BIND | siAllReceiver.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6274ff7d | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:428 |  | GRID_LOCK | siAllReceiver.LockColumn | (0, siAllReceiver.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a8c3ea37 | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:431 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f3408046 | FindButton [if (fps != null && fps.Name == SpdSheet.siAllRec… | SCM0006_Mail_Setup.cs:434 |  | GRID_INIT | siAllReceiver.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0006_Mail_Setup.FindData_Main

진입점: FindButton [else of (fps != null && fps.Name == SpdSheet.siAllReceiver)] / SaveButton [if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd9d2410 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:358 |  | CALL_EXT | CString.GetComboBoxValue | (cboModule.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-473b0e1a | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:359 |  | CALL_EXT | CString.GetComboBoxValue | (cboSubModule.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f9b5ab3f | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:360 |  | CALL_EXT | CString.GetComboBoxValue | (cboActive.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a8042fd | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:364 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b3c311f1 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:368 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_GET_RECIPIENT_MASTER") ⇒ SCM.SCM0006_GET_RECIPIENT_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-dc9ebfc4 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:369 | lambda | DATA_OP | request.Parameters["p_use_type"] | UseTypeCode | 행/컬럼 값 대입 |  |  |  |
| AC-c9a89cac | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:370 | lambda | DATA_OP | request.Parameters["p_module"] | Module | 행/컬럼 값 대입 |  |  |  |
| AC-db900d22 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:371 | lambda | DATA_OP | request.Parameters["p_submodule"] | SubMod | 행/컬럼 값 대입 |  |  |  |
| AC-c9a3e376 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:372 | lambda | DATA_OP | request.Parameters["p_active"] | Active | 행/컬럼 값 대입 |  |  |  |
| AC-357b8c38 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:374 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4decd230 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:376 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-dbf95811 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:380 |  | GRID_BIND | siCategory.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-de705057 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:381 |  | GRID_LOCK | siCategory.LockColumn | (0, siCategory.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f63f2962 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:384 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f081df0a | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0006_Mail_Setup.cs:387 |  | GRID_INIT | siCategory.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0006_Mail_Setup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5482ac7 | this.Load | SCM0006_Mail_Setup.cs:154 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0006_Mail_Setup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd3c4b21 | this.Load | SCM0006_Mail_Setup.cs:172 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-02490169 | this.Load | SCM0006_Mail_Setup.cs:178 |  | LIST_REBIND | cboModule.DataBind | (Data.Type.Module, true, CConstVariable.SMS_MAIL_SEND_SYSTEM) ⇒ biz:CommonData.CommonDataList [code=Module] | 목록 컨트롤 재구성 |  |  |  |
| AC-8c12cec3 | this.Load | SCM0006_Mail_Setup.cs:179 |  | LIST_REBIND | cboSubModule.DataBind | (Data.Type.SubModule, true, CConstVariable.SMS_MAIL_SEND_SYSTEM) ⇒ biz:CommonData.CommonDataList [code=SubModule] | 목록 컨트롤 재구성 |  |  |  |
| AC-cd320663 | this.Load | SCM0006_Mail_Setup.cs:180 |  | LIST_REBIND | cboActive.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-15e8dd7b | this.Load | SCM0006_Mail_Setup.cs:182 |  | VALUE_SET | cboActive.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |

## SCM0006_Mail_Setup.InitSpread

진입점: this.Load / this.Category.CellDoubleClick [else of (siCategory.IsLock(siCategory.SheetName) == false)] / FindButton [if (fps != null && fps.Name == SpdSheet.siAllReceiver)] / SaveButton [if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca1c82bc | this.Load 외 3 | SCM0006_Mail_Setup.cs:211 |  | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a123f2f7 | this.Load 외 3 | SCM0006_Mail_Setup.cs:215 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c75c3a02 | this.Load 외 3 | SCM0006_Mail_Setup.cs:216 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("USE_TYPE_CODE", DefColumns.USE_TYPE_CODE, FPMerge.None, 100, false, dtModule, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d69353d2 | this.Load 외 3 | SCM0006_Mail_Setup.cs:217 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Module*", DefColumns.MODULE_CODE, FPMerge.Restricted, 100, true, dtModule, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94daa90e | this.Load 외 3 | SCM0006_Mail_Setup.cs:218 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub Module*", DefColumns.SUB_MODULE_CODE, FPMerge.Restricted, 100, true, dtSubModule, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36e45f1b | this.Load 외 3 | SCM0006_Mail_Setup.cs:219 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b677514 | this.Load 외 3 | SCM0006_Mail_Setup.cs:220 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddTextColumn | ("Category*", DefColumns.CATEGORY_DESC, FPMerge.Restricted, 300, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e34a2868 | this.Load 외 3 | SCM0006_Mail_Setup.cs:221 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.Restricted, 100, true, dtYesOrNo, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b8271587 | this.Load 외 3 | SCM0006_Mail_Setup.cs:223 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Main*", DefColumns.CYCLE_CLASS_CODE, FPMerge.Restricted, 100, true, dtCycle, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36682f60 | this.Load 외 3 | SCM0006_Mail_Setup.cs:224 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub1", DefColumns.DETAIL_CLASS_CODE, FPMerge.Restricted, 100, true, dtCycleSub1, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0dad45f6 | this.Load 외 3 | SCM0006_Mail_Setup.cs:225 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub2", DefColumns.SEND_TIME_TEXT, FPMerge.Restricted, 100, true, dtCycleSub2, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2361a02e | this.Load 외 3 | SCM0006_Mail_Setup.cs:226 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub3", DefColumns.SEND_MIN_TIME_TEXT, FPMerge.Restricted, 100, true, dtCycleSub3, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fafb4c89 | this.Load 외 3 | SCM0006_Mail_Setup.cs:228 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddButtonColumn | ("SQL VIEW", DefColumns.VIEW, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6505735a | this.Load 외 3 | SCM0006_Mail_Setup.cs:232 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.USE_TYPE_CODE), 2, 1, 25, "USE_TYPE_CODE", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aabaab44 | this.Load 외 3 | SCM0006_Mail_Setup.cs:233 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.MODULE_CODE), 2, 1, 25, "Module*", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4ad88db | this.Load 외 3 | SCM0006_Mail_Setup.cs:234 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.SUB_MODULE_CODE), 2, 1, 25, "Sub Module*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35cc1e24 | this.Load 외 3 | SCM0006_Mail_Setup.cs:235 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.CATEGORY_DESC), 2, 1, 25, "Category*", FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4bd8917e | this.Load 외 3 | SCM0006_Mail_Setup.cs:236 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.ACTIVE_FLAG), 2, 1, 25, "Active", FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e375e61 | this.Load 외 3 | SCM0006_Mail_Setup.cs:238 | if (spreadInfo.SheetName == SpdSheet.siCategory) | CALL_EXT | clsCtrl.HeaderSpan | (spreadInfo, 0, DefColumns.CYCLE_CLASS_CODE, 1, 4, "Period") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6dcc3f5 | this.Load 외 3 | SCM0006_Mail_Setup.cs:240 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.VIEW), 2, 1, 25, "SQL VIEW", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca082533 | this.Load 외 3 | SCM0006_Mail_Setup.cs:242 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-64936b48 | this.Load 외 3 | SCM0006_Mail_Setup.cs:247 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-836d38ce | this.Load 외 3 | SCM0006_Mail_Setup.cs:248 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("USE_TYPE_CODE", DefColumns.USE_TYPE_CODE, FPMerge.Restricted, 100, false, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-519cc808 | this.Load 외 3 | SCM0006_Mail_Setup.cs:249 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-caaf809e | this.Load 외 3 | SCM0006_Mail_Setup.cs:250 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_DESC, FPMerge.Always, 300, true, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbc5945b | this.Load 외 3 | SCM0006_Mail_Setup.cs:251 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddComboColumn | ("Language*", DefColumns.LANGUAGE_CODE, FPMerge.None, 100, true, dtLang, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9892ea5 | this.Load 외 3 | SCM0006_Mail_Setup.cs:252 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Mail Title*", DefColumns.MAIL_TITLE, FPMerge.None, 200, true, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4937691f | this.Load 외 3 | SCM0006_Mail_Setup.cs:253 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Mail Content*", DefColumns.MESSAGE_CONTENT, FPMerge.None, 400, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a1b82d7 | this.Load 외 3 | SCM0006_Mail_Setup.cs:254 | if (spreadInfo.SheetName == SpdSheet.siMessage) | CALL_EXT | spreadInfo.AutoRowHeight | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ac31803 | this.Load 외 3 | SCM0006_Mail_Setup.cs:256 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-68814995 | this.Load 외 3 | SCM0006_Mail_Setup.cs:261 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1f2167dd | this.Load 외 3 | SCM0006_Mail_Setup.cs:262 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("UserID", DefColumns.USER_ID, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27fda06f | this.Load 외 3 | SCM0006_Mail_Setup.cs:263 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Name", DefColumns.USER_NAME, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c5bf5323 | this.Load 외 3 | SCM0006_Mail_Setup.cs:264 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Department", DefColumns.DEFT_NAME, FPMerge.Restricted, 150, true, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73113e7f | this.Load 외 3 | SCM0006_Mail_Setup.cs:265 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Email", DefColumns.EMAIL_ADDR, FPMerge.Restricted, 150, false, FPHAlign.Left, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7af13227 | this.Load 외 3 | SCM0006_Mail_Setup.cs:266 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("TEL", DefColumns.MOBILE_PHONE, FPMerge.Restricted, 150, false, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1616ba19 | this.Load 외 3 | SCM0006_Mail_Setup.cs:267 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.AddComboColumn | ("Language", DefColumns.LANGUAGE_CODE, FPMerge.Restricted, 100, false, dtLang, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99411702 | this.Load 외 3 | SCM0006_Mail_Setup.cs:269 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b8efd94d | this.Load 외 3 | SCM0006_Mail_Setup.cs:274 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d74ec034 | this.Load 외 3 | SCM0006_Mail_Setup.cs:275 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("USE_TYPE_CODE", DefColumns.USE_TYPE_CODE, FPMerge.Restricted, 100, false, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-508f4008 | this.Load 외 3 | SCM0006_Mail_Setup.cs:276 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_ID, FPMerge.Always, 200, false, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5b7b757 | this.Load 외 3 | SCM0006_Mail_Setup.cs:277 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_DESC, FPMerge.Always, 200, true, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ed4ceb5 | this.Load 외 3 | SCM0006_Mail_Setup.cs:278 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("UserID", DefColumns.USER_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-824fa323 | this.Load 외 3 | SCM0006_Mail_Setup.cs:279 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Name", DefColumns.USER_NAME, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6be46105 | this.Load 외 3 | SCM0006_Mail_Setup.cs:280 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Department", DefColumns.DEFT_NAME, FPMerge.Restricted, 150, true, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04f1981f | this.Load 외 3 | SCM0006_Mail_Setup.cs:281 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Email", DefColumns.EMAIL_ADDR, FPMerge.Restricted, 150, false, FPHAlign.Left, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8edf8274 | this.Load 외 3 | SCM0006_Mail_Setup.cs:282 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("TEL", DefColumns.MOBILE_PHONE, FPMerge.Restricted, 150, false, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b55a1eb | this.Load 외 3 | SCM0006_Mail_Setup.cs:283 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddComboColumn | ("Language", DefColumns.LANGUAGE_CODE, FPMerge.Restricted, 100, false, dtLang, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61a36b6e | this.Load 외 3 | SCM0006_Mail_Setup.cs:285 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0006_Mail_Setup.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44b8cc04 | InsertButton | SCM0006_Mail_Setup.cs:727 | if (fps.Name == SpdSheet.siCategory) | DATA_OP | siCategory.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e22fcec6 | InsertButton | SCM0006_Mail_Setup.cs:730 | if (fps.Name == SpdSheet.siCategory) | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-74a62638 | InsertButton | SCM0006_Mail_Setup.cs:732 | if (fps.Name == SpdSheet.siCategory) | GRID_SET | siCategory.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-f5e9dd98 | InsertButton | SCM0006_Mail_Setup.cs:733 | if (fps.Name == SpdSheet.siCategory) | GRID_LOCK | siCategory.LockRange | (insCell, siCategory.GetColumnIndex(DefColumns.VIEW), siCategory.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-84dd81c3 | InsertButton | SCM0006_Mail_Setup.cs:737 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | siMessage.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5088ccb4 | InsertButton | SCM0006_Mail_Setup.cs:740 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | defaultData.Add | (DefColumns.USE_TYPE_CODE, UseTypeCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-427217a9 | InsertButton | SCM0006_Mail_Setup.cs:741 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | defaultData.Add | (DefColumns.CATEGORY_ID, strCategory) | 데이터 객체 조작/조회 |  |  |  |
| AC-da7c8667 | InsertButton | SCM0006_Mail_Setup.cs:742 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | defaultData.Add | (DefColumns.CATEGORY_DESC, strCategoryDESC) | 데이터 객체 조작/조회 |  |  |  |
| AC-aec60b54 | InsertButton | SCM0006_Mail_Setup.cs:744 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_SET | siMessage.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-45c42225 | InsertButton | SCM0006_Mail_Setup.cs:745 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_LOCK | siMessage.LockRange | (insCell, siMessage.GetColumnIndex(DefColumns.CATEGORY_DESC), siMessage.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0006_Mail_Setup.Message_EditChange

진입점: Message.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d67c7036 | Message.EditChange | SCM0006_Mail_Setup.cs:1200 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5aff6845 | Message.EditChange | SCM0006_Mail_Setup.cs:1206 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) | CALL_EXT | Encoding.Default.GetByteCount | (sContent) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb827869 | Message.EditChange | SCM0006_Mail_Setup.cs:1209 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (Encod… | MESSAGE | MessageHelper.GMessageBox | ("MSG00165", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e6cfdb0 | Message.EditChange | SCM0006_Mail_Setup.cs:1210 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (Encod… | GRID_SET | siMessage.SetValue | (e.Row, e.Column, sContentTemp) | 그리드 값 설정 |  |  |  |
| AC-a6af68b8 | Message.EditChange | SCM0006_Mail_Setup.cs:1211 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (Encod… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0251842 | Message.EditChange | SCM0006_Mail_Setup.cs:1214 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ else of (… | FLAG | sContentTemp | sContent | 화면 필드/플래그 변경 |  |  |  |

## SCM0006_Mail_Setup.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb371489 | SaveButton | SCM0006_Mail_Setup.cs:464 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) | VALIDATE | DataUtil.checkRequiredOfSpread | (siCategory) | 프레임워크 검증 |  |  |  |
| AC-ea525a3b | SaveButton | SCM0006_Mail_Setup.cs:464 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (!DataUt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ccb320c2 | SaveButton | SCM0006_Mail_Setup.cs:466 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (!ChkCat… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3da740dc | SaveButton | SCM0006_Mail_Setup.cs:503 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | MESSAGE | MessageHelper.GMessageBox | ("MSG00121") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-77970a38 | SaveButton | SCM0006_Mail_Setup.cs:503 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c5037b9 | SaveButton | SCM0006_Mail_Setup.cs:505 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_SAVE_RECIPIENT_MASTER") ⇒ SCM.SCM0006_SAVE_RECIPIENT_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-b0211860 | SaveButton | SCM0006_Mail_Setup.cs:510 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1bc49cf2 | SaveButton | SCM0006_Mail_Setup.cs:514 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9fff53b2 | SaveButton | SCM0006_Mail_Setup.cs:515 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_use_type"] | p_use_type | 행/컬럼 값 대입 |  |  |  |
| AC-b2418595 | SaveButton | SCM0006_Mail_Setup.cs:516 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_module"] | p_module | 행/컬럼 값 대입 |  |  |  |
| AC-8467ee72 | SaveButton | SCM0006_Mail_Setup.cs:517 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_submodule"] | p_submodule | 행/컬럼 값 대입 |  |  |  |
| AC-8ed84999 | SaveButton | SCM0006_Mail_Setup.cs:518 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-5631c7f3 | SaveButton | SCM0006_Mail_Setup.cs:519 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_category_desc"] | p_category_desc | 행/컬럼 값 대입 |  |  |  |
| AC-ab6d1bf1 | SaveButton | SCM0006_Mail_Setup.cs:520 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_cycle_class_code"] | p_cycle_class_code | 행/컬럼 값 대입 |  |  |  |
| AC-b510ae63 | SaveButton | SCM0006_Mail_Setup.cs:521 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_detail_class_code"] | p_detail_class_code | 행/컬럼 값 대입 |  |  |  |
| AC-41a71001 | SaveButton | SCM0006_Mail_Setup.cs:522 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_send_time_text"] | p_send_time_text | 행/컬럼 값 대입 |  |  |  |
| AC-782063cf | SaveButton | SCM0006_Mail_Setup.cs:523 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_send_min_time_text"] | p_send_min_time_text | 행/컬럼 값 대입 |  |  |  |
| AC-57b85e7c | SaveButton | SCM0006_Mail_Setup.cs:524 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_active"] | p_active | 행/컬럼 값 대입 |  |  |  |
| AC-cb2131ef | SaveButton | SCM0006_Mail_Setup.cs:525 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-5352be90 | SaveButton | SCM0006_Mail_Setup.cs:526 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-9eedcf03 | SaveButton | SCM0006_Mail_Setup.cs:527 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-f010012e | SaveButton | SCM0006_Mail_Setup.cs:529 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f1579b1e | SaveButton | SCM0006_Mail_Setup.cs:529 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-b684b51d | SaveButton | SCM0006_Mail_Setup.cs:538 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6623cbfe | SaveButton | SCM0006_Mail_Setup.cs:547 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25d6dbd2 | SaveButton | SCM0006_Mail_Setup.cs:571 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMessage) | 프레임워크 검증 |  |  |  |
| AC-b723dec7 | SaveButton | SCM0006_Mail_Setup.cs:571 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (!DataUtil.ch… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afc92871 | SaveButton | SCM0006_Mail_Setup.cs:574 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (!ChkMsgValid… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ae2cfc6 | SaveButton | SCM0006_Mail_Setup.cs:600 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_SAVE_RECIPIENT_MESSAGE") ⇒ SCM.SCM0006_SAVE_RECIPIENT_MESSAGE | 엔드포인트 요청 생성 |  |  |  |
| AC-62fd10ab | SaveButton | SCM0006_Mail_Setup.cs:605 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8f26426c | SaveButton | SCM0006_Mail_Setup.cs:609 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6e576fe6 | SaveButton | SCM0006_Mail_Setup.cs:610 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_use_type"] | p_use_type | 행/컬럼 값 대입 |  |  |  |
| AC-1ca7e97b | SaveButton | SCM0006_Mail_Setup.cs:611 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-3c0f4ba1 | SaveButton | SCM0006_Mail_Setup.cs:612 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-5544c6a7 | SaveButton | SCM0006_Mail_Setup.cs:613 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-1ce3c769 | SaveButton | SCM0006_Mail_Setup.cs:614 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_content"] | p_content | 행/컬럼 값 대입 |  |  |  |
| AC-2fb4c354 | SaveButton | SCM0006_Mail_Setup.cs:615 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-708d8b98 | SaveButton | SCM0006_Mail_Setup.cs:616 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-81ddb438 | SaveButton | SCM0006_Mail_Setup.cs:617 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-02d0a755 | SaveButton | SCM0006_Mail_Setup.cs:619 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-652959c2 | SaveButton | SCM0006_Mail_Setup.cs:619 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-58b807db | SaveButton | SCM0006_Mail_Setup.cs:628 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cc5f7ecf | SaveButton | SCM0006_Mail_Setup.cs:637 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0140569a | SaveButton | SCM0006_Mail_Setup.cs:680 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_SAVE_RECIPIENT_ASSIGN") ⇒ SCM.SCM0006_SAVE_RECIPIENT_ASSIGN | 엔드포인트 요청 생성 |  |  |  |
| AC-844dd171 | SaveButton | SCM0006_Mail_Setup.cs:685 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b2f4370e | SaveButton | SCM0006_Mail_Setup.cs:689 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0db32e4e | SaveButton | SCM0006_Mail_Setup.cs:690 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_use_type"] | p_use_type | 행/컬럼 값 대입 |  |  |  |
| AC-1447cdb7 | SaveButton | SCM0006_Mail_Setup.cs:691 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-2dc8bf06 | SaveButton | SCM0006_Mail_Setup.cs:692 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8cd03cac | SaveButton | SCM0006_Mail_Setup.cs:693 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-62e5ffe0 | SaveButton | SCM0006_Mail_Setup.cs:694 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-66fd1634 | SaveButton | SCM0006_Mail_Setup.cs:695 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-b0e08ff0 | SaveButton | SCM0006_Mail_Setup.cs:697 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b235ca26 | SaveButton | SCM0006_Mail_Setup.cs:697 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-9a939745 | SaveButton | SCM0006_Mail_Setup.cs:706 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cd2cfd85 | SaveButton | SCM0006_Mail_Setup.cs:715 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCM0006_Mail_Setup.SetSelData

진입점: this.btnRAdd.Click / All_Receiver.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3268e276 | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1559 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (TartgetSp.IsLock… | GRID_LOCK | TartgetSp.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f0b2e19e | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1560 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (TartgetSp.IsLock… | GRID_LOCK | TartgetSp.LockColumn | (TartgetSp.GetColumnIndex(DefColumns.USE_TYPE_CODE), TartgetSp.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bda8a82d | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1577 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | DATA_OP | (TartgetSp.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3fcf1949 | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1587 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3bbc950e | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1588 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e306115 | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1592 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | DATA_OP | TartgetSp.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7128d31d | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1594 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.CATEGORY_… | strRCategory | 그리드 속성/값 설정 |  |  |  |
| AC-c638cae4 | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1595 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.CATEGORY_… | strRCategoryDESC | 그리드 속성/값 설정 |  |  |  |
| AC-1cf4a41a | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1596 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.USE_TYPE_… | UseTypeCode | 그리드 속성/값 설정 |  |  |  |
| AC-8c274dbc | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1599 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.USER_ID)]… | (objUserID != null) ? objUserID.ToString() : string.Empty | 그리드 속성/값 설정 |  |  |  |
| AC-686103f0 | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1602 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.USER_NAME… | (objUserNM != null) ? objUserNM.ToString() : string.Empty | 그리드 속성/값 설정 |  |  |  |
| AC-78b7b22f | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1605 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.DEFT_NAME… | (objOrgan != null) ? objOrgan.ToString() : string.Empty | 그리드 속성/값 설정 |  |  |  |
| AC-0e6d373d | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1608 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.EMAIL_ADD… | (objEmail != null) ? objEmail.ToString() : string.Empty | 그리드 속성/값 설정 |  |  |  |
| AC-acfe5d3c | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1611 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.MOBILE_PH… | (objTel != null) ? objTel.ToString() : string.Empty | 그리드 속성/값 설정 |  |  |  |
| AC-538fa6bb | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1614 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.LANGUAGE_… | (objLang != null) ? objLang.ToString() : string.Empty | 그리드 속성/값 설정 |  |  |  |
| AC-f854049e | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1616 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_LOCK | TartgetSp.LockRange | (range, TartgetSp.GetColumnIndex(DefColumns.USE_TYPE_CODE), TartgetSp.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7cad3eee | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1618 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | DATA_OP | siAllreciverDellist.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-69bdd289 | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1624 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ i… | CALL_EXT | siAllreciverDellist.OrderByDescending | (c => c.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0274fea2 | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1628 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ i… | DATA_OP | dtAllReceiver.ImportRow | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-22715b1d | this.btnRAdd.Click 외 1 | SCM0006_Mail_Setup.cs:1629 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ i… | DATA_OP | SourceSp.ActiveSheet.Rows.Remove | (iRow,1) | 데이터 객체 조작/조회 |  |  |  |

## SCM0006_Mail_Setup.ShowMessage

진입점: this.Category.CellDoubleClick [else of (siCategory.IsLock(siCategory.SheetName) == false)] / SaveButton [if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74afba4f | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1327 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-44e16442 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1331 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_GET_RECIPIENT_MESSAGE") ⇒ SCM.SCM0006_GET_RECIPIENT_MESSAGE | 엔드포인트 요청 생성 |  |  |  |
| AC-1e9e660a | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1332 | lambda | DATA_OP | request.Parameters["p_use_type"] | UseTypeCode | 행/컬럼 값 대입 |  |  |  |
| AC-f8c7ecf6 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1333 | lambda | DATA_OP | request.Parameters["p_categoryID"] | strCategory | 행/컬럼 값 대입 |  |  |  |
| AC-20ea51fe | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1335 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d73ccbc9 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1337 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5d734ba1 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1341 |  | GRID_BIND | siMessage.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-380fa986 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1342 |  | GRID_LOCK | siMessage.LockColumn | (0, siMessage.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4ded0d94 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1345 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-40b1d52a | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1348 |  | GRID_INIT | siMessage.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0006_Mail_Setup.ShowReceiver

진입점: this.Category.CellDoubleClick [else of (siCategory.IsLock(siCategory.SheetName) == false)] / SaveButton [if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76743972 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1366 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ab1c02f1 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1370 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_GET_RECIPIENT_ASSIGN") ⇒ SCM.SCM0006_GET_RECIPIENT_ASSIGN | 엔드포인트 요청 생성 |  |  |  |
| AC-43ced623 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1371 | lambda | DATA_OP | request.Parameters["p_use_type"] | UseTypeCode | 행/컬럼 값 대입 |  |  |  |
| AC-6714bbc5 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1372 | lambda | DATA_OP | request.Parameters["p_categoryID"] | strCategory | 행/컬럼 값 대입 |  |  |  |
| AC-beac2b3b | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1374 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-87d23cdd | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1376 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-35d8d853 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1380 |  | GRID_BIND | siSelReceiver.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6c2a8183 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1381 |  | GRID_LOCK | siSelReceiver.LockColumn | (0, siSelReceiver.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ebf74e9 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1384 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3e5d0cf9 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0006_Mail_Setup.cs:1387 |  | GRID_INIT | siSelReceiver.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0006_Mail_Setup.SprCategory_CellClick

진입점: this.Category.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-710e20e6 | this.Category.CellClick | SCM0006_Mail_Setup.cs:756 | if (this.siCategory.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e07a6143 | this.Category.CellClick | SCM0006_Mail_Setup.cs:763 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | POPUP | new POPUP.SCM0006_PopSQL | () | 팝업/폼 생성 |  |  |  |
| AC-b6567ee1 | this.Category.CellClick | SCM0006_Mail_Setup.cs:764 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.UseTypeCode | siCategory.GetValue(e.Row, siCategory.GetColumnIndex(DefColumns.USE_TYPE_CODE)).ToString() | 속성 UseTypeCode 설정 |  |  |  |
| AC-26b23248 | this.Category.CellClick | SCM0006_Mail_Setup.cs:765 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.ModuleCode | siCategory.GetValue(e.Row, siCategory.GetColumnIndex(DefColumns.MODULE_CODE)).ToString() | 속성 ModuleCode 설정 |  |  |  |
| AC-ae946c68 | this.Category.CellClick | SCM0006_Mail_Setup.cs:766 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.SubModuleCode | siCategory.GetValue(e.Row, siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)).ToString… | 속성 SubModuleCode 설정 |  |  |  |
| AC-6939da65 | this.Category.CellClick | SCM0006_Mail_Setup.cs:767 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.CategoryID | strCategoryID | 속성 CategoryID 설정 |  |  |  |
| AC-19ec954c | this.Category.CellClick | SCM0006_Mail_Setup.cs:768 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.CategoryDESC | siCategory.GetValue(e.Row, siCategory.GetColumnIndex(DefColumns.CATEGORY_DESC)).ToString() | 속성 CategoryDESC 설정 |  |  |  |
| AC-8a603d82 | this.Category.CellClick | SCM0006_Mail_Setup.cs:769 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.LastUpdateBy | UserInfo.UserId | 속성 LastUpdateBy 설정 |  |  |  |
| AC-c12a55e4 | this.Category.CellClick | SCM0006_Mail_Setup.cs:771 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | POPUP | popSQL.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |
| AC-884473d0 | this.Category.CellClick | SCM0006_Mail_Setup.cs:781 | if (siCategory.IsLock(siCategory.SheetName) == false) | CALL_EXT | siCategory.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e077956 | this.Category.CellClick | SCM0006_Mail_Setup.cs:783 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction) == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40a327b9 | this.Category.CellClick | SCM0006_Mail_Setup.cs:786 | if (siCategory.IsLock(siCategory.SheetName) == false) | CALL_EXT | siCategory.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-85298dcf | this.Category.CellClick | SCM0006_Mail_Setup.cs:802 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00111", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-76fe0bcc | this.Category.CellClick | SCM0006_Mail_Setup.cs:803 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-6a1350bc | this.Category.CellClick | SCM0006_Mail_Setup.cs:808 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | DATA_OP | dtSubModule.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-587ef1b4 | this.Category.CellClick | SCM0006_Mail_Setup.cs:810 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | UI_PROP | dvNewSubModule.RowFilter | string.Format("SYSTEM_CODE = '{0}'", strModule) | 속성 RowFilter 설정 |  |  |  |
| AC-8594cb42 | this.Category.CellClick | SCM0006_Mail_Setup.cs:812 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | LIST_REBIND | siCategory.LoadCombo | (e.Row, e.Column, dvNewSubModule.ToTable(), strSubModule, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-e35a97f0 | this.Category.CellClick | SCM0006_Mail_Setup.cs:812 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | DATA_OP | dvNewSubModule.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f019b729 | this.Category.CellClick | SCM0006_Mail_Setup.cs:827 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullO… | MESSAGE | MessageHelper.GMessageBox | ("MSG00112", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-16db6996 | this.Category.CellClick | SCM0006_Mail_Setup.cs:828 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullO… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-b92580b5 | this.Category.CellClick | SCM0006_Mail_Setup.cs:833 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | DATA_OP | dtCycleSub1.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-59c01c05 | this.Category.CellClick | SCM0006_Mail_Setup.cs:835 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | UI_PROP | dvNewSub1.RowFilter | string.Format("CYCLE_CODE = '{0}'", strMain) | 속성 RowFilter 설정 |  |  |  |
| AC-adf8d573 | this.Category.CellClick | SCM0006_Mail_Setup.cs:837 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | LIST_REBIND | siCategory.LoadCombo | (e.Row, e.Column, dvNewSub1.ToTable(), strCurr, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-bd4c6757 | this.Category.CellClick | SCM0006_Mail_Setup.cs:837 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | DATA_OP | dvNewSub1.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4e3252ad | this.Category.CellClick | SCM0006_Mail_Setup.cs:848 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (strMain == "RT") | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-9463afba | this.Category.CellClick | SCM0006_Mail_Setup.cs:849 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (strMain == "RT") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a399a470 | this.Category.CellClick | SCM0006_Mail_Setup.cs:859 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (String.IsNullOrEm… | MESSAGE | MessageHelper.GMessageBox | ("MSG00112", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0a547c4f | this.Category.CellClick | SCM0006_Mail_Setup.cs:860 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (String.IsNullOrEm… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-89d627b1 | this.Category.CellClick | SCM0006_Mail_Setup.cs:865 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNul… | DATA_OP | dtCycleSub2.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-31e04f9e | this.Category.CellClick | SCM0006_Mail_Setup.cs:869 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNul… | UI_PROP | dvNewSub2.RowFilter | string.Format("CYCLE_CODE = '{0}'", "DAY") | 속성 RowFilter 설정 |  |  |  |
| AC-ceff4fc8 | this.Category.CellClick | SCM0006_Mail_Setup.cs:873 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNul… | UI_PROP | dvNewSub2.RowFilter | string.Format("CYCLE_CODE = '{0}'", "HOUR") | 속성 RowFilter 설정 |  |  |  |
| AC-93741eac | this.Category.CellClick | SCM0006_Mail_Setup.cs:876 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNul… | LIST_REBIND | siCategory.LoadCombo | (e.Row, e.Column, dvNewSub2.ToTable(), strCurr, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-3cb1ef6d | this.Category.CellClick | SCM0006_Mail_Setup.cs:876 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNul… | DATA_OP | dvNewSub2.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a386bad2 | this.Category.CellClick | SCM0006_Mail_Setup.cs:889 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_MIN_TIME_TEXT")) ▸ if (strMain == "D… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-f122a3f8 | this.Category.CellClick | SCM0006_Mail_Setup.cs:904 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (String.IsNullOrEmpty(strState) \|\| strState == "M" \|\| strState == "D") ▸ if (… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## SCM0006_Mail_Setup.SprCategory_CellDoubleClick

진입점: this.Category.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0127ab5a | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:946 | if (e.Column != siCategory.GetColumnIndex(DefColumns.CATEGORY_DESC)) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-a15442b1 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:950 | if (this.siCategory.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-555cf515 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:957 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | POPUP | new POPUP.SCM0006_PopSQL | () | 팝업/폼 생성 |  |  |  |
| AC-590bfb76 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:958 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.UseTypeCode | siCategory.GetValue(e.Row, siCategory.GetColumnIndex(DefColumns.USE_TYPE_CODE)).ToString() | 속성 UseTypeCode 설정 |  |  |  |
| AC-7174e6de | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:959 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.ModuleCode | siCategory.GetValue(e.Row, siCategory.GetColumnIndex(DefColumns.MODULE_CODE)).ToString() | 속성 ModuleCode 설정 |  |  |  |
| AC-133faf4a | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:960 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.SubModuleCode | siCategory.GetValue(e.Row, siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)).ToString… | 속성 SubModuleCode 설정 |  |  |  |
| AC-944e73a9 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:961 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.CategoryID | strCategoryID | 속성 CategoryID 설정 |  |  |  |
| AC-3785647c | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:962 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.CategoryDESC | siCategory.GetValue(e.Row, siCategory.GetColumnIndex(DefColumns.CATEGORY_DESC)).ToString() | 속성 CategoryDESC 설정 |  |  |  |
| AC-f753bd2d | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:963 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | UI_PROP | popSQL.LastUpdateBy | UserInfo.UserId | 속성 LastUpdateBy 설정 |  |  |  |
| AC-cb0b2a0c | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:965 | if (!String.IsNullOrEmpty(strCategoryID) && !e.ColumnHeader && e.Column == siCategory.GetColumnIndex(DefColumns.VIEW)) | POPUP | popSQL.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |
| AC-a5d3ca77 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:975 | if (siCategory.IsLock(siCategory.SheetName) == false) | CALL_EXT | siCategory.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c9f4e70a | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:977 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction) == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4fe39dd | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:980 | if (siCategory.IsLock(siCategory.SheetName) == false) | CALL_EXT | siCategory.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0fcfce2 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:996 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00111", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ab9158a | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:997 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-16c293bd | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1002 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | DATA_OP | dtSubModule.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f40dd9cb | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1004 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | UI_PROP | dvNewSubModule.RowFilter | string.Format("SYSTEM_CODE = '{0}'", strModule) | 속성 RowFilter 설정 |  |  |  |
| AC-73a780f8 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1006 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | LIST_REBIND | siCategory.LoadCombo | (e.Row, e.Column, dvNewSubModule.ToTable(), strSubModule, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-d1258288 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1006 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | DATA_OP | dvNewSubModule.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-73c0f203 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1021 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullO… | MESSAGE | MessageHelper.GMessageBox | ("MSG00112", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4d9f3dd2 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1022 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullO… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-e5a4d89e | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1027 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | DATA_OP | dtCycleSub1.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f76e3f5 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1029 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | UI_PROP | dvNewSub1.RowFilter | string.Format("CYCLE_CODE = '{0}'", strMain) | 속성 RowFilter 설정 |  |  |  |
| AC-2a390215 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1031 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | LIST_REBIND | siCategory.LoadCombo | (e.Row, e.Column, dvNewSub1.ToTable(), strCurr, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-99963b6b | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1031 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | DATA_OP | dvNewSub1.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-893eb791 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1042 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (strMain == "RT") | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-4ec3f3d4 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1043 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (strMain == "RT") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6caa6a88 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1053 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (String.IsNullOrEm… | MESSAGE | MessageHelper.GMessageBox | ("MSG00112", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39201b62 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1054 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (String.IsNullOrEm… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-3aa5d930 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1059 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNul… | DATA_OP | dtCycleSub2.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea11556d | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1063 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNul… | UI_PROP | dvNewSub2.RowFilter | string.Format("CYCLE_CODE = '{0}'", "DAY") | 속성 RowFilter 설정 |  |  |  |
| AC-448d3873 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1067 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNul… | UI_PROP | dvNewSub2.RowFilter | string.Format("CYCLE_CODE = '{0}'", "HOUR") | 속성 RowFilter 설정 |  |  |  |
| AC-83b780d1 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1070 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNul… | LIST_REBIND | siCategory.LoadCombo | (e.Row, e.Column, dvNewSub2.ToTable(), strCurr, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-5bf2623b | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1070 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ else of (String.IsNul… | DATA_OP | dvNewSub2.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c3170719 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1083 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_MIN_TIME_TEXT")) ▸ if (strMain == "D… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-ba568062 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1097 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (String.IsNullOrEmpty(strState) \|\| strState == "M" \|\| strState == "D") ▸ if (… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-2a6c60c4 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1111 | else of (siCategory.IsLock(siCategory.SheetName) == false) | FLAG | strCategory | (objCategory == null) ? string.Empty : objCategory.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-83182dbe | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1114 | else of (siCategory.IsLock(siCategory.SheetName) == false) | FLAG | strCategoryDESC | (objCategoryDESC == null) ? string.Empty : objCategoryDESC.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-43d74060 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1117 | else of (siCategory.IsLock(siCategory.SheetName) == false) | FLAG | sContentTemp | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-76cea519 | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1122 | else of (siCategory.IsLock(siCategory.SheetName) == false) | FLAG | strRCategory | (objCategory == null) ? string.Empty : objCategory.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8a096f0e | this.Category.CellDoubleClick | SCM0006_Mail_Setup.cs:1123 | else of (siCategory.IsLock(siCategory.SheetName) == false) | FLAG | strRCategoryDESC | (objCategoryDESC == null) ? string.Empty : objCategoryDESC.ToString() | 화면 필드/플래그 변경 |  |  |  |

## SCM0006_Mail_Setup.SprCategory_ComboSelChange

진입점: this.Category.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-015067b9 | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:917 | if (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siCategory.SetValue | (e.Row, siCategory.GetColumnIndex(DefColumns.DETAIL_CLASS_CODE), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-6c0d7a59 | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:918 | if (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siCategory.SetText | (e.Row, siCategory.GetColumnIndex(DefColumns.DETAIL_CLASS_CODE), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-90362e90 | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:920 | if (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siCategory.SetValue | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-98ec5876 | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:921 | if (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siCategory.SetText | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-5f8f6d28 | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:923 | if (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siCategory.SetValue | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_MIN_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-c80d71d1 | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:924 | if (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siCategory.SetText | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_MIN_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-80c6109b | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:928 | else of (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.DETAIL_C… | GRID_SET | siCategory.SetValue | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-ee000f93 | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:929 | else of (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.DETAIL_C… | GRID_SET | siCategory.SetText | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-ead29a00 | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:931 | else of (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.DETAIL_C… | GRID_SET | siCategory.SetValue | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_MIN_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-d0795d84 | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:932 | else of (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.DETAIL_C… | GRID_SET | siCategory.SetText | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_MIN_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-67c30e9f | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:936 | else of (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) ▸ else of (e.Column == siCategory.GetColumnIndex(DefColumns.DET… | GRID_SET | siCategory.SetValue | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_MIN_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-1d5d764e | this.Category.ComboSelChange | SCM0006_Mail_Setup.cs:937 | else of (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) ▸ else of (e.Column == siCategory.GetColumnIndex(DefColumns.DET… | GRID_SET | siCategory.SetText | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_MIN_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |

## SCM0006_Mail_Setup.SprMessage_CellClick

진입점: this.Message.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d24b1910 | this.Message.CellClick | SCM0006_Mail_Setup.cs:1140 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c4791e8 | this.Message.CellClick | SCM0006_Mail_Setup.cs:1142 | if (this.siMessage.IsLock(siMessage.SheetName) == false) | CALL_EXT | siMessage.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17f69ddb | this.Message.CellClick | SCM0006_Mail_Setup.cs:1150 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.CATEGORY_DESC)) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-66fd08b5 | this.Message.CellClick | SCM0006_Mail_Setup.cs:1154 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ else of (e.Column == siMessage.GetColumnIndex(DefColumns.CATEGORY_DESC)) ▸ if (e.… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## SCM0006_Mail_Setup.SprMessage_CellDoubleClick

진입점: this.Message.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51c0af54 | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1164 | if (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-4f8f977d | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1168 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ if (th… | POPUP | new POPUP.SCM0006_PopContent | () | 팝업/폼 생성 |  |  |  |
| AC-f318928a | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1169 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ if (th… | UI_PROP | pop.UseTypeCode | UseTypeCode | 속성 UseTypeCode 설정 |  |  |  |
| AC-a8a494f4 | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1170 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ if (th… | VALUE_SET | pop.Text | "Mail Content 입력" | 컨트롤 값 설정 |  |  |  |
| AC-bb263e52 | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1172 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ if (th… | UI_PROP | pop.Content | Message.ActiveSheet.Cells[e.Row, e.Column].Text | 속성 Content 설정 |  |  |  |
| AC-1eb24d7c | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1174 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ if (th… | POPUP | pop.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |
| AC-47eb399d | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1176 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ if (th… | GRID_SET | Message.ActiveSheet.Cells[e.Row, e.Column].Text | pop.Content | 그리드 속성/값 설정 |  |  |  |
| AC-4f55a45e | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1177 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ if (th… | FLAG | sContentTemp | pop.Content | 화면 필드/플래그 변경 |  |  |  |
| AC-9e26aa2b | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1185 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ else o… | POPUP | new POPUP.SCM0006_PopContent | () | 팝업/폼 생성 |  |  |  |
| AC-feafda7c | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1186 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ else o… | UI_PROP | pop.UseTypeCode | UseTypeCode | 속성 UseTypeCode 설정 |  |  |  |
| AC-4d9dfc4a | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1187 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ else o… | UI_PROP | pop.Content | Message.ActiveSheet.Cells[e.Row, e.Column].Text | 속성 Content 설정 |  |  |  |
| AC-12d9286c | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1188 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ else o… | UI_PROP | pop.SaveDiasable | false | 속성 SaveDiasable 설정 |  |  |  |
| AC-0b50ce49 | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1189 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ else o… | VALUE_SET | pop.Text | "Mail Content" | 컨트롤 값 설정 |  |  |  |
| AC-52cc2e74 | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1190 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ else o… | CALL_EXT | pop.SetTextBold | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0cc75b5c | this.Message.CellDoubleClick | SCM0006_Mail_Setup.cs:1191 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MAIL_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_C…) ▸ else o… | POPUP | pop.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |

## SCM0006_PopContent.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c22d629 | this.btnButtonList.UsrButtonList_Click_Detected | SCM0006_PopContent.cs:186 | else of (buttonItem.UserType == ButtonListType.OK) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCM0006_PopContent.ChkContent

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4896280e | (진입점 미연결) | SCM0006_PopContent.cs:213 | try ▸ if (rtxtContent.Text.Length > 0) | CALL_EXT | Encoding.Default.GetByteCount | (rtxtContent.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c880290 | (진입점 미연결) | SCM0006_PopContent.cs:216 | try ▸ if (rtxtContent.Text.Length > 0) ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) <= 4000) | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |
| AC-bbddacfe | (진입점 미연결) | SCM0006_PopContent.cs:221 | try ▸ if (rtxtContent.Text.Length > 0) ▸ else of (Encoding.Default.GetByteCount(rtxtContent.Text) <= 4000) | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |
| AC-2aa3ce56 | (진입점 미연결) | SCM0006_PopContent.cs:228 | try ▸ else of (rtxtContent.Text.Length > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6a1969f | (진입점 미연결) | SCM0006_PopContent.cs:229 | try ▸ else of (rtxtContent.Text.Length > 0) | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |
| AC-4b339f70 | (진입점 미연결) | SCM0006_PopContent.cs:234 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-8e0f3929 | (진입점 미연결) | SCM0006_PopContent.cs:235 | catch ((Exception ex)) | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |

## SCM0006_PopContent.Define

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86715cd0 | this.Load | SCM0006_PopContent.cs:97 | if (UseTypeCode == "MAIL") | FLAG | sMaxTextLength | "4000" | 화면 필드/플래그 변경 |  |  |  |
| AC-4beedc89 | this.Load | SCM0006_PopContent.cs:98 | if (UseTypeCode == "MAIL") | UI_PROP | rtxtContent.MaxLength | 3700 | 속성 MaxLength 설정 |  |  |  |
| AC-c2c8928a | this.Load | SCM0006_PopContent.cs:102 | else of (UseTypeCode == "MAIL") | FLAG | sMaxTextLength | "1000" | 화면 필드/플래그 변경 |  |  |  |
| AC-9bb40287 | this.Load | SCM0006_PopContent.cs:103 | else of (UseTypeCode == "MAIL") | UI_PROP | rtxtContent.MaxLength | 800 | 속성 MaxLength 설정 |  |  |  |

## SCM0006_PopContent.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4744bc5e | Dispose | SCM0006_PopContent.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0006_PopContent.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f290ea1a | this.Load | SCM0006_PopContent.cs:84 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-523afe6a | this.Load | SCM0006_PopContent.cs:86 |  | FLAG | _sTempContent | rtxtContent.Text | 화면 필드/플래그 변경 |  |  |  |

## SCM0006_PopContent.RtxtContent_TextChanged

진입점: rtxtContent.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e76a6e5 | rtxtContent.TextChanged | SCM0006_PopContent.cs:115 | if (rtxtContent.Text.Length > 0) ▸ if (UseTypeCode == "MAIL") | CALL_EXT | Encoding.Default.GetByteCount | (rtxtContent.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-582be464 | rtxtContent.TextChanged | SCM0006_PopContent.cs:118 | if (rtxtContent.Text.Length > 0) ▸ if (UseTypeCode == "MAIL") ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) >= 3700) | MESSAGE | MessageHelper.GMessageBox | ("MSG00165", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22fe91e7 | rtxtContent.TextChanged | SCM0006_PopContent.cs:119 | if (rtxtContent.Text.Length > 0) ▸ if (UseTypeCode == "MAIL") ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) >= 3700) | VALUE_SET | rtxtContent.Text | _sTempContent | 컨트롤 값 설정 |  |  |  |
| AC-ab80daa0 | rtxtContent.TextChanged | SCM0006_PopContent.cs:120 | if (rtxtContent.Text.Length > 0) ▸ if (UseTypeCode == "MAIL") ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) >= 3700) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0884c851 | rtxtContent.TextChanged | SCM0006_PopContent.cs:123 | if (rtxtContent.Text.Length > 0) ▸ if (UseTypeCode == "MAIL") ▸ else of (Encoding.Default.GetByteCount(rtxtContent.Text) >= 3700) | FLAG | _sTempContent | rtxtContent.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-2af8cd43 | rtxtContent.TextChanged | SCM0006_PopContent.cs:127 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") | CALL_EXT | Encoding.Default.GetByteCount | (rtxtContent.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d8957a9 | rtxtContent.TextChanged | SCM0006_PopContent.cs:130 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) >= 800) | MESSAGE | MessageHelper.GMessageBox | ("MSG00165", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf5983af | rtxtContent.TextChanged | SCM0006_PopContent.cs:131 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) >= 800) | VALUE_SET | rtxtContent.Text | _sTempContent | 컨트롤 값 설정 |  |  |  |
| AC-4d9f38a0 | rtxtContent.TextChanged | SCM0006_PopContent.cs:132 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) >= 800) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce04256a | rtxtContent.TextChanged | SCM0006_PopContent.cs:135 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ else of (Encoding.Default.GetByteCount(rtxtContent.Text) >= 800) | FLAG | _sTempContent | rtxtContent.Text | 화면 필드/플래그 변경 |  |  |  |

## SCM0006_PopContent.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecfe56fc | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopContent.cs:165 | try | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-929e7dcf | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopContent.cs:166 | try | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-4f4005e8 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopContent.cs:170 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d00a5703 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopContent.cs:171 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCM0006_PopContent.SetTextBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccba019b | (진입점 미연결) | SCM0006_PopContent.cs:196 |  | UI_PROP | rtxtContent.Font | new Font("굴림", 9) | 속성 Font 설정 |  |  |  |

## SCM0006_PopSQL.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1aed518f | this.btnButtonList.UsrButtonList_Click_Detected | SCM0006_PopSQL.cs:230 | else of (buttonItem.UserType == ButtonListType.OK) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_PROP | this.DialogResult | DialogResult.No | 속성 DialogResult 설정 |  |  |  |
| AC-7591f680 | this.btnButtonList.UsrButtonList_Click_Detected | SCM0006_PopSQL.cs:231 | else of (buttonItem.UserType == ButtonListType.OK) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCM0006_PopSQL.ConvertDos2Unix

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.OK) ▸ else of (UseTypeCode == BIZTYPE.NOTICE.ToString()) ▸ if (UseTypeCode == BIZTYPE.MAIL.ToString())] / this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d708439 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SCM0006_PopSQL.cs:218 |  | RETURN | return xString; |  | 처리 중단/반환 |  |  |  |

## SCM0006_PopSQL.ConvertUnix2DOS

진입점: this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7481cd5 | this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())] | SCM0006_PopSQL.cs:213 |  | RETURN | return xString; |  | 처리 중단/반환 |  |  |  |

## SCM0006_PopSQL.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b719329 | Dispose | SCM0006_PopSQL.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0006_PopSQL.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd3cb736 | this.Load | SCM0006_PopSQL.cs:91 |  | VALUE_SET | this.Text | string.Format("SQL VIEW({0})", strCategoryDESC) | 컨트롤 값 설정 |  |  |  |
| AC-cd5b8ae2 | this.Load | SCM0006_PopSQL.cs:93 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCM0006_PopSQL.GetMailSqlLongText

진입점: this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a61662c2 | this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())] | SCM0006_PopSQL.cs:258 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f0245ae3 | this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())] | SCM0006_PopSQL.cs:262 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_GET_SQL_LONG_TEXT") ⇒ SCM.SCM0006_GET_SQL_LONG_TEXT | 엔드포인트 요청 생성 |  |  |  |
| AC-36aab8b9 | this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())] | SCM0006_PopSQL.cs:263 | lambda | DATA_OP | request.Parameters["p_use_type"] | UseTypeCode | 행/컬럼 값 대입 |  |  |  |
| AC-f46c3529 | this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())] | SCM0006_PopSQL.cs:264 | lambda | DATA_OP | request.Parameters["p_module"] | ModuleCode | 행/컬럼 값 대입 |  |  |  |
| AC-2c1551a5 | this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())] | SCM0006_PopSQL.cs:265 | lambda | DATA_OP | request.Parameters["p_submodule"] | SubModuleCode | 행/컬럼 값 대입 |  |  |  |
| AC-d5d19c46 | this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())] | SCM0006_PopSQL.cs:266 | lambda | DATA_OP | request.Parameters["p_category_id"] | CategoryID | 행/컬럼 값 대입 |  |  |  |
| AC-2b1699c4 | this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())] | SCM0006_PopSQL.cs:268 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-faaed7ac | this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())] | SCM0006_PopSQL.cs:270 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d2cd1429 | this.Load [if (UseTypeCode == BIZTYPE.MAIL.ToString())] | SCM0006_PopSQL.cs:289 |  | VALUE_SET | rtxtSQL.Text | ConvertUnix2DOS(sql) | 컨트롤 값 설정 |  |  |  |

## SCM0006_PopSQL.SaveMailSqlData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.OK) ▸ else of (UseTypeCode == BIZTYPE.NOTICE.ToString()) ▸ if (UseTypeCode == BIZTYPE.MAIL.ToString())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5148156e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:148 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_SAVE_RECIPIENT_MASTER_U") ⇒ SCM.SCM0006_SAVE_RECIPIENT_MASTER_U | 엔드포인트 요청 생성 |  |  |  |
| AC-fffd106c | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:152 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-663f968a | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:156 | lambda | DATA_OP | request.Parameters["p_use_type"] | strUseTypeCode | 행/컬럼 값 대입 |  |  |  |
| AC-7cc0a1ec | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:157 | lambda | DATA_OP | request.Parameters["p_module"] | strModuleCode | 행/컬럼 값 대입 |  |  |  |
| AC-5c88f90b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:158 | lambda | DATA_OP | request.Parameters["p_submodule"] | strSubModuleCode | 행/컬럼 값 대입 |  |  |  |
| AC-47ca991b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:159 | lambda | DATA_OP | request.Parameters["p_category_id"] | strCategoryID | 행/컬럼 값 대입 |  |  |  |
| AC-24d555a0 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:160 | lambda | DATA_OP | request.Parameters["p_category_desc"] | strCategoryDESC | 행/컬럼 값 대입 |  |  |  |
| AC-c141972a | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:161 | lambda | DATA_OP | request.Parameters["p_sql"] | strSql | 행/컬럼 값 대입 |  |  |  |
| AC-699b91b0 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:162 | lambda | DATA_OP | request.Parameters["p_last_updated_by"] | strLastUpdateBy | 행/컬럼 값 대입 |  |  |  |
| AC-c081b11f | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:164 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef1438df | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:164 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-58599c0c | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:173 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e13dba02 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:181 | if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4112b25f | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:184 | if (t.Success) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-1c7b7c8d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0006_PopSQL.cs:185 | if (t.Success) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

