# AS-IS 액션 대조표 — SCP0040

> 원천: `Doc/asisfacts/screens/SCP0040/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 68행 · 메서드 13 · 종류 DATA_OP 14 · RETURN 6 · UI_MISC 6 · ENDPOINT 6 · POPUP 5 · UI_PROP 5 · MESSAGE 5 · GRID_LOCK 5 · GRID_INIT 4 · FLAG 4 · VALIDATE 3 · LIST_REBIND 2 · VALUE_SET 1 · GRID_BIND 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 0


## SCP0040_CharacteristicCapacity.BtnItemId_Click

진입점: btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9aad94a9 | btnItemId.Click | SCP0040_CharacteristicCapacity.cs:218 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d10c171c | btnItemId.Click | SCP0040_CharacteristicCapacity.cs:220 |  | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-43366d00 | btnItemId.Click | SCP0040_CharacteristicCapacity.cs:221 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8043b2b6 | btnItemId.Click | SCP0040_CharacteristicCapacity.cs:222 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-81750d77 | btnItemId.Click | SCP0040_CharacteristicCapacity.cs:228 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0040_CharacteristicCapacity.checkValidN

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02b36dd7 | (진입점 미연결) | SCP0040_CharacteristicCapacity.cs:453 | for (idx<sPlant.Length) | DATA_OP | valiList.Contains | (sPlant[idx]) | 데이터 객체 조작/조회 |  |  |  |
| AC-77aefd98 | (진입점 미연결) | SCP0040_CharacteristicCapacity.cs:455 | for (idx<sPlant.Length) ▸ if (!valiList.Contains(sPlant[idx])) | DATA_OP | valiList.Add | (sPlant[idx]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba936a8b | (진입점 미연결) | SCP0040_CharacteristicCapacity.cs:495 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00258", new object[] { msgPlantId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd20f86f | (진입점 미연결) | SCP0040_CharacteristicCapacity.cs:498 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0040_CharacteristicCapacity.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea875001 | this.Load | SCP0040_CharacteristicCapacity.cs:136 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8aaf5560 | this.Load | SCP0040_CharacteristicCapacity.cs:137 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d9832dd1 | this.Load | SCP0040_CharacteristicCapacity.cs:138 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0040_CharacteristicCapacity.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d375f27c | this.Load | SCP0040_CharacteristicCapacity.cs:117 |  | UI_PROP | usrConditionPanel1.Height | 48 | 속성 Height 설정 |  |  |  |

## SCP0040_CharacteristicCapacity.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d31355e5 | Dispose | SCP0040_CharacteristicCapacity.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0040_CharacteristicCapacity.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c8af414 | EditButton | SCP0040_CharacteristicCapacity.cs:255 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36f9ecb5 | EditButton | SCP0040_CharacteristicCapacity.cs:256 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea93c4f1 | EditButton | SCP0040_CharacteristicCapacity.cs:261 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7fcf2794 | EditButton | SCP0040_CharacteristicCapacity.cs:262 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-42ed46bd | EditButton | SCP0040_CharacteristicCapacity.cs:270 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ if (siMain.ActiveSheet.RowCount>0 && this.IsEditMode) ▸ … | GRID_LOCK | siMain.LockRange | (i, 1, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e61e3160 | EditButton | SCP0040_CharacteristicCapacity.cs:280 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | ( 0 , siMain.GetColumnIndex(DefMain.ITEM_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-51dc520c | EditButton | SCP0040_CharacteristicCapacity.cs:281 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DAILY_CAPA_QTY_FP), siMain.GetColumnIndex(DefMain.LAST_UPDA… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0040_CharacteristicCapacity.FindData_Main

진입점: FindButton / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccb7bae3 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:366 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-9a338b1d | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:366 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe29c022 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:384 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-dd030a96 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:386 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-71b59608 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:391 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-17a24e19 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:393 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_MASTER… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2fedb6e1 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:395 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0040_GET_CHARACTERISTIC_CAPA") ⇒ SCP.SCP0040_GET_CHARACTERISTIC_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-88440327 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:396 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c546b64e | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:397 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-334ac87d | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:398 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-ebd2f1c1 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:399 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-377ebf49 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:401 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac83595a | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:402 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7fa6bb88 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:409 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-10dae63a | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:410 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8301de7d | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:413 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-52672c1d | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:418 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fc288493 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:420 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62878256 | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:422 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2b3368fc | FindButton 외 1 | SCP0040_CharacteristicCapacity.cs:423 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0040_CharacteristicCapacity.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26cda9ba | this.Load | SCP0040_CharacteristicCapacity.cs:104 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0040_CharacteristicCapacity.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b59cfcdc | this.Load | SCP0040_CharacteristicCapacity.cs:123 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-7bf8b58c | this.Load | SCP0040_CharacteristicCapacity.cs:125 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6cbd3a7a | this.Load | SCP0040_CharacteristicCapacity.cs:126 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4c07c646 | this.Load | SCP0040_CharacteristicCapacity.cs:130 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |

## SCP0040_CharacteristicCapacity.InitSpread

진입점: this.Load / FindButton / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6823409e | this.Load 외 2 | SCP0040_CharacteristicCapacity.cs:202 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a0c88aaa | this.Load 외 2 | SCP0040_CharacteristicCapacity.cs:203 |  | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefMain.DAILY_CAPA_QTY), 0, 0, 100000000) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0040_CharacteristicCapacity.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89ebe5d9 | SaveButton | SCP0040_CharacteristicCapacity.cs:288 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0040_CharacteristicCapacity.SaveData

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c57fcbf | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:324 | if (iCount > 0) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-63e64d1c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:324 | if (iCount > 0) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32b97ea5 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:329 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA") ⇒ SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-7067e32a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:331 | if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9572a9b0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:333 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-84eec1e4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:335 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-bb6665f9 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:336 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-93c7f050 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:337 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a5d469dc | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:338 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-520ba6b2 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:339 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_daily_capa_qty"] | p_daily_capa_qty | 행/컬럼 값 대입 |  |  |  |
| AC-2301f64a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:340 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-b60078ae | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:341 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-c80f9e24 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:342 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-b60638b8 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:343 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-071cc5f4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:343 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-417fea67 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0040_CharacteristicCapacity.cs:348 | if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0040_CharacteristicCapacity.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dd53a62 | this.Load 외 1 | SCP0040_CharacteristicCapacity.cs:360 |  | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.AllPlantByOperation, false, division, "A") | 화면 필드/플래그 변경 |  |  |  |
| AC-2e5325e3 | this.Load 외 1 | SCP0040_CharacteristicCapacity.cs:360 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.AllPlantByOperation, false, division, "A") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89564967 | this.Load 외 1 | SCP0040_CharacteristicCapacity.cs:361 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, false) | 목록 컨트롤 재구성 |  |  |  |

