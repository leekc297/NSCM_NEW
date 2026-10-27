# AS-IS 액션 대조표 — FP00310

> 원천: `Doc/asisfacts/screens/FP00310/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 143행 · 메서드 28 · 종류 DATA_OP 30 · FLAG 20 · RETURN 14 · LIST_REBIND 11 · COMBO_DATA 11 · GRID_INIT 10 · UI_PROP 9 · UI_MISC 6 · MESSAGE 5 · POPUP 4 · GRID_SET 4 · VALIDATE 3 · ENDPOINT 3 · CALL_EXT 2 · GRID_BIND 2 · STATE 2 · THROW 2 · STATE_RESET 1 · EXCEL 1 · GRID_LOCK 1 · GRID_STYLE 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 3


## FP00310_Formation_Yield.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ab9d93a | this.btnSql.Click | FP00310_Formation_Yield.cs:620 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ed22ee48 | this.btnSql.Click | FP00310_Formation_Yield.cs:621 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d2a6be25 | this.btnSql.Click | FP00310_Formation_Yield.cs:623 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00310_FORMATION_YIELD") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed80f719 | this.btnSql.Click | FP00310_Formation_Yield.cs:625 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00310_Formation_Yield.CheckValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-126455d1 | (진입점 미연결) | FP00310_Formation_Yield.cs:1067 | try ▸ if (spd.SpreadObject.DataSource == null) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-36114bbf | (진입점 미연결) | FP00310_Formation_Yield.cs:1096 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sUserID)) ▸ if (sUserID == schkUserID) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d4fedd8b | (진입점 미연결) | FP00310_Formation_Yield.cs:1097 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sUserID)) ▸ if (sUserID == schkUserID) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d71921af | (진입점 미연결) | FP00310_Formation_Yield.cs:1105 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-ac993a53 | (진입점 미연결) | FP00310_Formation_Yield.cs:1107 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00310_Formation_Yield.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad6b5047 | (진입점 미연결) | FP00310_Formation_Yield.cs:301 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8fab73dd | (진입점 미연결) | FP00310_Formation_Yield.cs:302 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00310_Formation_Yield.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c68fd7d0 | this.Load | FP00310_Formation_Yield.cs:311 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9d272194 | this.Load | FP00310_Formation_Yield.cs:312 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e2e58631 | this.Load | FP00310_Formation_Yield.cs:314 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00310_Formation_Yield.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b2fadd4 | this.Load | FP00310_Formation_Yield.cs:190 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-488b6dbc | this.Load | FP00310_Formation_Yield.cs:192 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a177840e | this.Load | FP00310_Formation_Yield.cs:193 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-2e42c9ca | this.Load | FP00310_Formation_Yield.cs:194 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00310_Formation_Yield.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56ad5b50 | DeleteButton | FP00310_Formation_Yield.cs:408 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de3c2ee4 | DeleteButton | FP00310_Formation_Yield.cs:409 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00310_Formation_Yield.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76c74441 | Dispose | FP00310_Formation_Yield.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00310_Formation_Yield.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0456b82a | EditButton | FP00310_Formation_Yield.cs:392 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39f39b98 | EditButton | FP00310_Formation_Yield.cs:393 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00310_Formation_Yield.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29235cd8 | ExcelButton | FP00310_Formation_Yield.cs:608 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00310_Formation_Yield.Find_Data

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-330f3ca8 | FindButton | FP00310_Formation_Yield.cs:435 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ef65d2f0 | FindButton | FP00310_Formation_Yield.cs:440 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b46635a3 | FindButton | FP00310_Formation_Yield.cs:441 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f2aa903 | FindButton | FP00310_Formation_Yield.cs:444 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-74407c17 | FindButton | FP00310_Formation_Yield.cs:447 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d73dca31 | FindButton | FP00310_Formation_Yield.cs:450 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-80b1b93a | FindButton | FP00310_Formation_Yield.cs:450 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-06aaf924 | FindButton | FP00310_Formation_Yield.cs:458 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8bb675c5 | FindButton | FP00310_Formation_Yield.cs:461 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71672297 | FindButton | FP00310_Formation_Yield.cs:467 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Yield("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-41c3605e | FindButton | FP00310_Formation_Yield.cs:479 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5097e799 | FindButton | FP00310_Formation_Yield.cs:481 | try ▸ if (ds != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e7c15d42 | FindButton | FP00310_Formation_Yield.cs:484 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-361c02da | FindButton | FP00310_Formation_Yield.cs:488 | try ▸ if (ds != null) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-067b0aef | FindButton | FP00310_Formation_Yield.cs:496 | try ▸ if (ds != null) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-fc39d98e | FindButton | FP00310_Formation_Yield.cs:501 | try ▸ else of (ds != null) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-36d90c95 | FindButton | FP00310_Formation_Yield.cs:503 | try ▸ else of (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fe748195 | FindButton | FP00310_Formation_Yield.cs:505 | try ▸ else of (ds != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-58ab2565 | FindButton | FP00310_Formation_Yield.cs:510 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6149a586 | FindButton | FP00310_Formation_Yield.cs:514 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-24af8fac | FindButton | FP00310_Formation_Yield.cs:515 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-32d09599 | FindButton | FP00310_Formation_Yield.cs:516 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8a5916a6 | FindButton | FP00310_Formation_Yield.cs:516 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00310_Formation_Yield.Find_Data_Yield

진입점: popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIELD")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e31b5be2 | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:530 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivisionID = CString.GetCheckedListValue(d… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef859c51 | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:549 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00310_FORMATION_YIELD") ⇒ FP_Master.PR_UI_FP00310_FORMATION_YIELD | 엔드포인트 요청 생성 |  |  |  |
| AC-df8eceeb | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:551 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-f55c1708 | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:552 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-d6d9e08d | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:553 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36a7fa9f | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:554 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9fe52fb7 | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:556 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-329f45f4 | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:557 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-9d0e88c6 | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:558 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-afafe3ee | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:559 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-3a40e96b | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:560 | try | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? "" : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-33180961 | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:561 | try | DATA_OP | request.Parameters["p_item_id"] | pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-c02f9f52 | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:562 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-84013cd8 | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:565 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c11204e | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:567 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b4f5625b | popSql.OnSql [if (programID == "PR_UI_FP00310_FORMATION_YIEL… 외 1 | FP00310_Formation_Yield.cs:572 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00310_Formation_Yield.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea98c64c | this.Load | FP00310_Formation_Yield.cs:122 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00310_Formation_Yield.GetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-787340e8 | this.Load [try] | FP00310_Formation_Yield.cs:201 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-020318e7 | this.Load [try] | FP00310_Formation_Yield.cs:202 |  | FLAG | dtMyDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f95f2ddc | this.Load [try] | FP00310_Formation_Yield.cs:202 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1e327b35 | this.Load [try] | FP00310_Formation_Yield.cs:205 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-3e5b8108 | this.Load [try] | FP00310_Formation_Yield.cs:208 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00310_Formation_Yield.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19fd25a7 | (진입점 미연결) | FP00310_Formation_Yield.cs:864 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00310_Formation_Yield.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d0f9477 | this.Load | FP00310_Formation_Yield.cs:144 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-597477e2 | this.Load | FP00310_Formation_Yield.cs:147 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdc16b90 | this.Load | FP00310_Formation_Yield.cs:150 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-32243310 | this.Load | FP00310_Formation_Yield.cs:151 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-62aead40 | this.Load | FP00310_Formation_Yield.cs:156 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-d701cdf1 | this.Load | FP00310_Formation_Yield.cs:158 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-1a9bd422 | this.Load | FP00310_Formation_Yield.cs:174 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2c392b93 | this.Load | FP00310_Formation_Yield.cs:175 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9a0bdc34 | this.Load | FP00310_Formation_Yield.cs:176 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fa1bef48 | this.Load | FP00310_Formation_Yield.cs:183 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00310_Formation_Yield.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea99e608 | this.Load | FP00310_Formation_Yield.cs:270 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5a59f68f | this.Load | FP00310_Formation_Yield.cs:271 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1ce03feb | this.Load | FP00310_Formation_Yield.cs:272 |  | UI_PROP | clbBuilding.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9e4d7922 | this.Load | FP00310_Formation_Yield.cs:273 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00310_Formation_Yield.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b8467b6 | this.Load | FP00310_Formation_Yield.cs:326 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98ebdad4 | this.Load | FP00310_Formation_Yield.cs:327 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-efa75b59 | this.Load | FP00310_Formation_Yield.cs:331 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00310_Formation_Yield.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d6613a3 | InsertButton | FP00310_Formation_Yield.cs:378 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a16adcac | InsertButton | FP00310_Formation_Yield.cs:379 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00310_Formation_Yield.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5722186 | popSql.OnSql | FP00310_Formation_Yield.cs:1055 | if (programID == "PR_UI_FP00310_FORMATION_YIELD") | RETURN | return Find_Data_Yield("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-93005a30 | popSql.OnSql | FP00310_Formation_Yield.cs:1058 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00310_Formation_Yield.SetChangeControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbBuilding.SelectedIndexChanged / clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-795ccd46 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:219 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtMyDivision.Good()) | FLAG | dtMyDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-91f48597 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:219 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtMyDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8b182f3e | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:225 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good()) | FLAG | dtSiteByDivision | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-fee6e4be | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:225 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-46ed42b9 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:226 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-53687755 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:232 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSiteByDivision, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-7870061b | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:233 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) | FLAG | dtPlantByDivision | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-efd6cd60 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:233 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5f6174dc | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:234 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-62b90a04 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:241 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByDivision.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlantByDivision, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-04eb446f | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:242 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByDivision.Good()) | FLAG | dtBuildingBySitePlant | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-385cc088 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:242 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c3c19e09 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:243 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0ea6a5d5 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:250 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingBySitePlant.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtBuildingBySitePlant, clbBuilding.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-07b84976 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:252 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingBySitePlant.Good()) | DATA_OP | Filter["OPERATION_ID"] | pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-070fd606 | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:253 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingBySitePlant.Good()) | FLAG | dtLineByOperation | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc0e888f | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:253 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingBySitePlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9b8f910b | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:254 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingBySitePlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c44890bc | this.Load [try] 외 5 | FP00310_Formation_Yield.cs:260 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLineByOperation.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLineByOperation, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00310_Formation_Yield.SetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7291a92 | (진입점 미연결) | FP00310_Formation_Yield.cs:870 |  | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-951df910 | (진입점 미연결) | FP00310_Formation_Yield.cs:870 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8ca3fb12 | (진입점 미연결) | FP00310_Formation_Yield.cs:873 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-4c2ea18c | (진입점 미연결) | FP00310_Formation_Yield.cs:876 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00310_Formation_Yield.SetFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e9a85d9 | (진입점 미연결) | FP00310_Formation_Yield.cs:958 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7ea574e | (진입점 미연결) | FP00310_Formation_Yield.cs:963 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-25dd6194 | (진입점 미연결) | FP00310_Formation_Yield.cs:968 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-64a7f7dc | (진입점 미연결) | FP00310_Formation_Yield.cs:972 |  | FLAG | dtBuildingBySitePlant | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-eee20015 | (진입점 미연결) | FP00310_Formation_Yield.cs:972 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3af44771 | (진입점 미연결) | FP00310_Formation_Yield.cs:973 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00310_Formation_Yield.SetFilter

진입점: this.Load [try ▸ switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good())] / clbBuilding.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good())] / clbLine.SelectedIndexChanged [switch (t…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f94cac7b | this.Load [try ▸ switch (triggerControl) case DefColumns.DIV… 외 6 | FP00310_Formation_Yield.cs:859 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00310_Formation_Yield.SetLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecc058e5 | (진입점 미연결) | FP00310_Formation_Yield.cs:1042 |  | FLAG | dtLineByOperation | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00310_findLineCode_common", "", pDivis… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-1d08601c | (진입점 미연결) | FP00310_Formation_Yield.cs:1042 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00310_findLineCode_common", "", pDivisionID, pSiteID, pPlantID, pFacto… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a2edea07 | (진입점 미연결) | FP00310_Formation_Yield.cs:1043 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00310_Formation_Yield.SetOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-328a8ecf | (진입점 미연결) | FP00310_Formation_Yield.cs:995 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-97bade8f | (진입점 미연결) | FP00310_Formation_Yield.cs:1000 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-a43b70b8 | (진입점 미연결) | FP00310_Formation_Yield.cs:1005 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d9002d1 | (진입점 미연결) | FP00310_Formation_Yield.cs:1010 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |

## FP00310_Formation_Yield.SetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94fedffd | (진입점 미연결) | FP00310_Formation_Yield.cs:925 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc7cff7a | (진입점 미연결) | FP00310_Formation_Yield.cs:930 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-ddd384a3 | (진입점 미연결) | FP00310_Formation_Yield.cs:934 |  | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-6cbc48ab | (진입점 미연결) | FP00310_Formation_Yield.cs:934 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9c7624b8 | (진입점 미연결) | FP00310_Formation_Yield.cs:935 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00310_Formation_Yield.SetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce120c02 | (진입점 미연결) | FP00310_Formation_Yield.cs:898 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-45e79c5c | (진입점 미연결) | FP00310_Formation_Yield.cs:901 |  | FLAG | dtSiteByDivision | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-92e316ee | (진입점 미연결) | FP00310_Formation_Yield.cs:901 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", "", "", "", pDivisi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea10636b | (진입점 미연결) | FP00310_Formation_Yield.cs:902 |  | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00310_Formation_Yield.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-273c49ff | this.Load [try] | FP00310_Formation_Yield.cs:340 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4cc0e68 | this.Load [try] | FP00310_Formation_Yield.cs:341 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-ba8f29ce | this.Load [try] | FP00310_Formation_Yield.cs:346 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-464392a7 | this.Load [try] | FP00310_Formation_Yield.cs:347 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.LINE_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c42868b8 | this.Load [try] | FP00310_Formation_Yield.cs:350 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c07e895b | this.Load [try] | FP00310_Formation_Yield.cs:351 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |

