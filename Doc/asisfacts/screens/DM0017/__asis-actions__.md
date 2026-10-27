# AS-IS 액션 대조표 — DM0017

> 원천: `Doc/asisfacts/screens/DM0017/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 95행 · 메서드 15 · 종류 GRID_INIT 28 · DATA_OP 21 · ENDPOINT 13 · FLAG 8 · RETURN 6 · UI_PROP 4 · GRID_LOCK 3 · CALL_EXT 3 · UI_MISC 2 · LIST_REBIND 2 · MESSAGE 2 · GRID_BIND 1 · GRID_SET 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 3


## DM0017_ShipmentRequest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddf74268 | this.Load | DM0017_ShipmentRequest.cs:147 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2daa8c4b | this.Load | DM0017_ShipmentRequest.cs:148 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-88711d75 | this.Load | DM0017_ShipmentRequest.cs:149 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0017_ShipmentRequest.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dc7b2f9 | DeleteButton | DM0017_ShipmentRequest.cs:274 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0017_ShipmentRequest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aefff093 | Dispose | DM0017_ShipmentRequest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0017_ShipmentRequest.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-110c7cf9 | EditButton | DM0017_ShipmentRequest.cs:281 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eaaf646d | EditButton | DM0017_ShipmentRequest.cs:282 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1cc0937a | EditButton | DM0017_ShipmentRequest.cs:284 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.Column1), siMain.GetColumnIndex(DefColumns.Column3), tru… | 그리드 편집 잠금/해제 |  |  |  |

## DM0017_ShipmentRequest.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75f939a7 | FindButton 외 1 | DM0017_ShipmentRequest.cs:308 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DM.Shipment.WSL/FoxDataServic… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f1e3c916 | FindButton 외 1 | DM0017_ShipmentRequest.cs:312 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA") ⇒ DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-ed8620cf | FindButton 외 1 | DM0017_ShipmentRequest.cs:313 | lambda | DATA_OP | request.Parameters["Search"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c75a569c | FindButton 외 1 | DM0017_ShipmentRequest.cs:314 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5ffc34a | FindButton 외 1 | DM0017_ShipmentRequest.cs:316 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-bb9b5a5d | FindButton 외 1 | DM0017_ShipmentRequest.cs:320 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-35050961 | FindButton 외 1 | DM0017_ShipmentRequest.cs:321 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9994436c | FindButton 외 1 | DM0017_ShipmentRequest.cs:324 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-059fcc15 | FindButton 외 1 | DM0017_ShipmentRequest.cs:329 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-86e64e4c | FindButton 외 1 | DM0017_ShipmentRequest.cs:329 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-01519001 | FindButton 외 1 | DM0017_ShipmentRequest.cs:330 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0017_ShipmentRequest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e734ad7e | this.Load | DM0017_ShipmentRequest.cs:115 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-98c4dbcd | this.Load | DM0017_ShipmentRequest.cs:117 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0017_ShipmentRequest.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3f3e8de | this.Load | DM0017_ShipmentRequest.cs:474 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-c298b3f6 | this.Load | DM0017_ShipmentRequest.cs:475 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b830cc4 | this.Load | DM0017_ShipmentRequest.cs:478 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0017_ShipmentRequest.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21e59276 | this.Load | DM0017_ShipmentRequest.cs:446 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-f50316e8 | this.Load | DM0017_ShipmentRequest.cs:448 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-51b9ce63 | this.Load | DM0017_ShipmentRequest.cs:451 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0017_ShipmentRequest.GetScmSitebyDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55a51d5c | this.Load | DM0017_ShipmentRequest.cs:460 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7afa1f72 | this.Load | DM0017_ShipmentRequest.cs:461 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cf0ee6b1 | this.Load | DM0017_ShipmentRequest.cs:462 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-674ed594 | this.Load | DM0017_ShipmentRequest.cs:465 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0017_ShipmentRequest.GetSpdTitle

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6a654cf | this.Load 외 2 | DM0017_ShipmentRequest.cs:251 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0007_GET_SPREAD_TITLE") ⇒ DM.DM0007_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-05175155 | this.Load 외 2 | DM0017_ShipmentRequest.cs:252 |  | DATA_OP | request.Parameters["p_plan_week"] | sPlanWeek | 행/컬럼 값 대입 |  |  |  |
| AC-73be54a2 | this.Load 외 2 | DM0017_ShipmentRequest.cs:254 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-9adcf807 | this.Load 외 2 | DM0017_ShipmentRequest.cs:254 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DM0017_ShipmentRequest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-880da3a5 | this.Load | DM0017_ShipmentRequest.cs:129 |  | FLAG | dtDivision | GetDivision() | 화면 필드/플래그 변경 |  |  |  |
| AC-d61faca2 | this.Load | DM0017_ShipmentRequest.cs:130 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5a590451 | this.Load | DM0017_ShipmentRequest.cs:132 |  | FLAG | dtScmSite | GetScmSitebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-464be47f | this.Load | DM0017_ShipmentRequest.cs:133 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-56110f7f | this.Load | DM0017_ShipmentRequest.cs:135 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |

## DM0017_ShipmentRequest.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11e40123 | this.Load 외 2 | DM0017_ShipmentRequest.cs:169 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-981b1a97 | this.Load 외 2 | DM0017_ShipmentRequest.cs:171 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-40353152 | this.Load 외 2 | DM0017_ShipmentRequest.cs:172 |  | GRID_INIT | siMain.AddTextColumn | ("Division", DefColumns.Column1, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82ca3976 | this.Load 외 2 | DM0017_ShipmentRequest.cs:173 |  | GRID_INIT | siMain.AddTextColumn | ("Biz. Type", DefColumns.Column2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90f14ea1 | this.Load 외 2 | DM0017_ShipmentRequest.cs:174 |  | GRID_INIT | siMain.AddTextColumn | ("Project", DefColumns.Column3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-62482ed1 | this.Load 외 2 | DM0017_ShipmentRequest.cs:175 |  | GRID_INIT | siMain.AddTextColumn | ("Model", "4", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-54a6aff7 | this.Load 외 2 | DM0017_ShipmentRequest.cs:176 |  | GRID_INIT | siMain.AddTextColumn | ("Nick Name", "5", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17029a1f | this.Load 외 2 | DM0017_ShipmentRequest.cs:177 |  | GRID_INIT | siMain.AddTextColumn | ("Sales Site", "6", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ed17493 | this.Load 외 2 | DM0017_ShipmentRequest.cs:178 |  | GRID_INIT | siMain.AddTextColumn | ("Sold to Party", "7", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e089015b | this.Load 외 2 | DM0017_ShipmentRequest.cs:179 |  | GRID_INIT | siMain.AddTextColumn | ("Ship to Party", "8", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a3bc841 | this.Load 외 2 | DM0017_ShipmentRequest.cs:180 |  | GRID_INIT | siMain.AddTextColumn | ("Ship. Type", "9", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90ea9b47 | this.Load 외 2 | DM0017_ShipmentRequest.cs:181 |  | GRID_INIT | siMain.AddTextColumn | ("Do/Ex", "10", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a366274 | this.Load 외 2 | DM0017_ShipmentRequest.cs:182 |  | GRID_INIT | siMain.AddTextColumn | ("Prod. Site", "11", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3613d1ab | this.Load 외 2 | DM0017_ShipmentRequest.cs:183 |  | GRID_INIT | siMain.AddTextColumn | ("Trans. Mode", "12", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ddee5485 | this.Load 외 2 | DM0017_ShipmentRequest.cs:184 |  | GRID_INIT | siMain.AddTextColumn | ("L/T(Day)", "13", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eaecef68 | this.Load 외 2 | DM0017_ShipmentRequest.cs:185 |  | GRID_INIT | siMain.AddTextColumn | ("BOH", "14", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27c42902 | this.Load 외 2 | DM0017_ShipmentRequest.cs:186 |  | GRID_INIT | siMain.AddTextColumn | ("Measure", "15", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39154e06 | this.Load 외 2 | DM0017_ShipmentRequest.cs:231 | foreach (DataRow dr in dtTitle.Rows) | GRID_INIT | siMain.AddComboColumn | (sColumnLabel, sColumnName, FPMerge.Restricted, 40, true, dtYesOrNo, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c399090 | this.Load 외 2 | DM0017_ShipmentRequest.cs:235 | foreach (DataRow dr in dtTitle.Rows) ▸ if (sSpanLabelName != sSmallLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b0a0f1d | this.Load 외 2 | DM0017_ShipmentRequest.cs:243 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72731eb7 | this.Load 외 2 | DM0017_ShipmentRequest.cs:245 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Column3)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0017_ShipmentRequest.InitSpread0

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6329f14 | (진입점 미연결) | DM0017_ShipmentRequest.cs:156 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.PlanWeek, DefColumns.PlanWeek, FPMerge.Restricted, 60, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad106587 | (진입점 미연결) | DM0017_ShipmentRequest.cs:157 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionId, DefColumns.DivisionId, FPMerge.Restricted, 60, true, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae429fdb | (진입점 미연결) | DM0017_ShipmentRequest.cs:158 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.PlanWeek), 2, 1, 30, DefColumnsLabel.PlanWeek, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-505b731c | (진입점 미연결) | DM0017_ShipmentRequest.cs:159 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DivisionId), 2, 1, 30, DefColumnsLabel.DivisionId, FP… | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0017_ShipmentRequest.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a06a78d | InsertButton | DM0017_ShipmentRequest.cs:421 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f2fb1e6 | InsertButton | DM0017_ShipmentRequest.cs:424 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column1, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-247be419 | InsertButton | DM0017_ShipmentRequest.cs:425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column2, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2ee6f5b | InsertButton | DM0017_ShipmentRequest.cs:426 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column3, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-6aaeeacb | InsertButton | DM0017_ShipmentRequest.cs:428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## DM0017_ShipmentRequest.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5416f1dc | SaveButton | DM0017_ShipmentRequest.cs:340 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-91535bfd | SaveButton | DM0017_ShipmentRequest.cs:349 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-600f8bb7 | SaveButton | DM0017_ShipmentRequest.cs:351 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-6eb29d64 | SaveButton | DM0017_ShipmentRequest.cs:352 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column1] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-703991e2 | SaveButton | DM0017_ShipmentRequest.cs:353 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column2] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c4e33f49 | SaveButton | DM0017_ShipmentRequest.cs:354 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column3] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a3ebce3 | SaveButton | DM0017_ShipmentRequest.cs:355 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-802b1bf8 | SaveButton | DM0017_ShipmentRequest.cs:357 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-10bab200 | SaveButton | DM0017_ShipmentRequest.cs:360 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e6146d12 | SaveButton | DM0017_ShipmentRequest.cs:363 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.Column1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1e222c0 | SaveButton | DM0017_ShipmentRequest.cs:364 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.Column2) | 데이터 객체 조작/조회 |  |  |  |
| AC-73fda068 | SaveButton | DM0017_ShipmentRequest.cs:375 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-49129ede | SaveButton | DM0017_ShipmentRequest.cs:376 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46efa4ea | SaveButton | DM0017_ShipmentRequest.cs:385 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f09f2155 | SaveButton | DM0017_ShipmentRequest.cs:386 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-99a12844 | SaveButton | DM0017_ShipmentRequest.cs:387 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | DATA_OP | saveDS.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b43d8665 | SaveButton | DM0017_ShipmentRequest.cs:391 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-62c463fb | SaveButton | DM0017_ShipmentRequest.cs:392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-088c9ac5 | SaveButton | DM0017_ShipmentRequest.cs:393 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-cda78787 | SaveButton | DM0017_ShipmentRequest.cs:395 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-5d12c5a5 | SaveButton | DM0017_ShipmentRequest.cs:395 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2fb0124b | SaveButton | DM0017_ShipmentRequest.cs:399 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-289da95f | SaveButton | DM0017_ShipmentRequest.cs:403 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-756f1f85 | SaveButton | DM0017_ShipmentRequest.cs:403 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-67b7437f | SaveButton | DM0017_ShipmentRequest.cs:408 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

