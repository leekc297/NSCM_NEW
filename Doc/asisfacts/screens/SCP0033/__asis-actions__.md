# AS-IS 액션 대조표 — SCP0033

> 원천: `Doc/asisfacts/screens/SCP0033/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 91행 · 메서드 15 · 종류 DATA_OP 22 · RETURN 13 · MESSAGE 8 · GRID_INIT 7 · GRID_LOCK 7 · UI_MISC 5 · POPUP 5 · ENDPOINT 5 · FLAG 4 · UI_PROP 4 · VALIDATE 3 · GRID_SET 3 · LIST_REBIND 2 · GRID_BIND 1 · GRID_COMBO 1 · CALL_EXT 1 · ⚠ 의미 확인 필요 1


## SCP0033_Shipment_semi_dept_day.checkValid

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87852fa5 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0033_Shipment_semi_dept_day.cs:514 | if (null!= dsValiChkBinding) ▸ for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a28ffaa8 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0033_Shipment_semi_dept_day.cs:515 | if (null!= dsValiChkBinding) ▸ for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-562fcd0e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0033_Shipment_semi_dept_day.cs:517 | if (null!= dsValiChkBinding) ▸ for (i < dt.Rows.Count) | DATA_OP | dsValiChkBinding.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3296e133 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0033_Shipment_semi_dept_day.cs:533 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c695ae5d | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0033_Shipment_semi_dept_day.cs:536 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0033_Shipment_semi_dept_day.checkValid1

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5a8c7c2 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0033_Shipment_semi_dept_day.cs:556 | if (null != dsValiChkBinding) ▸ for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-57f99dff | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0033_Shipment_semi_dept_day.cs:557 | if (null != dsValiChkBinding) ▸ for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4607977 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0033_Shipment_semi_dept_day.cs:559 | if (null != dsValiChkBinding) ▸ for (i < dt.Rows.Count) | DATA_OP | dt.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-143453bf | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0033_Shipment_semi_dept_day.cs:575 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-752557fd | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0033_Shipment_semi_dept_day.cs:578 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0033_Shipment_semi_dept_day.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e64a8715 | this.Load | SCP0033_Shipment_semi_dept_day.cs:147 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c53a1a7f | this.Load | SCP0033_Shipment_semi_dept_day.cs:148 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4f1bfd1f | this.Load | SCP0033_Shipment_semi_dept_day.cs:149 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0033_Shipment_semi_dept_day.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ef72273 | DeleteButton | SCP0033_Shipment_semi_dept_day.cs:186 | if (action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39567270 | DeleteButton | SCP0033_Shipment_semi_dept_day.cs:188 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0033_Shipment_semi_dept_day.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a736f5b | Dispose | SCP0033_Shipment_semi_dept_day.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0033_Shipment_semi_dept_day.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-704223ee | EditButton | SCP0033_Shipment_semi_dept_day.cs:219 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-61b55b5c | EditButton | SCP0033_Shipment_semi_dept_day.cs:220 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-37501448 | EditButton | SCP0033_Shipment_semi_dept_day.cs:224 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-56a7165a | EditButton | SCP0033_Shipment_semi_dept_day.cs:225 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0033_Shipment_semi_dept_day.FindData_Main

진입점: FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f0d7687 | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:233 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8f076e5f | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:236 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-47740d7c | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:236 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8122b4a5 | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:252 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5c7076b8 | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:253 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c1e9e271 | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:254 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ce3563da | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:258 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY") ⇒ SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY | 엔드포인트 요청 생성 |  |  |  |
| AC-72bd9b4a | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:259 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c0b7867d | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:260 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-a148545f | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:261 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3a29c6ac | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:262 | try ▸ lambda | DATA_OP | request.Parameters["p_valid"] | p_valid | 행/컬럼 값 대입 |  |  |  |
| AC-b9f0f070 | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:265 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e22c5978 | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:267 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c9a56864 | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:274 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9b10f50a | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:275 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4324139b | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:278 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5ab938f4 | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:284 | try ▸ if (null!= ds.Tables[1]) | FLAG | dsValiChkBinding | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-832616f9 | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:289 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f87a198c | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:291 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d5fab047 | FindButton 외 1 | SCP0033_Shipment_semi_dept_day.cs:298 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0033_Shipment_semi_dept_day.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3feebf03 | this.Load | SCP0033_Shipment_semi_dept_day.cs:91 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0033_Shipment_semi_dept_day.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12ad5e25 | this.Load | SCP0033_Shipment_semi_dept_day.cs:129 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-ec2f9673 | this.Load | SCP0033_Shipment_semi_dept_day.cs:131 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e473f953 | this.Load | SCP0033_Shipment_semi_dept_day.cs:133 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8ae013e2 | this.Load | SCP0033_Shipment_semi_dept_day.cs:134 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboValidYN, true, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0033_Shipment_semi_dept_day.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89b7027f | this.Load 외 2 | SCP0033_Shipment_semi_dept_day.cs:156 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-4bbf94c3 | this.Load 외 2 | SCP0033_Shipment_semi_dept_day.cs:161 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-08d97a03 | this.Load 외 2 | SCP0033_Shipment_semi_dept_day.cs:162 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75cd30c2 | this.Load 외 2 | SCP0033_Shipment_semi_dept_day.cs:163 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0033_Shipment_semi_dept_day.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04655218 | InsertButton | SCP0033_Shipment_semi_dept_day.cs:201 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-870b5874 | InsertButton | SCP0033_Shipment_semi_dept_day.cs:204 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-96cb0c2c | InsertButton | SCP0033_Shipment_semi_dept_day.cs:206 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0661f29 | InsertButton | SCP0033_Shipment_semi_dept_day.cs:207 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-f51ce261 | InsertButton | SCP0033_Shipment_semi_dept_day.cs:209 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-360a3b5d | InsertButton | SCP0033_Shipment_semi_dept_day.cs:210 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4bf820b2 | InsertButton | SCP0033_Shipment_semi_dept_day.cs:211 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0033_Shipment_semi_dept_day.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b45d8c47 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:308 | if (siMain.ActiveSheet.RowCount <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00059") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9d702d40 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:309 | if (siMain.ActiveSheet.RowCount <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b9ca89c | SaveButton | SCP0033_Shipment_semi_dept_day.cs:317 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19f5e00c | SaveButton | SCP0033_Shipment_semi_dept_day.cs:318 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-bfcb4abb | SaveButton | SCP0033_Shipment_semi_dept_day.cs:318 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4aae076 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:319 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!checkValid()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec6ad446 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:320 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!checkValid1()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4da6b363 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:380 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY") ⇒ SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY | 엔드포인트 요청 생성 |  |  |  |
| AC-8cd6f37e | SaveButton | SCP0033_Shipment_semi_dept_day.cs:384 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2bcc4900 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:385 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c68164cb | SaveButton | SCP0033_Shipment_semi_dept_day.cs:386 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3f29385a | SaveButton | SCP0033_Shipment_semi_dept_day.cs:387 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_departure_day"] | p_departure_day | 행/컬럼 값 대입 |  |  |  |
| AC-e741b1fd | SaveButton | SCP0033_Shipment_semi_dept_day.cs:388 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-990fa80f | SaveButton | SCP0033_Shipment_semi_dept_day.cs:389 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_s_valid_yn"] | p_s_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-ee9aa799 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:390 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-04967780 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:391 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-cbe02f73 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:392 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-f68b1199 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:393 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9dc8b848 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:395 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-31b289b1 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:400 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c503a638 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:409 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d7471c8 | SaveButton | SCP0033_Shipment_semi_dept_day.cs:417 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0033_Shipment_semi_dept_day.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e869e3f | this.spdMain.CellClick | SCP0033_Shipment_semi_dept_day.cs:452 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80da84c7 | this.spdMain.CellClick | SCP0033_Shipment_semi_dept_day.cs:466 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c8f56006 | this.spdMain.CellClick | SCP0033_Shipment_semi_dept_day.cs:467 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36f4e612 | this.spdMain.CellClick | SCP0033_Shipment_semi_dept_day.cs:471 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (clbDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b924b59 | this.spdMain.CellClick | SCP0033_Shipment_semi_dept_day.cs:477 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b459b4d7 | this.spdMain.CellClick | SCP0033_Shipment_semi_dept_day.cs:479 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | POPUP | popItem.Form_Load | (false, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-20d020b1 | this.spdMain.CellClick | SCP0033_Shipment_semi_dept_day.cs:480 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8681d332 | this.spdMain.CellClick | SCP0033_Shipment_semi_dept_day.cs:481 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d2224b25 | this.spdMain.CellClick | SCP0033_Shipment_semi_dept_day.cs:487 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID) | 그리드 값 설정 |  |  |  |
| AC-237e9e31 | this.spdMain.CellClick | SCP0033_Shipment_semi_dept_day.cs:488 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), popItem.NickName) | 그리드 값 설정 |  |  |  |

## SCP0033_Shipment_semi_dept_day.SpdMain_KeyPress

진입점: this.spdMain.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c23976d0 | this.spdMain.KeyPress | SCP0033_Shipment_semi_dept_day.cs:442 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-79de049e | this.spdMain.KeyPress | SCP0033_Shipment_semi_dept_day.cs:444 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0033_Shipment_semi_dept_day.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fde5188 | spdMain.TopChange | SCP0033_Shipment_semi_dept_day.cs:116 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

