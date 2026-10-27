# AS-IS 액션 대조표 — GSCM_GROUPUSERINFO

> 원천: `Doc/asisfacts/screens/GSCM_GROUPUSERINFO/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 347행 · 메서드 18 · 종류 DATA_OP 121 · GRID_INIT 44 · UI_PROP 37 · ENDPOINT 21 · RETURN 20 · GRID_SET 20 · FLAG 19 · CALL_EXT 14 · GRID_LOCK 13 · MESSAGE 11 · POPUP 11 · UI_MISC 5 · GRID_BIND 5 · STATE_RESET 4 · STATE 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 14


## GroupUserInfo.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37b0271a | this.Load | GroupUserInfo.cs:125 |  | GRID_INIT | AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-19cd8a7a | this.Load | GroupUserInfo.cs:126 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2b029c36 | this.Load | GroupUserInfo.cs:129 |  | GRID_INIT | AddSheet | (spdUserInfo, SpdSheet.shtUserInfo, SpdSheet.shtUserInfo, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9882540c | this.Load | GroupUserInfo.cs:130 |  | FLAG | siUserInfo | GetSheetInfo(spdUserInfo.Name, spdUserInfo.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e38f8a1e | this.Load | GroupUserInfo.cs:133 |  | GRID_INIT | AddSheet | (spdDivision, SpdSheet.shtDivision, SpdSheet.shtDivision, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6d58b1e8 | this.Load | GroupUserInfo.cs:134 |  | FLAG | siDivision | GetSheetInfo(spdDivision.Name, spdDivision.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a263037f | this.Load | GroupUserInfo.cs:145 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## GroupUserInfo.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e98c8963 | this.Load | GroupUserInfo.cs:120 |  | STATE | this.usrConditionPanel1.Visible | false | 컨트롤 상태 Visible |  |  |  |

## GroupUserInfo.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a00f8be | DeleteButton | GroupUserInfo.cs:237 | if (this.fps != null) ▸ switch (fps.Name) case "spdUserInfo": | DATA_OP | siUserInfo.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aed4efb5 | DeleteButton | GroupUserInfo.cs:241 | if (this.fps != null) ▸ switch (fps.Name) case "spdDivision": | DATA_OP | siDivision.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ba7badd3 | DeleteButton | GroupUserInfo.cs:245 | if (this.fps != null) ▸ switch (fps.Name) case "spdPlant": | DATA_OP | siPlant.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-551fa7ea | DeleteButton | GroupUserInfo.cs:249 | if (this.fps != null) ▸ switch (fps.Name) case "spdCustomer": | DATA_OP | siCustomer.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## GroupUserInfo.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-388144a7 | Dispose | GroupUserInfo.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## GroupUserInfo.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-879fa821 | EditButton | GroupUserInfo.cs:269 | if (this.fps != null) ▸ if (fps.Name == "spdUserInfo") | FLAG | siUserInfo | GetSheetInfo(spdUserInfo.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c04e1333 | EditButton | GroupUserInfo.cs:270 | if (this.fps != null) ▸ if (fps.Name == "spdUserInfo") | GRID_LOCK | siUserInfo.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-0e15591d | EditButton | GroupUserInfo.cs:272 | if (this.fps != null) ▸ if (fps.Name == "spdUserInfo") | GRID_LOCK | siUserInfo.LockColumn | (0, siUserInfo.GetColumnIndex(DefColumns.Dept_Name), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8b33aa40 | EditButton | GroupUserInfo.cs:277 | if (this.fps != null) ▸ if (fps.Name == "spdDivision") | FLAG | siDivision | GetSheetInfo(spdDivision.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d469034f | EditButton | GroupUserInfo.cs:278 | if (this.fps != null) ▸ if (fps.Name == "spdDivision") | GRID_LOCK | siDivision.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4a1253cb | EditButton | GroupUserInfo.cs:280 | if (this.fps != null) ▸ if (fps.Name == "spdDivision") ▸ if (groupID == "JV Planner") | GRID_LOCK | siDivision.LockColumn | (siDivision.GetColumnIndex(DefColumns.JV_Plant), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f180a78c | EditButton | GroupUserInfo.cs:285 | if (this.fps != null) ▸ if (fps.Name == "spdPlant") | GRID_LOCK | siPlant.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-66b5c3de | EditButton | GroupUserInfo.cs:286 | if (this.fps != null) ▸ if (fps.Name == "spdPlant") | GRID_LOCK | siPlant.LockColumn | (0, siPlant.GetColumnIndex(DefColumns.Code), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b66f71ac | EditButton | GroupUserInfo.cs:291 | if (this.fps != null) ▸ if (fps.Name == "spdCustomer") | GRID_LOCK | siCustomer.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5e07ab9f | EditButton | GroupUserInfo.cs:292 | if (this.fps != null) ▸ if (fps.Name == "spdCustomer") | GRID_LOCK | siCustomer.LockColumn | (0, siCustomer.GetColumnIndex(DefColumns.Code), true) | 그리드 편집 잠금/해제 |  |  |  |

## GroupUserInfo.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8389975f | this.Load 외 1 | GroupUserInfo.cs:313 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6ffdbe4f | this.Load 외 1 | GroupUserInfo.cs:317 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetGroupInfoList") ⇒ SystemManager.UP_FX_GetGroupInfoList | 엔드포인트 요청 생성 |  |  |  |
| AC-5d5f6596 | this.Load 외 1 | GroupUserInfo.cs:318 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-27164100 | this.Load 외 1 | GroupUserInfo.cs:320 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-36f19487 | this.Load 외 1 | GroupUserInfo.cs:324 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-39fe0bb4 | this.Load 외 1 | GroupUserInfo.cs:325 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bfe45be8 | this.Load 외 1 | GroupUserInfo.cs:328 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bde08756 | this.Load 외 1 | GroupUserInfo.cs:331 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-66dceb4d | this.Load 외 1 | GroupUserInfo.cs:340 |  | FLAG | groupID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-7daeb023 | this.Load 외 1 | GroupUserInfo.cs:341 |  | FLAG | userID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-106d5f1b | this.Load 외 1 | GroupUserInfo.cs:342 |  | FLAG | divisionID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## GroupUserInfo.FindData_Customer

진입점: SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == SpdSheet.shtCustomer)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-843cbb0c | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:465 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-2d0c9392 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:466 |  | DATA_OP | request.Parameters["GroupID"] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-6bdd1c06 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:467 |  | DATA_OP | request.Parameters["UserID"] | userID | 행/컬럼 값 대입 |  |  |  |
| AC-122c09d8 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:468 |  | DATA_OP | request.Parameters["AuthType"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-d6062bb0 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:469 |  | DATA_OP | request.Parameters["DivisionID"] | divisionID | 행/컬럼 값 대입 |  |  |  |
| AC-0e46be85 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:470 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-770a825f | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:475 |  | GRID_BIND | siCustomer.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3dd7c5b9 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:476 |  | GRID_LOCK | siCustomer.LockColumn | (0, siCustomer.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d0fbd44 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:479 |  | GRID_INIT | siCustomer.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5594e3df | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:482 |  | FLAG | saveDSCustomer | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-5ee03237 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:482 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b2e20ac3 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:483 |  | DATA_OP | saveDSCustomer.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-25165a85 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:484 |  | DATA_OP | saveDSCustomer.Tables[0].Columns.Add | ("GroupID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6213aa8d | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:485 |  | DATA_OP | saveDSCustomer.Tables[0].Columns.Add | ("UserID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef7402c2 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:486 |  | DATA_OP | saveDSCustomer.Tables[0].Columns.Add | ("AuthType", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8eb29e2a | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:487 |  | DATA_OP | saveDSCustomer.Tables[0].Columns.Add | ("PrntCode", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-587d37a1 | SaveButton [if (fps.Name == "spdCustomer") ▸ if (siCustomer … | GroupUserInfo.cs:488 |  | DATA_OP | saveDSCustomer.Tables[0].Columns.Add | ("RegtUserID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## GroupUserInfo.FindData_Division

진입점: this.spdUserInfo.CellDoubleClick / SaveButton [if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == SpdSheet.shtDivision)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd7163e0 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:384 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dc1f79b9 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:388 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-e1871ac8 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:389 | lambda | DATA_OP | request.Parameters["GroupID"] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-8ed6e0bc | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:390 | lambda | DATA_OP | request.Parameters["UserID"] | userID | 행/컬럼 값 대입 |  |  |  |
| AC-36adab70 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:391 | lambda | DATA_OP | request.Parameters["AuthType"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-561f6ee0 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:392 | lambda ▸ if (groupID == "JV Planner") | DATA_OP | request.Parameters["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-54d0b0ce | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:393 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-f58b2533 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:394 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-89d53b60 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:396 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9ce79dfe | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:400 |  | GRID_BIND | siDivision.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-23ff84b2 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:401 |  | GRID_LOCK | siDivision.LockColumn | (0, siDivision.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4b3db2f6 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:407 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-69b6534f | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:410 |  | GRID_INIT | siDivision.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-81224ecc | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:413 |  | FLAG | saveDSDivision | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-5b4a56ab | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:413 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ca591ea2 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:414 |  | DATA_OP | saveDSDivision.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-62166535 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:415 |  | DATA_OP | saveDSDivision.Tables[0].Columns.Add | ("GroupID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5b48a52 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:416 |  | DATA_OP | saveDSDivision.Tables[0].Columns.Add | ("UserID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e221e31 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:417 |  | DATA_OP | saveDSDivision.Tables[0].Columns.Add | ("AuthType", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-79656b18 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:418 |  | DATA_OP | saveDSDivision.Tables[0].Columns.Add | ("PrntCode", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0559acf5 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:419 |  | DATA_OP | saveDSDivision.Tables[0].Columns.Add | ("RegtUserID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7386e723 | this.spdUserInfo.CellDoubleClick 외 1 | GroupUserInfo.cs:420 |  | DATA_OP | saveDSDivision.Tables[0].Columns.Add | ("JV_PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## GroupUserInfo.FindData_Plant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f15e651 | (진입점 미연결) | GroupUserInfo.cs:431 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-073b237c | (진입점 미연결) | GroupUserInfo.cs:432 |  | DATA_OP | request.Parameters["GroupID"] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-8281d8b1 | (진입점 미연결) | GroupUserInfo.cs:433 |  | DATA_OP | request.Parameters["UserID"] | userID | 행/컬럼 값 대입 |  |  |  |
| AC-26670bfa | (진입점 미연결) | GroupUserInfo.cs:434 |  | DATA_OP | request.Parameters["AuthType"] | "P" | 행/컬럼 값 대입 |  |  |  |
| AC-fc73d78d | (진입점 미연결) | GroupUserInfo.cs:435 |  | DATA_OP | request.Parameters["DivisionID"] | divisionID | 행/컬럼 값 대입 |  |  |  |
| AC-66eef85b | (진입점 미연결) | GroupUserInfo.cs:436 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9dca8b6c | (진입점 미연결) | GroupUserInfo.cs:441 |  | GRID_BIND | siPlant.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a1a18c42 | (진입점 미연결) | GroupUserInfo.cs:442 |  | GRID_LOCK | siPlant.LockColumn | (0, siPlant.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc0a2f02 | (진입점 미연결) | GroupUserInfo.cs:445 |  | GRID_INIT | siPlant.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-07a9acf2 | (진입점 미연결) | GroupUserInfo.cs:448 |  | FLAG | saveDSPlant | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-548b611a | (진입점 미연결) | GroupUserInfo.cs:448 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6d75eb26 | (진입점 미연결) | GroupUserInfo.cs:449 |  | DATA_OP | saveDSPlant.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8a1090e | (진입점 미연결) | GroupUserInfo.cs:450 |  | DATA_OP | saveDSPlant.Tables[0].Columns.Add | ("GroupID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e862581 | (진입점 미연결) | GroupUserInfo.cs:451 |  | DATA_OP | saveDSPlant.Tables[0].Columns.Add | ("UserID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-01fcbb8e | (진입점 미연결) | GroupUserInfo.cs:452 |  | DATA_OP | saveDSPlant.Tables[0].Columns.Add | ("AuthType", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-abd37aad | (진입점 미연결) | GroupUserInfo.cs:453 |  | DATA_OP | saveDSPlant.Tables[0].Columns.Add | ("PrntCode", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ecd714c | (진입점 미연결) | GroupUserInfo.cs:454 |  | DATA_OP | saveDSPlant.Tables[0].Columns.Add | ("RegtUserID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## GroupUserInfo.FindData_User

진입점: this.spdMain.CellDoubleClick / SaveButton [if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == SpdSheet.shtUserInfo)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf9986e0 | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:351 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-122d1750 | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:355 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupInfoList") ⇒ SystemManager.UP_FX_GetUserGroupInfoList | 엔드포인트 요청 생성 |  |  |  |
| AC-a2eebbea | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:356 | lambda | DATA_OP | request.Parameters["GroupID"] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-ded41c11 | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:357 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ffee4b50 | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:359 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-47fde98d | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:363 |  | GRID_BIND | siUserInfo.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-24dd2eb4 | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:364 |  | GRID_LOCK | siUserInfo.LockColumn | (0, siUserInfo.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7f1fb7f | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:367 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c8c01ead | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:370 |  | GRID_INIT | siUserInfo.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b486a778 | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:373 |  | FLAG | saveDSUser | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-376b6423 | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:373 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f7270bc6 | this.spdMain.CellDoubleClick 외 1 | GroupUserInfo.cs:374 |  | DATA_OP | saveDSUser.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## GroupUserInfo.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fac26791 | this.Load | GroupUserInfo.cs:106 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## GroupUserInfo.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (groupID == "JV Planner")] / this.spdUserInfo.CellDoubleClick [if (GroupID == "JV Planner")] / FindButton / SaveButton [if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == SpdSheet.shtUserInfo)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e91a1ba | this.Load 외 5 | GroupUserInfo.cs:152 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.InitSheet | (spread.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-94c55ebb | this.Load 외 5 | GroupUserInfo.cs:154 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4091c461 | this.Load 외 5 | GroupUserInfo.cs:155 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddTextColumn | ("GroupID", DefColumns.GroupID, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53c6f1ba | this.Load 외 5 | GroupUserInfo.cs:156 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddTextColumn | ("GrpName", DefColumns.GrpName, FPMerge.None, 170, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-041bf6a1 | this.Load 외 5 | GroupUserInfo.cs:157 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddComboColumn | ("UseYN", DefColumns.UseYN, FPMerge.None, 60, false, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d2ca2b3 | this.Load 외 5 | GroupUserInfo.cs:159 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.Freeze | (0, siMain.GetColumnIndex(DefColumns.GroupID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fa2aa01e | this.Load 외 5 | GroupUserInfo.cs:161 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-86532798 | this.Load 외 5 | GroupUserInfo.cs:166 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.InitSheet | (spread.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-63b34f57 | this.Load 외 5 | GroupUserInfo.cs:168 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-af2ad275 | this.Load 외 5 | GroupUserInfo.cs:169 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.AddTextColumn | ("GroupID*", DefColumns.GroupID, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bb112f2 | this.Load 외 5 | GroupUserInfo.cs:170 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.AddTextColumn | ("UserID*", DefColumns.UserID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a418267 | this.Load 외 5 | GroupUserInfo.cs:171 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.AddTextColumn | ("UserName*", DefColumns.UserName, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f9fd6bb | this.Load 외 5 | GroupUserInfo.cs:172 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.AddTextColumn | ("EnglishName", DefColumns.UserName_E, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b618173f | this.Load 외 5 | GroupUserInfo.cs:173 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.AddTextColumn | ("Email", DefColumns.Email, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb432020 | this.Load 외 5 | GroupUserInfo.cs:174 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.AddTextColumn | ("Dept_ID*", DefColumns.Dept_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-838f0f7f | this.Load 외 5 | GroupUserInfo.cs:175 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.AddTextColumn | ("Dept_Name*", DefColumns.Dept_Name, FPMerge.None, 220, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c773b947 | this.Load 외 5 | GroupUserInfo.cs:176 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.AddComboColumn | ("UseYN", DefColumns.UseYN, FPMerge.None, 60, false, Data.Common(Data.Type.YesOrNo), FPHAl… ⇒ biz:CommonData.YesOrNo | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-797348c4 | this.Load 외 5 | GroupUserInfo.cs:176 | if (sheetName == SpdSheet.shtUserInfo) | COMBO_DATA | Data.Common | (Data.Type.YesOrNo) ⇒ biz:CommonData.YesOrNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0357d468 | this.Load 외 5 | GroupUserInfo.cs:178 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.Freeze | (0, spread.GetColumnIndex(DefColumns.UserID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9508ab70 | this.Load 외 5 | GroupUserInfo.cs:180 | if (sheetName == SpdSheet.shtUserInfo) | GRID_INIT | spread.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-820e667b | this.Load 외 5 | GroupUserInfo.cs:185 | if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.InitSheet | (spread.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-66b4c625 | this.Load 외 5 | GroupUserInfo.cs:187 | if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-89c37861 | this.Load 외 5 | GroupUserInfo.cs:188 | if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.AddTextColumn | ("Name*", DefColumns.Name, FPMerge.None, 180, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2445c227 | this.Load 외 5 | GroupUserInfo.cs:189 | if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.AddTextColumn | ("Code", DefColumns.Code, FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21e0e1de | this.Load 외 5 | GroupUserInfo.cs:190 | if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.AddTextColumn | ("JV Plant*", DefColumns.JV_Plant, FPMerge.None, 180, JV_Plant_Enable) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06ecbc70 | this.Load 외 5 | GroupUserInfo.cs:192 | if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.Freeze | (0, siDivision.GetColumnIndex(DefColumns.Code)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b19cbaca | this.Load 외 5 | GroupUserInfo.cs:194 | if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8e3cce92 | this.Load 외 5 | GroupUserInfo.cs:199 | if (sheetName == SpdSheet.shtPlant) | GRID_INIT | spread.InitSheet | (spread.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b84b6762 | this.Load 외 5 | GroupUserInfo.cs:201 | if (sheetName == SpdSheet.shtPlant) | GRID_INIT | spread.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3a68c135 | this.Load 외 5 | GroupUserInfo.cs:202 | if (sheetName == SpdSheet.shtPlant) | GRID_INIT | spread.AddTextColumn | ("Name*", DefColumns.Name, FPMerge.None, 400, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1c9e03b | this.Load 외 5 | GroupUserInfo.cs:203 | if (sheetName == SpdSheet.shtPlant) | GRID_INIT | spread.AddTextColumn | ("Code", DefColumns.Code, FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3a099ee | this.Load 외 5 | GroupUserInfo.cs:205 | if (sheetName == SpdSheet.shtPlant) | GRID_INIT | spread.Freeze | (0, siPlant.GetColumnIndex(DefColumns.Code)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-02da987e | this.Load 외 5 | GroupUserInfo.cs:207 | if (sheetName == SpdSheet.shtPlant) | GRID_INIT | spread.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## GroupUserInfo.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abd24243 | InsertButton | GroupUserInfo.cs:773 | if (this.fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d03606c | InsertButton | GroupUserInfo.cs:780 | if (fps.Name == "spdUserInfo") ▸ if (string.IsNullOrEmpty(groupID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Group" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-13436272 | InsertButton | GroupUserInfo.cs:781 | if (fps.Name == "spdUserInfo") ▸ if (string.IsNullOrEmpty(groupID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46ff3fe2 | InsertButton | GroupUserInfo.cs:786 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-52e68326 | InsertButton | GroupUserInfo.cs:788 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) | UI_PROP | popup.Width | 900 | 속성 Width 설정 |  |  |  |
| AC-bb4a1f6b | InsertButton | GroupUserInfo.cs:789 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-3a527de9 | InsertButton | GroupUserInfo.cs:790 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0fdb7a8b | InsertButton | GroupUserInfo.cs:792 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2976b80c | InsertButton | GroupUserInfo.cs:798 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | siUserInfo.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d8e56e07 | InsertButton | GroupUserInfo.cs:801 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.GroupID, groupID) | 데이터 객체 조작/조회 |  |  |  |
| AC-58547143 | InsertButton | GroupUserInfo.cs:802 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.UserID, item.UserID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b5b74df | InsertButton | GroupUserInfo.cs:803 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.UserName, item.UserName) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0d3d094 | InsertButton | GroupUserInfo.cs:804 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.UserName_E, item.UserName_E) | 데이터 객체 조작/조회 |  |  |  |
| AC-faf911bf | InsertButton | GroupUserInfo.cs:805 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.Email, item.Email) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a60d88e | InsertButton | GroupUserInfo.cs:806 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.Dept_ID, item.Dept_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1ad50ae | InsertButton | GroupUserInfo.cs:807 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.Dept_Name, item.Dept_Name) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3dc8791 | InsertButton | GroupUserInfo.cs:808 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.UseYN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-d10f0135 | InsertButton | GroupUserInfo.cs:810 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | GRID_SET | siUserInfo.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-c40ee24b | InsertButton | GroupUserInfo.cs:821 | if (fps.Name == "spdDivision") ▸ if (string.IsNullOrEmpty(groupID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Group" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-754d510e | InsertButton | GroupUserInfo.cs:822 | if (fps.Name == "spdDivision") ▸ if (string.IsNullOrEmpty(groupID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c40435c1 | InsertButton | GroupUserInfo.cs:828 | if (fps.Name == "spdDivision") ▸ if (string.IsNullOrEmpty(userID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "User" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00f9de9f | InsertButton | GroupUserInfo.cs:829 | if (fps.Name == "spdDivision") ▸ if (string.IsNullOrEmpty(userID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-341987ee | InsertButton | GroupUserInfo.cs:834 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) | POPUP | new CommonDataPopup | () | 팝업/폼 생성 |  |  |  |
| AC-41b4a282 | InsertButton | GroupUserInfo.cs:836 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) | UI_PROP | popup.DataType | Data.Type.DIVISION_COD_NAME | 속성 DataType 설정 |  |  |  |
| AC-715eadcf | InsertButton | GroupUserInfo.cs:838 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) | UI_PROP | popup.Width | 480 | 속성 Width 설정 |  |  |  |
| AC-ca0dbfd7 | InsertButton | GroupUserInfo.cs:839 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-0af1bed6 | InsertButton | GroupUserInfo.cs:840 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-915160c0 | InsertButton | GroupUserInfo.cs:842 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-abc54daf | InsertButton | GroupUserInfo.cs:848 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | siDivision.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9dac8bca | InsertButton | GroupUserInfo.cs:851 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.Name, item.Name) | 데이터 객체 조작/조회 |  |  |  |
| AC-454c7249 | InsertButton | GroupUserInfo.cs:852 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.Code, item.Code) | 데이터 객체 조작/조회 |  |  |  |
| AC-31ac7051 | InsertButton | GroupUserInfo.cs:854 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | GRID_SET | siDivision.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-0484c776 | InsertButton | GroupUserInfo.cs:860 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | GRID_INIT | siDivision.VisibleColumns | (JV_Plant_Index, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7d9d611f | InsertButton | GroupUserInfo.cs:871 | if (fps.Name == "spdPlant") ▸ if (string.IsNullOrEmpty(divisionID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f3d6328c | InsertButton | GroupUserInfo.cs:872 | if (fps.Name == "spdPlant") ▸ if (string.IsNullOrEmpty(divisionID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cdbda2a2 | InsertButton | GroupUserInfo.cs:878 | if (fps.Name == "spdPlant") ▸ if (string.IsNullOrEmpty(userID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "User" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-635f50a9 | InsertButton | GroupUserInfo.cs:879 | if (fps.Name == "spdPlant") ▸ if (string.IsNullOrEmpty(userID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-881f216b | InsertButton | GroupUserInfo.cs:884 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) | POPUP | new CommonDataPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fbfa35cc | InsertButton | GroupUserInfo.cs:886 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) | UI_PROP | popup.DataType | Data.Type.Plant | 속성 DataType 설정 |  |  |  |
| AC-c3d0f42c | InsertButton | GroupUserInfo.cs:887 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) | UI_PROP | popup.DivisionID | divisionID | 속성 DivisionID 설정 |  |  |  |
| AC-88e6e6b0 | InsertButton | GroupUserInfo.cs:888 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) | UI_PROP | popup.Width | 480 | 속성 Width 설정 |  |  |  |
| AC-20828f15 | InsertButton | GroupUserInfo.cs:889 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-efa63958 | InsertButton | GroupUserInfo.cs:890 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ca893d1f | InsertButton | GroupUserInfo.cs:892 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-702bc99b | InsertButton | GroupUserInfo.cs:898 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK… | DATA_OP | siPlant.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f3fc719 | InsertButton | GroupUserInfo.cs:901 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK… | DATA_OP | defaultData.Add | (DefColumns.Name, item.Name) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4b11ebe | InsertButton | GroupUserInfo.cs:902 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK… | DATA_OP | defaultData.Add | (DefColumns.Code, item.Code) | 데이터 객체 조작/조회 |  |  |  |
| AC-964bdeaa | InsertButton | GroupUserInfo.cs:904 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK… | GRID_SET | siPlant.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-06cb3403 | InsertButton | GroupUserInfo.cs:915 | if (fps.Name == "spdCustomer") ▸ if (string.IsNullOrEmpty(divisionID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4b05621 | InsertButton | GroupUserInfo.cs:916 | if (fps.Name == "spdCustomer") ▸ if (string.IsNullOrEmpty(divisionID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5a666e7 | InsertButton | GroupUserInfo.cs:922 | if (fps.Name == "spdCustomer") ▸ if (string.IsNullOrEmpty(userID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "User" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d590e4d1 | InsertButton | GroupUserInfo.cs:923 | if (fps.Name == "spdCustomer") ▸ if (string.IsNullOrEmpty(userID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94d19fb5 | InsertButton | GroupUserInfo.cs:928 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) | POPUP | new CommonDataPopup | () | 팝업/폼 생성 |  |  |  |
| AC-edb137d0 | InsertButton | GroupUserInfo.cs:930 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) | UI_PROP | popup.DataType | Data.Type.Customer | 속성 DataType 설정 |  |  |  |
| AC-00e204e7 | InsertButton | GroupUserInfo.cs:931 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) | UI_PROP | popup.DivisionID | divisionID | 속성 DivisionID 설정 |  |  |  |
| AC-e3dae7d1 | InsertButton | GroupUserInfo.cs:932 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) | UI_PROP | popup.Width | 480 | 속성 Width 설정 |  |  |  |
| AC-fa51f5c9 | InsertButton | GroupUserInfo.cs:933 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-27fab9ed | InsertButton | GroupUserInfo.cs:934 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3f7d9efc | InsertButton | GroupUserInfo.cs:936 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c8ee265f | InsertButton | GroupUserInfo.cs:942 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | siCustomer.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7c33f226 | InsertButton | GroupUserInfo.cs:945 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.Name, item.Name) | 데이터 객체 조작/조회 |  |  |  |
| AC-837ef674 | InsertButton | GroupUserInfo.cs:946 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | DATA_OP | defaultData.Add | (DefColumns.Code, item.Code) | 데이터 객체 조작/조회 |  |  |  |
| AC-90978d41 | InsertButton | GroupUserInfo.cs:948 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (popup.ShowDialog() == Dia… | GRID_SET | siCustomer.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## GroupUserInfo.JVPlantColumn

진입점: this.spdUserInfo.CellDoubleClick [if (groupID == "JV Planner")] / SaveButton [if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == SpdSheet.shtDivision) ▸ if (groupID == "JV Planner")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-866d7ed1 | this.spdUserInfo.CellDoubleClick [if (groupID == "JV Planner… 외 1 | GroupUserInfo.cs:214 | if (JV_ColumnIndex != -1) | GRID_INIT | siDivision.VisibleColumns | (JV_ColumnIndex, mEnable) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## GroupUserInfo.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1997c81b | SaveButton | GroupUserInfo.cs:501 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | STATE_RESET | saveDSUser.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-33c5e5ec | SaveButton | GroupUserInfo.cs:510 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | DATA_OP | saveDSUser.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5827e49f | SaveButton | GroupUserInfo.cs:512 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-f1fffcb0 | SaveButton | GroupUserInfo.cs:513 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | DATA_OP | dr[DefColumns.GroupID] | siUserInfo.GetValue(i, siUserInfo.GetColumnIndex(DefColumns.GroupID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-968fb50f | SaveButton | GroupUserInfo.cs:514 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | DATA_OP | dr[DefColumns.UserID] | siUserInfo.GetValue(i, siUserInfo.GetColumnIndex(DefColumns.UserID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-206976dd | SaveButton | GroupUserInfo.cs:515 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | DATA_OP | dr[DefColumns.UseYN] | siUserInfo.GetValue(i, siUserInfo.GetColumnIndex(DefColumns.UseYN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8eb87922 | SaveButton | GroupUserInfo.cs:516 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-64451935 | SaveButton | GroupUserInfo.cs:518 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | DATA_OP | saveDSUser.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-a20bba2b | SaveButton | GroupUserInfo.cs:521 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | DATA_OP | saveDSUser.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f1f75357 | SaveButton | GroupUserInfo.cs:529 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-71c2345c | SaveButton | GroupUserInfo.cs:530 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4eae482c | SaveButton | GroupUserInfo.cs:531 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2cf994db | SaveButton | GroupUserInfo.cs:535 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveUserGroupInfo" | 속성 InsertQueryId 설정 |  |  |  |
| AC-34c0f70b | SaveButton | GroupUserInfo.cs:536 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteUserGroupInfo" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-533bc3fe | SaveButton | GroupUserInfo.cs:537 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveUserGroupInfo" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-ca98ac2e | SaveButton | GroupUserInfo.cs:538 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | UI_PROP | request.DataSet | saveDSUser.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-fa7a3a13 | SaveButton | GroupUserInfo.cs:538 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | CALL_EXT | saveDSUser.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a75f94c | SaveButton | GroupUserInfo.cs:542 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b1212a66 | SaveButton | GroupUserInfo.cs:546 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d98b575 | SaveButton | GroupUserInfo.cs:546 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-d2c44a0e | SaveButton | GroupUserInfo.cs:551 | if (fps.Name == "spdUserInfo") ▸ if (siUserInfo != null && siUserInfo.IsLock(siUserInfo.SheetName) == false) ▸ if (siUserInfo.SheetName == S… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-129736e0 | SaveButton | GroupUserInfo.cs:565 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | STATE_RESET | saveDSDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c170fbef | SaveButton | GroupUserInfo.cs:574 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | saveDSDivision.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e601a1d4 | SaveButton | GroupUserInfo.cs:576 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-78ba9678 | SaveButton | GroupUserInfo.cs:577 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | dr[DefColumns.GroupID] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-a66db7d4 | SaveButton | GroupUserInfo.cs:578 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | dr[DefColumns.UserID] | userID | 행/컬럼 값 대입 |  |  |  |
| AC-aeb3cfc5 | SaveButton | GroupUserInfo.cs:579 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | dr["AuthType"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-aaa63988 | SaveButton | GroupUserInfo.cs:580 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | dr["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-c4aa1231 | SaveButton | GroupUserInfo.cs:581 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | dr[DefColumns.Code] | siDivision.GetValue(i, siDivision.GetColumnIndex(DefColumns.Code)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9d471268 | SaveButton | GroupUserInfo.cs:582 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | dr["PrntCode"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-88178634 | SaveButton | GroupUserInfo.cs:583 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-151d5f97 | SaveButton | GroupUserInfo.cs:584 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | dr[DefColumns.JV_Plant] | siDivision.GetValue(i, siDivision.GetColumnIndex(DefColumns.JV_Plant)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aeceb266 | SaveButton | GroupUserInfo.cs:585 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | dr[DefColumns.JV_Plant] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3f712d0e | SaveButton | GroupUserInfo.cs:587 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | saveDSDivision.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-0481d254 | SaveButton | GroupUserInfo.cs:590 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | saveDSDivision.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e19db860 | SaveButton | GroupUserInfo.cs:598 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a95f427c | SaveButton | GroupUserInfo.cs:599 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b3ec81c | SaveButton | GroupUserInfo.cs:600 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43b00a1c | SaveButton | GroupUserInfo.cs:604 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveUserGroupAuthExtention" | 속성 InsertQueryId 설정 |  |  |  |
| AC-8a63c0e7 | SaveButton | GroupUserInfo.cs:605 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteUserGroupAuthExtention" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-9e59303a | SaveButton | GroupUserInfo.cs:606 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveUserGroupAuthExtention" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-31db9f4d | SaveButton | GroupUserInfo.cs:607 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | UI_PROP | request.DataSet | saveDSDivision.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-3ecf13e4 | SaveButton | GroupUserInfo.cs:607 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | CALL_EXT | saveDSDivision.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-40a6b11e | SaveButton | GroupUserInfo.cs:611 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0a265774 | SaveButton | GroupUserInfo.cs:615 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f59498c2 | SaveButton | GroupUserInfo.cs:615 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-76c1134b | SaveButton | GroupUserInfo.cs:620 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41145ca4 | SaveButton | GroupUserInfo.cs:627 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | FLAG | divisionID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-6b41a63f | SaveButton | GroupUserInfo.cs:631 | if (fps.Name == "spdDivision") ▸ if (siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ▸ if (siDivision.SheetName == S… | GRID_INIT | siDivision.VisibleColumns | (JV_Plant_Index, true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bfa09f99 | SaveButton | GroupUserInfo.cs:644 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | STATE_RESET | saveDSPlant.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8e916b90 | SaveButton | GroupUserInfo.cs:653 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | saveDSPlant.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-67cf5a7d | SaveButton | GroupUserInfo.cs:655 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-0533826b | SaveButton | GroupUserInfo.cs:656 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | dr[DefColumns.GroupID] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-b71b0fa3 | SaveButton | GroupUserInfo.cs:657 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | dr[DefColumns.UserID] | userID | 행/컬럼 값 대입 |  |  |  |
| AC-4e7eb3d0 | SaveButton | GroupUserInfo.cs:658 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | dr["AuthType"] | "P" | 행/컬럼 값 대입 |  |  |  |
| AC-7167109e | SaveButton | GroupUserInfo.cs:659 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | dr[DefColumns.Code] | siPlant.GetValue(i, siPlant.GetColumnIndex(DefColumns.Code)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b2562168 | SaveButton | GroupUserInfo.cs:660 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | dr["PrntCode"] | divisionID | 행/컬럼 값 대입 |  |  |  |
| AC-9c2402c4 | SaveButton | GroupUserInfo.cs:661 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a33a7f42 | SaveButton | GroupUserInfo.cs:663 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | saveDSPlant.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f8af523 | SaveButton | GroupUserInfo.cs:666 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | saveDSPlant.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fad3fb71 | SaveButton | GroupUserInfo.cs:674 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c29b053 | SaveButton | GroupUserInfo.cs:675 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-43a67920 | SaveButton | GroupUserInfo.cs:676 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-68a3ce89 | SaveButton | GroupUserInfo.cs:680 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveUserGroupAuthExtention" | 속성 InsertQueryId 설정 |  |  |  |
| AC-9cf111bb | SaveButton | GroupUserInfo.cs:681 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteUserGroupAuthExtention" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-0c4ef1fe | SaveButton | GroupUserInfo.cs:682 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveUserGroupAuthExtention" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-e03874db | SaveButton | GroupUserInfo.cs:683 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | UI_PROP | request.DataSet | saveDSPlant.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-2c4cbcb6 | SaveButton | GroupUserInfo.cs:683 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | CALL_EXT | saveDSPlant.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e4a0ba3 | SaveButton | GroupUserInfo.cs:687 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e7b6230 | SaveButton | GroupUserInfo.cs:691 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d0193866 | SaveButton | GroupUserInfo.cs:691 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-d8868f0c | SaveButton | GroupUserInfo.cs:696 | if (fps.Name == "spdPlant") ▸ if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlan… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-45865bd0 | SaveButton | GroupUserInfo.cs:710 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | STATE_RESET | saveDSCustomer.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-d0de8f58 | SaveButton | GroupUserInfo.cs:719 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | saveDSCustomer.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7b7de8c0 | SaveButton | GroupUserInfo.cs:721 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-246cb753 | SaveButton | GroupUserInfo.cs:722 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | dr[DefColumns.GroupID] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-a145a602 | SaveButton | GroupUserInfo.cs:723 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | dr[DefColumns.UserID] | userID | 행/컬럼 값 대입 |  |  |  |
| AC-1da689ae | SaveButton | GroupUserInfo.cs:724 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | dr["AuthType"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-1c832cf1 | SaveButton | GroupUserInfo.cs:725 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | dr[DefColumns.Code] | siCustomer.GetValue(i, siCustomer.GetColumnIndex(DefColumns.Code)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57fc6b3b | SaveButton | GroupUserInfo.cs:726 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | dr["PrntCode"] | divisionID | 행/컬럼 값 대입 |  |  |  |
| AC-cf4eec45 | SaveButton | GroupUserInfo.cs:727 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a3dca202 | SaveButton | GroupUserInfo.cs:729 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | saveDSCustomer.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1fe4a8f | SaveButton | GroupUserInfo.cs:732 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | saveDSCustomer.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f00df209 | SaveButton | GroupUserInfo.cs:740 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e71d059 | SaveButton | GroupUserInfo.cs:741 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-45ed84a4 | SaveButton | GroupUserInfo.cs:742 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3f756981 | SaveButton | GroupUserInfo.cs:746 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveUserGroupAuthExtention" | 속성 InsertQueryId 설정 |  |  |  |
| AC-1cc019ea | SaveButton | GroupUserInfo.cs:747 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteUserGroupAuthExtention" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-16f7a789 | SaveButton | GroupUserInfo.cs:748 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveUserGroupAuthExtention" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-7ac478d6 | SaveButton | GroupUserInfo.cs:749 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | UI_PROP | request.DataSet | saveDSCustomer.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-5bf70c4c | SaveButton | GroupUserInfo.cs:749 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | CALL_EXT | saveDSCustomer.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f038e376 | SaveButton | GroupUserInfo.cs:753 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aa1de1fc | SaveButton | GroupUserInfo.cs:757 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a211313f | SaveButton | GroupUserInfo.cs:757 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-c8431376 | SaveButton | GroupUserInfo.cs:762 | if (fps.Name == "spdCustomer") ▸ if (siCustomer != null && siCustomer.IsLock(siCustomer.SheetName) == false) ▸ if (siCustomer.SheetName == S… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## GroupUserInfo.SpdDivision_CellDoubleClick

진입점: this.spdDivision.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da93f04b | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:994 | if (siDivision.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0bbbea8b | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:995 |  | FLAG | divisionID | siDivision.GetText(e.Row, siDivision.GetColumnIndex(DefColumns.Code)) | 화면 필드/플래그 변경 |  |  |  |
| AC-f1c33c1a | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:997 | if (siDivision.IsLock(siDivision.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6f9635c | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1009 | if (JV_ColumnIndex == e.Column) ▸ if (cr.Row == -1) | DATA_OP | dt1.Columns.Add | (DefColumns.Division_id, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fe7b320 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1010 | if (JV_ColumnIndex == e.Column) ▸ if (cr.Row == -1) | DATA_OP | dt1.Columns.Add | (DefColumns.Plant_id, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d463e23 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1014 | if (JV_ColumnIndex == e.Column) ▸ if (cr.Row == -1) ▸ for (i < siDivision.ActiveSheet.Rows.Count) | DATA_OP | dt1.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2a8328ed | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1015 | if (JV_ColumnIndex == e.Column) ▸ if (cr.Row == -1) ▸ for (i < siDivision.ActiveSheet.Rows.Count) | DATA_OP | row[0] | siDivision.ActiveSheet.Cells[i, CodeNumber].Text | 행/컬럼 값 대입 |  |  |  |
| AC-062c6eec | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1016 | if (JV_ColumnIndex == e.Column) ▸ if (cr.Row == -1) ▸ for (i < siDivision.ActiveSheet.Rows.Count) | DATA_OP | row[1] | siDivision.ActiveSheet.Cells[i, JV_ColumnIndex].Text | 행/컬럼 값 대입 |  |  |  |
| AC-80719a4a | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1017 | if (JV_ColumnIndex == e.Column) ▸ if (cr.Row == -1) ▸ for (i < siDivision.ActiveSheet.Rows.Count) | DATA_OP | dt1.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ac7e526 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1019 | if (JV_ColumnIndex == e.Column) ▸ if (cr.Row == -1) | POPUP | new JVPlantDataPopup | (dt1) | 팝업/폼 생성 |  |  |  |
| AC-0e7dbc93 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1032 | if (JV_ColumnIndex == e.Column) ▸ else of (cr.Row == -1) | DATA_OP | dt1.Columns.Add | (DefColumns.Division_id, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcceb00c | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1033 | if (JV_ColumnIndex == e.Column) ▸ else of (cr.Row == -1) | DATA_OP | dt1.Columns.Add | (DefColumns.Plant_id, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ffd1d2c | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1034 | if (JV_ColumnIndex == e.Column) ▸ else of (cr.Row == -1) | DATA_OP | dt1.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-442feda3 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1035 | if (JV_ColumnIndex == e.Column) ▸ else of (cr.Row == -1) | DATA_OP | row[0] | CodeValue | 행/컬럼 값 대입 |  |  |  |
| AC-8aae8d94 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1035 | if (JV_ColumnIndex == e.Column) ▸ else of (cr.Row == -1) | DATA_OP | row[1] | paramData | 행/컬럼 값 대입 |  |  |  |
| AC-fb088f13 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1036 | if (JV_ColumnIndex == e.Column) ▸ else of (cr.Row == -1) | DATA_OP | dt1.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f064952 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1038 | if (JV_ColumnIndex == e.Column) ▸ else of (cr.Row == -1) | POPUP | new JVPlantDataPopup | (dt1) | 팝업/폼 생성 |  |  |  |
| AC-1b62e486 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1042 | if (JV_ColumnIndex == e.Column) | UI_PROP | popup.DataType | Data.Type.JV_Plant | 속성 DataType 설정 |  |  |  |
| AC-91c03f02 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1044 | if (JV_ColumnIndex == e.Column) | UI_PROP | popup.Width | 480 | 속성 Width 설정 |  |  |  |
| AC-f7c6429e | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1045 | if (JV_ColumnIndex == e.Column) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-ff1412c6 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1046 | if (JV_ColumnIndex == e.Column) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-90f56c1f | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1048 | if (JV_ColumnIndex == e.Column) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-48920ff3 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1056 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ for (i < siDivision.ActiveSheet.Rows.Count) | DATA_OP | listDivisionID.Contains | (siDivision.GetValue2(i, IndexCode_Division_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f1379ab | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1056 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ for (i < siDivision.ActiveSheet.Rows.Count) | CALL_EXT | siDivision.GetValue2 | (i, IndexCode_Division_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1b7df62 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1058 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ for (i < siDivision.ActiveSheet.Rows.Count) ▸ if (!listDivisi… | DATA_OP | listDivisionID.Add | (siDivision.GetValue2(i, IndexCode_Division_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-341551c4 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1058 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ for (i < siDivision.ActiveSheet.Rows.Count) ▸ if (!listDivisi… | CALL_EXT | siDivision.GetValue2 | (i, IndexCode_Division_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd11175b | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1067 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var item in popup.selectedJVPlantDatInfo) ▸ if (inde… | DATA_OP | arrPlantIdData[indexDivision] | += item.Plant_id + "," | 행/컬럼 값 대입 |  |  |  |
| AC-09668d2f | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1078 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (cr.Row == -1) ▸ for (i < arrPlantIdData.Count()) ▸ if (ar… | GRID_SET | siDivision.ActiveSheet.Cells[i, JV_ColumnIndex].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-cc997be2 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1079 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (cr.Row == -1) ▸ for (i < arrPlantIdData.Count()) ▸ if (ar… | GRID_SET | siDivision.ActiveSheet.Cells[i, 0].Value | "M" | 그리드 속성/값 설정 |  |  |  |
| AC-5475a507 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1080 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (cr.Row == -1) ▸ for (i < arrPlantIdData.Count()) ▸ if (ar… | GRID_SET | siDivision.ActiveSheet.Cells[i, 0].BackColor | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-f2023972 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1081 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (cr.Row == -1) ▸ for (i < arrPlantIdData.Count()) ▸ if (ar… | GRID_SET | siDivision.ActiveSheet.Cells[i, JV_ColumnIndex].ForeColor | ControlColor.DeleteRowColor | 그리드 속성/값 설정 |  |  |  |
| AC-90196615 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1086 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (cr.Row == -1) ▸ for (i < arrPlantIdData.Count()) | DATA_OP | siDivision.ActiveSheet.Cells[i, IndexCode_Division_id].Text.Contains | (listDivisionID[i].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0838674 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1090 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (cr.Row == -1) ▸ for (i < arrPlantIdData.Count()) ▸ if (si… | GRID_SET | siDivision.ActiveSheet.Cells[i, JV_ColumnIndex].Text | arrPlantIdData[i].Substring(0, arrPlantIdData[i].Length - 1) | 그리드 속성/값 설정 |  |  |  |
| AC-43c3323d | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1091 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (cr.Row == -1) ▸ for (i < arrPlantIdData.Count()) ▸ if (si… | GRID_SET | siDivision.ActiveSheet.Cells[i, 0].Value | "M" | 그리드 속성/값 설정 |  |  |  |
| AC-6bd64ade | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1092 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (cr.Row == -1) ▸ for (i < arrPlantIdData.Count()) ▸ if (si… | GRID_SET | siDivision.ActiveSheet.Cells[i, 0].BackColor | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-1856dba5 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1093 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (cr.Row == -1) ▸ for (i < arrPlantIdData.Count()) ▸ if (si… | GRID_SET | siDivision.ActiveSheet.Cells[i, JV_ColumnIndex].ForeColor | ControlColor.DeleteRowColor | 그리드 속성/값 설정 |  |  |  |
| AC-dd6ba011 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1107 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ else of (cr.Row == -1) ▸ if (arrPlantIdData[clkRow] == null) … | GRID_SET | siDivision.ActiveSheet.Cells[clkRow, JV_ColumnIndex].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-a58ed3a2 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1108 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ else of (cr.Row == -1) ▸ if (arrPlantIdData[clkRow] == null) … | GRID_SET | siDivision.ActiveSheet.Cells[clkRow, 0].Value | "M" | 그리드 속성/값 설정 |  |  |  |
| AC-9060190f | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1109 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ else of (cr.Row == -1) ▸ if (arrPlantIdData[clkRow] == null) … | GRID_SET | siDivision.ActiveSheet.Cells[clkRow, 0].BackColor | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-cd7317a0 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1110 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ else of (cr.Row == -1) ▸ if (arrPlantIdData[clkRow] == null) … | GRID_SET | siDivision.ActiveSheet.Cells[clkRow, JV_ColumnIndex].ForeColor | ControlColor.DeleteRowColor | 그리드 속성/값 설정 |  |  |  |
| AC-414b0940 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1112 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ else of (cr.Row == -1) ▸ if (arrPlantIdData[clkRow] == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7be197e5 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1117 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ else of (cr.Row == -1) ▸ if (siDivision.ActiveSheet.Cells[clk… | GRID_SET | siDivision.ActiveSheet.Cells[clkRow, JV_ColumnIndex].Text | arrPlantIdData[clkRow].Substring(0, arrPlantIdData[clkRow].Length - 1) | 그리드 속성/값 설정 |  |  |  |
| AC-33af2631 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1118 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ else of (cr.Row == -1) ▸ if (siDivision.ActiveSheet.Cells[clk… | GRID_SET | siDivision.ActiveSheet.Cells[clkRow, 0].Value | "M" | 그리드 속성/값 설정 |  |  |  |
| AC-2cf6710d | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1119 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ else of (cr.Row == -1) ▸ if (siDivision.ActiveSheet.Cells[clk… | GRID_SET | siDivision.ActiveSheet.Cells[clkRow, 0].BackColor | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-26095806 | this.spdDivision.CellDoubleClick | GroupUserInfo.cs:1120 | if (JV_ColumnIndex == e.Column) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ else of (cr.Row == -1) ▸ if (siDivision.ActiveSheet.Cells[clk… | GRID_SET | siDivision.ActiveSheet.Cells[clkRow, JV_ColumnIndex].ForeColor | ControlColor.DeleteRowColor | 그리드 속성/값 설정 |  |  |  |

## GroupUserInfo.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68a92589 | this.spdMain.CellDoubleClick | GroupUserInfo.cs:962 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c7e7932 | this.spdMain.CellDoubleClick | GroupUserInfo.cs:964 |  | FLAG | groupID | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.GroupID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf65242d | this.spdMain.CellDoubleClick | GroupUserInfo.cs:972 |  | FLAG | userID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9484d2f0 | this.spdMain.CellDoubleClick | GroupUserInfo.cs:973 |  | FLAG | divisionID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## GroupUserInfo.SpdUserInfo_CellDoubleClick

진입점: this.spdUserInfo.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adc13774 | this.spdUserInfo.CellDoubleClick | GroupUserInfo.cs:979 | if (siUserInfo.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c95d816 | this.spdUserInfo.CellDoubleClick | GroupUserInfo.cs:981 |  | FLAG | userID | siUserInfo.GetText(e.Row, siUserInfo.GetColumnIndex(DefColumns.UserID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-550ee6aa | this.spdUserInfo.CellDoubleClick | GroupUserInfo.cs:988 |  | FLAG | divisionID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

