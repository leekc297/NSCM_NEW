# AS-IS 액션 대조표 — SSP0017

> 원천: `Doc/asisfacts/screens/SSP0017/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 91행 · 메서드 18 · 종류 DATA_OP 15 · UI_PROP 9 · RETURN 9 · POPUP 7 · GRID_INIT 7 · FLAG 7 · ENDPOINT 7 · LIST_REBIND 6 · UI_MISC 4 · COMBO_DATA 4 · GRID_SET 4 · VALUE_SET 2 · MESSAGE 2 · VALIDATE 2 · CALL_EXT 2 · STATE_RESET 1 · GRID_BIND 1 · GRID_LOCK 1 · STATE 1 · ⚠ 의미 확인 필요 2


## SSP0017_InventoryRaw.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-268145b2 | this.btnItemId.Click | SSP0017_InventoryRaw.cs:291 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d5c79650 | this.btnItemId.Click | SSP0017_InventoryRaw.cs:293 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c5d78613 | this.btnItemId.Click | SSP0017_InventoryRaw.cs:294 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4fd82c6d | this.btnItemId.Click | SSP0017_InventoryRaw.cs:295 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e0abead9 | this.btnItemId.Click | SSP0017_InventoryRaw.cs:301 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0017_InventoryRaw.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e314e25d | this.btnMeasure.Click | SSP0017_InventoryRaw.cs:316 | if (fps != null) ▸ else of (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36477b88 | this.btnMeasure.Click | SSP0017_InventoryRaw.cs:317 | if (fps != null) ▸ else of (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c85742a6 | this.btnMeasure.Click | SSP0017_InventoryRaw.cs:322 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3ff2c0c | this.btnMeasure.Click | SSP0017_InventoryRaw.cs:323 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d463b6b6 | this.btnMeasure.Click | SSP0017_InventoryRaw.cs:326 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0001", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-0b3e0a94 | this.btnMeasure.Click | SSP0017_InventoryRaw.cs:327 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ee9f55f3 | this.btnMeasure.Click | SSP0017_InventoryRaw.cs:328 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0367d54e | this.btnMeasure.Click | SSP0017_InventoryRaw.cs:332 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-4a113c2b | this.btnMeasure.Click | SSP0017_InventoryRaw.cs:334 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0017_InventoryRaw.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34f14686 | (진입점 미연결) | SSP0017_InventoryRaw.cs:155 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e36d1d79 | (진입점 미연결) | SSP0017_InventoryRaw.cs:156 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0017_InventoryRaw.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c83fc673 | this.Load | SSP0017_InventoryRaw.cs:188 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ffaf1dad | this.Load | SSP0017_InventoryRaw.cs:189 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a85cb34 | this.Load | SSP0017_InventoryRaw.cs:191 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0017_InventoryRaw.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acb618d5 | this.Load | SSP0017_InventoryRaw.cs:141 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-2a39551d | this.Load | SSP0017_InventoryRaw.cs:143 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-05ca47cf | this.Load | SSP0017_InventoryRaw.cs:144 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-5d21986f | this.Load | SSP0017_InventoryRaw.cs:145 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0017_InventoryRaw.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2065523c | Dispose | SSP0017_InventoryRaw.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0017_InventoryRaw.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d7311b5 | FindButton | SSP0017_InventoryRaw.cs:372 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3d0fd148 | FindButton | SSP0017_InventoryRaw.cs:377 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c5d81184 | FindButton | SSP0017_InventoryRaw.cs:377 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4860f2ea | FindButton | SSP0017_InventoryRaw.cs:380 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-757c35ba | FindButton | SSP0017_InventoryRaw.cs:400 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-496b3619 | FindButton | SSP0017_InventoryRaw.cs:401 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3da23ee | FindButton | SSP0017_InventoryRaw.cs:405 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0017_GET_INVENTORY_RAW") ⇒ SSP.SSP0017_GET_INVENTORY_RAW | 엔드포인트 요청 생성 |  |  |  |
| AC-991733a8 | FindButton | SSP0017_InventoryRaw.cs:407 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9c9fcdb1 | FindButton | SSP0017_InventoryRaw.cs:409 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4db9c905 | FindButton | SSP0017_InventoryRaw.cs:410 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-77c31883 | FindButton | SSP0017_InventoryRaw.cs:411 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-518d16d6 | FindButton | SSP0017_InventoryRaw.cs:412 | try ▸ lambda | DATA_OP | req.Parameters["p_inventory_type"] | p_inventory_type | 행/컬럼 값 대입 |  |  |  |
| AC-b18efe4d | FindButton | SSP0017_InventoryRaw.cs:413 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ea2d964b | FindButton | SSP0017_InventoryRaw.cs:414 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2f6757e | FindButton | SSP0017_InventoryRaw.cs:415 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-e50e006e | FindButton | SSP0017_InventoryRaw.cs:416 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-62eddb54 | FindButton | SSP0017_InventoryRaw.cs:417 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-1507e4c8 | FindButton | SSP0017_InventoryRaw.cs:419 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-194dfbb6 | FindButton | SSP0017_InventoryRaw.cs:420 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3cf52ac2 | FindButton | SSP0017_InventoryRaw.cs:431 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c1d57b89 | FindButton | SSP0017_InventoryRaw.cs:432 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-43a2e152 | FindButton | SSP0017_InventoryRaw.cs:434 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f083795 | FindButton | SSP0017_InventoryRaw.cs:436 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e470df42 | FindButton | SSP0017_InventoryRaw.cs:443 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0017_InventoryRaw.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f09a3d8 | this.Load | SSP0017_InventoryRaw.cs:128 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0017_InventoryRaw.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1570b408 | (진입점 미연결) | SSP0017_InventoryRaw.cs:514 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-72355aa1 | (진입점 미연결) | SSP0017_InventoryRaw.cs:515 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-978dcf49 | (진입점 미연결) | SSP0017_InventoryRaw.cs:516 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-f307839c | (진입점 미연결) | SSP0017_InventoryRaw.cs:517 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-17a60e6e | (진입점 미연결) | SSP0017_InventoryRaw.cs:518 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-da4934ad | (진입점 미연결) | SSP0017_InventoryRaw.cs:521 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0017_InventoryRaw.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53eec87e | (진입점 미연결) | SSP0017_InventoryRaw.cs:478 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d304b2a6 | (진입점 미연결) | SSP0017_InventoryRaw.cs:479 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3aa5bfe2 | (진입점 미연결) | SSP0017_InventoryRaw.cs:482 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0017_InventoryRaw.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-692dc3b3 | (진입점 미연결) | SSP0017_InventoryRaw.cs:494 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0017_InventoryRaw.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e662eb3 | (진입점 미연결) | SSP0017_InventoryRaw.cs:488 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0017_InventoryRaw.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7809a4f | (진입점 미연결) | SSP0017_InventoryRaw.cs:500 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0017_InventoryRaw.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7649567 | this.Load | SSP0017_InventoryRaw.cs:162 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0ac9da4 | this.Load | SSP0017_InventoryRaw.cs:165 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-d11f40fb | this.Load | SSP0017_InventoryRaw.cs:168 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f596a7e | this.Load | SSP0017_InventoryRaw.cs:171 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-5f05d8a0 | this.Load | SSP0017_InventoryRaw.cs:173 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-1ef92122 | this.Load | SSP0017_InventoryRaw.cs:175 |  | VALUE_SET | clbDivision.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-bf4479d2 | this.Load | SSP0017_InventoryRaw.cs:176 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-63bef084 | this.Load | SSP0017_InventoryRaw.cs:179 |  | FLAG | dtInventoryType | Data.Common(Data.Type.LookupCommon, false, "INV_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-274d4ef3 | this.Load | SSP0017_InventoryRaw.cs:179 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "INV_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-de5702eb | this.Load | SSP0017_InventoryRaw.cs:180 |  | LIST_REBIND | clsCtrl.setListBox | (dtInventoryType, cboInventoryType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0017_InventoryRaw.InitSpread

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c3f630e | this.Load 외 2 | SSP0017_InventoryRaw.cs:200 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-54faa4fc | this.Load 외 2 | SSP0017_InventoryRaw.cs:202 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-0dbf03b0 | this.Load 외 2 | SSP0017_InventoryRaw.cs:205 | if (spdInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("OWMS_STOCK_STATUS", dtInventoryStatus) | 목록 컨트롤 재구성 |  |  |  |
| AC-342c826a | this.Load 외 2 | SSP0017_InventoryRaw.cs:207 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0017_InventoryRaw.InitSpreadFooterSum

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77a5ec90 | this.Load 외 2 | SSP0017_InventoryRaw.cs:217 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c56f199c | this.Load 외 2 | SSP0017_InventoryRaw.cs:218 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-d465cfa5 | this.Load 외 2 | SSP0017_InventoryRaw.cs:228 | for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c0e5ee7 | this.Load 외 2 | SSP0017_InventoryRaw.cs:229 | for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b29870c | this.Load 외 2 | SSP0017_InventoryRaw.cs:230 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-75b81b66 | this.Load 외 2 | SSP0017_InventoryRaw.cs:231 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0017_InventoryRaw.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7df6db6 | this.Load 외 1 | SSP0017_InventoryRaw.cs:352 |  | DATA_OP | pDivisionID.Contains | ("EE") | 데이터 객체 조작/조회 |  |  |  |
| AC-720d49b4 | this.Load 외 1 | SSP0017_InventoryRaw.cs:354 | if (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-12d6b010 | this.Load 외 1 | SSP0017_InventoryRaw.cs:354 | if (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d2f7877 | this.Load 외 1 | SSP0017_InventoryRaw.cs:358 | else of (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fd81937 | this.Load 외 1 | SSP0017_InventoryRaw.cs:358 | else of (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6a56ec63 | this.Load 외 1 | SSP0017_InventoryRaw.cs:362 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, this.clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b5320ebd | this.Load 외 1 | SSP0017_InventoryRaw.cs:365 |  | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-0a4b3f30 | this.Load 외 1 | SSP0017_InventoryRaw.cs:365 |  | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c46619a4 | this.Load 외 1 | SSP0017_InventoryRaw.cs:366 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0017_InventoryRaw.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9677539 | spdMain.TopChange | SSP0017_InventoryRaw.cs:255 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

