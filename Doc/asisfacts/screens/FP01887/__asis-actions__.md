# AS-IS 액션 대조표 — FP01887

> 원천: `Doc/asisfacts/screens/FP01887/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 726행 · 메서드 75 · 종류 DATA_OP 272 · FLAG 77 · RETURN 75 · UI_PROP 63 · ENDPOINT 33 · GRID_SET 32 · UI_MISC 28 · MESSAGE 23 · GRID_INIT 17 · GRID_STYLE 17 · CALL_EXT 13 · LIST_REBIND 13 · GRID_LOCK 13 · POPUP 12 · VALIDATE 9 · COMBO_DATA 8 · VALUE_SET 6 · GRID_BIND 5 · THROW 3 · STATE_RESET 2 · STATE 2 · EXCEL 1 · CALL_BASE 1 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 14


## FP01887_Authority_Approval.AddMyAuthList

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bd7726b | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1286 |  | STATE_RESET | listReqAuthList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c1686ac9 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1306 |  | FLAG | endForLoop | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ce0a7061 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1307 |  | FLAG | finalSuccessIndex | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-da489f62 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1315 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (_p == siMain.GetMaxRowIndex()) | FLAG | endForLoop | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c655fa1a | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1332 | for (_p <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.IsLockCell | (_p, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-96685f2e | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1371 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | dtMyAuthList.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-af849f73 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1473 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_SaveReqAuthAddMyList") ⇒ SystemManager.UP_FX_SaveReqAuthAddMyList | 엔드포인트 요청 생성 |  |  |  |
| AC-68fb6ef1 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1475 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b335445 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1479 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-35d048d2 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1480 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | req.Parameters["p_User_ID"] | p_User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-a49ec8d5 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1481 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | req.Parameters["p_Group_ID"] | p_Group_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8951afdf | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1482 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | req.Parameters["p_Division_ID"] | p_Division_ID | 행/컬럼 값 대입 |  |  |  |
| AC-e516c7fa | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1483 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | req.Parameters["p_Plant_ID"] | p_Plant_ID | 행/컬럼 값 대입 |  |  |  |
| AC-567029b7 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1484 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | req.Parameters["p_Customer_Code"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ef25469c | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1485 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | req.Parameters["p_Approval_Result"] | p_Approval_Result | 행/컬럼 값 대입 |  |  |  |
| AC-86201bad | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1486 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | req.Parameters["p_Created_By"] | p_Created_By | 행/컬럼 값 대입 |  |  |  |
| AC-73897d94 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1487 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | req.Parameters["p_Last_Updated_By"] | p_Last_Updated_By | 행/컬럼 값 대입 |  |  |  |
| AC-f6722775 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1489 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-043bb927 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1489 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-217e3a42 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1496 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | DATA_OP | listReqAuthList.Add | (s_New_User_ID + curGroupID + curDivisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-09fb2dc5 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1502 | for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p,… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01887_Authority_Approval.btnApproval_Click

진입점: this.btnApproval.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3efe30a3 | this.btnApproval.Click | FP01887_Authority_Approval.cs:663 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.btnReject_Click

진입점: this.btnReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8120c70d | this.btnReject.Click | FP01887_Authority_Approval.cs:679 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b83cefe1 | this.btnReject.Click | FP01887_Authority_Approval.cs:687 | if (fps.Name == "spdMain") ▸ if (siMain != null) | POPUP | new FP01887_DescriptionPopup | ("Reject Description") | 팝업/폼 생성 |  |  |  |
| AC-f10c8d25 | this.btnReject.Click | FP01887_Authority_Approval.cs:688 | if (fps.Name == "spdMain") ▸ if (siMain != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-89845aa6 | this.btnReject.Click | FP01887_Authority_Approval.cs:689 | if (fps.Name == "spdMain") ▸ if (siMain != null) | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-dfd69fcc | this.btnReject.Click | FP01887_Authority_Approval.cs:690 | if (fps.Name == "spdMain") ▸ if (siMain != null) | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-5595ff6d | this.btnReject.Click | FP01887_Authority_Approval.cs:691 | if (fps.Name == "spdMain") ▸ if (siMain != null) | UI_PROP | popup.Name | "Reject Description" | 속성 Name 설정 |  |  |  |
| AC-7ed92961 | this.btnReject.Click | FP01887_Authority_Approval.cs:693 | if (fps.Name == "spdMain") ▸ if (siMain != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01887_Authority_Approval.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9de34bf | this.btnSql.Click | FP01887_Authority_Approval.cs:705 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-261bd50d | this.btnSql.Click | FP01887_Authority_Approval.cs:706 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ec070f7f | this.btnSql.Click | FP01887_Authority_Approval.cs:708 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01887_AUTHORITY_APPROVAL_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-078f311f | this.btnSql.Click | FP01887_Authority_Approval.cs:710 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01887_AUTHORITY_APPROVAL_REJECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-deefbd09 | this.btnSql.Click | FP01887_Authority_Approval.cs:711 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01887_Authority_Approval.ChangeAllCheckboxes

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c7d6279 | spdMain.CellClick | FP01887_Authority_Approval.cs:446 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-043719e7 | spdMain.CellClick | FP01887_Authority_Approval.cs:455 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60059323 | spdMain.CellClick | FP01887_Authority_Approval.cs:458 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.ActiveSheet.GetRowVisible | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-48a69547 | spdMain.CellClick | FP01887_Authority_Approval.cs:459 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ if (spread.ActiveSheet.… | GRID_SET | spread.SetText | (i, 1, AllCheck.ToString()) | 그리드 값 설정 |  |  |  |
| AC-05b959ed | spdMain.CellClick | FP01887_Authority_Approval.cs:461 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ else of (spread.ActiveS… | GRID_SET | spread.SetText | (i, 1, false.ToString()) | 그리드 값 설정 |  |  |  |

## FP01887_Authority_Approval.ClbDivision_SelectedIndexChanged

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b00cb9f | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2466 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-93fcea42 | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2468 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01887_Authority_Approval.ClbFactory_SelectedIndexChanged

진입점: this.Load [try] / clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0520a9cc | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2500 |  | FLAG | dtPlanGroup | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP01887_find_newAuth_plangroup", pInstan… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-a60a62b0 | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2500 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP01887_find_newAuth_plangroup", pInstance, pFactory) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a72b1d38 | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2501 |  | UI_PROP | clbPlanGroup.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1b65ef76 | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2502 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-e67e52df | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2503 |  | UI_PROP | clbPlanGroup.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01887_Authority_Approval.ClbInstance_SelectedIndexChanged

진입점: this.Load [try] / clbInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bfd94f1 | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2480 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d137ba55 | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2482 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01887_Authority_Approval.ClbPlanGroup_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04950c34 | (진입점 미연결) | FP01887_Authority_Approval.cs:422 |  | FLAG | dtPlanGroup | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP01887_find_newAuth_plangroup", pInstan… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5e0dedec | (진입점 미연결) | FP01887_Authority_Approval.cs:422 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP01887_find_newAuth_plangroup", pInstance, pFactory) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7230cc98 | (진입점 미연결) | FP01887_Authority_Approval.cs:423 |  | UI_PROP | clbPlanGroup.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-0bbd4fc9 | (진입점 미연결) | FP01887_Authority_Approval.cs:424 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-a05cfa62 | (진입점 미연결) | FP01887_Authority_Approval.cs:425 |  | UI_PROP | clbPlanGroup.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01887_Authority_Approval.ClbPlant_SelectedIndexChanged

진입점: this.Load [try] / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea9ac3a8 | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2473 |  | UI_PROP | clbInstance.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-4882f376 | this.Load [try] 외 1 | FP01887_Authority_Approval.cs:2475 |  | UI_PROP | clbInstance.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01887_Authority_Approval.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f5a67d2 | this.Load | FP01887_Authority_Approval.cs:496 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d5f2a947 | this.Load | FP01887_Authority_Approval.cs:497 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f3dcacc7 | this.Load | FP01887_Authority_Approval.cs:502 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01887_Authority_Approval.CreatSaveDataTable

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a1fb540 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1686 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-cba9ec67 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1687 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6de035d0 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1688 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NEW_USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ed58150 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1689 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NEW_USER_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8e529a5 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1690 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7da0b8b3 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1691 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-71a2b550 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1692 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca5e67fe | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1693 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-63490799 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1694 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_GROUP_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f673d11 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1695 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MENU_AUTHORITY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-89d6ccb3 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1696 |  | DATA_OP | dt.Columns.Add | (new DataColumn("RELEASE_NOTIFIY_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f81d6c9a | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1697 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DESCRIPTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-73f14a80 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1698 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa326f3e | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1699 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e156aa3 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1700 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3cdafaff | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1701 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-716725d8 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1702 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_PLAN_GROUP_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-df4bef11 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1703 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9354c1f3 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1705 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.CreatSaveMenuDataTable

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d44ed78 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1710 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-3d91061e | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1711 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NEW_USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-311afdcf | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1712 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MENU_AUTHORITY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5f63ae7 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1713 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e5f16c1 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1715 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc5e0782 | this.Load | FP01887_Authority_Approval.cs:266 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-380790cd | this.Load | FP01887_Authority_Approval.cs:268 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-aa167cf6 | this.Load | FP01887_Authority_Approval.cs:269 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-cee20b58 | this.Load | FP01887_Authority_Approval.cs:270 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-864675cc | this.Load | FP01887_Authority_Approval.cs:282 | else of (CurUserID == null) | UI_PROP | _userinfo.UserID | CurUserID | 속성 UserID 설정 |  |  |  |
| AC-316b8abf | this.Load | FP01887_Authority_Approval.cs:283 | else of (CurUserID == null) | UI_PROP | _userinfo.UserName | UserInfoContext.Current["NewUserName"] | 속성 UserName 설정 |  |  |  |
| AC-39e79e8b | this.Load | FP01887_Authority_Approval.cs:286 | else of (CurUserID == null) ▸ if (UserInfoContext.Current["NewUserNameE"] == null) | UI_PROP | _userinfo.UserNameE | UserInfoContext.Current["NewUserName"] | 속성 UserNameE 설정 |  |  |  |
| AC-94a1993e | this.Load | FP01887_Authority_Approval.cs:288 | else of (CurUserID == null) ▸ else of (UserInfoContext.Current["NewUserNameE"] == null) | UI_PROP | _userinfo.UserNameE | UserInfoContext.Current["NewUserNameE"] | 속성 UserNameE 설정 |  |  |  |
| AC-2e212b55 | this.Load | FP01887_Authority_Approval.cs:291 | else of (CurUserID == null) | UI_PROP | _userinfo.Email | CurUserID + @"@lgensol.com" | 속성 Email 설정 |  |  |  |
| AC-d17194af | this.Load | FP01887_Authority_Approval.cs:292 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_ID | UserInfoContext.Current["NewDeptID"] | 속성 Dept_ID 설정 |  |  |  |
| AC-fa26ceff | this.Load | FP01887_Authority_Approval.cs:293 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_NameK | UserInfoContext.Current["NewDeptNameK"] | 속성 Dept_NameK 설정 |  |  |  |
| AC-2fa1ffa8 | this.Load | FP01887_Authority_Approval.cs:294 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_NameE | UserInfoContext.Current["NewDeptNameE"] | 속성 Dept_NameE 설정 |  |  |  |
| AC-9ef41ec0 | this.Load | FP01887_Authority_Approval.cs:295 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_NameC | UserInfoContext.Current["NewDeptNameC"] | 속성 Dept_NameC 설정 |  |  |  |
| AC-f78bfc6c | this.Load | FP01887_Authority_Approval.cs:296 | else of (CurUserID == null) | UI_PROP | _userinfo.UserExistYN | UserInfoContext.Current["NewUserExistYN"] | 속성 UserExistYN 설정 |  |  |  |
| AC-cb596e0d | this.Load | FP01887_Authority_Approval.cs:297 | else of (CurUserID == null) | UI_PROP | _userinfo.Default_Grp_ID | "Guest" | 속성 Default_Grp_ID 설정 |  |  |  |
| AC-061a0b97 | this.Load | FP01887_Authority_Approval.cs:298 | else of (CurUserID == null) | UI_PROP | _userinfo.Language | "EN" | 속성 Language 설정 |  |  |  |
| AC-9107c6c4 | this.Load | FP01887_Authority_Approval.cs:299 | else of (CurUserID == null) | UI_PROP | _userinfo.IsNewUser | "Y" | 속성 IsNewUser 설정 |  |  |  |
| AC-81f5ffb6 | this.Load | FP01887_Authority_Approval.cs:305 |  | FLAG | _dtUserInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-8cb6f037 | this.Load | FP01887_Authority_Approval.cs:307 |  | DATA_OP | _dtUserInfo.Columns.Add | ("UserID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad12012a | this.Load | FP01887_Authority_Approval.cs:308 |  | DATA_OP | _dtUserInfo.Columns.Add | ("UserName", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f436709 | this.Load | FP01887_Authority_Approval.cs:309 |  | DATA_OP | _dtUserInfo.Columns.Add | ("UserName_E", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d4f317a | this.Load | FP01887_Authority_Approval.cs:310 |  | DATA_OP | _dtUserInfo.Columns.Add | ("Dept_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5a39d77 | this.Load | FP01887_Authority_Approval.cs:311 |  | DATA_OP | _dtUserInfo.Columns.Add | ("Language", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-38a6dbd3 | this.Load | FP01887_Authority_Approval.cs:312 |  | DATA_OP | _dtUserInfo.Columns.Add | ("DefaultGroupID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6bb8ea29 | this.Load | FP01887_Authority_Approval.cs:313 |  | DATA_OP | _dtUserInfo.Columns.Add | ("TimeZone", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## FP01887_Authority_Approval.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-790fea8d | DeleteButton | FP01887_Authority_Approval.cs:637 |  | MESSAGE | MessageBox.Show | ("Delete Button can't use.!") | 메시지 표시 |  |  |  |
| AC-eab3941b | DeleteButton | FP01887_Authority_Approval.cs:638 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5e5bfa9 | Dispose | FP01887_Authority_Approval.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01887_Authority_Approval.drpPeriod_ValueChanged

진입점: this.drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c5b9769 | this.drpPeriod.ValueChanged | FP01887_Authority_Approval.cs:2517 | if (!sEndDate.Equals("19990101")) ▸ if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sEndDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Start Date can't more than EndDate." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35f8b37b | this.drpPeriod.ValueChanged | FP01887_Authority_Approval.cs:2527 | if (!sEndDate.Equals("19990101")) ▸ if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sEndDate)) | VALUE_SET | drpPeriod.InitValue | sInitDay.ToString() + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b4f6ebb9 | this.drpPeriod.ValueChanged | FP01887_Authority_Approval.cs:2529 | if (!sEndDate.Equals("19990101")) ▸ if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sEndDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.EditButton

진입점: this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0)] / this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(_p, siMain.GetColumnIndex(DefColumns.CHK)).ToString() != "True") ▸ if (endForLoop) ▸ try ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c14f4714 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:579 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-633d9e79 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:585 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-91d2bcad | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:586 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e248f472 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:587 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SEQ), siMain.GetColumnIndex(DefColumns.NEW_USER_DEPARTME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53c4f360 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:588 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.SHOP_GROU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec4c1699 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:589 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FACTORY_ID), siMain.GetColumnIndex(DefColumns.PLAN_GROUP… | 그리드 편집 잠금/해제 |  |  |  |
| AC-54592c90 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:590 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.REQUEST_ID), siMain.GetColumnIndex(DefColumns.ORG_SITE_I… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b7602b84 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:591 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.COMPANY_ID… | 그리드 편집 잠금/해제 |  |  |  |
| AC-35794c52 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:592 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.CHK), siMain.ActiveSheet.RowCount - 1, siMain.GetColu… | 그리드 편집 잠금 전환 |  |  |  |
| AC-de626d2e | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:601 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-d7bcb100 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:606 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sUse… | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(255, 255, 255)) | 그리드 표시 설정 |  |  |  |
| AC-3892205f | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:608 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(250, 255, 220)) | 그리드 표시 설정 |  |  |  |
| AC-1c24d8b0 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:612 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID), i, siMain.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-fd5da404 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:613 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID), i, siMain.GetColumnIndex(DefColumns.INS… | 그리드 표시 설정 |  |  |  |
| AC-be5e7a11 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:614 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE), i, siMain.GetColumnIndex(DefCo… | 그리드 표시 설정 |  |  |  |
| AC-b3b0e259 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:619 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID), i, siMain.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-30183f7d | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:620 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID), i, siMain.GetColumnIndex(DefColumns.INS… | 그리드 표시 설정 |  |  |  |
| AC-a34e05b6 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:621 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE), i, siMain.GetColumnIndex(DefCo… | 그리드 표시 설정 |  |  |  |

## FP01887_Authority_Approval.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cad8a21 | ExcelButton | FP01887_Authority_Approval.cs:721 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP01887_Authority_Approval.FilterData

진입점: this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(_p, siMain.GetColumnIndex(DefColumns.CHK)).ToString() != "True") ▸ if (endForLoop) ▸ try] / comboAuthority.SelectedIndexChanged [try] / F…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a2d29a6 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:961 | if (src.Good()) ▸ if (!string.IsNullOrWhiteSpace(mad)) ▸ else of (mad == "ALL" \|\| mad == "*") ▸ lambda | DATA_OP | x.Field | ("MENU_AUTHORITY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e32b3b46 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:966 | if (src.Good()) ▸ if (!string.IsNullOrWhiteSpace(mad)) ▸ else of (mad == "ALL" \|\| mad == "*") ▸ if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d6c2a5ed | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:967 | if (src.Good()) ▸ if (!string.IsNullOrWhiteSpace(mad)) ▸ else of (mad == "ALL" \|\| mad == "*") ▸ if (m != null && m.Count() > 0) | DATA_OP | ret.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef05f629 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:968 | if (src.Good()) ▸ if (!string.IsNullOrWhiteSpace(mad)) ▸ else of (mad == "ALL" \|\| mad == "*") ▸ if (m != null && m.Count() > 0) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-abf70c56 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:974 |  | DATA_OP | src.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9f629a13 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:974 |  | RETURN | return src.Copy(); |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.finalMessageShow

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(_p, siMain.GetColumnIndex(DefColumns.CHK)).ToString() != "True") ▸ if (endForLoop)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dedccd28 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1511 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c570b820 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1512 |  | MESSAGE | MessageBox.Show | ("Authority List 저장 완료") | 메시지 표시 |  |  |  |

## FP01887_Authority_Approval.Find_Data

진입점: this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(_p, siMain.GetColumnIndex(DefColumns.CHK)).ToString() != "True") ▸ if (endForLoop)] / FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8299f38a | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:726 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-27c869d2 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:731 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a33a5d4 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:734 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b75188d8 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:734 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9bdece0a | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:737 | try | FLAG | dsMainScreen | null | 화면 필드/플래그 변경 |  |  |  |
| AC-32298a50 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:740 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78452375 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:746 | try | FLAG | dsMainQuery | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Approval("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-89fcf0db | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:746 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Approval("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6cfdc7d7 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:752 | try | FLAG | dsMainScreen | FilterData(dsMainQuery) | 화면 필드/플래그 변경 |  |  |  |
| AC-32ba3294 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:754 | try | FLAG | _userList | (from r in dtUser.AsEnumerable() select r["NEW_USER_ID"]).Distinct().ToArray() | 화면 필드/플래그 변경 |  |  |  |
| AC-bd83da94 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:757 | try | STATE_RESET | _dtUserInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-21480a72 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:762 | try ▸ for (i < _userList.Length) | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_User(_userList.GetValue(i).ToString()) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-20df90b6 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:775 | try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMainScreen, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-17f63e29 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:781 | try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMainScreen) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1931ce73 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:784 | try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-30e3c232 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:790 | try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1c4bc127 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:795 | try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-2ce5d164 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:800 | try ▸ else of (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMainScreen, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4a8384bd | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:802 | try ▸ else of (dsMainScreen.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMainScreen) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0ac8c21a | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:804 | try ▸ else of (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-1733f4f1 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:813 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-458da07e | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:818 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5ffb799b | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:818 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP01887_Authority_Approval.Find_Data_Approval

진입점: this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(_p, siMain.GetColumnIndex(DefColumns.CHK)).ToString() != "True") ▸ if (endForLoop) ▸ try ▸ lambda] / popSql.OnSql [if (programID…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92ae2fcd | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1031 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_new_user_id = txtUserID.Text; p_new_user_name = txtUser… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c8a8057 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1054 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL") ⇒ FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | 엔드포인트 요청 생성 |  |  |  |
| AC-26b33bc9 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1055 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-1d31b08f | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1056 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-a5676662 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1057 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-62c2ff4f | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1058 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cb84f820 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1060 | try | DATA_OP | request.Parameters["p_seq"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3cf55dc6 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1061 | try | DATA_OP | request.Parameters["p_new_user_id"] | p_new_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-61b8f022 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1062 | try | DATA_OP | request.Parameters["p_new_user_name"] | p_new_user_name | 행/컬럼 값 대입 |  |  |  |
| AC-01b28a36 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1063 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e723f4ca | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1064 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-ebbedff3 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1065 | try | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-63ef1d69 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1066 | try | DATA_OP | request.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-f71ef105 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1067 | try | DATA_OP | request.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-4ee33f08 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1068 | try | DATA_OP | request.Parameters["p_menu_authority_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bae1736d | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1069 | try | DATA_OP | request.Parameters["p_release_notifiy"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0792eb2b | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1070 | try | DATA_OP | request.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-da3bd0a9 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1071 | try | DATA_OP | request.Parameters["p_request_name"] | p_request_name | 행/컬럼 값 대입 |  |  |  |
| AC-c7391c5b | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1072 | try | DATA_OP | request.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-0a84d3bc | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1073 | try | DATA_OP | request.Parameters["p_end_date"] | p_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-b0480cf1 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1074 | try | DATA_OP | request.Parameters["p_approval_flag"] | p_approval_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1885f330 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1075 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-49bccec9 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1076 | try | DATA_OP | request.Parameters["p_org_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0fb33758 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1077 | try | DATA_OP | request.Parameters["p_org_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aff512af | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1078 | try | DATA_OP | request.Parameters["p_org_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7833501b | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1079 | try | DATA_OP | request.Parameters["p_org_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ee9e6872 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1080 | try | DATA_OP | request.Parameters["p_org_plan_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-126418bc | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1083 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5d888884 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1085 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1aecd3a9 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1090 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.Find_Data_User

진입점: this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ for (i < _userList.Length) ▸ lambda] / this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(_p, siMain.GetColumnIndex(DefColumns.CHK)).ToString() != "True") ▸ if (endForLoop) ▸ try ▸ for (i <…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1372cfe | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:835 | try | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserInfoSearchList") ⇒ SystemManager.UP_FX_GetUserInfoSearchList | 엔드포인트 요청 생성 |  |  |  |
| AC-85c28514 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:836 | try | DATA_OP | request.Parameters["Search"] | search | 행/컬럼 값 대입 |  |  |  |
| AC-a74e4d92 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:837 | try | DATA_OP | request.Parameters["DeptName"] | deptName | 행/컬럼 값 대입 |  |  |  |
| AC-4f1239ad | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:838 | try | DATA_OP | request.Parameters["GroupID"] | group | 행/컬럼 값 대입 |  |  |  |
| AC-58a88b25 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:839 | try | DATA_OP | request.Parameters["UseYN"] | useYN | 행/컬럼 값 대입 |  |  |  |
| AC-aef9498a | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:841 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7e8ff610 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:845 | try ▸ if (response.DataSet.Tables[0].Rows.Count > 0) | DATA_OP | _dtUserInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0040a1ac | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:846 | try ▸ if (response.DataSet.Tables[0].Rows.Count > 0) | DATA_OP | row["UserID"] | response.DataSet.Tables[0].Rows[0]["UserID"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-e7077855 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:847 | try ▸ if (response.DataSet.Tables[0].Rows.Count > 0) | DATA_OP | row["UserName"] | response.DataSet.Tables[0].Rows[0]["UserName"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-cad2eccc | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:848 | try ▸ if (response.DataSet.Tables[0].Rows.Count > 0) | DATA_OP | row["UserName_E"] | response.DataSet.Tables[0].Rows[0]["UserName_E"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-10754353 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:849 | try ▸ if (response.DataSet.Tables[0].Rows.Count > 0) | DATA_OP | row["Dept_ID"] | response.DataSet.Tables[0].Rows[0]["Dept_ID"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-1dc9315d | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:850 | try ▸ if (response.DataSet.Tables[0].Rows.Count > 0) | DATA_OP | row["Language"] | response.DataSet.Tables[0].Rows[0]["Language"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-432000cf | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:851 | try ▸ if (response.DataSet.Tables[0].Rows.Count > 0) | DATA_OP | row["DefaultGroupID"] | response.DataSet.Tables[0].Rows[0]["DefaultGroupID"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-96c3f46d | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:852 | try ▸ if (response.DataSet.Tables[0].Rows.Count > 0) | DATA_OP | row["TimeZone"] | response.DataSet.Tables[0].Rows[0]["TimeZone"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-635cae62 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:853 | try ▸ if (response.DataSet.Tables[0].Rows.Count > 0) | DATA_OP | _dtUserInfo.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-85fdfcc7 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:856 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b8445f0f | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 3 | FP01887_Authority_Approval.cs:862 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.FindButton

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(_p, siMain.GetColumnIndex(DefColumns.CHK)).ToString() != "True") ▸ if (endForLoop)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d035241 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… 외 1 | FP01887_Authority_Approval.cs:559 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1fb6b0ab | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… 외 1 | FP01887_Authority_Approval.cs:564 |  | FLAG | idx_COMPANY_ID | siMain.GetColumnIndex("COMPANY_ID") | 화면 필드/플래그 변경 |  |  |  |

## FP01887_Authority_Approval.FindData_MyAddedAuthList

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p, siMain.GetColumnIndex…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50bec120 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:2748 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetReqAuthMyListAdded") ⇒ SystemManager.UP_FX_GetReqAuthMyListAdded | 엔드포인트 요청 생성 |  |  |  |
| AC-c547b980 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:2750 |  | DATA_OP | request.Parameters["p_UserID"] | Req_User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-c2306ccc | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:2751 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b3c7f37a | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:2765 |  | RETURN | return ds.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b89067a8 | this.Load | FP01887_Authority_Approval.cs:149 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01887_Authority_Approval.GetAuthorityGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99d0cda8 | this.Load [try] | FP01887_Authority_Approval.cs:245 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP01887_Authority_Approval", "AUTHORITY_GROUP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0eba0721 | this.Load [try] | FP01887_Authority_Approval.cs:261 |  | RETURN | return tmpAuth; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.GetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9529a19 | this.Load [try] | FP01887_Authority_Approval.cs:2901 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-eb4195a9 | this.Load [try] | FP01887_Authority_Approval.cs:2902 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-172d252f | this.Load [try] | FP01887_Authority_Approval.cs:2902 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9c056e2b | this.Load [try] | FP01887_Authority_Approval.cs:2903 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01887_Authority_Approval.GetInsertedUserInfo

진입점: this.Load [if (CurUserID == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bff1b51 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:322 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-54bd6059 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:325 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetReqAuthCurrentUser") ⇒ SystemManager.UP_FX_GetReqAuthCurrentUser | 엔드포인트 요청 생성 |  |  |  |
| AC-55e41f30 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:326 | lambda | DATA_OP | req.Parameters["p_UserID"] | User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-0cbeec47 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:328 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7e6f4ea | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:329 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ad7bb711 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:333 |  | CALL_EXT | Thread.Sleep | (2000) | ⚠ 의미 확인 필요 |  |  |  |
| AC-07737b8c | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:337 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.UserID | ds.Tables[0].Rows[0]["USERID"].ToString() | 속성 UserID 설정 |  |  |  |
| AC-5dc37d29 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:338 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.UserName | ds.Tables[0].Rows[0]["USERNAME"].ToString() | 속성 UserName 설정 |  |  |  |
| AC-3fbee20e | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:340 | if (ds.Tables[0].Rows.Count >= 0) ▸ if (ds.Tables[0].Rows[0]["USERNAME_E"].ToString() == "") | UI_PROP | _userinfo.UserNameE | ds.Tables[0].Rows[0]["USERNAME"].ToString() | 속성 UserNameE 설정 |  |  |  |
| AC-4085194f | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:342 | if (ds.Tables[0].Rows.Count >= 0) ▸ else of (ds.Tables[0].Rows[0]["USERNAME_E"].ToString() == "") | UI_PROP | _userinfo.UserNameE | ds.Tables[0].Rows[0]["USERNAME_E"].ToString() | 속성 UserNameE 설정 |  |  |  |
| AC-be24171a | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:344 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Email | ds.Tables[0].Rows[0]["EMAIL"].ToString() | 속성 Email 설정 |  |  |  |
| AC-626b1eed | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:345 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_ID | ds.Tables[0].Rows[0]["DEPT_ID"].ToString() | 속성 Dept_ID 설정 |  |  |  |
| AC-8b59d3dc | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:346 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.CellPhoneNum | ds.Tables[0].Rows[0]["CELLPHONENUM"].ToString() | 속성 CellPhoneNum 설정 |  |  |  |
| AC-9fc43e2f | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:347 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Language | ds.Tables[0].Rows[0]["LANGUAGE"].ToString() | 속성 Language 설정 |  |  |  |
| AC-aba58968 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:348 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Default_Grp_ID | ds.Tables[0].Rows[0]["DEFAULTGROUPID"].ToString() | 속성 Default_Grp_ID 설정 |  |  |  |
| AC-4c7f777c | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:349 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.TimeZone | ds.Tables[0].Rows[0]["TIMEZONE"].ToString() | 속성 TimeZone 설정 |  |  |  |
| AC-67cabf85 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:350 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_NameK | ds.Tables[0].Rows[0]["DEPT_NAME_KO"].ToString() | 속성 Dept_NameK 설정 |  |  |  |
| AC-48ec6eb7 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:351 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_NameE | ds.Tables[0].Rows[0]["DEPT_NAME_EN"].ToString() | 속성 Dept_NameE 설정 |  |  |  |
| AC-f5a772b0 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:352 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_NameC | ds.Tables[0].Rows[0]["DEPT_NAME_CN"].ToString() | 속성 Dept_NameC 설정 |  |  |  |
| AC-eec10b1a | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:353 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.UserExistYN | UserInfoContext.Current["NewUserExistYN"] ?? "Y" | 속성 UserExistYN 설정 |  |  |  |
| AC-71726e28 | this.Load [if (CurUserID == null)] | FP01887_Authority_Approval.cs:354 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.IsNewUser | "N" | 속성 IsNewUser 설정 |  |  |  |

## FP01887_Authority_Approval.GetToDay

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f6648e0 | this.Load [try] | FP01887_Authority_Approval.cs:2773 |  | RETURN | return sToDay; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9983dd47 | this.Load | FP01887_Authority_Approval.cs:175 | try | DATA_OP | Filter["SCREEN_EXCEPTION"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-85650bcd | this.Load | FP01887_Authority_Approval.cs:176 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b7ad06be | this.Load | FP01887_Authority_Approval.cs:182 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-81e72a85 | this.Load | FP01887_Authority_Approval.cs:183 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d0d44d71 | this.Load | FP01887_Authority_Approval.cs:188 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-9d0efb64 | this.Load | FP01887_Authority_Approval.cs:190 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-4012fb60 | this.Load | FP01887_Authority_Approval.cs:193 | try | FLAG | dtAuthority | GetAuthorityGroup() | 화면 필드/플래그 변경 |  |  |  |
| AC-909ea51c | this.Load | FP01887_Authority_Approval.cs:194 | try | LIST_REBIND | clsCtrl.setListBox | (dtAuthority, comboAuthority, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a5bc9d3d | this.Load | FP01887_Authority_Approval.cs:201 | try ▸ for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d691be5 | this.Load | FP01887_Authority_Approval.cs:204 | try | VALUE_SET | rdoGroup1.EditValue | 2 | 컨트롤 값 설정 |  |  |  |
| AC-4d02b423 | this.Load | FP01887_Authority_Approval.cs:205 | try | VALUE_SET | rdoGroup1.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-3d023c37 | this.Load | FP01887_Authority_Approval.cs:226 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-dcef7cfc | this.Load | FP01887_Authority_Approval.cs:227 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4a341e84 | this.Load | FP01887_Authority_Approval.cs:228 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-03075c98 | this.Load | FP01887_Authority_Approval.cs:232 | try ▸ if (!_sSaveAuth.Equals("Y")) | UI_PROP | lblApproval.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-17baef9f | this.Load | FP01887_Authority_Approval.cs:233 | try ▸ if (!_sSaveAuth.Equals("Y")) | UI_PROP | lblReject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0a480d08 | this.Load | FP01887_Authority_Approval.cs:239 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01887_Authority_Approval.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9950e86 | this.Load | FP01887_Authority_Approval.cs:511 | try | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-cfb06a6a | this.Load | FP01887_Authority_Approval.cs:514 | try | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-4d541e84 | this.Load | FP01887_Authority_Approval.cs:516 | try | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.PLAN_GROUP_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-af1fa9b2 | this.Load | FP01887_Authority_Approval.cs:526 | try | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-8c9b9edb | this.Load | FP01887_Authority_Approval.cs:527 | try | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-94c9463b | this.Load | FP01887_Authority_Approval.cs:528 | try | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-136d8e3a | this.Load | FP01887_Authority_Approval.cs:533 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01887_Authority_Approval.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85306741 | InsertButton | FP01887_Authority_Approval.cs:572 |  | MESSAGE | MessageBox.Show | ("Insert Button can't use.!") | 메시지 표시 |  |  |  |
| AC-1c68cd91 | InsertButton | FP01887_Authority_Approval.cs:573 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.rdoGroup1_SelectedIndexChanged

진입점: this.rdoGroup1.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-830c06f5 | this.rdoGroup1.SelectedIndexChanged | FP01887_Authority_Approval.cs:2448 | if (radioGroup.SelectedIndex == 0) | FLAG | _sApprovalFlag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9ab521f2 | this.rdoGroup1.SelectedIndexChanged | FP01887_Authority_Approval.cs:2452 | else of (radioGroup.SelectedIndex == 0) ▸ if (radioGroup.SelectedIndex == 1) | FLAG | _sApprovalFlag | "R" | 화면 필드/플래그 변경 |  |  |  |
| AC-fd47bcdf | this.rdoGroup1.SelectedIndexChanged | FP01887_Authority_Approval.cs:2456 | else of (radioGroup.SelectedIndex == 0) ▸ else of (radioGroup.SelectedIndex == 1) ▸ if (radioGroup.SelectedIndex == 2) | FLAG | _sApprovalFlag | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-6e9b89dd | this.rdoGroup1.SelectedIndexChanged | FP01887_Authority_Approval.cs:2460 | else of (radioGroup.SelectedIndex == 0) ▸ else of (radioGroup.SelectedIndex == 1) ▸ else of (radioGroup.SelectedIndex == 2) ▸ if (radioGroup… | FLAG | _sApprovalFlag | "N" | 화면 필드/플래그 변경 |  |  |  |

## FP01887_Authority_Approval.ReLoad_Data

진입점: comboAuthority.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-882b7ac8 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:869 | if (!dsMainQuery.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd60c9d6 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:870 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8105ff6a | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:875 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-48062801 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:878 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-48f840e0 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:878 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8394f7e6 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:881 | try | FLAG | dsMainScreen | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7ccd1d40 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:884 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f778534 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:890 | try | FLAG | dsMainScreen | FilterData(dsMainQuery) | 화면 필드/플래그 변경 |  |  |  |
| AC-93b88187 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:899 | try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMainScreen, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-26f9c5a4 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:905 | try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMainScreen) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6811b5d0 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:908 | try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c19daa88 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:914 | try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f15aa668 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:919 | try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-d601f8b0 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:924 | try ▸ else of (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMainScreen, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c0e1edbf | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:926 | try ▸ else of (dsMainScreen.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMainScreen) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d188c44e | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:928 | try ▸ else of (dsMainScreen.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b6f057a0 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:936 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-40ca9ee5 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:941 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-79aa2663 | comboAuthority.SelectedIndexChanged | FP01887_Authority_Approval.cs:941 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP01887_Authority_Approval.RequestAuthList

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p, siMain.GetColumnIndex…) ▸ else of (dtMyAuthList.Select().Where(s => s["user_id"].ToString() == SP_DataSource.Tables[0].Rows[_p]["NEW_USER_ID"].ToString() &…) ▸ try ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f4410f9 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1528 | if (siMain.GetValue(_p2, siMain.GetColumnIndex(DefColumns.CHK)).ToString() != "True") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d24e859 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1530 |  | CALL_EXT | siMain.IsLockCell | (_p2, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b393d21 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1554 | if (iCount <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee8d7a96 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1560 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_SaveReqAuthRequestMyList") ⇒ SystemManager.UP_FX_SaveReqAuthRequestMyList | 엔드포인트 요청 생성 |  |  |  |
| AC-17a506d9 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1562 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7e488b33 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1565 | lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e28de7af | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1566 | lambda | DATA_OP | req.Parameters["p_User_ID"] | p_User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-558d7354 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1567 | lambda | DATA_OP | req.Parameters["p_User_Name"] | p_User_Name | 행/컬럼 값 대입 |  |  |  |
| AC-06d19bc2 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1568 | lambda | DATA_OP | req.Parameters["p_Group_ID"] | p_Group_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f1d68d01 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1569 | lambda | DATA_OP | req.Parameters["p_Division_ID"] | p_Division_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f87f2057 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1570 | lambda | DATA_OP | req.Parameters["p_Plant_ID"] | p_Plant_ID | 행/컬럼 값 대입 |  |  |  |
| AC-9656c3c5 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1571 | lambda | DATA_OP | req.Parameters["p_Customer_Code"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6a7732b6 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1572 | lambda | DATA_OP | req.Parameters["p_User_NameE"] | p_UserName_E | 행/컬럼 값 대입 |  |  |  |
| AC-48a6792f | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1573 | lambda | DATA_OP | req.Parameters["p_Default_Group_ID"] | p_DefaultGroupID | 행/컬럼 값 대입 |  |  |  |
| AC-c5a53bf0 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1574 | lambda | DATA_OP | req.Parameters["p_Dept_ID"] | p_Dept_ID | 행/컬럼 값 대입 |  |  |  |
| AC-e747f884 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1575 | lambda | DATA_OP | req.Parameters["p_Email"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7b0f29e6 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1576 | lambda | DATA_OP | req.Parameters["p_CellPhone"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1cffc91d | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1577 | lambda | DATA_OP | req.Parameters["p_Language"] | _Language | 행/컬럼 값 대입 |  |  |  |
| AC-57d4252f | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1578 | lambda | DATA_OP | req.Parameters["p_TimeZone"] | _TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-d9979fe0 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1580 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4cb05f3c | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1580 | lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-46e8fa93 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1591 | else of (tran.Success) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01887_Authority_Approval.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc96ac60 | popSql.OnSql | FP01887_Authority_Approval.cs:2781 | if (programID == "PR_UI_FP01887_AUTHORITY_APPROVAL_SELECT") | RETURN | return Find_Data_Approval("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-f05f45fc | popSql.OnSql | FP01887_Authority_Approval.cs:2789 | if (programID == "PR_UI_FP01887_AUTHORITY_APPROVAL_REJECT") | RETURN | return Save_Data_Reject("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-81ebaed4 | popSql.OnSql | FP01887_Authority_Approval.cs:2791 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.Save_Approval

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a92087f | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1106 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-1c03cb11 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1106 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f5d11db | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1110 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e4abb1b | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1112 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f228f36 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1117 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8ae29070 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1118 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e63ff6e | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1121 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c2e100f5 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1128 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-5b6a296d | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1130 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-46159b4b | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1131 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8cf9c62b | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1151 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eb9c41e8 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1153 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["SEQ"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06825290 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1154 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["NEW_USER_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.NEW_USER_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6e1b34c | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1155 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["NEW_USER_NAME"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.NEW_USER_NAME)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-414c1b0e | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1156 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["DIVISION_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-856915bc | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1157 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["PLANT_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1dee1a75 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1158 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["FACTORY_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ec4a41f9 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1159 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["INSTANCE_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1cf1f804 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1160 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["PLAN_GROUP_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_GROUP_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e359df76 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1161 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["MENU_AUTHORITY_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-356a8ed4 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1162 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["RELEASE_NOTIFIY_TYPE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-db0fe4a9 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1163 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["DESCRIPTION"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-49c41862 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1164 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["ORG_DIVISION_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ORG_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-86c7bfe4 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1165 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["ORG_PLANT_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ORG_PLANT_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8690374 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1166 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["ORG_FACTORY_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ORG_FACTORY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ce3be694 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1167 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["ORG_INSTANCE_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ORG_INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3e416d8e | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1168 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["ORG_PLAN_GROUP_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ORG_PLAN_GROUP_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69a54217 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1169 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f43aac9f | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1171 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-74090ca4 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1180 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bCurrAuth) | MESSAGE | MessageBox.Show | ("Planner권한이 이미 있습니다.\r\nVIewer권한 승인 시 Planner 권한은 사라지고 VIewer 권한만 남게 됩니다.\r\n그래도 승인하시겠습니까… | 메시지 표시 |  |  |  |
| AC-f7dd1119 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1182 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bCurrAuth) ▸ if (MessageBox.Show("Planner권한이 이미 있습니다.\r\nVIewer권한 승인 시 Planner 권한은 사라지… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36b9edaa | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1188 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | MESSAGE | MessageBox.Show | ("Checked Row!.") | 메시지 표시 |  |  |  |
| AC-6e6d5bde | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1189 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e4f56f3 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1192 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a47641b | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1215 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dtMenu.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-98039e3a | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1217 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["NEW_USER_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.NEW_USER_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-635ce2e9 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1218 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["MENU_AUTHORITY_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c17559b3 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1219 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-62891d81 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1221 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dtMenu.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3979c448 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1227 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) | DATA_OP | dsSaveMenuData.Tables.Add | (dtMenu) | 데이터 객체 조작/조회 |  |  |  |
| AC-031b496d | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1237 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ if (bFlagMenu == false) | MESSAGE | MessageBox.Show | ("insert_approval_menu error.!", "Approval Menu Save", MessageBoxButtons.OK, MessageBoxIco… | 메시지 표시 |  |  |  |
| AC-280321d2 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1242 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-993d0933 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1245 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e8497d0a | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1254 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ catch ((Exception)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3a2d0544 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1263 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (bFlag) | MESSAGE | MessageBox.Show | (errorMsg, "insert_approval Save Error.", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-598f90e3 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1267 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-481d9de0 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1271 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-aa7c4807 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1273 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "Approval Save", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-3d342f7c | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1277 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b65b84de | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1278 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP01887_Authority_Approval.Save_Data_Approval

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dsSaveData.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c8bc80a | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1725 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP01887_AUTHORITY_APPROVAL", "insert_approval", dsData) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_approval] \| FP\Common\FP… | 엔드포인트 호출 |  |  |  |
| AC-6dd9e6c8 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1729 | try ▸ if (result.Good()) | DATA_OP | result.Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a0a4bc2 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1741 | try ▸ if (result.Good()) ▸ if (result.Columns.Contains("RESULT")) ▸ else of (result.Rows[0]["RESULT"].ToString().ToUpper() == "SUCCESS") ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ed51818e | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1748 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-53b276e4 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1752 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-fbbb698a | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1753 | catch ((Exception ex)) | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.Save_Data_Approval_Menu

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ if (dsSaveData.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5057eabe | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1763 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP01887_AUTHORITY_APPROVAL", "insert_approval_menu", dsData) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_approval_menu] \| FP\Comm… | 엔드포인트 호출 |  |  |  |
| AC-4c5bc3c6 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1767 | try ▸ if (result.Good()) | DATA_OP | result.Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-6d776dc8 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1779 | try ▸ if (result.Good()) ▸ if (result.Columns.Contains("RESULT")) ▸ else of (result.Rows[0]["RESULT"].ToString().ToUpper() == "SUCCESS") ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6d6a584 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1787 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-ba5f261b | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1791 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-7663fa1f | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1792 | catch ((Exception ex)) | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.Save_Data_Approval_Menu_Old

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a2bd46d | (진입점 미연결) | FP01887_Authority_Approval.cs:2002 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL") ⇒ FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | 엔드포인트 요청 생성 |  |  |  |
| AC-c86e4987 | (진입점 미연결) | FP01887_Authority_Approval.cs:2003 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-80420c03 | (진입점 미연결) | FP01887_Authority_Approval.cs:2005 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-275282ed | (진입점 미연결) | FP01887_Authority_Approval.cs:2006 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c180ec72 | (진입점 미연결) | FP01887_Authority_Approval.cs:2007 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-4f07ea3f | (진입점 미연결) | FP01887_Authority_Approval.cs:2008 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e383ca76 | (진입점 미연결) | FP01887_Authority_Approval.cs:2009 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d1613456 | (진입점 미연결) | FP01887_Authority_Approval.cs:2010 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_new_user_id"] | p_new_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-dee3704e | (진입점 미연결) | FP01887_Authority_Approval.cs:2011 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_new_user_name"] | p_new_user_name | 행/컬럼 값 대입 |  |  |  |
| AC-1dfc8e6c | (진입점 미연결) | FP01887_Authority_Approval.cs:2012 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ca698b1d | (진입점 미연결) | FP01887_Authority_Approval.cs:2013 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-cbb59eda | (진입점 미연결) | FP01887_Authority_Approval.cs:2014 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-b201d9fa | (진입점 미연결) | FP01887_Authority_Approval.cs:2015 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-61af23b6 | (진입점 미연결) | FP01887_Authority_Approval.cs:2016 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-be494b17 | (진입점 미연결) | FP01887_Authority_Approval.cs:2017 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_menu_authority_id"] | p_menu_authority_id | 행/컬럼 값 대입 |  |  |  |
| AC-3513893d | (진입점 미연결) | FP01887_Authority_Approval.cs:2018 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_notifiy"] | p_release_notifiy | 행/컬럼 값 대입 |  |  |  |
| AC-9170d64c | (진입점 미연결) | FP01887_Authority_Approval.cs:2019 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-512fc394 | (진입점 미연결) | FP01887_Authority_Approval.cs:2020 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_name"] | p_request_name | 행/컬럼 값 대입 |  |  |  |
| AC-6b0c0948 | (진입점 미연결) | FP01887_Authority_Approval.cs:2021 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-f9210c0c | (진입점 미연결) | FP01887_Authority_Approval.cs:2022 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_end_date"] | p_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-ae565cae | (진입점 미연결) | FP01887_Authority_Approval.cs:2023 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_approval_flag"] | p_approval_flag | 행/컬럼 값 대입 |  |  |  |
| AC-598a7ab4 | (진입점 미연결) | FP01887_Authority_Approval.cs:2024 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-38336e68 | (진입점 미연결) | FP01887_Authority_Approval.cs:2025 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_division_id"] | p_org_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e0bbe2f | (진입점 미연결) | FP01887_Authority_Approval.cs:2026 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_plant_id"] | p_org_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-c08db7f6 | (진입점 미연결) | FP01887_Authority_Approval.cs:2027 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_factory_id"] | p_org_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-93f022f8 | (진입점 미연결) | FP01887_Authority_Approval.cs:2028 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_instance_id"] | p_org_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-3115c26f | (진입점 미연결) | FP01887_Authority_Approval.cs:2029 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_plan_group_id"] | p_org_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab2d6b62 | (진입점 미연결) | FP01887_Authority_Approval.cs:2031 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c2b40b45 | (진입점 미연결) | FP01887_Authority_Approval.cs:2032 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-80abae7a | (진입점 미연결) | FP01887_Authority_Approval.cs:2038 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-cf032790 | (진입점 미연결) | FP01887_Authority_Approval.cs:2044 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.Save_Data_Approval_Old

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8297b9f | (진입점 미연결) | FP01887_Authority_Approval.cs:1875 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL") ⇒ FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | 엔드포인트 요청 생성 |  |  |  |
| AC-c1d8fb6e | (진입점 미연결) | FP01887_Authority_Approval.cs:1876 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d3aecf35 | (진입점 미연결) | FP01887_Authority_Approval.cs:1878 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-0015ed3b | (진입점 미연결) | FP01887_Authority_Approval.cs:1879 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b8d160f9 | (진입점 미연결) | FP01887_Authority_Approval.cs:1880 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-4b09f0b9 | (진입점 미연결) | FP01887_Authority_Approval.cs:1881 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cd369c3a | (진입점 미연결) | FP01887_Authority_Approval.cs:1882 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-1fdfe173 | (진입점 미연결) | FP01887_Authority_Approval.cs:1883 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_new_user_id"] | p_new_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d61caf3a | (진입점 미연결) | FP01887_Authority_Approval.cs:1884 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_new_user_name"] | p_new_user_name | 행/컬럼 값 대입 |  |  |  |
| AC-a582a9c5 | (진입점 미연결) | FP01887_Authority_Approval.cs:1885 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bd831b76 | (진입점 미연결) | FP01887_Authority_Approval.cs:1886 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-9dd50ae2 | (진입점 미연결) | FP01887_Authority_Approval.cs:1887 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-2ea8084d | (진입점 미연결) | FP01887_Authority_Approval.cs:1888 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-e33a3578 | (진입점 미연결) | FP01887_Authority_Approval.cs:1889 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-5240848e | (진입점 미연결) | FP01887_Authority_Approval.cs:1890 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_menu_authority_id"] | p_menu_authority_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c382f89 | (진입점 미연결) | FP01887_Authority_Approval.cs:1891 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_notifiy"] | p_release_notifiy | 행/컬럼 값 대입 |  |  |  |
| AC-38b96ab3 | (진입점 미연결) | FP01887_Authority_Approval.cs:1892 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-f75310bd | (진입점 미연결) | FP01887_Authority_Approval.cs:1893 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_name"] | p_request_name | 행/컬럼 값 대입 |  |  |  |
| AC-e870a394 | (진입점 미연결) | FP01887_Authority_Approval.cs:1894 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-fc2c534f | (진입점 미연결) | FP01887_Authority_Approval.cs:1895 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_end_date"] | p_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-463a4b71 | (진입점 미연결) | FP01887_Authority_Approval.cs:1896 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_approval_flag"] | p_approval_flag | 행/컬럼 값 대입 |  |  |  |
| AC-62a05dc2 | (진입점 미연결) | FP01887_Authority_Approval.cs:1897 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-2037901a | (진입점 미연결) | FP01887_Authority_Approval.cs:1898 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_division_id"] | p_org_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1f5293e8 | (진입점 미연결) | FP01887_Authority_Approval.cs:1899 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_plant_id"] | p_org_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-9ba661a6 | (진입점 미연결) | FP01887_Authority_Approval.cs:1900 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_factory_id"] | p_org_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e93fac1 | (진입점 미연결) | FP01887_Authority_Approval.cs:1901 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_instance_id"] | p_org_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-d5d63745 | (진입점 미연결) | FP01887_Authority_Approval.cs:1902 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_plan_group_id"] | p_org_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce16cdfa | (진입점 미연결) | FP01887_Authority_Approval.cs:1904 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-169fef06 | (진입점 미연결) | FP01887_Authority_Approval.cs:1905 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3756bbf5 | (진입점 미연결) | FP01887_Authority_Approval.cs:1911 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c5690d3d | (진입점 미연결) | FP01887_Authority_Approval.cs:1917 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.Save_Data_Edit

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cb74f18 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2389 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL") ⇒ FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | 엔드포인트 요청 생성 |  |  |  |
| AC-f1778fc8 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2390 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fdf02deb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2392 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-326447f5 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2393 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-62671fa9 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2394 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5ea4f987 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2395 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8be6ed75 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2396 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-1f5a2a64 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2397 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_new_user_id"] | p_new_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ca1bcf54 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2398 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_new_user_name"] | p_new_user_name | 행/컬럼 값 대입 |  |  |  |
| AC-11759869 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2399 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-578985bb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2400 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e6e361e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2401 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-87c42f55 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2402 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-408a88a8 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2403 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-ae76ea82 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2404 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_menu_authority_id"] | p_menu_authority_id | 행/컬럼 값 대입 |  |  |  |
| AC-89b390d4 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2405 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_notifiy"] | p_release_notifiy | 행/컬럼 값 대입 |  |  |  |
| AC-b9b3d5df | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2406 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-a578d1d4 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2407 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_name"] | p_request_name | 행/컬럼 값 대입 |  |  |  |
| AC-530883c4 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2408 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-21862eb6 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2409 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_end_date"] | p_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-c3de1cb9 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2410 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_approval_flag"] | p_approval_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4e1c4148 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2411 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-d1b79488 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2412 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_division_id"] | p_org_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-81585df2 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2413 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_plant_id"] | p_org_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-ee32a8c1 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2414 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_factory_id"] | p_org_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-a8b3536c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2415 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_instance_id"] | p_org_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-c50485d6 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2416 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_plan_group_id"] | p_org_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-16fdf190 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2418 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ce64688 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2419 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f7a744ec | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2425 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-4ab67b5a | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2431 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.Save_Data_Reject

진입점: this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)] / popSql.OnSql [if (programID == "PR_UI_FP01887_AUTHORITY_APPROVAL_REJECT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea85e125 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2199 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL") ⇒ FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | 엔드포인트 요청 생성 |  |  |  |
| AC-177f750a | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2200 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-646be80b | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2202 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-9ad47abb | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2203 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d77d8b4c | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2204 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-d5fe5772 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2205 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-1c8b5f9b | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2206 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-799cc723 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2207 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_new_user_id"] | p_new_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8dffa5a2 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2208 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_new_user_name"] | p_new_user_name | 행/컬럼 값 대입 |  |  |  |
| AC-26b75683 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2209 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c73e5ebe | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2210 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-a8fd8349 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2211 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-ed855818 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2212 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-95a2ff9f | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2213 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-fffaa3b3 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2214 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_menu_authority_id"] | p_menu_authority_id | 행/컬럼 값 대입 |  |  |  |
| AC-b49b6213 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2215 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_notifiy"] | p_release_notifiy | 행/컬럼 값 대입 |  |  |  |
| AC-bfa85a70 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2216 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-61e3d220 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2217 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_name"] | p_request_name | 행/컬럼 값 대입 |  |  |  |
| AC-e1a475e6 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2218 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-5fc02480 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2219 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_end_date"] | p_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-92e19763 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2220 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_approval_flag"] | p_approval_flag | 행/컬럼 값 대입 |  |  |  |
| AC-569f1763 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2221 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-cccd4f65 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2222 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_division_id"] | p_org_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-16474443 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2223 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_plant_id"] | p_org_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-304dd9b1 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2224 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_factory_id"] | p_org_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9235801 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2225 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_instance_id"] | p_org_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-787abc8d | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2226 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_plan_group_id"] | p_org_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-93d42b82 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2228 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d0753d2f | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2229 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7c69dd4d | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2235 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6d24ea1e | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 1 | FP01887_Authority_Approval.cs:2241 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.Save_Edit

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c9d65e6 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2247 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-59e68ad4 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2247 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af3af85e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2249 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b292d41 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2251 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-072e54f8 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2256 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f45aaa46 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2257 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81ea40b9 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2260 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0897226e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2267 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-83863b1b | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2269 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-950eb58d | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2270 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6f6bac7 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2275 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-12b6d11b | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2280 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97789dab | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2290 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0376b589 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2294 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cc981c4c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2298 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0f9c6353 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2299 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-89ba7946 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2304 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4b19a16c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01887_Authority_Approval.cs:2305 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP01887_Authority_Approval.Save_Reject

진입점: this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b638d319 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2051 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-991d2afa | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2051 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b682c13 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2055 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b581fa34 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2057 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15f4754e | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2062 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d70457d | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2063 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8299e17 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2066 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6521a878 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2073 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-b831dcd4 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2075 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-186cfb81 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2076 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8aa37523 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2084 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), message) | 그리드 값 설정 |  |  |  |
| AC-16f119ce | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2089 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f50ac0fc | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2094 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c22b9343 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2104 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95dc081e | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2108 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cb1c5fa1 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2112 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5ab8d959 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2113 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db1490c1 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2118 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8df93590 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… | FP01887_Authority_Approval.cs:2119 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP01887_Authority_Approval.SaveAuthList

진입점: this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(_p, 1).ToUpper().Equals("TRUE") && !siMain.IsLockCell(_p, 1) && !siMain.GetText(_p, siMain.GetColumnIndex…) ▸ else of (dtMyAuthList.Select().Where(s => s["user_id"].ToString() == SP_DataSource.Tables[0].Rows[_p]["NEW_USER_ID"].ToString() &…) ▸ try ▸ if (tran.Success) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed98450c | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1642 | if (iCount <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa7fa8a3 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1644 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_SaveApprovalAuthRequest") ⇒ SystemManager.UP_FX_SaveApprovalAuthRequest | 엔드포인트 요청 생성 |  |  |  |
| AC-5b31a6a4 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1646 |  | ENDPOINT | asyncProxyAp.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7c4cd84d | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1649 | lambda | DATA_OP | reqAp.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-24e571b0 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1650 | lambda | DATA_OP | reqAp.Parameters["p_Appr_Result"] | p_Appr_Result | 행/컬럼 값 대입 |  |  |  |
| AC-d453d0de | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1651 | lambda | DATA_OP | reqAp.Parameters["p_User_ID"] | p_User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-0635bb53 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1652 | lambda | DATA_OP | reqAp.Parameters["p_User_Name"] | p_User_Name | 행/컬럼 값 대입 |  |  |  |
| AC-f2e907df | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1653 | lambda | DATA_OP | reqAp.Parameters["p_Dept_ID"] | p_Dept_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b383a908 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1654 | lambda | DATA_OP | reqAp.Parameters["p_Group_ID"] | p_Group_ID | 행/컬럼 값 대입 |  |  |  |
| AC-0d62f394 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1655 | lambda | DATA_OP | reqAp.Parameters["p_Division_ID"] | p_Division_ID | 행/컬럼 값 대입 |  |  |  |
| AC-18fac60e | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1656 | lambda | DATA_OP | reqAp.Parameters["p_Plant_ID"] | p_Plant_ID | 행/컬럼 값 대입 |  |  |  |
| AC-a88e5149 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1657 | lambda | DATA_OP | reqAp.Parameters["p_Customer_Code"] | p_Customer_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f5aa188a | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1658 | lambda | DATA_OP | reqAp.Parameters["p_Regt_User_ID"] | _userinfo.UserID | 행/컬럼 값 대입 |  |  |  |
| AC-deaa7623 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1659 | lambda | DATA_OP | reqAp.Parameters["p_reject_reason"] | p_reject_reason | 행/컬럼 값 대입 |  |  |  |
| AC-c00cb765 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1660 | lambda | ENDPOINT | client.ExecuteDataSet | (reqAp) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0d646d4d | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1660 | lambda | RETURN | return client.ExecuteDataSet(reqAp); |  | 처리 중단/반환 |  |  |  |
| AC-efd72495 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1667 | if (tranAp.Success) | FLAG | finalSuccessIndex | _p3 | 화면 필드/플래그 변경 |  |  |  |
| AC-982433c3 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1671 | if (tranAp.Success) ▸ if (p_final) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-20bf3bf4 | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1672 | if (tranAp.Success) ▸ if (p_final) | MESSAGE | MessageBox.Show | ("Authority List 저장 완료") | 메시지 표시 |  |  |  |
| AC-df79275d | this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siM… | FP01887_Authority_Approval.cs:1678 | else of (tranAp.Success) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01887_Authority_Approval.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb584e52 | SaveButton | FP01887_Authority_Approval.cs:644 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.SetChangeControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbInstance.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-611fdd84 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2828 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-66396e55 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2828 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-67f300fd | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2833 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-3aa37c26 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2837 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-cc9f1692 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2837 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-56755bc3 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2839 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-70d5a056 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2841 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlan… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5f75fd44 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2848 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-560c6a62 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2849 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_BY_PLANT", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-91f39034 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2849 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_BY_PLANT", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-abff5b7d | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2851 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ if ((object)clbInstance is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtInstance, (object)clbInstance as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b34e182e | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2853 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ else of ((object)clbInstance is UsrCombo) ▸ if ((object)clbInstanc… | LIST_REBIND | clsCtrl.setListBox | (dtInstance, (object)clbInstance as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bd9bc920 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2860 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-adfb6146 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2861 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-ee4f29b8 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2861 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c5897b52 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2863 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ if ((object)clbFactory is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0ce4a572 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2865 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ else of ((object)clbFactory is UsrCombo) ▸ if ((object)clbFa… | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-83ffe818 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2872 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-a3fbe056 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2875 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if (dtPlanGroup == null) | FLAG | dtPlanGroup | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-40396887 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2876 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if (dtPlanGroup == null) | UI_PROP | dtPlanGroup.TableName | "" | 속성 TableName 설정 |  |  |  |
| AC-79edf719 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2877 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if (dtPlanGroup == null) | DATA_OP | dtPlanGroup.Columns.SafeAdd | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-62619c13 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2878 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if (dtPlanGroup == null) | DATA_OP | dtPlanGroup.Columns.SafeAdd | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c59c8ca | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2882 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ else of (dtPlanGroup == null) | GRID_CLEAR | dtPlanGroup.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-b35e0486 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2885 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if ((object)clbPlanGroup is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, (object)clbPlanGroup as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3bf7b770 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2887 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ else of ((object)clbPlanGroup is UsrCombo) ▸ if ((object)clbPl… | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, (object)clbPlanGroup as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fbc54c06 | this.Load [try] 외 5 | FP01887_Authority_Approval.cs:2893 | switch (triggerControl) case DefColumns.PLAN_GROUP_ID: ▸ if (dtPlanGroup.Good()) | DATA_OP | Filter["PLAN_GROUP_ID"] | CString.GetCheckedListValue(dtPlanGroup, clbPlanGroup.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01887_Authority_Approval.SetChangedControl

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a93b20c | (진입점 미연결) | FP01887_Authority_Approval.cs:378 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01887_Authority_Approval.SetHiddenColmn

진입점: this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ finally] / this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(_p, siMain.GetColumnIndex(DefColumns.CHK)).ToString() != "True") ▸ if (endForLoop) ▸ finally] / this.Load [try] / comboAuthority.Sele…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ff76f8e | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:541 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SEQ)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bee154c8 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:542 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-13cdca9f | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:543 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ORG_PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9deafa1c | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:544 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ORG_SHOP_GROUP_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d9c51921 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:545 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ORG_FACTORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-24727d7f | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:546 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ORG_INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3f8d6abc | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:547 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ORG_PLAN_GROUP_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-62f3a4ea | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 5 | FP01887_Authority_Approval.cs:548 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ORG_SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP01887_Authority_Approval.SetPlanGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91c89909 | (진입점 미연결) | FP01887_Authority_Approval.cs:2710 |  | FLAG | dtPlanGroup | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP01887_find_newAuth_plangroup", pInstan… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-555bcc5c | (진입점 미연결) | FP01887_Authority_Approval.cs:2710 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP01887_find_newAuth_plangroup", pInstance, pFactory) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a86907e6 | (진입점 미연결) | FP01887_Authority_Approval.cs:2711 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01887_Authority_Approval.SetSheetColorAndChkeck

진입점: this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (dsMainScreen.Tables[0].Rows.Count > 0)] / this.btnApproval.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFlag) ▸ else of (bFlagMenu == false) ▸ try ▸ for (_p <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(_p, siMain.GetColumnIndex(DefColumns.CHK)).ToString() != "True") ▸ if (endForLoop) ▸ try ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a62365aa | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:981 | if (siMain.GetMaxRowIndex() > 0) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-2bed0afb | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:990 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sValue.Equals("1")) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CHK), "True") | 그리드 값 설정 |  |  |  |
| AC-5c714aaa | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:993 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sValue.Equals("1")) ▸ if (sUser.Equals(UserInfoContext.Current.U… | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(255, 255, 255)) | 그리드 표시 설정 |  |  |  |
| AC-d95b5ece | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:995 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sValue.Equals("1")) ▸ else of (sUser.Equals(UserInfoContext.Curr… | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(250, 255, 220)) | 그리드 표시 설정 |  |  |  |
| AC-a1208fe9 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:999 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sValue.Equals("1")) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CHK), "False") | 그리드 값 설정 |  |  |  |
| AC-c9880321 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1002 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sValue.Equals("1")) ▸ if (sUser.Equals(UserInfoContext.Curr… | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(255, 255, 255)) | 그리드 표시 설정 |  |  |  |
| AC-e20b6693 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1004 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sValue.Equals("1")) ▸ else of (sUser.Equals(UserInfoContext… | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(250, 255, 220)) | 그리드 표시 설정 |  |  |  |
| AC-b015a8e1 | this.btnReject.Click [if (fps.Name == "spdMain") ▸ if (siMai… 외 4 | FP01887_Authority_Approval.cs:1007 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CHK), "False") | 그리드 값 설정 |  |  |  |

## FP01887_Authority_Approval.SetStartEndDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b4be1a4 | this.Load [try] | FP01887_Authority_Approval.cs:2728 |  | VALUE_SET | drpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |

## FP01887_Authority_Approval.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c554cd23 | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2553 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a9cffd1 | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2555 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be9c5524 | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2570 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (!sApprovalFlag.Equals("R")) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CHK), "False") | 그리드 값 설정 |  |  |  |
| AC-b133558e | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2571 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (!sApprovalFlag.Equals("R")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-759363dc | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2581 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) ▸ if (fc … | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a3643e44 | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2584 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) | POPUP | new FP01887_InstancePopup | () | 팝업/폼 생성 |  |  |  |
| AC-3687fa42 | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2585 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) | UI_PROP | popInstance.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b3cd1429 | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2586 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) | POPUP | popInstance.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c3591f6b | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2600 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) ▸ if (pop… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.INSTANCE_ID), pInstance) | 그리드 값 설정 |  |  |  |
| AC-d9313b35 | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2602 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) ▸ if (pop… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), pDivision) | 그리드 값 설정 |  |  |  |
| AC-0095f1e2 | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2603 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) ▸ if (pop… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), pSite) | 그리드 값 설정 |  |  |  |
| AC-3ee1a33e | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2604 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) ▸ if (pop… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), pPlant) | 그리드 값 설정 |  |  |  |
| AC-99527d7c | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2605 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) ▸ if (pop… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), pFactory) | 그리드 값 설정 |  |  |  |
| AC-9a54073a | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2606 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) ▸ if (pop… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLAN_GROUP_ID), pPlanGroup) | 그리드 값 설정 |  |  |  |
| AC-03c9b7a5 | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2607 | try ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.INSTANCE_ID)) ▸ if (pop… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SHOP_GROUP_ID), pShopGroup) | 그리드 값 설정 |  |  |  |
| AC-a3f32925 | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2616 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-bcd1c03e | this.spdMain.CellClick | FP01887_Authority_Approval.cs:2619 |  | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP01887_Authority_Approval.SpdSub_TextTipFetch

진입점: spdMain.TextTipFetch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1443aa6b | spdMain.TextTipFetch | FP01887_Authority_Approval.cs:470 | if (idx_COMPANY_ID == e.Column) | UI_PROP | e.ShowTip | true | 속성 ShowTip 설정 |  |  |  |
| AC-c53b4578 | spdMain.TextTipFetch | FP01887_Authority_Approval.cs:482 | if (idx_COMPANY_ID == e.Column) | UI_PROP | e.TipText | " " + get_company_name + " " | 속성 TipText 설정 |  |  |  |

## FP01887_DescriptionPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ebc5185 | .ctor | FP01887_DescriptionPopup.cs:45 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-b61ee52f | .ctor | FP01887_DescriptionPopup.cs:54 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-b069cddc | .ctor | FP01887_DescriptionPopup.cs:62 | if (!string.IsNullOrEmpty(title)) | VALUE_SET | this.Text | title | 컨트롤 값 설정 |  |  |  |
| AC-530a9e2d | .ctor | FP01887_DescriptionPopup.cs:63 | if (!string.IsNullOrEmpty(title)) | VALUE_SET | this.layoutCtr.Text | title | 컨트롤 값 설정 |  |  |  |

## FP01887_DescriptionPopup.BtnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1185aae | this.btnButtonList.UsrButtonList_Click_Detected | FP01887_DescriptionPopup.cs:121 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01887_DescriptionPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47d882e0 | Dispose | FP01887_DescriptionPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01887_DescriptionPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a88e71f | this.Load | FP01887_DescriptionPopup.cs:69 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01887_DescriptionPopup.GetReason

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d6f5faa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_DescriptionPopup.cs:98 | if (txtReason.Text.Length > 0) | FLAG | this.reason | this.txtReason.Text.Trim() | 화면 필드/플래그 변경 |  |  |  |
| AC-fb7443ee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_DescriptionPopup.cs:100 | if (txtReason.Text.Length > 0) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-16260bdc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_DescriptionPopup.cs:105 | else of (txtReason.Text.Length > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00181") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01887_InstancePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-beb105c8 | this.btnButtonList.UsrButtonList_Click_Detected | FP01887_InstancePopup.cs:359 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-accc18f4 | this.btnButtonList.UsrButtonList_Click_Detected | FP01887_InstancePopup.cs:362 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01887_InstancePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63d14982 | this.Load | FP01887_InstancePopup.cs:182 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1a2244d2 | this.Load | FP01887_InstancePopup.cs:183 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-03979d27 | this.Load | FP01887_InstancePopup.cs:184 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01887_InstancePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3580d699 | this.Load | FP01887_InstancePopup.cs:177 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01887_InstancePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a1b8399 | Dispose | FP01887_InstancePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01887_InstancePopup.Find_Data_Instance

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / this.Load [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5442925 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:303 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL") ⇒ FP_Master.PR_UI_FP01887_AUTHORITY_APPROVAL | 엔드포인트 요청 생성 |  |  |  |
| AC-348ea71b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:304 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-560a4603 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:305 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_INSTANCE_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-83314e67 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:306 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a1fb77a1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:307 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3acce227 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:309 | try | DATA_OP | request.Parameters["p_seq"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d516e8ee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:310 | try | DATA_OP | request.Parameters["p_new_user_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b51712a3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:311 | try | DATA_OP | request.Parameters["p_new_user_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2b604c47 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:312 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-003c0dc4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:313 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-824d7075 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:314 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2337afac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:315 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-67a27ecf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:316 | try | DATA_OP | request.Parameters["p_plan_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-565dbe56 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:317 | try | DATA_OP | request.Parameters["p_menu_authority_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7df61324 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:318 | try | DATA_OP | request.Parameters["p_release_notifiy"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dd129a79 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:319 | try | DATA_OP | request.Parameters["p_request_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5c95f3ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:320 | try | DATA_OP | request.Parameters["p_request_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ba086259 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:321 | try | DATA_OP | request.Parameters["p_start_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-034421f2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:322 | try | DATA_OP | request.Parameters["p_end_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ae9536d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:323 | try | DATA_OP | request.Parameters["p_approval_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0eeee034 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:324 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b95bb672 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:325 | try | DATA_OP | request.Parameters["p_org_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c4f54d2c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:326 | try | DATA_OP | request.Parameters["p_org_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9c426116 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:327 | try | DATA_OP | request.Parameters["p_org_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0bedab04 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:328 | try | DATA_OP | request.Parameters["p_org_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5e55b0c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:329 | try | DATA_OP | request.Parameters["p_org_plan_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6204f750 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:332 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88121383 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:334 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9a6cd12e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:340 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01887_InstancePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8425bea5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:231 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-97079d0a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:235 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e4bf1a1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:238 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-a8531454 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:238 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-319feae1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:244 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1c4f2f94 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:247 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d70001f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:253 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4c60deb1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:254 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Instance("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4946830b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:265 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-74e223b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:267 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-633f06fd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:270 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9b460190 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:273 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8a8f4d6e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:281 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-716bc99b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:283 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | iClick_Row | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-01e22b50 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:290 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5531a119 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:292 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e3f66278 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01887_InstancePopup.cs:292 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP01887_InstancePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e72e444d | this.Load | FP01887_InstancePopup.cs:152 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b80223d8 | this.Load | FP01887_InstancePopup.cs:154 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01887_InstancePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d718124f | this.Load | FP01887_InstancePopup.cs:194 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90bd1c74 | this.Load | FP01887_InstancePopup.cs:195 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01887_InstancePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f23c54f | (진입점 미연결) | FP01887_InstancePopup.cs:218 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01887_InstancePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1917801e | this.Load | FP01887_InstancePopup.cs:202 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f98aa58e | this.Load | FP01887_InstancePopup.cs:203 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e1004bad | this.Load | FP01887_InstancePopup.cs:207 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-85e6ed74 | this.Load | FP01887_InstancePopup.cs:210 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.SHOP_GROUP_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-fe16507a | this.Load | FP01887_InstancePopup.cs:211 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.ROLE_NAME), false) | 그리드 표시 설정 |  |  |  |

## FP01887_InstancePopup.SetUserInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd8e7698 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:405 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7909cd9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:406 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c32d841b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:408 |  | FLAG | _InstanceId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5268fbb0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:409 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b1c0d111 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:410 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5dbd760d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:411 |  | FLAG | _SiteId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b08125e9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:412 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f4542d8f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:413 |  | FLAG | _FactoryId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6b8c4172 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:414 |  | FLAG | _PlanGroupId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLAN_GROUP_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b9945186 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:415 |  | FLAG | _ShopGroupId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.SHOP_GROUP_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-70752fcc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01887_InstancePopup.cs:418 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01887_InstancePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4ff087b | this.spdMain.CellClick | FP01887_InstancePopup.cs:372 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8729b5f0 | this.spdMain.CellClick | FP01887_InstancePopup.cs:374 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP01887_InstancePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dc4fd57 | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:378 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-1736dfbe | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:380 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-161a03bd | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:382 |  | FLAG | _InstanceId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eb8d543f | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:383 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c984d2f0 | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:384 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d3284760 | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:385 |  | FLAG | _SiteId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ee1f75fd | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:386 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e1d65a8d | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:387 |  | FLAG | _FactoryId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-20d0005d | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:388 |  | FLAG | _PlanGroupId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLAN_GROUP_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-33e1c023 | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:389 |  | FLAG | _ShopGroupId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.SHOP_GROUP_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6f3b5bed | this.spdMain.CellDoubleClick | FP01887_InstancePopup.cs:394 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

