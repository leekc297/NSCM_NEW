# AS-IS 액션 대조표 — SCP0053

> 원천: `Doc/asisfacts/screens/SCP0053/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 96행 · 메서드 23 · 종류 DATA_OP 22 · GRID_INIT 14 · RETURN 11 · FLAG 10 · POPUP 5 · UI_MISC 5 · ENDPOINT 5 · MESSAGE 4 · UI_PROP 3 · LIST_REBIND 3 · GRID_LOCK 3 · VALIDATE 3 · VALUE_SET 2 · GRID_SET 2 · STATE_RESET 1 · GRID_BIND 1 · COMBO_DATA 1 · CALL_EXT 1 · ⚠ 의미 확인 필요 1


## SCP0053_SCPBOM.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09f0fd49 | this.btnItemId.Click | SCP0053_SCPBOM.cs:585 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-daef3354 | this.btnItemId.Click | SCP0053_SCPBOM.cs:587 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f5687ecd | this.btnItemId.Click | SCP0053_SCPBOM.cs:588 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b963aa3d | this.btnItemId.Click | SCP0053_SCPBOM.cs:589 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-badfe46a | this.btnItemId.Click | SCP0053_SCPBOM.cs:595 | if (popItem.ItemID != "") | VALUE_SET | txtModelID.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0053_SCPBOM.checkValidN0

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34ab4296 | (진입점 미연결) | SCP0053_SCPBOM.cs:554 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0053_SCPBOM.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3015cc0 | (진입점 미연결) | SCP0053_SCPBOM.cs:174 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-bf36901e | (진입점 미연결) | SCP0053_SCPBOM.cs:175 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0053_SCPBOM.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8320b147 | this.Load | SCP0053_SCPBOM.cs:195 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-526e51b7 | this.Load | SCP0053_SCPBOM.cs:196 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-072d0484 | this.Load | SCP0053_SCPBOM.cs:198 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0053_SCPBOM.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d1cef6f | DeleteButton | SCP0053_SCPBOM.cs:304 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0053_SCPBOM.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44e4135e | Dispose | SCP0053_SCPBOM.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0053_SCPBOM.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e627141 | EditButton | SCP0053_SCPBOM.cs:279 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c8d9d034 | EditButton | SCP0053_SCPBOM.cs:280 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-9e783ea8 | EditButton | SCP0053_SCPBOM.cs:284 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.ECO_CODE)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-835ff708 | EditButton | SCP0053_SCPBOM.cs:294 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if ((sTemp.ToU… | GRID_SET | siMain.ActiveSheet.Rows[iRow].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-9ecb08f6 | EditButton | SCP0053_SCPBOM.cs:295 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if ((sTemp.ToU… | GRID_SET | siMain.ActiveSheet.Rows[iRow].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |

## SCP0053_SCPBOM.FindData_Main

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e45f048 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:357 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-82c22e16 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:361 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-4901276c | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:361 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f890611 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:363 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b4d1a61a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:369 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8dc8e47b | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:381 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1be8c1c1 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:383 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2fb4d8e6 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:387 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0053_GET_SCP_BOM") ⇒ SCP.SCP0053_GET_SCP_BOM | 엔드포인트 요청 생성 |  |  |  |
| AC-8bf76a4b | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:388 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bec4a568 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:389 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-19f7dbf6 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:390 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-fe2daa5e | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:391 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-b924b9d7 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:392 | try ▸ lambda | DATA_OP | request.Parameters["p_parent_id"] | p_parent_id | 행/컬럼 값 대입 |  |  |  |
| AC-f73a2764 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:393 | try ▸ lambda | DATA_OP | request.Parameters["p_child_id"] | p_child_id | 행/컬럼 값 대입 |  |  |  |
| AC-655190a2 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:394 | try ▸ lambda | DATA_OP | request.Parameters["p_alter_bom"] | p_alter_bom | 행/컬럼 값 대입 |  |  |  |
| AC-b0e2bdd7 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:395 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-248da1b9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:397 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-914ea918 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:399 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-850a104c | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:406 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a9726991 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:407 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5ef8826 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:409 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-249dd596 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:412 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6e85be28 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:416 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6c745dbe | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:420 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9ad7c019 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0053_SCPBOM.cs:425 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0053_SCPBOM.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ea42dd6 | this.Load | SCP0053_SCPBOM.cs:102 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0053_SCPBOM.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d0e59c2 | this.Load | SCP0053_SCPBOM.cs:121 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-832e11cd | this.Load | SCP0053_SCPBOM.cs:124 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-8402cf12 | this.Load | SCP0053_SCPBOM.cs:126 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0053_SCPBOM.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d3ee741 | this.Load | SCP0053_SCPBOM.cs:206 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d9f6befe | this.Load | SCP0053_SCPBOM.cs:207 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0053_SCPBOM.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ac4cb43 | InsertButton | SCP0053_SCPBOM.cs:327 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0053_SCPBOM.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-400ededf | SaveButton | SCP0053_SCPBOM.cs:265 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0053_SCPBOM.SaveData_Main

진입점: SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f4ce59d | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:437 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-faaa0aef | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:456 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-699dfe6f | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:456 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3828e7d1 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:496 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0053_SAVE_SCP_BOM") ⇒ SCP.SCP0053_SAVE_SCP_BOM | 엔드포인트 요청 생성 |  |  |  |
| AC-83474c89 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:498 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a4aa1ad9 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:499 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-da5fcf25 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:500 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_cd"] | p_plant_cd | 행/컬럼 값 대입 |  |  |  |
| AC-253d9ec5 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:501 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-ec4b96d8 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:502 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_parent_item_id"] | p_parent_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a910cf85 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:503 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_child_item_id"] | p_child_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d729f6f | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:504 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_alt_id"] | p_alt_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a958f2a | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:505 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_eff_start_date"] | p_eff_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-b58cfca1 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:506 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_eff_end_date"] | p_eff_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-f73747ee | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:507 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_eco_code"] | p_eco_code | 행/컬럼 값 대입 |  |  |  |
| AC-38a26cab | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:508 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scp_yn"] | p_scp_yn | 행/컬럼 값 대입 |  |  |  |
| AC-7d4fb62f | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:509 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_si_alt_priority"] | p_si_alt_priority | 행/컬럼 값 대입 |  |  |  |
| AC-df9756cb | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:510 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_si_scp_yn"] | p_si_scp_yn | 행/컬럼 값 대입 |  |  |  |
| AC-8ea644e6 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:512 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b977f212 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:513 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | debug_mode | 행/컬럼 값 대입 |  |  |  |
| AC-621649e4 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:515 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-91ccce85 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:520 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fcf6621f | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:531 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-312904e2 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0053_SCPBOM.cs:537 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0053_SCPBOM.SelectCombo

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a69880c | OnShown | SCP0053_SCPBOM.cs:147 | if (iIdx >= 0) | VALUE_SET | cCombo.SelectedIndex | iIdx | 컨트롤 값 설정 |  |  |  |

## SCP0053_SCPBOM.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7668b5c8 | this.Load 외 2 | SCP0053_SCPBOM.cs:186 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantByDivisionAll, false, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce3c819c | this.Load 외 2 | SCP0053_SCPBOM.cs:186 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionAll, false, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-df846ad2 | this.Load 외 2 | SCP0053_SCPBOM.cs:187 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0053_SCPBOM.SetSpreadInit

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca3e5f7c | this.Load 외 2 | SCP0053_SCPBOM.cs:214 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f67cb91 | this.Load 외 2 | SCP0053_SCPBOM.cs:215 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-5949a7f7 | this.Load 외 2 | SCP0053_SCPBOM.cs:216 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-379457a2 | this.Load 외 2 | SCP0053_SCPBOM.cs:217 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59a22e9d | this.Load 외 2 | SCP0053_SCPBOM.cs:218 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0053_SCPBOM.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c196bfcf | this.spdMain.ActiveSheetChanged | SCP0053_SCPBOM.cs:641 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96a8f78e | this.spdMain.ActiveSheetChanged | SCP0053_SCPBOM.cs:642 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0053_SCPBOM.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8380cc19 | spdMain.CellClick | SCP0053_SCPBOM.cs:602 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0053_SCPBOM.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c12dccff | spdMain.CellDoubleClick | SCP0053_SCPBOM.cs:154 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f12cac34 | spdMain.CellDoubleClick | SCP0053_SCPBOM.cs:158 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-5312c4ce | spdMain.CellDoubleClick | SCP0053_SCPBOM.cs:159 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0053_SCPBOM.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac0bd526 | dsdmMain.Changed | SCP0053_SCPBOM.cs:610 | if (!this.CanModelChange \|\| e.Row == -1 \|\| e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-683c5c3b | dsdmMain.Changed | SCP0053_SCPBOM.cs:611 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7aee2f05 | dsdmMain.Changed | SCP0053_SCPBOM.cs:620 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-634ed333 | dsdmMain.Changed | SCP0053_SCPBOM.cs:621 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0053_SCPBOM.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-371025fb | this.spdMain.EditChange | SCP0053_SCPBOM.cs:650 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-06d14e4d | this.spdMain.EditChange | SCP0053_SCPBOM.cs:651 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0053_SCPBOM.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b6ab2b6 | spdMain.TopChange | SCP0053_SCPBOM.cs:166 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

