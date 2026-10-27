# AS-IS 액션 대조표 — FP01630

> 원천: `Doc/asisfacts/screens/FP01630/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 225행 · 메서드 28 · 종류 FLAG 59 · DATA_OP 41 · UI_PROP 19 · RETURN 18 · MESSAGE 13 · COMBO_DATA 12 · LIST_REBIND 11 · CALL_EXT 8 · GRID_STYLE 7 · UI_MISC 6 · GRID_INIT 5 · ENDPOINT 5 · POPUP 4 · STATE 4 · GRID_SET 4 · GRID_LOCK 3 · VALIDATE 2 · EXCEL 1 · CALL_BASE 1 · THROW 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 9


## FP01630_Close_Work_Order.btnCancle_Click

진입점: this.btnCancle.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-054284c3 | this.btnCancle.Click | FP01630_Close_Work_Order.cs:1161 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f3ade91f | this.btnCancle.Click | FP01630_Close_Work_Order.cs:1162 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8822f012 | this.btnCancle.Click | FP01630_Close_Work_Order.cs:1168 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1eb0b700 | this.btnCancle.Click | FP01630_Close_Work_Order.cs:1172 | else of (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("Do you want to run the Cancel W/O ?") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01630_Close_Work_Order.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59728969 | this.btnSql.Click | FP01630_Close_Work_Order.cs:447 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5f97d0a4 | this.btnSql.Click | FP01630_Close_Work_Order.cs:448 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c95a7d0b | this.btnSql.Click | FP01630_Close_Work_Order.cs:450 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01630_CLOSE_WORK_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-65091ba5 | this.btnSql.Click | FP01630_Close_Work_Order.cs:451 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01630_Close_Work_Order.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b8eae6c | (진입점 미연결) | FP01630_Close_Work_Order.cs:967 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01630_Close_Work_Order.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a8a81f0 | this.Load | FP01630_Close_Work_Order.cs:374 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-55bdce43 | this.Load | FP01630_Close_Work_Order.cs:375 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b3967fda | this.Load | FP01630_Close_Work_Order.cs:376 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01630_Close_Work_Order.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faf5cc06 | this.Load | FP01630_Close_Work_Order.cs:155 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b33c91cc | this.Load | FP01630_Close_Work_Order.cs:156 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-a4694c13 | this.Load | FP01630_Close_Work_Order.cs:157 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4689b270 | this.Load | FP01630_Close_Work_Order.cs:161 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-811456aa | this.Load | FP01630_Close_Work_Order.cs:162 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-ac79303e | this.Load | FP01630_Close_Work_Order.cs:163 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP01630_Close_Work_Order.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d12fda20 | Dispose | FP01630_Close_Work_Order.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01630_Close_Work_Order.DrpPeriod_ValueChanged

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1addb1fc | drpPeriod.ValueChanged | FP01630_Close_Work_Order.cs:853 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (drpPeriod.Text1, drpPeriod.Text2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-01561b8f | drpPeriod.ValueChanged | FP01630_Close_Work_Order.cs:858 | if (dayCount > 56) | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { dayCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd82f4f3 | drpPeriod.ValueChanged | FP01630_Close_Work_Order.cs:861 | if (dayCount > 56) | UI_PROP | drpPeriod.Text2 | DateUtil_FP.gfn_addDate(drpPeriod.Value1.ToString("yyyyMMdd"), 55) | 속성 Text2 설정 |  |  |  |
| AC-54cf0700 | drpPeriod.ValueChanged | FP01630_Close_Work_Order.cs:861 | if (dayCount > 56) | CALL_EXT | DateUtil_FP.gfn_addDate | (drpPeriod.Value1.ToString("yyyyMMdd"), 55) | ⚠ 의미 확인 필요 |  |  |  |

## FP01630_Close_Work_Order.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d73dcd79 | EditButton | FP01630_Close_Work_Order.cs:417 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c33c597 | EditButton | FP01630_Close_Work_Order.cs:419 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e875262e | EditButton | FP01630_Close_Work_Order.cs:421 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.ERP_MESSA… | 그리드 편집 잠금/해제 |  |  |  |

## FP01630_Close_Work_Order.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9429482e | ExcelButton | FP01630_Close_Work_Order.cs:434 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP01630_Close_Work_Order.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORDER")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-861aca81 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:544 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = CString.GetCheckedListValue(dtDivision, clb… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f163b00 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:546 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b1cc8a32 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:547 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a4f1697 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:548 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-0574a95a | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:549 | try ▸ lambda | FLAG | pFactoryID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-2718ff1f | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:550 | try ▸ lambda | FLAG | pOperationID | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-f927c0ba | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:551 | try ▸ lambda | FLAG | pLineID | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b60d1b0e | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:573 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01630_CLOSE_WORK_ORDER") ⇒ FP_Master.PR_UI_FP01630_CLOSE_WORK_ORDER | 엔드포인트 요청 생성 |  |  |  |
| AC-09abd69a | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:574 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-43ca3e31 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:575 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-c22fbbf2 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:576 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-3d79dbc6 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:577 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-817330c1 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:578 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-294cc73e | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:580 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-322cf0cb | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:581 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-4204e63d | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:582 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-51b93bf0 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:583 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-2e421b0f | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:584 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-5f3e6470 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:585 | try | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? DBNull.Value : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-d97eaa25 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:586 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-8ce4e550 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:587 | try | DATA_OP | request.Parameters["p_work_order_id"] | pWorkOrderId.Equals("ALL") ? DBNull.Value : pWorkOrderId | 행/컬럼 값 대입 |  |  |  |
| AC-2956adca | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:588 | try | DATA_OP | request.Parameters["p_from_date"] | p_from_date.Equals("ALL") ? DBNull.Value : p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-0a28ac39 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:589 | try | DATA_OP | request.Parameters["p_to_date"] | p_to_date.Equals("ALL") ? DBNull.Value : p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-9f0b3ba2 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:591 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d7bf8e62 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:593 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-977efc02 | popSql.OnSql [if (programID == "PR_UI_FP01630_CLOSE_WORK_ORD… 외 2 | FP01630_Close_Work_Order.cs:600 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01630_Close_Work_Order.FindData

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7672301c | FindButton 외 1 | FP01630_Close_Work_Order.cs:459 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d134ac2d | FindButton 외 1 | FP01630_Close_Work_Order.cs:465 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9244b013 | FindButton 외 1 | FP01630_Close_Work_Order.cs:466 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b59a0ec | FindButton 외 1 | FP01630_Close_Work_Order.cs:469 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a581c287 | FindButton 외 1 | FP01630_Close_Work_Order.cs:471 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d8259365 | FindButton 외 1 | FP01630_Close_Work_Order.cs:471 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90c68a26 | FindButton 외 1 | FP01630_Close_Work_Order.cs:477 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6a750396 | FindButton 외 1 | FP01630_Close_Work_Order.cs:484 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a5aa1caa | FindButton 외 1 | FP01630_Close_Work_Order.cs:486 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd21b88f | FindButton 외 1 | FP01630_Close_Work_Order.cs:496 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7fb35acc | FindButton 외 1 | FP01630_Close_Work_Order.cs:498 | try | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-44991ab3 | FindButton 외 1 | FP01630_Close_Work_Order.cs:499 | try | CALL_EXT | siMain.SetFormat | ("#,###,###.######", 16, 5, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-239a0a49 | FindButton 외 1 | FP01630_Close_Work_Order.cs:501 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5274c58a | FindButton 외 1 | FP01630_Close_Work_Order.cs:504 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-02edac92 | FindButton 외 1 | FP01630_Close_Work_Order.cs:519 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c16b5a20 | FindButton 외 1 | FP01630_Close_Work_Order.cs:520 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01630_Close_Work_Order.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba76fe5d | this.Load | FP01630_Close_Work_Order.cs:134 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01630_Close_Work_Order.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd7f6d30 | this.Load | FP01630_Close_Work_Order.cs:170 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-019c3263 | this.Load | FP01630_Close_Work_Order.cs:177 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2f90d630 | this.Load | FP01630_Close_Work_Order.cs:178 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d9f6f990 | this.Load | FP01630_Close_Work_Order.cs:181 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-b055183e | this.Load | FP01630_Close_Work_Order.cs:181 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b9599a13 | this.Load | FP01630_Close_Work_Order.cs:182 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bad441a8 | this.Load | FP01630_Close_Work_Order.cs:184 |  | FLAG | dtCurDate | Data_FP.Common_FP(Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 화면 필드/플래그 변경 |  |  |  |
| AC-70a43655 | this.Load | FP01630_Close_Work_Order.cs:184 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1bd7426a | this.Load | FP01630_Close_Work_Order.cs:186 |  | FLAG | sCurDate | (string)dtCurDate.Rows[0]["CUR_DATE"] | 화면 필드/플래그 변경 |  |  |  |
| AC-47b20eb8 | this.Load | FP01630_Close_Work_Order.cs:187 |  | FLAG | sPlanDate | sCurDate.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-21285f14 | this.Load | FP01630_Close_Work_Order.cs:188 |  | FLAG | sPrevDate | sCurDate | 화면 필드/플래그 변경 |  |  |  |
| AC-310e56e8 | this.Load | FP01630_Close_Work_Order.cs:190 |  | UI_PROP | drpPeriod.Text1 | DateUtil.GetDateAdd(sCurDate, -6, "D") | 속성 Text1 설정 |  |  |  |
| AC-204c6c94 | this.Load | FP01630_Close_Work_Order.cs:191 |  | UI_PROP | drpPeriod.Text2 | sCurDate | 속성 Text2 설정 |  |  |  |

## FP01630_Close_Work_Order.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fc76b48 | this.Load | FP01630_Close_Work_Order.cs:353 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-af84db41 | this.Load | FP01630_Close_Work_Order.cs:354 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-e951bd87 | this.Load | FP01630_Close_Work_Order.cs:355 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01630_Close_Work_Order.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-355e479c | this.Load 외 2 | FP01630_Close_Work_Order.cs:383 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-94456cdc | this.Load 외 2 | FP01630_Close_Work_Order.cs:385 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b422a84d | this.Load 외 2 | FP01630_Close_Work_Order.cs:393 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-cae2abb8 | this.Load 외 2 | FP01630_Close_Work_Order.cs:394 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-63b64098 | this.Load 외 2 | FP01630_Close_Work_Order.cs:395 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-64f29567 | this.Load 외 2 | FP01630_Close_Work_Order.cs:399 |  | UI_PROP | col.MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 속성 MergePolicy 설정 |  |  |  |
| AC-671ae5d1 | this.Load 외 2 | FP01630_Close_Work_Order.cs:401 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01630_Close_Work_Order.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3aef2ad1 | popSql.OnSql | FP01630_Close_Work_Order.cs:980 | if (programID == "PR_UI_FP01630_CLOSE_WORK_ORDER") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-83eb0337 | popSql.OnSql | FP01630_Close_Work_Order.cs:983 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01630_Close_Work_Order.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45d4b18f | SaveButton | FP01630_Close_Work_Order.cs:606 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1309fdae | SaveButton | FP01630_Close_Work_Order.cs:608 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3d86674 | SaveButton | FP01630_Close_Work_Order.cs:613 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-59ae86a3 | SaveButton | FP01630_Close_Work_Order.cs:614 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3fc951a | SaveButton | FP01630_Close_Work_Order.cs:617 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8bafe3c6 | SaveButton | FP01630_Close_Work_Order.cs:624 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-ea2330ed | SaveButton | FP01630_Close_Work_Order.cs:626 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8c075d65 | SaveButton | FP01630_Close_Work_Order.cs:627 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68b338d4 | SaveButton | FP01630_Close_Work_Order.cs:632 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9cf955d6 | SaveButton | FP01630_Close_Work_Order.cs:637 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc44e774 | SaveButton | FP01630_Close_Work_Order.cs:646 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-413bbf53 | SaveButton | FP01630_Close_Work_Order.cs:650 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-068cacde | SaveButton | FP01630_Close_Work_Order.cs:654 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a5bd2f43 | SaveButton | FP01630_Close_Work_Order.cs:655 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d213ef44 | SaveButton | FP01630_Close_Work_Order.cs:659 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01630_Close_Work_Order.Save_Data_Execute

진입점: this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b698c303 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:712 | try ▸ if (sQueryType.Equals("MAIN")) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e59a1318 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:752 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01630_SAVE") ⇒ FP_Master.PR_UI_FP01630_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-db63eb6d | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:753 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-097acbd6 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:755 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-58023574 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:756 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-45b79554 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:757 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a42f2f58 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:758 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b502cd6e | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:760 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-416d267b | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:761 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-08678d88 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:762 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b4cd18ea | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:763 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-b361d627 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:764 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-d3f28bdc | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:765 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-c06b0e84 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:766 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cutoff_date"] | p_cutoff_date | 행/컬럼 값 대입 |  |  |  |
| AC-42ea31f7 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:767 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_work_order_id"] | p_work_order_id | 행/컬럼 값 대입 |  |  |  |
| AC-d1a04728 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:768 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_work_order_spl_id"] | p_work_order_spl_id | 행/컬럼 값 대입 |  |  |  |
| AC-36056b6d | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:769 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_actual_qty"] | p_actual_qty | 행/컬럼 값 대입 |  |  |  |
| AC-6e52be62 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:770 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_group_id"] | p_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-e44641b3 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:772 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0438a6fc | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:773 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-36f04140 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:779 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c9a78559 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… 외 1 | FP01630_Close_Work_Order.cs:785 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01630_Close_Work_Order.Save_Data_NetJob

진입점: this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2034591d | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… | FP01630_Close_Work_Order.cs:798 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d1059bb | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… | FP01630_Close_Work_Order.cs:799 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4aa53baf | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… | FP01630_Close_Work_Order.cs:802 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1ab9f4b6 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… | FP01630_Close_Work_Order.cs:817 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a5937b66 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… | FP01630_Close_Work_Order.cs:822 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8ee9a826 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… | FP01630_Close_Work_Order.cs:831 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1bc54ae7 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… | FP01630_Close_Work_Order.cs:839 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c2ed4ce0 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… | FP01630_Close_Work_Order.cs:840 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2c9c7af4 | this.btnCancle.Click [else of (siMain.IsLock(siMain.SheetNam… | FP01630_Close_Work_Order.cs:844 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01630_Close_Work_Order.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3037aab9 | SaveButton | FP01630_Close_Work_Order.cs:439 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01630_Close_Work_Order.Search_After

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95401964 | (진입점 미연결) | FP01630_Close_Work_Order.cs:907 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-038d3a96 | (진입점 미연결) | FP01630_Close_Work_Order.cs:920 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.ERR… | 그리드 표시 설정 |  |  |  |
| AC-892447d5 | (진입점 미연결) | FP01630_Close_Work_Order.cs:921 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_STYLE | siMain.SetForeColor | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.ERR… | 그리드 표시 설정 |  |  |  |
| AC-e2c873aa | (진입점 미연결) | FP01630_Close_Work_Order.cs:922 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_STYLE | siMain.SetFontBold | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.ERR… | 그리드 표시 설정 |  |  |  |

## FP01630_Close_Work_Order.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / cboOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-144256f4 | this.Load 외 5 | FP01630_Close_Work_Order.cs:204 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-6decdb54 | this.Load 외 5 | FP01630_Close_Work_Order.cs:205 | if (argType == "DIVISION") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-461d28e0 | this.Load 외 5 | FP01630_Close_Work_Order.cs:206 | if (argType == "DIVISION") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-bc5e8c38 | this.Load 외 5 | FP01630_Close_Work_Order.cs:206 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2bb5402a | this.Load 외 5 | FP01630_Close_Work_Order.cs:207 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6f2f9e38 | this.Load 외 5 | FP01630_Close_Work_Order.cs:211 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-bd57e0ec | this.Load 외 5 | FP01630_Close_Work_Order.cs:212 | if (argType == "DIVISION") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-2ca6021f | this.Load 외 5 | FP01630_Close_Work_Order.cs:213 | if (argType == "DIVISION") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-b9b8e359 | this.Load 외 5 | FP01630_Close_Work_Order.cs:213 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1626f3dc | this.Load 외 5 | FP01630_Close_Work_Order.cs:214 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9f51a83a | this.Load 외 5 | FP01630_Close_Work_Order.cs:218 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-57c8628d | this.Load 외 5 | FP01630_Close_Work_Order.cs:219 | if (argType == "DIVISION") | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-55c4d412 | this.Load 외 5 | FP01630_Close_Work_Order.cs:220 | if (argType == "DIVISION") | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-59b95ce6 | this.Load 외 5 | FP01630_Close_Work_Order.cs:220 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff6bb998 | this.Load 외 5 | FP01630_Close_Work_Order.cs:221 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-834281e9 | this.Load 외 5 | FP01630_Close_Work_Order.cs:225 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd0fe49f | this.Load 외 5 | FP01630_Close_Work_Order.cs:226 | if (argType == "DIVISION") | FLAG | pFactoryID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-abdb49a7 | this.Load 외 5 | FP01630_Close_Work_Order.cs:227 | if (argType == "DIVISION") | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-0a780308 | this.Load 외 5 | FP01630_Close_Work_Order.cs:227 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7bac107b | this.Load 외 5 | FP01630_Close_Work_Order.cs:228 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-83ee2d4b | this.Load 외 5 | FP01630_Close_Work_Order.cs:232 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-026efbe2 | this.Load 외 5 | FP01630_Close_Work_Order.cs:233 | if (argType == "DIVISION") | FLAG | pOperationID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-cb8efe2d | this.Load 외 5 | FP01630_Close_Work_Order.cs:234 | if (argType == "DIVISION") | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-5451f4c1 | this.Load 외 5 | FP01630_Close_Work_Order.cs:234 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7a03645 | this.Load 외 5 | FP01630_Close_Work_Order.cs:235 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f20d46f3 | this.Load 외 5 | FP01630_Close_Work_Order.cs:241 | else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-36507675 | this.Load 외 5 | FP01630_Close_Work_Order.cs:242 | else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-b2be5942 | this.Load 외 5 | FP01630_Close_Work_Order.cs:243 | else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-5dc0e3ae | this.Load 외 5 | FP01630_Close_Work_Order.cs:243 | else of (argType == "DIVISION") ▸ if (argType == "SITE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e97bc1f | this.Load 외 5 | FP01630_Close_Work_Order.cs:244 | else of (argType == "DIVISION") ▸ if (argType == "SITE") | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-10875a7d | this.Load 외 5 | FP01630_Close_Work_Order.cs:277 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-6acdfc0b | this.Load 외 5 | FP01630_Close_Work_Order.cs:278 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-149a30af | this.Load 외 5 | FP01630_Close_Work_Order.cs:279 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-0fb2e65b | this.Load 외 5 | FP01630_Close_Work_Order.cs:279 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d75e5d9b | this.Load 외 5 | FP01630_Close_Work_Order.cs:280 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-64887ed2 | this.Load 외 5 | FP01630_Close_Work_Order.cs:306 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FACTORY") | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-62211e2d | this.Load 외 5 | FP01630_Close_Work_Order.cs:307 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FACTORY") | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-420411de | this.Load 외 5 | FP01630_Close_Work_Order.cs:308 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FACTORY") | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-d2ec1b0d | this.Load 외 5 | FP01630_Close_Work_Order.cs:308 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FACTORY") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5bf288f2 | this.Load 외 5 | FP01630_Close_Work_Order.cs:309 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FACTORY") | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f18af390 | this.Load 외 5 | FP01630_Close_Work_Order.cs:328 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ else of (argType == "FACTORY") ▸ if (argType … | FLAG | sDataID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce9fd88a | this.Load 외 5 | FP01630_Close_Work_Order.cs:329 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ else of (argType == "FACTORY") ▸ if (argType … | FLAG | pFactoryID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-6e28ce42 | this.Load 외 5 | FP01630_Close_Work_Order.cs:330 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ else of (argType == "FACTORY") ▸ if (argType … | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-68c6f86c | this.Load 외 5 | FP01630_Close_Work_Order.cs:330 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ else of (argType == "FACTORY") ▸ if (argType … | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e0ba54f4 | this.Load 외 5 | FP01630_Close_Work_Order.cs:331 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ else of (argType == "FACTORY") ▸ if (argType … | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9241d908 | this.Load 외 5 | FP01630_Close_Work_Order.cs:343 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ else of (argType == "FACTORY") ▸ else of (arg… | FLAG | sDataID | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad2067ca | this.Load 외 5 | FP01630_Close_Work_Order.cs:344 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ else of (argType == "FACTORY") ▸ else of (arg… | FLAG | pOperationID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-591c1843 | this.Load 외 5 | FP01630_Close_Work_Order.cs:345 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ else of (argType == "FACTORY") ▸ else of (arg… | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-cd427f7a | this.Load 외 5 | FP01630_Close_Work_Order.cs:345 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ else of (argType == "FACTORY") ▸ else of (arg… | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-97dc7b8c | this.Load 외 5 | FP01630_Close_Work_Order.cs:346 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ else of (argType == "FACTORY") ▸ else of (arg… | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## FP01630_Close_Work_Order.SetFornt

진입점: this.spdMain.Change [if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("CHK")) ▸ if (chk_string.Equals("TRUE"))] / this.spdMain.CellClick [if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals("CHK")) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!Convert.ToBoolean(sv.ColumnHeader.Cells[e.Row, e.Column].Value))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72da1efa | this.spdMain.Change [if (e.Row >= 0 && siMain.GetColumnTag(e… 외 1 | FP01630_Close_Work_Order.cs:1129 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-23c1b1b7 | this.spdMain.Change [if (e.Row >= 0 && siMain.GetColumnTag(e… 외 1 | FP01630_Close_Work_Order.cs:1137 | if (sFontFlag.Equals("Strikeout")) | UI_PROP | range1.Font | new System.Drawing.Font(fps.Font.Name, fps.Font.Size, FontStyle.Strikeout) | 속성 Font 설정 |  |  |  |
| AC-2a8f0a6a | this.spdMain.Change [if (e.Row >= 0 && siMain.GetColumnTag(e… 외 1 | FP01630_Close_Work_Order.cs:1142 | if (sFontFlag.Equals("Regular")) | UI_PROP | range1.Font | new System.Drawing.Font(fps.Font.Name, fps.Font.Size, FontStyle.Regular) | 속성 Font 설정 |  |  |  |
| AC-a5f4ffb0 | this.spdMain.Change [if (e.Row >= 0 && siMain.GetColumnTag(e… 외 1 | FP01630_Close_Work_Order.cs:1145 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01630_Close_Work_Order.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaf28faf | this.spdMain.CellClick | FP01630_Close_Work_Order.cs:1054 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | CALL_EXT | Console.Write | ("e.Row " + e.Row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44ab5d08 | this.spdMain.CellClick | FP01630_Close_Work_Order.cs:1055 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | CALL_EXT | Console.Write | ("chk " + siMain.GetText(e.Row, siMain.GetColumnIndex("CHK"))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e5c2ffe | this.spdMain.CellClick | FP01630_Close_Work_Order.cs:1064 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | CALL_EXT | siMain.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0e41f66 | this.spdMain.CellClick | FP01630_Close_Work_Order.cs:1075 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | CALL_EXT | siMain.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e59fb4d1 | this.spdMain.CellClick | FP01630_Close_Work_Order.cs:1077 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | GRID_SET | siMain.SetText | (i, 0, AllCheck.ToString()) | 그리드 값 설정 |  |  |  |
| AC-0246e1d3 | this.spdMain.CellClick | FP01630_Close_Work_Order.cs:1083 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | GRID_STYLE | siMain.SetForeColor | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.ERR… | 그리드 표시 설정 |  |  |  |
| AC-7eeb24ea | this.spdMain.CellClick | FP01630_Close_Work_Order.cs:1088 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | GRID_STYLE | siMain.SetForeColor | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.ERR… | 그리드 표시 설정 |  |  |  |

## FP01630_Close_Work_Order.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c5b844d | this.spdMain.Change | FP01630_Close_Work_Order.cs:1114 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("CHK")) ▸ if (chk_string.Equals("TRUE")) | GRID_STYLE | siMain.SetForeColor | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), e.Row, siMain.GetColumnIndex(DefCol… | 그리드 표시 설정 |  |  |  |
| AC-3448931b | this.spdMain.Change | FP01630_Close_Work_Order.cs:1121 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("CHK")) ▸ else of (chk_string.Equals("TRUE")) | GRID_STYLE | siMain.SetForeColor | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), e.Row, siMain.GetColumnIndex(DefCol… | 그리드 표시 설정 |  |  |  |

## FP01630_Close_Work_Order.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ad556bb | this.spdMain.EditChange | FP01630_Close_Work_Order.cs:1151 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01630_Close_Work_Order.tbItemId_BeforeOpenSearch

진입점: this.tbItemId.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67a22617 | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:997 |  | DATA_OP | tbItemId.Filter["division_lt"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e8053bbf | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:998 |  | DATA_OP | tbItemId.Filter["site_lt"] | cboSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-79a023e4 | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1002 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 25) | 데이터 객체 조작/조회 |  |  |  |
| AC-d766d45c | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1003 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d7720da | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1004 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-b485f52d | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1005 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3b3d4bb | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1006 |  | DATA_OP | _col_width.Add | ("item".ToUpper(), 150) | 데이터 객체 조작/조회 |  |  |  |
| AC-2854dedc | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1007 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 150) | 데이터 객체 조작/조회 |  |  |  |
| AC-10cb53f9 | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1008 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5fdaec6 | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1012 |  | DATA_OP | _col_title.Add | ("Material".ToUpper(), "Material") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b866a14 | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1014 |  | UI_PROP | tbItemId.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-608e23a3 | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1015 |  | UI_PROP | tbItemId.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |
| AC-33c5be9b | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1017 |  | UI_PROP | tbItemId.PopupWidth | 800 | 속성 PopupWidth 설정 |  |  |  |
| AC-dacfa0ec | this.tbItemId.BeforeOpenSearch | FP01630_Close_Work_Order.cs:1018 |  | UI_PROP | tbItemId.PopupHeight | 600 | 속성 PopupHeight 설정 |  |  |  |

## FP01630_Close_Work_Order.tbItemId_OnSearchConditionChanged

진입점: this.tbItemId.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8110cae1 | this.tbItemId.OnSearchConditionChanged | FP01630_Close_Work_Order.cs:1032 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

