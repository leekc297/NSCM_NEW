# AS-IS 액션 대조표 — FP02510

> 원천: `Doc/asisfacts/screens/FP02510/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 101행 · 메서드 25 · 종류 DATA_OP 21 · FLAG 11 · RETURN 10 · GRID_INIT 9 · GRID_SET 9 · UI_PROP 6 · UI_MISC 4 · POPUP 3 · LIST_REBIND 3 · MESSAGE 3 · ENDPOINT 3 · THROW 3 · COMBO_DATA 3 · CALL_EXT 2 · VALIDATE 2 · GRID_BIND 2 · STATE 2 · STATE_RESET 1 · EXCEL 1 · GRID_LOCK 1 · GRID_STYLE 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 3


## FP02510_Model_Routing.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbfdfe19 | this.btnSql.Click | FP02510_Model_Routing.cs:606 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b2fdb338 | this.btnSql.Click | FP02510_Model_Routing.cs:607 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ae04c31e | this.btnSql.Click | FP02510_Model_Routing.cs:609 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02510_Model_Routing") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f506cfd | this.btnSql.Click | FP02510_Model_Routing.cs:611 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02510_Model_Routing.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-235fb05b | (진입점 미연결) | FP02510_Model_Routing.cs:282 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-cf53ae4e | (진입점 미연결) | FP02510_Model_Routing.cs:283 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02510_Model_Routing.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3eebe16 | this.Load | FP02510_Model_Routing.cs:292 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9418c3d4 | this.Load | FP02510_Model_Routing.cs:293 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0bbc89a | this.Load | FP02510_Model_Routing.cs:295 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02510_Model_Routing.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-671b4d75 | this.Load | FP02510_Model_Routing.cs:199 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-2bdfa6ee | this.Load | FP02510_Model_Routing.cs:201 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-cb0ec372 | this.Load | FP02510_Model_Routing.cs:202 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-24eaa54a | this.Load | FP02510_Model_Routing.cs:203 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP02510_Model_Routing.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34a7480a | DeleteButton | FP02510_Model_Routing.cs:394 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-afdad51d | DeleteButton | FP02510_Model_Routing.cs:395 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02510_Model_Routing.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb628a78 | Dispose | FP02510_Model_Routing.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02510_Model_Routing.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42670cb9 | EditButton | FP02510_Model_Routing.cs:378 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82c6d747 | EditButton | FP02510_Model_Routing.cs:379 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02510_Model_Routing.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebaa70cb | ExcelButton | FP02510_Model_Routing.cs:594 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP02510_Model_Routing.Find_Data

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40b1eb9a | FindButton | FP02510_Model_Routing.cs:421 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fca962f0 | FindButton | FP02510_Model_Routing.cs:425 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-670cb1d2 | FindButton | FP02510_Model_Routing.cs:428 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-50b6889f | FindButton | FP02510_Model_Routing.cs:428 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6eb9ba9b | FindButton | FP02510_Model_Routing.cs:439 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c509edf | FindButton | FP02510_Model_Routing.cs:445 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Inventory("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7e095bc9 | FindButton | FP02510_Model_Routing.cs:457 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e50cff85 | FindButton | FP02510_Model_Routing.cs:459 | try ▸ if (ds != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-94356d92 | FindButton | FP02510_Model_Routing.cs:462 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f0d3b13b | FindButton | FP02510_Model_Routing.cs:466 | try ▸ if (ds != null) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c5909efe | FindButton | FP02510_Model_Routing.cs:474 | try ▸ if (ds != null) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-b04e921c | FindButton | FP02510_Model_Routing.cs:479 | try ▸ else of (ds != null) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-485fc0cd | FindButton | FP02510_Model_Routing.cs:481 | try ▸ else of (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-278c063a | FindButton | FP02510_Model_Routing.cs:483 | try ▸ else of (ds != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b8fa3780 | FindButton | FP02510_Model_Routing.cs:494 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9c5d2501 | FindButton | FP02510_Model_Routing.cs:494 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP02510_Model_Routing.Find_Data_Inventory

진입점: popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af37298b | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:510 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivisionID = CString.GetCheckedListValue(d… | ⚠ 의미 확인 필요 |  |  |  |
| AC-68e8b257 | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:533 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02510_Model_Routing") ⇒ FP_Master.PR_UI_FP02510_Model_Routing | 엔드포인트 요청 생성 |  |  |  |
| AC-c9e4bfe3 | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:535 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-238a03b6 | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:536 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-a6343940 | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:537 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-357a787e | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:538 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2bb29baf | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:540 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-c47017b3 | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:541 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-d694130e | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:542 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-064da9d2 | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:543 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-51dad50c | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:544 | try | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? "" : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-e773137e | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:545 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? "" : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-886aa0e0 | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:546 | try | DATA_OP | request.Parameters["p_route_id"] | pRouteID.Equals("ALL") ? "" : pRouteID | 행/컬럼 값 대입 |  |  |  |
| AC-58313f99 | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:547 | try | DATA_OP | request.Parameters["p_item_id"] | pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-b5b1f43b | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:548 | try | DATA_OP | request.Parameters["p_cur_off_date"] | pCurOffDate | 행/컬럼 값 대입 |  |  |  |
| AC-c81829b2 | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:551 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d1b7666c | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:553 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-39733575 | popSql.OnSql [if (programID == "PR_UI_FP02510_Model_Routing"… 외 1 | FP02510_Model_Routing.cs:558 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02510_Model_Routing.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22707b88 | this.Load | FP02510_Model_Routing.cs:124 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02510_Model_Routing.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f6b7a4d | (진입점 미연결) | FP02510_Model_Routing.cs:849 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP02510_Model_Routing.GetToDay

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f69f770 | this.Load [try] | FP02510_Model_Routing.cs:838 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-fd4188e9 | this.Load [try] | FP02510_Model_Routing.cs:839 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP02510_Model_Routing.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e985cd61 | this.Load | FP02510_Model_Routing.cs:146 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b954421 | this.Load | FP02510_Model_Routing.cs:149 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-14cfb92d | this.Load | FP02510_Model_Routing.cs:152 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-58716346 | this.Load | FP02510_Model_Routing.cs:153 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-006249df | this.Load | FP02510_Model_Routing.cs:158 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-dc686caa | this.Load | FP02510_Model_Routing.cs:160 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-900557ef | this.Load | FP02510_Model_Routing.cs:183 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-830771b8 | this.Load | FP02510_Model_Routing.cs:184 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-26836b6a | this.Load | FP02510_Model_Routing.cs:185 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f96813a8 | this.Load | FP02510_Model_Routing.cs:192 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02510_Model_Routing.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78ad808a | this.Load | FP02510_Model_Routing.cs:247 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02510_Model_Routing.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-713d0115 | this.Load | FP02510_Model_Routing.cs:307 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ec7807d | this.Load | FP02510_Model_Routing.cs:308 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c29247aa | this.Load | FP02510_Model_Routing.cs:312 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02510_Model_Routing.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5549f31b | InsertButton | FP02510_Model_Routing.cs:364 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3c70f250 | InsertButton | FP02510_Model_Routing.cs:365 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02510_Model_Routing.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e60c5aa1 | popSql.OnSql | FP02510_Model_Routing.cs:1011 | if (programID == "PR_UI_FP02510_Model_Routing") | RETURN | return Find_Data_Inventory("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-35b68807 | popSql.OnSql | FP02510_Model_Routing.cs:1014 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02510_Model_Routing.SetChangedControl

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1170c1a9 | this.Load [try] | FP02510_Model_Routing.cs:239 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02510_Model_Routing.SetDivision

진입점: this.Load [try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1adba964 | this.Load [try ▸ try] | FP02510_Model_Routing.cs:855 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-35a5d2e8 | this.Load [try ▸ try] | FP02510_Model_Routing.cs:855 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-34709d2f | this.Load [try ▸ try] | FP02510_Model_Routing.cs:858 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-c9f1f762 | this.Load [try ▸ try] | FP02510_Model_Routing.cs:861 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02510_Model_Routing.SetFactory

진입점: this.Load [try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50cbd87b | this.Load [try ▸ try] | FP02510_Model_Routing.cs:943 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-9e95f270 | this.Load [try ▸ try] | FP02510_Model_Routing.cs:948 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |

## FP02510_Model_Routing.SetFilter

진입점: this.Load [try ▸ try] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f829865 | this.Load [try ▸ try] 외 2 | FP02510_Model_Routing.cs:844 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02510_Model_Routing.SetPlant

진입점: this.Load [try ▸ try] / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2fb02e8 | this.Load [try ▸ try] 외 1 | FP02510_Model_Routing.cs:910 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e8873e2 | this.Load [try ▸ try] 외 1 | FP02510_Model_Routing.cs:915 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-11991c65 | this.Load [try ▸ try] 외 1 | FP02510_Model_Routing.cs:919 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-b7c7dd33 | this.Load [try ▸ try] 외 1 | FP02510_Model_Routing.cs:919 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP02510_Model_Routing.SetSite

진입점: this.Load [try ▸ try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e00c9571 | this.Load [try ▸ try] 외 1 | FP02510_Model_Routing.cs:883 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d43cbdf | this.Load [try ▸ try] 외 1 | FP02510_Model_Routing.cs:886 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-d3c1ee2c | this.Load [try ▸ try] 외 1 | FP02510_Model_Routing.cs:886 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", "", "", "", pDivisi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-609f7328 | this.Load [try ▸ try] 외 1 | FP02510_Model_Routing.cs:887 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP02510_Model_Routing.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcd731fb | this.Load [try] | FP02510_Model_Routing.cs:321 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6125bce8 | this.Load [try] | FP02510_Model_Routing.cs:322 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-9307f70e | this.Load [try] | FP02510_Model_Routing.cs:327 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-8bc41bb6 | this.Load [try] | FP02510_Model_Routing.cs:331 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c74040c1 | this.Load [try] | FP02510_Model_Routing.cs:332 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CUTOFF_DATE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-410290b1 | this.Load [try] | FP02510_Model_Routing.cs:333 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SEQ)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-438afcab | this.Load [try] | FP02510_Model_Routing.cs:334 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.HOLDING_DATE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-37d760ff | this.Load [try] | FP02510_Model_Routing.cs:335 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INPUT_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0dde3adc | this.Load [try] | FP02510_Model_Routing.cs:336 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.QTY_UOM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0ede7e91 | this.Load [try] | FP02510_Model_Routing.cs:337 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.OPERATION_SEQ)].Visible | false | 그리드 속성/값 설정 |  |  |  |

