# AS-IS 액션 대조표 — SCP0028

> 원천: `Doc/asisfacts/screens/SCP0028/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 149행 · 메서드 20 · 종류 DATA_OP 40 · POPUP 14 · RETURN 13 · ENDPOINT 12 · GRID_INIT 9 · UI_PROP 8 · MESSAGE 7 · LIST_REBIND 7 · FLAG 7 · UI_MISC 7 · CALL_EXT 6 · GRID_LOCK 5 · VALIDATE 4 · COMBO_DATA 3 · GRID_BIND 2 · GRID_SET 2 · VALUE_SET 1 · STATE_RESET 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 6


## SCP0028_Shipment_Lot_Size.btnDelete_Click

진입점: this.btnDelete.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a01cdcee | this.btnDelete.Click | SCP0028_Shipment_Lot_Size.cs:298 |  | POPUP | new SCM0002_ShipmentLotSizePopup | () | 팝업/폼 생성 |  |  |  |
| AC-c4c972d1 | this.btnDelete.Click | SCP0028_Shipment_Lot_Size.cs:299 |  | POPUP | popItem.Form_Load | ("D", sDivision_id.ToString()) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1b4a8c54 | this.btnDelete.Click | SCP0028_Shipment_Lot_Size.cs:300 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c32131bc | this.btnDelete.Click | SCP0028_Shipment_Lot_Size.cs:301 |  | UI_PROP | popItem.Width | 870 | 속성 Width 설정 |  |  |  |
| AC-a1974460 | this.btnDelete.Click | SCP0028_Shipment_Lot_Size.cs:302 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0028_Shipment_Lot_Size.btnInput_Click

진입점: this.btnInput.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ed7bd04 | this.btnInput.Click | SCP0028_Shipment_Lot_Size.cs:270 |  | POPUP | new SCM0002_ShipmentLotSizePopup | () | 팝업/폼 생성 |  |  |  |
| AC-43a61b15 | this.btnInput.Click | SCP0028_Shipment_Lot_Size.cs:271 |  | POPUP | popItem.Form_Load | ("I", sDivision_id.ToString()) | 팝업 초기화(인자 전달) |  |  |  |
| AC-799824c4 | this.btnInput.Click | SCP0028_Shipment_Lot_Size.cs:272 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c3654859 | this.btnInput.Click | SCP0028_Shipment_Lot_Size.cs:273 |  | UI_PROP | popItem.Width | 870 | 속성 Width 설정 |  |  |  |
| AC-03c39334 | this.btnInput.Click | SCP0028_Shipment_Lot_Size.cs:274 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0028_Shipment_Lot_Size.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da284978 | this.btnItemId.Click | SCP0028_Shipment_Lot_Size.cs:246 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1bf5d0e9 | this.btnItemId.Click | SCP0028_Shipment_Lot_Size.cs:248 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9dd4e581 | this.btnItemId.Click | SCP0028_Shipment_Lot_Size.cs:249 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-41b26ff2 | this.btnItemId.Click | SCP0028_Shipment_Lot_Size.cs:250 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3e21f76d | this.btnItemId.Click | SCP0028_Shipment_Lot_Size.cs:256 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0028_Shipment_Lot_Size.checkValidSize

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2b306c7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0028_Shipment_Lot_Size.cs:762 | for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOT_SIZE))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32edff1d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0028_Shipment_Lot_Size.cs:762 | for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INCREMENT))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51785e4a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0028_Shipment_Lot_Size.cs:764 | for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToInt64(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOT_SIZE))) < Convert.ToInt64(s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00099", new object[] { MessageHelper.GetTerm("Increment"), MessageHelper.GetTerm("Lot… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f88fb122 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0028_Shipment_Lot_Size.cs:766 | for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToInt64(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOT_SIZE))) < Convert.ToInt64(s… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-73495585 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0028_Shipment_Lot_Size.cs:769 | for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOT_SIZE))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38e6a6a4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0028_Shipment_Lot_Size.cs:769 | for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INCREMENT))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3c05f0c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0028_Shipment_Lot_Size.cs:771 | for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToInt64(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOT_SIZE)))==0 \|\| Convert.ToI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6a856db4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0028_Shipment_Lot_Size.cs:773 | for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToInt64(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOT_SIZE)))==0 \|\| Convert.ToI… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5d742fde | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0028_Shipment_Lot_Size.cs:777 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0028_Shipment_Lot_Size.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b32823a6 | (진입점 미연결) | SCP0028_Shipment_Lot_Size.cs:153 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-77c6918c | (진입점 미연결) | SCP0028_Shipment_Lot_Size.cs:154 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0028_Shipment_Lot_Size.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe90003d | this.Load | SCP0028_Shipment_Lot_Size.cs:176 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fec33dd4 | this.Load | SCP0028_Shipment_Lot_Size.cs:177 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-399e5ba3 | this.Load | SCP0028_Shipment_Lot_Size.cs:178 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0028_Shipment_Lot_Size.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28813dd5 | DeleteButton | SCP0028_Shipment_Lot_Size.cs:218 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ecdeda62 | DeleteButton | SCP0028_Shipment_Lot_Size.cs:223 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0028_Shipment_Lot_Size.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4342ee90 | Dispose | SCP0028_Shipment_Lot_Size.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0028_Shipment_Lot_Size.EditButton

진입점: this.btnInput.Click [if (InputSucs) ▸ try] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac77f55b | this.btnInput.Click [if (InputSucs) ▸ try] 외 1 | SCP0028_Shipment_Lot_Size.cs:231 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-15d1175d | this.btnInput.Click [if (InputSucs) ▸ try] 외 1 | SCP0028_Shipment_Lot_Size.cs:232 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-9fe3d764 | this.btnInput.Click [if (InputSucs) ▸ try] 외 1 | SCP0028_Shipment_Lot_Size.cs:234 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.TRANS_MOD… | 그리드 편집 잠금/해제 |  |  |  |
| AC-68a893f9 | this.btnInput.Click [if (InputSucs) ▸ try] 외 1 | SCP0028_Shipment_Lot_Size.cs:235 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0028_Shipment_Lot_Size.FindData

진입점: this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a722e47a | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:322 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-507aa7c8 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:325 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b6c7ac30 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:325 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db88d0a9 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:329 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-376e6dd6 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:344 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f8fff7c9 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:345 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e00cab96 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:349 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0028_GET_SHIPMENT_LOT_SIZE") ⇒ SCP.SCP0028_GET_SHIPMENT_LOT_SIZE | 엔드포인트 요청 생성 |  |  |  |
| AC-e490a15b | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:350 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ad538d00 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:351 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9e30c5d4 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:352 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-965782af | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:353 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-10d25a89 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:354 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-c5306c91 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:355 | try ▸ lambda | DATA_OP | request.Parameters["p_trans_mode"] | p_trans_mode | 행/컬럼 값 대입 |  |  |  |
| AC-5b86cdbe | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:356 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6880da29 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:357 | try ▸ lambda | DATA_OP | request.Parameters["p_valid"] | p_valid.Equals("ALL") ? DBNull.Value : p_valid | 행/컬럼 값 대입 |  |  |  |
| AC-6b054096 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:359 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-58757bf1 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:361 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-719e0722 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:368 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-48aca20a | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:369 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-401a2a26 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:371 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-616667e8 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:373 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-010a0bda | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | SCP0028_Shipment_Lot_Size.cs:384 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0028_Shipment_Lot_Size.FindDelete

진입점: this.btnDelete.Click [if (InputSucs)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2763e83 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:464 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4e3ae4ee | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:511 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE") ⇒ SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE | 엔드포인트 요청 생성 |  |  |  |
| AC-08f16287 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:515 | try ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ed2ff795 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:519 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-dbad6c86 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:520 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-af39fd93 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:521 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-8179d5d4 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:522 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-7fc2c9aa | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:523 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-2b4a5105 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:524 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-78a1cb9f | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:525 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-eab62d06 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:526 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_lot_size"] | p_lot_size | 행/컬럼 값 대입 |  |  |  |
| AC-a0bddb05 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:527 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_increment"] | p_increment | 행/컬럼 값 대입 |  |  |  |
| AC-9fe45d9c | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:528 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_split_yn"] | p_split_yn | 행/컬럼 값 대입 |  |  |  |
| AC-878708d8 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:529 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-0a487070 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:530 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e088d18 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:531 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-880f1bc4 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:533 | try ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f63fb4d9 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:533 | try ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-ea79c9b8 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:544 | try ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00031", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0779b053 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:553 | try ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6046c421 | this.btnDelete.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:563 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0028_Shipment_Lot_Size.FindInput

진입점: this.btnInput.Click [if (InputSucs)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97e2cdd8 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:397 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-dfcaf926 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:400 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-aedf3e91 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:400 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b2307652 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:404 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bb7cedfc | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:411 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4f7425c1 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:413 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9004b838 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:417 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT") ⇒ SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | 엔드포인트 요청 생성 |  |  |  |
| AC-bd6076dc | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:418 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | divList | 행/컬럼 값 대입 |  |  |  |
| AC-0b62d481 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:419 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | operationList | 행/컬럼 값 대입 |  |  |  |
| AC-83c0bc74 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:420 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | fromSiteList | 행/컬럼 값 대입 |  |  |  |
| AC-8880d1b7 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:421 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | toSiteList | 행/컬럼 값 대입 |  |  |  |
| AC-7ec27a6e | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:422 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | itemList | 행/컬럼 값 대입 |  |  |  |
| AC-aef56543 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:423 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-42b18867 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:426 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3c0f084 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:428 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-03e0fcb2 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:435 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3fddd57f | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:436 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d9dc393 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:438 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8870770e | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:440 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9c968058 | this.btnInput.Click [if (InputSucs)] | SCP0028_Shipment_Lot_Size.cs:455 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0028_Shipment_Lot_Size.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31f24788 | this.Load | SCP0028_Shipment_Lot_Size.cs:100 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0028_Shipment_Lot_Size.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9492fb4 | this.Load | SCP0028_Shipment_Lot_Size.cs:129 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5dbdb251 | this.Load | SCP0028_Shipment_Lot_Size.cs:132 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-13481d73 | this.Load | SCP0028_Shipment_Lot_Size.cs:134 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1c66beb5 | this.Load | SCP0028_Shipment_Lot_Size.cs:135 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-c20226c5 | this.Load | SCP0028_Shipment_Lot_Size.cs:137 |  | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-77bf3c23 | this.Load | SCP0028_Shipment_Lot_Size.cs:137 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-87887d42 | this.Load | SCP0028_Shipment_Lot_Size.cs:138 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6072b1d1 | this.Load | SCP0028_Shipment_Lot_Size.cs:140 |  | LIST_REBIND | clsCtrl.setListBox | (dtTransMode, clbTransMode, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0028_Shipment_Lot_Size.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a3ac17e | this.Load | SCP0028_Shipment_Lot_Size.cs:122 |  | FLAG | dsdm | (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Dat… | 화면 필드/플래그 변경 |  |  |  |

## SCP0028_Shipment_Lot_Size.InitSpread

진입점: this.Load / this.btnInput.Click [if (InputSucs) ▸ try] / this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39e8a88e | this.Load 외 4 | SCP0028_Shipment_Lot_Size.cs:185 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-beb1a1be | this.Load 외 4 | SCP0028_Shipment_Lot_Size.cs:186 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-2cb5ece0 | this.Load 외 4 | SCP0028_Shipment_Lot_Size.cs:187 |  | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.LOT_SIZE), 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb4adfb8 | this.Load 외 4 | SCP0028_Shipment_Lot_Size.cs:188 |  | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.INCREMENT), 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0028_Shipment_Lot_Size.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0ba2d6c | SaveButton | SCP0028_Shipment_Lot_Size.cs:594 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-61fe66eb | SaveButton | SCP0028_Shipment_Lot_Size.cs:595 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(CAppSetting.StringAction), i, siMain.GetColumnIndex(CAppSetting.… | 그리드 표시 설정 |  |  |  |
| AC-ff274810 | SaveButton | SCP0028_Shipment_Lot_Size.cs:608 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (modiCnt==0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2f8aa26 | SaveButton | SCP0028_Shipment_Lot_Size.cs:609 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (modiCnt==0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d135e95c | SaveButton | SCP0028_Shipment_Lot_Size.cs:612 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-b3c569b6 | SaveButton | SCP0028_Shipment_Lot_Size.cs:612 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fe6f028 | SaveButton | SCP0028_Shipment_Lot_Size.cs:614 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidSize()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3fa37349 | SaveButton | SCP0028_Shipment_Lot_Size.cs:659 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE") ⇒ SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE | 엔드포인트 요청 생성 |  |  |  |
| AC-c7bc227e | SaveButton | SCP0028_Shipment_Lot_Size.cs:663 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8a7a041 | SaveButton | SCP0028_Shipment_Lot_Size.cs:667 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1be02cc7 | SaveButton | SCP0028_Shipment_Lot_Size.cs:668 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-231b1316 | SaveButton | SCP0028_Shipment_Lot_Size.cs:669 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-750b6f44 | SaveButton | SCP0028_Shipment_Lot_Size.cs:670 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-10734cba | SaveButton | SCP0028_Shipment_Lot_Size.cs:671 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-d0318b36 | SaveButton | SCP0028_Shipment_Lot_Size.cs:672 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5542e819 | SaveButton | SCP0028_Shipment_Lot_Size.cs:673 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-b576767e | SaveButton | SCP0028_Shipment_Lot_Size.cs:674 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_lot_size"] | p_lot_size | 행/컬럼 값 대입 |  |  |  |
| AC-6aafce1e | SaveButton | SCP0028_Shipment_Lot_Size.cs:675 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_increment"] | p_increment | 행/컬럼 값 대입 |  |  |  |
| AC-413d6f57 | SaveButton | SCP0028_Shipment_Lot_Size.cs:676 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_split_yn"] | p_split_yn | 행/컬럼 값 대입 |  |  |  |
| AC-82fbe0c2 | SaveButton | SCP0028_Shipment_Lot_Size.cs:677 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-8d916750 | SaveButton | SCP0028_Shipment_Lot_Size.cs:678 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb8cd59d | SaveButton | SCP0028_Shipment_Lot_Size.cs:679 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-6461ed9c | SaveButton | SCP0028_Shipment_Lot_Size.cs:681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-509dc5f6 | SaveButton | SCP0028_Shipment_Lot_Size.cs:681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-eda08ce3 | SaveButton | SCP0028_Shipment_Lot_Size.cs:691 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18b4c739 | SaveButton | SCP0028_Shipment_Lot_Size.cs:700 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0028_Shipment_Lot_Size.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78432c8f | this.Load 외 1 | SCP0028_Shipment_Lot_Size.cs:166 |  | FLAG | dtFromSite | Data.Common(Data.Type.FromSiteByDivision, false, cboDivision.ControlValues, UserInfoContex… ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-761c3929 | this.Load 외 1 | SCP0028_Shipment_Lot_Size.cs:166 |  | COMBO_DATA | Data.Common | (Data.Type.FromSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.Current["… ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0125376c | this.Load 외 1 | SCP0028_Shipment_Lot_Size.cs:167 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-47b1dc66 | this.Load 외 1 | SCP0028_Shipment_Lot_Size.cs:169 |  | FLAG | dtToSite | Data.Common(Data.Type.ToSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.… ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d20d1691 | this.Load 외 1 | SCP0028_Shipment_Lot_Size.cs:169 |  | COMBO_DATA | Data.Common | (Data.Type.ToSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.Current["No… ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1dc765e6 | this.Load 외 1 | SCP0028_Shipment_Lot_Size.cs:170 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0028_Shipment_Lot_Size.spdMain_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdd9f67e | dsdm.Changed | SCP0028_Shipment_Lot_Size.cs:734 | if (e.Column == siMain.GetColumnIndex(DefColumns.LOT_SIZE) \|\| e.Column == siMain.GetColumnIndex(DefColumns.INCREMENT)) ▸ if (e.Column == s… | CALL_EXT | Convert.ToInt64 | (lotsize) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2129ea7a | dsdm.Changed | SCP0028_Shipment_Lot_Size.cs:734 | if (e.Column == siMain.GetColumnIndex(DefColumns.LOT_SIZE) \|\| e.Column == siMain.GetColumnIndex(DefColumns.INCREMENT)) ▸ if (e.Column == s… | CALL_EXT | Convert.ToInt64 | (increment) | ⚠ 의미 확인 필요 |  |  |  |
| AC-59f7ac55 | dsdm.Changed | SCP0028_Shipment_Lot_Size.cs:735 | if (e.Column == siMain.GetColumnIndex(DefColumns.LOT_SIZE) \|\| e.Column == siMain.GetColumnIndex(DefColumns.INCREMENT)) ▸ if (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCREMENT), siMain.GetValue(e.Row, siMain.GetColu… | 그리드 값 설정 |  |  |  |

## SCP0028_Shipment_Lot_Size.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f43ba2e | spdMain.TopChange | SCP0028_Shipment_Lot_Size.cs:721 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

