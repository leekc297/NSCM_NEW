# AS-IS 액션 대조표 — SCP0003

> 원천: `Doc/asisfacts/screens/SCP0003/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 208행 · 메서드 23 · 종류 DATA_OP 64 · GRID_INIT 47 · FLAG 16 · ENDPOINT 11 · UI_PROP 10 · COMBO_DATA 9 · RETURN 9 · LIST_REBIND 8 · GRID_LOCK 8 · POPUP 5 · GRID_SET 5 · UI_MISC 4 · VALIDATE 3 · GRID_BIND 3 · MESSAGE 3 · CALL_EXT 2 · STATE_RESET 1 · ⚠ 의미 확인 필요 2


## SCP0003_ProductionCapacity.BtnMeasure_Click

진입점: btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c97ad591 | btnMeasure.Click | SCP0003_ProductionCapacity.cs:1075 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0003", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-0f864b54 | btnMeasure.Click | SCP0003_ProductionCapacity.cs:1079 | else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtSub) | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0003", SpdSheet.shtSub, false) | 팝업/폼 생성 |  |  |  |
| AC-ee9fa58d | btnMeasure.Click | SCP0003_ProductionCapacity.cs:1082 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-11515706 | btnMeasure.Click | SCP0003_ProductionCapacity.cs:1083 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0003_ProductionCapacity.ClbBuilding_SelectedIndexChanged

진입점: clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ad92e57 | clbBuilding.SelectedIndexChanged | SCP0003_ProductionCapacity.cs:881 |  | FLAG | dtOperation | Data.Common(Data.Type.OperationByBuilding, false, division, pPlantSiteID, pFactoryID) ⇒ biz:CommonData.CommonDataList [code=OperationByBuilding] | 화면 필드/플래그 변경 |  |  |  |
| AC-eec80472 | clbBuilding.SelectedIndexChanged | SCP0003_ProductionCapacity.cs:881 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByBuilding, false, division, pPlantSiteID, pFactoryID) ⇒ biz:CommonData.CommonDataList [code=OperationByBuilding] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f28719a0 | clbBuilding.SelectedIndexChanged | SCP0003_ProductionCapacity.cs:882 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0003_ProductionCapacity.ClbOperation_SelectedIndexChanged

진입점: clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0561a1ca | clbOperation.SelectedIndexChanged | SCP0003_ProductionCapacity.cs:894 |  | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, pPlantSiteID, pFactoryID, pOperati… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-b6ef86d5 | clbOperation.SelectedIndexChanged | SCP0003_ProductionCapacity.cs:894 |  | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, pPlantSiteID, pFactoryID, pOperationID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb418b70 | clbOperation.SelectedIndexChanged | SCP0003_ProductionCapacity.cs:895 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0003_ProductionCapacity.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb58d08e | clbPlantSite.SelectedIndexChanged | SCP0003_ProductionCapacity.cs:868 |  | FLAG | dtBuilding | Data.Common(Data.Type.BuildingByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=BuildingByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-9b628939 | clbPlantSite.SelectedIndexChanged | SCP0003_ProductionCapacity.cs:868 |  | COMBO_DATA | Data.Common | (Data.Type.BuildingByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=BuildingByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f6c0e23 | clbPlantSite.SelectedIndexChanged | SCP0003_ProductionCapacity.cs:869 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuilding, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0003_ProductionCapacity.ClearUsrCheckedList

진입점: clbDivision.SelectedIndexChanged / clbPlantSite.SelectedIndexChanged / clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f5dd304 | clbDivision.SelectedIndexChanged 외 2 | SCP0003_ProductionCapacity.cs:815 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f676ce9c | clbDivision.SelectedIndexChanged 외 2 | SCP0003_ProductionCapacity.cs:816 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0003_ProductionCapacity.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a654296 | this.Load | SCP0003_ProductionCapacity.cs:176 |  | GRID_INIT | AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-36d1422a | this.Load | SCP0003_ProductionCapacity.cs:177 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-87512f02 | this.Load | SCP0003_ProductionCapacity.cs:179 |  | GRID_INIT | AddSheet | (spdMain, SpdSheet.shtSub, SpdSheet.shtSub, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9e9d97b6 | this.Load | SCP0003_ProductionCapacity.cs:180 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-2243669c | this.Load | SCP0003_ProductionCapacity.cs:182 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0003_ProductionCapacity.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87ef8264 | Dispose | SCP0003_ProductionCapacity.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0003_ProductionCapacity.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64f8cfbf | EditButton | SCP0003_ProductionCapacity.cs:411 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f3d3684 | EditButton | SCP0003_ProductionCapacity.cs:412 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8f0fbcf0 | EditButton | SCP0003_ProductionCapacity.cs:414 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.MEASURE),… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0003_ProductionCapacity.FindData_OutsoucingCapacity

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14090519 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:499 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d35cf61e | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:499 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f13085e5 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:503 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c76547d | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:515 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9976aa72 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:519 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0003_GET_PRODUCTION_CAPACITY_OSP") ⇒ SCP.SCP0003_GET_PRODUCTION_CAPACITY_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-93a8713c | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:520 | lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d6e75619 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:523 | lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | pFromYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-8e6bbb08 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:524 | lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | pToYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-33777349 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:525 | lambda | DATA_OP | request.Parameters["p_division_id"] | division.Equals("ALL") ? DBNull.Value : division | 행/컬럼 값 대입 |  |  |  |
| AC-c3a3ed75 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:526 | lambda | DATA_OP | request.Parameters["p_plant_site"] | pPlantSite.Equals("ALL") ? DBNull.Value : pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-37267e28 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:527 | lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-e790bd91 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:528 | lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-6afaeda4 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:529 | lambda | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? DBNull.Value : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-76958864 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:530 | lambda | DATA_OP | request.Parameters["p_program_id"] | "SCP0003" | 행/컬럼 값 대입 |  |  |  |
| AC-452550c9 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:531 | lambda | DATA_OP | request.Parameters["p_sheet_name"] | "Outsourcing Capacity" | 행/컬럼 값 대입 |  |  |  |
| AC-1c60575e | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:532 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c290f4be | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:534 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c646183c | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:536 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-90da55b6 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:540 |  | FLAG | dsQtyTemp | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-5c984804 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:542 |  | FLAG | dsQtyTemp | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1313ab16 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:542 |  | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-17ce6650 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:545 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ab9ff58a | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:546 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-31883da1 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:549 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-54ad9fa5 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0003_ProductionCapacity.cs:551 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0003_ProductionCapacity.FindData_ProductionCapacity

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e674c775 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:435 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-6930051c | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:435 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb0605a2 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:439 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ef517e4 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:459 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7d0969ac | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:463 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0003_GET_PRODUCTION_CAPACITY") ⇒ SCP.SCP0003_GET_PRODUCTION_CAPACITY | 엔드포인트 요청 생성 |  |  |  |
| AC-b51625ab | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:464 | lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fe3dbac2 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:467 | lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | pFromYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-15f5c71e | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:468 | lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | pToYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-c75e4809 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:469 | lambda | DATA_OP | request.Parameters["p_division_id"] | division.Equals("ALL") ? DBNull.Value : division | 행/컬럼 값 대입 |  |  |  |
| AC-b81eadb6 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:470 | lambda | DATA_OP | request.Parameters["p_plant_site"] | pPlantSite.Equals("ALL") ? DBNull.Value : pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-a6d0ca32 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:471 | lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-7c1a3fe9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:472 | lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-fec15a31 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:473 | lambda | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? DBNull.Value : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-9d1dbf67 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:474 | lambda | DATA_OP | request.Parameters["p_program_id"] | "SCP0003" | 행/컬럼 값 대입 |  |  |  |
| AC-d23997c6 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:475 | lambda | DATA_OP | request.Parameters["p_sheet_name"] | "Production Capacity" | 행/컬럼 값 대입 |  |  |  |
| AC-a54b2607 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:476 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4a5b5ea0 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:478 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62e4972a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:480 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b995c92f | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:484 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-71c9cc57 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:485 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba92761a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:488 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1f5e9827 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0003_ProductionCapacity.cs:490 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0003_ProductionCapacity.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65f10d5a | this.Load | SCP0003_ProductionCapacity.cs:142 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0003_ProductionCapacity.GetSpdTitle

진입점: this.Load / btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ff27d7d | this.Load 외 4 | SCP0003_ProductionCapacity.cs:1055 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0003_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0003_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-5e847dbf | this.Load 외 4 | SCP0003_ProductionCapacity.cs:1060 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dateRangePeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-2035d8fe | this.Load 외 4 | SCP0003_ProductionCapacity.cs:1061 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dateRangePeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-a10bb721 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:1066 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-08fa1ef8 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:1066 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0003_ProductionCapacity.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73bd835b | this.Load | SCP0003_ProductionCapacity.cs:159 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f8adfde | this.Load | SCP0003_ProductionCapacity.cs:161 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ca87c123 | this.Load | SCP0003_ProductionCapacity.cs:164 |  | LIST_REBIND | cboPeriod.DataBind | (Data.Type.PeriodType, false) ⇒ biz:CommonData.CommonDataList [code=PeriodType] | 목록 컨트롤 재구성 |  |  |  |

## SCP0003_ProductionCapacity.InitSpreadDateColumn

진입점: this.Load / btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36ac9334 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:283 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12b66d9b | this.Load 외 4 | SCP0003_ProductionCapacity.cs:287 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 75, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93f07e08 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:291 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-069d5fb2 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:304 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName \|\| iCellCnt == dsSpdTitle.Tables[0].Rows.Count) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff2deb8a | this.Load 외 4 | SCP0003_ProductionCapacity.cs:310 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName \|\| iCellCnt == dsSpdTitle.Tables[0].Rows.Count) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d157296 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:319 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName \|\| iCellCnt == dsSpdTitle.Tables[0].Rows.Co… | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0003_ProductionCapacity.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c02c828 | InsertButton | SCP0003_ProductionCapacity.cs:716 |  | POPUP | new SCM0003_ProductionCapacityInsertPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f47389ac | InsertButton | SCP0003_ProductionCapacity.cs:718 |  | UI_PROP | popup.Width | 1000 | 속성 Width 설정 |  |  |  |
| AC-438e62bd | InsertButton | SCP0003_ProductionCapacity.cs:719 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-047de0f7 | InsertButton | SCP0003_ProductionCapacity.cs:720 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0092e1c1 | InsertButton | SCP0003_ProductionCapacity.cs:722 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9b1610e7 | InsertButton | SCP0003_ProductionCapacity.cs:724 | if (popup.ShowDialog() == DialogResult.OK) | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32f5b980 | InsertButton | SCP0003_ProductionCapacity.cs:733 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (siMain.Sheet().Rows.Count > 0) | DATA_OP | ds.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b6dcaf19 | InsertButton | SCP0003_ProductionCapacity.cs:747 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (siMain.Sheet().Rows.Count > 0)… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cc387f3b | InsertButton | SCP0003_ProductionCapacity.cs:748 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (siMain.Sheet().Rows.Count > 0)… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-805b695b | InsertButton | SCP0003_ProductionCapacity.cs:758 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | CALL_EXT | siMain.InsertNewRow | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b388f53b | InsertButton | SCP0003_ProductionCapacity.cs:762 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | DATA_OP | defaultData.Add | (DefColumns.KEY_IDX, sKeyIdx) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a818c5d | InsertButton | SCP0003_ProductionCapacity.cs:763 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, ProdCapa.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a8ae029 | InsertButton | SCP0003_ProductionCapacity.cs:764 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | DATA_OP | defaultData.Add | (DefColumns.SCM_SITE_ID, ProdCapa.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-6dddd368 | InsertButton | SCP0003_ProductionCapacity.cs:765 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | DATA_OP | defaultData.Add | (DefColumns.FACTORY_ID, ProdCapa.FACTORY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-446337fa | InsertButton | SCP0003_ProductionCapacity.cs:766 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | DATA_OP | defaultData.Add | (DefColumns.OPERATION_ID, ProdCapa.OPERATION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d97c1e7b | InsertButton | SCP0003_ProductionCapacity.cs:767 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | DATA_OP | defaultData.Add | (DefColumns.LINE_ID, ProdCapa.LINE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a555ad8d | InsertButton | SCP0003_ProductionCapacity.cs:768 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | DATA_OP | defaultData.Add | (DefColumns.PROJECT_ID, ProdCapa.PROJECT_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-31bdcec7 | InsertButton | SCP0003_ProductionCapacity.cs:769 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, ProdCapa.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-14faf610 | InsertButton | SCP0003_ProductionCapacity.cs:770 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | DATA_OP | defaultData.Add | (DefColumns.USER_SORT_ORDER_NO, ((iRow+1) * 10).ToString("00")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcb350ae | InsertButton | SCP0003_ProductionCapacity.cs:771 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | DATA_OP | defaultData.Add | (DefColumns.MEASURE, str) | 데이터 객체 조작/조회 |  |  |  |
| AC-7719d7e9 | InsertButton | SCP0003_ProductionCapacity.cs:773 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-29934b29 | InsertButton | SCP0003_ProductionCapacity.cs:776 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ foreach (string str in FixColumn) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c95c05d9 | InsertButton | SCP0003_ProductionCapacity.cs:784 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-598ef5d7 | InsertButton | SCP0003_ProductionCapacity.cs:787 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | DATA_OP | (siMain.ActiveSheet.DataSource as DataSet).Tables[0].Select().OrderBy(c => c[DefColumns.US… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f0272312 | InsertButton | SCP0003_ProductionCapacity.cs:787 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | DATA_OP | (siMain.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1253f7a3 | InsertButton | SCP0003_ProductionCapacity.cs:789 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | UI_PROP | dt.DefaultView.Sort | DefColumns.USER_SORT_ORDER_NO + " ASC" | 속성 Sort 설정 |  |  |  |
| AC-2e5411a7 | InsertButton | SCP0003_ProductionCapacity.cs:790 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | UI_PROP | dt.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-00ce7489 | InsertButton | SCP0003_ProductionCapacity.cs:791 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3acee9e8 | InsertButton | SCP0003_ProductionCapacity.cs:794 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | DATA_OP | dsTemp.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-0315ae19 | InsertButton | SCP0003_ProductionCapacity.cs:796 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | GRID_BIND | siMain.Query | (dsTemp) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9f853e17 | InsertButton | SCP0003_ProductionCapacity.cs:797 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d010b177 | InsertButton | SCP0003_ProductionCapacity.cs:799 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0bfa763c | InsertButton | SCP0003_ProductionCapacity.cs:800 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |

## SCP0003_ProductionCapacity.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0fe027e | SaveButton | SCP0003_ProductionCapacity.cs:581 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-5ade5f88 | SaveButton | SCP0003_ProductionCapacity.cs:581 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8358dfa | SaveButton | SCP0003_ProductionCapacity.cs:614 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ for (i <= siMain.GetMaxRowIndex… | DATA_OP | dsQtyTemp.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9cee0b1d | SaveButton | SCP0003_ProductionCapacity.cs:659 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0003_SAVE_PRODUCTION_CAPACITY_OSP") ⇒ SCP.SCP0003_SAVE_PRODUCTION_CAPACITY_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-93e58fd4 | SaveButton | SCP0003_ProductionCapacity.cs:664 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-66dd9734 | SaveButton | SCP0003_ProductionCapacity.cs:668 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0d0dc588 | SaveButton | SCP0003_ProductionCapacity.cs:669 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a49de60 | SaveButton | SCP0003_ProductionCapacity.cs:670 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5f4c5e26 | SaveButton | SCP0003_ProductionCapacity.cs:671 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-062d45ec | SaveButton | SCP0003_ProductionCapacity.cs:672 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-94b60394 | SaveButton | SCP0003_ProductionCapacity.cs:673 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-c48e88ed | SaveButton | SCP0003_ProductionCapacity.cs:674 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-047375b6 | SaveButton | SCP0003_ProductionCapacity.cs:675 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ca481700 | SaveButton | SCP0003_ProductionCapacity.cs:676 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_measure_group"] | p_measure_group | 행/컬럼 값 대입 |  |  |  |
| AC-c236c516 | SaveButton | SCP0003_ProductionCapacity.cs:677 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cca6e1cf | SaveButton | SCP0003_ProductionCapacity.cs:678 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-97d51274 | SaveButton | SCP0003_ProductionCapacity.cs:679 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-39e403ed | SaveButton | SCP0003_ProductionCapacity.cs:680 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-c3c8bc67 | SaveButton | SCP0003_ProductionCapacity.cs:681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-6c0e26ff | SaveButton | SCP0003_ProductionCapacity.cs:683 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-66ff9c3c | SaveButton | SCP0003_ProductionCapacity.cs:683 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-c6a57543 | SaveButton | SCP0003_ProductionCapacity.cs:692 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ if (t.Success… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3ba8991 | SaveButton | SCP0003_ProductionCapacity.cs:701 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ if (t.Success… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0003_ProductionCapacity.SetCalCulation

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1145a246 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:955 | for (iRow <= siMain.GetMaxRowIndex()) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-273f533d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:957 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((siMain.SpreadObject.DataSource as DataSet).Tables[0].Select().Where(c => c[DefColumns.MEASURE].… | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cc70415d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:962 | for (iRow <= siMain.GetMaxRowIndex()) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-add7c292 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:964 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((siMain.SpreadObject.DataSource as DataSet).Tables[0].Select().Where(c => c[DefColumns.MEASURE].… | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c48aa456 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:969 | for (iRow <= siMain.GetMaxRowIndex()) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-abdac677 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:971 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((siMain.SpreadObject.DataSource as DataSet).Tables[0].Select().Where(c => c[DefColumns.MEASURE].… | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d9179180 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:976 | for (iRow <= siMain.GetMaxRowIndex()) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d0aeaea6 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:978 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((siMain.SpreadObject.DataSource as DataSet).Tables[0].Select().Where(c => c[DefColumns.MEASURE].… | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-945eb533 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:996 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (sMeasure.Equals("PPM")) ▸ if (iTackTime > 0) | GRID_SET | siMain.SetValue | (iRow, iCol, Math.Round(60 / iTackTime, 2)) | 그리드 값 설정 |  |  |  |
| AC-b281859e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:1011 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (sMeasure.Equals("CAPACITY_IN")) ▸ if (dTackTime > 0) | GRID_SET | siMain.SetValue | (iRow, iCol, Math.Round(dWorkingTime / dTackTime * 60, 2)) | 그리드 값 설정 |  |  |  |
| AC-52784e2b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | SCP0003_ProductionCapacity.cs:1028 | for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (sMeasure.Equals("CAPACITY_OUT")) ▸ if (iYield > 0) | GRID_SET | siMain.SetValue | (iRow, iCol, (iCapacityIn * iYield) / 100) | 그리드 값 설정 |  |  |  |

## SCP0003_ProductionCapacity.SetCalendar

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8ed9e99 | (진입점 미연결) | SCP0003_ProductionCapacity.cs:346 |  | FLAG | dtCalendar | Data.Common(Data.Type.CalendarWeek, false, dateRangePeriod.Text1.Replace("-", ""), dateRan… ⇒ biz:CommonData.CommonDataList [code=CalendarWeek] | 화면 필드/플래그 변경 |  |  |  |
| AC-bd5e700e | (진입점 미연결) | SCP0003_ProductionCapacity.cs:346 |  | COMBO_DATA | Data.Common | (Data.Type.CalendarWeek, false, dateRangePeriod.Text1.Replace("-", ""), dateRangePeriod.Te… ⇒ biz:CommonData.CommonDataList [code=CalendarWeek] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0e957375 | (진입점 미연결) | SCP0003_ProductionCapacity.cs:356 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-d20075e5 | (진입점 미연결) | SCP0003_ProductionCapacity.cs:357 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.WEEK) | 데이터 객체 조작/조회 |  |  |  |
| AC-499c4b20 | (진입점 미연결) | SCP0003_ProductionCapacity.cs:358 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.WEEK) | 데이터 객체 조작/조회 |  |  |  |
| AC-c36eb7b2 | (진입점 미연결) | SCP0003_ProductionCapacity.cs:360 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.AddNumColumn | (sWEEK_YYYMMDD, sWEEK_YYYMMDD, FPMerge.None, 75, true, FPHAlign.Right,FPVAlign.Center,4,fa… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1aed3fcc | (진입점 미연결) | SCP0003_ProductionCapacity.cs:362 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.SetColumnHeader | (0, spreadinfo.GetColumnIndex(sWEEK_YYYMMDD), sWEEK) | 그리드 재구성/초기화 |  |  |  |
| AC-00908b30 | (진입점 미연결) | SCP0003_ProductionCapacity.cs:363 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.SetColumnHeader | (1, spreadinfo.GetColumnIndex(sWEEK_YYYMMDD), sYYYYMMDD) | 그리드 재구성/초기화 |  |  |  |
| AC-e61be3a5 | (진입점 미연결) | SCP0003_ProductionCapacity.cs:374 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.ColumnHeaderSpan | (0, wIndex, 1, wCnt, 25, sWEEK, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0003_ProductionCapacity.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1202224e | this.Load 외 1 | SCP0003_ProductionCapacity.cs:824 |  | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantSiteByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-9926ae66 | this.Load 외 1 | SCP0003_ProductionCapacity.cs:824 |  | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d9d2e30a | this.Load 외 1 | SCP0003_ProductionCapacity.cs:825 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6f324172 | this.Load 외 1 | SCP0003_ProductionCapacity.cs:827 |  | FLAG | dtBuilding | Data.Common(Data.Type.BuildingByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=BuildingByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-206af811 | this.Load 외 1 | SCP0003_ProductionCapacity.cs:827 |  | COMBO_DATA | Data.Common | (Data.Type.BuildingByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=BuildingByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7a081847 | this.Load 외 1 | SCP0003_ProductionCapacity.cs:828 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuilding, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-47576679 | this.Load 외 1 | SCP0003_ProductionCapacity.cs:832 |  | FLAG | dtOperation | Data.Common(Data.Type.OperationByBuilding, false, division, "", "") ⇒ biz:CommonData.CommonDataList [code=OperationByBuilding] | 화면 필드/플래그 변경 |  |  |  |
| AC-34e821db | this.Load 외 1 | SCP0003_ProductionCapacity.cs:832 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByBuilding, false, division, "", "") ⇒ biz:CommonData.CommonDataList [code=OperationByBuilding] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-96efd8c4 | this.Load 외 1 | SCP0003_ProductionCapacity.cs:836 |  | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, pPlantSiteID, "", pOperationID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-801725cb | this.Load 외 1 | SCP0003_ProductionCapacity.cs:836 |  | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, pPlantSiteID, "", pOperationID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0003_ProductionCapacity.SetChangedPeriod

진입점: this.Load / cboPeriod.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66f7794a | this.Load 외 1 | SCP0003_ProductionCapacity.cs:841 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_"+ value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-02540fbb | this.Load 외 1 | SCP0003_ProductionCapacity.cs:844 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-024763f6 | this.Load 외 1 | SCP0003_ProductionCapacity.cs:848 | if (dt.Rows.Count > 0) | UI_PROP | dateRangePeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-9381b93b | this.Load 외 1 | SCP0003_ProductionCapacity.cs:849 | if (dt.Rows.Count > 0) | UI_PROP | dateRangePeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0003_ProductionCapacity.SetLockRow

진입점: InsertButton / EditButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1e1b86d | InsertButton 외 1 | SCP0003_ProductionCapacity.cs:1044 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.Equals("PPM") \|\| sMeasure.Equals("CAPACITY_IN") \|\| sMeasure.Equals("CAPACITY_OUT")) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0003_ProductionCapacity.SetSpreadInit

진입점: this.Load / btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var ProdCapa in popup.ProductionCapacityInfoList) ▸ if (bFlag)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40d054f9 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:192 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74015730 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:202 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4524547a | this.Load 외 4 | SCP0003_ProductionCapacity.cs:203 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-fc5b32a4 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:207 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1781d33 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:208 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-5e99049a | this.Load 외 4 | SCP0003_ProductionCapacity.cs:211 |  | GRID_INIT | siObj.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3fdc69e0 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:214 | if (sheetName.Equals(SpdSheet.shtSub)) | GRID_INIT | siObj.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a6fbea08 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:216 |  | GRID_INIT | siObj.AddTextColumn | ("KEY_IDX", DefColumns.KEY_IDX, FPMerge.Always, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c4cde9f | this.Load 외 4 | SCP0003_ProductionCapacity.cs:217 |  | GRID_INIT | siObj.AddComboColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.Restricted, 60, true, dtMyDivision, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-498c7b5b | this.Load 외 4 | SCP0003_ProductionCapacity.cs:218 |  | GRID_INIT | siObj.AddComboColumn | ("Plant Site", DefColumns.SCM_SITE_ID, FPMerge.Restricted, 90, true, dtPlantSiteByDivision… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f64e0f01 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:219 |  | GRID_INIT | siObj.AddComboColumn | ("Building", DefColumns.FACTORY_ID, FPMerge.Restricted, 60, true,dtBuilding, FPHAlign.Left… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9cf158e | this.Load 외 4 | SCP0003_ProductionCapacity.cs:220 |  | GRID_INIT | siObj.AddComboColumn | ("Operation", DefColumns.OPERATION_ID, FPMerge.Restricted, 60, true, dtOperation, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e1919c5 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:221 |  | GRID_INIT | siObj.AddComboColumn | ("Line", DefColumns.LINE_ID, FPMerge.Restricted, 90, true, dtLine) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-593ee4af | this.Load 외 4 | SCP0003_ProductionCapacity.cs:222 |  | GRID_INIT | siObj.AddTextColumn | ("Project", DefColumns.PROJECT_ID, FPMerge.Restricted, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-55ee6e0b | this.Load 외 4 | SCP0003_ProductionCapacity.cs:223 |  | GRID_INIT | siObj.AddTextColumn | ("Model", DefColumns.ITEM_ID, FPMerge.Always, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71324362 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:224 |  | GRID_INIT | siObj.AddTextColumn | ("Sort", DefColumns.USER_SORT_ORDER_NO, FPMerge.Always, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8569ead | this.Load 외 4 | SCP0003_ProductionCapacity.cs:225 |  | GRID_INIT | siObj.AddTextColumn | ("Measure", DefColumns.MEASURE, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d338acb4 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:228 |  | GRID_INIT | siObj.ColumnHeaderSpan | (0, siObj.GetColumnIndex(DefColumns.KEY_IDX), 3, 1, 20, "KEY_IDX", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3dd1a37e | this.Load 외 4 | SCP0003_ProductionCapacity.cs:229 |  | GRID_INIT | siObj.ColumnHeaderSpan | (0, siObj.GetColumnIndex(DefColumns.DIVISION_ID), 3, 1, 20, "Division", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72d03eb9 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:230 |  | GRID_INIT | siObj.ColumnHeaderSpan | (0, siObj.GetColumnIndex(DefColumns.SCM_SITE_ID), 3, 1, 20, "Plant Site", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a1ea24b | this.Load 외 4 | SCP0003_ProductionCapacity.cs:231 |  | GRID_INIT | siObj.ColumnHeaderSpan | (0, siObj.GetColumnIndex(DefColumns.FACTORY_ID), 3, 1, 20, "Building", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4185b7f8 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:232 |  | GRID_INIT | siObj.ColumnHeaderSpan | (0, siObj.GetColumnIndex(DefColumns.OPERATION_ID), 3, 1, 20, "Operation", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1048b198 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:233 |  | GRID_INIT | siObj.ColumnHeaderSpan | (0, siObj.GetColumnIndex(DefColumns.LINE_ID), 3, 1, 20, "Line", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16ba5261 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:234 |  | GRID_INIT | siObj.ColumnHeaderSpan | (0, siObj.GetColumnIndex(DefColumns.PROJECT_ID), 3, 1, 20, "Project", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-996cc2f9 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:235 |  | GRID_INIT | siObj.ColumnHeaderSpan | (0, siObj.GetColumnIndex(DefColumns.ITEM_ID), 3, 1, 20, "Model", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5999ff58 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:236 |  | GRID_INIT | siObj.ColumnHeaderSpan | (0, siObj.GetColumnIndex(DefColumns.MEASURE), 3, 1, 20, "Measure", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eab61b7c | this.Load 외 4 | SCP0003_ProductionCapacity.cs:238 |  | CALL_EXT | siObj.ColumnHeaderSpanRow | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.MEASURE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc374648 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:239 |  | GRID_INIT | siObj.Freeze | (0, siObj.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8c5178a3 | this.Load 외 4 | SCP0003_ProductionCapacity.cs:244 |  | GRID_INIT | siObj.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6479a9bf | this.Load 외 4 | SCP0003_ProductionCapacity.cs:245 |  | GRID_INIT | siObj.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0003_ProductionCapacity.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d267a51 | dsdm.Changed | SCP0003_ProductionCapacity.cs:910 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtSub) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |

