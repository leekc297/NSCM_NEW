# AS-IS 액션 대조표 — FM0011

> 원천: `Doc/asisfacts/screens/FM0011/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 432행 · 메서드 30 · 종류 DATA_OP 228 · FLAG 48 · RETURN 43 · GRID_SET 18 · GRID_INIT 14 · ENDPOINT 11 · UI_PROP 9 · MESSAGE 9 · UI_MISC 8 · POPUP 7 · VALIDATE 7 · COMBO_DATA 5 · GRID_LOCK 5 · LIST_REBIND 4 · THROW 4 · CALL_EXT 4 · GRID_BIND 3 · STATE 2 · EXCEL 1 · CALL_BASE 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 5


## FM0011_SlurryBatchGroup_Master.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5740e1e5 | this.btnSql.Click | FM0011_SlurryBatchGroup_Master.cs:413 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-aa61cc19 | this.btnSql.Click | FM0011_SlurryBatchGroup_Master.cs:414 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-abe5bb88 | this.btnSql.Click | FM0011_SlurryBatchGroup_Master.cs:416 |  | DATA_OP | popSql.Services.Add | ("SELECT_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-88e5fbf0 | this.btnSql.Click | FM0011_SlurryBatchGroup_Master.cs:417 |  | DATA_OP | popSql.Services.Add | ("SELECT_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-5573e6df | this.btnSql.Click | FM0011_SlurryBatchGroup_Master.cs:418 |  | DATA_OP | popSql.Services.Add | ("SELECT_BY_RATIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-60a3a7ff | this.btnSql.Click | FM0011_SlurryBatchGroup_Master.cs:419 |  | DATA_OP | popSql.Services.Add | ("SAVE_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-819236df | this.btnSql.Click | FM0011_SlurryBatchGroup_Master.cs:420 |  | DATA_OP | popSql.Services.Add | ("SAVE_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-a82e9b78 | this.btnSql.Click | FM0011_SlurryBatchGroup_Master.cs:421 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FM0011_SlurryBatchGroup_Master.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9d4d618 | cboSite.SelectedIndexChanged | FM0011_SlurryBatchGroup_Master.cs:1376 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-524a92fa | cboSite.SelectedIndexChanged | FM0011_SlurryBatchGroup_Master.cs:1381 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-20bebd85 | cboSite.SelectedIndexChanged | FM0011_SlurryBatchGroup_Master.cs:1384 | try | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-0ca51e44 | cboSite.SelectedIndexChanged | FM0011_SlurryBatchGroup_Master.cs:1384 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37ab88dc | cboSite.SelectedIndexChanged | FM0011_SlurryBatchGroup_Master.cs:1385 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2491428c | cboSite.SelectedIndexChanged | FM0011_SlurryBatchGroup_Master.cs:1391 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0011_SlurryBatchGroup_Master.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aae6631c | this.Load | FM0011_SlurryBatchGroup_Master.cs:246 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-97685fe2 | this.Load | FM0011_SlurryBatchGroup_Master.cs:247 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-69fee8f4 | this.Load | FM0011_SlurryBatchGroup_Master.cs:250 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b7c88eef | this.Load | FM0011_SlurryBatchGroup_Master.cs:251 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-e4508904 | this.Load | FM0011_SlurryBatchGroup_Master.cs:254 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d11e4aa1 | this.Load | FM0011_SlurryBatchGroup_Master.cs:258 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FM0011_SlurryBatchGroup_Master.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f358873e | this.Load | FM0011_SlurryBatchGroup_Master.cs:164 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-090c6b70 | this.Load | FM0011_SlurryBatchGroup_Master.cs:166 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-bac6acb8 | this.Load | FM0011_SlurryBatchGroup_Master.cs:167 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-c836b767 | this.Load | FM0011_SlurryBatchGroup_Master.cs:168 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FM0011_SlurryBatchGroup_Master.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6610477 | DeleteButton | FM0011_SlurryBatchGroup_Master.cs:368 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d612e36f | DeleteButton | FM0011_SlurryBatchGroup_Master.cs:383 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iClickSubRow == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4482541d | DeleteButton | FM0011_SlurryBatchGroup_Master.cs:387 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.Acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ab74cb6 | DeleteButton | FM0011_SlurryBatchGroup_Master.cs:391 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b540ede3 | Dispose | FM0011_SlurryBatchGroup_Master.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FM0011_SlurryBatchGroup_Master.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93116314 | EditButton | FM0011_SlurryBatchGroup_Master.cs:306 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec54c2eb | EditButton | FM0011_SlurryBatchGroup_Master.cs:308 | if (bSubSearchDoubleClick == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23944323 | EditButton | FM0011_SlurryBatchGroup_Master.cs:316 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | FLAG | bMainLockMode | !bMainLockMode | 화면 필드/플래그 변경 |  |  |  |
| AC-c2b9cd9d | EditButton | FM0011_SlurryBatchGroup_Master.cs:317 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.SetLockFlag | (spdMain.Name, bMainLockMode) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9ff6e57d | EditButton | FM0011_SlurryBatchGroup_Master.cs:319 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_SET | spdMain.ActiveSheet.OperationMode | OperationMode.ReadOnly | 그리드 속성/값 설정 |  |  |  |
| AC-6c2c3e93 | EditButton | FM0011_SlurryBatchGroup_Master.cs:320 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | FLAG | bMainCheckLockMode | !bMainCheckLockMode | 화면 필드/플래그 변경 |  |  |  |
| AC-510a3736 | EditButton | FM0011_SlurryBatchGroup_Master.cs:329 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-64b58688 | EditButton | FM0011_SlurryBatchGroup_Master.cs:330 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b03d49cb | EditButton | FM0011_SlurryBatchGroup_Master.cs:331 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.LockColumn | (0, siSub.GetColumnIndex(DefColumns.RATIO_NAME), true) | 그리드 편집 잠금/해제 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cc559e7 | ExcelButton | FM0011_SlurryBatchGroup_Master.cs:447 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Find_Data_Main

진입점: popSql.OnSql [if (programID == "SELECT_MAIN")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b334dd6 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:544 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivision = CString.GetCheckedListValue(dtM… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e1f6a3c | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:558 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0011_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FM0011_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-dc34ac5b | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:559 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-20f309e4 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:560 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-483fae68 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:561 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9fcde220 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:562 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7b93adf2 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:564 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-70b5cc11 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:565 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fe64fb67 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:566 | try | DATA_OP | request.Parameters["p_site_id"] | pSite.Equals("ALL") ? DBNull.Value : pSite | 행/컬럼 값 대입 |  |  |  |
| AC-2d641ebf | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:567 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant.Equals("ALL") ? DBNull.Value : pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-1b058135 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:568 | try | DATA_OP | request.Parameters["p_batch_ratio_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-26a477b7 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:569 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5672b149 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:570 | try | DATA_OP | request.Parameters["p_parent_item_id"] | pItem | 행/컬럼 값 대입 |  |  |  |
| AC-51c223a8 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:571 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-df7a2211 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:572 | try | DATA_OP | request.Parameters["p_parent_item_class"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-290e16c6 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:573 | try | DATA_OP | request.Parameters["p_material_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5a6132ae | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:574 | try | DATA_OP | request.Parameters["p_level_name_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-943b6ffc | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:575 | try | DATA_OP | request.Parameters["p_input_rate_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9ca26e42 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:576 | try | DATA_OP | request.Parameters["p_material_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-72586625 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:577 | try | DATA_OP | request.Parameters["p_level_name_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7e9bc5f6 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:578 | try | DATA_OP | request.Parameters["p_input_rate_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a800b1ac | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:579 | try | DATA_OP | request.Parameters["p_material_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8c572a4d | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:580 | try | DATA_OP | request.Parameters["p_level_name_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2a51516f | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:581 | try | DATA_OP | request.Parameters["p_input_rate_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a7c2c525 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:582 | try | DATA_OP | request.Parameters["p_material_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-443b130e | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:583 | try | DATA_OP | request.Parameters["p_level_name_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-137cd067 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:584 | try | DATA_OP | request.Parameters["p_input_rate_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0c78fb73 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:585 | try | DATA_OP | request.Parameters["p_material_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-056f7055 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:586 | try | DATA_OP | request.Parameters["p_level_name_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4d0c9e9f | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:587 | try | DATA_OP | request.Parameters["p_input_rate_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cd8763f8 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:588 | try | DATA_OP | request.Parameters["p_material_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b96ebf22 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:589 | try | DATA_OP | request.Parameters["p_level_name_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9c1559f5 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:590 | try | DATA_OP | request.Parameters["p_input_rate_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-33ccac28 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:591 | try | DATA_OP | request.Parameters["p_material_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e015143b | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:592 | try | DATA_OP | request.Parameters["p_level_name_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-45d7db5f | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:593 | try | DATA_OP | request.Parameters["p_input_rate_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9118b287 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:594 | try | DATA_OP | request.Parameters["p_material_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-841aed50 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:595 | try | DATA_OP | request.Parameters["p_level_name_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a60e5fa6 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:596 | try | DATA_OP | request.Parameters["p_input_rate_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ba9f157e | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:597 | try | DATA_OP | request.Parameters["p_material_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fca3aed6 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:598 | try | DATA_OP | request.Parameters["p_level_name_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2795fc6b | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:599 | try | DATA_OP | request.Parameters["p_input_rate_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-af876967 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:600 | try | DATA_OP | request.Parameters["p_material_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ca7cf9d7 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:601 | try | DATA_OP | request.Parameters["p_level_name_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e4ce07d4 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:602 | try | DATA_OP | request.Parameters["p_input_rate_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-618875b5 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:604 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d671367d | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:606 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e624ea4a | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:611 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-afebab65 | popSql.OnSql [if (programID == "SELECT_MAIN")] 외 2 | FM0011_SlurryBatchGroup_Master.cs:615 | finally | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Find_Data_Main_By_Ratio

진입점: this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0)] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "SELECT_BY_RATIO")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cebb0fd | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1261 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7b264244 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1267 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f68bd4c1 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1269 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-68fc8b67 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1273 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0011_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FM0011_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-00e2d023 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1274 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-e306e5c6 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1275 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_BY_RATIO" | 행/컬럼 값 대입 |  |  |  |
| AC-2093fcfb | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1276 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9639a6e1 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1277 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a46ca6b7 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1279 | try | DATA_OP | request.Parameters["p_company_id"] | pCompany | 행/컬럼 값 대입 |  |  |  |
| AC-49189b26 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1280 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-85c7c480 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1281 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-63649833 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1282 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-cb75a0fd | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1283 | try | DATA_OP | request.Parameters["p_batch_ratio_id"] | pRatio | 행/컬럼 값 대입 |  |  |  |
| AC-d84d9caa | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1284 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f867c1b6 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1285 | try | DATA_OP | request.Parameters["p_parent_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c7ba8b79 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1286 | try | DATA_OP | request.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0b62d720 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1287 | try | DATA_OP | request.Parameters["p_parent_item_class"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-345fa0bc | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1288 | try | DATA_OP | request.Parameters["p_material_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-86b0e6e1 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1289 | try | DATA_OP | request.Parameters["p_level_name_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-50fd5311 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1290 | try | DATA_OP | request.Parameters["p_input_rate_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-76ba8095 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1291 | try | DATA_OP | request.Parameters["p_material_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8af632cb | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1292 | try | DATA_OP | request.Parameters["p_level_name_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5e164634 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1293 | try | DATA_OP | request.Parameters["p_input_rate_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7927efa2 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1294 | try | DATA_OP | request.Parameters["p_material_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fc9e1e14 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1295 | try | DATA_OP | request.Parameters["p_level_name_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1ff666de | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1296 | try | DATA_OP | request.Parameters["p_input_rate_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c70c4711 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1297 | try | DATA_OP | request.Parameters["p_material_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-20094a03 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1298 | try | DATA_OP | request.Parameters["p_level_name_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-83a6fa73 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1299 | try | DATA_OP | request.Parameters["p_input_rate_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-479b6c26 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1300 | try | DATA_OP | request.Parameters["p_material_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2a0a8daa | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1301 | try | DATA_OP | request.Parameters["p_level_name_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d46e1467 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1302 | try | DATA_OP | request.Parameters["p_input_rate_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b9389d8f | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1303 | try | DATA_OP | request.Parameters["p_material_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-66500145 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1304 | try | DATA_OP | request.Parameters["p_level_name_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0f36b7e7 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1305 | try | DATA_OP | request.Parameters["p_input_rate_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d8ec0459 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1306 | try | DATA_OP | request.Parameters["p_material_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a18dc798 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1307 | try | DATA_OP | request.Parameters["p_level_name_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a29f34dd | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1308 | try | DATA_OP | request.Parameters["p_input_rate_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8bf64b0e | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1309 | try | DATA_OP | request.Parameters["p_material_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a9208e50 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1310 | try | DATA_OP | request.Parameters["p_level_name_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-608ae3a6 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1311 | try | DATA_OP | request.Parameters["p_input_rate_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a3e6894c | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1312 | try | DATA_OP | request.Parameters["p_material_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4c2ab2cb | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1313 | try | DATA_OP | request.Parameters["p_level_name_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-462132cb | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1314 | try | DATA_OP | request.Parameters["p_input_rate_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-24d682b4 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1315 | try | DATA_OP | request.Parameters["p_material_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-53959589 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1316 | try | DATA_OP | request.Parameters["p_level_name_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-648908dc | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1317 | try | DATA_OP | request.Parameters["p_input_rate_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-64933f10 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1318 | try | DATA_OP | request.Parameters["p_material_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-44312d88 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1319 | try | DATA_OP | request.Parameters["p_level_name_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-43755a5b | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1320 | try | DATA_OP | request.Parameters["p_input_rate_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4895d713 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1323 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2c3ee59a | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1329 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-48839440 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1332 | try | FLAG | bMainCheckLockMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bfdfc52c | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1333 | try | FLAG | bSubSearchDoubleClick | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3d425808 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1342 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-3de5a5aa | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1346 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8febfab9 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1350 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Find_Data_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Row >= 0) ▸ try] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB")] / FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ if (MessageBox.Show("In Case Delete, Data dependent on Group Batch to be deleted exists.\r\n Do you want to proceed with the…) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52dcb120 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:686 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0011_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FM0011_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-56afef7c | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:687 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-1ecdbe07 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:688 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_SUB" | 행/컬럼 값 대입 |  |  |  |
| AC-02f152ee | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:689 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7aadefe4 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:690 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-28e175d1 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:692 | try | DATA_OP | request.Parameters["p_company_id"] | pCompany | 행/컬럼 값 대입 |  |  |  |
| AC-96738909 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:693 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-04037812 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:694 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-efad9b68 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:695 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-1517b888 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:696 | try | DATA_OP | request.Parameters["p_batch_ratio_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9f3418f6 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:697 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1e133704 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:698 | try | DATA_OP | request.Parameters["p_parent_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-11e4a545 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:699 | try | DATA_OP | request.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-50ce3f7d | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:700 | try | DATA_OP | request.Parameters["p_parent_item_class"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bfda1a3a | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:701 | try | DATA_OP | request.Parameters["p_material_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-800ec6b5 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:702 | try | DATA_OP | request.Parameters["p_level_name_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8604beb6 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:703 | try | DATA_OP | request.Parameters["p_input_rate_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f774dcd9 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:704 | try | DATA_OP | request.Parameters["p_material_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-49f8cbb3 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:705 | try | DATA_OP | request.Parameters["p_level_name_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f3a51bd3 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:706 | try | DATA_OP | request.Parameters["p_input_rate_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ad282823 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:707 | try | DATA_OP | request.Parameters["p_material_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c0ded4f8 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:708 | try | DATA_OP | request.Parameters["p_level_name_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2dee0e48 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:709 | try | DATA_OP | request.Parameters["p_input_rate_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a604324e | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:710 | try | DATA_OP | request.Parameters["p_material_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8d2b8f38 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:711 | try | DATA_OP | request.Parameters["p_level_name_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1472fe5d | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:712 | try | DATA_OP | request.Parameters["p_input_rate_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4f5365aa | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:713 | try | DATA_OP | request.Parameters["p_material_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-356c63d2 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:714 | try | DATA_OP | request.Parameters["p_level_name_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2a270d8f | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:715 | try | DATA_OP | request.Parameters["p_input_rate_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-83beb049 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:716 | try | DATA_OP | request.Parameters["p_material_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-47f511b3 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:717 | try | DATA_OP | request.Parameters["p_level_name_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0224da2b | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:718 | try | DATA_OP | request.Parameters["p_input_rate_6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d37b4125 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:719 | try | DATA_OP | request.Parameters["p_material_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-862c2278 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:720 | try | DATA_OP | request.Parameters["p_level_name_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-49bac461 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:721 | try | DATA_OP | request.Parameters["p_input_rate_7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1108e6a7 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:722 | try | DATA_OP | request.Parameters["p_material_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-182fe694 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:723 | try | DATA_OP | request.Parameters["p_level_name_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3aa6ac00 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:724 | try | DATA_OP | request.Parameters["p_input_rate_8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ecd3a402 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:725 | try | DATA_OP | request.Parameters["p_material_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-381d2ee9 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:726 | try | DATA_OP | request.Parameters["p_level_name_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-500743f0 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:727 | try | DATA_OP | request.Parameters["p_input_rate_9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-235a002f | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:728 | try | DATA_OP | request.Parameters["p_material_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7b766e3a | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:729 | try | DATA_OP | request.Parameters["p_level_name_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5be807a8 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:730 | try | DATA_OP | request.Parameters["p_input_rate_10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-72a58706 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:732 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b969d190 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:734 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5bcc2f6c | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 3 | FM0011_SlurryBatchGroup_Master.cs:739 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Find_Main

진입점: FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a049e0a | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:456 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-22e85dfe | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:460 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-326c1f88 | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:463 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b42d9ab5 | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:463 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a19284f | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:469 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7c1205de | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:472 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-296711b8 | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:478 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1454507e | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:479 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Main("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9324d777 | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:487 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2a230e53 | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:489 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-36f7b8a4 | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:492 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-841d2334 | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:516 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-fdc9027d | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:526 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-51c3f3da | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:528 | finally | FLAG | bMainCheckLockMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3c2118e8 | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:529 | finally | FLAG | bSubSearchDoubleClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-29430224 | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:530 | finally | FLAG | bMainLockMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a506f6a2 | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:532 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dccffd7a | FindButton 외 1 | FM0011_SlurryBatchGroup_Master.cs:532 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Find_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Row >= 0)] / FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ if (MessageBox.Show("In Case Delete, Data dependent on Group Batch to be deleted exists.\r\n Do you want to proceed with the…) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7164d55e | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FM0011_SlurryBatchGroup_Master.cs:622 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5b094cc5 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FM0011_SlurryBatchGroup_Master.cs:636 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22d9882f | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FM0011_SlurryBatchGroup_Master.cs:647 | try | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-969fc74e | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FM0011_SlurryBatchGroup_Master.cs:652 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dc54771d | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FM0011_SlurryBatchGroup_Master.cs:660 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cb48e380 | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FM0011_SlurryBatchGroup_Master.cs:673 | finally | GRID_SET | this.spdSub.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a0aefdac | this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Ro… 외 2 | FM0011_SlurryBatchGroup_Master.cs:673 | finally | CALL_EXT | this.spdSub.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5fab831 | this.Load | FM0011_SlurryBatchGroup_Master.cs:138 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FM0011_SlurryBatchGroup_Master.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bd77071 | this.Load | FM0011_SlurryBatchGroup_Master.cs:177 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8094942 | this.Load | FM0011_SlurryBatchGroup_Master.cs:183 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3495af92 | this.Load | FM0011_SlurryBatchGroup_Master.cs:184 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d0b57091 | this.Load | FM0011_SlurryBatchGroup_Master.cs:187 | try | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee5e0ff7 | this.Load | FM0011_SlurryBatchGroup_Master.cs:187 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-36c36133 | this.Load | FM0011_SlurryBatchGroup_Master.cs:188 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-794b1a86 | this.Load | FM0011_SlurryBatchGroup_Master.cs:198 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-8138c65e | this.Load | FM0011_SlurryBatchGroup_Master.cs:199 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7aac099d | this.Load | FM0011_SlurryBatchGroup_Master.cs:200 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-30e0419e | this.Load | FM0011_SlurryBatchGroup_Master.cs:203 | try | FLAG | bMainCheckLockMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0c1e563d | this.Load | FM0011_SlurryBatchGroup_Master.cs:204 | try | FLAG | bSubSearchDoubleClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5d79be94 | this.Load | FM0011_SlurryBatchGroup_Master.cs:208 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0011_SlurryBatchGroup_Master.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4151ed68 | this.Load | FM0011_SlurryBatchGroup_Master.cs:265 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2cbcd3b8 | this.Load | FM0011_SlurryBatchGroup_Master.cs:268 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-27f23aaf | this.Load | FM0011_SlurryBatchGroup_Master.cs:272 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.BATCH_RATIO_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-60f3acd5 | this.Load | FM0011_SlurryBatchGroup_Master.cs:275 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.VALID_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-554c9765 | this.Load | FM0011_SlurryBatchGroup_Master.cs:280 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-dbcbef65 | this.Load | FM0011_SlurryBatchGroup_Master.cs:283 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-aaedaef3 | this.Load | FM0011_SlurryBatchGroup_Master.cs:285 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, siSub.GetColumnIndex(DefColumns.DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FM0011_SlurryBatchGroup_Master.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be1f8696 | popSql.OnSql | FM0011_SlurryBatchGroup_Master.cs:1562 | if (programID == "SELECT_MAIN") | RETURN | return Find_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-1c285b68 | popSql.OnSql | FM0011_SlurryBatchGroup_Master.cs:1573 | else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_SUB") | RETURN | return Find_Data_Sub("SQL", pCompany, pDivision, pSite, pPlant); |  | 처리 중단/반환 |  |  |  |
| AC-ebfefbbd | popSql.OnSql | FM0011_SlurryBatchGroup_Master.cs:1584 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "SELECT_BY_RATIO") | RETURN | return Find_Data_Main_By_Ratio(pCompany, pDivision, pSite, pPlant, pRatio, "SQL"… |  | 처리 중단/반환 |  |  |  |
| AC-441b1f89 | popSql.OnSql | FM0011_SlurryBatchGroup_Master.cs:1589 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ if (programID == "SA… | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-b9481af0 | popSql.OnSql | FM0011_SlurryBatchGroup_Master.cs:1589 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ if (programID == "SA… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c1c97ea4 | popSql.OnSql | FM0011_SlurryBatchGroup_Master.cs:1590 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ if (programID == "SA… | RETURN | return Save_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-608691d0 | popSql.OnSql | FM0011_SlurryBatchGroup_Master.cs:1595 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ else of (programID =… | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-9e4e28c5 | popSql.OnSql | FM0011_SlurryBatchGroup_Master.cs:1595 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ else of (programID =… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-369a42ca | popSql.OnSql | FM0011_SlurryBatchGroup_Master.cs:1596 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ else of (programID =… | RETURN | return Save_Data_Sub("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-441f3fbe | popSql.OnSql | FM0011_SlurryBatchGroup_Master.cs:1599 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Save_Data_Main

진입점: popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ if (programID == "SAVE_MAIN")] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cd7f3b9 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:878 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.BATCH_RATIO_ID)).ToString().Equals("[New … | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FM0011_findNewBatch", sCompany, sDivision, sSite, sBatchRatio) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1e2d4e81 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:939 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0011_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FM0011_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-e32ec4eb | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:940 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9a6c8bbb | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:942 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b7de9662 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:943 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a4655057 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:944 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-0f1f8475 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:945 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-81cd678c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:946 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-e758de1c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:947 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9637718c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:948 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-e59e78fd | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:949 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-c4050672 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:950 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_batch_ratio_id"] | p_batch_ratio_id | 행/컬럼 값 대입 |  |  |  |
| AC-95f84ab0 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:951 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-a160dda3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:952 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_parent_item_id"] | p_parent_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-157e08cd | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:953 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-da51218c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:954 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_parent_item_class"] | p_parent_item_class | 행/컬럼 값 대입 |  |  |  |
| AC-fe09aa30 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:955 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_1"] | p_material_1 | 행/컬럼 값 대입 |  |  |  |
| AC-dd3089f4 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:956 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_1"] | p_level_name_1 | 행/컬럼 값 대입 |  |  |  |
| AC-b16e8f25 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:957 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_1"] | p_input_rate_1 | 행/컬럼 값 대입 |  |  |  |
| AC-332f5efe | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:958 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_2"] | p_material_2 | 행/컬럼 값 대입 |  |  |  |
| AC-c63ca6af | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:959 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_2"] | p_level_name_2 | 행/컬럼 값 대입 |  |  |  |
| AC-7c03919f | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:960 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_2"] | p_input_rate_2 | 행/컬럼 값 대입 |  |  |  |
| AC-efed89ba | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:961 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_3"] | p_material_3 | 행/컬럼 값 대입 |  |  |  |
| AC-67767354 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:962 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_3"] | p_level_name_3 | 행/컬럼 값 대입 |  |  |  |
| AC-e2d69cb3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:963 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_3"] | p_input_rate_3 | 행/컬럼 값 대입 |  |  |  |
| AC-b861aad6 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:964 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_4"] | p_material_4 | 행/컬럼 값 대입 |  |  |  |
| AC-c4965257 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:965 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_4"] | p_level_name_4 | 행/컬럼 값 대입 |  |  |  |
| AC-b0724ed7 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:966 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_4"] | p_input_rate_4 | 행/컬럼 값 대입 |  |  |  |
| AC-91eab79d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:967 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_5"] | p_material_5 | 행/컬럼 값 대입 |  |  |  |
| AC-07429b00 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:968 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_5"] | p_level_name_5 | 행/컬럼 값 대입 |  |  |  |
| AC-ea6cce82 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:969 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_5"] | p_input_rate_5 | 행/컬럼 값 대입 |  |  |  |
| AC-747b1e08 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:970 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_6"] | p_material_6 | 행/컬럼 값 대입 |  |  |  |
| AC-1449a03b | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:971 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_6"] | p_level_name_6 | 행/컬럼 값 대입 |  |  |  |
| AC-65edebaa | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:972 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_6"] | p_input_rate_6 | 행/컬럼 값 대입 |  |  |  |
| AC-7f77d200 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:973 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_7"] | p_material_7 | 행/컬럼 값 대입 |  |  |  |
| AC-d23eb36c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:974 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_7"] | p_level_name_7 | 행/컬럼 값 대입 |  |  |  |
| AC-99347b3c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:975 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_7"] | p_input_rate_7 | 행/컬럼 값 대입 |  |  |  |
| AC-bc007689 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:976 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_8"] | p_material_8 | 행/컬럼 값 대입 |  |  |  |
| AC-7f6c1ae1 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:977 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_8"] | p_level_name_8 | 행/컬럼 값 대입 |  |  |  |
| AC-c855ccd3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:978 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_8"] | p_input_rate_8 | 행/컬럼 값 대입 |  |  |  |
| AC-22f3591c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:979 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_9"] | p_material_9 | 행/컬럼 값 대입 |  |  |  |
| AC-6cd1512d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:980 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_9"] | p_level_name_9 | 행/컬럼 값 대입 |  |  |  |
| AC-aff2235e | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:981 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_9"] | p_input_rate_9 | 행/컬럼 값 대입 |  |  |  |
| AC-2a95d692 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:982 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_10"] | p_material_10 | 행/컬럼 값 대입 |  |  |  |
| AC-e6528177 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:983 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_10"] | p_level_name_10 | 행/컬럼 값 대입 |  |  |  |
| AC-097d41f0 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:984 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_10"] | p_input_rate_10 | 행/컬럼 값 대입 |  |  |  |
| AC-477a51fa | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:987 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3bffa64f | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:988 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-703a22d1 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:994 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-396c559f | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1000 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Save_Data_Sub

진입점: popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "SELECT_BY_RATIO") ▸ else of (programID == "SAVE_MAIN") ▸ if (programID == "SAVE_SUB")] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ if (MessageBox.Show("In Case Delete, Data dependent on Group Batch to be deleted exists.\r\n Do you want to proceed with the…) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6bfed5b | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1195 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0011_SLURRYBATCHGROUP_MASTER") ⇒ FP_Master.PR_UI_FM0011_SLURRYBATCHGROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-e6bf3d53 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1196 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e7de778c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1198 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-2a174895 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1199 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ec09e9c8 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1200 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-35dcfc12 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1201 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-dddc3f75 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1202 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-e7c3cbd2 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1203 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5d7f5883 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1204 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d9d46311 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1205 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-b8188074 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1206 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_batch_ratio_id"] | p_batch_ratio_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e0e763b | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1207 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-ef554731 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1208 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_parent_item_id"] | p_parent_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-823c72d9 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1209 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-a4220c34 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1210 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_parent_item_class"] | p_parent_item_class | 행/컬럼 값 대입 |  |  |  |
| AC-caa5a523 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1211 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_1"] | p_material_1 | 행/컬럼 값 대입 |  |  |  |
| AC-1752b6bb | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1212 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_1"] | p_level_name_1 | 행/컬럼 값 대입 |  |  |  |
| AC-3413c0a0 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1213 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_1"] | p_input_rate_1 | 행/컬럼 값 대입 |  |  |  |
| AC-726d5eff | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1214 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_2"] | p_material_2 | 행/컬럼 값 대입 |  |  |  |
| AC-87cc0744 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1215 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_2"] | p_level_name_2 | 행/컬럼 값 대입 |  |  |  |
| AC-94d9bd20 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1216 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_2"] | p_input_rate_2 | 행/컬럼 값 대입 |  |  |  |
| AC-fe1fbd5c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1217 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_3"] | p_material_3 | 행/컬럼 값 대입 |  |  |  |
| AC-deb8a5d2 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1218 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_3"] | p_level_name_3 | 행/컬럼 값 대입 |  |  |  |
| AC-eeff6b25 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1219 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_3"] | p_input_rate_3 | 행/컬럼 값 대입 |  |  |  |
| AC-15420ec2 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1220 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_4"] | p_material_4 | 행/컬럼 값 대입 |  |  |  |
| AC-de1d9d59 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1221 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_4"] | p_level_name_4 | 행/컬럼 값 대입 |  |  |  |
| AC-45c1c303 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1222 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_4"] | p_input_rate_4 | 행/컬럼 값 대입 |  |  |  |
| AC-35288a87 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1223 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_5"] | p_material_5 | 행/컬럼 값 대입 |  |  |  |
| AC-6fb16bf8 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1224 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_5"] | p_level_name_5 | 행/컬럼 값 대입 |  |  |  |
| AC-d53f0af0 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1225 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_5"] | p_input_rate_5 | 행/컬럼 값 대입 |  |  |  |
| AC-2e092878 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1226 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_6"] | p_material_6 | 행/컬럼 값 대입 |  |  |  |
| AC-ebd37b2a | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1227 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_6"] | p_level_name_6 | 행/컬럼 값 대입 |  |  |  |
| AC-c3d61359 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1228 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_6"] | p_input_rate_6 | 행/컬럼 값 대입 |  |  |  |
| AC-702805d3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1229 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_7"] | p_material_7 | 행/컬럼 값 대입 |  |  |  |
| AC-73e10cd0 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1230 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_7"] | p_level_name_7 | 행/컬럼 값 대입 |  |  |  |
| AC-eabf169d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1231 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_7"] | p_input_rate_7 | 행/컬럼 값 대입 |  |  |  |
| AC-23cde5e4 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1232 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_8"] | p_material_8 | 행/컬럼 값 대입 |  |  |  |
| AC-ce30dc78 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1233 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_8"] | p_level_name_8 | 행/컬럼 값 대입 |  |  |  |
| AC-0c5514b3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1234 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_8"] | p_input_rate_8 | 행/컬럼 값 대입 |  |  |  |
| AC-2e9e3e2c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1235 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_9"] | p_material_9 | 행/컬럼 값 대입 |  |  |  |
| AC-675159e5 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1236 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_9"] | p_level_name_9 | 행/컬럼 값 대입 |  |  |  |
| AC-96d903a6 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1237 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_9"] | p_input_rate_9 | 행/컬럼 값 대입 |  |  |  |
| AC-1e5703c3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1238 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_material_10"] | p_material_10 | 행/컬럼 값 대입 |  |  |  |
| AC-e5730101 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1239 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_level_name_10"] | p_level_name_10 | 행/컬럼 값 대입 |  |  |  |
| AC-fedc9048 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1240 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_input_rate_10"] | p_input_rate_10 | 행/컬럼 값 대입 |  |  |  |
| AC-7c2f133c | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1242 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-54bf2ec6 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1243 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-750af02d | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1249 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5a40ecf3 | popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of… 외 1 | FM0011_SlurryBatchGroup_Master.cs:1255 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Save_Main

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-453ce158 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:746 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-bf25b6de | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:746 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4768ded4 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:748 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0ad2feb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:750 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29effdb4 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:755 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-114e249e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:756 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba3fc885 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:759 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d1837c3e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:766 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-8c63fdae | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:768 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1ea80c9b | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:769 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef02f9fb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:774 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fd835ebf | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:779 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fbba339f | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:788 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-678f77eb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:792 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-003479b0 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:796 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d70a08dc | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:797 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d143dda0 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:802 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-975f2c4d | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FM0011_SlurryBatchGroup_Master.cs:803 | finally | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FM0011_SlurryBatchGroup_Master.Save_Sub

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ if (MessageBox.Show("In Case Delete, Data dependent on Group Batch to be deleted exists.\r\n Do you want to proceed with the…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7310f4f7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1006 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-5a5acd39 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1006 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7cefa8ad | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1008 | if (siSub == null \|\| siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ce4fe1f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1010 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2be175c0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1015 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-decd1c05 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1016 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe9bcc83 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1019 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9154f959 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1026 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-ea752b14 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1028 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b1e5d1fe | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1029 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f467b4a | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1034 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8a054bb3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1039 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-635dd4cf | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1053 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd44ca5d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1057 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-24b68878 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1061 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7d6dd737 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1062 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ed6d005 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1067 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-998087ad | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FM0011_SlurryBatchGroup_Master.cs:1068 | finally | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FM0011_SlurryBatchGroup_Master.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3709ce26 | SaveButton | FM0011_SlurryBatchGroup_Master.cs:341 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61ef85bc | SaveButton | FM0011_SlurryBatchGroup_Master.cs:354 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) | MESSAGE | MessageBox.Show | ("In Case Delete, Data dependent on Group Batch to be deleted exists.\r\n Do you want to p… | 메시지 표시 |  |  |  |

## FM0011_SlurryBatchGroup_Master.SetBackColorRowNumberGroup

진입점: this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0) ▸ try] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "SELECT_BY_RATIO") ▸ try] / FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds.Tables[0]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c21fceb9 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 3 | FM0011_SlurryBatchGroup_Master.cs:1529 | for (iRow < spdMain.ActiveSheet.Rows.Count) ▸ if (sFindBackRowNum.Equals("1")) | GRID_SET | siMain.ActiveSheet.Rows[iRow].BackColor | Color.PeachPuff | 그리드 속성/값 설정 |  |  |  |
| AC-0c3fffa9 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 3 | FM0011_SlurryBatchGroup_Master.cs:1531 | for (iRow < spdMain.ActiveSheet.Rows.Count) ▸ else of (sFindBackRowNum.Equals("1")) | GRID_SET | siMain.ActiveSheet.Rows[iRow].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |

## FM0011_SlurryBatchGroup_Master.SetChangedControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc5158e4 | this.Load [try] 외 1 | FM0011_SlurryBatchGroup_Master.cs:226 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ac4b6b8 | this.Load [try] 외 1 | FM0011_SlurryBatchGroup_Master.cs:228 | try | FLAG | dtSiteByDivision | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-85519aea | this.Load [try] 외 1 | FM0011_SlurryBatchGroup_Master.cs:228 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", "", "", "", pDivisi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eeb1d183 | this.Load [try] 외 1 | FM0011_SlurryBatchGroup_Master.cs:229 | try | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1d01c72a | this.Load [try] 외 1 | FM0011_SlurryBatchGroup_Master.cs:233 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-20917e5d | this.Load [try] 외 1 | FM0011_SlurryBatchGroup_Master.cs:235 | try | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-557da78e | this.Load [try] 외 1 | FM0011_SlurryBatchGroup_Master.cs:235 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-758f6cbc | this.Load [try] 외 1 | FM0011_SlurryBatchGroup_Master.cs:236 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FM0011_SlurryBatchGroup_Master.SetCheckCloumnEditMode

진입점: this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0) ▸ try] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "SELECT_BY_RATIO") ▸ try] / EditButton [if (this.fps != null) ▸ switch (fps.Name) case "spdMain":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a7b9ec1 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 2 | FM0011_SlurryBatchGroup_Master.cs:1537 |  | GRID_SET | spdMain.ActiveSheet.OperationMode | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-91ced460 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 2 | FM0011_SlurryBatchGroup_Master.cs:1538 |  | UI_PROP | spdMain.EditMode | true | 속성 EditMode 설정 |  |  |  |
| AC-0147d181 | this.spdSub.CellDoubleClick [if (siSub != null && siSub.IsLo… 외 2 | FM0011_SlurryBatchGroup_Master.cs:1543 | for (iRow < spdMain.ActiveSheet.Rows.Count) ▸ for (iCol < 2) | GRID_SET | spdMain.ActiveSheet.Cells[iRow, iCol].Locked | bLock | 그리드 속성/값 설정 |  |  |  |

## FM0011_SlurryBatchGroup_Master.SetSpdMainValueEditChange

진입점: this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellType(e.Row, e.Column).ToString() == "CheckBoxCellType")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79f01864 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1623 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | FLAG | iClickMainRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-1e599fb5 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1624 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79e7dc02 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1628 | try ▸ if (bMainCheckLockMode == true) | FLAG | iClickMainRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-fa8e7a05 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1629 | try ▸ if (bMainCheckLockMode == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfdd6bf1 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1634 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-29f73671 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1643 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.BATCH_RATIO_ID)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-b95dd557 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1644 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.DESCRIPTION)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-a74579bf | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1645 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ if (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Rows[e.Row].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-ed7d9603 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1667 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.BATCH_RATIO_ID)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-3ff0e5a0 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1668 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.DESCRIPTION)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-1041e686 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1669 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | GRID_SET | siMain.ActiveSheet.Rows[e.Row].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-23f436c0 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1670 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | GRID_SET | siMain.ActiveSheet.SetValue | (e.Row, e.Column, 0) | 그리드 값 설정 |  |  |  |
| AC-5b7e4c5a | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1672 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | FLAG | iClickMainRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-090271cd | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1673 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a63fe91d | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1674 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) ▸ if (bfindChecked == true) ▸ if (sChkRowNum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aaa6d7b3 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1682 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.BATCH_RATIO_ID)].Value | sRatioName | 그리드 속성/값 설정 |  |  |  |
| AC-7d2f1d87 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1683 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.DESCRIPTION)].Value | sDescription | 그리드 속성/값 설정 |  |  |  |
| AC-226710b3 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1686 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) ▸ else of (sValue.Equals("False")) | GRID_SET | siMain.ActiveSheet.Rows[e.Row].ForeColor | Color.Crimson | 그리드 속성/값 설정 |  |  |  |
| AC-835a2f78 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1689 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHK)) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d93f4710 | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1692 | try | FLAG | iClickMainRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-4bc4545e | this.spdMain.ButtonClicked [if (spdMain.ActiveSheet.GetCellT… | FM0011_SlurryBatchGroup_Master.cs:1696 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0011_SlurryBatchGroup_Master.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75b197dd | this.spdMain.ButtonClicked | FM0011_SlurryBatchGroup_Master.cs:1505 |  | CALL_EXT | spdMain.ActiveSheet.GetCellType | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |

## FM0011_SlurryBatchGroup_Master.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-598cf50b | this.spdMain.CellDoubleClick | FM0011_SlurryBatchGroup_Master.cs:1446 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | FLAG | iClickMainRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-90691509 | this.spdMain.CellDoubleClick | FM0011_SlurryBatchGroup_Master.cs:1447 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af29b390 | this.spdMain.CellDoubleClick | FM0011_SlurryBatchGroup_Master.cs:1461 | if (siMain != null) ▸ if (e.Row >= 0) | FLAG | iClickMainRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-f42785db | this.spdMain.CellDoubleClick | FM0011_SlurryBatchGroup_Master.cs:1466 |  | FLAG | iClickMainRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FM0011_SlurryBatchGroup_Master.spdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3621668e | this.spdSub.CellClick | FM0011_SlurryBatchGroup_Master.cs:1421 | try ▸ if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-50d3eaaf | this.spdSub.CellClick | FM0011_SlurryBatchGroup_Master.cs:1422 | try ▸ if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d838b978 | this.spdSub.CellClick | FM0011_SlurryBatchGroup_Master.cs:1426 | try ▸ if (siSub != null && e.Row >= 0) | FLAG | iClickSubRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-28347e09 | this.spdSub.CellClick | FM0011_SlurryBatchGroup_Master.cs:1429 | try | FLAG | iClickSubRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-f3f0866a | this.spdSub.CellClick | FM0011_SlurryBatchGroup_Master.cs:1433 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0011_SlurryBatchGroup_Master.SpdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c822b56 | this.spdSub.CellDoubleClick | FM0011_SlurryBatchGroup_Master.cs:1480 | if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | FLAG | iClickSubRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-91d784da | this.spdSub.CellDoubleClick | FM0011_SlurryBatchGroup_Master.cs:1481 | if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9a8ace7 | this.spdSub.CellDoubleClick | FM0011_SlurryBatchGroup_Master.cs:1495 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false && e.Column == siSub.GetColumnIndex(DefColumns.RATIO_NAME)) ▸ if (e.Row >= 0) | FLAG | iClickSubRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-56400c08 | this.spdSub.CellDoubleClick | FM0011_SlurryBatchGroup_Master.cs:1500 |  | FLAG | iClickSubRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

