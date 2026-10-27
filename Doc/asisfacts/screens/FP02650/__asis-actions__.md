# AS-IS 액션 대조표 — FP02650

> 원천: `Doc/asisfacts/screens/FP02650/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 523행 · 메서드 33 · 종류 DATA_OP 271 · RETURN 60 · FLAG 56 · GRID_SET 22 · GRID_INIT 14 · ENDPOINT 13 · UI_PROP 12 · GRID_STYLE 10 · MESSAGE 10 · UI_MISC 8 · GRID_LOCK 8 · POPUP 7 · VALIDATE 7 · COMBO_DATA 5 · LIST_REBIND 4 · THROW 4 · CALL_EXT 4 · GRID_BIND 3 · STATE 2 · EXCEL 1 · CALL_BASE 1 · LIST_BIND 1 · ⚠ 의미 확인 필요 5


## FP02650_SlurryBatchGroup_Master.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37c0cb30 | this.btnSql.Click | FP02650_SlurryBatchGroup_Master.cs:1768 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fc90b509 | this.btnSql.Click | FP02650_SlurryBatchGroup_Master.cs:1769 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a43b5031 | this.btnSql.Click | FP02650_SlurryBatchGroup_Master.cs:1771 |  | DATA_OP | popSql.Services.Add | ("SELECT_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc0768f4 | this.btnSql.Click | FP02650_SlurryBatchGroup_Master.cs:1772 |  | DATA_OP | popSql.Services.Add | ("SELECT_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-29e76969 | this.btnSql.Click | FP02650_SlurryBatchGroup_Master.cs:1773 |  | DATA_OP | popSql.Services.Add | ("SELECT_BY_RATIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-d273cabf | this.btnSql.Click | FP02650_SlurryBatchGroup_Master.cs:1774 |  | DATA_OP | popSql.Services.Add | ("SAVE_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8bead1d | this.btnSql.Click | FP02650_SlurryBatchGroup_Master.cs:1775 |  | DATA_OP | popSql.Services.Add | ("SAVE_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-35aaa255 | this.btnSql.Click | FP02650_SlurryBatchGroup_Master.cs:1776 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02650_SlurryBatchGroup_Master.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-315d263f | cboSite.SelectedIndexChanged | FP02650_SlurryBatchGroup_Master.cs:1798 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-07b5799f | cboSite.SelectedIndexChanged | FP02650_SlurryBatchGroup_Master.cs:1803 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-66631f6b | cboSite.SelectedIndexChanged | FP02650_SlurryBatchGroup_Master.cs:1806 | try | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-99c21b16 | cboSite.SelectedIndexChanged | FP02650_SlurryBatchGroup_Master.cs:1806 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ebfa57f0 | cboSite.SelectedIndexChanged | FP02650_SlurryBatchGroup_Master.cs:1807 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dbd7004a | cboSite.SelectedIndexChanged | FP02650_SlurryBatchGroup_Master.cs:1813 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Check_NewBatchFlag_Main

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17b0e488 | (진입점 미연결) | FP02650_SlurryBatchGroup_Master.cs:2142 | try | RETURN | return bNewBatchFlag; |  | 처리 중단/반환 |  |  |  |
| AC-185eab61 | (진입점 미연결) | FP02650_SlurryBatchGroup_Master.cs:2146 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02650_SlurryBatchGroup_Master.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3388859a | this.Load | FP02650_SlurryBatchGroup_Master.cs:258 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0a16ab68 | this.Load | FP02650_SlurryBatchGroup_Master.cs:259 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-04cd29de | this.Load | FP02650_SlurryBatchGroup_Master.cs:262 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-71424434 | this.Load | FP02650_SlurryBatchGroup_Master.cs:263 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf7d7e18 | this.Load | FP02650_SlurryBatchGroup_Master.cs:266 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e70d8a0 | this.Load | FP02650_SlurryBatchGroup_Master.cs:270 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02650_SlurryBatchGroup_Master.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d26e4628 | this.Load | FP02650_SlurryBatchGroup_Master.cs:169 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-81dc8715 | this.Load | FP02650_SlurryBatchGroup_Master.cs:171 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-4fec2c54 | this.Load | FP02650_SlurryBatchGroup_Master.cs:172 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-48aff0fa | this.Load | FP02650_SlurryBatchGroup_Master.cs:173 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP02650_SlurryBatchGroup_Master.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b4c5a2a | DeleteButton | FP02650_SlurryBatchGroup_Master.cs:503 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd655a4b | DeleteButton | FP02650_SlurryBatchGroup_Master.cs:518 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iClickSubRow == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da16fe12 | DeleteButton | FP02650_SlurryBatchGroup_Master.cs:522 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.Acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a997b25e | DeleteButton | FP02650_SlurryBatchGroup_Master.cs:526 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e17a7c30 | Dispose | FP02650_SlurryBatchGroup_Master.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02650_SlurryBatchGroup_Master.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f0c0b41 | EditButton | FP02650_SlurryBatchGroup_Master.cs:318 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff724045 | EditButton | FP02650_SlurryBatchGroup_Master.cs:320 | if (bSubSearchDoubleClick == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a27f28b7 | EditButton | FP02650_SlurryBatchGroup_Master.cs:324 | if (this.fps != null) | FLAG | bMainLockMode | !bMainLockMode | 화면 필드/플래그 변경 |  |  |  |
| AC-6a8a9c1b | EditButton | FP02650_SlurryBatchGroup_Master.cs:325 | if (this.fps != null) | GRID_LOCK | siMain.SetLockFlag | (spdMain.Name, bMainLockMode) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d490cdf2 | EditButton | FP02650_SlurryBatchGroup_Master.cs:327 | if (this.fps != null) | GRID_SET | spdMain.ActiveSheet.OperationMode | OperationMode.ReadOnly | 그리드 속성/값 설정 |  |  |  |
| AC-9734e1f2 | EditButton | FP02650_SlurryBatchGroup_Master.cs:328 | if (this.fps != null) | FLAG | bMainCheckLockMode | !bMainCheckLockMode | 화면 필드/플래그 변경 |  |  |  |
| AC-7326a97a | EditButton | FP02650_SlurryBatchGroup_Master.cs:346 | if (this.fps != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!bMainCheckLockMode) ▸ if (sFindBackRowN… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CHK), i, siMain.GetMaxColumnIndex(), Color.PeachPuff) | 그리드 표시 설정 |  |  |  |
| AC-9dbc8266 | EditButton | FP02650_SlurryBatchGroup_Master.cs:350 | if (this.fps != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!bMainCheckLockMode) ▸ else of (sFindBac… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | System.Drawing.Color.FromArgb(255, 255, 170) | 그리드 속성/값 설정 |  |  |  |
| AC-57dfc81d | EditButton | FP02650_SlurryBatchGroup_Master.cs:364 | if (this.fps != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (!bMainCheckLockMode) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CHK), i, siMain.GetColumnIndex(DefColumns.CHK), Syste… | 그리드 표시 설정 |  |  |  |
| AC-f4cc0cd7 | EditButton | FP02650_SlurryBatchGroup_Master.cs:369 | if (this.fps != null) | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-371ca5d8 | EditButton | FP02650_SlurryBatchGroup_Master.cs:370 | if (this.fps != null) | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-328ea430 | EditButton | FP02650_SlurryBatchGroup_Master.cs:371 | if (this.fps != null) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetColumnIndex(DefColumns.RATIO_NAME), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-652f8d4d | EditButton | FP02650_SlurryBatchGroup_Master.cs:379 | if (this.fps != null) ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.DESCRIPTION), i, siSub.GetColumnIndex(DefColumns.DESCR… | 그리드 표시 설정 |  |  |  |
| AC-beb49d57 | EditButton | FP02650_SlurryBatchGroup_Master.cs:383 | if (this.fps != null) ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.DESCRIPTION), i, siSub.GetColumnIndex(DefColumns.DESCR… | 그리드 표시 설정 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a732ebf | ExcelButton | FP02650_SlurryBatchGroup_Master.cs:561 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Find_Data_Main

진입점: popSql.OnSql [if (programID == "SELECT_MAIN")] / FindButton [try ▸ lambda] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bSaveResult1 == true && bSaveResult2 == true) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b2d23a2 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:672 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivision = CString.GetCheckedListValue(dtM… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0812c9a0 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:686 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-342ee7e6 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:687 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-ce4ab1b2 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:688 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-8000ec50 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:689 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a66142e0 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:690 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-40c8edca | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:692 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-06d6bf72 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:693 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3cc46c36 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:694 | try | DATA_OP | request.Parameters["p_site_id"] | pSite.Equals("ALL") ? DBNull.Value : pSite | 행/컬럼 값 대입 |  |  |  |
| AC-8200441e | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:695 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant.Equals("ALL") ? DBNull.Value : pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-82c69d2c | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:696 | try | DATA_OP | request.Parameters["p_batch_ratio_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2e33c535 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:697 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-be35ea9d | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:698 | try | DATA_OP | request.Parameters["p_parent_item_id"] | pItem | 행/컬럼 값 대입 |  |  |  |
| AC-aa38ec1d | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:699 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-c922eca3 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:700 | try | DATA_OP | request.Parameters["p_parent_item_class"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2d8d837d | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:701 | try | DATA_OP | request.Parameters["p_material_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-12565534 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:702 | try | DATA_OP | request.Parameters["p_level_name_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3afa39dc | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:703 | try | DATA_OP | request.Parameters["p_input_rate_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ad58a265 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:704 | try | DATA_OP | request.Parameters["p_material_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-052cfd44 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:705 | try | DATA_OP | request.Parameters["p_level_name_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-affca280 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:706 | try | DATA_OP | request.Parameters["p_input_rate_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1ad6de8e | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:707 | try | DATA_OP | request.Parameters["p_material_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6eacec66 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:708 | try | DATA_OP | request.Parameters["p_level_name_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e4b64ee0 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:709 | try | DATA_OP | request.Parameters["p_input_rate_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-56cef565 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:710 | try | DATA_OP | request.Parameters["p_material_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c632ee65 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:711 | try | DATA_OP | request.Parameters["p_level_name_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4996fd45 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:712 | try | DATA_OP | request.Parameters["p_input_rate_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ef7cb498 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:713 | try | DATA_OP | request.Parameters["p_material_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-72f23a92 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:714 | try | DATA_OP | request.Parameters["p_level_name_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6818ae7d | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:715 | try | DATA_OP | request.Parameters["p_input_rate_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-603afb79 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:716 | try | DATA_OP | request.Parameters["p_material_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2972f0dd | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:717 | try | DATA_OP | request.Parameters["p_level_name_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a9cdb2b8 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:718 | try | DATA_OP | request.Parameters["p_input_rate_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-753832b3 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:719 | try | DATA_OP | request.Parameters["p_material_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-60001290 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:720 | try | DATA_OP | request.Parameters["p_level_name_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0f563a94 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:721 | try | DATA_OP | request.Parameters["p_input_rate_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6047b470 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:722 | try | DATA_OP | request.Parameters["p_material_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ff8493b7 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:723 | try | DATA_OP | request.Parameters["p_level_name_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-91faa672 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:724 | try | DATA_OP | request.Parameters["p_input_rate_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-15bff4f1 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:725 | try | DATA_OP | request.Parameters["p_material_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-18567217 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:726 | try | DATA_OP | request.Parameters["p_level_name_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-96055833 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:727 | try | DATA_OP | request.Parameters["p_input_rate_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6aa0d302 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:728 | try | DATA_OP | request.Parameters["p_material_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9cc65591 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:729 | try | DATA_OP | request.Parameters["p_level_name_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e7b8a53a | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:730 | try | DATA_OP | request.Parameters["p_input_rate_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-217e3858 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:732 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c5de96a9 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:734 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b641cd9d | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FP02650_SlurryBatchGroup_Master.cs:739 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Find_Data_Main_By_Ratio

진입점: this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0)] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "SELECT_BY_RATIO")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29454ef7 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1660 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a695adae | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1666 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-230d2cc4 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1668 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a78b86b0 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1672 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-5e631b8e | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1674 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-616e782f | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1675 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_BY_RATIO" | 행/컬럼 값 대입 |  |  |  |
| AC-621348aa | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1676 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c9f4705e | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1677 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ed4811ab | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1679 | try | DATA_OP | request.Parameters["p_company_id"] | pCompany | 행/컬럼 값 대입 |  |  |  |
| AC-05b200da | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1680 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1b639b78 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1681 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-7a965db5 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1682 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-71a4af01 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1683 | try | DATA_OP | request.Parameters["p_batch_ratio_id"] | pRatio | 행/컬럼 값 대입 |  |  |  |
| AC-c1aedfe7 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1684 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-60545c88 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1685 | try | DATA_OP | request.Parameters["p_parent_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5f3b79bc | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1686 | try | DATA_OP | request.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-47c9094d | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1687 | try | DATA_OP | request.Parameters["p_parent_item_class"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-624d8dfb | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1688 | try | DATA_OP | request.Parameters["p_material_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-39b2c17e | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1689 | try | DATA_OP | request.Parameters["p_level_name_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-36a6e4a6 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1690 | try | DATA_OP | request.Parameters["p_input_rate_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-62fabe3f | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1691 | try | DATA_OP | request.Parameters["p_material_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4e2ac304 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1692 | try | DATA_OP | request.Parameters["p_level_name_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-95c88255 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1693 | try | DATA_OP | request.Parameters["p_input_rate_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6c236dca | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1694 | try | DATA_OP | request.Parameters["p_material_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-196b1f01 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1695 | try | DATA_OP | request.Parameters["p_level_name_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-364d0c3a | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1696 | try | DATA_OP | request.Parameters["p_input_rate_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-62294f90 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1697 | try | DATA_OP | request.Parameters["p_material_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7d9b9224 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1698 | try | DATA_OP | request.Parameters["p_level_name_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dfe9c670 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1699 | try | DATA_OP | request.Parameters["p_input_rate_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3407b1ea | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1700 | try | DATA_OP | request.Parameters["p_material_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-340dda8c | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1701 | try | DATA_OP | request.Parameters["p_level_name_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3b4bb23c | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1702 | try | DATA_OP | request.Parameters["p_input_rate_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4fd7eed9 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1703 | try | DATA_OP | request.Parameters["p_material_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ecaceeb5 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1704 | try | DATA_OP | request.Parameters["p_level_name_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f4177318 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1705 | try | DATA_OP | request.Parameters["p_input_rate_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e74e5db3 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1706 | try | DATA_OP | request.Parameters["p_material_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a2e9cf70 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1707 | try | DATA_OP | request.Parameters["p_level_name_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-39f60f2c | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1708 | try | DATA_OP | request.Parameters["p_input_rate_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dbddf87d | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1709 | try | DATA_OP | request.Parameters["p_material_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-657d8b00 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1710 | try | DATA_OP | request.Parameters["p_level_name_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ce19070d | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1711 | try | DATA_OP | request.Parameters["p_input_rate_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b674f950 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1712 | try | DATA_OP | request.Parameters["p_material_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-12342322 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1713 | try | DATA_OP | request.Parameters["p_level_name_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c4855551 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1714 | try | DATA_OP | request.Parameters["p_input_rate_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c24bbba8 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1715 | try | DATA_OP | request.Parameters["p_material_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-775ba3dc | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1716 | try | DATA_OP | request.Parameters["p_level_name_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a6a0a71f | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1717 | try | DATA_OP | request.Parameters["p_input_rate_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-59c435d6 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1718 | try | DATA_OP | request.Parameters["p_material_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ad90226f | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1719 | try | DATA_OP | request.Parameters["p_level_name_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c78fb2bd | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1720 | try | DATA_OP | request.Parameters["p_input_rate_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1a61b7db | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1723 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-938f7265 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1732 | try ▸ if (pSysType.Equals("SELECT")) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6bbf23f4 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1735 | try ▸ if (pSysType.Equals("SELECT")) | FLAG | bMainCheckLockMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e862b030 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1736 | try ▸ if (pSysType.Equals("SELECT")) | FLAG | bSubSearchDoubleClick | true | 화면 필드/플래그 변경 |  |  |  |
| AC-40c293a2 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1747 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-ffd830f0 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1751 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5f1354d7 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1755 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Find_Data_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Row >= 0) ▸ try] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB")] / FindButton [try ▸ if (ds != null) ▸ try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bSaveResult1 == true && bSaveResult2 == true) ▸ try ▸ if (ds != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d9ef9cf | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:812 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-fb409e6d | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:813 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-4d868850 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:814 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_SUB" | 행/컬럼 값 대입 |  |  |  |
| AC-5f91860a | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:815 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c8c0994f | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:816 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ea97e978 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:818 | try | DATA_OP | request.Parameters["p_company_id"] | pCompany | 행/컬럼 값 대입 |  |  |  |
| AC-ad94badc | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:819 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-09186855 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:820 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-fcfa54aa | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:821 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-e9ad4050 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:822 | try | DATA_OP | request.Parameters["p_batch_ratio_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-774d5e2b | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:823 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b3c800a0 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:824 | try | DATA_OP | request.Parameters["p_parent_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-041248d7 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:825 | try | DATA_OP | request.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-857f9155 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:826 | try | DATA_OP | request.Parameters["p_parent_item_class"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3834aab7 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:827 | try | DATA_OP | request.Parameters["p_material_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ae5db8b2 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:828 | try | DATA_OP | request.Parameters["p_level_name_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a702edea | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:829 | try | DATA_OP | request.Parameters["p_input_rate_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ecf0746e | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:830 | try | DATA_OP | request.Parameters["p_material_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8f3caefb | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:831 | try | DATA_OP | request.Parameters["p_level_name_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e1a7d5af | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:832 | try | DATA_OP | request.Parameters["p_input_rate_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a5669042 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:833 | try | DATA_OP | request.Parameters["p_material_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2439b44c | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:834 | try | DATA_OP | request.Parameters["p_level_name_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cf1fd11c | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:835 | try | DATA_OP | request.Parameters["p_input_rate_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6a058ba7 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:836 | try | DATA_OP | request.Parameters["p_material_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-17fd3254 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:837 | try | DATA_OP | request.Parameters["p_level_name_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cf7b715b | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:838 | try | DATA_OP | request.Parameters["p_input_rate_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ead4d2f7 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:839 | try | DATA_OP | request.Parameters["p_material_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1ca44cc4 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:840 | try | DATA_OP | request.Parameters["p_level_name_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d6ef9dfa | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:841 | try | DATA_OP | request.Parameters["p_input_rate_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d169c96c | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:842 | try | DATA_OP | request.Parameters["p_material_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-38e39dfe | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:843 | try | DATA_OP | request.Parameters["p_level_name_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7de0c72a | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:844 | try | DATA_OP | request.Parameters["p_input_rate_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b996e0c7 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:845 | try | DATA_OP | request.Parameters["p_material_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5f1e351b | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:846 | try | DATA_OP | request.Parameters["p_level_name_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-44dc40dc | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:847 | try | DATA_OP | request.Parameters["p_input_rate_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cce6773a | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:848 | try | DATA_OP | request.Parameters["p_material_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-59062c27 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:849 | try | DATA_OP | request.Parameters["p_level_name_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8de33df3 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:850 | try | DATA_OP | request.Parameters["p_input_rate_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e15e816d | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:851 | try | DATA_OP | request.Parameters["p_material_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1f3f239c | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:852 | try | DATA_OP | request.Parameters["p_level_name_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cd76651e | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:853 | try | DATA_OP | request.Parameters["p_input_rate_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cc1c8ec8 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:854 | try | DATA_OP | request.Parameters["p_material_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f785c4fe | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:855 | try | DATA_OP | request.Parameters["p_level_name_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c02f3b3d | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:856 | try | DATA_OP | request.Parameters["p_input_rate_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5225de70 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:858 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e886efd | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:860 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-458b2918 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FP02650_SlurryBatchGroup_Master.cs:865 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Find_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bSaveResult1 == true && bSaveResult2 == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b21b91c9 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:570 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d6a32cf3 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:574 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a27ba1a6 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:577 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-f1a1a863 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:577 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2683958 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:580 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d0e9f8f3 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:581 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0934a89e | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:584 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dade5331 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:590 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-070a8f3a | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:593 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c0f6da42 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:599 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0b51571d | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:600 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Main("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-99a18e18 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:608 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9fc96bfb | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:610 | try ▸ if (ds != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2c92ebe1 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:613 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a2eead10 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:637 | try ▸ if (ds != null) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-ba552cf9 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:644 | try ▸ else of (ds != null) | LIST_BIND | spdMain.DataSource | ds | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-9cda8830 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:652 | finally | FLAG | _sNewBatchRatioID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3c999691 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:653 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bbc11cc1 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:654 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-34cc2525 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:656 | finally | FLAG | bMainCheckLockMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-470099d8 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:657 | finally | FLAG | bSubSearchDoubleClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a90c56b2 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:658 | finally | FLAG | bMainLockMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5ef2bc44 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:659 | finally | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-f9b1aab7 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:660 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5a70c908 | FindButton 외 1 | FP02650_SlurryBatchGroup_Master.cs:660 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Find_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Row >= 0)] / FindButton [try ▸ if (ds != null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bSaveResult1 == true && bSaveResult2 == true) ▸ try ▸ if (ds != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fca070b | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FP02650_SlurryBatchGroup_Master.cs:750 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2b9ca404 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FP02650_SlurryBatchGroup_Master.cs:764 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34cf8c76 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FP02650_SlurryBatchGroup_Master.cs:775 | try | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c4da444d | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FP02650_SlurryBatchGroup_Master.cs:780 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-39f09557 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FP02650_SlurryBatchGroup_Master.cs:788 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b27b6225 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FP02650_SlurryBatchGroup_Master.cs:800 | finally | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-17c8c450 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FP02650_SlurryBatchGroup_Master.cs:801 | finally | GRID_SET | this.spdSub.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6c478146 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FP02650_SlurryBatchGroup_Master.cs:801 | finally | CALL_EXT | this.spdSub.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88bd6935 | this.Load | FP02650_SlurryBatchGroup_Master.cs:140 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02650_SlurryBatchGroup_Master.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4342ad1f | this.Load | FP02650_SlurryBatchGroup_Master.cs:182 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8813d53a | this.Load | FP02650_SlurryBatchGroup_Master.cs:188 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-dbdc0086 | this.Load | FP02650_SlurryBatchGroup_Master.cs:189 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1d862062 | this.Load | FP02650_SlurryBatchGroup_Master.cs:193 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-b67f2af0 | this.Load | FP02650_SlurryBatchGroup_Master.cs:195 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-36647fe7 | this.Load | FP02650_SlurryBatchGroup_Master.cs:199 | try | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-5e3607f8 | this.Load | FP02650_SlurryBatchGroup_Master.cs:199 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-41bdba6f | this.Load | FP02650_SlurryBatchGroup_Master.cs:200 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-cecf47f4 | this.Load | FP02650_SlurryBatchGroup_Master.cs:210 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f61b9893 | this.Load | FP02650_SlurryBatchGroup_Master.cs:211 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-356fee05 | this.Load | FP02650_SlurryBatchGroup_Master.cs:212 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5b8cc6ea | this.Load | FP02650_SlurryBatchGroup_Master.cs:215 | try | FLAG | bMainCheckLockMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-df22102c | this.Load | FP02650_SlurryBatchGroup_Master.cs:216 | try | FLAG | bSubSearchDoubleClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-eb34da20 | this.Load | FP02650_SlurryBatchGroup_Master.cs:220 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02650_SlurryBatchGroup_Master.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a130de8 | this.Load | FP02650_SlurryBatchGroup_Master.cs:156 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d7e99ff7 | this.Load | FP02650_SlurryBatchGroup_Master.cs:157 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02650_SlurryBatchGroup_Master.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91eb0fcc | this.Load | FP02650_SlurryBatchGroup_Master.cs:277 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e98a8683 | this.Load | FP02650_SlurryBatchGroup_Master.cs:280 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-afa2932c | this.Load | FP02650_SlurryBatchGroup_Master.cs:284 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.BATCH_RATIO_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-107aa482 | this.Load | FP02650_SlurryBatchGroup_Master.cs:287 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0614fa3b | this.Load | FP02650_SlurryBatchGroup_Master.cs:292 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-39dded51 | this.Load | FP02650_SlurryBatchGroup_Master.cs:295 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-d559968e | this.Load | FP02650_SlurryBatchGroup_Master.cs:297 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, siSub.GetColumnIndex(DefColumns.DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02650_SlurryBatchGroup_Master.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc7e43ac | popSql.OnSql | FP02650_SlurryBatchGroup_Master.cs:2164 | if (programID == "SELECT_MAIN") | RETURN | return Find_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-e68fa11f | popSql.OnSql | FP02650_SlurryBatchGroup_Master.cs:2175 | else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB") | RETURN | return Find_Data_Sub("SQL", pCompany, pDivision, pSite, pPlant); |  | 처리 중단/반환 |  |  |  |
| AC-cad2429d | popSql.OnSql | FP02650_SlurryBatchGroup_Master.cs:2187 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "SELECT_BY_RATIO") | RETURN | return Find_Data_Main_By_Ratio(pCompany, pDivision, pSite, pPlant, pRatio, "SQL"… |  | 처리 중단/반환 |  |  |  |
| AC-e8faf1e2 | popSql.OnSql | FP02650_SlurryBatchGroup_Master.cs:2192 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ if (programID == "SA… | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-92b99d34 | popSql.OnSql | FP02650_SlurryBatchGroup_Master.cs:2192 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ if (programID == "SA… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5d15cc13 | popSql.OnSql | FP02650_SlurryBatchGroup_Master.cs:2193 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ if (programID == "SA… | RETURN | return Save_GroupMasterData_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-a6238051 | popSql.OnSql | FP02650_SlurryBatchGroup_Master.cs:2198 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ else of (programID =… | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-72113718 | popSql.OnSql | FP02650_SlurryBatchGroup_Master.cs:2198 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ else of (programID =… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-633060da | popSql.OnSql | FP02650_SlurryBatchGroup_Master.cs:2199 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ else of (programID =… | RETURN | return Save_Data_Sub("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-f2b5d462 | popSql.OnSql | FP02650_SlurryBatchGroup_Master.cs:2202 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Save_Data_Sub

진입점: popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ else of (programID == "SAVE_MAIN") ▸ if (programID == "SAVE_SUB")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bDelFlag == true) ▸ if (MessageBox.Show("[Delete], Data dependent on Group Batch to be deleted exists.\r\n Do you want to proceed with the delet…) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f7decdb | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1594 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-2c743e4b | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1595 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3340868d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1597 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-c6346d0f | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1598 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-be2cdd07 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1599 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-693964c8 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1600 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b3eea732 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1601 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb1748e6 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1602 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0f99fca9 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1603 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f6a98a89 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1604 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-ac35091d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1605 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_batch_ratio_id"] | p_batch_ratio_id | 행/컬럼 값 대입 |  |  |  |
| AC-8f04232e | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1606 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-45de7f4a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1607 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_parent_item_id"] | p_parent_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-671c26cc | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1608 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-f9367016 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1609 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_parent_item_class"] | p_parent_item_class | 행/컬럼 값 대입 |  |  |  |
| AC-afb084d3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1610 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_1"] | p_material_1 | 행/컬럼 값 대입 |  |  |  |
| AC-0828176d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1611 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_1"] | p_level_name_1 | 행/컬럼 값 대입 |  |  |  |
| AC-c58d7c69 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1612 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_1"] | p_input_rate_1 | 행/컬럼 값 대입 |  |  |  |
| AC-a113ae67 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1613 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_2"] | p_material_2 | 행/컬럼 값 대입 |  |  |  |
| AC-987a0959 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1614 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_2"] | p_level_name_2 | 행/컬럼 값 대입 |  |  |  |
| AC-4a2105f9 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1615 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_2"] | p_input_rate_2 | 행/컬럼 값 대입 |  |  |  |
| AC-b5db074a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1616 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_3"] | p_material_3 | 행/컬럼 값 대입 |  |  |  |
| AC-553b3b7b | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1617 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_3"] | p_level_name_3 | 행/컬럼 값 대입 |  |  |  |
| AC-e1a07e44 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1618 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_3"] | p_input_rate_3 | 행/컬럼 값 대입 |  |  |  |
| AC-cbad2ec5 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1619 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_4"] | p_material_4 | 행/컬럼 값 대입 |  |  |  |
| AC-ea3454e2 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1620 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_4"] | p_level_name_4 | 행/컬럼 값 대입 |  |  |  |
| AC-c84d3048 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1621 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_4"] | p_input_rate_4 | 행/컬럼 값 대입 |  |  |  |
| AC-213b8780 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1622 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_5"] | p_material_5 | 행/컬럼 값 대입 |  |  |  |
| AC-63ce90d0 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1623 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_5"] | p_level_name_5 | 행/컬럼 값 대입 |  |  |  |
| AC-7c95f2b3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1624 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_5"] | p_input_rate_5 | 행/컬럼 값 대입 |  |  |  |
| AC-846cd2e1 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1625 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_6"] | p_material_6 | 행/컬럼 값 대입 |  |  |  |
| AC-eddbb7c3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1626 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_6"] | p_level_name_6 | 행/컬럼 값 대입 |  |  |  |
| AC-ddb18352 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1627 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_6"] | p_input_rate_6 | 행/컬럼 값 대입 |  |  |  |
| AC-5548b95a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1628 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_7"] | p_material_7 | 행/컬럼 값 대입 |  |  |  |
| AC-661f6e33 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1629 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_7"] | p_level_name_7 | 행/컬럼 값 대입 |  |  |  |
| AC-3a597158 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1630 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_7"] | p_input_rate_7 | 행/컬럼 값 대입 |  |  |  |
| AC-7390e7c0 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1631 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_8"] | p_material_8 | 행/컬럼 값 대입 |  |  |  |
| AC-67aa8923 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1632 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_8"] | p_level_name_8 | 행/컬럼 값 대입 |  |  |  |
| AC-289bd072 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1633 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_8"] | p_input_rate_8 | 행/컬럼 값 대입 |  |  |  |
| AC-c18d4fd7 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1634 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_9"] | p_material_9 | 행/컬럼 값 대입 |  |  |  |
| AC-9975aec9 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1635 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_9"] | p_level_name_9 | 행/컬럼 값 대입 |  |  |  |
| AC-f9b5f7f4 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1636 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_9"] | p_input_rate_9 | 행/컬럼 값 대입 |  |  |  |
| AC-5884ffbf | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1637 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_10"] | p_material_10 | 행/컬럼 값 대입 |  |  |  |
| AC-53cbe043 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1638 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_10"] | p_level_name_10 | 행/컬럼 값 대입 |  |  |  |
| AC-3cbc1f84 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1639 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_10"] | p_input_rate_10 | 행/컬럼 값 대입 |  |  |  |
| AC-8ae71364 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1641 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3fb8a0b4 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1642 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-23fde025 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1648 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-35d0ee2a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1654 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Save_GroupMasterData_Main

진입점: popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ if (programID == "SAVE_MAIN")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bDelFlag == true) ▸ if (MessageBox.Show("[Delete], Data dependent on Group Batch to be deleted exists.\r\n Do you want to proceed with the delet…) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6503ac1d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1029 | try | FLAG | _sNewBatchRatioID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0c523e5b | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1055 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sCheckData.Equals("[New Batch]")) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP02650_findNewBatch", sCompany, sDivision, sSite, sPlant) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f6e45a97 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1060 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sCheckData.Equals("[New Batch]")) ▸ if (dtNewBatchRatio != null) | FLAG | _sNewBatchRatioID | sBatchRatio | 화면 필드/플래그 변경 |  |  |  |
| AC-d01ec058 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1062 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sCheckData.Equals("[New Batch]")) ▸ if (dtNewBatchRatio != null) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), siSub.GetValue(0, siSub.GetColumnIndex(… | 그리드 값 설정 |  |  |  |
| AC-07401cde | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1132 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-92207fd8 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1133 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9d472b93 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1135 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-af0caa80 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1136 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-36719851 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1137 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-688c43c9 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1138 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cef2ab73 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1139 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-0a95efe3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1140 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e108e509 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1141 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-cdabe3ac | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1142 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-11f9401a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1143 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_batch_ratio_id"] | p_batch_ratio_id | 행/컬럼 값 대입 |  |  |  |
| AC-48531f57 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1144 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-6d2ee5df | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1145 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_parent_item_id"] | p_parent_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-315a87a4 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1146 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-59a74fce | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1147 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_parent_item_class"] | p_parent_item_class | 행/컬럼 값 대입 |  |  |  |
| AC-afa9fe36 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1148 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_1"] | p_material_1 | 행/컬럼 값 대입 |  |  |  |
| AC-1fcf1f10 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1149 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_1"] | p_level_name_1 | 행/컬럼 값 대입 |  |  |  |
| AC-a7e1ee2f | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1150 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_1"] | p_input_rate_1 | 행/컬럼 값 대입 |  |  |  |
| AC-4b333d53 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1151 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_2"] | p_material_2 | 행/컬럼 값 대입 |  |  |  |
| AC-4a47c4ba | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1152 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_2"] | p_level_name_2 | 행/컬럼 값 대입 |  |  |  |
| AC-bed0d7f1 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1153 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_2"] | p_input_rate_2 | 행/컬럼 값 대입 |  |  |  |
| AC-25d1a36f | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1154 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_3"] | p_material_3 | 행/컬럼 값 대입 |  |  |  |
| AC-76667798 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1155 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_3"] | p_level_name_3 | 행/컬럼 값 대입 |  |  |  |
| AC-41420c0c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1156 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_3"] | p_input_rate_3 | 행/컬럼 값 대입 |  |  |  |
| AC-54ad40e6 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1157 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_4"] | p_material_4 | 행/컬럼 값 대입 |  |  |  |
| AC-96cbb081 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1158 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_4"] | p_level_name_4 | 행/컬럼 값 대입 |  |  |  |
| AC-b4cb1863 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1159 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_4"] | p_input_rate_4 | 행/컬럼 값 대입 |  |  |  |
| AC-df011d08 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1160 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_5"] | p_material_5 | 행/컬럼 값 대입 |  |  |  |
| AC-a1e7c655 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1161 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_5"] | p_level_name_5 | 행/컬럼 값 대입 |  |  |  |
| AC-4d0abf7a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1162 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_5"] | p_input_rate_5 | 행/컬럼 값 대입 |  |  |  |
| AC-ffff87fc | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1163 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_6"] | p_material_6 | 행/컬럼 값 대입 |  |  |  |
| AC-33b51971 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1164 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_6"] | p_level_name_6 | 행/컬럼 값 대입 |  |  |  |
| AC-408a60ae | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1165 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_6"] | p_input_rate_6 | 행/컬럼 값 대입 |  |  |  |
| AC-6eae5408 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1166 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_7"] | p_material_7 | 행/컬럼 값 대입 |  |  |  |
| AC-2271550b | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1167 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_7"] | p_level_name_7 | 행/컬럼 값 대입 |  |  |  |
| AC-4b744cd7 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1168 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_7"] | p_input_rate_7 | 행/컬럼 값 대입 |  |  |  |
| AC-155475f3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1169 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_8"] | p_material_8 | 행/컬럼 값 대입 |  |  |  |
| AC-b6d640a1 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1170 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_8"] | p_level_name_8 | 행/컬럼 값 대입 |  |  |  |
| AC-4281b745 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1171 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_8"] | p_input_rate_8 | 행/컬럼 값 대입 |  |  |  |
| AC-78d9d9ec | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1172 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_9"] | p_material_9 | 행/컬럼 값 대입 |  |  |  |
| AC-edb1d440 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1173 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_9"] | p_level_name_9 | 행/컬럼 값 대입 |  |  |  |
| AC-fdd789cf | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1174 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_9"] | p_input_rate_9 | 행/컬럼 값 대입 |  |  |  |
| AC-1f55d9ed | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1175 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_10"] | p_material_10 | 행/컬럼 값 대입 |  |  |  |
| AC-6e13ee4e | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1176 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_10"] | p_level_name_10 | 행/컬럼 값 대입 |  |  |  |
| AC-be4f194d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1177 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_10"] | p_input_rate_10 | 행/컬럼 값 대입 |  |  |  |
| AC-16f2eb23 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1180 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fa920a96 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1181 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-95345734 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1187 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-0c83849e | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FP02650_SlurryBatchGroup_Master.cs:1193 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Save_Main

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bDelFlag == true) ▸ if (MessageBox.Show("[Delete], Data dependent on Group Batch to be deleted exists.\r\n Do you want to proceed with the delet…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-632dfdbc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:876 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-91daff38 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:876 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-446b8d03 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:878 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-80339854 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:880 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-332723ee | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:885 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-26287545 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:886 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-21c64b9e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:890 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bf87a2cf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:897 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-b3e8c16a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:899 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6c49442b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:900 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1985f0fc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:923 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1 != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (!string.IsN… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.BATCH_RATIO_ID), _sNewBatchRatioID) | 그리드 값 설정 |  |  |  |
| AC-0ec14540 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:924 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1 != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (!string.IsN… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), siSub.GetValue(0, siSub.GetColumnIndex(… | 그리드 값 설정 |  |  |  |
| AC-8ee6eca8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:934 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1 != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (!string.IsN… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-075f0f72 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:941 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1 != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ else of (!strin… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-ceea9cde | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:952 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1 != null) ▸ else of (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81570c9c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:954 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1 != null) ▸ else of (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-414d7873 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:959 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ade50801 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:960 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-7ca7c39e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:964 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cec56cd2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:965 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d0fd16c5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:966 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-845d66a4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:970 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-753e2660 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:971 | finally | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Save_Sub

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bDelFlag == true) ▸ if (MessageBox.Show("[Delete], Data dependent on Group Batch to be deleted exists.\r\n Do you want to proceed with the delet…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-753276d5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1390 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-4167ccfe | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1390 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c7072aa2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1392 | if (siSub == null \|\| siSub.IsLock(siSub.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-81aed1c3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1394 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bf217c19 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1399 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-77288074 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1400 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9c3bdac5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1407 | if (!sEditYN.Equals("Y")) | MESSAGE | MessageBox.Show | ("Your Authority don't have permission to Save!") | 메시지 표시 |  |  |  |
| AC-cc5c5d64 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1408 | if (!sEditYN.Equals("Y")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-907d4ea2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1412 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7f0bb0df | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1419 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-54e6841c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1421 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4e1b6c85 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1422 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8f60d012 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1427 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5a427d41 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1433 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-f199a9df | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1443 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-29185391 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1444 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7919d3fa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1447 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a037a8d9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1450 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ccd3d8ac | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1451 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-deaa9080 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1455 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-df1dca84 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1456 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-9dd91d7c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1457 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a5f6cdcd | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1461 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-91f18fdd | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1462 | finally | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP02650_SlurryBatchGroup_Master.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c93e3d50 | SaveButton | FP02650_SlurryBatchGroup_Master.cs:453 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8abfa473 | SaveButton | FP02650_SlurryBatchGroup_Master.cs:473 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bDelFlag == true) | MESSAGE | MessageBox.Show | ("[Delete], Data dependent on Group Batch to be deleted exists.\r\n Do you want to proceed… | 메시지 표시 |  |  |  |
| AC-f5ae1c97 | SaveButton | FP02650_SlurryBatchGroup_Master.cs:489 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bSaveResult1 == true && bSaveResult2 == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02650_SlurryBatchGroup_Master.SetBackColorRowNumberGroup

진입점: this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0) ▸ try ▸ if (pSysType.Equals("SELECT"))] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "SELECT_BY_RATIO") ▸ try ▸ if (pSysType.Equals("SELECT"))] / FindButton [try ▸ if (ds != null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bSaveResult1 == true && bSaveResult2 == true) ▸ try ▸ if (ds != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc869cb8 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 3 | FP02650_SlurryBatchGroup_Master.cs:2095 | for (iRow < spdMain.ActiveSheet.Rows.Count) ▸ if (sFindBackRowNum.Equals("1")) | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetMaxColumnIndex(), Co… | 그리드 표시 설정 |  |  |  |
| AC-6fabd9f0 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 3 | FP02650_SlurryBatchGroup_Master.cs:2099 | for (iRow < spdMain.ActiveSheet.Rows.Count) ▸ else of (sFindBackRowNum.Equals("1")) | GRID_SET | siMain.ActiveSheet.Rows[iRow].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |

## FP02650_SlurryBatchGroup_Master.SetChangedControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c4f1d67 | this.Load [try] 외 1 | FP02650_SlurryBatchGroup_Master.cs:238 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-620e0f35 | this.Load [try] 외 1 | FP02650_SlurryBatchGroup_Master.cs:240 | try | FLAG | dtSiteByDivision | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-6be1115c | this.Load [try] 외 1 | FP02650_SlurryBatchGroup_Master.cs:240 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", "", "", "", pDivisi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-634510b7 | this.Load [try] 외 1 | FP02650_SlurryBatchGroup_Master.cs:241 | try | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6c0edc00 | this.Load [try] 외 1 | FP02650_SlurryBatchGroup_Master.cs:245 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b0a1bf7 | this.Load [try] 외 1 | FP02650_SlurryBatchGroup_Master.cs:247 | try | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-f7d1b359 | this.Load [try] 외 1 | FP02650_SlurryBatchGroup_Master.cs:247 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-56f6187a | this.Load [try] 외 1 | FP02650_SlurryBatchGroup_Master.cs:248 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02650_SlurryBatchGroup_Master.SetCheckCloumnLockMode

진입점: this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0) ▸ if (siSub != null && siSub.IsLock(siMain.SheetName) == false)] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "SELECT_BY_RATIO") ▸ try ▸ if (pSysType.Equals("SELECT"))] / EditButton [if (this.fps != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16c15ed3 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 2 | FP02650_SlurryBatchGroup_Master.cs:2107 |  | GRID_SET | spdMain.ActiveSheet.OperationMode | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-8160e158 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 2 | FP02650_SlurryBatchGroup_Master.cs:2108 |  | UI_PROP | spdMain.EditMode | true | 속성 EditMode 설정 |  |  |  |
| AC-d49bff69 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 2 | FP02650_SlurryBatchGroup_Master.cs:2113 | for (iRow < spdMain.ActiveSheet.Rows.Count) ▸ for (iCol < 2) | GRID_SET | spdMain.ActiveSheet.Cells[iRow, iCol].Locked | bLock | 그리드 속성/값 설정 |  |  |  |

## FP02650_SlurryBatchGroup_Master.SetSpdMainValueEditChange

진입점: this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellType(e.Row, e.Column).ToString() == "CheckBoxCellType")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb90a53b | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2006 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | FLAG | iClickMainRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-caf78f2c | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2007 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dde657d2 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2011 | try ▸ if (bMainCheckLockMode == true) | FLAG | iClickMainRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-071ba8c9 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2012 | try ▸ if (bMainCheckLockMode == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f628de05 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2017 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1f41a3ae | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2026 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.BATCH_RATIO_ID)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-8d8b368c | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2027 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.DESCRIPTION)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-8606ff7d | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2028 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Rows[e.Row].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-11dc927e | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2050 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.BATCH_RATIO_ID)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-7d833f13 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2051 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.DESCRIPTION)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-b50c21d8 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2052 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | GRID_SET | siMain.ActiveSheet.Rows[e.Row].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-bad0ff3a | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2053 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | GRID_SET | siMain.ActiveSheet.SetValue | (e.Row, e.Column, 0) | 그리드 값 설정 |  |  |  |
| AC-1f4a03a2 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2055 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | FLAG | iClickMainRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-6dceff0e | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2056 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bd05fdc6 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2057 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-927eebb1 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2066 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.BATCH_RATIO_ID)].Value | sRatioName | 그리드 속성/값 설정 |  |  |  |
| AC-a8d97367 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2067 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.DESCRIPTION)].Value | sDescription | 그리드 속성/값 설정 |  |  |  |
| AC-34c26c76 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2070 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Rows[e.Row].ForeColor | Color.Crimson | 그리드 속성/값 설정 |  |  |  |
| AC-09cb6592 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2073 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8e531d1a | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2076 | try | FLAG | iClickMainRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-efd42917 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FP02650_SlurryBatchGroup_Master.cs:2080 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02650_SlurryBatchGroup_Master.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-873a3104 | this.spdMain.ButtonClicked | FP02650_SlurryBatchGroup_Master.cs:1973 |  | CALL_EXT | spdMain.ActiveSheet.GetCellType | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |

## FP02650_SlurryBatchGroup_Master.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49aa85c7 | this.spdMain.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1869 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | FLAG | iClickMainRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b64cb910 | this.spdMain.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1870 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-def94a66 | this.spdMain.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1886 | if (siMain != null) ▸ if (e.Row >= 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-331db016 | this.spdMain.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1887 | if (siMain != null) ▸ if (e.Row >= 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ffa290d7 | this.spdMain.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1888 | if (siMain != null) ▸ if (e.Row >= 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetColumnIndex(DefColumns.RATIO_NAME), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-86b5db4f | this.spdMain.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1896 | if (siMain != null) ▸ if (e.Row >= 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siSub.GetMaxRowIndex() > 0) ▸ … | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.DESCRIPTION), i, siSub.GetColumnIndex(DefColumns.DESCR… | 그리드 표시 설정 |  |  |  |
| AC-aec6b557 | this.spdMain.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1900 | if (siMain != null) ▸ if (e.Row >= 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siSub.GetMaxRowIndex() > 0) ▸ … | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.DESCRIPTION), i, siSub.GetColumnIndex(DefColumns.DESCR… | 그리드 표시 설정 |  |  |  |
| AC-1d1bf8ef | this.spdMain.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1906 | if (siMain != null) ▸ if (e.Row >= 0) | FLAG | iClickMainRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-a64312f0 | this.spdMain.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1911 |  | FLAG | iClickMainRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP02650_SlurryBatchGroup_Master.spdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ed6d63f | this.spdSub.CellClick | FP02650_SlurryBatchGroup_Master.cs:1843 | try ▸ if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2b62f886 | this.spdSub.CellClick | FP02650_SlurryBatchGroup_Master.cs:1844 | try ▸ if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a423dcf | this.spdSub.CellClick | FP02650_SlurryBatchGroup_Master.cs:1848 | try ▸ if (siSub != null && e.Row >= 0) | FLAG | iClickSubRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-42acce64 | this.spdSub.CellClick | FP02650_SlurryBatchGroup_Master.cs:1851 | try | FLAG | iClickSubRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-55b319f0 | this.spdSub.CellClick | FP02650_SlurryBatchGroup_Master.cs:1855 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02650_SlurryBatchGroup_Master.SpdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-072ee223 | this.spdSub.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1925 | if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-82e06fc2 | this.spdSub.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1926 | if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5014be6d | this.spdSub.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1942 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0) ▸ … | GRID_LOCK | siMain.SetLockFlag | (spdMain.Name, bMainLockMode) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b79f7f42 | this.spdSub.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1944 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0) ▸ … | GRID_SET | spdMain.ActiveSheet.OperationMode | OperationMode.ReadOnly | 그리드 속성/값 설정 |  |  |  |
| AC-38ed47b9 | this.spdSub.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1954 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0) ▸ … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CHK), i, siMain.GetColumnIndex(DefColumns.CHK), Syste… | 그리드 표시 설정 |  |  |  |
| AC-67ecde87 | this.spdSub.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1958 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0) ▸ … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CHK), i, siMain.GetColumnIndex(DefColumns.CHK), Syste… | 그리드 표시 설정 |  |  |  |
| AC-50668872 | this.spdSub.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1963 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0) | FLAG | iClickSubRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-21a1e9e0 | this.spdSub.CellDoubleClick | FP02650_SlurryBatchGroup_Master.cs:1968 |  | FLAG | iClickSubRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP02650_SlurryBatchGroup_Master.Update_DataDetail_Main

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (bDelFlag == true) ▸ if (MessageBox.Show("[Delete], Data dependent on Group Batch to be deleted exists.\r\n Do you want to proceed with the delet…) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1 != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (!string.IsNullOrEmpty(_sNewBatchRatioID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e269eb3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1321 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-275df349 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1322 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d491ac06 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1324 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-968001ec | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1325 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5a4f7880 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1326 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-c55bcbe6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1327 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e511d509 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1328 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-99c191f6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1329 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3030b3a1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1330 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a43b3859 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1331 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff60776d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1332 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_batch_ratio_id"] | p_batch_ratio_id | 행/컬럼 값 대입 |  |  |  |
| AC-4da1b0b5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1333 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-51c3f316 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1334 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_parent_item_id"] | p_parent_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2d370e40 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1335 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-8ae2b07d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1336 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_parent_item_class"] | p_parent_item_class | 행/컬럼 값 대입 |  |  |  |
| AC-5ea2b411 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1337 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_1"] | p_material_1 | 행/컬럼 값 대입 |  |  |  |
| AC-db32c587 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1338 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_1"] | p_level_name_1 | 행/컬럼 값 대입 |  |  |  |
| AC-c10d02d8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1339 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_1"] | p_input_rate_1 | 행/컬럼 값 대입 |  |  |  |
| AC-dbfa6fd8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1340 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_2"] | p_material_2 | 행/컬럼 값 대입 |  |  |  |
| AC-778732ac | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1341 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_2"] | p_level_name_2 | 행/컬럼 값 대입 |  |  |  |
| AC-9fc819a0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1342 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_2"] | p_input_rate_2 | 행/컬럼 값 대입 |  |  |  |
| AC-a58ad01c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1343 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_3"] | p_material_3 | 행/컬럼 값 대입 |  |  |  |
| AC-3ffd35ee | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1344 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_3"] | p_level_name_3 | 행/컬럼 값 대입 |  |  |  |
| AC-88a83cbb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1345 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_3"] | p_input_rate_3 | 행/컬럼 값 대입 |  |  |  |
| AC-d0ca6d7b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1346 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_4"] | p_material_4 | 행/컬럼 값 대입 |  |  |  |
| AC-95a086a0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1347 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_4"] | p_level_name_4 | 행/컬럼 값 대입 |  |  |  |
| AC-ff021a1b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1348 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_4"] | p_input_rate_4 | 행/컬럼 값 대입 |  |  |  |
| AC-60ba8927 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1349 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_5"] | p_material_5 | 행/컬럼 값 대입 |  |  |  |
| AC-ebeb74d5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1350 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_5"] | p_level_name_5 | 행/컬럼 값 대입 |  |  |  |
| AC-8ff4ed49 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1351 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_5"] | p_input_rate_5 | 행/컬럼 값 대입 |  |  |  |
| AC-6598be8d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1352 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_6"] | p_material_6 | 행/컬럼 값 대입 |  |  |  |
| AC-61acd780 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1353 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_6"] | p_level_name_6 | 행/컬럼 값 대입 |  |  |  |
| AC-2aa36aea | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1354 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_6"] | p_input_rate_6 | 행/컬럼 값 대입 |  |  |  |
| AC-90bec0a2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1355 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_7"] | p_material_7 | 행/컬럼 값 대입 |  |  |  |
| AC-eb3a132e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1356 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_7"] | p_level_name_7 | 행/컬럼 값 대입 |  |  |  |
| AC-28cfd79c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1357 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_7"] | p_input_rate_7 | 행/컬럼 값 대입 |  |  |  |
| AC-319b301f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1358 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_8"] | p_material_8 | 행/컬럼 값 대입 |  |  |  |
| AC-c3193dfa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1359 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_8"] | p_level_name_8 | 행/컬럼 값 대입 |  |  |  |
| AC-64a57606 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1360 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_8"] | p_input_rate_8 | 행/컬럼 값 대입 |  |  |  |
| AC-3f6a8767 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1361 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_9"] | p_material_9 | 행/컬럼 값 대입 |  |  |  |
| AC-f86c0cfa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1362 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_9"] | p_level_name_9 | 행/컬럼 값 대입 |  |  |  |
| AC-0973f8ae | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1363 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_9"] | p_input_rate_9 | 행/컬럼 값 대입 |  |  |  |
| AC-468c783a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1364 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_10"] | p_material_10 | 행/컬럼 값 대입 |  |  |  |
| AC-edfb88c7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1365 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_10"] | p_level_name_10 | 행/컬럼 값 대입 |  |  |  |
| AC-2c1143b6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1366 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_10"] | p_input_rate_10 | 행/컬럼 값 대입 |  |  |  |
| AC-54e6c103 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1369 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11f6a869 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1370 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-59c34ea3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1376 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6cd2591e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | FP02650_SlurryBatchGroup_Master.cs:1382 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

