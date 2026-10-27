# AS-IS 액션 대조표 — SCM0010

> 원천: `Doc/asisfacts/screens/SCM0010/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 203행 · 메서드 23 · 종류 DATA_OP 43 · GRID_INIT 27 · RETURN 20 · UI_PROP 19 · CALL_EXT 17 · MESSAGE 17 · GRID_SET 12 · ENDPOINT 11 · FLAG 8 · GRID_LOCK 7 · POPUP 6 · LIST_REBIND 4 · UI_MISC 4 · VALUE_SET 3 · GRID_BIND 2 · GRID_COMBO 2 · VALIDATE 1 · ⚠ 의미 확인 필요 17


## SCM0010_Notice_Setup.btnMessageTest_Click

진입점: this.btnMessageTest.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fb6ad39 | this.btnMessageTest.Click | SCM0010_Notice_Setup.cs:1311 |  | CALL_EXT | GSCM.Windows.Forms.GSCM_MainForm.Instance.InitUserNotice | () | ⚠ 의미 확인 필요 |  |  |  |

## SCM0010_Notice_Setup.btnPreview_Click

진입점: this.btnPreview.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe295cb4 | this.btnPreview.Click | SCM0010_Notice_Setup.cs:1320 | try ▸ if (r < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25797bc8 | this.btnPreview.Click | SCM0010_Notice_Setup.cs:1322 | try | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00125", UserInfoContext.Current["Language"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-849b7076 | this.btnPreview.Click | SCM0010_Notice_Setup.cs:1329 | try | CALL_EXT | GSCM.Windows.Forms.GSCM_MainForm.Instance.GetNoticeImage | (notice_id, notice_image_name) | ⚠ 의미 확인 필요 |  |  |  |
| AC-828e98b2 | this.btnPreview.Click | SCM0010_Notice_Setup.cs:1330 | try | CALL_EXT | GSCM.Windows.Forms.GSCM_MainForm.Instance.ShowAlert | ( notice_id,//dr["NOTICE_ID"].ToString(), notice_title,//dr["NOTICE_TITLE"].ToString(), no… | ⚠ 의미 확인 필요 |  |  |  |

## SCM0010_Notice_Setup.CboModule_SelectedIndexChanged

진입점: cboModule.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-339f13c7 | cboModule.SelectedIndexChanged | SCM0010_Notice_Setup.cs:1303 |  | LIST_REBIND | cboSubModule.DataBind | (Data.Type.SubModule, true, CConstVariable.SMS_MAIL_SEND_SYSTEM, cboModule.SelectedValue.T… ⇒ biz:CommonData.CommonDataList [code=SubModule] | 목록 컨트롤 재구성 |  |  |  |

## SCM0010_Notice_Setup.ChkMsgValidation

진입점: SaveButton [if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f477305d | SaveButton [if (siMessage != null && siMessage.IsLock(siMess… | SCM0010_Notice_Setup.cs:1132 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (cntDuplicate > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f5bd2fac | SaveButton [if (siMessage != null && siMessage.IsLock(siMess… | SCM0010_Notice_Setup.cs:1146 |  | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |

## SCM0010_Notice_Setup.ChkNoticeValidation

진입점: SaveButton [if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69a61045 | SaveButton [if (siNotice != null && siNotice.IsLock(siNotice… | SCM0010_Notice_Setup.cs:1223 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (!string.IsNullOrEmpty(strMain)) ▸ if (strMain == "MONTH" \|\| strMain == "… | MESSAGE | MessageHelper.GMessageBox | ("MSG00122", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-77a4a055 | SaveButton [if (siNotice != null && siNotice.IsLock(siNotice… | SCM0010_Notice_Setup.cs:1235 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (!string.IsNullOrEmpty(strMain)) ▸ else of (strMain == "MONTH" \|\| strMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00123", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f932efa4 | SaveButton [if (siNotice != null && siNotice.IsLock(siNotice… | SCM0010_Notice_Setup.cs:1244 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ else of (!string.IsNullOrEmpty(strMain)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00124", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7affa474 | SaveButton [if (siNotice != null && siNotice.IsLock(siNotice… | SCM0010_Notice_Setup.cs:1279 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (cntDuplicate > 1) | CALL_EXT | siNotice.GetColumnText | (0, siNotice.GetColumnIndex(DefColumns.NOTICE_MAIN_TITLE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5a52585 | SaveButton [if (siNotice != null && siNotice.IsLock(siNotice… | SCM0010_Notice_Setup.cs:1283 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (cntDuplicate > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f192c131 | SaveButton [if (siNotice != null && siNotice.IsLock(siNotice… | SCM0010_Notice_Setup.cs:1298 |  | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |

## SCM0010_Notice_Setup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-915a2aca | this.Load | SCM0010_Notice_Setup.cs:175 |  | GRID_INIT | this.AddSheet | (Notice, SpdSheet.siNotice, SpdSheet.siNotice, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ad888b29 | this.Load | SCM0010_Notice_Setup.cs:176 |  | FLAG | siNotice | GetSheetInfo(Notice.Name, Notice.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e88a6deb | this.Load | SCM0010_Notice_Setup.cs:178 |  | GRID_INIT | this.AddSheet | (Message, SpdSheet.siMessage, SpdSheet.siMessage, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-de4382a2 | this.Load | SCM0010_Notice_Setup.cs:179 |  | FLAG | siMessage | GetSheetInfo(Message.Name, Message.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ed85e9fb | this.Load | SCM0010_Notice_Setup.cs:181 |  | GRID_INIT | siNotice.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0010_Notice_Setup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40a93c52 | DeleteButton | SCM0010_Notice_Setup.cs:260 | if (fps != null) ▸ if (fps.Name == SpdSheet.siNotice) | DATA_OP | siNotice.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-38ef06f0 | DeleteButton | SCM0010_Notice_Setup.cs:263 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | siMessage.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCM0010_Notice_Setup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b73df7e6 | Dispose | SCM0010_Notice_Setup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0010_Notice_Setup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82d1a989 | EditButton | SCM0010_Notice_Setup.cs:273 | if (fps != null) ▸ if (fps.Name == SpdSheet.siNotice) | GRID_LOCK | siNotice.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a8798f3e | EditButton | SCM0010_Notice_Setup.cs:274 | if (fps != null) ▸ if (fps.Name == SpdSheet.siNotice) | GRID_LOCK | siNotice.LockColumn | (siNotice.GetColumnIndex(DefColumns.MODULE_CODE), siNotice.GetColumnIndex(DefColumns.SUB_M… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6a8dbb03 | EditButton | SCM0010_Notice_Setup.cs:278 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_LOCK | siMessage.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d532a63b | EditButton | SCM0010_Notice_Setup.cs:279 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_LOCK | siMessage.LockColumn | (siMessage.GetColumnIndex(DefColumns.NOTICE_ID), siMessage.GetColumnIndex(DefColumns.NOTIC… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0010_Notice_Setup.FindData_Main

진입점: FindButton / SaveButton [if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74076787 | FindButton 외 1 | SCM0010_Notice_Setup.cs:298 |  | CALL_EXT | CString.GetComboBoxValue | (cboModule.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a22be3fc | FindButton 외 1 | SCM0010_Notice_Setup.cs:299 |  | CALL_EXT | CString.GetComboBoxValue | (cboSubModule.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-360924c5 | FindButton 외 1 | SCM0010_Notice_Setup.cs:300 |  | CALL_EXT | CString.GetComboBoxValue | (cboActive.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea98a80e | FindButton 외 1 | SCM0010_Notice_Setup.cs:304 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5dcf5947 | FindButton 외 1 | SCM0010_Notice_Setup.cs:308 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0010_GET_NOTICE_MASTER") ⇒ SCM.SCM0010_GET_NOTICE_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-39f90614 | FindButton 외 1 | SCM0010_Notice_Setup.cs:309 | lambda | DATA_OP | request.Parameters["p_module"] | Module | 행/컬럼 값 대입 |  |  |  |
| AC-aee315ef | FindButton 외 1 | SCM0010_Notice_Setup.cs:310 | lambda | DATA_OP | request.Parameters["p_submodule"] | SubMod | 행/컬럼 값 대입 |  |  |  |
| AC-f080c0d6 | FindButton 외 1 | SCM0010_Notice_Setup.cs:311 | lambda | DATA_OP | request.Parameters["p_active"] | Active | 행/컬럼 값 대입 |  |  |  |
| AC-785a931d | FindButton 외 1 | SCM0010_Notice_Setup.cs:313 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-af607290 | FindButton 외 1 | SCM0010_Notice_Setup.cs:315 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ff10f13c | FindButton 외 1 | SCM0010_Notice_Setup.cs:319 |  | GRID_BIND | siNotice.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c10e5907 | FindButton 외 1 | SCM0010_Notice_Setup.cs:320 |  | GRID_LOCK | siNotice.LockColumn | (0, siNotice.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ef1b47f2 | FindButton 외 1 | SCM0010_Notice_Setup.cs:323 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0a0ea7ab | FindButton 외 1 | SCM0010_Notice_Setup.cs:326 |  | GRID_INIT | siNotice.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0010_Notice_Setup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78d81a59 | this.Load | SCM0010_Notice_Setup.cs:142 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0010_Notice_Setup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5795e71 | this.Load | SCM0010_Notice_Setup.cs:159 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-226ffe69 | this.Load | SCM0010_Notice_Setup.cs:161 |  | LIST_REBIND | cboModule.DataBind | (Data.Type.Module, true, CConstVariable.SMS_MAIL_SEND_SYSTEM) ⇒ biz:CommonData.CommonDataList [code=Module] | 목록 컨트롤 재구성 |  |  |  |
| AC-08678591 | this.Load | SCM0010_Notice_Setup.cs:162 |  | LIST_REBIND | cboSubModule.DataBind | (Data.Type.SubModule, true, CConstVariable.SMS_MAIL_SEND_SYSTEM) ⇒ biz:CommonData.CommonDataList [code=SubModule] | 목록 컨트롤 재구성 |  |  |  |
| AC-e8559e9c | this.Load | SCM0010_Notice_Setup.cs:163 |  | LIST_REBIND | cboActive.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-d1394ba0 | this.Load | SCM0010_Notice_Setup.cs:165 |  | VALUE_SET | cboActive.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-03e2a7c1 | this.Load | SCM0010_Notice_Setup.cs:169 |  | UI_PROP | lcTest.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCM0010_Notice_Setup.InitSpread

진입점: this.Load / this.Notice.CellClick [else of (siNotice.IsLock(siNotice.SheetName) == false)] / FindButton / SaveButton [if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7389e88 | this.Load 외 3 | SCM0010_Notice_Setup.cs:189 |  | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-561944bb | this.Load 외 3 | SCM0010_Notice_Setup.cs:193 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5d1a9e3e | this.Load 외 3 | SCM0010_Notice_Setup.cs:194 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.AddComboColumn | ("Module*", DefColumns.MODULE_CODE, FPMerge.Restricted, 100, true, dtModule, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61c66d39 | this.Load 외 3 | SCM0010_Notice_Setup.cs:195 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub Module*", DefColumns.SUB_MODULE_CODE, FPMerge.Restricted, 100, true, dtSubModule, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-141c3343 | this.Load 외 3 | SCM0010_Notice_Setup.cs:196 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.AddTextColumn | ("Notice", DefColumns.NOTICE_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6fe43e00 | this.Load 외 3 | SCM0010_Notice_Setup.cs:197 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.AddTextColumn | ("Notice*", DefColumns.NOTICE_MAIN_TITLE, FPMerge.Restricted, 300, true, FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1718733 | this.Load 외 3 | SCM0010_Notice_Setup.cs:198 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.Restricted, 100, true, dtYesOrNo, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9863687c | this.Load 외 3 | SCM0010_Notice_Setup.cs:200 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.AddComboColumn | ("Main*", DefColumns.CYCLE_CLASS_CODE, FPMerge.Restricted, 100, true, dtCycle, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f16e99a6 | this.Load 외 3 | SCM0010_Notice_Setup.cs:201 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub1", DefColumns.DETAIL_CLASS_CODE, FPMerge.Restricted, 100, true, dtCycleSub1, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6763760c | this.Load 외 3 | SCM0010_Notice_Setup.cs:202 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub2", DefColumns.SEND_TIME_TEXT, FPMerge.Restricted, 100, true, dtCycleSub2, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b077ee94 | this.Load 외 3 | SCM0010_Notice_Setup.cs:208 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.MODULE_CODE), 2, 1, 25, "Module*", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71c3b409 | this.Load 외 3 | SCM0010_Notice_Setup.cs:209 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.SUB_MODULE_CODE), 2, 1, 25, "Sub Module*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b931f8a | this.Load 외 3 | SCM0010_Notice_Setup.cs:210 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.NOTICE_MAIN_TITLE), 2, 1, 25, "Notice*", FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ae6af47 | this.Load 외 3 | SCM0010_Notice_Setup.cs:211 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.ACTIVE_FLAG), 2, 1, 25, "Active", FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e92218c4 | this.Load 외 3 | SCM0010_Notice_Setup.cs:213 | if (spreadInfo.SheetName == SpdSheet.siNotice) | CALL_EXT | clsCtrl.HeaderSpan | (spreadInfo, 0, DefColumns.CYCLE_CLASS_CODE, 1, 3, "Period") | ⚠ 의미 확인 필요 |  |  |  |
| AC-75309f6d | this.Load 외 3 | SCM0010_Notice_Setup.cs:217 | if (spreadInfo.SheetName == SpdSheet.siNotice) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3bb8e499 | this.Load 외 3 | SCM0010_Notice_Setup.cs:222 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1674dd99 | this.Load 외 3 | SCM0010_Notice_Setup.cs:223 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Notice", DefColumns.NOTICE_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8508065f | this.Load 외 3 | SCM0010_Notice_Setup.cs:224 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Notice", DefColumns.NOTICE_MAIN_TITLE, FPMerge.Always, 300, true, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90a1e91e | this.Load 외 3 | SCM0010_Notice_Setup.cs:226 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Notice Title*", DefColumns.NOTICE_TITLE, FPMerge.None, 200, true, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53508818 | this.Load 외 3 | SCM0010_Notice_Setup.cs:227 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Notice Content*", DefColumns.NOTICE_CONTENT, FPMerge.None, 400, true, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71cef88a | this.Load 외 3 | SCM0010_Notice_Setup.cs:228 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Image", "NOTICE_IMAGE", FPMerge.None, 200, true, FPHAlign.Left, FPVAlign.Center, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e98e777 | this.Load 외 3 | SCM0010_Notice_Setup.cs:229 | if (spreadInfo.SheetName == SpdSheet.siMessage) | CALL_EXT | spreadInfo.AddButtonColumn2 | ("Upload", "NOTICE_IMAGE_ID","Upload", FPMerge.None, 100, true, FPHAlign.Left, FPVAlign.Ce… | ⚠ 의미 확인 필요 |  |  |  |
| AC-89bae707 | this.Load 외 3 | SCM0010_Notice_Setup.cs:230 | if (spreadInfo.SheetName == SpdSheet.siMessage) | CALL_EXT | spreadInfo.AutoRowHeight | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-08d427e9 | this.Load 외 3 | SCM0010_Notice_Setup.cs:232 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0010_Notice_Setup.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bc5f569 | InsertButton | SCM0010_Notice_Setup.cs:740 | if (fps.Name == SpdSheet.siNotice) | DATA_OP | siNotice.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6478ca03 | InsertButton | SCM0010_Notice_Setup.cs:743 | if (fps.Name == SpdSheet.siNotice) | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e70fe70 | InsertButton | SCM0010_Notice_Setup.cs:745 | if (fps.Name == SpdSheet.siNotice) | GRID_SET | siNotice.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-c4321bfb | InsertButton | SCM0010_Notice_Setup.cs:751 | else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) ▸ if (siMessage.ActiveSheet.RowCount > 0) | MESSAGE | MessageBox.Show | ("You have notice content already. You can add only one message.") | 메시지 표시 |  |  |  |
| AC-a24cd99f | InsertButton | SCM0010_Notice_Setup.cs:752 | else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) ▸ if (siMessage.ActiveSheet.RowCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88abf12c | InsertButton | SCM0010_Notice_Setup.cs:754 | else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | siMessage.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f2811af | InsertButton | SCM0010_Notice_Setup.cs:757 | else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | defaultData.Add | (DefColumns.NOTICE_ID, strNotice) | 데이터 객체 조작/조회 |  |  |  |
| AC-475e3144 | InsertButton | SCM0010_Notice_Setup.cs:758 | else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | defaultData.Add | (DefColumns.NOTICE_MAIN_TITLE, strNoticeDESC) | 데이터 객체 조작/조회 |  |  |  |
| AC-1811983c | InsertButton | SCM0010_Notice_Setup.cs:759 | else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | defaultData.Add | (DefColumns.LANGUAGE_CODE, "KO") | 데이터 객체 조작/조회 |  |  |  |
| AC-906f72e0 | InsertButton | SCM0010_Notice_Setup.cs:761 | else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_SET | siMessage.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-3f5fb662 | InsertButton | SCM0010_Notice_Setup.cs:762 | else of (fps.Name == SpdSheet.siNotice) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_LOCK | siMessage.LockRange | (insCell, siMessage.GetColumnIndex(DefColumns.NOTICE_MAIN_TITLE), siMessage.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0010_Notice_Setup.Message_EditChange

진입점: Message.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcd8a6e8 | Message.EditChange | SCM0010_Notice_Setup.cs:1037 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f42b2823 | Message.EditChange | SCM0010_Notice_Setup.cs:1043 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.NOTICE_CONTENT)) | CALL_EXT | Encoding.Default.GetByteCount | (sContent) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4271ab37 | Message.EditChange | SCM0010_Notice_Setup.cs:1046 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.NOTICE_CONTENT)) ▸ if (Encodi… | MESSAGE | MessageHelper.GMessageBox | ("MSG00165", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db5080a7 | Message.EditChange | SCM0010_Notice_Setup.cs:1047 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.NOTICE_CONTENT)) ▸ if (Encodi… | GRID_SET | siMessage.SetValue | (e.Row, e.Column, sContentTemp) | 그리드 값 설정 |  |  |  |
| AC-8b69d499 | Message.EditChange | SCM0010_Notice_Setup.cs:1048 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.NOTICE_CONTENT)) ▸ if (Encodi… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-226b5806 | Message.EditChange | SCM0010_Notice_Setup.cs:1051 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.NOTICE_CONTENT)) ▸ else of (E… | FLAG | sContentTemp | sContent | 화면 필드/플래그 변경 |  |  |  |

## SCM0010_Notice_Setup.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86187570 | SaveButton | SCM0010_Notice_Setup.cs:355 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) | VALIDATE | DataUtil.checkRequiredOfSpread | (siNotice) | 프레임워크 검증 |  |  |  |
| AC-516ceeb6 | SaveButton | SCM0010_Notice_Setup.cs:355 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (!DataUtil.checkRe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9730a4db | SaveButton | SCM0010_Notice_Setup.cs:357 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (!ChkNoticeValidat… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f38bf563 | SaveButton | SCM0010_Notice_Setup.cs:392 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00121") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4593fc7f | SaveButton | SCM0010_Notice_Setup.cs:392 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ if … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf26d281 | SaveButton | SCM0010_Notice_Setup.cs:394 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCM.SCM0010_SAVE_NOTICE_MASTER") ⇒ SCM.SCM0010_SAVE_NOTICE_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-9f891df7 | SaveButton | SCM0010_Notice_Setup.cs:399 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-596a023f | SaveButton | SCM0010_Notice_Setup.cs:403 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-89e964f6 | SaveButton | SCM0010_Notice_Setup.cs:404 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_module"] | p_module | 행/컬럼 값 대입 |  |  |  |
| AC-1de0eaf7 | SaveButton | SCM0010_Notice_Setup.cs:405 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_submodule"] | p_submodule | 행/컬럼 값 대입 |  |  |  |
| AC-93a79d32 | SaveButton | SCM0010_Notice_Setup.cs:406 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_notice_id"] | p_notice_id | 행/컬럼 값 대입 |  |  |  |
| AC-2aad0f70 | SaveButton | SCM0010_Notice_Setup.cs:407 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_notice_desc"] | p_notice_desc | 행/컬럼 값 대입 |  |  |  |
| AC-390d17ba | SaveButton | SCM0010_Notice_Setup.cs:408 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_cycle_class_code"] | p_cycle_class_code | 행/컬럼 값 대입 |  |  |  |
| AC-fb3a6058 | SaveButton | SCM0010_Notice_Setup.cs:409 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_detail_class_code"] | p_detail_class_code | 행/컬럼 값 대입 |  |  |  |
| AC-be9b937f | SaveButton | SCM0010_Notice_Setup.cs:410 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_send_time_text"] | p_send_time_text | 행/컬럼 값 대입 |  |  |  |
| AC-6e710a37 | SaveButton | SCM0010_Notice_Setup.cs:411 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_active"] | p_active | 행/컬럼 값 대입 |  |  |  |
| AC-151b6965 | SaveButton | SCM0010_Notice_Setup.cs:412 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-0d011381 | SaveButton | SCM0010_Notice_Setup.cs:413 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-7fe54b6e | SaveButton | SCM0010_Notice_Setup.cs:414 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-dfc9d83c | SaveButton | SCM0010_Notice_Setup.cs:416 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a314e0a | SaveButton | SCM0010_Notice_Setup.cs:416 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ lam… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-f28daba5 | SaveButton | SCM0010_Notice_Setup.cs:425 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a0976c5 | SaveButton | SCM0010_Notice_Setup.cs:434 | if (siNotice != null && siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.SheetName == SpdSheet.siNotice) ▸ if (iCount > 0) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3cb532a1 | SaveButton | SCM0010_Notice_Setup.cs:490 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ try ▸ for (iRow … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47209c1d | SaveButton | SCM0010_Notice_Setup.cs:501 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (bFlag == fal… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-469624b8 | SaveButton | SCM0010_Notice_Setup.cs:504 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (!ChkMsgValid… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9dab5395 | SaveButton | SCM0010_Notice_Setup.cs:510 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (dsSave == nu… | MESSAGE | MessageBox.Show | ("There's nothing to save") | 메시지 표시 |  |  |  |
| AC-c98938e9 | SaveButton | SCM0010_Notice_Setup.cs:511 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (dsSave == nu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0741f4c | SaveButton | SCM0010_Notice_Setup.cs:513 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) | DATA_OP | dsSave.Tables[0].Columns.SafeAdd | ("_OPCODE_", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-449040a6 | SaveButton | SCM0010_Notice_Setup.cs:514 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) | DATA_OP | dsSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0642e751 | SaveButton | SCM0010_Notice_Setup.cs:517 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ foreach (DataRow… | DATA_OP | r["_OPCODE_"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-ab52facc | SaveButton | SCM0010_Notice_Setup.cs:526 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ for (i <= siMess… | DATA_OP | siMessage.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d0311446 | SaveButton | SCM0010_Notice_Setup.cs:532 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ for (i <= siMess… | DATA_OP | bindingRow["_OPCODE_"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-ea2ef72c | SaveButton | SCM0010_Notice_Setup.cs:536 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ for (i <= siMess… | DATA_OP | bindingRow["_OPCODE_"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-1b0232e8 | SaveButton | SCM0010_Notice_Setup.cs:540 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ for (i <= siMess… | DATA_OP | bindingRow["_OPCODE_"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-263e5ec5 | SaveButton | SCM0010_Notice_Setup.cs:544 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ for (i <= siMess… | DATA_OP | bindingRow["_OPCODE_"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-003af5bd | SaveButton | SCM0010_Notice_Setup.cs:555 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) | DATA_OP | dsSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-39031b19 | SaveButton | SCM0010_Notice_Setup.cs:556 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) | DATA_OP | dsSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a10e64c3 | SaveButton | SCM0010_Notice_Setup.cs:564 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | dsDelete.Tables[0].ImportRow | (r) | 데이터 객체 조작/조회 |  |  |  |
| AC-c47e065e | SaveButton | SCM0010_Notice_Setup.cs:572 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | r["language_code"] | "EN" | 행/컬럼 값 대입 |  |  |  |
| AC-7aabacc6 | SaveButton | SCM0010_Notice_Setup.cs:573 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | r["language"] | "EN" | 행/컬럼 값 대입 |  |  |  |
| AC-250c59a4 | SaveButton | SCM0010_Notice_Setup.cs:575 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | dsToSave.Tables[0].ImportRow | (r) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1c02879 | SaveButton | SCM0010_Notice_Setup.cs:585 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) | UI_PROP | ret1.Success | true | 속성 Success 설정 |  |  |  |
| AC-3fd732fe | SaveButton | SCM0010_Notice_Setup.cs:586 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) | UI_PROP | ret2.Success | true | 속성 Success 설정 |  |  |  |
| AC-23a13df7 | SaveButton | SCM0010_Notice_Setup.cs:624 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | ENDPOINT | GService.CommonPseudoBatch | (@"scm\admin\scm_notice_setup", "update_notice", dsToSave, 0) ⇒ biz:AppService.GeneralPseudoBatch [batchId=update_notice] \| scm\admin\scm_notic… | 엔드포인트 호출 |  |  |  |
| AC-079938d4 | SaveButton | SCM0010_Notice_Setup.cs:635 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | ENDPOINT | GService.CommonPseudoBatch | (@"scm\admin\scm_notice_setup", "delete_notice", dsDelete, 0) ⇒ biz:AppService.GeneralPseudoBatch [batchId=delete_notice] \| scm\admin\scm_notic… | 엔드포인트 호출 |  |  |  |
| AC-18b952a9 | SaveButton | SCM0010_Notice_Setup.cs:646 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { success_cnt }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b6611c4 | SaveButton | SCM0010_Notice_Setup.cs:654 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56a0a0cb | SaveButton | SCM0010_Notice_Setup.cs:659 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ else of (iCount … | MESSAGE | MessageBox.Show | ("No data to save") | 메시지 표시 |  |  |  |
| AC-166ea84b | SaveButton | SCM0010_Notice_Setup.cs:660 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ else of (iCount … | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCM0010_Notice_Setup.ShowMessage

진입점: this.Notice.CellClick [else of (siNotice.IsLock(siNotice.SheetName) == false)] / SaveButton [if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) ▸ if (success_cnt > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-707af465 | this.Notice.CellClick [else of (siNotice.IsLock(siNotice.She… 외 1 | SCM0010_Notice_Setup.cs:1162 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1d587dfa | this.Notice.CellClick [else of (siNotice.IsLock(siNotice.She… 외 1 | SCM0010_Notice_Setup.cs:1166 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0010_GET_NOTICE_CONTENT_MASTER") ⇒ SCM.SCM0010_GET_NOTICE_CONTENT_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-fe7884cd | this.Notice.CellClick [else of (siNotice.IsLock(siNotice.She… 외 1 | SCM0010_Notice_Setup.cs:1167 | lambda | DATA_OP | request.Parameters["p_notice_id"] | strNotice | 행/컬럼 값 대입 |  |  |  |
| AC-90cdc6cc | this.Notice.CellClick [else of (siNotice.IsLock(siNotice.She… 외 1 | SCM0010_Notice_Setup.cs:1169 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-53aeee6e | this.Notice.CellClick [else of (siNotice.IsLock(siNotice.She… 외 1 | SCM0010_Notice_Setup.cs:1171 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3004c63a | this.Notice.CellClick [else of (siNotice.IsLock(siNotice.She… 외 1 | SCM0010_Notice_Setup.cs:1175 |  | GRID_BIND | siMessage.Query | (ds,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1dd58d46 | this.Notice.CellClick [else of (siNotice.IsLock(siNotice.She… 외 1 | SCM0010_Notice_Setup.cs:1176 |  | GRID_LOCK | siMessage.LockColumn | (0, siMessage.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-31d129c4 | this.Notice.CellClick [else of (siNotice.IsLock(siNotice.She… 외 1 | SCM0010_Notice_Setup.cs:1179 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-20cc7599 | this.Notice.CellClick [else of (siNotice.IsLock(siNotice.She… 외 1 | SCM0010_Notice_Setup.cs:1182 |  | GRID_INIT | siMessage.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0010_Notice_Setup.SprMessage_CellClick

진입점: this.Message.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dad2a91 | this.Message.CellClick | SCM0010_Notice_Setup.cs:944 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f11817d9 | this.Message.CellClick | SCM0010_Notice_Setup.cs:946 | if (this.siMessage.IsLock(siMessage.SheetName) == false) | CALL_EXT | siMessage.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7a16fe9 | this.Message.CellClick | SCM0010_Notice_Setup.cs:954 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.NOTICE_MAIN_TITLE)) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-c4bf9f66 | this.Message.CellClick | SCM0010_Notice_Setup.cs:958 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ else of (e.Column == siMessage.GetColumnIndex(DefColumns.NOTICE_MAIN_TITLE)) ▸ if… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-8f2f43f5 | this.Message.CellClick | SCM0010_Notice_Setup.cs:964 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ else of (e.Column == siMessage.GetColumnIndex(DefColumns.NOTICE_MAIN_TITLE)) ▸ el… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## SCM0010_Notice_Setup.SprMessage_CellDoubleClick

진입점: this.Message.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-802b4bfd | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1001 | if (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-f44925e1 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1005 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ if (th… | POPUP | new POPUP.SCM0006_PopContent | () | 팝업/폼 생성 |  |  |  |
| AC-88e8b9a2 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1006 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ if (th… | UI_PROP | pop.UseTypeCode | "Notice" | 속성 UseTypeCode 설정 |  |  |  |
| AC-25276bff | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1007 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ if (th… | VALUE_SET | pop.Text | "Notice Content 입력" | 컨트롤 값 설정 |  |  |  |
| AC-cf37b5c3 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1009 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ if (th… | UI_PROP | pop.Content | Message.ActiveSheet.Cells[e.Row, e.Column].Text | 속성 Content 설정 |  |  |  |
| AC-699f5438 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1011 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ if (th… | POPUP | pop.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |
| AC-b7db13b8 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1013 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ if (th… | GRID_SET | Message.ActiveSheet.Cells[e.Row, e.Column].Text | pop.Content | 그리드 속성/값 설정 |  |  |  |
| AC-c3b95767 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1014 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ if (th… | FLAG | sContentTemp | pop.Content | 화면 필드/플래그 변경 |  |  |  |
| AC-3dab9e67 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1022 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ else o… | POPUP | new POPUP.SCM0006_PopContent | () | 팝업/폼 생성 |  |  |  |
| AC-f8e31217 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1023 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ else o… | UI_PROP | pop.UseTypeCode | "Notice" | 속성 UseTypeCode 설정 |  |  |  |
| AC-d80f8674 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1024 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ else o… | UI_PROP | pop.Content | Message.ActiveSheet.Cells[e.Row, e.Column].Text | 속성 Content 설정 |  |  |  |
| AC-03bc7b95 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1025 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ else o… | UI_PROP | pop.SaveDiasable | false | 속성 SaveDiasable 설정 |  |  |  |
| AC-089f0475 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1026 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ else o… | VALUE_SET | pop.Text | "Notice Content" | 컨트롤 값 설정 |  |  |  |
| AC-3ddc85a7 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1027 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ else o… | CALL_EXT | pop.SetTextBold | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0fd5725 | this.Message.CellDoubleClick | SCM0010_Notice_Setup.cs:1028 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_TITLE) && e.Column != siMessage.GetColumnIndex(DefColumns.NOTICE_…) ▸ else o… | POPUP | pop.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |

## SCM0010_Notice_Setup.SprNotice_CellClick

진입점: this.Notice.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3ee0608 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:773 | if (this.siNotice.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe20a751 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:797 | if (siNotice.IsLock(siNotice.SheetName) == false) | CALL_EXT | siNotice.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15d1fdd0 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:799 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (siNotice.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction) == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8262a99b | this.Notice.CellClick | SCM0010_Notice_Setup.cs:802 | if (siNotice.IsLock(siNotice.SheetName) == false) | CALL_EXT | siNotice.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6a63ff6 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:818 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.IsNull… | MESSAGE | MessageHelper.GMessageBox | ("MSG00111", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-49d62167 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:819 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.IsNull… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-06170b76 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:824 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (String.I… | DATA_OP | dtSubModule.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-07793da7 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:826 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (String.I… | UI_PROP | dvNewSubModule.RowFilter | string.Format("SYSTEM_CODE = '{0}'", strModule) | 속성 RowFilter 설정 |  |  |  |
| AC-8958edae | this.Notice.CellClick | SCM0010_Notice_Setup.cs:828 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (String.I… | GRID_COMBO | siNotice.SetCellTypeCombo | (e.Row, e.Column, dvNewSubModule.ToTable()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cee5a9d5 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:828 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (String.I… | DATA_OP | dvNewSubModule.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fe8515ee | this.Notice.CellClick | SCM0010_Notice_Setup.cs:843 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullOrEmpty… | MESSAGE | MessageHelper.GMessageBox | ("MSG00112", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-810685f4 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:844 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullOrEmpty… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-f7b70464 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:849 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.IsNullOr… | DATA_OP | dtCycleSub1.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b39a0813 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:851 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.IsNullOr… | UI_PROP | dvNewSub1.RowFilter | string.Format("CYCLE_CODE = '{0}'", strMain) | 속성 RowFilter 설정 |  |  |  |
| AC-db1bc32d | this.Notice.CellClick | SCM0010_Notice_Setup.cs:853 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.IsNullOr… | GRID_COMBO | siNotice.SetCellTypeCombo | (e.Row, e.Column, dvNewSub1.ToTable()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ec2ec944 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:853 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.IsNullOr… | DATA_OP | dvNewSub1.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25fa96db | this.Notice.CellClick | SCM0010_Notice_Setup.cs:869 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (e.Column == siNotice.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (strMain == "DAY" \|\| s… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-8f13961b | this.Notice.CellClick | SCM0010_Notice_Setup.cs:883 | if (siNotice.IsLock(siNotice.SheetName) == false) ▸ if (String.IsNullOrEmpty(strState) \|\| strState == "M" \|\| strState == "D") ▸ if (e.Co… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-0dc8b813 | this.Notice.CellClick | SCM0010_Notice_Setup.cs:897 | else of (siNotice.IsLock(siNotice.SheetName) == false) | FLAG | strNotice | (objNoticeID == null) ? string.Empty : objNoticeID.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8837cd7e | this.Notice.CellClick | SCM0010_Notice_Setup.cs:900 | else of (siNotice.IsLock(siNotice.SheetName) == false) | FLAG | strNoticeDESC | (objNoticeDESC == null) ? string.Empty : objNoticeDESC.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-561ff6fa | this.Notice.CellClick | SCM0010_Notice_Setup.cs:903 | else of (siNotice.IsLock(siNotice.SheetName) == false) | FLAG | sContentTemp | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SCM0010_Notice_Setup.SprNotice_CellDoubleClick

진입점: this.Notice.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cc14df3 | this.Notice.CellDoubleClick | SCM0010_Notice_Setup.cs:932 | if (e.Column != siNotice.GetColumnIndex(DefColumns.NOTICE_MAIN_TITLE)) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## SCM0010_Notice_Setup.SprNotice_ComboSelChange

진입점: this.Notice.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0589a7ec | this.Notice.ComboSelChange | SCM0010_Notice_Setup.cs:914 | if (e.Column == siNotice.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siNotice.SetValue | (e.Row, siNotice.GetColumnIndex(DefColumns.DETAIL_CLASS_CODE), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-aafcf03a | this.Notice.ComboSelChange | SCM0010_Notice_Setup.cs:915 | if (e.Column == siNotice.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siNotice.SetText | (e.Row, siNotice.GetColumnIndex(DefColumns.DETAIL_CLASS_CODE), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-a0672012 | this.Notice.ComboSelChange | SCM0010_Notice_Setup.cs:917 | if (e.Column == siNotice.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siNotice.SetValue | (e.Row, siNotice.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-c402af76 | this.Notice.ComboSelChange | SCM0010_Notice_Setup.cs:918 | if (e.Column == siNotice.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siNotice.SetText | (e.Row, siNotice.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-6d36e9f7 | this.Notice.ComboSelChange | SCM0010_Notice_Setup.cs:922 | else of (e.Column == siNotice.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) ▸ if (e.Column == siNotice.GetColumnIndex(DefColumns.DETAIL_CLASS… | GRID_SET | siNotice.SetValue | (e.Row, siNotice.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-13b180c2 | this.Notice.ComboSelChange | SCM0010_Notice_Setup.cs:923 | else of (e.Column == siNotice.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) ▸ if (e.Column == siNotice.GetColumnIndex(DefColumns.DETAIL_CLASS… | GRID_SET | siNotice.SetText | (e.Row, siNotice.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |

## SCM0010_Notice_Setup.UploadFile

진입점: this.Message.CellClick [if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ else of (e.Column == siMessage.GetColumnIndex(DefColumns.NOTICE_MAIN_TITLE)) ▸ else of (e.Column == siMessage.GetColumnIndex(DefColumns.LANGUAGE_CODE) && strState != "I") ▸ if (e.Column == siMessage.GetColumnIndex("NOTICE_IMAGE_ID"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-615bc165 | this.Message.CellClick [if (this.siMessage.IsLock(siMessage.… | SCM0010_Notice_Setup.cs:974 | try | POPUP | new System.Windows.Forms.OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-196b51f1 | this.Message.CellClick [if (this.siMessage.IsLock(siMessage.… | SCM0010_Notice_Setup.cs:975 | try | POPUP | ofp.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-151a1973 | this.Message.CellClick [if (this.siMessage.IsLock(siMessage.… | SCM0010_Notice_Setup.cs:981 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3430880c | this.Message.CellClick [if (this.siMessage.IsLock(siMessage.… | SCM0010_Notice_Setup.cs:982 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) | GRID_SET | siMessage.SetValue | (row, siMessage.GetColumnIndex("NOTICE_IMAGE"), fi.Name) | 그리드 값 설정 |  |  |  |
| AC-5439fa47 | this.Message.CellClick [if (this.siMessage.IsLock(siMessage.… | SCM0010_Notice_Setup.cs:983 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) | GRID_SET | siMessage.SetValue | (row, siMessage.GetColumnIndex("NOTICE_IMAGE_ID"), notice_id) | 그리드 값 설정 |  |  |  |
| AC-1a748bd3 | this.Message.CellClick [if (this.siMessage.IsLock(siMessage.… | SCM0010_Notice_Setup.cs:984 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) | CALL_EXT | DataService.FP_DataPushFile | (fi.FullName, notice_id, "GSCM.NOTICE", "\\Image\\", true, Filter.Dictionary) | ⚠ 의미 확인 필요 |  |  |  |
| AC-334e97a3 | this.Message.CellClick [if (this.siMessage.IsLock(siMessage.… | SCM0010_Notice_Setup.cs:992 |  | RETURN | return upload; |  | 처리 중단/반환 |  |  |  |

