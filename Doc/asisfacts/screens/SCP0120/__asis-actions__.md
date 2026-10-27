# AS-IS 액션 대조표 — SCP0120

> 원천: `Doc/asisfacts/screens/SCP0120/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 325행 · 메서드 16 · 종류 DATA_OP 147 · GRID_INIT 90 · RETURN 17 · GRID_LOCK 12 · ENDPOINT 12 · FLAG 10 · UI_PROP 10 · CALL_EXT 8 · MESSAGE 4 · UI_MISC 3 · GRID_BIND 2 · STATE_RESET 2 · LIST_REBIND 2 · GRID_SET 2 · VALIDATE 2 · STATE 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 8


## SCP0120_ConstraintMgmt.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f674e99 | SaveButton [if (fps.Name == "spdMain")] | SCP0120_ConstraintMgmt.cs:998 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25f69b57 | SaveButton [if (fps.Name == "spdMain")] | SCP0120_ConstraintMgmt.cs:999 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5f3da71f | SaveButton [if (fps.Name == "spdMain")] | SCP0120_ConstraintMgmt.cs:1006 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-f9a2ca28 | SaveButton [if (fps.Name == "spdMain")] | SCP0120_ConstraintMgmt.cs:1008 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## SCP0120_ConstraintMgmt.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2586f251 | this.Load | SCP0120_ConstraintMgmt.cs:169 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b2c20b66 | this.Load | SCP0120_ConstraintMgmt.cs:170 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-da4fc4d6 | this.Load | SCP0120_ConstraintMgmt.cs:172 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2559da77 | this.Load | SCP0120_ConstraintMgmt.cs:173 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd8c976c | this.Load | SCP0120_ConstraintMgmt.cs:175 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0120_ConstraintMgmt.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b83cfa9 | DeleteButton | SCP0120_ConstraintMgmt.cs:335 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d000042 | DeleteButton | SCP0120_ConstraintMgmt.cs:338 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-28af2472 | DeleteButton | SCP0120_ConstraintMgmt.cs:340 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0120_ConstraintMgmt.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38516a25 | Dispose | SCP0120_ConstraintMgmt.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0120_ConstraintMgmt.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e6eaf79 | EditButton | SCP0120_ConstraintMgmt.cs:349 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a99c1da8 | EditButton | SCP0120_ConstraintMgmt.cs:350 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-36805b38 | EditButton | SCP0120_ConstraintMgmt.cs:352 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2107b9b9 | EditButton | SCP0120_ConstraintMgmt.cs:357 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-433562c4 | EditButton | SCP0120_ConstraintMgmt.cs:358 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5017de51 | EditButton | SCP0120_ConstraintMgmt.cs:360 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE), siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f2700d2b | EditButton | SCP0120_ConstraintMgmt.cs:361 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.SEGMENT10), siSub.GetColumnIndex(DefColumns.SEGMENT10), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-da4763e6 | EditButton | SCP0120_ConstraintMgmt.cs:362 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.CREATED_BY), siSub.GetColumnIndex(DefColumns.LAST_UPDATE_… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0120_ConstraintMgmt.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f652ee7c | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:913 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-62118a7e | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:921 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d61e5ba | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:925 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa263f8a | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:926 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c4303efb | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:933 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-b37a6863 | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:935 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SCP0120_ConstraintMgmt.FindData_Main

진입점: FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73dfbf73 | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:395 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b7d5bbc | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:399 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0120_GET_LOOKUP_MASTER") ⇒ SCP.SCP0120_GET_LOOKUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-5539feb6 | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:400 | lambda | DATA_OP | request.Parameters["p_lookup_type"] | p_lookup_type | 행/컬럼 값 대입 |  |  |  |
| AC-56a03888 | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:401 | lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-dd55aeef | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:402 | lambda | DATA_OP | request.Parameters["p_admin_yn"] | p_admin_yn | 행/컬럼 값 대입 |  |  |  |
| AC-04592ab6 | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:404 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc775270 | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:406 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-676ffabd | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:410 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-544ab378 | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:411 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-271fbfc4 | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:414 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e8b34648 | FindButton 외 1 | SCP0120_ConstraintMgmt.cs:417 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0120_ConstraintMgmt.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54f83cf2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:430 | if (string.IsNullOrWhiteSpace(mainLookupType)) | FLAG | mainLookupType | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3ee46884 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:434 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96ab9f3e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:438 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0120_GET_LOOKUP_MASTER_DETAIL") ⇒ SCP.SCP0120_GET_LOOKUP_MASTER_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-a2ef379f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:439 | lambda | DATA_OP | request.Parameters["p_lookup_type"] | mainLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-dce74c14 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:440 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-286c8a64 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:442 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6f8d4eec | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:446 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb9f9bfc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:459 | if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-47bca286 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:467 | if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace(sValue)… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-25e3524c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:473 | if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace(sV… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |
| AC-ce3f49e1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:522 | if (!string.IsNullOrEmpty(nowGroupID) && (nowGroupID != "ADMIN" && nowGroupID != "SCM PI Admin")) ▸ if (search_ColName != string.Empty) | DATA_OP | GSCM.Utils.DBUtils.Filter | (ds.Tables[0], search_ColName + " IN (" + plan_group_name + ")", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-97277054 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:524 | if (!string.IsNullOrEmpty(nowGroupID) && (nowGroupID != "ADMIN" && nowGroupID != "SCM PI Admin")) ▸ if (search_ColName != string.Empty) | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5ff8da70 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:525 | if (!string.IsNullOrEmpty(nowGroupID) && (nowGroupID != "ADMIN" && nowGroupID != "SCM PI Admin")) ▸ if (search_ColName != string.Empty) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ca98a05 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:526 | if (!string.IsNullOrEmpty(nowGroupID) && (nowGroupID != "ADMIN" && nowGroupID != "SCM PI Admin")) ▸ if (search_ColName != string.Empty) | DATA_OP | ds.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-91b154e3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:531 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4e9c0ae3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:532 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-530b4231 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0120_ConstraintMgmt.cs:535 |  | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0120_ConstraintMgmt.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e17939b | this.Load | SCP0120_ConstraintMgmt.cs:134 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0120_ConstraintMgmt.GetPlanGroupByUserID

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34e85a5a | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:306 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_GET_SEARCH_INFO") ⇒ SCP.SCP0121_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-0bdca277 | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:308 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9ca9c28c | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:309 |  | DATA_OP | request.Parameters["p_user_id"] | userId | 행/컬럼 값 대입 |  |  |  |
| AC-ca9544bd | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:312 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd3afbb9 | (진입점 미연결) | SCP0120_ConstraintMgmt.cs:316 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0120_ConstraintMgmt.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3857fa2 | this.Load | SCP0120_ConstraintMgmt.cs:150 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8136426 | this.Load | SCP0120_ConstraintMgmt.cs:152 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-851baa18 | this.Load | SCP0120_ConstraintMgmt.cs:154 |  | VALUE_SET | cboValid.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-342c22f4 | this.Load | SCP0120_ConstraintMgmt.cs:156 |  | FLAG | dtColumInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-24365f39 | this.Load | SCP0120_ConstraintMgmt.cs:160 | foreach (string str in sColumnList) | DATA_OP | dtColumInfo.Columns.Add | (str) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb92979e | this.Load | SCP0120_ConstraintMgmt.cs:163 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-380cbfa6 | this.Load | SCP0120_ConstraintMgmt.cs:164 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroupAll, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0120_ConstraintMgmt.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03b2aa6f | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:185 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c6b7435a | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:187 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-00768714 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:188 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Lookup TypeKey", DefColumns.LOOKUP_TYPE_KEY, FPMerge.None, 160, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2deeef77 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:189 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Lookup Type*", DefColumns.LOOKUP_TYPE, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7295fcb2 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:190 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Description*", DefColumns.DESCRIPTION, FPMerge.None, 220, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac253efa | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:191 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("System*", DefColumns.LOOKUP_GROUP, FPMerge.None, 80, true, dtSystem, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1204aa37 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:192 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Valid", DefColumns.VALID_YN, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8682979c | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:193 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1*", DefColumns.SEGMENT1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb14ee13 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:194 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2*", DefColumns.SEGMENT2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33f2149b | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:195 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3*", DefColumns.SEGMENT3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-963b0e4f | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:196 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4*", DefColumns.SEGMENT4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a8411529 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:197 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5*", DefColumns.SEGMENT5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cabc8ece | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:198 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment6*", DefColumns.SEGMENT6, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2617a701 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:199 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment7*", DefColumns.SEGMENT7, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27c13ded | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:200 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment8*", DefColumns.SEGMENT8, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-275edc4e | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:201 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment9*", DefColumns.SEGMENT9, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-309da91c | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:203 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Admin*", DefColumns.SEGMENT10, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-05e18b74 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:204 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f11310f | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:205 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aaf96352 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:206 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d7b15b4 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:207 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1757ad6f | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:208 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27d6521a | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:209 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b67fcb1 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:210 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4371bc7d | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:211 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1aa5130 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:212 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb2c8678 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:213 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a26b4906 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:214 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9ab9836 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:215 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd860b16 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:216 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52a25dd9 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:217 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c7945279 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:218 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ef7a5db | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:219 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Created By", DefColumns.CREATED_BY, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e01288bc | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:220 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Creation Date", DefColumns.CREATION_DATE, FPMerge.None, 160, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-048503a4 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:221 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Updated By", DefColumns.LAST_UPDATED_BY, FPMerge.None, 100, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0cca218e | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:222 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update Date", DefColumns.LAST_UPDATE_DATE, FPMerge.None, 160, true, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ee09e1b | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:224 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-349a501f | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:226 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0ed868de | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:231 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-1ddad69d | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:233 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-287b84dc | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:234 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Lookup Type*", DefColumns.LOOKUP_TYPE, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7aa30e9d | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:235 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1", DefColumns.SEGMENT1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-55a3717d | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:236 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2", DefColumns.SEGMENT2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c453adf3 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:237 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3", DefColumns.SEGMENT3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-58c9f6ea | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:238 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4", DefColumns.SEGMENT4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-623fda9f | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:239 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5", DefColumns.SEGMENT5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e5f88df | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:240 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment6", DefColumns.SEGMENT6, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1d3f47b6 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:241 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment7", DefColumns.SEGMENT7, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ec19f74 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:242 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment8", DefColumns.SEGMENT8, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dfa1e24e | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:243 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment9", DefColumns.SEGMENT9, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0a06109 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:244 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddComboColumn | ("Valid", DefColumns.VALID_YN, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50734005 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:245 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-112253f3 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:246 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51979077 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:247 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fe99ffca | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:248 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f9fd794 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:249 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d0f1fa2d | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:250 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aad4ae23 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:251 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-089b2939 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:252 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e949912d | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:253 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-65a182b0 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:254 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0378484a | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:255 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-439bc2b3 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:256 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d067cc11 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:257 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b50ffe3b | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:258 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d9ea925 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:259 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6eb42557 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:260 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Display Seq", DefColumns.DISPLAY_SEQ, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc98129e | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:261 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Description", DefColumns.DESCRIPTION, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-46934c3e | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:262 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Created By", DefColumns.CREATED_BY, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35185764 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:263 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Creation Date", DefColumns.CREATION_DATE, FPMerge.None, 160, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60663dc1 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:264 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Updated By", DefColumns.LAST_UPDATED_BY, FPMerge.None, 100, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f48dbc9f | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:265 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update Date", DefColumns.LAST_UPDATE_DATE, FPMerge.None, 160, true, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7d9a0a2e | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:267 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment10", DefColumns.SEGMENT10, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b65661f | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:270 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1", DefColumns.SEGMENT1_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79176f41 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:271 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2", DefColumns.SEGMENT2_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2302e00c | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:272 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3", DefColumns.SEGMENT3_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e21b6c23 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:273 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4", DefColumns.SEGMENT4_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41704af1 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:274 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5", DefColumns.SEGMENT5_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f51647f8 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:275 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment6", DefColumns.SEGMENT6_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-921c2623 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:276 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment7", DefColumns.SEGMENT7_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22db4932 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:277 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment8", DefColumns.SEGMENT8_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28b7779b | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:278 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment9", DefColumns.SEGMENT9_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2603975d | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:279 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment10", DefColumns.SEGMENT10_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a2c98c0b | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:281 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5f4b9563 | this.Load 외 3 | SCP0120_ConstraintMgmt.cs:283 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0120_ConstraintMgmt.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51fe11a8 | InsertButton | SCP0120_ConstraintMgmt.cs:810 | if (fps.Name == "spdMain") | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-804d5982 | InsertButton | SCP0120_ConstraintMgmt.cs:813 | if (fps.Name == "spdMain") | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-612ca267 | InsertButton | SCP0120_ConstraintMgmt.cs:815 | if (fps.Name == "spdMain") | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-6ff27d80 | InsertButton | SCP0120_ConstraintMgmt.cs:817 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6782fc07 | InsertButton | SCP0120_ConstraintMgmt.cs:821 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cc455bd3 | InsertButton | SCP0120_ConstraintMgmt.cs:823 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.LOOKUP_TYPE, mainLookupType) | 데이터 객체 조작/조회 |  |  |  |
| AC-db09a2cf | InsertButton | SCP0120_ConstraintMgmt.cs:824 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT1, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-48e8b2bd | InsertButton | SCP0120_ConstraintMgmt.cs:825 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT2, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ea51914 | InsertButton | SCP0120_ConstraintMgmt.cs:826 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT3, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d02e4d8 | InsertButton | SCP0120_ConstraintMgmt.cs:827 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT4, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf5b00d4 | InsertButton | SCP0120_ConstraintMgmt.cs:828 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT5, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f6f8c73 | InsertButton | SCP0120_ConstraintMgmt.cs:829 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT6, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f9f20c2 | InsertButton | SCP0120_ConstraintMgmt.cs:830 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT7, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-d97841ac | InsertButton | SCP0120_ConstraintMgmt.cs:831 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT8, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-acdae36e | InsertButton | SCP0120_ConstraintMgmt.cs:832 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT9, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-21a78180 | InsertButton | SCP0120_ConstraintMgmt.cs:833 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT10, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-bff6bb40 | InsertButton | SCP0120_ConstraintMgmt.cs:834 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-77f8891b | InsertButton | SCP0120_ConstraintMgmt.cs:836 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-e9e77a40 | InsertButton | SCP0120_ConstraintMgmt.cs:838 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE), siSub.GetColumnIndex(DefColumns.LO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-28f53d0f | InsertButton | SCP0120_ConstraintMgmt.cs:839 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.SEGMENT10), siSub.GetColumnIndex(DefColumns.SEGM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cf01f1f7 | InsertButton | SCP0120_ConstraintMgmt.cs:840 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.CREATED_BY), siSub.GetColumnIndex(DefColumns.LAS… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0120_ConstraintMgmt.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01ed4508 | SaveButton | SCP0120_ConstraintMgmt.cs:546 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-87e6659f | SaveButton | SCP0120_ConstraintMgmt.cs:546 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78e18d86 | SaveButton | SCP0120_ConstraintMgmt.cs:548 | if (fps.Name == "spdMain") ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92a6033d | SaveButton | SCP0120_ConstraintMgmt.cs:552 | if (fps.Name == "spdMain") | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7e010a9c | SaveButton | SCP0120_ConstraintMgmt.cs:553 | if (fps.Name == "spdMain") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c4b1b59 | SaveButton | SCP0120_ConstraintMgmt.cs:567 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-24c97961 | SaveButton | SCP0120_ConstraintMgmt.cs:569 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[CAppSetting.StringAction] | action | 행/컬럼 값 대입 |  |  |  |
| AC-e7c3f2d9 | SaveButton | SCP0120_ConstraintMgmt.cs:570 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LOOKUP_TYPE_KEY] | sLooupTypeKey | 행/컬럼 값 대입 |  |  |  |
| AC-3e15a2bf | SaveButton | SCP0120_ConstraintMgmt.cs:571 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LOOKUP_TYPE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd08cfcf | SaveButton | SCP0120_ConstraintMgmt.cs:572 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.DESCRIPTION] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8dcff60a | SaveButton | SCP0120_ConstraintMgmt.cs:573 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LOOKUP_GROUP] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOOKUP_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-db160783 | SaveButton | SCP0120_ConstraintMgmt.cs:574 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.VALID_YN] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c767ff94 | SaveButton | SCP0120_ConstraintMgmt.cs:575 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT1] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-33ecd2df | SaveButton | SCP0120_ConstraintMgmt.cs:576 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT2] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-efeb82c7 | SaveButton | SCP0120_ConstraintMgmt.cs:577 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT3] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad85600d | SaveButton | SCP0120_ConstraintMgmt.cs:578 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT4] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e39383a0 | SaveButton | SCP0120_ConstraintMgmt.cs:579 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT5] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bf6a920f | SaveButton | SCP0120_ConstraintMgmt.cs:580 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT6] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b1e9bb1 | SaveButton | SCP0120_ConstraintMgmt.cs:581 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT7] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-042996f7 | SaveButton | SCP0120_ConstraintMgmt.cs:582 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT8] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ec53b8fe | SaveButton | SCP0120_ConstraintMgmt.cs:583 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT9] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2cea1e9f | SaveButton | SCP0120_ConstraintMgmt.cs:584 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT10] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6c489ab4 | SaveButton | SCP0120_ConstraintMgmt.cs:585 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c5cf142a | SaveButton | SCP0120_ConstraintMgmt.cs:586 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ea529827 | SaveButton | SCP0120_ConstraintMgmt.cs:587 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-195e748e | SaveButton | SCP0120_ConstraintMgmt.cs:588 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-206ba688 | SaveButton | SCP0120_ConstraintMgmt.cs:589 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-89c3af98 | SaveButton | SCP0120_ConstraintMgmt.cs:590 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1f3aeb1e | SaveButton | SCP0120_ConstraintMgmt.cs:591 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-34320d3a | SaveButton | SCP0120_ConstraintMgmt.cs:592 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8ed9237 | SaveButton | SCP0120_ConstraintMgmt.cs:593 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae5173c3 | SaveButton | SCP0120_ConstraintMgmt.cs:594 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3df952ac | SaveButton | SCP0120_ConstraintMgmt.cs:595 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c7e22caa | SaveButton | SCP0120_ConstraintMgmt.cs:596 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-694bc09d | SaveButton | SCP0120_ConstraintMgmt.cs:597 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc8d740a | SaveButton | SCP0120_ConstraintMgmt.cs:598 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c648434b | SaveButton | SCP0120_ConstraintMgmt.cs:599 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-809c5d38 | SaveButton | SCP0120_ConstraintMgmt.cs:603 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATED_BY] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3a3f9cb9 | SaveButton | SCP0120_ConstraintMgmt.cs:604 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATION_DATE] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f79d22a1 | SaveButton | SCP0120_ConstraintMgmt.cs:608 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATED_BY] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CREATED_BY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8074c23 | SaveButton | SCP0120_ConstraintMgmt.cs:609 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATION_DATE] | Convert.ToDateTime(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CREATION_DATE)).ToS… | 행/컬럼 값 대입 |  |  |  |
| AC-b7bfa32d | SaveButton | SCP0120_ConstraintMgmt.cs:611 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LAST_UPDATED_BY] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fd6bd98f | SaveButton | SCP0120_ConstraintMgmt.cs:613 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-b48a444f | SaveButton | SCP0120_ConstraintMgmt.cs:616 | if (fps.Name == "spdMain") | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4357cb4b | SaveButton | SCP0120_ConstraintMgmt.cs:624 | if (fps.Name == "spdMain") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.StringAction].ToString()) case CAppSet… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5395257 | SaveButton | SCP0120_ConstraintMgmt.cs:625 | if (fps.Name == "spdMain") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.StringAction].ToString()) case CAppSet… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fee7e5ce | SaveButton | SCP0120_ConstraintMgmt.cs:626 | if (fps.Name == "spdMain") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.StringAction].ToString()) case CAppSet… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9562cf46 | SaveButton | SCP0120_ConstraintMgmt.cs:630 | if (fps.Name == "spdMain") | UI_PROP | request.InsertQueryId | "SCP.SCP0120_SAVE_LOOKUP_MASTER" | 속성 InsertQueryId 설정 |  |  |  |
| AC-8cf812be | SaveButton | SCP0120_ConstraintMgmt.cs:631 | if (fps.Name == "spdMain") | UI_PROP | request.DeleteQueryId | "SCP.SCP0120_DELETE_LOOKUP_MASTER" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-b2ae7b14 | SaveButton | SCP0120_ConstraintMgmt.cs:632 | if (fps.Name == "spdMain") | UI_PROP | request.UpdateQueryId | "SCP.SCP0120_SAVE_LOOKUP_MASTER" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-f270a76d | SaveButton | SCP0120_ConstraintMgmt.cs:634 | if (fps.Name == "spdMain") | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-4ab3cf23 | SaveButton | SCP0120_ConstraintMgmt.cs:634 | if (fps.Name == "spdMain") | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bc07a97 | SaveButton | SCP0120_ConstraintMgmt.cs:638 | if (fps.Name == "spdMain") | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ea34d641 | SaveButton | SCP0120_ConstraintMgmt.cs:642 | if (fps.Name == "spdMain") ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-68db683b | SaveButton | SCP0120_ConstraintMgmt.cs:642 | if (fps.Name == "spdMain") ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-a2f9c476 | SaveButton | SCP0120_ConstraintMgmt.cs:647 | if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5e5849df | SaveButton | SCP0120_ConstraintMgmt.cs:655 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | (siSub.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-110db569 | SaveButton | SCP0120_ConstraintMgmt.cs:656 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-29354a35 | SaveButton | SCP0120_ConstraintMgmt.cs:659 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-dc9ed5d9 | SaveButton | SCP0120_ConstraintMgmt.cs:659 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00047941 | SaveButton | SCP0120_ConstraintMgmt.cs:661 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9313d7e | SaveButton | SCP0120_ConstraintMgmt.cs:670 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b455c3d1 | SaveButton | SCP0120_ConstraintMgmt.cs:677 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[CAppSetting.StringAction] | action | 행/컬럼 값 대입 |  |  |  |
| AC-c9a5ab2f | SaveButton | SCP0120_ConstraintMgmt.cs:678 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LOOKUP_TYPE] | mainLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-0bdb148f | SaveButton | SCP0120_ConstraintMgmt.cs:679 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.DESCRIPTION] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9e29339e | SaveButton | SCP0120_ConstraintMgmt.cs:680 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT1] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ddccedae | SaveButton | SCP0120_ConstraintMgmt.cs:681 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT2] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d4e32aeb | SaveButton | SCP0120_ConstraintMgmt.cs:682 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT3] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9bfe4e28 | SaveButton | SCP0120_ConstraintMgmt.cs:683 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT4] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0202940a | SaveButton | SCP0120_ConstraintMgmt.cs:684 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT5] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a3f98a1c | SaveButton | SCP0120_ConstraintMgmt.cs:685 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT6] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a429445c | SaveButton | SCP0120_ConstraintMgmt.cs:686 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT7] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b8a403a9 | SaveButton | SCP0120_ConstraintMgmt.cs:687 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT8] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8138a9eb | SaveButton | SCP0120_ConstraintMgmt.cs:688 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT9] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ce61e63b | SaveButton | SCP0120_ConstraintMgmt.cs:689 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT10] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f045aee9 | SaveButton | SCP0120_ConstraintMgmt.cs:690 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT1_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT1_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7bf153a9 | SaveButton | SCP0120_ConstraintMgmt.cs:691 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT2_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT2_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-647437a0 | SaveButton | SCP0120_ConstraintMgmt.cs:692 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT3_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT3_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f48e7ffc | SaveButton | SCP0120_ConstraintMgmt.cs:693 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT4_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT4_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-421483fa | SaveButton | SCP0120_ConstraintMgmt.cs:694 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT5_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT5_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2bdf45cd | SaveButton | SCP0120_ConstraintMgmt.cs:695 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT6_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT6_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd380ff8 | SaveButton | SCP0120_ConstraintMgmt.cs:696 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT7_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT7_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b284bd0 | SaveButton | SCP0120_ConstraintMgmt.cs:697 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT8_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT8_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8e939819 | SaveButton | SCP0120_ConstraintMgmt.cs:698 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT9_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT9_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-579aab14 | SaveButton | SCP0120_ConstraintMgmt.cs:699 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT10_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT10_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6b9c4aaf | SaveButton | SCP0120_ConstraintMgmt.cs:700 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.DISPLAY_SEQ] | sDisplaySeq | 행/컬럼 값 대입 |  |  |  |
| AC-2eab9ed6 | SaveButton | SCP0120_ConstraintMgmt.cs:701 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.VALID_YN] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.VALID_YN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d8f600f | SaveButton | SCP0120_ConstraintMgmt.cs:702 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8507df89 | SaveButton | SCP0120_ConstraintMgmt.cs:703 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a77fab22 | SaveButton | SCP0120_ConstraintMgmt.cs:704 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c493d155 | SaveButton | SCP0120_ConstraintMgmt.cs:705 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-645f43c5 | SaveButton | SCP0120_ConstraintMgmt.cs:706 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dc98d619 | SaveButton | SCP0120_ConstraintMgmt.cs:707 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7e455f1f | SaveButton | SCP0120_ConstraintMgmt.cs:708 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-22684d16 | SaveButton | SCP0120_ConstraintMgmt.cs:709 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2d54b26c | SaveButton | SCP0120_ConstraintMgmt.cs:710 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cd4d2d9c | SaveButton | SCP0120_ConstraintMgmt.cs:711 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5bbbf037 | SaveButton | SCP0120_ConstraintMgmt.cs:712 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3903132b | SaveButton | SCP0120_ConstraintMgmt.cs:713 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-933c3345 | SaveButton | SCP0120_ConstraintMgmt.cs:714 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f423a891 | SaveButton | SCP0120_ConstraintMgmt.cs:715 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5f3c74a8 | SaveButton | SCP0120_ConstraintMgmt.cs:716 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-41f47953 | SaveButton | SCP0120_ConstraintMgmt.cs:720 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATED_BY] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8c4ab6ac | SaveButton | SCP0120_ConstraintMgmt.cs:721 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATION_DATE] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c3f97322 | SaveButton | SCP0120_ConstraintMgmt.cs:725 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATED_BY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CREATED_BY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a3133f40 | SaveButton | SCP0120_ConstraintMgmt.cs:726 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATION_DATE] | Convert.ToDateTime(siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CREATION_DATE)).ToStr… | 행/컬럼 값 대입 |  |  |  |
| AC-831e2eea | SaveButton | SCP0120_ConstraintMgmt.cs:728 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LAST_UPDATED_BY] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bd21e8f5 | SaveButton | SCP0120_ConstraintMgmt.cs:730 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-20025232 | SaveButton | SCP0120_ConstraintMgmt.cs:733 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-31993b48 | SaveButton | SCP0120_ConstraintMgmt.cs:741 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.Strin… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-79bc92de | SaveButton | SCP0120_ConstraintMgmt.cs:742 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.Strin… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c0c66f0 | SaveButton | SCP0120_ConstraintMgmt.cs:743 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.Strin… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9f5965ed | SaveButton | SCP0120_ConstraintMgmt.cs:747 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | UI_PROP | request.InsertQueryId | "SCP.SCP0120_SAVE_LOOKUP_MASTER_DETAIL" | 속성 InsertQueryId 설정 |  |  |  |
| AC-892a73c7 | SaveButton | SCP0120_ConstraintMgmt.cs:748 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | UI_PROP | request.DeleteQueryId | "SCP.SCP0120_DELETE_LOOKUP_MASTER_DETAIL" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-fe837274 | SaveButton | SCP0120_ConstraintMgmt.cs:749 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | UI_PROP | request.UpdateQueryId | "SCP.SCP0120_SAVE_LOOKUP_MASTER_DETAIL" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-31d80d8c | SaveButton | SCP0120_ConstraintMgmt.cs:751 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-4f0b531c | SaveButton | SCP0120_ConstraintMgmt.cs:751 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7060f1f9 | SaveButton | SCP0120_ConstraintMgmt.cs:755 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ad4a0bc2 | SaveButton | SCP0120_ConstraintMgmt.cs:759 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-221875b7 | SaveButton | SCP0120_ConstraintMgmt.cs:759 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-db94efb5 | SaveButton | SCP0120_ConstraintMgmt.cs:764 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0120_ConstraintMgmt.SetColumInfo

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2150cebe | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:868 |  | DATA_OP | dtColumInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d3538180 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:869 |  | DATA_OP | dr[DefColumns.SEGMENT1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-73c9f77f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:870 |  | DATA_OP | dr[DefColumns.SEGMENT2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29912050 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:871 |  | DATA_OP | dr[DefColumns.SEGMENT3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4a0906e3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:872 |  | DATA_OP | dr[DefColumns.SEGMENT4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a58aed99 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:873 |  | DATA_OP | dr[DefColumns.SEGMENT5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-07a2c7fe | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:874 |  | DATA_OP | dr[DefColumns.SEGMENT6] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6cdbfd37 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:875 |  | DATA_OP | dr[DefColumns.SEGMENT7] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fed704d7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:876 |  | DATA_OP | dr[DefColumns.SEGMENT8] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-512051e2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:877 |  | DATA_OP | dr[DefColumns.SEGMENT9] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a4e78198 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:878 |  | DATA_OP | dr[DefColumns.SEGMENT10] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-16a8f7e6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:879 |  | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e46272d9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:880 |  | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad292c48 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:881 |  | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c9d5d89 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:882 |  | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5e066e51 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:883 |  | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-30b6ed1a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:884 |  | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-175f5ad7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:885 |  | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-420d186d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:886 |  | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ab84b321 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:887 |  | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a53d21a2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:888 |  | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-197dc85f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:889 |  | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9050c9a1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:890 |  | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f7d6acd6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:891 |  | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-24f8e545 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:892 |  | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c82278a1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:893 |  | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cf9602a4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCP0120_ConstraintMgmt.cs:895 |  | DATA_OP | dtColumInfo.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |

## SCP0120_ConstraintMgmt.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfbbc510 | this.spdMain.CellDoubleClick | SCP0120_ConstraintMgmt.cs:854 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13e1ffab | this.spdMain.CellDoubleClick | SCP0120_ConstraintMgmt.cs:856 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | mainLookupType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5b3520bb | this.spdMain.CellDoubleClick | SCP0120_ConstraintMgmt.cs:858 | if (siMain.IsLock(siMain.SheetName) == true) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

