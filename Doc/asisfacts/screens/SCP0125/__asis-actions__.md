# AS-IS 액션 대조표 — SCP0125

> 원천: `Doc/asisfacts/screens/SCP0125/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 445행 · 메서드 27 · 종류 DATA_OP 134 · RETURN 45 · MESSAGE 40 · FLAG 36 · GRID_INIT 32 · LIST_REBIND 26 · GRID_LOCK 24 · UI_PROP 24 · ENDPOINT 17 · UI_MISC 16 · POPUP 16 · CALL_EXT 14 · GRID_SET 13 · VALIDATE 3 · GRID_CLEAR 2 · VALUE_SET 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 14


## SCP0125_Workbench.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7035874e | cboPlanDate.SelectedIndexChanged | SCP0125_Workbench.cs:2004 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0125_Workbench.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad4943cc | cboDivision.SelectedIndexChanged | SCP0125_Workbench.cs:1997 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0125_Workbench.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9977b176 | this.Load | SCP0125_Workbench.cs:312 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMktFcst, SpdSheet.shtMktFcst, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b6204776 | this.Load | SCP0125_Workbench.cs:313 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtStock, SpdSheet.shtStock, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3d0e898b | this.Load | SCP0125_Workbench.cs:314 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtStockElec, SpdSheet.shtStockElec, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2da7ecfa | this.Load | SCP0125_Workbench.cs:315 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtElecDemand, SpdSheet.shtElecDemand, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b3a6bbe5 | this.Load | SCP0125_Workbench.cs:316 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtStockSecondOcv, SpdSheet.shtStockSecondOcv, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2e438c25 | this.Load | SCP0125_Workbench.cs:318 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMktFcst) | 화면 필드/플래그 변경 |  |  |  |
| AC-2b49828e | this.Load | SCP0125_Workbench.cs:321 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-48cb2a29 | this.Load | SCP0125_Workbench.cs:325 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtStockElec) | 화면 필드/플래그 변경 |  |  |  |
| AC-6984983e | this.Load | SCP0125_Workbench.cs:328 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtElecDemand) | 화면 필드/플래그 변경 |  |  |  |
| AC-542ea0ef | this.Load | SCP0125_Workbench.cs:333 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtStockSecondOcv) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce3f9153 | this.Load | SCP0125_Workbench.cs:336 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0125_Workbench.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0d9f27e | DeleteButton | SCP0125_Workbench.cs:496 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39ca7e2c | DeleteButton | SCP0125_Workbench.cs:500 | if (fps.Name == "spdMain") ▸ if (this._currRowIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea6795e9 | DeleteButton | SCP0125_Workbench.cs:507 | if (fps.Name == "spdMain") ▸ if (chg_type != "") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0125_Workbench.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b00985f4 | Dispose | SCP0125_Workbench.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0125_Workbench.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1c5a3af | EditButton | SCP0125_Workbench.cs:516 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cbe6a0a1 | EditButton | SCP0125_Workbench.cs:517 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-2a2eba3c | EditButton | SCP0125_Workbench.cs:518 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.QTY), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e1cc18b4 | EditButton | SCP0125_Workbench.cs:519 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CHG_TYPE), siMain.GetColumnIndex(DefColumns.LAST_UPDATE_… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0125_Workbench.FindData_Main

진입점: FindButton / SaveButton [if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c12487e | FindButton 외 1 | SCP0125_Workbench.cs:536 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-19df54fe | FindButton 외 1 | SCP0125_Workbench.cs:539 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d707981f | FindButton 외 1 | SCP0125_Workbench.cs:539 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d7f5640b | FindButton 외 1 | SCP0125_Workbench.cs:541 | try | FLAG | _isFinding | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f2c8f0df | FindButton 외 1 | SCP0125_Workbench.cs:544 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-15012eb6 | FindButton 외 1 | SCP0125_Workbench.cs:547 | try ▸ if (string.IsNullOrWhiteSpace(_sActiveSheetName)) | FLAG | _sActiveSheetName | siMain.ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-11a9f302 | FindButton 외 1 | SCP0125_Workbench.cs:561 | try ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMktFcst) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbdc626e | FindButton 외 1 | SCP0125_Workbench.cs:572 | try ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02a80407 | FindButton 외 1 | SCP0125_Workbench.cs:588 | try ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock) ▸ if (_sActiveSheetName == SpdSh… | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtStockElec) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92e907fe | FindButton 외 1 | SCP0125_Workbench.cs:603 | try ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock) ▸ else of (_sActiveSheetName == … | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtElecDemand) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c157c0b9 | FindButton 외 1 | SCP0125_Workbench.cs:612 | try ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock) ▸ else of (_sActiveSheetName == … | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtStockSecondOcv) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-389df9f7 | FindButton 외 1 | SCP0125_Workbench.cs:630 | try ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + p_division_id + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b3c8b371 | FindButton 외 1 | SCP0125_Workbench.cs:654 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-75d2608d | FindButton 외 1 | SCP0125_Workbench.cs:655 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-79dafe9f | FindButton 외 1 | SCP0125_Workbench.cs:659 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (queryId) ⇒ {?string.Empty} \| SCP.SCP0125_GET_MKT_FCST_ADJ \| SCP.SCP0125_GET_STOCK_ADJ \| … | 엔드포인트 요청 생성 |  |  |  |
| AC-051bf058 | FindButton 외 1 | SCP0125_Workbench.cs:660 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d7094fd7 | FindButton 외 1 | SCP0125_Workbench.cs:661 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-378fbde2 | FindButton 외 1 | SCP0125_Workbench.cs:662 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e1d15898 | FindButton 외 1 | SCP0125_Workbench.cs:663 | try ▸ lambda | DATA_OP | request.Parameters["p_version_no"] | p_version_no | 행/컬럼 값 대입 |  |  |  |
| AC-4bc28f0f | FindButton 외 1 | SCP0125_Workbench.cs:664 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-d573e3b4 | FindButton 외 1 | SCP0125_Workbench.cs:665 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-54849cc6 | FindButton 외 1 | SCP0125_Workbench.cs:667 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5e32ca5 | FindButton 외 1 | SCP0125_Workbench.cs:669 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-86865ff3 | FindButton 외 1 | SCP0125_Workbench.cs:680 | try ▸ if (ds.Tables.Count > 0) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | FLAG | this.dtMktFcstAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-664ff483 | FindButton 외 1 | SCP0125_Workbench.cs:680 | try ▸ if (ds.Tables.Count > 0) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cb551f15 | FindButton 외 1 | SCP0125_Workbench.cs:684 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActi… | FLAG | this.dtStockAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-52b87583 | FindButton 외 1 | SCP0125_Workbench.cs:684 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActi… | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d9a5e22e | FindButton 외 1 | SCP0125_Workbench.cs:689 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _… | FLAG | this.dtElecDemandAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-246bffc6 | FindButton 외 1 | SCP0125_Workbench.cs:689 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _… | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-38279158 | FindButton 외 1 | SCP0125_Workbench.cs:693 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _… | FLAG | this.dtStockSecondOcvAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-cb3d9520 | FindButton 외 1 | SCP0125_Workbench.cs:693 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _… | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6f0327ab | FindButton 외 1 | SCP0125_Workbench.cs:699 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fb08bbb8 | FindButton 외 1 | SCP0125_Workbench.cs:700 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e4afaa6a | FindButton 외 1 | SCP0125_Workbench.cs:703 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6b165caa | FindButton 외 1 | SCP0125_Workbench.cs:706 | try | FLAG | _isFinding | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a49351e9 | FindButton 외 1 | SCP0125_Workbench.cs:714 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0125_Workbench.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d98670a9 | this.Load | SCP0125_Workbench.cs:169 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0125_Workbench.GetOperationByLine

진입점: this.spdMain.ClipboardPasted [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec \|\| _sActiveSheetName == SpdSheet.sh…) ▸ if (_sActiveSheetName == SpdSheet.shtElecDemand) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ▸ if (iCol == siMain.GetColumnIndex(DefColumns.LINE_ID))] / this.spdMain.ComboSelChange [if (si…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea6bded8 | this.spdMain.ClipboardPasted [if (siMain != null && siMain.I… 외 1 | SCP0125_Workbench.cs:2382 |  | DATA_OP | DBUtils.Filter | (dtPlantSite, "DIVISION_ID = '" + division + "' AND CODE = '" + plantSiteID + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2be2c522 | this.spdMain.ClipboardPasted [if (siMain != null && siMain.I… 외 1 | SCP0125_Workbench.cs:2389 | if (dtPlant.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtLine, "DIVISION_ID = '" + division + "' AND PLANT_ID = '" + plant_id + "' AND CODE = '"… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4b573f03 | this.spdMain.ClipboardPasted [if (siMain != null && siMain.I… 외 1 | SCP0125_Workbench.cs:2397 |  | RETURN | return operation; |  | 처리 중단/반환 |  |  |  |

## SCP0125_Workbench.GetSearchInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-010e6128 | (진입점 미연결) | SCP0125_Workbench.cs:241 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0125_GET_SEARCH_INFO") ⇒ SCP.SCP0125_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-920ba45f | (진입점 미연결) | SCP0125_Workbench.cs:243 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2367c867 | (진입점 미연결) | SCP0125_Workbench.cs:246 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a2a8a60a | (진입점 미연결) | SCP0125_Workbench.cs:250 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0125_Workbench.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bd06e5e | this.Load | SCP0125_Workbench.cs:188 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-804aeda1 | this.Load | SCP0125_Workbench.cs:191 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-a92a3a16 | this.Load | SCP0125_Workbench.cs:193 |  | FLAG | dtVersionNoAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4ec699b0 | this.Load | SCP0125_Workbench.cs:194 |  | FLAG | dtSalesSiteAll | dsSearchInfo.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-9b43dfc0 | this.Load | SCP0125_Workbench.cs:195 |  | FLAG | dtPlantSiteAll | dsSearchInfo.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-2ff0323d | this.Load | SCP0125_Workbench.cs:196 |  | FLAG | dtScmSiteAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-847dc765 | this.Load | SCP0125_Workbench.cs:197 |  | FLAG | dtItemAll | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-5692529a | this.Load | SCP0125_Workbench.cs:198 |  | FLAG | dtProjectCodeAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-330a9c7c | this.Load | SCP0125_Workbench.cs:199 |  | FLAG | dtProjectCodeAll_40 | dsSearchInfo.Tables[6] | 화면 필드/플래그 변경 |  |  |  |
| AC-905975d8 | this.Load | SCP0125_Workbench.cs:200 |  | FLAG | dtLocation | dsSearchInfo.Tables[7] | 화면 필드/플래그 변경 |  |  |  |
| AC-158a8efb | this.Load | SCP0125_Workbench.cs:201 |  | FLAG | dtLineAll | dsSearchInfo.Tables[8] | 화면 필드/플래그 변경 |  |  |  |
| AC-8b215589 | this.Load | SCP0125_Workbench.cs:203 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-099ee860 | this.Load | SCP0125_Workbench.cs:206 |  | FLAG | dtPlantIDAll | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-bdf22ab2 | this.Load | SCP0125_Workbench.cs:207 |  | DATA_OP | dtPlantIDAll.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34808eec | this.Load | SCP0125_Workbench.cs:208 |  | DATA_OP | dtPlantIDAll.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c72016ca | this.Load | SCP0125_Workbench.cs:209 |  | DATA_OP | dtPlantIDAll.Columns.Add | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b7e7765 | this.Load | SCP0125_Workbench.cs:213 | for (i < dtPlantSiteAll.Rows.Count) | DATA_OP | dtPlantIDAll.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b54c52ec | this.Load | SCP0125_Workbench.cs:214 | for (i < dtPlantSiteAll.Rows.Count) | DATA_OP | dr["CODE"] | dtPlantSiteAll.Rows[i]["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-32dbffe4 | this.Load | SCP0125_Workbench.cs:215 | for (i < dtPlantSiteAll.Rows.Count) | DATA_OP | dr["NAME"] | dtPlantSiteAll.Rows[i]["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-33a1802d | this.Load | SCP0125_Workbench.cs:216 | for (i < dtPlantSiteAll.Rows.Count) | DATA_OP | dr["DIVISION_ID"] | dtPlantSiteAll.Rows[i]["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-58fafde3 | this.Load | SCP0125_Workbench.cs:218 | for (i < dtPlantSiteAll.Rows.Count) | DATA_OP | dtPlantIDAll.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2e57d26 | this.Load | SCP0125_Workbench.cs:223 |  | FLAG | _sActiveSheetName | SpdSheet.shtMktFcst | 화면 필드/플래그 변경 |  |  |  |

## SCP0125_Workbench.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a71b9109 | this.Load | SCP0125_Workbench.cs:345 | if (spreadInfo.SheetName == SpdSheet.shtMktFcst) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-880b0bcd | this.Load | SCP0125_Workbench.cs:348 | if (spreadInfo.SheetName == SpdSheet.shtMktFcst) | LIST_REBIND | SpreadInfo.SetComBoParam | ("SalesSite", dtSalesSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-e6874a09 | this.Load | SCP0125_Workbench.cs:349 | if (spreadInfo.SheetName == SpdSheet.shtMktFcst) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSite", dtPlantSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-e810abd6 | this.Load | SCP0125_Workbench.cs:350 | if (spreadInfo.SheetName == SpdSheet.shtMktFcst) | LIST_REBIND | SpreadInfo.SetComBoParam | ("FcstType", dtFcstType) | 목록 컨트롤 재구성 |  |  |  |
| AC-dd12a8a5 | this.Load | SCP0125_Workbench.cs:351 | if (spreadInfo.SheetName == SpdSheet.shtMktFcst) | LIST_REBIND | SpreadInfo.SetComBoParam | ("Incoterms", dtIncoterms) | 목록 컨트롤 재구성 |  |  |  |
| AC-92e0bf99 | this.Load | SCP0125_Workbench.cs:352 | if (spreadInfo.SheetName == SpdSheet.shtMktFcst) | LIST_REBIND | SpreadInfo.SetComBoParam | ("EndCustomer", dtProjectCodeAll_40) | 목록 컨트롤 재구성 |  |  |  |
| AC-ac1d00ba | this.Load | SCP0125_Workbench.cs:355 | if (spreadInfo.SheetName == SpdSheet.shtMktFcst) | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-89999c5e | this.Load | SCP0125_Workbench.cs:356 | if (spreadInfo.SheetName == SpdSheet.shtMktFcst) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-685a45a7 | this.Load | SCP0125_Workbench.cs:360 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f32ab69f | this.Load | SCP0125_Workbench.cs:362 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | DATA_OP | dtIncoterms.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-84aadbf0 | this.Load | SCP0125_Workbench.cs:363 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | DATA_OP | drLine["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-59e1dcd1 | this.Load | SCP0125_Workbench.cs:364 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | DATA_OP | drLine["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-690b146d | this.Load | SCP0125_Workbench.cs:365 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | CALL_EXT | dtIncoterms.Rows.InsertAt | (drLine, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94686a2e | this.Load | SCP0125_Workbench.cs:366 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | DATA_OP | dtIncoterms.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ed15b7c2 | this.Load | SCP0125_Workbench.cs:369 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | LIST_REBIND | SpreadInfo.SetComBoParam | ("StockType", dtStockType) | 목록 컨트롤 재구성 |  |  |  |
| AC-cbaf0a9e | this.Load | SCP0125_Workbench.cs:371 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | LIST_REBIND | SpreadInfo.SetComBoParam | ("ScmSite", dtScmSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-f0c5fade | this.Load | SCP0125_Workbench.cs:372 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | LIST_REBIND | SpreadInfo.SetComBoParam | ("Incoterms", dtIncoterms) | 목록 컨트롤 재구성 |  |  |  |
| AC-36af1176 | this.Load | SCP0125_Workbench.cs:375 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-f97c0b50 | this.Load | SCP0125_Workbench.cs:376 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ if (spreadInfo.SheetName == SpdSheet.shtStock) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-aa4bd3f8 | this.Load | SCP0125_Workbench.cs:381 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStock) ▸ if (spreadInfo.SheetName == Sp… | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-483ec5cf | this.Load | SCP0125_Workbench.cs:383 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStock) ▸ if (spreadInfo.SheetName == Sp… | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-3a018404 | this.Load | SCP0125_Workbench.cs:384 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStock) ▸ if (spreadInfo.SheetName == Sp… | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a1ed4d3a | this.Load | SCP0125_Workbench.cs:388 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStock) ▸ else of (spreadInfo.SheetName … | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8c090680 | this.Load | SCP0125_Workbench.cs:390 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStock) ▸ else of (spreadInfo.SheetName … | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a0149e94 | this.Load | SCP0125_Workbench.cs:391 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStock) ▸ else of (spreadInfo.SheetName … | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9a763432 | this.Load | SCP0125_Workbench.cs:397 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStock) ▸ else of (spreadInfo.SheetName … | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e36bdb81 | this.Load | SCP0125_Workbench.cs:399 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStock) ▸ else of (spreadInfo.SheetName … | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-811374e8 | this.Load | SCP0125_Workbench.cs:400 | else of (spreadInfo.SheetName == SpdSheet.shtMktFcst) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStock) ▸ else of (spreadInfo.SheetName … | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a3c4754f | this.Load | SCP0125_Workbench.cs:409 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf8c6c53 | this.Load | SCP0125_Workbench.cs:410 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMktFcst) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d0988ac4 | this.Load | SCP0125_Workbench.cs:411 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0125_Workbench.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-186cd025 | InsertButton | SCP0125_Workbench.cs:723 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c1cca61f | InsertButton | SCP0125_Workbench.cs:732 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | DATA_OP | DBUtils.Filter | (dtVersionNo, "DIVISION_ID = '" + division_id + "' AND CODE = '" + versionNo + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-993b2a30 | InsertButton | SCP0125_Workbench.cs:736 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (division_id != "40") | DATA_OP | defaultData.Add | (DefColumns.CELL_PROD_SITE_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-f239ab47 | InsertButton | SCP0125_Workbench.cs:738 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (division_id != "40") | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8a42b912 | InsertButton | SCP0125_Workbench.cs:741 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-81a66995 | InsertButton | SCP0125_Workbench.cs:742 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | DATA_OP | defaultData.Add | (DefColumns.VERSION_NO, versionNo) | 데이터 객체 조작/조회 |  |  |  |
| AC-8877376f | InsertButton | SCP0125_Workbench.cs:743 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | DATA_OP | defaultData.Add | (DefColumns.CUTOFF_YYYYMMDD, cutoff_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc22aed6 | InsertButton | SCP0125_Workbench.cs:744 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | DATA_OP | defaultData.Add | (DefColumns.CHG_TYPE, "New") | 데이터 객체 조작/조회 |  |  |  |
| AC-375200d1 | InsertButton | SCP0125_Workbench.cs:746 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-854309ab | InsertButton | SCP0125_Workbench.cs:748 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d5e4eff | InsertButton | SCP0125_Workbench.cs:749 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-77ee5e9f | InsertButton | SCP0125_Workbench.cs:750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.FCST_TYPE), siMain.GetColumnIndex(DefColumns.FC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a55a228 | InsertButton | SCP0125_Workbench.cs:751 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.QTY), siMain.GetColumnIndex(DefColumns.QTY), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b721fe5 | InsertButton | SCP0125_Workbench.cs:752 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CHG_TYPE), siMain.GetColumnIndex(DefColumns.LAS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-baba94a7 | InsertButton | SCP0125_Workbench.cs:760 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + division_id + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6ba0d39a | InsertButton | SCP0125_Workbench.cs:774 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b23cc5d | InsertButton | SCP0125_Workbench.cs:775 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | DATA_OP | defaultData.Add | (DefColumns.CUTOFF_YYYYMMDD, cutoff_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-34e4f375 | InsertButton | SCP0125_Workbench.cs:776 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | DATA_OP | defaultData.Add | (DefColumns.CHG_TYPE, "New") | 데이터 객체 조작/조회 |  |  |  |
| AC-a9b19501 | InsertButton | SCP0125_Workbench.cs:778 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-024e824e | InsertButton | SCP0125_Workbench.cs:780 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac040daa | InsertButton | SCP0125_Workbench.cs:781 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.STOCK_TYPE), siMain.GetColumnIndex(DefColumns.S… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a9474ca | InsertButton | SCP0125_Workbench.cs:782 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ceb8d3d7 | InsertButton | SCP0125_Workbench.cs:783 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.QTY), siMain.GetColumnIndex(DefColumns.QTY), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8a10e98d | InsertButton | SCP0125_Workbench.cs:784 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CHG_TYPE), siMain.GetColumnIndex(DefColumns.LAS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ea3a2fe2 | InsertButton | SCP0125_Workbench.cs:790 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-35c1321e | InsertButton | SCP0125_Workbench.cs:791 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | defaultData.Add | (DefColumns.PLAN_START_YYYYMMDD, plan_start_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d072cf7 | InsertButton | SCP0125_Workbench.cs:792 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | defaultData.Add | (DefColumns.PLAN_TYPE, "FN") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc874f53 | InsertButton | SCP0125_Workbench.cs:793 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | defaultData.Add | (DefColumns.CHG_TYPE, "New") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b705ae3 | InsertButton | SCP0125_Workbench.cs:795 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-672a09df | InsertButton | SCP0125_Workbench.cs:797 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b31b366d | InsertButton | SCP0125_Workbench.cs:798 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_ID), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-173eea88 | InsertButton | SCP0125_Workbench.cs:799 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.QTY), siMain.GetColumnIndex(DefColumns.QTY), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-22a63c6f | InsertButton | SCP0125_Workbench.cs:800 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CHG_TYPE), siMain.GetColumnIndex(DefColumns.LAS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4be77544 | InsertButton | SCP0125_Workbench.cs:808 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + division_id + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f12cc882 | InsertButton | SCP0125_Workbench.cs:822 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-7270388d | InsertButton | SCP0125_Workbench.cs:823 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | defaultData.Add | (DefColumns.CUTOFF_YYYYMMDD, cutoff_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-5466b4e1 | InsertButton | SCP0125_Workbench.cs:824 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | defaultData.Add | (DefColumns.CHG_TYPE, "New") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ee82143 | InsertButton | SCP0125_Workbench.cs:826 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-22eeb9f3 | InsertButton | SCP0125_Workbench.cs:828 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ccf57b76 | InsertButton | SCP0125_Workbench.cs:829 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-20b2963b | InsertButton | SCP0125_Workbench.cs:830 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_NAME), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b286fdf | InsertButton | SCP0125_Workbench.cs:831 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.QTY), siMain.GetColumnIndex(DefColumns.QTY), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fe6dbbda | InsertButton | SCP0125_Workbench.cs:832 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CHG_TYPE), siMain.GetColumnIndex(DefColumns.LAS… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0125_Workbench.RefreshPlanDate

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d7b7cde | this.Load 외 1 | SCP0125_Workbench.cs:261 |  | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-aa9a019c | this.Load 외 1 | SCP0125_Workbench.cs:265 | if ((_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) && dtGM.Rows.Count > 0) | UI_PROP | lciPlanDate_Days.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b5e5697a | this.Load 외 1 | SCP0125_Workbench.cs:266 | if ((_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) && dtGM.Rows.Count > 0) | UI_PROP | lciPlanDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d3799904 | this.Load 외 1 | SCP0125_Workbench.cs:268 | if ((_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) && dtGM.Rows.Count > 0) | VALUE_SET | dpPlanDate_Days.Text | DateTime.Now.ToShortDateString() | 컨트롤 값 설정 |  |  |  |
| AC-01becb78 | this.Load 외 1 | SCP0125_Workbench.cs:268 | if ((_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) && dtGM.Rows.Count > 0) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3456890 | this.Load 외 1 | SCP0125_Workbench.cs:272 | else of ((_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) && dtGM.Rows.Count > 0) | UI_PROP | lciPlanDate_Days.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-632ce568 | this.Load 외 1 | SCP0125_Workbench.cs:273 | else of ((_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) && dtGM.Rows.Count > 0) | UI_PROP | lciPlanDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-55f620ad | this.Load 외 1 | SCP0125_Workbench.cs:275 | else of ((_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) && dtGM.Rows.Count > 0) | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-b3092367 | this.Load 외 1 | SCP0125_Workbench.cs:275 | else of ((_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) && dtGM.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-000c9720 | this.Load 외 1 | SCP0125_Workbench.cs:276 | else of ((_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) && dtGM.Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0125_Workbench.RefreshSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ea60e04 | this.Load 외 1 | SCP0125_Workbench.cs:295 |  | FLAG | dtSalesSite | DBUtils.Filter(dtSalesSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-64f32085 | this.Load 외 1 | SCP0125_Workbench.cs:295 |  | DATA_OP | DBUtils.Filter | (dtSalesSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a94cac8a | this.Load 외 1 | SCP0125_Workbench.cs:296 |  | FLAG | dtPlantSite | DBUtils.Filter(dtPlantSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-30921b1f | this.Load 외 1 | SCP0125_Workbench.cs:296 |  | DATA_OP | DBUtils.Filter | (dtPlantSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4c915fb7 | this.Load 외 1 | SCP0125_Workbench.cs:297 |  | FLAG | dtScmSite | DBUtils.Filter(dtScmSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-3343d58a | this.Load 외 1 | SCP0125_Workbench.cs:297 |  | DATA_OP | DBUtils.Filter | (dtScmSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fb8045ab | this.Load 외 1 | SCP0125_Workbench.cs:298 |  | FLAG | dtLine | DBUtils.Filter(dtLineAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-90319e30 | this.Load 외 1 | SCP0125_Workbench.cs:298 |  | DATA_OP | DBUtils.Filter | (dtLineAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-68d115bd | this.Load 외 1 | SCP0125_Workbench.cs:299 |  | FLAG | dtPlantID | DBUtils.Filter(dtPlantIDAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-c3c1b38d | this.Load 외 1 | SCP0125_Workbench.cs:299 |  | DATA_OP | DBUtils.Filter | (dtPlantIDAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0125_Workbench.RefreshVersionNo

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-feda831f | this.Load 외 2 | SCP0125_Workbench.cs:286 |  | CALL_EXT | dtEnd_yyyymmdd.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c770f308 | this.Load 외 2 | SCP0125_Workbench.cs:288 |  | FLAG | dtVersionNo | DBUtils.Filter(dtVersionNoAll, "DIVISION_ID = '" + division + "' AND YYYYMMDD >= '" + p_pl… | 화면 필드/플래그 변경 |  |  |  |
| AC-8e34ea5b | this.Load 외 2 | SCP0125_Workbench.cs:288 |  | DATA_OP | DBUtils.Filter | (dtVersionNoAll, "DIVISION_ID = '" + division + "' AND YYYYMMDD >= '" + p_plan_start_yyyym… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-394b0be8 | this.Load 외 2 | SCP0125_Workbench.cs:289 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionNo, cboVersion, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0125_Workbench.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-395c0afd | SaveButton | SCP0125_Workbench.cs:840 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7720e9a7 | SaveButton | SCP0125_Workbench.cs:842 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a37394b | SaveButton | SCP0125_Workbench.cs:928 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df57c9ec | SaveButton | SCP0125_Workbench.cs:929 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d178f06 | SaveButton | SCP0125_Workbench.cs:938 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f1414ad0 | SaveButton | SCP0125_Workbench.cs:939 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9826c508 | SaveButton | SCP0125_Workbench.cs:969 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | DATA_OP | DBUtils.Filter | (dtMktFcstAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-44f189c0 | SaveButton | SCP0125_Workbench.cs:973 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7603a226 | SaveButton | SCP0125_Workbench.cs:974 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3710c84 | SaveButton | SCP0125_Workbench.cs:990 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Due Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c63995a4 | SaveButton | SCP0125_Workbench.cs:991 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66a6d073 | SaveButton | SCP0125_Workbench.cs:997 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | MESSAGE | MessageHelper.GMessageBox | ("MSG00463", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cda48032 | SaveButton | SCP0125_Workbench.cs:998 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af206524 | SaveButton | SCP0125_Workbench.cs:1005 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | DATA_OP | DBUtils.Filter | (dtProjectCodeAll, "DIVISION_ID = '" + division_id + "' AND PROJECT_CODE = '" + project_co… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-739d1643 | SaveButton | SCP0125_Workbench.cs:1009 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | MESSAGE | MessageHelper.GMessageBox | ("MSG00457", new object[] { project_code }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be747b47 | SaveButton | SCP0125_Workbench.cs:1010 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9537e1c | SaveButton | SCP0125_Workbench.cs:1017 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | DATA_OP | DBUtils.Filter | (dtProjectCodeAll_40, "CODE = '" + project_code_40 + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-32b759eb | SaveButton | SCP0125_Workbench.cs:1021 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | MESSAGE | MessageHelper.GMessageBox | ("MSG00457", new object[] { project_code_40 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d6ca701 | SaveButton | SCP0125_Workbench.cs:1022 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5534ef86 | SaveButton | SCP0125_Workbench.cs:1030 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | DATA_OP | DBUtils.Filter | (dtItemAll, "DIVISION_ID = '" + division_id + "' AND ITEM_ID = '" + item_id + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-defbb71b | SaveButton | SCP0125_Workbench.cs:1034 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | MESSAGE | MessageHelper.GMessageBox | ("MSG00458", new object[] { item_id }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-74e0a28e | SaveButton | SCP0125_Workbench.cs:1035 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9fe0d11 | SaveButton | SCP0125_Workbench.cs:1045 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-4bf3a690 | SaveButton | SCP0125_Workbench.cs:1045 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53840619 | SaveButton | SCP0125_Workbench.cs:1062 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { chg_qty }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9712e1e9 | SaveButton | SCP0125_Workbench.cs:1063 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSett… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-06e2562f | SaveButton | SCP0125_Workbench.cs:1095 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2e03a0fc | SaveButton | SCP0125_Workbench.cs:1096 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c23cfe2b | SaveButton | SCP0125_Workbench.cs:1100 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0125_SAVE_MKT_FCST_ADJ") ⇒ SCP.SCP0125_SAVE_MKT_FCST_ADJ | 엔드포인트 요청 생성 |  |  |  |
| AC-fbee8792 | SaveButton | SCP0125_Workbench.cs:1103 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fbe90de3 | SaveButton | SCP0125_Workbench.cs:1107 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-67969303 | SaveButton | SCP0125_Workbench.cs:1109 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-89d240ab | SaveButton | SCP0125_Workbench.cs:1110 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-07e1d1f5 | SaveButton | SCP0125_Workbench.cs:1111 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_version_no"] | p_version_no | 행/컬럼 값 대입 |  |  |  |
| AC-927927b9 | SaveButton | SCP0125_Workbench.cs:1112 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_cutoff_yyyymmdd"] | p_cutoff_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ef10286d | SaveButton | SCP0125_Workbench.cs:1113 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-c0ab3199 | SaveButton | SCP0125_Workbench.cs:1114 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_sales_site_id"] | p_sales_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb338831 | SaveButton | SCP0125_Workbench.cs:1115 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-39f307cc | SaveButton | SCP0125_Workbench.cs:1116 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-c9d7f3f1 | SaveButton | SCP0125_Workbench.cs:1117 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-ada6219f | SaveButton | SCP0125_Workbench.cs:1118 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-45670679 | SaveButton | SCP0125_Workbench.cs:1119 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_cell_prod_site_id"] | p_cell_prod_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-8f502b0c | SaveButton | SCP0125_Workbench.cs:1120 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_due_date"] | p_due_date | 행/컬럼 값 대입 |  |  |  |
| AC-4dc343cc | SaveButton | SCP0125_Workbench.cs:1121 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-861d23b0 | SaveButton | SCP0125_Workbench.cs:1122 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_chg_qty"] | p_chg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-56b12711 | SaveButton | SCP0125_Workbench.cs:1123 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_chg_rsn"] | p_chg_rsn | 행/컬럼 값 대입 |  |  |  |
| AC-7d730140 | SaveButton | SCP0125_Workbench.cs:1124 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_chg_type"] | p_chg_type | 행/컬럼 값 대입 |  |  |  |
| AC-9757bddc | SaveButton | SCP0125_Workbench.cs:1125 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4ea957ce | SaveButton | SCP0125_Workbench.cs:1127 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-83497a8f | SaveButton | SCP0125_Workbench.cs:1127 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-819c2b0c | SaveButton | SCP0125_Workbench.cs:1131 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9bd29913 | SaveButton | SCP0125_Workbench.cs:1138 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString()… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82fad21c | SaveButton | SCP0125_Workbench.cs:1147 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToStr… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6a7014da | SaveButton | SCP0125_Workbench.cs:1153 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-10bd77b4 | SaveButton | SCP0125_Workbench.cs:1154 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc20db60 | SaveButton | SCP0125_Workbench.cs:1158 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c2a35650 | SaveButton | SCP0125_Workbench.cs:1271 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4009ece | SaveButton | SCP0125_Workbench.cs:1272 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b740aa1 | SaveButton | SCP0125_Workbench.cs:1301 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | DBUtils.Filter | (dtStockAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-60a02cd9 | SaveButton | SCP0125_Workbench.cs:1305 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e880339 | SaveButton | SCP0125_Workbench.cs:1306 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48baa11d | SaveButton | SCP0125_Workbench.cs:1323 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5441ca40 | SaveButton | SCP0125_Workbench.cs:1324 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7a5ebb6 | SaveButton | SCP0125_Workbench.cs:1330 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00463", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-71e8884f | SaveButton | SCP0125_Workbench.cs:1331 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b826a55 | SaveButton | SCP0125_Workbench.cs:1344 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fa8f7d4 | SaveButton | SCP0125_Workbench.cs:1345 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6fab0ad4 | SaveButton | SCP0125_Workbench.cs:1362 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { chg_qty }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c20ce4a | SaveButton | SCP0125_Workbench.cs:1363 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2de0f45b | SaveButton | SCP0125_Workbench.cs:1395 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3020da7f | SaveButton | SCP0125_Workbench.cs:1396 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dc484b0f | SaveButton | SCP0125_Workbench.cs:1400 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | ENDPOINT | new FoxDataRequest | ("SCP.SCP0125_SAVE_STOCK_ADJ") ⇒ SCP.SCP0125_SAVE_STOCK_ADJ | 엔드포인트 요청 생성 |  |  |  |
| AC-1efb6f56 | SaveButton | SCP0125_Workbench.cs:1403 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-33a38811 | SaveButton | SCP0125_Workbench.cs:1407 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-211a8409 | SaveButton | SCP0125_Workbench.cs:1409 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_active_flag"] | p_stock_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-969e9670 | SaveButton | SCP0125_Workbench.cs:1410 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_division_id"] | p_stock_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-190ed702 | SaveButton | SCP0125_Workbench.cs:1411 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_stock_type"] | p_stock_type | 행/컬럼 값 대입 |  |  |  |
| AC-8d49ecef | SaveButton | SCP0125_Workbench.cs:1412 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_cutoff_yyyymmdd"] | p_stock_cutoff_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e587b997 | SaveButton | SCP0125_Workbench.cs:1413 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_project_code"] | p_stock_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-c7c10a50 | SaveButton | SCP0125_Workbench.cs:1414 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_item_id"] | p_stock_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-05388b55 | SaveButton | SCP0125_Workbench.cs:1415 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_incoterms"] | p_stock_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-66c7d0f4 | SaveButton | SCP0125_Workbench.cs:1416 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_from_site_id"] | p_from_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a842d4d0 | SaveButton | SCP0125_Workbench.cs:1417 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b01469d5 | SaveButton | SCP0125_Workbench.cs:1418 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_location_code"] | p_location_code | 행/컬럼 값 대입 |  |  |  |
| AC-f4cbcba9 | SaveButton | SCP0125_Workbench.cs:1419 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-673a231a | SaveButton | SCP0125_Workbench.cs:1420 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_before_degas"] | p_before_degas | 행/컬럼 값 대입 |  |  |  |
| AC-ac7f5986 | SaveButton | SCP0125_Workbench.cs:1421 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_inv_date"] | p_inv_date | 행/컬럼 값 대입 |  |  |  |
| AC-e3894bb3 | SaveButton | SCP0125_Workbench.cs:1422 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_qty"] | p_stock_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e8ab1b71 | SaveButton | SCP0125_Workbench.cs:1423 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_chg_qty"] | p_stock_chg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-8185f3cd | SaveButton | SCP0125_Workbench.cs:1424 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_chg_rsn"] | p_stock_chg_rsn | 행/컬럼 값 대입 |  |  |  |
| AC-ec61ec81 | SaveButton | SCP0125_Workbench.cs:1425 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_chg_type"] | p_stock_chg_type | 행/컬럼 값 대입 |  |  |  |
| AC-a75a3473 | SaveButton | SCP0125_Workbench.cs:1426 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | DATA_OP | req.Parameters["p_user_id"] | p_stock_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-60b9eb03 | SaveButton | SCP0125_Workbench.cs:1428 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9a61eb2f | SaveButton | SCP0125_Workbench.cs:1428 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-54c2c16c | SaveButton | SCP0125_Workbench.cs:1432 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-becb4ce4 | SaveButton | SCP0125_Workbench.cs:1439 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9094ec98 | SaveButton | SCP0125_Workbench.cs:1448 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dfefb02d | SaveButton | SCP0125_Workbench.cs:1454 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4abc4d15 | SaveButton | SCP0125_Workbench.cs:1455 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8e125c5 | SaveButton | SCP0125_Workbench.cs:1459 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockE… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b54f9714 | SaveButton | SCP0125_Workbench.cs:1537 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dff0d576 | SaveButton | SCP0125_Workbench.cs:1538 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14d83733 | SaveButton | SCP0125_Workbench.cs:1556 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | DBUtils.Filter | (dtElecDemandAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a90b7cb7 | SaveButton | SCP0125_Workbench.cs:1560 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d41a564 | SaveButton | SCP0125_Workbench.cs:1561 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47dd1a08 | SaveButton | SCP0125_Workbench.cs:1577 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bf5ac1ef | SaveButton | SCP0125_Workbench.cs:1578 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb87b4af | SaveButton | SCP0125_Workbench.cs:1584 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00463", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c6c41d4 | SaveButton | SCP0125_Workbench.cs:1585 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1183af96 | SaveButton | SCP0125_Workbench.cs:1589 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | DBUtils.Filter | (dtItemAll, "DIVISION_ID = '" + division_id + "' AND ITEM_ID = '" + item_id + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3456d55f | SaveButton | SCP0125_Workbench.cs:1593 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00458", new object[] { item_id }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e706d0d | SaveButton | SCP0125_Workbench.cs:1594 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11b32f6f | SaveButton | SCP0125_Workbench.cs:1606 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1b28237 | SaveButton | SCP0125_Workbench.cs:1607 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13427aa8 | SaveButton | SCP0125_Workbench.cs:1625 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { chg_qty }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-49da8ebf | SaveButton | SCP0125_Workbench.cs:1626 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4916c25 | SaveButton | SCP0125_Workbench.cs:1656 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9dc0ec8a | SaveButton | SCP0125_Workbench.cs:1657 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-62b60cdd | SaveButton | SCP0125_Workbench.cs:1661 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | ENDPOINT | new FoxDataRequest | ("SCP.SCP0125_SAVE_MKT_FCST_ELEC_DEMAND") ⇒ SCP.SCP0125_SAVE_MKT_FCST_ELEC_DEMAND | 엔드포인트 요청 생성 |  |  |  |
| AC-34811ff0 | SaveButton | SCP0125_Workbench.cs:1664 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-268c0847 | SaveButton | SCP0125_Workbench.cs:1668 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1393648a | SaveButton | SCP0125_Workbench.cs:1670 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_active_flag"] | p_elec_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f3cdd5e1 | SaveButton | SCP0125_Workbench.cs:1671 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_division_id"] | p_elec_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc81d2c5 | SaveButton | SCP0125_Workbench.cs:1672 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-04a79f6f | SaveButton | SCP0125_Workbench.cs:1673 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-37bd8056 | SaveButton | SCP0125_Workbench.cs:1674 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-66523998 | SaveButton | SCP0125_Workbench.cs:1675 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_plant_site_id"] | p_elec_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-596063f3 | SaveButton | SCP0125_Workbench.cs:1676 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_line_id"] | p_elec_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-7352b433 | SaveButton | SCP0125_Workbench.cs:1677 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-12bba3b6 | SaveButton | SCP0125_Workbench.cs:1678 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_item_id"] | p_elec_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7429d652 | SaveButton | SCP0125_Workbench.cs:1679 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-56fd8df1 | SaveButton | SCP0125_Workbench.cs:1680 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_qty"] | p_elec_qty | 행/컬럼 값 대입 |  |  |  |
| AC-02f823bf | SaveButton | SCP0125_Workbench.cs:1681 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_chg_qty"] | p_elec_chg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-c260d927 | SaveButton | SCP0125_Workbench.cs:1682 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_chg_rsn"] | p_elec_chg_rsn | 행/컬럼 값 대입 |  |  |  |
| AC-3bd196e3 | SaveButton | SCP0125_Workbench.cs:1683 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_chg_type"] | p_elec_chg_type | 행/컬럼 값 대입 |  |  |  |
| AC-0ab61da9 | SaveButton | SCP0125_Workbench.cs:1684 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | DATA_OP | req.Parameters["p_user_id"] | p_elec_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-3bcd0b8e | SaveButton | SCP0125_Workbench.cs:1686 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef39be84 | SaveButton | SCP0125_Workbench.cs:1686 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-9154b715 | SaveButton | SCP0125_Workbench.cs:1690 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-046f1639 | SaveButton | SCP0125_Workbench.cs:1697 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-325de4cf | SaveButton | SCP0125_Workbench.cs:1706 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56d3b924 | SaveButton | SCP0125_Workbench.cs:1712 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cb9a2f74 | SaveButton | SCP0125_Workbench.cs:1713 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8713b6e0 | SaveButton | SCP0125_Workbench.cs:1717 | else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtS… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0125_Workbench.Save_SecondOcv

진입점: SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) ▸ else of (_sActiveSheetName == SpdSheet.shtElecDemand) ▸ if (_sActiveSheetName == SpdSheet.shtStockSecondOcv)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c04dad2e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1801 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (action == CAppSetting.FlagI) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f52b128 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1802 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (action == CAppSetting.FlagI) ▸ … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97627607 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1828 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (action == CAppSetting.FlagI) ▸ … | DATA_OP | DBUtils.Filter | (dtStockSecondOcvAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-735a765b | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1832 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (action == CAppSetting.FlagI) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2c1b404a | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1833 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (action == CAppSetting.FlagI) ▸ … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-857bb522 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1851 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (action == CAppSetting.FlagI) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-029a9b46 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1852 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (action == CAppSetting.FlagI) ▸ … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ed69446 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1866 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (action == CAppSetting.Flag… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-983876a5 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1867 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ else of (action == CAppSetting.Flag… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64dedaeb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1887 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dChg_qty < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { chg_qty }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-45840a7f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1888 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (dChg_qty < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e1fa294 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1918 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3c5818d3 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1919 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c83242d1 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1923 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0125_SAVE_STOCK_SECOND_OCV") ⇒ SCP.SCP0125_SAVE_STOCK_SECOND_OCV | 엔드포인트 요청 생성 |  |  |  |
| AC-4fd86162 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1926 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-149ce0e2 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1930 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-584807af | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1932 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_stock_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-41636e4e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1933 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_stock_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-151fe74c | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1934 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_stock_type"] | p_stock_type | 행/컬럼 값 대입 |  |  |  |
| AC-d80032fb | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1935 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_cutoff_yyyymmdd"] | p_stock_cutoff_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6665a072 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1936 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_stock_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-9e024977 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1937 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-441a36e0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1938 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-441f2678 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1939 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_second_ocv_time"] | p_second_ocv_time | 행/컬럼 값 대입 |  |  |  |
| AC-510bad40 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1940 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_second_ocv_date"] | p_second_ocv_date | 행/컬럼 값 대입 |  |  |  |
| AC-3e265d9e | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1941 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_qty"] | p_stock_qty | 행/컬럼 값 대입 |  |  |  |
| AC-d5c6955d | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1942 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_chg_qty"] | p_stock_chg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-a37cf340 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1943 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_chg_rsn"] | p_stock_chg_rsn | 행/컬럼 값 대입 |  |  |  |
| AC-6a5f7695 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1944 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_chg_type"] | p_stock_chg_type | 행/컬럼 값 대입 |  |  |  |
| AC-694aa6b1 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1945 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_stock_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4be1ee5f | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1947 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e7c78f0 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1947 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-26e32098 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1951 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-193a4764 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1958 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12b033bf | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1967 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be0a7fa3 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1973 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f78ea296 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1974 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b7ee782 | SaveButton [else of (_sActiveSheetName == SpdSheet.shtMktFcs… | SCP0125_Workbench.cs:1978 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0125_Workbench.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-749a181e | SaveButton | SCP0125_Workbench.cs:525 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0125_Workbench.SetSpreadInit

진입점: this.Load / FindButton [try ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst)] / SaveButton [if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3427387f | this.Load 외 2 | SCP0125_Workbench.cs:418 | if (sheetName.Equals(SpdSheet.shtMktFcst)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc1a0f03 | this.Load 외 2 | SCP0125_Workbench.cs:419 | if (sheetName.Equals(SpdSheet.shtMktFcst)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-aa62b980 | this.Load 외 2 | SCP0125_Workbench.cs:422 |  | GRID_INIT | siObj.SetSheetHeaderColumnSCP | (siObj, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

## SCP0125_Workbench.SetVisibleSheetColumns

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged / FindButton [try] / SaveButton [if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e7a5ef2 | this.Load 외 4 | SCP0125_Workbench.cs:447 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (division == "40") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.PROJECT_CODE, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df3a3021 | this.Load 외 4 | SCP0125_Workbench.cs:448 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (division == "40") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.PROJECT_CODE_40, 100, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-656e3adc | this.Load 외 4 | SCP0125_Workbench.cs:452 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (division == "40") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.PROJECT_CODE, 100, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3428fac4 | this.Load 외 4 | SCP0125_Workbench.cs:453 | if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (division == "40") | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.PROJECT_CODE_40, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fc8ed09 | this.Load 외 4 | SCP0125_Workbench.cs:461 | if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) ▸ if (_sActiveSheetName == SpdSheet.shtStock && … | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.LINE_ID, 100, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b83e48d9 | this.Load 외 4 | SCP0125_Workbench.cs:462 | if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) ▸ if (_sActiveSheetName == SpdSheet.shtStock && … | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.BEFORE_DEGAS, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b901e82 | this.Load 외 4 | SCP0125_Workbench.cs:467 | if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) ▸ else of (_sActiveSheetName == SpdSheet.shtStoc… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.LINE_ID, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1a2a343 | this.Load 외 4 | SCP0125_Workbench.cs:468 | if (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) ▸ else of (_sActiveSheetName == SpdSheet.shtStoc… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.BEFORE_DEGAS, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-96fad170 | this.Load 외 4 | SCP0125_Workbench.cs:473 | else of (_sActiveSheetName == SpdSheet.shtStock \|\| _sActiveSheetName == SpdSheet.shtStockElec) ▸ if (_sActiveSheetName == SpdSheet.shtElec… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.LINE_ID, 100, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-542abf66 | this.Load 외 4 | SCP0125_Workbench.cs:477 |  | CALL_EXT | SheetUtils.SetColumHide | (siMain) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0125_Workbench.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca5ccab0 | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2010 | if (sender != null) | FLAG | _sActiveSheetName | ((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b76c2668 | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2017 | if (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcs… | UI_PROP | this.lciVersion.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-94079d7a | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2021 | if (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) ▸ else of (_sActiveSheetName == SpdSheet.shtM… | UI_PROP | this.lciVersion.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e757e10f | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2024 | if (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) | UI_PROP | this.lciPlanDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7152b244 | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2025 | if (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) | UI_PROP | this.lciPlanDate_Days.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a57b3933 | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2029 | else of (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) | UI_PROP | this.lciVersion.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-52511fd8 | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2032 | else of (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d881156e | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2036 | else of (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) ▸ if (dtGM.Rows.Count > 0) | UI_PROP | this.lciPlanDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-046fcc5f | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2037 | else of (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) ▸ if (dtGM.Rows.Count > 0) | UI_PROP | this.lciPlanDate_Days.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5e74acbb | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2039 | else of (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) ▸ if (dtGM.Rows.Count > 0) | VALUE_SET | dpPlanDate_Days.Text | DateTime.Now.ToShortDateString() | 컨트롤 값 설정 |  |  |  |
| AC-10e2ec22 | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2039 | else of (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) ▸ if (dtGM.Rows.Count > 0) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e47347f8 | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2043 | else of (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) ▸ else of (dtGM.Rows.Count > 0) | UI_PROP | this.lciPlanDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-350dcf1a | this.spdMain.ActiveSheetChanged | SCP0125_Workbench.cs:2044 | else of (_sActiveSheetName == SpdSheet.shtMktFcst \|\| _sActiveSheetName == SpdSheet.shtElecDemand) ▸ else of (dtGM.Rows.Count > 0) | UI_PROP | this.lciPlanDate_Days.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0125_Workbench.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-636e2d44 | this.spdMain.CellClick | SCP0125_Workbench.cs:2072 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-60de1396 | this.spdMain.CellClick | SCP0125_Workbench.cs:2079 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc5c4de2 | this.spdMain.CellClick | SCP0125_Workbench.cs:2085 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (e.Column == siMain.GetColumnIndex(De… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.SCM_SITE_ID, dtSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ac362e47 | this.spdMain.CellClick | SCP0125_Workbench.cs:2089 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (e.Column == siMain.GetColumnInd… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.FCST_TYPE_NAME, dtFcstType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6a3caa58 | this.spdMain.CellClick | SCP0125_Workbench.cs:2093 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (e.Column == siMain.GetColumnInd… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.INCOTERMS, dtIncoterms, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-788b04d5 | this.spdMain.CellClick | SCP0125_Workbench.cs:2097 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (e.Column == siMain.GetColumnInd… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.PLANT_SITE_ID, dtPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d9295443 | this.spdMain.CellClick | SCP0125_Workbench.cs:2101 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (e.Column == siMain.GetColumnInd… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.CELL_PROD_SITE_ID, dtPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b362a5fa | this.spdMain.CellClick | SCP0125_Workbench.cs:2105 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (e.Column == siMain.GetColumnInd… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.PROJECT_CODE_40, dtProjectCodeAll_40, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-14721175 | this.spdMain.CellClick | SCP0125_Workbench.cs:2113 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.s… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.STOCK_TYPE_NAME, dtStockType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-70720349 | this.spdMain.CellClick | SCP0125_Workbench.cs:2117 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.s… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.INCOTERMS, dtIncoterms, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-813da988 | this.spdMain.CellClick | SCP0125_Workbench.cs:2125 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.s… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.SCM_SITE_ID, dtScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d7735f13 | this.spdMain.CellClick | SCP0125_Workbench.cs:2131 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.s… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.LOCATION_CODE, dtLocation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6f17af9f | this.spdMain.CellClick | SCP0125_Workbench.cs:2141 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName == SpdSheet.s… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.LINE_ID, dtLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9e6da532 | this.spdMain.CellClick | SCP0125_Workbench.cs:2149 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSh… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.PLANT_SITE_ID, dtPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bc732794 | this.spdMain.CellClick | SCP0125_Workbench.cs:2153 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSh… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.LINE_ID, dtLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f2d0f46a | this.spdMain.CellClick | SCP0125_Workbench.cs:2162 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSh… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.STOCK_TYPE_NAME, dtStockType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-27c50d80 | this.spdMain.CellClick | SCP0125_Workbench.cs:2166 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveSheetName == SpdSh… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.PLANT_ID, dtPlantID, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0125_Workbench.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6d05a62 | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2181 | if (!e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CA… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d82dee8 | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2196 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-8410405f | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2198 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-58344d5e | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2199 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-30a986ff | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2200 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e78cb3ac | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2210 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-fd041ece | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2218 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColum… | POPUP | new GSCM.SCM.Popup.UIL.SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-abd31840 | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2219 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColum… | POPUP | popItem.Form_Load | (true, division, "", "", "") | 팝업 초기화(인자 전달) |  |  |  |
| AC-5916099c | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2220 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColum… | UI_PROP | popItem.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d6ca5188 | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2221 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColum… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-add9c8af | this.spdMain.CellDoubleClick | SCP0125_Workbench.cs:2227 | if (!e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColum… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |

## SCP0125_Workbench.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fabc4960 | this.spdMain.ClipboardPasted | SCP0125_Workbench.cs:2247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (iRow < e.CellRange.Ro… | DATA_OP | dtFcstType.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-935adfe0 | this.spdMain.ClipboardPasted | SCP0125_Workbench.cs:2248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ for (iRow < e.CellRange.Ro… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE), codeVal) | 그리드 값 설정 |  |  |  |
| AC-f076ddbe | this.spdMain.ClipboardPasted | SCP0125_Workbench.cs:2264 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | DATA_OP | dtStockType.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3e2545ad | this.spdMain.ClipboardPasted | SCP0125_Workbench.cs:2265 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.STOCK_TYPE), codeVal) | 그리드 값 설정 |  |  |  |
| AC-7906d218 | this.spdMain.ClipboardPasted | SCP0125_Workbench.cs:2288 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_ID), operation) | 그리드 값 설정 |  |  |  |

## SCP0125_Workbench.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45a64802 | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2306 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (e.Column == siMain.Get… | DATA_OP | dtFcstType.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7eff3c11 | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2307 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (e.Column == siMain.Get… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FCST_TYPE), codeVal) | 그리드 값 설정 |  |  |  |
| AC-5b2afd99 | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | DATA_OP | dtStockType.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc52073 | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2316 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.STOCK_TYPE), codeVal) | 그리드 값 설정 |  |  |  |
| AC-321ee3a9 | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2324 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | DATA_OP | DBUtils.Filter | (dtPlantSite, "DIVISION_ID = '" + division + "' AND CODE = '" + scmSiteID + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b4e9397c | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2330 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | FLAG | dtLine | DBUtils.Filter(dtLineAll, "DIVISION_ID = '" + division + "' AND PLANT_ID = '" + plant_id +… | 화면 필드/플래그 변경 |  |  |  |
| AC-9ad9d3bf | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2330 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ if (_sActiveSheetName… | DATA_OP | DBUtils.Filter | (dtLineAll, "DIVISION_ID = '" + division + "' AND PLANT_ID = '" + plant_id + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0cb2de74 | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2343 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | DBUtils.Filter | (dtPlantSite, "DIVISION_ID = '" + division + "' AND CODE = '" + plantSiteID + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4f08b960 | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2349 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | FLAG | dtLine | DBUtils.Filter(dtLineAll, "DIVISION_ID = '" + division + "' AND PLANT_ID = '" + plant_id +… | 화면 필드/플래그 변경 |  |  |  |
| AC-d4eee3f5 | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2349 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | DBUtils.Filter | (dtLineAll, "DIVISION_ID = '" + division + "' AND PLANT_ID = '" + plant_id + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3143122b | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2361 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), operation) | 그리드 값 설정 |  |  |  |
| AC-01cf2d17 | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2369 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | DATA_OP | dtStockType.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-93a82d68 | this.spdMain.ComboSelChange | SCP0125_Workbench.cs:2370 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtMktFcst) ▸ else of (_sActiveShee… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.STOCK_TYPE), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0125_Workbench.spdSub_ActiveSheetChanging

진입점: this.spdMain.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7102e624 | this.spdMain.ActiveSheetChanging | SCP0125_Workbench.cs:2057 | if (_isFinding) | UI_PROP | e.ActivatedSheetIndex | siMain.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-301234eb | this.spdMain.ActiveSheetChanging | SCP0125_Workbench.cs:2058 | if (_isFinding) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-987dc099 | this.spdMain.ActiveSheetChanging | SCP0125_Workbench.cs:2063 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siMain.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-e8eff9d3 | this.spdMain.ActiveSheetChanging | SCP0125_Workbench.cs:2065 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d2af458d | this.spdMain.ActiveSheetChanging | SCP0125_Workbench.cs:2066 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

