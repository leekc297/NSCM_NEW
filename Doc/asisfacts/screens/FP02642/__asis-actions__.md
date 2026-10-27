# AS-IS 액션 대조표 — FP02642

> 원천: `Doc/asisfacts/screens/FP02642/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 157행 · 메서드 21 · 종류 DATA_OP 47 · FLAG 28 · UI_PROP 17 · LIST_REBIND 14 · COMBO_DATA 10 · RETURN 8 · GRID_INIT 6 · POPUP 4 · STATE 4 · UI_MISC 4 · ENDPOINT 3 · THROW 3 · MESSAGE 2 · EXCEL 1 · CALL_BASE 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · VALUE_SET 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 1


## FP02642_WO_History.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6194b378 | this.btnSql.Click | FP02642_WO_History.cs:416 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-894aec31 | this.btnSql.Click | FP02642_WO_History.cs:417 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f0b7065a | this.btnSql.Click | FP02642_WO_History.cs:419 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02642_WO_History") | 데이터 객체 조작/조회 |  |  |  |
| AC-6fb268e4 | this.btnSql.Click | FP02642_WO_History.cs:420 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02642_WO_History.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eef7680c | (진입점 미연결) | FP02642_WO_History.cs:712 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02642_WO_History.ClbDivision_SelectedIndexChanged

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10561d00 | this.Load 외 1 | FP02642_WO_History.cs:617 |  | FLAG | dtProdType | Data_FP.Common_FP(Data_FP.Type.PRODUCTION_TYPE, false, UserInfoContext.Current.UserId, _sN… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-52dcefcb | this.Load 외 1 | FP02642_WO_History.cs:617 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PRODUCTION_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b059a4e7 | this.Load 외 1 | FP02642_WO_History.cs:618 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cboProdType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP02642_WO_History.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7dd8edf | this.Load | FP02642_WO_History.cs:370 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e8b86579 | this.Load | FP02642_WO_History.cs:371 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cb0512fe | this.Load | FP02642_WO_History.cs:372 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02642_WO_History.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51c44eab | this.Load | FP02642_WO_History.cs:158 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-baba38c9 | this.Load | FP02642_WO_History.cs:159 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-a3258702 | this.Load | FP02642_WO_History.cs:160 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6c1e2a6d | this.Load | FP02642_WO_History.cs:164 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bc083a28 | this.Load | FP02642_WO_History.cs:165 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-da44532f | this.Load | FP02642_WO_History.cs:166 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02642_WO_History.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5901dfa3 | Dispose | FP02642_WO_History.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02642_WO_History.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b4d1c8e | EditButton | FP02642_WO_History.cs:398 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b46b8987 | EditButton | FP02642_WO_History.cs:399 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02642_WO_History.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe4b7f39 | ExcelButton | FP02642_WO_History.cs:409 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP02642_WO_History.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35863a55 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:513 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pInstanceID = CString.GetCheckedListValue(dtInstance, cbo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c68e694a | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:516 | try ▸ lambda | FLAG | pInstanceID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-593014f2 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:517 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-9e7730fd | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:518 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-0bb1964f | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:519 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d77b977 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:520 | try ▸ lambda | FLAG | pFactoryID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-269bae21 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:521 | try ▸ lambda | FLAG | pOperationID | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a76a1bc | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:522 | try ▸ lambda | FLAG | pLineID | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc347b0f | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:527 | try ▸ lambda | FLAG | pProdType | cboProdType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-5078c3bf | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:548 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02642_WO_HISTORY") ⇒ FP_Master.PR_UI_FP02642_WO_HISTORY | 엔드포인트 요청 생성 |  |  |  |
| AC-07b3cf4e | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:549 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1d42fed1 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:550 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-71cb17fd | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:551 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-96a98723 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:552 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1852ca7f | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:553 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-831d130a | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:555 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstanceID.Equals("ALL") ? DBNull.Value : pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-cd7d4d43 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:556 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-db623e07 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:557 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-d7a467ac | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:558 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-3954f2d7 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:559 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-f660ccec | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:560 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-bdb724f1 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:561 | try | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? DBNull.Value : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-39232ff8 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:562 | try | DATA_OP | request.Parameters["p_top_item_id"] | pTopItemId.Equals("ALL") ? DBNull.Value : pTopItemId | 행/컬럼 값 대입 |  |  |  |
| AC-c63ae8ef | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:563 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-f7a52883 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:564 | try | DATA_OP | request.Parameters["p_work_order_id"] | pWorkOrderId.Equals("ALL") ? DBNull.Value : pWorkOrderId | 행/컬럼 값 대입 |  |  |  |
| AC-69346fd6 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:565 | try | DATA_OP | request.Parameters["p_from_date"] | p_from_date.Equals("ALL") ? DBNull.Value : p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-548ae713 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:566 | try | DATA_OP | request.Parameters["p_to_date"] | p_to_date.Equals("ALL") ? DBNull.Value : p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-7cd34d54 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:567 | try | DATA_OP | request.Parameters["p_update_from_date"] | p_update_from_date.Equals("ALL") ? DBNull.Value : p_update_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-d840d2ab | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:568 | try | DATA_OP | request.Parameters["p_update_to_date"] | p_update_to_date.Equals("ALL") ? DBNull.Value : p_update_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-cbfdb6e4 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:569 | try | DATA_OP | request.Parameters["p_prod_type"] | pProdType.Equals("ALL") ? DBNull.Value : pProdType | 행/컬럼 값 대입 |  |  |  |
| AC-04d855b4 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:570 | try | DATA_OP | request.Parameters["p_status"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d3a0f1fa | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:573 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a5ecfc95 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:575 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fe39cc97 | popSql.OnSql [if (programID == "PR_UI_FP02642_WO_History")] 외 1 | FP02642_WO_History.cs:582 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02642_WO_History.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbeae55e | FindButton | FP02642_WO_History.cs:428 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-60dbf55e | FindButton | FP02642_WO_History.cs:432 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-371a9dc5 | FindButton | FP02642_WO_History.cs:432 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22a0778f | FindButton | FP02642_WO_History.cs:436 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4282cc4 | FindButton | FP02642_WO_History.cs:437 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82a9da22 | FindButton | FP02642_WO_History.cs:440 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6bf0d5ea | FindButton | FP02642_WO_History.cs:446 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f09e5aa6 | FindButton | FP02642_WO_History.cs:453 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5fe2acef | FindButton | FP02642_WO_History.cs:455 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-214eee35 | FindButton | FP02642_WO_History.cs:464 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0c231de9 | FindButton | FP02642_WO_History.cs:468 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f28ae403 | FindButton | FP02642_WO_History.cs:471 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fa528aa2 | FindButton | FP02642_WO_History.cs:475 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4424952 | FindButton | FP02642_WO_History.cs:486 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-46502601 | FindButton | FP02642_WO_History.cs:487 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02642_WO_History.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c4bcd7f | this.Load | FP02642_WO_History.cs:137 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02642_WO_History.GetPlanGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc8ee388 | this.Load | FP02642_WO_History.cs:222 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6617dbe6 | this.Load | FP02642_WO_History.cs:223 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1e52d33 | this.Load | FP02642_WO_History.cs:223 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a3d76068 | this.Load | FP02642_WO_History.cs:225 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-0ac186fb | this.Load | FP02642_WO_History.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-705bc9a8 | this.Load | FP02642_WO_History.cs:230 | if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-174270f5 | this.Load | FP02642_WO_History.cs:231 | if (cboInstance.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-6023ec3d | this.Load | FP02642_WO_History.cs:231 | if (cboInstance.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-59cb240a | this.Load | FP02642_WO_History.cs:232 | if (cboInstance.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cboInstance.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b346e2d | this.Load | FP02642_WO_History.cs:233 | if (cboInstance.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cboInstance.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-339326a1 | this.Load | FP02642_WO_History.cs:234 | if (cboInstance.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cboInstance.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-056fc63d | this.Load | FP02642_WO_History.cs:238 | else of (cboInstance.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP02642_WO_History.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bef1a3c | this.Load | FP02642_WO_History.cs:173 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0ed10ffd | this.Load | FP02642_WO_History.cs:175 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-9436650d | this.Load | FP02642_WO_History.cs:180 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3e02f1f8 | this.Load | FP02642_WO_History.cs:181 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-bd076c24 | this.Load | FP02642_WO_History.cs:190 |  | FLAG | dtCurDate | Data_FP.Common_FP(Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 화면 필드/플래그 변경 |  |  |  |
| AC-be774bc3 | this.Load | FP02642_WO_History.cs:190 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-69e4e188 | this.Load | FP02642_WO_History.cs:192 |  | FLAG | sCurDate | (string)dtCurDate.Rows[0]["CUR_DATE"] | 화면 필드/플래그 변경 |  |  |  |
| AC-696fbaa3 | this.Load | FP02642_WO_History.cs:193 |  | FLAG | sPlanDate | sCurDate.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-71b93d13 | this.Load | FP02642_WO_History.cs:194 |  | FLAG | sPrevDate | sCurDate | 화면 필드/플래그 변경 |  |  |  |
| AC-d22d1e6c | this.Load | FP02642_WO_History.cs:199 |  | UI_PROP | drpPeriod.Text1 | DateUtil.GetDateAdd(sCurDate.Replace("-", ""), -7, "D") | 속성 Text1 설정 |  |  |  |
| AC-be4fab07 | this.Load | FP02642_WO_History.cs:200 |  | UI_PROP | drpPeriod.Text2 | DateUtil.GetDateAdd(sCurDate.Replace("-", ""), 7, "D") | 속성 Text2 설정 |  |  |  |
| AC-64064c60 | this.Load | FP02642_WO_History.cs:202 |  | UI_PROP | drpUpdate.Text1 | DateUtil.GetDateAdd(sCurDate.Replace("-", "").Replace("/",""), -30, "D") | 속성 Text1 설정 |  |  |  |
| AC-0f3f3a56 | this.Load | FP02642_WO_History.cs:203 |  | UI_PROP | drpUpdate.Text2 | sCurDate | 속성 Text2 설정 |  |  |  |

## FP02642_WO_History.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c542b72 | this.Load | FP02642_WO_History.cs:346 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-096967b3 | this.Load | FP02642_WO_History.cs:347 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-2b76d7c0 | this.Load | FP02642_WO_History.cs:348 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-55c91cfc | this.Load | FP02642_WO_History.cs:349 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02642_WO_History.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea5e9510 | this.Load 외 1 | FP02642_WO_History.cs:379 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b71acb44 | this.Load 외 1 | FP02642_WO_History.cs:381 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-44d8d073 | this.Load 외 1 | FP02642_WO_History.cs:383 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02642_WO_History.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39d3abfb | popSql.OnSql | FP02642_WO_History.cs:725 | if (programID == "PR_UI_FP02642_WO_History") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-bcfa8258 | popSql.OnSql | FP02642_WO_History.cs:728 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02642_WO_History.Search_After

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3be00667 | (진입점 미연결) | FP02642_WO_History.cs:652 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a5c7237 | (진입점 미연결) | FP02642_WO_History.cs:659 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fe9a6ca4 | (진입점 미연결) | FP02642_WO_History.cs:665 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sReturn_Status.Equals("Error")) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_ID), i, siMain.GetColumnIndex(DefColumns.WO… | 그리드 표시 설정 |  |  |  |

## FP02642_WO_History.SetChangeControl

진입점: this.Load / cboInstance.SelectedIndexChanged / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / cboOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfa45c9d | this.Load 외 7 | FP02642_WO_History.cs:249 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-701db2b9 | this.Load 외 7 | FP02642_WO_History.cs:249 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f5c252d8 | this.Load 외 7 | FP02642_WO_History.cs:258 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1314ee1e | this.Load 외 7 | FP02642_WO_History.cs:259 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1783e5a9 | this.Load 외 7 | FP02642_WO_History.cs:259 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5c867175 | this.Load 외 7 | FP02642_WO_History.cs:262 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ if ((object)clbDivision is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, (object)clbDivision as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ba904408 | this.Load 외 7 | FP02642_WO_History.cs:264 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ else of ((object)clbDivision is UsrCombo) ▸ if ((object)clbD… | LIST_REBIND | clsCtrl.setListBox | (dtDivision, (object)clbDivision as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f628dd1f | this.Load 외 7 | FP02642_WO_History.cs:270 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8f1a3587 | this.Load 외 7 | FP02642_WO_History.cs:271 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7494df96 | this.Load 외 7 | FP02642_WO_History.cs:271 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d0aacc72 | this.Load 외 7 | FP02642_WO_History.cs:274 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)cboSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bad165b2 | this.Load 외 7 | FP02642_WO_History.cs:276 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)cboSite is UsrCombo) ▸ if ((object)cboSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-75c0dcd9 | this.Load 외 7 | FP02642_WO_History.cs:282 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-0b964260 | this.Load 외 7 | FP02642_WO_History.cs:283 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b38d8633 | this.Load 외 7 | FP02642_WO_History.cs:283 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-80fc7229 | this.Load 외 7 | FP02642_WO_History.cs:286 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-95bbfac8 | this.Load 외 7 | FP02642_WO_History.cs:288 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6dca20a9 | this.Load 외 7 | FP02642_WO_History.cs:294 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-522703df | this.Load 외 7 | FP02642_WO_History.cs:295 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-97a55877 | this.Load 외 7 | FP02642_WO_History.cs:295 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-28d56ebe | this.Load 외 7 | FP02642_WO_History.cs:297 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ if ((object)clbFactory is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d0064328 | this.Load 외 7 | FP02642_WO_History.cs:299 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ else of ((object)clbFactory is UsrCombo) ▸ if ((object)clbFactory … | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dc4879d6 | this.Load 외 7 | FP02642_WO_History.cs:305 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3bcac217 | this.Load 외 7 | FP02642_WO_History.cs:306 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-94b78727 | this.Load 외 7 | FP02642_WO_History.cs:306 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f6d91850 | this.Load 외 7 | FP02642_WO_History.cs:308 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if ((object)cboOperation is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, (object)cboOperation as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3be40f6b | this.Load 외 7 | FP02642_WO_History.cs:310 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ else of ((object)cboOperation is UsrCombo) ▸ if ((object)cboOp… | LIST_REBIND | clsCtrl.setListBox | (dtOperation, (object)cboOperation as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b30118b6 | this.Load 외 7 | FP02642_WO_History.cs:316 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-29cb9801 | this.Load 외 7 | FP02642_WO_History.cs:317 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c9671d43 | this.Load 외 7 | FP02642_WO_History.cs:317 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-fb845f4d | this.Load 외 7 | FP02642_WO_History.cs:319 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) ▸ if ((object)clbLine is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)clbLine as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-60875ff9 | this.Load 외 7 | FP02642_WO_History.cs:321 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) ▸ else of ((object)clbLine is UsrCombo) ▸ if ((object)clbLin… | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)clbLine as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c8eddba7 | this.Load 외 7 | FP02642_WO_History.cs:327 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP02642_WO_History.SetFilter

진입점: this.Load [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboInstance.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbFactory.SelectedIndexChanged [switch (triggerControl…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82f8f4a0 | this.Load [switch (triggerControl) case DefColumns.INSTANCE_… 외 7 | FP02642_WO_History.cs:218 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02642_WO_History.tbItemId_BeforeOpenSearch

진입점: this.tbItemId.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d290a42d | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:742 |  | DATA_OP | tbItemId.Filter["division_lt"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-158bf2d0 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:743 |  | DATA_OP | tbItemId.Filter["site_lt"] | cboSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-76737ab2 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:747 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 25) | 데이터 객체 조작/조회 |  |  |  |
| AC-71a663b3 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:748 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-226e1920 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:749 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-32285565 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:750 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-26699edd | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:751 |  | DATA_OP | _col_width.Add | ("item".ToUpper(), 150) | 데이터 객체 조작/조회 |  |  |  |
| AC-503d5e78 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:752 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 150) | 데이터 객체 조작/조회 |  |  |  |
| AC-ceae8559 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:753 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-404f6c25 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:757 |  | DATA_OP | _col_title.Add | ("Material".ToUpper(), "Material") | 데이터 객체 조작/조회 |  |  |  |
| AC-432df96b | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:759 |  | UI_PROP | tbItemId.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-c0b282a3 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:760 |  | UI_PROP | tbItemId.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |
| AC-e3ae9159 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:762 |  | UI_PROP | tbItemId.PopupWidth | 800 | 속성 PopupWidth 설정 |  |  |  |
| AC-712c6943 | this.tbItemId.BeforeOpenSearch | FP02642_WO_History.cs:763 |  | UI_PROP | tbItemId.PopupHeight | 600 | 속성 PopupHeight 설정 |  |  |  |

## FP02642_WO_History.tbItemId_OnSearchConditionChanged

진입점: this.tbItemId.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07c976e9 | this.tbItemId.OnSearchConditionChanged | FP02642_WO_History.cs:777 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

