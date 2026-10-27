# AS-IS 액션 대조표 — SCP0126

> 원천: `Doc/asisfacts/screens/SCP0126/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 998행 · 메서드 83 · 종류 DATA_OP 298 · RETURN 112 · FLAG 86 · MESSAGE 73 · UI_PROP 63 · GRID_SET 60 · GRID_LOCK 47 · CALL_EXT 42 · GRID_INIT 41 · UI_MISC 41 · ENDPOINT 41 · POPUP 32 · LIST_REBIND 27 · VALUE_SET 16 · VALIDATE 8 · GRID_CLEAR 4 · LIST_BIND 3 · GRID_BIND 2 · CALL_BASE 1 · STATE 1 · ⚠ 의미 확인 필요 43


## SCP0126_CAPA._defaultDataModel_Changed

진입점: _defaultDataModel.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab29fa1e | _defaultDataModel.Changed | SCP0126_CAPA.cs:3949 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (e.Column == siMain.GetC… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DAY_OF_WEEK), dayOfWeek) | 그리드 값 설정 |  |  |  |

## SCP0126_CAPA.BtnBatchSave_Click

진입점: btnBatchSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6e46701 | btnBatchSave.Click | SCP0126_CAPA.cs:4208 |  | POPUP | new GSCM.SCM.Master.UIL.SCP0126_NoWork_BatchPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a60b4fa8 | btnBatchSave.Click | SCP0126_CAPA.cs:4209 |  | POPUP | popup.Form_Load | (division, dtPlantId, dtLineAll) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c636761c | btnBatchSave.Click | SCP0126_CAPA.cs:4210 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7e4755a8 | btnBatchSave.Click | SCP0126_CAPA.cs:4212 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0126_CAPA.BtnExcelForm_Click

진입점: btnExcelForm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca347b30 | btnExcelForm.Click | SCP0126_CAPA.cs:4200 |  | CALL_BASE | MenuEtcFileDownButton | ("NoWork_ExcelForm.xls") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0126_CAPA.BtnExcelUpload_Click

진입점: btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6201be51 | btnExcelUpload.Click | SCP0126_CAPA.cs:4192 |  | POPUP | new ExcelUploadForm | ("SCP0126", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-785038e0 | btnExcelUpload.Click | SCP0126_CAPA.cs:4193 |  | UI_PROP | frm.SaveExceptError | false | 속성 SaveExceptError 설정 |  |  |  |
| AC-f86ead79 | btnExcelUpload.Click | SCP0126_CAPA.cs:4194 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9ed6bc61 | btnExcelUpload.Click | SCP0126_CAPA.cs:4195 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0126_CAPA.cboBucketType_SelectedIndexChanged

진입점: cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7863a5cf | cboBucketType.SelectedIndexChanged | SCP0126_CAPA.cs:3853 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0126_CAPA.CboPlanGroup_SelectedIndexChanged

진입점: cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d3466b0 | cboPlanGroup.SelectedIndexChanged | SCP0126_CAPA.cs:3838 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0126_CAPA.CheckDouble

진입점: SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (division_id == "EE_UC" && operation_id == "E2000")) ▸ if (!string.IsNullOrEmpty(prdn_oper_rt))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4cb4b75 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa) … | SCP0126_CAPA.cs:3651 | if (double.TryParse(doubleText, out double number)) ▸ if (sFieldText == DefColumns.ELEC_POST \|\| sFieldText == DefColumns.ASSY) ▸ if (dotCo… | MESSAGE | MessageHelper.GMessageBox | ("{0} \r\n소수점 최대 10자리까지 입력가능합니다. ", new object[] { args + doubleText }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d8f944af | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa) … | SCP0126_CAPA.cs:3653 | if (double.TryParse(doubleText, out double number)) ▸ if (sFieldText == DefColumns.ELEC_POST \|\| sFieldText == DefColumns.ASSY) ▸ if (dotCo… | RETURN | return isNotError; |  | 처리 중단/반환 |  |  |  |
| AC-434eb29e | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa) … | SCP0126_CAPA.cs:3687 | else of (double.TryParse(doubleText, out double number)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { args + doubleText }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce1a4edb | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa) … | SCP0126_CAPA.cs:3689 | else of (double.TryParse(doubleText, out double number)) | RETURN | return isNotError; |  | 처리 중단/반환 |  |  |  |
| AC-326abae5 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa) … | SCP0126_CAPA.cs:3692 |  | RETURN | return isNotError; |  | 처리 중단/반환 |  |  |  |

## SCP0126_CAPA.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b8f54a3 | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3710 |  | DATA_OP | DBUtils.Filter | (dtExptDivAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e5770ddb | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3717 | if (dtExptDiv.Rows.Count > 0) ▸ for (i < dtExptDiv.Rows.Count) | CALL_EXT | siMain.RemoveSheet | (dtExptDiv.Rows[i]["SHEET_NAME"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f865030c | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3722 | if (dtExptDiv.Rows.Count > 0) ▸ for (i < _spdSheets.Length) | DATA_OP | DBUtils.Filter | (dtExptDiv, "SHEET_NAME = '" + _spdSheets[i] + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-24618d82 | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3730 | if (dtExptDiv.Rows.Count > 0) ▸ for (i < _spdSheets.Length) ▸ else of (dtExptDivTemp.Rows.Count > 0) | DATA_OP | spdMain.Sheets.Find | (_spdSheets[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa35af09 | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3736 | if (dtExptDiv.Rows.Count > 0) ▸ for (i < _spdSheets.Length) ▸ else of (dtExptDivTemp.Rows.Count > 0) ▸ if (sv == null) ▸ if (_spdSheets[i] =… | GRID_INIT | this.AddSheet | (spdMain, _spdSheets[i], _spdSheets[i], 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-54756f95 | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3740 | if (dtExptDiv.Rows.Count > 0) ▸ for (i < _spdSheets.Length) ▸ else of (dtExptDivTemp.Rows.Count > 0) ▸ if (sv == null) ▸ else of (_spdSheets… | GRID_INIT | this.AddSheet | (spdMain, _spdSheets[i], _spdSheets[i], 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-916e04be | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3742 | if (dtExptDiv.Rows.Count > 0) ▸ for (i < _spdSheets.Length) ▸ else of (dtExptDivTemp.Rows.Count > 0) ▸ if (sv == null) | FLAG | siMain | GetSheetInfo(spdMain.Name, _spdSheets[i]) | 화면 필드/플래그 변경 |  |  |  |
| AC-67521726 | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3752 | else of (dtExptDiv.Rows.Count > 0) ▸ for (i < _spdSheets.Length) | DATA_OP | spdMain.Sheets.Find | (_spdSheets[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-32666193 | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3758 | else of (dtExptDiv.Rows.Count > 0) ▸ for (i < _spdSheets.Length) ▸ if (sv == null) ▸ if (_spdSheets[i] == SpdSheet.shtYield) | GRID_INIT | this.AddSheet | (spdMain, _spdSheets[i], _spdSheets[i], 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ca47994d | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3762 | else of (dtExptDiv.Rows.Count > 0) ▸ for (i < _spdSheets.Length) ▸ if (sv == null) ▸ else of (_spdSheets[i] == SpdSheet.shtYield) | GRID_INIT | this.AddSheet | (spdMain, _spdSheets[i], _spdSheets[i], 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4d3a2d9b | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3764 | else of (dtExptDiv.Rows.Count > 0) ▸ for (i < _spdSheets.Length) ▸ if (sv == null) | FLAG | siMain | GetSheetInfo(spdMain.Name, _spdSheets[i]) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f99c61b | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3770 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ddf5334 | cboDivision.SelectedIndexChanged | SCP0126_CAPA.cs:3833 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0126_CAPA.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adeb6cea | clbPlant.SelectedIndexChanged | SCP0126_CAPA.cs:3845 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0126_CAPA.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31cbbbd3 | this.Load | SCP0126_CAPA.cs:595 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtNoWork, SpdSheet.shtNoWork, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9e670fc5 | this.Load | SCP0126_CAPA.cs:596 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtDailyCapa, SpdSheet.shtDailyCapa, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c49ac645 | this.Load | SCP0126_CAPA.cs:597 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtSopEop, SpdSheet.shtSopEop, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0369fff4 | this.Load | SCP0126_CAPA.cs:598 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtRampup, SpdSheet.shtRampup, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9760a474 | this.Load | SCP0126_CAPA.cs:599 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtRampupItvl, SpdSheet.shtRampupItvl, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-64c6de0f | this.Load | SCP0126_CAPA.cs:601 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8e10be1 | this.Load | SCP0126_CAPA.cs:604 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea9bef69 | this.Load | SCP0126_CAPA.cs:607 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop) | 화면 필드/플래그 변경 |  |  |  |
| AC-3972ae7e | this.Load | SCP0126_CAPA.cs:610 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtRampup) | 화면 필드/플래그 변경 |  |  |  |
| AC-bbe73f9b | this.Load | SCP0126_CAPA.cs:613 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl) | 화면 필드/플래그 변경 |  |  |  |
| AC-16294576 | this.Load | SCP0126_CAPA.cs:619 | if (division == "40") | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPrepRt, SpdSheet.shtPrepRt, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7dcf2c91 | this.Load | SCP0126_CAPA.cs:621 | if (division == "40") | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt) | 화면 필드/플래그 변경 |  |  |  |
| AC-3eefaed8 | this.Load | SCP0126_CAPA.cs:625 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtUtilRt, SpdSheet.shtUtilRt, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-660d7ddb | this.Load | SCP0126_CAPA.cs:626 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt) | 화면 필드/플래그 변경 |  |  |  |
| AC-17a10289 | this.Load | SCP0126_CAPA.cs:629 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtYield, SpdSheet.shtYield, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3c6edd4e | this.Load | SCP0126_CAPA.cs:630 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtYield) | 화면 필드/플래그 변경 |  |  |  |
| AC-e8077583 | this.Load | SCP0126_CAPA.cs:634 |  | DATA_OP | DBUtils.Filter | (dtExptDivAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-27b649ff | this.Load | SCP0126_CAPA.cs:639 | if (dtExptDiv.Rows.Count > 0) ▸ for (i < dtExptDiv.Rows.Count) | CALL_EXT | siMain.RemoveSheet | (dtExptDiv.Rows[i]["SHEET_NAME"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c71c805 | this.Load | SCP0126_CAPA.cs:645 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0126_CAPA.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecb345cf | DeleteButton | SCP0126_CAPA.cs:821 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d141afab | DeleteButton | SCP0126_CAPA.cs:828 | if (fps.Name == "spdMain") ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (this._currRowIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4857d38e | DeleteButton | SCP0126_CAPA.cs:835 | if (fps.Name == "spdMain") ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (pre_key_values.Split('\|')[0] != "") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ba98c9a0 | DeleteButton | SCP0126_CAPA.cs:844 | if (fps.Name == "spdMain") ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork \|\| _sActiv… | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0126_CAPA.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c66e2ef | Dispose | SCP0126_CAPA.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0126_CAPA.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53616387 | EditButton | SCP0126_CAPA.cs:894 | if (spdMain != null) ▸ if (string.IsNullOrWhiteSpace(_sActiveSheetName)) | FLAG | _sActiveSheetName | siMain.ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-7e3f6bd2 | EditButton | SCP0126_CAPA.cs:897 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-667710fe | EditButton | SCP0126_CAPA.cs:898 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-15023ad4 | EditButton | SCP0126_CAPA.cs:910 | if (spdMain != null) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (division.IndexOf("EE_UC") >= 0) ▸ for (i <= siMain.GetMaxRowInd… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.YYY… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac175c3c | EditButton | SCP0126_CAPA.cs:911 | if (spdMain != null) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (division.IndexOf("EE_UC") >= 0) ▸ for (i <= siMain.GetMaxRowInd… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), i, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b440f5a1 | EditButton | SCP0126_CAPA.cs:915 | if (spdMain != null) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (division.IndexOf("EE_UC") >= 0) ▸ for (i <= siMain.GetMaxRowInd… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CAPA), i, siMain.GetColumnIndex(DefColumns.CAPA), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-28c685e8 | EditButton | SCP0126_CAPA.cs:919 | if (spdMain != null) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (division.IndexOf("EE_UC") >= 0) ▸ for (i <= siMain.GetMaxRowInd… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.M_MIN), i, siMain.GetColumnIndex(DefColumns.M_MIN), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4f2414f | EditButton | SCP0126_CAPA.cs:920 | if (spdMain != null) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (division.IndexOf("EE_UC") >= 0) ▸ for (i <= siMain.GetMaxRowInd… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LANE), i, siMain.GetColumnIndex(DefColumns.LANE), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a6ed888 | EditButton | SCP0126_CAPA.cs:921 | if (spdMain != null) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (division.IndexOf("EE_UC") >= 0) ▸ for (i <= siMain.GetMaxRowInd… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.WIDE_YN), i, siMain.GetColumnIndex(DefColumns.WIDE_YN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-80975aeb | EditButton | SCP0126_CAPA.cs:927 | if (spdMain != null) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (division.IndexOf("EE_UC") >= 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.YYYYMM), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-aec76607 | EditButton | SCP0126_CAPA.cs:928 | if (spdMain != null) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (division.IndexOf("EE_UC") >= 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.PRE_K… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0eeb00e7 | EditButton | SCP0126_CAPA.cs:935 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.OPMZ_PLAN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1c330991 | EditButton | SCP0126_CAPA.cs:936 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LINE_NAME), siMain.GetColumnIndex(DefColumns.LINE_NAME),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b72c970a | EditButton | SCP0126_CAPA.cs:937 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DAY_OF_WEEK), siMain.GetColumnIndex(DefColumns.DAY_OF_WE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6b1be7a5 | EditButton | SCP0126_CAPA.cs:938 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.PRE_K… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e43abac2 | EditButton | SCP0126_CAPA.cs:945 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (bucketType … | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.WEEK_NAME), siMain.GetColumnIndex(DefColumns.WEEK_NAME),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a24e5fa5 | EditButton | SCP0126_CAPA.cs:954 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (division !=… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LINE_TYPE), siMain.GetColumnIndex(DefColumns.LINE_TYPE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-adfb755c | EditButton | SCP0126_CAPA.cs:959 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActi… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.OPMZ_PLAN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-156de8c3 | EditButton | SCP0126_CAPA.cs:960 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActi… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LINE_NAME), siMain.GetColumnIndex(DefColumns.LINE_NAME),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b147d305 | EditButton | SCP0126_CAPA.cs:961 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActi… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NICK_NAME),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-44748063 | EditButton | SCP0126_CAPA.cs:962 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActi… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.PRE_K… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dc84a0d4 | EditButton | SCP0126_CAPA.cs:968 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActi… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LINE_TYPE), siMain.GetColumnIndex(DefColumns.LINE_TYPE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b22fc3ee | EditButton | SCP0126_CAPA.cs:974 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.OPMZ_PLAN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-99f7f06e | EditButton | SCP0126_CAPA.cs:975 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LINE_NAME), siMain.GetColumnIndex(DefColumns.LINE_NAME),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2cb32fef | EditButton | SCP0126_CAPA.cs:976 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.PRE_K… | 그리드 편집 잠금/해제 |  |  |  |
| AC-54a8e57a | EditButton | SCP0126_CAPA.cs:980 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.OPMZ_PLAN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-80a5a169 | EditButton | SCP0126_CAPA.cs:981 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NICK_NAME),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-59f2c7fa | EditButton | SCP0126_CAPA.cs:982 | if (spdMain != null) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.PRE_K… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0126_CAPA.FindData_Main

진입점: btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.OK)] / FindButton / SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3437d775 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1137 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2c1f93dd | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1140 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-6ed1838b | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1140 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7b8a0d2 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1149 | try ▸ if (DateTime.Compare(dtFrom, dtTo) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00344") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-703be934 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1150 | try ▸ if (DateTime.Compare(dtFrom, dtTo) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-300bcfba | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1153 | try | FLAG | _isFinding | true | 화면 필드/플래그 변경 |  |  |  |
| AC-07a2a83f | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1156 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5972461a | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1169 | try ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtDailyCapa) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-84312d33 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1177 | try ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtNoWork) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c0ed718 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1198 | try ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName == Sp… | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtSopEop) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-97c9b346 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1205 | try ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheetName … | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtRampup) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8dd9afd5 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1212 | try ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheetName … | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtRampupItvl) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82e9f6c2 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1219 | try ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheetName … | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPrepRt) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dfc9df0a | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1226 | try ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheetName … | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtUtilRt) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2a2b0568 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1233 | try ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheetName … | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtYield) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52918401 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1252 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0d7e2ff8 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1253 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f696e922 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1257 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (queryId) ⇒ {?string.Empty} \| SCP.SCP0126_GET_DAILY_CAPA \| SCP.SCP0126_GET_NO_WORK_WEEK \|… | 엔드포인트 요청 생성 |  |  |  |
| AC-dad023a9 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1258 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b52b5366 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1259 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5c130041 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1260 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_gr_id"] | p_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-03717bee | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1261 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | p_from_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-2b5dca9e | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1262 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | p_to_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-567d7702 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1263 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-867f7217 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1264 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-7196597d | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1265 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-f2673528 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1266 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6c368cc5 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1268 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1ea49ab7 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1270 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2b23ae2e | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1282 | try ▸ if (ds.Tables.Count > 0) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) | FLAG | this.dtDailyCapaAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-af764b46 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1282 | try ▸ if (ds.Tables.Count > 0) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8e775f21 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1286 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | FLAG | this.dtNoWorkAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a80aa167 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1286 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-50d70bf7 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1290 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | FLAG | this.dtSopEopAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-90dbb6d6 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1290 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-47a76cdf | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1294 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | FLAG | this.dtRampupAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-643d3a8f | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1294 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6eaaedd9 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1298 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | FLAG | this.dtRampupItvlAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-fbe3414a | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1298 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8bcfda2c | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1302 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | FLAG | this.dtPrepRtAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-fe11d346 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1302 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-253430b7 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1306 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | FLAG | this.dtUtilRtAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c7bfbf27 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1306 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-46a6cffb | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1310 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | FLAG | this.dtYieldAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-aa3c2171 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1310 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ … | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3ca46fe2 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1315 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bae2064c | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1316 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ffdf34cb | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1319 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-edd50792 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1322 | try | FLAG | _isFinding | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0c571272 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1330 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9f7dbbb2 | btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.O… 외 2 | SCP0126_CAPA.cs:1331 | finally | FLAG | _isFinding | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0126_CAPA.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9eee5b0 | this.Load | SCP0126_CAPA.cs:198 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0126_CAPA.GetOperationByLine

진입점: this.spdMain.ComboSelChange [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != SpdSheet.shtYield) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.LINE_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ae25d44 | this.spdMain.ComboSelChange [if (siMain != null && siMain.Is… | SCP0126_CAPA.cs:3916 |  | DATA_OP | DBUtils.Filter | (dtPlantId, "DIVISION_ID = '" + division + "' AND CODE = '" + plantID + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3d9d160e | this.spdMain.ComboSelChange [if (siMain != null && siMain.Is… | SCP0126_CAPA.cs:3923 | if (dtPlant.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtLine, "DIVISION_ID = '" + division + "' AND PLANT_ID = '" + plant_id + "' AND CODE = '"… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-179083a2 | this.spdMain.ComboSelChange [if (siMain != null && siMain.Is… | SCP0126_CAPA.cs:3931 |  | RETURN | return operation; |  | 처리 중단/반환 |  |  |  |

## SCP0126_CAPA.GetPlanGroupByUserID

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5a395db | (진입점 미연결) | SCP0126_CAPA.cs:358 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_GET_SEARCH_INFO") ⇒ SCP.SCP0121_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-1bfd502a | (진입점 미연결) | SCP0126_CAPA.cs:360 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-274e396f | (진입점 미연결) | SCP0126_CAPA.cs:361 |  | DATA_OP | request.Parameters["p_user_id"] | userId | 행/컬럼 값 대입 |  |  |  |
| AC-0e357174 | (진입점 미연결) | SCP0126_CAPA.cs:364 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-94fc6456 | (진입점 미연결) | SCP0126_CAPA.cs:368 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0126_CAPA.GetSearchInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04a14c55 | (진입점 미연결) | SCP0126_CAPA.cs:324 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_GET_CAPA_SEARCH_INFO") ⇒ SCP.SCP0126_GET_CAPA_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-fbb1c05a | (진입점 미연결) | SCP0126_CAPA.cs:326 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-118a6c30 | (진입점 미연결) | SCP0126_CAPA.cs:327 |  | DATA_OP | request.Parameters["p_user_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e6f7e2c8 | (진입점 미연결) | SCP0126_CAPA.cs:330 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-409760e5 | (진입점 미연결) | SCP0126_CAPA.cs:334 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0126_CAPA.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee8ed411 | this.Load | SCP0126_CAPA.cs:219 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-897f6c39 | this.Load | SCP0126_CAPA.cs:222 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-77002fd7 | this.Load | SCP0126_CAPA.cs:224 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5964ed6a | this.Load | SCP0126_CAPA.cs:226 |  | FLAG | dtPlantIdAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2a5fba7f | this.Load | SCP0126_CAPA.cs:227 |  | FLAG | dtLineAll | dsSearchInfo.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-ca11552f | this.Load | SCP0126_CAPA.cs:228 |  | FLAG | dtOperationAll | dsSearchInfo.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-b73a1866 | this.Load | SCP0126_CAPA.cs:229 |  | FLAG | dtExptDivAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-5f3b83a5 | this.Load | SCP0126_CAPA.cs:230 |  | FLAG | dtLineTypeAll | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-83c41828 | this.Load | SCP0126_CAPA.cs:231 |  | FLAG | dtNoWorkType | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-8d3cee6c | this.Load | SCP0126_CAPA.cs:233 |  | FLAG | dtPlanGroupAll | dsPlanGroup.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-9a88482d | this.Load | SCP0126_CAPA.cs:237 |  | UI_PROP | mrpPeriod.MonthText1 | DateTime.Now.ToShortDateString().Substring(0, 7) | 속성 MonthText1 설정 |  |  |  |
| AC-56ec5a82 | this.Load | SCP0126_CAPA.cs:237 |  | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-141913bc | this.Load | SCP0126_CAPA.cs:238 |  | UI_PROP | mrpPeriod.MonthText2 | DateTime.Now.AddMonths(12).ToShortDateString().Substring(0, 7) | 속성 MonthText2 설정 |  |  |  |
| AC-8a40a650 | this.Load | SCP0126_CAPA.cs:238 |  | CALL_EXT | DateTime.Now.AddMonths(12).ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-48defce5 | this.Load | SCP0126_CAPA.cs:244 |  | FLAG | dtType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a9d3df5 | this.Load | SCP0126_CAPA.cs:245 |  | DATA_OP | dtType.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-af489bec | this.Load | SCP0126_CAPA.cs:246 |  | DATA_OP | dtType.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9522e0a | this.Load | SCP0126_CAPA.cs:248 |  | DATA_OP | dtType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3c001696 | this.Load | SCP0126_CAPA.cs:249 |  | DATA_OP | row["CODE"] | "SOP" | 행/컬럼 값 대입 |  |  |  |
| AC-de840c6a | this.Load | SCP0126_CAPA.cs:250 |  | DATA_OP | row["NAME"] | "SOP" | 행/컬럼 값 대입 |  |  |  |
| AC-d7431e8f | this.Load | SCP0126_CAPA.cs:251 |  | DATA_OP | dtType.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-e200809d | this.Load | SCP0126_CAPA.cs:253 |  | DATA_OP | dtType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-968b01d2 | this.Load | SCP0126_CAPA.cs:254 |  | DATA_OP | row["CODE"] | "EOP" | 행/컬럼 값 대입 |  |  |  |
| AC-733fd86b | this.Load | SCP0126_CAPA.cs:255 |  | DATA_OP | row["NAME"] | "EOP" | 행/컬럼 값 대입 |  |  |  |
| AC-d8aff688 | this.Load | SCP0126_CAPA.cs:256 |  | DATA_OP | dtType.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f38ce6c | this.Load | SCP0126_CAPA.cs:260 |  | FLAG | _sActiveSheetName | SpdSheet.shtNoWork | 화면 필드/플래그 변경 |  |  |  |
| AC-0c6f27e2 | this.Load | SCP0126_CAPA.cs:264 |  | FLAG | dtFixCombo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-7511d47a | this.Load | SCP0126_CAPA.cs:265 |  | DATA_OP | dtFixCombo.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bb68541 | this.Load | SCP0126_CAPA.cs:266 |  | DATA_OP | dtFixCombo.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb0922ea | this.Load | SCP0126_CAPA.cs:268 |  | DATA_OP | dtFixCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0e161d16 | this.Load | SCP0126_CAPA.cs:269 |  | DATA_OP | rowFix["CODE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cf9ff49b | this.Load | SCP0126_CAPA.cs:270 |  | DATA_OP | rowFix["NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5803214 | this.Load | SCP0126_CAPA.cs:271 |  | DATA_OP | dtFixCombo.Rows.Add | (rowFix) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4b2d17c | this.Load | SCP0126_CAPA.cs:273 |  | DATA_OP | dtFixCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-41428715 | this.Load | SCP0126_CAPA.cs:274 |  | DATA_OP | rowFix["CODE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-6992c991 | this.Load | SCP0126_CAPA.cs:275 |  | DATA_OP | rowFix["NAME"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-f7dbfeeb | this.Load | SCP0126_CAPA.cs:276 |  | DATA_OP | dtFixCombo.Rows.Add | (rowFix) | 데이터 객체 조작/조회 |  |  |  |
| AC-eccf1a9b | this.Load | SCP0126_CAPA.cs:281 |  | FLAG | dtBucketType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-aefaeb15 | this.Load | SCP0126_CAPA.cs:282 |  | DATA_OP | dtBucketType.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0fa4371 | this.Load | SCP0126_CAPA.cs:283 |  | DATA_OP | dtBucketType.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-73a97093 | this.Load | SCP0126_CAPA.cs:285 |  | DATA_OP | dtBucketType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f4beafe | this.Load | SCP0126_CAPA.cs:286 |  | DATA_OP | drBucketDayRow["CODE"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-80900d5f | this.Load | SCP0126_CAPA.cs:287 |  | DATA_OP | drBucketDayRow["NAME"] | "Day" | 행/컬럼 값 대입 |  |  |  |
| AC-7da49f4c | this.Load | SCP0126_CAPA.cs:288 |  | DATA_OP | dtBucketType.Rows.Add | (drBucketDayRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-55a1ec1e | this.Load | SCP0126_CAPA.cs:290 |  | DATA_OP | dtBucketType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4d4b3d73 | this.Load | SCP0126_CAPA.cs:291 |  | DATA_OP | drBucketWeekhRow["CODE"] | "W" | 행/컬럼 값 대입 |  |  |  |
| AC-01b79757 | this.Load | SCP0126_CAPA.cs:292 |  | DATA_OP | drBucketWeekhRow["NAME"] | "Week" | 행/컬럼 값 대입 |  |  |  |
| AC-126edcb6 | this.Load | SCP0126_CAPA.cs:293 |  | DATA_OP | dtBucketType.Rows.Add | (drBucketWeekhRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2e40b2a | this.Load | SCP0126_CAPA.cs:295 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-be09a319 | this.Load | SCP0126_CAPA.cs:299 |  | FLAG | _spdSheets | new string[8] | 화면 필드/플래그 변경 |  |  |  |
| AC-c06035ea | this.Load | SCP0126_CAPA.cs:300 |  | GRID_SET | _spdSheets[0] | SpdSheet.shtNoWork | 그리드 속성/값 설정 |  |  |  |
| AC-11e1db80 | this.Load | SCP0126_CAPA.cs:301 |  | GRID_SET | _spdSheets[1] | SpdSheet.shtDailyCapa | 그리드 속성/값 설정 |  |  |  |
| AC-52635f3d | this.Load | SCP0126_CAPA.cs:302 |  | GRID_SET | _spdSheets[2] | SpdSheet.shtSopEop | 그리드 속성/값 설정 |  |  |  |
| AC-5f109ac3 | this.Load | SCP0126_CAPA.cs:303 |  | GRID_SET | _spdSheets[3] | SpdSheet.shtRampup | 그리드 속성/값 설정 |  |  |  |
| AC-3823576c | this.Load | SCP0126_CAPA.cs:304 |  | GRID_SET | _spdSheets[4] | SpdSheet.shtRampupItvl | 그리드 속성/값 설정 |  |  |  |
| AC-568f22ca | this.Load | SCP0126_CAPA.cs:305 |  | GRID_SET | _spdSheets[5] | SpdSheet.shtUtilRt | 그리드 속성/값 설정 |  |  |  |
| AC-63732c31 | this.Load | SCP0126_CAPA.cs:306 |  | GRID_SET | _spdSheets[6] | SpdSheet.shtPrepRt | 그리드 속성/값 설정 |  |  |  |
| AC-e7a39cd6 | this.Load | SCP0126_CAPA.cs:307 |  | GRID_SET | _spdSheets[7] | SpdSheet.shtYield | 그리드 속성/값 설정 |  |  |  |

## SCP0126_CAPA.InitSpread

진입점: this.Load / cboDivision.SelectedIndexChanged [if (dtExptDiv.Rows.Count > 0) ▸ for (i < _spdSheets.Length) ▸ else of (dtExptDivTemp.Rows.Count > 0) ▸ if (sv == null)] / btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa)] / FindButton [try ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa)] / SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41bbb118 | this.Load 외 4 | SCP0126_CAPA.cs:654 | if (spreadInfo.SheetName == SpdSheet.shtNoWork) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-60526649 | this.Load 외 4 | SCP0126_CAPA.cs:657 | if (spreadInfo.SheetName == SpdSheet.shtNoWork) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantID", dtPlantCombo) | 목록 컨트롤 재구성 |  |  |  |
| AC-9f4937b2 | this.Load 외 4 | SCP0126_CAPA.cs:658 | if (spreadInfo.SheetName == SpdSheet.shtNoWork) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LineID", dtLineCombo) | 목록 컨트롤 재구성 |  |  |  |
| AC-d00f9133 | this.Load 외 4 | SCP0126_CAPA.cs:659 | if (spreadInfo.SheetName == SpdSheet.shtNoWork) | LIST_REBIND | SpreadInfo.SetComBoParam | ("OperationID", dtOperation) | 목록 컨트롤 재구성 |  |  |  |
| AC-147e88bd | this.Load 외 4 | SCP0126_CAPA.cs:661 | if (spreadInfo.SheetName == SpdSheet.shtNoWork) | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-66c4acdd | this.Load 외 4 | SCP0126_CAPA.cs:662 | if (spreadInfo.SheetName == SpdSheet.shtNoWork) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-654a3385 | this.Load 외 4 | SCP0126_CAPA.cs:669 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f3a11946 | this.Load 외 4 | SCP0126_CAPA.cs:670 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c94ebc6a | this.Load 외 4 | SCP0126_CAPA.cs:674 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) ▸ if (spreadInfo.SheetName != SpdSheet.shtYield) | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-f00b1b80 | this.Load 외 4 | SCP0126_CAPA.cs:679 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) ▸ if (spreadInfo.SheetName != SpdSheet.shtYield) ▸ if (spreadInfo.SheetName == SpdSheet… | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantID", dtPlantCombo) | 목록 컨트롤 재구성 |  |  |  |
| AC-f26429b1 | this.Load 외 4 | SCP0126_CAPA.cs:680 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) ▸ if (spreadInfo.SheetName != SpdSheet.shtYield) ▸ if (spreadInfo.SheetName == SpdSheet… | LIST_REBIND | SpreadInfo.SetComBoParam | ("LineID", dtLineCombo) | 목록 컨트롤 재구성 |  |  |  |
| AC-5e9cddf2 | this.Load 외 4 | SCP0126_CAPA.cs:681 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) ▸ if (spreadInfo.SheetName != SpdSheet.shtYield) ▸ if (spreadInfo.SheetName == SpdSheet… | LIST_REBIND | SpreadInfo.SetComBoParam | ("OperationID", dtOperation) | 목록 컨트롤 재구성 |  |  |  |
| AC-17877d23 | this.Load 외 4 | SCP0126_CAPA.cs:682 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) ▸ if (spreadInfo.SheetName != SpdSheet.shtYield) ▸ if (spreadInfo.SheetName == SpdSheet… | LIST_REBIND | SpreadInfo.SetComBoParam | ("Type", dtType) | 목록 컨트롤 재구성 |  |  |  |
| AC-996d0439 | this.Load 외 4 | SCP0126_CAPA.cs:688 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) ▸ if (spreadInfo.SheetName != SpdSheet.shtYield) ▸ else of (spreadInfo.SheetName == Spd… | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantID", dtPlantCombo) | 목록 컨트롤 재구성 |  |  |  |
| AC-4f02a1db | this.Load 외 4 | SCP0126_CAPA.cs:689 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) ▸ if (spreadInfo.SheetName != SpdSheet.shtYield) ▸ else of (spreadInfo.SheetName == Spd… | LIST_REBIND | SpreadInfo.SetComBoParam | ("LineID", dtLineCombo) | 목록 컨트롤 재구성 |  |  |  |
| AC-80887da6 | this.Load 외 4 | SCP0126_CAPA.cs:690 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) ▸ if (spreadInfo.SheetName != SpdSheet.shtYield) ▸ else of (spreadInfo.SheetName == Spd… | LIST_REBIND | SpreadInfo.SetComBoParam | ("OperationID", dtOperation) | 목록 컨트롤 재구성 |  |  |  |
| AC-fd08c5c4 | this.Load 외 4 | SCP0126_CAPA.cs:696 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) ▸ else of (spreadInfo.SheetName != SpdSheet.shtYield) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantID", dtPlantCombo) | 목록 컨트롤 재구성 |  |  |  |
| AC-de32f5d0 | this.Load 외 4 | SCP0126_CAPA.cs:698 | else of (spreadInfo.SheetName == SpdSheet.shtNoWork) ▸ else of (spreadInfo.SheetName != SpdSheet.shtYield) | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |

## SCP0126_CAPA.Insert_Row

진입점: InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b6e7605 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1060 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-60d29249 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1067 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-79f58752 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1071 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (division_id != "EE_UC") | DATA_OP | defaultData.Add | (DefColumns.LINE_TYPE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-12d07fbf | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1074 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-24225978 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1075 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-1d3e09e4 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1077 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-523ed493 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1078 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINE_NAME), siMain.GetColumnIndex(DefColumns.LI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2254e3ad | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1079 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DAY_OF_WEEK), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1bc6df86 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1080 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4d9b498 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1084 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (division_id != "EE_UC") | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINE_TYPE), siMain.GetColumnIndex(DefColumns.LI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c69812f0 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1090 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName … | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-96f8201a | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1094 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName … | DATA_OP | defaultData.Add | (DefColumns.LINE_TYPE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-48219d34 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1097 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName … | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b57aba4 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1098 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName … | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-9cb11a31 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1100 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName … | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f06af451 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1101 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName … | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINE_NAME), siMain.GetColumnIndex(DefColumns.LI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4a7bcde | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1102 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName … | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d25ca28 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1103 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName … | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0bfb15d6 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1107 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName … | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINE_TYPE), siMain.GetColumnIndex(DefColumns.LI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7544c6f9 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1113 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-44f1c1b7 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1114 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-69960200 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1115 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-bc0e3dde | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1117 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-664e0edf | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1118 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINE_NAME), siMain.GetColumnIndex(DefColumns.LI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6e27bb7b | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1119 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-703c2656 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1123 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-595d7b85 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1124 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7535fe2 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1125 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-8f3fdb60 | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1127 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a3154ada | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1128 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-976aff3c | InsertButton [if (_sActiveSheetName != SpdSheet.shtDailyCapa… | SCP0126_CAPA.cs:1129 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0126_CAPA.RefreshLine

진입점: this.Load / cboDivision.SelectedIndexChanged / clbPlant.SelectedIndexChanged / this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3476b725 | this.Load 외 3 | SCP0126_CAPA.cs:476 | if (division == "EE_UC") | DATA_OP | DBUtils.Filter | (dtLineAll, strFilter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5951d9f4 | this.Load 외 3 | SCP0126_CAPA.cs:480 | if (division == "EE_UC") ▸ if (dtTemp.Rows.Count > 0) | CALL_EXT | dtTemp.Rows[0]["ORG_DIVISION_ID"].ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdaae2a3 | this.Load 외 3 | SCP0126_CAPA.cs:482 | if (division == "EE_UC") ▸ if (dtTemp.Rows.Count > 0) | FLAG | dtLine | DBUtils.Filter(dtLineAll, "ORG_DIVISION_ID = '" + org_division + "'" + filterPlantId, true… | 화면 필드/플래그 변경 |  |  |  |
| AC-1fd63bea | this.Load 외 3 | SCP0126_CAPA.cs:482 | if (division == "EE_UC") ▸ if (dtTemp.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtLineAll, "ORG_DIVISION_ID = '" + org_division + "'" + filterPlantId, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0bd07ab1 | this.Load 외 3 | SCP0126_CAPA.cs:487 | else of (division == "EE_UC") | FLAG | dtLine | DBUtils.Filter(dtLineAll, "DIVISION_ID = '" + division + "'" + filterPlantId, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-86d5385b | this.Load 외 3 | SCP0126_CAPA.cs:487 | else of (division == "EE_UC") | DATA_OP | DBUtils.Filter | (dtLineAll, "DIVISION_ID = '" + division + "'" + filterPlantId, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-73f42faa | this.Load 외 3 | SCP0126_CAPA.cs:493 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ec466d27 | this.Load 외 3 | SCP0126_CAPA.cs:495 |  | FLAG | dtLineCombo | dtLine.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-e30087fc | this.Load 외 3 | SCP0126_CAPA.cs:495 |  | DATA_OP | dtLine.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ba56868d | this.Load 외 3 | SCP0126_CAPA.cs:499 | for (i < dtLineCombo.Rows.Count) | GRID_SET | dtLineCombo.Rows[i]["NAME"] | dtLineCombo.Rows[i]["CODE"] | 그리드 속성/값 설정 |  |  |  |

## SCP0126_CAPA.RefreshLineByCombo

진입점: this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.LINE_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43a436e6 | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:514 | if (division == "EE_UC") | DATA_OP | DBUtils.Filter | (dtLineAll, strFilter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e7ecaa5c | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:518 | if (division == "EE_UC") ▸ if (dtTemp.Rows.Count > 0) | CALL_EXT | dtTemp.Rows[0]["ORG_DIVISION_ID"].ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-099d062e | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:520 | if (division == "EE_UC") ▸ if (dtTemp.Rows.Count > 0) | FLAG | dtLineCombo | DBUtils.Filter(dtLineAll, "ORG_DIVISION_ID = '" + org_division + "'" + filterPlantId, true… | 화면 필드/플래그 변경 |  |  |  |
| AC-f9bc7b9f | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:520 | if (division == "EE_UC") ▸ if (dtTemp.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtLineAll, "ORG_DIVISION_ID = '" + org_division + "'" + filterPlantId, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b91288be | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:525 | else of (division == "EE_UC") | FLAG | dtLineCombo | DBUtils.Filter(dtLineAll, "DIVISION_ID = '" + division + "'" + filterPlantId, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-6410c638 | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:525 | else of (division == "EE_UC") | DATA_OP | DBUtils.Filter | (dtLineAll, "DIVISION_ID = '" + division + "'" + filterPlantId, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-232710af | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:533 | for (i < dtLineCombo.Rows.Count) | GRID_SET | dtLineCombo.Rows[i]["NAME"] | dtLineCombo.Rows[i]["CODE"] | 그리드 속성/값 설정 |  |  |  |

## SCP0126_CAPA.RefreshLineTypeByCombo

진입점: this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.LINE_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPERATION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FIX)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.LINE_TYPE)) ▸ if (division_id == "EE_UC")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d8bf2a9 | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:579 |  | FLAG | dtLineType | DBUtils.Filter(dtLineTypeAll, strFilter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7bf8184d | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:579 |  | DATA_OP | DBUtils.Filter | (dtLineTypeAll, strFilter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0126_CAPA.RefreshOperationByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b7bbdac | this.Load 외 2 | SCP0126_CAPA.cs:566 |  | FLAG | dtOperation | DBUtils.Filter(dtOperationAll, strFilter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4944b41c | this.Load 외 2 | SCP0126_CAPA.cs:566 |  | DATA_OP | DBUtils.Filter | (dtOperationAll, strFilter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-376a2332 | this.Load 외 2 | SCP0126_CAPA.cs:570 | for (i < dtOperation.Rows.Count) | GRID_SET | dtOperation.Rows[i]["NAME"] | dtOperation.Rows[i]["CODE"] | 그리드 속성/값 설정 |  |  |  |

## SCP0126_CAPA.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a8e5b0a | this.Load 외 1 | SCP0126_CAPA.cs:375 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-50df2900 | this.Load 외 1 | SCP0126_CAPA.cs:375 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a41151c2 | this.Load 외 1 | SCP0126_CAPA.cs:377 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, cboPlanGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0126_CAPA.RefreshPlantIdByCombo

진입점: this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e159949b | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:435 | if (division == "EE_UC") | DATA_OP | DBUtils.Filter | (dtPlantIdAll, strFilter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1d87f1ae | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:439 | if (division == "EE_UC") ▸ if (dtTemp.Rows.Count > 0) | CALL_EXT | dtTemp.Rows[0]["ORG_DIVISION_ID"].ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4daf2af | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:455 |  | FLAG | dtPlantCombo | DBUtils.Filter(dtPlantIdAll, strFilter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-dd2aa51a | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:455 |  | DATA_OP | DBUtils.Filter | (dtPlantIdAll, strFilter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f3bd8cc9 | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:456 |  | FLAG | dtPlantCombo | DBUtils.GetDistinctTable(dtPlantCombo, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-8a477362 | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:456 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtPlantCombo, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4cfec3d | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… | SCP0126_CAPA.cs:460 | for (i < dtPlantCombo.Rows.Count) | GRID_SET | dtPlantCombo.Rows[i]["NAME"] | dtPlantCombo.Rows[i]["CODE"] | 그리드 속성/값 설정 |  |  |  |

## SCP0126_CAPA.RefreshPlantIdByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-116958cc | this.Load 외 2 | SCP0126_CAPA.cs:390 | if (division == "EE_UC") | DATA_OP | DBUtils.Filter | (dtPlantIdAll, strFilter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a5db9c70 | this.Load 외 2 | SCP0126_CAPA.cs:394 | if (division == "EE_UC") ▸ if (dtTemp.Rows.Count > 0) | CALL_EXT | dtTemp.Rows[0]["ORG_DIVISION_ID"].ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee7d9e3f | this.Load 외 2 | SCP0126_CAPA.cs:409 |  | FLAG | dtPlantId | DBUtils.Filter(dtPlantIdAll, strFilter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-02a48378 | this.Load 외 2 | SCP0126_CAPA.cs:409 |  | DATA_OP | DBUtils.Filter | (dtPlantIdAll, strFilter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5049d7a2 | this.Load 외 2 | SCP0126_CAPA.cs:411 |  | FLAG | dtPlantId | DBUtils.GetDistinctTable(dtPlantId, "CODE", "NAME", "DIVISION_ID") | 화면 필드/플래그 변경 |  |  |  |
| AC-2433de81 | this.Load 외 2 | SCP0126_CAPA.cs:411 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtPlantId, "CODE", "NAME", "DIVISION_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-80b6cf6a | this.Load 외 2 | SCP0126_CAPA.cs:413 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantId, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-20c1d70a | this.Load 외 2 | SCP0126_CAPA.cs:415 |  | FLAG | dtPlantCombo | dtPlantId.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-80d216e4 | this.Load 외 2 | SCP0126_CAPA.cs:415 |  | DATA_OP | dtPlantId.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-53584953 | this.Load 외 2 | SCP0126_CAPA.cs:419 | for (i < dtPlantCombo.Rows.Count) | GRID_SET | dtPlantCombo.Rows[i]["NAME"] | dtPlantCombo.Rows[i]["CODE"] | 그리드 속성/값 설정 |  |  |  |

## SCP0126_CAPA.Save_DailyCapa

진입점: SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dd89303 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1798 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03609d31 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1800 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fdca7b6 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1886 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col.Label.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b2cddf6d | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1887 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6709e9d5 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1894 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col.Label.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b8a0134c | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1895 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f567b792 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1902 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col.Label.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-686e1aa5 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1903 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9411ea01 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1930 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | MESSAGE | MessageHelper.GMessageBox | ("{0} \r\n소수점 최대 10자리까지 입력가능합니다. ", new object[] { args + m_min }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd3b0762 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1931 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3856decc | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1937 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { args + m_min }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5d95fd73 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1938 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b511b17 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1944 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { lane }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-09793dc4 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1945 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6396f4f5 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1953 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (division_id == "EE" \|\| (divis… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c170dc97 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1965 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (division_id == "EE" \|\| (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col.Label.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d18d6432 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1966 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (division_id == "EE" \|\| (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49064388 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1980 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (division_id == "EE" \|\| (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { col.Label.ToString() + " : " + capa }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dcdb7404 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1981 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (division_id == "EE" \|\| (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29e52cf1 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:1989 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (division_id == "EE" \|\| (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b716cbb4 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2036 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f09152e0 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2037 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cadc74c3 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2041 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_SAVE_DAILY_CAPA") ⇒ SCP.SCP0126_SAVE_DAILY_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-d6f0a7ce | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2044 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11f56ad7 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2048 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-408017c5 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2050 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-446420bf | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2051 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9368fb92 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2052 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-2097806b | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2053 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-c2f0a9e5 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2054 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-4092d05d | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2055 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c34095e0 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2056 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_yyyymm"] | p_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-d0842f1d | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2058 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_capa"] | p_capa | 행/컬럼 값 대입 |  |  |  |
| AC-0d93944a | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2059 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_m_min"] | p_m_min | 행/컬럼 값 대입 |  |  |  |
| AC-225d5120 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2060 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_lane"] | p_lane | 행/컬럼 값 대입 |  |  |  |
| AC-99945195 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2061 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_wide_yn"] | p_wide_yn | 행/컬럼 값 대입 |  |  |  |
| AC-07fee0ea | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2062 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_prdn_oper_rt"] | p_prdn_oper_rt | 행/컬럼 값 대입 |  |  |  |
| AC-502321cf | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2063 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-0a566821 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2065 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f35e157d | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2066 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plant_id"] | p_pre_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-06dd35ca | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2067 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_id"] | p_pre_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-17ccee57 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2068 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_operation_id"] | p_pre_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff0608b8 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2069 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-459256b7 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2070 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_yyyymm"] | p_pre_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-9c717c23 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2071 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e6cd6000 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2073 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b9fcec8 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2073 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-1c7da0c4 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2077 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0fe57912 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2084 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd93883e | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2093 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8ce366d | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2099 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-daa30e07 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2100 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d62a365 | SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa)] | SCP0126_CAPA.cs:2104 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_CAPA.Save_NoWork

진입점: SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (p_buckettype == "W")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-764ac090 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1337 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b38b03e7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1339 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39bf9749 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1421 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ for (iCol <= siMain.GetMaxColumnInd… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31da3351 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1422 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ for (iCol <= siMain.GetMaxColumnInd… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ecc2b06 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1439 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtNoWorkAll != null) | DATA_OP | DBUtils.Filter | (dtNoWorkAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d6d6d283 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1445 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtNoWorkAll != null) ▸ if (dtNo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c1dfc50 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1446 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtNoWorkAll != null) ▸ if (dtNo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0fd4b48e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1454 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtNoWorkAll != null) ▸ if (dtNo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00443") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68a89f8c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1455 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtNoWorkAll != null) ▸ if (dtNo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29a91dbb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1472 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ catch ((Exception)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "No Work Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dace73b1 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1473 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ catch ((Exception)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d01cec4b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1487 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (double.TryParse(off_time, out d… | MESSAGE | MessageHelper.GMessageBox | ("{0} \r\n소수점 최대 10자리까지 입력가능합니다. ", new object[] { args + off_time }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f468af85 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1488 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (double.TryParse(off_time, out d… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24452c56 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1494 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (double.TryParse(off_time, … | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { args + off_time }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fef18ee1 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1495 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (double.TryParse(off_time, … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f96503b3 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1545 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5f3d351d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1546 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-799b4729 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1550 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_SAVE_NO_WORK") ⇒ SCP.SCP0126_SAVE_NO_WORK | 엔드포인트 요청 생성 |  |  |  |
| AC-f459e1c3 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1553 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d53e1b5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1557 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0dc32da0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1559 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ef54fef6 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1560 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-14ffea7c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1561 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-553794f1 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1562 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-44345df6 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1563 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-3c8823f3 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1564 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_type"] | p_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-5f802e53 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1565 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_no_work_date"] | p_no_work_date | 행/컬럼 값 대입 |  |  |  |
| AC-eecfea80 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1566 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_off_time"] | p_off_time | 행/컬럼 값 대입 |  |  |  |
| AC-8408e407 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1567 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-f8acebcf | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1568 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_desc"] | p_desc | 행/컬럼 값 대입 |  |  |  |
| AC-7d6cd866 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1569 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-e7f97c10 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1570 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_fix"] | p_fix | 행/컬럼 값 대입 |  |  |  |
| AC-f05a0276 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1571 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d36c8c7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1572 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plant_id"] | p_pre_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-ed21e086 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1573 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_id"] | p_pre_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-697c4610 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1574 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_operation_id"] | p_pre_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-7dc5fe2f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1575 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_type"] | p_pre_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-a2748761 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1576 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_no_work_date"] | p_pre_no_work_date | 행/컬럼 값 대입 |  |  |  |
| AC-528252ba | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1577 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-35da33e9 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1579 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1bdf87d0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1579 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-ae9b8a18 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1583 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-191db8df | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1590 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a22ed1b6 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1599 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0b9d2b2 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1605 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-46cc55f9 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1606 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97069949 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1610 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_CAPA.Save_NoWork_Week

진입점: SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (p_buckettype == "W")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b1e0a98 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1619 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43e26481 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1621 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b50b32f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1687 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ for (iCol <= siMain.GetMaxColumnInd… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b10f115 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1688 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ for (iCol <= siMain.GetMaxColumnInd… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-444299eb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1703 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (double.TryParse(off_time, out d… | MESSAGE | MessageHelper.GMessageBox | ("{0} \r\n소수점 최대 10자리까지 입력가능합니다. ", new object[] { args + off_time }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b7671d4d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1704 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (double.TryParse(off_time, out d… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e70bff16 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1710 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (double.TryParse(off_time, … | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { args + off_time }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d82c2787 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1711 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (double.TryParse(off_time, … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-928a2300 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1731 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a2d740f5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1732 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9c8bc7ed | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1736 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_SAVE_NO_WORK_WEEK") ⇒ SCP.SCP0126_SAVE_NO_WORK_WEEK | 엔드포인트 요청 생성 |  |  |  |
| AC-f2ce3fa4 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1739 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac2a3958 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1743 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d77736de | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1745 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f3d6a04b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1746 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-86d5d9e1 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1747 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-dca93a4a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1748 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a30247d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1749 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-8ab61379 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1750 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_type"] | p_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-db2a61af | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1751 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_week_name"] | p_week_name | 행/컬럼 값 대입 |  |  |  |
| AC-c864eb20 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1752 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_off_time"] | p_off_time | 행/컬럼 값 대입 |  |  |  |
| AC-d535f30b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1753 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-e767a658 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1754 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_desc"] | p_desc | 행/컬럼 값 대입 |  |  |  |
| AC-3e411611 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1755 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ba02e316 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1757 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-65a950ab | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1757 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-52068409 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1761 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-44ba80ad | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1768 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a32c2fd0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1777 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f81c1a56 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1783 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1fb92a06 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1784 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7e42c1f4 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:1788 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_CAPA.Save_PrepRt

진입점: SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheetName == SpdSheet.shtSopEop) ▸ else of (_sActiveSheetName == SpdSheet.shtRampup) ▸ else of (_sActiveSheetName == SpdSheet.shtRampupItvl) ▸ if (_sActiveSheetName == SpdSheet.shtPrepRt)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e8eccad | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2902 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-956bf9d9 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2904 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7712545 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2956 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-4e9b2ab4 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2956 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!DataUtil.checkRequiredOfSpread… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43f93484 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2970 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtPrepRtAll != null) | DATA_OP | DBUtils.Filter | (dtPrepRtAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4b585e51 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2976 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtPrepRtAll != null) ▸ if (dtPr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-383533b8 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2977 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtPrepRtAll != null) ▸ if (dtPr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0061f1ef | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2985 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtPrepRtAll != null) ▸ if (dtPr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00443") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1dccca48 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2986 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtPrepRtAll != null) ▸ if (dtPr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cadac7e5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3002 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtPrepRtAll != null) | DATA_OP | DBUtils.Filter | (dtPrepRtAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2ef7b4ba | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3027 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtPrepRtAll != null) ▸ for (k <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00105") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bbe6cc00 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3028 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtPrepRtAll != null) ▸ for (k <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e71ee47 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3038 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (DateTime.Compare(dtFrom, dtTo) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec5bfe78 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3039 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (DateTime.Compare(dtFrom, dtTo) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d417caf | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3047 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!string.IsNullOrEmpty(prep_rt))… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3b69bd1 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3091 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-79779d8f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3092 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0bb9330a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3096 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_SAVE_PREP_RT") ⇒ SCP.SCP0126_SAVE_PREP_RT | 엔드포인트 요청 생성 |  |  |  |
| AC-4fcbf94b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3099 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e6a36b5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3103 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4dd3184c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3105 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0fa50e11 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3106 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cbce4217 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3107 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-7f7d0d5d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3108 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-1795f668 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3109 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-37bc5ba7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3110 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-79080f78 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3111 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_date"] | p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-7d5d4b9d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3112 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_prep_rt"] | p_prep_rt | 행/컬럼 값 대입 |  |  |  |
| AC-ff521221 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3113 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-6c3d7e45 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3114 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-15d42249 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3115 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plant_id"] | p_pre_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-f7c89ce2 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3116 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_id"] | p_pre_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce3f1ce7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3117 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_operation_id"] | p_pre_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-d488de42 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3118 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_from_date"] | p_pre_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-f8e45115 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3119 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_to_date"] | p_pre_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-890edc39 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3120 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-efad58b4 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3122 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3dfe2ad5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3122 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-91aec938 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3126 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9b626ccc | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3133 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6848617b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3142 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cc3190fe | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3148 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dfa8a220 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3149 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19f7daf0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3153 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_CAPA.Save_Rampup

진입점: SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheetName == SpdSheet.shtSopEop) ▸ if (_sActiveSheetName == SpdSheet.shtRampup)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acc0e1d5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2332 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a27c43d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2334 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6432b41f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2397 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-b7732047 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2397 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!DataUtil.checkRequiredOfSpread… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6bfc7ad | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2413 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupAll != null) | DATA_OP | DBUtils.Filter | (dtRampupAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6ff857bf | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2419 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupAll != null) ▸ if (dtRa… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-925b40ea | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2420 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupAll != null) ▸ if (dtRa… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6438f1c0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2428 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupAll != null) ▸ if (dtRa… | MESSAGE | MessageHelper.GMessageBox | ("MSG00443") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-217a96ed | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2429 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupAll != null) ▸ if (dtRa… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9888541 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2444 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupAll != null) | DATA_OP | DBUtils.Filter | (dtRampupAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-efe7497b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2469 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupAll != null) ▸ for (k <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00105") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-86f96db7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2470 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupAll != null) ▸ for (k <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76f47fe0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2481 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (DateTime.Compare(dtStart, dtEnd… | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-040e0ffe | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2482 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (DateTime.Compare(dtStart, dtEnd… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca5cf4ff | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2490 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!string.IsNullOrEmpty(efcy)) ▸ … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b90f6318 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2541 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9b2eb07f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2542 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-52855823 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2546 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_SAVE_RAMP_UP") ⇒ SCP.SCP0126_SAVE_RAMP_UP | 엔드포인트 요청 생성 |  |  |  |
| AC-d857a3ba | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2549 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dc6b056b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2553 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d275918a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2555 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d16d9bac | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2556 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-735c9866 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2557 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-3f4f43c9 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2558 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-49244ec0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2559 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-2fe6f3c5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2560 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_type"] | p_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-c96a2982 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2561 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd9f57b8 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2562 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-935e6a9b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2563 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_end_date"] | p_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-acdc933a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2564 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_efcy"] | p_efcy | 행/컬럼 값 대입 |  |  |  |
| AC-67761fc9 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2565 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_desc"] | p_desc | 행/컬럼 값 대입 |  |  |  |
| AC-fc76829c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2566 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-84370256 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2567 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e0f89c9 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2568 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plant_id"] | p_pre_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc222cec | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2569 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_id"] | p_pre_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-c61397eb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2570 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_operation_id"] | p_pre_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-8a9137ba | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2571 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_type"] | p_pre_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-aeb4e3ac | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2572 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-45dacecc | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2573 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_start_date"] | p_pre_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-54dc1068 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2574 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_end_date"] | p_pre_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-c6c22a14 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2575 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-810e0694 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2577 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-034535e9 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2577 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-dfcae8da | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2581 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0f8997e8 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2588 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-656b285c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2597 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53e4b846 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2603 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-47f84ca7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2604 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-90ea4393 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2608 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_CAPA.Save_Rampup_Itvl

진입점: SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheetName == SpdSheet.shtSopEop) ▸ else of (_sActiveSheetName == SpdSheet.shtRampup) ▸ if (_sActiveSheetName == SpdSheet.shtRampupItvl)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-240110df | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2616 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46785be5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2618 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6751b516 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2698 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-c9a101e7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2698 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!DataUtil.checkRequiredOfSpread… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5edbe31f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2713 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupItvlAll != null) | DATA_OP | DBUtils.Filter | (dtRampupItvlAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-06d8dfb7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2719 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupItvlAll != null) ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-600968c0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2720 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupItvlAll != null) ▸ if (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0af561a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2728 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupItvlAll != null) ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00443") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37a737f1 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2729 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtRampupItvlAll != null) ▸ if (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac3656d8 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2741 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!string.IsNullOrEmpty(efcy1)) ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13da1811 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2750 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!string.IsNullOrEmpty(efcy2)) ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a02015f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2759 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!string.IsNullOrEmpty(efcy3)) ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-831500de | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2768 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!string.IsNullOrEmpty(efcy4)) ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db794222 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2822 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-aad8fdb3 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2823 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-19b24d02 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2827 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_SAVE_RAMP_UP_ITVL") ⇒ SCP.SCP0126_SAVE_RAMP_UP_ITVL | 엔드포인트 요청 생성 |  |  |  |
| AC-d3c4bc2f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2830 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ffc154c0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2834 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fc7adf0a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2836 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1f151bb9 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2837 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2cd19e73 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2838 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-a95c17ec | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2839 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-85950f81 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2840 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-af0fd0c0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2841 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_type"] | p_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-68d881bb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2842 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-4cc5175e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2843 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-8834a1b0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2844 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_itvl1"] | p_itvl1 | 행/컬럼 값 대입 |  |  |  |
| AC-fd7e56c4 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2845 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_efcy1"] | p_efcy1 | 행/컬럼 값 대입 |  |  |  |
| AC-a39c48e5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2846 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_itvl2"] | p_itvl2 | 행/컬럼 값 대입 |  |  |  |
| AC-1e59e5f3 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2847 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_efcy2"] | p_efcy2 | 행/컬럼 값 대입 |  |  |  |
| AC-d3e5c6cc | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2848 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_itvl3"] | p_itvl3 | 행/컬럼 값 대입 |  |  |  |
| AC-31abbd73 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2849 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_efcy3"] | p_efcy3 | 행/컬럼 값 대입 |  |  |  |
| AC-689993f2 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2850 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_itvl4"] | p_itvl4 | 행/컬럼 값 대입 |  |  |  |
| AC-2eabb1a2 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2851 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_efcy4"] | p_efcy4 | 행/컬럼 값 대입 |  |  |  |
| AC-77015790 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2852 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_desc"] | p_desc | 행/컬럼 값 대입 |  |  |  |
| AC-bcb7c6bb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2853 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-b4c8dbf5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2854 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-57365f94 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2855 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plant_id"] | p_pre_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-e5079f45 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2856 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_id"] | p_pre_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-119b6bcf | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2857 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_operation_id"] | p_pre_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-0f68ee0a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2858 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_type"] | p_pre_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-cd75c246 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2859 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5d81f644 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2860 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_start_date"] | p_pre_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-4352f3b7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2861 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-dd5de6d0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2863 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11e350e4 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2863 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-c88aa292 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2867 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f01cad2b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2874 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6b16a362 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2883 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-86f41b93 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2889 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-941f7c16 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2890 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b9186d6e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2894 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_CAPA.Save_SopEop

진입점: SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (_sActiveSheetName == SpdSheet.shtSopEop)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-661aeb8f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2112 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-932dd465 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2114 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f23797e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2174 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-8f9607e5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2174 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!DataUtil.checkRequiredOfSpread… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24d0d247 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2190 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtSopEopAll != null) | DATA_OP | DBUtils.Filter | (dtSopEopAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-02b2af8a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2196 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtSopEopAll != null) ▸ if (dtSo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4bf92dfc | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2197 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtSopEopAll != null) ▸ if (dtSo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70afeb3a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2206 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtSopEopAll != null) ▸ if (dtSo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00443") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97bfeba8 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2207 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtSopEopAll != null) ▸ if (dtSo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d7abcb32 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2258 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e174a784 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2259 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-53f1c365 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2263 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_SAVE_SOP_EOP") ⇒ SCP.SCP0126_SAVE_SOP_EOP | 엔드포인트 요청 생성 |  |  |  |
| AC-37fcefcd | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2266 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8fdbc55a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2270 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f619afe0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2272 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-af147f71 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2273 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ffd726ea | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2274 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-a1b21135 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2275 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-97deba40 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2276 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-40fa4bcf | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2277 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_type"] | p_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-f77d0a9b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2278 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8fe27302 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2279 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-a59c8d76 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2280 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_date"] | p_date | 행/컬럼 값 대입 |  |  |  |
| AC-e85e90be | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2281 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_desc"] | p_desc | 행/컬럼 값 대입 |  |  |  |
| AC-c6e207cd | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2282 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-97a0793e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2283 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-96a834cb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2284 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plant_id"] | p_pre_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-e369be36 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2285 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_id"] | p_pre_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-58760bab | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2286 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_operation_id"] | p_pre_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-163af75d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2287 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_type"] | p_pre_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-3bb95403 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2288 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-da890040 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2289 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_type"] | p_pre_type | 행/컬럼 값 대입 |  |  |  |
| AC-8935d6c5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2290 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_date"] | p_pre_date | 행/컬럼 값 대입 |  |  |  |
| AC-84f6a7cb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2291 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0c5d0936 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2293 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c832be0f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2293 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-ebae7b89 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2297 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1d1d16bd | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2304 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54aa7917 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2313 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ab714e2a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2319 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b6eab35d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2320 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8196be0d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:2324 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_CAPA.Save_UtilRt

진입점: SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheetName == SpdSheet.shtSopEop) ▸ else of (_sActiveSheetName == SpdSheet.shtRampup) ▸ else of (_sActiveSheetName == SpdSheet.shtRampupItvl) ▸ else of (_sActiveSheetName == SpdSheet.shtPrepRt) ▸ if (_sActiveSheetName == SpdSheet.shtUtilRt)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2353c803 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3161 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fce0a397 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3163 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f093d56 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3215 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-4d10abff | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3215 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!DataUtil.checkRequiredOfSpread… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-faac89c5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3229 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtUtilRtAll != null) | DATA_OP | DBUtils.Filter | (dtUtilRtAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-248e2a7b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3235 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtUtilRtAll != null) ▸ if (dtUt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f96f80f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3236 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtUtilRtAll != null) ▸ if (dtUt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1615b7fb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3244 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtUtilRtAll != null) ▸ if (dtUt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00443") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b474385 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3245 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtUtilRtAll != null) ▸ if (dtUt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa47e62c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3258 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtUtilRtAll != null) | DATA_OP | DBUtils.Filter | (dtUtilRtAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4adbd78b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3283 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtUtilRtAll != null) ▸ for (k <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00105") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f45b484 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3284 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtUtilRtAll != null) ▸ for (k <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1396de58 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3294 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (DateTime.Compare(dtFrom, dtTo) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-faec293e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3295 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (DateTime.Compare(dtFrom, dtTo) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92729407 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3303 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!string.IsNullOrEmpty(util_rt))… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-acf4c5ed | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3347 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2030f37e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3348 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-36372791 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3352 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_SAVE_UTIL_RT") ⇒ SCP.SCP0126_SAVE_UTIL_RT | 엔드포인트 요청 생성 |  |  |  |
| AC-3312af2d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3355 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f4089dde | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3359 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fc6c5407 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3361 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c734e2e9 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3362 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4eb903b4 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3363 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-ad9228c6 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3364 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d2a55d5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3365 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-f937ddc3 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3366 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-dd084b41 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3367 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_date"] | p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-81811192 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3368 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_util_rt"] | p_util_rt | 행/컬럼 값 대입 |  |  |  |
| AC-533167ca | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3369 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-b5d5f502 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3370 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-99677192 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3371 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plant_id"] | p_pre_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-78018c0c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3372 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_line_id"] | p_pre_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-1982445d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3373 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_operation_id"] | p_pre_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff049536 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3374 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_from_date"] | p_pre_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-4200a205 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3375 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_to_date"] | p_pre_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-b096e8b2 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3376 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4bea40e8 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3378 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-de4beece | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3378 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-d7c4957c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3382 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-75409955 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3389 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe58538a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3398 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e97d861 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3404 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4d4564a7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3405 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ffd3faf | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3409 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_CAPA.Save_YieldElec

진입점: SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (_sActiveSheetName == SpdSheet.shtSopEop) ▸ else of (_sActiveSheetName == SpdSheet.shtRampup) ▸ else of (_sActiveSheetName == SpdSheet.shtRampupItvl) ▸ else of (_sActiveSheetName == SpdSheet.shtPrepRt) ▸ else of (_sActiveSheetName == SpdSheet.shtUtilRt) ▸ if (_sActiveSheetName == SpdSheet.shtYield)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8274797d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3417 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-100f2fb7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3419 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66189393 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3468 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-e14de501 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3468 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!DataUtil.checkRequiredOfSpread… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7077222 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3480 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtYieldAll != null) | DATA_OP | DBUtils.Filter | (dtYieldAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ff5a73aa | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3486 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtYieldAll != null) ▸ if (dtYie… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c06cc9c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3487 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtYieldAll != null) ▸ if (dtYie… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aed1713c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3495 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtYieldAll != null) ▸ if (dtYie… | MESSAGE | MessageHelper.GMessageBox | ("MSG00443") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97b84ae1 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3496 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dtYieldAll != null) ▸ if (dtYie… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b954a519 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3507 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!string.IsNullOrEmpty(elec_post… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5b0d310 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3516 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (!string.IsNullOrEmpty(assy)) ▸ … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-943fb57f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3554 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9c741087 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3555 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fb9477eb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3559 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_SAVE_YLD_ELEC") ⇒ SCP.SCP0126_SAVE_YLD_ELEC | 엔드포인트 요청 생성 |  |  |  |
| AC-a61af355 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3562 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4a44b981 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3566 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e238ea62 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3568 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-620061d0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3569 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2492d045 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3570 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-b09d753a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3571 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f7e19ce6 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3572 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_yyyymm"] | p_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-6904f209 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3573 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_elec_post"] | p_elec_post | 행/컬럼 값 대입 |  |  |  |
| AC-a850ee3d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3574 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_assy"] | p_assy | 행/컬럼 값 대입 |  |  |  |
| AC-27d8c30f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3575 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-7adbc920 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3576 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d3f4ce2e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3577 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plant_id"] | p_pre_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-89491433 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3578 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f285bac3 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3579 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_yyyymm"] | p_pre_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-bc1fbd07 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3580 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-49d5002f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3582 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-207cd1b7 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3582 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-47b08917 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3586 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7ddf0b34 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3593 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3da25f35 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3602 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-132819c2 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3608 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5385e3d4 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3609 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f631e3b4 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtDailyC… | SCP0126_CAPA.cs:3613 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_CAPA.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fb8f71f | SaveButton | SCP0126_CAPA.cs:1004 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0126_CAPA.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-114e73a8 | (진입점 미연결) | SCP0126_CAPA.cs:723 | if (sheetName.Equals(SpdSheet.shtNoWork)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-45da0cd3 | (진입점 미연결) | SCP0126_CAPA.cs:724 | if (sheetName.Equals(SpdSheet.shtNoWork)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-c2d77a55 | (진입점 미연결) | SCP0126_CAPA.cs:728 |  | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0126_CAPA.SetVisibleSearchControls

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3811cd15 | this.Load 외 2 | SCP0126_CAPA.cs:4022 | if (_sActiveSheetName == SpdSheet.shtNoWork) | UI_PROP | this.lciExcelUpload.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1c3ae870 | this.Load 외 2 | SCP0126_CAPA.cs:4023 | if (_sActiveSheetName == SpdSheet.shtNoWork) | UI_PROP | this.lciExcelForm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-68efe40c | this.Load 외 2 | SCP0126_CAPA.cs:4024 | if (_sActiveSheetName == SpdSheet.shtNoWork) | UI_PROP | this.lciBucketType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-134b789c | this.Load 외 2 | SCP0126_CAPA.cs:4031 | if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (division_id != "EE_UC") | UI_PROP | this.lciBatchSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5beaba0a | this.Load 외 2 | SCP0126_CAPA.cs:4035 | if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (division_id != "EE_UC") | UI_PROP | this.lciBatchSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a5e4c6d2 | this.Load 외 2 | SCP0126_CAPA.cs:4044 | else of (_sActiveSheetName == SpdSheet.shtNoWork) | UI_PROP | this.lciExcelUpload.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9f5359cb | this.Load 외 2 | SCP0126_CAPA.cs:4045 | else of (_sActiveSheetName == SpdSheet.shtNoWork) | UI_PROP | this.lciExcelForm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e6c603ba | this.Load 외 2 | SCP0126_CAPA.cs:4046 | else of (_sActiveSheetName == SpdSheet.shtNoWork) | UI_PROP | this.lciBatchSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-55bc653f | this.Load 외 2 | SCP0126_CAPA.cs:4047 | else of (_sActiveSheetName == SpdSheet.shtNoWork) | UI_PROP | this.lciBucketType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0126_CAPA.SetVisibleSheetColumns

진입점: this.Load / cboDivision.SelectedIndexChanged / cboBucketType.SelectedIndexChanged / btnBatchSave.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ try] / FindButton [try] / SaveButton [if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5fd3d68 | this.Load 외 5 | SCP0126_CAPA.cs:764 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (division.IndexOf("EE_UC") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.CAPA, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f76e2b6c | this.Load 외 5 | SCP0126_CAPA.cs:765 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (division.IndexOf("EE_UC") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.M_MIN, 100, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4ab4a9f | this.Load 외 5 | SCP0126_CAPA.cs:766 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (division.IndexOf("EE_UC") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.LANE, 60, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd96ee13 | this.Load 외 5 | SCP0126_CAPA.cs:767 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (division.IndexOf("EE_UC") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.WIDE_YN, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c7708bb | this.Load 외 5 | SCP0126_CAPA.cs:772 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (division.IndexOf("EE_UC") >= 0) ▸ if (division.IndexOf("EE") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.CAPA, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-049565f7 | this.Load 외 5 | SCP0126_CAPA.cs:773 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (division.IndexOf("EE_UC") >= 0) ▸ if (division.IndexOf("EE") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.M_MIN, 100, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f53676f | this.Load 외 5 | SCP0126_CAPA.cs:774 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (division.IndexOf("EE_UC") >= 0) ▸ if (division.IndexOf("EE") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.LANE, 60, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71a15e21 | this.Load 외 5 | SCP0126_CAPA.cs:775 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (division.IndexOf("EE_UC") >= 0) ▸ if (division.IndexOf("EE") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.WIDE_YN, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-892cdeb1 | this.Load 외 5 | SCP0126_CAPA.cs:779 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (division.IndexOf("EE_UC") >= 0) ▸ else of (division.IndexOf("EE") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.CAPA, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2bc0c49f | this.Load 외 5 | SCP0126_CAPA.cs:780 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (division.IndexOf("EE_UC") >= 0) ▸ else of (division.IndexOf("EE") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.M_MIN, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a39be12 | this.Load 외 5 | SCP0126_CAPA.cs:781 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (division.IndexOf("EE_UC") >= 0) ▸ else of (division.IndexOf("EE") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.LANE, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-28766932 | this.Load 외 5 | SCP0126_CAPA.cs:782 | if (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ else of (division.IndexOf("EE_UC") >= 0) ▸ else of (division.IndexOf("EE") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.WIDE_YN, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04410273 | this.Load 외 5 | SCP0126_CAPA.cs:793 | else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (bucketType == "W") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.WEEK_NAME, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7f021f7 | this.Load 외 5 | SCP0126_CAPA.cs:794 | else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (bucketType == "W") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.NO_WORK_DATE, 80, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-600ec430 | this.Load 외 5 | SCP0126_CAPA.cs:795 | else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (bucketType == "W") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.DAY_OF_WEEK, 80, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4de29615 | this.Load 외 5 | SCP0126_CAPA.cs:796 | else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (bucketType == "W") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.VALID_YN, 60, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f5fe446 | this.Load 외 5 | SCP0126_CAPA.cs:797 | else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ if (bucketType == "W") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.FIX, 60, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f829aa4 | this.Load 외 5 | SCP0126_CAPA.cs:802 | else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (bucketType == "W") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.WEEK_NAME, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6eda2c8f | this.Load 외 5 | SCP0126_CAPA.cs:803 | else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (bucketType == "W") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.NO_WORK_DATE, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5533c899 | this.Load 외 5 | SCP0126_CAPA.cs:804 | else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (bucketType == "W") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.DAY_OF_WEEK, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6553240 | this.Load 외 5 | SCP0126_CAPA.cs:805 | else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (bucketType == "W") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.VALID_YN, 60, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-baa8f435 | this.Load 외 5 | SCP0126_CAPA.cs:806 | else of (_sActiveSheetName == SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtNoWork) ▸ else of (bucketType == "W") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.FIX, 60, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc5f2887 | this.Load 외 5 | SCP0126_CAPA.cs:811 |  | CALL_EXT | SheetUtils.SetColumHide | (siMain) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0126_CAPA.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02f2cca9 | this.spdMain.ActiveSheetChanged | SCP0126_CAPA.cs:4004 | if (sender != null) | FLAG | _sActiveSheetName | ((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |

## SCP0126_CAPA.SpdMain_ActiveSheetChanging

진입점: this.spdMain.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-508ea9b3 | this.spdMain.ActiveSheetChanging | SCP0126_CAPA.cs:3983 | if (siMain.ActiveSheetIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53ac4568 | this.spdMain.ActiveSheetChanging | SCP0126_CAPA.cs:3988 | if (_isFinding) | UI_PROP | e.ActivatedSheetIndex | siMain.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-5c96deda | this.spdMain.ActiveSheetChanging | SCP0126_CAPA.cs:3989 | if (_isFinding) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7dbd4d0a | this.spdMain.ActiveSheetChanging | SCP0126_CAPA.cs:3994 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siMain.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-555ce174 | this.spdMain.ActiveSheetChanging | SCP0126_CAPA.cs:3996 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5fe625ef | this.spdMain.ActiveSheetChanging | SCP0126_CAPA.cs:3997 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0126_CAPA.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b69db9a5 | this.spdMain.CellClick | SCP0126_CAPA.cs:4122 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-636d7a9a | this.spdMain.CellClick | SCP0126_CAPA.cs:4137 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ if (e.Column == siMain.GetColumnIndex(… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.PLANT_ID, dtPlantCombo, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7655af63 | this.spdMain.CellClick | SCP0126_CAPA.cs:4146 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ else of (e.Column == siMain.GetColumnI… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.LINE_ID, dtLineCombo, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-31ef0acf | this.spdMain.CellClick | SCP0126_CAPA.cs:4150 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ else of (e.Column == siMain.GetColumnI… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.OPERATION_ID, dtOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8457309e | this.spdMain.CellClick | SCP0126_CAPA.cs:4155 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ else of (e.Column == siMain.GetColumnI… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.FIX, dtFixCombo, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-78c90358 | this.spdMain.CellClick | SCP0126_CAPA.cs:4168 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ else of (e.Column == siMain.GetColumnI… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.LINE_TYPE, dtLineType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-407ecf22 | this.spdMain.CellClick | SCP0126_CAPA.cs:4175 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ else of (e.Column == siMain.GetColumnI… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.NO_WORK_TYPE, dtNoWorkType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-998aeb13 | this.spdMain.CellClick | SCP0126_CAPA.cs:4183 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ if (_sActiveSheetName == SpdSheet.shtS… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.TYPE, dtType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0126_CAPA.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be6209f0 | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4058 | if (!e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37b4803e | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4061 | if (!e.ColumnHeader) ▸ if (_sActiveSheetName == SpdSheet.shtDailyCapa) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c836085 | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4069 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | new GSCM.SCM.Popup.UIL.SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-751fe234 | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4070 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.Form_Load | (true, division, "", "", "") | 팝업 초기화(인자 전달) |  |  |  |
| AC-e857808e | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4071 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | UI_PROP | popItem.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-24af3fc9 | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4072 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8799dcdf | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4079 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (popItem.ItemID != string.Empty) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-3a0ba9c7 | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4080 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (popItem.ItemID != string.Empty) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-994e212e | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4087 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex("WEEK_NAME"))… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cdec5458 | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4089 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex("WEEK_NAME")) | POPUP | new GSCM.SCM.Master.UIL.SCP0126_SingleDatePopup | (Color.Transparent, false) | 팝업/폼 생성 |  |  |  |
| AC-45e370aa | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4090 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex("WEEK_NAME")) | UI_PROP | popupWeek.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-210c01c1 | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4093 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex("WEEK_NAME")) | UI_PROP | popupWeek.cmb_Cal | txtDate | 속성 cmb_Cal 설정 |  |  |  |
| AC-7fb9da2e | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4098 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex("WEEK_NAME"))… | UI_PROP | popupWeek.CurrentDate | DateTime.ParseExact(DateTime.Now.ToShortDateString().Substring(0, 10), "yyyy-MM-dd", enUS) | 속성 CurrentDate 설정 |  |  |  |
| AC-57d96f18 | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4098 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex("WEEK_NAME"))… | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a60468d | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4104 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex("WEEK_NAME")) | POPUP | popupWeek.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-481421e4 | this.spdMain.CellDoubleClick | SCP0126_CAPA.cs:4112 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex("WEEK_NAME"))… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.WEEK_NAME), weekName) | 그리드 값 설정 |  |  |  |

## SCP0126_CAPA.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b54d5eb | this.spdMain.ClipboardPasted | SCP0126_CAPA.cs:3970 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ for (iRow < e.CellRange.… | DATA_OP | dtLineAll.Select | ("CODE = '" + lineId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ec3e787 | this.spdMain.ClipboardPasted | SCP0126_CAPA.cs:3971 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa) ▸ for (iRow < e.CellRange.… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LINE_NAME), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0126_CAPA.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7ebafba | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3870 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | DATA_OP | DBUtils.Filter | (dtLineAll, "DIVISION_ID = '" + division + "' AND PLANT_ID = '" + plantId + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4edf6c8b | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | FLAG | dtLineCombo | dtLineTemp.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-054bd4f8 | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | DATA_OP | dtLineTemp.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e4de87aa | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3876 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | GRID_SET | dtLineCombo.Rows[i]["NAME"] | dtLineCombo.Rows[i]["CODE"] | 그리드 속성/값 설정 |  |  |  |
| AC-cd4b50a7 | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3880 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | DATA_OP | dtLineCombo.Select | ("CODE = '" + lineID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a257ae2 | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3882 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-6da92442 | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3883 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-77f56f2b | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3889 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | DATA_OP | dtLineAll.Select | ("CODE = '" + lineId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad25a081 | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3890 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_NAME), codeVal) | 그리드 값 설정 |  |  |  |
| AC-4a326dbc | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3897 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), operation) | 그리드 값 설정 |  |  |  |
| AC-7de27428 | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | FLAG | dtLineType | DBUtils.Filter(dtLineTypeAll, "OPERATION_ID = '" + operationID + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-21937cad | this.spdMain.ComboSelChange | SCP0126_CAPA.cs:3904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName != SpdSheet.shtDailyCapa && _sActiveSheetName != Spd… | DATA_OP | DBUtils.Filter | (dtLineTypeAll, "OPERATION_ID = '" + operationID + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0126_NoWork_BatchPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5aa376ee | this.btnButtonList.UsrButtonList_Click_Detected | SCP0126_NoWork_BatchPopup.cs:484 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_NoWork_BatchPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75d802c4 | this.Load | SCP0126_NoWork_BatchPopup.cs:172 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b538ac87 | this.Load | SCP0126_NoWork_BatchPopup.cs:173 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e29e4149 | this.Load | SCP0126_NoWork_BatchPopup.cs:174 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0126_NoWork_BatchPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-655751f2 | this.Load | SCP0126_NoWork_BatchPopup.cs:167 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0126_NoWork_BatchPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dce5a287 | Dispose | SCP0126_NoWork_BatchPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0126_NoWork_BatchPopup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c128edc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:243 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1f0cb0f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:244 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5f70b8ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:246 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SEQ), siMain.GetColumnIndex(DefColumns.SEQ), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6cbad1dc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:247 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DAY_OF_WEEK), siMain.GetColumnIndex(DefColumns.DAY_OF_WE… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0126_NoWork_BatchPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12d90c3e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:269 |  | DATA_OP | dtTemp.Columns.Add | ("SEQ", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d4fd079 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:270 |  | DATA_OP | dtTemp.Columns.Add | ("DAY_OF_WEEK", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7461508d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:271 |  | DATA_OP | dtTemp.Columns.Add | ("OFF_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e818550 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:272 |  | DATA_OP | dtTemp.Columns.Add | ("TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf4cabe5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:273 |  | DATA_OP | dtTemp.Columns.Add | ("DESC", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-44ef97e6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:283 | if (iWeek > 0) ▸ for (i < iWeek) ▸ for (k < _dayOfWeek.Length) | DATA_OP | dtTemp.Rows.Add | (new object[] { iCnt, _dayOfWeek[k], "0", "" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c97b2fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:290 |  | DATA_OP | ds.Tables.Add | (dtTemp) | 데이터 객체 조작/조회 |  |  |  |
| AC-84ce01e9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:293 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d5d0ebb5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:294 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-059b600e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:298 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0126_NoWork_BatchPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99724a51 | this.Load | SCP0126_NoWork_BatchPopup.cs:100 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2dc6ee28 | this.Load | SCP0126_NoWork_BatchPopup.cs:101 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-175100b0 | this.Load | SCP0126_NoWork_BatchPopup.cs:109 |  | FLAG | division | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-cb7f9526 | this.Load | SCP0126_NoWork_BatchPopup.cs:110 |  | FLAG | dtScmSite | scmSite | 화면 필드/플래그 변경 |  |  |  |
| AC-96c3dbd6 | this.Load | SCP0126_NoWork_BatchPopup.cs:111 |  | FLAG | dtLineAll | LineAll | 화면 필드/플래그 변경 |  |  |  |

## SCP0126_NoWork_BatchPopup.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2308ba1 | this.Load | SCP0126_NoWork_BatchPopup.cs:223 |  | CALL_EXT | monday.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4db5cc78 | this.Load | SCP0126_NoWork_BatchPopup.cs:229 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0126_NoWork_BatchPopup.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0b5c9fd | this.Load | SCP0126_NoWork_BatchPopup.cs:526 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-64bdda7b | this.Load | SCP0126_NoWork_BatchPopup.cs:528 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e842175 | this.Load | SCP0126_NoWork_BatchPopup.cs:531 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0126_NoWork_BatchPopup.GetSearchInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49fc6b23 | (진입점 미연결) | SCP0126_NoWork_BatchPopup.cs:152 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_GET_CAPA_SEARCH_INFO") ⇒ SCP.SCP0126_GET_CAPA_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-f54d45c6 | (진입점 미연결) | SCP0126_NoWork_BatchPopup.cs:154 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6e3fad41 | (진입점 미연결) | SCP0126_NoWork_BatchPopup.cs:155 |  | DATA_OP | request.Parameters["p_user_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e289af56 | (진입점 미연결) | SCP0126_NoWork_BatchPopup.cs:158 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-259e1180 | (진입점 미연결) | SCP0126_NoWork_BatchPopup.cs:162 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0126_NoWork_BatchPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecf8e924 | this.Load | SCP0126_NoWork_BatchPopup.cs:118 |  | FLAG | dtDivision | GetDivision() | 화면 필드/플래그 변경 |  |  |  |
| AC-647bcc90 | this.Load | SCP0126_NoWork_BatchPopup.cs:119 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-502f99c1 | this.Load | SCP0126_NoWork_BatchPopup.cs:120 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c6d7ce77 | this.Load | SCP0126_NoWork_BatchPopup.cs:124 |  | VALUE_SET | clbDivision.ControlValues | division | 컨트롤 값 설정 |  |  |  |
| AC-a27052ec | this.Load | SCP0126_NoWork_BatchPopup.cs:125 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-db85b248 | this.Load | SCP0126_NoWork_BatchPopup.cs:126 |  | VALUE_SET | txtWeek.Text | "1" | 컨트롤 값 설정 |  |  |  |
| AC-705518d4 | this.Load | SCP0126_NoWork_BatchPopup.cs:128 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-764afbff | this.Load | SCP0126_NoWork_BatchPopup.cs:130 |  | FLAG | _dayOfWeek | new string[7] | 화면 필드/플래그 변경 |  |  |  |
| AC-3cb84c4d | this.Load | SCP0126_NoWork_BatchPopup.cs:131 |  | DATA_OP | _dayOfWeek[0] | "MON" | 행/컬럼 값 대입 |  |  |  |
| AC-52cf8e3b | this.Load | SCP0126_NoWork_BatchPopup.cs:132 |  | DATA_OP | _dayOfWeek[1] | "TUE" | 행/컬럼 값 대입 |  |  |  |
| AC-5d94212d | this.Load | SCP0126_NoWork_BatchPopup.cs:133 |  | DATA_OP | _dayOfWeek[2] | "WED" | 행/컬럼 값 대입 |  |  |  |
| AC-a9ac4331 | this.Load | SCP0126_NoWork_BatchPopup.cs:134 |  | DATA_OP | _dayOfWeek[3] | "THU" | 행/컬럼 값 대입 |  |  |  |
| AC-9073fc45 | this.Load | SCP0126_NoWork_BatchPopup.cs:135 |  | DATA_OP | _dayOfWeek[4] | "FRI" | 행/컬럼 값 대입 |  |  |  |
| AC-09abeaea | this.Load | SCP0126_NoWork_BatchPopup.cs:136 |  | DATA_OP | _dayOfWeek[5] | "SAT" | 행/컬럼 값 대입 |  |  |  |
| AC-6cd51377 | this.Load | SCP0126_NoWork_BatchPopup.cs:137 |  | DATA_OP | _dayOfWeek[6] | "SUN" | 행/컬럼 값 대입 |  |  |  |
| AC-cd885c0a | this.Load | SCP0126_NoWork_BatchPopup.cs:139 |  | FLAG | dtNoWorkType | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |

## SCP0126_NoWork_BatchPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77e510a5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0126_NoWork_BatchPopup.cs:188 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2dace77d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0126_NoWork_BatchPopup.cs:190 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d649312e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0126_NoWork_BatchPopup.cs:192 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.Seq, DefColumns.SEQ, FPMerge.None, 60, true, FPHAlign.Right, FPVAlign.Gen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d47a1230 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0126_NoWork_BatchPopup.cs:193 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DayOfWeek, DefColumns.DAY_OF_WEEK, FPMerge.None, 100, true, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4932bf2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0126_NoWork_BatchPopup.cs:194 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.OffTime, DefColumns.OFF_TIME, FPMerge.None, 100, true, FPHAlign.Right, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-354a0db7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0126_NoWork_BatchPopup.cs:195 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.Type, DefColumns.NO_WORK_TYPE, FPMerge.None, 200, true, FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d8a22b1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0126_NoWork_BatchPopup.cs:196 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.Desc, DefColumns.DESC, FPMerge.None, 200, true, FPHAlign.Left, FPVAlign.G… | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0126_NoWork_BatchPopup.RefreshLine

진입점: this.Load / this.clbScmSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b2bce5d | this.Load 외 1 | SCP0126_NoWork_BatchPopup.cs:206 |  | FLAG | dtLine | DBUtils.Filter(dtLineAll, "DIVISION_ID = '" + division + "'" + filterPlantId, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f4052a0 | this.Load 외 1 | SCP0126_NoWork_BatchPopup.cs:206 |  | DATA_OP | DBUtils.Filter | (dtLineAll, "DIVISION_ID = '" + division + "'" + filterPlantId, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-39041aa1 | this.Load 외 1 | SCP0126_NoWork_BatchPopup.cs:208 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0126_NoWork_BatchPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ec5e064 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:314 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31b01f42 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:316 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-40c4f808 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:329 | try ▸ if (dayOfWeek != 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00330") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a0bf5a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:330 | try ▸ if (dayOfWeek != 1) | FLAG | isEdit | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4057c732 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:331 | try ▸ if (dayOfWeek != 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3db26cd3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:337 | try ▸ if (DateTime.Compare(dtFrom, dtTo) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00344") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c49a6da2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:338 | try ▸ if (DateTime.Compare(dtFrom, dtTo) > 0) | FLAG | isEdit | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2431c0cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:339 | try ▸ if (DateTime.Compare(dtFrom, dtTo) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04d6084f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:347 | try ▸ if (p_line_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00061", new object[] { "Line" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-606dd169 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:348 | try ▸ if (p_line_id == "") | FLAG | isEdit | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ca08c465 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:349 | try ▸ if (p_line_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-816f5ae7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:387 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (double.TryParse(off_time, out double number)) ▸ if (dotCount == 1) ▸ if (off_time.Split('.')[… | MESSAGE | MessageHelper.GMessageBox | ("{0} \r\n소수점 최대 10자리까지 입력가능합니다. ", new object[] { args + off_time }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb6142c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:388 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (double.TryParse(off_time, out double number)) ▸ if (dotCount == 1) ▸ if (off_time.Split('.')[… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb003729 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:394 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (double.TryParse(off_time, out double number)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { args + off_time }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f837420 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:395 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (double.TryParse(off_time, out double number)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-468f1573 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:409 | try ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-830f648f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:411 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0126_SAVE_NO_WORK_BATCH") ⇒ SCP.SCP0126_SAVE_NO_WORK_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-c04ed19c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:414 | try ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-623491c2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:418 | try ▸ if (iCount > 0) ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-650692cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:420 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b1292c07 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:421 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-56e663e0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:422 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-d1a6d870 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:423 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_end_date"] | p_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-a39801c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:424 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-6fc392dc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:425 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_off_time"] | p_off_time | 행/컬럼 값 대입 |  |  |  |
| AC-4c4cd58b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:426 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-2524ebcd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:427 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_desc"] | p_desc | 행/컬럼 값 대입 |  |  |  |
| AC-fe9678da | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:428 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6cb897ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:430 | try ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f3739e31 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:430 | try ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-01b9ce57 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:434 | try ▸ if (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-55744e3a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:441 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-26e51fe2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:443 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-92d98ccb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:444 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | isEdit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4a83996f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:451 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0482a39e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:459 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5ce94000 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0126_NoWork_BatchPopup.cs:461 | finally ▸ if (isEdit) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_NoWork_BatchPopup.SCP0126_NoWork_BatchPopup_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ba6787a | this.FormClosing | SCP0126_NoWork_BatchPopup.cs:515 | if (isEdit) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## SCP0126_NoWork_BatchPopup.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f9ea4ae | this.spdMain.CellClick | SCP0126_NoWork_BatchPopup.cs:497 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.NO_WORK_TYPE)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.NO_WORK_TYPE, dtNoWorkType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0126_SingleDatePopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-317a2c91 | .ctor | SCP0126_SingleDatePopup.cs:96 |  | FLAG | ChangeImmediately | changeImmediately | 화면 필드/플래그 변경 |  |  |  |
| AC-635f6b79 | .ctor | SCP0126_SingleDatePopup.cs:97 |  | UI_PROP | dataGridViewCellStyle.BackColor | pn_Controls.BackColor = pn_Header.BackColor = headerColor | 속성 BackColor 설정 |  |  |  |
| AC-c501f9ff | .ctor | SCP0126_SingleDatePopup.cs:97 |  | UI_PROP | pn_Controls.BackColor | pn_Header.BackColor = headerColor | 속성 BackColor 설정 |  |  |  |
| AC-324a9b57 | .ctor | SCP0126_SingleDatePopup.cs:97 |  | UI_PROP | pn_Header.BackColor | headerColor | 속성 BackColor 설정 |  |  |  |
| AC-ffab6731 | .ctor | SCP0126_SingleDatePopup.cs:98 |  | UI_PROP | dataGridViewCellStyle.Font | new Font("Tahoma", 7.5F, FontStyle.Regular, GraphicsUnit.Point, (204)) | 속성 Font 설정 |  |  |  |
| AC-dcd94d6d | .ctor | SCP0126_SingleDatePopup.cs:99 |  | UI_PROP | dgv_Dates.ColumnHeadersDefaultCellStyle | dataGridViewCellStyle | 속성 ColumnHeadersDefaultCellStyle 설정 |  |  |  |
| AC-833fdd91 | .ctor | SCP0126_SingleDatePopup.cs:101 |  | UI_PROP | dgv_Dates.RowTemplate.Height | 19 | 속성 Height 설정 |  |  |  |

## SCP0126_SingleDatePopup.AddGridViewColumns

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c661af37 | this.Load | SCP0126_SingleDatePopup.cs:213 |  | FLAG | colWidth | 40 | 화면 필드/플래그 변경 |  |  |  |
| AC-03155280 | this.Load | SCP0126_SingleDatePopup.cs:214 |  | FLAG | weekWidth | 150 | 화면 필드/플래그 변경 |  |  |  |
| AC-1c0fdfd2 | this.Load | SCP0126_SingleDatePopup.cs:219 | for (i < WEEK_LEN-1) | DATA_OP | dayNames[i] | longDayDaynames[i+1].ToUpper().Substring(0, 3) | 행/컬럼 값 대입 |  |  |  |
| AC-86078198 | this.Load | SCP0126_SingleDatePopup.cs:221 |  | DATA_OP | dayNames[6] | longDayDaynames[0].ToUpper().Substring(0, 3) | 행/컬럼 값 대입 |  |  |  |
| AC-9613b78d | this.Load | SCP0126_SingleDatePopup.cs:225 |  | DATA_OP | dgv_Dates.Columns.Add | ("col" +"WEEK","WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-2fe7301e | this.Load | SCP0126_SingleDatePopup.cs:230 | for (i < WEEK_LEN) | DATA_OP | dgv_Dates.Columns.Add | ("col" + dayNames[i].Substring(0, 2), dayNames[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-c02014c9 | this.Load | SCP0126_SingleDatePopup.cs:239 | for (i < WEEK_LEN+1) | UI_PROP | column.HeaderCell.Style.Font | new Font("Tahpma", 7.5F, FontStyle.Regular, GraphicsUnit.Point, 0) | 속성 Font 설정 |  |  |  |
| AC-c09e2957 | this.Load | SCP0126_SingleDatePopup.cs:240 | for (i < WEEK_LEN+1) | UI_PROP | column.HeaderCell.Style.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-3d692112 | this.Load | SCP0126_SingleDatePopup.cs:241 | for (i < WEEK_LEN+1) | UI_PROP | column.HeaderCell.Style.Alignment | DataGridViewContentAlignment.MiddleCenter | 속성 Alignment 설정 |  |  |  |
| AC-850aa162 | this.Load | SCP0126_SingleDatePopup.cs:244 | for (i < WEEK_LEN+1) ▸ if (i==0) | UI_PROP | column.HeaderCell.Style.ForeColor | Color.Red | 속성 ForeColor 설정 |  |  |  |
| AC-ec8ec804 | this.Load | SCP0126_SingleDatePopup.cs:246 | for (i < WEEK_LEN+1) ▸ else of (i==0) ▸ if (i == 6) | UI_PROP | column.HeaderCell.Style.ForeColor | Color.Blue | 속성 ForeColor 설정 |  |  |  |
| AC-d53198d0 | this.Load | SCP0126_SingleDatePopup.cs:248 | for (i < WEEK_LEN+1) ▸ else of (i==0) ▸ else of (i == 6) ▸ if (i == 7) | UI_PROP | column.HeaderCell.Style.ForeColor | Color.Red | 속성 ForeColor 설정 |  |  |  |
| AC-211e1261 | this.Load | SCP0126_SingleDatePopup.cs:250 | for (i < WEEK_LEN+1) ▸ else of (i==0) ▸ else of (i == 6) ▸ else of (i == 7) | UI_PROP | column.HeaderCell.Style.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-18725384 | this.Load | SCP0126_SingleDatePopup.cs:257 | foreach (DataGridViewColumn each_column in dgv_Dates.Columns) | UI_PROP | each_column.SortMode | DataGridViewColumnSortMode.NotSortable | 속성 SortMode 설정 |  |  |  |
| AC-5886eea0 | this.Load | SCP0126_SingleDatePopup.cs:269 | for (i < ROW_LEN) | DATA_OP | dgv_Dates.Rows.Add | ("") | 데이터 객체 조작/조회 |  |  |  |

## SCP0126_SingleDatePopup.btnCancel_Click

진입점: this.btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78628264 | this.btnCancel.Click | SCP0126_SingleDatePopup.cs:632 |  | UI_PROP | this.DialogResult | DialogResult.Cancel | 속성 DialogResult 설정 |  |  |  |
| AC-8e6676fb | this.btnCancel.Click | SCP0126_SingleDatePopup.cs:633 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_SingleDatePopup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4faa5a34 | this.btnOK.Click | SCP0126_SingleDatePopup.cs:625 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-86e0eb1d | this.btnOK.Click | SCP0126_SingleDatePopup.cs:626 |  | VALUE_SET | cmb_Cal.Text | _currentDate.ToString("yyyyMMdd",enUS) | 컨트롤 값 설정 |  |  |  |
| AC-074aaab1 | this.btnOK.Click | SCP0126_SingleDatePopup.cs:627 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_SingleDatePopup.ChangeCurrentCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d7f595c | (진입점 미연결) | SCP0126_SingleDatePopup.cs:292 |  | FLAG | CurrentRow | rowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-f46f4c40 | (진입점 미연결) | SCP0126_SingleDatePopup.cs:293 |  | FLAG | CurrentColumn | columnIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-e15326af | (진입점 미연결) | SCP0126_SingleDatePopup.cs:294 |  | GRID_SET | dgv_Dates.Rows[rowIndex].Cells[columnIndex].Selected | true | 그리드 속성/값 설정 |  |  |  |

## SCP0126_SingleDatePopup.cmb_Months_SelectedIndexChanged

진입점: cmb_Months.SelectedIndexChanged / this.cmb_Months.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a68409e | cmb_Months.SelectedIndexChanged 외 1 | SCP0126_SingleDatePopup.cs:523 | if (cmb_Months.SelectedValue is int) | CALL_EXT | DateTime.DaysInMonth | (_currentDate.Year, (int)cmb_Months.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-da42037d | cmb_Months.SelectedIndexChanged 외 1 | SCP0126_SingleDatePopup.cs:524 | if (cmb_Months.SelectedValue is int) | FLAG | _currentDate | new DateTime(_currentDate.Year, (int)cmb_Months.SelectedValue, day, _currentDate.Hour, _cu… | 화면 필드/플래그 변경 |  |  |  |
| AC-adf4b0c8 | cmb_Months.SelectedIndexChanged 외 1 | SCP0126_SingleDatePopup.cs:528 | if (cmb_Months.SelectedValue is int) ▸ if (ChangeImmediately) | VALUE_SET | cmb_Cal.Text | _currentDate.ToString("yyyyMMdd",enUS) | 컨트롤 값 설정 |  |  |  |

## SCP0126_SingleDatePopup.cmb_Years_SelectedIndexChanged

진입점: this.cmb_Years.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e75e3627 | this.cmb_Years.SelectedIndexChanged | SCP0126_SingleDatePopup.cs:510 | if (cmb_Years.SelectedItem != null) | FLAG | _currentDate | new DateTime((int)cmb_Years.SelectedItem, _currentDate.Month, _currentDate.Day, _currentDa… | 화면 필드/플래그 변경 |  |  |  |
| AC-17c2c5be | this.cmb_Years.SelectedIndexChanged | SCP0126_SingleDatePopup.cs:514 | if (cmb_Years.SelectedItem != null) ▸ if (ChangeImmediately) | VALUE_SET | cmb_Cal.Text | _currentDate.ToString("yyyyMMdd",enUS) | 컨트롤 값 설정 |  |  |  |

## SCP0126_SingleDatePopup.dgv_Dates_SelectionChanged

진입점: dgv_Dates.SelectionChanged / this.dgv_Dates.SelectionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6efc953e | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:655 | if (OnInit) | FLAG | OnInit | false | 화면 필드/플래그 변경 |  |  |  |
| AC-04a2b374 | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:664 | if (columnIndex == 0) ▸ if (CurrentColumn != -1 && CurrentRow != -1) | GRID_SET | dgv_Dates.Rows[CurrentRow].Cells[CurrentColumn].Selected | true | 그리드 속성/값 설정 |  |  |  |
| AC-79bfa67d | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:667 | if (columnIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82c71c21 | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:692 | if (!same_month) | GRID_SET | dgv_Dates.Rows[CurrentRow].Cells[CurrentColumn].Selected | true | 그리드 속성/값 설정 |  |  |  |
| AC-e4faa5ea | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:694 | if (!same_month) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c87c0616 | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:698 | try | FLAG | _currentDate | new DateTime(_currentDate.Year, tag_str, val_date, _currentDate.Hour, _currentDate.Minute,… | 화면 필드/플래그 변경 |  |  |  |
| AC-a57f30ff | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:703 | try | FLAG | _currentWeek | dgv_Dates.Rows[rowIndex].Cells[0].Value.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9d66f737 | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:708 | try | FLAG | _weekStart | weekStartDate.ToString("yyyyMMdd", enUS) | 화면 필드/플래그 변경 |  |  |  |
| AC-b40c1814 | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:709 | try | FLAG | _weekEnd | weekStartDate.AddDays(6).ToString("yyyyMMdd", enUS) | 화면 필드/플래그 변경 |  |  |  |
| AC-13d95567 | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:714 | if (ChangeImmediately) | VALUE_SET | cmb_Cal.Text | _currentDate.ToString("yyyyMMdd",enUS) | 컨트롤 값 설정 |  |  |  |
| AC-bbd17db1 | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:723 |  | FLAG | CurrentColumn | columnIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-4104b4fe | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:724 |  | FLAG | CurrentRow | rowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-6a98fc86 | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:730 | for (r < dgv_Dates.Rows.Count) ▸ if (r == rowIndex) | GRID_SET | dgv_Dates.Rows[rowIndex].Cells[0].Style.BackColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ea54c4fc | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:731 | for (r < dgv_Dates.Rows.Count) ▸ if (r == rowIndex) | GRID_SET | dgv_Dates.Rows[rowIndex].Cells[0].Style.ForeColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-10492538 | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:735 | for (r < dgv_Dates.Rows.Count) ▸ else of (r == rowIndex) | GRID_SET | dgv_Dates.Rows[r].Cells[0].Style.BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-e6563a36 | dgv_Dates.SelectionChanged 외 1 | SCP0126_SingleDatePopup.cs:736 | for (r < dgv_Dates.Rows.Count) ▸ else of (r == rowIndex) | GRID_SET | dgv_Dates.Rows[r].Cells[0].Style.ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |

## SCP0126_SingleDatePopup.dgvDates_CellEnter

진입점: this.dgv_Dates.CellEnter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9197175 | this.dgv_Dates.CellEnter | SCP0126_SingleDatePopup.cs:536 | if (e.ColumnIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0126_SingleDatePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43dd2282 | Dispose | SCP0126_SingleDatePopup.designer.cs:20 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0126_SingleDatePopup.exitButton_Click

진입점: this.btnExit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd1d9e6c | this.btnExit.Click | SCP0126_SingleDatePopup.cs:619 |  | UI_PROP | this.DialogResult | DialogResult.Abort | 속성 DialogResult 설정 |  |  |  |
| AC-a1445eb7 | this.btnExit.Click | SCP0126_SingleDatePopup.cs:620 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0126_SingleDatePopup.FillCells

진입점: cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValue is int)] / this.btn_NextMonth.Click / this.btn_PrevMonth.Click / this.cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValue is int)] / this.cmb_Years.SelectedIndexChanged [if (cmb_Years.SelectedItem != null)] / this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5d5bf66 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:348 | try ▸ for (i < ROW_LEN) | CALL_EXT | DateTime.DaysInMonth | (_currentDate.Year, _currentDate.Month) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb47b370 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:353 | try ▸ for (i < ROW_LEN) ▸ if ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|\| (n… | DATA_OP | dgv_Dates.Rows.RemoveAt | (ROW_LEN - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-84adfa6b | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:367 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | DATA_OP | dgv_Dates.Rows.Add | ("") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb2042f2 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:393 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[0].Value | weekEndYear + week_index.ToString("D2") | 그리드 속성/값 설정 |  |  |  |
| AC-31f1c966 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:397 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[0].Value | weekStartYear + week_index.ToString("D2") | 그리드 속성/값 설정 |  |  |  |
| AC-b186bcd6 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:402 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[0].Value | weekStartYear + week_index.ToString("D2") | 그리드 속성/값 설정 |  |  |  |
| AC-4accbbbd | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:406 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[0].Tag | week_index | 그리드 속성/값 설정 |  |  |  |
| AC-d0ce4029 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:407 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[0].Style.Font | new Font("Tahpma", 7.5F, FontStyle.Regular, GraphicsUnit.Point, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-a336f807 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:408 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[0].Style.BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-31c9f9f8 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:409 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[0].Style.ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-299a0d4d | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:410 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[0].Style.Alignment | DataGridViewContentAlignment.MiddleCenter | 그리드 속성/값 설정 |  |  |  |
| AC-9d8d0d1a | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:423 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | CALL_EXT | DateTime.DaysInMonth | (_currentDate.Year, _currentDate.AddMonths(-1).Month) | ⚠ 의미 확인 필요 |  |  |  |
| AC-586e2426 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:431 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | CALL_EXT | DateTime.DaysInMonth | (_currentDate.Year, _currentDate.Month) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a52ade8 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:438 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Value | nrDay.ToString("D2") | 그리드 속성/값 설정 |  |  |  |
| AC-39ec9fcb | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:439 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Tag | nrMonth | 그리드 속성/값 설정 |  |  |  |
| AC-c1876c3d | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:457 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.Font | new Font("Tahpma", 7.5F, FontStyle.Bold, GraphicsUnit.Point, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-3a1fd257 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:458 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.BackColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-61cd7d41 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:459 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.ForeColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-707b516b | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:460 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.Alignment | DataGridViewContentAlignment.MiddleCenter | 그리드 속성/값 설정 |  |  |  |
| AC-854a73f0 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:469 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-ace81384 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:474 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-a79cab7f | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:479 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-526f39fe | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:482 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.Font | new Font("Tahpma", 7.5F, FontStyle.Regular, GraphicsUnit.Point, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-b4d674ec | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:483 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-ca6b31fa | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:484 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.Alignment | DataGridViewContentAlignment.MiddleCenter | 그리드 속성/값 설정 |  |  |  |
| AC-4192ac4c | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:490 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.Font | new Font("Tahpma", 7.5F, FontStyle.Regular, GraphicsUnit.Point, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-0e1d6a15 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:491 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-030d0f2e | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:492 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.ForeColor | Color.DarkGray | 그리드 속성/값 설정 |  |  |  |
| AC-913ee6fc | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:493 | try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|… | GRID_SET | dgv_Dates.Rows[i].Cells[x].Style.Alignment | DataGridViewContentAlignment.MiddleCenter | 그리드 속성/값 설정 |  |  |  |

## SCP0126_SingleDatePopup.FillComboxes

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-168d4bfb | this.Load | SCP0126_SingleDatePopup.cs:150 |  | DATA_OP | monthList.Columns.Add | (new DataColumn("Month", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd51360a | this.Load | SCP0126_SingleDatePopup.cs:151 |  | DATA_OP | monthList.Columns.Add | (new DataColumn("Id", typeof(int))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9881ee84 | this.Load | SCP0126_SingleDatePopup.cs:154 | for (i < 12) | DATA_OP | monthList.Rows.Add | (monthList.NewRow()) | 데이터 객체 조작/조회 |  |  |  |
| AC-77b1be5b | this.Load | SCP0126_SingleDatePopup.cs:154 | for (i < 12) | DATA_OP | monthList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5c91dd78 | this.Load | SCP0126_SingleDatePopup.cs:156 | for (i < 12) | GRID_SET | monthList.Rows[i][0] | i + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-0950693e | this.Load | SCP0126_SingleDatePopup.cs:157 | for (i < 12) | GRID_SET | monthList.Rows[i][1] | i + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-c94e4c72 | this.Load | SCP0126_SingleDatePopup.cs:160 |  | LIST_BIND | cmb_Months.DataSource | monthList | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-abc05248 | this.Load | SCP0126_SingleDatePopup.cs:161 |  | LIST_BIND | cmb_Months.DisplayMember | "Month" | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-7c908724 | this.Load | SCP0126_SingleDatePopup.cs:162 |  | LIST_BIND | cmb_Months.ValueMember | "Id" | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-dbd4a0cb | this.Load | SCP0126_SingleDatePopup.cs:167 | for (i < 201) | DATA_OP | cmb_Years.Items.Insert | (i, i + 1900) | 데이터 객체 조작/조회 |  |  |  |
| AC-12ef4403 | this.Load | SCP0126_SingleDatePopup.cs:170 |  | VALUE_SET | cmb_Years.SelectedItem | _currentDate.Year | 컨트롤 값 설정 |  |  |  |
| AC-657c3b81 | this.Load | SCP0126_SingleDatePopup.cs:171 |  | VALUE_SET | cmb_Months.SelectedValue | _currentDate.Month | 컨트롤 값 설정 |  |  |  |

## SCP0126_SingleDatePopup.FirstDayOfMonth

진입점: cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValue is int)] / this.btn_NextMonth.Click / this.btn_PrevMonth.Click / this.cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValue is int)] / this.cmb_Years.SelectedIndexChanged [if (cmb_Years.SelectedItem != null)] / this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b62492b2 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:316 |  | RETURN | return new DateTime(dateTime.Year, dateTime.Month, 1,koreanCalendar); |  | 처리 중단/반환 |  |  |  |

## SCP0126_SingleDatePopup.frmDatePicker_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c8b8874 | this.Load | SCP0126_SingleDatePopup.cs:116 |  | UI_PROP | dgv_Dates.EnableHeadersVisualStyles | false | 속성 EnableHeadersVisualStyles 설정 |  |  |  |
| AC-d881085b | this.Load | SCP0126_SingleDatePopup.cs:120 | if (singleMode) | UI_PROP | this.Width | 289 | 속성 Width 설정 |  |  |  |
| AC-13e85307 | this.Load | SCP0126_SingleDatePopup.cs:121 | if (singleMode) | UI_PROP | this.Height | 246 | 속성 Height 설정 |  |  |  |
| AC-85a33cf3 | this.Load | SCP0126_SingleDatePopup.cs:122 | if (singleMode) | UI_PROP | btnOK.Left | 74 | 속성 Left 설정 |  |  |  |
| AC-ea26a258 | this.Load | SCP0126_SingleDatePopup.cs:123 | if (singleMode) | UI_PROP | btnOK.Top | 6 | 속성 Top 설정 |  |  |  |
| AC-e66dda00 | this.Load | SCP0126_SingleDatePopup.cs:124 | if (singleMode) | UI_PROP | btnCancel.Left | 155 | 속성 Left 설정 |  |  |  |
| AC-5fd6b2eb | this.Load | SCP0126_SingleDatePopup.cs:125 | if (singleMode) | UI_PROP | btnCancel.Top | 6 | 속성 Top 설정 |  |  |  |
| AC-b39fcd30 | this.Load | SCP0126_SingleDatePopup.cs:126 | if (singleMode) | UI_PROP | btnExit.Left | 257 | 속성 Left 설정 |  |  |  |
| AC-6c1853d9 | this.Load | SCP0126_SingleDatePopup.cs:127 | if (singleMode) | UI_PROP | btnExit.Top | 2 | 속성 Top 설정 |  |  |  |

## SCP0126_SingleDatePopup.GetIso8601WeekOfYear

진입점: cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValue is int) ▸ try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|\| (nrMonth == _c…)] / this.btn_NextMonth.Click [try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|\| (nrMonth == _c…)] / this.btn_PrevMonth.Click [try ▸ for (i < ROW_LEN) ▸ else of ((nrDay > DateTime.DaysInMonth(_currentDate.Year, _currentDate.Month) && nrMonth == _currentDate.Month) \|\| (nrMont…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b017f7ef | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:179 |  | CALL_EXT | CultureInfo.InvariantCulture.Calendar.GetDayOfWeek | (time) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b90be0fe | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:186 |  | CALL_EXT | CultureInfo.InvariantCulture.Calendar.GetWeekOfYear | (time, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b804e0c | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 6 | SCP0126_SingleDatePopup.cs:186 |  | RETURN | return CultureInfo.InvariantCulture.Calendar.GetWeekOfYear(time, CalendarWeekRul… |  | 처리 중단/반환 |  |  |  |

## SCP0126_SingleDatePopup.lbl_Today_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5cf5cb7 | (진입점 미연결) | SCP0126_SingleDatePopup.cs:567 |  | FLAG | _currentDate | DateTime.Now | 화면 필드/플래그 변경 |  |  |  |
| AC-e07b716a | (진입점 미연결) | SCP0126_SingleDatePopup.cs:570 |  | VALUE_SET | cmb_Years.SelectedItem | _currentDate.Year | 컨트롤 값 설정 |  |  |  |
| AC-20e71b0e | (진입점 미연결) | SCP0126_SingleDatePopup.cs:571 |  | VALUE_SET | cmb_Months.SelectedValue | _currentDate.Month | 컨트롤 값 설정 |  |  |  |
| AC-3e260d70 | (진입점 미연결) | SCP0126_SingleDatePopup.cs:573 | if (ChangeImmediately) | VALUE_SET | cmb_Cal.Text | DateTime.Now.ToString("yyyyMMdd",enUS) | 컨트롤 값 설정 |  |  |  |

## SCP0126_SingleDatePopup.NextPrevMonth

진입점: this.btn_NextMonth.Click / this.btn_PrevMonth.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7818398d | this.btn_NextMonth.Click 외 1 | SCP0126_SingleDatePopup.cs:304 |  | FLAG | _currentDate | _currentDate.AddMonths(monthNumber) | 화면 필드/플래그 변경 |  |  |  |
| AC-18341574 | this.btn_NextMonth.Click 외 1 | SCP0126_SingleDatePopup.cs:307 |  | VALUE_SET | cmb_Years.SelectedItem | _currentDate.Year | 컨트롤 값 설정 |  |  |  |
| AC-5cb75160 | this.btn_NextMonth.Click 외 1 | SCP0126_SingleDatePopup.cs:308 |  | VALUE_SET | cmb_Months.SelectedValue | _currentDate.Month | 컨트롤 값 설정 |  |  |  |
| AC-38f9cad1 | this.btn_NextMonth.Click 외 1 | SCP0126_SingleDatePopup.cs:310 | if (ChangeImmediately) | VALUE_SET | cmb_Cal.Text | _currentDate.ToString("yyyyMMdd",enUS) | 컨트롤 값 설정 |  |  |  |

## SCP0126_SingleDatePopup.SelectCell

진입점: cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValue is int)] / this.btn_NextMonth.Click / this.btn_PrevMonth.Click / this.cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValue is int)] / this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97059836 | cmb_Months.SelectedIndexChanged [if (cmb_Months.SelectedValu… 외 5 | SCP0126_SingleDatePopup.cs:283 | for (r < dgv_Dates.Rows.Count) ▸ for (c < dgv_Dates.Columns.Count) ▸ if (Convert.ToInt32(dgv_Dates.Rows[r].Cells[c].Value) == dayValue && Co… | CALL_EXT | dgv_Dates.BeginInvoke | (new ChangeCurrentCellDelegate(ChangeCurrentCell), new object[] { r, c }) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0126_SingleDatePopup.tr_Mins_Scroll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2357d81c | (진입점 미연결) | SCP0126_SingleDatePopup.cs:611 |  | FLAG | _currentDate | new DateTime(_currentDate.Year, _currentDate.Month, _currentDate.Day,koreanCalendar) | 화면 필드/플래그 변경 |  |  |  |
| AC-36568b95 | (진입점 미연결) | SCP0126_SingleDatePopup.cs:614 |  | VALUE_SET | cmb_Cal.Text | _currentDate.ToString("yyyyMMdd",enUS) | 컨트롤 값 설정 |  |  |  |

