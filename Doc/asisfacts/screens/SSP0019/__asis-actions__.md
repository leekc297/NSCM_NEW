# AS-IS 액션 대조표 — SSP0019

> 원천: `Doc/asisfacts/screens/SSP0019/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 102행 · 메서드 15 · 종류 DATA_OP 21 · FLAG 14 · UI_PROP 10 · COMBO_DATA 10 · GRID_INIT 8 · POPUP 7 · LIST_REBIND 6 · RETURN 5 · ENDPOINT 5 · UI_MISC 4 · CALL_EXT 3 · VALUE_SET 2 · VALIDATE 2 · GRID_STYLE 2 · GRID_BIND 1 · GRID_LOCK 1 · GRID_SET 1 · ⚠ 의미 확인 필요 3


## SSP0019_ShipmentChangeHistory.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1573bd08 | this.btnItemId.Click | SSP0019_ShipmentChangeHistory.cs:221 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-97e43bd6 | this.btnItemId.Click | SSP0019_ShipmentChangeHistory.cs:223 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a41eddb8 | this.btnItemId.Click | SSP0019_ShipmentChangeHistory.cs:224 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-68a7817d | this.btnItemId.Click | SSP0019_ShipmentChangeHistory.cs:225 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-283f98a2 | this.btnItemId.Click | SSP0019_ShipmentChangeHistory.cs:231 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0019_ShipmentChangeHistory.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a866e06e | this.Load | SSP0019_ShipmentChangeHistory.cs:318 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7d345c90 | this.Load | SSP0019_ShipmentChangeHistory.cs:319 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-509053d7 | this.Load | SSP0019_ShipmentChangeHistory.cs:321 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0019_ShipmentChangeHistory.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04cbb836 | this.Load | SSP0019_ShipmentChangeHistory.cs:248 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-739d0d3b | this.Load | SSP0019_ShipmentChangeHistory.cs:250 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-977dace3 | this.Load | SSP0019_ShipmentChangeHistory.cs:251 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-e8b7d976 | this.Load | SSP0019_ShipmentChangeHistory.cs:252 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0019_ShipmentChangeHistory.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fd635e2 | Dispose | SSP0019_ShipmentChangeHistory.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0019_ShipmentChangeHistory.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-688ab677 | FindButton | SSP0019_ShipmentChangeHistory.cs:376 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5596fc60 | FindButton | SSP0019_ShipmentChangeHistory.cs:380 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-f1d5500c | FindButton | SSP0019_ShipmentChangeHistory.cs:380 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6b7b9c9 | FindButton | SSP0019_ShipmentChangeHistory.cs:383 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2e0322d9 | FindButton | SSP0019_ShipmentChangeHistory.cs:404 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-90a6680b | FindButton | SSP0019_ShipmentChangeHistory.cs:405 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a6a2f579 | FindButton | SSP0019_ShipmentChangeHistory.cs:409 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY") ⇒ SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY | 엔드포인트 요청 생성 |  |  |  |
| AC-7f2d1871 | FindButton | SSP0019_ShipmentChangeHistory.cs:410 | try ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6eab962b | FindButton | SSP0019_ShipmentChangeHistory.cs:411 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-13a5ba41 | FindButton | SSP0019_ShipmentChangeHistory.cs:412 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-6df88fa2 | FindButton | SSP0019_ShipmentChangeHistory.cs:413 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-7944f4ec | FindButton | SSP0019_ShipmentChangeHistory.cs:414 | try ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-1027011d | FindButton | SSP0019_ShipmentChangeHistory.cs:416 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1bba835c | FindButton | SSP0019_ShipmentChangeHistory.cs:417 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-be885035 | FindButton | SSP0019_ShipmentChangeHistory.cs:418 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e7d7e392 | FindButton | SSP0019_ShipmentChangeHistory.cs:419 | try ▸ lambda | DATA_OP | request.Parameters["p_sono"] | p_sono | 행/컬럼 값 대입 |  |  |  |
| AC-37b16fb9 | FindButton | SSP0019_ShipmentChangeHistory.cs:420 | try ▸ lambda | DATA_OP | request.Parameters["p_trans_mode"] | p_trans_mode | 행/컬럼 값 대입 |  |  |  |
| AC-7ada5ab2 | FindButton | SSP0019_ShipmentChangeHistory.cs:422 | try ▸ lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-b618504b | FindButton | SSP0019_ShipmentChangeHistory.cs:423 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-7ac61243 | FindButton | SSP0019_ShipmentChangeHistory.cs:424 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-5a07e103 | FindButton | SSP0019_ShipmentChangeHistory.cs:426 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-474cac91 | FindButton | SSP0019_ShipmentChangeHistory.cs:428 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a4eabed4 | FindButton | SSP0019_ShipmentChangeHistory.cs:437 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3c72303c | FindButton | SSP0019_ShipmentChangeHistory.cs:438 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1524f8e9 | FindButton | SSP0019_ShipmentChangeHistory.cs:440 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-91735b30 | FindButton | SSP0019_ShipmentChangeHistory.cs:443 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-778318a9 | FindButton | SSP0019_ShipmentChangeHistory.cs:456 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0019_ShipmentChangeHistory.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdfc072a | this.Load | SSP0019_ShipmentChangeHistory.cs:144 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0019_ShipmentChangeHistory.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f499ac63 | this.Load | SSP0019_ShipmentChangeHistory.cs:522 |  | ENDPOINT | new FoxDataRequest | ("SCP.GET_DATE_RANGE_1MONTH") ⇒ SCP.GET_DATE_RANGE_1MONTH | 엔드포인트 요청 생성 |  |  |  |
| AC-ed4b1e2c | this.Load | SSP0019_ShipmentChangeHistory.cs:524 |  | DATA_OP | request.Parameters["p_from_date"] | sFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-80448721 | this.Load | SSP0019_ShipmentChangeHistory.cs:525 |  | DATA_OP | request.Parameters["p_offset_day"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-02250a9c | this.Load | SSP0019_ShipmentChangeHistory.cs:526 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-f5e81511 | this.Load | SSP0019_ShipmentChangeHistory.cs:527 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b15db8d5 | this.Load | SSP0019_ShipmentChangeHistory.cs:530 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0019_ShipmentChangeHistory.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe505592 | this.Load | SSP0019_ShipmentChangeHistory.cs:265 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c6e4c782 | this.Load | SSP0019_ShipmentChangeHistory.cs:268 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-c08047c4 | this.Load | SSP0019_ShipmentChangeHistory.cs:271 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-81dd542e | this.Load | SSP0019_ShipmentChangeHistory.cs:273 |  | FLAG | dtMyDivision | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-182052a7 | this.Load | SSP0019_ShipmentChangeHistory.cs:273 |  | DATA_OP | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6538f654 | this.Load | SSP0019_ShipmentChangeHistory.cs:273 |  | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-32c0f56d | this.Load | SSP0019_ShipmentChangeHistory.cs:275 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-8d7995ee | this.Load | SSP0019_ShipmentChangeHistory.cs:284 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange("") | 컨트롤 값 설정 |  |  |  |
| AC-bc7c646b | this.Load | SSP0019_ShipmentChangeHistory.cs:286 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |

## SSP0019_ShipmentChangeHistory.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0cb840f | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:330 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-477dbf7b | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:332 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-e646a1f6 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:334 | if (spdInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("CHANGE_REASON_CODE_ALL", dtChangeReasonCode) | 목록 컨트롤 재구성 |  |  |  |
| AC-305677e8 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:336 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.Freeze | (0, spdInfo.GetColumnIndex(DefColumns.CONFIRM_ID) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1562e4e6 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:338 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-42c3643a | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:339 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.REQUEST_NO)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0019_ShipmentChangeHistory.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-448c68d9 | this.Load | SSP0019_ShipmentChangeHistory.cs:163 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b8eeaf92 | this.Load | SSP0019_ShipmentChangeHistory.cs:164 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c05aaa4e | this.Load | SSP0019_ShipmentChangeHistory.cs:170 | switch (triggerControl) case "MyDivision": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b7f1ea3f | this.Load | SSP0019_ShipmentChangeHistory.cs:170 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-285c4289 | this.Load | SSP0019_ShipmentChangeHistory.cs:175 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | FLAG | dtShipmentInputPeriod | DataService.GetSSPInnerTable("SHIPMENT_PERIOD_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f9cf0a8 | this.Load | SSP0019_ShipmentChangeHistory.cs:175 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("SHIPMENT_PERIOD_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-658a2163 | this.Load | SSP0019_ShipmentChangeHistory.cs:180 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | FLAG | dtChangeReasonCode | DataService.GetSSPInnerTable("CHANGE_REASON_CODE_ALL", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdb20d5c | this.Load | SSP0019_ShipmentChangeHistory.cs:180 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0019_ShipmentChangeHistory.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c93e864c | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:295 |  | DATA_OP | pDivisionID.Contains | ("EE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9e5845ec | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:297 | if (!pDivisionID.Contains("EE")) | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-52072b57 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:297 | if (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d482132 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:298 | if (!pDivisionID.Contains("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.SSPToSiteByDivision, false, clbDivision.ControlValues, UserI… | 화면 필드/플래그 변경 |  |  |  |
| AC-2397f016 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:298 | if (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPToSiteByDivision, false, clbDivision.ControlValues, UserInfoContext.Curr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5b07793e | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:302 | else of (!pDivisionID.Contains("EE")) | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-2714e635 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:302 | else of (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-04f1345d | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:303 | else of (!pDivisionID.Contains("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-3b4e1f87 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:303 | else of (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Current["NowGroupID… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-470a2045 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:306 |  | FLAG | dtInconterms | Data_SCP.Common(Data_SCP.Type.ssp0019_Incoterms, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-f403656b | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:306 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ssp0019_Incoterms, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d2fd210d | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:307 |  | FLAG | dtTransMode | Data_SCP.Common(Data_SCP.Type.ssp0019_TransportMode, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-45ec4ecb | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:307 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ssp0019_TransportMode, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1d0ccae0 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:309 |  | LIST_REBIND | clsCtrl.setListBox | (dtInconterms, clbIncomterms, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e4c0c7e0 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:310 |  | LIST_REBIND | clsCtrl.setListBox | (dtTransMode, clbTransportMode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5d2a6d86 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:311 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0e4f5fb0 | this.Load 외 1 | SSP0019_ShipmentChangeHistory.cs:312 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0019_ShipmentChangeHistory.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55b70c58 | (진입점 미연결) | SSP0019_ShipmentChangeHistory.cs:500 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c314e35 | (진입점 미연결) | SSP0019_ShipmentChangeHistory.cs:503 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-922acdbc | (진입점 미연결) | SSP0019_ShipmentChangeHistory.cs:507 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-599def90 | (진입점 미연결) | SSP0019_ShipmentChangeHistory.cs:508 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0019_ShipmentChangeHistory.SetCheckRow

진입점: chkCurrent.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68cd6717 | chkCurrent.CheckedChanged 외 1 | SSP0019_ShipmentChangeHistory.cs:471 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (chkCurrent.Checked == true) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(i, siMa… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.SEQ), i, siMain.GetMaxColumnIndex(), Color.FromArgb(8… | 그리드 표시 설정 |  |  |  |
| AC-4602c7d1 | chkCurrent.CheckedChanged 외 1 | SSP0019_ShipmentChangeHistory.cs:472 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (chkCurrent.Checked == true) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(i, siMa… | CALL_EXT | siMain.VisibleRow | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b97ef31b | chkCurrent.CheckedChanged 외 1 | SSP0019_ShipmentChangeHistory.cs:476 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (chkCurrent.Checked == true) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.GetValue(i,… | CALL_EXT | siMain.VisibleRow | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2cb319c | chkCurrent.CheckedChanged 외 1 | SSP0019_ShipmentChangeHistory.cs:482 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (chkCurrent.Checked == true) | CALL_EXT | siMain.VisibleRow | (0, siMain.ActiveSheet.RowCount - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4c68919 | chkCurrent.CheckedChanged 외 1 | SSP0019_ShipmentChangeHistory.cs:487 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (chkCurrent.Checked == true) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(i,… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.SEQ), i, siMain.GetMaxColumnIndex(), Color.FromArgb(8… | 그리드 표시 설정 |  |  |  |

## SSP0019_ShipmentChangeHistory.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7eaafc47 | spdMain.CellClick | SSP0019_ShipmentChangeHistory.cs:205 | if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_NO)) ▸ if (string.IsNullOrWhiteSpace(sRequestNo)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c60e871f | spdMain.CellClick | SSP0019_ShipmentChangeHistory.cs:207 | if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_NO)) | POPUP | new SCM0002_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4977064a | spdMain.CellClick | SSP0019_ShipmentChangeHistory.cs:208 | if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_NO)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-51326eb1 | spdMain.CellClick | SSP0019_ShipmentChangeHistory.cs:209 | if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_NO)) | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-8ec19f5d | spdMain.CellClick | SSP0019_ShipmentChangeHistory.cs:210 | if (e.Column == siMain.GetColumnIndex(DefColumns.REQUEST_NO)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0019_ShipmentChangeHistory.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-482fd3d7 | spdMain.TopChange | SSP0019_ShipmentChangeHistory.cs:536 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

