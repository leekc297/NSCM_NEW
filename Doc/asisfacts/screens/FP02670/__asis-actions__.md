# AS-IS 액션 대조표 — FP02670

> 원천: `Doc/asisfacts/screens/FP02670/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 212행 · 메서드 27 · 종류 FLAG 55 · DATA_OP 34 · RETURN 22 · MESSAGE 19 · UI_PROP 14 · COMBO_DATA 10 · LIST_REBIND 8 · CALL_EXT 7 · UI_MISC 6 · GRID_SET 6 · ENDPOINT 6 · GRID_INIT 5 · GRID_LOCK 5 · POPUP 4 · STATE 4 · VALIDATE 2 · EXCEL 1 · CALL_BASE 1 · THROW 1 · GRID_BIND 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 8


## FP02670_Slurry_Batch_Master.btnCopyGplm_Click

진입점: this.btnCopyGplm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00691a0e | this.btnCopyGplm.Click | FP02670_Slurry_Batch_Master.cs:1144 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b843d96f | this.btnCopyGplm.Click | FP02670_Slurry_Batch_Master.cs:1145 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-baca853a | this.btnCopyGplm.Click | FP02670_Slurry_Batch_Master.cs:1151 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33aeb474 | this.btnCopyGplm.Click | FP02670_Slurry_Batch_Master.cs:1156 | else of (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | (meg, "Copy", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-8e448e61 | this.btnCopyGplm.Click | FP02670_Slurry_Batch_Master.cs:1157 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageBox.Show(meg, "Copy", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02670_Slurry_Batch_Master.btnRecieveGplm_Click

진입점: this.btnRecieveGplm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e28be6d9 | this.btnRecieveGplm.Click | FP02670_Slurry_Batch_Master.cs:1170 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-78b8ca3a | this.btnRecieveGplm.Click | FP02670_Slurry_Batch_Master.cs:1171 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d038316 | this.btnRecieveGplm.Click | FP02670_Slurry_Batch_Master.cs:1177 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00e2e8f1 | this.btnRecieveGplm.Click | FP02670_Slurry_Batch_Master.cs:1182 | else of (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | (meg, "Recieve", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-533469fd | this.btnRecieveGplm.Click | FP02670_Slurry_Batch_Master.cs:1183 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageBox.Show(meg, "Recieve", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02670_Slurry_Batch_Master.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eedf8323 | this.btnSql.Click | FP02670_Slurry_Batch_Master.cs:393 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a1f4a21a | this.btnSql.Click | FP02670_Slurry_Batch_Master.cs:394 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-27ae8675 | this.btnSql.Click | FP02670_Slurry_Batch_Master.cs:396 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02670_SLURRY_BATCH_MASTER") | 데이터 객체 조작/조회 |  |  |  |
| AC-924a2ffe | this.btnSql.Click | FP02670_Slurry_Batch_Master.cs:397 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02670_Slurry_Batch_Master.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f173f1af | (진입점 미연결) | FP02670_Slurry_Batch_Master.cs:1022 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02670_Slurry_Batch_Master.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcfba739 | this.Load | FP02670_Slurry_Batch_Master.cs:287 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8ab9ca95 | this.Load | FP02670_Slurry_Batch_Master.cs:288 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4fb0446e | this.Load | FP02670_Slurry_Batch_Master.cs:289 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02670_Slurry_Batch_Master.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56bea70e | this.Load | FP02670_Slurry_Batch_Master.cs:149 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-10822874 | this.Load | FP02670_Slurry_Batch_Master.cs:150 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-871044c1 | this.Load | FP02670_Slurry_Batch_Master.cs:151 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-acb8a5e8 | this.Load | FP02670_Slurry_Batch_Master.cs:155 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3636726e | this.Load | FP02670_Slurry_Batch_Master.cs:156 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-db5e2a83 | this.Load | FP02670_Slurry_Batch_Master.cs:157 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02670_Slurry_Batch_Master.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f5d47ca | Dispose | FP02670_Slurry_Batch_Master.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02670_Slurry_Batch_Master.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9623f3ba | EditButton | FP02670_Slurry_Batch_Master.cs:331 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-31a0d57b | EditButton | FP02670_Slurry_Batch_Master.cs:334 | if (spdMain != null) | CALL_EXT | siMain.SwitchLockEx | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b78b4aa1 | EditButton | FP02670_Slurry_Batch_Master.cs:338 | if (spdMain != null) ▸ if (!blnEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.GPLM_BATC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f9960421 | EditButton | FP02670_Slurry_Batch_Master.cs:339 | if (spdMain != null) ▸ if (!blnEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LOT_SIZE_UOM), siMain.GetColumnIndex(DefColumns.LOT_SIZE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f656bcb8 | EditButton | FP02670_Slurry_Batch_Master.cs:340 | if (spdMain != null) ▸ if (!blnEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TAT_UOM), siMain.GetColumnIndex(DefColumns.TAT_UOM), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-154cb1a1 | EditButton | FP02670_Slurry_Batch_Master.cs:341 | if (spdMain != null) ▸ if (!blnEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PROD_VERSION_TYPE), siMain.GetColumnIndex(DefColumns.UPD… | 그리드 편집 잠금/해제 |  |  |  |
| AC-62396706 | EditButton | FP02670_Slurry_Batch_Master.cs:349 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-655245ac | EditButton | FP02670_Slurry_Batch_Master.cs:362 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-13d5acb3 | EditButton | FP02670_Slurry_Batch_Master.cs:363 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.DefaultBackColor | 그리드 속성/값 설정 |  |  |  |

## FP02670_Slurry_Batch_Master.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54ad8605 | ExcelButton | FP02670_Slurry_Batch_Master.cs:380 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP02670_Slurry_Batch_Master.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_MASTER")] / this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ try ▸ try ▸ lambda] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d91a5971 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:485 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pCompanyID = string.Empty; pDivisionID = CString.GetCheck… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b04552b2 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:489 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-dfaca310 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:490 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef890956 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:491 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-095ae6e7 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:492 | try ▸ lambda | FLAG | pFactoryID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b684dd31 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:493 | try ▸ lambda | FLAG | pOperationID | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-a26853fa | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:512 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02670_SLURRY_BATCH_MASTER") ⇒ FP_Master.PR_UI_FP02670_SLURRY_BATCH_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-01e82817 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:513 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-95291070 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:514 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-9b62fb2e | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:515 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-f3366541 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:516 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-57f524c7 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:518 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-03bc43b7 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:520 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-7c185d2b | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:521 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-b5f45a87 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:522 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-12aeeca1 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:523 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-ca2ee2e7 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:524 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-ed943eb9 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:525 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-560ab8e7 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:526 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-b1737212 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:528 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-60cc9ebb | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:530 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-101910e2 | popSql.OnSql [if (programID == "PR_UI_FP02670_SLURRY_BATCH_M… 외 4 | FP02670_Slurry_Batch_Master.cs:537 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02670_Slurry_Batch_Master.FindData

진입점: this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ try] / FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4fe2181 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:405 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9eb55b8e | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:409 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-0dab0c42 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:409 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-983e04b5 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:412 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f23ae2c6 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:413 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9326eb67 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:416 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-af69f30b | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:421 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-eef13b9f | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:428 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fbeb2d42 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:429 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-301d3fc6 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:438 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7e79c1ea | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:440 | try | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b4445df | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:441 | try | CALL_EXT | siMain.SetFormat | ("#,###.#####", 11, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57ce7f2b | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:442 | try | CALL_EXT | siMain.SetFormat | ("####-##-##", 17, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5eeed5aa | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:444 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7d2b85ec | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:447 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6f98a5bb | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:462 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-63ed2521 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 3 | FP02670_Slurry_Batch_Master.cs:463 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02670_Slurry_Batch_Master.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e35f802f | this.Load | FP02670_Slurry_Batch_Master.cs:128 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02670_Slurry_Batch_Master.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bd27ac1 | this.Load | FP02670_Slurry_Batch_Master.cs:164 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e5e4890 | this.Load | FP02670_Slurry_Batch_Master.cs:171 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5cdc101a | this.Load | FP02670_Slurry_Batch_Master.cs:172 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b7b2e4f5 | this.Load | FP02670_Slurry_Batch_Master.cs:174 |  | FLAG | dtYesNo | Data_FP.Common_FP(Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 화면 필드/플래그 변경 |  |  |  |
| AC-bd68b9ae | this.Load | FP02670_Slurry_Batch_Master.cs:174 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-240370e6 | this.Load | FP02670_Slurry_Batch_Master.cs:178 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-d67013fb | this.Load | FP02670_Slurry_Batch_Master.cs:178 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-18d8823c | this.Load | FP02670_Slurry_Batch_Master.cs:179 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f8432d12 | this.Load | FP02670_Slurry_Batch_Master.cs:181 |  | FLAG | dtCurDate | Data_FP.Common_FP(Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 화면 필드/플래그 변경 |  |  |  |
| AC-80ab533d | this.Load | FP02670_Slurry_Batch_Master.cs:181 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9aad62c0 | this.Load | FP02670_Slurry_Batch_Master.cs:183 |  | FLAG | sCurDate | (string)dtCurDate.Rows[0]["CUR_DATE"] | 화면 필드/플래그 변경 |  |  |  |
| AC-2bebacc2 | this.Load | FP02670_Slurry_Batch_Master.cs:184 |  | FLAG | sPlanDate | sCurDate.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-cc06bdb2 | this.Load | FP02670_Slurry_Batch_Master.cs:185 |  | FLAG | sPrevDate | sCurDate | 화면 필드/플래그 변경 |  |  |  |

## FP02670_Slurry_Batch_Master.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a250e0c3 | this.Load | FP02670_Slurry_Batch_Master.cs:266 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-6743e6e1 | this.Load | FP02670_Slurry_Batch_Master.cs:267 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-4c7a5aef | this.Load | FP02670_Slurry_Batch_Master.cs:268 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-73303c00 | this.Load | FP02670_Slurry_Batch_Master.cs:269 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d88f81c9 | this.Load | FP02670_Slurry_Batch_Master.cs:270 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02670_Slurry_Batch_Master.InitSpread

진입점: this.Load / this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ try ▸ try] / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fec1221 | this.Load 외 4 | FP02670_Slurry_Batch_Master.cs:296 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2919e8e0 | this.Load 외 4 | FP02670_Slurry_Batch_Master.cs:298 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-0ffa08cc | this.Load 외 4 | FP02670_Slurry_Batch_Master.cs:306 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns._GPLMCHK)].CellT… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-83d1d382 | this.Load 외 4 | FP02670_Slurry_Batch_Master.cs:307 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns._GPLMCHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-d908857d | this.Load 외 4 | FP02670_Slurry_Batch_Master.cs:308 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns._GPLMCHK)].Borde… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-764c6029 | this.Load 외 4 | FP02670_Slurry_Batch_Master.cs:312 |  | UI_PROP | col.MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 속성 MergePolicy 설정 |  |  |  |
| AC-2b3def8c | this.Load 외 4 | FP02670_Slurry_Batch_Master.cs:314 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02670_Slurry_Batch_Master.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-308cb9db | popSql.OnSql | FP02670_Slurry_Batch_Master.cs:1035 | if (programID == "PR_UI_FP02670_SLURRY_BATCH_MASTER") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-3d3651dd | popSql.OnSql | FP02670_Slurry_Batch_Master.cs:1038 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02670_Slurry_Batch_Master.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62cf99ad | SaveButton | FP02670_Slurry_Batch_Master.cs:543 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-580d407c | SaveButton | FP02670_Slurry_Batch_Master.cs:545 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1599ae14 | SaveButton | FP02670_Slurry_Batch_Master.cs:550 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25068ea8 | SaveButton | FP02670_Slurry_Batch_Master.cs:551 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82e88ce8 | SaveButton | FP02670_Slurry_Batch_Master.cs:554 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-47dec8a6 | SaveButton | FP02670_Slurry_Batch_Master.cs:561 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-5bedd4aa | SaveButton | FP02670_Slurry_Batch_Master.cs:563 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-14508393 | SaveButton | FP02670_Slurry_Batch_Master.cs:564 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13ef5e06 | SaveButton | FP02670_Slurry_Batch_Master.cs:569 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b4f0551f | SaveButton | FP02670_Slurry_Batch_Master.cs:574 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6b612d39 | SaveButton | FP02670_Slurry_Batch_Master.cs:583 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b432416 | SaveButton | FP02670_Slurry_Batch_Master.cs:587 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-73a988a3 | SaveButton | FP02670_Slurry_Batch_Master.cs:591 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-32e6b8e5 | SaveButton | FP02670_Slurry_Batch_Master.cs:592 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-faf2f6fe | SaveButton | FP02670_Slurry_Batch_Master.cs:596 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02670_Slurry_Batch_Master.Save_Data_Copy

진입점: this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f371953b | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:789 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c3234591 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:790 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db3b6061 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:793 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c316e9e2 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:818 | try ▸ if (AllCheck) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-80ef9a80 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:819 | try ▸ if (AllCheck) | MESSAGE | MessageHelper.GMessageBox | ("Please select Checkbox") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c78cc78a | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:821 | try ▸ if (AllCheck) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76da7dbc | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:826 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b560f35d | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:831 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-680e8960 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:840 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1df4a31 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:848 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c9639695 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:849 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2bb3232c | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… | FP02670_Slurry_Batch_Master.cs:853 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02670_Slurry_Batch_Master.Save_Data_Execute

진입점: this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67e6b7cf | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:654 | try ▸ if (sQueryType.Equals("MAIN")) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a189f6e4 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:698 | try ▸ else of (sQueryType.Equals("MAIN")) ▸ if (sQueryType.Equals("COPY")) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cd675911 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:739 | try ▸ if (iCount >= 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02670_SAVE") ⇒ FP_Master.PR_UI_FP02670_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-562b3317 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:740 | try ▸ if (iCount >= 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-367e793f | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:742 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-6cfbbc15 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:743 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-40b9dd41 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:744 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-125194b3 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:746 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e072c5f3 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:748 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-28c2fafe | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:749 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-878eeedf | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:750 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-039e166b | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:751 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-2f4de2bd | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:752 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-00b8b7b5 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:753 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-c1d84e7f | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:754 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a3bc0e1 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:755 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_batch_lot_size"] | p_batch_lot_size | 행/컬럼 값 대입 |  |  |  |
| AC-0d9c4b20 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:756 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_lot_size_uom"] | p_lot_size_uom | 행/컬럼 값 대입 |  |  |  |
| AC-09127922 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:757 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_tat"] | p_tat | 행/컬럼 값 대입 |  |  |  |
| AC-974f9df4 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:758 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_tat_uom"] | p_tat_uom | 행/컬럼 값 대입 |  |  |  |
| AC-6432cbde | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:759 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cda9a159 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:760 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_prod_version_type"] | p_prod_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-fe7e0f6c | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:761 | try ▸ if (iCount >= 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-a6f2e5e7 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:763 | try ▸ if (iCount >= 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-45a549da | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:764 | try ▸ if (iCount >= 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a7498a91 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:770 | try ▸ else of (iCount >= 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-3fd47987 | this.btnCopyGplm.Click [else of (siMain.IsLock(siMain.SheetN… 외 1 | FP02670_Slurry_Batch_Master.cs:776 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02670_Slurry_Batch_Master.Save_Data_Receive

진입점: this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9a9f07d | this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.She… | FP02670_Slurry_Batch_Master.cs:868 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bf2ad853 | this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.She… | FP02670_Slurry_Batch_Master.cs:869 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cfdaa2b3 | this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.She… | FP02670_Slurry_Batch_Master.cs:872 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cf4ba7b7 | this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.She… | FP02670_Slurry_Batch_Master.cs:886 | try | DATA_OP | Filter["USER_ID"] | "DEMO" | 행/컬럼 값 대입 |  |  |  |
| AC-a09fb11d | this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.She… | FP02670_Slurry_Batch_Master.cs:888 | try | ENDPOINT | DataService.FP_RunProcedure | ("FP02670_Slurry_Batch_Master", "execute_receive", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_receive] \| FP\Common… | 엔드포인트 호출 |  |  |  |
| AC-c0b814e3 | this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.She… | FP02670_Slurry_Batch_Master.cs:892 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0fc97eae | this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.She… | FP02670_Slurry_Batch_Master.cs:894 | try | MESSAGE | MessageHelper.GMessageBox | ("Saved.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-60be49e5 | this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.She… | FP02670_Slurry_Batch_Master.cs:918 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e8d7b6e2 | this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.She… | FP02670_Slurry_Batch_Master.cs:919 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d7437100 | this.btnRecieveGplm.Click [else of (siMain.IsLock(siMain.She… | FP02670_Slurry_Batch_Master.cs:923 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02670_Slurry_Batch_Master.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcfcca58 | SaveButton | FP02670_Slurry_Batch_Master.cs:385 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02670_Slurry_Batch_Master.Search_After

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9c825bf | (진입점 미연결) | FP02670_Slurry_Batch_Master.cs:962 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## FP02670_Slurry_Batch_Master.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4da43aa6 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:198 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c25dc8f | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:199 | if (argType == "DIVISION") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-363b997c | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:200 | if (argType == "DIVISION") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-1b5e40fd | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:200 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d20a97eb | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:201 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-781926c5 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:204 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3a24a30 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:205 | if (argType == "DIVISION") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-f4a66add | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:206 | if (argType == "DIVISION") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-1353b00f | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:206 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1e4ee496 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:207 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2c5fbec4 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:210 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2b9a6f7 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:211 | if (argType == "DIVISION") | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-b9fb229a | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:212 | if (argType == "DIVISION") | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-2ee3b0ed | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:212 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d5a2d6bd | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:213 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3188f9f9 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:216 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0c85b87 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:217 | if (argType == "DIVISION") | FLAG | pFactoryID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-da3b0a60 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:218 | if (argType == "DIVISION") | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-1e90baf3 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:218 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-18822780 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:222 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5647ae92 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:228 | else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad78339b | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:229 | else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-a2f1b419 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:230 | else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-eaf85b4f | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:230 | else of (argType == "DIVISION") ▸ if (argType == "SITE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a6850dd | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:231 | else of (argType == "DIVISION") ▸ if (argType == "SITE") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-33f1c0d7 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:238 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-413a9b79 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:239 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-7dc6fd34 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:240 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-41837373 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:240 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a1b76e5 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:241 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-177c77d8 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:247 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FACTORY") | FLAG | sDataID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b76051ab | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:248 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FACTORY") | FLAG | pFactoryID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-45afb8ea | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:249 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FACTORY") | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-4c97fcf5 | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:249 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FACTORY") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9176628b | this.Load 외 5 | FP02670_Slurry_Batch_Master.cs:253 | else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FACTORY") | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02670_Slurry_Batch_Master.SetFornt

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8eb53601 | (진입점 미연결) | FP02670_Slurry_Batch_Master.cs:1112 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a92aec24 | (진입점 미연결) | FP02670_Slurry_Batch_Master.cs:1120 | if (sFontFlag.Equals("Strikeout")) | UI_PROP | range1.Font | new System.Drawing.Font(fps.Font.Name, fps.Font.Size, FontStyle.Strikeout) | 속성 Font 설정 |  |  |  |
| AC-598c105c | (진입점 미연결) | FP02670_Slurry_Batch_Master.cs:1125 | if (sFontFlag.Equals("Regular")) | UI_PROP | range1.Font | new System.Drawing.Font(fps.Font.Name, fps.Font.Size, FontStyle.Regular) | 속성 Font 설정 |  |  |  |
| AC-b05646aa | (진입점 미연결) | FP02670_Slurry_Batch_Master.cs:1128 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02670_Slurry_Batch_Master.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d0776b1 | this.spdMain.CellClick | FP02670_Slurry_Batch_Master.cs:1060 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | CALL_EXT | siMain.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-be196920 | this.spdMain.CellClick | FP02670_Slurry_Batch_Master.cs:1071 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | CALL_EXT | siMain.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-59a50bf4 | this.spdMain.CellClick | FP02670_Slurry_Batch_Master.cs:1073 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | GRID_SET | siMain.SetText | (i, 0, AllCheck.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d48f75c0 | this.spdMain.CellClick | FP02670_Slurry_Batch_Master.cs:1092 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), dtYesNo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## FP02670_Slurry_Batch_Master.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7da53bfd | this.spdMain.Change | FP02670_Slurry_Batch_Master.cs:1106 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("ACTIVE_FLAG")) | CALL_EXT | siMain.SetHAlign | (e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), e.Row, siMain.GetColumnIndex(DefCol… | ⚠ 의미 확인 필요 |  |  |  |

## FP02670_Slurry_Batch_Master.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bef64fe | this.spdMain.EditChange | FP02670_Slurry_Batch_Master.cs:1134 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

