# AS-IS 액션 대조표 — FP01820

> 원천: `Doc/asisfacts/screens/FP01820/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 706행 · 메서드 100 · 종류 DATA_OP 155 · RETURN 104 · FLAG 95 · MESSAGE 52 · UI_PROP 42 · GRID_SET 38 · ENDPOINT 36 · VALUE_SET 29 · GRID_INIT 25 · UI_MISC 22 · GRID_LOCK 21 · CALL_EXT 20 · LIST_REBIND 17 · POPUP 16 · GRID_BIND 6 · STATE 6 · VALIDATE 6 · THROW 5 · GRID_COMBO 3 · COMBO_DATA 3 · STATE_RESET 2 · EXCEL 1 · CALL_BASE 1 · FOCUS 1 · ⚠ 의미 확인 필요 21


## clsFP01820_Search_Cond.Clear

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84a4b469 | (진입점 미연결) | FP01820_Net_Job.cs:1435 |  | FLAG | this.GROUP_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-4f1cdbf0 | (진입점 미연결) | FP01820_Net_Job.cs:1436 |  | FLAG | this.GROUP_NAME | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-f2947ad2 | (진입점 미연결) | FP01820_Net_Job.cs:1437 |  | FLAG | this.DIVISION_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job_AddPop.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75c73c9d | (진입점 미연결) | FP01820_Net_Job_AddPop.cs:770 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-a2ef1ae6 | (진입점 미연결) | FP01820_Net_Job_AddPop.cs:773 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-531c8e55 | (진입점 미연결) | FP01820_Net_Job_AddPop.cs:774 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_AddPop.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5bc1d12 | this.btnClose.Click | FP01820_Net_Job_AddPop.cs:362 |  | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ce738ee4 | this.btnClose.Click | FP01820_Net_Job_AddPop.cs:363 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_AddPop.cboValid_SelectedValueChanged

진입점: this.cboValid.SelectedValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f8ac94c | this.cboValid.SelectedValueChanged | FP01820_Net_Job_AddPop.cs:1077 |  | DATA_OP | Filter["VALID"] | cboValid.Text | 행/컬럼 값 대입 |  |  |  |

## FP01820_Net_Job_AddPop.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b9b6ef6 | this.Load | FP01820_Net_Job_AddPop.cs:255 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-10becb17 | this.Load | FP01820_Net_Job_AddPop.cs:256 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-71ce1a93 | this.Load | FP01820_Net_Job_AddPop.cs:257 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01820_Net_Job_AddPop.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91f5a38b | this.Load | FP01820_Net_Job_AddPop.cs:250 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01820_Net_Job_AddPop.DeleteData

진입점: this.btnDel.Click / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c75af9a8 | this.btnDel.Click 외 1 | FP01820_Net_Job_AddPop.cs:726 | if (!this.IsEditMode) | MESSAGE | MessageBox.Show | ("Can not add as it is not in modify mode.") | 메시지 표시 |  |  |  |
| AC-fb8a3ce7 | this.btnDel.Click 외 1 | FP01820_Net_Job_AddPop.cs:727 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-858d0c98 | this.btnDel.Click 외 1 | FP01820_Net_Job_AddPop.cs:730 | if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98d54224 | this.btnDel.Click 외 1 | FP01820_Net_Job_AddPop.cs:737 | if (strMode == "ADD") | DATA_OP | dtFindData.Rows.Remove | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-806d9aae | this.btnDel.Click 외 1 | FP01820_Net_Job_AddPop.cs:743 | else of (strMode == "ADD") ▸ if (strMode == "VIEW") ▸ if (action == CAppSetting.FlagI) | DATA_OP | dtFindData.Rows.Remove | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-c521129f | this.btnDel.Click 외 1 | FP01820_Net_Job_AddPop.cs:747 | else of (strMode == "ADD") ▸ if (strMode == "VIEW") ▸ else of (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP01820_Net_Job_AddPop.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dc2c08f | Dispose | FP01820_Net_Job_AddPop.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_AddPop.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-601afd8c | EditButton | FP01820_Net_Job_AddPop.cs:313 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7042e7a | EditButton | FP01820_Net_Job_AddPop.cs:315 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb7d9c83 | EditButton | FP01820_Net_Job_AddPop.cs:318 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b81eca5c | EditButton | FP01820_Net_Job_AddPop.cs:319 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f6a4a6f6 | EditButton | FP01820_Net_Job_AddPop.cs:322 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SUB_NO), siMain.GetColumnIndex(DefColumns.SUB_NO), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0e7ec9ba | EditButton | FP01820_Net_Job_AddPop.cs:323 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SUB_CREATE_USER_ID), siMain.GetColumnIndex(DefColumns.SU… | 그리드 편집 잠금/해제 |  |  |  |

## FP01820_Net_Job_AddPop.Find_Data_Line

진입점: this.btnFind.Click [try ▸ lambda] / this.Load [try ▸ lambda] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de5a5ee2 | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_AddPop.cs:480 | try | DATA_OP | Filter["GROUP_ID"] | argGroupID | 행/컬럼 값 대입 |  |  |  |
| AC-23a41f8d | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_AddPop.cs:481 | try | DATA_OP | Filter["DIVISION_ID"] | argDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a24c2bf4 | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_AddPop.cs:482 | try | DATA_OP | Filter["GROUP_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-603c8ae5 | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_AddPop.cs:483 | try | DATA_OP | Filter["VALID_YN"] | argValid | 행/컬럼 값 대입 |  |  |  |
| AC-49b9e8ca | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_AddPop.cs:485 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01820_Net_Job", "find_FP01820_Sub", Filter.Dictionary, "Admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] \| FP\Admin\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a45ff45c | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_AddPop.cs:486 | try | RETURN | return dsLines; |  | 처리 중단/반환 |  |  |  |
| AC-b425e80f | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_AddPop.cs:490 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job_AddPop.Find_Data_Line_except

진입점: this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Count > 0)] / this.Load [try ▸ else of (dsMain.Tables[0].Rows.Count > 0)] / FindButton [try ▸ else of (dsMain.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78311ae9 | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_AddPop.cs:497 | try | DATA_OP | Filter["GROUP_ID"] | HardCodeService.GetCodeFp("FP01820_Net_Job_AddPop", "EXCEPT_GROUP")[0] | 행/컬럼 값 대입 |  |  |  |
| AC-71b26a20 | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_AddPop.cs:497 | try | CALL_EXT | HardCodeService.GetCodeFp | ("FP01820_Net_Job_AddPop", "EXCEPT_GROUP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcf72a7b | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_AddPop.cs:498 | try | DATA_OP | Filter["DIVISION_ID"] | HardCodeService.GetCodeFp("FP01820_Net_Job_AddPop", "EXCEPT_DIVISION")[0] | 행/컬럼 값 대입 |  |  |  |
| AC-347dfcd1 | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_AddPop.cs:498 | try | CALL_EXT | HardCodeService.GetCodeFp | ("FP01820_Net_Job_AddPop", "EXCEPT_DIVISION") | ⚠ 의미 확인 필요 |  |  |  |
| AC-177061ff | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_AddPop.cs:499 | try | DATA_OP | Filter["GROUP_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-be529e55 | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_AddPop.cs:501 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01820_Net_Job", "find_FP01820_Sub", Filter.Dictionary, "Admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] \| FP\Admin\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7531f154 | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_AddPop.cs:502 | try | RETURN | return dsLines; |  | 처리 중단/반환 |  |  |  |
| AC-412ec298 | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_AddPop.cs:506 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job_AddPop.find_Master

진입점: this.btnFind.Click [try] / this.Load [try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e7e1b4c | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:515 |  | DATA_OP | Filter["JOB_LIST"] | (argGroupID=="" \|\| argGroupID==null ? "zzzzzzzzzzzz" : argGroupID) | 행/컬럼 값 대입 |  |  |  |
| AC-6a304bab | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:516 |  | DATA_OP | Filter["DIVISION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4abd0a3c | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:518 |  | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP01820_Net_Job", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1e9fa0eb | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:520 |  | FLAG | dtMaster | ret.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job_AddPop.FindData

진입점: this.btnFind.Click / this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-042f1b64 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:391 | try | FLAG | argValid | cboValid.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-a9ff42a0 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:393 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e7b4608a | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:396 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) // detail 조회 ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c0a53934 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:402 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-10d69abf | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:404 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d2d15b41 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:406 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-624a6685 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:413 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ for (i < rowcount) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.SUB_JOB_TYPE), dtJobType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-52a36433 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:428 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsExct, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-aecf9b22 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:431 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-badeb491 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:433 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsExct.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4c5a03e0 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:440 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸ for (i < rowcount) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.SUB_JOB_TYPE), dtJobType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e523a0d1 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:443 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | STATE_RESET | dtFindData.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7208369e | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:455 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-0ef0fd71 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:461 | if (_Lock) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b1b9055 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:462 | if (_Lock) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-63dfd8eb | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:463 | if (_Lock) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.SUB_NO), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e5ea87f | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:464 | if (_Lock) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SUB_CREATE_USER_ID), siMain.GetColumnIndex(DefColumns.SU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b030a558 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:466 | if (_Lock) | FLAG | _Lock | false | 화면 필드/플래그 변경 |  |  |  |
| AC-79a47e83 | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:470 | else of (_Lock) | GRID_LOCK | siMain.SetLockFlag | (siMain.SheetName.ToString(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba37253d | this.btnFind.Click 외 3 | FP01820_Net_Job_AddPop.cs:471 | else of (_Lock) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |

## FP01820_Net_Job_AddPop.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5482552e | this.Load | FP01820_Net_Job_AddPop.cs:138 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef03c79c | this.Load | FP01820_Net_Job_AddPop.cs:140 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01820_Net_Job_AddPop.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ffbb847 | this.Load | FP01820_Net_Job_AddPop.cs:157 | try ▸ if (argGroupID == "") | FLAG | strMode | "ADD" | 화면 필드/플래그 변경 |  |  |  |
| AC-5e81d34f | this.Load | FP01820_Net_Job_AddPop.cs:158 | try ▸ else of (argGroupID == "") | FLAG | strMode | "VIEW" | 화면 필드/플래그 변경 |  |  |  |
| AC-597c0d3e | this.Load | FP01820_Net_Job_AddPop.cs:161 | try | DATA_OP | dtHour.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e482efff | this.Load | FP01820_Net_Job_AddPop.cs:162 | try | DATA_OP | dtHour.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-fcf648ba | this.Load | FP01820_Net_Job_AddPop.cs:165 | try ▸ for (i < 24) | DATA_OP | dtHour.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3b6851be | this.Load | FP01820_Net_Job_AddPop.cs:166 | try ▸ for (i < 24) | CALL_EXT | (i.ToString()).PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-135773a7 | this.Load | FP01820_Net_Job_AddPop.cs:167 | try ▸ for (i < 24) | DATA_OP | row["CODE"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-d131ec5e | this.Load | FP01820_Net_Job_AddPop.cs:168 | try ▸ for (i < 24) | DATA_OP | row["NAME"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-e394313f | this.Load | FP01820_Net_Job_AddPop.cs:169 | try ▸ for (i < 24) | DATA_OP | dtHour.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-9bdfa680 | this.Load | FP01820_Net_Job_AddPop.cs:171 | try | LIST_REBIND | clsCtrl.setListBox | (dtHour, cboHourS, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-748df2da | this.Load | FP01820_Net_Job_AddPop.cs:172 | try | LIST_REBIND | clsCtrl.setListBox | (dtHour, cboHourE, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-81e65d8f | this.Load | FP01820_Net_Job_AddPop.cs:175 | try | DATA_OP | dtMin.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8165d104 | this.Load | FP01820_Net_Job_AddPop.cs:176 | try | DATA_OP | dtMin.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-d423d44c | this.Load | FP01820_Net_Job_AddPop.cs:179 | try ▸ for (i < 6) | DATA_OP | dtMin.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cbdc4b28 | this.Load | FP01820_Net_Job_AddPop.cs:180 | try ▸ for (i < 6) | CALL_EXT | ((i * 10).ToString()).PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-154b8053 | this.Load | FP01820_Net_Job_AddPop.cs:181 | try ▸ for (i < 6) | DATA_OP | row["CODE"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-507aff48 | this.Load | FP01820_Net_Job_AddPop.cs:182 | try ▸ for (i < 6) | DATA_OP | row["NAME"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-b373131e | this.Load | FP01820_Net_Job_AddPop.cs:183 | try ▸ for (i < 6) | DATA_OP | dtMin.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fd3e43e | this.Load | FP01820_Net_Job_AddPop.cs:185 | try | LIST_REBIND | clsCtrl.setListBox | (dtMin, cboMinS, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-ca1efd09 | this.Load | FP01820_Net_Job_AddPop.cs:186 | try | LIST_REBIND | clsCtrl.setListBox | (dtMin, cboMinE, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-4f316fc5 | this.Load | FP01820_Net_Job_AddPop.cs:189 | try | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-65ada841 | this.Load | FP01820_Net_Job_AddPop.cs:189 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7aaa6c95 | this.Load | FP01820_Net_Job_AddPop.cs:191 | try | DATA_OP | dtDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-af910bde | this.Load | FP01820_Net_Job_AddPop.cs:192 | try | DATA_OP | divrow["CODE"] | "999" | 행/컬럼 값 대입 |  |  |  |
| AC-39211b22 | this.Load | FP01820_Net_Job_AddPop.cs:193 | try | DATA_OP | divrow["NAME"] | "(999)SYSTEM" | 행/컬럼 값 대입 |  |  |  |
| AC-f0bcd49b | this.Load | FP01820_Net_Job_AddPop.cs:194 | try | DATA_OP | dtDivision.Rows.Add | (divrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-201d9cdc | this.Load | FP01820_Net_Job_AddPop.cs:196 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-7cce64be | this.Load | FP01820_Net_Job_AddPop.cs:200 | try | DATA_OP | column_params.Add | ("LOOKUP_TYPE_CODE", "NET_JOB_PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-a64751fa | this.Load | FP01820_Net_Job_AddPop.cs:202 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01820_Net_Job", "findLookupCode", column_params, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLookupCode] \| FP\ADMIN\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ef77da4b | this.Load | FP01820_Net_Job_AddPop.cs:203 | try | FLAG | dtPeriod | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2ef16391 | this.Load | FP01820_Net_Job_AddPop.cs:205 | try | LIST_REBIND | clsCtrl.setListBox | (dtPeriod, cboPeriod, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-1e5f10a4 | this.Load | FP01820_Net_Job_AddPop.cs:208 | try | FLAG | dtValid | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP01820_NET_JOB_EXCEPT_POP", "VALID… | 화면 필드/플래그 변경 |  |  |  |
| AC-80397396 | this.Load | FP01820_Net_Job_AddPop.cs:208 | try | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP01820_NET_JOB_EXCEPT_POP", "VALID_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c3f2157 | this.Load | FP01820_Net_Job_AddPop.cs:224 | try | LIST_REBIND | clsCtrl.setListBox | (dtValid, cboValid, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ab2319ff | this.Load | FP01820_Net_Job_AddPop.cs:227 | try | FLAG | dtJobType | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP01820_NET_JOB_EXCEPT_POP", "JOB_T… | 화면 필드/플래그 변경 |  |  |  |
| AC-83d96001 | this.Load | FP01820_Net_Job_AddPop.cs:227 | try | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP01820_NET_JOB_EXCEPT_POP", "JOB_TYPE") | ⚠ 의미 확인 필요 |  |  |  |

## FP01820_Net_Job_AddPop.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80e2b2b2 | this.Load | FP01820_Net_Job_AddPop.cs:267 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12d8129f | this.Load | FP01820_Net_Job_AddPop.cs:268 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01820_Net_Job_AddPop.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69cd4f1f | (진입점 미연결) | FP01820_Net_Job_AddPop.cs:289 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01820_Net_Job_AddPop.InsertData

진입점: this.btnAdd.Click / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aea7a2a6 | this.btnAdd.Click 외 1 | FP01820_Net_Job_AddPop.cs:691 | if (!this.IsEditMode) | MESSAGE | MessageBox.Show | ("Can not add as it is not in modify mode.") | 메시지 표시 |  |  |  |
| AC-300503ae | this.btnAdd.Click 외 1 | FP01820_Net_Job_AddPop.cs:692 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e199b341 | this.btnAdd.Click 외 1 | FP01820_Net_Job_AddPop.cs:704 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6464757a | this.btnAdd.Click 외 1 | FP01820_Net_Job_AddPop.cs:708 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.SUB_JOB_TYPE), dtJobType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-965d3a29 | this.btnAdd.Click 외 1 | FP01820_Net_Job_AddPop.cs:710 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(DefColumns.SUB_JOB_TYPE), dtJobType.getColumn(0, "CODE").ToSt… | 그리드 값 설정 |  |  |  |
| AC-6d12550d | this.btnAdd.Click 외 1 | FP01820_Net_Job_AddPop.cs:710 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | dtJobType.getColumn | (0, "CODE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-12a0fac0 | this.btnAdd.Click 외 1 | FP01820_Net_Job_AddPop.cs:711 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(DefColumns.SUB_VALID), "Y") | 그리드 값 설정 |  |  |  |
| AC-e366d0cd | this.btnAdd.Click 외 1 | FP01820_Net_Job_AddPop.cs:717 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.SUB_CREATE_USER_ID), siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |

## FP01820_Net_Job_AddPop.lfn_saveAllDetail

진입점: this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode == "VIEW") ▸ try] / SaveButton [else of (strMode == "ADD") ▸ if (strMode == "VIEW") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-052d3ef5 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:957 | else of (dtFindData.Rows.Count == 0) | DATA_OP | dtFindData.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f6ecc7a6 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:958 | else of (dtFindData.Rows.Count == 0) | DATA_OP | dtFindData.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43cc208e | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:959 | else of (dtFindData.Rows.Count == 0) | CALL_EXT | changed.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-471454fd | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:960 | else of (dtFindData.Rows.Count == 0) | CALL_EXT | removed.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-01fe5d72 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:968 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting… | DATA_OP | row["DIVISION_ID"] | clbDivision.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1bc40aed | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:969 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting… | DATA_OP | row["GROUP_ID"] | txtJobGroupID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c13ab7d1 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:971 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting… | DATA_OP | row["ORG_JOB_ID"] | row["JOB_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-62d5c9dc | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:972 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting… | DATA_OP | row["ORG_NO"] | row["NO"] | 행/컬럼 값 대입 |  |  |  |
| AC-95d8bba1 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:974 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting… | DATA_OP | changed.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d7890c91 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:975 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting… | UI_PROP | newrow.ItemArray | row.ItemArray | 속성 ItemArray 설정 |  |  |  |
| AC-a0445049 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:979 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ else of (action == CAppSetting.FlagI \|\| action == CAppSe… | DATA_OP | changed.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cf3205bc | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:980 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ else of (action == CAppSetting.FlagI \|\| action == CAppSe… | UI_PROP | newrow.ItemArray | row.ItemArray | 속성 ItemArray 설정 |  |  |  |
| AC-4198fbfe | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:984 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ else of (action == CAppSetting.FlagI \|\| action == CAppSe… | DATA_OP | removed.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9a8753c5 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:985 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ else of (action == CAppSetting.FlagI \|\| action == CAppSe… | UI_PROP | newrow.ItemArray | row.ItemArray | 속성 ItemArray 설정 |  |  |  |
| AC-74c70e6e | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:995 | else of (dtFindData.Rows.Count == 0) ▸ if (changed.Rows.Count == 0 && removed.Rows.Count == 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-03fae0b2 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:999 | else of (dtFindData.Rows.Count == 0) ▸ if (changed.Rows.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01820_Net_Job", "merge_FP01820_detail", changed, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP01820_detail] \| FP\ADMI… | 엔드포인트 호출 |  |  |  |
| AC-b102659c | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:1012 | else of (dtFindData.Rows.Count == 0) ▸ if (removed.Rows.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01820_Net_Job", "delete_FP01820_detail", removed, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_detail] \| FP\ADM… | 엔드포인트 호출 |  |  |  |
| AC-74a3405e | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:1029 | else of (dtFindData.Rows.Count == 0) ▸ else of (rtnVal) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d49cbeb3 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:1032 | else of (dtFindData.Rows.Count == 0) | RETURN | return rtnVal; |  | 처리 중단/반환 |  |  |  |
| AC-84f651b8 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:1058 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job_AddPop.lfn_saveAllMaster

진입점: this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode == "VIEW") ▸ try] / SaveButton [else of (strMode == "ADD") ▸ if (strMode == "VIEW") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d4bdce1 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:914 |  | GRID_SET | dtMaster.Rows[0]["DIVISION_ID"] | clbDivision.Text | 그리드 속성/값 설정 |  |  |  |
| AC-3aba6d46 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:915 |  | GRID_SET | dtMaster.Rows[0]["GROUP_NAME"] | txtJobName.Text | 그리드 속성/값 설정 |  |  |  |
| AC-afd99b58 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:916 |  | GRID_SET | dtMaster.Rows[0]["DESCRIPTION"] | txtJobDesc.Text | 그리드 속성/값 설정 |  |  |  |
| AC-233c1f68 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:917 |  | GRID_SET | dtMaster.Rows[0]["PERIOD"] | cboPeriod.Text | 그리드 속성/값 설정 |  |  |  |
| AC-867faeda | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:918 |  | GRID_SET | dtMaster.Rows[0]["TIME"] | txtTime.Text | 그리드 속성/값 설정 |  |  |  |
| AC-8c8e52d3 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:919 |  | GRID_SET | dtMaster.Rows[0]["VALID"] | cboValid.Text | 그리드 속성/값 설정 |  |  |  |
| AC-f87ce2b1 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:921 |  | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01820_Net_Job", "update_FP01820_master", dtMaster, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP01820_master] \| FP\ADM… | 엔드포인트 호출 |  |  |  |
| AC-8d16f6ea | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:929 | if (ret != null && ret.DataSet == null) ▸ if (ret.Rows[0][0].ToString() == "SUCCESS") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-bd9331ee | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:936 | if (ret != null && ret.DataSet == null) ▸ else of (ret.Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5ce003a | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:938 | if (ret != null && ret.DataSet == null) ▸ else of (ret.Rows[0][0].ToString() == "SUCCESS") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-56db38a9 | this.btnSave.Click [else of (strMode == "ADD") ▸ if (strMode… 외 1 | FP01820_Net_Job_AddPop.cs:942 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job_AddPop.lfn_saveDetail

진입점: this.btnSave.Click [if (strMode == "ADD") ▸ try] / SaveButton [if (strMode == "ADD") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d132c9f | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:881 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) | DATA_OP | row["DIVISION_ID"] | clbDivision.Text | 행/컬럼 값 대입 |  |  |  |
| AC-762e77dd | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:883 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) | DATA_OP | row["ORG_JOB_ID"] | row["JOB_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d94b7412 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:884 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) | DATA_OP | row["ORG_NO"] | row["NO"] | 행/컬럼 값 대입 |  |  |  |
| AC-446ebe69 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:887 | else of (dtFindData.Rows.Count == 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01820_Net_Job", "insert_FP01820_detail", dtFindData, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_FP01820_detail] \| FP\ADM… | 엔드포인트 호출 |  |  |  |
| AC-90a61a32 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:895 | else of (dtFindData.Rows.Count == 0) ▸ if (ret != null && ret.DataSet == null) ▸ if (ret.Rows[0][0].ToString() == "SUCCESS") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-6c847fad | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:902 | else of (dtFindData.Rows.Count == 0) ▸ if (ret != null && ret.DataSet == null) ▸ else of (ret.Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-24a1d3d4 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:904 | else of (dtFindData.Rows.Count == 0) ▸ if (ret != null && ret.DataSet == null) ▸ else of (ret.Rows[0][0].ToString() == "SUCCESS") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ff3bd720 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:909 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job_AddPop.lfn_saveDone

진입점: this.btnSave.Click [if (strMode == "ADD") ▸ try] / SaveButton [if (strMode == "ADD") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f66caefc | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:1063 |  | MESSAGE | MessageHelper.GMessageBox | ("저장되었습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-50b34329 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:1065 |  | UI_PROP | this.IsChange | false | 속성 IsChange 설정 |  |  |  |
| AC-0f2fce76 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:1068 |  | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-11aab4ee | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:1069 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_AddPop.lfn_saveMaster

진입점: this.btnSave.Click [if (strMode == "ADD") ▸ try] / SaveButton [if (strMode == "ADD") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e08051bd | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:840 |  | GRID_SET | dtMaster.Rows[0]["DIVISION_ID"] | clbDivision.Text | 그리드 속성/값 설정 |  |  |  |
| AC-ee33bfbe | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:841 |  | GRID_SET | dtMaster.Rows[0]["GROUP_NAME"] | txtJobName.Text | 그리드 속성/값 설정 |  |  |  |
| AC-03eede0d | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:842 |  | GRID_SET | dtMaster.Rows[0]["DESCRIPTION"] | txtJobDesc.Text | 그리드 속성/값 설정 |  |  |  |
| AC-5c426547 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:843 |  | GRID_SET | dtMaster.Rows[0]["PERIOD"] | cboPeriod.Text | 그리드 속성/값 설정 |  |  |  |
| AC-b397bceb | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:844 |  | GRID_SET | dtMaster.Rows[0]["TIME"] | txtTime.Text | 그리드 속성/값 설정 |  |  |  |
| AC-7a6a2622 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:845 |  | GRID_SET | dtMaster.Rows[0]["VALID"] | cboValid.Text | 그리드 속성/값 설정 |  |  |  |
| AC-e851b17c | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:847 |  | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01820_Net_Job", "insert_FP01820_master", dtMaster, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_FP01820_master] \| FP\ADM… | 엔드포인트 호출 |  |  |  |
| AC-48cca1ff | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:855 | if (ret != null && ret.DataSet == null) ▸ if (ret.Rows[0][0].ToString() == "SUCCESS") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-c9c16af3 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:862 | if (ret != null && ret.DataSet == null) ▸ else of (ret.Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bdf51773 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:864 | if (ret != null && ret.DataSet == null) ▸ else of (ret.Rows[0][0].ToString() == "SUCCESS") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3d41fee4 | this.btnSave.Click [if (strMode == "ADD") ▸ try] 외 1 | FP01820_Net_Job_AddPop.cs:868 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job_AddPop.saveData

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-222a9755 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:534 | if (Filter["VALID"].SafeString() == "ALL") | MESSAGE | MessageBox.Show | ("For Master, you need select Valid \"Y\" or \"N\"") | 메시지 표시 |  |  |  |
| AC-3dc1a541 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:535 | if (Filter["VALID"].SafeString() == "ALL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-41e33c2e | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:540 | if (string.IsNullOrEmpty(txtJobName.Text)) | MESSAGE | MessageBox.Show | ("Job Name 을 입력하시오.") | 메시지 표시 |  |  |  |
| AC-bb22b4eb | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:541 | if (string.IsNullOrEmpty(txtJobName.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2dd7156 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:546 | if (string.IsNullOrEmpty(txtTime.Text)) | MESSAGE | MessageBox.Show | ("Time 을 입력하시오.") | 메시지 표시 |  |  |  |
| AC-3989a0bf | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:547 | if (string.IsNullOrEmpty(txtTime.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3826c313 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:555 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) | DATA_OP | dtFindData.getColumn | (i, "NO") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c88b753c | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:556 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) | DATA_OP | dtFindData.getColumn | (i, "SEQ") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7e7a5e0e | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:557 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) | DATA_OP | dtFindData.getColumn | (i, "JOB_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-15992e3b | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:558 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) | DATA_OP | dtFindData.getColumn | (i, "JOB_DESC") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-577c1938 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:564 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (i < dtFindData.Rows.Count - 1) ▸ for (j < dtFindData.Rows.Count) | DATA_OP | dtFindData.getColumn | (j, "JOB_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4134abf1 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:566 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (i < dtFindData.Rows.Count - 1) ▸ for (j < dtFindData.Rows.Count) ▸ if… | MESSAGE | MessageBox.Show | ("There are Duplicated Datas.") | 메시지 표시 |  |  |  |
| AC-67d9e453 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:567 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (i < dtFindData.Rows.Count - 1) ▸ for (j < dtFindData.Rows.Count) ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23b615a6 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:574 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (string.IsNullOrEmpty(sNo)) | MESSAGE | MessageBox.Show | ("No. 을 입력하시오.") | 메시지 표시 |  |  |  |
| AC-d2bc8650 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:575 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (string.IsNullOrEmpty(sNo)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3eeac73 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:580 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (string.IsNullOrEmpty(sSeq)) | MESSAGE | MessageBox.Show | ("Job Seq 을 입력하시오.") | 메시지 표시 |  |  |  |
| AC-3d13cb8d | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:581 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (string.IsNullOrEmpty(sSeq)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ef9ea3c | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:586 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (string.IsNullOrEmpty(sSubJobName)) | MESSAGE | MessageBox.Show | ("Sub Job Name 을 입력하시오.") | 메시지 표시 |  |  |  |
| AC-56536d13 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:587 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (string.IsNullOrEmpty(sSubJobName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aff87f52 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:592 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (string.IsNullOrEmpty(sJob)) | MESSAGE | MessageBox.Show | ("Procedure Name 을 입력하시오.") | 메시지 표시 |  |  |  |
| AC-36bdbe61 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:593 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (string.IsNullOrEmpty(sJob)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8603bd0e | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:599 | else of (dtFindData.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Sub Job 을 입력하시오.") | 메시지 표시 |  |  |  |
| AC-856c1ae6 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:600 | else of (dtFindData.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f423fa9d | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:603 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7061953 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:604 | if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ae2419b | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:621 | if (dtMaster.Rows.Count == 0) | DATA_OP | dtMaster.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d4b65e15 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:623 |  | GRID_SET | dtMaster.Rows[0]["START_DATE"] | strTime | 그리드 속성/값 설정 |  |  |  |
| AC-1c92d13a | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:624 |  | GRID_SET | dtMaster.Rows[0]["END_DATE"] | strEnd | 그리드 속성/값 설정 |  |  |  |
| AC-fe025ae5 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:636 | if (strMode == "ADD") ▸ try | DATA_OP | column_params.Add | ("DIVISION_ID", clbDivision.Text) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ebfbf6e | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:637 | if (strMode == "ADD") ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01820_Net_Job", "find_GroupId", column_params, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_GroupId] \| FP\ADMIN\FP018… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-36c7cffe | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:640 | if (strMode == "ADD") ▸ try | GRID_SET | dtMaster.Rows[0]["GROUP_ID"] | newGroup | 그리드 속성/값 설정 |  |  |  |
| AC-1dfc0d3b | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:643 | if (strMode == "ADD") ▸ try ▸ foreach (DataRow row in dtFindData.Rows) | DATA_OP | row["GROUP_ID"] | newGroup | 행/컬럼 값 대입 |  |  |  |
| AC-2fbcc1f5 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:648 | if (strMode == "ADD") ▸ try ▸ if (!bRtn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a2f09f63 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:652 | if (strMode == "ADD") ▸ try ▸ if (!bRtn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e650e05 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:658 | if (strMode == "ADD") ▸ catch ((Exception ee)) | MESSAGE | MessageHelper.GMessageBox | (ee.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1448347a | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:670 | else of (strMode == "ADD") ▸ if (strMode == "VIEW") ▸ try ▸ if (!bRtn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fdd6233f | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:674 | else of (strMode == "ADD") ▸ if (strMode == "VIEW") ▸ try ▸ if (!bRtn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9da1e93 | this.btnSave.Click 외 1 | FP01820_Net_Job_AddPop.cs:680 | else of (strMode == "ADD") ▸ if (strMode == "VIEW") ▸ catch ((Exception ee)) | MESSAGE | MessageHelper.GMessageBox | (ee.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01820_Net_Job_AddPop.set_AftereFind

진입점: this.btnFind.Click [try] / this.Load [try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55c14510 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:805 |  | STATE | txtJobGroupID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1e1d0d09 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:810 | if (strMode == "VIEW") | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-88a0ab6b | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:813 | if (strMode == "VIEW") | VALUE_SET | clbDivision.Text | dtMaster.Rows[0]["DIVISION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a51aa2e6 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:814 | if (strMode == "VIEW") | VALUE_SET | txtJobGroupID.Text | dtMaster.Rows[0]["GROUP_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-de667db5 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:815 | if (strMode == "VIEW") | VALUE_SET | txtJobName.Text | dtMaster.Rows[0]["GROUP_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a09e277d | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:816 | if (strMode == "VIEW") | VALUE_SET | txtJobDesc.Text | dtMaster.Rows[0]["DESCRIPTION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9e5ed7b4 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:818 | if (strMode == "VIEW") | VALUE_SET | dpStartRunTime.Value | DateTime.ParseExact(dtMaster.Rows[0]["START_YMD"].ToString(), "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-bf3af74c | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:819 | if (strMode == "VIEW") | VALUE_SET | cboHourS.Text | dtMaster.Rows[0]["START_HOUR"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ae720d9d | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:820 | if (strMode == "VIEW") | VALUE_SET | cboMinS.Text | dtMaster.Rows[0]["START_MIN"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-e12524d5 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:821 | if (strMode == "VIEW") | VALUE_SET | dpEndRunTime.Value | DateTime.ParseExact(dtMaster.Rows[0]["END_YMD"].ToString(), "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-f2e6eca6 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:822 | if (strMode == "VIEW") | VALUE_SET | cboHourE.Text | dtMaster.Rows[0]["END_HOUR"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-83794360 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:823 | if (strMode == "VIEW") | VALUE_SET | cboMinE.Text | dtMaster.Rows[0]["END_MIN"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bd6f102e | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:825 | if (strMode == "VIEW") | VALUE_SET | cboPeriod.Text | dtMaster.Rows[0]["PERIOD"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-29080f81 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:826 | if (strMode == "VIEW") | VALUE_SET | txtTime.Text | dtMaster.Rows[0]["TIME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-29dd03a4 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:828 | if (strMode == "VIEW") ▸ if (cboValid.Text == "") | VALUE_SET | cboValid.Text | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-cc1cf1e1 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:832 | else of (strMode == "VIEW") | VALUE_SET | dpStartRunTime.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-e207bb8a | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_AddPop.cs:833 | else of (strMode == "VIEW") | VALUE_SET | dpEndRunTime.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |

## FP01820_Net_Job_AddPop.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfe338f6 | this.Load | FP01820_Net_Job_AddPop.cs:274 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48610219 | this.Load | FP01820_Net_Job_AddPop.cs:275 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-b9a3f822 | this.Load | FP01820_Net_Job_AddPop.cs:279 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01820_Net_Job_AddPop.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-002d9541 | this.spdMain.CellClick | FP01820_Net_Job_AddPop.cs:785 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d01379be | this.spdMain.CellClick | FP01820_Net_Job_AddPop.cs:786 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-afdb2c93 | this.spdMain.CellClick | FP01820_Net_Job_AddPop.cs:789 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job_DatePop..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b33894a6 | .ctor | FP01820_Net_Job_DatePop.cs:75 |  | FLAG | this._START_YMD | filterDs["START_YMD"] | 화면 필드/플래그 변경 |  |  |  |
| AC-a82cd25e | .ctor | FP01820_Net_Job_DatePop.cs:76 |  | FLAG | this._END_YMD | filterDs["END_YMD"] | 화면 필드/플래그 변경 |  |  |  |
| AC-f26ace5b | .ctor | FP01820_Net_Job_DatePop.cs:77 |  | FLAG | this._START_HOUR | filterDs["START_HOUR"] | 화면 필드/플래그 변경 |  |  |  |
| AC-7212de2c | .ctor | FP01820_Net_Job_DatePop.cs:78 |  | FLAG | this._END_HOUR | filterDs["END_HOUR"] | 화면 필드/플래그 변경 |  |  |  |
| AC-54de03fa | .ctor | FP01820_Net_Job_DatePop.cs:79 |  | FLAG | this._START_MIN | filterDs["START_MIN"] | 화면 필드/플래그 변경 |  |  |  |
| AC-c8a31a43 | .ctor | FP01820_Net_Job_DatePop.cs:80 |  | FLAG | this._END_MIN | filterDs["END_MIN"] | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job_DatePop.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd739c46 | this.btnClose.Click | FP01820_Net_Job_DatePop.cs:173 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_DatePop.btnSql_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-311edbfd | (진입점 미연결) | FP01820_Net_Job_DatePop.cs:179 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d8a78169 | (진입점 미연결) | FP01820_Net_Job_DatePop.cs:180 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-79183790 | (진입점 미연결) | FP01820_Net_Job_DatePop.cs:183 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01820_Net_Job_DatePop.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b3ccddf | this.Load | FP01820_Net_Job_DatePop.cs:159 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01820_Net_Job_DatePop.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31842fa7 | Dispose | FP01820_Net_Job_DatePop.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_DatePop.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-127a7c7c | this.Load | FP01820_Net_Job_DatePop.cs:90 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-63f25255 | this.Load | FP01820_Net_Job_DatePop.cs:92 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01820_Net_Job_DatePop.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce125589 | this.Load | FP01820_Net_Job_DatePop.cs:105 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf4f3c22 | this.Load | FP01820_Net_Job_DatePop.cs:108 |  | DATA_OP | dtHour.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e60aa2d | this.Load | FP01820_Net_Job_DatePop.cs:109 |  | DATA_OP | dtHour.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a702040 | this.Load | FP01820_Net_Job_DatePop.cs:112 | for (i < 24) | DATA_OP | dtHour.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b56bb647 | this.Load | FP01820_Net_Job_DatePop.cs:113 | for (i < 24) | CALL_EXT | (i.ToString()).PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-e166038e | this.Load | FP01820_Net_Job_DatePop.cs:114 | for (i < 24) | DATA_OP | row["CODE"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-0e416698 | this.Load | FP01820_Net_Job_DatePop.cs:115 | for (i < 24) | DATA_OP | row["NAME"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-56b36dd2 | this.Load | FP01820_Net_Job_DatePop.cs:116 | for (i < 24) | DATA_OP | dtHour.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a3f90fa | this.Load | FP01820_Net_Job_DatePop.cs:118 |  | LIST_REBIND | clsCtrl.setListBox | (dtHour, cboHourS, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-f5077c55 | this.Load | FP01820_Net_Job_DatePop.cs:119 |  | LIST_REBIND | clsCtrl.setListBox | (dtHour, cboHourE, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-ba42ed42 | this.Load | FP01820_Net_Job_DatePop.cs:122 |  | DATA_OP | dtMin.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d86055ac | this.Load | FP01820_Net_Job_DatePop.cs:123 |  | DATA_OP | dtMin.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-6402d468 | this.Load | FP01820_Net_Job_DatePop.cs:126 | for (i < 6) | DATA_OP | dtMin.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c21a5ecc | this.Load | FP01820_Net_Job_DatePop.cs:127 | for (i < 6) | CALL_EXT | ((i * 10).ToString()).PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-15a91fec | this.Load | FP01820_Net_Job_DatePop.cs:128 | for (i < 6) | DATA_OP | row["CODE"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-dab361f7 | this.Load | FP01820_Net_Job_DatePop.cs:129 | for (i < 6) | DATA_OP | row["NAME"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-5eea5c36 | this.Load | FP01820_Net_Job_DatePop.cs:130 | for (i < 6) | DATA_OP | dtMin.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ab62852 | this.Load | FP01820_Net_Job_DatePop.cs:132 |  | LIST_REBIND | clsCtrl.setListBox | (dtMin, cboMinS, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-c3e04bc3 | this.Load | FP01820_Net_Job_DatePop.cs:133 |  | LIST_REBIND | clsCtrl.setListBox | (dtMin, cboMinE, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-e308a216 | this.Load | FP01820_Net_Job_DatePop.cs:137 |  | UI_PROP | dateRange.Value1 | DateTime.Today.AddDays(1) | 속성 Value1 설정 |  |  |  |
| AC-842c9229 | this.Load | FP01820_Net_Job_DatePop.cs:138 |  | UI_PROP | dateRange.Value2 | DateTime.Today.AddDays(2) | 속성 Value2 설정 |  |  |  |
| AC-c6441367 | this.Load | FP01820_Net_Job_DatePop.cs:142 | try ▸ if (!string.IsNullOrEmpty( _START_YMD )) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(_START_YMD, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-98fa3bbf | this.Load | FP01820_Net_Job_DatePop.cs:143 | try ▸ if (!string.IsNullOrEmpty( _END_YMD )) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(_END_YMD, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-6c373a70 | this.Load | FP01820_Net_Job_DatePop.cs:145 | try ▸ if (!string.IsNullOrEmpty(_START_HOUR)) | VALUE_SET | cboHourS.Text | _START_HOUR | 컨트롤 값 설정 |  |  |  |
| AC-458d2475 | this.Load | FP01820_Net_Job_DatePop.cs:146 | try ▸ if (!string.IsNullOrEmpty(_END_HOUR)) | VALUE_SET | cboHourE.Text | _END_HOUR | 컨트롤 값 설정 |  |  |  |
| AC-fd948ed3 | this.Load | FP01820_Net_Job_DatePop.cs:148 | try ▸ if (!string.IsNullOrEmpty(_START_MIN)) | VALUE_SET | cboMinS.Text | _START_MIN | 컨트롤 값 설정 |  |  |  |
| AC-5fc9148f | this.Load | FP01820_Net_Job_DatePop.cs:149 | try ▸ if (!string.IsNullOrEmpty(_END_MIN)) | VALUE_SET | cboMinE.Text | _END_MIN | 컨트롤 값 설정 |  |  |  |

## FP01820_Net_Job_DatePop.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6db5d3da | popSql.OnSql | FP01820_Net_Job_DatePop.cs:260 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job_DatePop.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5202270f | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:197 | if (dateRange.Value1 < DateTime.Today) | MESSAGE | MessageHelper.GMessageBox | ("현재 이후 날짜만 선택 가능합니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-52c97a6c | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:198 | if (dateRange.Value1 < DateTime.Today) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e07566ee | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:207 | try | DATA_OP | FilterTmp["START_DATE"] | startDate | 행/컬럼 값 대입 |  |  |  |
| AC-6739b3cc | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:209 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01820_Net_Job", "find_FP01820_timechk", FilterTmp.Dictionary, "Admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_timechk] \| FP\Adm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-58bb37e2 | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:214 | try ▸ if (dsTmp.Tables[0].Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("현재 이후 날짜만 선택 가능합니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-724833e4 | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:215 | try ▸ if (dsTmp.Tables[0].Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8e830d1 | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:222 |  | FLAG | _START_DATE | startDate | 화면 필드/플래그 변경 |  |  |  |
| AC-c09eea82 | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:223 |  | FLAG | _END_DATE | endDate | 화면 필드/플래그 변경 |  |  |  |
| AC-1285fd3f | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:224 |  | FLAG | _START_YMD | stDate | 화면 필드/플래그 변경 |  |  |  |
| AC-239e2c5f | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:225 |  | FLAG | _END_YMD | edDate | 화면 필드/플래그 변경 |  |  |  |
| AC-7f92bc26 | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:226 |  | FLAG | _START_HOUR | cboHourS.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-ec1e7d38 | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:227 |  | FLAG | _END_HOUR | cboHourE.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-6ce12734 | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:228 |  | FLAG | _START_MIN | cboMinS.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-cbf253ae | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:229 |  | FLAG | _END_MIN | cboMinE.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-9f432d74 | this.btnSave.Click | FP01820_Net_Job_DatePop.cs:232 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_ExceptPop.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aea4079d | (진입점 미연결) | FP01820_Net_Job_ExceptPop.cs:647 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-1b1b3847 | (진입점 미연결) | FP01820_Net_Job_ExceptPop.cs:650 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-33266963 | (진입점 미연결) | FP01820_Net_Job_ExceptPop.cs:651 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_ExceptPop.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1e766eb | this.btnClose.Click | FP01820_Net_Job_ExceptPop.cs:357 |  | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-12605a2e | this.btnClose.Click | FP01820_Net_Job_ExceptPop.cs:358 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_ExceptPop.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57a1ca50 | this.Load | FP01820_Net_Job_ExceptPop.cs:246 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a97849bf | this.Load | FP01820_Net_Job_ExceptPop.cs:247 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bbceb91e | this.Load | FP01820_Net_Job_ExceptPop.cs:248 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d95573ec | this.Load | FP01820_Net_Job_ExceptPop.cs:253 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-41119306 | this.Load | FP01820_Net_Job_ExceptPop.cs:255 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f2a1bff | this.Load | FP01820_Net_Job_ExceptPop.cs:256 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-ab893b5e | this.Load | FP01820_Net_Job_ExceptPop.cs:257 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP01820_Net_Job_ExceptPop.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb9b3c70 | this.Load | FP01820_Net_Job_ExceptPop.cs:241 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01820_Net_Job_ExceptPop.DeleteData

진입점: this.btnDel.Click / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a61e41b | this.btnDel.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:611 | if (!this.IsEditMode) | MESSAGE | MessageBox.Show | ("Can not add as it is not in modify mode.") | 메시지 표시 |  |  |  |
| AC-86babe0d | this.btnDel.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:612 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd21243e | this.btnDel.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:615 | if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f141707 | this.btnDel.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:622 | if (action == CAppSetting.FlagI) | DATA_OP | dtFindData.Rows.Remove | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-a75d4594 | this.btnDel.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:626 | else of (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP01820_Net_Job_ExceptPop.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4ebce8e | Dispose | FP01820_Net_Job_ExceptPop.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_ExceptPop.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89ecfdd5 | EditButton | FP01820_Net_Job_ExceptPop.cs:311 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3253401 | EditButton | FP01820_Net_Job_ExceptPop.cs:314 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b5cbac3c | EditButton | FP01820_Net_Job_ExceptPop.cs:315 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8176cc11 | EditButton | FP01820_Net_Job_ExceptPop.cs:317 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SUB_NO), siMain.GetColumnIndex(DefColumns.SUB_END_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-78cac619 | EditButton | FP01820_Net_Job_ExceptPop.cs:318 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SUB_CREATE_USER_ID), siMain.GetColumnIndex(DefColumns.SU… | 그리드 편집 잠금/해제 |  |  |  |

## FP01820_Net_Job_ExceptPop.Find_Data_Line

진입점: this.btnFind.Click [try ▸ lambda] / this.Load [try ▸ lambda] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39e42bd8 | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_ExceptPop.cs:460 | try | DATA_OP | Filter["GROUP_ID"] | argGroupID | 행/컬럼 값 대입 |  |  |  |
| AC-4575b926 | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_ExceptPop.cs:461 | try | DATA_OP | Filter["DIVISION_ID"] | argDivision | 행/컬럼 값 대입 |  |  |  |
| AC-96ea87f4 | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_ExceptPop.cs:463 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01820_Net_Job", "find_FP01820_except", Filter.Dictionary, "Admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_except] \| FP\Admi… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e288d75f | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_ExceptPop.cs:464 | try | RETURN | return dsLines; |  | 처리 중단/반환 |  |  |  |
| AC-42e456e7 | this.btnFind.Click [try ▸ lambda] 외 3 | FP01820_Net_Job_ExceptPop.cs:468 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job_ExceptPop.Find_Data_Line_except

진입점: this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Count > 0)] / this.Load [try ▸ else of (dsMain.Tables[0].Rows.Count > 0)] / FindButton [try ▸ else of (dsMain.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5d5eab0 | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_ExceptPop.cs:475 | try | DATA_OP | Filter["GROUP_ID"] | HardCodeService.GetCodeFp("FP01820_Net_Job_AddPop", "EXCEPT_GROUP")[0] | 행/컬럼 값 대입 |  |  |  |
| AC-c638d52f | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_ExceptPop.cs:475 | try | CALL_EXT | HardCodeService.GetCodeFp | ("FP01820_Net_Job_AddPop", "EXCEPT_GROUP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e5774fc | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_ExceptPop.cs:476 | try | DATA_OP | Filter["DIVISION_ID"] | HardCodeService.GetCodeFp("FP01820_Net_Job_AddPop", "EXCEPT_DIVISION")[0] | 행/컬럼 값 대입 |  |  |  |
| AC-1c5d8fdb | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_ExceptPop.cs:476 | try | CALL_EXT | HardCodeService.GetCodeFp | ("FP01820_Net_Job_AddPop", "EXCEPT_DIVISION") | ⚠ 의미 확인 필요 |  |  |  |
| AC-defaec59 | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_ExceptPop.cs:478 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01820_Net_Job", "find_FP01820_except", Filter.Dictionary, "Admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_except] \| FP\Admi… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c61a1c7e | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_ExceptPop.cs:479 | try | RETURN | return dsLines; |  | 처리 중단/반환 |  |  |  |
| AC-7b78ecf3 | this.btnFind.Click [try ▸ else of (dsMain.Tables[0].Rows.Cou… 외 3 | FP01820_Net_Job_ExceptPop.cs:483 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job_ExceptPop.find_Master

진입점: this.btnFind.Click [try] / this.Load [try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffaf0bd9 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:492 |  | DATA_OP | Filter["JOB_LIST"] | (argGroupID=="" \|\| argGroupID==null ? "zzzzzzzzzzzz" : argGroupID) | 행/컬럼 값 대입 |  |  |  |
| AC-63ab3a9b | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:493 |  | DATA_OP | Filter["DIVISION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f3b7be9 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:495 |  | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP01820_Net_Job", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d756ac2d | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:497 |  | FLAG | dtMaster | ret.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job_ExceptPop.FindData

진입점: this.btnFind.Click / this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a93fec11 | this.btnFind.Click 외 3 | FP01820_Net_Job_ExceptPop.cs:384 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4d5daee5 | this.btnFind.Click 외 3 | FP01820_Net_Job_ExceptPop.cs:388 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) // detail 조회 ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-44c9a011 | this.btnFind.Click 외 3 | FP01820_Net_Job_ExceptPop.cs:394 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a10fae97 | this.btnFind.Click 외 3 | FP01820_Net_Job_ExceptPop.cs:397 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a69cab05 | this.btnFind.Click 외 3 | FP01820_Net_Job_ExceptPop.cs:399 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-c799587e | this.btnFind.Click 외 3 | FP01820_Net_Job_ExceptPop.cs:423 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsExct, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a93f134c | this.btnFind.Click 외 3 | FP01820_Net_Job_ExceptPop.cs:426 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-194b7542 | this.btnFind.Click 외 3 | FP01820_Net_Job_ExceptPop.cs:428 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsExct.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-e576c270 | this.btnFind.Click 외 3 | FP01820_Net_Job_ExceptPop.cs:440 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | STATE_RESET | dtFindData.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7899efef | this.btnFind.Click 외 3 | FP01820_Net_Job_ExceptPop.cs:452 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP01820_Net_Job_ExceptPop.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-452b1556 | this.Load | FP01820_Net_Job_ExceptPop.cs:132 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f46e9b9 | this.Load | FP01820_Net_Job_ExceptPop.cs:134 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01820_Net_Job_ExceptPop.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76e0248d | this.Load | FP01820_Net_Job_ExceptPop.cs:153 | try | DATA_OP | dtHour.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b7ca4b3 | this.Load | FP01820_Net_Job_ExceptPop.cs:154 | try | DATA_OP | dtHour.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-62615eaa | this.Load | FP01820_Net_Job_ExceptPop.cs:157 | try ▸ for (i < 24) | DATA_OP | dtHour.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f81629ba | this.Load | FP01820_Net_Job_ExceptPop.cs:158 | try ▸ for (i < 24) | CALL_EXT | (i.ToString()).PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-77588874 | this.Load | FP01820_Net_Job_ExceptPop.cs:159 | try ▸ for (i < 24) | DATA_OP | row["CODE"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-dc983d2b | this.Load | FP01820_Net_Job_ExceptPop.cs:160 | try ▸ for (i < 24) | DATA_OP | row["NAME"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-6b66b08d | this.Load | FP01820_Net_Job_ExceptPop.cs:161 | try ▸ for (i < 24) | DATA_OP | dtHour.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc0cb8d0 | this.Load | FP01820_Net_Job_ExceptPop.cs:167 | try | DATA_OP | dtMin.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e59fe1c8 | this.Load | FP01820_Net_Job_ExceptPop.cs:168 | try | DATA_OP | dtMin.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f7b5c21 | this.Load | FP01820_Net_Job_ExceptPop.cs:171 | try ▸ for (i < 6) | DATA_OP | dtMin.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-81cadb6d | this.Load | FP01820_Net_Job_ExceptPop.cs:172 | try ▸ for (i < 6) | CALL_EXT | ((i * 10).ToString()).PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-1568a5ae | this.Load | FP01820_Net_Job_ExceptPop.cs:173 | try ▸ for (i < 6) | DATA_OP | row["CODE"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-f4c9fd8d | this.Load | FP01820_Net_Job_ExceptPop.cs:174 | try ▸ for (i < 6) | DATA_OP | row["NAME"] | tochar | 행/컬럼 값 대입 |  |  |  |
| AC-3d098c40 | this.Load | FP01820_Net_Job_ExceptPop.cs:175 | try ▸ for (i < 6) | DATA_OP | dtMin.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-d204847e | this.Load | FP01820_Net_Job_ExceptPop.cs:181 | try | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-06d6dad3 | this.Load | FP01820_Net_Job_ExceptPop.cs:181 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-584c4307 | this.Load | FP01820_Net_Job_ExceptPop.cs:183 | try | DATA_OP | dtDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0c12b960 | this.Load | FP01820_Net_Job_ExceptPop.cs:184 | try | DATA_OP | divrow["CODE"] | "999" | 행/컬럼 값 대입 |  |  |  |
| AC-1287a540 | this.Load | FP01820_Net_Job_ExceptPop.cs:185 | try | DATA_OP | divrow["NAME"] | "(999)SYSTEM" | 행/컬럼 값 대입 |  |  |  |
| AC-6171ef23 | this.Load | FP01820_Net_Job_ExceptPop.cs:186 | try | DATA_OP | dtDivision.Rows.Add | (divrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0e2d18f | this.Load | FP01820_Net_Job_ExceptPop.cs:188 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-2411ce01 | this.Load | FP01820_Net_Job_ExceptPop.cs:192 | try | DATA_OP | column_params.Add | ("LOOKUP_TYPE_CODE", "NET_JOB_PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-92bdcd99 | this.Load | FP01820_Net_Job_ExceptPop.cs:194 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01820_Net_Job", "findLookupCode", column_params, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLookupCode] \| FP\ADMIN\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a7631055 | this.Load | FP01820_Net_Job_ExceptPop.cs:195 | try | FLAG | dtPeriod | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-04e7491a | this.Load | FP01820_Net_Job_ExceptPop.cs:197 | try | LIST_REBIND | clsCtrl.setListBox | (dtPeriod, cboPeriod, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-3d3d1ad8 | this.Load | FP01820_Net_Job_ExceptPop.cs:200 | try | FLAG | dtValid | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP01820_NET_JOB_EXCEPT_POP", "VALID… | 화면 필드/플래그 변경 |  |  |  |
| AC-3e4b9146 | this.Load | FP01820_Net_Job_ExceptPop.cs:200 | try | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP01820_NET_JOB_EXCEPT_POP", "VALID_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d81f2957 | this.Load | FP01820_Net_Job_ExceptPop.cs:215 | try | LIST_REBIND | clsCtrl.setListBox | (dtValid, cboValid, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-060e6fb9 | this.Load | FP01820_Net_Job_ExceptPop.cs:218 | try | FLAG | dtJobType | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP01820_NET_JOB_EXCEPT_POP", "JOB_T… | 화면 필드/플래그 변경 |  |  |  |
| AC-988b28e2 | this.Load | FP01820_Net_Job_ExceptPop.cs:218 | try | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP01820_NET_JOB_EXCEPT_POP", "JOB_TYPE") | ⚠ 의미 확인 필요 |  |  |  |

## FP01820_Net_Job_ExceptPop.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12843ff7 | this.Load | FP01820_Net_Job_ExceptPop.cs:265 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63af190c | this.Load | FP01820_Net_Job_ExceptPop.cs:266 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01820_Net_Job_ExceptPop.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b10e8e0 | (진입점 미연결) | FP01820_Net_Job_ExceptPop.cs:287 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01820_Net_Job_ExceptPop.InsertData

진입점: this.btnAdd.Click / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abbb8252 | this.btnAdd.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:574 | if (!this.IsEditMode) | MESSAGE | MessageBox.Show | ("Can not add as it is not in modify mode.") | 메시지 표시 |  |  |  |
| AC-6a2b70dc | this.btnAdd.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:575 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-644bd1d3 | this.btnAdd.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:582 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d17ab0ec | this.btnAdd.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:593 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | newRow["VALID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-04f60485 | this.btnAdd.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:594 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | newRow["VIEW_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-dfd84dbc | this.btnAdd.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:595 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | newRow["DIVISION_ID"] | clbDivision.Text | 행/컬럼 값 대입 |  |  |  |
| AC-57a37de1 | this.btnAdd.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:596 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | newRow["GROUP_ID"] | txtJobGroupID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-623f0b37 | this.btnAdd.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:598 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SUB_START_DATE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-857f2171 | this.btnAdd.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:601 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.SUB_NO), siMain.GetColumnIndex(DefColumns.SUB_N… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5deeaf72 | this.btnAdd.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:602 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.SUB_CREATE_USER_ID), siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |

## FP01820_Net_Job_ExceptPop.lfn_saveAllDetail

진입점: this.btnSave.Click [try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f959edf4 | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:746 | else of (dtFindData.Rows.Count == 0) | DATA_OP | dtFindData.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-edb283b7 | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:747 | else of (dtFindData.Rows.Count == 0) | DATA_OP | dtFindData.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3d3331ea | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:748 | else of (dtFindData.Rows.Count == 0) | CALL_EXT | changed.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2695b2e3 | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:749 | else of (dtFindData.Rows.Count == 0) | CALL_EXT | removed.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1374ee3b | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:763 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting… | DATA_OP | changed.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fb9c5501 | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:764 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting… | UI_PROP | newrow.ItemArray | row.ItemArray | 속성 ItemArray 설정 |  |  |  |
| AC-9bcbc19b | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:768 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ else of (action == CAppSetting.FlagI \|\| action == CAppSe… | DATA_OP | changed.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-efb015c8 | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:769 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ else of (action == CAppSetting.FlagI \|\| action == CAppSe… | UI_PROP | newrow.ItemArray | row.ItemArray | 속성 ItemArray 설정 |  |  |  |
| AC-3e29ee7f | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:773 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ else of (action == CAppSetting.FlagI \|\| action == CAppSe… | DATA_OP | removed.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4a52e39e | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:774 | else of (dtFindData.Rows.Count == 0) ▸ foreach (DataRow row in dtFindData.Rows) ▸ else of (action == CAppSetting.FlagI \|\| action == CAppSe… | UI_PROP | newrow.ItemArray | row.ItemArray | 속성 ItemArray 설정 |  |  |  |
| AC-9f3a9c7b | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:784 | else of (dtFindData.Rows.Count == 0) ▸ if (changed.Rows.Count == 0 && removed.Rows.Count == 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b44e0e5c | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:788 | else of (dtFindData.Rows.Count == 0) ▸ if (changed.Rows.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01820_Net_Job", "merge_FP01820_except", changed, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP01820_except] \| FP\ADMI… | 엔드포인트 호출 |  |  |  |
| AC-a55bbd70 | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:801 | else of (dtFindData.Rows.Count == 0) ▸ if (removed.Rows.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01820_Net_Job", "delete_FP01820_except", removed, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_except] \| FP\ADM… | 엔드포인트 호출 |  |  |  |
| AC-4539e5f5 | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:818 | else of (dtFindData.Rows.Count == 0) ▸ else of (rtnVal) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d585cb3f | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:821 | else of (dtFindData.Rows.Count == 0) | RETURN | return rtnVal; |  | 처리 중단/반환 |  |  |  |
| AC-0ef34ebf | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:824 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job_ExceptPop.lfn_saveDone

진입점: this.btnSave.Click [try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fe76bd0 | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:829 |  | MESSAGE | MessageHelper.GMessageBox | ("저장되었습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d0447078 | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:831 |  | UI_PROP | this.IsChange | false | 속성 IsChange 설정 |  |  |  |
| AC-ebbc22f0 | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:834 |  | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7df2a9fc | this.btnSave.Click [try] 외 1 | FP01820_Net_Job_ExceptPop.cs:835 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job_ExceptPop.saveData

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-becf7f86 | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:505 | if (!this.IsEditMode) | MESSAGE | MessageBox.Show | ("Can not add as it is not in modify mode.") | 메시지 표시 |  |  |  |
| AC-51e67d87 | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:506 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26d38c64 | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:521 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) | DATA_OP | dtFindData.getColumn | (i, "START_DATE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-49a1d616 | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:527 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (i < dtFindData.Rows.Count - 1) ▸ for (j < dtFindData.Rows.Count) | DATA_OP | dtFindData.getColumn | (j, "START_DATE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f3c39a72 | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:529 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (i < dtFindData.Rows.Count - 1) ▸ for (j < dtFindData.Rows.Count) ▸ if… | MESSAGE | MessageBox.Show | ("중첩된 Start Date 가 존재합니다.") | 메시지 표시 |  |  |  |
| AC-90ae268f | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:530 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (i < dtFindData.Rows.Count - 1) ▸ for (j < dtFindData.Rows.Count) ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fdb8391e | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:537 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (string.IsNullOrEmpty(sStart)) | MESSAGE | MessageBox.Show | ("Start Date 를 입력하시오.") | 메시지 표시 |  |  |  |
| AC-b49ec53e | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:538 | if (dtFindData.Rows.Count > 0) ▸ for (i < dtFindData.Rows.Count) ▸ if (string.IsNullOrEmpty(sStart)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd3c6df5 | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:545 | else of (dtFindData.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Job Except 을 입력하시오.") | 메시지 표시 |  |  |  |
| AC-6b54782d | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:546 | else of (dtFindData.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3316397 | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:549 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e88ad2b4 | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:550 | if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c8e3a79 | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:559 | try ▸ if (!bRtn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f50f29a | this.btnSave.Click 외 1 | FP01820_Net_Job_ExceptPop.cs:565 | catch ((Exception ee)) | MESSAGE | MessageHelper.GMessageBox | (ee.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01820_Net_Job_ExceptPop.set_AftereFind

진입점: this.btnFind.Click [try] / this.Load [try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ac70682 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:723 |  | VALUE_SET | clbDivision.Text | dtMaster.Rows[0]["DIVISION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f117ea81 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:724 |  | VALUE_SET | txtJobGroupID.Text | dtMaster.Rows[0]["GROUP_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-fb651129 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:725 |  | VALUE_SET | txtJobName.Text | dtMaster.Rows[0]["GROUP_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-2b9a1206 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:726 |  | VALUE_SET | txtJobDesc.Text | dtMaster.Rows[0]["DESCRIPTION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-4814f72a | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:727 |  | VALUE_SET | txtStartTime.Text | dtMaster.Rows[0]["START_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f3e1832c | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:728 |  | VALUE_SET | txtEndTime.Text | dtMaster.Rows[0]["END_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ececaa78 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:729 |  | VALUE_SET | cboPeriod.Text | dtMaster.Rows[0]["PERIOD"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-0da29c03 | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:730 |  | VALUE_SET | txtTime.Text | dtMaster.Rows[0]["TIME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f080ca5e | this.btnFind.Click [try] 외 3 | FP01820_Net_Job_ExceptPop.cs:731 |  | VALUE_SET | cboValid.Text | dtMaster.Rows[0]["VALID"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP01820_Net_Job_ExceptPop.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb59494c | this.Load | FP01820_Net_Job_ExceptPop.cs:272 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb23a1f1 | this.Load | FP01820_Net_Job_ExceptPop.cs:273 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e0a71eb0 | this.Load | FP01820_Net_Job_ExceptPop.cs:277 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01820_Net_Job_ExceptPop.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be782952 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:662 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b7ad5cfe | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:663 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5e17a484 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:666 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-94370a31 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:671 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b10e3262 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:673 | if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3bfd80c | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:684 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | DATA_OP | FilterTmp["START_YMD"] | dtFindData.Rows[e.Row][DefColumns.SUB_START_YMD].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c8fec24 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:685 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | DATA_OP | FilterTmp["END_YMD"] | dtFindData.Rows[e.Row][DefColumns.SUB_END_YMD].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a09eb320 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:686 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | DATA_OP | FilterTmp["START_HOUR"] | dtFindData.Rows[e.Row][DefColumns.SUB_START_HOUR].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dca888f7 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:687 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | DATA_OP | FilterTmp["END_HOUR"] | dtFindData.Rows[e.Row][DefColumns.SUB_END_HOUR].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0570240c | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:688 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | DATA_OP | FilterTmp["START_MIN"] | dtFindData.Rows[e.Row][DefColumns.SUB_START_MIN].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f8b7a296 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:689 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | DATA_OP | FilterTmp["END_MIN"] | dtFindData.Rows[e.Row][DefColumns.SUB_END_MIN].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d1474c2b | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:691 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | POPUP | new FP01820_Net_Job_DatePop | (FilterTmp) | 팝업/폼 생성 |  |  |  |
| AC-bc503ece | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:692 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f624b4f6 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:694 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cc70242b | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:696 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | GRID_SET | dtFindData.Rows[e.Row][DefColumns.SUB_START_DATE] | popItem._START_DATE | 그리드 속성/값 설정 |  |  |  |
| AC-eaae5516 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:697 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | GRID_SET | dtFindData.Rows[e.Row][DefColumns.SUB_END_DATE] | popItem._END_DATE | 그리드 속성/값 설정 |  |  |  |
| AC-79ef184c | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:698 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | GRID_SET | dtFindData.Rows[e.Row][DefColumns.SUB_START_YMD] | popItem._START_YMD | 그리드 속성/값 설정 |  |  |  |
| AC-6cecff25 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:699 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | GRID_SET | dtFindData.Rows[e.Row][DefColumns.SUB_END_YMD] | popItem._END_YMD | 그리드 속성/값 설정 |  |  |  |
| AC-8688a4e3 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:700 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | GRID_SET | dtFindData.Rows[e.Row][DefColumns.SUB_START_HOUR] | popItem._START_HOUR | 그리드 속성/값 설정 |  |  |  |
| AC-5f836c16 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:701 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | GRID_SET | dtFindData.Rows[e.Row][DefColumns.SUB_END_HOUR] | popItem._END_HOUR | 그리드 속성/값 설정 |  |  |  |
| AC-6cfbb690 | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:702 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | GRID_SET | dtFindData.Rows[e.Row][DefColumns.SUB_START_MIN] | popItem._START_MIN | 그리드 속성/값 설정 |  |  |  |
| AC-372feaea | this.spdMain.CellClick | FP01820_Net_Job_ExceptPop.cs:703 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SUB_START_DATE) && acti… | GRID_SET | dtFindData.Rows[e.Row][DefColumns.SUB_END_MIN] | popItem._END_MIN | 그리드 속성/값 설정 |  |  |  |

## FP01820_Net_Job..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e94f3694 | .ctor | FP01820_Net_Job.cs:154 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job.btn_except_Click

진입점: this.btn_except.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-553bfb11 | this.btn_except.Click | FP01820_Net_Job.cs:1523 | try ▸ if (nSelRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.btn_start_Click

진입점: this.btn_start.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d88016a | this.btn_start.Click | FP01820_Net_Job.cs:1446 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8810c3a4 | this.btn_start.Click | FP01820_Net_Job.cs:1447 | if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abff5b85 | this.btn_start.Click | FP01820_Net_Job.cs:1452 |  | DATA_OP | dtSave.Columns.Add | ("GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-614224ac | this.btn_start.Click | FP01820_Net_Job.cs:1454 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-900e0964 | this.btn_start.Click | FP01820_Net_Job.cs:1455 |  | DATA_OP | dtSave.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b7a3a12 | this.btn_start.Click | FP01820_Net_Job.cs:1456 |  | GRID_SET | dtSave.Rows[0][0] | dsbind.Tables[0].Rows[iClickRow]["GROUP_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-c103ce9b | this.btn_start.Click | FP01820_Net_Job.cs:1458 |  | DATA_OP | dsSave.Tables.Add | (dtSave) | 데이터 객체 조작/조회 |  |  |  |
| AC-384afd14 | this.btn_start.Click | FP01820_Net_Job.cs:1460 |  | ENDPOINT | DataService.FP_UpdateBatch | ("FP01820_Net_Job", "save_FP01820_start", dsSave, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_FP01820_start] \| FP\ADMIN\… | 엔드포인트 호출 |  |  |  |
| AC-ee86718f | this.btn_start.Click | FP01820_Net_Job.cs:1466 | if (ret != null && ret.DataSet == null) ▸ if (ret.Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ret.Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f0fa33c | this.btn_start.Click | FP01820_Net_Job.cs:1473 | if (ret != null && ret.DataSet == null) ▸ else of (ret.Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01820_Net_Job.btn_stop_Click

진입점: this.btn_stop.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-820c298c | this.btn_stop.Click | FP01820_Net_Job.cs:1480 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2b2a293d | this.btn_stop.Click | FP01820_Net_Job.cs:1481 | if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8a4f9bf2 | this.btn_stop.Click | FP01820_Net_Job.cs:1486 |  | DATA_OP | dtSave.Columns.Add | ("GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ea74a87 | this.btn_stop.Click | FP01820_Net_Job.cs:1488 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2d87e8d6 | this.btn_stop.Click | FP01820_Net_Job.cs:1489 |  | DATA_OP | dtSave.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4374288 | this.btn_stop.Click | FP01820_Net_Job.cs:1490 |  | GRID_SET | dtSave.Rows[0][0] | dsbind.Tables[0].Rows[iClickRow]["GROUP_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-1acbb93b | this.btn_stop.Click | FP01820_Net_Job.cs:1492 |  | DATA_OP | dsSave.Tables.Add | (dtSave) | 데이터 객체 조작/조회 |  |  |  |
| AC-80971507 | this.btn_stop.Click | FP01820_Net_Job.cs:1494 |  | ENDPOINT | DataService.FP_UpdateBatch | ("FP01820_Net_Job", "save_FP01820_stop", dsSave, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_FP01820_stop] \| FP\ADMIN\F… | 엔드포인트 호출 |  |  |  |
| AC-76f6143a | this.btn_stop.Click | FP01820_Net_Job.cs:1500 | if (ret != null && ret.DataSet == null) ▸ if (ret.Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ret.Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e2d7c64 | this.btn_stop.Click | FP01820_Net_Job.cs:1507 | if (ret != null && ret.DataSet == null) ▸ else of (ret.Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01820_Net_Job.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90cd94aa | this.btnSql.Click | FP01820_Net_Job.cs:659 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-508ca2ea | this.btnSql.Click | FP01820_Net_Job.cs:660 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5deb2fb5 | this.btnSql.Click | FP01820_Net_Job.cs:662 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01820_Net_Job") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b5f879d | this.btnSql.Click | FP01820_Net_Job.cs:664 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01820_Net_Job.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-666f6514 | this.Load | FP01820_Net_Job.cs:274 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5b179921 | this.Load | FP01820_Net_Job.cs:275 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-08187fe0 | this.Load | FP01820_Net_Job.cs:279 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8964d0c9 | this.Load | FP01820_Net_Job.cs:280 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-91021428 | this.Load | FP01820_Net_Job.cs:282 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60d578f3 | this.Load | FP01820_Net_Job.cs:285 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01820_Net_Job.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-704d450c | this.Load | FP01820_Net_Job.cs:187 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-949308b0 | this.Load | FP01820_Net_Job.cs:189 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-4eed2352 | this.Load | FP01820_Net_Job.cs:190 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-9725cfa6 | this.Load | FP01820_Net_Job.cs:191 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-e362daa9 | this.Load | FP01820_Net_Job.cs:196 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-943dcf79 | this.Load | FP01820_Net_Job.cs:197 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-d612c04a | this.Load | FP01820_Net_Job.cs:198 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0d4d5c0c | this.Load | FP01820_Net_Job.cs:202 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4516ad59 | this.Load | FP01820_Net_Job.cs:203 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-586da92b | this.Load | FP01820_Net_Job.cs:204 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP01820_Net_Job.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5de524e7 | DeleteButton | FP01820_Net_Job.cs:497 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94692180 | DeleteButton | FP01820_Net_Job.cs:503 | if (fps.Name == "spdMain") ▸ if (spdMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eeaea22f | DeleteButton | FP01820_Net_Job.cs:507 | if (fps.Name == "spdMain") ▸ if (spdMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP01820_Net_Job.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d69d916a | Dispose | FP01820_Net_Job.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job.EditButton

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try] / this.btn_detail.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ try] / FindButton [try] / EditButton / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-160c3f70 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:366 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8a94f04 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:372 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7e4631f9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:373 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c942861b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:389 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f4306ad9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:394 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-be623929 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:395 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.DefaultBackColor | 그리드 속성/값 설정 |  |  |  |
| AC-9a814942 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:406 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8146e8c3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:407 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-0a9b8f53 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:420 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | siSub.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-73cd931d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:425 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-8210e923 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:426 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Rows[i].BackColor | ControlColor.DefaultBackColor | 그리드 속성/값 설정 |  |  |  |

## FP01820_Net_Job.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f35555ae | ExcelButton | FP01820_Net_Job.cs:715 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP01820_Net_Job.ExcelImport_Main_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9640d5b8 | (진입점 미연결) | FP01820_Net_Job.cs:602 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.ExcelImport_Main_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db1b5b61 | (진입점 미연결) | FP01820_Net_Job.cs:574 |  | ENDPOINT | DataService.FP_PseudoBatch | ("FP02550_OperationBod", "merge_FP02550", data, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550] \| FP\Master\FP02… | 엔드포인트 호출 |  |  |  |
| AC-3286382a | (진입점 미연결) | FP01820_Net_Job.cs:582 |  | DATA_OP | rds.Tables.Add | (rdt) | 데이터 객체 조작/조회 |  |  |  |
| AC-5af6f858 | (진입점 미연결) | FP01820_Net_Job.cs:584 |  | RETURN | return rds; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.ExcelImport_Main_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bddedbc5 | (진입점 미연결) | FP01820_Net_Job.cs:591 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-25777933 | (진입점 미연결) | FP01820_Net_Job.cs:593 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP02550_OperationBod", "delete_Excel_buffer", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-b6fcf4a6 | (진입점 미연결) | FP01820_Net_Job.cs:596 |  | ENDPOINT | DataService.FP_PseudoBatch | ("FP02550_OperationBod", "insert_Excel_buffer", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\MASTE… | 엔드포인트 호출 |  |  |  |
| AC-72a8dc29 | (진입점 미연결) | FP01820_Net_Job.cs:597 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02550_OperationBod", "find_Excel_buffer_validation", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-72cafedf | (진입점 미연결) | FP01820_Net_Job.cs:597 |  | RETURN | return DataService.FP_ExecuteQuery("FP02550_OperationBod", "find_Excel_buffer_va… |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.ExcelImport_Sub_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8eb2363 | (진입점 미연결) | FP01820_Net_Job.cs:645 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.ExcelImport_Sub_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c94a3c82 | (진입점 미연결) | FP01820_Net_Job.cs:620 |  | ENDPOINT | DataService.FP_PseudoBatch | ("FP02550_OperationBod", "merge_FP02550_Sub", data, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550_Sub] \| FP\Master\… | 엔드포인트 호출 |  |  |  |
| AC-2544d40e | (진입점 미연결) | FP01820_Net_Job.cs:625 |  | DATA_OP | rds.Tables.Add | (rdt) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffc39be7 | (진입점 미연결) | FP01820_Net_Job.cs:627 |  | RETURN | return rds; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.ExcelImport_Sub_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81dce77b | (진입점 미연결) | FP01820_Net_Job.cs:634 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-da124548 | (진입점 미연결) | FP01820_Net_Job.cs:636 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP02550_OperationBod", "delete_Excel_buffer_sub", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer_sub] \| … | 엔드포인트 호출 |  |  |  |
| AC-0883aa26 | (진입점 미연결) | FP01820_Net_Job.cs:639 |  | ENDPOINT | DataService.FP_PseudoBatch | ("FP02550_OperationBod", "insert_Excel_buffer_sub", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer_sub] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-9d827f6c | (진입점 미연결) | FP01820_Net_Job.cs:640 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02550_OperationBod", "find_Excel_buffer_validation_sub", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_su… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-95ffcad7 | (진입점 미연결) | FP01820_Net_Job.cs:640 |  | RETURN | return DataService.FP_ExecuteQuery("FP02550_OperationBod", "find_Excel_buffer_va… |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.ExcelPopup_Search_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae17aac5 | (진입점 미연결) | FP01820_Net_Job.cs:558 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.ExcelPopup_Search_Sub_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc09cd47 | (진입점 미연결) | FP01820_Net_Job.cs:608 |  | FLAG | _search | GetSearchCondition(iClickRow) | 화면 필드/플래그 변경 |  |  |  |
| AC-7885902e | (진입점 미연결) | FP01820_Net_Job.cs:612 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.Find_Data_Execute

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda] / this.btn_detail.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP01820_Net_Job")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbdb90b2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:838 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["DIVISION_ID"] = CString.GetCheckedListValue(dtDiv… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8352a6b1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:840 | try ▸ lambda | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-830d9a7c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:841 | try ▸ lambda | DATA_OP | Filter["JOB_LIST"] | CString.GetCheckedListValue(dtSite, clbJobList.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-aecca3d2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:842 | try ▸ lambda | DATA_OP | Filter["ITEM_ID"] | txtCreator.Text | 행/컬럼 값 대입 |  |  |  |
| AC-ae753865 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:843 | try ▸ lambda | DATA_OP | Filter["SEARCH_COND"] | txtSearch.Text.SafeString().Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-997cc7b8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:846 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP01820_Net_Job", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-be3e21fd | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:847 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-863acd9b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP01820_Net_Job.cs:851 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01820_Net_Job.Find_Data_Sub

진입점: this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Sheet().Rows.Count > 0)] / this.spdMain.KeyUp [if (e.KeyCode == Keys.Up \|\| e.KeyCode == Keys.Down) ▸ if (row != null)] / this.btn_detail.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Sheet().Rows.Count > 0)] / this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ if (e.Colum…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-692e212f | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:857 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7349a24e | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:862 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-ab61585a | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:862 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9775a45 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:868 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-50ac447c | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:879 | try | GRID_BIND | siSub.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7bc8d5fd | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:880 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac25b76e | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:888 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siSub.GetText(i, siSub.GetColumnIndex(DefColumns.STATUS)) == "ERROR") | VALUE_SET | buttonCellType11.Text | "ERROR" | 컨트롤 값 설정 |  |  |  |
| AC-ede1036d | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:889 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siSub.GetText(i, siSub.GetColumnIndex(DefColumns.STATUS)) == "ERROR") | UI_PROP | buttonCellType11.TextDown | "ERROR" | 속성 TextDown 설정 |  |  |  |
| AC-a57f7c5f | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:890 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siSub.GetText(i, siSub.GetColumnIndex(DefColumns.STATUS)) == "ERROR") | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS)].CellType | buttonCellType11 | 그리드 속성/값 설정 |  |  |  |
| AC-3fee6982 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:895 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c92c7027 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:898 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8775b71d | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:909 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP01820_Net_Job.Find_Data_Sub_Execute

진입점: this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Sheet().Rows.Count > 0) ▸ try] / this.spdMain.KeyUp [if (e.KeyCode == Keys.Up \|\| e.KeyCode == Keys.Down) ▸ if (row != null) ▸ try] / this.btn_detail.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Sheet().Rows.Count > 0) ▸ try] / this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STAT…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20355f2b | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:926 | try ▸ if (queryFlag.Equals("SUB")) | FLAG | pDivisionID | search.DIVISION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-55174b92 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:941 | try | DATA_OP | column_params.Add | ("GROUP_ID", pGroupID) | 데이터 객체 조작/조회 |  |  |  |
| AC-47486ad7 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:942 | try | DATA_OP | column_params.Add | ("GROUP_NAME", pGroupName) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f4ab9f9 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:943 | try | DATA_OP | column_params.Add | ("DIVISION_ID", pDivisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac7a5854 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:944 | try | DATA_OP | column_params.Add | ("VALID_YN", "ALL") | 데이터 객체 조작/조회 |  |  |  |
| AC-a71d62f1 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:946 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01820_Net_Job", "find_FP01820_Sub", column_params, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] \| FP\ADMIN\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8f55c533 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:946 | try | RETURN | return DataService.FP_ExecuteQuery("FP01820_Net_Job", "find_FP01820_Sub", column… |  | 처리 중단/반환 |  |  |  |
| AC-31d7f576 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:950 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01820_Net_Job.Find_Main

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (popup.ShowDialog() == DialogResult.OK)] / this.btn_detail.Click [if (popup.ShowDialog() == DialogResult.OK)] / FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / InsertButton [if (popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1370e523 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:724 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c3625822 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:729 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35ba53d4 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:730 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b232940 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:733 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-456c4ae3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:735 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-185e6eac | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:735 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a186aa72 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:739 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-234816e2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:746 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b5d41ca1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:748 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac142296 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:758 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0b232726 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:760 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd84e610 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:805 | try ▸ if (siMain.Sheet().Rows.Count > 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-fe298f5b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:810 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-00beb8fb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:822 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-0a70f29b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:826 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-af4dc5c0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP01820_Net_Job.cs:827 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job.fn_detailView

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / this.btn_detail.Click / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04e49ad0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | FP01820_Net_Job.cs:1543 |  | POPUP | new FP01820_Net_Job_AddPop | () | 팝업/폼 생성 |  |  |  |
| AC-82e3df78 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | FP01820_Net_Job.cs:1544 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-9a5d18bc | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | FP01820_Net_Job.cs:1546 |  | UI_PROP | popup.argGroupID | sGroupID | 속성 argGroupID 설정 |  |  |  |
| AC-1f599efe | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | FP01820_Net_Job.cs:1547 |  | UI_PROP | popup.argDivision | SDivision | 속성 argDivision 설정 |  |  |  |
| AC-9586c00e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | FP01820_Net_Job.cs:1549 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6f0a172e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | FP01820_Net_Job.cs:1551 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01820_Net_Job.fn_exceptView

진입점: this.btn_except.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e867790c | this.btn_except.Click [try] | FP01820_Net_Job.cs:1570 |  | POPUP | new FP01820_Net_Job_ExceptPop | () | 팝업/폼 생성 |  |  |  |
| AC-34aa0d8c | this.btn_except.Click [try] | FP01820_Net_Job.cs:1571 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-d4139386 | this.btn_except.Click [try] | FP01820_Net_Job.cs:1573 |  | UI_PROP | popup.argGroupID | sGroupID | 속성 argGroupID 설정 |  |  |  |
| AC-619ccd63 | this.btn_except.Click [try] | FP01820_Net_Job.cs:1574 |  | UI_PROP | popup.argDivision | SDivision | 속성 argDivision 설정 |  |  |  |
| AC-44239cc2 | this.btn_except.Click [try] | FP01820_Net_Job.cs:1576 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cb759149 | this.btn_except.Click [try] | FP01820_Net_Job.cs:1578 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01820_Net_Job.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d67d9981 | this.Load | FP01820_Net_Job.cs:162 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01820_Net_Job.GetSearchCondition

진입점: this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Sheet().Rows.Count > 0)] / this.spdMain.KeyUp [if (e.KeyCode == Keys.Up \|\| e.KeyCode == Keys.Down) ▸ if (row != null)] / this.btn_detail.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Sheet().Rows.Count > 0)] / this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ if (e.Colum…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6239a78 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 9 | FP01820_Net_Job.cs:1414 |  | DATA_OP | siMain.GetBindingRow | (row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-94f0ce21 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 9 | FP01820_Net_Job.cs:1416 |  | CALL_EXT | _search.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc53004d | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 9 | FP01820_Net_Job.cs:1418 |  | UI_PROP | _search.GROUP_ID | dRow["GROUP_ID"] as string | 속성 GROUP_ID 설정 |  |  |  |
| AC-514d77ff | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 9 | FP01820_Net_Job.cs:1419 |  | UI_PROP | _search.GROUP_NAME | dRow["GROUP_NAME"] as string | 속성 GROUP_NAME 설정 |  |  |  |
| AC-3da353bc | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 9 | FP01820_Net_Job.cs:1420 |  | UI_PROP | _search.DIVISION_ID | dRow["DIVISION_ID"] as string | 속성 DIVISION_ID 설정 |  |  |  |
| AC-c8249987 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 9 | FP01820_Net_Job.cs:1424 |  | RETURN | return _search; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b56d944 | this.Load | FP01820_Net_Job.cs:214 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f14f9a6c | this.Load | FP01820_Net_Job.cs:220 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2b307a4b | this.Load | FP01820_Net_Job.cs:221 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0379c131 | this.Load | FP01820_Net_Job.cs:224 | try | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-8d982727 | this.Load | FP01820_Net_Job.cs:224 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd1d1778 | this.Load | FP01820_Net_Job.cs:226 | try | DATA_OP | dtDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e9b0659f | this.Load | FP01820_Net_Job.cs:227 | try | DATA_OP | row["CODE"] | "999" | 행/컬럼 값 대입 |  |  |  |
| AC-aef8ec55 | this.Load | FP01820_Net_Job.cs:228 | try | DATA_OP | row["NAME"] | "(999)SYSTEM" | 행/컬럼 값 대입 |  |  |  |
| AC-68d1410a | this.Load | FP01820_Net_Job.cs:229 | try | DATA_OP | dtDivision.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-85398e8c | this.Load | FP01820_Net_Job.cs:231 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7d17b556 | this.Load | FP01820_Net_Job.cs:239 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01820_Net_Job.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32754aa9 | this.Load | FP01820_Net_Job.cs:178 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ba922969 | this.Load | FP01820_Net_Job.cs:179 |  | UI_PROP | clbJobList.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01820_Net_Job.InitSpread

진입점: this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Sheet().Rows.Count > 0) ▸ try] / this.spdMain.KeyUp [if (e.KeyCode == Keys.Up \|\| e.KeyCode == Keys.Down) ▸ if (row != null) ▸ try] / this.btn_detail.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Sheet().Rows.Count > 0) ▸ try] / this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STAT…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1daae036 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:294 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8127b052 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:296 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-008cf7b4 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:302 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-cf1d0025 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0) ▸… 외 9 | FP01820_Net_Job.cs:304 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |

## FP01820_Net_Job.Insert_Row_Sub

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1706144 | (진입점 미연결) | FP01820_Net_Job.cs:673 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5d622c78 | (진입점 미연결) | FP01820_Net_Job.cs:698 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siMain.GetBindingRow | (iClickRow) | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP01820_Net_Job.lfn_SearchDetailGrid

진입점: this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Sheet().Rows.Count > 0)] / this.spdMain.KeyUp [if (e.KeyCode == Keys.Up \|\| e.KeyCode == Keys.Down) ▸ if (row != null)] / this.btn_detail.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Sheet().Rows.Count > 0)] / this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ if (e.Colum…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2de50f33 | this.spdMain.CellClick [if (!e.ColumnHeader && e.Row >= 0)] 외 8 | FP01820_Net_Job.cs:1407 |  | FLAG | _search | GetSearchCondition(row) | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0695a254 | popSql.OnSql | FP01820_Net_Job.cs:1392 | if (programID == "PR_UI_FP01820_Net_Job") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-404316e8 | popSql.OnSql | FP01820_Net_Job.cs:1397 | else of (programID == "PR_UI_FP01820_Net_Job") ▸ if (programID == "find_FP01820_Sub") | FLAG | _search | GetSearchCondition(iClickRow) | 화면 필드/플래그 변경 |  |  |  |
| AC-55af7171 | popSql.OnSql | FP01820_Net_Job.cs:1399 | else of (programID == "PR_UI_FP01820_Net_Job") ▸ if (programID == "find_FP01820_Sub") | RETURN | return Find_Data_Sub_Execute(false, _search, "SUB"); |  | 처리 중단/반환 |  |  |  |
| AC-56a826dd | popSql.OnSql | FP01820_Net_Job.cs:1402 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.Save_Data_Execute

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b706860d | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1094 | try | DATA_OP | dtmain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bbeb0e20 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1095 | try | CALL_EXT | removed.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fb7255e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1103 | try ▸ foreach (DataRow row in dtmain.Rows) ▸ if (action == CAppSetting.FlagD) | DATA_OP | removed.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-941efaec | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1104 | try ▸ foreach (DataRow row in dtmain.Rows) ▸ if (action == CAppSetting.FlagD) | UI_PROP | newrow.ItemArray | row.ItemArray | 속성 ItemArray 설정 |  |  |  |
| AC-261ff949 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1110 | try ▸ if (removed.Rows.Count == 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-dd754425 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1113 | try | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01820_Net_Job", "delete_FP01820_all", removed, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_all] \| FP\ADMIN\… | 엔드포인트 호출 |  |  |  |
| AC-ef144536 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1120 | try ▸ if (ret2 != null && ret2.DataSet == null) ▸ if (ret2.Rows[0][0].ToString() == "SUCCESS") | DATA_OP | dtrtn.Tables.Add | (ret2) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ae7d1c6 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1122 | try ▸ if (ret2 != null && ret2.DataSet == null) ▸ if (ret2.Rows[0][0].ToString() == "SUCCESS") | RETURN | return dtrtn; |  | 처리 중단/반환 |  |  |  |
| AC-ae6ed6cc | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1126 | try ▸ if (ret2 != null && ret2.DataSet == null) ▸ else of (ret2.Rows[0][0].ToString() == "SUCCESS") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-832ad444 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1130 | try | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c7b152bf | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … 외 1 | FP01820_Net_Job.cs:1135 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.Save_Main

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9ba86ab | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:956 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-27333d59 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:956 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0170742e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:958 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-470deac6 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:960 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db191912 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:965 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b1a056ac | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:966 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4325f749 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:969 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-73e0a776 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:976 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-76ea261a | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:978 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-80d6b197 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:979 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0bd48857 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:984 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4aba8b1c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:989 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4d15a86 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:998 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6395cff7 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:1002 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-086a695c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:1006 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-19363ce6 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:1007 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12461161 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:1011 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5fe792c6 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP01820_Net_Job.cs:1012 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job.Save_Sub

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-484cac73 | (진입점 미연결) | FP01820_Net_Job.cs:1018 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b76ccf11 | (진입점 미연결) | FP01820_Net_Job.cs:1020 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-e59b5f70 | (진입점 미연결) | FP01820_Net_Job.cs:1020 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f97a11f | (진입점 미연결) | FP01820_Net_Job.cs:1022 | if (siSub == null \|\| siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d8365a5 | (진입점 미연결) | FP01820_Net_Job.cs:1024 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4c4da5c | (진입점 미연결) | FP01820_Net_Job.cs:1029 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3058072f | (진입점 미연결) | FP01820_Net_Job.cs:1030 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e66a8502 | (진입점 미연결) | FP01820_Net_Job.cs:1033 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-239ad321 | (진입점 미연결) | FP01820_Net_Job.cs:1040 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-21b55387 | (진입점 미연결) | FP01820_Net_Job.cs:1042 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2cb7a520 | (진입점 미연결) | FP01820_Net_Job.cs:1043 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-208381e6 | (진입점 미연결) | FP01820_Net_Job.cs:1048 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-400eeee3 | (진입점 미연결) | FP01820_Net_Job.cs:1053 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4cdd97cc | (진입점 미연결) | FP01820_Net_Job.cs:1068 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c3a8710b | (진입점 미연결) | FP01820_Net_Job.cs:1072 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d704bd96 | (진입점 미연결) | FP01820_Net_Job.cs:1076 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-81884efd | (진입점 미연결) | FP01820_Net_Job.cs:1077 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2649e4e3 | (진입점 미연결) | FP01820_Net_Job.cs:1082 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e76e7f3f | (진입점 미연결) | FP01820_Net_Job.cs:1083 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a60a5264 | SaveButton | FP01820_Net_Job.cs:442 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.SetChangedControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb9f4b47 | this.Load [try] 외 1 | FP01820_Net_Job.cs:257 | if (argType == "") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-e954b493 | this.Load [try] 외 1 | FP01820_Net_Job.cs:258 | if (argType == "") | DATA_OP | Filter["DIVISION_ID"] | sDataID | 행/컬럼 값 대입 |  |  |  |
| AC-442597cb | this.Load [try] 외 1 | FP01820_Net_Job.cs:259 | if (argType == "") | FLAG | dtJobList | Data_FP.CallGeneralProcedure2(("PR_UI_FP01820_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-5b36b7a6 | this.Load [try] 외 1 | FP01820_Net_Job.cs:259 | if (argType == "") | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01820_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "JOBLIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b6d01b17 | this.Load [try] 외 1 | FP01820_Net_Job.cs:260 | if (argType == "") | LIST_REBIND | clsCtrl.setListBox | (dtJobList, clbJobList, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ff443b52 | this.Load [try] 외 1 | FP01820_Net_Job.cs:265 | else of (argType == "") ▸ if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-cc2fea95 | this.Load [try] 외 1 | FP01820_Net_Job.cs:266 | else of (argType == "") ▸ if (argType == "DIVISION") | DATA_OP | Filter["DIVISION_ID"] | sDataID | 행/컬럼 값 대입 |  |  |  |
| AC-28cb4764 | this.Load [try] 외 1 | FP01820_Net_Job.cs:267 | else of (argType == "") ▸ if (argType == "DIVISION") | FLAG | dtJobList | Data_FP.CallGeneralProcedure2(("PR_UI_FP01820_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-86388a6c | this.Load [try] 외 1 | FP01820_Net_Job.cs:267 | else of (argType == "") ▸ if (argType == "DIVISION") | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01820_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "JOBLIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2b6120c9 | this.Load [try] 외 1 | FP01820_Net_Job.cs:268 | else of (argType == "") ▸ if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtJobList, clbJobList, true) | 목록 컨트롤 재구성 |  |  |  |

## FP01820_Net_Job.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c3088e6 | this.spdMain.CellClick | FP01820_Net_Job.cs:1292 | if (siMain.Sheet().Rows.Count <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-3be97662 | this.spdMain.CellClick | FP01820_Net_Job.cs:1293 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-935473f3 | this.spdMain.CellClick | FP01820_Net_Job.cs:1300 | if (!e.ColumnHeader && e.Row >= 0) ▸ if (string.IsNullOrWhiteSpace(siMain.GetValue(e.Row, e.Column).ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6dff1f78 | this.spdMain.CellClick | FP01820_Net_Job.cs:1302 | if (!e.ColumnHeader && e.Row >= 0) ▸ if (iClickRow == e.Row) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-383837bf | this.spdMain.CellClick | FP01820_Net_Job.cs:1304 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP01820_Net_Job.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39a0307f | this.spdMain.CellDoubleClick | FP01820_Net_Job.cs:1313 | if (siMain.Sheet().Rows.Count <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-404d25e8 | this.spdMain.CellDoubleClick | FP01820_Net_Job.cs:1314 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01820_Net_Job.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdb7ba3d | this.spdMain.KeyUp | FP01820_Net_Job.cs:1595 | if (e.KeyCode == Keys.Up \|\| e.KeyCode == Keys.Down) ▸ if (row != null) | FLAG | iClickRow | row.Index | 화면 필드/플래그 변경 |  |  |  |
| AC-258069a0 | this.spdMain.KeyUp | FP01820_Net_Job.cs:1598 | if (e.KeyCode == Keys.Up \|\| e.KeyCode == Keys.Down) ▸ if (row != null) | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |

## FP01820_Net_Job.spdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62788111 | this.spdSub.CellClick | FP01820_Net_Job.cs:1167 | try ▸ if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ef0f2d2 | this.spdSub.CellClick | FP01820_Net_Job.cs:1169 | try ▸ if ((siSub.ActiveSheet.Rows.Count <= 0)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4326802f | this.spdSub.CellClick | FP01820_Net_Job.cs:1216 | try ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) | DATA_OP | siSub.GetBindingRow | (e.Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-010499cd | this.spdSub.CellClick | FP01820_Net_Job.cs:1222 | try ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) | MESSAGE | MessageHelper.GMessageBox | (sSql) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00f59bb2 | this.spdSub.CellClick | FP01820_Net_Job.cs:1240 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93a3376d | this.spdSub.CellClick | FP01820_Net_Job.cs:1241 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0935f4f | this.spdSub.CellClick | FP01820_Net_Job.cs:1246 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | DATA_OP | dtSave.Columns.Add | ("GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-026971e6 | this.spdSub.CellClick | FP01820_Net_Job.cs:1247 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | DATA_OP | dtSave.Columns.Add | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-95b5b97c | this.spdSub.CellClick | FP01820_Net_Job.cs:1248 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | DATA_OP | dtSave.Columns.Add | ("JOB_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e17a430a | this.spdSub.CellClick | FP01820_Net_Job.cs:1249 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | DATA_OP | dtSave.Columns.Add | ("NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-092391f0 | this.spdSub.CellClick | FP01820_Net_Job.cs:1250 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | DATA_OP | dtSave.Columns.Add | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7efe507 | this.spdSub.CellClick | FP01820_Net_Job.cs:1252 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f960696 | this.spdSub.CellClick | FP01820_Net_Job.cs:1253 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | DATA_OP | dtSave.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-37e7e24d | this.spdSub.CellClick | FP01820_Net_Job.cs:1254 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | GRID_SET | dtSave.Rows[0][0] | dsbind.Tables[0].Rows[e.Row]["GROUP_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-110129a0 | this.spdSub.CellClick | FP01820_Net_Job.cs:1255 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | GRID_SET | dtSave.Rows[0][1] | dsbind.Tables[0].Rows[e.Row]["DIVISION_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-54d19f6d | this.spdSub.CellClick | FP01820_Net_Job.cs:1256 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | GRID_SET | dtSave.Rows[0][2] | dsbind.Tables[0].Rows[e.Row]["JOB_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-14135b83 | this.spdSub.CellClick | FP01820_Net_Job.cs:1257 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | GRID_SET | dtSave.Rows[0][3] | dsbind.Tables[0].Rows[e.Row]["NO"] | 그리드 속성/값 설정 |  |  |  |
| AC-02187b77 | this.spdSub.CellClick | FP01820_Net_Job.cs:1258 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | GRID_SET | dtSave.Rows[0][4] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-c3601d50 | this.spdSub.CellClick | FP01820_Net_Job.cs:1260 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | DATA_OP | dsSave.Tables.Add | (dtSave) | 데이터 객체 조작/조회 |  |  |  |
| AC-001a3f6d | this.spdSub.CellClick | FP01820_Net_Job.cs:1262 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | ENDPOINT | DataService.FP_UpdateBatch | ("FP01820_Net_Job", "update_InitStatus", dsSave, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_InitStatus] \| FP\ADMIN\F… | 엔드포인트 호출 |  |  |  |
| AC-2557a26f | this.spdSub.CellClick | FP01820_Net_Job.cs:1268 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ret.Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-068b6c78 | this.spdSub.CellClick | FP01820_Net_Job.cs:1276 | try ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.STATUS) && siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.STATUS)) == …) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d5735d98 | this.spdSub.CellClick | FP01820_Net_Job.cs:1284 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

