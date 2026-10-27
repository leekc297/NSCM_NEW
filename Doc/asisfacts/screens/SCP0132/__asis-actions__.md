# AS-IS 액션 대조표 — SCP0132

> 원천: `Doc/asisfacts/screens/SCP0132/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 184행 · 메서드 31 · 종류 DATA_OP 53 · FLAG 23 · RETURN 21 · LIST_REBIND 17 · POPUP 10 · UI_PROP 9 · MESSAGE 9 · UI_MISC 8 · ENDPOINT 8 · GRID_SET 7 · GRID_INIT 6 · GRID_LOCK 6 · GRID_CLEAR 3 · VALIDATE 2 · VALUE_SET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SCP0132_ConstraintOfShipmentQty.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56fbdfa2 | this.btnItemId.Click | SCP0132_ConstraintOfShipmentQty.cs:1038 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3d363ea1 | this.btnItemId.Click | SCP0132_ConstraintOfShipmentQty.cs:1040 |  | POPUP | popItem.Form_Load | (true, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2cb94648 | this.btnItemId.Click | SCP0132_ConstraintOfShipmentQty.cs:1041 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-65f4f3ef | this.btnItemId.Click | SCP0132_ConstraintOfShipmentQty.cs:1042 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b86d7c0e | this.btnItemId.Click | SCP0132_ConstraintOfShipmentQty.cs:1048 | if (itemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.CboPlanGroup_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12a4434d | (진입점 미연결) | SCP0132_ConstraintOfShipmentQty.cs:920 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.CboPlanSeq_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec27552e | (진입점 미연결) | SCP0132_ConstraintOfShipmentQty.cs:363 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.checkMinMax

진입점: SaveButton [for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9059c0a | SaveButton [for (i <= siMain.GetMaxRowIndex())] | SCP0132_ConstraintOfShipmentQty.cs:547 | if (!string.IsNullOrEmpty(pMin) && !string.IsNullOrEmpty(pMax)) ▸ if (iMin > iMax) | MESSAGE | MessageHelper.GMessageBox | ("MSG00099", new object[] { pMinTitle, pMaxTitle }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a42e117 | SaveButton [for (i <= siMain.GetMaxRowIndex())] | SCP0132_ConstraintOfShipmentQty.cs:548 | if (!string.IsNullOrEmpty(pMin) && !string.IsNullOrEmpty(pMax)) ▸ if (iMin > iMax) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e51a167c | SaveButton [for (i <= siMain.GetMaxRowIndex())] | SCP0132_ConstraintOfShipmentQty.cs:552 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7be6ef97 | cboDivision.SelectedIndexChanged | SCP0132_ConstraintOfShipmentQty.cs:915 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-126be558 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:317 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5c90e782 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:318 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f028698 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:319 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54ad5423 | DeleteButton | SCP0132_ConstraintOfShipmentQty.cs:393 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b26ed528 | DeleteButton | SCP0132_ConstraintOfShipmentQty.cs:396 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba4ab9fc | Dispose | SCP0132_ConstraintOfShipmentQty.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7aa525d0 | EditButton | SCP0132_ConstraintOfShipmentQty.cs:404 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7bb87616 | EditButton | SCP0132_ConstraintOfShipmentQty.cs:405 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a405e3ae | EditButton | SCP0132_ConstraintOfShipmentQty.cs:406 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.DIVISION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8b83b28b | EditButton | SCP0132_ConstraintOfShipmentQty.cs:408 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.VAL_TP_CD), siMain.GetColumnIndex(DefColumns.PRE_KEY_VAL… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bca3e4fc | EditButton | SCP0132_ConstraintOfShipmentQty.cs:409 | if (spdMain != null) | FLAG | this._isEditMode | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.FindData_Main

진입점: FindButton / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9c32167 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:426 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5ecd65f7 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:431 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-3914c26f | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:431 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6dfced2e | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:435 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-50640b7f | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:438 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b801761f | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:459 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9df18af5 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:460 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c490a38e | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:464 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY") ⇒ SCP.SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY | 엔드포인트 요청 생성 |  |  |  |
| AC-036c48bc | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:465 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9de98fba | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:467 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-a0a4275a | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:468 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-a9087cdf | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:469 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site_id"] | pFromSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-ed437000 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:470 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site_id"] | pToSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-0b5dc881 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:471 | try ▸ lambda | DATA_OP | request.Parameters["p_mdl_gr_nm"] | pMdlGrNm | 행/컬럼 값 대입 |  |  |  |
| AC-085ef74f | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:472 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-61b60564 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:473 | try ▸ lambda | DATA_OP | request.Parameters["p_stage"] | pStage | 행/컬럼 값 대입 |  |  |  |
| AC-f717a76b | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:474 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | pFromYyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-27c4e41f | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:475 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | pToyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-73b223a7 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:476 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | pValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-7d97eea5 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:478 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3d0f27ed | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:480 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fec87142 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:489 | try ▸ if (ds.Tables.Count > 0) | FLAG | this.dtPreSafeStockAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-4cb7d9cb | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:489 | try ▸ if (ds.Tables.Count > 0) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c636e09d | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:493 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6ace5776 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:494 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dcee2256 | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:497 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b097a17e | FindButton 외 1 | SCP0132_ConstraintOfShipmentQty.cs:510 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-199c50f5 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:146 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.GetDivisionChecked

진입점: this.Load [else of (division.Equals("EE"))] / cboDivision.SelectedIndexChanged [else of (division.Equals("EE"))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6601e7ed | this.Load [else of (division.Equals("EE"))] 외 2 | SCP0132_ConstraintOfShipmentQty.cs:262 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.GetSearchInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09752500 | (진입점 미연결) | SCP0132_ConstraintOfShipmentQty.cs:217 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0132_GET_SEARCH_INFO") ⇒ SCP.SCP0132_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-8938afa0 | (진입점 미연결) | SCP0132_ConstraintOfShipmentQty.cs:219 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-df47794b | (진입점 미연결) | SCP0132_ConstraintOfShipmentQty.cs:220 |  | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-13d3ad10 | (진입점 미연결) | SCP0132_ConstraintOfShipmentQty.cs:221 |  | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-2a4d9695 | (진입점 미연결) | SCP0132_ConstraintOfShipmentQty.cs:222 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3360ac36 | (진입점 미연결) | SCP0132_ConstraintOfShipmentQty.cs:226 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad38b64b | this.Load | SCP0132_ConstraintOfShipmentQty.cs:162 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9181d91c | this.Load | SCP0132_ConstraintOfShipmentQty.cs:167 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-1eaaa369 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:169 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-38e887a0 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:171 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-bd35e5e2 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:174 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-58268303 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:177 |  | FLAG | dtToSiteAll | dsSearchInfo.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-d1654e51 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:180 |  | FLAG | dtFromSiteAll | dsSearchInfo.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-22cfd1db | this.Load | SCP0132_ConstraintOfShipmentQty.cs:183 |  | FLAG | dtStageAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-c8beabe4 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:187 |  | FLAG | dtModelGroupAll | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-ba2579bc | this.Load | SCP0132_ConstraintOfShipmentQty.cs:190 |  | FLAG | dtItemAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee13436a | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:327 |  | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |
| AC-8e083c89 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:328 |  | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5de348e5 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:330 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-ffad4656 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:333 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("Division", dtMyDivision) | 목록 컨트롤 재구성 |  |  |  |
| AC-e2305817 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:334 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanGroup", dtPlanGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-49e60833 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:335 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("Stage", dtStage) | 목록 컨트롤 재구성 |  |  |  |
| AC-711e8861 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:336 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("FromSite", dtFromSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-9cf4aa50 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:337 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ToSite", dtToSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-333d5226 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:344 |  | GRID_INIT | siMain.SetSheetHeaderColumnSCP | (siMain, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcca1f2c | InsertButton | SCP0132_ConstraintOfShipmentQty.cs:560 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7d68f3c2 | InsertButton | SCP0132_ConstraintOfShipmentQty.cs:566 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-95b1d413 | InsertButton | SCP0132_ConstraintOfShipmentQty.cs:567 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a81720f | InsertButton | SCP0132_ConstraintOfShipmentQty.cs:568 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.VAL_TP_CD, "A") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec9bd11e | InsertButton | SCP0132_ConstraintOfShipmentQty.cs:570 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-41879fd9 | InsertButton | SCP0132_ConstraintOfShipmentQty.cs:572 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b6947aab | InsertButton | SCP0132_ConstraintOfShipmentQty.cs:573 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.VAL_TP_CD), siMain.GetColumnIndex(DefColumns.LA… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.RefreshItemByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13bffa05 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:311 |  | FLAG | dtItem | DBUtils.Filter(dtItemAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-f25a9fbf | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:311 |  | DATA_OP | DBUtils.Filter | (dtItemAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f33bc0db | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:268 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-990f56cb | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:268 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-73cd938a | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:270 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.RefreshSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07116b16 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:278 | if (division.Equals("EE")) | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteAll, "DIVISION_ID IN ('81','40','82')") | 화면 필드/플래그 변경 |  |  |  |
| AC-9a1da4a1 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:278 | if (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtFromSiteAll, "DIVISION_ID IN ('81','40','82')") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a963fa55 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:279 | if (division.Equals("EE")) | FLAG | dtToSite | DBUtils.Filter(dtToSiteAll, "DIVISION_ID IN ('81','40','82')") | 화면 필드/플래그 변경 |  |  |  |
| AC-eca9ff65 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:279 | if (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtToSiteAll, "DIVISION_ID IN ('81','40','82')") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4405420c | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:284 | else of (division.Equals("EE")) | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-020fddeb | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:284 | else of (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtFromSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4326d03f | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:285 | else of (division.Equals("EE")) | FLAG | dtToSite | DBUtils.Filter(dtToSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-1c6f3e6d | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:285 | else of (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtToSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fd73824c | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:288 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-955da122 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:289 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.RefreshStageByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e96de324 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:295 |  | FLAG | dtStage | DBUtils.Filter(dtStageAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-01eabf08 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:295 |  | DATA_OP | DBUtils.Filter | (dtStageAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-446cda67 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:297 |  | LIST_REBIND | clsCtrl.setListBox | (dtStage, clbStage, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.RefreshStageByModelGroup

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e76c8069 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:303 |  | FLAG | dtModelGroup | DBUtils.Filter(dtModelGroupAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-dfac11b5 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:303 |  | DATA_OP | DBUtils.Filter | (dtModelGroupAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a364c6ed | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:305 |  | LIST_REBIND | clsCtrl.setListBox | (dtModelGroup, clbModelGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb5120a7 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:579 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6d00515 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:581 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-280026ed | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:678 | for (i <= siMain.GetMaxRowIndex()) ▸ if (v_division_id == string.Empty \|\| v_opmz_plan_gr_id == string.Empty \|\| v_from_ste_id == string.E… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b912d463 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:679 | for (i <= siMain.GetMaxRowIndex()) ▸ if (v_division_id == string.Empty \|\| v_opmz_plan_gr_id == string.Empty \|\| v_from_ste_id == string.E… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-299ad5ce | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:721 | for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Sales Site Priority" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-55a25f0e | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:722 | for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0dafaa7f | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:728 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFrom_date > dtTo_date) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9473645d | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:729 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFrom_date > dtTo_date) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27a75933 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:738 | for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(v_sipm_min_qyt) && string.IsNullOrEmpty(v_sipm_max_qty)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00022", new object[] {"MIN", "MAX" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a9bc2d52 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:739 | for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(v_sipm_min_qyt) && string.IsNullOrEmpty(v_sipm_max_qty)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a688d921 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:745 | for (i <= siMain.GetMaxRowIndex()) ▸ if (!checkMinMax("MIN", v_sipm_min_qyt, "MAX", v_sipm_max_qty)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26d3ae4a | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:750 | for (i <= siMain.GetMaxRowIndex()) ▸ if (!checkMinMax("MIN(SAT)", v_sat_sipm_min_qty, "MAX(SAT)", v_sat_sipm_max_qty)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26cf93cf | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:755 | for (i <= siMain.GetMaxRowIndex()) ▸ if (!checkMinMax("MIN(SUN)", v_sun_sipm_min_qty, "MAX(SUN)", v_sun_sipm_max_qty)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11928138 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:760 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | DBUtils.Filter | (dtItem, "ITEM_ID = '" + v_item_id + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-99804044 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:763 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtItemTemp.Rows.Count <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00458", new object[] { v_item_id }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fee8972 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:764 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtItemTemp.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f7480a0 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:809 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-678bb28f | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:810 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2744f5d3 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:814 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY") ⇒ SCP.SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY | 엔드포인트 요청 생성 |  |  |  |
| AC-c15e4671 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:817 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a82d7edb | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:821 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6f824b50 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:823 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1df4b80d | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:824 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3b71d9a3 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:825 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_opmz_plan_gr_id"] | p_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-f721604e | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:826 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_mdl_gr_nm"] | p_mdl_gr_nm | 행/컬럼 값 대입 |  |  |  |
| AC-eed216b7 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:827 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-292a8ece | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:828 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_stage"] | p_stage | 행/컬럼 값 대입 |  |  |  |
| AC-59f05cb7 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:829 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_from_ste_id"] | p_from_ste_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ee23601 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:830 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_ste_id"] | p_to_ste_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce3b389c | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:831 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6e4473c6 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:832 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b1b8c6ca | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:833 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_sipm_min_qyt"] | p_sipm_min_qyt | 행/컬럼 값 대입 |  |  |  |
| AC-7595499d | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:834 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_sipm_max_qty"] | p_sipm_max_qty | 행/컬럼 값 대입 |  |  |  |
| AC-85942db2 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:835 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_sat_sipm_min_qty"] | p_sat_sipm_min_qty | 행/컬럼 값 대입 |  |  |  |
| AC-b240411e | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:836 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_sat_sipm_max_qty"] | p_sat_sipm_max_qty | 행/컬럼 값 대입 |  |  |  |
| AC-90fbb8f2 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:837 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_sun_sipm_min_qty"] | p_sun_sipm_min_qty | 행/컬럼 값 대입 |  |  |  |
| AC-8cee6fd1 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:838 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_sun_sipm_max_qty"] | p_sun_sipm_max_qty | 행/컬럼 값 대입 |  |  |  |
| AC-012de705 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:839 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_val_tp_cd"] | p_val_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-f6d97819 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:840 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_description"] | p_value_description | 행/컬럼 값 대입 |  |  |  |
| AC-d4439049 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:841 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-11aee44a | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:842 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-db90784d | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:844 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7568fefc | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:845 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_opmz_plan_gr_id"] | p_pre_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-581eef3e | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:846 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_mdl_gr_nm"] | p_pre_mdl_gr_nm | 행/컬럼 값 대입 |  |  |  |
| AC-7bebbb78 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:847 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-1ab44e91 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:849 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-afcdc636 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:849 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-f52d4bbd | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:853 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e906e157 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:860 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-424856f3 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:869 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f1b6134e | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:876 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0c4f5422 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:877 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66938f95 | SaveButton | SCP0132_ConstraintOfShipmentQty.cs:881 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.Set_MeasureColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ca5a584 | (진입점 미연결) | SCP0132_ConstraintOfShipmentQty.cs:517 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0c6c4fe | (진입점 미연결) | SCP0132_ConstraintOfShipmentQty.cs:531 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0a927a9 | this.Load 외 2 | SCP0132_ConstraintOfShipmentQty.cs:369 |  | FLAG | _changeDivision | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.setPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eed8cb7e | this.Load | SCP0132_ConstraintOfShipmentQty.cs:904 |  | UI_PROP | dCalendar.Text1 | sMondayDate | 속성 Text1 설정 |  |  |  |
| AC-8666d054 | this.Load | SCP0132_ConstraintOfShipmentQty.cs:905 |  | UI_PROP | dCalendar.Text2 | sToDate | 속성 Text2 설정 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd35a009 | this.spdMain.CellClick | SCP0132_ConstraintOfShipmentQty.cs:940 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-66002a1c | this.spdMain.CellClick | SCP0132_ConstraintOfShipmentQty.cs:953 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-3b11f7d0 | this.spdMain.CellClick | SCP0132_ConstraintOfShipmentQty.cs:953 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c3aa57e0 | this.spdMain.CellClick | SCP0132_ConstraintOfShipmentQty.cs:959 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (action != CAppSetting.FlagI && !this._isEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b43a2fc | this.spdMain.CellClick | SCP0132_ConstraintOfShipmentQty.cs:967 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.OPMZ_PLAN_GR_ID, dtPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-112eb152 | this.spdMain.CellClick | SCP0132_ConstraintOfShipmentQty.cs:972 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ if (e.Column =… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.FROM_STE_ID, dtFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0baaad86 | this.spdMain.CellClick | SCP0132_ConstraintOfShipmentQty.cs:976 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.TO_STE_ID, dtToSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6991357e | this.spdMain.CellClick | SCP0132_ConstraintOfShipmentQty.cs:980 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.STAGE, dtStage, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-327dc660 | this.spdMain.CellClick | SCP0132_ConstraintOfShipmentQty.cs:988 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.VALID_YN, dtValidYn, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a0289cf | this.spdMain.CellDoubleClick | SCP0132_ConstraintOfShipmentQty.cs:1001 | if (!e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != C… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-612b513d | this.spdMain.CellDoubleClick | SCP0132_ConstraintOfShipmentQty.cs:1013 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a7592792 | this.spdMain.CellDoubleClick | SCP0132_ConstraintOfShipmentQty.cs:1015 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.Form_Load | (multiSelect, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-88907edf | this.spdMain.CellDoubleClick | SCP0132_ConstraintOfShipmentQty.cs:1016 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-25847d6e | this.spdMain.CellDoubleClick | SCP0132_ConstraintOfShipmentQty.cs:1017 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ac0b8c5d | this.spdMain.CellDoubleClick | SCP0132_ConstraintOfShipmentQty.cs:1024 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (!string.IsNullOrEmpty(sItemId)) ▸ if (siMain.GetColu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb4c0ba8 | this.spdMain.ClipboardPasted | SCP0132_ConstraintOfShipmentQty.cs:1112 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | DATA_OP | dtPlanGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a6141009 | this.spdMain.ClipboardPasted | SCP0132_ConstraintOfShipmentQty.cs:1114 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99034e4b | this.spdMain.EditChange | SCP0132_ConstraintOfShipmentQty.cs:1064 | if (e.Column == siMain.GetColumnIndex(DefColumns.SAT_SIPM_MIN_QTY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.SAT_SIPM_…) ▸ if (strin… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.VAL_TP_CD), "A") | 그리드 값 설정 |  |  |  |
| AC-ccfdaf48 | this.spdMain.EditChange | SCP0132_ConstraintOfShipmentQty.cs:1068 | if (e.Column == siMain.GetColumnIndex(DefColumns.SAT_SIPM_MIN_QTY) \|\| e.Column == siMain.GetColumnIndex(DefColumns.SAT_SIPM_…) ▸ else of (… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.VAL_TP_CD), "B") | 그리드 값 설정 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.SpdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a16eb2d | this.spdMain.KeyDown | SCP0132_ConstraintOfShipmentQty.cs:1089 | if (e.KeyCode == Keys.Delete) ▸ if (Col == siMain.GetColumnIndex(DefColumns.SAT_SIPM_MIN_QTY) \|\| Col == siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (Row, siMain.GetColumnIndex(DefColumns.VAL_TP_CD), "A") | 그리드 값 설정 |  |  |  |
| AC-d279e415 | this.spdMain.KeyDown | SCP0132_ConstraintOfShipmentQty.cs:1093 | if (e.KeyCode == Keys.Delete) ▸ if (Col == siMain.GetColumnIndex(DefColumns.SAT_SIPM_MIN_QTY) \|\| Col == siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (Row, siMain.GetColumnIndex(DefColumns.VAL_TP_CD), "B") | 그리드 값 설정 |  |  |  |

## SCP0132_ConstraintOfShipmentQty.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4f4cfda | this.spdMain.TopChange | SCP0132_ConstraintOfShipmentQty.cs:929 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

