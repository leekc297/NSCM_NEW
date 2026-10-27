# AS-IS 액션 대조표 — SCP0026

> 원천: `Doc/asisfacts/screens/SCP0026/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 64행 · 메서드 10 · 종류 DATA_OP 14 · GRID_INIT 9 · ENDPOINT 6 · POPUP 5 · GRID_LOCK 5 · FLAG 4 · UI_MISC 4 · RETURN 4 · UI_PROP 3 · MESSAGE 3 · VALIDATE 2 · LIST_REBIND 2 · VALUE_SET 1 · GRID_BIND 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 0


## SCP0026_DemandGrouping.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ae36a3e | this.btnItemId.Click | SCP0026_DemandGrouping.cs:243 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8ef0a221 | this.btnItemId.Click | SCP0026_DemandGrouping.cs:245 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-fc0a8402 | this.btnItemId.Click | SCP0026_DemandGrouping.cs:246 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4b0f6874 | this.btnItemId.Click | SCP0026_DemandGrouping.cs:247 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ff2c501a | this.btnItemId.Click | SCP0026_DemandGrouping.cs:253 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0026_DemandGrouping.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af8f4bd2 | this.Load | SCP0026_DemandGrouping.cs:159 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8dee8706 | this.Load | SCP0026_DemandGrouping.cs:160 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-91986b78 | this.Load | SCP0026_DemandGrouping.cs:162 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0026_DemandGrouping.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78ae8107 | Dispose | SCP0026_DemandGrouping.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0026_DemandGrouping.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a93b7d49 | EditButton | SCP0026_DemandGrouping.cs:219 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0b435fcb | EditButton | SCP0026_DemandGrouping.cs:220 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-0f78a4bf | EditButton | SCP0026_DemandGrouping.cs:221 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (0, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c72dfa4e | EditButton | SCP0026_DemandGrouping.cs:222 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.FLOW_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d263fd0e | EditButton | SCP0026_DemandGrouping.cs:223 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0026_DemandGrouping.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97c64c38 | FindButton 외 1 | SCP0026_DemandGrouping.cs:273 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f533fb4a | FindButton 외 1 | SCP0026_DemandGrouping.cs:277 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-9ecd24a0 | FindButton 외 1 | SCP0026_DemandGrouping.cs:277 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d707d203 | FindButton 외 1 | SCP0026_DemandGrouping.cs:281 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5b949dfa | FindButton 외 1 | SCP0026_DemandGrouping.cs:294 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ba693667 | FindButton 외 1 | SCP0026_DemandGrouping.cs:295 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SCP.Maste… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4fbc92e1 | FindButton 외 1 | SCP0026_DemandGrouping.cs:299 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0026_GET_DEMAND_GROUPING") ⇒ SCP.SCP0026_GET_DEMAND_GROUPING | 엔드포인트 요청 생성 |  |  |  |
| AC-4c7d9d29 | FindButton 외 1 | SCP0026_DemandGrouping.cs:300 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6edac01d | FindButton 외 1 | SCP0026_DemandGrouping.cs:301 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8940583c | FindButton 외 1 | SCP0026_DemandGrouping.cs:302 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-66383b84 | FindButton 외 1 | SCP0026_DemandGrouping.cs:303 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3dac6e44 | FindButton 외 1 | SCP0026_DemandGrouping.cs:305 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5b9cbf9e | FindButton 외 1 | SCP0026_DemandGrouping.cs:306 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c6d5c694 | FindButton 외 1 | SCP0026_DemandGrouping.cs:313 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2e8217bc | FindButton 외 1 | SCP0026_DemandGrouping.cs:314 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-91fb0f32 | FindButton 외 1 | SCP0026_DemandGrouping.cs:315 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-98860da2 | FindButton 외 1 | SCP0026_DemandGrouping.cs:317 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3fac2d74 | FindButton 외 1 | SCP0026_DemandGrouping.cs:325 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0026_DemandGrouping.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-044d87bb | this.Load | SCP0026_DemandGrouping.cs:113 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0026_DemandGrouping.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a247bc2c | this.Load | SCP0026_DemandGrouping.cs:141 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-7cb811dc | this.Load | SCP0026_DemandGrouping.cs:144 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4df72685 | this.Load | SCP0026_DemandGrouping.cs:147 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9d024cfe | this.Load | SCP0026_DemandGrouping.cs:149 |  | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-8eb2b4b6 | this.Load | SCP0026_DemandGrouping.cs:149 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-224a9124 | this.Load | SCP0026_DemandGrouping.cs:150 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0026_DemandGrouping.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18f4edfb | this.Load 외 2 | SCP0026_DemandGrouping.cs:170 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-0ecbd8a3 | this.Load 외 2 | SCP0026_DemandGrouping.cs:172 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-263d6499 | this.Load 외 2 | SCP0026_DemandGrouping.cs:173 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.DEMAND_GROUPING_DAYS), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7ca72f40 | this.Load 외 2 | SCP0026_DemandGrouping.cs:176 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a1e7e9df | this.Load 외 2 | SCP0026_DemandGrouping.cs:177 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0026_DemandGrouping.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68e8e8f7 | SaveButton | SCP0026_DemandGrouping.cs:379 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!dayChk) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19a416a1 | SaveButton | SCP0026_DemandGrouping.cs:380 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!dayChk) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb80abca | SaveButton | SCP0026_DemandGrouping.cs:386 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0026_SAVE_DEMAND_GROUPING") ⇒ SCP.SCP0026_SAVE_DEMAND_GROUPING | 엔드포인트 요청 생성 |  |  |  |
| AC-e73a6872 | SaveButton | SCP0026_DemandGrouping.cs:388 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-89e48d22 | SaveButton | SCP0026_DemandGrouping.cs:391 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b9a0b48a | SaveButton | SCP0026_DemandGrouping.cs:392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-07fec91d | SaveButton | SCP0026_DemandGrouping.cs:393 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-46867b9a | SaveButton | SCP0026_DemandGrouping.cs:394 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-a1d3afea | SaveButton | SCP0026_DemandGrouping.cs:395 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_class"] | p_item_class | 행/컬럼 값 대입 |  |  |  |
| AC-5603fc02 | SaveButton | SCP0026_DemandGrouping.cs:396 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-efaf4963 | SaveButton | SCP0026_DemandGrouping.cs:397 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_group_id"] | p_operation_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa6f0cc6 | SaveButton | SCP0026_DemandGrouping.cs:398 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-80f4260c | SaveButton | SCP0026_DemandGrouping.cs:399 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_flow_id"] | p_flow_id | 행/컬럼 값 대입 |  |  |  |
| AC-ebbfe311 | SaveButton | SCP0026_DemandGrouping.cs:400 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_demand_grouping_days"] | p_demand_grouping_days | 행/컬럼 값 대입 |  |  |  |
| AC-8aad9917 | SaveButton | SCP0026_DemandGrouping.cs:401 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b6387d29 | SaveButton | SCP0026_DemandGrouping.cs:403 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a446fc3b | SaveButton | SCP0026_DemandGrouping.cs:403 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-471ee09f | SaveButton | SCP0026_DemandGrouping.cs:409 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41c49eb7 | SaveButton | SCP0026_DemandGrouping.cs:415 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0026_DemandGrouping.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddf049fb | this.spdMain.TopChange | SCP0026_DemandGrouping.cs:134 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

