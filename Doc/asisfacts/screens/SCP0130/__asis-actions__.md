# AS-IS 액션 대조표 — SCP0130

> 원천: `Doc/asisfacts/screens/SCP0130/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 276행 · 메서드 36 · 종류 DATA_OP 64 · FLAG 41 · RETURN 33 · MESSAGE 25 · LIST_REBIND 19 · GRID_INIT 17 · UI_PROP 16 · POPUP 12 · ENDPOINT 11 · UI_MISC 10 · GRID_LOCK 8 · GRID_SET 5 · VALUE_SET 4 · VALIDATE 4 · GRID_CLEAR 3 · STATE 2 · GRID_BIND 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 0


## SCP0130_ScheduledRecieptInformation.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5aa0fcdf | this.btnItemId.Click | SCP0130_ScheduledRecieptInformation.cs:1452 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5cab052c | this.btnItemId.Click | SCP0130_ScheduledRecieptInformation.cs:1454 |  | POPUP | popItem.Form_Load | (true, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-b1ec5aaf | this.btnItemId.Click | SCP0130_ScheduledRecieptInformation.cs:1455 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c869bcd9 | this.btnItemId.Click | SCP0130_ScheduledRecieptInformation.cs:1456 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d9bc5b55 | this.btnItemId.Click | SCP0130_ScheduledRecieptInformation.cs:1462 | if (itemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0130_ScheduledRecieptInformation.CboPlanGroup_SelectedIndexChanged

진입점: clbPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b43d904c | clbPlanGroup.SelectedIndexChanged | SCP0130_ScheduledRecieptInformation.cs:1301 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0130_ScheduledRecieptInformation.CboPlanSeq_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e42fedb9 | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:497 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0130_ScheduledRecieptInformation.CheckDigitValueEntered

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-399b58ef | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1551 | if (nCol < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-695a8dc3 | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1569 | if (nCol == siMain.GetColumnIndex(DefColumns.TO_EXPC_QTY)) ▸ if (nVal < 0 \|\| res == false) | GRID_SET | spread.SetValue | (nRow, nCol, 0) | 그리드 값 설정 |  |  |  |
| AC-5014978e | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1572 | if (nCol == siMain.GetColumnIndex(DefColumns.TO_EXPC_QTY)) ▸ if (nVal < 0 \|\| res == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0130_ScheduledRecieptInformation.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01284175 | cboDivision.SelectedIndexChanged | SCP0130_ScheduledRecieptInformation.cs:1296 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0130_ScheduledRecieptInformation.CopyPlantSite

진입점: this.Load / cboDivision.SelectedIndexChanged / clbPlanGroup.SelectedIndexChanged [if (_sActiveSheetName == SpdSheet.sht02Sir)] / this.spdMain.ActiveSheetChanged [if (_sActiveSheetName == SpdSheet.sht01VirtualBom)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf93f4f9 | this.Load 외 4 | SCP0130_ScheduledRecieptInformation.cs:297 |  | DATA_OP | dtTemp.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcc4c430 | this.Load 외 4 | SCP0130_ScheduledRecieptInformation.cs:298 |  | DATA_OP | dtTemp.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-13024a5f | this.Load 외 4 | SCP0130_ScheduledRecieptInformation.cs:303 | if (dtPlantSite != null) | DATA_OP | dtPlantSite.AsEnumerable().Select | (row => new { Code = row.Field<string>("CODE"), Name = row.Field<string>("NAME") }) | 데이터 객체 조작/조회 |  |  |  |
| AC-1573dc04 | this.Load 외 4 | SCP0130_ScheduledRecieptInformation.cs:306 | if (dtPlantSite != null) ▸ lambda | DATA_OP | row.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a80d81b3 | this.Load 외 4 | SCP0130_ScheduledRecieptInformation.cs:307 | if (dtPlantSite != null) ▸ lambda | DATA_OP | row.Field | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-d44430af | this.Load 외 4 | SCP0130_ScheduledRecieptInformation.cs:314 | if (dtPlantSite != null) ▸ foreach (var item in distinctRows) | DATA_OP | dtTemp.Rows.Add | (item.Code, item.Name) | 데이터 객체 조작/조회 |  |  |  |
| AC-e09e8d43 | this.Load 외 4 | SCP0130_ScheduledRecieptInformation.cs:317 | if (dtPlantSite != null) | FLAG | dtPlantSite | dtTemp | 화면 필드/플래그 변경 |  |  |  |

## SCP0130_ScheduledRecieptInformation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2027065 | this.Load | SCP0130_ScheduledRecieptInformation.cs:393 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.sht01VirtualBom, SpdSheet.sht01VirtualBom, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e3e1e8e0 | this.Load | SCP0130_ScheduledRecieptInformation.cs:394 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.sht02Sir, SpdSheet.sht02Sir, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d9415514 | this.Load | SCP0130_ScheduledRecieptInformation.cs:396 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.sht01VirtualBom) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0c906f6 | this.Load | SCP0130_ScheduledRecieptInformation.cs:399 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.sht02Sir) | 화면 필드/플래그 변경 |  |  |  |
| AC-e00fe700 | this.Load | SCP0130_ScheduledRecieptInformation.cs:402 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0130_ScheduledRecieptInformation.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b84b0b2b | this.Load | SCP0130_ScheduledRecieptInformation.cs:165 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |

## SCP0130_ScheduledRecieptInformation.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e93ebfb4 | DeleteButton | SCP0130_ScheduledRecieptInformation.cs:526 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f88bbcef | DeleteButton | SCP0130_ScheduledRecieptInformation.cs:529 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0130_ScheduledRecieptInformation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84ae34cb | Dispose | SCP0130_ScheduledRecieptInformation.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0130_ScheduledRecieptInformation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fbe18d2 | EditButton | SCP0130_ScheduledRecieptInformation.cs:537 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d740488 | EditButton | SCP0130_ScheduledRecieptInformation.cs:538 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-eebbced2 | EditButton | SCP0130_ScheduledRecieptInformation.cs:539 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.DIVISION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7ec27647 | EditButton | SCP0130_ScheduledRecieptInformation.cs:541 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.PRE_KEY_VA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f2573d02 | EditButton | SCP0130_ScheduledRecieptInformation.cs:542 | if (spdMain != null) | FLAG | this._isEditMode | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0130_ScheduledRecieptInformation.FindData_Main

진입점: FindButton / SaveButton [if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2a61f00 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:558 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-020c70a6 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:563 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-37c82a48 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:563 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d26a3247 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:567 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8f3fbe84 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:570 | try ▸ if (string.IsNullOrWhiteSpace(_sActiveSheetName)) | FLAG | _sActiveSheetName | siMain.ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-96ba5a0c | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:578 | try ▸ if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.sht01VirtualBom) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d3d94ab | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:586 | try ▸ else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.sht02Sir) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c8f8b9e | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:614 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-561dbd46 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:615 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-091039b0 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:619 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (queryId) ⇒ {?string.Empty} \| SCP.SCP0130_GET_VIRTUAL_BOM \| SCP.SCP0130_GET_SCHEDULED_RECI… | 엔드포인트 요청 생성 |  |  |  |
| AC-0f6b6b21 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:620 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-63a1dab6 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:621 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-14068947 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:622 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-7e00993d | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:623 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-8efcf0c6 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:624 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-9f0f8d57 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:625 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id_child"] | pItemIdChild | 행/컬럼 값 대입 |  |  |  |
| AC-adeea4e6 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:626 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | pValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-7c60e544 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:627 | try ▸ lambda | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-de46ef4a | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:629 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-afceb07a | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:631 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3bf29f98 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:642 | try ▸ if (ds.Tables.Count > 0) ▸ if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | FLAG | this.dtVirtualBomAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c81af58a | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:642 | try ▸ if (ds.Tables.Count > 0) ▸ if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b3ef4535 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:646 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | FLAG | this.dtSchRecInfoAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-35254ace | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:646 | try ▸ if (ds.Tables.Count > 0) ▸ else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a9ba75d8 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:650 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a778986b | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:651 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dfcc6ff7 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:654 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-845dfea7 | FindButton 외 1 | SCP0130_ScheduledRecieptInformation.cs:664 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0130_ScheduledRecieptInformation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-694ab4c4 | this.Load | SCP0130_ScheduledRecieptInformation.cs:154 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0130_ScheduledRecieptInformation.GetDivisionChecked

진입점: this.Load [else of (division.Equals("EE"))] / cboDivision.SelectedIndexChanged [else of (division.Equals("EE"))] / this.spdMain.ActiveSheetChanged [if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ else of (division.Equals("EE"))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca043ba2 | this.Load [else of (division.Equals("EE"))] 외 3 | SCP0130_ScheduledRecieptInformation.cs:290 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0130_ScheduledRecieptInformation.GetSearchInfo

진입점: this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName == SpdSheet.sht01VirtualBom)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c9bb720 | this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName … | SCP0130_ScheduledRecieptInformation.cs:245 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0130_GET_SEARCH_INFO") ⇒ SCP.SCP0130_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-eaec5187 | this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName … | SCP0130_ScheduledRecieptInformation.cs:247 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a26639ad | this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName … | SCP0130_ScheduledRecieptInformation.cs:248 |  | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-a124dece | this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName … | SCP0130_ScheduledRecieptInformation.cs:249 |  | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-53f90e54 | this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName … | SCP0130_ScheduledRecieptInformation.cs:250 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-97de3b81 | this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName … | SCP0130_ScheduledRecieptInformation.cs:254 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0130_ScheduledRecieptInformation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e29ab363 | this.Load | SCP0130_ScheduledRecieptInformation.cs:170 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b826a4a | this.Load | SCP0130_ScheduledRecieptInformation.cs:175 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-fcc15841 | this.Load | SCP0130_ScheduledRecieptInformation.cs:177 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-49c2cf13 | this.Load | SCP0130_ScheduledRecieptInformation.cs:180 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-6e7d5f5d | this.Load | SCP0130_ScheduledRecieptInformation.cs:186 |  | FLAG | dtStageAll | dsSearchInfo.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-61040dec | this.Load | SCP0130_ScheduledRecieptInformation.cs:189 |  | FLAG | dtType | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-fd738b83 | this.Load | SCP0130_ScheduledRecieptInformation.cs:190 |  | LIST_REBIND | clsCtrl.setListBox | (dtType, cboValid, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4ef02dc1 | this.Load | SCP0130_ScheduledRecieptInformation.cs:193 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-d0623bf9 | this.Load | SCP0130_ScheduledRecieptInformation.cs:196 |  | FLAG | dtValidYn | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-7573eb5e | this.Load | SCP0130_ScheduledRecieptInformation.cs:198 |  | FLAG | dtItemIdChildlAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-145a6159 | this.Load | SCP0130_ScheduledRecieptInformation.cs:201 |  | FLAG | dtPlantSiteAll | dsSearchInfo.Tables[7] | 화면 필드/플래그 변경 |  |  |  |
| AC-2355c592 | this.Load | SCP0130_ScheduledRecieptInformation.cs:208 |  | FLAG | _sActiveSheetName | SpdSheet.sht01VirtualBom | 화면 필드/플래그 변경 |  |  |  |

## SCP0130_ScheduledRecieptInformation.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-491ffc8b | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:408 |  | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |
| AC-a116cc47 | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:409 |  | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8cf810f4 | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:413 | if (spreadInfo.SheetName == SpdSheet.sht01VirtualBom) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-34ba9936 | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:416 | if (spreadInfo.SheetName == SpdSheet.sht01VirtualBom) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanGroup", dtPlanGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-8e358056 | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:417 | if (spreadInfo.SheetName == SpdSheet.sht01VirtualBom) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSite", dtPlantSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-ce4ab29d | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:418 | if (spreadInfo.SheetName == SpdSheet.sht01VirtualBom) | LIST_REBIND | SpreadInfo.SetComBoParam | ("ValidYn", dtValidYn) | 목록 컨트롤 재구성 |  |  |  |
| AC-7734d0f3 | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:420 | if (spreadInfo.SheetName == SpdSheet.sht01VirtualBom) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.TO_EXPC_QTY), 0, 3) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7b3772cc | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:424 | else of (spreadInfo.SheetName == SpdSheet.sht01VirtualBom) ▸ if (spreadInfo.SheetName == SpdSheet.sht02Sir) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-4d8f30ba | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:427 | else of (spreadInfo.SheetName == SpdSheet.sht01VirtualBom) ▸ if (spreadInfo.SheetName == SpdSheet.sht02Sir) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSiteSir", dtPlantSiteSir) | 목록 컨트롤 재구성 |  |  |  |
| AC-da9adb39 | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:428 | else of (spreadInfo.SheetName == SpdSheet.sht01VirtualBom) ▸ if (spreadInfo.SheetName == SpdSheet.sht02Sir) | LIST_REBIND | SpreadInfo.SetComBoParam | ("ValidYn", dtValidYn) | 목록 컨트롤 재구성 |  |  |  |
| AC-7da5a0a7 | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:429 | else of (spreadInfo.SheetName == SpdSheet.sht01VirtualBom) ▸ if (spreadInfo.SheetName == SpdSheet.sht02Sir) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanGroup", dtPlanGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-42c562c1 | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:430 | else of (spreadInfo.SheetName == SpdSheet.sht01VirtualBom) ▸ if (spreadInfo.SheetName == SpdSheet.sht02Sir) | LIST_REBIND | SpreadInfo.SetComBoParam | ("ItemIdChild", dtItemIdChild) | 목록 컨트롤 재구성 |  |  |  |
| AC-17d4cabb | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:433 |  | GRID_INIT | spreadInfo.SetSheetHeaderColumnSCP | (spreadInfo, 1, false, "") | 그리드 재구성/초기화 |  |  |  |
| AC-2ae77861 | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:435 |  | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a9dc1c8c | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:443 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4ef3b5d | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:444 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.sht01VirtualBom) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-37944d6d | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:445 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0130_ScheduledRecieptInformation.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-841186c7 | InsertButton | SCP0130_ScheduledRecieptInformation.cs:673 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ed74dae0 | InsertButton | SCP0130_ScheduledRecieptInformation.cs:681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-0058d329 | InsertButton | SCP0130_ScheduledRecieptInformation.cs:682 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c6a5b0e | InsertButton | SCP0130_ScheduledRecieptInformation.cs:684 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-5c3dbd2f | InsertButton | SCP0130_ScheduledRecieptInformation.cs:686 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-50b20247 | InsertButton | SCP0130_ScheduledRecieptInformation.cs:687 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-28692a90 | InsertButton | SCP0130_ScheduledRecieptInformation.cs:692 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-44518b4c | InsertButton | SCP0130_ScheduledRecieptInformation.cs:693 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-dde96407 | InsertButton | SCP0130_ScheduledRecieptInformation.cs:695 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-ecc4114d | InsertButton | SCP0130_ScheduledRecieptInformation.cs:697 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-403cf933 | InsertButton | SCP0130_ScheduledRecieptInformation.cs:698 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0130_ScheduledRecieptInformation.RefreshDivisionByItem

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged [else of (_sActiveSheetName == SpdSheet.sht01VirtualBom)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73e8e986 | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:385 |  | FLAG | dtItemIdChild | DBUtils.Filter(dtItemIdChildlAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-18e8e9f7 | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:385 |  | DATA_OP | DBUtils.Filter | (dtItemIdChildlAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-df8ee3bc | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:387 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemIdChild, clbChildMaterial, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0130_ScheduledRecieptInformation.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged [if (_sActiveSheetName == SpdSheet.sht01VirtualBom)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8880871c | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:323 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c0b16cf | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:323 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ce61528a | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:325 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0130_ScheduledRecieptInformation.RefreshSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / this.spdMain.ActiveSheetChanged [if (_sActiveSheetName == SpdSheet.sht01VirtualBom)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8613992a | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:356 | if (division.Equals("EE")) | FLAG | dtPlantSite | DBUtils.Filter(dtPlantSiteAll, "DIVISION_ID IN ('81','40','82')") | 화면 필드/플래그 변경 |  |  |  |
| AC-6308312d | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:356 | if (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtPlantSiteAll, "DIVISION_ID IN ('81','40','82')") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-844b4fe5 | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:362 | else of (division.Equals("EE")) | FLAG | dtPlantSite | DBUtils.Filter(dtPlantSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-bb7c8573 | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:362 | else of (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtPlantSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-26a868c1 | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:365 |  | FLAG | dtPlantSiteTemp | dtPlantSite | 화면 필드/플래그 변경 |  |  |  |
| AC-eb42f6c6 | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:366 |  | FLAG | dtPlantSiteSir | dtPlantSite | 화면 필드/플래그 변경 |  |  |  |
| AC-a2db783e | this.Load 외 3 | SCP0130_ScheduledRecieptInformation.cs:370 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0130_ScheduledRecieptInformation.RefreshSiteByPlanGroup

진입점: this.Load [if (_sActiveSheetName == SpdSheet.sht02Sir)] / cboDivision.SelectedIndexChanged [if (_sActiveSheetName == SpdSheet.sht02Sir)] / clbPlanGroup.SelectedIndexChanged [if (_sActiveSheetName == SpdSheet.sht02Sir)] / this.spdMain.ActiveSheetChanged [if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (_sActiveSheetName == SpdSheet.sht02Sir)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76813a50 | this.Load [if (_sActiveSheetName == SpdSheet.sht02Sir)] 외 4 | SCP0130_ScheduledRecieptInformation.cs:337 |  | FLAG | dtPlantSite | dtPlantSiteTemp | 화면 필드/플래그 변경 |  |  |  |
| AC-b4d0f460 | this.Load [if (_sActiveSheetName == SpdSheet.sht02Sir)] 외 4 | SCP0130_ScheduledRecieptInformation.cs:338 |  | FLAG | dtPlantSiteSir | dtPlantSiteTemp | 화면 필드/플래그 변경 |  |  |  |
| AC-64bdd61e | this.Load [if (_sActiveSheetName == SpdSheet.sht02Sir)] 외 4 | SCP0130_ScheduledRecieptInformation.cs:343 | if (!string.IsNullOrEmpty(pPlanGroup.ToString())) | FLAG | dtPlantSite | DBUtils.Filter(dtPlantSiteTemp, sFilter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef642fb3 | this.Load [if (_sActiveSheetName == SpdSheet.sht02Sir)] 외 4 | SCP0130_ScheduledRecieptInformation.cs:343 | if (!string.IsNullOrEmpty(pPlanGroup.ToString())) | DATA_OP | DBUtils.Filter | (dtPlantSiteTemp, sFilter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-224ebf2d | this.Load [if (_sActiveSheetName == SpdSheet.sht02Sir)] 외 4 | SCP0130_ScheduledRecieptInformation.cs:347 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0130_ScheduledRecieptInformation.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93373e46 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:706 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a18b9eb5 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:708 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68ff4819 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:792 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d19a042 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:793 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc370950 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:835 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Valid To" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-73e76d54 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:836 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-196681be | SaveButton | SCP0130_ScheduledRecieptInformation.cs:860 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-66442224 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:860 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e904ca99 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:873 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Valid To" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b86585b2 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:874 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5308239d | SaveButton | SCP0130_ScheduledRecieptInformation.cs:890 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cadce5f2 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:891 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1071501 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:900 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | MESSAGE | MessageHelper.GMessageBox | ("{0} \r\n소수점 최대 10자리까지 입력가능합니다. ", new object[] { args + v_to_expc_qty }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aad6a370 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:901 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d01a008 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:907 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { args + v_to_expc_qty }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c612b2d8 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:908 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72e94dfe | SaveButton | SCP0130_ScheduledRecieptInformation.cs:913 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7b42a0a | SaveButton | SCP0130_ScheduledRecieptInformation.cs:914 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action == CAp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a63a3e59 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:947 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e32fb8aa | SaveButton | SCP0130_ScheduledRecieptInformation.cs:948 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-35bbe17c | SaveButton | SCP0130_ScheduledRecieptInformation.cs:952 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0130_SVAE_VIRTUAL_BOM") ⇒ SCP.SCP0130_SVAE_VIRTUAL_BOM | 엔드포인트 요청 생성 |  |  |  |
| AC-e8b4c2dd | SaveButton | SCP0130_ScheduledRecieptInformation.cs:955 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6341d02e | SaveButton | SCP0130_ScheduledRecieptInformation.cs:959 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1d80a8e6 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:961 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e5681202 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:962 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-dea3b80b | SaveButton | SCP0130_ScheduledRecieptInformation.cs:963 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_opmz_plan_gr_id"] | p_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-c9e8099f | SaveButton | SCP0130_ScheduledRecieptInformation.cs:964 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-bfb89bdb | SaveButton | SCP0130_ScheduledRecieptInformation.cs:965 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-60e4d884 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:966 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id_child"] | p_item_id_child | 행/컬럼 값 대입 |  |  |  |
| AC-c6acc0d2 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:967 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3c29c772 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:968 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_expc_qty"] | p_to_expc_qty | 행/컬럼 값 대입 |  |  |  |
| AC-17aa9f8d | SaveButton | SCP0130_ScheduledRecieptInformation.cs:969 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_description"] | p_value_description | 행/컬럼 값 대입 |  |  |  |
| AC-7f3a29f3 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:970 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-b7da9936 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:971 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-1f187b9c | SaveButton | SCP0130_ScheduledRecieptInformation.cs:973 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea90c424 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:974 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_opmz_plan_gr_id"] | p_pre_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-cd269e63 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:975 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plant_site_id"] | p_pre_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-be74b79a | SaveButton | SCP0130_ScheduledRecieptInformation.cs:976 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-725eee0c | SaveButton | SCP0130_ScheduledRecieptInformation.cs:977 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id_child"] | p_pre_item_id_child | 행/컬럼 값 대입 |  |  |  |
| AC-a88ca019 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:979 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-db34b1be | SaveButton | SCP0130_ScheduledRecieptInformation.cs:979 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-4d1cdb63 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:983 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d74003be | SaveButton | SCP0130_ScheduledRecieptInformation.cs:990 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToStr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb8ca67f | SaveButton | SCP0130_ScheduledRecieptInformation.cs:999 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82b99f77 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1005 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6cb8cc98 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1006 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05ba7e77 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1010 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-11b79701 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1078 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-714ade29 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1079 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f9658a2 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1093 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | DATA_OP | DBUtils.Filter | (dtSchRecInfoAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c6c96f19 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1097 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f127df1f | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1098 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab0e9dae | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1111 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Valid To" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-65f5e9af | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1112 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4c83d13 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1135 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-726fa735 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1135 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4191e457 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1146 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Valid To" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b86e15a8 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1147 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af4f0aa4 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1162 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f179a78 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1163 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b178646a | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1172 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | MESSAGE | MessageHelper.GMessageBox | ("{0} \r\n소수점 최대 10자리까지 입력가능합니다. ", new object[] { args + v_to_expc_qty }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-02a16169 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1173 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96c1dabc | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1179 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { args + v_to_expc_qty }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9f3b545 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1180 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fe9ff65 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1185 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee0914a7 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1186 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI \|\| action =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92be35d0 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1218 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f6e3f736 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1219 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5dfe700a | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1223 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION") ⇒ SCP.SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION | 엔드포인트 요청 생성 |  |  |  |
| AC-4b78adfe | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1226 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ddee0c4b | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1230 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f4d2a6a5 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1232 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1c91b900 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1233 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-916e7296 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1234 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_opmz_plan_gr_id"] | p_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-25fc090e | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1235 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2886a627 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1236 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id_child"] | p_item_id_child | 행/컬럼 값 대입 |  |  |  |
| AC-c1e39f22 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1237 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0226da8c | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1238 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_expc_qty"] | p_to_expc_qty | 행/컬럼 값 대입 |  |  |  |
| AC-27a36c8a | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1239 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_description"] | p_value_description | 행/컬럼 값 대입 |  |  |  |
| AC-92844452 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1240 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-d55f8386 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1241 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-3d467039 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1243 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ef3ada16 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1244 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_opmz_plan_gr_id"] | p_pre_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-916c5f55 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1245 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_plant_site_id"] | p_pre_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-813237ee | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1246 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id_child"] | p_pre_item_id_child | 행/컬럼 값 대입 |  |  |  |
| AC-12c0893b | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1247 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_to_yyyymmdd"] | p_pre_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-14432b41 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1249 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11f667a3 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1249 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-8d44964f | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1253 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5c2e2290 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1260 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc74f3d6 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1269 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-63b45a91 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1275 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-189a52d1 | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1276 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b00a02b | SaveButton | SCP0130_ScheduledRecieptInformation.cs:1280 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0130_ScheduledRecieptInformation.SetCellFocus_ERROR

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5002b55 | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1605 |  | GRID_STYLE | spread.ActiveSheet.SetActiveCell | (this._siMainCellRowIdx, this._siMainCellColIdx) | 그리드 표시 설정 |  |  |  |

## SCP0130_ScheduledRecieptInformation.setDatePicker

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d54ccc3 | this.Load | SCP0130_ScheduledRecieptInformation.cs:227 |  | VALUE_SET | datePicker.Value | mondayDate2 | 컨트롤 값 설정 |  |  |  |

## SCP0130_ScheduledRecieptInformation.SetSpreadInit

진입점: this.Load / FindButton [try ▸ if (_sActiveSheetName == SpdSheet.sht01VirtualBom)] / SaveButton [if (_sActiveSheetName == SpdSheet.sht01VirtualBom) ▸ if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (_sActiveSheetName == SpdSheet.sht01VirtualBom)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c47db7cb | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:453 | if (sheetName.Equals(SpdSheet.sht01VirtualBom)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b36d544b | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:454 | if (sheetName.Equals(SpdSheet.sht01VirtualBom)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e7730da1 | this.Load 외 2 | SCP0130_ScheduledRecieptInformation.cs:462 |  | GRID_INIT | siObj.SetSheetHeaderColumnSCP | (siObj, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

## SCP0130_ScheduledRecieptInformation.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9af7a8e3 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1469 | if (sender != null) | FLAG | _sActiveSheetName | ((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-cbdccdb0 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1473 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | STATE | btnItemId.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-8e78a584 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1474 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | UI_PROP | lblItemId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a7722a78 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1475 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | UI_PROP | lblItemIdButton.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-65b6c9dc | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1476 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | UI_PROP | lblChildMaterial.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-cd2495ce | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1477 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | VALUE_SET | lblChildMaterial.Text | "Child Material" | 컨트롤 값 설정 |  |  |  |
| AC-83c52e41 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1479 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-64d490b4 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1482 | if (_sActiveSheetName == SpdSheet.sht01VirtualBom) | FLAG | dtPlantSiteAll | dsSearchInfo.Tables[7] | 화면 필드/플래그 변경 |  |  |  |
| AC-e429f205 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1488 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | STATE | btnItemId.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e9aff5d2 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1489 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | UI_PROP | lblItemId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8c1f4e35 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1490 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | UI_PROP | lblItemIdButton.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-02b07f6f | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1491 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | UI_PROP | lblChildMaterial.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b1c87a90 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1493 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | VALUE_SET | lblChildMaterial.Text | "Material" | 컨트롤 값 설정 |  |  |  |
| AC-a5cf3be0 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1495 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | FLAG | dsSearchInfo | GetSearchInfo("81") | 화면 필드/플래그 변경 |  |  |  |
| AC-c34f4248 | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1496 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | FLAG | dtItemIdChildlAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-088c5a3a | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1500 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[8] | 화면 필드/플래그 변경 |  |  |  |
| AC-9e38045d | this.spdMain.ActiveSheetChanged | SCP0130_ScheduledRecieptInformation.cs:1503 | else of (_sActiveSheetName == SpdSheet.sht01VirtualBom) | FLAG | dtPlantSiteAll | dsSearchInfo.Tables[7] | 화면 필드/플래그 변경 |  |  |  |

## SCP0130_ScheduledRecieptInformation.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ec87ba9 | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1326 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-a613232a | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1340 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-f4a7aa4c | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1340 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-22c3e22a | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1346 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | FLAG | dtItemIdChild | DBUtils.Filter(dtItemIdChildlAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = … | 화면 필드/플래그 변경 |  |  |  |
| AC-652fc8c4 | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1346 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | DATA_OP | DBUtils.Filter | (dtItemIdChildlAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" + v_plan_gr… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cd3aa485 | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1347 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | FLAG | dtPlantSiteSir | DBUtils.Filter(dtPlantSiteAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" … | 화면 필드/플래그 변경 |  |  |  |
| AC-1b0751cb | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1347 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | DATA_OP | DBUtils.Filter | (dtPlantSiteAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" + v_plan_group… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3a031214 | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1353 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (action != CAppSetting.FlagI && !this._isEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b18952b3 | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1361 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.OPMZ_PLAN_GR_ID, dtPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2d503c65 | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1365 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ if (e.Column =… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.PLANT_SITE_ID, dtPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1657dadd | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1368 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ if (e.Column =… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.PLANT_SITE_ID, dtPlantSiteSir, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-26b4b732 | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1372 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.ITEM_ID_CHILD, dtItemIdChild, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f6701e04 | this.spdMain.CellClick | SCP0130_ScheduledRecieptInformation.cs:1376 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.VALID_YN, dtValidYn, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0130_ScheduledRecieptInformation.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fec9311 | this.spdMain.CellDoubleClick | SCP0130_ScheduledRecieptInformation.cs:1391 | if (!e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != C… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8091eb3b | this.spdMain.CellDoubleClick | SCP0130_ScheduledRecieptInformation.cs:1404 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6f5620cc | this.spdMain.CellDoubleClick | SCP0130_ScheduledRecieptInformation.cs:1406 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.Form_Load | (multiSelect, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-34610e49 | this.spdMain.CellDoubleClick | SCP0130_ScheduledRecieptInformation.cs:1407 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3e2cdceb | this.spdMain.CellDoubleClick | SCP0130_ScheduledRecieptInformation.cs:1408 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e2bfe294 | this.spdMain.CellDoubleClick | SCP0130_ScheduledRecieptInformation.cs:1415 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (!string.IsNullOrEmpty(sItemId)) ▸ if (siMain.GetColu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |

## SCP0130_ScheduledRecieptInformation.SpdMain_Changed

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1af3f5a7 | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1539 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b3e9d01b | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1540 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-757243d8 | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1543 | if (this._siMainCellRowIdx < 0 \|\| this._siMainCellColIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0130_ScheduledRecieptInformation.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-407899fc | this.spdMain.ClipboardPasted | SCP0130_ScheduledRecieptInformation.cs:1435 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | DATA_OP | dtPlanGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e92cc1b6 | this.spdMain.ClipboardPasted | SCP0130_ScheduledRecieptInformation.cs:1437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0130_ScheduledRecieptInformation.SpdMain_EditChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b11edfb | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1522 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-1dabda5a | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1523 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0130_ScheduledRecieptInformation.SpdMain_EditModeOff

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-970818d4 | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1531 | if (this._siMainCellRowIdx < 0 \|\| this._siMainCellColIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0130_ScheduledRecieptInformation.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c6ec945 | this.spdMain.TopChange | SCP0130_ScheduledRecieptInformation.cs:1315 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0130_ScheduledRecieptInformation.spdSub_ActiveSheetChanging

진입점: this.spdMain.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8a44079 | this.spdMain.ActiveSheetChanging | SCP0130_ScheduledRecieptInformation.cs:1513 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siMain.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-639da59c | this.spdMain.ActiveSheetChanging | SCP0130_ScheduledRecieptInformation.cs:1515 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-591ff52c | this.spdMain.ActiveSheetChanging | SCP0130_ScheduledRecieptInformation.cs:1516 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0130_ScheduledRecieptInformation.ValidateUserInput

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5416013a | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1590 | if (action_name.Equals("UPPER_ZERO")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9d1ef18e | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1594 | else of (action_name.Equals("UPPER_ZERO")) ▸ if (action_name.Equals("ZERO_OR_HIGHER")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6aea049e | (진입점 미연결) | SCP0130_ScheduledRecieptInformation.cs:1599 | else of (action_name.Equals("UPPER_ZERO")) ▸ else of (action_name.Equals("ZERO_OR_HIGHER")) ▸ if (action_name.Equals("OVER_DAY_MIN")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00160", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

