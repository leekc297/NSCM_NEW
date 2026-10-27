# AS-IS 액션 대조표 — FP01570

> 원천: `Doc/asisfacts/screens/FP01570/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 152행 · 메서드 19 · 종류 FLAG 29 · DATA_OP 25 · RETURN 19 · UI_PROP 16 · GRID_SET 8 · COMBO_DATA 7 · CALL_EXT 6 · MESSAGE 5 · ENDPOINT 5 · POPUP 4 · GRID_INIT 4 · STATE 4 · UI_MISC 4 · GRID_LOCK 4 · VALIDATE 3 · LIST_REBIND 3 · THROW 2 · EXCEL 1 · GRID_BIND 1 · CALL_BASE 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 7


## FP01570_PlanID_History.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d1faf27 | this.btnSql.Click | FP01570_PlanID_History.cs:450 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6e7b202f | this.btnSql.Click | FP01570_PlanID_History.cs:451 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8c4ac34a | this.btnSql.Click | FP01570_PlanID_History.cs:453 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01570_PLANID_HISTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-26a231f0 | this.btnSql.Click | FP01570_PlanID_History.cs:454 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01570_PlanID_History.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc130098 | (진입점 미연결) | FP01570_PlanID_History.cs:864 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01570_PlanID_History.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4978ff1c | this.Load | FP01570_PlanID_History.cs:357 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-571db179 | this.Load | FP01570_PlanID_History.cs:358 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1f94700e | this.Load | FP01570_PlanID_History.cs:360 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01570_PlanID_History.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a32f454e | this.Load | FP01570_PlanID_History.cs:158 |  | UI_PROP | siMain.ImagePopUp | imgList.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-19e72942 | this.Load | FP01570_PlanID_History.cs:160 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0c907965 | this.Load | FP01570_PlanID_History.cs:161 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-3deec36f | this.Load | FP01570_PlanID_History.cs:162 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-348813cf | this.Load | FP01570_PlanID_History.cs:164 |  | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b4eeda9a | this.Load | FP01570_PlanID_History.cs:171 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-92fd0e63 | this.Load | FP01570_PlanID_History.cs:172 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-6971e250 | this.Load | FP01570_PlanID_History.cs:173 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-eb8fcfb4 | this.Load | FP01570_PlanID_History.cs:177 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-20a58165 | this.Load | FP01570_PlanID_History.cs:178 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-c1168eca | this.Load | FP01570_PlanID_History.cs:179 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP01570_PlanID_History.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e06c2de6 | Dispose | FP01570_PlanID_History.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01570_PlanID_History.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa9d7642 | EditButton | FP01570_PlanID_History.cs:400 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f267cbab | EditButton | FP01570_PlanID_History.cs:402 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f5c842cd | EditButton | FP01570_PlanID_History.cs:404 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.INSTANCE_ID), siMain.GetColumnIndex(DefColumns.INSERT_TI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d92b1c74 | EditButton | FP01570_PlanID_History.cs:405 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PRE_FIX_DATE1), siMain.GetColumnIndex(DefColumns._QUEUE_… | 그리드 편집 잠금/해제 |  |  |  |

## FP01570_PlanID_History.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e866bdda | ExcelButton | FP01570_PlanID_History.cs:443 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP01570_PlanID_History.Find_Data

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-131d154e | FindButton 외 1 | FP01570_PlanID_History.cs:462 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3a38298c | FindButton 외 1 | FP01570_PlanID_History.cs:468 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-64c2a572 | FindButton 외 1 | FP01570_PlanID_History.cs:469 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8067e030 | FindButton 외 1 | FP01570_PlanID_History.cs:472 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8427214b | FindButton 외 1 | FP01570_PlanID_History.cs:475 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-0e40abc9 | FindButton 외 1 | FP01570_PlanID_History.cs:475 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d99850a | FindButton 외 1 | FP01570_PlanID_History.cs:477 | try | VALIDATE | DateUtil_FP.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-4b5b89c2 | FindButton 외 1 | FP01570_PlanID_History.cs:477 | try ▸ if (!DateUtil_FP.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-684bffd1 | FindButton 외 1 | FP01570_PlanID_History.cs:482 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-477bf1f1 | FindButton 외 1 | FP01570_PlanID_History.cs:489 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-db5b713d | FindButton 외 1 | FP01570_PlanID_History.cs:491 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-05c822c4 | FindButton 외 1 | FP01570_PlanID_History.cs:501 | try | GRID_BIND | siMain.Query | (ds,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e706d8cf | FindButton 외 1 | FP01570_PlanID_History.cs:503 | try | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-db902627 | FindButton 외 1 | FP01570_PlanID_History.cs:504 | try | CALL_EXT | siMain.SetFormat | ("####-##-##", 9, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-75034eaa | FindButton 외 1 | FP01570_PlanID_History.cs:505 | try | CALL_EXT | siMain.SetFormat | ("####-##", 13, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53550fa7 | FindButton 외 1 | FP01570_PlanID_History.cs:506 | try | CALL_EXT | siMain.SetFormat | ("####-##-##", 26, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2a3cd47 | FindButton 외 1 | FP01570_PlanID_History.cs:507 | try | CALL_EXT | siMain.SetFormat | ("####-##-##", 28, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-76819fd8 | FindButton 외 1 | FP01570_PlanID_History.cs:511 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b99d4821 | FindButton 외 1 | FP01570_PlanID_History.cs:514 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0603c744 | FindButton 외 1 | FP01570_PlanID_History.cs:527 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ced850ec | FindButton 외 1 | FP01570_PlanID_History.cs:528 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01570_PlanID_History.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de8ac07e | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:544 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pInstanceID = CString.GetCheckedListValue(dtInstance, cbo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c35c06b5 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:546 | try ▸ lambda | FLAG | pInstanceID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-85ff28cd | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:547 | try ▸ lambda | FLAG | pPlanID | CString.GetCheckedListValue(dtPlanID, cboPlanID.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7570c737 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:548 | try ▸ lambda | FLAG | pPlanType | CString.GetCheckedListValue(dtPlanType, cboPlanType.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ca66333b | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:549 | try ▸ lambda | FLAG | pPlanWeek | CString.GetCheckedListValue(dtPlanWeek, cboPlanWeek.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-faaeaec1 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:569 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01570_PLANID_HISTORY") ⇒ FP_Master.PR_UI_FP01570_PLANID_HISTORY | 엔드포인트 요청 생성 |  |  |  |
| AC-63b2c7c8 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:570 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6ec32b22 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:571 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-a68942fd | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:572 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-61f1806d | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:573 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-746c85f8 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:574 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-0b4c4376 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:576 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstanceID.Equals("ALL") ? DBNull.Value : pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-255f89e8 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:577 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID.Equals("ALL") ? DBNull.Value : pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-615283f5 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:578 | try | DATA_OP | request.Parameters["p_plan_type"] | pPlanType.Equals("ALL") ? DBNull.Value : pPlanType | 행/컬럼 값 대입 |  |  |  |
| AC-c61ceaa1 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:579 | try | DATA_OP | request.Parameters["p_plan_week"] | pPlanWeek.Equals("ALL") ? DBNull.Value : pPlanWeek | 행/컬럼 값 대입 |  |  |  |
| AC-dd5f7b15 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:580 | try | DATA_OP | request.Parameters["p_due_from_date"] | pFromDate.Equals("ALL") ? DBNull.Value : pFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-2c776566 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:581 | try | DATA_OP | request.Parameters["p_due_to_date"] | pToDate.Equals("ALL") ? DBNull.Value : pToDate | 행/컬럼 값 대입 |  |  |  |
| AC-6ae44ec6 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:582 | try | DATA_OP | request.Parameters["p_last_release_flag"] | pLastReleaseFlag | 행/컬럼 값 대입 |  |  |  |
| AC-ecc829bf | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:584 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96dac3c2 | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:586 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-50231fef | popSql.OnSql [if (programID == "PR_UI_FP01570_PLANID_HISTORY… 외 2 | FP01570_PlanID_History.cs:593 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01570_PlanID_History.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18def169 | this.Load | FP01570_PlanID_History.cs:139 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01570_PlanID_History.GetDtValue

진입점: this.Load [else of (argType == "INSTANCE_ID") ▸ if (argType == "PLAN_WEEK") ▸ else of (pPlanWeek.Equals("ALL"))] / cboInstance.SelectedIndexChanged [else of (argType == "INSTANCE_ID") ▸ if (argType == "PLAN_WEEK") ▸ else of (pPlanWeek.Equals("ALL"))] / cboPlanID.SelectedIndexChanged [else of (argType == "INSTANCE_ID") ▸ if (argType == "PLAN_WEEK") ▸ else of (pPlanWeek.Equals("ALL"))] / cboPlanType.SelectedIndexChanged [else of (argType == "INSTANCE_ID") ▸ if (argType == "PLAN_WEEK") ▸ else of (pPlanWeek.Equals("ALL"))] / cboPlanWeek.SelectedIndexChanged [else of (argType == "INSTANCE_ID") ▸ if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-739cf23f | this.Load [else of (argType == "INSTANCE_ID") ▸ if (argType … 외 4 | FP01570_PlanID_History.cs:304 | try | DATA_OP | dRow.Field | (targetRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-54f240b9 | this.Load [else of (argType == "INSTANCE_ID") ▸ if (argType … 외 4 | FP01570_PlanID_History.cs:316 | try ▸ if (rows != null) ▸ foreach (var row_ in rows) ▸ if (row_ != null) ▸ if (!string.IsNullOrWhiteSpace(each_value)) | DATA_OP | return_values.Contains | (each_value) | 데이터 객체 조작/조회 |  |  |  |
| AC-37dd9b4e | this.Load [else of (argType == "INSTANCE_ID") ▸ if (argType … 외 4 | FP01570_PlanID_History.cs:318 | try ▸ if (rows != null) ▸ foreach (var row_ in rows) ▸ if (row_ != null) ▸ if (!string.IsNullOrWhiteSpace(each_value)) ▸ if (!return_values.… | DATA_OP | return_values.Add | (each_value) | 데이터 객체 조작/조회 |  |  |  |
| AC-af4630f0 | this.Load [else of (argType == "INSTANCE_ID") ▸ if (argType … 외 4 | FP01570_PlanID_History.cs:336 | catch () | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-ed3068eb | this.Load [else of (argType == "INSTANCE_ID") ▸ if (argType … 외 4 | FP01570_PlanID_History.cs:337 |  | RETURN | return return_value; |  | 처리 중단/반환 |  |  |  |

## FP01570_PlanID_History.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddd345bf | this.Load | FP01570_PlanID_History.cs:191 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-48422002 | this.Load | FP01570_PlanID_History.cs:199 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-44ac89b4 | this.Load | FP01570_PlanID_History.cs:200 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6ea2e925 | this.Load | FP01570_PlanID_History.cs:203 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-98f3e4f2 | this.Load | FP01570_PlanID_History.cs:203 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be70877f | this.Load | FP01570_PlanID_History.cs:204 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6262b1ef | this.Load | FP01570_PlanID_History.cs:205 | if (dtInstance.Rows.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-db7cd097 | this.Load | FP01570_PlanID_History.cs:208 |  | FLAG | dtPlanType | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-1462ae93 | this.Load | FP01570_PlanID_History.cs:208 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-151c2d12 | this.Load | FP01570_PlanID_History.cs:212 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d85851a5 | this.Load | FP01570_PlanID_History.cs:216 |  | FLAG | dtPlanWeek | Data_FP.Common_FP(Data_FP.Type.FP_PLAN_WEEK, false, UserInfoContext.Current.UserId, _sNonA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_WEEK] | 화면 필드/플래그 변경 |  |  |  |
| AC-cc07fe76 | this.Load | FP01570_PlanID_History.cs:216 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FP_PLAN_WEEK, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_WEEK] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3491cf5c | this.Load | FP01570_PlanID_History.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanWeek, cboPlanWeek, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-86801a16 | this.Load | FP01570_PlanID_History.cs:220 |  | FLAG | dtStdWeek | Data_FP.Common_FP(Data_FP.Type.WEEK_EXP, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=WEEK_EXP] | 화면 필드/플래그 변경 |  |  |  |
| AC-12e197b6 | this.Load | FP01570_PlanID_History.cs:220 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.WEEK_EXP, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=WEEK_EXP] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-22a2f262 | this.Load | FP01570_PlanID_History.cs:226 |  | FLAG | dtCurDate | Data_FP.Common_FP(Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 화면 필드/플래그 변경 |  |  |  |
| AC-3368f28e | this.Load | FP01570_PlanID_History.cs:226 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a81eece6 | this.Load | FP01570_PlanID_History.cs:228 |  | FLAG | sCurDate | (string)dtCurDate.Rows[0]["CUR_DATE"] | 화면 필드/플래그 변경 |  |  |  |
| AC-434d1916 | this.Load | FP01570_PlanID_History.cs:230 |  | UI_PROP | drpPeriod.Text1 | DateUtil.GetDateAdd(sCurDate, -7, "D") | 속성 Text1 설정 |  |  |  |
| AC-38e3cdba | this.Load | FP01570_PlanID_History.cs:231 |  | UI_PROP | drpPeriod.Text2 | sCurDate | 속성 Text2 설정 |  |  |  |

## FP01570_PlanID_History.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-718ce026 | this.Load 외 2 | FP01570_PlanID_History.cs:367 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-87164af8 | this.Load 외 2 | FP01570_PlanID_History.cs:369 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-62acd67c | this.Load 외 2 | FP01570_PlanID_History.cs:375 | if (adminAuth) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PRE_FIX_DATE1)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5b168f75 | this.Load 외 2 | FP01570_PlanID_History.cs:376 | if (adminAuth) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PRE_FIX_DATE1)].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-4e17ab94 | this.Load 외 2 | FP01570_PlanID_History.cs:377 | if (adminAuth) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PRE_FIX_DATE2)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-053b1b64 | this.Load 외 2 | FP01570_PlanID_History.cs:378 | if (adminAuth) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PRE_FIX_DATE2)].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-78257641 | this.Load 외 2 | FP01570_PlanID_History.cs:379 | if (adminAuth) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PRE_FIX_TYPE1)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8173fbdb | this.Load 외 2 | FP01570_PlanID_History.cs:380 | if (adminAuth) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PRE_FIX_TYPE1)].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-519e1812 | this.Load 외 2 | FP01570_PlanID_History.cs:381 | if (adminAuth) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PRE_FIX_TYPE2)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-cefeee23 | this.Load 외 2 | FP01570_PlanID_History.cs:382 | if (adminAuth) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PRE_FIX_TYPE2)].Width | 100 | 그리드 속성/값 설정 |  |  |  |

## FP01570_PlanID_History.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d66db39a | popSql.OnSql | FP01570_PlanID_History.cs:877 | if (programID == "PR_UI_FP01570_PLANID_HISTORY") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-8ef665bd | popSql.OnSql | FP01570_PlanID_History.cs:880 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01570_PlanID_History.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b60e3ed9 | SaveButton | FP01570_PlanID_History.cs:599 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eab08947 | SaveButton | FP01570_PlanID_History.cs:601 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6a6ed24 | SaveButton | FP01570_PlanID_History.cs:606 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3bf982d3 | SaveButton | FP01570_PlanID_History.cs:607 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c330a675 | SaveButton | FP01570_PlanID_History.cs:610 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1d3877b1 | SaveButton | FP01570_PlanID_History.cs:617 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-709b7417 | SaveButton | FP01570_PlanID_History.cs:619 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-16af27e6 | SaveButton | FP01570_PlanID_History.cs:620 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5f467c3 | SaveButton | FP01570_PlanID_History.cs:625 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-76615d79 | SaveButton | FP01570_PlanID_History.cs:630 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd45a6b7 | SaveButton | FP01570_PlanID_History.cs:639 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2cb46d4e | SaveButton | FP01570_PlanID_History.cs:643 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c05a6bac | SaveButton | FP01570_PlanID_History.cs:647 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-42eda914 | SaveButton | FP01570_PlanID_History.cs:648 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-32f70c5e | SaveButton | FP01570_PlanID_History.cs:652 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01570_PlanID_History.Save_Data_Execute

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb7b12a7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:706 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01570_SAVE") ⇒ FP_Master.PR_UI_FP01570_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-f5dbef26 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:707 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1ec9baf6 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:709 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3d2b81f1 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:710 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4a8eee67 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:711 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-eb035f2e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:712 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5bd46e58 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:714 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-4e6db27b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:715 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-4b5c414a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:716 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-c11a213d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:717 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-8c8b626d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:718 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_relDescription"] | p_relDescription | 행/컬럼 값 대입 |  |  |  |
| AC-995e2768 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:720 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-260609a9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:721 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-19c95f65 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:727 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-0f95b6e0 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01570_PlanID_History.cs:733 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01570_PlanID_History.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec107179 | SaveButton | FP01570_PlanID_History.cs:432 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01570_PlanID_History.SetChangeControl

진입점: this.Load / cboInstance.SelectedIndexChanged / cboPlanID.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0846a7a | this.Load 외 4 | FP01570_PlanID_History.cs:242 | if (argType == "INSTANCE_ID") | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-48c3c687 | this.Load 외 4 | FP01570_PlanID_History.cs:245 | if (argType == "INSTANCE_ID") ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f1c3590 | this.Load 외 4 | FP01570_PlanID_History.cs:245 | if (argType == "INSTANCE_ID") ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4472760a | this.Load 외 4 | FP01570_PlanID_History.cs:248 | if (argType == "INSTANCE_ID") | FLAG | pInstanceID | sInstance_id | 화면 필드/플래그 변경 |  |  |  |
| AC-e035eb0a | this.Load 외 4 | FP01570_PlanID_History.cs:252 | if (argType == "INSTANCE_ID") | FLAG | dtPlanID | Data_FP.Common_FP(Data_FP.Type.FP_PLAN_INFO, false, UserInfoContext.Current.UserId, _sNonA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | 화면 필드/플래그 변경 |  |  |  |
| AC-d2a69ed7 | this.Load 외 4 | FP01570_PlanID_History.cs:252 | if (argType == "INSTANCE_ID") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FP_PLAN_INFO, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-525fece9 | this.Load 외 4 | FP01570_PlanID_History.cs:253 | if (argType == "INSTANCE_ID") | CALL_EXT | clsCtrl.setListBoxEx | (dtPlanID, cboPlanID, true, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c505876 | this.Load 외 4 | FP01570_PlanID_History.cs:259 | else of (argType == "INSTANCE_ID") ▸ if (argType == "PLAN_WEEK") | FLAG | sDataID | CString.GetCheckedListValue(dtPlanWeek, cboPlanWeek.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-574899bd | this.Load 외 4 | FP01570_PlanID_History.cs:260 | else of (argType == "INSTANCE_ID") ▸ if (argType == "PLAN_WEEK") | FLAG | pPlanWeek | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-e7c38835 | this.Load 외 4 | FP01570_PlanID_History.cs:264 | else of (argType == "INSTANCE_ID") ▸ if (argType == "PLAN_WEEK") ▸ if (pPlanWeek.Equals("ALL")) | UI_PROP | drpPeriod.Text1 | DateUtil.GetDateAdd(sCurDate, -7, "D") | 속성 Text1 설정 |  |  |  |
| AC-067e4da7 | this.Load 외 4 | FP01570_PlanID_History.cs:265 | else of (argType == "INSTANCE_ID") ▸ if (argType == "PLAN_WEEK") ▸ if (pPlanWeek.Equals("ALL")) | UI_PROP | drpPeriod.Text2 | sCurDate | 속성 Text2 설정 |  |  |  |
| AC-cc33b1aa | this.Load 외 4 | FP01570_PlanID_History.cs:273 | else of (argType == "INSTANCE_ID") ▸ if (argType == "PLAN_WEEK") ▸ else of (pPlanWeek.Equals("ALL")) | UI_PROP | drpPeriod.Text1 | sStartDate | 속성 Text1 설정 |  |  |  |
| AC-40ad732c | this.Load 외 4 | FP01570_PlanID_History.cs:274 | else of (argType == "INSTANCE_ID") ▸ if (argType == "PLAN_WEEK") ▸ else of (pPlanWeek.Equals("ALL")) | UI_PROP | drpPeriod.Text2 | sEndDate | 속성 Text2 설정 |  |  |  |

## FP01570_PlanID_History.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4517624 | this.spdMain.CellClick | FP01570_PlanID_History.cs:784 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b1970bd | this.spdMain.CellClick | FP01570_PlanID_History.cs:786 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b996721 | this.spdMain.CellClick | FP01570_PlanID_History.cs:826 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

