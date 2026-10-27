# AS-IS 액션 대조표 — SCM0009

> 원천: `Doc/asisfacts/screens/SCM0009/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 109행 · 메서드 15 · 종류 GRID_INIT 26 · DATA_OP 19 · RETURN 12 · ENDPOINT 8 · GRID_SET 7 · UI_PROP 6 · CALL_EXT 6 · MESSAGE 5 · FLAG 4 · VALUE_SET 4 · COMBO_DATA 3 · POPUP 2 · UI_MISC 2 · GRID_LOCK 2 · LIST_REBIND 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 6


## SCM0009_Auth_Approval.BtnApproval_Click

진입점: btnApproval.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4107cb1 | btnApproval.Click | SCM0009_Auth_Approval.cs:213 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c2a267d | btnApproval.Click | SCM0009_Auth_Approval.cs:214 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d5e110a | btnApproval.Click | SCM0009_Auth_Approval.cs:220 | if (InterlockTotalMiss("APP")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCM0009_Auth_Approval.BtnReject_Click

진입점: btnReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39d795bc | btnReject.Click | SCM0009_Auth_Approval.cs:180 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da3913c2 | btnReject.Click | SCM0009_Auth_Approval.cs:181 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0aff99aa | btnReject.Click | SCM0009_Auth_Approval.cs:187 | if (InterlockTotalMiss("REJ")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b646d711 | btnReject.Click | SCM0009_Auth_Approval.cs:190 |  | POPUP | new SCM0002_RejectReasonPopup | () | 팝업/폼 생성 |  |  |  |
| AC-73ac4785 | btnReject.Click | SCM0009_Auth_Approval.cs:191 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3baa6c76 | btnReject.Click | SCM0009_Auth_Approval.cs:192 |  | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-8a8345de | btnReject.Click | SCM0009_Auth_Approval.cs:193 |  | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-2a118c19 | btnReject.Click | SCM0009_Auth_Approval.cs:195 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCM0009_Auth_Approval.ChangeAllCheckboxes

진입점: spdMain.CellClick / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74b0b44d | spdMain.CellClick 외 1 | SCM0009_Auth_Approval.cs:153 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17c67aee | spdMain.CellClick 외 1 | SCM0009_Auth_Approval.cs:162 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dda05331 | spdMain.CellClick 외 1 | SCM0009_Auth_Approval.cs:165 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.ActiveSheet.GetRowVisible | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-573adb9e | spdMain.CellClick 외 1 | SCM0009_Auth_Approval.cs:166 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ if (spread.ActiveSheet.… | GRID_SET | spread.SetText | (i, 0, AllCheck.ToString()) | 그리드 값 설정 |  |  |  |
| AC-f9bf84d0 | spdMain.CellClick 외 1 | SCM0009_Auth_Approval.cs:168 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ else of (spread.ActiveS… | GRID_SET | spread.SetText | (i, 0, false.ToString()) | 그리드 값 설정 |  |  |  |

## SCM0009_Auth_Approval.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73cf8ef3 | this.Load | SCM0009_Auth_Approval.cs:358 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0707b222 | this.Load | SCM0009_Auth_Approval.cs:359 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-26740929 | this.Load | SCM0009_Auth_Approval.cs:360 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0009_Auth_Approval.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeba4ec0 | this.Load | SCM0009_Auth_Approval.cs:349 |  | UI_PROP | usrConditionPanel1.Height | 65 | 속성 Height 설정 |  |  |  |
| AC-2f421eec | this.Load | SCM0009_Auth_Approval.cs:351 |  | VALUE_SET | cboApprovalResult.SelectedValue | "REQUESTING" | 컨트롤 값 설정 |  |  |  |
| AC-7686d403 | this.Load | SCM0009_Auth_Approval.cs:352 |  | VALUE_SET | btnReject.Text | "REJECT" | 컨트롤 값 설정 |  |  |  |
| AC-acb73e8b | this.Load | SCM0009_Auth_Approval.cs:353 |  | VALUE_SET | btnApproval.Text | "APPROVAL" | 컨트롤 값 설정 |  |  |  |

## SCM0009_Auth_Approval.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07e4ca1c | Dispose | SCM0009_Auth_Approval.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0009_Auth_Approval.FindData

진입점: btnApproval.Click [if (tran.Success)] / btnReject.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.reason.Length > 0) ▸ if (tran.Success)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efa3634c | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:434 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-26462c88 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:437 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetApprovalAuthRequest") ⇒ SystemManager.UP_FX_GetApprovalAuthRequest | 엔드포인트 요청 생성 |  |  |  |
| AC-448861a6 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:438 | lambda | DATA_OP | req.Parameters["p_Division_id"] | p_Division_id | 행/컬럼 값 대입 |  |  |  |
| AC-975b2ed0 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:439 | lambda | DATA_OP | req.Parameters["p_User_id"] | p_User_id | 행/컬럼 값 대입 |  |  |  |
| AC-bd457ac8 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:440 | lambda | DATA_OP | req.Parameters["p_Dept_Name"] | p_Dept_Name | 행/컬럼 값 대입 |  |  |  |
| AC-9771276b | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:441 | lambda | DATA_OP | req.Parameters["p_ReqFromDate"] | p_ReqFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-0999c9e2 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:442 | lambda | DATA_OP | req.Parameters["p_ReqToDate"] | p_ReqToDate | 행/컬럼 값 대입 |  |  |  |
| AC-3ccf85e3 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:443 | lambda | DATA_OP | req.Parameters["p_ApprFromDate"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-86b45cfc | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:444 | lambda | DATA_OP | req.Parameters["p_ApprToDate"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-64b62f6f | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:445 | lambda | DATA_OP | req.Parameters["p_ApprResult"] | p_ApprResult | 행/컬럼 값 대입 |  |  |  |
| AC-54d67201 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:447 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f98558b6 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:448 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-36d04e10 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:452 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c02dbf98 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:460 | for (i <= siMain.GetMaxRowIndex()) ▸ if ((result.Equals("APPROVED") \|\| result.Equals("REJECT")) && result.Length > 0) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefMain.CHK), "True") | 그리드 값 설정 |  |  |  |
| AC-5ba34551 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:461 | for (i <= siMain.GetMaxRowIndex()) ▸ if ((result.Equals("APPROVED") \|\| result.Equals("REJECT")) && result.Length > 0) | GRID_LOCK | siMain.LockRange | (i, 0, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-33c1a4b6 | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:465 |  | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-46883eab | btnApproval.Click [if (tran.Success)] 외 2 | SCM0009_Auth_Approval.cs:466 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0009_Auth_Approval.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46dcc55a | this.Load | SCM0009_Auth_Approval.cs:120 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0009_Auth_Approval.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6a86aad | this.Load | SCM0009_Auth_Approval.cs:337 |  | ENDPOINT | new FoxDataRequest | ("SCP.GET_DATE_RANGE_1MONTH_BEFORE") ⇒ SCP.GET_DATE_RANGE_1MONTH_BEFORE | 엔드포인트 요청 생성 |  |  |  |
| AC-acf2afcf | this.Load | SCM0009_Auth_Approval.cs:338 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-30a46ae5 | this.Load | SCM0009_Auth_Approval.cs:340 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCM0009_Auth_Approval.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38cf5953 | this.Load | SCM0009_Auth_Approval.cs:315 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-001a8f2e | this.Load | SCM0009_Auth_Approval.cs:318 |  | FLAG | dtApprResult | Data.Common(Data.Type.LookupCommon, false, "APPROVAL_RESULT") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-b55ac01b | this.Load | SCM0009_Auth_Approval.cs:318 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "APPROVAL_RESULT") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7c017f54 | this.Load | SCM0009_Auth_Approval.cs:319 |  | LIST_REBIND | clsCtrl.setListBox | (dtApprResult, cboApprovalResult, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-68850e65 | this.Load | SCM0009_Auth_Approval.cs:322 |  | FLAG | dtDivision | Data_SCP.Common(Data_SCP.Type.MyDivisionInEE, false, UserInfoContext.Current["NowGroupID"]… | 화면 필드/플래그 변경 |  |  |  |
| AC-6f95edee | this.Load | SCM0009_Auth_Approval.cs:322 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MyDivisionInEE, false, UserInfoContext.Current["NowGroupID"], UserInfoConte… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f4f6074 | this.Load | SCM0009_Auth_Approval.cs:323 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-23c85b8c | this.Load | SCM0009_Auth_Approval.cs:328 |  | VALUE_SET | drpReqPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCM0009_Auth_Approval.InitSpread

진입점: this.Load / btnApproval.Click [if (tran.Success)] / btnReject.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.reason.Length > 0) ▸ if (tran.Success)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3f3c404 | this.Load 외 3 | SCM0009_Auth_Approval.cs:367 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-69ce79b3 | this.Load 외 3 | SCM0009_Auth_Approval.cs:369 |  | GRID_INIT | siMain.AddCheckColumn | (DefLabel.CHK, DefMain.CHK, FPMerge.None, 25, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6db889c2 | this.Load 외 3 | SCM0009_Auth_Approval.cs:370 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.USER_ID, DefMain.USER_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a2d17f3 | this.Load 외 3 | SCM0009_Auth_Approval.cs:371 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.USER_NAME, DefMain.USER_NAME, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7910a09 | this.Load 외 3 | SCM0009_Auth_Approval.cs:373 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.COMPANY_ID, DefMain.COMPANY_ID, FPMerge.None, 90, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f88f256 | this.Load 외 3 | SCM0009_Auth_Approval.cs:374 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.WORKING_NAME, DefMain.WORKING_NAME, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f4d5a94 | this.Load 외 3 | SCM0009_Auth_Approval.cs:375 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.SSO_LOCATE, DefMain.SSO_LOCATE, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d0a97d0 | this.Load 외 3 | SCM0009_Auth_Approval.cs:376 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.DEPT_ID, DefMain.DEPT_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-195117bd | this.Load 외 3 | SCM0009_Auth_Approval.cs:377 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.DEPT_NAME, DefMain.DEPT_NAME, FPMerge.None, 220, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75cb48a1 | this.Load 외 3 | SCM0009_Auth_Approval.cs:378 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.AUTHORITY, DefMain.AUTHORITY, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b565006 | this.Load 외 3 | SCM0009_Auth_Approval.cs:379 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.DIVISION_ID, DefMain.DIVISION_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ddd06488 | this.Load 외 3 | SCM0009_Auth_Approval.cs:380 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.DIVISION_NAME, DefMain.DIVISION_NAME, FPMerge.None, 150, false, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72dd0ec4 | this.Load 외 3 | SCM0009_Auth_Approval.cs:381 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.PLANT_ID, DefMain.PLANT_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2105ac35 | this.Load 외 3 | SCM0009_Auth_Approval.cs:382 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.PLANT_NAME, DefMain.PLANT_NAME, FPMerge.None, 160, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75a29518 | this.Load 외 3 | SCM0009_Auth_Approval.cs:384 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.CUSTOMER_CODE, DefMain.CUSTOMER_CODE, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-62234e57 | this.Load 외 3 | SCM0009_Auth_Approval.cs:385 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.CUSTOMER_NAME, DefMain.CUSTOMER_NAME, FPMerge.None, 165, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cbd479fa | this.Load 외 3 | SCM0009_Auth_Approval.cs:387 |  | GRID_INIT | siMain.AddDateTimeColumn | (DefLabel.REQUEST_DATE, DefMain.REQUEST_DATE, FPMerge.None, 165, true, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c53e8a0 | this.Load 외 3 | SCM0009_Auth_Approval.cs:388 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.APPROVAL_RESULT, DefMain.APPROVAL_RESULT, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14801753 | this.Load 외 3 | SCM0009_Auth_Approval.cs:389 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.APPROVAL_USER, DefMain.APPROVAL_USER, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c95f2f3f | this.Load 외 3 | SCM0009_Auth_Approval.cs:390 |  | GRID_INIT | siMain.AddDateTimeColumn | (DefLabel.APPROVAL_DATE, DefMain.APPROVAL_DATE, FPMerge.None, 165, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51b150a6 | this.Load 외 3 | SCM0009_Auth_Approval.cs:391 |  | GRID_INIT | siMain.AddTextColumn | (DefLabel.REJECT_REASON, DefMain.REJECT_REASON, FPMerge.None, 220, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b86a444 | this.Load 외 3 | SCM0009_Auth_Approval.cs:399 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefMain.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-ca8ee7a1 | this.Load 외 3 | SCM0009_Auth_Approval.cs:400 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefMain.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-10b61e0e | this.Load 외 3 | SCM0009_Auth_Approval.cs:401 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefMain.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-bbdef84a | this.Load 외 3 | SCM0009_Auth_Approval.cs:403 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefMain.USER_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3f6c4f8e | this.Load 외 3 | SCM0009_Auth_Approval.cs:405 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0009_Auth_Approval.InterlockTotalMiss

진입점: btnApproval.Click / btnReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-005e4b22 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:478 | if (siMain.GetMaxRowIndex() < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c879ddc2 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:484 | if (NoCheckedBoxes(siMain)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00021") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40cfacdf | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:488 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCM0009_Auth_Approval.NoCheckedBoxes

진입점: btnApproval.Click / btnReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-780f2600 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:496 | for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, spread.GetColumnIndex(DefMain.CHK)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a30cd45 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:497 | for (i <= spread.GetMaxRowIndex()) ▸ if (CHK.ToUpper().Equals("TRUE") && !spread.IsLockCell(i, spread.GetColumnIndex(DefMain.CHK))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5c2255f8 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:499 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCM0009_Auth_Approval.SaveData

진입점: btnApproval.Click / btnReject.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.reason.Length > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ba6b2d8 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:247 | for (p <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.ActiveSheet.GetRowVisible | (p) | ⚠ 의미 확인 필요 |  |  |  |
| AC-280c9f4b | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:248 | for (p <= siMain.GetMaxRowIndex()) ▸ if (!siMain.ActiveSheet.GetRowVisible(p)) | GRID_SET | siMain.SetText | (p, 0, false.ToString()) | 그리드 값 설정 |  |  |  |
| AC-7160a49b | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:250 | for (p <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.IsLockCell | (p, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a8e6d73 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:267 | if (iCount <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b86c7497 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:269 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_SaveApprovalAuthRequest") ⇒ SystemManager.UP_FX_SaveApprovalAuthRequest | 엔드포인트 요청 생성 |  |  |  |
| AC-44acac66 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:271 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c7a1a7b5 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:274 | lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-61671332 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:275 | lambda | DATA_OP | req.Parameters["p_Appr_Result"] | p_Appr_Result | 행/컬럼 값 대입 |  |  |  |
| AC-00cf0e16 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:276 | lambda | DATA_OP | req.Parameters["p_User_ID"] | p_User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-9bc821fb | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:277 | lambda | DATA_OP | req.Parameters["p_User_Name"] | p_User_Name | 행/컬럼 값 대입 |  |  |  |
| AC-636ceb85 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:278 | lambda | DATA_OP | req.Parameters["p_Dept_ID"] | p_Dept_ID | 행/컬럼 값 대입 |  |  |  |
| AC-dac4b1f4 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:279 | lambda | DATA_OP | req.Parameters["p_Group_ID"] | p_Group_ID | 행/컬럼 값 대입 |  |  |  |
| AC-339d48a7 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:280 | lambda | DATA_OP | req.Parameters["p_Division_ID"] | p_Division_ID | 행/컬럼 값 대입 |  |  |  |
| AC-4ae358a6 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:281 | lambda | DATA_OP | req.Parameters["p_Plant_ID"] | p_Plant_ID | 행/컬럼 값 대입 |  |  |  |
| AC-5aaa8ff1 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:282 | lambda | DATA_OP | req.Parameters["p_Customer_Code"] | p_Customer_ID | 행/컬럼 값 대입 |  |  |  |
| AC-2038384b | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:283 | lambda | DATA_OP | req.Parameters["p_Regt_User_ID"] | p_Regt_User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-81cc0d0b | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:284 | lambda | DATA_OP | req.Parameters["p_reject_reason"] | p_reject_reason | 행/컬럼 값 대입 |  |  |  |
| AC-94c6530e | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:285 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7ab16ac0 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:285 | lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-cca21cb1 | btnApproval.Click 외 1 | SCM0009_Auth_Approval.cs:291 | if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCM0009_Auth_Approval.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f93f881 | (진입점 미연결) | SCM0009_Auth_Approval.cs:298 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3eb6e9c9 | (진입점 미연결) | SCM0009_Auth_Approval.cs:301 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25cbe29c | (진입점 미연결) | SCM0009_Auth_Approval.cs:307 | if (dt.Rows.Count > 0) ▸ if (sObj.Equals("REQ")) | UI_PROP | drpReqPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-4b0ac176 | (진입점 미연결) | SCM0009_Auth_Approval.cs:308 | if (dt.Rows.Count > 0) ▸ if (sObj.Equals("REQ")) | UI_PROP | drpReqPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

