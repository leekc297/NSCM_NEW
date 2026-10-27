# AS-IS 액션 대조표 — SSP0012

> 원천: `Doc/asisfacts/screens/SSP0012/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 99행 · 메서드 22 · 종류 DATA_OP 16 · UI_PROP 14 · POPUP 11 · RETURN 11 · GRID_INIT 8 · FLAG 8 · ENDPOINT 5 · VALUE_SET 4 · UI_MISC 4 · GRID_SET 4 · LIST_REBIND 3 · VALIDATE 3 · COMBO_DATA 3 · GRID_LOCK 2 · STATE_RESET 1 · MESSAGE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SSP0012_ShipmentPlanConfirmDetail.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73cc994d | this.btnColumn.Click | SSP0012_ShipmentPlanConfirmDetail.cs:607 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0012", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-bd32aa73 | this.btnColumn.Click | SSP0012_ShipmentPlanConfirmDetail.cs:608 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6b86c257 | this.btnColumn.Click | SSP0012_ShipmentPlanConfirmDetail.cs:609 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1eb3bdec | this.btnItemId.Click | SSP0012_ShipmentPlanConfirmDetail.cs:331 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-adeeaad9 | this.btnItemId.Click | SSP0012_ShipmentPlanConfirmDetail.cs:333 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-99b24f87 | this.btnItemId.Click | SSP0012_ShipmentPlanConfirmDetail.cs:334 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e340c678 | this.btnItemId.Click | SSP0012_ShipmentPlanConfirmDetail.cs:335 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8df4d57f | this.btnItemId.Click | SSP0012_ShipmentPlanConfirmDetail.cs:341 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.CboPlanDate_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19998e10 | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:488 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91e0804c | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:220 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ff6dc72b | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:221 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f739edd1 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:253 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-89db7b3f | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:254 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-99822900 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:256 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-896656ee | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:207 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-3359c692 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:209 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-8d2e8ee0 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:210 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-df05ad09 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:211 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f95b8032 | Dispose | SSP0012_ShipmentPlanConfirmDetail.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be88a6fc | EditButton | SSP0012_ShipmentPlanConfirmDetail.cs:316 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7dce3966 | EditButton | SSP0012_ShipmentPlanConfirmDetail.cs:317 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-688eff67 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:386 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-42a7a052 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:390 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-bad8a591 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:390 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3182a187 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:393 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1f887e75 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:394 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-de3a6cfc | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:394 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb3ca382 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:413 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b5c21a1e | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:414 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8a76d1e | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:418 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL") ⇒ SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-669dba29 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:419 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8620a83b | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:420 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-64b3d945 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:421 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-80fd1275 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:422 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2ec37160 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:423 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2ead1d7b | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:424 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8ef7634c | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:425 | try ▸ lambda | DATA_OP | req.Parameters["p_Sold_To_Party"] | p_Sold_To_Party | 행/컬럼 값 대입 |  |  |  |
| AC-68cd1a88 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:426 | try ▸ lambda | DATA_OP | req.Parameters["p_Ship_To_Party"] | p_Ship_To_Party | 행/컬럼 값 대입 |  |  |  |
| AC-b23f772c | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:427 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-e7aada82 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:428 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-28bb6c92 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:430 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-33184248 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:431 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-964d8869 | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:438 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-523e71bd | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:439 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-25e5ad0f | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:441 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-187f446e | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:443 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e000c33c | FindButton | SSP0012_ShipmentPlanConfirmDetail.cs:453 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b2c7aef | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:192 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.GetDayRange

진입점: this.Load / clbDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1a2e977 | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:596 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-3ac1922e | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:597 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-4ef0b561 | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:598 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-ca85e303 | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:599 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-251df2e3 | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:600 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d79f3660 | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:603 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e7d6e2a | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:579 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2be66f4 | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:574 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ee939f6 | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:584 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b50bce9f | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:227 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d79eb263 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:230 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2d4608f | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:233 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-80b96924 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:237 |  | FLAG | dtMyDivision | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-fd0a496e | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:237 |  | DATA_OP | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-479416a8 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:237 |  | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-738997b0 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:239 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-3a43faad | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:243 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-ae548d78 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:246 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-631ebd13 | this.Load | SSP0012_ShipmentPlanConfirmDetail.cs:248 |  | FLAG | dBaseDate | Convert.ToDateTime(drpPeriod.Value2).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.InitSpread

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64a036fe | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:264 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-214b0602 | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:266 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-ad6af4b0 | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:267 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f3aec08 | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:268 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c5fdfc9c | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:270 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INCOTERMS)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3c9e9cec | this.Load 외 2 | SSP0012_ShipmentPlanConfirmDetail.cs:271 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dffc26c3 | this.Load 외 1 | SSP0012_ShipmentPlanConfirmDetail.cs:368 |  | DATA_OP | pDivisionID.Contains | ("EE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c139cd96 | this.Load 외 1 | SSP0012_ShipmentPlanConfirmDetail.cs:370 | if (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-d165de70 | this.Load 외 1 | SSP0012_ShipmentPlanConfirmDetail.cs:370 | if (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23f4450d | this.Load 외 1 | SSP0012_ShipmentPlanConfirmDetail.cs:374 | else of (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-2935ace1 | this.Load 외 1 | SSP0012_ShipmentPlanConfirmDetail.cs:374 | else of (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f53ee35d | this.Load 외 1 | SSP0012_ShipmentPlanConfirmDetail.cs:378 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6e018f97 | this.Load 외 1 | SSP0012_ShipmentPlanConfirmDetail.cs:380 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-475b8dba | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:542 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ddef989b | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:545 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6198d101 | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:549 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-60af48cb | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:550 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba9c5a8f | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:462 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetColumnIndex(DefColumns.INCOTERMS) > -1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-59cecd49 | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:465 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO) > -1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.SetLockSumColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de92ec65 | (진입점 미연결) | SSP0012_ShipmentPlanConfirmDetail.cs:359 | for (iCol <= spreadInfo.GetMaxColumnIndex()) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).Index… | GRID_LOCK | siMain.LockColumn | (iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faa9f2cf | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:505 | if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ebc472a0 | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:519 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) | POPUP | new SCM0002_ShipmentPlanConfirmBODPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ff84d18f | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:520 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-36bc8779 | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:521 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) | UI_PROP | pop._sDivisionID | sDivisionIDPop | 속성 _sDivisionID 설정 |  |  |  |
| AC-485867d7 | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:522 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) | UI_PROP | pop._sBodID | sBodID | 속성 _sBodID 설정 |  |  |  |
| AC-14dbfeaa | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:523 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c9794135 | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:528 | else of (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) ▸ if (s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74824885 | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:530 | else of (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | new SCM0002_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-efcf3658 | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:531 | else of (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7d6c98d4 | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:532 | else of (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-ae5a84c7 | this.spdMain.CellClick | SSP0012_ShipmentPlanConfirmDetail.cs:533 | else of (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0012_ShipmentPlanConfirmDetail.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8468c3d6 | this.spdMain.TopChange | SSP0012_ShipmentPlanConfirmDetail.cs:290 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

