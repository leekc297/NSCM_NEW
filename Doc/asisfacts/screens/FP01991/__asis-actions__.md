# AS-IS 액션 대조표 — FP01991

> 원천: `Doc/asisfacts/screens/FP01991/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 153행 · 메서드 34 · 종류 DATA_OP 27 · RETURN 24 · UI_PROP 19 · UI_MISC 14 · FLAG 12 · CALL_EXT 11 · MESSAGE 9 · GRID_INIT 8 · POPUP 6 · ENDPOINT 6 · GRID_LOCK 4 · GRID_SET 3 · VALUE_SET 2 · THROW 2 · LIST_REBIND 2 · STATE 2 · CALL_BASE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 12


## FP01991_ConfigSetting_SqlPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e834d5ba | this.btnClose.Click | FP01991_ConfigSetting_SqlPopup.cs:145 |  | FLAG | Changed | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fffead56 | this.btnClose.Click | FP01991_ConfigSetting_SqlPopup.cs:146 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01991_ConfigSetting_SqlPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a39fc3be | this.btnSave.Click | FP01991_ConfigSetting_SqlPopup.cs:168 |  | CALL_EXT | GSCM.App.Core.GAppSettings.GetLauncherType | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3190bb78 | this.btnSave.Click | FP01991_ConfigSetting_SqlPopup.cs:186 | try | UI_PROP | connection.ConnectionString | connectionString | 속성 ConnectionString 설정 |  |  |  |
| AC-3a944d70 | this.btnSave.Click | FP01991_ConfigSetting_SqlPopup.cs:188 | try | CALL_EXT | connection.Open | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bd99136 | this.btnSave.Click | FP01991_ConfigSetting_SqlPopup.cs:191 | try | UI_PROP | sqlComm.Connection | connection | 속성 Connection 설정 |  |  |  |
| AC-772000e0 | this.btnSave.Click | FP01991_ConfigSetting_SqlPopup.cs:193 | try | UI_PROP | sqlComm.CommandText | rtxtSQL.Text | 속성 CommandText 설정 |  |  |  |
| AC-95119ea1 | this.btnSave.Click | FP01991_ConfigSetting_SqlPopup.cs:195 | try | CALL_EXT | sqlComm.ExecuteReader | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-49d577fe | this.btnSave.Click | FP01991_ConfigSetting_SqlPopup.cs:202 | catch ((Exception)) | FLAG | ResultDB_SAVE | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d1b51b76 | this.btnSave.Click | FP01991_ConfigSetting_SqlPopup.cs:207 | finally | FLAG | Changed | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fb4e64b6 | this.btnSave.Click | FP01991_ConfigSetting_SqlPopup.cs:208 | finally | UI_MISC | connection.Close | () | 창 닫기/해제 |  |  |  |
| AC-0bd4f590 | this.btnSave.Click | FP01991_ConfigSetting_SqlPopup.cs:211 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01991_ConfigSetting_SqlPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efb8a9c8 | this.Load | FP01991_ConfigSetting_SqlPopup.cs:75 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01991_ConfigSetting_SqlPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e577f59 | Dispose | FP01991_ConfigSetting_SqlPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01991_ConfigSetting_SqlPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ca16a8a | this.Load | FP01991_ConfigSetting_SqlPopup.cs:58 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01991_ConfigSetting_SqlPopup.FPC0001_SqlPopup_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91a819b1 | this.Load | FP01991_ConfigSetting_SqlPopup.cs:158 |  | UI_PROP | btnClose.Left | (panel1.Width - btnClose.Width) / 2 | 속성 Left 설정 |  |  |  |

## FP01991_ConfigSetting_SqlPopup.panel1_SizeChanged

진입점: this.panel1.SizeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e68296ec | this.panel1.SizeChanged | FP01991_ConfigSetting_SqlPopup.cs:152 |  | UI_PROP | btnClose.Left | (panel1.Width - btnClose.Width) / 2 | 속성 Left 설정 |  |  |  |

## FP01991_ConfigSetting_SqlPopup.processDataset

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03dd6b34 | (진입점 미연결) | FP01991_ConfigSetting_SqlPopup.cs:133 | if (dt != null && dt.Tables != null && dt.Tables.Count > 0 && dt.Tables[0].Rows != null && dt.Tables[0].Rows.Count > 0) | VALUE_SET | rtxtSQL.Text | res | 컨트롤 값 설정 |  |  |  |

## FP01991_ConfigSetting..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d2e8d8c | .ctor | FP01991_ConfigSetting.cs:101 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP01991_ConfigSetting.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c42e3de5 | this.btnSql.Click | FP01991_ConfigSetting.cs:835 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-65d0cff1 | this.btnSql.Click | FP01991_ConfigSetting.cs:838 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8356ec31 | this.btnSql.Click | FP01991_ConfigSetting.cs:839 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0ad0ef48 | this.btnSql.Click | FP01991_ConfigSetting.cs:841 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01991_ConfigSetting") | 데이터 객체 조작/조회 |  |  |  |
| AC-b6ca6e88 | this.btnSql.Click | FP01991_ConfigSetting.cs:843 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01991_ConfigSetting.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-146922a1 | SaveButton [if (fps.Name == "spdMain")] | FP01991_ConfigSetting.cs:805 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sINSTANCE_ID == schkINSTANCE_ID && sCATEGORY_ID == schkCATEGORY_ID && sKEY_ID … | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-77fcc659 | SaveButton [if (fps.Name == "spdMain")] | FP01991_ConfigSetting.cs:806 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sINSTANCE_ID == schkINSTANCE_ID && sCATEGORY_ID == schkCATEGORY_ID && sKEY_ID … | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-83fcde2f | SaveButton [if (fps.Name == "spdMain")] | FP01991_ConfigSetting.cs:813 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-ff0284d7 | SaveButton [if (fps.Name == "spdMain")] | FP01991_ConfigSetting.cs:815 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP01991_ConfigSetting.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8900f52 | this.Load | FP01991_ConfigSetting.cs:159 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-23bc4454 | this.Load | FP01991_ConfigSetting.cs:160 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee880b6a | this.Load | FP01991_ConfigSetting.cs:165 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01991_ConfigSetting.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fefd5649 | DeleteButton | FP01991_ConfigSetting.cs:358 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30805d85 | DeleteButton | FP01991_ConfigSetting.cs:361 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP01991_ConfigSetting.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35ff8687 | Dispose | FP01991_ConfigSetting.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01991_ConfigSetting.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f96e6cd4 | EditButton | FP01991_ConfigSetting.cs:371 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-93adf94e | EditButton | FP01991_ConfigSetting.cs:372 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-814b883c | EditButton | FP01991_ConfigSetting.cs:374 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CONFIG_SET_ID), siMain.GetColumnIndex(DefColumns.CATEGOR… | 그리드 편집 잠금/해제 |  |  |  |

## FP01991_ConfigSetting.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fee0b3c8 | (진입점 미연결) | FP01991_ConfigSetting.cs:733 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f476d5db | (진입점 미연결) | FP01991_ConfigSetting.cs:741 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-192ace9d | (진입점 미연결) | FP01991_ConfigSetting.cs:745 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a94e4c15 | (진입점 미연결) | FP01991_ConfigSetting.cs:746 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1b0860bb | (진입점 미연결) | FP01991_ConfigSetting.cs:753 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-393dd052 | (진입점 미연결) | FP01991_ConfigSetting.cs:755 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## FP01991_ConfigSetting.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dab3536 | ExcelButton | FP01991_ConfigSetting.cs:213 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-179af500 | ExcelButton | FP01991_ConfigSetting.cs:214 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-a0e20365 | ExcelButton | FP01991_ConfigSetting.cs:216 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-192f083d | ExcelButton | FP01991_ConfigSetting.cs:220 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-434c655a | ExcelButton | FP01991_ConfigSetting.cs:221 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-34b0416f | ExcelButton | FP01991_ConfigSetting.cs:222 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-61ae5b4a | ExcelButton | FP01991_ConfigSetting.cs:225 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-df18b405 | ExcelButton | FP01991_ConfigSetting.cs:226 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-fd4554a1 | ExcelButton | FP01991_ConfigSetting.cs:227 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-6dd698ba | ExcelButton | FP01991_ConfigSetting.cs:229 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-71ccdba1 | ExcelButton | FP01991_ConfigSetting.cs:230 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-862238ad | ExcelButton | FP01991_ConfigSetting.cs:237 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cfee3ca8 | ExcelButton | FP01991_ConfigSetting.cs:241 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d8a2dd54 | ExcelButton | FP01991_ConfigSetting.cs:245 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01991_ConfigSetting.Find_Data_Amend

진입점: this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (popSql.Changed) ▸ try ▸ lambda] / popSql.OnSql [if (fps.Name == "spdMain")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0594f36c | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:581 | try | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4cf9fdf | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:583 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cboInstance.Text.ToUpper() != "ALL") { Filter["INSTAN… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e305d5f | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:587 | try ▸ lambda ▸ if (cboInstance.Text.ToUpper() != "ALL") | DATA_OP | Filter["INSTANCE_ID"] | cboInstance.Text | 행/컬럼 값 대입 |  |  |  |
| AC-2a0e3a54 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:592 | try ▸ lambda ▸ if (usrComboBox_Category.Text.ToUpper() != "ALL") | DATA_OP | Filter["CATEGORY_ID"] | usrComboBox_Category.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e98827be | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:597 | try ▸ lambda ▸ if (txtKeyType.Text.Length != 0) | DATA_OP | Filter["KEY_ID"] | txtKeyType.Text | 행/컬럼 값 대입 |  |  |  |
| AC-210312c5 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:602 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01991_ConfigSetting", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8e908ef1 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:603 | try | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f889b706 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:605 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-9fc561e3 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:609 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01991_ConfigSetting.Find_Data_Save

진입점: SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d188c083 | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP01991_ConfigSetting.cs:623 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01991_ConfigSetting", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f4c24c5a | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP01991_ConfigSetting.cs:625 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-2746bf27 | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP01991_ConfigSetting.cs:629 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01991_ConfigSetting.Find_Data_Save_INSERT_CHK

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ec9411f | (진입점 미연결) | FP01991_ConfigSetting.cs:639 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01991_ConfigSetting", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ab58d1e6 | (진입점 미연결) | FP01991_ConfigSetting.cs:643 | try ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "DUPLICITY") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9dd4ce65 | (진입점 미연결) | FP01991_ConfigSetting.cs:647 | try ▸ else of (dsResult.Tables[0].Rows[0][0].ToString() == "DUPLICITY") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-e1b7cd72 | (진입점 미연결) | FP01991_ConfigSetting.cs:654 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01991_ConfigSetting.Find_Data_Save_Sub

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6d4243c | (진입점 미연결) | FP01991_ConfigSetting.cs:669 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01991_ConfigSetting", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fcb02356 | (진입점 미연결) | FP01991_ConfigSetting.cs:671 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-66606235 | (진입점 미연결) | FP01991_ConfigSetting.cs:675 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01991_ConfigSetting.Find_Data_sub

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36474fed | (진입점 미연결) | FP01991_ConfigSetting.cs:683 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | mainLookupType.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-d8e4a616 | (진입점 미연결) | FP01991_ConfigSetting.cs:686 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01991_ConfigSetting", Filter, _CurrentUser, pSysType, "SELECT_MAIN_DETAIL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-445639e5 | (진입점 미연결) | FP01991_ConfigSetting.cs:688 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-2586a3f4 | (진입점 미연결) | FP01991_ConfigSetting.cs:692 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01991_ConfigSetting.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37c08346 | this.Load | FP01991_ConfigSetting.cs:114 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01991_ConfigSetting.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e03d3de9 | (진입점 미연결) | FP01991_ConfigSetting.cs:825 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP01991_ConfigSetting.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08d4f4bb | this.Load | FP01991_ConfigSetting.cs:150 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c93b62dd | this.Load | FP01991_ConfigSetting.cs:152 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategory, usrComboBox_Category, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4d58ee72 | this.Load | FP01991_ConfigSetting.cs:154 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01991_ConfigSetting.InitSpread

진입점: this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (popSql.Changed)] / this.Load / FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fdd31d7 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:178 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-479ad288 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:179 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-68c977a1 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:180 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f26da5de | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:184 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP01991_ConfigSetting.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c22bbcf | InsertButton | FP01991_ConfigSetting.cs:565 | if (fps.Name == "spdMain") | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f50c23c | InsertButton | FP01991_ConfigSetting.cs:570 | if (fps.Name == "spdMain") | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## FP01991_ConfigSetting.RefreshSpreadSheet

진입점: this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (popSql.Changed) ▸ try] / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc991782 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:346 |  | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e451dfc | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:347 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4fe21c41 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:348 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01991_ConfigSetting.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06cec326 | popSql.OnSql | FP01991_ConfigSetting.cs:850 | if (fps.Name == "spdMain") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-b1f04420 | popSql.OnSql | FP01991_ConfigSetting.cs:855 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01991_ConfigSetting.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a523e82a | SaveButton | FP01991_ConfigSetting.cs:467 | if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (sColmnText == "VALUE_TYP… | MESSAGE | MessageHelper.GMessageBox | ("MSG00023") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee4e0758 | SaveButton | FP01991_ConfigSetting.cs:476 | if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (sColmnText == "VALU… | MESSAGE | MessageHelper.GMessageBox | ("MSG00023") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4ae2ac9c | SaveButton | FP01991_ConfigSetting.cs:486 | if (fps.Name == "spdMain") ▸ if (!bFlag) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b9a87cc | SaveButton | FP01991_ConfigSetting.cs:490 | if (fps.Name == "spdMain") ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff921eff | SaveButton | FP01991_ConfigSetting.cs:492 | if (fps.Name == "spdMain") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-5eac8bbd | SaveButton | FP01991_ConfigSetting.cs:492 | if (fps.Name == "spdMain") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-053a60f5 | SaveButton | FP01991_ConfigSetting.cs:496 | if (fps.Name == "spdMain") | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2670fddb | SaveButton | FP01991_ConfigSetting.cs:497 | if (fps.Name == "spdMain") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e6a0e71 | SaveButton | FP01991_ConfigSetting.cs:510 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["INSTANCE_ID"] | siMain.GetValue(i, siMain.GetColumnIndex("INSTANCE_ID")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8a2b8e9f | SaveButton | FP01991_ConfigSetting.cs:511 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["CATEGORY_ID"] | siMain.GetValue(i, siMain.GetColumnIndex("CATEGORY_ID")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8155c001 | SaveButton | FP01991_ConfigSetting.cs:512 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["KEY_ID"] | siMain.GetValue(i, siMain.GetColumnIndex("KEY_ID")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0a53fbd7 | SaveButton | FP01991_ConfigSetting.cs:513 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["PART_ID"] | siMain.GetValue(i, siMain.GetColumnIndex("PART_ID")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b81e788c | SaveButton | FP01991_ConfigSetting.cs:514 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["KEY_VALUE"] | siMain.GetValue(i, siMain.GetColumnIndex("KEY_VALUE")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-89233bb7 | SaveButton | FP01991_ConfigSetting.cs:515 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["VALUE_TYPE"] | siMain.GetValue(i, siMain.GetColumnIndex("VALUE_TYPE")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b95eab6 | SaveButton | FP01991_ConfigSetting.cs:519 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex("KEY_PRIORITY")).ToString() =… | DATA_OP | SaveFilter["KEY_PRIORITY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-f028561e | SaveButton | FP01991_ConfigSetting.cs:521 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex("KEY_PRIORITY")).ToStrin… | DATA_OP | SaveFilter["KEY_PRIORITY"] | siMain.GetValue(i, siMain.GetColumnIndex("KEY_PRIORITY")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-43c1bc1b | SaveButton | FP01991_ConfigSetting.cs:524 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex("TOLERANCE")).ToString() == "… | DATA_OP | SaveFilter["TOLERANCE"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-cdd2c9fd | SaveButton | FP01991_ConfigSetting.cs:526 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex("TOLERANCE")).ToString()… | DATA_OP | SaveFilter["TOLERANCE"] | siMain.GetValue(i, siMain.GetColumnIndex("TOLERANCE")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-08f0fca3 | SaveButton | FP01991_ConfigSetting.cs:528 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["TOLERANCE_UOM"] | siMain.GetValue(i, siMain.GetColumnIndex("TOLERANCE_UOM")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-feb025db | SaveButton | FP01991_ConfigSetting.cs:529 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["VIEW_FLAG"] | siMain.GetValue(i, siMain.GetColumnIndex("VIEW_FLAG")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c3519568 | SaveButton | FP01991_ConfigSetting.cs:530 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["USE_YN"] | siMain.GetValue(i, siMain.GetColumnIndex("USE_YN")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6b280d15 | SaveButton | FP01991_ConfigSetting.cs:531 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["DESCRIPTION"] | siMain.GetValue(i, siMain.GetColumnIndex("DESCRIPTION")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4bf14f34 | SaveButton | FP01991_ConfigSetting.cs:533 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["OLD_KEY_ID"] | siMain.GetValue(i, siMain.GetColumnIndex("OLD_KEY_ID")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a28d3b76 | SaveButton | FP01991_ConfigSetting.cs:534 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["OLD_PART_ID"] | siMain.GetValue(i, siMain.GetColumnIndex("OLD_PART_ID")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6136b012 | SaveButton | FP01991_ConfigSetting.cs:535 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["OLD_KEY_VALUE"] | siMain.GetValue(i, siMain.GetColumnIndex("OLD_KEY_VALUE")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6613b7db | SaveButton | FP01991_ConfigSetting.cs:553 | if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { done.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01991_ConfigSetting.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d041b37a | this.Load | FP01991_ConfigSetting.cs:126 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e13d8ecb | this.Load | FP01991_ConfigSetting.cs:128 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-8f046b2b | this.Load | FP01991_ConfigSetting.cs:132 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-6a5429b6 | this.Load | FP01991_ConfigSetting.cs:135 |  | CALL_EXT | UserService.HasSuperRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b01fed27 | this.Load | FP01991_ConfigSetting.cs:137 | if (UserService.HasSuperRole(_CurrentUser)) | UI_PROP | layoutControlItem_SSQL.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-95b1dd35 | this.Load | FP01991_ConfigSetting.cs:141 | else of (UserService.HasSuperRole(_CurrentUser)) | UI_PROP | layoutControlItem_SSQL.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP01991_ConfigSetting.SetSpreadInit

진입점: this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (popSql.Changed) ▸ try] / this.Load [try] / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1c07fbd | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:193 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c8ab6ff | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:194 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-93b71fd6 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 3 | FP01991_ConfigSetting.cs:197 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01991_ConfigSetting.SuperRoleSQL_Click

진입점: this.SuperRoleSQL.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-360d6f67 | this.SuperRoleSQL.Click | FP01991_ConfigSetting.cs:863 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-091b7fc7 | this.SuperRoleSQL.Click | FP01991_ConfigSetting.cs:866 |  | POPUP | new FP01991_ConfigSetting_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-953e420b | this.SuperRoleSQL.Click | FP01991_ConfigSetting.cs:867 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d4e6982c | this.SuperRoleSQL.Click | FP01991_ConfigSetting.cs:871 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0968af4c | this.SuperRoleSQL.Click | FP01991_ConfigSetting.cs:882 | else of (popSql.ResultDB_SAVE) | MESSAGE | MessageHelper.GMessageBox | ("MSG00023") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01991_ConfigSetting.UIFindData

진입점: this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (popSql.Changed)] / FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3f11077 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:258 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de5ec758 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:259 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10b957c3 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:262 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-14eb9105 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:264 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-48f0c6d0 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:268 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cbc74c15 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:279 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1c6c9990 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:281 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-64f5a3e3 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:281 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2986667 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:295 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e5298a91 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:296 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0490a558 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:297 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-d582f265 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:302 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-742006c8 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:303 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-edf20a11 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:321 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-90918cce | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:326 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b85ab737 | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:327 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1ceddbdf | this.SuperRoleSQL.Click [if (popSql.ResultDB_SAVE) ▸ if (pop… 외 2 | FP01991_ConfigSetting.cs:329 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

