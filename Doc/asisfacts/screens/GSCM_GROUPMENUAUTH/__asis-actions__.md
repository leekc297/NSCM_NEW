# AS-IS 액션 대조표 — GSCM_GROUPMENUAUTH

> 원천: `Doc/asisfacts/screens/GSCM_GROUPMENUAUTH/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 200행 · 메서드 27 · 종류 DATA_OP 44 · GRID_INIT 32 · CALL_EXT 20 · RETURN 18 · ENDPOINT 15 · GRID_SET 14 · FLAG 11 · POPUP 10 · MESSAGE 9 · UI_PROP 8 · UI_MISC 6 · GRID_LOCK 6 · STATE_RESET 2 · GRID_BIND 2 · STATE 1 · CALL_BASE 1 · THROW 1 · ⚠ 의미 확인 필요 21


## GroupMenuAuth.CheckAuthManual

진입점: this.Load [if (spread.SheetName == SpdSheet.shtSub)] / this.spdMain.CellDoubleClick [if (spread.SheetName == SpdSheet.shtSub)] / FindButton [if (spread.SheetName == SpdSheet.shtSub)] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (spread.SheetName == SpdSheet.shtSub)] / OnShown [try ▸ if (ds != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12a1625d | this.Load [if (spread.SheetName == SpdSheet.shtSub)] 외 4 | GroupMenuAuth.cs:534 |  | RETURN | return hasAuth; |  | 처리 중단/반환 |  |  |  |

## GroupMenuAuth.CheckAuthMenuGroup

진입점: this.Load [if (spread.SheetName == SpdSheet.shtSub)] / this.spdMain.CellDoubleClick [if (spread.SheetName == SpdSheet.shtSub)] / FindButton [if (spread.SheetName == SpdSheet.shtSub)] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (spread.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a48fff6 | this.Load [if (spread.SheetName == SpdSheet.shtSub)] 외 3 | GroupMenuAuth.cs:554 |  | RETURN | return hasAuth; |  | 처리 중단/반환 |  |  |  |

## GroupMenuAuth.CheckExistsHelpFileInfo

진입점: this.Load [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ for (i <= dtFileExists.Rows.Count)] / this.spdMain.CellDoubleClick [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ for (i <= dtFileExists.Rows.Count)] / FindButton [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ for (i <= dtFileExists.Rows.Count)] / SaveBut…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a269f852 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:587 | try | ENDPOINT | CommonUtils.FindDataValue | (dtHelpFile, "shortname", MenuName, "shortname") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d313a195 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:592 | try | ENDPOINT | CommonUtils.FindDataValue | (dtHelpFile, "shortname", MenuName, "update_time") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## GroupMenuAuth.ConvertHelpFile

진입점: this.Load [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ try ▸ if (CommonUtils.CheckDataEmpty(ret) == false)] / this.spdMain.CellDoubleClick [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ try ▸ if (CommonUtils.CheckDataEmpty(ret) == false)] / FindButton [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ try ▸ if (C…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5626a052 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:832 |  | DATA_OP | dtCopy.Columns.Add | ("shortname") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4227b09 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:833 |  | DATA_OP | dtCopy.Columns.Add | ("update_time") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec351098 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:842 | if (CommonUtils.CheckDataEmpty(dtHelpFile) == false) ▸ foreach (DataRow row in dtHelpFile.Rows) | CALL_EXT | CommonUtils.ConvertKorNow | (update_time, "g") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a8fafd0 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:843 | if (CommonUtils.CheckDataEmpty(dtHelpFile) == false) ▸ foreach (DataRow row in dtHelpFile.Rows) | DATA_OP | dtCopy.Rows.Add | (shortname, update_time) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a7def1e | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:846 |  | RETURN | return dtCopy; |  | 처리 중단/반환 |  |  |  |

## GroupMenuAuth.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50c992e8 | this.Load | GroupMenuAuth.cs:130 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8c3836ab | this.Load | GroupMenuAuth.cs:131 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0e439a69 | this.Load | GroupMenuAuth.cs:133 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 15) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4bf81112 | this.Load | GroupMenuAuth.cs:134 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6f2dfa6 | this.Load | GroupMenuAuth.cs:136 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## GroupMenuAuth.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36fd51d7 | this.Load | GroupMenuAuth.cs:124 |  | STATE | this.usrConditionPanel1.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-d60fe13a | this.Load | GroupMenuAuth.cs:125 |  | FLAG | UserGroup | GetUserGroup() | 화면 필드/플래그 변경 |  |  |  |

## GroupMenuAuth.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f33c4059 | DeleteButton | GroupMenuAuth.cs:224 | if (this.fps != null) ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## GroupMenuAuth.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e66f3d81 | Dispose | GroupMenuAuth.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## GroupMenuAuth.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41a27ff3 | EditButton | GroupMenuAuth.cs:234 | if (this.fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a2022eda | EditButton | GroupMenuAuth.cs:235 | if (this.fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-cd65e543 | EditButton | GroupMenuAuth.cs:237 | if (this.fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (0, siSub.GetColumnIndex(DefColumns.Title), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-040dd1ec | EditButton | GroupMenuAuth.cs:238 | if (this.fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefHelpColumns.HELP_YN), siSub.GetColumnIndex(DefHelpColumns.HELP_UP… | 그리드 편집 잠금/해제 |  |  |  |

## GroupMenuAuth.FindData

진입점: this.Load / this.spdMain.CellDoubleClick / FindButton / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70723b6a | this.Load 외 3 | GroupMenuAuth.cs:254 |  | STATE_RESET | dtFileExists.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5444cea6 | this.Load 외 3 | GroupMenuAuth.cs:260 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ab9cac5 | this.Load 외 3 | GroupMenuAuth.cs:264 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetGroupInfoList") ⇒ SystemManager.UP_FX_GetGroupInfoList | 엔드포인트 요청 생성 |  |  |  |
| AC-324be80a | this.Load 외 3 | GroupMenuAuth.cs:265 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-76e8f265 | this.Load 외 3 | GroupMenuAuth.cs:267 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9438af25 | this.Load 외 3 | GroupMenuAuth.cs:271 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c9134b89 | this.Load 외 3 | GroupMenuAuth.cs:272 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0fa879a4 | this.Load 외 3 | GroupMenuAuth.cs:275 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2bb58ae2 | this.Load 외 3 | GroupMenuAuth.cs:278 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-30a4d794 | this.Load 외 3 | GroupMenuAuth.cs:292 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a12df4a | this.Load 외 3 | GroupMenuAuth.cs:296 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetGroupMenuAuthList") ⇒ SystemManager.UP_FX_GetGroupMenuAuthList | 엔드포인트 요청 생성 |  |  |  |
| AC-5f3d6d54 | this.Load 외 3 | GroupMenuAuth.cs:297 | try ▸ lambda | DATA_OP | request.Parameters["GroupID"] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-43806302 | this.Load 외 3 | GroupMenuAuth.cs:299 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b7615be9 | this.Load 외 3 | GroupMenuAuth.cs:301 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0db57cba | this.Load 외 3 | GroupMenuAuth.cs:305 | try | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e60889c7 | this.Load 외 3 | GroupMenuAuth.cs:306 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-af11a9ea | this.Load 외 3 | GroupMenuAuth.cs:309 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f4b32bd9 | this.Load 외 3 | GroupMenuAuth.cs:315 | try | FLAG | saveDSSub | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-a5dc07eb | this.Load 외 3 | GroupMenuAuth.cs:315 | try | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-976ec03d | this.Load 외 3 | GroupMenuAuth.cs:316 | try | DATA_OP | saveDSSub.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## GroupMenuAuth.FindDataList

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a8d9044 | OnShown | GroupMenuAuth.cs:348 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-20126397 | OnShown | GroupMenuAuth.cs:349 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-aebd894f | OnShown | GroupMenuAuth.cs:353 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7ee8369c | OnShown | GroupMenuAuth.cs:357 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetGroupMenuAuthList") ⇒ SystemManager.UP_FX_GetGroupMenuAuthList | 엔드포인트 요청 생성 |  |  |  |
| AC-0a647194 | OnShown | GroupMenuAuth.cs:358 | try ▸ lambda | DATA_OP | request.Parameters["GroupID"] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-7b5c38be | OnShown | GroupMenuAuth.cs:360 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d40f4d27 | OnShown | GroupMenuAuth.cs:362 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fe3b32ec | OnShown | GroupMenuAuth.cs:368 | try ▸ if (ds != null) | FLAG | dtFileExists | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-f507b9fe | OnShown | GroupMenuAuth.cs:377 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## GroupMenuAuth.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae5d3c95 | this.Load | GroupMenuAuth.cs:110 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## GroupMenuAuth.GetMenuName

진입점: this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumnIndex(DefHelpColumns.HELP_OPEN))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65b0812f | this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumn… | GroupMenuAuth.cs:661 |  | RETURN | return MenuName; |  | 처리 중단/반환 |  |  |  |

## GroupMenuAuth.GetUserGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b007425 | this.Load | GroupMenuAuth.cs:517 |  | RETURN | return UserInfoContext.Current["NowGroupID"].ToUpper(); |  | 처리 중단/반환 |  |  |  |

## GroupMenuAuth.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick / FindButton / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afd721f7 | this.Load 외 3 | GroupMenuAuth.cs:146 | if (spread.SheetName == SpdSheet.shtMain) | GRID_INIT | spread.InitSheet | (spread.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-24afc858 | this.Load 외 3 | GroupMenuAuth.cs:148 | if (spread.SheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2cf0b479 | this.Load 외 3 | GroupMenuAuth.cs:149 | if (spread.SheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddTextColumn | ("GroupID", DefColumns.GroupID, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-169b715d | this.Load 외 3 | GroupMenuAuth.cs:150 | if (spread.SheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddTextColumn | ("GrpName", DefColumns.GrpName, FPMerge.None, 170, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-774ebc0e | this.Load 외 3 | GroupMenuAuth.cs:151 | if (spread.SheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddComboColumn | ("UseYN", DefColumns.UseYN, FPMerge.None, 60, false, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c9f9090 | this.Load 외 3 | GroupMenuAuth.cs:155 | if (spread.SheetName == SpdSheet.shtMain) | GRID_INIT | spread.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a40b9b03 | this.Load 외 3 | GroupMenuAuth.cs:160 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.InitSheet | (spread.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-887d3551 | this.Load 외 3 | GroupMenuAuth.cs:162 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5c1f3f71 | this.Load 외 3 | GroupMenuAuth.cs:163 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddTextColumn | ("GroupID", DefColumns.GroupID, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-276dfafc | this.Load 외 3 | GroupMenuAuth.cs:164 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddTextColumn | ("Level1Title*", "Level1Title", FPMerge.Always, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9232d9bc | this.Load 외 3 | GroupMenuAuth.cs:165 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddTextColumn | ("Level2Title*", "Level2Title", FPMerge.Always, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-46dce217 | this.Load 외 3 | GroupMenuAuth.cs:166 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddTextColumn | ("Level1MenuID", "Level1MenuID", FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8084dda6 | this.Load 외 3 | GroupMenuAuth.cs:167 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddTextColumn | ("Level2MenuID", DefColumns.PrntMenuID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bba46c0 | this.Load 외 3 | GroupMenuAuth.cs:168 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddTextColumn | ("Level3MenuID*", DefColumns.MenuID, FPMerge.Always, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49747483 | this.Load 외 3 | GroupMenuAuth.cs:169 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddTextColumn | ("Title*", DefColumns.Title, FPMerge.None, 250, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-45792d83 | this.Load 외 3 | GroupMenuAuth.cs:170 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddCheckColumn | ("BasicACLC", DefColumns.BasicACLC, FPMerge.None, 60, false, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28addd5d | this.Load 외 3 | GroupMenuAuth.cs:171 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddCheckColumn | ("Read*", DefColumns.BasicACLR, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cfa46427 | this.Load 외 3 | GroupMenuAuth.cs:172 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddCheckColumn | ("Modify*", DefColumns.BasicACLU, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f95ba8af | this.Load 외 3 | GroupMenuAuth.cs:173 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddCheckColumn | ("BasicACLD", DefColumns.BasicACLD, FPMerge.None, 60, false, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cfd3f48b | this.Load 외 3 | GroupMenuAuth.cs:174 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddTextColumn | ("ExtendedACL", DefColumns.ExtendedACL, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2a5573a | this.Load 외 3 | GroupMenuAuth.cs:175 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.AddComboColumn | ("UseYN", DefColumns.UseYN, FPMerge.None, 60, false, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ccb719e7 | this.Load 외 3 | GroupMenuAuth.cs:177 | if (spread.SheetName == SpdSheet.shtSub) | CALL_EXT | spread.ColumnHeaderSpanRow | (0, spread.GetColumnIndex(DefColumns.BasicACLC)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-efb846ca | this.Load 외 3 | GroupMenuAuth.cs:178 | if (spread.SheetName == SpdSheet.shtSub) | CALL_EXT | spread.ColumnHeaderSpanRow | (spread.GetColumnIndex(DefColumns.BasicACLD), spread.GetColumnIndex(DefColumns.UseYN)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5c241ed | this.Load 외 3 | GroupMenuAuth.cs:184 | if (spread.SheetName == SpdSheet.shtSub) ▸ if (CheckAuthManual() && CheckAuthMenuGroup()) | GRID_INIT | spread.AddTextColumn | ("YN", DefHelpColumns.HELP_YN, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e2d4f0e | this.Load 외 3 | GroupMenuAuth.cs:185 | if (spread.SheetName == SpdSheet.shtSub) ▸ if (CheckAuthManual() && CheckAuthMenuGroup()) | GRID_INIT | spread.AddButtonColumn | ("Open", DefHelpColumns.HELP_OPEN, "...", FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-924e9122 | this.Load 외 3 | GroupMenuAuth.cs:186 | if (spread.SheetName == SpdSheet.shtSub) ▸ if (CheckAuthManual() && CheckAuthMenuGroup()) | GRID_INIT | spread.AddButtonColumn | ("File", DefHelpColumns.HELP_UPLOAD, "...", FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61455900 | this.Load 외 3 | GroupMenuAuth.cs:187 | if (spread.SheetName == SpdSheet.shtSub) ▸ if (CheckAuthManual() && CheckAuthMenuGroup()) | GRID_INIT | spread.AddTextColumn | ("Last Update", DefHelpColumns.HELP_LAST_UPDATE, FPMerge.None, 160, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf55e5ef | this.Load 외 3 | GroupMenuAuth.cs:189 | if (spread.SheetName == SpdSheet.shtSub) ▸ if (CheckAuthManual() && CheckAuthMenuGroup()) | CALL_EXT | spread.ColumnHeaderSpanRow | (spread.GetColumnIndex(DefHelpColumns.HELP_YN), spread.GetColumnIndex(DefHelpColumns.HELP_… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9188275 | this.Load 외 3 | GroupMenuAuth.cs:190 | if (spread.SheetName == SpdSheet.shtSub) ▸ if (CheckAuthManual() && CheckAuthMenuGroup()) | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(DefHelpColumns.HELP_YN), 1, iHelpColumCount, 25, "Help", FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17ee57c8 | this.Load 외 3 | GroupMenuAuth.cs:199 | if (spread.SheetName == SpdSheet.shtSub) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefColumns.BasicACLR)].Cell… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-bf61a6af | this.Load 외 3 | GroupMenuAuth.cs:200 | if (spread.SheetName == SpdSheet.shtSub) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefColumns.BasicACLR)].Valu… | false | 그리드 속성/값 설정 |  |  |  |
| AC-fb86e4f6 | this.Load 외 3 | GroupMenuAuth.cs:201 | if (spread.SheetName == SpdSheet.shtSub) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefColumns.BasicACLR)].Bord… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-37d994d7 | this.Load 외 3 | GroupMenuAuth.cs:203 | if (spread.SheetName == SpdSheet.shtSub) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefColumns.BasicACLU)].Cell… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-129b01ac | this.Load 외 3 | GroupMenuAuth.cs:204 | if (spread.SheetName == SpdSheet.shtSub) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefColumns.BasicACLU)].Valu… | false | 그리드 속성/값 설정 |  |  |  |
| AC-8c2d3d00 | this.Load 외 3 | GroupMenuAuth.cs:205 | if (spread.SheetName == SpdSheet.shtSub) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefColumns.BasicACLU)].Bord… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-f85f65c4 | this.Load 외 3 | GroupMenuAuth.cs:207 | if (spread.SheetName == SpdSheet.shtSub) | GRID_INIT | spread.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## GroupMenuAuth.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0ffe1de | (진입점 미연결) | GroupMenuAuth.cs:477 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | POPUP | new MenuItemInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b2474a18 | (진입점 미연결) | GroupMenuAuth.cs:479 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_PROP | popup.Width | 970 | 속성 Width 설정 |  |  |  |
| AC-afb17005 | (진입점 미연결) | GroupMenuAuth.cs:480 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-618e3498 | (진입점 미연결) | GroupMenuAuth.cs:481 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-25a16c29 | (진입점 미연결) | GroupMenuAuth.cs:483 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5d1e9025 | (진입점 미연결) | GroupMenuAuth.cs:485 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-399bf268 | (진입점 미연결) | GroupMenuAuth.cs:489 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9d79b5a2 | (진입점 미연결) | GroupMenuAuth.cs:492 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | (DefColumns.GroupID, groupID) | 데이터 객체 조작/조회 |  |  |  |
| AC-de88e60f | (진입점 미연결) | GroupMenuAuth.cs:493 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | ("Level1Title", selMenuItem.Level1Title) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9249c95 | (진입점 미연결) | GroupMenuAuth.cs:494 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | ("Level2Title", selMenuItem.Level2Title) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cd7b42a | (진입점 미연결) | GroupMenuAuth.cs:495 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | ("Level1MenuID", selMenuItem.PrntMenuID) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f1c35cf | (진입점 미연결) | GroupMenuAuth.cs:496 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | (DefColumns.PrntMenuID, selMenuItem.PrntMenuID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0cffb4f | (진입점 미연결) | GroupMenuAuth.cs:497 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | (DefColumns.MenuID, selMenuItem.MenuID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d07fba45 | (진입점 미연결) | GroupMenuAuth.cs:498 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | (DefColumns.Title, selMenuItem.Title) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5ced644 | (진입점 미연결) | GroupMenuAuth.cs:499 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | (DefColumns.BasicACLC, true) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec5e2376 | (진입점 미연결) | GroupMenuAuth.cs:500 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | (DefColumns.BasicACLR, true) | 데이터 객체 조작/조회 |  |  |  |
| AC-39de5a21 | (진입점 미연결) | GroupMenuAuth.cs:501 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | (DefColumns.BasicACLU, true) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf92ec8d | (진입점 미연결) | GroupMenuAuth.cs:502 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | (DefColumns.BasicACLD, true) | 데이터 객체 조작/조회 |  |  |  |
| AC-05c15a4d | (진입점 미연결) | GroupMenuAuth.cs:503 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | DATA_OP | defaultData.Add | (DefColumns.UseYN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-fcc30011 | (진입점 미연결) | GroupMenuAuth.cs:505 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-ce519cdb | (진입점 미연결) | GroupMenuAuth.cs:508 | if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ fore… | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.GroupID), siSub.GetColumnIndex(DefColumns.Title)… | 그리드 편집 잠금/해제 |  |  |  |

## GroupMenuAuth.OpenFileUplad

진입점: this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetColumnIndex(DefHelpColumns.HELP_OPEN)) ▸ if (e.Column == siSub.GetColumnIndex(DefHelpColumns.HELP_UPLOAD))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbc56ec5 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:678 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-771e77d6 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:679 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1c8c2a8a | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:684 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-66c59240 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:685 | try | POPUP | ofp.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d8239656 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:687 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) | CALL_EXT | CommonUtils.CheckFileUpload | (ref ofp, ref msg, MenuName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46b4d6ac | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:690 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ if (checkResult == false) | MESSAGE | MessageHelper.GMessageBox | (msg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7f187c3 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:691 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ if (checkResult == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9117333f | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:694 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) | CALL_EXT | System.IO.Path.GetDirectoryName | (ofp.FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fded41ee | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:695 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) | CALL_EXT | System.IO.Path.GetFileName | (ofp.FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd86f003 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:698 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e94bee08 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:701 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-478c87da | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:702 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) | ENDPOINT | asyncProxy.ExecuteAsync | (() => DataService.FP_DataPush(path_directory, "GSCM_HELP", file_name, true, Filter) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62c07330 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:703 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ lambda | CALL_EXT | DataService.FP_DataPush | (path_directory, "GSCM_HELP", file_name, true, Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d270cd18 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:710 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ if (isSuccess) | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefHelpColumns.HELP_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-ce70df2a | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:711 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ if (isSuccess) | GRID_SET | dtFileExists.Rows[iRow][DefHelpColumns.HELP_YN] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-31bf274e | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:715 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ if (isSuccess) | ENDPOINT | asyncProxyBackup.ExecuteAsync | (() => DataService.FP_DataPush(path_directory, "GSCM_HELP_UPLOAD", file_name, true, Filter… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b0158d56 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:716 | try ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ if (isSuccess) ▸ lambda | CALL_EXT | DataService.FP_DataPush | (path_directory, "GSCM_HELP_UPLOAD", file_name, true, Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e35962d3 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:725 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-370d8c7d | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:729 | finally ▸ if (isSuccess) | MESSAGE | MessageHelper.GMessageBox | (message_003) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-27a52e7d | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:733 | finally ▸ else of (isSuccess) | MESSAGE | MessageHelper.GMessageBox | (CommonUtils.message_005) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ef60972 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:743 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-c8cdab07 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:745 | try | POPUP | ofd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b3f52ae5 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:747 | try ▸ if (ofd.ShowDialog() == DialogResult.OK) | CALL_EXT | CommonUtils.CheckFileUpload | (ref ofd, ref msg, MenuName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04437976 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:750 | try ▸ if (ofd.ShowDialog() == DialogResult.OK) ▸ if (checkResult == false) | MESSAGE | MessageHelper.GMessageBox | (msg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b1f82344 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:751 | try ▸ if (ofd.ShowDialog() == DialogResult.OK) ▸ if (checkResult == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fcf7b89 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:754 | try ▸ if (ofd.ShowDialog() == DialogResult.OK) | CALL_EXT | CommonUtils.SaveHelpFile | (ofd, ref msg) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fadb54ce | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:756 | try ▸ if (ofd.ShowDialog() == DialogResult.OK) ▸ if (CommonUtils.SaveHelpFile(ofd, ref msg)) | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefHelpColumns.HELP_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-c4cd6f89 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:757 | try ▸ if (ofd.ShowDialog() == DialogResult.OK) ▸ if (CommonUtils.SaveHelpFile(ofd, ref msg)) | GRID_SET | dtFileExists.Rows[iRow][DefHelpColumns.HELP_YN] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-5c17fdcd | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:759 | try ▸ if (ofd.ShowDialog() == DialogResult.OK) ▸ if (CommonUtils.SaveHelpFile(ofd, ref msg)) | MESSAGE | MessageHelper.GMessageBox | (message_003) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e506d498 | this.spdSub.CellClick [try ▸ else of (e.Column == siSub.GetC… | GroupMenuAuth.cs:763 | try ▸ if (ofd.ShowDialog() == DialogResult.OK) ▸ else of (CommonUtils.SaveHelpFile(ofd, ref msg)) | MESSAGE | MessageBox.Show | (msg, "Upload Error") | 메시지 표시 |  |  |  |

## GroupMenuAuth.OpenHelpFile

진입점: this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumnIndex(DefHelpColumns.HELP_OPEN))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92383a60 | this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumn… | GroupMenuAuth.cs:779 | try ▸ if (string.IsNullOrWhiteSpace(sFileName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfdd36b1 | this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumn… | GroupMenuAuth.cs:782 | try | CALL_EXT | CommonUtils.GetWebFullPath | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5d209a9 | this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumn… | GroupMenuAuth.cs:783 | try | CALL_EXT | CommonUtils.CheckExistsWebFile | (sUrl) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44bf648f | this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumn… | GroupMenuAuth.cs:785 | try ▸ if (CommonUtils.CheckExistsWebFile(sUrl) != "Y") | MESSAGE | MessageBox.Show | (CommonUtils.message_004) | 메시지 표시 |  |  |  |
| AC-dee5a012 | this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumn… | GroupMenuAuth.cs:786 | try ▸ if (CommonUtils.CheckExistsWebFile(sUrl) != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-632c25ba | this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumn… | GroupMenuAuth.cs:790 | try | CALL_BASE | base.AddHelpButton | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e0e8525 | this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumn… | GroupMenuAuth.cs:798 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## GroupMenuAuth.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffa1df8b | SaveButton | GroupMenuAuth.cs:390 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (saveDSSub != null) | STATE_RESET | saveDSSub.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-10c117be | SaveButton | GroupMenuAuth.cs:399 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDSSub.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-40036f00 | SaveButton | GroupMenuAuth.cs:403 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-ed8662f8 | SaveButton | GroupMenuAuth.cs:404 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.GroupID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.GroupID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05243258 | SaveButton | GroupMenuAuth.cs:405 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.MenuID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.MenuID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6983668b | SaveButton | GroupMenuAuth.cs:406 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.BasicACLC] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.BasicACLU)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d7c82d4d | SaveButton | GroupMenuAuth.cs:407 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.BasicACLR] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.BasicACLR)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ed44f119 | SaveButton | GroupMenuAuth.cs:408 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.BasicACLU] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.BasicACLU)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-28234461 | SaveButton | GroupMenuAuth.cs:409 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.BasicACLD] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.BasicACLU)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a8faf4ae | SaveButton | GroupMenuAuth.cs:410 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ExtendedACL] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b392c1a1 | SaveButton | GroupMenuAuth.cs:411 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.UseYN] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.UseYN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4b21f2c2 | SaveButton | GroupMenuAuth.cs:412 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-259da6f9 | SaveButton | GroupMenuAuth.cs:414 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDSSub.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba63f99c | SaveButton | GroupMenuAuth.cs:417 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | saveDSSub.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-09c40736 | SaveButton | GroupMenuAuth.cs:420 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | DATA_OP | a.Field | (DefColumns.GroupID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6bf3303 | SaveButton | GroupMenuAuth.cs:421 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | DATA_OP | a.Field | (DefColumns.MenuID) | 데이터 객체 조작/조회 |  |  |  |
| AC-f95e7f6f | SaveButton | GroupMenuAuth.cs:432 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14b73204 | SaveButton | GroupMenuAuth.cs:433 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8dbba3c9 | SaveButton | GroupMenuAuth.cs:442 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ foreach (DataRow row in saveDSSub.T… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-08b9c9a8 | SaveButton | GroupMenuAuth.cs:443 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ foreach (DataRow row in saveDSSub.T… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-caf6c534 | SaveButton | GroupMenuAuth.cs:444 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ foreach (DataRow row in saveDSSub.T… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e076dabf | SaveButton | GroupMenuAuth.cs:448 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveGroupMenuAuth" | 속성 InsertQueryId 설정 |  |  |  |
| AC-c905d0a1 | SaveButton | GroupMenuAuth.cs:449 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteGroupMenuAuth" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-9421f779 | SaveButton | GroupMenuAuth.cs:450 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveGroupMenuAuth" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-25a715c9 | SaveButton | GroupMenuAuth.cs:451 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.DataSet | saveDSSub.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-09840ae6 | SaveButton | GroupMenuAuth.cs:451 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | CALL_EXT | saveDSSub.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-80d70a8e | SaveButton | GroupMenuAuth.cs:455 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-975cb28e | SaveButton | GroupMenuAuth.cs:459 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-575cfa89 | SaveButton | GroupMenuAuth.cs:459 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-914e013f | SaveButton | GroupMenuAuth.cs:464 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## GroupMenuAuth.SetAddColumnHelp

진입점: OnShown [try ▸ if (ds != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51669591 | OnShown [try ▸ if (ds != null)] | GroupMenuAuth.cs:563 | try | DATA_OP | dtFileExists.Columns.Contains | (DefHelpColumns.HELP_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2dca820 | OnShown [try ▸ if (ds != null)] | GroupMenuAuth.cs:565 | try ▸ if (!dtFileExists.Columns.Contains(DefHelpColumns.HELP_YN)) | DATA_OP | dtFileExists.Columns.Add | (DefHelpColumns.HELP_YN, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## GroupMenuAuth.SetCheckExistsHelpFile

진입점: this.Load [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0)] / this.spdMain.CellDoubleClick [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0)] / FindButton [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0)] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0)] / OnShown [try ▸ if (ds != null) ▸ if (CheckAuthManual())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bb45903 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:614 | try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ for (i <= dtFileExists.Rows.Count) | GRID_SET | dtFileExists.Rows[i][DefHelpColumns.HELP_YN] | strExist | 그리드 속성/값 설정 |  |  |  |
| AC-35cb782f | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:640 | try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ if (iColHELP_YN <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3385934a | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:646 | try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ for (i < dtFileExists.Rows.Count) | GRID_SET | siSub.SetValue | (i, iColHELP_YN, strExist) | 그리드 값 설정 |  |  |  |
| AC-704bb0c2 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:647 | try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ for (i < dtFileExists.Rows.Count) | GRID_SET | siSub.SetValue | (i, iColHELP_LastUpdate, lastUpdate) | 그리드 값 설정 |  |  |  |

## GroupMenuAuth.SetFileExists

진입점: this.Load [finally ▸ if (dtFileExists == null \|\| dtFileExists.Rows.Count == 0)] / this.spdMain.CellDoubleClick [finally ▸ if (dtFileExists == null \|\| dtFileExists.Rows.Count == 0)] / FindButton [finally ▸ if (dtFileExists == null \|\| dtFileExists.Rows.Count == 0)] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ finally ▸ if (dtFileExists == null \|\| dtFileExists.Rows.Count == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3276ac84 | this.Load [finally ▸ if (dtFileExists == null \|\| dtFileExi… 외 3 | GroupMenuAuth.cs:575 |  | FLAG | dtFileExists | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-96e58bfa | this.Load [finally ▸ if (dtFileExists == null \|\| dtFileExi… 외 3 | GroupMenuAuth.cs:575 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-676b9ae1 | this.Load [finally ▸ if (dtFileExists == null \|\| dtFileExi… 외 3 | GroupMenuAuth.cs:577 |  | DATA_OP | dtFileExists.Columns.Contains | (DefHelpColumns.HELP_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7f9b60e | this.Load [finally ▸ if (dtFileExists == null \|\| dtFileExi… 외 3 | GroupMenuAuth.cs:579 | if (!dtFileExists.Columns.Contains(DefHelpColumns.HELP_YN)) | DATA_OP | dtFileExists.Columns.Add | (DefHelpColumns.HELP_YN, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## GroupMenuAuth.SetFocusGroupID

진입점: this.Load [try] / this.spdMain.CellDoubleClick [try] / FindButton [try] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ try] / OnShown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fff9fe7 | this.Load [try] 외 4 | GroupMenuAuth.cs:340 |  | FLAG | focusGroupID | groupID | 화면 필드/플래그 변경 |  |  |  |

## GroupMenuAuth.SetHelpFileList

진입점: this.Load [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0)] / this.spdMain.CellDoubleClick [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0)] / FindButton [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0)] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ f…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3e19fa1 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:810 | try | DATA_OP | dictParam["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-29b2650e | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:812 | try | CALL_EXT | DataService.FP_FileDataClient | ("GSCM_HELP", "none", dictParam) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ac0491d | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:816 | try ▸ if (CommonUtils.CheckDataEmpty(ret) == false) | FLAG | HelpFileList | CommonUtils.ConvertFileList(ret, "shortname", false) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fd000b0 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:816 | try ▸ if (CommonUtils.CheckDataEmpty(ret) == false) | CALL_EXT | CommonUtils.ConvertFileList | (ret, "shortname", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-10fbc94f | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 4 | GroupMenuAuth.cs:817 | try ▸ if (CommonUtils.CheckDataEmpty(ret) == false) | FLAG | dtHelpFile | ConvertHelpFile(ret.Tables[0]) | 화면 필드/플래그 변경 |  |  |  |

## GroupMenuAuth.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc3dcffa | this.spdMain.CellDoubleClick | GroupMenuAuth.cs:875 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3845248a | this.spdMain.CellDoubleClick | GroupMenuAuth.cs:877 |  | FLAG | groupID | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.GroupID)) | 화면 필드/플래그 변경 |  |  |  |

## GroupMenuAuth.SpdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d63d3a7e | this.spdSub.CellClick | GroupMenuAuth.cs:891 | try ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13debcc0 | this.spdSub.CellClick | GroupMenuAuth.cs:894 | try ▸ if (IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## GroupMenuAuth.WriteLog

진입점: this.Load [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ if (HelpFileList != null)] / this.spdMain.CellDoubleClick [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != null && dtFileExists.Rows.Count > 0) ▸ if (HelpFileList != null)] / this.spdSub.CellClick [try ▸ if (e.Column == siSub.GetColumnIndex(DefHelpColumns.HELP_OPEN)) ▸ try] / FindButton [finally ▸ else of (dtFileExists == null \|\| dtFileExists.Rows.Count == 0) ▸ try ▸ if (dtFileExists != …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6ad5223 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 5 | GroupMenuAuth.cs:860 | try | CALL_EXT | FoxLogManager.GetLogger | ("GSCM.Log") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b8b36a6 | this.Load [finally ▸ else of (dtFileExists == null \|\| dtFi… 외 5 | GroupMenuAuth.cs:862 | try | CALL_EXT | log.Write | (FoxLogLevel.Error, message) | ⚠ 의미 확인 필요 |  |  |  |

