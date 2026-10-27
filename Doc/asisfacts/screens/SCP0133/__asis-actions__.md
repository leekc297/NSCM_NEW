# AS-IS 액션 대조표 — SCP0133

> 원천: `Doc/asisfacts/screens/SCP0133/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 288행 · 메서드 39 · 종류 DATA_OP 79 · FLAG 43 · UI_PROP 24 · RETURN 24 · LIST_REBIND 21 · GRID_INIT 16 · MESSAGE 14 · POPUP 12 · GRID_SET 11 · ENDPOINT 11 · UI_MISC 10 · GRID_LOCK 8 · VALIDATE 4 · STATE 3 · CALL_EXT 3 · GRID_CLEAR 2 · VALUE_SET 1 · GRID_BIND 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 3


## SCP0133_WarehouseCapacity.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9b3cfe3 | this.btnItemId.Click | SCP0133_WarehouseCapacity.cs:1351 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1596e3de | this.btnItemId.Click | SCP0133_WarehouseCapacity.cs:1353 |  | POPUP | popItem.Form_Load | (true, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8135e622 | this.btnItemId.Click | SCP0133_WarehouseCapacity.cs:1354 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6e9884d9 | this.btnItemId.Click | SCP0133_WarehouseCapacity.cs:1355 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f629da7e | this.btnItemId.Click | SCP0133_WarehouseCapacity.cs:1361 | if (itemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0133_WarehouseCapacity.CboPlanGroup_SelectedIndexChanged

진입점: clbPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52d591ce | clbPlanGroup.SelectedIndexChanged | SCP0133_WarehouseCapacity.cs:1166 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0133_WarehouseCapacity.CheckDigitValueEntered

진입점: this.spdMain.EditModeOff / dsdmMain.Changed / dsdmExcept.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27a38737 | this.spdMain.EditModeOff 외 2 | SCP0133_WarehouseCapacity.cs:1498 | if (nCol < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ade9bdf | this.spdMain.EditModeOff 외 2 | SCP0133_WarehouseCapacity.cs:1516 | if (nCol == siMain.GetColumnIndex(DefColumns.MAX_CAPA)) ▸ if (nVal < 0 \|\| res == false && !string.IsNullOrEmpty(val)) | GRID_SET | spread.SetValue | (nRow, nCol, 0) | 그리드 값 설정 |  |  |  |
| AC-de091280 | this.spdMain.EditModeOff 외 2 | SCP0133_WarehouseCapacity.cs:1519 | if (nCol == siMain.GetColumnIndex(DefColumns.MAX_CAPA)) ▸ if (nVal < 0 \|\| res == false && !string.IsNullOrEmpty(val)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0133_WarehouseCapacity.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1034fcef | cboDivision.SelectedIndexChanged | SCP0133_WarehouseCapacity.cs:1161 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0133_WarehouseCapacity.CopyPlantSite

진입점: this.Load / cboDivision.SelectedIndexChanged / clbPlanGroup.SelectedIndexChanged [if (_sActiveSheetName == SpdSheet.sht02ItemMap)] / this.spdMain.ActiveSheetChanged [if (_sActiveSheetName == SpdSheet.sht01WhCapa)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b65e54da | this.Load 외 3 | SCP0133_WarehouseCapacity.cs:300 |  | DATA_OP | dtTemp.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc3da2f2 | this.Load 외 3 | SCP0133_WarehouseCapacity.cs:301 |  | DATA_OP | dtTemp.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3045e2f2 | this.Load 외 3 | SCP0133_WarehouseCapacity.cs:306 | if (dtSite != null) | DATA_OP | dtSite.AsEnumerable().Select | (row => new { Code = row.Field<string>("CODE"), Name = row.Field<string>("NAME") }) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc1cd815 | this.Load 외 3 | SCP0133_WarehouseCapacity.cs:309 | if (dtSite != null) ▸ lambda | DATA_OP | row.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-08454f37 | this.Load 외 3 | SCP0133_WarehouseCapacity.cs:310 | if (dtSite != null) ▸ lambda | DATA_OP | row.Field | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-65196201 | this.Load 외 3 | SCP0133_WarehouseCapacity.cs:317 | if (dtSite != null) ▸ foreach (var item in distinctRows) | DATA_OP | dtTemp.Rows.Add | (item.Code, item.Name) | 데이터 객체 조작/조회 |  |  |  |
| AC-66b8c51c | this.Load 외 3 | SCP0133_WarehouseCapacity.cs:320 | if (dtSite != null) | FLAG | dtSite | dtTemp | 화면 필드/플래그 변경 |  |  |  |

## SCP0133_WarehouseCapacity.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9438b074 | this.Load | SCP0133_WarehouseCapacity.cs:412 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.sht01WhCapa, SpdSheet.sht01WhCapa, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1838210e | this.Load | SCP0133_WarehouseCapacity.cs:413 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.sht02ItemMap, SpdSheet.sht02ItemMap, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7f4f9747 | this.Load | SCP0133_WarehouseCapacity.cs:415 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.sht01WhCapa) | 화면 필드/플래그 변경 |  |  |  |
| AC-db444bc5 | this.Load | SCP0133_WarehouseCapacity.cs:418 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.sht02ItemMap) | 화면 필드/플래그 변경 |  |  |  |
| AC-7fd549c7 | this.Load | SCP0133_WarehouseCapacity.cs:421 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0133_WarehouseCapacity.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-872e38ff | this.Load | SCP0133_WarehouseCapacity.cs:170 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |

## SCP0133_WarehouseCapacity.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05ae7516 | DeleteButton | SCP0133_WarehouseCapacity.cs:549 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f023365 | DeleteButton | SCP0133_WarehouseCapacity.cs:552 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0133_WarehouseCapacity.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0af6b072 | Dispose | SCP0133_WarehouseCapacity.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0133_WarehouseCapacity.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25aa58d5 | EditButton | SCP0133_WarehouseCapacity.cs:560 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0df8952f | EditButton | SCP0133_WarehouseCapacity.cs:561 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-328d61cd | EditButton | SCP0133_WarehouseCapacity.cs:562 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.DIVISION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc52b180 | EditButton | SCP0133_WarehouseCapacity.cs:563 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.PRE_KEY_VA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0e2285ab | EditButton | SCP0133_WarehouseCapacity.cs:564 | if (spdMain != null) | FLAG | this._isEditMode | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0133_WarehouseCapacity.FindData_Main

진입점: FindButton / SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be391590 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:583 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a6312798 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:588 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-53ba5043 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:588 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78980eb9 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:592 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4f3536be | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:595 | try ▸ if (string.IsNullOrWhiteSpace(_sActiveSheetName)) | FLAG | _sActiveSheetName | siMain.ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-9d39972a | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:603 | try ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.sht01WhCapa) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-939d23d7 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:610 | try ▸ else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.sht02ItemMap) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7d15fae8 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:639 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-505cc288 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:640 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-af2e3b1e | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:644 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (queryId) ⇒ {?string.Empty} \| SCP.SCP0133_GET_WAREHOUSE_CAPACITY \| SCP.SCP0133_GET_WAREHOU… | 엔드포인트 요청 생성 |  |  |  |
| AC-5b9105ef | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:645 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3ecb8a93 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:646 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-5206a4d3 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:647 | try ▸ lambda | DATA_OP | request.Parameters["p_opmz_plan_gr_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-78cb2050 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:648 | try ▸ lambda | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-f5da6319 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:649 | try ▸ lambda | DATA_OP | request.Parameters["p_stage"] | pStage | 행/컬럼 값 대입 |  |  |  |
| AC-69460dd9 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:650 | try ▸ lambda | DATA_OP | request.Parameters["p_wh_nm"] | sWarehouse | 행/컬럼 값 대입 |  |  |  |
| AC-bd92a987 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:651 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | pFromYyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-879a3a8e | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:652 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | pToYyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ccb2a6ac | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:653 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-1f7b6950 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:654 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | pValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-6d6fa392 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:655 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25f36d52 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:657 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-12729512 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:668 | try ▸ if (ds.Tables.Count > 0) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) | FLAG | this.dtWarehouseCapaAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ab99a1f2 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:668 | try ▸ if (ds.Tables.Count > 0) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6389d646 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:672 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | FLAG | this.dtItemMappingAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-71c0d257 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:672 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9dc25af7 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:676 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-91995694 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:677 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e4c22ce3 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:680 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8c140909 | FindButton 외 1 | SCP0133_WarehouseCapacity.cs:690 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0133_WarehouseCapacity.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd2aa588 | this.Load | SCP0133_WarehouseCapacity.cs:158 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0133_WarehouseCapacity.GetDivisionChecked

진입점: this.Load [else of (division.Equals("EE"))] / cboDivision.SelectedIndexChanged [else of (division.Equals("EE"))] / this.spdMain.ActiveSheetChanged [if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ else of (division.Equals("EE"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afab734d | this.Load [else of (division.Equals("EE"))] 외 2 | SCP0133_WarehouseCapacity.cs:293 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0133_WarehouseCapacity.GetSearchInfo

진입점: this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName == SpdSheet.sht01WhCapa)] / SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a1f3dc8 | this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName … 외 1 | SCP0133_WarehouseCapacity.cs:250 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0133_GET_SEARCH_INFO") ⇒ SCP.SCP0133_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-eeba23a8 | this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName … 외 1 | SCP0133_WarehouseCapacity.cs:252 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-27a829dc | this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName … 외 1 | SCP0133_WarehouseCapacity.cs:253 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5648963b | this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName … 외 1 | SCP0133_WarehouseCapacity.cs:257 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0133_WarehouseCapacity.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76d733e7 | this.Load | SCP0133_WarehouseCapacity.cs:175 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-bbb8aba3 | this.Load | SCP0133_WarehouseCapacity.cs:180 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-2041a89a | this.Load | SCP0133_WarehouseCapacity.cs:182 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-070803a6 | this.Load | SCP0133_WarehouseCapacity.cs:184 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-28b90ba7 | this.Load | SCP0133_WarehouseCapacity.cs:187 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-1e64982c | this.Load | SCP0133_WarehouseCapacity.cs:190 |  | FLAG | dtSiteAll | dsSearchInfo.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-cd36e7d5 | this.Load | SCP0133_WarehouseCapacity.cs:193 |  | FLAG | dtStageAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-85071259 | this.Load | SCP0133_WarehouseCapacity.cs:196 |  | FLAG | dtWarehouseAll | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-4f7516c0 | this.Load | SCP0133_WarehouseCapacity.cs:199 |  | FLAG | dtItemAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-a87a97be | this.Load | SCP0133_WarehouseCapacity.cs:203 |  | FLAG | dtStorLoc | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-3dd55ddc | this.Load | SCP0133_WarehouseCapacity.cs:204 |  | DATA_OP | dtStorLoc.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-698a8b5b | this.Load | SCP0133_WarehouseCapacity.cs:205 |  | DATA_OP | dtStorLoc.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-01d02a38 | this.Load | SCP0133_WarehouseCapacity.cs:207 |  | DATA_OP | dtStorLoc.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2cd05e54 | this.Load | SCP0133_WarehouseCapacity.cs:208 |  | DATA_OP | row["CODE"] | "East" | 행/컬럼 값 대입 |  |  |  |
| AC-b059e807 | this.Load | SCP0133_WarehouseCapacity.cs:209 |  | DATA_OP | row["NAME"] | "East" | 행/컬럼 값 대입 |  |  |  |
| AC-17ea4d48 | this.Load | SCP0133_WarehouseCapacity.cs:210 |  | DATA_OP | dtStorLoc.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-96c7e6a8 | this.Load | SCP0133_WarehouseCapacity.cs:212 |  | DATA_OP | dtStorLoc.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c5d4248f | this.Load | SCP0133_WarehouseCapacity.cs:213 |  | DATA_OP | row["CODE"] | "West" | 행/컬럼 값 대입 |  |  |  |
| AC-d3970940 | this.Load | SCP0133_WarehouseCapacity.cs:214 |  | DATA_OP | row["NAME"] | "West" | 행/컬럼 값 대입 |  |  |  |
| AC-4507e8b1 | this.Load | SCP0133_WarehouseCapacity.cs:215 |  | DATA_OP | dtStorLoc.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-20cade87 | this.Load | SCP0133_WarehouseCapacity.cs:224 |  | FLAG | _sActiveSheetName | SpdSheet.sht01WhCapa | 화면 필드/플래그 변경 |  |  |  |
| AC-66ff3ed0 | this.Load | SCP0133_WarehouseCapacity.cs:228 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | STATE | btnItemId.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5f730b44 | this.Load | SCP0133_WarehouseCapacity.cs:229 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblItemId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5bc95602 | this.Load | SCP0133_WarehouseCapacity.cs:230 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblItemIdButton.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-44072a05 | this.Load | SCP0133_WarehouseCapacity.cs:232 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblWarehouse.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3eead4f6 | this.Load | SCP0133_WarehouseCapacity.cs:233 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblPeriod.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SCP0133_WarehouseCapacity.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0c4745b | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:427 |  | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |
| AC-ea11ca62 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:428 |  | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-43b46262 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:432 | if (spreadInfo.SheetName == SpdSheet.sht01WhCapa) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b50011e5 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:435 | if (spreadInfo.SheetName == SpdSheet.sht01WhCapa) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanGroup", dtPlanGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-b02f051b | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:436 | if (spreadInfo.SheetName == SpdSheet.sht01WhCapa) | LIST_REBIND | SpreadInfo.SetComBoParam | ("Site", dtSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-0fef2ed7 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:437 | if (spreadInfo.SheetName == SpdSheet.sht01WhCapa) | LIST_REBIND | SpreadInfo.SetComBoParam | ("Stage", dtStage) | 목록 컨트롤 재구성 |  |  |  |
| AC-6e21971d | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:441 | else of (spreadInfo.SheetName == SpdSheet.sht01WhCapa) ▸ if (spreadInfo.SheetName == SpdSheet.sht02ItemMap) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-92706235 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:444 | else of (spreadInfo.SheetName == SpdSheet.sht01WhCapa) ▸ if (spreadInfo.SheetName == SpdSheet.sht02ItemMap) | LIST_REBIND | SpreadInfo.SetComBoParam | ("SiteSub", dtSiteSub) | 목록 컨트롤 재구성 |  |  |  |
| AC-d1d7933a | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:445 | else of (spreadInfo.SheetName == SpdSheet.sht01WhCapa) ▸ if (spreadInfo.SheetName == SpdSheet.sht02ItemMap) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanGroup", dtPlanGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-6734473e | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:446 | else of (spreadInfo.SheetName == SpdSheet.sht01WhCapa) ▸ if (spreadInfo.SheetName == SpdSheet.sht02ItemMap) | LIST_REBIND | SpreadInfo.SetComBoParam | ("Stage", dtStage) | 목록 컨트롤 재구성 |  |  |  |
| AC-476fe5fd | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:447 | else of (spreadInfo.SheetName == SpdSheet.sht01WhCapa) ▸ if (spreadInfo.SheetName == SpdSheet.sht02ItemMap) | LIST_REBIND | SpreadInfo.SetComBoParam | ("Warehouse", dtWarehouse) | 목록 컨트롤 재구성 |  |  |  |
| AC-ebf2c4fa | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:448 | else of (spreadInfo.SheetName == SpdSheet.sht01WhCapa) ▸ if (spreadInfo.SheetName == SpdSheet.sht02ItemMap) | LIST_REBIND | SpreadInfo.SetComBoParam | ("StorLoc", dtStorLoc) | 목록 컨트롤 재구성 |  |  |  |
| AC-6a6820fd | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:451 |  | GRID_INIT | spreadInfo.SetSheetHeaderColumnSCP | (spreadInfo, 1, false, "") | 그리드 재구성/초기화 |  |  |  |
| AC-4039e5d7 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:453 |  | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-01e52d6e | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:461 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f99d6943 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:462 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.sht01WhCapa) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b6848be2 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:463 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0133_WarehouseCapacity.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74a27489 | InsertButton | SCP0133_WarehouseCapacity.cs:699 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7d741908 | InsertButton | SCP0133_WarehouseCapacity.cs:706 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-09ca8b10 | InsertButton | SCP0133_WarehouseCapacity.cs:707 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-c776d153 | InsertButton | SCP0133_WarehouseCapacity.cs:709 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-2d7206f7 | InsertButton | SCP0133_WarehouseCapacity.cs:711 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a6e8afd2 | InsertButton | SCP0133_WarehouseCapacity.cs:712 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c91eeafb | InsertButton | SCP0133_WarehouseCapacity.cs:716 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-639be444 | InsertButton | SCP0133_WarehouseCapacity.cs:717 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | DATA_OP | defaultData.Add | (DefColumns.STOR_PER, "1") | 데이터 객체 조작/조회 |  |  |  |
| AC-f54ab79d | InsertButton | SCP0133_WarehouseCapacity.cs:718 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-adbd863f | InsertButton | SCP0133_WarehouseCapacity.cs:720 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-28a85eae | InsertButton | SCP0133_WarehouseCapacity.cs:722 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ef77969 | InsertButton | SCP0133_WarehouseCapacity.cs:723 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0133_WarehouseCapacity.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged [if (_sActiveSheetName == SpdSheet.sht01WhCapa)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b889d31 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:326 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-88802aef | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:326 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a344bf9b | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:328 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0133_WarehouseCapacity.RefreshSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged [if (_sActiveSheetName == SpdSheet.sht01WhCapa)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a16bc41 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:359 | if (division.Equals("EE")) | FLAG | dtSite | DBUtils.Filter(dtSiteAll, "DIVISION_ID IN ('81','40','82')") | 화면 필드/플래그 변경 |  |  |  |
| AC-d7f98e60 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:359 | if (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtSiteAll, "DIVISION_ID IN ('81','40','82')") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e2aae194 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:365 | else of (division.Equals("EE")) | FLAG | dtSite | DBUtils.Filter(dtSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-2401d0b2 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:365 | else of (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f88be7be | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:368 |  | FLAG | dtSiteTemp | dtSite | 화면 필드/플래그 변경 |  |  |  |
| AC-97a98e47 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:369 |  | FLAG | dtSiteSub | dtSite | 화면 필드/플래그 변경 |  |  |  |
| AC-32f84607 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:373 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0133_WarehouseCapacity.RefreshSiteByPlanGroup

진입점: this.Load [if (_sActiveSheetName == SpdSheet.sht02ItemMap)] / cboDivision.SelectedIndexChanged [if (_sActiveSheetName == SpdSheet.sht02ItemMap)] / clbPlanGroup.SelectedIndexChanged [if (_sActiveSheetName == SpdSheet.sht02ItemMap)] / this.spdMain.ActiveSheetChanged [if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (_sActiveSheetName == SpdSheet.sht02ItemMap)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-551bd087 | this.Load [if (_sActiveSheetName == SpdSheet.sht02ItemMap)] 외 3 | SCP0133_WarehouseCapacity.cs:340 |  | FLAG | dtSite | dtSiteTemp | 화면 필드/플래그 변경 |  |  |  |
| AC-eab4460a | this.Load [if (_sActiveSheetName == SpdSheet.sht02ItemMap)] 외 3 | SCP0133_WarehouseCapacity.cs:341 |  | FLAG | dtSiteSub | dtSiteTemp | 화면 필드/플래그 변경 |  |  |  |
| AC-67ad544d | this.Load [if (_sActiveSheetName == SpdSheet.sht02ItemMap)] 외 3 | SCP0133_WarehouseCapacity.cs:346 | if (!string.IsNullOrEmpty(pPlanGroup.ToString())) | FLAG | dtSite | DBUtils.Filter(dtSiteTemp, sFilter) | 화면 필드/플래그 변경 |  |  |  |
| AC-992ddb70 | this.Load [if (_sActiveSheetName == SpdSheet.sht02ItemMap)] 외 3 | SCP0133_WarehouseCapacity.cs:346 | if (!string.IsNullOrEmpty(pPlanGroup.ToString())) | DATA_OP | DBUtils.Filter | (dtSiteTemp, sFilter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-58c214a9 | this.Load [if (_sActiveSheetName == SpdSheet.sht02ItemMap)] 외 3 | SCP0133_WarehouseCapacity.cs:351 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0133_WarehouseCapacity.RefreshStageByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a121dd8 | this.Load 외 1 | SCP0133_WarehouseCapacity.cs:379 |  | FLAG | dtStage | DBUtils.Filter(dtStageAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-8f38f7f4 | this.Load 외 1 | SCP0133_WarehouseCapacity.cs:379 |  | DATA_OP | DBUtils.Filter | (dtStageAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-08a56496 | this.Load 외 1 | SCP0133_WarehouseCapacity.cs:381 |  | LIST_REBIND | clsCtrl.setListBox | (dtStage, cboStage, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0133_WarehouseCapacity.RefreshWarehouse

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName == SpdSheet.sht01WhCapa)] / SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a828a242 | this.Load 외 3 | SCP0133_WarehouseCapacity.cs:402 |  | FLAG | dtWarehouse | DBUtils.Filter(dtWarehouseAll, sFilter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d693314 | this.Load 외 3 | SCP0133_WarehouseCapacity.cs:402 |  | DATA_OP | DBUtils.Filter | (dtWarehouseAll, sFilter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e2420839 | this.Load 외 3 | SCP0133_WarehouseCapacity.cs:404 |  | LIST_REBIND | clsCtrl.setListBox | (dtWarehouse, clbWarehouse, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0133_WarehouseCapacity.SaveData_ItemMapping

진입점: SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (_sActiveSheetName == SpdSheet.sht02ItemMap)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e75cb29 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:953 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58f3b786 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:955 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68048d72 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1032 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSe… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f4f3c5d0 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1033 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1824274 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1039 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSe… | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-8d8fdf4b | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1039 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79a88013 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1066 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0f54938a | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1067 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-69822ac7 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1071 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING") ⇒ SCP.SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING | 엔드포인트 요청 생성 |  |  |  |
| AC-fb8f5190 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1074 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0d9ba3d8 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1078 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-930e0933 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1080 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9abbd0b7 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1081 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c86a1cb4 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1082 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_opmz_plan_gr_id"] | p_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-4737be46 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1083 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_wh_nm"] | p_wh_nm | 행/컬럼 값 대입 |  |  |  |
| AC-1d2952d1 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1084 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea456429 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1085 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_stage"] | p_stage | 행/컬럼 값 대입 |  |  |  |
| AC-451b929b | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1086 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e5d4c3dc | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1087 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_stor_per"] | p_stor_per | 행/컬럼 값 대입 |  |  |  |
| AC-81db8832 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1088 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_stor_loc"] | p_stor_loc | 행/컬럼 값 대입 |  |  |  |
| AC-6c4bd6e3 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1089 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_description"] | p_value_description | 행/컬럼 값 대입 |  |  |  |
| AC-0c38c1f0 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1090 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-0db6b707 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1091 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ad4bb799 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1093 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a5b3b0d3 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1094 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_opmz_plan_gr_id"] | p_pre_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-b625b276 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1095 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_wh_nm"] | p_pre_wh_nm | 행/컬럼 값 대입 |  |  |  |
| AC-e3494fa2 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1096 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f5b6ea7a | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1098 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6b180148 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1098 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-50eb8b1e | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1102 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-57f1937f | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1109 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f377276 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1118 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToS… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38450ba9 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1124 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-479e3e40 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1125 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-433c3a74 | SaveButton [else of (_sActiveSheetName == SpdSheet.sht01WhCa… | SCP0133_WarehouseCapacity.cs:1129 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0133_WarehouseCapacity.SaveData_WhCapa

진입점: SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8592212 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:731 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c465417 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:733 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b923845 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:810 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSet… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7de84062 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:811 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSet… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52586a42 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:817 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSet… | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-89d51df3 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:817 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSet… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4288ff6 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:835 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSet… | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Warehouse Capacity" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39813084 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:836 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSet… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fe975bc | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:843 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSet… | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-497bb300 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:844 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSet… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fea113af | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:873 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-aa23ac86 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:874 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-60276c91 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:878 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0133_SAVE_WAREHOUSE_CAPACITY") ⇒ SCP.SCP0133_SAVE_WAREHOUSE_CAPACITY | 엔드포인트 요청 생성 |  |  |  |
| AC-ac1c0d70 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:881 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c266723 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:885 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-13ee4e2c | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:887 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-49370b78 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:888 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8df2af48 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:889 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_opmz_plan_gr_id"] | p_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-29ff1fa7 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:890 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_wh_nm"] | p_wh_nm | 행/컬럼 값 대입 |  |  |  |
| AC-d5b06737 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:891 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-4d55ea13 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:892 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_stage"] | p_stage | 행/컬럼 값 대입 |  |  |  |
| AC-57c87b7f | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:893 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b7727e9b | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:894 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c2d61e3c | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:895 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_max_capa"] | p_max_capa | 행/컬럼 값 대입 |  |  |  |
| AC-2979f278 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:896 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_description"] | p_value_description | 행/컬럼 값 대입 |  |  |  |
| AC-e97639d5 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:897 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-c8a6e974 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:898 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-9b58eff4 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:900 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9068d29e | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:901 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_opmz_plan_gr_id"] | p_pre_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-121b060e | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:902 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_wh_nm"] | p_pre_wh_nm | 행/컬럼 값 대입 |  |  |  |
| AC-3589d904 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:903 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_from_yyyymmdd"] | p_pre_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fd1d10d0 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:904 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_to_yyyymmdd"] | p_pre_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-69189026 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:906 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-efffd14b | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:906 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-95e853e9 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:910 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-92cc3aa1 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:917 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString(… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5abefbca | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:922 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString(… | FLAG | dsSearchInfo | GetSearchInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-e8c4df43 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:923 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString(… | FLAG | dtWarehouseAll | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-6717694b | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:931 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToSt… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb4ee3d5 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:937 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-87613e33 | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:938 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a862902e | SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa)] | SCP0133_WarehouseCapacity.cs:942 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0133_WarehouseCapacity.SetCellFocus_ERROR

진입점: this.spdMain.EditModeOff [if (nCol == siMain.GetColumnIndex(DefColumns.MAX_CAPA)) ▸ if (nVal < 0 \|\| res == false && !string.IsNullOrEmpty(val))] / dsdmMain.Changed [if (nCol == siMain.GetColumnIndex(DefColumns.MAX_CAPA)) ▸ if (nVal < 0 \|\| res == false && !string.IsNullOrEmpty(val))] / dsdmExcept.Changed [if (nCol == siMain.GetColumnIndex(DefColumns.MAX_CAPA)) ▸ if (nVal < 0 \|\| res == false && !string.IsNullOrEmpty(val))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e99c014 | this.spdMain.EditModeOff [if (nCol == siMain.GetColumnIndex(… 외 2 | SCP0133_WarehouseCapacity.cs:1544 |  | GRID_STYLE | spread.ActiveSheet.SetActiveCell | (this._siMainCellRowIdx, this._siMainCellColIdx) | 그리드 표시 설정 |  |  |  |

## SCP0133_WarehouseCapacity.setPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b63e611b | this.Load | SCP0133_WarehouseCapacity.cs:1150 |  | UI_PROP | dCalendar.Text1 | sMondayDate | 속성 Text1 설정 |  |  |  |
| AC-41d2cf2b | this.Load | SCP0133_WarehouseCapacity.cs:1151 |  | UI_PROP | dCalendar.Text2 | sToDate | 속성 Text2 설정 |  |  |  |

## SCP0133_WarehouseCapacity.SetSpreadInit

진입점: this.Load / FindButton [try ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa)] / SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47f3c942 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:471 | if (sheetName.Equals(SpdSheet.sht01WhCapa)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8be3581c | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:472 | if (sheetName.Equals(SpdSheet.sht01WhCapa)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-6acffcc6 | this.Load 외 2 | SCP0133_WarehouseCapacity.cs:475 |  | GRID_INIT | siObj.SetSheetHeaderColumnSCP | (siObj, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

## SCP0133_WarehouseCapacity.SetVisibleSheetColumns

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName == SpdSheet.sht01WhCapa)] / FindButton [try] / SaveButton [if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (_sActiveSheetName == SpdSheet.sht01WhCapa) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83f6f1db | this.Load 외 4 | SCP0133_WarehouseCapacity.cs:522 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (division.IndexOf("81_UC") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.STOR_LOC_NAME, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-76083fc6 | this.Load 외 4 | SCP0133_WarehouseCapacity.cs:526 | if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ else of (division.IndexOf("81_UC") >= 0) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.STOR_LOC_NAME, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-31419c2b | this.Load 외 4 | SCP0133_WarehouseCapacity.cs:530 |  | CALL_EXT | SheetUtils.SetColumHide | (siMain) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0133_WarehouseCapacity.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d0f7248 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1417 | if (sender != null) | FLAG | _sActiveSheetName | ((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-1cfbfa0b | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1421 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | STATE | btnItemId.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-60e1de50 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1422 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblItemId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-56242c82 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1423 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblItemIdButton.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-78d3e5e6 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1425 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblWarehouse.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-42524930 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1426 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblPeriod.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-160bcfa8 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1428 | if (_sActiveSheetName == SpdSheet.sht01WhCapa) | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-a869cf7f | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1434 | else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblWarehouse.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d3df5391 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1435 | else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblPeriod.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c538df0b | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1437 | else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | STATE | btnItemId.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-72ca6e0f | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1438 | else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblItemId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-12501d15 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1439 | else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | UI_PROP | lblItemIdButton.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b73dd417 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1441 | else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | FLAG | dsSearchInfo | GetSearchInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-6dadf777 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1443 | else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[6] | 화면 필드/플래그 변경 |  |  |  |
| AC-7db141e7 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1446 | else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | FLAG | dtSiteAll | dsSearchInfo.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-97307dc5 | this.spdMain.ActiveSheetChanged | SCP0133_WarehouseCapacity.cs:1449 | else of (_sActiveSheetName == SpdSheet.sht01WhCapa) | FLAG | dtWarehouseAll | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |

## SCP0133_WarehouseCapacity.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31838b68 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1186 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-9f616e25 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1199 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-4e7f5955 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1199 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a08012a6 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1204 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | FLAG | dtWarehouse | DBUtils.Filter(dtWarehouseAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" … | 화면 필드/플래그 변경 |  |  |  |
| AC-46e920c0 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1204 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | DATA_OP | DBUtils.Filter | (dtWarehouseAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" + v_plan_group… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9146a560 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1205 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | FLAG | dtSiteSub | DBUtils.Filter(dtSiteAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" + v_p… | 화면 필드/플래그 변경 |  |  |  |
| AC-f843d1c1 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1205 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | DATA_OP | DBUtils.Filter | (dtSiteAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" + v_plan_group + "'… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b82349bf | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1209 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (action != CAppSetting.FlagI && !this._isEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07cd4d44 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1217 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.OPMZ_PLAN_GR_ID, dtPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e708a480 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1221 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ if (e.Column =… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.SCM_SITE_ID, dtSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5449fcbc | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1224 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ if (e.Column =… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.SCM_SITE_ID, dtSiteSub, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d9db5c30 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1228 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.STAGE, dtStage, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d6ec5400 | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1233 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.WH_NM, dtWarehouse, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3de0b61a | this.spdMain.CellClick | SCP0133_WarehouseCapacity.cs:1238 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.STOR_LOC_NAME, dtStorLoc, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0133_WarehouseCapacity.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-606683b2 | this.spdMain.CellDoubleClick | SCP0133_WarehouseCapacity.cs:1251 | if (!e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != C… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c5748a2 | this.spdMain.CellDoubleClick | SCP0133_WarehouseCapacity.cs:1263 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e9f0f14d | this.spdMain.CellDoubleClick | SCP0133_WarehouseCapacity.cs:1265 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.Form_Load | (multiSelect, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f7ca1abc | this.spdMain.CellDoubleClick | SCP0133_WarehouseCapacity.cs:1266 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2b3a4cc2 | this.spdMain.CellDoubleClick | SCP0133_WarehouseCapacity.cs:1267 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-94d1a303 | this.spdMain.CellDoubleClick | SCP0133_WarehouseCapacity.cs:1274 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (!string.IsNullOrEmpty(sItemId)) ▸ if (siMain.GetColu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |

## SCP0133_WarehouseCapacity.SpdMain_Changed

진입점: dsdmMain.Changed / dsdmExcept.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6558e53b | dsdmMain.Changed 외 1 | SCP0133_WarehouseCapacity.cs:1487 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-f398cd32 | dsdmMain.Changed 외 1 | SCP0133_WarehouseCapacity.cs:1488 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-41b6d39d | dsdmMain.Changed 외 1 | SCP0133_WarehouseCapacity.cs:1491 | if (this._siMainCellRowIdx < 0 \|\| this._siMainCellColIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0133_WarehouseCapacity.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-812390f9 | this.spdMain.ClipboardPasted | SCP0133_WarehouseCapacity.cs:1294 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | DATA_OP | dtPlanGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-165f6170 | this.spdMain.ClipboardPasted | SCP0133_WarehouseCapacity.cs:1295 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), codeVal) | 그리드 값 설정 |  |  |  |
| AC-0b46e401 | this.spdMain.ClipboardPasted | SCP0133_WarehouseCapacity.cs:1305 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | DATA_OP | DBUtils.Filter | (dtWarehouseAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" + planGroup + … | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9aa2ffd0 | this.spdMain.ClipboardPasted | SCP0133_WarehouseCapacity.cs:1312 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), site) | 그리드 값 설정 |  |  |  |
| AC-3a426be1 | this.spdMain.ClipboardPasted | SCP0133_WarehouseCapacity.cs:1313 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.STAGE), stage) | 그리드 값 설정 |  |  |  |
| AC-6d17d795 | this.spdMain.ClipboardPasted | SCP0133_WarehouseCapacity.cs:1335 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.STOR_LOC), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0133_WarehouseCapacity.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-392a16c7 | this.spdMain.ComboSelChange | SCP0133_WarehouseCapacity.cs:1377 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (e.Column == siMain.G… | DATA_OP | DBUtils.Filter | (dtWarehouseAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" + planGroup + … | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f82bab81 | this.spdMain.ComboSelChange | SCP0133_WarehouseCapacity.cs:1384 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (e.Column == siMain.G… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), site) | 그리드 값 설정 |  |  |  |
| AC-0761518c | this.spdMain.ComboSelChange | SCP0133_WarehouseCapacity.cs:1385 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ if (e.Column == siMain.G… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.STAGE), stage) | 그리드 값 설정 |  |  |  |
| AC-279e0c40 | this.spdMain.ComboSelChange | SCP0133_WarehouseCapacity.cs:1406 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht02ItemMap) ▸ else of (e.Column == siM… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.STOR_LOC), storLoc) | 그리드 값 설정 |  |  |  |

## SCP0133_WarehouseCapacity.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da6f6833 | this.spdMain.EditChange | SCP0133_WarehouseCapacity.cs:1471 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-6b10dc2d | this.spdMain.EditChange | SCP0133_WarehouseCapacity.cs:1472 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0133_WarehouseCapacity.SpdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-209b28ea | this.spdMain.EditModeOff | SCP0133_WarehouseCapacity.cs:1480 | if (this._siMainCellRowIdx < 0 \|\| this._siMainCellColIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0133_WarehouseCapacity.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dde04e2 | this.spdMain.TopChange | SCP0133_WarehouseCapacity.cs:1180 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0133_WarehouseCapacity.spdSub_ActiveSheetChanging

진입점: this.spdMain.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddeb54c0 | this.spdMain.ActiveSheetChanging | SCP0133_WarehouseCapacity.cs:1462 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siMain.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-b31cfb99 | this.spdMain.ActiveSheetChanging | SCP0133_WarehouseCapacity.cs:1464 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-96fd0520 | this.spdMain.ActiveSheetChanging | SCP0133_WarehouseCapacity.cs:1465 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0133_WarehouseCapacity.ValidateUserInput

진입점: this.spdMain.EditModeOff [if (nCol == siMain.GetColumnIndex(DefColumns.MAX_CAPA)) ▸ if (nVal < 0 \|\| res == false && !string.IsNullOrEmpty(val))] / dsdmMain.Changed [if (nCol == siMain.GetColumnIndex(DefColumns.MAX_CAPA)) ▸ if (nVal < 0 \|\| res == false && !string.IsNullOrEmpty(val))] / dsdmExcept.Changed [if (nCol == siMain.GetColumnIndex(DefColumns.MAX_CAPA)) ▸ if (nVal < 0 \|\| res == false && !string.IsNullOrEmpty(val))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e93ffab3 | this.spdMain.EditModeOff [if (nCol == siMain.GetColumnIndex(… 외 2 | SCP0133_WarehouseCapacity.cs:1529 | if (action_name.Equals("UPPER_ZERO")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-414c7076 | this.spdMain.EditModeOff [if (nCol == siMain.GetColumnIndex(… 외 2 | SCP0133_WarehouseCapacity.cs:1533 | else of (action_name.Equals("UPPER_ZERO")) ▸ if (action_name.Equals("ZERO_OR_HIGHER")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-28f45995 | this.spdMain.EditModeOff [if (nCol == siMain.GetColumnIndex(… 외 2 | SCP0133_WarehouseCapacity.cs:1538 | else of (action_name.Equals("UPPER_ZERO")) ▸ else of (action_name.Equals("ZERO_OR_HIGHER")) ▸ if (action_name.Equals("OVER_DAY_MIN")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00160", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

