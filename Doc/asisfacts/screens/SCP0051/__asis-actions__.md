# AS-IS 액션 대조표 — SCP0051

> 원천: `Doc/asisfacts/screens/SCP0051/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 352행 · 메서드 33 · 종류 DATA_OP 129 · GRID_SET 50 · FLAG 30 · RETURN 20 · UI_PROP 19 · ENDPOINT 18 · MESSAGE 17 · GRID_LOCK 12 · GRID_COMBO 12 · CALL_EXT 11 · POPUP 10 · GRID_INIT 8 · UI_MISC 4 · VALIDATE 3 · LIST_REBIND 3 · COMBO_DATA 3 · VALUE_SET 1 · GRID_STYLE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 11


## SCP0051_ProductionPlanTarget.btnConfirm_Click

진입점: this.btnConfirm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-798203d3 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:832 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00019") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54d38907 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:833 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-240a0660 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:836 | if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-704ca480 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:847 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ for (i <= … | CALL_EXT | siMain.IsLockCell | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79b67281 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:857 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | MESSAGE | MessageHelper.GMessageBox | ("MSG00021") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54fc2ecc | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:858 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d1ee844 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:863 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | ENDPOINT | new FoxDataRequest | ("SCP.SCP0051_SAVE_PRODUCTION_PLAN_TARGET_CONFIRM") ⇒ SCP.SCP0051_SAVE_PRODUCTION_PLAN_TARGET_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-bf1e08b3 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:867 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a164fd3e | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:871 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_target_id"] | p_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-430f11e4 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:872 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | DATA_OP | request.Parameters["p_confirm_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-59e21584 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:874 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b02043a3 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:874 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-19640d05 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:883 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-240b8c08 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:895 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fcd88356 | this.btnConfirm.Click | SCP0051_ProductionPlanTarget.cs:899 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0051_ProductionPlanTarget.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68bf04bb | this.btnItemId.Click | SCP0051_ProductionPlanTarget.cs:807 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3cfa9556 | this.btnItemId.Click | SCP0051_ProductionPlanTarget.cs:812 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a4eb27e0 | this.btnItemId.Click | SCP0051_ProductionPlanTarget.cs:814 |  | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-dbc300c6 | this.btnItemId.Click | SCP0051_ProductionPlanTarget.cs:815 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-56ad8a1d | this.btnItemId.Click | SCP0051_ProductionPlanTarget.cs:816 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ecfc0941 | this.btnItemId.Click | SCP0051_ProductionPlanTarget.cs:822 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.ChangeAllCheckboxes

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ece372dd | this.spdMain.CellClick | SCP0051_ProductionPlanTarget.cs:774 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d60542a6 | this.spdMain.CellClick | SCP0051_ProductionPlanTarget.cs:785 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36d67b27 | this.spdMain.CellClick | SCP0051_ProductionPlanTarget.cs:789 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ if (!spread.IsLockCell(… | GRID_SET | spread.SetText | (i, 1, "False") | 그리드 값 설정 |  |  |  |
| AC-8b1e09bf | this.spdMain.CellClick | SCP0051_ProductionPlanTarget.cs:793 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ if (!spread.IsLockCell(… | GRID_SET | spread.SetText | (i, 1, AllCheck.ToString()) | 그리드 값 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.CheckExistsDomestic

진입점: spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (division.Substring(0, 2).Equals("EE") && originDivId == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e85c1e2 | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… | SCP0051_ProductionPlanTarget.cs:1529 |  | ENDPOINT | CommonUtils.FindData | (dtDomestic, colPlant, plantID) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e0b0a76 | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… | SCP0051_ProductionPlanTarget.cs:1534 |  | RETURN | return isExists; |  | 처리 중단/반환 |  |  |  |

## SCP0051_ProductionPlanTarget.CheckSaveDomestic

진입점: this.spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (pop.selectedItemId != "")] / spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (division.Substring(0, 2).Equals("EE") && originDivId == "")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d78280d4 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 2 | SCP0051_ProductionPlanTarget.cs:1495 | if (isCheckDomesticTerm() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98aae788 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 2 | SCP0051_ProductionPlanTarget.cs:1499 | if (CheckSaveDomestic(eRow) && isSave == false) | MESSAGE | MessageBox.Show | (msgCheckDomestic) | 메시지 표시 |  |  |  |
| AC-b4625f0b | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 2 | SCP0051_ProductionPlanTarget.cs:1522 |  | RETURN | return isCheck; |  | 처리 중단/반환 |  |  |  |

## SCP0051_ProductionPlanTarget.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd8bd84e | this.Load | SCP0051_ProductionPlanTarget.cs:163 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fef45386 | this.Load | SCP0051_ProductionPlanTarget.cs:164 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-788c93fe | this.Load | SCP0051_ProductionPlanTarget.cs:166 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0051_ProductionPlanTarget.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05f620d0 | this.Load | SCP0051_ProductionPlanTarget.cs:132 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-9a984e7b | this.Load | SCP0051_ProductionPlanTarget.cs:134 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-fbcd9f7a | this.Load | SCP0051_ProductionPlanTarget.cs:135 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-cb19426b | this.Load | SCP0051_ProductionPlanTarget.cs:136 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48e9d727 | DeleteButton | SCP0051_ProductionPlanTarget.cs:325 | if (fps != null) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0051_ProductionPlanTarget.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbedd229 | Dispose | SCP0051_ProductionPlanTarget.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0051_ProductionPlanTarget.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e855feb | EditButton | SCP0051_ProductionPlanTarget.cs:334 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3050de5f | EditButton | SCP0051_ProductionPlanTarget.cs:337 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a332870a | EditButton | SCP0051_ProductionPlanTarget.cs:345 | if (fps.Name == "spdMain") ▸ if (siMain.IsLock(SpdSheet.shtMain)) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CHK), siMain.GetColumnIndex(DefColumns.CHK), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab771fca | EditButton | SCP0051_ProductionPlanTarget.cs:349 | if (fps.Name == "spdMain") ▸ if (siMain.IsLock(SpdSheet.shtMain)) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.CHK), iRow, siMain.GetColumnIndex(DefColumns.CHK),… | 그리드 표시 설정 |  |  |  |
| AC-644c1e40 | EditButton | SCP0051_ProductionPlanTarget.cs:360 | if (fps.Name == "spdMain") ▸ else of (siMain.IsLock(SpdSheet.shtMain)) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.TARGET_YN), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f90bd7d1 | EditButton | SCP0051_ProductionPlanTarget.cs:361 | if (fps.Name == "spdMain") ▸ else of (siMain.IsLock(SpdSheet.shtMain)) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("CELL_TYPE"), siMain.GetColumnIndex("COUNTRY"), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c32e8bf | EditButton | SCP0051_ProductionPlanTarget.cs:368 | if (fps.Name == "spdMain") ▸ else of (siMain.IsLock(SpdSheet.shtMain)) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action != CAppSetting.F… | CALL_EXT | CUIControl.SetActionFlag | (spdMain, iRow, "N") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0051_ProductionPlanTarget.FindData_Main

진입점: this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c34283e6 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:434 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-15c246cc | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:438 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-f79a38e6 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:438 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eae85750 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:439 | try | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-1b3a498f | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:439 | try ▸ if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53155583 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:443 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b19bc127 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:470 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ca5281fe | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:472 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac8295ff | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:475 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0051_GET_PRODUCTION_PLAN_TARGET") ⇒ SCP.SCP0051_GET_PRODUCTION_PLAN_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-697170ba | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:476 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ee8f6c16 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:477 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2c3c4058 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:478 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7649a163 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:479 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-f890b415 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:480 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-15dc071e | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:481 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9021f543 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:482 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6b8a27d1 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:483 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-88468224 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:484 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-e44e10c0 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:485 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc8f5657 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:486 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-cc3599cf | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:487 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-03d628ca | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:488 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-43affa8d | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:489 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-52a0c10f | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:496 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bbcb4e29 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:498 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-20aabc18 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:508 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1751a648 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:514 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0051_ProductionPlanTarget.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5741e58 | this.Load | SCP0051_ProductionPlanTarget.cs:121 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0051_ProductionPlanTarget.Get_DataTable_Info

진입점: spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (division.Substring(0, 2).Equals("EE") && originDivId == "")] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84e1f3d0 | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0051_ProductionPlanTarget.cs:674 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0051_GET_NEW_INFO") ⇒ SCP.SCP0051_GET_NEW_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-3dc5083e | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0051_ProductionPlanTarget.cs:676 |  | DATA_OP | request.Parameters["code"] | code | 행/컬럼 값 대입 |  |  |  |
| AC-5b6a46d1 | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0051_ProductionPlanTarget.cs:677 |  | DATA_OP | request.Parameters["param1"] | param1 | 행/컬럼 값 대입 |  |  |  |
| AC-3f7b75eb | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0051_ProductionPlanTarget.cs:678 |  | DATA_OP | request.Parameters["param2"] | param2 | 행/컬럼 값 대입 |  |  |  |
| AC-c24a3f43 | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0051_ProductionPlanTarget.cs:679 |  | DATA_OP | request.Parameters["param3"] | param3 | 행/컬럼 값 대입 |  |  |  |
| AC-6ab3450a | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0051_ProductionPlanTarget.cs:680 |  | DATA_OP | request.Parameters["param4"] | param4 | 행/컬럼 값 대입 |  |  |  |
| AC-e675be7a | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0051_ProductionPlanTarget.cs:681 |  | DATA_OP | request.Parameters["param5"] | param5 | 행/컬럼 값 대입 |  |  |  |
| AC-4b619021 | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0051_ProductionPlanTarget.cs:682 |  | DATA_OP | request.Parameters["param6"] | param6 | 행/컬럼 값 대입 |  |  |  |
| AC-ffca4cd8 | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0051_ProductionPlanTarget.cs:683 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b61aa870 | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0051_ProductionPlanTarget.cs:693 |  | RETURN | return ReturnDt; |  | 처리 중단/반환 |  |  |  |

## SCP0051_ProductionPlanTarget.GetCellType

진입점: this.spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (pop.selectedItemId != "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-194a5725 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | SCP0051_ProductionPlanTarget.cs:1465 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0051_ProductionPlanTarget.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8e72a38 | this.Load | SCP0051_ProductionPlanTarget.cs:144 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4849fd8a | this.Load | SCP0051_ProductionPlanTarget.cs:147 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-068f31f1 | this.Load | SCP0051_ProductionPlanTarget.cs:151 |  | UI_PROP | dCalendar.Value1 | DateTime.Today.AddDays(-1) | 속성 Value1 설정 |  |  |  |
| AC-ce73e210 | this.Load | SCP0051_ProductionPlanTarget.cs:152 |  | UI_PROP | dCalendar.Value2 | DateTime.Today.AddDays(0) | 속성 Value2 설정 |  |  |  |
| AC-b63cc8cd | this.Load | SCP0051_ProductionPlanTarget.cs:154 |  | UI_PROP | dCalendar.MaxDate1 | DateTime.Today.AddDays(0) | 속성 MaxDate1 설정 |  |  |  |
| AC-16ce24a7 | this.Load | SCP0051_ProductionPlanTarget.cs:155 |  | UI_PROP | dCalendar.MaxDate2 | DateTime.Today.AddDays(0) | 속성 MaxDate2 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.InitSpread

진입점: this.Load / this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54993c06 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:174 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-eb1f90cb | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:178 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-43d550b4 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:185 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.ITEM_ID].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-616002d9 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:186 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.REQUEST_USER_ID].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-d4855310 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:189 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PROD_DATE), siMain.GetColumnIndex(DefColumns.TARGET_YN),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d612784 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:190 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0051_ProductionPlanTarget.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df68d77b | InsertButton | SCP0051_ProductionPlanTarget.cs:702 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5c6554ee | InsertButton | SCP0051_ProductionPlanTarget.cs:708 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.PROD_DATE, sToday) | 데이터 객체 조작/조회 |  |  |  |
| AC-594e14c3 | InsertButton | SCP0051_ProductionPlanTarget.cs:709 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-ace0dc76 | InsertButton | SCP0051_ProductionPlanTarget.cs:711 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!division.Substring(0, 2).Equals("EE")) | DATA_OP | defaultData.Add | (DefColumns.ORIGIN_DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-684b9e62 | InsertButton | SCP0051_ProductionPlanTarget.cs:713 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | this.siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-0bf2a7c1 | InsertButton | SCP0051_ProductionPlanTarget.cs:716 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | FLAG | dtItemPlantForCell | Get_DataTable_Info("ItemProdPlanLinePopup", division, "", "", "", "", "") ⇒ SCP.SCP0051_GET_NEW_INFO | 화면 필드/플래그 변경 |  |  |  |
| AC-e08f7486 | InsertButton | SCP0051_ProductionPlanTarget.cs:719 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dtPlantSite.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-634190ad | InsertButton | SCP0051_ProductionPlanTarget.cs:720 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dtPlantSite.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-b11cfb8b | InsertButton | SCP0051_ProductionPlanTarget.cs:722 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dtItemPlantForCell.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d72d7a64 | InsertButton | SCP0051_ProductionPlanTarget.cs:728 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (drArr != null) ▸ foreach (DataRow dr in drArr) | DATA_OP | dtPlantSite.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0ca1ada5 | InsertButton | SCP0051_ProductionPlanTarget.cs:729 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (drArr != null) ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["PLANT_SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9425e41c | InsertButton | SCP0051_ProductionPlanTarget.cs:730 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (drArr != null) ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["SITE_DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7486d54d | InsertButton | SCP0051_ProductionPlanTarget.cs:731 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (drArr != null) ▸ foreach (DataRow dr in drArr) | DATA_OP | dtPlantSite.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-942ab77f | InsertButton | SCP0051_ProductionPlanTarget.cs:737 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (drArr != null) | DATA_OP | view.ToTable | (true, new string[] { "CODE", "NAME" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-77c55fa2 | InsertButton | SCP0051_ProductionPlanTarget.cs:740 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | FLAG | dtItemForCell | dtItemPlantForCell.DefaultView.ToTable(true, "CODE", "NAME", "NICK_NAME", "ITEM_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-5b8315b0 | InsertButton | SCP0051_ProductionPlanTarget.cs:740 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dtItemPlantForCell.DefaultView.ToTable | (true, "CODE", "NAME", "NICK_NAME", "ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c3bdaaa | InsertButton | SCP0051_ProductionPlanTarget.cs:743 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | FLAG | dtLineAllForCell | Get_DataTable_Info("LineProdPlanLinePopupAll", "", "", "", "", "", "") ⇒ SCP.SCP0051_GET_NEW_INFO | 화면 필드/플래그 변경 |  |  |  |
| AC-68948c76 | InsertButton | SCP0051_ProductionPlanTarget.cs:747 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dd6aa20c | InsertButton | SCP0051_ProductionPlanTarget.cs:748 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.LINE_ID), dtLineAllForCell) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-112a48be | InsertButton | SCP0051_ProductionPlanTarget.cs:752 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CHK), siMain.GetColumnIndex(DefColumns.DIVISION… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d58089c | InsertButton | SCP0051_ProductionPlanTarget.cs:753 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3cf02ef1 | InsertButton | SCP0051_ProductionPlanTarget.cs:754 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_ID), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-225d677d | InsertButton | SCP0051_ProductionPlanTarget.cs:755 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CHARGE_USER_ID), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-644c621f | InsertButton | SCP0051_ProductionPlanTarget.cs:761 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID), siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0051_ProductionPlanTarget.isCheckDomesticTerm

진입점: this.spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (pop.selectedItemId != "")] / spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (division.Substring(0, 2).Equals("EE") && originDivId == "")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fedf61e0 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 2 | SCP0051_ProductionPlanTarget.cs:1615 |  | RETURN | return isCheckTerm; |  | 처리 중단/반환 |  |  |  |

## SCP0051_ProductionPlanTarget.Re_Design

진입점: this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally] / FindButton [finally] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26811d75 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:1081 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if ("Y" == sConfirmYN) | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(DefColumns.CHK), "True") | 그리드 값 설정 |  |  |  |
| AC-3e8a2820 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:1082 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if ("Y" == sConfirmYN) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-aa739551 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:1086 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ else of ("Y" == sConfirmYN) | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(DefColumns.CHK), "False") | 그리드 값 설정 |  |  |  |
| AC-492bbfe3 | this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtM… 외 2 | SCP0051_ProductionPlanTarget.cs:1091 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0051_ProductionPlanTarget.RefreshLine

진입점: this.Load / cboDivision.SelectedIndexChanged / clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4ac8e4a | this.Load 외 2 | SCP0051_ProductionPlanTarget.cs:410 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "SITE_ID" }, new List<string>() { division, plantSite… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f745d451 | this.Load 외 2 | SCP0051_ProductionPlanTarget.cs:411 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | DBUtils.Filter(dtLineEEAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d451ef8a | this.Load 외 2 | SCP0051_ProductionPlanTarget.cs:411 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtLineEEAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-21f00a4f | this.Load 외 2 | SCP0051_ProductionPlanTarget.cs:416 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "PLANT_ID", "OPERATION_GROUP", "SITE_ID" }, new List<… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ad222c8 | this.Load 외 2 | SCP0051_ProductionPlanTarget.cs:417 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | DBUtils.Filter(dtLineAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9b619ffe | this.Load 외 2 | SCP0051_ProductionPlanTarget.cs:417 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtLineAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d455898e | this.Load 외 2 | SCP0051_ProductionPlanTarget.cs:421 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0051_ProductionPlanTarget.RefreshPlantSite

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aae0cbfe | this.Load 외 1 | SCP0051_ProductionPlanTarget.cs:390 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionEEAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-283fb100 | this.Load 외 1 | SCP0051_ProductionPlanTarget.cs:390 | if (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionEEAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-64cf898d | this.Load 외 1 | SCP0051_ProductionPlanTarget.cs:394 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-40c8b6dc | this.Load 외 1 | SCP0051_ProductionPlanTarget.cs:394 | else of (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1974a9b6 | this.Load 외 1 | SCP0051_ProductionPlanTarget.cs:397 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0051_ProductionPlanTarget.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c7b0232 | SaveButton | SCP0051_ProductionPlanTarget.cs:525 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d7eddf5 | SaveButton | SCP0051_ProductionPlanTarget.cs:526 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-f87f3997 | SaveButton | SCP0051_ProductionPlanTarget.cs:526 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-beae03b1 | SaveButton | SCP0051_ProductionPlanTarget.cs:558 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "Plant Qty : 1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0bff0d1d | SaveButton | SCP0051_ProductionPlanTarget.cs:559 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8495ea42 | SaveButton | SCP0051_ProductionPlanTarget.cs:564 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "Plant Qty : 9,999,999,999" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c51e97f | SaveButton | SCP0051_ProductionPlanTarget.cs:565 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cbf6c09 | SaveButton | SCP0051_ProductionPlanTarget.cs:572 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00082", new object[] { "CONFIRM " }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c3bc3f86 | SaveButton | SCP0051_ProductionPlanTarget.cs:573 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec48b35c | SaveButton | SCP0051_ProductionPlanTarget.cs:579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | (msgCheckDomestic) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-966db601 | SaveButton | SCP0051_ProductionPlanTarget.cs:580 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-370b10d6 | SaveButton | SCP0051_ProductionPlanTarget.cs:607 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0051_SAVE_PRODUCTION_PLAN_TARGET") ⇒ SCP.SCP0051_SAVE_PRODUCTION_PLAN_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-efc75be6 | SaveButton | SCP0051_ProductionPlanTarget.cs:611 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1d849fba | SaveButton | SCP0051_ProductionPlanTarget.cs:615 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c551684e | SaveButton | SCP0051_ProductionPlanTarget.cs:616 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-419050e0 | SaveButton | SCP0051_ProductionPlanTarget.cs:617 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_target_id"] | p_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-4c23c24b | SaveButton | SCP0051_ProductionPlanTarget.cs:618 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_prod_date"] | p_prod_date | 행/컬럼 값 대입 |  |  |  |
| AC-53b389ac | SaveButton | SCP0051_ProductionPlanTarget.cs:619 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0a3b324e | SaveButton | SCP0051_ProductionPlanTarget.cs:620 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_origin_division_id"] | p_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-125d90b8 | SaveButton | SCP0051_ProductionPlanTarget.cs:621 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab8312ba | SaveButton | SCP0051_ProductionPlanTarget.cs:622 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_plant_scm_site_id"] | p_plant_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a61bee38 | SaveButton | SCP0051_ProductionPlanTarget.cs:623 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-5143ec58 | SaveButton | SCP0051_ProductionPlanTarget.cs:624 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-4f9dae71 | SaveButton | SCP0051_ProductionPlanTarget.cs:625 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_order_type"] | p_order_type | 행/컬럼 값 대입 |  |  |  |
| AC-179864ae | SaveButton | SCP0051_ProductionPlanTarget.cs:626 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-02cb626a | SaveButton | SCP0051_ProductionPlanTarget.cs:627 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_plant_qty"] | p_plant_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e317436c | SaveButton | SCP0051_ProductionPlanTarget.cs:628 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_reason"] | p_reason | 행/컬럼 값 대입 |  |  |  |
| AC-4d5e8519 | SaveButton | SCP0051_ProductionPlanTarget.cs:629 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_reason_detail"] | p_reason_detail | 행/컬럼 값 대입 |  |  |  |
| AC-c5b27f36 | SaveButton | SCP0051_ProductionPlanTarget.cs:630 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_request_user_id"] | p_request_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e323dcf9 | SaveButton | SCP0051_ProductionPlanTarget.cs:631 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_charge_user_id"] | p_charge_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-316186db | SaveButton | SCP0051_ProductionPlanTarget.cs:633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-485b4c79 | SaveButton | SCP0051_ProductionPlanTarget.cs:633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-bd9b69b5 | SaveButton | SCP0051_ProductionPlanTarget.cs:642 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f47c1894 | SaveButton | SCP0051_ProductionPlanTarget.cs:654 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e80c9ee8 | SaveButton | SCP0051_ProductionPlanTarget.cs:658 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0051_ProductionPlanTarget.SetBtnConfirm

진입점: this.Load / this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount)] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount)] / EditButton [if (fps.Name == "spdMain") ▸ if (siMain.IsLock(SpdSheet.shtMain))] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b401289 | this.Load 외 4 | SCP0051_ProductionPlanTarget.cs:223 | if (bConfirmVisible) ▸ switch (UserInfoContext.Current["NowGroupID"]) case "SCM PI Admin": | UI_PROP | layoutConfirm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7d58e1e9 | this.Load 외 4 | SCP0051_ProductionPlanTarget.cs:226 | if (bConfirmVisible) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutConfirm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a4ad5de0 | this.Load 외 4 | SCP0051_ProductionPlanTarget.cs:232 | else of (bConfirmVisible) | UI_PROP | layoutConfirm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.SetCellLock

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39431e80 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | SCP0051_ProductionPlanTarget.cs:1449 |  | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(colName), siMain.GetColumnIndex(colName), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0051_ProductionPlanTarget.SetCellValue

진입점: this.spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (pop.selectedItemId != "")] / spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (division.Substring(0, 2).Equals("EE") && originDivId == "") ▸ if (CheckExistsDomestic(plantID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-625301d9 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | SCP0051_ProductionPlanTarget.cs:1445 |  | GRID_SET | siMain.SetValue | (eRow, siMain.GetColumnIndex(colName), value) | 그리드 값 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.SetHeaderCheckBox

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnConfirm.Click [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / EditButton [if (fps.Name == "spdMain") ▸ if (siMain.IsLock(SpdSheet.shtMain))] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6d356da | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0051_ProductionPlanTarget.cs:203 | if (bCheckVisible) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-8942aa6a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0051_ProductionPlanTarget.cs:204 | if (bCheckVisible) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-81ea79aa | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0051_ProductionPlanTarget.cs:205 | if (bCheckVisible) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-efd914c3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0051_ProductionPlanTarget.cs:210 | else of (bCheckVisible) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].CellType | txt | 그리드 속성/값 설정 |  |  |  |
| AC-40acce43 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0051_ProductionPlanTarget.cs:211 | else of (bCheckVisible) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | "" | 그리드 속성/값 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.SetListDomestic

진입점: spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (division.Substring(0, 2).Equals("EE") && originDivId == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4076fd0a | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… | SCP0051_ProductionPlanTarget.cs:1441 |  | FLAG | dtDomestic | Data_SCP.Common(Data_SCP.Type.PLANT_DOMESTIC, false, null, null) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ec5ed27 | spdMain.ComboSelChange [if (e.Column == siMain.GetColumnInde… | SCP0051_ProductionPlanTarget.cs:1441 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PLANT_DOMESTIC, false, null, null) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0051_ProductionPlanTarget.SetProducttionPlanTargetCheck

진입점: this.Load / this.spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (pop.selectedItemId != "")] / spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (division.Substring(0, 2).Equals("EE") && originDivId == "")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e935e27 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1557 | try | FLAG | dtProducttionPlanTargetCheck | CommonUtils.GetLookupValues("PRODUCTION_PLAN_TARGET_CHECK") | 화면 필드/플래그 변경 |  |  |  |
| AC-aa2a8760 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1557 | try | CALL_EXT | CommonUtils.GetLookupValues | ("PRODUCTION_PLAN_TARGET_CHECK") | ⚠ 의미 확인 필요 |  |  |  |
| AC-30738ef8 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1558 | try | FLAG | strCheckUse | CommonUtils.FindDataValue(dtProducttionPlanTargetCheck, "CODE", "CHECK_USE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-75f6f831 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1558 | try | ENDPOINT | CommonUtils.FindDataValue | (dtProducttionPlanTargetCheck, "CODE", "CHECK_USE", "NAME") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6bcfe75d | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1561 | try ▸ if (strCheckUse.Equals("N")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d47fbe77 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1563 | try | FLAG | strCheckStart | CommonUtils.FindDataValue(dtProducttionPlanTargetCheck, "CODE", "CHECK_START_DATE", "NAME"… | 화면 필드/플래그 변경 |  |  |  |
| AC-06577a34 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1563 | try | ENDPOINT | CommonUtils.FindDataValue | (dtProducttionPlanTargetCheck, "CODE", "CHECK_START_DATE", "NAME") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6cfffec5 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1564 | try | FLAG | strCheckEnd | CommonUtils.FindDataValue(dtProducttionPlanTargetCheck, "CODE", "CHECK_END_DATE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-8c8aa091 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1564 | try | ENDPOINT | CommonUtils.FindDataValue | (dtProducttionPlanTargetCheck, "CODE", "CHECK_END_DATE", "NAME") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c956cba | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1567 | try | FLAG | strNow | System.DateTime.Now.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-23acf034 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1568 | try | FLAG | dateNow | Convert.ToDateTime(strNow) | 화면 필드/플래그 변경 |  |  |  |
| AC-76c5128f | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1571 | try ▸ if (CommonUtils.CheckDataEmpty(strCheckStart) == false) | FLAG | dateCheckStart | CommonUtils.GetDateTime(strCheckStart) | 화면 필드/플래그 변경 |  |  |  |
| AC-73dc85fc | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1574 | try ▸ if (CommonUtils.CheckDataEmpty(strCheckEnd) == false) | FLAG | dateCheckEnd | CommonUtils.GetDateTime(strCheckEnd) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdf433ab | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1577 | try ▸ if (dateNow < dateCheckStart) | FLAG | strCheckUse | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-a0c45f27 | this.Load 외 3 | SCP0051_ProductionPlanTarget.cs:1580 | try ▸ if (dateNow > dateCheckEnd) | FLAG | strCheckUse | "N" | 화면 필드/플래그 변경 |  |  |  |

## SCP0051_ProductionPlanTarget.setRowForEE

진입점: this.spdMain.ClipboardPasted [if (division.Substring(0, 2).Equals("EE"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f948127 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1115 | for (iRow <= rowCntIndex) ▸ if (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-313547fe | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1118 | for (iRow <= rowCntIndex) ▸ if (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Origin Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-885d9514 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1125 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") | DATA_OP | dtItemForCell.Select | ("CODE = '" + sItemID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b2cf487 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1129 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drNick != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-e2dc94eb | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1133 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drNick != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), itemType) | 그리드 값 설정 |  |  |  |
| AC-752e165a | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1137 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") | DATA_OP | originDiv.Select | ("ITEM_ID = '" + sItemID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-b4855115 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1139 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") | DATA_OP | dtOriginDiv.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-45e9ea43 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1140 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") | DATA_OP | dtOriginDiv.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-37204865 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1145 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOriginArr != nu… | DATA_OP | dtOriginDiv.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-705aa22e | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1146 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOriginArr != nu… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d17f82d3 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1147 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOriginArr != nu… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69d82753 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1148 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOriginArr != nu… | DATA_OP | dtOriginDiv.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-048b0bd7 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1150 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOriginArr != nu… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID), dtOriginDiv) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7b45dc56 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1153 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") | DATA_OP | dtOriginDiv.Select | ("CODE = '" + sOriginDiv + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbc997da | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1155 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin == null) | DATA_OP | dtOriginDiv.Select | ("NAME = '" + sOriginDiv + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1bead3ca | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1160 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID), sOriginDiv) | 그리드 값 설정 |  |  |  |
| AC-92d32202 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1164 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null) | DATA_OP | dtPlantSite.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-318d2628 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1165 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null) | DATA_OP | dtPlantSite.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-54d650d0 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1166 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null) | DATA_OP | dtPlantSite.Columns.Add | ("OSP_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-899ce3ea | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1167 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null) | DATA_OP | dtPlantSite.Columns.Add | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d6b35ef | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1169 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null) | DATA_OP | dtItemPlantForCell.Select | ("CODE = '" + sItemID + "' AND DIVISION_ID = '" + sOriginDiv + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a6e43b4 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1174 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtPlantSite.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9183f4ff | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1175 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | drRow["CODE"] | dr["PLANT_SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a1eeee4 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1176 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | drRow["NAME"] | dr["SITE_DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d81ba315 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1177 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | drRow["OSP_YN"] | dr["OSP_YN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b73275e | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1178 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | drRow["OPERATION_ID"] | dr["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d041d1f | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1179 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtPlantSite.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-9df05a0f | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1181 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f7ef560c | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1183 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtPlantSite.Select | ("CODE = '" + sPlantSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-909078ac | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1185 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtPlantSite.Select | ("NAME = '" + sPlantSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-73f314c5 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1189 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_ID), drPlant["OPERATION_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-df527f54 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1192 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), sPlantSite) | 그리드 값 설정 |  |  |  |
| AC-aa0762a9 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1198 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | table.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bf2dd85 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1199 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | table.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cb5d74b | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1201 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-db997f6a | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1202 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dr1["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-81fe111c | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1203 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dr1["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-eb11dd9a | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1204 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | table.Rows.Add | (dr1) | 데이터 객체 조작/조회 |  |  |  |
| AC-7af66f63 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1206 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), table) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0a5f7c44 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1212 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | FLAG | dtLineForCell | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-fa49ca97 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1213 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtLineForCell.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7d61977 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1214 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtLineForCell.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-3fbf0404 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1215 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtLineAllForCell.Select | ("DIVISION_ID = '" + sOriginDiv + "' AND PLANT_SITE_ID = '" + sPlantSite + "' AND OPERATIO… | 데이터 객체 조작/조회 |  |  |  |
| AC-8974c12a | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1220 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtLineForCell.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6f727c75 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1221 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5fd76b82 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1222 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-82025034 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1223 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtLineForCell.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0d8f699 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1225 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), dtLineForCell) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-010534d3 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1228 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtLineForCell.Select | ("CODE = '" + sLine + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d12d0f0 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1230 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | DATA_OP | dtLineForCell.Select | ("NAME = '" + sLine + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4917bae | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1235 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), sLine) | 그리드 값 설정 |  |  |  |
| AC-32fa3de8 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1239 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-edefabd9 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1247 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-b09a1aee | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1248 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ if (drOrigin != null)… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ab33b9b3 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1255 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ else of (drOrigin != … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-613d6004 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1256 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ else of (drOrigin != … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-02199dfd | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1257 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ if (sItemID != "") ▸ else of (drOrigin != … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-5771a08d | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1263 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ else of (sItemID != "") | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c5af31d2 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1264 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ else of (sItemID != "") | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-242c8c30 | this.spdMain.ClipboardPasted [if (division.Substring(0, 2).E… | SCP0051_ProductionPlanTarget.cs:1265 | for (iRow <= rowCntIndex) ▸ else of (division.Substring(0, 2).Equals("EE") && sOriginDiv == "") ▸ else of (sItemID != "") | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.setRowForNotEE

진입점: this.spdMain.ClipboardPasted [else of (division.Substring(0, 2).Equals("EE"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccef3a4d | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1289 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | dtItemForCell.Select | ("CODE = '" + sItemID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d1c1a56 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1293 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drNick != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-48a82e68 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1297 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drNick != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), itemType) | 그리드 값 설정 |  |  |  |
| AC-cd21b6ca | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1302 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | dtPlantSite.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3cb50116 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1303 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | dtPlantSite.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8515a69 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1304 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | dtPlantSite.Columns.Add | ("OSP_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd48f76b | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1305 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | dtPlantSite.Columns.Add | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-738d9894 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1307 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | dtItemPlantForCell.Select | ("CODE = '" + sItemID + "' AND DIVISION_ID = '" + division + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-9803f72d | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1312 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ foreach (DataRow dr in drArr) | DATA_OP | dtPlantSite.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f5138b22 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1313 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["PLANT_SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-99ee4681 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1314 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["SITE_DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3cf67b65 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1315 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["OSP_YN"] | dr["OSP_YN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-177df2c3 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1316 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["OPERATION_ID"] | dr["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c5eac9a | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1317 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ foreach (DataRow dr in drArr) | DATA_OP | dtPlantSite.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8614885 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1319 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-00b49453 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1321 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) | DATA_OP | dtPlantSite.Select | ("CODE = '" + sPlantSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ef3820f | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1324 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant == null) | DATA_OP | dtPlantSite.Select | ("NAME = '" + sPlantSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-74a4fd25 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1328 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_ID), drPlant["OPERATION_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-7e1a881b | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1331 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), sPlantSite) | 그리드 값 설정 |  |  |  |
| AC-11ff4d8c | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1336 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") | FLAG | dtLineForCell | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-8f043055 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1337 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") | DATA_OP | dtLineForCell.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ed9cff9 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1338 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") | DATA_OP | dtLineForCell.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-cfb67701 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1339 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") | DATA_OP | dtLineAllForCell.Select | ("DIVISION_ID = '" + division + "' AND PLANT_SITE_ID = '" + sPlantSite + "' AND ITEM_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-5e57347d | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1344 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ if (… | DATA_OP | dtLineForCell.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-65e6236f | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1345 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ if (… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-904a3e26 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1346 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ if (… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-da3e5e92 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1347 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ if (… | DATA_OP | dtLineForCell.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-99b93092 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1353 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ if (… | DATA_OP | dtLineForCell.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-02d95b40 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1354 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ if (… | DATA_OP | dr1["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-b411660c | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1355 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ if (… | DATA_OP | dr1["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-2770e279 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1356 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ if (… | DATA_OP | dtLineForCell.Rows.Add | (dr1) | 데이터 객체 조작/조회 |  |  |  |
| AC-43c56fb5 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1359 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), dtLineForCell) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-79721fb6 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1361 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") | DATA_OP | dtLineForCell.Select | ("CODE = '" + sLine + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5ff6ab1 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1363 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ if (… | DATA_OP | dtLineForCell.Select | ("NAME = '" + sLine + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-0cd6350a | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1368 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ if (… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), sLine) | 그리드 값 설정 |  |  |  |
| AC-1a6b9977 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1372 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ if (drPlant["OSP_YN"].ToString() == "Y") ▸ else… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-fba762b1 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1379 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") | FLAG | dtLineForCell | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-a9a240d5 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1380 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") | DATA_OP | dtLineForCell.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ede38bf9 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1381 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") | DATA_OP | dtLineForCell.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-02059b5b | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1382 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") | DATA_OP | dtLineAllForCell.Select | ("DIVISION_ID = '" + division + "' AND PLANT_SITE_ID = '" + sPlantSite + "' AND OPERATION_… | 데이터 객체 조작/조회 |  |  |  |
| AC-eca0b4e1 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1387 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") ▸… | DATA_OP | dtLineForCell.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-31bd01ea | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1388 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") ▸… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-96ede3ff | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1389 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") ▸… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c3b6196 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1390 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") ▸… | DATA_OP | dtLineForCell.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-40109817 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1392 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") ▸… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), dtLineForCell) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b9031028 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1395 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") | DATA_OP | dtLineForCell.Select | ("CODE = '" + sLine + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed8f0268 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1397 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") ▸… | DATA_OP | dtLineForCell.Select | ("NAME = '" + sLine + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-35df6f38 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1402 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") ▸… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), sLine) | 그리드 값 설정 |  |  |  |
| AC-2ca3e41d | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1406 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ if (drPlant != null) ▸ else of (drPlant["OSP_YN"].ToString() == "Y") ▸… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-50def20c | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1413 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ else of (drPlant != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-5dee1fe4 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1414 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drArr != null) ▸ else of (drPlant != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-bdea4a62 | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1421 | for (iRow <= rowCntIndex) ▸ else of (sItemID != "") | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c4a782cb | this.spdMain.ClipboardPasted [else of (division.Substring(0,… | SCP0051_ProductionPlanTarget.cs:1422 | for (iRow <= rowCntIndex) ▸ else of (sItemID != "") | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-180d08c6 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:987 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | CALL_EXT | sv.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e57395c7 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:998 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetC… | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-af9b1326 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1003 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetC… | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6e92af16 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1005 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetC… | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-76e3643f | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1006 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetC… | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4d045d58 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1007 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetC… | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fe86595d | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1014 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetC… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), itemId) | 그리드 값 설정 |  |  |  |
| AC-e7ee9520 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1015 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetC… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), nickname) | 그리드 값 설정 |  |  |  |
| AC-ccad0ab3 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1020 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetC… | FLAG | originDiv | Data_SCP.Common(Data_SCP.Type.OriginDivFromFinalItem, false, itemId) | 화면 필드/플래그 변경 |  |  |  |
| AC-79b2e27b | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1020 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetC… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OriginDivFromFinalItem, false, itemId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3186212 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1023 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sCellText.Trim() == CAppSetting.StringI) ▸ if (e.Column == siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID), originDiv) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a14eeb53 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER_ID)) | POPUP | new SCPAnalysisUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ee1303a2 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1036 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER_ID)) | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-4be3abfb | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1037 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER_ID)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-37ec0811 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1038 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER_ID)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e28522f3 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1040 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER_ID)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-6b98ec58 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1042 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER_ID)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-73f9cfc8 | this.spdMain.CellDoubleClick | SCP0051_ProductionPlanTarget.cs:1048 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_USER_ID)) ▸ if (p… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.REQUEST_USER_ID), item.USER_ID) | 그리드 값 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.SpdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfff78a4 | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:916 |  | FLAG | originDiv | Data_SCP.Common(Data_SCP.Type.OriginDivFromFinalItemEE, false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-8decd154 | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:916 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OriginDivFromFinalItemEE, false, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-82460dde | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:918 |  | ENDPOINT | Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-881a332d | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:922 |  | ENDPOINT | data.GetDataPresent | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8b498ada | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:924 | if (data.GetDataPresent(typeof(System.String))) | ENDPOINT | data.GetData | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9bec6578 | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:927 | if (data.GetDataPresent(typeof(System.String))) | CALL_EXT | strValue.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-51e97437 | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:955 | for (i < (selectRow + ClipRowCount)) | GRID_INIT | siMain.SetCellTypeText | (i, siMain.GetColumnIndex(DefColumns.LINE_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c10dc59b | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:956 | for (i < (selectRow + ClipRowCount)) | GRID_INIT | siMain.SetCellTypeText | (i, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bb4c4f65 | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:957 | for (i < (selectRow + ClipRowCount)) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), strPlantSite) | 그리드 값 설정 |  |  |  |
| AC-4caa9563 | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:958 | for (i < (selectRow + ClipRowCount)) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.LINE_ID), strLine) | 그리드 값 설정 |  |  |  |
| AC-8f7db95b | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:961 | for (i < (selectRow + ClipRowCount)) ▸ if (division.Substring(0, 2).Equals("EE")) | GRID_INIT | siMain.SetCellTypeText | (i, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a85f924b | this.spdMain.ClipboardPasting | SCP0051_ProductionPlanTarget.cs:962 | for (i < (selectRow + ClipRowCount)) ▸ if (division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID), strOriginDiv) | 그리드 값 설정 |  |  |  |

## SCP0051_ProductionPlanTarget.SpdMain_ComboSelChange

진입점: spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5253ccb3 | spdMain.ComboSelChange | SCP0051_ProductionPlanTarget.cs:261 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ if (divis… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-e3ca3e79 | spdMain.ComboSelChange | SCP0051_ProductionPlanTarget.cs:264 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ if (divis… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Origin Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4c881c25 | spdMain.ComboSelChange | SCP0051_ProductionPlanTarget.cs:274 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (… | DATA_OP | dtItemPlant2.Select | ("CODE = '" + sItemId + "' AND PLANT_SITE_ID='" + sPlantScmSiteId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-6be80acc | spdMain.ComboSelChange | SCP0051_ProductionPlanTarget.cs:287 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (… | FLAG | dtLineForCell | Get_DataTable_Info("LineProdPlanLinePopup", division, "", sPlantScmSiteId, sOperationId, o… ⇒ SCP.SCP0051_GET_NEW_INFO | 화면 필드/플래그 변경 |  |  |  |
| AC-4dd0a660 | spdMain.ComboSelChange | SCP0051_ProductionPlanTarget.cs:288 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID), dtLineForCell) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-42e63c22 | spdMain.ComboSelChange | SCP0051_ProductionPlanTarget.cs:293 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (… | FLAG | dtLineForCell | Get_DataTable_Info("LineProdPlanLinePopup", division, "", sPlantScmSiteId, sOperationId, o… ⇒ SCP.SCP0051_GET_NEW_INFO | 화면 필드/플래그 변경 |  |  |  |
| AC-0ae53819 | spdMain.ComboSelChange | SCP0051_ProductionPlanTarget.cs:294 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID), dtLineForCell) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8ff36d86 | spdMain.ComboSelChange | SCP0051_ProductionPlanTarget.cs:296 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), sOperationId) | 그리드 값 설정 |  |  |  |
| AC-3147cd35 | spdMain.ComboSelChange | SCP0051_ProductionPlanTarget.cs:297 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SCM_SITE_ID) \|\| e.Column == siMain.GetColumnIndex(DefColumns.ORIGIN_D…) ▸ else of (… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |

