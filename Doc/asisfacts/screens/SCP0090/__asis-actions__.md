# AS-IS 액션 대조표 — SCP0090

> 원천: `Doc/asisfacts/screens/SCP0090/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 399행 · 메서드 52 · 종류 DATA_OP 67 · RETURN 57 · GRID_SET 44 · GRID_INIT 40 · UI_PROP 30 · CALL_EXT 24 · MESSAGE 23 · GRID_LOCK 21 · POPUP 20 · GRID_STYLE 16 · ENDPOINT 15 · FLAG 15 · UI_MISC 12 · VALUE_SET 4 · LIST_REBIND 4 · VALIDATE 3 · COMBO_DATA 2 · GRID_BIND 1 · STATE 1 · ⚠ 의미 확인 필요 24


## SCP0090_Allo_Target_Request.btnConfirm_Click

진입점: this.btnConfirm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-024c6fee | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1310 | if (!bFlag) | MESSAGE | MessageHelper.GMessageBox | ("MSG00375") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92e2f430 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1311 | if (!bFlag) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea1dadf3 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1318 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00019") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f0bc7827 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1319 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb7a71df | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1322 | if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40b5b88f | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1340 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ for (i <= … | CALL_EXT | siMain.IsLockCell | (i, siMain.GetColumnIndex(DefColumns.CHK)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-05b638a8 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1358 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | MESSAGE | MessageHelper.GMessageBox | ("MSG00021") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aaddfd86 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1359 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c23e0b1b | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1369 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | ENDPOINT | new FoxDataRequest | ("SCP.SCP0090_SAVE_ALLO_TARGET_REQUEST_CONFIRM") ⇒ SCP.SCP0090_SAVE_ALLO_TARGET_REQUEST_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-ff8c5c73 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1371 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | UI_PROP | request.CommandTimeout | 60 * 15 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8ce2c7bb | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1373 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-72a1ede9 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1374 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2cfb4eeb | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1375 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_cutoff_yyyymmdd"] | p_cutoff_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ad15550f | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1376 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_to_dept_id"] | p_to_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-2ad4fa82 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1377 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_to_item_id"] | p_to_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-9f93b75b | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1378 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_to_yyyymm"] | p_to_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-f57a24cf | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1379 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_to_qty_tobe"] | p_to_qty_tobe | 행/컬럼 값 대입 |  |  |  |
| AC-8601c53b | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1380 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_confirm_user"] | p_user_info | 행/컬럼 값 대입 |  |  |  |
| AC-e9350c8c | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1381 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_confirm_comments"] | p_confirm_comments | 행/컬럼 값 대입 |  |  |  |
| AC-be9ec866 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1383 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-69d49581 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1387 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0cbdc244 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1397 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-98737223 | this.btnConfirm.Click | SCP0090_Allo_Target_Request.cs:1403 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0090_Allo_Target_Request.BtnFromItem_Id_Click

진입점: this.BtnFromItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-220de900 | this.BtnFromItem_Id.Click | SCP0090_Allo_Target_Request.cs:1145 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d86081f4 | this.BtnFromItem_Id.Click | SCP0090_Allo_Target_Request.cs:1150 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-28c89ddc | this.BtnFromItem_Id.Click | SCP0090_Allo_Target_Request.cs:1152 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-dfe1f572 | this.BtnFromItem_Id.Click | SCP0090_Allo_Target_Request.cs:1153 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a74e1ae7 | this.BtnFromItem_Id.Click | SCP0090_Allo_Target_Request.cs:1154 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ce747326 | this.BtnFromItem_Id.Click | SCP0090_Allo_Target_Request.cs:1160 | if (popItem.ItemID != "") | VALUE_SET | txtFromModel.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0090_Allo_Target_Request.btnNew_Click

진입점: this.btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b400ee54 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1192 | if (!bFlag) | MESSAGE | MessageHelper.GMessageBox | ("MSG00371") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f13cf8e | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1193 | if (!bFlag) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dae397c5 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1201 | if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (sChk.Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa0d93f2 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1212 |  | POPUP | new SCPAnalysisAlloTargetRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0e856e8f | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1214 |  | UI_PROP | popup.Width | 800 | 속성 Width 설정 |  |  |  |
| AC-6d4e1953 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1215 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-c2b4fe47 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1217 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c59a2325 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1219 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7f150e98 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1233 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | DATA_OP | x.Field | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-c8b91d32 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1258 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | DATA_OP | siMain.Sheet(0).Rows.Add | (iRow, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-909597e2 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1262 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.INS_FLAG), "I") | 그리드 값 설정 |  |  |  |
| AC-1d1a98bc | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1264 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD), sCutOff) | 그리드 값 설정 |  |  |  |
| AC-e325b0ef | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1266 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FROM_ITEM_ID), sModelId) | 그리드 값 설정 |  |  |  |
| AC-7c440ed4 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1267 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FROM_NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-820c63d2 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1268 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FROM_DEPT_NAME), sDeptName) | 그리드 값 설정 |  |  |  |
| AC-ff4ad82b | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1269 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FROM_YYYYMM), sMonth) | 그리드 값 설정 |  |  |  |
| AC-6e5335e6 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1270 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FROM_QTY), sQty) | 그리드 값 설정 |  |  |  |
| AC-b80d83f2 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1272 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CONFIRM), "N") | 그리드 값 설정 |  |  |  |
| AC-3f72f5c4 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1273 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), UserInfoContext.Current.UserId) | 그리드 값 설정 |  |  |  |
| AC-fede145f | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1274 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_DATE), DateTime.Now.ToString("yyyy-MM-dd t… | 그리드 값 설정 |  |  |  |
| AC-67646a8a | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1277 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, iRow, "I") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0ec6a75 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1283 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.ActiveSheet.Cells.Get(iRow, siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME)).CellTyp… | textCellType1 | 그리드 속성/값 설정 |  |  |  |
| AC-eb1de883 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1283 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | CALL_EXT | siMain.ActiveSheet.Cells.Get | (iRow, siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f20f93de | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1286 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.INS_FLAG), "Y") | 그리드 값 설정 |  |  |  |
| AC-28e025e2 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1288 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TO_ITEM_ID), sModelId) | 그리드 값 설정 |  |  |  |
| AC-25d2a3e2 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1289 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TO_NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-89063fcd | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1290 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME), sDeptName) | 그리드 값 설정 |  |  |  |
| AC-5dde791c | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1291 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TO_YYYYMM), sMonth) | 그리드 값 설정 |  |  |  |
| AC-9c8e64a6 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1292 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TO_QTY), sQty) | 그리드 값 설정 |  |  |  |
| AC-763d6861 | this.btnNew.Click | SCP0090_Allo_Target_Request.cs:1293 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetReq… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CONFIRM), "N") | 그리드 값 설정 |  |  |  |

## SCP0090_Allo_Target_Request.BtnToItem_Id_Click

진입점: this.BtnToItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62c12e4f | this.BtnToItem_Id.Click | SCP0090_Allo_Target_Request.cs:1166 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c837827 | this.BtnToItem_Id.Click | SCP0090_Allo_Target_Request.cs:1171 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-752beced | this.BtnToItem_Id.Click | SCP0090_Allo_Target_Request.cs:1173 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c7221512 | this.BtnToItem_Id.Click | SCP0090_Allo_Target_Request.cs:1174 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6f3246d8 | this.BtnToItem_Id.Click | SCP0090_Allo_Target_Request.cs:1175 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-669939b9 | this.BtnToItem_Id.Click | SCP0090_Allo_Target_Request.cs:1181 | if (popItem.ItemID != "") | VALUE_SET | txtToModel.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0090_Allo_Target_Request.ChangeAllCheckboxes

진입점: this.spdMain.CellClick [if (e.ColumnHeader && siMain.ActiveSheet.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fd2018c | this.spdMain.CellClick [if (e.ColumnHeader && siMain.ActiveS… | SCP0090_Allo_Target_Request.cs:1065 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72653d1a | this.spdMain.CellClick [if (e.ColumnHeader && siMain.ActiveS… | SCP0090_Allo_Target_Request.cs:1075 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32b23384 | this.spdMain.CellClick [if (e.ColumnHeader && siMain.ActiveS… | SCP0090_Allo_Target_Request.cs:1079 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ if (!spread.IsLockCell(… | GRID_SET | spread.SetText | (i, 1, "False") | 그리드 값 설정 |  |  |  |
| AC-dd7a8876 | this.spdMain.CellClick [if (e.ColumnHeader && siMain.ActiveS… | SCP0090_Allo_Target_Request.cs:1083 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ if (!spread.IsLockCell(… | GRID_SET | spread.SetText | (i, 1, AllCheck.ToString()) | 그리드 값 설정 |  |  |  |

## SCP0090_Allo_Target_Request.ChangeCONFIRM_COMMENTS

진입점: this.spdMain.ButtonClicked [if (e.Column == siMain.GetColumnIndex(DefColumns.CHK))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a53eb875 | this.spdMain.ButtonClicked [if (e.Column == siMain.GetColumn… | SCP0090_Allo_Target_Request.cs:1437 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD), siMain.GetColumnIndex(DefColumns.CONFI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3990aeff | this.spdMain.ButtonClicked [if (e.Column == siMain.GetColumn… | SCP0090_Allo_Target_Request.cs:1439 |  | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_COMMENTS)].Locked | bCellChk | 그리드 속성/값 설정 |  |  |  |
| AC-8e844364 | this.spdMain.ButtonClicked [if (e.Column == siMain.GetColumn… | SCP0090_Allo_Target_Request.cs:1443 | if (bCellChk) | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_COMMENTS), iRow, siMain.GetColumnIndex(Def… | 그리드 표시 설정 |  |  |  |
| AC-b9452cb8 | this.spdMain.ButtonClicked [if (e.Column == siMain.GetColumn… | SCP0090_Allo_Target_Request.cs:1447 | else of (bCellChk) | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_COMMENTS), iRow, siMain.GetColumnIndex(Def… | 그리드 표시 설정 |  |  |  |

## SCP0090_Allo_Target_Request.CheckMonth

진입점: this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMM))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95b626f3 | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:357 | if (sYYYYMM.Length != 6) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a9bf3cb1 | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:367 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9f70e372 | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:375 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a7bd11e7 | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:379 | if (month > 12) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-672483dd | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:381 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.ChkItem

진입점: this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe4630d7 | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:321 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-074bb40a | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:325 | if (defaultSelectedRow == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-97e8db86 | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:327 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.ChkTeam

진입점: this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-391afeec | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:333 | lambda | DATA_OP | x.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7309cabc | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:337 | if (drTeamId == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c8e9f1a6 | this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Colu… | SCP0090_Allo_Target_Request.cs:339 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24ec6201 | this.Load | SCP0090_Allo_Target_Request.cs:194 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-09b22aa8 | this.Load | SCP0090_Allo_Target_Request.cs:195 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f79e44d | this.Load | SCP0090_Allo_Target_Request.cs:196 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0090_Allo_Target_Request.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5df37ed7 | Dispose | SCP0090_Allo_Target_Request.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0090_Allo_Target_Request.EditButton

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK)] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7710346c | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:467 | if (!bFlag) | MESSAGE | MessageHelper.GMessageBox | ("MSG00371") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a0ec9a4b | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:468 | if (!bFlag) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5807379 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:473 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad990d1a | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:475 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b5ca1158 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:480 | if (fps.Name == "spdMain") ▸ if (!siMain.IsLock(SpdSheet.shtMain)) | FLAG | bEdit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fa2a1934 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:488 | if (fps.Name == "spdMain") ▸ else of (!siMain.IsLock(SpdSheet.shtMain)) | FLAG | bEdit | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0090_Allo_Target_Request.EditOrInsertChk

진입점: this.btnNew.Click / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab1024bc | this.btnNew.Click 외 1 | SCP0090_Allo_Target_Request.cs:522 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.EditOrInsertConfirmChk

진입점: this.spdMain.CellClick / this.btnConfirm.Click / this.spdMain.ButtonClicked [if (e.Column == siMain.GetColumnIndex(DefColumns.CHK))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23ff2e2e | this.spdMain.CellClick 외 2 | SCP0090_Allo_Target_Request.cs:535 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.FindData_Main

진입점: this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3069b644 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:636 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2ccfd37b | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:640 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-75a7baa8 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:640 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-918d213a | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:641 | try | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-0765b379 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:641 | try ▸ if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13b7540c | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:644 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-547671b4 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:665 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e26083d | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:668 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0090_GET_ALLO_TARGET_REQUEST") ⇒ SCP.SCP0090_GET_ALLO_TARGET_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-bbdeb5ca | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:669 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-111b7044 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:671 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-11cf7fd9 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:672 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0d026e9b | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:673 | try ▸ lambda | DATA_OP | req.Parameters["p_from_model"] | from_model | 행/컬럼 값 대입 |  |  |  |
| AC-6dae7884 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:674 | try ▸ lambda | DATA_OP | req.Parameters["p_from_team"] | from_team | 행/컬럼 값 대입 |  |  |  |
| AC-bee6bd77 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:675 | try ▸ lambda | DATA_OP | req.Parameters["p_from_month"] | from_month | 행/컬럼 값 대입 |  |  |  |
| AC-cd407ce4 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:676 | try ▸ lambda | DATA_OP | req.Parameters["p_to_model"] | to_model | 행/컬럼 값 대입 |  |  |  |
| AC-e27d357d | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:677 | try ▸ lambda | DATA_OP | req.Parameters["p_to_team"] | to_team | 행/컬럼 값 대입 |  |  |  |
| AC-52655036 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:678 | try ▸ lambda | DATA_OP | req.Parameters["p_to_month"] | to_month | 행/컬럼 값 대입 |  |  |  |
| AC-7e13e774 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:679 | try ▸ lambda | DATA_OP | req.Parameters["p_confirmYN"] | confirmYN | 행/컬럼 값 대입 |  |  |  |
| AC-f8571f4b | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:681 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b12be035 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:682 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-66f06fa3 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:690 | try ▸ if (ds.Tables[0].Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c260b654 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:692 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d446c98d | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:693 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e4a9c4de | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:704 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-43ac8aa2 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:711 | finally | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-70d9e1cd | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:713 | finally | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD), siMain.GetColumnIndex(DefColumns.CONFI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-abade248 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:716 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0090_Allo_Target_Request.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3523af76 | this.Load | SCP0090_Allo_Target_Request.cs:121 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0090_Allo_Target_Request.Get_AlloTarget_Qty

진입점: this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID))] / this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + e.CellRange.RowCount)] / this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedlloTargetRequest.Count > 0) ▸ foreach (var item in popup.SelectedlloTargetRequest)] / this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-986812bc | this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == s… 외 3 | SCP0090_Allo_Target_Request.cs:1097 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0090_GET_ALLO_TARGET_INFO") ⇒ SCP.SCP0090_GET_ALLO_TARGET_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-3762df9a | this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == s… 외 3 | SCP0090_Allo_Target_Request.cs:1099 | try | DATA_OP | request.Parameters["p_division_id"] | sDiv | 행/컬럼 값 대입 |  |  |  |
| AC-f3041485 | this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == s… 외 3 | SCP0090_Allo_Target_Request.cs:1100 | try | DATA_OP | request.Parameters["p_cutoff_yyyymmdd"] | sCutOff | 행/컬럼 값 대입 |  |  |  |
| AC-a499508b | this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == s… 외 3 | SCP0090_Allo_Target_Request.cs:1101 | try | DATA_OP | request.Parameters["p_from_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-fde4cb74 | this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == s… 외 3 | SCP0090_Allo_Target_Request.cs:1102 | try | DATA_OP | request.Parameters["p_from_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-339c1ac1 | this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == s… 외 3 | SCP0090_Allo_Target_Request.cs:1103 | try | DATA_OP | request.Parameters["p_from_yyyymm"] | syyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-cc9ae205 | this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == s… 외 3 | SCP0090_Allo_Target_Request.cs:1105 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5d17ee0d | this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == s… 외 3 | SCP0090_Allo_Target_Request.cs:1108 | try ▸ if (response.DataSet.Tables.Count != 0) | FLAG | dtAlloTargetQty | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-6a74e8c2 | this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == s… 외 3 | SCP0090_Allo_Target_Request.cs:1113 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0090_Allo_Target_Request.GetCutoff

진입점: this.spdMain.CellClick [if (bUserRole && !bEdit)] / this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID))] / this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + e.CellRange.RowCount)] / this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5260509 | this.spdMain.CellClick [if (bUserRole && !bEdit)] 외 8 | SCP0090_Allo_Target_Request.cs:1044 |  | RETURN | return sRtnCutoff; |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a1174cb | this.Load | SCP0090_Allo_Target_Request.cs:351 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.GetItemByDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9886ed63 | this.Load | SCP0090_Allo_Target_Request.cs:173 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d1ab9cd3 | this.Load | SCP0090_Allo_Target_Request.cs:176 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0090_GET_ITEM_BY_DIVISION") ⇒ SCP.SCP0090_GET_ITEM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b2fac976 | this.Load | SCP0090_Allo_Target_Request.cs:177 | lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c35f7d53 | this.Load | SCP0090_Allo_Target_Request.cs:179 | lambda | DATA_OP | req.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-076f9035 | this.Load | SCP0090_Allo_Target_Request.cs:180 | lambda | DATA_OP | req.Parameters["p_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9bb10b52 | this.Load | SCP0090_Allo_Target_Request.cs:181 | lambda | DATA_OP | req.Parameters["p_scm_site_id"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-d0575287 | this.Load | SCP0090_Allo_Target_Request.cs:182 | lambda | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-40130dd3 | this.Load | SCP0090_Allo_Target_Request.cs:184 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-291a2441 | this.Load | SCP0090_Allo_Target_Request.cs:185 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ab9d2a12 | this.Load | SCP0090_Allo_Target_Request.cs:189 |  | FLAG | dtItem | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0090_Allo_Target_Request.GetNextMonday

진입점: this.spdMain.CellClick [if (bUserRole && !bEdit) ▸ if (date.DayOfWeek == DayOfWeek.Friday \|\| date.DayOfWeek == DayOfWeek.Saturday \|\| date.DayOfWeek == DayOfWeek.Sunday)] / this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (date.DayOfWeek == DayOfWeek.Friday \|\| date.DayOfWeek == DayOfWeek.Saturday \|\| date.DayOfWeek == DayOfWeek.Sunday)] / this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (date.DayOfWeek == DayOfWeek.Friday \|\| date.DayOfWeek == DayOfWeek.Saturday \|\| date.DayOfWeek == DayO…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9c64935 | this.spdMain.CellClick [if (bUserRole && !bEdit) ▸ if (date.… 외 9 | SCP0090_Allo_Target_Request.cs:1054 |  | RETURN | return from.AddDays(target - start); |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f7a071c | this.Load | SCP0090_Allo_Target_Request.cs:139 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fce80e52 | this.Load | SCP0090_Allo_Target_Request.cs:142 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-48811882 | this.Load | SCP0090_Allo_Target_Request.cs:143 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c8b45c27 | this.Load | SCP0090_Allo_Target_Request.cs:147 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-ad4363a2 | this.Load | SCP0090_Allo_Target_Request.cs:147 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9b529c69 | this.Load | SCP0090_Allo_Target_Request.cs:149 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, cboFromTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ecfb698c | this.Load | SCP0090_Allo_Target_Request.cs:150 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, cboToTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0dc06ddf | this.Load | SCP0090_Allo_Target_Request.cs:153 |  | LIST_REBIND | cboConfirmYN.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-bc05581b | this.Load | SCP0090_Allo_Target_Request.cs:154 |  | VALUE_SET | cboConfirmYN.SelectedValue | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-dac827e1 | this.Load | SCP0090_Allo_Target_Request.cs:156 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-a65404b0 | this.Load | SCP0090_Allo_Target_Request.cs:160 | if (sUserGroup == "SCM PI Admin" \|\| sUserGroup == "SCP Planner") | FLAG | bUserRole | true | 화면 필드/플래그 변경 |  |  |  |
| AC-04de5825 | this.Load | SCP0090_Allo_Target_Request.cs:164 | else of (sUserGroup == "SCM PI Admin" \|\| sUserGroup == "SCP Planner") | FLAG | bUserRole | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0090_Allo_Target_Request.InitSpread

진입점: this.Load / this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a83eb146 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:204 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-a86b5ac4 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:206 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-23812593 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:207 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddCheckColumn | ("chk", DefColumns.CHK, FPMerge.None, 30, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48a349fa | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:208 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Seq", DefColumns.SEQ, FPMerge.None, 30, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-457f2f90 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:209 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumTextColumn | ("CutOff*", DefColumns.CUTOFF_YYYYMMDD, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10158018 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:211 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Model*", DefColumns.FROM_ITEM_ID, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4bace57 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:212 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("NickName", DefColumns.FROM_NICK_NAME, FPMerge.None, 130, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a811a06f | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:213 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Deptid", DefColumns.FROM_DEPT_ID, FPMerge.None, 70, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a9ca426 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:214 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Dept*", DefColumns.FROM_DEPT_NAME, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7eaa8a3c | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:215 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumTextColumn | ("Month*", DefColumns.FROM_YYYYMM, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72624076 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:216 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | ("Qty*", DefColumns.FROM_QTY, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c0379256 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:218 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Model*", DefColumns.TO_ITEM_ID, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-207f8efe | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:219 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("NickName", DefColumns.TO_NICK_NAME, FPMerge.None, 130, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bbda300 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:220 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Deptid", DefColumns.TO_DEPT_ID, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e3a0b637 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:221 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | ("Dept*", DefColumns.TO_DEPT_NAME, FPMerge.None, 160, true, dtTeam, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c92944a | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:222 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumTextColumn | ("Month*", DefColumns.TO_YYYYMM, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6a0f048 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:223 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | ("Qty(AsIs)", DefColumns.TO_QTY, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e99bb4e7 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:224 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | ("Qty(ToBe)*", DefColumns.TO_QTY_TOBE, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4be22e42 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:225 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Remark", DefColumns.COMMENTS, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33e49f8b | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:226 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Confirm", DefColumns.CONFIRM, FPMerge.None, 50, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb74137e | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:227 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Confirm\nRemark", DefColumns.CONFIRM_COMMENTS, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dfb2734d | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:228 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Request_User", DefColumns.REQUEST_USER, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-485a40d4 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:229 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddDateTimeColumn | ("Request_Date", DefColumns.REQUEST_DATE, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce2861bd | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:230 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Confirm_User", DefColumns.CONFIRM_USER, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74285cab | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:231 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddDateTimeColumn | ("Confirm_Date", DefColumns.CONFIRM_DATE, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1ed83e4 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:233 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Ins_Flag", DefColumns.INS_FLAG, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e93abf2 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:235 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-abf30df6 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:236 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.COMMENTS)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d602625 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:237 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CONFIRM)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1060a180 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:238 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CONFIRM_COMMENTS)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a388c3a0 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:240 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROM_ITEM_ID), 1, 6, 25, "From", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-617b3262 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:241 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TO_ITEM_ID), 1, 7, 25, "To", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce6a86f0 | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:242 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.REQUEST_USER), 1, 4, 25, "Result", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cdc72a3e | this.Load 외 3 | SCP0090_Allo_Target_Request.cs:247 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0090_Allo_Target_Request.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7504b293 | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:985 | if (bUserRole) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-06312986 | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:989 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-79f955ba | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:992 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.CONFIRM, "N") | 데이터 객체 조작/조회 |  |  |  |
| AC-30f894fa | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:993 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.REQUEST_USER, UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-07e06422 | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:994 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.REQUEST_DATE, DateTime.Now.ToString("yyyy-MM-dd tt hh:mm:ss")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fbbf212 | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:1003 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (date.DayOfWeek == DayOfWeek.Friday \|\| date.DayOfWeek == DayOfWeek.Sa… | DATA_OP | defaultData.Add | (DefColumns.CUTOFF_YYYYMMDD, GetNextMonday(DateTime.Today, DayOfWeek.Monday).ToString("yyy… | 데이터 객체 조작/조회 |  |  |  |
| AC-0c6deedf | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:1007 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (date.DayOfWeek == DayOfWeek.Friday \|\| date.DayOfWeek == DayOfWe… | DATA_OP | defaultData.Add | (DefColumns.CUTOFF_YYYYMMDD, DateTime.Now.ToString("yyyyMMdd")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0904144f | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:1010 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-e5270e5e | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:1013 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5dec130 | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:1014 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.FROM_NICK_NAME), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-98087acd | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:1015 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_NICK_NAME), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0471905c | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:1016 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CONFIRM), siMain.GetColumnIndex(DefColumns.CONF… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec9916a7 | (진입점 미연결) | SCP0090_Allo_Target_Request.cs:1018 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.REQUEST_USER), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0090_Allo_Target_Request.Re_Design

진입점: this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally] / FindButton [finally] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3879d582 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:1627 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if ("Y" == sConfirmYN \|\| iCompare > 0) | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(DefColumns.CHK), "True") | 그리드 값 설정 |  |  |  |
| AC-3c0b2057 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:1628 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if ("Y" == sConfirmYN \|\| iCompare > 0) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-653fec77 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:1632 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ else of ("Y" == sConfirmYN \|\| iCompare > 0) | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(DefColumns.CHK), "False") | 그리드 값 설정 |  |  |  |
| AC-1b7a8c59 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:1637 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0090_Allo_Target_Request.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96a1bb6c | SaveButton | SCP0090_Allo_Target_Request.cs:778 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-487a7d1d | SaveButton | SCP0090_Allo_Target_Request.cs:780 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-f1bad9c2 | SaveButton | SCP0090_Allo_Target_Request.cs:780 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d455e788 | SaveButton | SCP0090_Allo_Target_Request.cs:782 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-316e7782 | SaveButton | SCP0090_Allo_Target_Request.cs:823 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00372") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7807d803 | SaveButton | SCP0090_Allo_Target_Request.cs:824 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_SET | siMain.ActiveSheet.Cells.Get(i, siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD)).Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-eaa113bf | SaveButton | SCP0090_Allo_Target_Request.cs:824 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | CALL_EXT | siMain.ActiveSheet.Cells.Get | (i, siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-75d2c50b | SaveButton | SCP0090_Allo_Target_Request.cs:825 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6890318 | SaveButton | SCP0090_Allo_Target_Request.cs:832 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00373") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb9cd8f2 | SaveButton | SCP0090_Allo_Target_Request.cs:833 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60da1ae6 | SaveButton | SCP0090_Allo_Target_Request.cs:848 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "Plant Qty : 9,999,999,999" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d679ccca | SaveButton | SCP0090_Allo_Target_Request.cs:849 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67dd1e67 | SaveButton | SCP0090_Allo_Target_Request.cs:878 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | x.Field | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-162e826b | SaveButton | SCP0090_Allo_Target_Request.cs:912 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3d3346a4 | SaveButton | SCP0090_Allo_Target_Request.cs:917 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0090_SAVE_ALLO_TARGET_REQUEST") ⇒ SCP.SCP0090_SAVE_ALLO_TARGET_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-9675dd0c | SaveButton | SCP0090_Allo_Target_Request.cs:919 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | UI_PROP | request.CommandTimeout | 60 * 15 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5e2d9c43 | SaveButton | SCP0090_Allo_Target_Request.cs:920 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | strACTIVE_FLAG | 행/컬럼 값 대입 |  |  |  |
| AC-6d438dc2 | SaveButton | SCP0090_Allo_Target_Request.cs:922 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division"] | strDIVISION | 행/컬럼 값 대입 |  |  |  |
| AC-10261ef6 | SaveButton | SCP0090_Allo_Target_Request.cs:923 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_seq"] | strSEQ | 행/컬럼 값 대입 |  |  |  |
| AC-f8ef99df | SaveButton | SCP0090_Allo_Target_Request.cs:924 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cutoff_yyyymmdd"] | strCUTOFF_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-f9de8245 | SaveButton | SCP0090_Allo_Target_Request.cs:925 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_item_id"] | strFROM_ITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b082e873 | SaveButton | SCP0090_Allo_Target_Request.cs:926 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_dept_id"] | strFROM_DEPT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-ad69f98e | SaveButton | SCP0090_Allo_Target_Request.cs:927 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_dept_name"] | strFROM_DEPT_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-d621d710 | SaveButton | SCP0090_Allo_Target_Request.cs:928 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_yyyymm"] | strFROM_YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-9942344c | SaveButton | SCP0090_Allo_Target_Request.cs:929 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_qty"] | strFROM_QTY | 행/컬럼 값 대입 |  |  |  |
| AC-0377451f | SaveButton | SCP0090_Allo_Target_Request.cs:930 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_item_id"] | strTO_ITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-25dee171 | SaveButton | SCP0090_Allo_Target_Request.cs:931 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_dept_id"] | strTO_DEPT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-54125501 | SaveButton | SCP0090_Allo_Target_Request.cs:932 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_dept_name"] | strTO_DEPT_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-595d4da6 | SaveButton | SCP0090_Allo_Target_Request.cs:933 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_yyyymm"] | strTO_YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-7db55da1 | SaveButton | SCP0090_Allo_Target_Request.cs:934 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_qty"] | strTO_QTY | 행/컬럼 값 대입 |  |  |  |
| AC-dd1e1e1b | SaveButton | SCP0090_Allo_Target_Request.cs:935 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_qty_tobe"] | strTO_QTY_TOBE | 행/컬럼 값 대입 |  |  |  |
| AC-dd8019dd | SaveButton | SCP0090_Allo_Target_Request.cs:936 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_comments"] | strCOMMENTS | 행/컬럼 값 대입 |  |  |  |
| AC-87b94ff6 | SaveButton | SCP0090_Allo_Target_Request.cs:937 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_confirm"] | strCONFIRM | 행/컬럼 값 대입 |  |  |  |
| AC-62cb32d6 | SaveButton | SCP0090_Allo_Target_Request.cs:938 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_confirm_comments"] | strCONFIRM_COMMENTS | 행/컬럼 값 대입 |  |  |  |
| AC-9ca2fa86 | SaveButton | SCP0090_Allo_Target_Request.cs:939 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_request_user"] | strREQUEST_USER | 행/컬럼 값 대입 |  |  |  |
| AC-0de08e92 | SaveButton | SCP0090_Allo_Target_Request.cs:940 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_request_date"] | strREQUEST_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-38e42979 | SaveButton | SCP0090_Allo_Target_Request.cs:941 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_confirm_user"] | strCONFIRM_USER | 행/컬럼 값 대입 |  |  |  |
| AC-6250cb23 | SaveButton | SCP0090_Allo_Target_Request.cs:942 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_confirm_date"] | strCONFIRM_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-d1bcd858 | SaveButton | SCP0090_Allo_Target_Request.cs:944 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7ba719c | SaveButton | SCP0090_Allo_Target_Request.cs:948 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-479cc805 | SaveButton | SCP0090_Allo_Target_Request.cs:949 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7227b37d | SaveButton | SCP0090_Allo_Target_Request.cs:955 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6f109e96 | SaveButton | SCP0090_Allo_Target_Request.cs:963 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-432dd3f6 | SaveButton | SCP0090_Allo_Target_Request.cs:969 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bdc9bfec | SaveButton | SCP0090_Allo_Target_Request.cs:970 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-337de10c | SaveButton | SCP0090_Allo_Target_Request.cs:974 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0090_Allo_Target_Request.SetBtnConfirm

진입점: this.Load / this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount)] / this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (!siMain.IsLock(SpdSheet.shtMain))] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount)] / EditButton [if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec7e978f | this.Load 외 5 | SCP0090_Allo_Target_Request.cs:410 | if (bConfirmVisible) ▸ switch (UserInfoContext.Current["NowGroupID"]) case "SCM PI Admin": | UI_PROP | layoutConfirm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a3affe6f | this.Load 외 5 | SCP0090_Allo_Target_Request.cs:411 | if (bConfirmVisible) ▸ switch (UserInfoContext.Current["NowGroupID"]) case "SCM PI Admin": | UI_PROP | layoutNew.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0f3d8863 | this.Load 외 5 | SCP0090_Allo_Target_Request.cs:414 | if (bConfirmVisible) ▸ switch (UserInfoContext.Current["NowGroupID"]) case "SCP Planner": | UI_PROP | layoutConfirm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c01089e0 | this.Load 외 5 | SCP0090_Allo_Target_Request.cs:415 | if (bConfirmVisible) ▸ switch (UserInfoContext.Current["NowGroupID"]) case "SCP Planner": | UI_PROP | layoutNew.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-024080a3 | this.Load 외 5 | SCP0090_Allo_Target_Request.cs:418 | if (bConfirmVisible) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutConfirm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e06779e6 | this.Load 외 5 | SCP0090_Allo_Target_Request.cs:419 | if (bConfirmVisible) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutNew.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-97102e1c | this.Load 외 5 | SCP0090_Allo_Target_Request.cs:425 | else of (bConfirmVisible) | UI_PROP | layoutConfirm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6202644a | this.Load 외 5 | SCP0090_Allo_Target_Request.cs:426 | else of (bConfirmVisible) | UI_PROP | layoutNew.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0090_Allo_Target_Request.SetChkVisible

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally] / this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [finally] / EditButton [if (fps.Name == "spdMain")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97e209c6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0090_Allo_Target_Request.cs:618 | if (bUserRole) | GRID_STYLE | siMain.Sheet(0).SetColumnVisible | (siMain.GetColumnIndex(DefColumns.CHK), true) | 그리드 표시 설정 |  |  |  |
| AC-ccc1acc2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0090_Allo_Target_Request.cs:622 | else of (bUserRole) | GRID_STYLE | siMain.Sheet(0).SetColumnVisible | (siMain.GetColumnIndex(DefColumns.CHK), false) | 그리드 표시 설정 |  |  |  |

## SCP0090_Allo_Target_Request.SetEdit

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (!siMain.IsLock(SpdSheet.shtMain))] / EditButton [if (fps.Name == "spdMain") ▸ if (!siMain.IsLock(SpdSheet.shtMain))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ad18630 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:544 | if (!bLock) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.CONFIRM_DATE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dee7db79 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:565 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.FlagI) | CALL_EXT | CUIControl.SetActionFlag | (spdMain, iRow, "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-aacba153 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:571 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-814d65fe | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:575 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ if (bUserRole) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_COMMENTS), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-37c34d9e | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:576 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ if (bUserRole) | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_COMMENTS), iRow, siMain.GetColumnIndex(Def… | 그리드 표시 설정 |  |  |  |
| AC-974ef979 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:583 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.TO_QTY_TOBE), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d12ba0f2 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:584 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.TO_QTY_TOBE), iRow, siMain.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-5752bb62 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:588 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.TO_ITEM_ID), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e33f0aca | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:589 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b183e28a | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:590 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.TO_YYYYMM), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-54818a31 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:591 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.TO_QTY_TOBE), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b16e621c | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:592 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.COMMENTS), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-20cc7e0c | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:594 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.TO_ITEM_ID), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |
| AC-abcf02a1 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:595 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME), iRow, siMain.GetColumnIndex(DefColu… | 그리드 표시 설정 |  |  |  |
| AC-14cad4e3 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:596 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.TO_YYYYMM), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-b8130b7e | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:597 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.TO_QTY_TOBE), iRow, siMain.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-035fc1d2 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:598 | if (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sConfirmYN.Equals("N") \|\| string.IsNullOrEmpty(sConfirmYN)) ▸ else of (bUserRole… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.COMMENTS), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-f689f86f | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:606 | else of (!bLock) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CHK), siMain.GetColumnIndex(DefColumns.CHK), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-78c49060 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 1 | SCP0090_Allo_Target_Request.cs:609 | else of (!bLock) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD), iRow, siMain.GetColumnIndex(DefC… | 그리드 표시 설정 |  |  |  |

## SCP0090_Allo_Target_Request.SetHeaderCheckBox

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (!siMain.IsLock(SpdSheet.shtMain))] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / EditButton [if (fps.Name == "spdMain") ▸ if (!siMain.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09ca3b50 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0090_Allo_Target_Request.cs:391 | if (bCheckVisible) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-994b240a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0090_Allo_Target_Request.cs:392 | if (bCheckVisible) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-c4015a4f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0090_Allo_Target_Request.cs:393 | if (bCheckVisible) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-26cd9ed6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0090_Allo_Target_Request.cs:398 | else of (bCheckVisible) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].CellType | txt | 그리드 속성/값 설정 |  |  |  |
| AC-1a9f4add | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0090_Allo_Target_Request.cs:399 | else of (bCheckVisible) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | "" | 그리드 속성/값 설정 |  |  |  |

## SCP0090_Allo_Target_Request.SetRowSpan

진입점: this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3062d22d | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:747 | for (i <= iEndCol) ▸ for (j <= iEndRow) ▸ if (sOldCutOff != siMain.GetText(j, siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD)) \|\| sOldMo… | GRID_STYLE | siMain.SpreadObject.Sheets[0].AddSpanCell | (iFRow, i, iLRow - 1, 1) | 그리드 표시 설정 |  |  |  |
| AC-329e5028 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:759 | for (i <= iEndCol) ▸ for (j <= iEndRow) ▸ if (j == iEndRow) | GRID_STYLE | siMain.SpreadObject.Sheets[0].AddSpanCell | (iFRow, i, iLRow, 1) | 그리드 표시 설정 |  |  |  |
| AC-a38229f9 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:767 |  | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Left | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-209c3160 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0090_Allo_Target_Request.cs:768 |  | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |

## SCP0090_Allo_Target_Request.SetToQty

진입점: this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID))] / this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + e.CellRange.RowCount)] / this.spdMain.Change [if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME) \|…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a12dcc19 | this.spdMain.CellDoubleClick [if (bEdit) ▸ if (e.Column == s… 외 2 | SCP0090_Allo_Target_Request.cs:1137 |  | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TO_QTY), sQty) | 그리드 값 설정 |  |  |  |

## SCP0090_Allo_Target_Request.SpdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73feab06 | this.spdMain.ButtonClicked | SCP0090_Allo_Target_Request.cs:1423 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (!bFlag) | MESSAGE | MessageHelper.GMessageBox | ("MSG00375") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00abfdc3 | this.spdMain.ButtonClicked | SCP0090_Allo_Target_Request.cs:1424 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (!bFlag) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa487551 | this.spdMain.CellClick | SCP0090_Allo_Target_Request.cs:1453 | if (e.Column != siMain.GetColumnIndex(DefColumns.CHK)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cf7d55d | this.spdMain.CellClick | SCP0090_Allo_Target_Request.cs:1458 | if (!bFlag) | MESSAGE | MessageHelper.GMessageBox | ("MSG00375") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51e34794 | this.spdMain.CellClick | SCP0090_Allo_Target_Request.cs:1459 | if (!bFlag) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-248a1361 | this.spdMain.CellClick | SCP0090_Allo_Target_Request.cs:1488 | if (bUserRole && !bEdit) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (bCellChk) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CONFIRM_COMMENTS), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3b3a3f9 | this.spdMain.CellClick | SCP0090_Allo_Target_Request.cs:1489 | if (bUserRole && !bEdit) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (bCellChk) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CONFIRM_COMMENTS), i, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |
| AC-8464e37b | this.spdMain.CellClick | SCP0090_Allo_Target_Request.cs:1493 | if (bUserRole && !bEdit) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (bCellChk) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CONFIRM_COMMENTS), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8eb7aef0 | this.spdMain.CellClick | SCP0090_Allo_Target_Request.cs:1494 | if (bUserRole && !bEdit) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (bCellChk) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CONFIRM_COMMENTS), i, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |

## SCP0090_Allo_Target_Request.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3fb500c | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1503 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc974299 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1506 | if (bUserRole) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-189ca11c | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1510 | if (sConfirm == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1765a9d | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1519 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) | POPUP | new SCPAnalysisUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ae4a5f44 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1521 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-5f700af2 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1522 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-36cce1d5 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1523 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-604da379 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1525 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-a13c4819 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1527 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-408b19e7 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1534 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.Select… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.REQUEST_USER), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-ed4d5277 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1535 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.Select… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.REQUEST_DATE), DateTime.Now.ToString("yyyy-MM-dd … | 그리드 값 설정 |  |  |  |
| AC-9c3ed5fe | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1536 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.Select… | GRID_SET | siMain.ActiveSheet.Cells.Get(e.Row, e.Column).ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ea1ec979 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1536 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.Select… | CALL_EXT | siMain.ActiveSheet.Cells.Get | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f358f3f | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1539 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER)) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.Select… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d514f4c0 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1549 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (sIns_Flag.Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0968946 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1560 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (iCompare > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e3d65b9 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1567 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9d5b877c | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1569 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d3386272 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1570 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6f9ec5cd | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1571 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e548b445 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1575 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (string.IsNullOrEmpty(sItemId)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79e5b232 | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1579 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-b359a03a | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1580 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) | GRID_SET | siMain.ActiveSheet.Cells.Get(e.Row, e.Column).ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-dc8eeceb | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1580 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) | CALL_EXT | siMain.ActiveSheet.Cells.Get | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-212b262f | this.spdMain.CellDoubleClick | SCP0090_Allo_Target_Request.cs:1591 | if (bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (vAction == "") | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row, "M") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0090_Allo_Target_Request.SpdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-756a3638 | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:276 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (!ChkItem(sToItemId)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00374") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11a3a9c4 | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:277 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (!ChkItem(sToItemId)) | GRID_SET | siMain.ActiveSheet.Cells.Get(e.Row, siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)).Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-6d68d2ae | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:277 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (!ChkItem(sToItemId)) | CALL_EXT | siMain.ActiveSheet.Cells.Get | (e.Row, siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0eecf39f | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:278 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) ▸ if (!ChkItem(sToItemId)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84374631 | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:289 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME)) ▸ if (!ChkTeam(sToDeptId)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00377") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-305ad5ef | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:290 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME)) ▸ if (!ChkTeam(sToDeptId)) | GRID_SET | siMain.ActiveSheet.Cells.Get(e.Row, siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)).Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-6e4ce593 | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:290 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME)) ▸ if (!ChkTeam(sToDeptId)) | CALL_EXT | siMain.ActiveSheet.Cells.Get | (e.Row, siMain.GetColumnIndex(DefColumns.TO_ITEM_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d047a8d6 | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:291 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_DEPT_NAME)) ▸ if (!ChkTeam(sToDeptId)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24738aa0 | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:300 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMM)) ▸ if (!CheckMonth(syyyymm)) | GRID_SET | siMain.ActiveSheet.Cells.Get(e.Row, siMain.GetColumnIndex(DefColumns.TO_YYYYMM)).Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-dff0a112 | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:300 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMM)) ▸ if (!CheckMonth(syyyymm)) | CALL_EXT | siMain.ActiveSheet.Cells.Get | (e.Row, siMain.GetColumnIndex(DefColumns.TO_YYYYMM)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00067567 | this.spdMain.Change | SCP0090_Allo_Target_Request.cs:301 | if ((!bUserRole) && bEdit) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMM)) ▸ if (!CheckMonth(syyyymm)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0e5d2e3 | this.spdMain.ClipboardPasted | SCP0090_Allo_Target_Request.cs:1649 | if (bUserRole) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0090_Allo_Target_Request.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35db2ef2 | this.spdMain.ComboSelChange | SCP0090_Allo_Target_Request.cs:432 |  | GRID_SET | siMain.ActiveSheet.Cells.Get(e.Row, e.Column).ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-88ae6db5 | this.spdMain.ComboSelChange | SCP0090_Allo_Target_Request.cs:432 |  | CALL_EXT | siMain.ActiveSheet.Cells.Get | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.BtnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b99ffb21 | this.btnButtonList.UsrButtonList_Click_Detected | SCPAnalysisAlloTargetRequestPopup.cs:161 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_PROP | this.DialogResult | DialogResult.No | 속성 DialogResult 설정 |  |  |  |
| AC-beb33df3 | this.btnButtonList.UsrButtonList_Click_Detected | SCPAnalysisAlloTargetRequestPopup.cs:162 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.CheckMonth

진입점: this.spdMain.Change [else of (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MONTH))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-802f5456 | this.spdMain.Change [else of (e.Column == siMain.GetColumnIn… | SCPAnalysisAlloTargetRequestPopup.cs:334 | if (sYYYYMM.Length != 6) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a3b31b33 | this.spdMain.Change [else of (e.Column == siMain.GetColumnIn… | SCPAnalysisAlloTargetRequestPopup.cs:344 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bd0e481a | this.spdMain.Change [else of (e.Column == siMain.GetColumnIn… | SCPAnalysisAlloTargetRequestPopup.cs:352 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0be5b63b | this.spdMain.Change [else of (e.Column == siMain.GetColumnIn… | SCPAnalysisAlloTargetRequestPopup.cs:356 | if (month > 12) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5de21ee0 | this.spdMain.Change [else of (e.Column == siMain.GetColumnIn… | SCPAnalysisAlloTargetRequestPopup.cs:358 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.CheckRequiredOfSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7546b910 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCPAnalysisAlloTargetRequestPopup.cs:318 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14e12736 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCPAnalysisAlloTargetRequestPopup.cs:319 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-efc8eb17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCPAnalysisAlloTargetRequestPopup.cs:326 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-5408a036 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCPAnalysisAlloTargetRequestPopup.cs:328 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ff97740 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:105 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6f5002df | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:106 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c89724a | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:107 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ae97f14 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:116 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ee1a5de | Dispose | SCPAnalysisAlloTargetRequestPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3e620f2 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:83 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.GetItemByDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cca9ad15 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:275 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-122a7c83 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:278 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0090_GET_ITEM_BY_DIVISION") ⇒ SCP.SCP0090_GET_ITEM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-dbc13ded | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:279 | lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0af96b5b | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:281 | lambda | DATA_OP | req.Parameters["p_division_id"] | "40" | 행/컬럼 값 대입 |  |  |  |
| AC-86c0b2b7 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:282 | lambda | DATA_OP | req.Parameters["p_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1284f0b | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:283 | lambda | DATA_OP | req.Parameters["p_scm_site_id"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-17f3cc9f | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:284 | lambda | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5a59e65a | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:286 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d61e96dd | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:287 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b1ee8e54 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:291 |  | FLAG | dtItem | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d74bd4c | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:100 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-e949bf0e | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:100 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12be2cfc | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:121 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ee5ae98f | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:123 |  | GRID_INIT | siMain.AddTextColumn | ("Model*", DefColumns.MODEL_ID, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e9acc03 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:125 |  | GRID_INIT | siMain.AddComboColumn | ("Dept*", DefColumns.DEPT_NAME, FPMerge.None, 160, true, dtTeam, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-122386bb | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:126 |  | GRID_INIT | siMain.AddNumTextColumn | ("Month*", DefColumns.MONTH, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-efdfd6b6 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:127 |  | GRID_INIT | siMain.AddNumColumn | ("Row*", DefColumns.ROW_COUNT, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.InsertRow

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dcca507 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:257 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Sheet(0).Rows.Add | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-48201636 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:263 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | range1.ForeColor | Color.Red | 속성 ForeColor 설정 |  |  |  |
| AC-8d3f8180 | this.Load | SCPAnalysisAlloTargetRequestPopup.cs:264 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | range1.BackColor | ControlColor.UnLockColor | 속성 BackColor 설정 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.OkButtonClick

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29f8040a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCPAnalysisAlloTargetRequestPopup.cs:227 | if (!CheckRequiredOfSpread()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-acc62b76 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCPAnalysisAlloTargetRequestPopup.cs:233 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | lstInfo.Add | (new SelectedlloTargetRequest() { MODEL_ID = siMain.GetText(i, siMain.GetColumnIndex(DefCo… | 데이터 객체 조작/조회 |  |  |  |
| AC-2944290c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCPAnalysisAlloTargetRequestPopup.cs:242 |  | FLAG | SelectedlloTargetRequest | lstInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-40828f31 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCPAnalysisAlloTargetRequestPopup.cs:245 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5aef609 | this.spdMain.CellDoubleClick | SCPAnalysisAlloTargetRequestPopup.cs:184 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4c03bed9 | this.spdMain.CellDoubleClick | SCPAnalysisAlloTargetRequestPopup.cs:186 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-b01337cd | this.spdMain.CellDoubleClick | SCPAnalysisAlloTargetRequestPopup.cs:187 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b65b82e1 | this.spdMain.CellDoubleClick | SCPAnalysisAlloTargetRequestPopup.cs:188 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7a87964f | this.spdMain.CellDoubleClick | SCPAnalysisAlloTargetRequestPopup.cs:192 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) ▸ if (string.IsNullOrEmpty(sItemId)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddd95d44 | this.spdMain.CellDoubleClick | SCPAnalysisAlloTargetRequestPopup.cs:194 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MODEL_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-b49b6cf9 | this.spdMain.CellDoubleClick | SCPAnalysisAlloTargetRequestPopup.cs:195 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) | GRID_SET | siMain.ActiveSheet.Cells.Get(e.Row, e.Column).ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-0ac23293 | this.spdMain.CellDoubleClick | SCPAnalysisAlloTargetRequestPopup.cs:195 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) | CALL_EXT | siMain.ActiveSheet.Cells.Get | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |

## SCPAnalysisAlloTargetRequestPopup.SpdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-179b990f | this.spdMain.Change | SCPAnalysisAlloTargetRequestPopup.cs:205 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b2d6a5ed | this.spdMain.Change | SCPAnalysisAlloTargetRequestPopup.cs:209 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) ▸ if (defaultSelectedRow == null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00374") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b19acd64 | this.spdMain.Change | SCPAnalysisAlloTargetRequestPopup.cs:210 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) ▸ if (defaultSelectedRow == null) | GRID_SET | siMain.ActiveSheet.Cells.Get(e.Row, siMain.GetColumnIndex(DefColumns.MODEL_ID)).Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-eab364e0 | this.spdMain.Change | SCPAnalysisAlloTargetRequestPopup.cs:210 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) ▸ if (defaultSelectedRow == null) | CALL_EXT | siMain.ActiveSheet.Cells.Get | (e.Row, siMain.GetColumnIndex(DefColumns.MODEL_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7504183 | this.spdMain.Change | SCPAnalysisAlloTargetRequestPopup.cs:211 | if (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) ▸ if (defaultSelectedRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b957890e | this.spdMain.Change | SCPAnalysisAlloTargetRequestPopup.cs:219 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MONTH)) ▸ if (!CheckMont… | GRID_SET | siMain.ActiveSheet.Cells.Get(e.Row, siMain.GetColumnIndex(DefColumns.MONTH)).Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-1475bd02 | this.spdMain.Change | SCPAnalysisAlloTargetRequestPopup.cs:219 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MONTH)) ▸ if (!CheckMont… | CALL_EXT | siMain.ActiveSheet.Cells.Get | (e.Row, siMain.GetColumnIndex(DefColumns.MONTH)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6efb01b | this.spdMain.Change | SCPAnalysisAlloTargetRequestPopup.cs:220 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MODEL_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MONTH)) ▸ if (!CheckMont… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

