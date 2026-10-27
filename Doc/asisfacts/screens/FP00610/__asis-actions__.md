# AS-IS 액션 대조표 — FP00610

> 원천: `Doc/asisfacts/screens/FP00610/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 273행 · 메서드 33 · 종류 DATA_OP 88 · FLAG 36 · RETURN 27 · GRID_SET 17 · GRID_INIT 16 · UI_PROP 14 · UI_MISC 12 · CALL_EXT 10 · MESSAGE 10 · COMBO_DATA 8 · GRID_LOCK 8 · LIST_REBIND 6 · ENDPOINT 5 · POPUP 4 · THROW 3 · VALUE_SET 2 · GRID_BIND 2 · VALIDATE 2 · STATE 2 · CALL_BASE 1 · ⚠ 의미 확인 필요 11


## FP00610_PlanResultValidation..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03924519 | .ctor | FP00610_PlanResultValidation.cs:148 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00610_PlanResultValidation.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f94b1162 | this.btnSql.Click | FP00610_PlanResultValidation.cs:1305 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-4a0d6fb0 | this.btnSql.Click | FP00610_PlanResultValidation.cs:1308 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fdaf6692 | this.btnSql.Click | FP00610_PlanResultValidation.cs:1309 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-073106a3 | this.btnSql.Click | FP00610_PlanResultValidation.cs:1311 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00610_PlanResultValidation") | 데이터 객체 조작/조회 |  |  |  |
| AC-05d16b93 | this.btnSql.Click | FP00610_PlanResultValidation.cs:1312 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00610_PlanResultValidation_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-d103cf76 | this.btnSql.Click | FP00610_PlanResultValidation.cs:1314 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00610_PlanResultValidation.CboInstance_SelectedIndexChanged

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dec680d | cboInstance.SelectedIndexChanged | FP00610_PlanResultValidation.cs:205 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-aecc8ade | cboInstance.SelectedIndexChanged | FP00610_PlanResultValidation.cs:206 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7cfca25c | cboInstance.SelectedIndexChanged | FP00610_PlanResultValidation.cs:209 |  | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-a7049d7e | cboInstance.SelectedIndexChanged | FP00610_PlanResultValidation.cs:210 |  | FLAG | pInstanceID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-403e542e | cboInstance.SelectedIndexChanged | FP00610_PlanResultValidation.cs:215 |  | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findFpPlan_info", pInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-a5ca5d13 | cboInstance.SelectedIndexChanged | FP00610_PlanResultValidation.cs:215 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findFpPlan_info", pInstanceID, dtpPlanDate.ControlValues.ToStrin… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-57295929 | cboInstance.SelectedIndexChanged | FP00610_PlanResultValidation.cs:216 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtPlanID, cboPlanID, false, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1409b617 | cboInstance.SelectedIndexChanged | FP00610_PlanResultValidation.cs:218 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInst… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-88198043 | cboInstance.SelectedIndexChanged | FP00610_PlanResultValidation.cs:218 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInstanceID) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ddb31d6d | cboInstance.SelectedIndexChanged | FP00610_PlanResultValidation.cs:219 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00610_PlanResultValidation.CboPlanID_SelectedIndexChanged

진입점: cboPlanID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7dab775 | cboPlanID.SelectedIndexChanged | FP00610_PlanResultValidation.cs:180 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e0c7e9b8 | cboPlanID.SelectedIndexChanged | FP00610_PlanResultValidation.cs:181 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-22d5d1c7 | cboPlanID.SelectedIndexChanged | FP00610_PlanResultValidation.cs:183 |  | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f89da86a | cboPlanID.SelectedIndexChanged | FP00610_PlanResultValidation.cs:184 |  | FLAG | pInstanceID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-631d87df | cboPlanID.SelectedIndexChanged | FP00610_PlanResultValidation.cs:186 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInst… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-d0922bba | cboPlanID.SelectedIndexChanged | FP00610_PlanResultValidation.cs:186 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInstanceID) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6672b217 | cboPlanID.SelectedIndexChanged | FP00610_PlanResultValidation.cs:187 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00610_PlanResultValidation.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e73966a | SaveButton [if (fps.Name == "spdMain")] | FP00610_PlanResultValidation.cs:1278 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0bf4c6f6 | SaveButton [if (fps.Name == "spdMain")] | FP00610_PlanResultValidation.cs:1279 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-55de5696 | SaveButton [if (fps.Name == "spdMain")] | FP00610_PlanResultValidation.cs:1286 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-ccdd2caf | SaveButton [if (fps.Name == "spdMain")] | FP00610_PlanResultValidation.cs:1288 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00610_PlanResultValidation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e3f6b43 | this.Load | FP00610_PlanResultValidation.cs:299 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6612f09e | this.Load | FP00610_PlanResultValidation.cs:300 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-284d77a4 | this.Load | FP00610_PlanResultValidation.cs:302 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9620c186 | this.Load | FP00610_PlanResultValidation.cs:303 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## FP00610_PlanResultValidation.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b725a19a | DeleteButton | FP00610_PlanResultValidation.cs:577 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e17d420 | DeleteButton | FP00610_PlanResultValidation.cs:580 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-64c65553 | DeleteButton | FP00610_PlanResultValidation.cs:582 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00610_PlanResultValidation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f16d0eba | Dispose | FP00610_PlanResultValidation.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00610_PlanResultValidation.DtpPlanDate_ValueChanged

진입점: dtpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bbf279b | dtpPlanDate.ValueChanged | FP00610_PlanResultValidation.cs:198 |  | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findFpPlan_info", pInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3facaede | dtpPlanDate.ValueChanged | FP00610_PlanResultValidation.cs:198 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findFpPlan_info", pInstanceID, dtpPlanDate.ControlValues.ToStrin… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2113c110 | dtpPlanDate.ValueChanged | FP00610_PlanResultValidation.cs:199 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtPlanID, cboPlanID, false, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |

## FP00610_PlanResultValidation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66558ca1 | EditButton | FP00610_PlanResultValidation.cs:587 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf652ca2 | EditButton | FP00610_PlanResultValidation.cs:592 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-749874c6 | EditButton | FP00610_PlanResultValidation.cs:593 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-90e8e115 | EditButton | FP00610_PlanResultValidation.cs:595 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MODIFY_DATE), siMain.GetColumnIndex(DefColumns.modify_us… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d919e4f1 | EditButton | FP00610_PlanResultValidation.cs:601 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1c2e1652 | EditButton | FP00610_PlanResultValidation.cs:602 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-15792322 | EditButton | FP00610_PlanResultValidation.cs:606 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.MODIFY_DATE), siSub.GetColumnIndex(DefColumns.modify_user… | 그리드 편집 잠금/해제 |  |  |  |

## FP00610_PlanResultValidation.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54546a5b | (진입점 미연결) | FP00610_PlanResultValidation.cs:1207 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55975fbc | (진입점 미연결) | FP00610_PlanResultValidation.cs:1215 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f395d1fc | (진입점 미연결) | FP00610_PlanResultValidation.cs:1219 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c92b17a | (진입점 미연결) | FP00610_PlanResultValidation.cs:1220 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-02de618b | (진입점 미연결) | FP00610_PlanResultValidation.cs:1227 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-9a9220f6 | (진입점 미연결) | FP00610_PlanResultValidation.cs:1229 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## FP00610_PlanResultValidation.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bcd29ea | ExcelButton | FP00610_PlanResultValidation.cs:620 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-337c5c1f | ExcelButton | FP00610_PlanResultValidation.cs:621 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-231d40e0 | ExcelButton | FP00610_PlanResultValidation.cs:623 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-65a3097d | ExcelButton | FP00610_PlanResultValidation.cs:627 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-e123206a | ExcelButton | FP00610_PlanResultValidation.cs:628 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-e444a796 | ExcelButton | FP00610_PlanResultValidation.cs:629 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-673fb27b | ExcelButton | FP00610_PlanResultValidation.cs:632 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-b4ce40f6 | ExcelButton | FP00610_PlanResultValidation.cs:633 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-efbb1bfb | ExcelButton | FP00610_PlanResultValidation.cs:634 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-80bf08b8 | ExcelButton | FP00610_PlanResultValidation.cs:636 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-f40536a3 | ExcelButton | FP00610_PlanResultValidation.cs:637 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-d5228f5c | ExcelButton | FP00610_PlanResultValidation.cs:644 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-58e9f6bd | ExcelButton | FP00610_PlanResultValidation.cs:648 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-4a124a8c | ExcelButton | FP00610_PlanResultValidation.cs:652 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00610_PlanResultValidation.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00610_PlanResultValidation")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a7c6c1a | popSql.OnSql [if (programID == "PR_UI_FP00610_PlanResultVali… 외 2 | FP00610_PlanResultValidation.cs:1028 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //조회 전 필터링 string instance_id = ""; SetFilter("INSTANCE_I… | ⚠ 의미 확인 필요 |  |  |  |
| AC-06747e5c | popSql.OnSql [if (programID == "PR_UI_FP00610_PlanResultVali… 외 2 | FP00610_PlanResultValidation.cs:1033 | try ▸ lambda | DATA_OP | Filter["PLAN_DATE"] | dtpPlanDate.Value.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-9e5ebfdd | popSql.OnSql [if (programID == "PR_UI_FP00610_PlanResultVali… 외 2 | FP00610_PlanResultValidation.cs:1034 | try ▸ lambda | DATA_OP | Filter["PLAN_ID"] | cboPlanID.ControlValues.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-92491469 | popSql.OnSql [if (programID == "PR_UI_FP00610_PlanResultVali… 외 2 | FP00610_PlanResultValidation.cs:1037 | try ▸ lambda | DATA_OP | Filter["MATERIAL_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-23571927 | popSql.OnSql [if (programID == "PR_UI_FP00610_PlanResultVali… 외 2 | FP00610_PlanResultValidation.cs:1049 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00610_PlanResultValidation", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3a6e5451 | popSql.OnSql [if (programID == "PR_UI_FP00610_PlanResultVali… 외 2 | FP00610_PlanResultValidation.cs:1051 | try | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-34b77e27 | popSql.OnSql [if (programID == "PR_UI_FP00610_PlanResultVali… 외 2 | FP00610_PlanResultValidation.cs:1053 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-75473e7e | popSql.OnSql [if (programID == "PR_UI_FP00610_PlanResultVali… 외 2 | FP00610_PlanResultValidation.cs:1057 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00610_PlanResultValidation.Find_Data_Save

진입점: SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1778458 | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP00610_PlanResultValidation.cs:1071 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a5f19ba5 | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP00610_PlanResultValidation.cs:1073 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-e843d4ab | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP00610_PlanResultValidation.cs:1077 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00610_PlanResultValidation.Find_Data_Save_Sub

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4db93ba1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00610_PlanResultValidation.cs:1092 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4c63e518 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00610_PlanResultValidation.cs:1094 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-a16a2678 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00610_PlanResultValidation.cs:1098 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00610_PlanResultValidation.Find_Data_sub

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00610_PlanResultValidation") ▸ if (programID == "PR_UI_FP00610_PlanResultValidation_SUB")] / FindButton [if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72745612 | popSql.OnSql [else of (programID == "PR_UI_FP00610_PlanResul… 외 2 | FP00610_PlanResultValidation.cs:1106 | try | DATA_OP | Filter["PLAN_ID"] | cboPlanID.ControlValues.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7908e7cd | popSql.OnSql [else of (programID == "PR_UI_FP00610_PlanResul… 외 2 | FP00610_PlanResultValidation.cs:1141 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00610_PlanResultValidation", Filter, _CurrentUser, pSysType, "SELECT_SUB") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-86a6de34 | popSql.OnSql [else of (programID == "PR_UI_FP00610_PlanResul… 외 2 | FP00610_PlanResultValidation.cs:1143 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-b6db95cc | popSql.OnSql [else of (programID == "PR_UI_FP00610_PlanResul… 외 2 | FP00610_PlanResultValidation.cs:1147 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00610_PlanResultValidation.FindData_Sub

진입점: FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ab3e49e | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:705 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aae907a0 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:714 | try | FLAG | dsSub | null | 화면 필드/플래그 변경 |  |  |  |
| AC-74403ba2 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:725 | try | FLAG | dsSub | Find_Data_sub("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-10889980 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:736 | try ▸ if (dsSub != null) ▸ else of (dsSub.Tables[0].Rows.Count > 0) | GRID_BIND | siSub.Query | (dsSub, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-433bff08 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:737 | try ▸ if (dsSub != null) ▸ else of (dsSub.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsSub) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b52e7687 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:738 | try ▸ if (dsSub != null) ▸ else of (dsSub.Tables[0].Rows.Count > 0) | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-5ba4b6ae | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:743 | try ▸ else of (dsSub != null) | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-e3d3aaa5 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:744 | try ▸ else of (dsSub != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-91415224 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:763 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eafa5bd9 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:768 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d76144ef | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:769 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a77dbc10 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:777 |  | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-6efaaee5 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:780 |  | GRID_SET | siSub.ActiveSheet.Columns[iPLAN_QTY].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-99df2406 | FindButton [if (siMain.ActiveSheet.RowCount > 0)] 외 1 | FP00610_PlanResultValidation.cs:781 |  | GRID_SET | siSub.ActiveSheet.Columns[iIN_PLAN_QTY].CellType | num | 그리드 속성/값 설정 |  |  |  |

## FP00610_PlanResultValidation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0cd8677 | this.Load | FP00610_PlanResultValidation.cs:160 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00610_PlanResultValidation.GetFilter

진입점: FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20c3a206 | FindButton [try] 외 1 | FP00610_PlanResultValidation.cs:1161 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00610_PlanResultValidation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e02f8352 | this.Load | FP00610_PlanResultValidation.cs:247 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b70f534f | this.Load | FP00610_PlanResultValidation.cs:249 |  | VALUE_SET | dtpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-4234969e | this.Load | FP00610_PlanResultValidation.cs:250 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-66524fb4 | this.Load | FP00610_PlanResultValidation.cs:251 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-55c970dd | this.Load | FP00610_PlanResultValidation.cs:252 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNo… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-9ca8f783 | this.Load | FP00610_PlanResultValidation.cs:252 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5bd5b2c6 | this.Load | FP00610_PlanResultValidation.cs:256 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-90a3837e | this.Load | FP00610_PlanResultValidation.cs:259 |  | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4dcecb0f | this.Load | FP00610_PlanResultValidation.cs:260 |  | FLAG | pInstanceID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-f22fc8d6 | this.Load | FP00610_PlanResultValidation.cs:261 |  | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findFpPlan_info", pInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-774ef6c3 | this.Load | FP00610_PlanResultValidation.cs:261 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findFpPlan_info", pInstanceID, dtpPlanDate.Value.ToString("yyyyM… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f05575a | this.Load | FP00610_PlanResultValidation.cs:263 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtPlanID, cboPlanID, false, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-23597614 | this.Load | FP00610_PlanResultValidation.cs:268 |  | FLAG | dtColumInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-95eaadaf | this.Load | FP00610_PlanResultValidation.cs:272 | foreach (string str in sColumnList) | DATA_OP | dtColumInfo.Columns.Add | (str) | 데이터 객체 조작/조회 |  |  |  |
| AC-5db06cec | this.Load | FP00610_PlanResultValidation.cs:275 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInst… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-819453fd | this.Load | FP00610_PlanResultValidation.cs:275 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInstanceID) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a8faf340 | this.Load | FP00610_PlanResultValidation.cs:276 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-307a3084 | this.Load | FP00610_PlanResultValidation.cs:281 |  | FLAG | dtProblem | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "PROBLEM_TYPE", "", "") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-63539394 | this.Load | FP00610_PlanResultValidation.cs:281 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "PROBLEM_TYPE", "", "") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-895fb27f | this.Load | FP00610_PlanResultValidation.cs:282 |  | LIST_REBIND | clsCtrl.setListBox | (dtProblem, cboProblem, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cbc54e06 | this.Load | FP00610_PlanResultValidation.cs:285 |  | FLAG | dtPeriod | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-2de8aa03 | this.Load | FP00610_PlanResultValidation.cs:286 |  | DATA_OP | dtPeriod.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-603caddb | this.Load | FP00610_PlanResultValidation.cs:287 |  | DATA_OP | dtPeriod.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ffd79cd | this.Load | FP00610_PlanResultValidation.cs:291 | for (i < 91) | DATA_OP | dtPeriod.Rows.Add | (i.ToString(), i.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-44ad76a9 | this.Load | FP00610_PlanResultValidation.cs:293 |  | LIST_REBIND | clsCtrl.setListBox | (dtPeriod, cboPeriod, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00610_PlanResultValidation.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8191368 | this.Load | FP00610_PlanResultValidation.cs:169 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00610_PlanResultValidation.InitSpread

진입점: FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-842a1037 | FindButton [try] 외 1 | FP00610_PlanResultValidation.cs:376 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-11c0ea4a | FindButton [try] 외 1 | FP00610_PlanResultValidation.cs:377 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 15) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a9ce440 | FindButton [try] 외 1 | FP00610_PlanResultValidation.cs:378 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 15) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00610_PlanResultValidation.InitSpread_main

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0bdd37b | this.Load | FP00610_PlanResultValidation.cs:317 | try | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-9f9af52c | this.Load | FP00610_PlanResultValidation.cs:318 | try | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b2a2ca8 | this.Load | FP00610_PlanResultValidation.cs:319 | try | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dfc919d9 | this.Load | FP00610_PlanResultValidation.cs:322 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc6bb3af | this.Load | FP00610_PlanResultValidation.cs:327 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00610_PlanResultValidation.InitSpread_Sub

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8621217 | this.Load | FP00610_PlanResultValidation.cs:344 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00610_PlanResultValidation.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2fdf2f9 | InsertButton | FP00610_PlanResultValidation.cs:997 | if (fps.Name == "spdMain") | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3d21ae80 | InsertButton | FP00610_PlanResultValidation.cs:1000 | if (fps.Name == "spdMain") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-59668bb8 | InsertButton | FP00610_PlanResultValidation.cs:1002 | if (fps.Name == "spdMain") | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-4d0960b0 | InsertButton | FP00610_PlanResultValidation.cs:1008 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-baf29327 | InsertButton | FP00610_PlanResultValidation.cs:1010 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.LOOKUP_TYPE_CODE, mainLookupType) | 데이터 객체 조작/조회 |  |  |  |
| AC-de80e400 | InsertButton | FP00610_PlanResultValidation.cs:1011 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT1, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-792e705e | InsertButton | FP00610_PlanResultValidation.cs:1012 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT2, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-c73e93f5 | InsertButton | FP00610_PlanResultValidation.cs:1013 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT3, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-f25358ec | InsertButton | FP00610_PlanResultValidation.cs:1014 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT4, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-142ae610 | InsertButton | FP00610_PlanResultValidation.cs:1015 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT5, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-96030d79 | InsertButton | FP00610_PlanResultValidation.cs:1016 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b924481 | InsertButton | FP00610_PlanResultValidation.cs:1018 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## FP00610_PlanResultValidation.RefreshSpreadSheet

진입점: FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31230c69 | FindButton [try] 외 1 | FP00610_PlanResultValidation.cs:559 | if (mode == "MAIN") | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf7a6c3c | FindButton [try] 외 1 | FP00610_PlanResultValidation.cs:560 | if (mode == "MAIN") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d891abf1 | FindButton [try] 외 1 | FP00610_PlanResultValidation.cs:564 | else of (mode == "MAIN") ▸ if (mode == "SUB") | CALL_EXT | siSub.EditQuery | (dsSub) | ⚠ 의미 확인 필요 |  |  |  |
| AC-762f0539 | FindButton [try] 외 1 | FP00610_PlanResultValidation.cs:565 | else of (mode == "MAIN") ▸ if (mode == "SUB") | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00610_PlanResultValidation.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6e362ee | popSql.OnSql | FP00610_PlanResultValidation.cs:1321 | if (programID == "PR_UI_FP00610_PlanResultValidation") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-453e0c63 | popSql.OnSql | FP00610_PlanResultValidation.cs:1326 | else of (programID == "PR_UI_FP00610_PlanResultValidation") ▸ if (programID == "PR_UI_FP00610_PlanResultValidation_SUB") | RETURN | return Find_Data_sub("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7bbf3000 | popSql.OnSql | FP00610_PlanResultValidation.cs:1329 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00610_PlanResultValidation.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90952317 | SaveButton | FP00610_PlanResultValidation.cs:614 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00610_PlanResultValidation.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75466091 | SaveButton | FP00610_PlanResultValidation.cs:790 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-f269ea40 | SaveButton | FP00610_PlanResultValidation.cs:790 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cbffcb9a | SaveButton | FP00610_PlanResultValidation.cs:792 | if (fps.Name == "spdMain") ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-577c53d0 | SaveButton | FP00610_PlanResultValidation.cs:794 | if (fps.Name == "spdMain") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-81dc84e9 | SaveButton | FP00610_PlanResultValidation.cs:794 | if (fps.Name == "spdMain") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-18635e34 | SaveButton | FP00610_PlanResultValidation.cs:798 | if (fps.Name == "spdMain") | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-764f732d | SaveButton | FP00610_PlanResultValidation.cs:799 | if (fps.Name == "spdMain") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc284ad2 | SaveButton | FP00610_PlanResultValidation.cs:820 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["LOOKUP_TYPE_CODE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a537813 | SaveButton | FP00610_PlanResultValidation.cs:821 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["LOOKUP_DESCRIPTION"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOOKUP_DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2a1432ac | SaveButton | FP00610_PlanResultValidation.cs:822 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SYSTEM_TYPE_CODE"] | "FP" | 행/컬럼 값 대입 |  |  |  |
| AC-c743b262 | SaveButton | FP00610_PlanResultValidation.cs:827 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString(… | DATA_OP | SaveFilter["ACTIVE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-d0a6af40 | SaveButton | FP00610_PlanResultValidation.cs:831 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToSt… | DATA_OP | SaveFilter["ACTIVE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f144fcbd | SaveButton | FP00610_PlanResultValidation.cs:833 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c368e5ec | SaveButton | FP00610_PlanResultValidation.cs:834 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-df0850c8 | SaveButton | FP00610_PlanResultValidation.cs:835 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b9919081 | SaveButton | FP00610_PlanResultValidation.cs:836 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT4"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-114f6f5b | SaveButton | FP00610_PlanResultValidation.cs:837 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT5"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-43eae4f1 | SaveButton | FP00610_PlanResultValidation.cs:838 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6e9eac2a | SaveButton | FP00610_PlanResultValidation.cs:839 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9d2bae57 | SaveButton | FP00610_PlanResultValidation.cs:840 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f165d2da | SaveButton | FP00610_PlanResultValidation.cs:841 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE4"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5eaaa312 | SaveButton | FP00610_PlanResultValidation.cs:842 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE5"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-99e17d14 | SaveButton | FP00610_PlanResultValidation.cs:843 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE6"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bf138527 | SaveButton | FP00610_PlanResultValidation.cs:844 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE7"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a56b7ca2 | SaveButton | FP00610_PlanResultValidation.cs:845 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE8"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-92695db8 | SaveButton | FP00610_PlanResultValidation.cs:846 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE9"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-50b0db87 | SaveButton | FP00610_PlanResultValidation.cs:847 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE10"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3c5272f3 | SaveButton | FP00610_PlanResultValidation.cs:848 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE11"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-125831c4 | SaveButton | FP00610_PlanResultValidation.cs:849 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE12"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c3489fd0 | SaveButton | FP00610_PlanResultValidation.cs:850 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE13"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3a2d1403 | SaveButton | FP00610_PlanResultValidation.cs:851 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE14"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-60e0b7a3 | SaveButton | FP00610_PlanResultValidation.cs:852 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE15"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7440cdff | SaveButton | FP00610_PlanResultValidation.cs:884 | if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { done.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f5462b2 | SaveButton | FP00610_PlanResultValidation.cs:892 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-ca82e207 | SaveButton | FP00610_PlanResultValidation.cs:892 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a36ae9c | SaveButton | FP00610_PlanResultValidation.cs:894 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52fa9860 | SaveButton | FP00610_PlanResultValidation.cs:896 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-b7e58ecb | SaveButton | FP00610_PlanResultValidation.cs:896 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9338d58f | SaveButton | FP00610_PlanResultValidation.cs:900 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | (siSub.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f2ca012 | SaveButton | FP00610_PlanResultValidation.cs:901 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-57f92d4b | SaveButton | FP00610_PlanResultValidation.cs:913 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["LOOKUP_TYPE_CODE"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52938505 | SaveButton | FP00610_PlanResultValidation.cs:916 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetColumnIndex… | DATA_OP | SaveFilter["LOOKUP_DESCRIPTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d00c4aa9 | SaveButton | FP00610_PlanResultValidation.cs:920 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.GetColumn… | DATA_OP | SaveFilter["LOOKUP_DESCRIPTION"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LOOKUP_DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c3241591 | SaveButton | FP00610_PlanResultValidation.cs:923 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SYSTEM_TYPE_CODE"] | "FP" | 행/컬럼 값 대입 |  |  |  |
| AC-0a5e23e0 | SaveButton | FP00610_PlanResultValidation.cs:928 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetColumnIndex… | DATA_OP | SaveFilter["ACTIVE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-0c914e80 | SaveButton | FP00610_PlanResultValidation.cs:932 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.GetColumn… | DATA_OP | SaveFilter["ACTIVE"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b5e0bdcf | SaveButton | FP00610_PlanResultValidation.cs:934 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT1"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0e887772 | SaveButton | FP00610_PlanResultValidation.cs:935 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT2"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9d3194b2 | SaveButton | FP00610_PlanResultValidation.cs:936 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT3"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8accef7b | SaveButton | FP00610_PlanResultValidation.cs:937 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT4"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eeacfc99 | SaveButton | FP00610_PlanResultValidation.cs:938 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT5"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f6d0a201 | SaveButton | FP00610_PlanResultValidation.cs:940 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT1_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT1_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-13ec2bce | SaveButton | FP00610_PlanResultValidation.cs:941 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT2_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT2_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c756ca75 | SaveButton | FP00610_PlanResultValidation.cs:942 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT3_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT3_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2c76b155 | SaveButton | FP00610_PlanResultValidation.cs:943 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT4_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT4_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-47b63979 | SaveButton | FP00610_PlanResultValidation.cs:944 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT5_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT5_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a12b654c | SaveButton | FP00610_PlanResultValidation.cs:947 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE1"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7670df1b | SaveButton | FP00610_PlanResultValidation.cs:948 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE2"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-36630597 | SaveButton | FP00610_PlanResultValidation.cs:949 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE3"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4a58ed37 | SaveButton | FP00610_PlanResultValidation.cs:950 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE4"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4810b43b | SaveButton | FP00610_PlanResultValidation.cs:951 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE5"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a176aa89 | SaveButton | FP00610_PlanResultValidation.cs:952 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE6"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-efe8441c | SaveButton | FP00610_PlanResultValidation.cs:953 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE7"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6839a382 | SaveButton | FP00610_PlanResultValidation.cs:954 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE8"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f8e47ff | SaveButton | FP00610_PlanResultValidation.cs:955 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE9"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-14d17aee | SaveButton | FP00610_PlanResultValidation.cs:956 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE10"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8323d245 | SaveButton | FP00610_PlanResultValidation.cs:957 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE11"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5cb240a1 | SaveButton | FP00610_PlanResultValidation.cs:958 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE12"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-707b8d25 | SaveButton | FP00610_PlanResultValidation.cs:959 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE13"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8e34e255 | SaveButton | FP00610_PlanResultValidation.cs:960 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE14"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bfbfca00 | SaveButton | FP00610_PlanResultValidation.cs:961 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE15"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a8b96281 | SaveButton | FP00610_PlanResultValidation.cs:969 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (result) | DATA_OP | SaveFilter["SORT_ORDER"] | m_num.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1b4cb03c | SaveButton | FP00610_PlanResultValidation.cs:973 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (result) | DATA_OP | SaveFilter["SORT_ORDER"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0b466cea | SaveButton | FP00610_PlanResultValidation.cs:976 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["VALUE_DESCRIPTION"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.VALUE_DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc65c2d7 | SaveButton | FP00610_PlanResultValidation.cs:986 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { done.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00610_PlanResultValidation.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6497c56 | this.Load | FP00610_PlanResultValidation.cs:231 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f97f5f5 | this.Load | FP00610_PlanResultValidation.cs:233 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-d5c81bfc | this.Load | FP00610_PlanResultValidation.cs:237 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00610_PlanResultValidation.SetFilter

진입점: this.Load / cboInstance.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / cboPlanID.SelectedIndexChanged / popSql.OnSql [if (programID == "PR_UI_FP00610_PlanResultValidation") ▸ try ▸ lambda] / FindButton [try ▸ if (string.IsNullOrWhiteSpace(sDivision))] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (string.IsNullOrWhiteSpace(sDivision))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b78963b4 | this.Load 외 6 | FP00610_PlanResultValidation.cs:1156 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00610_PlanResultValidation.SetSpreadInit

진입점: this.Load [try] / FindButton [try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-747d4c5d | this.Load [try] 외 2 | FP00610_PlanResultValidation.cs:352 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba13af82 | this.Load [try] 외 2 | FP00610_PlanResultValidation.cs:353 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (sheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f5843fd0 | this.Load [try] 외 2 | FP00610_PlanResultValidation.cs:355 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-833bc4da | this.Load [try] 외 2 | FP00610_PlanResultValidation.cs:356 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-45939679 | this.Load [try] 외 2 | FP00610_PlanResultValidation.cs:361 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12f3be64 | this.Load [try] 외 2 | FP00610_PlanResultValidation.cs:362 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (sheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-abd3d454 | this.Load [try] 외 2 | FP00610_PlanResultValidation.cs:365 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siSub.SetSheetHeaderColumn_FP | (siSub, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-79607606 | this.Load [try] 외 2 | FP00610_PlanResultValidation.cs:366 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siSub.ColumnHeaderHeight | (0, 15) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd199e23 | this.Load [try] 외 2 | FP00610_PlanResultValidation.cs:367 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siSub.ColumnHeaderHeight | (1, 15) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00610_PlanResultValidation.UIFindData

진입점: FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-568a6a22 | FindButton 외 1 | FP00610_PlanResultValidation.cs:411 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-42ed26ff | FindButton 외 1 | FP00610_PlanResultValidation.cs:412 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc66b2fc | FindButton 외 1 | FP00610_PlanResultValidation.cs:415 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-72c44c6d | FindButton 외 1 | FP00610_PlanResultValidation.cs:424 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-59cb15de | FindButton 외 1 | FP00610_PlanResultValidation.cs:428 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-33edbbf8 | FindButton 외 1 | FP00610_PlanResultValidation.cs:442 | try ▸ if (cboPlanID.ControlValues == null \|\| cboPlanID.ControlValues == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a99036f0 | FindButton 외 1 | FP00610_PlanResultValidation.cs:443 | try ▸ if (cboPlanID.ControlValues == null \|\| cboPlanID.ControlValues == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-256cecf6 | FindButton 외 1 | FP00610_PlanResultValidation.cs:448 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-14ef1b45 | FindButton 외 1 | FP00610_PlanResultValidation.cs:450 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-c4c46d29 | FindButton 외 1 | FP00610_PlanResultValidation.cs:450 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c0d1138 | FindButton 외 1 | FP00610_PlanResultValidation.cs:467 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-612feaff | FindButton 외 1 | FP00610_PlanResultValidation.cs:468 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-813dd9ac | FindButton 외 1 | FP00610_PlanResultValidation.cs:469 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-9ec99303 | FindButton 외 1 | FP00610_PlanResultValidation.cs:474 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-e67e46d9 | FindButton 외 1 | FP00610_PlanResultValidation.cs:475 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-41fb69d1 | FindButton 외 1 | FP00610_PlanResultValidation.cs:494 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0c08b53 | FindButton 외 1 | FP00610_PlanResultValidation.cs:498 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-55fefa06 | FindButton 외 1 | FP00610_PlanResultValidation.cs:500 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e229b99f | FindButton 외 1 | FP00610_PlanResultValidation.cs:501 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-96cbb6a9 | FindButton 외 1 | FP00610_PlanResultValidation.cs:521 |  | UI_PROP | num2.DecimalPlaces | mRatio | 속성 DecimalPlaces 설정 |  |  |  |
| AC-ecd9daa1 | FindButton 외 1 | FP00610_PlanResultValidation.cs:522 |  | UI_PROP | num3.DecimalPlaces | mQTY | 속성 DecimalPlaces 설정 |  |  |  |
| AC-3bc5219c | FindButton 외 1 | FP00610_PlanResultValidation.cs:525 |  | GRID_SET | siMain.ActiveSheet.Columns[iCOMPLETE_QTY].CellType | num3 | 그리드 속성/값 설정 |  |  |  |
| AC-70fffe28 | FindButton 외 1 | FP00610_PlanResultValidation.cs:528 |  | GRID_SET | siMain.ActiveSheet.Columns[iCOMPLETE_RATIO].CellType | num2 | 그리드 속성/값 설정 |  |  |  |
| AC-760f7110 | FindButton 외 1 | FP00610_PlanResultValidation.cs:532 |  | GRID_SET | siMain.ActiveSheet.Columns[iUNPLAN_QTY].CellType | num3 | 그리드 속성/값 설정 |  |  |  |
| AC-c9712bb6 | FindButton 외 1 | FP00610_PlanResultValidation.cs:535 |  | GRID_SET | siMain.ActiveSheet.Columns[iUNPLAN_RATIO].CellType | num2 | 그리드 속성/값 설정 |  |  |  |
| AC-cef05da4 | FindButton 외 1 | FP00610_PlanResultValidation.cs:538 |  | GRID_SET | siMain.ActiveSheet.Columns[iLATE_QTY].CellType | num3 | 그리드 속성/값 설정 |  |  |  |
| AC-43248470 | FindButton 외 1 | FP00610_PlanResultValidation.cs:541 |  | GRID_SET | siMain.ActiveSheet.Columns[iLATE_RATIO].CellType | num2 | 그리드 속성/값 설정 |  |  |  |
| AC-576e47f6 | FindButton 외 1 | FP00610_PlanResultValidation.cs:544 |  | GRID_SET | siMain.ActiveSheet.Columns[iWEEK_LATE_QTY].CellType | num3 | 그리드 속성/값 설정 |  |  |  |
| AC-5bb0e53f | FindButton 외 1 | FP00610_PlanResultValidation.cs:547 |  | GRID_SET | siMain.ActiveSheet.Columns[iWEEK_LATE_RATIO].CellType | num2 | 그리드 속성/값 설정 |  |  |  |
| AC-c1a4af0a | FindButton 외 1 | FP00610_PlanResultValidation.cs:551 |  | GRID_SET | siMain.ActiveSheet.Columns[iQTY].CellType | num3 | 그리드 속성/값 설정 |  |  |  |

