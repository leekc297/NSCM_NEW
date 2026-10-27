# AS-IS 액션 대조표 — FP01470

> 원천: `Doc/asisfacts/screens/FP01470/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 240행 · 메서드 30 · 종류 DATA_OP 85 · FLAG 32 · RETURN 26 · UI_MISC 16 · UI_PROP 12 · CALL_EXT 10 · MESSAGE 10 · GRID_INIT 10 · GRID_SET 9 · ENDPOINT 5 · POPUP 4 · COMBO_DATA 4 · GRID_LOCK 4 · THROW 3 · VALUE_SET 2 · GRID_BIND 2 · VALIDATE 2 · STATE 2 · CALL_BASE 1 · LIST_REBIND 1 · ⚠ 의미 확인 필요 11


## FP01470_OrderTracking..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec1b8da9 | .ctor | FP01470_OrderTracking.cs:147 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP01470_OrderTracking.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-280047a2 | this.btnSql.Click | FP01470_OrderTracking.cs:1205 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-01b2992c | this.btnSql.Click | FP01470_OrderTracking.cs:1208 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f12d44dc | this.btnSql.Click | FP01470_OrderTracking.cs:1209 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8e52f50e | this.btnSql.Click | FP01470_OrderTracking.cs:1211 |  | DATA_OP | popSql.Services.Add | ("FP01470_OrderTracking") | 데이터 객체 조작/조회 |  |  |  |
| AC-06a2a957 | this.btnSql.Click | FP01470_OrderTracking.cs:1212 |  | DATA_OP | popSql.Services.Add | ("FP01470_OrderTracking_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-38fa41eb | this.btnSql.Click | FP01470_OrderTracking.cs:1214 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01470_OrderTracking.CboInstance_SelectedIndexChanged

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d86144aa | cboInstance.SelectedIndexChanged | FP01470_OrderTracking.cs:181 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-40050c6f | cboInstance.SelectedIndexChanged | FP01470_OrderTracking.cs:182 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ac0ad156 | cboInstance.SelectedIndexChanged | FP01470_OrderTracking.cs:185 |  | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-3054a95a | cboInstance.SelectedIndexChanged | FP01470_OrderTracking.cs:186 |  | FLAG | pInstanceID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-a91ecb1d | cboInstance.SelectedIndexChanged | FP01470_OrderTracking.cs:191 |  | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findFpPlan_info", pInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-9f26a2d4 | cboInstance.SelectedIndexChanged | FP01470_OrderTracking.cs:191 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findFpPlan_info", pInstanceID, dtpPlanDate.ControlValues.ToStrin… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ddcae5a | cboInstance.SelectedIndexChanged | FP01470_OrderTracking.cs:192 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtPlanID, cboPlanID, false, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |

## FP01470_OrderTracking.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce5282aa | SaveButton [if (fps.Name == "spdMain")] | FP01470_OrderTracking.cs:1178 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a505202 | SaveButton [if (fps.Name == "spdMain")] | FP01470_OrderTracking.cs:1179 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5383f30d | SaveButton [if (fps.Name == "spdMain")] | FP01470_OrderTracking.cs:1186 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-03c3a40e | SaveButton [if (fps.Name == "spdMain")] | FP01470_OrderTracking.cs:1188 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP01470_OrderTracking.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6092ab91 | this.Load | FP01470_OrderTracking.cs:247 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-739e5a81 | this.Load | FP01470_OrderTracking.cs:248 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7c61edf | this.Load | FP01470_OrderTracking.cs:250 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b74aa9c3 | this.Load | FP01470_OrderTracking.cs:251 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## FP01470_OrderTracking.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8b730f4 | DeleteButton | FP01470_OrderTracking.cs:478 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-251145e0 | DeleteButton | FP01470_OrderTracking.cs:481 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-455cf9fb | DeleteButton | FP01470_OrderTracking.cs:483 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP01470_OrderTracking.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b8cc32d | Dispose | FP01470_OrderTracking.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01470_OrderTracking.DtpPlanDate_ValueChanged

진입점: dtpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55c4e84b | dtpPlanDate.ValueChanged | FP01470_OrderTracking.cs:174 |  | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findFpPlan_info", pInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d168b585 | dtpPlanDate.ValueChanged | FP01470_OrderTracking.cs:174 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findFpPlan_info", pInstanceID, dtpPlanDate.ControlValues.ToStrin… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-46fecd89 | dtpPlanDate.ValueChanged | FP01470_OrderTracking.cs:175 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtPlanID, cboPlanID, false, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |

## FP01470_OrderTracking.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4c470e8 | EditButton | FP01470_OrderTracking.cs:492 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3576a00d | EditButton | FP01470_OrderTracking.cs:493 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-99e5a960 | EditButton | FP01470_OrderTracking.cs:495 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MODIFY_DATE), siMain.GetColumnIndex(DefColumns.modify_us… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bdf36f90 | EditButton | FP01470_OrderTracking.cs:501 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e4fee60e | EditButton | FP01470_OrderTracking.cs:502 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b6cbad17 | EditButton | FP01470_OrderTracking.cs:506 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.MODIFY_DATE), siSub.GetColumnIndex(DefColumns.modify_user… | 그리드 편집 잠금/해제 |  |  |  |

## FP01470_OrderTracking.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c362085d | (진입점 미연결) | FP01470_OrderTracking.cs:1107 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6b50227 | (진입점 미연결) | FP01470_OrderTracking.cs:1115 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20f1f15b | (진입점 미연결) | FP01470_OrderTracking.cs:1119 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d20e427 | (진입점 미연결) | FP01470_OrderTracking.cs:1120 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-98d0c478 | (진입점 미연결) | FP01470_OrderTracking.cs:1127 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-9473696a | (진입점 미연결) | FP01470_OrderTracking.cs:1129 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## FP01470_OrderTracking.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9631ad3d | ExcelButton | FP01470_OrderTracking.cs:519 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-684621c7 | ExcelButton | FP01470_OrderTracking.cs:520 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-4346b4c9 | ExcelButton | FP01470_OrderTracking.cs:522 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0a67e89e | ExcelButton | FP01470_OrderTracking.cs:526 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-54940921 | ExcelButton | FP01470_OrderTracking.cs:527 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-e7b17846 | ExcelButton | FP01470_OrderTracking.cs:528 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-700b36fe | ExcelButton | FP01470_OrderTracking.cs:531 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-e2e7d743 | ExcelButton | FP01470_OrderTracking.cs:532 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-37ccffbd | ExcelButton | FP01470_OrderTracking.cs:533 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-16078c5d | ExcelButton | FP01470_OrderTracking.cs:535 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-8ad74e16 | ExcelButton | FP01470_OrderTracking.cs:536 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-b1057efd | ExcelButton | FP01470_OrderTracking.cs:543 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ecde8d63 | ExcelButton | FP01470_OrderTracking.cs:547 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-5db26e72 | ExcelButton | FP01470_OrderTracking.cs:551 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01470_OrderTracking.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "FP01470_OrderTracking")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f83ca4c3 | popSql.OnSql [if (programID == "FP01470_OrderTracking")] 외 2 | FP01470_OrderTracking.cs:930 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //조회 전 필터링 SetFilter("INSTANCE_ID", instance_id = CString… | ⚠ 의미 확인 필요 |  |  |  |
| AC-15cf2e91 | popSql.OnSql [if (programID == "FP01470_OrderTracking")] 외 2 | FP01470_OrderTracking.cs:935 | try ▸ lambda | DATA_OP | Filter["PLAN_DATE"] | dtpPlanDate.Value.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-9796abc4 | popSql.OnSql [if (programID == "FP01470_OrderTracking")] 외 2 | FP01470_OrderTracking.cs:937 | try ▸ lambda | DATA_OP | Filter["PLAN_ID"] | cboPlanID.ControlValues?.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4ae49b8d | popSql.OnSql [if (programID == "FP01470_OrderTracking")] 외 2 | FP01470_OrderTracking.cs:938 | try ▸ lambda | DATA_OP | Filter["MATERIAL_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b84030ba | popSql.OnSql [if (programID == "FP01470_OrderTracking")] 외 2 | FP01470_OrderTracking.cs:946 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01470_OrderTracking", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6c8f45a6 | popSql.OnSql [if (programID == "FP01470_OrderTracking")] 외 2 | FP01470_OrderTracking.cs:948 | try | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8dedd88 | popSql.OnSql [if (programID == "FP01470_OrderTracking")] 외 2 | FP01470_OrderTracking.cs:950 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-6bc51aa3 | popSql.OnSql [if (programID == "FP01470_OrderTracking")] 외 2 | FP01470_OrderTracking.cs:954 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01470_OrderTracking.Find_Data_Save

진입점: SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55205d16 | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP01470_OrderTracking.cs:968 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-109d39e6 | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP01470_OrderTracking.cs:970 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-4d6d7642 | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP01470_OrderTracking.cs:974 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01470_OrderTracking.Find_Data_Save_Sub

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4599782c | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01470_OrderTracking.cs:989 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bfdd2234 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01470_OrderTracking.cs:991 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-d4dba7de | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01470_OrderTracking.cs:995 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01470_OrderTracking.Find_Data_sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / popSql.OnSql [else of (programID == "FP01470_OrderTracking") ▸ if (programID == "FP01470_OrderTracking_SUB")] / FindButton [if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95190c54 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | FP01470_OrderTracking.cs:1019 | try ▸ if (siMain.Sheet().Rows.Count > 0) ▸ if (cellDclk) | FLAG | mainLookupType | _eRowSite | 화면 필드/플래그 변경 |  |  |  |
| AC-8a156282 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | FP01470_OrderTracking.cs:1024 | try ▸ if (siMain.Sheet().Rows.Count > 0) ▸ else of (cellDclk) | FLAG | mainLookupType | SP_DataSource.Tables[0].Rows[0][iSITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ab03388f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | FP01470_OrderTracking.cs:1040 | try | DATA_OP | Filter["PLAN_ID"] | cboPlanID.ControlValues.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3282e844 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | FP01470_OrderTracking.cs:1043 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01470_OrderTracking", Filter, _CurrentUser, pSysType, "SELECT_SUB") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-349c6860 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | FP01470_OrderTracking.cs:1045 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-dcbd5647 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | FP01470_OrderTracking.cs:1049 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01470_OrderTracking.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98015ab2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:605 | try | FLAG | cellDclk | dClick | 화면 필드/플래그 변경 |  |  |  |
| AC-e6a8da1a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:610 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1c78f36f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:614 | try | FLAG | dsSub | null | 화면 필드/플래그 변경 |  |  |  |
| AC-94568376 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:625 | try | FLAG | dsSub | Find_Data_sub("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-d2a6222c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:632 | try ▸ if (dsSub != null) ▸ if (dsSub.Tables[0].Rows.Count > 0) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4eabf281 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:633 | try ▸ if (dsSub != null) ▸ if (dsSub.Tables[0].Rows.Count > 0) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-17a5aa85 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:637 | try ▸ if (dsSub != null) ▸ else of (dsSub.Tables[0].Rows.Count > 0) | GRID_BIND | siSub.Query | (dsSub, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-61f15e39 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:638 | try ▸ if (dsSub != null) ▸ else of (dsSub.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsSub) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-803c47d5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:639 | try ▸ if (dsSub != null) ▸ else of (dsSub.Tables[0].Rows.Count > 0) | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-bf88cae4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:644 | try ▸ else of (dsSub != null) | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-a8c51b38 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:645 | try ▸ else of (dsSub != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-a16dae2c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:651 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-26c805a0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:652 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9966c0f1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:665 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18a4c734 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:670 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b0f0f457 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:671 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4ddc3b92 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:679 |  | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-f72fe64a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:682 |  | GRID_SET | siSub.ActiveSheet.Columns[iPLAN_QTY].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-bf874a41 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:683 |  | GRID_SET | siSub.ActiveSheet.Columns[iIN_PLAN_QTY].CellType | num | 그리드 속성/값 설정 |  |  |  |

## FP01470_OrderTracking.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-799cf218 | this.Load | FP01470_OrderTracking.cs:159 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01470_OrderTracking.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd02068f | (진입점 미연결) | FP01470_OrderTracking.cs:1063 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP01470_OrderTracking.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-821b73af | this.Load | FP01470_OrderTracking.cs:218 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-997e24e5 | this.Load | FP01470_OrderTracking.cs:220 |  | VALUE_SET | dtpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-37cb0f36 | this.Load | FP01470_OrderTracking.cs:221 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e623685d | this.Load | FP01470_OrderTracking.cs:222 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1e3422eb | this.Load | FP01470_OrderTracking.cs:223 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNo… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ea14e2bd | this.Load | FP01470_OrderTracking.cs:223 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-58c16486 | this.Load | FP01470_OrderTracking.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3628c85d | this.Load | FP01470_OrderTracking.cs:230 |  | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f7bd90a | this.Load | FP01470_OrderTracking.cs:231 |  | FLAG | pInstanceID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-91398ee8 | this.Load | FP01470_OrderTracking.cs:232 |  | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findFpPlan_info", pInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ba62e160 | this.Load | FP01470_OrderTracking.cs:232 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findFpPlan_info", pInstanceID, dtpPlanDate.Value.ToString("yyyyM… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a2e53eb | this.Load | FP01470_OrderTracking.cs:234 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtPlanID, cboPlanID, false, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3328a953 | this.Load | FP01470_OrderTracking.cs:236 |  | FLAG | dtColumInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-b9034d2d | this.Load | FP01470_OrderTracking.cs:240 | foreach (string str in sColumnList) | DATA_OP | dtColumInfo.Columns.Add | (str) | 데이터 객체 조작/조회 |  |  |  |

## FP01470_OrderTracking.InitSpread_main

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e480a4e6 | this.Load | FP01470_OrderTracking.cs:269 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01470_OrderTracking.InitSpread_Sub

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83b510b0 | this.Load | FP01470_OrderTracking.cs:286 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01470_OrderTracking.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c3521c0 | InsertButton | FP01470_OrderTracking.cs:899 | if (fps.Name == "spdMain") | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f305f5f6 | InsertButton | FP01470_OrderTracking.cs:902 | if (fps.Name == "spdMain") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd907f46 | InsertButton | FP01470_OrderTracking.cs:904 | if (fps.Name == "spdMain") | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-4c62b264 | InsertButton | FP01470_OrderTracking.cs:910 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-817cd471 | InsertButton | FP01470_OrderTracking.cs:912 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.LOOKUP_TYPE_CODE, mainLookupType) | 데이터 객체 조작/조회 |  |  |  |
| AC-af2358cb | InsertButton | FP01470_OrderTracking.cs:913 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT1, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb1d7337 | InsertButton | FP01470_OrderTracking.cs:914 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT2, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-05ca2880 | InsertButton | FP01470_OrderTracking.cs:915 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT3, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d2b84af | InsertButton | FP01470_OrderTracking.cs:916 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT4, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-efa213c3 | InsertButton | FP01470_OrderTracking.cs:917 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT5, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-f339cc58 | InsertButton | FP01470_OrderTracking.cs:918 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a46d768 | InsertButton | FP01470_OrderTracking.cs:920 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## FP01470_OrderTracking.RefreshSpreadSheet

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f060d572 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:460 | if (mode == "MAIN") | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c973fcb9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | FP01470_OrderTracking.cs:465 | else of (mode == "MAIN") ▸ if (mode == "SUB") | CALL_EXT | siSub.EditQuery | (dsSub) | ⚠ 의미 확인 필요 |  |  |  |

## FP01470_OrderTracking.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9aea659a | popSql.OnSql | FP01470_OrderTracking.cs:1221 | if (programID == "FP01470_OrderTracking") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7b662f45 | popSql.OnSql | FP01470_OrderTracking.cs:1226 | else of (programID == "FP01470_OrderTracking") ▸ if (programID == "FP01470_OrderTracking_SUB") | RETURN | return Find_Data_sub("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-cff454a5 | popSql.OnSql | FP01470_OrderTracking.cs:1229 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01470_OrderTracking.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30a8885a | SaveButton | FP01470_OrderTracking.cs:692 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-a5bf9877 | SaveButton | FP01470_OrderTracking.cs:692 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-039dc12a | SaveButton | FP01470_OrderTracking.cs:694 | if (fps.Name == "spdMain") ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ef733a0 | SaveButton | FP01470_OrderTracking.cs:696 | if (fps.Name == "spdMain") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-3f60a4dd | SaveButton | FP01470_OrderTracking.cs:696 | if (fps.Name == "spdMain") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e7e36316 | SaveButton | FP01470_OrderTracking.cs:700 | if (fps.Name == "spdMain") | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-434362c3 | SaveButton | FP01470_OrderTracking.cs:701 | if (fps.Name == "spdMain") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-959d67ba | SaveButton | FP01470_OrderTracking.cs:722 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["LOOKUP_TYPE_CODE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-589cf7f3 | SaveButton | FP01470_OrderTracking.cs:723 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["LOOKUP_DESCRIPTION"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOOKUP_DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aa3a6fc1 | SaveButton | FP01470_OrderTracking.cs:724 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SYSTEM_TYPE_CODE"] | "FP" | 행/컬럼 값 대입 |  |  |  |
| AC-d95a8d04 | SaveButton | FP01470_OrderTracking.cs:729 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString(… | DATA_OP | SaveFilter["ACTIVE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-eb28c917 | SaveButton | FP01470_OrderTracking.cs:733 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToSt… | DATA_OP | SaveFilter["ACTIVE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3a28c809 | SaveButton | FP01470_OrderTracking.cs:735 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b27e302e | SaveButton | FP01470_OrderTracking.cs:736 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-61972b07 | SaveButton | FP01470_OrderTracking.cs:737 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6e6d8c5f | SaveButton | FP01470_OrderTracking.cs:738 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT4"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ceb6b835 | SaveButton | FP01470_OrderTracking.cs:739 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT5"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ed047196 | SaveButton | FP01470_OrderTracking.cs:740 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4977b02 | SaveButton | FP01470_OrderTracking.cs:741 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9d372672 | SaveButton | FP01470_OrderTracking.cs:742 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c98b0d4 | SaveButton | FP01470_OrderTracking.cs:743 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE4"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c23c991e | SaveButton | FP01470_OrderTracking.cs:744 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE5"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-939da342 | SaveButton | FP01470_OrderTracking.cs:745 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE6"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a464d7a2 | SaveButton | FP01470_OrderTracking.cs:746 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE7"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-25b091a6 | SaveButton | FP01470_OrderTracking.cs:747 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE8"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4c455f9 | SaveButton | FP01470_OrderTracking.cs:748 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE9"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-33ad2691 | SaveButton | FP01470_OrderTracking.cs:749 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE10"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-07bce820 | SaveButton | FP01470_OrderTracking.cs:750 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE11"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-87e76ec8 | SaveButton | FP01470_OrderTracking.cs:751 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE12"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ecbc840 | SaveButton | FP01470_OrderTracking.cs:752 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE13"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f0cceaa2 | SaveButton | FP01470_OrderTracking.cs:753 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE14"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1d842b53 | SaveButton | FP01470_OrderTracking.cs:754 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE15"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3bc8b460 | SaveButton | FP01470_OrderTracking.cs:786 | if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { done.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-380117c2 | SaveButton | FP01470_OrderTracking.cs:794 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-e6db01d1 | SaveButton | FP01470_OrderTracking.cs:794 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-281b8464 | SaveButton | FP01470_OrderTracking.cs:796 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0012406d | SaveButton | FP01470_OrderTracking.cs:798 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-0c42fa5f | SaveButton | FP01470_OrderTracking.cs:798 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-da4c705e | SaveButton | FP01470_OrderTracking.cs:802 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | (siSub.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-906da525 | SaveButton | FP01470_OrderTracking.cs:803 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3397124f | SaveButton | FP01470_OrderTracking.cs:815 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["LOOKUP_TYPE_CODE"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-79c8b57c | SaveButton | FP01470_OrderTracking.cs:818 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetColumnIndex… | DATA_OP | SaveFilter["LOOKUP_DESCRIPTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-026cb07c | SaveButton | FP01470_OrderTracking.cs:822 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.GetColumn… | DATA_OP | SaveFilter["LOOKUP_DESCRIPTION"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LOOKUP_DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-66f2bbf2 | SaveButton | FP01470_OrderTracking.cs:825 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SYSTEM_TYPE_CODE"] | "FP" | 행/컬럼 값 대입 |  |  |  |
| AC-596db62f | SaveButton | FP01470_OrderTracking.cs:830 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetColumnIndex… | DATA_OP | SaveFilter["ACTIVE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-f423e6ac | SaveButton | FP01470_OrderTracking.cs:834 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.GetColumn… | DATA_OP | SaveFilter["ACTIVE"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a1bea13d | SaveButton | FP01470_OrderTracking.cs:836 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT1"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4bb7d3da | SaveButton | FP01470_OrderTracking.cs:837 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT2"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-928b1f7f | SaveButton | FP01470_OrderTracking.cs:838 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT3"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-348cfed1 | SaveButton | FP01470_OrderTracking.cs:839 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT4"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a7dfef7e | SaveButton | FP01470_OrderTracking.cs:840 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT5"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2934df75 | SaveButton | FP01470_OrderTracking.cs:842 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT1_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT1_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e55fff8b | SaveButton | FP01470_OrderTracking.cs:843 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT2_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT2_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cb30dee9 | SaveButton | FP01470_OrderTracking.cs:844 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT3_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT3_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-978a8428 | SaveButton | FP01470_OrderTracking.cs:845 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT4_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT4_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fc36528c | SaveButton | FP01470_OrderTracking.cs:846 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT5_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT5_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b9ddbf95 | SaveButton | FP01470_OrderTracking.cs:849 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE1"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b63858fb | SaveButton | FP01470_OrderTracking.cs:850 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE2"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d93c9f30 | SaveButton | FP01470_OrderTracking.cs:851 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE3"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-22d4f8d8 | SaveButton | FP01470_OrderTracking.cs:852 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE4"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fa43a58b | SaveButton | FP01470_OrderTracking.cs:853 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE5"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8b12555 | SaveButton | FP01470_OrderTracking.cs:854 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE6"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5db5764e | SaveButton | FP01470_OrderTracking.cs:855 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE7"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81603681 | SaveButton | FP01470_OrderTracking.cs:856 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE8"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4f6cfb79 | SaveButton | FP01470_OrderTracking.cs:857 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE9"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8e6236fa | SaveButton | FP01470_OrderTracking.cs:858 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE10"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5d1a3ba2 | SaveButton | FP01470_OrderTracking.cs:859 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE11"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a44f2aad | SaveButton | FP01470_OrderTracking.cs:860 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE12"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-85bca23f | SaveButton | FP01470_OrderTracking.cs:861 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE13"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a681e260 | SaveButton | FP01470_OrderTracking.cs:862 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE14"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8229cb1a | SaveButton | FP01470_OrderTracking.cs:863 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE15"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c2cd26a3 | SaveButton | FP01470_OrderTracking.cs:871 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (result) | DATA_OP | SaveFilter["SORT_ORDER"] | m_num.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-48cb6084 | SaveButton | FP01470_OrderTracking.cs:875 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (result) | DATA_OP | SaveFilter["SORT_ORDER"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f0218254 | SaveButton | FP01470_OrderTracking.cs:878 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["VALUE_DESCRIPTION"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.VALUE_DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cfefdf0e | SaveButton | FP01470_OrderTracking.cs:888 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { done.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01470_OrderTracking.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2674f7f | this.Load | FP01470_OrderTracking.cs:202 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0cc21d4c | this.Load | FP01470_OrderTracking.cs:204 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-12d87bfe | this.Load | FP01470_OrderTracking.cs:208 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP01470_OrderTracking.SetFilter

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try ▸ try] / popSql.OnSql [if (programID == "FP01470_OrderTracking") ▸ try ▸ lambda] / FindButton [try ▸ lambda ▸ try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ lambda ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3240f5a2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | FP01470_OrderTracking.cs:1058 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP01470_OrderTracking.SetSpreadInit

진입점: this.Load [try] / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / FindButton [if (spreadInfo.SheetName == SpdSheet.shtMain)] / SaveButton [if (fps.Name == "spdMain") ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9065403 | this.Load [try] 외 3 | FP01470_OrderTracking.cs:294 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b49af2cd | this.Load [try] 외 3 | FP01470_OrderTracking.cs:295 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (sheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7db91ca8 | this.Load [try] 외 3 | FP01470_OrderTracking.cs:297 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-d1bc0542 | this.Load [try] 외 3 | FP01470_OrderTracking.cs:302 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-061b857c | this.Load [try] 외 3 | FP01470_OrderTracking.cs:303 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (sheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8a61e4e1 | this.Load [try] 외 3 | FP01470_OrderTracking.cs:306 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siSub.SetSheetHeaderColumn_FP | (siSub, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-cdd7f470 | this.Load [try] 외 3 | FP01470_OrderTracking.cs:307 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siSub.ColumnHeaderHeight | (0, 15) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3b972c8 | this.Load [try] 외 3 | FP01470_OrderTracking.cs:308 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siSub.ColumnHeaderHeight | (1, 15) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01470_OrderTracking.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec1b562d | this.spdMain.CellDoubleClick | FP01470_OrderTracking.cs:1072 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ef8f632 | this.spdMain.CellDoubleClick | FP01470_OrderTracking.cs:1077 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | _eRowSite | SP_DataSource.Tables[0].Rows[e.Row][iSITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-524b805a | this.spdMain.CellDoubleClick | FP01470_OrderTracking.cs:1079 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | _eRowDemand | SP_DataSource.Tables[0].Rows[e.Row][iFP_DEMAND_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |

## FP01470_OrderTracking.UIFindData

진입점: FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b48f410 | FindButton 외 1 | FP01470_OrderTracking.cs:350 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-45d00411 | FindButton 외 1 | FP01470_OrderTracking.cs:351 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8296c4b4 | FindButton 외 1 | FP01470_OrderTracking.cs:354 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-51875684 | FindButton 외 1 | FP01470_OrderTracking.cs:357 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-807b9ef8 | FindButton 외 1 | FP01470_OrderTracking.cs:361 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-36b3fcaf | FindButton 외 1 | FP01470_OrderTracking.cs:372 | try ▸ if (cboPlanID.ControlValues == null \|\| cboPlanID.ControlValues == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f6afad8 | FindButton 외 1 | FP01470_OrderTracking.cs:373 | try ▸ if (cboPlanID.ControlValues == null \|\| cboPlanID.ControlValues == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74a560b5 | FindButton 외 1 | FP01470_OrderTracking.cs:378 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-83728c50 | FindButton 외 1 | FP01470_OrderTracking.cs:380 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-c3849a2e | FindButton 외 1 | FP01470_OrderTracking.cs:380 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac468be4 | FindButton 외 1 | FP01470_OrderTracking.cs:399 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-994aa554 | FindButton 외 1 | FP01470_OrderTracking.cs:400 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ad74f71e | FindButton 외 1 | FP01470_OrderTracking.cs:401 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-5510a291 | FindButton 외 1 | FP01470_OrderTracking.cs:406 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-69ff45b3 | FindButton 외 1 | FP01470_OrderTracking.cs:407 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-13ee4271 | FindButton 외 1 | FP01470_OrderTracking.cs:427 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d08e4cb1 | FindButton 외 1 | FP01470_OrderTracking.cs:432 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-55a3c135 | FindButton 외 1 | FP01470_OrderTracking.cs:433 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c9eb765a | FindButton 외 1 | FP01470_OrderTracking.cs:434 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e2943c7f | FindButton 외 1 | FP01470_OrderTracking.cs:451 |  | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-94b36fd3 | FindButton 외 1 | FP01470_OrderTracking.cs:453 |  | GRID_SET | siMain.ActiveSheet.Columns[iMFG_QTY].CellType | num | 그리드 속성/값 설정 |  |  |  |

