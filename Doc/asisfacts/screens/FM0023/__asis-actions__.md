# AS-IS 액션 대조표 — FM0023

> 원천: `Doc/asisfacts/screens/FM0023/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 449행 · 메서드 39 · 종류 DATA_OP 151 · RETURN 51 · FLAG 45 · UI_PROP 34 · MESSAGE 19 · POPUP 15 · LIST_REBIND 14 · GRID_INIT 14 · ENDPOINT 13 · VALUE_SET 13 · GRID_SET 12 · VALUE_CLEAR 11 · COMBO_DATA 10 · STATE 10 · UI_MISC 9 · GRID_LOCK 7 · VALIDATE 7 · THROW 6 · CALL_EXT 3 · GRID_BIND 2 · EXCEL 1 · CALL_BASE 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 4


## FM0023_Setup_Group.btnRefreshSetup_Click

진입점: this.btnRefreshSetup.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5fc8d6d | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:410 | try | MESSAGE | MessageBox.Show | ("Will you refresh to Setup Group?", "Confrim", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-38b39c4c | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:412 | try ▸ if (MessageBox.Show("Will you refresh to Setup Group?", "Confrim", MessageBoxButtons.YesNo) == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9ba7851 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:417 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0023_SETUP_GROUP") ⇒ FP_Master.PR_UI_FM0023_SETUP_GROUP | 엔드포인트 요청 생성 |  |  |  |
| AC-748f7422 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:418 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6c04b7fe | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:420 | try | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-89d5a59d | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:421 | try | DATA_OP | req.Parameters["p_sys_flag"] | "EXECUTE_INIT_SETUP" | 행/컬럼 값 대입 |  |  |  |
| AC-114714ee | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:422 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-da801426 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:423 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f3fbfe4e | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:424 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4b900e17 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:425 | try | DATA_OP | req.Parameters["p_division_id"] | pDivision.Equals("ALL") ? DBNull.Value : pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-da251609 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:426 | try | DATA_OP | req.Parameters["p_site_id"] | pSite.Equals("ALL") ? DBNull.Value : pSite | 행/컬럼 값 대입 |  |  |  |
| AC-7e6597f6 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:427 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65a19901 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:428 | try | DATA_OP | req.Parameters["p_operation_id"] | pOperation.Equals("ALL") ? DBNull.Value : pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-e7ead516 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:429 | try | DATA_OP | req.Parameters["p_setup_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c2d9452a | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:430 | try | DATA_OP | req.Parameters["p_setup_key_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a5aadaa3 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:431 | try | DATA_OP | req.Parameters["p_level"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-523ccc4e | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:432 | try | DATA_OP | req.Parameters["p_referance_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-88088cf8 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:433 | try | DATA_OP | req.Parameters["p_calculation"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2da117c5 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:434 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-442e4cee | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:435 | try | DATA_OP | req.Parameters["p_line_setup_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-da0aad84 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:436 | try | DATA_OP | req.Parameters["p_org_line_setup_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-05d14ebb | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:438 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aff4271f | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:444 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "1") | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a19547d9 | this.btnRefreshSetup.Click | FM0023_Setup_Group.cs:454 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0023_Setup_Group.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-054d5893 | this.btnSql.Click | FM0023_Setup_Group.cs:512 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-14328543 | this.btnSql.Click | FM0023_Setup_Group.cs:513 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-82133b67 | this.btnSql.Click | FM0023_Setup_Group.cs:515 |  | DATA_OP | popSql.Services.Add | ("SELECT_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad878c07 | this.btnSql.Click | FM0023_Setup_Group.cs:516 |  | DATA_OP | popSql.Services.Add | ("SELECT_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3476826 | this.btnSql.Click | FM0023_Setup_Group.cs:517 |  | DATA_OP | popSql.Services.Add | ("REFRESH_SETUP_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ad2a75c | this.btnSql.Click | FM0023_Setup_Group.cs:518 |  | DATA_OP | popSql.Services.Add | ("SAVE_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-335d51d5 | this.btnSql.Click | FM0023_Setup_Group.cs:519 |  | DATA_OP | popSql.Services.Add | ("SAVE_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-117135a1 | this.btnSql.Click | FM0023_Setup_Group.cs:520 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FM0023_Setup_Group.btnSubImport_Click

진입점: this.btnSubImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc8824a8 | this.btnSubImport.Click | FM0023_Setup_Group.cs:472 | try ▸ if (iClickRow < 0 \|\| siSub.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-028f4663 | this.btnSubImport.Click | FM0023_Setup_Group.cs:484 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-5c31ed91 | this.btnSubImport.Click | FM0023_Setup_Group.cs:487 | try | POPUP | new FPC0100_ExcelImportPopup | ("FPC0100", "SetupGroupImport", "FP_Master.PR_UI_FM0023_SETUP_GROUP_EXCEL", sParamsFilter,… | 팝업/폼 생성 |  |  |  |
| AC-fc36622b | this.btnSubImport.Click | FM0023_Setup_Group.cs:488 | try | UI_PROP | popImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ffd1e0a2 | this.btnSubImport.Click | FM0023_Setup_Group.cs:489 | try | POPUP | popImport.Show | () | 팝업/폼 열기 |  |  |  |
| AC-86c120ec | this.btnSubImport.Click | FM0023_Setup_Group.cs:497 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0023_Setup_Group.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10ef549c | cboSite.SelectedIndexChanged | FM0023_Setup_Group.cs:1142 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-77bbb665 | cboSite.SelectedIndexChanged | FM0023_Setup_Group.cs:1147 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ed86ddc | cboSite.SelectedIndexChanged | FM0023_Setup_Group.cs:1150 | try | FLAG | dtOperationByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-8ff1bfe6 | cboSite.SelectedIndexChanged | FM0023_Setup_Group.cs:1150 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b328b159 | cboSite.SelectedIndexChanged | FM0023_Setup_Group.cs:1151 | try | LIST_REBIND | clsCtrl.setListBox | (dtOperationByDivision, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6d7db7e7 | cboSite.SelectedIndexChanged | FM0023_Setup_Group.cs:1157 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0023_Setup_Group.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbe05208 | this.Load | FM0023_Setup_Group.cs:216 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d5738f0d | this.Load | FM0023_Setup_Group.cs:217 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4f0a6555 | this.Load | FM0023_Setup_Group.cs:220 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e501e07d | this.Load | FM0023_Setup_Group.cs:221 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-0de8a80d | this.Load | FM0023_Setup_Group.cs:224 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9dd5c44 | this.Load | FM0023_Setup_Group.cs:228 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FM0023_Setup_Group.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e876a115 | this.Load | FM0023_Setup_Group.cs:133 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-8e73bf01 | this.Load | FM0023_Setup_Group.cs:135 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a47cf0cf | this.Load | FM0023_Setup_Group.cs:136 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-429db927 | this.Load | FM0023_Setup_Group.cs:137 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FM0023_Setup_Group.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aae2eaa6 | DeleteButton | FM0023_Setup_Group.cs:368 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2634cbb4 | DeleteButton | FM0023_Setup_Group.cs:374 | if (fps.Name == "spdMain") ▸ if (spdMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79588a23 | DeleteButton | FM0023_Setup_Group.cs:378 | if (fps.Name == "spdMain") ▸ if (spdMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-48805e89 | DeleteButton | FM0023_Setup_Group.cs:385 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.Acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce66de98 | DeleteButton | FM0023_Setup_Group.cs:389 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FM0023_Setup_Group.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-374390e0 | Dispose | FM0023_Setup_Group.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FM0023_Setup_Group.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75180e58 | EditButton | FM0023_Setup_Group.cs:280 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fdad557e | EditButton | FM0023_Setup_Group.cs:286 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-28ad9ddf | EditButton | FM0023_Setup_Group.cs:287 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-3b068e9f | EditButton | FM0023_Setup_Group.cs:288 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.VALID_YN),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f59aa3b3 | EditButton | FM0023_Setup_Group.cs:291 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4a7d0e0a | EditButton | FM0023_Setup_Group.cs:292 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-9a9dd0ff | EditButton | FM0023_Setup_Group.cs:293 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.LockColumn | (0, siSub.GetColumnIndex(DefColumns.OPERATION_ID), true) | 그리드 편집 잠금/해제 |  |  |  |

## FM0023_Setup_Group.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-468a0f23 | ExcelButton | FM0023_Setup_Group.cs:546 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FM0023_Setup_Group.Find_Data_Main

진입점: this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "1") ▸ try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_MAIN")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00103f78 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:633 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivision = CString.GetCheckedListValue(dtM… | ⚠ 의미 확인 필요 |  |  |  |
| AC-856488fd | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:647 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0023_SETUP_GROUP") ⇒ FP_Master.PR_UI_FM0023_SETUP_GROUP | 엔드포인트 요청 생성 |  |  |  |
| AC-39911985 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:648 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-0d1f7022 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:649 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-cabfbf37 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:650 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-78fc5d99 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:651 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0f4541f1 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:653 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2558ab7a | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:654 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9033be51 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:655 | try | DATA_OP | request.Parameters["p_site_id"] | pSite.Equals("ALL") ? DBNull.Value : pSite | 행/컬럼 값 대입 |  |  |  |
| AC-2cdb29f2 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:656 | try | DATA_OP | request.Parameters["p_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d7ff0561 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:657 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperation.Equals("ALL") ? DBNull.Value : pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-2034d68e | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:658 | try | DATA_OP | request.Parameters["p_setup_category_id"] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-a9d08a88 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:659 | try | DATA_OP | request.Parameters["p_setup_key_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7152ba52 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:660 | try | DATA_OP | request.Parameters["p_level"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-be15f077 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:661 | try | DATA_OP | request.Parameters["p_referance_operation_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cf9d669a | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:662 | try | DATA_OP | request.Parameters["p_calculation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f2027366 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:663 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-40ac92be | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:664 | try | DATA_OP | request.Parameters["p_line_setup_group_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9a9c85fa | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:665 | try | DATA_OP | request.Parameters["p_org_line_setup_group_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6da89a8b | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:668 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b00a3453 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:670 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3bb8bd76 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:675 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-586e443f | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:679 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FM0023_Setup_Group.Find_Data_Sub

진입점: this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "1") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ try] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB")] / FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bf0daa5 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:750 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0023_SETUP_GROUP") ⇒ FP_Master.PR_UI_FM0023_SETUP_GROUP | 엔드포인트 요청 생성 |  |  |  |
| AC-1c9b0005 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:751 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-e7d71eea | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:752 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_SUB" | 행/컬럼 값 대입 |  |  |  |
| AC-449ec65b | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:753 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9fffa6c7 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:754 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5ea0ea7a | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:756 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c8ff05c3 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:757 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d3d0020a | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:758 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-4544a42e | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:759 | try | DATA_OP | request.Parameters["p_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-eb85c91b | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:760 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-3a8e0fe1 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:761 | try | DATA_OP | request.Parameters["p_setup_category_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cee87fd7 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:762 | try | DATA_OP | request.Parameters["p_setup_key_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c50928b0 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:763 | try | DATA_OP | request.Parameters["p_level"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-13f15308 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:764 | try | DATA_OP | request.Parameters["p_referance_operation_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-42f23221 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:765 | try | DATA_OP | request.Parameters["p_calculation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d7fa6fa3 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:766 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5991f049 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:767 | try | DATA_OP | request.Parameters["p_line_setup_group_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b718f967 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:768 | try | DATA_OP | request.Parameters["p_org_line_setup_group_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f870d214 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:770 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f104f2b | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:772 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1cfb1f12 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 3 | FM0023_Setup_Group.cs:777 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0023_Setup_Group.Find_Main

진입점: this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "1")] / FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff6da825 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:555 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ca7f1769 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:559 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fb641a8 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:562 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-1910eb34 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:562 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c2062f6 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:568 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-79bb4003 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:571 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ced3aef2 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:577 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fb910a33 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:578 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Main("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c4beed1a | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:597 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8d32f388 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:599 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a75cf96 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:602 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7ecab03b | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:605 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f2165a27 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:613 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-c8e63132 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:620 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f07c7a9e | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:622 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0f4ffbf9 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:622 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FM0023_Setup_Group.Find_Sub

진입점: this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "1") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad546afd | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:686 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a17e05ad | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:700 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9f09ae7 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:711 | try | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e3b25bb5 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:716 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7576c0f0 | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:724 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-be296a5d | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:737 | finally | GRID_SET | this.spdSub.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-446e485a | this.btnRefreshSetup.Click [try ▸ if (ds.Tables[0].Rows[0][0… 외 2 | FM0023_Setup_Group.cs:737 | finally | CALL_EXT | this.spdSub.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FM0023_Setup_Group.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9120951 | this.Load | FM0023_Setup_Group.cs:110 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FM0023_Setup_Group.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a90f105 | this.Load | FM0023_Setup_Group.cs:146 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-994af931 | this.Load | FM0023_Setup_Group.cs:152 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0b56c803 | this.Load | FM0023_Setup_Group.cs:153 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9922a5f1 | this.Load | FM0023_Setup_Group.cs:156 | try | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-b88e4aef | this.Load | FM0023_Setup_Group.cs:156 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac0ff263 | this.Load | FM0023_Setup_Group.cs:157 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-e8e176a8 | this.Load | FM0023_Setup_Group.cs:160 | try | FLAG | dtCategory | DataCommon.GetUserFormCodeData(_FormProcedure, "FM0023_find_FilterCategory") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-56319298 | this.Load | FM0023_Setup_Group.cs:160 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FM0023_find_FilterCategory") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e8312ad2 | this.Load | FM0023_Setup_Group.cs:161 | try | LIST_REBIND | clsCtrl.setListBox | (dtCategory, cboCategory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-53a95eb1 | this.Load | FM0023_Setup_Group.cs:170 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2423678f | this.Load | FM0023_Setup_Group.cs:171 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-48373430 | this.Load | FM0023_Setup_Group.cs:172 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fe6eeeec | this.Load | FM0023_Setup_Group.cs:178 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0023_Setup_Group.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11f046c6 | this.Load | FM0023_Setup_Group.cs:235 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-57439ecc | this.Load | FM0023_Setup_Group.cs:238 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-03b2ea8d | this.Load | FM0023_Setup_Group.cs:243 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7d196a34 | this.Load | FM0023_Setup_Group.cs:246 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7ea470a7 | this.Load | FM0023_Setup_Group.cs:247 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.VALID_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-67b1d263 | this.Load | FM0023_Setup_Group.cs:252 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a09cf6ca | this.Load | FM0023_Setup_Group.cs:255 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-cee145be | this.Load | FM0023_Setup_Group.cs:257 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, siSub.GetColumnIndex(DefColumns.VALID_YN)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-610c28c2 | this.Load | FM0023_Setup_Group.cs:260 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e1ef2dc5 | this.Load | FM0023_Setup_Group.cs:261 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.VALID_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FM0023_Setup_Group.Insert_Row_Sub

진입점: InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cc7290f | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FM0023_Setup_Group.cs:529 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fdc3fb1a | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FM0023_Setup_Group.cs:536 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.OPERATION_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-21a7f141 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FM0023_Setup_Group.cs:539 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.COMPANY_ID), siSub.GetColumnIndex(DefColumns.PLA… | 그리드 편집 잠금/해제 |  |  |  |

## FM0023_Setup_Group.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85b5e915 | InsertButton | FM0023_Setup_Group.cs:323 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b6103b3 | InsertButton | FM0023_Setup_Group.cs:340 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-876f946c | InsertButton | FM0023_Setup_Group.cs:344 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | POPUP | new FM0023_SetupGroupAddPopup | (pDivision, pSite, pOperation) | 팝업/폼 생성 |  |  |  |
| AC-190cbd63 | InsertButton | FM0023_Setup_Group.cs:345 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | UI_PROP | popSetupAdd.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ef416953 | InsertButton | FM0023_Setup_Group.cs:346 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | POPUP | popSetupAdd.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a23208ce | InsertButton | FM0023_Setup_Group.cs:354 | try ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52cf49b9 | InsertButton | FM0023_Setup_Group.cs:362 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0023_Setup_Group.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3acb4f5 | popSql.OnSql | FM0023_Setup_Group.cs:1263 | if (programID == "SELECT_MAIN") | RETURN | return Find_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-805ea92d | popSql.OnSql | FM0023_Setup_Group.cs:1272 | else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB") | RETURN | return Find_Data_Sub("SQL", pDivision, pSite, pOperation); |  | 처리 중단/반환 |  |  |  |
| AC-1e667ad4 | popSql.OnSql | FM0023_Setup_Group.cs:1283 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c54b052c | popSql.OnSql | FM0023_Setup_Group.cs:1284 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_UF_ITEM_SETUP_RENEW ") | 데이터 객체 조작/조회 |  |  |  |
| AC-892cda81 | popSql.OnSql | FM0023_Setup_Group.cs:1286 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-772c0caf | popSql.OnSql | FM0023_Setup_Group.cs:1288 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-b67b8800 | popSql.OnSql | FM0023_Setup_Group.cs:1293 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ if (programID ==… | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-4f6c565c | popSql.OnSql | FM0023_Setup_Group.cs:1293 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ if (programID ==… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-541f715e | popSql.OnSql | FM0023_Setup_Group.cs:1294 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ if (programID ==… | RETURN | return Save_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-8eed9d15 | popSql.OnSql | FM0023_Setup_Group.cs:1299 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ else of (program… | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-98b73997 | popSql.OnSql | FM0023_Setup_Group.cs:1299 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ else of (program… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-3784b87b | popSql.OnSql | FM0023_Setup_Group.cs:1300 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ else of (program… | RETURN | return Save_Data_Sub("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-d1b75f8e | popSql.OnSql | FM0023_Setup_Group.cs:1303 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0023_Setup_Group.Save_Data_Main

진입점: popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ if (programID == "SAVE_MAIN")] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a01faee | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:905 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0023_SETUP_GROUP") ⇒ FP_Master.PR_UI_FM0023_SETUP_GROUP | 엔드포인트 요청 생성 |  |  |  |
| AC-031649f3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:906 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6e3528c5 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:908 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d32ca987 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:909 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c3b8359d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:910 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-4acefdb1 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:911 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-bb94eeaf | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:912 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-888c5647 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:913 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-11d79a7e | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:914 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-59a3021d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:915 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-3388f4d2 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:916 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-69ee00c5 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:917 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_setup_category_id"] | p_setup_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-61145f3f | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:918 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_setup_key_id"] | p_setup_key_id | 행/컬럼 값 대입 |  |  |  |
| AC-e6738bd2 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:919 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level"] | p_level | 행/컬럼 값 대입 |  |  |  |
| AC-8a9acac0 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:920 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_referance_operation_id"] | p_referance_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-50a2c34c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:921 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_calculation"] | p_calculation | 행/컬럼 값 대입 |  |  |  |
| AC-3eecb1df | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:922 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-e9b9d68f | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:923 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_setup_group_id"] | p_line_setup_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-1e30bbc2 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:924 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_line_setup_group_id"] | p_org_line_setup_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-8fd8794e | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:928 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a7dc9aa | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:929 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e0c92587 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:935 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-817166d2 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:941 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0023_Setup_Group.Save_Data_Sub

진입점: popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ else of (programID == "SAVE_MAIN") ▸ if (programID == "SAVE_SUB")] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f02512c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1082 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0023_SETUP_GROUP") ⇒ FP_Master.PR_UI_FM0023_SETUP_GROUP | 엔드포인트 요청 생성 |  |  |  |
| AC-7de84e8c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1083 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-623a6bf7 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1085 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-9865be43 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1086 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-15a2c78a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1087 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-1e06d4e0 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1088 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-47a47e6c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1089 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-1745e82c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1090 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8c863939 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1091 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-53fe9882 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1092 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-4a31046a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1093 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-d62b4a2a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1094 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_setup_category_id"] | p_setup_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-620ef530 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1095 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_setup_key_id"] | p_setup_key_id | 행/컬럼 값 대입 |  |  |  |
| AC-dcd6506a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1096 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level"] | p_level | 행/컬럼 값 대입 |  |  |  |
| AC-f369f232 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1097 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_referance_operation_id"] | p_referance_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-04dcabee | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1098 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_calculation"] | p_calculation | 행/컬럼 값 대입 |  |  |  |
| AC-8819f169 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1099 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-cda0a66e | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1100 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_setup_group_id"] | p_line_setup_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-351a7055 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1101 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_line_setup_group_id"] | p_org_line_setup_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-babe47ec | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1103 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-315b3254 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1104 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d395b684 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1110 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a7ff5ab2 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0023_Setup_Group.cs:1116 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0023_Setup_Group.Save_Main

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7387d997 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:784 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-fd8b6c7b | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:784 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63632168 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:786 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e55d3e60 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:788 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-782bd999 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:793 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-529f733a | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:794 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2dd5add9 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:797 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0fda21ba | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:804 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-fc875964 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:806 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1161d876 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:807 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee0ecd69 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:812 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2368defe | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:817 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4b872acb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:826 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f40e5bb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:830 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-858266d0 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:834 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9e07c16b | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:835 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-61c55b59 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:840 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3d64d9aa | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0023_Setup_Group.cs:841 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FM0023_Setup_Group.Save_Sub

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4370266e | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:947 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-f4589055 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:947 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8105819 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:949 | if (siSub == null \|\| siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c2602ea | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:951 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52e487cc | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:956 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1bcd81e0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:957 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8bcd250c | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:960 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c50315ee | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:967 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-b2507629 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:969 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3569eb3c | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:970 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24330f32 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:975 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b68a0006 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:980 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a65cd982 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:994 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97a8790d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:998 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1f5e35b7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:1002 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-822168dc | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:1003 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd7d749a | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:1008 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5e59c566 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0023_Setup_Group.cs:1009 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FM0023_Setup_Group.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edf17942 | SaveButton | FM0023_Setup_Group.cs:303 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FM0023_Setup_Group.SetChangedControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c4e71b7 | this.Load [try] 외 1 | FM0023_Setup_Group.cs:196 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-aab38e6f | this.Load [try] 외 1 | FM0023_Setup_Group.cs:198 | try | FLAG | dtSiteByDivision | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-c6004e2e | this.Load [try] 외 1 | FM0023_Setup_Group.cs:198 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", "", "", "", pDivisi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-af3300a2 | this.Load [try] 외 1 | FM0023_Setup_Group.cs:199 | try | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a7c877f2 | this.Load [try] 외 1 | FM0023_Setup_Group.cs:203 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-09dac926 | this.Load [try] 외 1 | FM0023_Setup_Group.cs:205 | try | FLAG | dtOperationByDivision | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-a8dd9f4c | this.Load [try] 외 1 | FM0023_Setup_Group.cs:205 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c8df200e | this.Load [try] 외 1 | FM0023_Setup_Group.cs:206 | try | LIST_REBIND | clsCtrl.setListBox | (dtOperationByDivision, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FM0023_Setup_Group.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bae68fb0 | this.spdMain.CellDoubleClick | FM0023_Setup_Group.cs:1230 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-8603e277 | this.spdMain.CellDoubleClick | FM0023_Setup_Group.cs:1231 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e899594 | this.spdMain.CellDoubleClick | FM0023_Setup_Group.cs:1241 |  | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FM0023_Setup_Group.spdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f6f7663 | this.spdSub.CellClick | FM0023_Setup_Group.cs:1179 | try ▸ if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71e85916 | this.spdSub.CellClick | FM0023_Setup_Group.cs:1181 | try ▸ if ((siSub.ActiveSheet.Rows.Count <= 0) \|\| siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-055edf13 | this.spdSub.CellClick | FM0023_Setup_Group.cs:1196 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | POPUP | new FPC0025_WorkCenterOperationPopup | ("WorkCenterOperationFactory", sSite, "", false) | 팝업/폼 생성 |  |  |  |
| AC-0fa65a3c | this.spdSub.CellClick | FM0023_Setup_Group.cs:1197 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6f908aa3 | this.spdSub.CellClick | FM0023_Setup_Group.cs:1198 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4f62b22b | this.spdSub.CellClick | FM0023_Setup_Group.cs:1210 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.COMPANY_ID), sCompany) | 그리드 값 설정 |  |  |  |
| AC-354bf3aa | this.spdSub.CellClick | FM0023_Setup_Group.cs:1211 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-9064cc55 | this.spdSub.CellClick | FM0023_Setup_Group.cs:1212 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-1b2186c6 | this.spdSub.CellClick | FM0023_Setup_Group.cs:1213 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PLANT_ID), sPlant) | 그리드 값 설정 |  |  |  |
| AC-ec14d66c | this.spdSub.CellClick | FM0023_Setup_Group.cs:1214 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID), sOperation) | 그리드 값 설정 |  |  |  |
| AC-a40ebe1c | this.spdSub.CellClick | FM0023_Setup_Group.cs:1223 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0023_SetupGroupAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b901cc70 | .ctor | FM0023_SetupGroupAddPopup.cs:80 |  | FLAG | this._sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-887a70a8 | .ctor | FM0023_SetupGroupAddPopup.cs:81 |  | FLAG | this._sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-61ec04b4 | .ctor | FM0023_SetupGroupAddPopup.cs:82 |  | FLAG | this._sOperation | pOperation | 화면 필드/플래그 변경 |  |  |  |

## FM0023_SetupGroupAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00f7a254 | this.btnClose.Click | FM0023_SetupGroupAddPopup.cs:172 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FM0023_SetupGroupAddPopup.btnSearchOperation_Click

진입점: this.btnSearchOperation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-336390fb | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:185 |  | POPUP | new FPC0002_OperationPopup | (bFilterEnable, bMultiSelect, "All", _sSite) | 팝업/폼 생성 |  |  |  |
| AC-3b80240d | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:186 |  | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-db9eaa24 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:187 |  | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50f193e3 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:191 | if (popOperation.DialogResult == DialogResult.OK) | FLAG | _sCompany | popOperation._CompanyId | 화면 필드/플래그 변경 |  |  |  |
| AC-4bbe83ae | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:192 | if (popOperation.DialogResult == DialogResult.OK) | FLAG | _sPlant | popOperation._PlantId | 화면 필드/플래그 변경 |  |  |  |
| AC-e0ebc730 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:193 | if (popOperation.DialogResult == DialogResult.OK) | FLAG | _sOperationGroup | popOperation._OperationGroupId | 화면 필드/플래그 변경 |  |  |  |
| AC-c63de325 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:199 | if (popOperation.DialogResult == DialogResult.OK) | VALUE_SET | txtDivision.Text | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-932b6979 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:200 | if (popOperation.DialogResult == DialogResult.OK) | VALUE_SET | txtSite.Text | sSite | 컨트롤 값 설정 |  |  |  |
| AC-0b1e19a7 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:201 | if (popOperation.DialogResult == DialogResult.OK) | VALUE_SET | txtOperation.Text | sOperation | 컨트롤 값 설정 |  |  |  |
| AC-638066cc | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:203 | if (popOperation.DialogResult == DialogResult.OK) | FLAG | dtLevelKey | DataCommon.GetMasterFormCodeData(_FormProcedure, "FM0023_findKey") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-e22ebb7b | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:203 | if (popOperation.DialogResult == DialogResult.OK) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FM0023_findKey") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8f8c4237 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:210 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) | DATA_OP | dtLevelKey.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c57576f4 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:219 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) | DATA_OP | dRow.Field | ("OPERATION_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ecc887ed | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:225 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ foreach (var row in distinctR… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString(), row.col4.ToString(), row.c… | 데이터 객체 조작/조회 |  |  |  |
| AC-a932a706 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:231 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ if (dtResult.Rows.Count ==0) | VALUE_CLEAR | cboClass.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-5bbafe00 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:235 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ else of (dtResult.Rows.Count … | DATA_OP | dtResult.Rows.Add | ("-", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-7fb59aa9 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:236 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ else of (dtResult.Rows.Count … | LIST_REBIND | clsCtrl.setListBox | (dtResult, cboClass, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7f649c81 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:237 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ else of (dtResult.Rows.Count … | VALUE_SET | cboClass.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |
| AC-f96eb948 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:238 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ else of (dtResult.Rows.Count … | FLAG | dtLevelKey | dtResult.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-90e415fd | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:238 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ else of (dtResult.Rows.Count … | DATA_OP | dtResult.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f4d61f0 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:243 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ else of (dtLevelKey.Rows.Count > 0) | VALUE_CLEAR | cboClass.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-4d04d38d | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:252 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c0aedce | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:253 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-052e3783 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:255 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2aa5664 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:255 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7dc33560 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:256 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-72732c19 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:256 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dRow.Field | ("OPERATION_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cac275cf | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:261 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) ▸ foreach (var row in di… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7e32ab7 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:264 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dtResult.Rows.Add | ("-", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-b12f767c | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:265 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | LIST_REBIND | clsCtrl.setListBox | (dtResult, cboRefOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0604dd14 | this.btnSearchOperation.Click | FM0023_SetupGroupAddPopup.cs:266 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | VALUE_SET | cboRefOperation.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |

## FM0023_SetupGroupAddPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c911f4e | this.btnSql.Click | FM0023_SetupGroupAddPopup.cs:275 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-78e7540f | this.btnSql.Click | FM0023_SetupGroupAddPopup.cs:276 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-518e9eb6 | this.btnSql.Click | FM0023_SetupGroupAddPopup.cs:278 |  | DATA_OP | popSql.Services.Add | ("SETUP_GROUP_ADD") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f448c4d | this.btnSql.Click | FM0023_SetupGroupAddPopup.cs:279 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FM0023_SetupGroupAddPopup.cboCategory_SelectionChangeCommitted

진입점: this.cboCategory.SelectionChangeCommitted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf6d5bd5 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:426 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | lbltxtClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-018fd346 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:427 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | lblcboClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-47e17214 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:428 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | lbltxtRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0a580b0d | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:429 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-12f75beb | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:431 | if (sValue == "Item" \|\| sValue == "Jig") | VALUE_SET | txtClass.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-96b43d4f | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:432 | if (sValue == "Item" \|\| sValue == "Jig") | VALUE_SET | txtRefOperation.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-85510173 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:434 | if (sValue == "Item" \|\| sValue == "Jig") | STATE | txtClass.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-780d2cd4 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:435 | if (sValue == "Item" \|\| sValue == "Jig") | STATE | txtRefOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dc84671c | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:441 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | lbltxtClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c7e39e22 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:442 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | lblcboClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ae757adf | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:443 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | lbltxtRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9c74599f | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:444 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3c3d6c8c | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:449 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | DATA_OP | dtLevelKey.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-51c86a16 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:458 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | DATA_OP | dRow.Field | ("OPERATION_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a8026e4 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:463 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString(), row.col4.ToString(), row.c… | 데이터 객체 조작/조회 |  |  |  |
| AC-370869af | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:466 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | LIST_REBIND | clsCtrl.setListBox | (dtResult, cboClass, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f2bf1211 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:467 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | VALUE_CLEAR | cboClass.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-025ac93b | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:468 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | FLAG | dtLevelKey | dtResult.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-453da224 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:468 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | DATA_OP | dtResult.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5d632dab | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:474 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtLevelKey.Rows.Count == 0) | DATA_OP | dtResult2.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0a7cd57 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:475 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtLevelKey.Rows.Count == 0) | DATA_OP | dtResult2.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c87dcb0 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:476 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtLevelKey.Rows.Count == 0) | DATA_OP | dtResult2.Rows.Add | ("-", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e60085b | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:477 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtLevelKey.Rows.Count == 0) | LIST_REBIND | clsCtrl.setListBox | (dtResult2, cboRefOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-de3cc67b | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:478 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtLevelKey.Rows.Count == 0) | VALUE_SET | cboRefOperation.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |
| AC-c8fcbac1 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:480 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtLevelKey.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Class List" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1effcd83 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:491 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtLevelKey.Rows.Count == 0) | DATA_OP | dtResult2.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b436f9b5 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:492 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtLevelKey.Rows.Count == 0) | DATA_OP | dtResult2.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8e1d119 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:496 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtLevelKey.Rows.Count == 0) | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-51b72b64 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:496 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtLevelKey.Rows.Count == 0) | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b069e66 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:497 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtLevelKey.Rows.Count == 0) | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-57483424 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:497 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtLevelKey.Rows.Count == 0) | DATA_OP | dRow.Field | ("OPERATION_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d193ce95 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:502 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtLevelKey.Rows.Count == 0) ▸ foreach (var row in dis… | DATA_OP | dtResult2.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9fed207 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:506 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtLevelKey.Rows.Count == 0) | DATA_OP | dtResult2.Rows.Add | ("-", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-eba72597 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:507 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtLevelKey.Rows.Count == 0) | LIST_REBIND | clsCtrl.setListBox | (dtResult2, cboRefOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4269088d | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:508 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtLevelKey.Rows.Count == 0) | VALUE_SET | cboRefOperation.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |
| AC-28abd939 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:514 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") >= 0) | UI_PROP | lbltxtClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-bf96a414 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:515 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") >= 0) | UI_PROP | lblcboClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f77503e9 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:516 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") >= 0) | UI_PROP | lbltxtRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d349e864 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:517 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") >= 0) | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fa7dd601 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:519 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") >= 0) | VALUE_SET | txtClass.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-860d0cc1 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:520 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") >= 0) | VALUE_SET | txtRefOperation.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-77e62d87 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:522 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") >= 0) | STATE | txtClass.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b42e3b32 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:523 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") >= 0) | STATE | txtRefOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7bbf4214 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:529 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") >= 0) | UI_PROP | lbltxtClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d63c64e4 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:530 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") >= 0) | UI_PROP | lblcboClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-621389a8 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:531 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") >= 0) | UI_PROP | lbltxtRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e6873349 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:532 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") >= 0) | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4a56f75f | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:535 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") >= 0) | VALUE_SET | txtClass.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-5a865129 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:536 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") >= 0) | VALUE_SET | txtRefOperation.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-c2f6bc57 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:538 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") >= 0) | STATE | txtClass.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-53d3cc05 | this.cboCategory.SelectionChangeCommitted | FM0023_SetupGroupAddPopup.cs:539 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") >= 0) | STATE | txtRefOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FM0023_SetupGroupAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77430f21 | Dispose | FM0023_SetupGroupAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FM0023_SetupGroupAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e253416d | this.Load | FM0023_SetupGroupAddPopup.cs:92 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d80039b | this.Load | FM0023_SetupGroupAddPopup.cs:94 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FM0023_SetupGroupAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f6a6fca | this.Load | FM0023_SetupGroupAddPopup.cs:109 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4535cdfb | this.Load | FM0023_SetupGroupAddPopup.cs:111 |  | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3fdf903 | this.Load | FM0023_SetupGroupAddPopup.cs:112 |  | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a2db6b8 | this.Load | FM0023_SetupGroupAddPopup.cs:116 |  | FLAG | dtCategory | DataCommon.GetMasterFormCodeData(_FormProcedure, "FM0023_find_FilterCategory") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b5450ade | this.Load | FM0023_SetupGroupAddPopup.cs:116 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FM0023_find_FilterCategory") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe11282d | this.Load | FM0023_SetupGroupAddPopup.cs:117 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategory, cboCategory, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f1dc007e | this.Load | FM0023_SetupGroupAddPopup.cs:118 |  | VALUE_CLEAR | cboCategory.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-b972bf01 | this.Load | FM0023_SetupGroupAddPopup.cs:121 |  | FLAG | dtLevelKey | DataCommon.GetMasterFormCodeData(_FormProcedure, "FM0023_findKey") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-28baab83 | this.Load | FM0023_SetupGroupAddPopup.cs:121 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FM0023_findKey") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7a3313e2 | this.Load | FM0023_SetupGroupAddPopup.cs:122 |  | LIST_REBIND | clsCtrl.setListBox | (dtLevelKey, cboClass, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-12a21e45 | this.Load | FM0023_SetupGroupAddPopup.cs:123 |  | VALUE_CLEAR | cboClass.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-3d16a3bd | this.Load | FM0023_SetupGroupAddPopup.cs:126 |  | FLAG | dtRefOperation | DataCommon.GetMasterFormCodeData(_FormProcedure, "FM0023_findRefOperation") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3930894a | this.Load | FM0023_SetupGroupAddPopup.cs:126 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FM0023_findRefOperation") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-34b0af4c | this.Load | FM0023_SetupGroupAddPopup.cs:127 |  | LIST_REBIND | clsCtrl.setListBox | (dtRefOperation, cboRefOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bdc35116 | this.Load | FM0023_SetupGroupAddPopup.cs:128 |  | VALUE_CLEAR | cboRefOperation.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-25391825 | this.Load | FM0023_SetupGroupAddPopup.cs:131 |  | FLAG | dtCalculation | DataCommon.GetMasterFormCodeData(_FormProcedure, "FM0023_findCalculation") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-e05d2c09 | this.Load | FM0023_SetupGroupAddPopup.cs:131 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FM0023_findCalculation") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb9c11d3 | this.Load | FM0023_SetupGroupAddPopup.cs:132 |  | LIST_REBIND | clsCtrl.setListBox | (dtCalculation, cboCalculation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4fbed782 | this.Load | FM0023_SetupGroupAddPopup.cs:133 |  | VALUE_CLEAR | cboCalculation.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-8b907278 | this.Load | FM0023_SetupGroupAddPopup.cs:135 |  | VALUE_CLEAR | txtDivision.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-048c6322 | this.Load | FM0023_SetupGroupAddPopup.cs:136 |  | VALUE_CLEAR | txtRefOperation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-841ae174 | this.Load | FM0023_SetupGroupAddPopup.cs:137 |  | VALUE_CLEAR | txtSite.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b1216ea6 | this.Load | FM0023_SetupGroupAddPopup.cs:138 |  | VALUE_CLEAR | txtClass.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-31f39a20 | this.Load | FM0023_SetupGroupAddPopup.cs:141 |  | UI_PROP | lblcboClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0d531945 | this.Load | FM0023_SetupGroupAddPopup.cs:142 |  | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6e3fcb0e | this.Load | FM0023_SetupGroupAddPopup.cs:150 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-57f9e3a5 | this.Load | FM0023_SetupGroupAddPopup.cs:151 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b1e76282 | this.Load | FM0023_SetupGroupAddPopup.cs:152 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FM0023_SetupGroupAddPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-233f7a2e | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:573 | if (programID == "SETUP_GROUP_ADD") ▸ if (txtSite.Text.ToString() == "" \|\| txtDivision.Text.ToString() == "" \|\| txtOperation.Text.ToStri… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Division, Site, Operation" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f50b3b1 | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:574 | if (programID == "SETUP_GROUP_ADD") ▸ if (txtSite.Text.ToString() == "" \|\| txtDivision.Text.ToString() == "" \|\| txtOperation.Text.ToStri… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-7d9e32f9 | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:578 | if (programID == "SETUP_GROUP_ADD") ▸ if (string.IsNullOrEmpty(p_setup_category_id.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Category" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5ffbd1cb | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:579 | if (programID == "SETUP_GROUP_ADD") ▸ if (string.IsNullOrEmpty(p_setup_category_id.ToString())) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-e12e1f14 | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:584 | if (programID == "SETUP_GROUP_ADD") ▸ if (string.IsNullOrEmpty(p_calculation.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Calculation" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7203737 | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:585 | if (programID == "SETUP_GROUP_ADD") ▸ if (string.IsNullOrEmpty(p_calculation.ToString())) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-82b04c0b | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:611 | if (programID == "SETUP_GROUP_ADD") | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd2f1620 | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:612 | if (programID == "SETUP_GROUP_ADD") | DATA_OP | dt.Rows.Add | ("EXEC PR_UI_FM0023_SETUP_GROUP " + "'" + p_company_id + "', " + "'" + p_division_id + "',… | 데이터 객체 조작/조회 |  |  |  |
| AC-d8c54748 | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:613 | if (programID == "SETUP_GROUP_ADD") | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e56172e | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:614 | if (programID == "SETUP_GROUP_ADD") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-9d63a019 | popSql.OnSql | FM0023_SetupGroupAddPopup.cs:617 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0023_SetupGroupAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ea6d2b8 | this.btnSave.Click | FM0023_SetupGroupAddPopup.cs:306 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "1") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f51d35d | this.btnSave.Click | FM0023_SetupGroupAddPopup.cs:311 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FM0023_SetupGroupAddPopup.Save_Data_Add

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f5f29c4 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:334 | if (txtSite.Text.ToString() == "" \|\| txtDivision.Text.ToString() == "" \|\| txtOperation.Text.ToString() == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Division, Site, Operation" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f24272b2 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:335 | if (txtSite.Text.ToString() == "" \|\| txtDivision.Text.ToString() == "" \|\| txtOperation.Text.ToString() == "") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-6cc62fe6 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:339 | if (string.IsNullOrEmpty(p_setup_category_id.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Category" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d033298 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:340 | if (string.IsNullOrEmpty(p_setup_category_id.ToString())) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-f9df77fe | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:345 | if (string.IsNullOrEmpty(p_calculation.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Calculation" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39da23cc | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:346 | if (string.IsNullOrEmpty(p_calculation.ToString())) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-5d39ef87 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:374 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0023_SETUP_GROUP") ⇒ FP_Master.PR_UI_FM0023_SETUP_GROUP | 엔드포인트 요청 생성 |  |  |  |
| AC-4c625df8 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:375 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2394f7ad | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:377 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-9edfcb11 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:378 | try | DATA_OP | req.Parameters["p_sys_flag"] | "EXECUTE_ADD" | 행/컬럼 값 대입 |  |  |  |
| AC-36565d4a | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:379 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5753af6 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:380 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6416b555 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:381 | try | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-67579afb | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:382 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f2a646c7 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:383 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-53aa6d75 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:384 | try | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-0630a906 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:385 | try | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-63e3fe28 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:386 | try | DATA_OP | req.Parameters["p_setup_category_id"] | p_setup_category_id.Equals("ALL") ? "-" : p_setup_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-84428e9c | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:387 | try | DATA_OP | req.Parameters["p_setup_key_id"] | p_setup_key_id.Equals("ALL") ? "-" : p_setup_key_id | 행/컬럼 값 대입 |  |  |  |
| AC-ec9ea4c5 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:388 | try | DATA_OP | req.Parameters["p_level"] | p_level | 행/컬럼 값 대입 |  |  |  |
| AC-b2ffc44e | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:389 | try | DATA_OP | req.Parameters["p_referance_operation_id"] | p_referance_operation_id.Equals("ALL") ? "-" : p_referance_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-18006b91 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:390 | try | DATA_OP | req.Parameters["p_calculation"] | p_calculation.Equals("ALL") ? "-" : p_calculation | 행/컬럼 값 대입 |  |  |  |
| AC-7e8c7025 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:391 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f8ee53e | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:392 | try | DATA_OP | req.Parameters["p_line_setup_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-202a9d6c | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:393 | try | DATA_OP | req.Parameters["p_org_line_setup_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7c9b7d88 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:395 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ecbf935 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:396 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5e7954b1 | this.btnSave.Click [try] | FM0023_SetupGroupAddPopup.cs:402 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

