# AS-IS 액션 대조표 — SCP0041

> 원천: `Doc/asisfacts/screens/SCP0041/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 169행 · 메서드 23 · 종류 DATA_OP 37 · UI_PROP 25 · RETURN 14 · ENDPOINT 14 · GRID_INIT 11 · MESSAGE 10 · FLAG 10 · UI_MISC 10 · GRID_LOCK 10 · POPUP 9 · VALUE_SET 5 · GRID_SET 4 · VALIDATE 3 · LIST_REBIND 3 · GRID_BIND 2 · CALL_BASE 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 1


## SCP0041_StockOSP.ActiveSheet_CellChanged

진입점: this.siMain.ActiveSheet.CellChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52965283 | this.siMain.ActiveSheet.CellChanged | SCP0041_StockOSP.cs:821 | try ▸ if (e.Column == siMain.GetColumnIndex(DefPack.DATE_FORECAST_START) \|\| e.Column == siMain.GetColumnIndex(DefPack.DATE_FORECAS…) ▸ if … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05004629 | this.siMain.ActiveSheet.CellChanged | SCP0041_StockOSP.cs:830 | try ▸ if (e.Column == siMain.GetColumnIndex(DefPack.DATE_FORECAST_START) \|\| e.Column == siMain.GetColumnIndex(DefPack.DATE_FORECAS…) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-487552da | this.siMain.ActiveSheet.CellChanged | SCP0041_StockOSP.cs:834 | try ▸ if (e.Column == siMain.GetColumnIndex(DefPack.DATE_FORECAST_START) \|\| e.Column == siMain.GetColumnIndex(DefPack.DATE_FORECAS…) ▸ if … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefPack.DATE_FORECAST_START), DATE_FORECAST_FINISH_ORG) | 그리드 값 설정 |  |  |  |
| AC-7311f5bb | this.siMain.ActiveSheet.CellChanged | SCP0041_StockOSP.cs:838 | try ▸ if (e.Column == siMain.GetColumnIndex(DefPack.DATE_FORECAST_START) \|\| e.Column == siMain.GetColumnIndex(DefPack.DATE_FORECAS…) ▸ if … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefPack.DATE_FORECAST_FINISH), DATE_FORECAST_START_ORG) | 그리드 값 설정 |  |  |  |
| AC-427a12f1 | this.siMain.ActiveSheet.CellChanged | SCP0041_StockOSP.cs:840 | try ▸ if (e.Column == siMain.GetColumnIndex(DefPack.DATE_FORECAST_START) \|\| e.Column == siMain.GetColumnIndex(DefPack.DATE_FORECAS…) ▸ if … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19a2be9d | this.siMain.ActiveSheet.CellChanged | SCP0041_StockOSP.cs:848 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## SCP0041_StockOSP.btnExcelFormDownload_Click

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53e23cdf | this.formDown.Click | SCP0041_StockOSP.cs:896 |  | CALL_BASE | MenuEtcFileDownButton | ("StockOSP_ExcelForm.xls") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0041_StockOSP.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42e58b59 | this.btnExcelUpload.Click | SCP0041_StockOSP.cs:792 |  | POPUP | new ExcelUploadForm | ("SCP0041", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-2c704f02 | this.btnExcelUpload.Click | SCP0041_StockOSP.cs:793 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-cd84d0a4 | this.btnExcelUpload.Click | SCP0041_StockOSP.cs:794 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7059c1b3 | this.btnExcelUpload.Click | SCP0041_StockOSP.cs:795 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0041_StockOSP.BtnItemId_Click

진입점: btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ef9b08f | btnItemId.Click | SCP0041_StockOSP.cs:872 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-30c294fc | btnItemId.Click | SCP0041_StockOSP.cs:874 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-44068e16 | btnItemId.Click | SCP0041_StockOSP.cs:875 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d061660b | btnItemId.Click | SCP0041_StockOSP.cs:876 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9ec7deee | btnItemId.Click | SCP0041_StockOSP.cs:882 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0041_StockOSP.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b4b3133 | this.Load | SCP0041_StockOSP.cs:174 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ad85cd7b | this.Load | SCP0041_StockOSP.cs:175 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-17ed9ddb | this.Load | SCP0041_StockOSP.cs:177 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPacker, SpdSheet.shtPacker, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c26cb9c4 | this.Load | SCP0041_StockOSP.cs:178 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-81c5bc13 | this.Load | SCP0041_StockOSP.cs:180 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0041_StockOSP.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69232528 | this.Load | SCP0041_StockOSP.cs:135 |  | UI_PROP | usrConditionPanel1.Height | 48 | 속성 Height 설정 |  |  |  |

## SCP0041_StockOSP.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4b99157 | Dispose | SCP0041_StockOSP.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0041_StockOSP.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d5b2922 | EditButton | SCP0041_StockOSP.cs:268 | if (iFocusTabIndex == 1) ▸ if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-114a8ea8 | EditButton | SCP0041_StockOSP.cs:269 | if (iFocusTabIndex == 1) ▸ if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-bd6b5674 | EditButton | SCP0041_StockOSP.cs:281 | if (iFocusTabIndex == 1) ▸ if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockRange | (iRowStart, iColStart, iRowEnd, iColEnd, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5d2ffae | EditButton | SCP0041_StockOSP.cs:284 | if (iFocusTabIndex == 1) ▸ if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ if (IsEditMode == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47c0843f | EditButton | SCP0041_StockOSP.cs:294 | if (iFocusTabIndex == 1) ▸ if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ for (iRow < siMain.ActiveShee… | GRID_LOCK | siMain.LockRange | (iRow, iCol_QTY, iRow, iCol_QTY, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b2103e11 | EditButton | SCP0041_StockOSP.cs:295 | if (iFocusTabIndex == 1) ▸ if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ for (iRow < siMain.ActiveShee… | GRID_LOCK | siMain.LockRange | (iRow, iCol_DATE_FORECAST_START, iRow, iCol_DATE_FORECAST_START, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5449a17a | EditButton | SCP0041_StockOSP.cs:296 | if (iFocusTabIndex == 1) ▸ if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ for (iRow < siMain.ActiveShee… | GRID_LOCK | siMain.LockRange | (iRow, iCol_DATE_FORECAST_FINISH, iRow, iCol_DATE_FORECAST_FINISH, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a49d924 | EditButton | SCP0041_StockOSP.cs:300 | if (iFocusTabIndex == 1) ▸ if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ for (iRow < siMain.ActiveShee… | GRID_LOCK | siMain.LockRange | (iRow, iCol_QTY, iRow, iCol_QTY, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-87848f6e | EditButton | SCP0041_StockOSP.cs:301 | if (iFocusTabIndex == 1) ▸ if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ for (iRow < siMain.ActiveShee… | GRID_LOCK | siMain.LockRange | (iRow, iCol_DATE_FORECAST_START, iRow, iCol_DATE_FORECAST_START, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-942206f1 | EditButton | SCP0041_StockOSP.cs:302 | if (iFocusTabIndex == 1) ▸ if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ for (iRow < siMain.ActiveShee… | GRID_LOCK | siMain.LockRange | (iRow, iCol_DATE_FORECAST_FINISH, iRow, iCol_DATE_FORECAST_FINISH, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0041_StockOSP.FindData_Main

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d16f1c06 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:631 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-443f0062 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:631 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f1b2b5a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:651 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-11390f5b | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:653 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0ea8e6c2 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:658 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fa9708b0 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:660 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_MASTER… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c5ae86a7 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:662 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0041_GET_STOCK_OSP") ⇒ SCP.SCP0041_GET_STOCK_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-ee3fabd3 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:663 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4172cfb5 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:664 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-822c39f3 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:665 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-01d68cb3 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:666 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-64f8c655 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:667 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e3e1f14a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:668 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3e644620 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:670 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-401a4a6f | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:671 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-82fd2201 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:678 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f82cea37 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:679 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cebd8ba3 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:682 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f0733e4e | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:687 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ef0e47ae | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:689 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c732da13 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:691 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d101bfdb | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0041_StockOSP.cs:692 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0041_StockOSP.FindData_Pack

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)] / SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2221f02b | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:704 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-988aaa26 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:704 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23a2f849 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:727 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-66f923a5 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:730 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-743f1935 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:735 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4cf7e48a | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:737 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_MASTER… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-953623fd | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:740 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0041_GET_PACK_HOLD_STOCK") ⇒ SCP.SCP0041_GET_PACK_HOLD_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-3a495137 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:741 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b3d9a87d | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:742 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b0d78a3 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:743 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6037ff3f | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:744 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-09aa8a15 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:745 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-81e16dab | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:746 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-796ec9fb | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:747 | try ▸ lambda | DATA_OP | req.Parameters["p_inspection_id"] | p_inspection_id | 행/컬럼 값 대입 |  |  |  |
| AC-f4b6237e | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:748 | try ▸ lambda | DATA_OP | req.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-86b43709 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:749 | try ▸ lambda | DATA_OP | req.Parameters["p_cutoff_from_yyyymmdd"] | p_cutoff_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4bc446f2 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:750 | try ▸ lambda | DATA_OP | req.Parameters["p_cutoff_to_yyyymmdd"] | p_cutoff_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-804ec7fa | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:752 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-86978176 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:753 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-937727ed | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:760 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2ed2cb2a | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:761 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1f82275d | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:765 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d638df4 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:771 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c4b11977 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:773 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58b72ae2 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:777 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5323b795 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0041_StockOSP.cs:778 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0041_StockOSP.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55a471bb | this.Load | SCP0041_StockOSP.cs:122 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0041_StockOSP.GetDayRange

진입점: this.Load [if (iFocusTabIndex == 1)] / spdMain.SheetTabClick [if (iFocusTabIndex == 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58d27589 | this.Load [if (iFocusTabIndex == 1)] 외 1 | SCP0041_StockOSP.cs:588 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0041_StockOSP.GetLookupData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4625f3ac | this.Load | SCP0041_StockOSP.cs:165 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-fd4bd764 | this.Load | SCP0041_StockOSP.cs:166 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-266573c2 | this.Load | SCP0041_StockOSP.cs:167 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c90a3302 | this.Load | SCP0041_StockOSP.cs:169 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0041_StockOSP.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9d594ba | this.Load | SCP0041_StockOSP.cs:143 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-6a2cacbb | this.Load | SCP0041_StockOSP.cs:145 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3058d4d0 | this.Load | SCP0041_StockOSP.cs:146 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-633d59ef | this.Load | SCP0041_StockOSP.cs:148 |  | FLAG | dtStatus | GetLookupData("PACKER_HOLD_STATUS") | 화면 필드/플래그 변경 |  |  |  |
| AC-3bc1d1d8 | this.Load | SCP0041_StockOSP.cs:149 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-99327a21 | this.Load | SCP0041_StockOSP.cs:150 |  | LIST_REBIND | clsCtrl.setListBox | (dtStatus, cboStatus, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9ef6125c | this.Load | SCP0041_StockOSP.cs:156 |  | VALUE_SET | layoutInspection.Text | DefPackLabel.INSEPECTION_ID | 컨트롤 값 설정 |  |  |  |

## SCP0041_StockOSP.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c16d906d | this.Load 외 3 | SCP0041_StockOSP.cs:195 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-530e872d | this.Load 외 3 | SCP0041_StockOSP.cs:196 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0041_StockOSP.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a25016c2 | SaveButton | SCP0041_StockOSP.cs:315 | if (iFocusTabIndex == 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0041_StockOSP.SaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a46c1c3c | (진입점 미연결) | SCP0041_StockOSP.cs:354 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA") ⇒ SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-2e1aa1bf | (진입점 미연결) | SCP0041_StockOSP.cs:356 | if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2f3a015c | (진입점 미연결) | SCP0041_StockOSP.cs:358 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-feaf8965 | (진입점 미연결) | SCP0041_StockOSP.cs:360 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-504846c5 | (진입점 미연결) | SCP0041_StockOSP.cs:361 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2c1fcc2f | (진입점 미연결) | SCP0041_StockOSP.cs:362 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f2072337 | (진입점 미연결) | SCP0041_StockOSP.cs:363 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f31d843d | (진입점 미연결) | SCP0041_StockOSP.cs:364 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_daily_capa_qty"] | p_daily_capa_qty | 행/컬럼 값 대입 |  |  |  |
| AC-5414810e | (진입점 미연결) | SCP0041_StockOSP.cs:365 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-71b8cec0 | (진입점 미연결) | SCP0041_StockOSP.cs:366 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-2adf8a4b | (진입점 미연결) | SCP0041_StockOSP.cs:367 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-a8ddeb01 | (진입점 미연결) | SCP0041_StockOSP.cs:368 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-718b8d5e | (진입점 미연결) | SCP0041_StockOSP.cs:368 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-ae12f4f7 | (진입점 미연결) | SCP0041_StockOSP.cs:373 | if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0041_StockOSP.SaveDataPacker

진입점: SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8ba4948 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:449 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (nDate1 > nDate2) | GRID_SET | siMain.ActiveSheet.Cells[i, iCol_DATE_FORECAST_START].BackColor | Color.LightPink | 그리드 속성/값 설정 |  |  |  |
| AC-e1d833ae | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:450 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (nDate1 > nDate2) | GRID_SET | siMain.ActiveSheet.Cells[i, iCol_DATE_FORECAST_FINISH].BackColor | Color.LightPink | 그리드 속성/값 설정 |  |  |  |
| AC-c5bc4229 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:463 | try ▸ if (iCheckCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35a43169 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:464 | try ▸ if (iCheckCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96099339 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:469 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0041_SAVE_PACKER_HOLD_STOCK") ⇒ SCP.SCP0041_SAVE_PACKER_HOLD_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-11abfc06 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:471 | try ▸ if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8fe5efd0 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:473 | try ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { req.Paramet… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-474acf0d | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:476 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8ea460db | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:477 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_inspection_id"] | p_inspection_id | 행/컬럼 값 대입 |  |  |  |
| AC-9f9e3551 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:478 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_dir"] | p_dir | 행/컬럼 값 대입 |  |  |  |
| AC-078a6acc | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:479 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-7d3b933d | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:480 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_prod_id"] | p_prod_id | 행/컬럼 값 대입 |  |  |  |
| AC-ca03e261 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:481 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-fc6d23ab | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:482 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_date_forecast_start"] | p_date_forecast_start | 행/컬럼 값 대입 |  |  |  |
| AC-c3df6d74 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:483 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_date_forecast_finish"] | p_date_forecast_finish | 행/컬럼 값 대입 |  |  |  |
| AC-1c072cac | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:484 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_cutoff_date"] | p_cutoff_date | 행/컬럼 값 대입 |  |  |  |
| AC-88b2066d | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:485 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-31b8ddfd | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:486 | try ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5b2e78a2 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:486 | try ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-11b5be4c | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:492 | try ▸ if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9a1fb3d9 | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:500 | try ▸ if (iCount > 0) ▸ else of (tran.Success) | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b368cc2a | SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMe… | SCP0041_StockOSP.cs:508 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0041_StockOSP.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged / spdMain.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d900f88 | this.Load 외 2 | SCP0041_StockOSP.cs:524 |  | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll,filterExpression,true) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a280867 | this.Load 외 2 | SCP0041_StockOSP.cs:524 |  | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll,filterExpression,true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f7d0f0ba | this.Load 외 2 | SCP0041_StockOSP.cs:526 |  | FLAG | dtSalesSiteByDivision | DBUtils.Filter(dtSalesSiteByDivisionAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-952dc0ee | this.Load 외 2 | SCP0041_StockOSP.cs:526 |  | DATA_OP | DBUtils.Filter | (dtSalesSiteByDivisionAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-49627784 | this.Load 외 2 | SCP0041_StockOSP.cs:528 |  | DATA_OP | dtPlantSiteByDivision.Merge | (dtSalesSiteByDivision) | 데이터 객체 조작/조회 |  |  |  |
| AC-91bd0eab | this.Load 외 2 | SCP0041_StockOSP.cs:532 | if (iFocusTabIndex == 1) | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAllIF, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a512d77 | this.Load 외 2 | SCP0041_StockOSP.cs:532 | if (iFocusTabIndex == 1) | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAllIF, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5b66c698 | this.Load 외 2 | SCP0041_StockOSP.cs:535 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0041_StockOSP.setPeriod

진입점: this.Load / spdMain.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03b36e18 | this.Load 외 1 | SCP0041_StockOSP.cs:543 | if (iFocusTabIndex == 1) | VALUE_SET | dCalendar.InitValue | GetDayRange(DefTerm.PERIOD) | 컨트롤 값 설정 |  |  |  |
| AC-198c308c | this.Load 외 1 | SCP0041_StockOSP.cs:544 | if (iFocusTabIndex == 1) | VALUE_SET | dCalendarCutoff.InitValue | GetDayRange(DefTerm.CUTOFFDATE) | 컨트롤 값 설정 |  |  |  |
| AC-b56c1585 | this.Load 외 1 | SCP0041_StockOSP.cs:545 | if (iFocusTabIndex == 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9bfc1cd6 | this.Load 외 1 | SCP0041_StockOSP.cs:549 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_DEFAULT") ⇒ biz:CommonData.CommonDataList [code=PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aaeec796 | this.Load 외 1 | SCP0041_StockOSP.cs:554 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1dce63d0 | this.Load 외 1 | SCP0041_StockOSP.cs:566 |  | VALUE_SET | dCalendar.InitValue | MonthText1 + ":" + MonthText2 | 컨트롤 값 설정 |  |  |  |

## SCP0041_StockOSP.SetSelectMenu

진입점: this.Load / spdMain.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6056d43 | this.Load 외 1 | SCP0041_StockOSP.cs:597 |  | UI_PROP | layoutInspection.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-63b90dcb | this.Load 외 1 | SCP0041_StockOSP.cs:598 |  | UI_PROP | layStatus.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b949a020 | this.Load 외 1 | SCP0041_StockOSP.cs:603 | if (iFocusTabIndex == 0) | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-51daa88f | this.Load 외 1 | SCP0041_StockOSP.cs:604 | if (iFocusTabIndex == 0) | UI_PROP | layoutControlItem2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-174164fe | this.Load 외 1 | SCP0041_StockOSP.cs:605 | if (iFocusTabIndex == 0) | UI_PROP | layoutInspection.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-05531539 | this.Load 외 1 | SCP0041_StockOSP.cs:606 | if (iFocusTabIndex == 0) | UI_PROP | layStatus.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c3784655 | this.Load 외 1 | SCP0041_StockOSP.cs:607 | if (iFocusTabIndex == 0) | UI_PROP | layoutCutoffDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-baf28849 | this.Load 외 1 | SCP0041_StockOSP.cs:615 | else of (iFocusTabIndex == 0) | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9aed76c5 | this.Load 외 1 | SCP0041_StockOSP.cs:616 | else of (iFocusTabIndex == 0) | UI_PROP | layoutControlItem2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a70a2c25 | this.Load 외 1 | SCP0041_StockOSP.cs:617 | else of (iFocusTabIndex == 0) | UI_PROP | layoutInspection.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-adda5fc5 | this.Load 외 1 | SCP0041_StockOSP.cs:618 | else of (iFocusTabIndex == 0) | UI_PROP | layStatus.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-cc1c091e | this.Load 외 1 | SCP0041_StockOSP.cs:619 | else of (iFocusTabIndex == 0) | UI_PROP | layoutCutoffDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-68965dc2 | this.Load 외 1 | SCP0041_StockOSP.cs:620 | else of (iFocusTabIndex == 0) | UI_PROP | this.layoutCutoffDate.Location | new System.Drawing.Point(716, 0) | 속성 Location 설정 |  |  |  |
| AC-7e9eaf18 | this.Load 외 1 | SCP0041_StockOSP.cs:621 | else of (iFocusTabIndex == 0) | UI_PROP | this.layoutInspection.Location | new System.Drawing.Point(976, 0) | 속성 Location 설정 |  |  |  |
| AC-87317a73 | this.Load 외 1 | SCP0041_StockOSP.cs:622 | else of (iFocusTabIndex == 0) | UI_PROP | this.layStatus.Location | new System.Drawing.Point(1142, 0) | 속성 Location 설정 |  |  |  |

## SCP0041_StockOSP.SetSpreadInit

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (iFocusTabIndex == 1) ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1faef99 | this.Load 외 3 | SCP0041_StockOSP.cs:203 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbb58167 | this.Load 외 3 | SCP0041_StockOSP.cs:204 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-47a25798 | this.Load 외 3 | SCP0041_StockOSP.cs:208 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-517e9476 | this.Load 외 3 | SCP0041_StockOSP.cs:209 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-5c632055 | this.Load 외 3 | SCP0041_StockOSP.cs:211 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-9699e6e4 | this.Load 외 3 | SCP0041_StockOSP.cs:213 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0041_StockOSP.SetTabIndex

진입점: spdMain.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43efe183 | spdMain.SheetTabClick | SCP0041_StockOSP.cs:516 |  | FLAG | iFocusTabIndex | index | 화면 필드/플래그 변경 |  |  |  |

