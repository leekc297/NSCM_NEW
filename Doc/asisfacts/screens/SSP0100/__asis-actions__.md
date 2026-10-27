# AS-IS 액션 대조표 — SSP0100

> 원천: `Doc/asisfacts/screens/SSP0100/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 95행 · 메서드 15 · 종류 DATA_OP 15 · RETURN 11 · GRID_INIT 10 · POPUP 8 · MESSAGE 6 · FLAG 6 · GRID_LOCK 6 · ENDPOINT 6 · GRID_SET 5 · UI_PROP 4 · UI_MISC 4 · VALIDATE 3 · LIST_REBIND 3 · COMBO_DATA 3 · GRID_COMBO 3 · VALUE_SET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SSP0100_LTManagement.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc5c98f9 | this.btnItemId.Click | SSP0100_LTManagement.cs:267 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-eead41b9 | this.btnItemId.Click | SSP0100_LTManagement.cs:269 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f5c1202a | this.btnItemId.Click | SSP0100_LTManagement.cs:270 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9d610fe9 | this.btnItemId.Click | SSP0100_LTManagement.cs:271 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-44c6cb0d | this.btnItemId.Click | SSP0100_LTManagement.cs:277 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0100_LTManagement.checkValidN1

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e564115 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0100_LTManagement.cs:601 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-047a60ae | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0100_LTManagement.cs:604 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SSP0100_LTManagement.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6172ffc6 | this.Load | SSP0100_LTManagement.cs:158 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f0173001 | this.Load | SSP0100_LTManagement.cs:159 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f467a88 | this.Load | SSP0100_LTManagement.cs:161 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0100_LTManagement.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5eff5515 | DeleteButton | SSP0100_LTManagement.cs:212 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30e6d9f6 | DeleteButton | SSP0100_LTManagement.cs:217 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0100_LTManagement.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab09beda | Dispose | SSP0100_LTManagement.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0100_LTManagement.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0166f6e7 | EditButton | SSP0100_LTManagement.cs:244 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-15796294 | EditButton | SSP0100_LTManagement.cs:245 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-35060889 | EditButton | SSP0100_LTManagement.cs:249 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-be3bc309 | EditButton | SSP0100_LTManagement.cs:250 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0100_LTManagement.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-816cc603 | FindButton 외 1 | SSP0100_LTManagement.cs:299 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-caff1dd0 | FindButton 외 1 | SSP0100_LTManagement.cs:303 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-031c4457 | FindButton 외 1 | SSP0100_LTManagement.cs:303 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-071213d0 | FindButton 외 1 | SSP0100_LTManagement.cs:307 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fb290988 | FindButton 외 1 | SSP0100_LTManagement.cs:320 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-81437f5d | FindButton 외 1 | SSP0100_LTManagement.cs:321 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7da71784 | FindButton 외 1 | SSP0100_LTManagement.cs:325 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0100_GET_LT_MANAGEMENT") ⇒ SSP.SSP0100_GET_LT_MANAGEMENT | 엔드포인트 요청 생성 |  |  |  |
| AC-d7b9ffd4 | FindButton 외 1 | SSP0100_LTManagement.cs:326 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6dcf1553 | FindButton 외 1 | SSP0100_LTManagement.cs:327 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-dbfd8ab4 | FindButton 외 1 | SSP0100_LTManagement.cs:328 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-aa3f8cf9 | FindButton 외 1 | SSP0100_LTManagement.cs:329 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8a7a934e | FindButton 외 1 | SSP0100_LTManagement.cs:331 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-36326dbb | FindButton 외 1 | SSP0100_LTManagement.cs:332 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2cb0f051 | FindButton 외 1 | SSP0100_LTManagement.cs:339 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4b662d87 | FindButton 외 1 | SSP0100_LTManagement.cs:340 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3cef3872 | FindButton 외 1 | SSP0100_LTManagement.cs:341 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-145fbc04 | FindButton 외 1 | SSP0100_LTManagement.cs:343 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a8e0de1 | FindButton 외 1 | SSP0100_LTManagement.cs:351 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0100_LTManagement.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5973e777 | this.Load | SSP0100_LTManagement.cs:112 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0100_LTManagement.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dac07845 | this.Load | SSP0100_LTManagement.cs:140 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-c17e74ea | this.Load | SSP0100_LTManagement.cs:143 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c601f14a | this.Load | SSP0100_LTManagement.cs:146 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-25074415 | this.Load | SSP0100_LTManagement.cs:148 |  | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-4695bf94 | this.Load | SSP0100_LTManagement.cs:148 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fda5573b | this.Load | SSP0100_LTManagement.cs:149 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0100_LTManagement.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc204452 | this.Load 외 2 | SSP0100_LTManagement.cs:169 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-37519716 | this.Load 외 2 | SSP0100_LTManagement.cs:171 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-d519614a | this.Load 외 2 | SSP0100_LTManagement.cs:172 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.LT_DAY), 0, 0, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f5cbbcc8 | this.Load 외 2 | SSP0100_LTManagement.cs:175 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b37c5734 | this.Load 외 2 | SSP0100_LTManagement.cs:176 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7c9aa30d | this.Load 외 2 | SSP0100_LTManagement.cs:178 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetReNumerCellType | (siMain, spdInfo.GetColumnIndex(DefColumns.YEILD), 0, 2, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0100_LTManagement.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da665551 | InsertButton | SSP0100_LTManagement.cs:469 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-573c5112 | InsertButton | SSP0100_LTManagement.cs:473 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b4f9cf02 | InsertButton | SSP0100_LTManagement.cs:476 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, pDivisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d749220d | InsertButton | SSP0100_LTManagement.cs:478 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-0a615919 | InsertButton | SSP0100_LTManagement.cs:481 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53c6d413 | InsertButton | SSP0100_LTManagement.cs:482 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0100_LTManagement.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f14cb47c | SaveButton | SSP0100_LTManagement.cs:362 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a244026 | SaveButton | SSP0100_LTManagement.cs:363 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-351d6c26 | SaveButton | SSP0100_LTManagement.cs:363 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7f6e370 | SaveButton | SSP0100_LTManagement.cs:377 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN1()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fec8002c | SaveButton | SSP0100_LTManagement.cs:414 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0100_SAVE_LT_MANAGEMENT") ⇒ SSP.SSP0100_SAVE_LT_MANAGEMENT | 엔드포인트 요청 생성 |  |  |  |
| AC-a1076328 | SaveButton | SSP0100_LTManagement.cs:418 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-628bbfe7 | SaveButton | SSP0100_LTManagement.cs:422 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b49e7fcf | SaveButton | SSP0100_LTManagement.cs:423 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-28bba3a0 | SaveButton | SSP0100_LTManagement.cs:424 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-08cb5566 | SaveButton | SSP0100_LTManagement.cs:425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-13216bd7 | SaveButton | SSP0100_LTManagement.cs:426 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_lt_day"] | p_lt_day | 행/컬럼 값 대입 |  |  |  |
| AC-94aa64f7 | SaveButton | SSP0100_LTManagement.cs:427 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_yeild"] | p_yeild | 행/컬럼 값 대입 |  |  |  |
| AC-83d0f89d | SaveButton | SSP0100_LTManagement.cs:428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-3a893bc2 | SaveButton | SSP0100_LTManagement.cs:429 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-73f7b592 | SaveButton | SSP0100_LTManagement.cs:430 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-58a6a75f | SaveButton | SSP0100_LTManagement.cs:433 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-32c48a82 | SaveButton | SSP0100_LTManagement.cs:433 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-e81ea55f | SaveButton | SSP0100_LTManagement.cs:443 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-61cc1788 | SaveButton | SSP0100_LTManagement.cs:452 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0100_LTManagement.SetChangedControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e14c8d48 | this.Load | SSP0100_LTManagement.cs:291 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-65bcb36a | this.Load | SSP0100_LTManagement.cs:291 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf44ee56 | this.Load | SSP0100_LTManagement.cs:292 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0100_LTManagement.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c792aec | spdMain.CellClick | SSP0100_LTManagement.cs:495 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da7db894 | spdMain.CellClick | SSP0100_LTManagement.cs:507 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e05b3b6 | spdMain.CellClick | SSP0100_LTManagement.cs:512 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-ebc817e3 | spdMain.CellClick | SSP0100_LTManagement.cs:516 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | FLAG | dtPlantSiteByDivisionForIns | Data_SCP.Common(Data_SCP.Type.PlantByDivisionOperNonOsp2, false, pDivisionId, "E") | 화면 필드/플래그 변경 |  |  |  |
| AC-f9a95430 | spdMain.CellClick | SSP0100_LTManagement.cs:516 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionOperNonOsp2, false, pDivisionId, "E") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-21fdcf6e | spdMain.CellClick | SSP0100_LTManagement.cs:517 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtPlantSiteByDivisionForIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-31172d0c | spdMain.CellClick | SSP0100_LTManagement.cs:523 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3d776c86 | spdMain.CellClick | SSP0100_LTManagement.cs:524 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), divisionId) | 그리드 값 설정 |  |  |  |
| AC-2f7b873c | spdMain.CellClick | SSP0100_LTManagement.cs:534 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Div" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc680928 | spdMain.CellClick | SSP0100_LTManagement.cs:535 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d740270 | spdMain.CellClick | SSP0100_LTManagement.cs:541 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "From Site" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2445004f | spdMain.CellClick | SSP0100_LTManagement.cs:542 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86bed45a | spdMain.CellClick | SSP0100_LTManagement.cs:554 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | POPUP | new SCM0002_ItembyPlantSitePopup | () | 팝업/폼 생성 |  |  |  |
| AC-2f77d653 | spdMain.CellClick | SSP0100_LTManagement.cs:556 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | POPUP | popItem.Form_Load | (false, "N", sdivision, sScmSite, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-af2685df | spdMain.CellClick | SSP0100_LTManagement.cs:557 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-89356fc3 | spdMain.CellClick | SSP0100_LTManagement.cs:558 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-609f7f2e | spdMain.CellClick | SSP0100_LTManagement.cs:562 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID) | 그리드 값 설정 |  |  |  |
| AC-41de3f61 | spdMain.CellClick | SSP0100_LTManagement.cs:563 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), popItem.NickName) | 그리드 값 설정 |  |  |  |

## SSP0100_LTManagement.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c45d5d5b | this.spdMain.TopChange | SSP0100_LTManagement.cs:133 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

