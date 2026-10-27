# AS-IS 액션 대조표 — SCP0075

> 원천: `Doc/asisfacts/screens/SCP0075/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 223행 · 메서드 30 · 종류 DATA_OP 55 · RETURN 17 · FLAG 17 · POPUP 16 · GRID_INIT 14 · UI_PROP 12 · UI_MISC 12 · MESSAGE 12 · GRID_LOCK 11 · GRID_SET 11 · ENDPOINT 8 · LIST_REBIND 7 · COMBO_DATA 7 · CALL_EXT 6 · VALUE_SET 5 · STATE 4 · GRID_STYLE 3 · EXCEL 2 · VALIDATE 2 · GRID_CLEAR 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 6


## SCP0075_Allo_Target.btnModel_ID_Click

진입점: this.btnModel_ID.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1dffcb79 | this.btnModel_ID.Click | SCP0075_Allo_Target.cs:1340 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c56b304 | this.btnModel_ID.Click | SCP0075_Allo_Target.cs:1342 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fa409a16 | this.btnModel_ID.Click | SCP0075_Allo_Target.cs:1343 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-39ba0b98 | this.btnModel_ID.Click | SCP0075_Allo_Target.cs:1344 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-feecc82c | this.btnModel_ID.Click | SCP0075_Allo_Target.cs:1345 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1ed2dfc6 | this.btnModel_ID.Click | SCP0075_Allo_Target.cs:1349 | if (popItem.ItemID != "") | VALUE_SET | txtModel_ID.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0075_Allo_Target.btnNickName_Click

진입점: this.btnNickName.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5053331 | this.btnNickName.Click | SCP0075_Allo_Target.cs:1359 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c28bb81 | this.btnNickName.Click | SCP0075_Allo_Target.cs:1361 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-91a3385c | this.btnNickName.Click | SCP0075_Allo_Target.cs:1362 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-973b9d76 | this.btnNickName.Click | SCP0075_Allo_Target.cs:1363 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-664eb7d9 | this.btnNickName.Click | SCP0075_Allo_Target.cs:1364 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d25be823 | this.btnNickName.Click | SCP0075_Allo_Target.cs:1369 | if (popItem.NickName != "") | VALUE_SET | txtNickName.Text | sNickName | 컨트롤 값 설정 |  |  |  |

## SCP0075_Allo_Target.ClearDataSource

진입점: this.FormClosing / FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74c52678 | this.FormClosing 외 2 | SCP0075_Allo_Target.cs:654 | if (fpSpread.ActiveSheet == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b632ec8 | this.FormClosing 외 2 | SCP0075_Allo_Target.cs:662 | if (fpSpread.ActiveSheet.DataSource != null) ▸ if (((DataSet)fpSpread.ActiveSheet.DataSource).Tables[0].Rows.Count > 0) | GRID_CLEAR | ((DataSet)fpSpread.ActiveSheet.DataSource).Tables[0].Rows.Clear | () | 그리드 행 비움 |  |  |  |

## SCP0075_Allo_Target.ColumnHeaderSpan

진입점: FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aaa71360 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:390 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (sPrevious.Equals(string.Empty)) ▸ else of (sPrevious == sHeaderText) | CALL_EXT | sheet.AddColumnHeaderSpanCell | (0, iCurIdx, 1, iSpanCnt) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0075_Allo_Target.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-022d97cc | this.Load | SCP0075_Allo_Target.cs:303 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bf4e1ca6 | this.Load | SCP0075_Allo_Target.cs:304 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-767d0f33 | this.Load | SCP0075_Allo_Target.cs:305 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0075_Allo_Target.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1d1152a | this.Load | SCP0075_Allo_Target.cs:145 |  | UI_PROP | usrConditionPanel1.Height | 100 | 속성 Height 설정 |  |  |  |
| AC-dd73309e | this.Load | SCP0075_Allo_Target.cs:146 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-e1a3a102 | this.Load | SCP0075_Allo_Target.cs:147 |  | VALUE_SET | cboCellTypeGr.SelectedValue | CellTypeGroupType.Cyl | 컨트롤 값 설정 |  |  |  |

## SCP0075_Allo_Target.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4173ea9c | Dispose | SCP0075_Allo_Target.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0075_Allo_Target.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9399acd3 | EditButton | SCP0075_Allo_Target.cs:494 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a618189b | EditButton | SCP0075_Allo_Target.cs:495 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-863859b3 | EditButton | SCP0075_Allo_Target.cs:497 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7cf618db | EditButton | SCP0075_Allo_Target.cs:506 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e577a955 | EditButton | SCP0075_Allo_Target.cs:510 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (iRow < siMain.Sheet(… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefCol.DIVISION_ID), iRow, siMain.GetColumnIndex(DefCol.SORT_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a47e40c1 | EditButton | SCP0075_Allo_Target.cs:522 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (iRow < siMain.Sheet(… | DATA_OP | sHeaderChkText.Contains | ("Q") | 데이터 객체 조작/조회 |  |  |  |
| AC-43190e54 | EditButton | SCP0075_Allo_Target.cs:525 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (iRow < siMain.Sheet(… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b4e27113 | EditButton | SCP0075_Allo_Target.cs:533 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0075_Allo_Target.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a69355d0 | ExcelButton | SCP0075_Allo_Target.cs:1258 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00100") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7207b769 | ExcelButton | SCP0075_Allo_Target.cs:1260 | if (result == DialogResult.Yes) | EXCEL | ExportExcel | (true) | 엑셀 내보내기/올리기 |  |  |  |
| AC-3bda1c04 | ExcelButton | SCP0075_Allo_Target.cs:1262 | else of (result == DialogResult.Yes) ▸ if (result == DialogResult.No) | EXCEL | ExportExcel | (false) | 엑셀 내보내기/올리기 |  |  |  |
| AC-c970e2fc | ExcelButton | SCP0075_Allo_Target.cs:1264 | else of (result == DialogResult.Yes) ▸ else of (result == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0075_Allo_Target.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e1f8dfc | FindButton 외 1 | SCP0075_Allo_Target.cs:550 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-d8f49e36 | FindButton 외 1 | SCP0075_Allo_Target.cs:559 | if (DateTime.Compare(dtFrom, dtTo) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00344") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef7ba339 | FindButton 외 1 | SCP0075_Allo_Target.cs:560 | if (DateTime.Compare(dtFrom, dtTo) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-372a690f | FindButton 외 1 | SCP0075_Allo_Target.cs:569 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-89981e75 | FindButton 외 1 | SCP0075_Allo_Target.cs:572 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-956cebd6 | FindButton 외 1 | SCP0075_Allo_Target.cs:585 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5ea92ab3 | FindButton 외 1 | SCP0075_Allo_Target.cs:586 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a6f90e7f | FindButton 외 1 | SCP0075_Allo_Target.cs:589 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0075_GET_ALLO_TARGET_SMALL") ⇒ SCP.SCP0075_GET_ALLO_TARGET_SMALL | 엔드포인트 요청 생성 |  |  |  |
| AC-0cb3bdc7 | FindButton 외 1 | SCP0075_Allo_Target.cs:590 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-09a66852 | FindButton 외 1 | SCP0075_Allo_Target.cs:591 | try ▸ lambda | DATA_OP | req.Parameters["P_DIVISION_ID"] | pdivisionid | 행/컬럼 값 대입 |  |  |  |
| AC-252b6ed4 | FindButton 외 1 | SCP0075_Allo_Target.cs:592 | try ▸ lambda | DATA_OP | req.Parameters["P_CUTOFF_YYYYMMDD"] | p_cutoff_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9b1c23b9 | FindButton 외 1 | SCP0075_Allo_Target.cs:593 | try ▸ lambda | DATA_OP | req.Parameters["P_ITEM_ID"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2738e739 | FindButton 외 1 | SCP0075_Allo_Target.cs:595 | try ▸ lambda | DATA_OP | req.Parameters["P_NICK_NAME"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-0c1ed858 | FindButton 외 1 | SCP0075_Allo_Target.cs:596 | try ▸ lambda | DATA_OP | req.Parameters["P_TEAM_ID"] | p_team_id | 행/컬럼 값 대입 |  |  |  |
| AC-e48ced1c | FindButton 외 1 | SCP0075_Allo_Target.cs:597 | try ▸ lambda | DATA_OP | req.Parameters["P_FROM_YYYYMM"] | p_from_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-2d815ca8 | FindButton 외 1 | SCP0075_Allo_Target.cs:598 | try ▸ lambda | DATA_OP | req.Parameters["P_TO_YYYYMM"] | p_to_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-0db01606 | FindButton 외 1 | SCP0075_Allo_Target.cs:600 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-47bb5373 | FindButton 외 1 | SCP0075_Allo_Target.cs:601 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2b44249b | FindButton 외 1 | SCP0075_Allo_Target.cs:607 | try ▸ if (dsBinding.Tables[0].Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ef5884b | FindButton 외 1 | SCP0075_Allo_Target.cs:615 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-22f7cd8d | FindButton 외 1 | SCP0075_Allo_Target.cs:617 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cbb5daed | FindButton 외 1 | SCP0075_Allo_Target.cs:621 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-549b5682 | FindButton 외 1 | SCP0075_Allo_Target.cs:628 | try ▸ for (iCol < siMain.ActiveSheet.FrozenColumnCount) | GRID_STYLE | siMain.ActiveSheet.SetColumnMerge | (iCol, FarPoint.Win.Spread.Model.MergePolicy.Always) | 그리드 표시 설정 |  |  |  |
| AC-0602e94d | FindButton 외 1 | SCP0075_Allo_Target.cs:630 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c21597aa | FindButton 외 1 | SCP0075_Allo_Target.cs:637 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b1b06d1f | FindButton 외 1 | SCP0075_Allo_Target.cs:639 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7470dd39 | FindButton 외 1 | SCP0075_Allo_Target.cs:643 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a29b8246 | FindButton 외 1 | SCP0075_Allo_Target.cs:644 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b6077bb0 | FindButton 외 1 | SCP0075_Allo_Target.cs:648 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0075_Allo_Target.FixColumnSpan

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c82b2de | (진입점 미연결) | SCP0075_Allo_Target.cs:672 | try | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, siMain.GetMaxRowIndex(), 1, siMain.GetColumnIndex(DefCol.S… | ⚠ 의미 확인 필요 |  |  |  |

## SCP0075_Allo_Target.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57b309f7 | this.Load | SCP0075_Allo_Target.cs:135 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0075_Allo_Target.Get_All_CutOff_Idx

진입점: FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05a82d1f | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:707 |  | FLAG | dtDistinctCutOff | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-0faf6efc | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:708 |  | FLAG | dtCutOff | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-78c31a1d | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:710 |  | DATA_OP | dtDistinctCutOff.Columns.Add | ("NICK_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-237550ce | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:711 |  | DATA_OP | dtDistinctCutOff.Columns.Add | ("DEPT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-01484f73 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:712 |  | DATA_OP | dtDistinctCutOff.Columns.Add | ("CUTOFF", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffd09ead | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:713 |  | DATA_OP | dtDistinctCutOff.Columns.Add | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e721f35 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:715 |  | DATA_OP | dtCutOff.Columns.Add | ("NICK_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d55769d5 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:716 |  | DATA_OP | dtCutOff.Columns.Add | ("DEPT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ab3da11 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:717 |  | DATA_OP | dtCutOff.Columns.Add | ("CUTOFF", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-830eaa01 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:718 |  | DATA_OP | dtCutOff.Columns.Add | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93ef7e79 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:719 |  | DATA_OP | dtCutOff.Columns.Add | ("ROW_IDX", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b29e27eb | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:722 |  | DATA_OP | dtTemp.Columns.Add | ("NICK_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3425408d | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:723 |  | DATA_OP | dtTemp.Columns.Add | ("DEPT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea9e661f | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:724 |  | DATA_OP | dtTemp.Columns.Add | ("CUTOFF", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-12e35679 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:725 |  | DATA_OP | dtTemp.Columns.Add | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc5c804c | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:734 | for (iRow < spdMain.ActiveSheet.RowCount) | DATA_OP | dtCutOff.Rows.Add | (nick_name, dept_id, cutoff_yyyymmdd, item_id, iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0615c3d | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:735 | for (iRow < spdMain.ActiveSheet.RowCount) | DATA_OP | dtTemp.Rows.Add | (nick_name, dept_id, cutoff_yyyymmdd, item_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd0e1551 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:739 |  | FLAG | dtDistinctCutOff | dtTemp.DefaultView.ToTable(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6342acc | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:739 |  | DATA_OP | dtTemp.DefaultView.ToTable | (true) | 데이터 객체 조작/조회 |  |  |  |

## SCP0075_Allo_Target.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a959691 | this.Load | SCP0075_Allo_Target.cs:230 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-54c0114d | this.Load | SCP0075_Allo_Target.cs:231 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1f68a32a | this.Load | SCP0075_Allo_Target.cs:233 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0075_Allo_Target.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b3dfa13 | this.Load | SCP0075_Allo_Target.cs:152 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-0246d137 | this.Load | SCP0075_Allo_Target.cs:153 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-911bd994 | this.Load | SCP0075_Allo_Target.cs:155 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-09a08f0f | this.Load | SCP0075_Allo_Target.cs:156 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-178b89c1 | this.Load | SCP0075_Allo_Target.cs:157 |  | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-a70089f3 | this.Load | SCP0075_Allo_Target.cs:157 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a8770dea | this.Load | SCP0075_Allo_Target.cs:158 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c064971c | this.Load | SCP0075_Allo_Target.cs:159 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-5784d43f | this.Load | SCP0075_Allo_Target.cs:160 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-642564a9 | this.Load | SCP0075_Allo_Target.cs:161 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellTypeGr, cboCellTypeGr, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0075_Allo_Target.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55a1f37e | this.Load | SCP0075_Allo_Target.cs:311 |  | GRID_INIT | spreadInfo.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-65ef0f50 | this.Load | SCP0075_Allo_Target.cs:312 |  | GRID_INIT | spreadInfo.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0075_Allo_Target.InitSpreadVariable

진입점: FindButton [try ▸ if (siMain.GetMaxColumnIndex() != dsBinding.Tables[0].Columns.Count)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (siMain.GetMaxColumnIndex() != dsBinding.Tables[0].Columns.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03c0921f | FindButton [try ▸ if (siMain.GetMaxColumnIndex() != dsBindin… 외 1 | SCP0075_Allo_Target.cs:342 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-103b1aa2 | FindButton [try ▸ if (siMain.GetMaxColumnIndex() != dsBindin… 외 1 | SCP0075_Allo_Target.cs:343 |  | DATA_OP | dtCol.Columns.Cast<DataColumn>().Select | (x => x.ColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-2681b16d | FindButton [try ▸ if (siMain.GetMaxColumnIndex() != dsBindin… 외 1 | SCP0075_Allo_Target.cs:343 |  | CALL_EXT | dtCol.Columns.Cast | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-50831d4a | FindButton [try ▸ if (siMain.GetMaxColumnIndex() != dsBindin… 외 1 | SCP0075_Allo_Target.cs:352 | foreach (string s in sColArray) | DATA_OP | sHeaderText_2_tmp.Contains | ("_") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9541c82 | FindButton [try ▸ if (siMain.GetMaxColumnIndex() != dsBindin… 외 1 | SCP0075_Allo_Target.cs:354 | foreach (string s in sColArray) ▸ if (sHeaderText_2_tmp.Contains("_")) | DATA_OP | sHeaderText_2_tmp.Remove | (0, sHeaderText_2_tmp.IndexOf('_') + 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-65eca2dd | FindButton [try ▸ if (siMain.GetMaxColumnIndex() != dsBindin… 외 1 | SCP0075_Allo_Target.cs:361 | foreach (string s in sColArray) | GRID_INIT | spdInfo.AddNumColumn | (sHeaderText, s, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5df2fff7 | FindButton [try ▸ if (siMain.GetMaxColumnIndex() != dsBindin… 외 1 | SCP0075_Allo_Target.cs:363 | foreach (string s in sColArray) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b7fd4e4e | FindButton [try ▸ if (siMain.GetMaxColumnIndex() != dsBindin… 외 1 | SCP0075_Allo_Target.cs:364 | foreach (string s in sColArray) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, sHeaderText) | 그리드 재구성/초기화 |  |  |  |
| AC-f258235e | FindButton [try ▸ if (siMain.GetMaxColumnIndex() != dsBindin… 외 1 | SCP0075_Allo_Target.cs:365 | foreach (string s in sColArray) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurIdx, sHeaderText_2) | 그리드 재구성/초기화 |  |  |  |

## SCP0075_Allo_Target.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa346026 | InsertButton | SCP0075_Allo_Target.cs:428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(txtMo… | MESSAGE | MessageHelper.GMessageBox | ("Model 필수 입력 후 조회한 상태에서 Insert 가능합니다..!") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a87d5e1 | InsertButton | SCP0075_Allo_Target.cs:429 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(txtMo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-398eb955 | InsertButton | SCP0075_Allo_Target.cs:444 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sItem… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0bf266db | InsertButton | SCP0075_Allo_Target.cs:448 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.InsertNewRow | (iInsertRowIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-03de09f2 | InsertButton | SCP0075_Allo_Target.cs:450 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefCol.DIVISION_ID, cboDivision.ControlValues.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-42b9da87 | InsertButton | SCP0075_Allo_Target.cs:451 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefCol.ITEM_ID, sItemId) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9db82ae | InsertButton | SCP0075_Allo_Target.cs:455 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefCol.CUTOFF_YYYYMMDD, dtPlanDate.Rows[0]["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e0f5fd2 | InsertButton | SCP0075_Allo_Target.cs:457 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-e8818129 | InsertButton | SCP0075_Allo_Target.cs:461 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol < siMain.ActiveSheet… | GRID_STYLE | siMain.ActiveSheet.SetColumnMerge | (iCol, FarPoint.Win.Spread.Model.MergePolicy.None) | 그리드 표시 설정 |  |  |  |
| AC-13b55e63 | InsertButton | SCP0075_Allo_Target.cs:464 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefCol.EXTRA_SPEC), siMain.GetColumnIndex(DefCol.EXTRA_SPE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9ce46344 | InsertButton | SCP0075_Allo_Target.cs:465 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefCol.MODEL), siMain.GetColumnIndex(DefCol.MODEL), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b7975e69 | InsertButton | SCP0075_Allo_Target.cs:466 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefCol.DEPT_NAME), siMain.GetColumnIndex(DefCol.DEPT_NAME)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8c81a00a | InsertButton | SCP0075_Allo_Target.cs:467 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefCol.CUTOFF_YYYYMMDD), siMain.GetColumnIndex(DefCol.CUTO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0e2c9298 | InsertButton | SCP0075_Allo_Target.cs:474 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol < siMain.ActiveSheet… | DATA_OP | sHeaderChk.Contains | ("Q") | 데이터 객체 조작/조회 |  |  |  |
| AC-68a6b80e | InsertButton | SCP0075_Allo_Target.cs:477 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol < siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (iInsertRowIdx, iCol, iInsertRowIdx, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-96155cf4 | InsertButton | SCP0075_Allo_Target.cs:481 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol < siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (iInsertRowIdx, iCol, iInsertRowIdx, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0075_Allo_Target.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7bdf181 | OnShown | SCP0075_Allo_Target.cs:1398 |  | STATE | cboOperationGroup.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b2d3f0c5 | OnShown | SCP0075_Allo_Target.cs:1400 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-667b3988 | OnShown | SCP0075_Allo_Target.cs:1402 |  | STATE | cboBucketType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4d72fe98 | OnShown | SCP0075_Allo_Target.cs:1404 |  | STATE | cboCellTypeGr.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0075_Allo_Target.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8d74d76 | SaveButton | SCP0075_Allo_Target.cs:1027 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bf7d506e | SaveButton | SCP0075_Allo_Target.cs:1038 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92778d51 | SaveButton | SCP0075_Allo_Target.cs:1041 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-1cc5a138 | SaveButton | SCP0075_Allo_Target.cs:1041 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e915af1d | SaveButton | SCP0075_Allo_Target.cs:1083 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39a68d28 | SaveButton | SCP0075_Allo_Target.cs:1084 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3fb5a51f | SaveButton | SCP0075_Allo_Target.cs:1089 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if… | DATA_OP | ds.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-809567de | SaveButton | SCP0075_Allo_Target.cs:1103 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d95dba3 | SaveButton | SCP0075_Allo_Target.cs:1104 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72be5d5f | SaveButton | SCP0075_Allo_Target.cs:1125 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-4d643a37 | SaveButton | SCP0075_Allo_Target.cs:1126 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b4b347a | SaveButton | SCP0075_Allo_Target.cs:1127 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-423bcde2 | SaveButton | SCP0075_Allo_Target.cs:1159 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c33eb3ff | SaveButton | SCP0075_Allo_Target.cs:1162 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0075_SAVE_ALLO_TARGET_SMALL") ⇒ SCP.SCP0075_SAVE_ALLO_TARGET_SMALL | 엔드포인트 요청 생성 |  |  |  |
| AC-303e8c95 | SaveButton | SCP0075_Allo_Target.cs:1168 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-01776c1a | SaveButton | SCP0075_Allo_Target.cs:1170 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d4d6892 | SaveButton | SCP0075_Allo_Target.cs:1174 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2b6160a0 | SaveButton | SCP0075_Allo_Target.cs:1176 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_ACTIVE_FLAG"] | n_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f2b46d21 | SaveButton | SCP0075_Allo_Target.cs:1177 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_DIVISION_ID"] | n_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d543cabd | SaveButton | SCP0075_Allo_Target.cs:1178 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_EXTRA_SPEC"] | n_extra_spec | 행/컬럼 값 대입 |  |  |  |
| AC-e6e3df73 | SaveButton | SCP0075_Allo_Target.cs:1179 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_CUTOFF_YYYYMMDD"] | n_cutoff_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d8995c51 | SaveButton | SCP0075_Allo_Target.cs:1180 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_DEPT_ID"] | n_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-72d1149e | SaveButton | SCP0075_Allo_Target.cs:1181 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_NICK_NAME"] | n_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-7a4bc2c3 | SaveButton | SCP0075_Allo_Target.cs:1182 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_ITEM_ID"] | n_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b78376a8 | SaveButton | SCP0075_Allo_Target.cs:1183 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_QTY"] | n_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1b13901a | SaveButton | SCP0075_Allo_Target.cs:1185 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_YYYY"] | n_yyyy | 행/컬럼 값 대입 |  |  |  |
| AC-fbd5b790 | SaveButton | SCP0075_Allo_Target.cs:1186 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_YYYYMM"] | n_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-f7e99a06 | SaveButton | SCP0075_Allo_Target.cs:1187 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["P_YYYYQQ"] | n_yyyyqq | 행/컬럼 값 대입 |  |  |  |
| AC-61f8cd71 | SaveButton | SCP0075_Allo_Target.cs:1194 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fe641706 | SaveButton | SCP0075_Allo_Target.cs:1194 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-2aca41ea | SaveButton | SCP0075_Allo_Target.cs:1204 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ce1ad22b | SaveButton | SCP0075_Allo_Target.cs:1205 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0d117a1 | SaveButton | SCP0075_Allo_Target.cs:1215 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-620e7367 | SaveButton | SCP0075_Allo_Target.cs:1216 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-179330a6 | SaveButton | SCP0075_Allo_Target.cs:1226 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dd9d434f | SaveButton | SCP0075_Allo_Target.cs:1227 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-877e17f9 | SaveButton | SCP0075_Allo_Target.cs:1234 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e6cd231 | SaveButton | SCP0075_Allo_Target.cs:1241 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-81579d3e | SaveButton | SCP0075_Allo_Target.cs:1242 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f57aafa6 | SaveButton | SCP0075_Allo_Target.cs:1248 | finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0075_Allo_Target.SelectCombo

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8aea9bf | OnShown | SCP0075_Allo_Target.cs:251 | if (iIdx >= 0) | VALUE_SET | cCombo.SelectedIndex | iIdx | 컨트롤 값 설정 |  |  |  |

## SCP0075_Allo_Target.SetCellTypeFormat

진입점: FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d919c55 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:1021 | for (iCol < siMain.ActiveSheet.Columns.Count) | UI_PROP | col.CellType | percentCellType | 속성 CellType 설정 |  |  |  |

## SCP0075_Allo_Target.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5a9e75a | this.Load 외 1 | SCP0075_Allo_Target.cs:259 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-483b343b | this.Load 외 1 | SCP0075_Allo_Target.cs:259 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d763f8be | this.Load 외 1 | SCP0075_Allo_Target.cs:261 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-e83a8249 | this.Load 외 1 | SCP0075_Allo_Target.cs:261 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "40,81,82") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f151962 | this.Load 외 1 | SCP0075_Allo_Target.cs:262 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8834b4a3 | this.Load 외 1 | SCP0075_Allo_Target.cs:263 |  | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.AllPlantSiteDescription, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-19a6947c | this.Load 외 1 | SCP0075_Allo_Target.cs:263 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.AllPlantSiteDescription, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26848fc2 | this.Load 외 1 | SCP0075_Allo_Target.cs:269 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-ebaa92d2 | this.Load 외 1 | SCP0075_Allo_Target.cs:269 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b00254c | this.Load 외 1 | SCP0075_Allo_Target.cs:273 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-26d36b06 | this.Load 외 1 | SCP0075_Allo_Target.cs:273 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-50139e28 | this.Load 외 1 | SCP0075_Allo_Target.cs:275 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9787a92d | this.Load 외 1 | SCP0075_Allo_Target.cs:281 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ try ▸ if (!division.Substring(0, 2).Equals("EE")) | DATA_OP | dtFromSite.Select() .Where(c => c[DefMain.OPERATION_GROUP].ToString() == sOperationGroup.T… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f1e3aa67 | this.Load 외 1 | SCP0075_Allo_Target.cs:281 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ try ▸ if (!division.Substring(0, 2).Equals("EE")) | DATA_OP | dtFromSite.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8206f579 | this.Load 외 1 | SCP0075_Allo_Target.cs:287 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ try ▸ else of (!division.Substring(0, 2).Equals("EE")) | DATA_OP | dtFromSite.Select() .Where(c => c[DefMain.OPERATION_GROUP].ToString() == sOperationGroup.T… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f08e53fd | this.Load 외 1 | SCP0075_Allo_Target.cs:287 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ try ▸ else of (!division.Substring(0, 2).Equals("EE")) | DATA_OP | dtFromSite.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3cfbc609 | this.Load 외 1 | SCP0075_Allo_Target.cs:297 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data_SCP.Common(Data_SCP.Type.PlanDate_AlloTarget2, false, null) | 화면 필드/플래그 변경 |  |  |  |
| AC-c680ea6c | this.Load 외 1 | SCP0075_Allo_Target.cs:297 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlanDate_AlloTarget2, false, null) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3142f7e5 | this.Load 외 1 | SCP0075_Allo_Target.cs:298 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0075_Allo_Target.SetColor

진입점: FindButton [try] / EditButton [if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain")] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d715635 | FindButton [try] 외 2 | SCP0075_Allo_Target.cs:405 | for (i < siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) | GRID_SET | siMain.ActiveSheet.Cells[i, j].BackColor | System.Drawing.Color.Aqua | 그리드 속성/값 설정 |  |  |  |

## SCP0075_Allo_Target.SetFormula

진입점: FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9ff891c | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:801 | for (iCol < siMain.ActiveSheet.ColumnCount) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (sHeaderText.Equals(DefFormul.TOTAL)) ▸ if (!s… | GRID_SET | spdMain.ActiveSheet.Cells[iRow, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |
| AC-3aa4a509 | FindButton [try] 외 1 | SCP0075_Allo_Target.cs:856 | for (iCol < siMain.ActiveSheet.ColumnCount) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (sHeaderText.Equals(DefFormul.RATE)) | GRID_SET | spdMain.ActiveSheet.Cells[iRow, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |

## SCP0075_Allo_Target.SetFormula_Quarter_Plan

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8ecbeb3 | (진입점 미연결) | SCP0075_Allo_Target.cs:984 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) | DATA_OP | sHeaderTextYyyyMm.Contains | ("Q") | 데이터 객체 조작/조회 |  |  |  |
| AC-c688bed5 | (진입점 미연결) | SCP0075_Allo_Target.cs:989 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) | DATA_OP | sHeaderTextYyyyMm.Contains | ("Q") | 데이터 객체 조작/조회 |  |  |  |
| AC-1eeadc0e | (진입점 미연결) | SCP0075_Allo_Target.cs:994 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (sHeaderTextYyyyMm.Contains("Q") && sHeaderTex… | GRID_SET | spdMain.ActiveSheet.Cells[iRow, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |

## SCP0075_Allo_Target.SetFormula_Quarter_Plan_2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a74aea25 | (진입점 미연결) | SCP0075_Allo_Target.cs:886 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.DisplayedSheet.GetValue(iRow, 0) != null) | DATA_OP | ListItem.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0062fbf | (진입점 미연결) | SCP0075_Allo_Target.cs:907 | if (ListItem.Count > 0) ▸ foreach (int obj in ListItem) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (obj == iRow) ▸ for (iCol < siMain… | DATA_OP | sHeaderTextYyyyMm.Contains | ("Q") | 데이터 객체 조작/조회 |  |  |  |
| AC-550db0c2 | (진입점 미연결) | SCP0075_Allo_Target.cs:912 | if (ListItem.Count > 0) ▸ foreach (int obj in ListItem) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (obj == iRow) ▸ for (iCol < siMain… | DATA_OP | sHeaderTextYyyyMm.Contains | ("Q") | 데이터 객체 조작/조회 |  |  |  |
| AC-03343b5a | (진입점 미연결) | SCP0075_Allo_Target.cs:917 | if (ListItem.Count > 0) ▸ foreach (int obj in ListItem) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (obj == iRow) ▸ for (iCol < siMain… | GRID_SET | spdMain.ActiveSheet.Cells[iRow, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |
| AC-ecee775e | (진입점 미연결) | SCP0075_Allo_Target.cs:941 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) | DATA_OP | sHeaderTextYyyyMm.Contains | ("Q") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab2828c2 | (진입점 미연결) | SCP0075_Allo_Target.cs:946 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) | DATA_OP | sHeaderTextYyyyMm.Contains | ("Q") | 데이터 객체 조작/조회 |  |  |  |
| AC-73fce138 | (진입점 미연결) | SCP0075_Allo_Target.cs:951 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (sHeaderTextYyyyMm.Contains("Q") && sHeaderTex… | GRID_SET | spdMain.ActiveSheet.Cells[iRow, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |

## SCP0075_Allo_Target.SetPeriod

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5343fe63 | this.Load 외 1 | SCP0075_Allo_Target.cs:202 |  | UI_PROP | umpMonthFrom.MonthText | cboPlanDate.ControlValues.ToString().Substring(0, 4) + "-" + sRsltMonth | 속성 MonthText 설정 |  |  |  |
| AC-636d92ad | this.Load 외 1 | SCP0075_Allo_Target.cs:205 |  | UI_PROP | umpMonthTo.MonthText | dtTo.ToString("yyyyMM") | 속성 MonthText 설정 |  |  |  |

## SCP0075_Allo_Target.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b71a515a | this.Load | SCP0075_Allo_Target.cs:318 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-990ef8af | this.Load | SCP0075_Allo_Target.cs:319 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-a51cfd91 | this.Load | SCP0075_Allo_Target.cs:320 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-2b087396 | this.Load | SCP0075_Allo_Target.cs:321 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0075_Allo_Target.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8070c0d0 | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1272 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0818c478 | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1276 | if (vActionChk != "I") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19deb3b7 | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1287 | if (e.Column == siMain.GetColumnIndex(DefCol.ITEM_ID)) | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a6cb3bac | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1289 | if (e.Column == siMain.GetColumnIndex(DefCol.ITEM_ID)) | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1509f52a | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1290 | if (e.Column == siMain.GetColumnIndex(DefCol.ITEM_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c926ac68 | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1291 | if (e.Column == siMain.GetColumnIndex(DefCol.ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-efc5e405 | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1296 | if (e.Column == siMain.GetColumnIndex(DefCol.ITEM_ID)) ▸ if (string.IsNullOrEmpty(sItemId)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee3c6165 | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1298 | if (e.Column == siMain.GetColumnIndex(DefCol.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefCol.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-51133397 | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1299 | if (e.Column == siMain.GetColumnIndex(DefCol.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefCol.MODEL), sNickName) | 그리드 값 설정 |  |  |  |
| AC-05dd289d | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1309 | if (e.Column == siMain.GetColumnIndex(DefCol.DEPT_ID)) | POPUP | new SCM0002_TeamPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ebf4b49a | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1311 | if (e.Column == siMain.GetColumnIndex(DefCol.DEPT_ID)) | POPUP | popTeam.Form_Load | (false, sTeamID, sTeamName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0b57f5ee | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1312 | if (e.Column == siMain.GetColumnIndex(DefCol.DEPT_ID)) | UI_PROP | popTeam.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2d8645aa | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1313 | if (e.Column == siMain.GetColumnIndex(DefCol.DEPT_ID)) | POPUP | popTeam.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9577c016 | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1321 | if (e.Column == siMain.GetColumnIndex(DefCol.DEPT_ID)) ▸ if (popTeam.TeamId != "") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefCol.DEPT_ID), sTeamID) | 그리드 값 설정 |  |  |  |
| AC-a86d1acb | this.spdMain.CellDoubleClick | SCP0075_Allo_Target.cs:1322 | if (e.Column == siMain.GetColumnIndex(DefCol.DEPT_ID)) ▸ if (popTeam.TeamId != "") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefCol.DEPT_NAME), sTeamName) | 그리드 값 설정 |  |  |  |

