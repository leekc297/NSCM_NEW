# AS-IS 액션 대조표 — SCP0046

> 원천: `Doc/asisfacts/screens/SCP0046/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 327행 · 메서드 30 · 종류 DATA_OP 127 · GRID_SET 25 · GRID_INIT 24 · RETURN 19 · ENDPOINT 19 · FLAG 18 · GRID_COMBO 16 · POPUP 15 · UI_MISC 15 · GRID_LOCK 13 · CALL_EXT 8 · UI_PROP 8 · LIST_REBIND 7 · MESSAGE 6 · VALIDATE 3 · VALUE_SET 2 · GRID_BIND 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 8


## SCP0046_ModelAllocation.btnItemId_Click

진입점: btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-891c27cb | btnItemId.Click | SCP0046_ModelAllocation.cs:940 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (clbDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b32b8e76 | btnItemId.Click | SCP0046_ModelAllocation.cs:947 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0cffdee2 | btnItemId.Click | SCP0046_ModelAllocation.cs:949 |  | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f343d43e | btnItemId.Click | SCP0046_ModelAllocation.cs:950 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d46a2a29 | btnItemId.Click | SCP0046_ModelAllocation.cs:951 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bc28ffbf | btnItemId.Click | SCP0046_ModelAllocation.cs:957 | if (pop.selectedItemId != "") | VALUE_SET | txtCellItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0046_ModelAllocation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6777244b | this.Load | SCP0046_ModelAllocation.cs:480 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fa37d405 | this.Load | SCP0046_ModelAllocation.cs:481 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a48ffd52 | this.Load | SCP0046_ModelAllocation.cs:482 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66feed8d | this.Load | SCP0046_ModelAllocation.cs:484 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-7064ac43 | this.Load | SCP0046_ModelAllocation.cs:487 | if (editYYYYMMDD=="") | FLAG | editYYYYMMDD | drpPeriod.Text1.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |

## SCP0046_ModelAllocation.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1458a0f6 | DeleteButton | SCP0046_ModelAllocation.cs:536 | if (action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0064859 | DeleteButton | SCP0046_ModelAllocation.cs:538 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0046_ModelAllocation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a009d4b1 | Dispose | SCP0046_ModelAllocation.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0046_ModelAllocation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-136bbb12 | EditButton | SCP0046_ModelAllocation.cs:649 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-413b4558 | EditButton | SCP0046_ModelAllocation.cs:655 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b623130 | EditButton | SCP0046_ModelAllocation.cs:656 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b43acf46 | EditButton | SCP0046_ModelAllocation.cs:659 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.TR_MODE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3b6dca35 | EditButton | SCP0046_ModelAllocation.cs:662 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f8ec559 | EditButton | SCP0046_ModelAllocation.cs:662 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e34d6c6d | EditButton | SCP0046_ModelAllocation.cs:668 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID), i, siMain.GetColumnIndex(DefColumns.CE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-882a47a5 | EditButton | SCP0046_ModelAllocation.cs:669 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), i, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-369f1d44 | EditButton | SCP0046_ModelAllocation.cs:681 | if (fps.Name == "spdMain") ▸ if (Convert.ToInt32(editYYYYMMDD) > Convert.ToInt32(startYYYYMMDD) && siMain.GetColumnIndex("D_" + editYYYYMMDD… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TR_MODE) + 1, siMain.GetColumnIndex("D_" + editYYYYMMDD)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c42ac615 | EditButton | SCP0046_ModelAllocation.cs:685 | if (fps.Name == "spdMain") ▸ else of (Convert.ToInt32(editYYYYMMDD) > Convert.ToInt32(startYYYYMMDD) && siMain.GetColumnIndex("D_" + editYYY… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TR_MODE) + 1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0046_ModelAllocation.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9775c145 | FindButton 외 1 | SCP0046_ModelAllocation.cs:697 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a221ba5a | FindButton 외 1 | SCP0046_ModelAllocation.cs:700 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-fdb6a184 | FindButton 외 1 | SCP0046_ModelAllocation.cs:700 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b106c30c | FindButton 외 1 | SCP0046_ModelAllocation.cs:723 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-21c56cc0 | FindButton 외 1 | SCP0046_ModelAllocation.cs:724 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8690c45c | FindButton 외 1 | SCP0046_ModelAllocation.cs:725 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3277a644 | FindButton 외 1 | SCP0046_ModelAllocation.cs:729 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0046_GET_MODEL_ALLOCATION") ⇒ SCP.SCP0046_GET_MODEL_ALLOCATION | 엔드포인트 요청 생성 |  |  |  |
| AC-228bb233 | FindButton 외 1 | SCP0046_ModelAllocation.cs:730 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6f5122b7 | FindButton 외 1 | SCP0046_ModelAllocation.cs:731 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-943d67aa | FindButton 외 1 | SCP0046_ModelAllocation.cs:732 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_plant_site_id"] | p_cell_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-e0a32977 | FindButton 외 1 | SCP0046_ModelAllocation.cs:733 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_item_id"] | p_cell_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7ebcd046 | FindButton 외 1 | SCP0046_ModelAllocation.cs:734 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_line_id"] | p_cell_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-8182a9ad | FindButton 외 1 | SCP0046_ModelAllocation.cs:735 | try ▸ lambda | DATA_OP | request.Parameters["p_elec_plant_site_id"] | p_elec_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-90591eeb | FindButton 외 1 | SCP0046_ModelAllocation.cs:736 | try ▸ lambda | DATA_OP | request.Parameters["p_elec_item_id"] | p_elec_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8cfd021c | FindButton 외 1 | SCP0046_ModelAllocation.cs:737 | try ▸ lambda | DATA_OP | request.Parameters["p_elec_line_id"] | p_elec_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-966df34b | FindButton 외 1 | SCP0046_ModelAllocation.cs:738 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4d55ccb8 | FindButton 외 1 | SCP0046_ModelAllocation.cs:739 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-66bf1b29 | FindButton 외 1 | SCP0046_ModelAllocation.cs:740 | try ▸ lambda | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ec69486 | FindButton 외 1 | SCP0046_ModelAllocation.cs:741 | try ▸ lambda | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-26463dd8 | FindButton 외 1 | SCP0046_ModelAllocation.cs:742 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5226e589 | FindButton 외 1 | SCP0046_ModelAllocation.cs:743 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-cb078c03 | FindButton 외 1 | SCP0046_ModelAllocation.cs:745 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-49c97cc2 | FindButton 외 1 | SCP0046_ModelAllocation.cs:747 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b0c6ad53 | FindButton 외 1 | SCP0046_ModelAllocation.cs:754 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-22933094 | FindButton 외 1 | SCP0046_ModelAllocation.cs:755 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b7dce819 | FindButton 외 1 | SCP0046_ModelAllocation.cs:758 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0f246481 | FindButton 외 1 | SCP0046_ModelAllocation.cs:760 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-327456ef | FindButton 외 1 | SCP0046_ModelAllocation.cs:764 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d3af60ba | FindButton 외 1 | SCP0046_ModelAllocation.cs:765 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a98827ad | FindButton 외 1 | SCP0046_ModelAllocation.cs:772 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0046_ModelAllocation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de08e4af | this.Load | SCP0046_ModelAllocation.cs:143 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0046_ModelAllocation.GetAllPrjRouteModel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e85ebdc0 | (진입점 미연결) | SCP0046_ModelAllocation.cs:330 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-210fbe3b | (진입점 미연결) | SCP0046_ModelAllocation.cs:331 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2e328d3a | (진입점 미연결) | SCP0046_ModelAllocation.cs:336 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-183bee1a | (진입점 미연결) | SCP0046_ModelAllocation.cs:338 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c67382d | (진입점 미연결) | SCP0046_ModelAllocation.cs:342 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0046_GET_AllInputModelAllocation") ⇒ SCP.SCP0046_GET_AllInputModelAllocation | 엔드포인트 요청 생성 |  |  |  |
| AC-fa6d00ec | (진입점 미연결) | SCP0046_ModelAllocation.cs:343 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cb596d66 | (진입점 미연결) | SCP0046_ModelAllocation.cs:344 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | "A" | 행/컬럼 값 대입 |  |  |  |
| AC-919e12c0 | (진입점 미연결) | SCP0046_ModelAllocation.cs:345 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-42e6b1bb | (진입점 미연결) | SCP0046_ModelAllocation.cs:347 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fa6402ed | (진입점 미연결) | SCP0046_ModelAllocation.cs:353 | try ▸ if (CommonUtils.CheckDataEmpty(ds) == false) | FLAG | dtAllPrjRouteModel | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-14d82a23 | (진입점 미연결) | SCP0046_ModelAllocation.cs:360 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0046_ModelAllocation.GetAllPrjRouteModel_old

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dceffe34 | (진입점 미연결) | SCP0046_ModelAllocation.cs:319 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-de6272b2 | (진입점 미연결) | SCP0046_ModelAllocation.cs:320 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a166e113 | (진입점 미연결) | SCP0046_ModelAllocation.cs:323 |  | FLAG | dtAllPrjRouteModel | Data_SCP.Common(Data_SCP.Type.AllInputModelAllocation, false, "", "A") | 화면 필드/플래그 변경 |  |  |  |
| AC-3964170f | (진입점 미연결) | SCP0046_ModelAllocation.cs:323 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.AllInputModelAllocation, false, "", "A") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-38c74ea3 | (진입점 미연결) | SCP0046_ModelAllocation.cs:325 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0046_ModelAllocation.GetAllPrjRouteModelDivision

진입점: clbDivision.SelectedIndexChanged / InsertButton [if (CommonUtils.CheckDataEmpty(dtAllPrjRouteModelDivision))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c3257b2 | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:367 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b69a5940 | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:368 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-da665a27 | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:375 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-36536eab | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:377 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-92a6576d | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:381 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0046_GET_AllInputModelAllocation_EX") ⇒ SCP.SCP0046_GET_AllInputModelAllocation_EX | 엔드포인트 요청 생성 |  |  |  |
| AC-df782026 | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:382 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a2537c30 | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:383 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-be68e5fb | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:384 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | "A" | 행/컬럼 값 대입 |  |  |  |
| AC-3b9b13a7 | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:385 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7f46d860 | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:387 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-02500ced | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:393 | try ▸ if (CommonUtils.CheckDataEmpty(ds) == false) | FLAG | dtAllPrjRouteModel | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-b3a360e1 | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:394 | try ▸ if (CommonUtils.CheckDataEmpty(ds) == false) | FLAG | dtAllPrjRouteModelDivision | dtAllPrjRouteModel | 화면 필드/플래그 변경 |  |  |  |
| AC-b33b7aea | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:395 | try ▸ if (CommonUtils.CheckDataEmpty(ds) == false) | FLAG | dtAllPrjRouteModelDivisionItem | dtAllPrjRouteModelDivision.DefaultView.ToTable(true, "DIVISION_ID", "ITEM_ID") | 화면 필드/플래그 변경 |  |  |  |
| AC-fc33da40 | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:395 | try ▸ if (CommonUtils.CheckDataEmpty(ds) == false) | DATA_OP | dtAllPrjRouteModelDivision.DefaultView.ToTable | (true, "DIVISION_ID", "ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-abfbfa40 | clbDivision.SelectedIndexChanged 외 2 | SCP0046_ModelAllocation.cs:402 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0046_ModelAllocation.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6627cf43 | this.Load | SCP0046_ModelAllocation.cs:988 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_WEEK_MONDAY_PERIOD") ⇒ SCM.SCM0001_GET_WEEK_MONDAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-04709036 | this.Load | SCP0046_ModelAllocation.cs:989 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-039b2a18 | this.Load | SCP0046_ModelAllocation.cs:990 |  | DATA_OP | request.Parameters["p_offset_day"] | "370" | 행/컬럼 값 대입 |  |  |  |
| AC-ee86652c | this.Load | SCP0046_ModelAllocation.cs:991 |  | DATA_OP | request.Parameters["p_timezone"] | "AS054" | 행/컬럼 값 대입 |  |  |  |
| AC-88d72db7 | this.Load | SCP0046_ModelAllocation.cs:992 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d57a095 | this.Load | SCP0046_ModelAllocation.cs:995 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0046_ModelAllocation.GetDTitem

진입점: clbDivision.SelectedIndexChanged [finally ▸ if (isInsert) ▸ try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / InsertButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-694d8189 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert) ▸ … 외 2 | SCP0046_ModelAllocation.cs:632 |  | DATA_OP | dtItem.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d169b34e | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert) ▸ … 외 2 | SCP0046_ModelAllocation.cs:633 |  | DATA_OP | dtItem.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-7119d9d5 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert) ▸ … 외 2 | SCP0046_ModelAllocation.cs:637 | foreach (DataRow dr in drArr) | DATA_OP | dtItem.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e1cae46 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert) ▸ … 외 2 | SCP0046_ModelAllocation.cs:638 | foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3617c339 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert) ▸ … 외 2 | SCP0046_ModelAllocation.cs:639 | foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6ed7f286 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert) ▸ … 외 2 | SCP0046_ModelAllocation.cs:640 | foreach (DataRow dr in drArr) | DATA_OP | dtItem.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a93af0e5 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert) ▸ … 외 2 | SCP0046_ModelAllocation.cs:643 |  | RETURN | return dtItem; |  | 처리 중단/반환 |  |  |  |

## SCP0046_ModelAllocation.GetSpdTitle

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72e7b1f8 | this.Load 외 2 | SCP0046_ModelAllocation.cs:1005 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-bdc933d5 | this.Load 외 2 | SCP0046_ModelAllocation.cs:1007 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-fabf45cb | this.Load 외 2 | SCP0046_ModelAllocation.cs:1008 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-dfbfb5a0 | this.Load 외 2 | SCP0046_ModelAllocation.cs:1010 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-718276e1 | this.Load 외 2 | SCP0046_ModelAllocation.cs:1010 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0046_ModelAllocation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca51a27c | this.Load | SCP0046_ModelAllocation.cs:298 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-3936f7ca | this.Load | SCP0046_ModelAllocation.cs:300 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef839bf2 | this.Load | SCP0046_ModelAllocation.cs:301 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6385f50e | this.Load | SCP0046_ModelAllocation.cs:306 |  | FLAG | this.dtAllPlant | DBUtils.Filter(dtAllPlantAll, "DIVISION_ID IN (" + UIUtils.GetAllDivision1(clbDivision) + … | 화면 필드/플래그 변경 |  |  |  |
| AC-0f4e106a | this.Load | SCP0046_ModelAllocation.cs:306 |  | DATA_OP | DBUtils.Filter | (dtAllPlantAll, "DIVISION_ID IN (" + UIUtils.GetAllDivision1(clbDivision) + ")", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-237324f8 | this.Load | SCP0046_ModelAllocation.cs:306 |  | CALL_EXT | UIUtils.GetAllDivision1 | (clbDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-efce3cee | this.Load | SCP0046_ModelAllocation.cs:312 |  | FLAG | dtTmp | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-ac0a6c78 | this.Load | SCP0046_ModelAllocation.cs:313 |  | DATA_OP | dtTmp.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae537fa2 | this.Load | SCP0046_ModelAllocation.cs:314 |  | DATA_OP | dtTmp.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |

## SCP0046_ModelAllocation.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f2c6d87 | this.Load | SCP0046_ModelAllocation.cs:249 |  | UI_PROP | layoutControlItem2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0046_ModelAllocation.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c84c361 | this.Load 외 2 | SCP0046_ModelAllocation.cs:496 |  | GRID_INIT | spdInfo.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8879ee5f | this.Load 외 2 | SCP0046_ModelAllocation.cs:498 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSiteByDivision", dtAllPlant) | 목록 컨트롤 재구성 |  |  |  |
| AC-336d4822 | this.Load 외 2 | SCP0046_ModelAllocation.cs:499 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ToSiteByDivision", dtAllPlant) | 목록 컨트롤 재구성 |  |  |  |
| AC-31eec56e | this.Load 외 2 | SCP0046_ModelAllocation.cs:504 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-e99320c3 | this.Load 외 2 | SCP0046_ModelAllocation.cs:509 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a1c9544 | this.Load 외 2 | SCP0046_ModelAllocation.cs:511 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c2d45f7 | this.Load 외 2 | SCP0046_ModelAllocation.cs:513 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0046_ModelAllocation.InitSpreadDateColumn

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a561ab95 | this.Load 외 2 | SCP0046_ModelAllocation.cs:188 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3304133 | this.Load 외 2 | SCP0046_ModelAllocation.cs:189 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-335af460 | this.Load 외 2 | SCP0046_ModelAllocation.cs:193 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddComboColumn | (sColumnLabelname, sColumnName, FPMerge.None, 50, true, dtValidYN, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-196d2875 | this.Load 외 2 | SCP0046_ModelAllocation.cs:199 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d34b8250 | this.Load 외 2 | SCP0046_ModelAllocation.cs:206 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36dcb350 | this.Load 외 2 | SCP0046_ModelAllocation.cs:207 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13f0e881 | this.Load 외 2 | SCP0046_ModelAllocation.cs:212 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e061d6a3 | this.Load 외 2 | SCP0046_ModelAllocation.cs:213 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f236490 | this.Load 외 2 | SCP0046_ModelAllocation.cs:221 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a27a7e2e | this.Load 외 2 | SCP0046_ModelAllocation.cs:222 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ff53a0d | this.Load 외 2 | SCP0046_ModelAllocation.cs:232 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11058b95 | this.Load 외 2 | SCP0046_ModelAllocation.cs:233 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f77b2542 | this.Load 외 2 | SCP0046_ModelAllocation.cs:234 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59302661 | this.Load 외 2 | SCP0046_ModelAllocation.cs:235 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0046_ModelAllocation.InsertButton

진입점: clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] / InsertButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b01e2e2 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:547 | if (CommonUtils.CheckDataEmpty(dtAllPrjRouteModelDivision)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0046_ModelAllocation.InsertRow

진입점: clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] / InsertButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9f232fa | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:556 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7cf3cfd2 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:557 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2ef04f85 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:567 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0c1205b | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:569 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a3be1538 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:573 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, p_division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb1f37b7 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:574 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | DATA_OP | defaultData.Add | (DefColumns.ELEC_ITEM_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-608e4a1d | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:575 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | DATA_OP | defaultData.Add | (DefColumns.ELEC_LINE_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ebe0865 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:576 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | DATA_OP | defaultData.Add | (DefColumns.TR_MODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec86c850 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:578 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_SET | this.siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-30efab61 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:580 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8a737aa8 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:581 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CELL_NICK_NAME), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d3c53a71 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:582 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ELEC_ITEM_ID), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-96356b9d | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:594 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_LOCK | siMain.LockRange | (insCell, iColTR_MODE + 1, siMain.GetColumnIndex("D_" + editYYYYMMDD) - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2bea7dd4 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:595 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex("D_" + editYYYYMMDD), siMain.ActiveRowIndex,… | 그리드 값 설정 |  |  |  |
| AC-b3a93512 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:599 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_LOCK | siMain.LockRange | (insCell, iColTR_MODE + 1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d0d10bc | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:603 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, iColTR_MODE + 1, siMain.ActiveRowIndex, siMain.GetMaxColumnIndex()… | 그리드 값 설정 |  |  |  |
| AC-a62ce946 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:607 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | DATA_OP | dtAllPrjRouteModelDivisionItem.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-02a27912 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:608 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | FLAG | dtAllPrjRouteModelDivisionItemCombo | GetDTitem(drArr) | 화면 필드/플래그 변경 |  |  |  |
| AC-c65ad18e | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:610 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID), dtAllPrjRouteModel… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6d471d67 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:611 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), dtTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-91b88dac | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:612 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), dtTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-25053979 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:613 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ELEC_PLANT_SITE_ID), dtSupplySite… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2bc00036 | clbDivision.SelectedIndexChanged [finally ▸ if (isInsert)] 외 2 | SCP0046_ModelAllocation.cs:623 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0046_ModelAllocation.RefreshPKGLine

진입점: this.Load / clbDivision.SelectedIndexChanged / clbPKGSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f4c4868 | this.Load 외 2 | SCP0046_ModelAllocation.cs:423 |  | FLAG | dtPKGLine | DBUtils.Filter(dtPKGLineAll, "DIVISION_ID = '" + this._division + "' AND " + filterExpress… | 화면 필드/플래그 변경 |  |  |  |
| AC-88209a43 | this.Load 외 2 | SCP0046_ModelAllocation.cs:423 |  | DATA_OP | DBUtils.Filter | (dtPKGLineAll, "DIVISION_ID = '" + this._division + "' AND " + filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c4021554 | this.Load 외 2 | SCP0046_ModelAllocation.cs:425 |  | DATA_OP | dtPKGLine.Rows[0].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-df7ebb3a | this.Load 외 2 | SCP0046_ModelAllocation.cs:426 |  | DATA_OP | dtPKGLine.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-926e9133 | this.Load 외 2 | SCP0046_ModelAllocation.cs:427 |  | LIST_REBIND | clsCtrl.setListBox | (dtPKGLine, clbPKGLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0046_ModelAllocation.RefreshPKGSite

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16ac98e2 | this.Load 외 1 | SCP0046_ModelAllocation.cs:413 |  | FLAG | dtPKGSite | DBUtils.Filter(dtPKGSiteAll, "DIVISION_ID = '" + this._division + "' AND OPERATION_GROUP =… | 화면 필드/플래그 변경 |  |  |  |
| AC-bcb2d76b | this.Load 외 1 | SCP0046_ModelAllocation.cs:413 |  | DATA_OP | DBUtils.Filter | (dtPKGSiteAll, "DIVISION_ID = '" + this._division + "' AND OPERATION_GROUP = 'A'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c5301b69 | this.Load 외 1 | SCP0046_ModelAllocation.cs:415 |  | LIST_REBIND | clsCtrl.setListBox | (dtPKGSite, clbPKGSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0046_ModelAllocation.RefreshSupplyLine

진입점: this.Load / clbDivision.SelectedIndexChanged / clbSupplySite.SelectedIndexChanged / clbPKGSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-243bf25a | this.Load 외 3 | SCP0046_ModelAllocation.cs:445 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "SCM_SITE_ID" }, new List<string>() { this._division,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2fa1f7d1 | this.Load 외 3 | SCP0046_ModelAllocation.cs:447 |  | FLAG | dtSupplyLine | DBUtils.Filter(dtSupplyLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f77d378f | this.Load 외 3 | SCP0046_ModelAllocation.cs:447 |  | DATA_OP | DBUtils.Filter | (dtSupplyLineAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9546ac37 | this.Load 외 3 | SCP0046_ModelAllocation.cs:454 |  | DATA_OP | dtSupplyLine.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-212f0b88 | this.Load 외 3 | SCP0046_ModelAllocation.cs:455 |  | LIST_REBIND | clsCtrl.setListBox | (dtSupplyLine, clbSupplyLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0046_ModelAllocation.RefreshSupplySite

진입점: this.Load / clbDivision.SelectedIndexChanged / clbPKGSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-791b63d2 | this.Load 외 2 | SCP0046_ModelAllocation.cs:434 | if (this._division.Equals("81_UC")) | FLAG | dtSupplySite | DBUtils.Filter(dtSupplySiteAll, "DIVISION_ID = '" + this._division + "' AND OPERATION_GROU… | 화면 필드/플래그 변경 |  |  |  |
| AC-1cb1ff98 | this.Load 외 2 | SCP0046_ModelAllocation.cs:434 | if (this._division.Equals("81_UC")) | DATA_OP | DBUtils.Filter | (dtSupplySiteAll, "DIVISION_ID = '" + this._division + "' AND OPERATION_GROUP = 'A'", true… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0fb2c838 | this.Load 외 2 | SCP0046_ModelAllocation.cs:438 | else of (this._division.Equals("81_UC")) | FLAG | dtSupplySite | DBUtils.Filter(dtSupplySiteAll, "DIVISION_ID IN (" + UIUtils.GetAllDivisionsExceptUCEE1(cl… | 화면 필드/플래그 변경 |  |  |  |
| AC-691a5a70 | this.Load 외 2 | SCP0046_ModelAllocation.cs:438 | else of (this._division.Equals("81_UC")) | DATA_OP | DBUtils.Filter | (dtSupplySiteAll, "DIVISION_ID IN (" + UIUtils.GetAllDivisionsExceptUCEE1(clbDivision) + "… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f5c8e648 | this.Load 외 2 | SCP0046_ModelAllocation.cs:438 | else of (this._division.Equals("81_UC")) | CALL_EXT | UIUtils.GetAllDivisionsExceptUCEE1 | (clbDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-966bd302 | this.Load 외 2 | SCP0046_ModelAllocation.cs:441 |  | LIST_REBIND | clsCtrl.setListBox | (dtSupplySite, clbSupplySite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0046_ModelAllocation.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60c5a532 | SaveButton | SCP0046_ModelAllocation.cs:780 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-215191eb | SaveButton | SCP0046_ModelAllocation.cs:789 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef88eb63 | SaveButton | SCP0046_ModelAllocation.cs:792 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-bf7a990a | SaveButton | SCP0046_ModelAllocation.cs:792 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-380ad2b8 | SaveButton | SCP0046_ModelAllocation.cs:798 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-c397bd67 | SaveButton | SCP0046_ModelAllocation.cs:799 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-eeff481a | SaveButton | SCP0046_ModelAllocation.cs:800 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_cell_plant_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b88b54ac | SaveButton | SCP0046_ModelAllocation.cs:801 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_cell_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-41309c7a | SaveButton | SCP0046_ModelAllocation.cs:802 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_cell_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-53717699 | SaveButton | SCP0046_ModelAllocation.cs:803 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_elec_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7241b511 | SaveButton | SCP0046_ModelAllocation.cs:804 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_elec_plant_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d928ff9e | SaveButton | SCP0046_ModelAllocation.cs:805 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_elec_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-1bae6078 | SaveButton | SCP0046_ModelAllocation.cs:806 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_tr_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b681504 | SaveButton | SCP0046_ModelAllocation.cs:807 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-06a311b5 | SaveButton | SCP0046_ModelAllocation.cs:808 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_valid_yn") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef8ce5e3 | SaveButton | SCP0046_ModelAllocation.cs:809 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-c79ccbde | SaveButton | SCP0046_ModelAllocation.cs:810 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-86248a62 | SaveButton | SCP0046_ModelAllocation.cs:838 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f0a0559 | SaveButton | SCP0046_ModelAllocation.cs:840 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-4bc539c8 | SaveButton | SCP0046_ModelAllocation.cs:841 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d9a2c48f | SaveButton | SCP0046_ModelAllocation.cs:842 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_cell_plant_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b93c487b | SaveButton | SCP0046_ModelAllocation.cs:843 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_cell_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-41f15c4f | SaveButton | SCP0046_ModelAllocation.cs:844 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_cell_line_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-96278598 | SaveButton | SCP0046_ModelAllocation.cs:845 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_elec_item_id"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-3743f0f0 | SaveButton | SCP0046_ModelAllocation.cs:846 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_elec_plant_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ELEC_PLANT_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-078eb3b0 | SaveButton | SCP0046_ModelAllocation.cs:847 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_elec_line_id"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-ca622f59 | SaveButton | SCP0046_ModelAllocation.cs:848 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_tr_mode"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-96cc3b7c | SaveButton | SCP0046_ModelAllocation.cs:849 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | strDayName | 행/컬럼 값 대입 |  |  |  |
| AC-b821fc3e | SaveButton | SCP0046_ModelAllocation.cs:850 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_valid_yn"] | strDayYN | 행/컬럼 값 대입 |  |  |  |
| AC-ac1b730d | SaveButton | SCP0046_ModelAllocation.cs:851 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-300bffbf | SaveButton | SCP0046_ModelAllocation.cs:853 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b1267fe | SaveButton | SCP0046_ModelAllocation.cs:859 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a598accf | SaveButton | SCP0046_ModelAllocation.cs:866 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ec07bd32 | SaveButton | SCP0046_ModelAllocation.cs:876 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0046", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df172558 | SaveButton | SCP0046_ModelAllocation.cs:877 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveModelAllocation") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveModelAllocation] \|… | 엔드포인트 호출 |  |  |  |
| AC-c377cce7 | SaveButton | SCP0046_ModelAllocation.cs:880 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-835600a5 | SaveButton | SCP0046_ModelAllocation.cs:885 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ed7a4096 | SaveButton | SCP0046_ModelAllocation.cs:894 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54c0660c | SaveButton | SCP0046_ModelAllocation.cs:903 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a21de42e | SaveButton | SCP0046_ModelAllocation.cs:904 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d8e12ced | SaveButton | SCP0046_ModelAllocation.cs:910 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgClo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-91d71c14 | SaveButton | SCP0046_ModelAllocation.cs:917 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0270c58d | SaveButton | SCP0046_ModelAllocation.cs:925 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-73d18d6f | SaveButton | SCP0046_ModelAllocation.cs:926 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d541e3a7 | SaveButton | SCP0046_ModelAllocation.cs:930 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f7e3f35a | SaveButton | SCP0046_ModelAllocation.cs:931 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0046_ModelAllocation.SCM_SYS_LOG_BATCH

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b369fa4f | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0046_ModelAllocation.cs:1022 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-a0af9194 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0046_ModelAllocation.cs:1023 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-3d8363af | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0046_ModelAllocation.cs:1024 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-09590995 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0046_ModelAllocation.cs:1025 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-aec2c721 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0046_ModelAllocation.cs:1026 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-5507c575 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0046_ModelAllocation.cs:1027 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-37209b1a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0046_ModelAllocation.cs:1028 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-2f0f0d39 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0046_ModelAllocation.cs:1030 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0046_ModelAllocation.SetSpreadColumn

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48b20595 | this.Load 외 2 | SCP0046_ModelAllocation.cs:1053 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-02993bd9 | this.Load 외 2 | SCP0046_ModelAllocation.cs:1058 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0046_ModelAllocation.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-743feb2d | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1126 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f41b966 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1127 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ecfedb1 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1156 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | dtAllPrjRouteModel.Select | ("DIVISION_ID = '" + division + "' AND ITEM_ID = '" + sItemID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cdb1ca9c | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1159 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | dtPlant.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c75730b | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1160 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | dtPlant.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-1897a278 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1164 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ foreach (DataRow dr in drArr) | DATA_OP | dtPlant.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-60a2ee28 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1165 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["PLANT_SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aec58491 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1166 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["SITE_DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e41b0e1d | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1167 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ foreach (DataRow dr in drArr) | DATA_OP | dtPlant.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-671cdc38 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1170 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | dtPlant.DefaultView.ToTable | (true, "CODE", "NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-dbfa0e54 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1173 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), tmpDtPlant) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-12628103 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1174 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") | DATA_OP | tmpDtPlant.Select | ("CODE = '" + sPlantSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c12170c | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1176 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drPlant == null) | DATA_OP | tmpDtPlant.Select | ("NAME = '" + sPlantSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5114305 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1181 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (drPlant != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), sPlantSite) | 그리드 값 설정 |  |  |  |
| AC-aca655a7 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1185 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ else of (drPlant != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ea226d78 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1194 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") | DATA_OP | dtAllPrjRouteModel.Select | ("DIVISION_ID = '" + division + "' AND ITEM_ID = '" + sItemID + "' AND PLANT_SITE_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-a5e4eb43 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1197 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") | DATA_OP | dtLine.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8eb94dc | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1198 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") | DATA_OP | dtLine.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-53a2c35f | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1202 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") ▸ foreach (DataRow dr in drArr) | DATA_OP | dtLine.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-68563551 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1203 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae22e9da | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1204 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8378a9c | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1205 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") ▸ foreach (DataRow dr in drArr) | DATA_OP | dtLine.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-ccb2b4b3 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1208 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") | DATA_OP | dtLine.DefaultView.ToTable | (true, "CODE", "NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-0329f922 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1210 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), tmpDtLine) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5107e2a1 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1211 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") | DATA_OP | tmpDtLine.Select | ("CODE = '" + sLine + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-096c308f | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1214 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") ▸ if (drLine != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), sLine) | 그리드 값 설정 |  |  |  |
| AC-ce260810 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1218 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ if (sPlantSite != "") ▸ else of (drLine != null) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-05e6c18b | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1225 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ else of (sPlantSite != "") | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), dtTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-622aa39c | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1226 | for (iRow <= rowCntIndex) ▸ if (sItemID != "") ▸ else of (sPlantSite != "") | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-b5300f6f | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1231 | for (iRow <= rowCntIndex) ▸ else of (sItemID != "") | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), dtTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-83356617 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1232 | for (iRow <= rowCntIndex) ▸ else of (sItemID != "") | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-37daa99e | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1233 | for (iRow <= rowCntIndex) ▸ else of (sItemID != "") | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), dtTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-eb88b877 | this.spdMain.ClipboardPasted | SCP0046_ModelAllocation.cs:1234 | for (iRow <= rowCntIndex) ▸ else of (sItemID != "") | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), "") | 그리드 값 설정 |  |  |  |

## SCP0046_ModelAllocation.SpdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7e707c7 | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1066 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-100bf400 | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1067 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ccb0d92 | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1072 |  | ENDPOINT | Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8bb5c3c7 | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1076 |  | ENDPOINT | data.GetDataPresent | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c571e8c5 | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1078 | if (data.GetDataPresent(typeof(System.String))) | ENDPOINT | data.GetData | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f750fa77 | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1081 | if (data.GetDataPresent(typeof(System.String))) | CALL_EXT | strValue.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a07ac344 | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1114 | for (i < (selectRow + ClipRowCount)) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), i, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a82e58e2 | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1116 | for (i < (selectRow + ClipRowCount)) | GRID_INIT | siMain.SetCellTypeText | (i, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-42f605ce | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1117 | for (i < (selectRow + ClipRowCount)) | GRID_INIT | siMain.SetCellTypeText | (i, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-452024b6 | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1118 | for (i < (selectRow + ClipRowCount)) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), strPlantSite) | 그리드 값 설정 |  |  |  |
| AC-ef2ee453 | this.spdMain.ClipboardPasting | SCP0046_ModelAllocation.cs:1119 | for (i < (selectRow + ClipRowCount)) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), strLineId) | 그리드 값 설정 |  |  |  |

## SCP0046_ModelAllocation.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange / spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b25397c | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1247 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac4b7cb9 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1248 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fec67f91 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1249 | if (siMain.GetText(e.Row, 0) != "I") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b251c288 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1262 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") | DATA_OP | dtAllPrjRouteModel.Select | ("DIVISION_ID = '" + division + "' AND ITEM_ID = '" + sItemID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-169ed47f | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1265 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") | DATA_OP | dtPlant.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e410786 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1266 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") | DATA_OP | dtPlant.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-402fd07c | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1270 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ foreach (DataRow dr in drArr) | DATA_OP | dtPlant.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-956f7c34 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1271 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["PLANT_SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2696102c | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1272 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["SITE_DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-326810b0 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1273 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ foreach (DataRow dr in drArr) | DATA_OP | dtPlant.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c306c681 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1276 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") | DATA_OP | dtPlant.DefaultView.ToTable | (true, "CODE", "NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-4238a6e3 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1279 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), tmpDtPlant) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-364e5af5 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1281 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") | DATA_OP | tmpDtPlant.Select | ("CODE = '" + sPlantSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d0b7d73 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1283 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (drPlant == null) | DATA_OP | tmpDtPlant.Select | ("NAME = '" + sPlantSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-182a1aaa | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1288 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (drPlant != null) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), sPlantSite) | 그리드 값 설정 |  |  |  |
| AC-d2b4a3f9 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1291 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ else of (drPlant != null) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-403d72dd | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1300 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") | DATA_OP | dtAllPrjRouteModel.Select | ("DIVISION_ID = '" + division + "' AND ITEM_ID = '" + sItemID + "' AND PLANT_SITE_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-5c098ae6 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1303 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") | DATA_OP | dtLine.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe30ae6e | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1304 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") | DATA_OP | dtLine.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-e818236a | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1308 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") ▸ foreach (DataRow dr in drArr) | DATA_OP | dtLine.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fa5b08e2 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1309 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc4b95ce | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1310 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-71ba05ea | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1311 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") ▸ foreach (DataRow dr in drArr) | DATA_OP | dtLine.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f17d4b2e | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1314 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") | DATA_OP | dtLine.DefaultView.ToTable | (true, "CODE", "NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-885d1f08 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1316 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), tmpDtLine) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9d73f0d3 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1319 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") | DATA_OP | tmpDtLine.Select | ("CODE = '" + sLine + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-05e2cd8b | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1322 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") ▸ if (drLine != null) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), sLine) | 그리드 값 설정 |  |  |  |
| AC-2a86686e | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1326 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ if (sPlantSite!="") ▸ else of (drLine != null) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-43d1f15e | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1332 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ else of (sPlantSite!="") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), dtTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-aa048131 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1333 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (sItemID!="") ▸ else of (sPlantSite!="") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-1b4a2b35 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1338 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ else of (sItemID!="") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), dtTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-63ff891b | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1339 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ else of (sItemID!="") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-eb831625 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1340 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ else of (sItemID!="") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), dtTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0ffab92c | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1341 | if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ else of (sItemID!="") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-8507c8e6 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1348 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | DATA_OP | dtAllPrjRouteModel.Select | ("DIVISION_ID = '" + division + "' AND ITEM_ID = '" + sItemID + "' AND PLANT_SITE_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-ea827195 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1351 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | DATA_OP | dtLine.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c4eb087 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1352 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | DATA_OP | dtLine.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-62b553d7 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1356 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | DATA_OP | dtLine.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-87e93ba0 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1357 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | DATA_OP | drRow["CODE"] | dr["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-16f72619 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1358 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | DATA_OP | drRow["NAME"] | dr["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae22bffc | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1359 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | DATA_OP | dtLine.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6329fca | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1362 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | DATA_OP | dtLine.DefaultView.ToTable | (true, "CODE", "NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-deb387cd | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1364 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), tmpDtLine) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1ca294f8 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1366 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | DATA_OP | tmpDtLine.Select | ("CODE = '" + sLine + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-04bb57c2 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1369 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), sLine) | 그리드 값 설정 |  |  |  |
| AC-3a3896b6 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1373 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-5c4157c8 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1379 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), dtTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-74d4a266 | this.spdMain.ComboSelChange 외 1 | SCP0046_ModelAllocation.cs:1380 | else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PLANT_SITE_ID))… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_LINE_ID), "") | 그리드 값 설정 |  |  |  |

## SCP0046_ModelAllocation.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87c027d0 | spdMain.TopChange | SCP0046_ModelAllocation.cs:260 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

