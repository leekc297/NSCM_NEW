# AS-IS 액션 대조표 — SCP0007

> 원천: `Doc/asisfacts/screens/SCP0007/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-26).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 435행 · 메서드 41 · 종류 DATA_OP 88 · GRID_INIT 76 · FLAG 43 · RETURN 36 · GRID_SET 34 · GRID_LOCK 29 · MESSAGE 15 · ENDPOINT 13 · CALL_EXT 12 · UI_PROP 11 · UI_MISC 11 · GRID_COMBO 11 · LIST_REBIND 11 · POPUP 9 · VALUE_SET 9 · GRID_STYLE 9 · STATE 7 · COMBO_DATA 5 · VALIDATE 3 · GRID_BIND 2 · THROW 1 · ⚠ 의미 확인 필요 12


## SCP0007_BOD.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d70f8de7 | this.Load | SCP0007_BOD.cs:262 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8f05afde | this.Load | SCP0007_BOD.cs:263 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ada6aa53 | this.Load | SCP0007_BOD.cs:264 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0007_BOD.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f4d3986 | this.Load | SCP0007_BOD.cs:200 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-03ed0734 | this.Load | SCP0007_BOD.cs:202 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-4947fe92 | this.Load | SCP0007_BOD.cs:203 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-01a99c2f | this.Load | SCP0007_BOD.cs:204 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0007_BOD.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e069c41 | DeleteButton | SCP0007_BOD.cs:362 | if (action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8a76b5a2 | DeleteButton | SCP0007_BOD.cs:364 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0007_BOD.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88236e4d | Dispose | SCP0007_BOD.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0007_BOD.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3379a15d | EditButton | SCP0007_BOD.cs:443 | if (boolEditChange == true) | FLAG | boolEditChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a6473f82 | EditButton | SCP0007_BOD.cs:447 | else of (boolEditChange == true) | FLAG | boolEditChange | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b957d92f | EditButton | SCP0007_BOD.cs:450 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c2de26c6 | EditButton | SCP0007_BOD.cs:451 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-be296dd3 | EditButton | SCP0007_BOD.cs:453 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.INCOTERMS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9075c19c | EditButton | SCP0007_BOD.cs:454 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ROUTE_CNT), siMain.GetColumnIndex(DefColumns.TRANSPORT_M… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb485b40 | EditButton | SCP0007_BOD.cs:455 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LT_TYPE), siMain.GetColumnIndex(DefColumns.BOD_ID), true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-687bbf18 | EditButton | SCP0007_BOD.cs:456 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ROUTE_VALID), siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-edf17d07 | EditButton | SCP0007_BOD.cs:462 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.VMI_YN)).ToString() != "Y") | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK), i, siMain.GetColumnIndex(DefColumns.SA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-056b0ad1 | EditButton | SCP0007_BOD.cs:473 | for (i < siMain.ActiveSheet.RowCount) | DATA_OP | dtCountryCity.Select | ("SCM_SITE_ID = '" + strTO_SITE_CODE + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-b02e9933 | EditButton | SCP0007_BOD.cs:482 | for (i < siMain.ActiveSheet.RowCount) ▸ if (drsTo.Length > 0) ▸ if (strTO_SITE_TYPE == "PLANT") ▸ if (boolEditChange == true) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), i, siMain.GetColumnIndex(DefColumns.I… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8769cec5 | EditButton | SCP0007_BOD.cs:484 | for (i < siMain.ActiveSheet.RowCount) ▸ if (drsTo.Length > 0) ▸ if (strTO_SITE_TYPE == "PLANT") ▸ if (boolEditChange == true) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), dtIncotermsEdit) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b4163e8f | EditButton | SCP0007_BOD.cs:488 | for (i < siMain.ActiveSheet.RowCount) ▸ if (drsTo.Length > 0) ▸ if (strTO_SITE_TYPE == "PLANT") ▸ else of (boolEditChange == true) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), i, siMain.GetColumnIndex(DefColumns.I… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1ec5c874 | EditButton | SCP0007_BOD.cs:490 | for (i < siMain.ActiveSheet.RowCount) ▸ if (drsTo.Length > 0) ▸ if (strTO_SITE_TYPE == "PLANT") ▸ else of (boolEditChange == true) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), dtIncoterms) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-debe456d | EditButton | SCP0007_BOD.cs:496 | for (i < siMain.ActiveSheet.RowCount) ▸ if (drsTo.Length > 0) ▸ else of (strTO_SITE_TYPE == "PLANT") | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), i, siMain.GetColumnIndex(DefColumns.I… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0007_BOD.FindData_Main

진입점: FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4266249a | FindButton 외 1 | SCP0007_BOD.cs:510 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2da40957 | FindButton 외 1 | SCP0007_BOD.cs:513 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-fa0f73eb | FindButton 외 1 | SCP0007_BOD.cs:513 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2fd4bcf | FindButton 외 1 | SCP0007_BOD.cs:522 | try | FLAG | dtCustomer | DBUtils.Filter(dtCustomerAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7628b782 | FindButton 외 1 | SCP0007_BOD.cs:522 | try | DATA_OP | DBUtils.Filter | (dtCustomerAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1799cc97 | FindButton 외 1 | SCP0007_BOD.cs:524 | try | FLAG | dtFromSiteOfSpd | DBUtils.Filter(dtFromSiteOfSpdAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-631a2e60 | FindButton 외 1 | SCP0007_BOD.cs:524 | try | DATA_OP | DBUtils.Filter | (dtFromSiteOfSpdAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8ae633a6 | FindButton 외 1 | SCP0007_BOD.cs:526 | try | FLAG | dtToSiteOfSpd | DBUtils.Filter(dtToSiteOfSpdAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c9e7cd55 | FindButton 외 1 | SCP0007_BOD.cs:526 | try | DATA_OP | DBUtils.Filter | (dtToSiteOfSpdAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-32f11af0 | FindButton 외 1 | SCP0007_BOD.cs:540 | try | FLAG | strSel_InputStatus | p_input_status.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-392b81be | FindButton 외 1 | SCP0007_BOD.cs:541 | try | FLAG | strSel_Division | division.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bd062382 | FindButton 외 1 | SCP0007_BOD.cs:547 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2d6e8d94 | FindButton 외 1 | SCP0007_BOD.cs:548 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-812bb050 | FindButton 외 1 | SCP0007_BOD.cs:549 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f4482e5f | FindButton 외 1 | SCP0007_BOD.cs:553 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0007_GET_BOD") ⇒ SCP.SCP0007_GET_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-f6ea2de7 | FindButton 외 1 | SCP0007_BOD.cs:554 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2bdbd4d5 | FindButton 외 1 | SCP0007_BOD.cs:555 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-7dc1d141 | FindButton 외 1 | SCP0007_BOD.cs:556 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-0bdab4ea | FindButton 외 1 | SCP0007_BOD.cs:557 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-60038908 | FindButton 외 1 | SCP0007_BOD.cs:558 | try ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-9ca6bdc0 | FindButton 외 1 | SCP0007_BOD.cs:559 | try ▸ lambda | DATA_OP | request.Parameters["p_incoterms_ssp"] | p_incoterms_ssp | 행/컬럼 값 대입 |  |  |  |
| AC-5727907a | FindButton 외 1 | SCP0007_BOD.cs:560 | try ▸ lambda | DATA_OP | request.Parameters["p_trans_mode"] | p_trans_mode | 행/컬럼 값 대입 |  |  |  |
| AC-8c304600 | FindButton 외 1 | SCP0007_BOD.cs:561 | try ▸ lambda | DATA_OP | request.Parameters["p_input_status"] | p_input_status | 행/컬럼 값 대입 |  |  |  |
| AC-14bc35ff | FindButton 외 1 | SCP0007_BOD.cs:562 | try ▸ lambda | DATA_OP | request.Parameters["p_valid"] | p_valid | 행/컬럼 값 대입 |  |  |  |
| AC-de8d87c4 | FindButton 외 1 | SCP0007_BOD.cs:563 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a28f2d7d | FindButton 외 1 | SCP0007_BOD.cs:565 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d785e322 | FindButton 외 1 | SCP0007_BOD.cs:567 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b155aba7 | FindButton 외 1 | SCP0007_BOD.cs:574 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5d798d90 | FindButton 외 1 | SCP0007_BOD.cs:575 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c6d83ca4 | FindButton 외 1 | SCP0007_BOD.cs:578 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-950830c7 | FindButton 외 1 | SCP0007_BOD.cs:582 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-248514f4 | FindButton 외 1 | SCP0007_BOD.cs:586 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9a87b247 | FindButton 외 1 | SCP0007_BOD.cs:590 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-185ca7d4 | FindButton 외 1 | SCP0007_BOD.cs:592 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b46283a0 | FindButton 외 1 | SCP0007_BOD.cs:599 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0007_BOD.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e12c9b5 | this.Load | SCP0007_BOD.cs:162 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0007_BOD.GetData_Country

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0c3edb1 | FindButton | SCP0007_BOD.cs:611 | if (division == null \|\| division == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c066bfda | FindButton | SCP0007_BOD.cs:621 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2258f97a | FindButton | SCP0007_BOD.cs:622 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4c62bf90 | FindButton | SCP0007_BOD.cs:626 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0007_GET_COUNTRY_CITY") ⇒ SCP.SCP0007_GET_COUNTRY_CITY | 엔드포인트 요청 생성 |  |  |  |
| AC-37eb593d | FindButton | SCP0007_BOD.cs:627 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division | 행/컬럼 값 대입 |  |  |  |
| AC-0ca19ab3 | FindButton | SCP0007_BOD.cs:628 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-89e9200f | FindButton | SCP0007_BOD.cs:629 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-b0d52ff9 | FindButton | SCP0007_BOD.cs:631 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9919e8a5 | FindButton | SCP0007_BOD.cs:633 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-31e6abbf | FindButton | SCP0007_BOD.cs:637 |  | FLAG | dtCountryCity | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0007_BOD.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2314c6ff | this.Load | SCP0007_BOD.cs:213 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-891c5b49 | this.Load | SCP0007_BOD.cs:215 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ef35ad0 | this.Load | SCP0007_BOD.cs:217 |  | FLAG | dtInputStatus | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-ef0eb373 | this.Load | SCP0007_BOD.cs:218 |  | DATA_OP | dtInputStatus.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f6618c3 | this.Load | SCP0007_BOD.cs:219 |  | DATA_OP | dtInputStatus.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e01a894 | this.Load | SCP0007_BOD.cs:220 |  | DATA_OP | dtInputStatus.Rows.Add | (new String[] { "R", "Required" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-722a7350 | this.Load | SCP0007_BOD.cs:221 |  | DATA_OP | dtInputStatus.Rows.Add | (new String[] { "C", "Completed" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac7e8e2a | this.Load | SCP0007_BOD.cs:222 |  | LIST_REBIND | clsCtrl.setListBox | (dtInputStatus, cboInputStatus, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3d19d854 | this.Load | SCP0007_BOD.cs:223 |  | VALUE_SET | cboInputStatus.SelectedValue | "C" | 컨트롤 값 설정 |  |  |  |
| AC-d0f6cf2d | this.Load | SCP0007_BOD.cs:225 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-cb1ea213 | this.Load | SCP0007_BOD.cs:226 |  | LIST_REBIND | clsCtrl.setListBox | (dtIncoterms, clbIncoterms, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e423b8e5 | this.Load | SCP0007_BOD.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtIncoterms, clbIncotermsSSP, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a4d376f5 | this.Load | SCP0007_BOD.cs:228 |  | LIST_REBIND | clsCtrl.setListBox | (dtTransMode, clbTransMode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a1ed21dd | this.Load | SCP0007_BOD.cs:229 |  | LIST_REBIND | clsCtrl.setListBox | (dtValidYN, cboValidYN, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0007_BOD.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab69cd00 | this.Load 외 2 | SCP0007_BOD.cs:271 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8f6f459c | this.Load 외 2 | SCP0007_BOD.cs:273 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("FromSiteByDivision", dtFromSiteOfSpd) | 목록 컨트롤 재구성 |  |  |  |
| AC-686978ca | this.Load 외 2 | SCP0007_BOD.cs:274 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ToSiteByDivision", dtToSiteOfSpd) | 목록 컨트롤 재구성 |  |  |  |
| AC-978b81d9 | this.Load 외 2 | SCP0007_BOD.cs:275 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-505544e9 | this.Load 외 2 | SCP0007_BOD.cs:277 |  | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.ROUTE_ID].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-437feee0 | this.Load 외 2 | SCP0007_BOD.cs:279 |  | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.PRIORITY), 0, 0, 99) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-42031158 | this.Load 외 2 | SCP0007_BOD.cs:280 |  | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK), 0, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1a75c6ca | this.Load 외 2 | SCP0007_BOD.cs:282 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0cbf0003 | this.Load 외 2 | SCP0007_BOD.cs:284 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5c7d490b | this.Load 외 2 | SCP0007_BOD.cs:338 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SAFETY_STOCK)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0007_BOD.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-645e7eb5 | InsertButton | SCP0007_BOD.cs:373 | if (strSel_InputStatus == "R") | MESSAGE | MessageHelper.GMessageBox | ("MSG00159", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4dac0396 | InsertButton | SCP0007_BOD.cs:374 | if (strSel_InputStatus == "R") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c82c3ec2 | InsertButton | SCP0007_BOD.cs:384 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-854fb721 | InsertButton | SCP0007_BOD.cs:387 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-956290bd | InsertButton | SCP0007_BOD.cs:393 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VMI_YN), "N") | 그리드 값 설정 |  |  |  |
| AC-bb41b2fa | InsertButton | SCP0007_BOD.cs:394 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BOD_VALID), "Y") | 그리드 값 설정 |  |  |  |
| AC-2b2a3537 | InsertButton | SCP0007_BOD.cs:395 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BEFORE_LEAD_TIME), 0) | 그리드 값 설정 |  |  |  |
| AC-de6dbc00 | InsertButton | SCP0007_BOD.cs:396 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.AFTER_LEAD_TIME), 0) | 그리드 값 설정 |  |  |  |
| AC-3808e4ca | InsertButton | SCP0007_BOD.cs:397 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD), sYYYYMMDD) | 그리드 값 설정 |  |  |  |
| AC-0c4adbdd | InsertButton | SCP0007_BOD.cs:398 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD), "2099-12-27") | 그리드 값 설정 |  |  |  |
| AC-80de3724 | InsertButton | SCP0007_BOD.cs:410 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), strSel_Division) | 그리드 값 설정 |  |  |  |
| AC-cf14ad88 | InsertButton | SCP0007_BOD.cs:411 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2559252e | InsertButton | SCP0007_BOD.cs:414 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CUSTOMER), siMain.GetColumnIndex(DefColumns.CUS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f5f76e38 | InsertButton | SCP0007_BOD.cs:415 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.FROM_CITY), siMain.GetColumnIndex(DefColumns.FR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-23f7979b | InsertButton | SCP0007_BOD.cs:416 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_CITY), siMain.GetColumnIndex(DefColumns.TO_C… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9bc6050a | InsertButton | SCP0007_BOD.cs:417 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-76bb7cce | InsertButton | SCP0007_BOD.cs:418 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ROUTE_CNT), siMain.GetColumnIndex(DefColumns.RO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b4d2975e | InsertButton | SCP0007_BOD.cs:419 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ROUTE_ID), siMain.GetColumnIndex(DefColumns.BOD… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f03aa6a9 | InsertButton | SCP0007_BOD.cs:420 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ROUTE_VALID), siMain.ActiveSheet.ColumnCount - … | 그리드 편집 잠금/해제 |  |  |  |
| AC-b6a4d64d | InsertButton | SCP0007_BOD.cs:424 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS), dtIncotermsEdit) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7f0aed58 | InsertButton | SCP0007_BOD.cs:425 | else of (strSel_InputStatus == "R") ▸ if (strSel_InputStatus == "C") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMa… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), dtIncotermsEdit) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0007_BOD.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dcf8eb1 | SaveButton | SCP0007_BOD.cs:647 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-011858ee | SaveButton | SCP0007_BOD.cs:677 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-03a40737 | SaveButton | SCP0007_BOD.cs:677 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee3a0828 | SaveButton | SCP0007_BOD.cs:707 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sBef… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "ExFactory(LeadTime) : 0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a4b56b9 | SaveButton | SCP0007_BOD.cs:708 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sBef… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-241d4249 | SaveButton | SCP0007_BOD.cs:713 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sAft… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "Additional Lead Time : 0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a2d7e0e8 | SaveButton | SCP0007_BOD.cs:714 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sAft… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e47b134 | SaveButton | SCP0007_BOD.cs:717 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | Encoding.Default.GetByteCount | (sRemarks) | ⚠ 의미 확인 필요 |  |  |  |
| AC-66e6c45a | SaveButton | SCP0007_BOD.cs:720 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Enco… | MESSAGE | MessageHelper.GMessageBox | ("MSG00165", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-75b80ff0 | SaveButton | SCP0007_BOD.cs:721 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Enco… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8406c3fa | SaveButton | SCP0007_BOD.cs:727 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Conv… | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d35d5da | SaveButton | SCP0007_BOD.cs:728 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Conv… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3ab1498 | SaveButton | SCP0007_BOD.cs:735 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00355", new object[] { "FROM", "Monday" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0f3ea3b | SaveButton | SCP0007_BOD.cs:736 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFr… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD), mondayDate) | 그리드 값 설정 |  |  |  |
| AC-925cae6e | SaveButton | SCP0007_BOD.cs:737 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3976817 | SaveButton | SCP0007_BOD.cs:743 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (dtTo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00355", new object[] { "TO", "Sunday" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7cc2000f | SaveButton | SCP0007_BOD.cs:744 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (dtTo… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD), sundayDate) | 그리드 값 설정 |  |  |  |
| AC-1fa4f23b | SaveButton | SCP0007_BOD.cs:745 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (dtTo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a705fcf7 | SaveButton | SCP0007_BOD.cs:780 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !valid_chk) | MESSAGE | MessageHelper.GMessageBox | ("MSG00253", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6ed18b7 | SaveButton | SCP0007_BOD.cs:781 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !valid_chk) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3df44f3 | SaveButton | SCP0007_BOD.cs:794 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0007_SAVE_BOD") ⇒ SCP.SCP0007_SAVE_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-0b295349 | SaveButton | SCP0007_BOD.cs:798 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b3562c76 | SaveButton | SCP0007_BOD.cs:799 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-282ee9c8 | SaveButton | SCP0007_BOD.cs:800 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d6b3125 | SaveButton | SCP0007_BOD.cs:801 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_code"] | p_customer_code | 행/컬럼 값 대입 |  |  |  |
| AC-37a80dde | SaveButton | SCP0007_BOD.cs:802 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-1c0e5583 | SaveButton | SCP0007_BOD.cs:803 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-fe51387f | SaveButton | SCP0007_BOD.cs:804 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-6b91ce72 | SaveButton | SCP0007_BOD.cs:805 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms_ssp"] | p_incoterms_ssp | 행/컬럼 값 대입 |  |  |  |
| AC-4f3ac0f0 | SaveButton | SCP0007_BOD.cs:806 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-11429ce8 | SaveButton | SCP0007_BOD.cs:807 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_route_id"] | p_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-c9d4646d | SaveButton | SCP0007_BOD.cs:808 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-5e26550f | SaveButton | SCP0007_BOD.cs:809 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_safety_stock"] | p_safety_stock | 행/컬럼 값 대입 |  |  |  |
| AC-8742cbd2 | SaveButton | SCP0007_BOD.cs:811 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_input_status"] | p_input_status | 행/컬럼 값 대입 |  |  |  |
| AC-f19134cd | SaveButton | SCP0007_BOD.cs:812 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_vmi_yn"] | p_vmi_yn | 행/컬럼 값 대입 |  |  |  |
| AC-64c71926 | SaveButton | SCP0007_BOD.cs:813 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-41dc68b9 | SaveButton | SCP0007_BOD.cs:814 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ef07d178 | SaveButton | SCP0007_BOD.cs:815 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_before_lead_time"] | p_before_lead_time | 행/컬럼 값 대입 |  |  |  |
| AC-34ca4855 | SaveButton | SCP0007_BOD.cs:816 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_after_lead_time"] | p_after_lead_time | 행/컬럼 값 대입 |  |  |  |
| AC-94acb4ad | SaveButton | SCP0007_BOD.cs:817 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-2548da36 | SaveButton | SCP0007_BOD.cs:819 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b667da3 | SaveButton | SCP0007_BOD.cs:820 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-aa64775b | SaveButton | SCP0007_BOD.cs:822 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4c69eecf | SaveButton | SCP0007_BOD.cs:827 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e16acd73 | SaveButton | SCP0007_BOD.cs:866 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | (commMsgCode, new object[] { errMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a281a62 | SaveButton | SCP0007_BOD.cs:911 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.INC… | 그리드 표시 설정 |  |  |  |
| AC-e76b5211 | SaveButton | SCP0007_BOD.cs:914 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), i, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-b6d8cf28 | SaveButton | SCP0007_BOD.cs:918 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), i, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-0b390682 | SaveButton | SCP0007_BOD.cs:922 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.PRIORITY), i, siMain.GetColumnIndex(DefColumns.PRIORI… | 그리드 표시 설정 |  |  |  |
| AC-6ea2ed98 | SaveButton | SCP0007_BOD.cs:932 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e9753d5 | SaveButton | SCP0007_BOD.cs:942 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0007_BOD.Set_ValidTextColor

진입점: spdMain.CellDoubleClick [if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try] / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c849e1e3 | spdMain.CellDoubleClick [if (!siMain.IsLock(siMain.SheetName… 외 2 | SCP0007_BOD.cs:981 | for (i < nRowCount) ▸ if (routeValid != null && routeValid == "N") | GRID_STYLE | siMain.SetFGColor | (i, nStartColIdx, i, nEndColIdx, ControlColor.InvalidFGColor) | 그리드 표시 설정 |  |  |  |
| AC-fd2b16a0 | spdMain.CellDoubleClick [if (!siMain.IsLock(siMain.SheetName… 외 2 | SCP0007_BOD.cs:985 | for (i < nRowCount) ▸ else of (routeValid != null && routeValid == "N") | GRID_STYLE | siMain.SetFGColor | (i, nStartColIdx, i, nEndColIdx, ControlColor.DefaultForeColor) | 그리드 표시 설정 |  |  |  |
| AC-1d8d8296 | spdMain.CellDoubleClick [if (!siMain.IsLock(siMain.SheetName… 외 2 | SCP0007_BOD.cs:994 | for (i < nRowCount) ▸ if (nSelRow == -1) ▸ if (srouteChk == "Y") | GRID_STYLE | siMain.SetFGColor | (i, siMain.GetColumnIndex(DefColumns.ROUTE_ID), i, siMain.GetColumnIndex(DefColumns.ROUTE_… | 그리드 표시 설정 |  |  |  |
| AC-a219cb20 | spdMain.CellDoubleClick [if (!siMain.IsLock(siMain.SheetName… 외 2 | SCP0007_BOD.cs:996 | for (i < nRowCount) ▸ if (nSelRow == -1) ▸ else of (srouteChk == "Y") | GRID_STYLE | siMain.SetFGColor | (i, siMain.GetColumnIndex(DefColumns.ROUTE_ID), i, siMain.GetColumnIndex(DefColumns.ROUTE_… | 그리드 표시 설정 |  |  |  |

## SCP0007_BOD.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c8f2b6e | this.Load 외 1 | SCP0007_BOD.cs:244 |  | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteAll,filterExpression,true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c4e9771a | this.Load 외 1 | SCP0007_BOD.cs:244 |  | DATA_OP | DBUtils.Filter | (dtFromSiteAll,filterExpression,true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6a3a97bf | this.Load 외 1 | SCP0007_BOD.cs:246 |  | FLAG | dtToSite | DBUtils.Filter(dtToSiteAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-82492a42 | this.Load 외 1 | SCP0007_BOD.cs:246 |  | DATA_OP | DBUtils.Filter | (dtToSiteAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-75db00ce | this.Load 외 1 | SCP0007_BOD.cs:248 |  | FLAG | dtCustomer | DBUtils.Filter(dtCustomerAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-8e217b59 | this.Load 외 1 | SCP0007_BOD.cs:248 |  | DATA_OP | DBUtils.Filter | (dtCustomerAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8016a257 | this.Load 외 1 | SCP0007_BOD.cs:250 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-25eef18d | this.Load 외 1 | SCP0007_BOD.cs:251 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0007_BOD.SetCityCode

진입점: dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f781cbf | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1365 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) | DATA_OP | dtCountryCity.Select | ("SCM_SITE_ID = '" + strFROM_SITE_CODE + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec066e66 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1368 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) ▸ if (drsFrom.Lengt… | DATA_OP | dr[DefColumns.FROM_COUNTRY.ToLower()] | drsFrom[0]["COUNTRY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-41254fff | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1369 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) ▸ if (drsFrom.Lengt… | DATA_OP | dr[DefColumns.FROM_CITY.ToLower()] | drsFrom[0]["CITY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d745e079 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1374 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) ▸ else of (drsFrom.… | DATA_OP | dr[DefColumns.FROM_COUNTRY.ToLower()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3560f8ad | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1375 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) ▸ else of (drsFrom.… | DATA_OP | dr[DefColumns.FROM_CITY.ToLower()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6abf7138 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1377 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) | DATA_OP | dtCountryCity.Select | ("SCM_SITE_ID = '" + strTO_SITE_CODE + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-db1662a9 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1380 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) ▸ if (drsTo.Length … | DATA_OP | dr[DefColumns.TO_COUNTRY.ToLower()] | drsTo[0]["COUNTRY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-46a9c544 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1381 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) ▸ if (drsTo.Length … | DATA_OP | dr[DefColumns.TO_CITY.ToLower()] | drsTo[0]["CITY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d0c14c4f | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1382 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) ▸ if (drsTo.Length … | DATA_OP | dr[DefColumns.VMI_YN.ToLower()] | drsTo[0]["VMI_YN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c4e5b4c0 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1387 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) ▸ else of (drsTo.Le… | DATA_OP | dr[DefColumns.TO_COUNTRY.ToLower()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d8601705 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1388 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) ▸ else of (drsTo.Le… | DATA_OP | dr[DefColumns.TO_CITY.ToLower()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f573a0b3 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1389 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dtCountryCity != null) ▸ else of (drsTo.Le… | DATA_OP | dr[DefColumns.VMI_YN.ToLower()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0e5d9696 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1393 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) | CALL_EXT | siMain.ActiveSheet.GetViewRowFromModelRow | (nRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-edddadca | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1400 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(strTO_SITE_TYPE) && … | DATA_OP | dr[DefColumns.INCOTERMS.ToLower()] | "EXW" | 행/컬럼 값 대입 |  |  |  |
| AC-a9d07b9f | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1404 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(strTO_SITE_TYPE) && … | DATA_OP | dr[DefColumns.INCOTERMS.ToLower()] | "DAP" | 행/컬럼 값 대입 |  |  |  |
| AC-55bd8bc5 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1411 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(strTO_SITE_TYPE) && … | GRID_SET | siMain.SetText | (nRow, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), siMain.GetText(nRow, siMain.GetCol… | 그리드 값 설정 |  |  |  |
| AC-8ce4e809 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1415 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(strTO_SITE_TYPE) && … | GRID_LOCK | siMain.LockRange | (nViewRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), nViewRow, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-96005777 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1418 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(strTO_SITE_TYPE) && … | GRID_LOCK | siMain.LockRange | (nViewRow, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), nViewRow, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5196c7ba | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1422 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ else of (!string.IsNullOrEmpty(strTO_SITE_TYPE… | DATA_OP | dr[DefColumns.INCOTERMS.ToLower()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a256f647 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1423 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ else of (!string.IsNullOrEmpty(strTO_SITE_TYPE… | GRID_LOCK | siMain.LockRange | (nViewRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), nViewRow, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a738e472 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1426 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ else of (!string.IsNullOrEmpty(strTO_SITE_TYPE… | DATA_OP | dr[DefColumns.INCOTERMS_SSP.ToLower()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f66c81fb | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1427 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ else of (!string.IsNullOrEmpty(strTO_SITE_TYPE… | GRID_LOCK | siMain.LockRange | (nViewRow, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), nViewRow, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b7cdf75f | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1433 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (dr[DefColumns.VMI_YN.ToLower()].ToString()… | GRID_LOCK | siMain.LockRange | (nViewRow, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK), nViewRow, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-03a2f938 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1437 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ else of (dr[DefColumns.VMI_YN.ToLower()].ToStr… | GRID_LOCK | siMain.LockRange | (nViewRow, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK), nViewRow, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-adee70c7 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1448 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(p_from_city) && !str… | ENDPOINT | new FoxDataRequest | ("SCP.SCP0007_GET_ROUTE_CNT") ⇒ SCP.SCP0007_GET_ROUTE_CNT | 엔드포인트 요청 생성 |  |  |  |
| AC-0967461b | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1450 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(p_from_city) && !str… | DATA_OP | request.Parameters["p_from_city"] | p_from_city | 행/컬럼 값 대입 |  |  |  |
| AC-939fd86f | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1451 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(p_from_city) && !str… | DATA_OP | request.Parameters["p_to_city"] | p_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-8db8a0c6 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1452 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(p_from_city) && !str… | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9ec8ea98 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1455 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(p_from_city) && !str… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-da1385cb | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0007_BOD.cs:1461 | if (!string.IsNullOrEmpty(strFROM_SITE_CODE) \|\| !string.IsNullOrEmpty(strFROM_SITE_CODE)) ▸ if (!string.IsNullOrEmpty(p_from_city) && !str… | DATA_OP | dr[DefColumns.ROUTE_CNT.ToLower()] | strROUTE_CNT | 행/컬럼 값 대입 |  |  |  |

## SCP0007_BOD.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b920d702 | (진입점 미연결) | SCP0007_BOD.cs:1017 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ROUTE_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SCP0007_BOD.spdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6de93b3a | spdMain.CellDoubleClick | SCP0007_BOD.cs:1030 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6dd1347 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1051 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | POPUP | new SCP0007_DistributionRoutePopup | () | 팝업/폼 생성 |  |  |  |
| AC-6878c850 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1052 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | POPUP | popRoute.Form_Load | (sFromCountry, sFromCity, sToCountry, sToCity, sTransMode, false, true) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1643afae | spdMain.CellDoubleClick | SCP0007_BOD.cs:1054 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | UI_PROP | popRoute.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-533fa9b2 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1055 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | POPUP | popRoute.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d964c275 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1064 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (arList.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89fc20b6 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1077 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ROUTE_ID), dr["ROUTE_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-e6b10b21 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1078 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), dr["TRANSPORT_MODE_NAME"].ToStri… | 그리드 값 설정 |  |  |  |
| AC-60cdfab0 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1079 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRIORITY), dr["PRIORITY"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-3862ec11 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1080 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_MON), dr["DAYS_MON"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-ef82c35d | spdMain.CellDoubleClick | SCP0007_BOD.cs:1081 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_TUE), dr["DAYS_TUE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-738ebf94 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1082 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_WED), dr["DAYS_WED"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-7a34a5e2 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1083 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_THU), dr["DAYS_THU"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-c1325125 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1084 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_FRI), dr["DAYS_FRI"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-d1b7def2 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1085 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_SAT), dr["DAYS_SAT"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-911ca813 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1086 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_SUN), dr["DAYS_SUN"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-bb5cb5a8 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1087 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ROUTE_VALID), dr["VALID_YN"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-17588b68 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1088 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIS_TOTAL_LEAD_TIME), dr["LT_SUM"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-91ec601e | spdMain.CellDoubleClick | SCP0007_BOD.cs:1089 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.LT_TYPE), dr["LT_TYPE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-e1b91f72 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1091 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_VALID), "Y") | 그리드 값 설정 |  |  |  |
| AC-3947c5f3 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1095 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, e.Column) | 그리드 표시 설정 |  |  |  |
| AC-af04f010 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1096 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ try | CALL_EXT | spdMain.ShowCell | (0, 0, e.Row, e.Column, FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.H… | ⚠ 의미 확인 필요 |  |  |  |
| AC-98a9f129 | spdMain.CellDoubleClick | SCP0007_BOD.cs:1106 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) ▸ if (strRouteId != "") ▸ finally | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0007_BOD.SpdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeea1de9 | dsdm.Changed | SCP0007_BOD.cs:1279 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf371e7e | dsdm.Changed | SCP0007_BOD.cs:1293 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0cc143c | dsdm.Changed | SCP0007_BOD.cs:1295 | try ▸ if (e.Column < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-307de415 | dsdm.Changed | SCP0007_BOD.cs:1297 | try ▸ if (!(e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE) \|\| e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_C…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1afd7fc4 | dsdm.Changed | SCP0007_BOD.cs:1310 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-607a777e | dsdm.Changed | SCP0007_BOD.cs:1314 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0007_BOD.SpdMain_ClipboardPasted

진입점: spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53c11abc | spdMain.ClipboardPasted | SCP0007_BOD.cs:1193 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6bff20d6 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1214 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | DATA_OP | dtFromSiteOfSpd.Select | ("CODE = '" + sFromSite2 + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9a95c27 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1222 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | FLAG | dtToSiteOfSpd | DBUtils.Filter(dtToSiteOfSpdAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb11aebb | spdMain.ClipboardPasted | SCP0007_BOD.cs:1222 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | DATA_OP | DBUtils.Filter | (dtToSiteOfSpdAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7c858f3d | spdMain.ClipboardPasted | SCP0007_BOD.cs:1224 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.TO_SITE_CODE), dtToSiteOfSpd) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-04a82b5c | spdMain.ClipboardPasted | SCP0007_BOD.cs:1230 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | FLAG | dtToSiteOfSpd | DBUtils.Filter(dtToSiteOfSpdAll1, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-743870fc | spdMain.ClipboardPasted | SCP0007_BOD.cs:1230 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | DATA_OP | DBUtils.Filter | (dtToSiteOfSpdAll1, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b7e59fa0 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1232 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.TO_SITE_CODE), dtToSiteOfSpd) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-60e10206 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1238 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | FLAG | dtToSiteOfSpd | DBUtils.Filter(dtToSiteOfSpdAll2, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-200ead8d | spdMain.ClipboardPasted | SCP0007_BOD.cs:1238 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | DATA_OP | DBUtils.Filter | (dtToSiteOfSpdAll2, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e29ec6f7 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1240 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.TO_SITE_CODE), dtToSiteOfSpd) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e64f3af9 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1245 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FROM_CITY), dr["CITY"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-6a4d12c8 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1251 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | DATA_OP | dtToSiteOfSpd.Select | ("CODE = '" + sToSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cafbd3a5 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1255 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TO_CITY), dr["CITY"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-8e5392d5 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1263 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc8f1693 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1265 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-50e21043 | spdMain.ClipboardPasted | SCP0007_BOD.cs:1269 | if (!siMain.IsLock(siMain.SheetName)) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.C… | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), siMain.GetText(iRow, siMain.GetCol… | 그리드 값 설정 |  |  |  |

## SCP0007_BOD.SpdMain_ComboSelChange

진입점: spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1c2f4ed | spdMain.ComboSelChange | SCP0007_BOD.cs:1121 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48d62728 | spdMain.ComboSelChange | SCP0007_BOD.cs:1136 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) | DATA_OP | dtFromSiteOfSpd.Select | ("CODE = '" + strFromSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-166e2a7d | spdMain.ComboSelChange | SCP0007_BOD.cs:1144 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ if (sFromSite == "E") | FLAG | dtToSiteOfSpd | DBUtils.Filter(dtToSiteOfSpdAll,filterExpression,true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce573224 | spdMain.ComboSelChange | SCP0007_BOD.cs:1144 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ if (sFromSite == "E") | DATA_OP | DBUtils.Filter | (dtToSiteOfSpdAll,filterExpression,true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-450b8d6b | spdMain.ComboSelChange | SCP0007_BOD.cs:1146 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ if (sFromSite == "E") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_CODE), dtToSiteOfSpd) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b4796f67 | spdMain.ComboSelChange | SCP0007_BOD.cs:1152 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ else of (sFromSite == "E") ▸ if … | FLAG | dtToSiteOfSpd | DBUtils.Filter(dtToSiteOfSpdAll1, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ca975e4f | spdMain.ComboSelChange | SCP0007_BOD.cs:1152 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ else of (sFromSite == "E") ▸ if … | DATA_OP | DBUtils.Filter | (dtToSiteOfSpdAll1, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-38238b97 | spdMain.ComboSelChange | SCP0007_BOD.cs:1154 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ else of (sFromSite == "E") ▸ if … | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_CODE), dtToSiteOfSpd) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8c6191f2 | spdMain.ComboSelChange | SCP0007_BOD.cs:1159 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ else of (sFromSite == "E") ▸ els… | FLAG | dtToSiteOfSpd | DBUtils.Filter(dtToSiteOfSpdAll2, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-3398d851 | spdMain.ComboSelChange | SCP0007_BOD.cs:1159 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ else of (sFromSite == "E") ▸ els… | DATA_OP | DBUtils.Filter | (dtToSiteOfSpdAll2, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5686c4ad | spdMain.ComboSelChange | SCP0007_BOD.cs:1160 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ else of (sFromSite == "E") ▸ els… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_CODE), dtToSiteOfSpd) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9d3a2651 | spdMain.ComboSelChange | SCP0007_BOD.cs:1165 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ if (dr != null) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_CITY), dr["CITY"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-8045ade0 | spdMain.ComboSelChange | SCP0007_BOD.cs:1172 | if (!siMain.IsLock(siMain.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ if (e.Column == siMain.GetC… | DATA_OP | dtToSiteOfSpd.Select | ("CODE = '" + sToSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b6dcaf0 | spdMain.ComboSelChange | SCP0007_BOD.cs:1176 | if (!siMain.IsLock(siMain.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ if (e.Column == siMain.GetC… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_CITY), dr["CITY"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-38494cb3 | spdMain.ComboSelChange | SCP0007_BOD.cs:1184 | if (!siMain.IsLock(siMain.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ else of (e.Column == siMain… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c5d7bb7 | spdMain.ComboSelChange | SCP0007_BOD.cs:1186 | if (!siMain.IsLock(siMain.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_CODE)) ▸ else of (e.Column == siMain… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0007_BOD.SpdMain_EditChange

진입점: spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51f4de02 | spdMain.EditChange | SCP0007_BOD.cs:1332 | if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | CALL_EXT | ((FarPoint.Win.Spread.FpSpread)sender).CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cef5f534 | spdMain.EditChange | SCP0007_BOD.cs:1341 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS) \|\| e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_CODE)) | DATA_OP | dtCountryCity.Select | ("SCM_SITE_ID = '" + strTO_SITE_CODE + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e1bf937e | spdMain.EditChange | SCP0007_BOD.cs:1348 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS) \|\| e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_CODE)) ▸ if (drsTo.Len… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS_SSP), siMain.GetText(e.Row, siMain.GetC… | 그리드 값 설정 |  |  |  |

## SCP0007_BOD.SpdMain_KeyPress

진입점: spdMain.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-112cb813 | spdMain.KeyPress | SCP0007_BOD.cs:1325 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## SCP0007_BOD.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5c61f60 | spdMain.TopChange | SCP0007_BOD.cs:193 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0007_DistributionRoutePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-534b8045 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0007_DistributionRoutePopup.cs:372 | switch (buttonItem.UserType) case ButtonListType.OK: ▸ if (!isEmptyValue) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-7427fbd1 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0007_DistributionRoutePopup.cs:373 | switch (buttonItem.UserType) case ButtonListType.OK: ▸ else of (!isEmptyValue) | FLAG | isEmptyValue | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4f75b716 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0007_DistributionRoutePopup.cs:376 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0007_DistributionRoutePopup.btnFromSrch_Click

진입점: this.btnFromSrch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-144ceb90 | this.btnFromSrch.Click | SCP0007_DistributionRoutePopup.cs:683 |  | POPUP | popCity.Form_Load | (true, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9753696a | this.btnFromSrch.Click | SCP0007_DistributionRoutePopup.cs:684 |  | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-32c830f4 | this.btnFromSrch.Click | SCP0007_DistributionRoutePopup.cs:685 |  | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-566cd686 | this.btnFromSrch.Click | SCP0007_DistributionRoutePopup.cs:689 | if (popCity.Country != "") | VALUE_SET | txtFromCountry.Text | popCity.Country | 컨트롤 값 설정 |  |  |  |
| AC-6215fae2 | this.btnFromSrch.Click | SCP0007_DistributionRoutePopup.cs:690 | if (popCity.Country != "") | VALUE_SET | txtFromCity.Text | popCity.City | 컨트롤 값 설정 |  |  |  |

## SCP0007_DistributionRoutePopup.btnToSrch_Click

진입점: this.btnToSrch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a88ae200 | this.btnToSrch.Click | SCP0007_DistributionRoutePopup.cs:701 |  | POPUP | popCity.Form_Load | (true, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-edf71acf | this.btnToSrch.Click | SCP0007_DistributionRoutePopup.cs:702 |  | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d1b4840a | this.btnToSrch.Click | SCP0007_DistributionRoutePopup.cs:703 |  | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f73e51a2 | this.btnToSrch.Click | SCP0007_DistributionRoutePopup.cs:707 | if (popCity.Country != "") | VALUE_SET | txtToCountry.Text | popCity.Country | 컨트롤 값 설정 |  |  |  |
| AC-994d3930 | this.btnToSrch.Click | SCP0007_DistributionRoutePopup.cs:708 | if (popCity.Country != "") | VALUE_SET | txtToCity.Text | popCity.City | 컨트롤 값 설정 |  |  |  |

## SCP0007_DistributionRoutePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b19c5d2 | this.Load | SCP0007_DistributionRoutePopup.cs:247 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d68b376a | this.Load | SCP0007_DistributionRoutePopup.cs:248 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-31064d48 | this.Load | SCP0007_DistributionRoutePopup.cs:250 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0007_DistributionRoutePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbb6185b | this.Load | SCP0007_DistributionRoutePopup.cs:239 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0007_DistributionRoutePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7ae0b5e | Dispose | SCP0007_DistributionRoutePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0007_DistributionRoutePopup.FindDataMain

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load [if (isConditionReadOnly)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cb0bf99 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:432 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8d4e8d01 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:436 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0005_GET_DISTRIBUTION_ROUTE") ⇒ SCP.SCP0005_GET_DISTRIBUTION_ROUTE | 엔드포인트 요청 생성 |  |  |  |
| AC-c37b6f1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:437 | lambda | DATA_OP | request.Parameters["p_from_country"] | p_from_country | 행/컬럼 값 대입 |  |  |  |
| AC-7c85751b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:438 | lambda | DATA_OP | request.Parameters["p_from_city"] | p_from_city | 행/컬럼 값 대입 |  |  |  |
| AC-79502987 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:439 | lambda | DATA_OP | request.Parameters["p_to_country"] | p_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-d497c0f4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:440 | lambda | DATA_OP | request.Parameters["p_to_city"] | p_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-5e39ebac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:441 | lambda | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-5fad06c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:442 | lambda | DATA_OP | request.Parameters["p_valid_yn"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-cd6911b2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:444 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-902f60cc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:446 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3148fb95 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:453 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-96889ebb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:454 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0007_DistributionRoutePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa396317 | this.Load | SCP0007_DistributionRoutePopup.cs:157 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b4d0189 | this.Load | SCP0007_DistributionRoutePopup.cs:158 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7d9f00de | this.Load | SCP0007_DistributionRoutePopup.cs:173 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-a4d5eeb1 | this.Load | SCP0007_DistributionRoutePopup.cs:174 |  | FLAG | sFromCountry | _FromCountry | 화면 필드/플래그 변경 |  |  |  |
| AC-2c9a6b9c | this.Load | SCP0007_DistributionRoutePopup.cs:175 |  | FLAG | sFromCity | _FromCity | 화면 필드/플래그 변경 |  |  |  |
| AC-198d16e3 | this.Load | SCP0007_DistributionRoutePopup.cs:176 |  | FLAG | sToCountry | _ToCountry | 화면 필드/플래그 변경 |  |  |  |
| AC-33e6f5e6 | this.Load | SCP0007_DistributionRoutePopup.cs:177 |  | FLAG | sToCity | _ToCity | 화면 필드/플래그 변경 |  |  |  |
| AC-51723d98 | this.Load | SCP0007_DistributionRoutePopup.cs:178 |  | FLAG | isConditionReadOnly | _isConditionReadOnly | 화면 필드/플래그 변경 |  |  |  |
| AC-193c942e | this.Load | SCP0007_DistributionRoutePopup.cs:184 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-323c1253 | this.Load | SCP0007_DistributionRoutePopup.cs:185 |  | FLAG | sFromCountry | _FromCountry | 화면 필드/플래그 변경 |  |  |  |
| AC-6cb42847 | this.Load | SCP0007_DistributionRoutePopup.cs:186 |  | FLAG | sFromCity | _FromCity | 화면 필드/플래그 변경 |  |  |  |
| AC-d93e547c | this.Load | SCP0007_DistributionRoutePopup.cs:187 |  | FLAG | sToCountry | _ToCountry | 화면 필드/플래그 변경 |  |  |  |
| AC-82b6da53 | this.Load | SCP0007_DistributionRoutePopup.cs:188 |  | FLAG | sToCity | _ToCity | 화면 필드/플래그 변경 |  |  |  |
| AC-b4851d2a | this.Load | SCP0007_DistributionRoutePopup.cs:189 |  | FLAG | sTransMode | _TransMode | 화면 필드/플래그 변경 |  |  |  |
| AC-d7e7a3c0 | this.Load | SCP0007_DistributionRoutePopup.cs:190 |  | FLAG | isConditionReadOnly | _isConditionReadOnly | 화면 필드/플래그 변경 |  |  |  |

## SCP0007_DistributionRoutePopup.GetBodType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0df39700 | (진입점 미연결) | SCP0007_DistributionRoutePopup.cs:569 |  | COMBO_DATA | Data.Common | (Data.Type.BodType, false) ⇒ biz:CommonData.CommonDataList [code=BodType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-85a5b877 | (진입점 미연결) | SCP0007_DistributionRoutePopup.cs:571 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0007_DistributionRoutePopup.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abb5adf9 | (진입점 미연결) | SCP0007_DistributionRoutePopup.cs:540 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserGroup, UserId) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2079a2d0 | (진입점 미연결) | SCP0007_DistributionRoutePopup.cs:542 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0007_DistributionRoutePopup.GetFromSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2905d98 | (진입점 미연결) | SCP0007_DistributionRoutePopup.cs:549 |  | COMBO_DATA | Data.Common | (Data.Type.FromSiteByDivision, false, division, UserGroup, UserId) ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2fbcfecc | (진입점 미연결) | SCP0007_DistributionRoutePopup.cs:550 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0007_DistributionRoutePopup.GetToSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f3c7a39 | (진입점 미연결) | SCP0007_DistributionRoutePopup.cs:557 |  | COMBO_DATA | Data.Common | (Data.Type.ToSiteByDivision, false, division, UserGroup, UserId) ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-901a502a | (진입점 미연결) | SCP0007_DistributionRoutePopup.cs:559 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0007_DistributionRoutePopup.GetTransMode

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3b15bfd | (진입점 미연결) | SCP0007_DistributionRoutePopup.cs:579 |  | COMBO_DATA | Data.Common | (Data.Type.TransportMode, false) ⇒ biz:CommonData.CommonDataList [code=TransportMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-091a0f30 | (진입점 미연결) | SCP0007_DistributionRoutePopup.cs:580 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0007_DistributionRoutePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c0c6489 | this.Load | SCP0007_DistributionRoutePopup.cs:211 |  | LIST_REBIND | clsCtrl.setListBox | (dtTransMode, clbTransMode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fb743e65 | this.Load | SCP0007_DistributionRoutePopup.cs:214 | if (isConditionReadOnly) | STATE | txtFromCity.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2047b3cd | this.Load | SCP0007_DistributionRoutePopup.cs:215 | if (isConditionReadOnly) | STATE | txtFromCountry.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-91e0044c | this.Load | SCP0007_DistributionRoutePopup.cs:216 | if (isConditionReadOnly) | STATE | btnFromSrch.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0fb1d77c | this.Load | SCP0007_DistributionRoutePopup.cs:218 | if (isConditionReadOnly) | STATE | txtToCountry.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c150c98e | this.Load | SCP0007_DistributionRoutePopup.cs:219 | if (isConditionReadOnly) | STATE | txtToCity.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-48f8de51 | this.Load | SCP0007_DistributionRoutePopup.cs:220 | if (isConditionReadOnly) | STATE | btnToSrch.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3d81d2d1 | this.Load | SCP0007_DistributionRoutePopup.cs:222 | if (isConditionReadOnly) | STATE | clbTransMode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2c1961ce | this.Load | SCP0007_DistributionRoutePopup.cs:226 |  | VALUE_SET | txtFromCountry.Text | sFromCountry | 컨트롤 값 설정 |  |  |  |
| AC-a9aec1f5 | this.Load | SCP0007_DistributionRoutePopup.cs:227 |  | VALUE_SET | txtFromCity.Text | sFromCity | 컨트롤 값 설정 |  |  |  |
| AC-8897e180 | this.Load | SCP0007_DistributionRoutePopup.cs:228 |  | VALUE_SET | txtToCountry.Text | sToCountry | 컨트롤 값 설정 |  |  |  |
| AC-a0cd23ae | this.Load | SCP0007_DistributionRoutePopup.cs:229 |  | VALUE_SET | txtToCity.Text | sToCity | 컨트롤 값 설정 |  |  |  |
| AC-04f12067 | this.Load | SCP0007_DistributionRoutePopup.cs:231 |  | CALL_EXT | clbTransMode.SetValues | ( sTransMode) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0007_DistributionRoutePopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4bd6bbb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:259 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-5f4194bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:263 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b26974a0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:264 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Route Id", DefColumns.ROUTE_ID, FPMerge.None, 60, true, FPHAlign.Right, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2eea7907 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:265 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("L/T Type", DefColumns.LT_TYPE, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3bffbc3a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:266 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | ("Valid", DefColumns.VALID_YN, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6025064 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:267 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("City Name", DefColumns.FROM_CITY_NAME, FPMerge.None, 130, true, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ddb10a72 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:268 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddExTextColumn | ("Country", DefColumns.FROM_COUNTRY, FPMerge.None, 50, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cfdd1836 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:269 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddExTextColumn | ("City", DefColumns.FROM_CITY, FPMerge.None, 50, true, FPHAlign.Center, FPVAlign.Center, f… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f681f2e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:271 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Trans Mode", DefColumns.TRANSPORT_MODE, FPMerge.None, 60, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9937747 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:272 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumTextColumn | ("Priority", DefColumns.PRIORITY, FPMerge.None, 60, true, FPHAlign.Right, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb4695fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:273 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | ("Mon", DefColumns.DAYS_MON, FPMerge.None, 40, false,dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb6e8b7e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:274 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | ("Tue", DefColumns.DAYS_TUE, FPMerge.None, 40, false, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc6ddd60 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:275 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | ("Wed", DefColumns.DAYS_WED, FPMerge.None, 40, false, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-426b2733 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:276 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | ("Thu", DefColumns.DAYS_THU, FPMerge.None, 40, false, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b979213f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:277 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | ("Fri", DefColumns.DAYS_FRI, FPMerge.None, 40, false, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42648d3b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:278 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | ("Sat", DefColumns.DAYS_SAT, FPMerge.None, 40, false, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f98bc768 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:279 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | ("Sun", DefColumns.DAYS_SUN, FPMerge.None, 40, false, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d64f84d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:280 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Departure Days", DefColumns.DAYS, FPMerge.None, 140, true, FPHAlign.Left, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35b76168 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:281 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Port", DefColumns.D_PORT_NAME, FPMerge.None, 80, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e779f36 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:282 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddExTextColumn | ("Country", DefColumns.D_COUNTRY, FPMerge.None, 50, true, FPHAlign.Center, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4cf90f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:283 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddExTextColumn | ("Port Code", DefColumns.D_PORT_CODE, FPMerge.None, 70, true, FPHAlign.Center, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b8c92f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:284 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("Port", DefColumns.A_PORT_NAME, FPMerge.None, 80, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a329429a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:285 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddExTextColumn | ("Country", DefColumns.A_COUNTRY, FPMerge.None, 50, true, FPHAlign.Center, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-01583aff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:286 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddExTextColumn | ("Port Code", DefColumns.A_PORT_CODE, FPMerge.None, 70, true, FPHAlign.Center, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e9f9f1f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:287 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddExTextColumn | ("Shipping Company", DefColumns.SHIPPING_COMPANY, FPMerge.None, 80, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-319245c9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:288 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("City Name", DefColumns.TO_CITY_NAME, FPMerge.None, 130, true, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da1a19de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:289 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddExTextColumn | ("Country", DefColumns.TO_COUNTRY, FPMerge.None, 50, true, FPHAlign.Center, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29983566 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:290 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddExTextColumn | ("City", DefColumns.TO_CITY, FPMerge.None, 50, true, FPHAlign.Center, FPVAlign.Center, fal… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80d19d6e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:291 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddDateColumn | ("Shipping Document Preparation Data", DefColumns.SHIP_DOC_PREPARATION_DATE, FPMerge.None,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c7eaade | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:292 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumTextColumn | ("Departure Inland", DefColumns.LT_DEPARTURE_INLAND, FPMerge.None, 100, true, FPHAlign.Rig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fcc980e7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:293 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumTextColumn | ("Waiting For Shipping", DefColumns.LT_WAIT_SHIPPING, FPMerge.None, 100, true, FPHAlign.Ri… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d1f747a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:294 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumTextColumn | ("Sea/Air Ferry", DefColumns.LT_VOYAGE, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f4debe2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:295 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumTextColumn | ("Lay Off/Customs Clearance", DefColumns.LT_LAY_OFF_CLEARANCE, FPMerge.None, 100, true, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c46866d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:296 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumTextColumn | ("Arrival Inland", DefColumns.LT_ARRIVAL_INLAND, FPMerge.None, 100, true, FPHAlign.Right, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d58affc7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:297 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumTextColumn | ("Sum", DefColumns.LT_SUM, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21b71ea9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:301 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(CAppSetting.StringAction), 2, 1, 30, "A", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5896da15 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:303 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ROUTE_ID), 2, 1, 30, "Route Id", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7cea4a1d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:304 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LT_TYPE), 2, 1, 30, "L/T Type", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-912e9f6e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:305 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.FROM_CITY_NAME), 1, 1, 30, "City Name", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c3953a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:306 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.FROM_COUNTRY) , 1, 1, 30, "Country", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70675301 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:307 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.FROM_CITY), 1, 1, 30, "City", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-378ba0bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:308 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-43d890cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:309 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.VALID_YN), 2, 1, 30, "Valid", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-23ec0d89 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:310 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.PRIORITY), 2, 1, 30, "Priority", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66ca4d9b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:318 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DAYS), 2, 1, 30, "Departure Days", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a0d8b04 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:319 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.D_PORT_NAME), 1, 1, 30, "Port", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a4e1548 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:320 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.D_COUNTRY), 1, 1, 30, "Country", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-df54082a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:321 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.D_PORT_CODE), 1, 1, 30, "Port Code", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-504989ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:322 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.A_PORT_NAME), 1, 1, 30, "Port", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-713733c2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:323 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.A_COUNTRY), 1, 1, 30, "Country", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d009521 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:324 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.A_PORT_CODE), 1, 1, 30, "Port Code", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1d0a7bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:325 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.SHIPPING_COMPANY), 2, 1, 30, "Shipping Company", FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41e1bff5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:326 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.TO_CITY_NAME), 1, 1, 30, "City Name", FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a20f202f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:327 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.TO_COUNTRY), 1, 1, 30, "Country", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e689470 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:328 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.TO_CITY), 1, 1, 30, "City", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d405968d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:329 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.SHIP_DOC_PREPARATION_DATE), 2, 1, 30, "Shipping Docum… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ed45c607 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:330 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LT_DEPARTURE_INLAND), 1, 1, 30, "Departure Inland", F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25411b39 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:331 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LT_WAIT_SHIPPING), 1, 1, 30, "Waiting For Shipping", … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14eb8f49 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:332 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LT_VOYAGE), 1, 1, 30, "Sea/Air Ferry", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac1df2ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:333 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LT_LAY_OFF_CLEARANCE), 1, 1, 30, "Lay Off/Customs Cle… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5c3944c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:334 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LT_ARRIVAL_INLAND), 1, 1, 30, "Arrival Inland", FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00afe31d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:335 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LT_SUM), 2, 1, 30, "Sum", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dab6a2fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:338 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.FROM_CITY_NAME), 1, 3, "From Site") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9959a86a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:340 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.D_PORT_NAME), 1, 3, "Departure Port") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e916186d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:341 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.A_PORT_NAME), 1, 3, "Arrival Port") | ⚠ 의미 확인 필요 |  |  |  |
| AC-03e581cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:342 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.TO_CITY_NAME), 1, 3, "To Site") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c89d3d9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:343 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.LT_DEPARTURE_INLAND), 1, 6, "Lead Time") | ⚠ 의미 확인 필요 |  |  |  |
| AC-463f5361 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:345 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.ROUTE_ID) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dba06a72 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0007_DistributionRoutePopup.cs:347 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0007_DistributionRoutePopup.SetRoute

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98c2f7f2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:619 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16d3a61f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:624 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4afc1d6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:636 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) | CALL_EXT | spdMain.ActiveSheet.GetModelRowFromViewRow | (cr.Row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21066412 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:641 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ if (String.IsNullOrEmpt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00222", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e730c3c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:642 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ if (String.IsNullOrEmpt… | FLAG | arrayListResult | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-d662ec72 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:643 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ if (String.IsNullOrEmpt… | FLAG | isEmptyValue | true | 화면 필드/플래그 변경 |  |  |  |
| AC-57777621 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:644 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ if (String.IsNullOrEmpt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34f64ece | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:648 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ else of (String.IsNullO… | DATA_OP | arrayListResult.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-42a5d0ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:655 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03008031 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:660 | else of (bMulltiSelect) | CALL_EXT | spdMain.ActiveSheet.GetModelRowFromViewRow | (siMain.ActiveRowIndex) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b15c1be7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:665 | else of (bMulltiSelect) ▸ if (String.IsNullOrEmpty(dr[DefColumns.DAYS].ToString()) == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00222", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-676a3589 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:666 | else of (bMulltiSelect) ▸ if (String.IsNullOrEmpty(dr[DefColumns.DAYS].ToString()) == true) | FLAG | arrayListResult | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-ec5d6aec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:667 | else of (bMulltiSelect) ▸ if (String.IsNullOrEmpty(dr[DefColumns.DAYS].ToString()) == true) | FLAG | isEmptyValue | true | 화면 필드/플래그 변경 |  |  |  |
| AC-25823603 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:668 | else of (bMulltiSelect) ▸ if (String.IsNullOrEmpty(dr[DefColumns.DAYS].ToString()) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d787300 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0007_DistributionRoutePopup.cs:672 | else of (bMulltiSelect) ▸ else of (String.IsNullOrEmpty(dr[DefColumns.DAYS].ToString()) == true) | DATA_OP | arrayListResult.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |

## SCP0007_DistributionRoutePopup.spdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d0ee186 | spdMain.CellDoubleClick | SCP0007_DistributionRoutePopup.cs:530 | if (!isEmptyValue) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-127d77b5 | spdMain.CellDoubleClick | SCP0007_DistributionRoutePopup.cs:531 | else of (!isEmptyValue) | FLAG | isEmptyValue | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0007_DistributionRoutePopup.spdMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e3dbe1c | dsdm.Changed | SCP0007_DistributionRoutePopup.cs:484 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-794e3a98 | dsdm.Changed | SCP0007_DistributionRoutePopup.cs:487 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3651428 | dsdm.Changed | SCP0007_DistributionRoutePopup.cs:516 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.LT_A… | GRID_SET | dt.Rows[nRow][DefColumns.LT_SUM] | strLtSum | 그리드 속성/값 설정 |  |  |  |
| AC-7f416a34 | dsdm.Changed | SCP0007_DistributionRoutePopup.cs:520 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

