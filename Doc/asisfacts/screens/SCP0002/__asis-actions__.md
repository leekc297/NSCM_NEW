# AS-IS 액션 대조표 — SCP0002

> 원천: `Doc/asisfacts/screens/SCP0002/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 161행 · 메서드 24 · 종류 DATA_OP 47 · GRID_INIT 19 · RETURN 14 · FLAG 11 · GRID_SET 11 · LIST_REBIND 9 · GRID_LOCK 9 · UI_PROP 9 · ENDPOINT 9 · UI_MISC 6 · POPUP 4 · VALIDATE 4 · MESSAGE 3 · COMBO_DATA 2 · GRID_BIND 2 · STATE_RESET 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 0


## SCP0002_LineMaster.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41972312 | (진입점 미연결) | SCP0002_LineMaster.cs:160 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5de0253f | (진입점 미연결) | SCP0002_LineMaster.cs:161 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0002_LineMaster.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c609d2bf | this.Load | SCP0002_LineMaster.cs:255 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-80f7fce1 | this.Load | SCP0002_LineMaster.cs:256 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e5805cbf | this.Load | SCP0002_LineMaster.cs:258 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPacker, SpdSheet.shtPacker, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-04a51401 | this.Load | SCP0002_LineMaster.cs:259 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-178fc14f | this.Load | SCP0002_LineMaster.cs:261 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0002_LineMaster.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0c686e0 | this.Load | SCP0002_LineMaster.cs:132 |  | FLAG | dtPlantSiteByDivisionPacker | Data_SCP.Common(Data_SCP.Type.PlantByDivisionOperOsp3, false, "40,81,82", "P", "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-eec740b4 | this.Load | SCP0002_LineMaster.cs:132 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionOperOsp3, false, "40,81,82", "P", "Y") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0002_LineMaster.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9d73ce8 | DeleteButton | SCP0002_LineMaster.cs:394 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b34a6595 | DeleteButton | SCP0002_LineMaster.cs:398 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2216f112 | DeleteButton | SCP0002_LineMaster.cs:403 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0002_LineMaster.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4455e393 | Dispose | SCP0002_LineMaster.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0002_LineMaster.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d376874 | EditButton | SCP0002_LineMaster.cs:371 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-09c2e377 | EditButton | SCP0002_LineMaster.cs:372 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6528281d | EditButton | SCP0002_LineMaster.cs:376 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-77afde6e | EditButton | SCP0002_LineMaster.cs:378 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-55cf37a8 | EditButton | SCP0002_LineMaster.cs:379 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.LINE_ID),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6aa23f03 | EditButton | SCP0002_LineMaster.cs:380 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.OPERATION_ID), siMain.GetColumnIndex(DefColumns.OPERATIO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-03966dc6 | EditButton | SCP0002_LineMaster.cs:381 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.RACK_YN), siMain.GetColumnIndex(DefColumns.RACK_YN), tru… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0002_LineMaster.Find_Packer

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85a87bdd | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:512 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-20c4e632 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:515 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-9060807a | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:515 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f3e8ce3 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:519 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-55478ce7 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:523 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPacker) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8be8a1ba | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:539 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6b61f51d | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:540 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc65807a | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:544 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0002_GET_LINE_MASTER_OSP") ⇒ SCP.SCP0002_GET_LINE_MASTER_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-dfd3a88a | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:545 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-500863ff | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:546 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-4b67c340 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:547 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-540a15ba | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:548 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? DBNull.Value : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-f9ab1556 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:549 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | pValid.Equals("ALL") ? DBNull.Value : pValid | 행/컬럼 값 대입 |  |  |  |
| AC-5f5ca648 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:551 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-214dfb28 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:553 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-052e78ce | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:560 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-30d8ca53 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:561 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ede0a321 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:564 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-38a1ca83 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0002_LineMaster.cs:577 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0002_LineMaster.FindData_Plant

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1cb69ca | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:438 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4f871008 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:441 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c968af32 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:441 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19d1c2b2 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:445 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4a87f4b9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:449 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e5364fa | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:463 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-dfbf7c7a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:464 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f0b423ab | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:468 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0002_GET_LINE_MASTER") ⇒ SCP.SCP0002_GET_LINE_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-b8bff41c | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:469 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2796b683 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:470 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-e1919d5f | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:471 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-8a1ffbf9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:472 | try ▸ lambda | DATA_OP | request.Parameters["p_location_code"] | pLocationCode.Equals("ALL") ? DBNull.Value : pLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-e4bb1d89 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:473 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-1ee7800a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:474 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-4ec5f3fe | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:475 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? DBNull.Value : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-4c83bfd4 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:476 | try ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | pValid.Equals("ALL") ? DBNull.Value : pValid | 행/컬럼 값 대입 |  |  |  |
| AC-0fcfde3a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:478 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7a464a37 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:480 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-432e56a8 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:487 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5106f400 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:488 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3319c237 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:491 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1cbe292a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:494 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5dd4604a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0002_LineMaster.cs:504 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0002_LineMaster.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a541a8a | this.Load | SCP0002_LineMaster.cs:119 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0002_LineMaster.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96eb5631 | this.Load | SCP0002_LineMaster.cs:137 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f995cf2d | this.Load | SCP0002_LineMaster.cs:140 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-5978ef21 | this.Load | SCP0002_LineMaster.cs:143 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-6f12455f | this.Load | SCP0002_LineMaster.cs:145 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-78fbfcd4 | this.Load | SCP0002_LineMaster.cs:146 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |

## SCP0002_LineMaster.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a8ee2d5 | this.Load | SCP0002_LineMaster.cs:271 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d799eeb4 | this.Load | SCP0002_LineMaster.cs:272 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0002_LineMaster.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-462b2e8d | InsertButton | SCP0002_LineMaster.cs:589 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | DATA_OP | dtPlantSiteByDivisionPacker.Select | ("DIVISION_ID = '" + division + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-7fa2b639 | InsertButton | SCP0002_LineMaster.cs:592 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | DATA_OP | dtPlantRowIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1d002fa | InsertButton | SCP0002_LineMaster.cs:593 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | DATA_OP | dtPlantRowIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-1cca4118 | InsertButton | SCP0002_LineMaster.cs:597 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ foreach (DataRow… | DATA_OP | dtPlantRowIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2cb8255d | InsertButton | SCP0002_LineMaster.cs:598 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ foreach (DataRow… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-33df69fb | InsertButton | SCP0002_LineMaster.cs:599 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ foreach (DataRow… | DATA_OP | drRow["NAME"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-38049684 | InsertButton | SCP0002_LineMaster.cs:600 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ foreach (DataRow… | DATA_OP | dtPlantRowIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d50ae97 | InsertButton | SCP0002_LineMaster.cs:604 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ae192e19 | InsertButton | SCP0002_LineMaster.cs:607 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtPlantRowIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2c9bd91e | InsertButton | SCP0002_LineMaster.cs:609 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b3cd3b3 | InsertButton | SCP0002_LineMaster.cs:610 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-e7d05e93 | InsertButton | SCP0002_LineMaster.cs:611 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | DATA_OP | defaultData.Add | (DefColumns.RACK_YN, "N") | 데이터 객체 조작/조회 |  |  |  |
| AC-65580594 | InsertButton | SCP0002_LineMaster.cs:613 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-7307eb1d | InsertButton | SCP0002_LineMaster.cs:615 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a0550aed | InsertButton | SCP0002_LineMaster.cs:616 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f476562d | InsertButton | SCP0002_LineMaster.cs:617 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_ID), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0002_LineMaster.RefreshBuildingByPlantSite

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / clbPlantSite.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b45a92eb | this.Load 외 3 | SCP0002_LineMaster.cs:182 |  | FLAG | dtBuildingByPlantSite | DBUtils.Filter(dtBuildingByPlantSiteAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-dbc05e4d | this.Load 외 3 | SCP0002_LineMaster.cs:182 |  | DATA_OP | DBUtils.Filter | (dtBuildingByPlantSiteAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-26723fda | this.Load 외 3 | SCP0002_LineMaster.cs:184 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByPlantSite, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0002_LineMaster.RefreshLine

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / clbPlantSite.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / clbBuilding.SelectedIndexChanged / clbOperation.SelectedIndexChanged / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b0958f0 | this.Load 외 5 | SCP0002_LineMaster.cs:203 |  | FLAG | dtLineByOperation | DBUtils.Filter(dtLineByOperationAll, "DIVISION_ID = '" + division + "'" + filterBuilding +… | 화면 필드/플래그 변경 |  |  |  |
| AC-769a8ec3 | this.Load 외 5 | SCP0002_LineMaster.cs:203 |  | DATA_OP | DBUtils.Filter | (dtLineByOperationAll, "DIVISION_ID = '" + division + "'" + filterBuilding + filterOperati… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7b26d945 | this.Load 외 5 | SCP0002_LineMaster.cs:205 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0002_LineMaster.RefreshOperationByBuilding

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / clbPlantSite.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / clbBuilding.SelectedIndexChanged / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e25255b | this.Load 외 4 | SCP0002_LineMaster.cs:166 |  | FLAG | dtOperationByBuilding | Data.Common(Data.Type.LocationGroupByCapa, false) ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 화면 필드/플래그 변경 |  |  |  |
| AC-c32854b1 | this.Load 외 4 | SCP0002_LineMaster.cs:166 |  | COMBO_DATA | Data.Common | (Data.Type.LocationGroupByCapa, false) ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33d632ad | this.Load 외 4 | SCP0002_LineMaster.cs:168 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByBuilding, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0002_LineMaster.RefreshPlantSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1461b3f5 | this.Load 외 2 | SCP0002_LineMaster.cs:174 |  | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-0865b72d | this.Load 외 2 | SCP0002_LineMaster.cs:174 |  | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5c3ed833 | this.Load 외 2 | SCP0002_LineMaster.cs:176 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0002_LineMaster.RefreshtLineByPlantPacker

진입점: clbPlantSite.SelectedIndexChanged [else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2fbd57d | clbPlantSite.SelectedIndexChanged [else of (siMain.ActiveShe… 외 1 | SCP0002_LineMaster.cs:214 |  | FLAG | dtLineByPlantPacker | DBUtils.Filter(dtLineByPlantPackerAll, "DIVISION_ID = '" + division + "'" + filterPlantSit… | 화면 필드/플래그 변경 |  |  |  |
| AC-cd962d0c | clbPlantSite.SelectedIndexChanged [else of (siMain.ActiveShe… 외 1 | SCP0002_LineMaster.cs:214 |  | DATA_OP | DBUtils.Filter | (dtLineByPlantPackerAll, "DIVISION_ID = '" + division + "'" + filterPlantSite, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-55a34c0f | clbPlantSite.SelectedIndexChanged [else of (siMain.ActiveShe… 외 1 | SCP0002_LineMaster.cs:216 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByPlantPacker, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0002_LineMaster.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7383149 | SaveButton | SCP0002_LineMaster.cs:625 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4adaafc | SaveButton | SCP0002_LineMaster.cs:627 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87b73e85 | SaveButton | SCP0002_LineMaster.cs:632 | if (siMain.SheetName == SpdSheet.shtPacker) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-e83a5f7e | SaveButton | SCP0002_LineMaster.cs:634 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62218d3a | SaveButton | SCP0002_LineMaster.cs:674 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0002_SAVE_LINE_MASTER_OSP") ⇒ SCP.SCP0002_SAVE_LINE_MASTER_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-696f189a | SaveButton | SCP0002_LineMaster.cs:677 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4948f171 | SaveButton | SCP0002_LineMaster.cs:680 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-72e4e410 | SaveButton | SCP0002_LineMaster.cs:682 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b529f35a | SaveButton | SCP0002_LineMaster.cs:683 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-362f444c | SaveButton | SCP0002_LineMaster.cs:684 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-1daafe64 | SaveButton | SCP0002_LineMaster.cs:685 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-b283976e | SaveButton | SCP0002_LineMaster.cs:686 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-25763cc6 | SaveButton | SCP0002_LineMaster.cs:687 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-58770606 | SaveButton | SCP0002_LineMaster.cs:688 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_scs_prod_amend"] | p_scs_prod_amend | 행/컬럼 값 대입 |  |  |  |
| AC-878c7993 | SaveButton | SCP0002_LineMaster.cs:689 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-62040ccc | SaveButton | SCP0002_LineMaster.cs:690 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-a8d693d1 | SaveButton | SCP0002_LineMaster.cs:692 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-78771cb2 | SaveButton | SCP0002_LineMaster.cs:692 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-5712c81b | SaveButton | SCP0002_LineMaster.cs:701 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62f787ec | SaveButton | SCP0002_LineMaster.cs:714 | if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0002_LineMaster.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c24df324 | SaveButton | SCP0002_LineMaster.cs:411 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0002_LineMaster.SetChangedControl_Osp

진입점: cboDivision.SelectedIndexChanged [else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtPacker)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d44546f | cboDivision.SelectedIndexChanged [else of (siMain.ActiveShee… 외 1 | SCP0002_LineMaster.cs:236 |  | DATA_OP | dtPlantSiteByDivisionPacker.Select | ("DIVISION_ID = '" + division + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-2e6e1a74 | cboDivision.SelectedIndexChanged [else of (siMain.ActiveShee… 외 1 | SCP0002_LineMaster.cs:238 |  | FLAG | dtPlantSiteOspIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-45c92b3f | cboDivision.SelectedIndexChanged [else of (siMain.ActiveShee… 외 1 | SCP0002_LineMaster.cs:239 |  | DATA_OP | dtPlantSiteOspIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-04f87e9d | cboDivision.SelectedIndexChanged [else of (siMain.ActiveShee… 외 1 | SCP0002_LineMaster.cs:240 |  | DATA_OP | dtPlantSiteOspIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-9e93555f | cboDivision.SelectedIndexChanged [else of (siMain.ActiveShee… 외 1 | SCP0002_LineMaster.cs:244 | foreach (DataRow dr in drArr) | DATA_OP | dtPlantSiteOspIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-da3789fc | cboDivision.SelectedIndexChanged [else of (siMain.ActiveShee… 외 1 | SCP0002_LineMaster.cs:245 | foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1beec9ae | cboDivision.SelectedIndexChanged [else of (siMain.ActiveShee… 외 1 | SCP0002_LineMaster.cs:246 | foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f5ce2132 | cboDivision.SelectedIndexChanged [else of (siMain.ActiveShee… 외 1 | SCP0002_LineMaster.cs:247 | foreach (DataRow dr in drArr) | DATA_OP | dtPlantSiteOspIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ce19c6b | cboDivision.SelectedIndexChanged [else of (siMain.ActiveShee… 외 1 | SCP0002_LineMaster.cs:249 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteOspIns, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0002_LineMaster.SetSpreadInit

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (siMain.SheetName == SpdSheet.shtPacker) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0123d752 | this.Load 외 2 | SCP0002_LineMaster.cs:279 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9584288b | this.Load 외 2 | SCP0002_LineMaster.cs:280 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-9df2f1e7 | this.Load 외 2 | SCP0002_LineMaster.cs:284 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27472e16 | this.Load 외 2 | SCP0002_LineMaster.cs:285 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-f83c0a0f | this.Load 외 2 | SCP0002_LineMaster.cs:287 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b05f36a8 | this.Load 외 2 | SCP0002_LineMaster.cs:288 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3ce9d9f3 | this.Load 외 2 | SCP0002_LineMaster.cs:289 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0002_LineMaster.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd018de0 | this.spdMain.ActiveSheetChanged | SCP0002_LineMaster.cs:309 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-afab11cb | this.spdMain.ActiveSheetChanged | SCP0002_LineMaster.cs:310 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-35c7eeff | this.spdMain.ActiveSheetChanged | SCP0002_LineMaster.cs:312 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-edab1778 | this.spdMain.ActiveSheetChanged | SCP0002_LineMaster.cs:313 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-526f88db | this.spdMain.ActiveSheetChanged | SCP0002_LineMaster.cs:319 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f9f81818 | this.spdMain.ActiveSheetChanged | SCP0002_LineMaster.cs:320 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-eb17cf4b | this.spdMain.ActiveSheetChanged | SCP0002_LineMaster.cs:322 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPacker) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a906d73d | this.spdMain.ActiveSheetChanged | SCP0002_LineMaster.cs:323 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPacker) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0002_LineMaster.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09e39ab0 | this.spdMain.ClipboardPasted | SCP0002_LineMaster.cs:830 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ if (siMain.Activ… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cca34f42 | this.spdMain.ClipboardPasted | SCP0002_LineMaster.cs:863 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ for (iRow < e.Ce… | DATA_OP | dtPlantSiteByDivisionPacker.Select | ("DIVISION_ID = '" + division + "' AND CODE = '" + sScmSiteId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e54e4e35 | this.spdMain.ClipboardPasted | SCP0002_LineMaster.cs:866 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ for (iRow < e.Ce… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), drArr[DefColumns.NAME].ToString… | 그리드 값 설정 |  |  |  |
| AC-6c69f953 | this.spdMain.ClipboardPasted | SCP0002_LineMaster.cs:867 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ for (iRow < e.Ce… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_ID), drArr[DefColumns.OPERATION_ID].ToSt… | 그리드 값 설정 |  |  |  |
| AC-f3d61f70 | this.spdMain.ClipboardPasted | SCP0002_LineMaster.cs:872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ for (iRow < e.Ce… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-c3ef4edf | this.spdMain.ClipboardPasted | SCP0002_LineMaster.cs:873 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ for (iRow < e.Ce… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |

## SCP0002_LineMaster.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcedef82 | this.spdMain.ComboSelChange | SCP0002_LineMaster.cs:779 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ if (siMain.Activ… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c185829 | this.spdMain.ComboSelChange | SCP0002_LineMaster.cs:788 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ if (e.Column == … | DATA_OP | dtPlantSiteByDivisionPacker.Select | ("DIVISION_ID = '" + division + "' AND CODE = '" + sScmSiteId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-694f937d | this.spdMain.ComboSelChange | SCP0002_LineMaster.cs:791 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ if (e.Column == … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), drArr[DefColumns.NAME].ToStrin… | 그리드 값 설정 |  |  |  |
| AC-7c7180ce | this.spdMain.ComboSelChange | SCP0002_LineMaster.cs:792 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ if (e.Column == … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), drArr[DefColumns.OPERATION_ID].ToS… | 그리드 값 설정 |  |  |  |
| AC-56984aca | this.spdMain.ComboSelChange | SCP0002_LineMaster.cs:797 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ if (e.Column == … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-90bb8f60 | this.spdMain.ComboSelChange | SCP0002_LineMaster.cs:798 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ if (e.Column == … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-5700b0e8 | this.spdMain.ComboSelChange | SCP0002_LineMaster.cs:806 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ else of (e.Colum… | DATA_OP | dtPlantSiteByDivisionPacker.Select | ("DIVISION_ID = '" + division + "' AND CODE = '" + sScmSiteId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b9be0cc | this.spdMain.ComboSelChange | SCP0002_LineMaster.cs:811 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ else of (e.Colum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), drArr[DefColumns.OPERATION_ID].ToS… | 그리드 값 설정 |  |  |  |
| AC-2a6bed63 | this.spdMain.ComboSelChange | SCP0002_LineMaster.cs:815 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ else of (e.Colum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), drArr[DefColumns.OPERATION_ID].ToS… | 그리드 값 설정 |  |  |  |

