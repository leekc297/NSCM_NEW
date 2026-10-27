# AS-IS 액션 대조표 — GSCM_MENUITEMINFO

> 원천: `Doc/asisfacts/screens/GSCM_MENUITEMINFO/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 172행 · 메서드 15 · 종류 GRID_INIT 58 · DATA_OP 42 · UI_PROP 12 · RETURN 10 · CALL_EXT 9 · GRID_LOCK 8 · FLAG 7 · GRID_SET 7 · POPUP 6 · ENDPOINT 5 · UI_MISC 3 · MESSAGE 2 · STATE 1 · GRID_BIND 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 9


## MenuItemInfo.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8550ccf9 | this.Load | MenuItemInfo.cs:122 |  | GRID_INIT | AddSheet | (spdLevel1, SpdSheet.shtLevel1, SpdSheet.shtLevel1, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6db42c81 | this.Load | MenuItemInfo.cs:123 |  | FLAG | siLevel1 | GetSheetInfo(spdLevel1.Name, spdLevel1.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-402c8aa9 | this.Load | MenuItemInfo.cs:125 |  | GRID_INIT | AddSheet | (spdLevel2, SpdSheet.shtLevel2, SpdSheet.shtLevel2, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4e95f512 | this.Load | MenuItemInfo.cs:126 |  | FLAG | siLevel2 | GetSheetInfo(spdLevel2.Name, spdLevel2.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f8663350 | this.Load | MenuItemInfo.cs:128 |  | GRID_INIT | AddSheet | (spdLevel3, SpdSheet.shtLevel3, SpdSheet.shtLevel3, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7ab72eeb | this.Load | MenuItemInfo.cs:129 |  | FLAG | siLevel3 | GetSheetInfo(spdLevel3.Name, spdLevel3.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-656dad51 | this.Load | MenuItemInfo.cs:131 |  | GRID_INIT | siLevel1.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## MenuItemInfo.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1628b6cf | this.Load | MenuItemInfo.cs:117 |  | STATE | this.usrPanel.Visible | false | 컨트롤 상태 Visible |  |  |  |

## MenuItemInfo.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f79f140c | DeleteButton | MenuItemInfo.cs:247 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": | DATA_OP | siLevel1.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5bb6d79e | DeleteButton | MenuItemInfo.cs:248 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": | DATA_OP | siLevel2.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4ad2b561 | DeleteButton | MenuItemInfo.cs:249 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": | DATA_OP | siLevel3.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## MenuItemInfo.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a738214 | Dispose | MenuItemInfo.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## MenuItemInfo.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cb3032a | EditButton | MenuItemInfo.cs:261 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": | GRID_LOCK | siLevel1.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-90459489 | EditButton | MenuItemInfo.cs:264 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": | GRID_LOCK | siLevel2.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e6b68084 | EditButton | MenuItemInfo.cs:265 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": | GRID_LOCK | siLevel2.LockColumn | (0, siLevel2.GetColumnIndex(DefColumns.PrntMenuID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1c995afe | EditButton | MenuItemInfo.cs:268 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": | GRID_LOCK | siLevel3.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8da61b9c | EditButton | MenuItemInfo.cs:269 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": | GRID_LOCK | siLevel3.LockColumn | (0, siLevel3.GetColumnIndex(DefColumns.PrntMenuID), true) | 그리드 편집 잠금/해제 |  |  |  |

## MenuItemInfo.FindData

진입점: this.Load / this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel2.CellDoubleClick [if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / FindButton / SaveButton [if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-208a4aef | this.Load 외 4 | MenuItemInfo.cs:311 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1b72ac2b | this.Load 외 4 | MenuItemInfo.cs:315 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetMenuItemInfoList") ⇒ SystemManager.UP_FX_GetMenuItemInfoList | 엔드포인트 요청 생성 |  |  |  |
| AC-134ea601 | this.Load 외 4 | MenuItemInfo.cs:316 | lambda | DATA_OP | request.Parameters["MenuLevel"] | level | 행/컬럼 값 대입 |  |  |  |
| AC-fd2a5e7a | this.Load 외 4 | MenuItemInfo.cs:317 | lambda | DATA_OP | request.Parameters["PrntMenuID"] | prntMenuID | 행/컬럼 값 대입 |  |  |  |
| AC-a3c30ac1 | this.Load 외 4 | MenuItemInfo.cs:318 | lambda | DATA_OP | request.Parameters["MenuID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-6a988210 | this.Load 외 4 | MenuItemInfo.cs:319 | lambda | DATA_OP | request.Parameters["ProgramID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-acb80c8c | this.Load 외 4 | MenuItemInfo.cs:320 | lambda | DATA_OP | request.Parameters["Title"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-20d71dc6 | this.Load 외 4 | MenuItemInfo.cs:322 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-41603d04 | this.Load 외 4 | MenuItemInfo.cs:324 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9da80124 | this.Load 외 4 | MenuItemInfo.cs:332 | if (level == 3) ▸ foreach (DataRow dr in ds.Tables[0].Rows) | DATA_OP | dr["Level1MenuID"] | level1MenuID | 행/컬럼 값 대입 |  |  |  |
| AC-66bb447b | this.Load 외 4 | MenuItemInfo.cs:336 |  | GRID_BIND | spreadLevel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-396ce739 | this.Load 외 4 | MenuItemInfo.cs:337 |  | GRID_LOCK | spreadLevel.LockColumn | (0, spreadLevel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f8849c3 | this.Load 외 4 | MenuItemInfo.cs:340 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-dc15c49f | this.Load 외 4 | MenuItemInfo.cs:343 |  | GRID_INIT | spreadLevel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-14875c2e | this.Load 외 4 | MenuItemInfo.cs:348 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-f6439f3e | this.Load 외 4 | MenuItemInfo.cs:348 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6386528c | this.Load 외 4 | MenuItemInfo.cs:349 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## MenuItemInfo.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb86be6b | this.Load | MenuItemInfo.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## MenuItemInfo.IconFileDialog

진입점: this.spdLevel2.CellClick [if (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel2.GetColumnIndex(DefColumns.File))] / this.spdLevel3.CellClick [if (siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel3.GetColumnIndex(DefColumns.File))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70ee04e6 | this.spdLevel2.CellClick [if (siLevel2.ActiveSheet.Columns[C… 외 1 | MenuItemInfo.cs:550 |  | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-26e2d49b | this.spdLevel2.CellClick [if (siLevel2.ActiveSheet.Columns[C… 외 1 | MenuItemInfo.cs:551 |  | UI_PROP | openDialog.AutoUpgradeEnabled | false | 속성 AutoUpgradeEnabled 설정 |  |  |  |
| AC-8f7d302c | this.spdLevel2.CellClick [if (siLevel2.ActiveSheet.Columns[C… 외 1 | MenuItemInfo.cs:553 |  | UI_PROP | openDialog.Filter | "Icon File\|*.ico" | 속성 Filter 설정 |  |  |  |
| AC-a372786d | this.spdLevel2.CellClick [if (siLevel2.ActiveSheet.Columns[C… 외 1 | MenuItemInfo.cs:555 |  | POPUP | openDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-faf3b9f3 | this.spdLevel2.CellClick [if (siLevel2.ActiveSheet.Columns[C… 외 1 | MenuItemInfo.cs:560 |  | RETURN | return filePath; |  | 처리 중단/반환 |  |  |  |

## MenuItemInfo.InitSpread

진입점: this.Load / this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (level) case 1:] / this.spdLevel2.CellDoubleClick [if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (level) case 1:] / FindButton [switch (level) case 1:] / SaveButton [if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ switch (level) case 1:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f05d0f04 | this.Load 외 4 | MenuItemInfo.cs:145 | if (level == 1) | GRID_INIT | siLevel1.InitSheet | (siLevel1.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d65d579b | this.Load 외 4 | MenuItemInfo.cs:147 | if (level == 1) | GRID_INIT | siLevel1.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ff80fdd1 | this.Load 외 4 | MenuItemInfo.cs:148 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Level1MenuID*", DefColumns.MenuID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9ccb3a37 | this.Load 외 4 | MenuItemInfo.cs:149 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("PrntMenuID", DefColumns.PrntMenuID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8d1f556 | this.Load 외 4 | MenuItemInfo.cs:150 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Title*", DefColumns.Title, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0662d564 | this.Load 외 4 | MenuItemInfo.cs:151 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Group Title*", DefColumns.Description, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5da04876 | this.Load 외 4 | MenuItemInfo.cs:152 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("ProgramID", DefColumns.ProgramID, FPMerge.None, 150, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da90d253 | this.Load 외 4 | MenuItemInfo.cs:153 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Parameter", DefColumns.Parameter, FPMerge.None, 200, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5fd1ca48 | this.Load 외 4 | MenuItemInfo.cs:154 | if (level == 1) | GRID_INIT | siLevel1.AddNumColumn | ("SortOrder*", DefColumns.SortOrder, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c666fba | this.Load 외 4 | MenuItemInfo.cs:155 | if (level == 1) | GRID_INIT | siLevel1.AddNumColumn | ("MenuLevel", DefColumns.MenuLevel, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fe6432fb | this.Load 외 4 | MenuItemInfo.cs:156 | if (level == 1) | GRID_INIT | siLevel1.AddNumColumn | ("MenuAction", DefColumns.MenuAction, FPMerge.None, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d8f6010 | this.Load 외 4 | MenuItemInfo.cs:157 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("IconName", DefColumns.IconName, FPMerge.None, 150, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85ae916b | this.Load 외 4 | MenuItemInfo.cs:158 | if (level == 1) | GRID_INIT | siLevel1.AddComboColumn | ("UseYN*", DefColumns.UseYN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3150d02 | this.Load 외 4 | MenuItemInfo.cs:160 | if (level == 1) | GRID_INIT | siLevel1.Freeze | (0, siLevel1.GetColumnIndex(DefColumns.MenuID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d979cc47 | this.Load 외 4 | MenuItemInfo.cs:162 | if (level == 1) | GRID_INIT | siLevel1.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-28b49ffb | this.Load 외 4 | MenuItemInfo.cs:168 | if (level == 2) | GRID_INIT | siLevel2.InitSheet | (siLevel2.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-696ad6f5 | this.Load 외 4 | MenuItemInfo.cs:170 | if (level == 2) | GRID_INIT | siLevel2.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fd484d48 | this.Load 외 4 | MenuItemInfo.cs:171 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Level1MenuID", DefColumns.PrntMenuID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-57556877 | this.Load 외 4 | MenuItemInfo.cs:172 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Level2MenuID*", DefColumns.MenuID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ba12b23 | this.Load 외 4 | MenuItemInfo.cs:173 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Title*", DefColumns.Title, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0221beaf | this.Load 외 4 | MenuItemInfo.cs:174 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Group Title", DefColumns.Description, FPMerge.None, 150, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6dc4bab | this.Load 외 4 | MenuItemInfo.cs:175 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("ProgramID", DefColumns.ProgramID, FPMerge.None, 150, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f056554 | this.Load 외 4 | MenuItemInfo.cs:176 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Parameter", DefColumns.Parameter, FPMerge.None, 200, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eef14966 | this.Load 외 4 | MenuItemInfo.cs:177 | if (level == 2) | GRID_INIT | siLevel2.AddNumColumn | ("SortOrder*", DefColumns.SortOrder, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4de7b70e | this.Load 외 4 | MenuItemInfo.cs:178 | if (level == 2) | GRID_INIT | siLevel2.AddNumColumn | ("MenuLevel", DefColumns.MenuLevel, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ebbc9662 | this.Load 외 4 | MenuItemInfo.cs:179 | if (level == 2) | GRID_INIT | siLevel2.AddNumColumn | ("MenuAction", DefColumns.MenuAction, FPMerge.None, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-653965bb | this.Load 외 4 | MenuItemInfo.cs:180 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("IconName", DefColumns.IconName, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74a318b1 | this.Load 외 4 | MenuItemInfo.cs:181 | if (level == 2) | GRID_INIT | siLevel2.AddButtonColumn | ("File", DefColumns.File, "...", FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f26acfc | this.Load 외 4 | MenuItemInfo.cs:182 | if (level == 2) | GRID_INIT | siLevel2.AddComboColumn | ("UseYN*", DefColumns.UseYN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a34ae8d9 | this.Load 외 4 | MenuItemInfo.cs:184 | if (level == 2) | CALL_EXT | siLevel2.ColumnHeaderSpanRow | (0, siLevel2.GetColumnIndex(DefColumns.MenuAction)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7a73a1c | this.Load 외 4 | MenuItemInfo.cs:185 | if (level == 2) | GRID_INIT | siLevel2.ColumnHeaderSpan | (0, siLevel2.GetColumnIndex(DefColumns.IconName), 1, 2, 25, "Icon", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28444e94 | this.Load 외 4 | MenuItemInfo.cs:186 | if (level == 2) | CALL_EXT | siLevel2.ColumnHeaderSpanRow | (siLevel2.GetColumnIndex(DefColumns.UseYN), siLevel2.GetColumnIndex(DefColumns.UseYN)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-59eee663 | this.Load 외 4 | MenuItemInfo.cs:188 | if (level == 2) | GRID_INIT | siLevel2.Freeze | (0, siLevel2.GetColumnIndex(DefColumns.PrntMenuID) + 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0d7e73df | this.Load 외 4 | MenuItemInfo.cs:190 | if (level == 2) | GRID_INIT | siLevel2.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2538339f | this.Load 외 4 | MenuItemInfo.cs:196 | if (level == 3) | GRID_INIT | siLevel3.InitSheet | (siLevel3.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-4965a66d | this.Load 외 4 | MenuItemInfo.cs:198 | if (level == 3) | GRID_INIT | siLevel3.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1ae0ff83 | this.Load 외 4 | MenuItemInfo.cs:199 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Level1MenuID", "Level1MenuID", FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b144121c | this.Load 외 4 | MenuItemInfo.cs:200 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Level2MenuID", DefColumns.PrntMenuID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9c397f2 | this.Load 외 4 | MenuItemInfo.cs:201 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Level3MenuID*", DefColumns.MenuID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42cf2879 | this.Load 외 4 | MenuItemInfo.cs:202 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Title*", DefColumns.Title, FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-62820f79 | this.Load 외 4 | MenuItemInfo.cs:203 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Group Title*", DefColumns.Description, FPMerge.None, 150, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-243f60ab | this.Load 외 4 | MenuItemInfo.cs:204 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("ProgramID*", DefColumns.ProgramID, FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b34a865 | this.Load 외 4 | MenuItemInfo.cs:205 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("ProgramName*", DefColumns.ProgramName, FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6a3d08e | this.Load 외 4 | MenuItemInfo.cs:206 | if (level == 3) | GRID_INIT | siLevel3.AddButtonColumn | ("Search*", DefColumns.ProgramPopup, "...", FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa2bd6dc | this.Load 외 4 | MenuItemInfo.cs:207 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Parameter", DefColumns.Parameter, FPMerge.None, 200, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa50dbf0 | this.Load 외 4 | MenuItemInfo.cs:208 | if (level == 3) | GRID_INIT | siLevel3.AddNumColumn | ("SortOrder*", DefColumns.SortOrder, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f5c9e31 | this.Load 외 4 | MenuItemInfo.cs:209 | if (level == 3) | GRID_INIT | siLevel3.AddNumColumn | ("MenuLevel", DefColumns.MenuLevel, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb971131 | this.Load 외 4 | MenuItemInfo.cs:210 | if (level == 3) | GRID_INIT | siLevel3.AddNumColumn | ("MenuAction", DefColumns.MenuAction, FPMerge.None, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf6e2253 | this.Load 외 4 | MenuItemInfo.cs:211 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("IconName", DefColumns.IconName, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3021ebbd | this.Load 외 4 | MenuItemInfo.cs:212 | if (level == 3) | GRID_INIT | siLevel3.AddButtonColumn | ("File", DefColumns.File, "...", FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee9745ff | this.Load 외 4 | MenuItemInfo.cs:213 | if (level == 3) | GRID_INIT | siLevel3.AddComboColumn | ("UseYN*", DefColumns.UseYN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5185a7fc | this.Load 외 4 | MenuItemInfo.cs:215 | if (level == 3) | CALL_EXT | siLevel3.ColumnHeaderSpanRow | (0, siLevel3.GetColumnIndex(DefColumns.Description)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c43a1fd9 | this.Load 외 4 | MenuItemInfo.cs:216 | if (level == 3) | GRID_INIT | siLevel3.ColumnHeaderSpan | (0, siLevel3.GetColumnIndex(DefColumns.ProgramID), 1, 3, 25, "Program", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-69302155 | this.Load 외 4 | MenuItemInfo.cs:217 | if (level == 3) | CALL_EXT | siLevel3.ColumnHeaderSpanRow | (siLevel3.GetColumnIndex(DefColumns.Parameter), siLevel3.GetColumnIndex(DefColumns.MenuAct… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8704dd9 | this.Load 외 4 | MenuItemInfo.cs:218 | if (level == 3) | GRID_INIT | siLevel3.ColumnHeaderSpan | (0, siLevel3.GetColumnIndex(DefColumns.IconName), 1, 2, 25, "Icon", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53a64503 | this.Load 외 4 | MenuItemInfo.cs:219 | if (level == 3) | CALL_EXT | siLevel3.ColumnHeaderSpanRow | (siLevel3.GetColumnIndex(DefColumns.UseYN), siLevel3.GetColumnIndex(DefColumns.UseYN)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee4e3320 | this.Load 외 4 | MenuItemInfo.cs:221 | if (level == 3) | GRID_INIT | siLevel3.Freeze | (0, siLevel3.GetColumnIndex(DefColumns.PrntMenuID) + 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-79e6df80 | this.Load 외 4 | MenuItemInfo.cs:223 | if (level == 3) | GRID_INIT | siLevel3.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## MenuItemInfo.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0263a466 | InsertButton | MenuItemInfo.cs:498 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ if (string.IsNullOrEmpty(level1MenuID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43fc12ad | InsertButton | MenuItemInfo.cs:506 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ if (string.IsNullOrEmpty(level2MenuID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-942a0b79 | InsertButton | MenuItemInfo.cs:517 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | ds.Tables[0].AsEnumerable().Select | (a => a.Field<int>("SortOrder")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d5b58fa | InsertButton | MenuItemInfo.cs:517 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | DATA_OP | a.Field | ("SortOrder") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ad175bd | InsertButton | MenuItemInfo.cs:520 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (ds.Tables[0].AsEnumerable().Select(a => a.Field<in… | DATA_OP | ds.Tables[0].AsEnumerable().Select | (a => a.Field<int>("SortOrder")) | 데이터 객체 조작/조회 |  |  |  |
| AC-86e4e8e7 | InsertButton | MenuItemInfo.cs:520 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (ds.Tables[0].AsEnumerable().Select(a => a.Field<in… | DATA_OP | a.Field | ("SortOrder") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd4cfc6e | InsertButton | MenuItemInfo.cs:522 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | spreadLevel.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e9826abc | InsertButton | MenuItemInfo.cs:526 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (fps.Name == "spdLevel2") | DATA_OP | defaultData.Add | (DefColumns.PrntMenuID, level1MenuID) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c99c3d4 | InsertButton | MenuItemInfo.cs:530 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (fps.Name == "spdLevel3") | DATA_OP | defaultData.Add | ("Level1MenuID", level1MenuID) | 데이터 객체 조작/조회 |  |  |  |
| AC-370b30f5 | InsertButton | MenuItemInfo.cs:531 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (fps.Name == "spdLevel3") | DATA_OP | defaultData.Add | (DefColumns.PrntMenuID, level2MenuID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5003993 | InsertButton | MenuItemInfo.cs:533 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.SortOrder, sortOrder) | 데이터 객체 조작/조회 |  |  |  |
| AC-206a7ee2 | InsertButton | MenuItemInfo.cs:534 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.UseYN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-0121144a | InsertButton | MenuItemInfo.cs:536 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | GRID_SET | spreadLevel.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-28d51090 | InsertButton | MenuItemInfo.cs:540 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (fps.Name == "spdLevel2") | GRID_LOCK | spreadLevel.LockRange | (insCell, spreadLevel.GetColumnIndex(DefColumns.PrntMenuID), spreadLevel.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3755bf0 | InsertButton | MenuItemInfo.cs:542 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel2") ▸ if (fps.Name == "spdLev… | GRID_LOCK | spreadLevel.LockRange | (insCell, spreadLevel.GetColumnIndex("Level1MenuID"), spreadLevel.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |

## MenuItemInfo.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d27117f | SaveButton | MenuItemInfo.cs:386 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-bbda86e9 | SaveButton | MenuItemInfo.cs:395 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c2bb7ae0 | SaveButton | MenuItemInfo.cs:397 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-ded9c079 | SaveButton | MenuItemInfo.cs:398 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.MenuID] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.MenuID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b7497c6 | SaveButton | MenuItemInfo.cs:399 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ProgramID] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.ProgramID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57132ced | SaveButton | MenuItemInfo.cs:400 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.PrntMenuID] | prntMenuID | 행/컬럼 값 대입 |  |  |  |
| AC-deb58bca | SaveButton | MenuItemInfo.cs:401 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.Title] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.Title)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-148e40a1 | SaveButton | MenuItemInfo.cs:402 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.Description] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.Description)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d1aa370f | SaveButton | MenuItemInfo.cs:403 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.Parameter] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.Parameter)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06733b84 | SaveButton | MenuItemInfo.cs:404 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SortOrder] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.SortOrder)).ToString() != ""… | 행/컬럼 값 대입 |  |  |  |
| AC-b49e27a8 | SaveButton | MenuItemInfo.cs:405 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.MenuLevel] | level | 행/컬럼 값 대입 |  |  |  |
| AC-345d2a16 | SaveButton | MenuItemInfo.cs:412 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) ▸ if (sptIconName.C… | DATA_OP | dr[DefColumns.IconName] | sptIconName[sptIconName.Count() - 1] | 행/컬럼 값 대입 |  |  |  |
| AC-a8b20219 | SaveButton | MenuItemInfo.cs:414 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) ▸ if (sptIconName.C… | CALL_EXT | File.ReadAllBytes | (iconName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7bf3f45d | SaveButton | MenuItemInfo.cs:415 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) ▸ if (sptIconName.C… | DATA_OP | dr[DefColumns.Icon] | imgData | 행/컬럼 값 대입 |  |  |  |
| AC-41395922 | SaveButton | MenuItemInfo.cs:419 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) ▸ else of (sptIconN… | DATA_OP | dr[DefColumns.IconName] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.IconName)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d2496072 | SaveButton | MenuItemInfo.cs:420 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) ▸ else of (sptIconN… | DATA_OP | dr[DefColumns.Icon] | null | 행/컬럼 값 대입 |  |  |  |
| AC-38bf70bf | SaveButton | MenuItemInfo.cs:423 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.UseYN] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.UseYN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a7b7e02d | SaveButton | MenuItemInfo.cs:424 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d8f2d819 | SaveButton | MenuItemInfo.cs:426 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-87f4fd67 | SaveButton | MenuItemInfo.cs:429 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2b4ef3ef | SaveButton | MenuItemInfo.cs:432 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | DATA_OP | a.Field | (DefColumns.MenuID) | 데이터 객체 조작/조회 |  |  |  |
| AC-89d9b6e3 | SaveButton | MenuItemInfo.cs:433 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | DATA_OP | a.Field | (DefColumns.Title) | 데이터 객체 조작/조회 |  |  |  |
| AC-2000d512 | SaveButton | MenuItemInfo.cs:444 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-642725f0 | SaveButton | MenuItemInfo.cs:445 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26013e43 | SaveButton | MenuItemInfo.cs:454 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (ro… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b401dda | SaveButton | MenuItemInfo.cs:455 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (ro… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d29371d6 | SaveButton | MenuItemInfo.cs:456 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (ro… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-98836665 | SaveButton | MenuItemInfo.cs:460 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveMenuItemInfo" | 속성 InsertQueryId 설정 |  |  |  |
| AC-1662142f | SaveButton | MenuItemInfo.cs:461 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteMenuItemInfo" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-79af0082 | SaveButton | MenuItemInfo.cs:462 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveMenuItemInfo" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-24822f81 | SaveButton | MenuItemInfo.cs:463 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-9fedc08d | SaveButton | MenuItemInfo.cs:463 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aca865a6 | SaveButton | MenuItemInfo.cs:467 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-56a43c3a | SaveButton | MenuItemInfo.cs:471 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-925916e8 | SaveButton | MenuItemInfo.cs:471 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-e09f045a | SaveButton | MenuItemInfo.cs:476 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## MenuItemInfo.SpdLevel1_CellDoubleClick

진입점: this.spdLevel1.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5b41dea | this.spdLevel1.CellDoubleClick | MenuItemInfo.cs:570 | if (siLevel1.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d8be18f | this.spdLevel1.CellDoubleClick | MenuItemInfo.cs:577 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel1.GetText(e.Row, siLevel1.GetColumnIndex(DefColumns.MenuID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-9ea22f22 | this.spdLevel1.CellDoubleClick | MenuItemInfo.cs:580 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level2MenuID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## MenuItemInfo.SpdLevel2_CellClick

진입점: this.spdLevel2.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ee49c05 | this.spdLevel2.CellClick | MenuItemInfo.cs:599 | if (siLevel2.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afde33a9 | this.spdLevel2.CellClick | MenuItemInfo.cs:607 | if (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel2.GetColumnIndex(DefColumns.File)) | GRID_SET | siLevel2.SetValue | (e.Row, siLevel2.GetColumnIndex(DefColumns.IconName), filePath) | 그리드 값 설정 |  |  |  |
| AC-bcd2438b | this.spdLevel2.CellClick | MenuItemInfo.cs:612 | if (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel2.GetColumnIndex(DefColumns.ProgramPopup)) | POPUP | new ProgramInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4792ed4e | this.spdLevel2.CellClick | MenuItemInfo.cs:615 | if (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel2.GetColumnIndex(DefColumns.ProgramPopup)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-898580ee | this.spdLevel2.CellClick | MenuItemInfo.cs:616 | if (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel2.GetColumnIndex(DefColumns.ProgramPopup)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-62c4464b | this.spdLevel2.CellClick | MenuItemInfo.cs:617 | if (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel2.GetColumnIndex(DefColumns.ProgramPopup)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-65f10f9c | this.spdLevel2.CellClick | MenuItemInfo.cs:619 | if (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel2.GetColumnIndex(DefColumns.ProgramPopup)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-392ce461 | this.spdLevel2.CellClick | MenuItemInfo.cs:621 | if (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel2.GetColumnIndex(DefColumns.ProgramPopup)) ▸ if… | GRID_SET | siLevel2.SetValue | (e.Row, siLevel2.GetColumnIndex(DefColumns.ProgramID), popup.ProgramID) | 그리드 값 설정 |  |  |  |
| AC-6a6c8491 | this.spdLevel2.CellClick | MenuItemInfo.cs:622 | if (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel2.GetColumnIndex(DefColumns.ProgramPopup)) ▸ if… | GRID_SET | siLevel2.SetValue | (e.Row, siLevel2.GetColumnIndex(DefColumns.ProgramName), popup.ProgramName) | 그리드 값 설정 |  |  |  |

## MenuItemInfo.SpdLevel2_CellDoubleClick

진입점: this.spdLevel2.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc9014d7 | this.spdLevel2.CellDoubleClick | MenuItemInfo.cs:587 | if (siLevel2.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47b534a0 | this.spdLevel2.CellDoubleClick | MenuItemInfo.cs:591 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level2MenuID | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.MenuID)) | 화면 필드/플래그 변경 |  |  |  |

## MenuItemInfo.SpdLevel3_CellClick

진입점: this.spdLevel3.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd82a2ba | this.spdLevel3.CellClick | MenuItemInfo.cs:634 | if (siLevel3.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dcdf1eed | this.spdLevel3.CellClick | MenuItemInfo.cs:642 | if (siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel3.GetColumnIndex(DefColumns.File)) | GRID_SET | siLevel3.SetValue | (e.Row, siLevel3.GetColumnIndex(DefColumns.IconName), filePath) | 그리드 값 설정 |  |  |  |
| AC-d65f26f1 | this.spdLevel3.CellClick | MenuItemInfo.cs:647 | if (siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel3.GetColumnIndex(DefColumns.ProgramPopup)) | POPUP | new ProgramInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f9b3117f | this.spdLevel3.CellClick | MenuItemInfo.cs:650 | if (siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel3.GetColumnIndex(DefColumns.ProgramPopup)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-93e42b8a | this.spdLevel3.CellClick | MenuItemInfo.cs:651 | if (siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel3.GetColumnIndex(DefColumns.ProgramPopup)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-ca7e14a6 | this.spdLevel3.CellClick | MenuItemInfo.cs:652 | if (siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel3.GetColumnIndex(DefColumns.ProgramPopup)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-97be6515 | this.spdLevel3.CellClick | MenuItemInfo.cs:654 | if (siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel3.GetColumnIndex(DefColumns.ProgramPopup)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1d357853 | this.spdLevel3.CellClick | MenuItemInfo.cs:656 | if (siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel3.GetColumnIndex(DefColumns.ProgramPopup)) ▸ if… | GRID_SET | siLevel3.SetValue | (e.Row, siLevel3.GetColumnIndex(DefColumns.ProgramID), popup.ProgramID) | 그리드 값 설정 |  |  |  |
| AC-7c9814bf | this.spdLevel3.CellClick | MenuItemInfo.cs:657 | if (siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siLevel3.GetColumnIndex(DefColumns.ProgramPopup)) ▸ if… | GRID_SET | siLevel3.SetValue | (e.Row, siLevel3.GetColumnIndex(DefColumns.ProgramName), popup.ProgramName) | 그리드 값 설정 |  |  |  |

