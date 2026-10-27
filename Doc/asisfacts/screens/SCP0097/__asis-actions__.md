# AS-IS 액션 대조표 — SCP0097

> 원천: `Doc/asisfacts/screens/SCP0097/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 79행 · 메서드 20 · 종류 GRID_INIT 14 · DATA_OP 12 · RETURN 9 · FLAG 9 · UI_MISC 5 · ENDPOINT 5 · MESSAGE 5 · GRID_LOCK 4 · GRID_SET 3 · VALIDATE 3 · LIST_REBIND 2 · POPUP 2 · UI_PROP 2 · STATE_RESET 1 · GRID_BIND 1 · VALUE_SET 1 · CALL_EXT 1 · ⚠ 의미 확인 필요 1


## SCP0097_SCP_BOM_Elec.CheckScpYN

진입점: this.spdMain.EditChange [if (e.Column == iSCP_YN)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b8b8a7f | this.spdMain.EditChange [if (e.Column == iSCP_YN)] | SCP0097_SCP_BOM_Elec.cs:532 | try ▸ if (scpYN.Equals("N")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f967b824 | this.spdMain.EditChange [if (e.Column == iSCP_YN)] | SCP0097_SCP_BOM_Elec.cs:568 | try ▸ if (scpYN_Cnt > 1) | GRID_SET | siMain.SetValue | (eRow, iSCP_YN, "N") | 그리드 값 설정 |  |  |  |

## SCP0097_SCP_BOM_Elec.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66961ebd | (진입점 미연결) | SCP0097_SCP_BOM_Elec.cs:164 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-a3f271be | (진입점 미연결) | SCP0097_SCP_BOM_Elec.cs:165 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0097_SCP_BOM_Elec.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40cadbf6 | this.Load | SCP0097_SCP_BOM_Elec.cs:176 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-68733b87 | this.Load | SCP0097_SCP_BOM_Elec.cs:177 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d5ebaa5 | this.Load | SCP0097_SCP_BOM_Elec.cs:179 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0097_SCP_BOM_Elec.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4fc792d | Dispose | SCP0097_SCP_BOM_Elec.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0097_SCP_BOM_Elec.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3b2cf5e | EditButton | SCP0097_SCP_BOM_Elec.cs:250 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9b6d2b2f | EditButton | SCP0097_SCP_BOM_Elec.cs:251 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-114f8fec | EditButton | SCP0097_SCP_BOM_Elec.cs:255 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.USAGE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a3e69fff | EditButton | SCP0097_SCP_BOM_Elec.cs:256 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5e3acf58 | EditButton | SCP0097_SCP_BOM_Elec.cs:266 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if ((sTemp.ToU… | GRID_SET | siMain.ActiveSheet.Rows[iRow].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-fc334493 | EditButton | SCP0097_SCP_BOM_Elec.cs:267 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if ((sTemp.ToU… | GRID_SET | siMain.ActiveSheet.Rows[iRow].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |

## SCP0097_SCP_BOM_Elec.FindData_Main

진입점: FindButton / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d0aab8d | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:280 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-10015f6a | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:284 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-675257ed | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:284 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1a64170 | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:286 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-916b1efe | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:292 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-69767b9f | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:301 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c0060f63 | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:303 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ab075a81 | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:307 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0097_GET_SCP_BOM_ELEC") ⇒ SCP.SCP0097_GET_SCP_BOM_ELEC | 엔드포인트 요청 생성 |  |  |  |
| AC-6d4ab549 | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:308 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d01f76ee | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:309 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-41649ac8 | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:310 | try ▸ lambda | DATA_OP | request.Parameters["p_parent_id"] | p_parent_id | 행/컬럼 값 대입 |  |  |  |
| AC-1851cac4 | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:311 | try ▸ lambda | DATA_OP | request.Parameters["p_child_id"] | p_child_id | 행/컬럼 값 대입 |  |  |  |
| AC-efd8c4cb | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:312 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9ca8cff8 | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:314 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e8c6fb8 | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:316 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-dde1a878 | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:323 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fc67b6ec | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:324 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b259335a | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:326 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07445fee | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:329 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1a109877 | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:333 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-02bd449f | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:337 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4fb37b8d | FindButton 외 1 | SCP0097_SCP_BOM_Elec.cs:342 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0097_SCP_BOM_Elec.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfb89e01 | this.Load | SCP0097_SCP_BOM_Elec.cs:92 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0097_SCP_BOM_Elec.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b337536 | this.Load | SCP0097_SCP_BOM_Elec.cs:111 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f58c3f63 | this.Load | SCP0097_SCP_BOM_Elec.cs:114 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-2fea3bf4 | this.Load | SCP0097_SCP_BOM_Elec.cs:116 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0097_SCP_BOM_Elec.InitSpread

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-868903ee | this.Load 외 1 | SCP0097_SCP_BOM_Elec.cs:187 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6045a420 | this.Load 외 1 | SCP0097_SCP_BOM_Elec.cs:188 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0097_SCP_BOM_Elec.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3db9990b | SaveButton | SCP0097_SCP_BOM_Elec.cs:236 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0097_SCP_BOM_Elec.SaveData_Main

진입점: SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a258ad50 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:354 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2401f88a | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:368 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-44d6b008 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:368 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe9529a3 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:401 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0097_SAVE_SCP_BOM_ELEC") ⇒ SCP.SCP0097_SAVE_SCP_BOM_ELEC | 엔드포인트 요청 생성 |  |  |  |
| AC-b6b997f0 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:403 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-074547ca | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:404 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa86956c | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:405 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_parent_item_id"] | p_parent_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a199507a | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:406 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_child_item_id"] | p_child_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-80a8d7d4 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:407 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scp_yn"] | p_scp_yn | 행/컬럼 값 대입 |  |  |  |
| AC-5b9691d2 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:408 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_stock_yn"] | p_stock_yn | 행/컬럼 값 대입 |  |  |  |
| AC-f4ea77fc | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:409 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d6e3cd62 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:410 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | debug_mode | 행/컬럼 값 대입 |  |  |  |
| AC-446beaf3 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:412 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3102706d | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:417 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e680cfc | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:428 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-43b7c37e | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0097_SCP_BOM_Elec.cs:434 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0097_SCP_BOM_Elec.SelectCombo

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab1373f3 | OnShown | SCP0097_SCP_BOM_Elec.cs:137 | if (iIdx >= 0) | VALUE_SET | cCombo.SelectedIndex | iIdx | 컨트롤 값 설정 |  |  |  |

## SCP0097_SCP_BOM_Elec.SetSpreadInit

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / FindButton [try] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-138a09c8 | this.Load 외 3 | SCP0097_SCP_BOM_Elec.cs:195 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0175ea67 | this.Load 외 3 | SCP0097_SCP_BOM_Elec.cs:196 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-5fa3e6c4 | this.Load 외 3 | SCP0097_SCP_BOM_Elec.cs:197 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-fb523228 | this.Load 외 3 | SCP0097_SCP_BOM_Elec.cs:198 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2bf56bd4 | this.Load 외 3 | SCP0097_SCP_BOM_Elec.cs:199 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0097_SCP_BOM_Elec.ShowMessage

진입점: this.spdMain.EditChange [if (e.Column == iSCP_YN) ▸ try ▸ if (scpYN_Cnt > 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5501bf2 | this.spdMain.EditChange [if (e.Column == iSCP_YN) ▸ try ▸ if… | SCP0097_SCP_BOM_Elec.cs:579 |  | MESSAGE | MessageBox.Show | (this, message, "GSCM", MessageBoxButtons.OK, MessageBoxIcon.Information) | 메시지 표시 |  |  |  |

## SCP0097_SCP_BOM_Elec.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba84ae48 | this.spdMain.ActiveSheetChanged | SCP0097_SCP_BOM_Elec.cs:499 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2546d176 | this.spdMain.ActiveSheetChanged | SCP0097_SCP_BOM_Elec.cs:500 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0097_SCP_BOM_Elec.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e98074d | spdMain.CellClick | SCP0097_SCP_BOM_Elec.cs:460 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0097_SCP_BOM_Elec.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33a8dea7 | spdMain.CellDoubleClick | SCP0097_SCP_BOM_Elec.cs:144 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0477e9de | spdMain.CellDoubleClick | SCP0097_SCP_BOM_Elec.cs:148 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-0d895f95 | spdMain.CellDoubleClick | SCP0097_SCP_BOM_Elec.cs:149 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0097_SCP_BOM_Elec.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9fd3f73 | dsdmMain.Changed | SCP0097_SCP_BOM_Elec.cs:468 | if (!this.CanModelChange \|\| e.Row == -1 \|\| e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-405b8122 | dsdmMain.Changed | SCP0097_SCP_BOM_Elec.cs:469 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-149f6be0 | dsdmMain.Changed | SCP0097_SCP_BOM_Elec.cs:478 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-a079bc65 | dsdmMain.Changed | SCP0097_SCP_BOM_Elec.cs:479 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0097_SCP_BOM_Elec.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dcb3e5a | this.spdMain.EditChange | SCP0097_SCP_BOM_Elec.cs:508 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e32a31ff | this.spdMain.EditChange | SCP0097_SCP_BOM_Elec.cs:509 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0097_SCP_BOM_Elec.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e55b41c4 | spdMain.TopChange | SCP0097_SCP_BOM_Elec.cs:156 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

