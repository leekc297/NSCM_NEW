# AS-IS 액션 대조표 — SSP0300

> 원천: `Doc/asisfacts/screens/SSP0300/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 66행 · 메서드 6 · 종류 GRID_INIT 28 · FLAG 12 · DATA_OP 8 · ENDPOINT 6 · UI_MISC 4 · UI_PROP 2 · RETURN 2 · GRID_BIND 2 · GRID_LOCK 2 · ⚠ 의미 확인 필요 0


## SSP0300_OrderDetailPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5a9c1d1 | this.Load | SSP0300_OrderDetailPopup.cs:122 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-aea42530 | this.Load | SSP0300_OrderDetailPopup.cs:123 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8aee2065 | this.Load | SSP0300_OrderDetailPopup.cs:124 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f9c11ee | this.Load | SSP0300_OrderDetailPopup.cs:122 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6b3378a5 | this.Load | SSP0300_OrderDetailPopup.cs:123 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9dd05983 | this.Load | SSP0300_OrderDetailPopup.cs:124 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0300_OrderDetailPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f71e90f1 | this.Load | SSP0300_OrderDetailPopup.cs:117 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-b599a06b | this.Load | SSP0300_OrderDetailPopup.cs:117 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0300_OrderDetailPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a74b0b3d | Dispose | SSP0300_OrderDetailPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-d92223fa | Dispose | SSP0300_OrderDetailPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0300_OrderDetailPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f37db8fd | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:174 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f35cfaf3 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:178 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0300_GET_ORDER_DETAIL") ⇒ SSP.SSP0300_GET_ORDER_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-59d311b9 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:180 | lambda | DATA_OP | request.Parameters["P_DIVISION_ID"] | strDivision_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4addd4b | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:181 | lambda | DATA_OP | request.Parameters["P_ERP_SO_NO"] | strSo_No | 행/컬럼 값 대입 |  |  |  |
| AC-20e91381 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:182 | lambda | DATA_OP | request.Parameters["P_CONFIRM_ID"] | strConfirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-e462e827 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:183 | lambda | DATA_OP | request.Parameters["P_ITEM_ID"] | strItem_id | 행/컬럼 값 대입 |  |  |  |
| AC-13ea7ccb | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:185 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e3f665c | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:187 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0d20bce0 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:191 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-62099860 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:192 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae50b190 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:195 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6b2182dd | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:174 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d46951d5 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:178 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0300_GET_ORDER_DETAIL") ⇒ SSP.SSP0300_GET_ORDER_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-fbba9fd0 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:180 | lambda | DATA_OP | request.Parameters["P_DIVISION_ID"] | strDivision_id | 행/컬럼 값 대입 |  |  |  |
| AC-9d940dbf | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:181 | lambda | DATA_OP | request.Parameters["P_ERP_SO_NO"] | strSo_No | 행/컬럼 값 대입 |  |  |  |
| AC-fe3a1579 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:182 | lambda | DATA_OP | request.Parameters["P_CONFIRM_ID"] | strConfirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-e5d398bf | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:183 | lambda | DATA_OP | request.Parameters["P_ITEM_ID"] | strItem_id | 행/컬럼 값 대입 |  |  |  |
| AC-48041b3c | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:185 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-76d083f6 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:187 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-bfddf885 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:191 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-76a57a72 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:192 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e691775b | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:195 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0300_OrderDetailPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebc04aeb | this.Load | SSP0300_OrderDetailPopup.cs:87 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e9d75bfa | this.Load | SSP0300_OrderDetailPopup.cs:100 |  | FLAG | strDivision_id | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-0055b93a | this.Load | SSP0300_OrderDetailPopup.cs:101 |  | FLAG | strConfirm_id | _ConfirmId | 화면 필드/플래그 변경 |  |  |  |
| AC-13e22e35 | this.Load | SSP0300_OrderDetailPopup.cs:102 |  | FLAG | strSo_No | _ErpSoNo | 화면 필드/플래그 변경 |  |  |  |
| AC-c4e82639 | this.Load | SSP0300_OrderDetailPopup.cs:103 |  | FLAG | strItem_id | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-86502c4e | this.Load | SSP0300_OrderDetailPopup.cs:104 |  | FLAG | strElectrode_yn | _electrode_yn | 화면 필드/플래그 변경 |  |  |  |
| AC-2d68f047 | this.Load | SSP0300_OrderDetailPopup.cs:87 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b56e2b36 | this.Load | SSP0300_OrderDetailPopup.cs:100 |  | FLAG | strDivision_id | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-780f4ad5 | this.Load | SSP0300_OrderDetailPopup.cs:101 |  | FLAG | strConfirm_id | _ConfirmId | 화면 필드/플래그 변경 |  |  |  |
| AC-84686c9f | this.Load | SSP0300_OrderDetailPopup.cs:102 |  | FLAG | strSo_No | _ErpSoNo | 화면 필드/플래그 변경 |  |  |  |
| AC-b9a0c9d7 | this.Load | SSP0300_OrderDetailPopup.cs:103 |  | FLAG | strItem_id | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-c387770d | this.Load | SSP0300_OrderDetailPopup.cs:104 |  | FLAG | strElectrode_yn | _electrode_yn | 화면 필드/플래그 변경 |  |  |  |

## SSP0300_OrderDetailPopup.InitSpread

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83305dc8 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:131 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-167e37c4 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:135 | if (strElectrode_yn == "Y") | GRID_INIT | siMain.AddTextColumn | ("PO NO.", DefColumns.SO_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90dc7d5b | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:136 | if (strElectrode_yn == "Y") | GRID_INIT | siMain.AddTextColumn | ("PO Item No.", DefColumns.SO_ITEM_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8c927ff4 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:137 | if (strElectrode_yn == "Y") | GRID_INIT | siMain.AddNumColumn | ("PO Item Qty", DefColumns.SO_ITEM_QTY, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a20118a0 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:141 | else of (strElectrode_yn == "Y") | GRID_INIT | siMain.AddTextColumn | ("SO NO.", DefColumns.SO_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6acbce36 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:142 | else of (strElectrode_yn == "Y") | GRID_INIT | siMain.AddTextColumn | ("SO Item No.", DefColumns.SO_ITEM_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0a211b7 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:143 | else of (strElectrode_yn == "Y") | GRID_INIT | siMain.AddNumColumn | ("SO Item Qty", DefColumns.SO_ITEM_QTY, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9ff4be12 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:147 |  | GRID_INIT | siMain.AddTextColumn | ("DO NO.", DefColumns.DO_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-110cd240 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:148 |  | GRID_INIT | siMain.AddTextColumn | ("DO Item No.", DefColumns.DO_ITEM_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e2a5479 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:149 |  | GRID_INIT | siMain.AddNumColumn | ("DO Item Qty.", DefColumns.DO_ITEM_QTY, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a610d28 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:150 |  | GRID_INIT | siMain.AddTextColumn | ("Confirm ID", DefColumns.CONFIRM_ID, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da4cb800 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:131 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a0beafd9 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:135 | if (strElectrode_yn == "Y") | GRID_INIT | siMain.AddTextColumn | ("PO NO.", DefColumns.SO_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88458b64 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:136 | if (strElectrode_yn == "Y") | GRID_INIT | siMain.AddTextColumn | ("PO Item No.", DefColumns.SO_ITEM_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79229728 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:137 | if (strElectrode_yn == "Y") | GRID_INIT | siMain.AddNumColumn | ("PO Item Qty", DefColumns.SO_ITEM_QTY, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aba68542 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:141 | else of (strElectrode_yn == "Y") | GRID_INIT | siMain.AddTextColumn | ("SO NO.", DefColumns.SO_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5caa7baa | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:142 | else of (strElectrode_yn == "Y") | GRID_INIT | siMain.AddTextColumn | ("SO Item No.", DefColumns.SO_ITEM_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb876880 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:143 | else of (strElectrode_yn == "Y") | GRID_INIT | siMain.AddNumColumn | ("SO Item Qty", DefColumns.SO_ITEM_QTY, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afb4e0a6 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:147 |  | GRID_INIT | siMain.AddTextColumn | ("DO NO.", DefColumns.DO_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c82a7dc | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:148 |  | GRID_INIT | siMain.AddTextColumn | ("DO Item No.", DefColumns.DO_ITEM_NO, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c844b8b8 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:149 |  | GRID_INIT | siMain.AddNumColumn | ("DO Item Qty.", DefColumns.DO_ITEM_QTY, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1a5f7b8 | this.Load 외 1 | SSP0300_OrderDetailPopup.cs:150 |  | GRID_INIT | siMain.AddTextColumn | ("Confirm ID", DefColumns.CONFIRM_ID, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |

