# AS-IS 액션 대조표 — FP00960

> 원천: `Doc/asisfacts/screens/FP00960/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 115행 · 메서드 22 · 종류 DATA_OP 20 · FLAG 15 · RETURN 11 · GRID_INIT 9 · GRID_SET 9 · UI_PROP 8 · LIST_REBIND 8 · COMBO_DATA 5 · MESSAGE 4 · UI_MISC 4 · POPUP 3 · ENDPOINT 3 · CALL_EXT 2 · VALIDATE 2 · GRID_BIND 2 · STATE 2 · THROW 2 · STATE_RESET 1 · EXCEL 1 · GRID_LOCK 1 · GRID_STYLE 1 · CALL_BASE 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 3


## FP00960_Aging_Inventory.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-351d7952 | this.btnSql.Click | FP00960_Aging_Inventory.cs:614 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bd465c3b | this.btnSql.Click | FP00960_Aging_Inventory.cs:615 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-389aea5f | this.btnSql.Click | FP00960_Aging_Inventory.cs:617 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00960_AGING_INVENTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-4414fd95 | this.btnSql.Click | FP00960_Aging_Inventory.cs:619 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00960_Aging_Inventory.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11ce4f63 | (진입점 미연결) | FP00960_Aging_Inventory.cs:277 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7613d718 | (진입점 미연결) | FP00960_Aging_Inventory.cs:278 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00960_Aging_Inventory.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75eb99c8 | this.Load | FP00960_Aging_Inventory.cs:287 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a77fd26e | this.Load | FP00960_Aging_Inventory.cs:288 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-479d6ed1 | this.Load | FP00960_Aging_Inventory.cs:290 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00960_Aging_Inventory.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-252fdd97 | this.Load | FP00960_Aging_Inventory.cs:195 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-45ac3ac0 | this.Load | FP00960_Aging_Inventory.cs:197 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d5a935c3 | this.Load | FP00960_Aging_Inventory.cs:198 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-6c8776f3 | this.Load | FP00960_Aging_Inventory.cs:199 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00960_Aging_Inventory.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34068cf8 | DeleteButton | FP00960_Aging_Inventory.cs:389 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94f69c85 | DeleteButton | FP00960_Aging_Inventory.cs:390 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00960_Aging_Inventory.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1729e91d | Dispose | FP00960_Aging_Inventory.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00960_Aging_Inventory.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-682053ca | EditButton | FP00960_Aging_Inventory.cs:373 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d566bdb1 | EditButton | FP00960_Aging_Inventory.cs:374 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00960_Aging_Inventory.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4db5bd58 | ExcelButton | FP00960_Aging_Inventory.cs:602 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00960_Aging_Inventory.Find_Data

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-456c0c78 | FindButton | FP00960_Aging_Inventory.cs:416 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8daaa97b | FindButton | FP00960_Aging_Inventory.cs:420 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d857c77c | FindButton | FP00960_Aging_Inventory.cs:423 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-33907fa6 | FindButton | FP00960_Aging_Inventory.cs:423 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4752381 | FindButton | FP00960_Aging_Inventory.cs:427 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b16751d | FindButton | FP00960_Aging_Inventory.cs:428 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64373854 | FindButton | FP00960_Aging_Inventory.cs:431 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-05216d2f | FindButton | FP00960_Aging_Inventory.cs:442 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53ac78c6 | FindButton | FP00960_Aging_Inventory.cs:448 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Inventory("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc21e9b6 | FindButton | FP00960_Aging_Inventory.cs:460 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds, false) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b3ab2ed2 | FindButton | FP00960_Aging_Inventory.cs:462 | try ▸ if (ds != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a22aadd8 | FindButton | FP00960_Aging_Inventory.cs:465 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-64949349 | FindButton | FP00960_Aging_Inventory.cs:469 | try ▸ if (ds != null) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bc5484cb | FindButton | FP00960_Aging_Inventory.cs:477 | try ▸ if (ds != null) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-cf630399 | FindButton | FP00960_Aging_Inventory.cs:482 | try ▸ else of (ds != null) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-284202e1 | FindButton | FP00960_Aging_Inventory.cs:484 | try ▸ else of (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b8c2b50f | FindButton | FP00960_Aging_Inventory.cs:486 | try ▸ else of (ds != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-7d3dac72 | FindButton | FP00960_Aging_Inventory.cs:497 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fa26a8d1 | FindButton | FP00960_Aging_Inventory.cs:497 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f11bdd30 | FindButton | FP00960_Aging_Inventory.cs:498 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00960_Aging_Inventory.Find_Data_Inventory

진입점: popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTORY")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46ecf114 | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:514 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivisionID = CString.GetCheckedListValue(d… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2bc030ab | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:541 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00960_AGING_INVENTORY") ⇒ FP_Master.PR_UI_FP00960_AGING_INVENTORY | 엔드포인트 요청 생성 |  |  |  |
| AC-2fe631a5 | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:543 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-ff77e4bf | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:544 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-e6120565 | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:545 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cb35a01d | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:546 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6639380b | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:548 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-436579b5 | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:549 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-d5b75bfe | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:550 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-a6b7b36a | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:551 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-fcd8f24f | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:552 | try | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? "" : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-00f1c6ff | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:553 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? "" : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-30596c9b | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:554 | try | DATA_OP | request.Parameters["p_route_id"] | pRouteID.Equals("ALL") ? "" : pRouteID | 행/컬럼 값 대입 |  |  |  |
| AC-ca2cef49 | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:555 | try | DATA_OP | request.Parameters["p_item_id"] | pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-82a5e05d | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:556 | try | DATA_OP | request.Parameters["p_cur_off_date"] | pCurOffDate | 행/컬럼 값 대입 |  |  |  |
| AC-223a9640 | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:559 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b1012c2d | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:561 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7b980540 | popSql.OnSql [if (programID == "PR_UI_FP00960_AGING_INVENTOR… 외 1 | FP00960_Aging_Inventory.cs:566 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00960_Aging_Inventory.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4f95324 | this.Load | FP00960_Aging_Inventory.cs:128 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00960_Aging_Inventory.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a82a3ee | (진입점 미연결) | FP00960_Aging_Inventory.cs:898 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00960_Aging_Inventory.GetToDay

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ceaf67f7 | this.Load [try] | FP00960_Aging_Inventory.cs:887 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-d5b7047a | this.Load [try] | FP00960_Aging_Inventory.cs:888 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00960_Aging_Inventory.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69633110 | this.Load | FP00960_Aging_Inventory.cs:150 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f591072 | this.Load | FP00960_Aging_Inventory.cs:153 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-529d14a2 | this.Load | FP00960_Aging_Inventory.cs:156 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7c1e21c5 | this.Load | FP00960_Aging_Inventory.cs:157 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8693aa25 | this.Load | FP00960_Aging_Inventory.cs:162 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-d577f9d8 | this.Load | FP00960_Aging_Inventory.cs:164 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-51843529 | this.Load | FP00960_Aging_Inventory.cs:169 | try | VALUE_SET | dtpCurOffDate.Value | dCurDate | 컨트롤 값 설정 |  |  |  |
| AC-b750ff11 | this.Load | FP00960_Aging_Inventory.cs:181 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5379fc94 | this.Load | FP00960_Aging_Inventory.cs:182 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b0f657ec | this.Load | FP00960_Aging_Inventory.cs:183 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fe5f5369 | this.Load | FP00960_Aging_Inventory.cs:188 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00960_Aging_Inventory.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48a206fc | this.Load | FP00960_Aging_Inventory.cs:243 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-3588db43 | this.Load | FP00960_Aging_Inventory.cs:244 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-09c4b2c6 | this.Load | FP00960_Aging_Inventory.cs:245 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00960_Aging_Inventory.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b0c9557 | this.Load | FP00960_Aging_Inventory.cs:302 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80dac84d | this.Load | FP00960_Aging_Inventory.cs:303 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9cd3ecdc | this.Load | FP00960_Aging_Inventory.cs:307 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00960_Aging_Inventory.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f32654d | InsertButton | FP00960_Aging_Inventory.cs:359 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-08af5ecf | InsertButton | FP00960_Aging_Inventory.cs:360 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00960_Aging_Inventory.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24a431f7 | popSql.OnSql | FP00960_Aging_Inventory.cs:929 | if (programID == "PR_UI_FP00960_AGING_INVENTORY") | RETURN | return Find_Data_Inventory("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-db603283 | popSql.OnSql | FP00960_Aging_Inventory.cs:932 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00960_Aging_Inventory.SetChangeControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-704ba65a | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1003 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0f22e09 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1003 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-44c0f43d | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1012 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-91aba6c0 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1012 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1578ab6e | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1014 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)cboSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d77a6505 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1016 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)cboSite is UsrCombo) ▸ if ((object)cboSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bb0a2faa | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1023 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-36b3c705 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1024 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c03d50c2 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1024 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-75e78097 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1026 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fe7b5c15 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1028 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-14f1d6d1 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1034 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-501b6943 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1035 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-d255e010 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1035 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-752be1e9 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1037 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ if ((object)clbFactory is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1dc2ad55 | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1039 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ else of ((object)clbFactory is UsrCombo) ▸ if ((object)clbPlant is… | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9b4fc13e | this.Load [try] 외 4 | FP00960_Aging_Inventory.cs:1045 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00960_Aging_Inventory.SetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b689eb56 | this.Load [try] | FP00960_Aging_Inventory.cs:904 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e8ba1a50 | this.Load [try] | FP00960_Aging_Inventory.cs:905 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-00306430 | this.Load [try] | FP00960_Aging_Inventory.cs:905 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6d3c7111 | this.Load [try] | FP00960_Aging_Inventory.cs:908 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-9b11d50c | this.Load [try] | FP00960_Aging_Inventory.cs:911 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00960_Aging_Inventory.SetFilter

진입점: this.Load [try ▸ switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbFactory.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / txtRoute.TextChanged / txtOperation.TextChanged / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39e19544 | this.Load [try ▸ switch (triggerControl) case DefColumns.DIV… 외 7 | FP00960_Aging_Inventory.cs:893 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00960_Aging_Inventory.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c19bee42 | this.Load [try] | FP00960_Aging_Inventory.cs:316 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-908a3009 | this.Load [try] | FP00960_Aging_Inventory.cs:317 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e0d6c5a6 | this.Load [try] | FP00960_Aging_Inventory.cs:322 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-d0a66178 | this.Load [try] | FP00960_Aging_Inventory.cs:326 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6e65fecc | this.Load [try] | FP00960_Aging_Inventory.cs:327 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CUTOFF_DATE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0e099dfe | this.Load [try] | FP00960_Aging_Inventory.cs:328 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SEQ)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-adf191c7 | this.Load [try] | FP00960_Aging_Inventory.cs:329 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.HOLDING_DATE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-abec879d | this.Load [try] | FP00960_Aging_Inventory.cs:330 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INPUT_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c85c80f1 | this.Load [try] | FP00960_Aging_Inventory.cs:331 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.QTY_UOM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bcdd2678 | this.Load [try] | FP00960_Aging_Inventory.cs:332 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.OPERATION_SEQ)].Visible | false | 그리드 속성/값 설정 |  |  |  |

