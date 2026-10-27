# AS-IS 액션 대조표 — GSCM_GROUPINFO

> 원천: `Doc/asisfacts/screens/GSCM_GROUPINFO/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 58행 · 메서드 10 · 종류 DATA_OP 18 · GRID_INIT 10 · ENDPOINT 5 · UI_PROP 4 · FLAG 3 · UI_MISC 3 · GRID_LOCK 3 · RETURN 3 · CALL_EXT 3 · MESSAGE 2 · STATE 1 · GRID_BIND 1 · GRID_SET 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 3


## GroupInfo.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-388e37df | this.Load | GroupInfo.cs:89 |  | GRID_INIT | AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0795ebcd | this.Load | GroupInfo.cs:90 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-246d75ee | this.Load | GroupInfo.cs:94 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## GroupInfo.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c00e57e9 | this.Load | GroupInfo.cs:84 |  | STATE | this.usrConditionPanel1.Visible | false | 컨트롤 상태 Visible |  |  |  |

## GroupInfo.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a163c3f | DeleteButton | GroupInfo.cs:132 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## GroupInfo.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9cfec51 | Dispose | GroupInfo.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## GroupInfo.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19756031 | EditButton | GroupInfo.cs:142 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7dd92a76 | EditButton | GroupInfo.cs:143 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-39df2e11 | EditButton | GroupInfo.cs:145 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.GroupID), true) | 그리드 편집 잠금/해제 |  |  |  |

## GroupInfo.FindData

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a02f4193 | this.Load 외 2 | GroupInfo.cs:166 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-568cc992 | this.Load 외 2 | GroupInfo.cs:170 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetGroupInfoList") ⇒ SystemManager.UP_FX_GetGroupInfoList | 엔드포인트 요청 생성 |  |  |  |
| AC-e8c6a5b4 | this.Load 외 2 | GroupInfo.cs:171 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7872f896 | this.Load 외 2 | GroupInfo.cs:173 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6f4ccb76 | this.Load 외 2 | GroupInfo.cs:177 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c1661f65 | this.Load 외 2 | GroupInfo.cs:178 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d61c2051 | this.Load 외 2 | GroupInfo.cs:181 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0147ffd2 | this.Load 외 2 | GroupInfo.cs:184 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-022e0197 | this.Load 외 2 | GroupInfo.cs:189 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-7fc8db4d | this.Load 외 2 | GroupInfo.cs:189 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b38cb287 | this.Load 외 2 | GroupInfo.cs:190 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## GroupInfo.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cb310e0 | this.Load | GroupInfo.cs:70 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## GroupInfo.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97157816 | this.Load 외 2 | GroupInfo.cs:101 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.InitSheet | (spread.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8d9a7067 | this.Load 외 2 | GroupInfo.cs:103 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ce3968f9 | this.Load 외 2 | GroupInfo.cs:104 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddTextColumn | ("GroupID*", DefColumns.GroupID, FPMerge.None, 250, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b61773a | this.Load 외 2 | GroupInfo.cs:105 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddTextColumn | ("GrpName*", DefColumns.GrpName, FPMerge.None, 300, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-715d3c9f | this.Load 외 2 | GroupInfo.cs:106 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddComboColumn | ("UseYN*", DefColumns.UseYN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-539d0f8e | this.Load 외 2 | GroupInfo.cs:108 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.Freeze | (0, siMain.GetColumnIndex(DefColumns.GroupID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bbbae1e7 | this.Load 외 2 | GroupInfo.cs:110 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## GroupInfo.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd9eca02 | InsertButton | GroupInfo.cs:281 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-90f58c9f | InsertButton | GroupInfo.cs:284 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.GroupID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b6f7d26 | InsertButton | GroupInfo.cs:285 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.GrpName, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-3758d309 | InsertButton | GroupInfo.cs:286 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.UseYN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-110d6660 | InsertButton | GroupInfo.cs:288 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## GroupInfo.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65f665fa | SaveButton | GroupInfo.cs:201 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ab21e972 | SaveButton | GroupInfo.cs:210 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-627071bf | SaveButton | GroupInfo.cs:212 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-20796326 | SaveButton | GroupInfo.cs:213 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.GroupID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.GroupID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8b3f7da2 | SaveButton | GroupInfo.cs:214 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.GrpName] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.GrpName)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0218def0 | SaveButton | GroupInfo.cs:215 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.UseYN] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UseYN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a02397c3 | SaveButton | GroupInfo.cs:216 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1bd9e089 | SaveButton | GroupInfo.cs:218 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7154c3e0 | SaveButton | GroupInfo.cs:221 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1ab00738 | SaveButton | GroupInfo.cs:224 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.GroupID) | 데이터 객체 조작/조회 |  |  |  |
| AC-bab3206f | SaveButton | GroupInfo.cs:225 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.GrpName) | 데이터 객체 조작/조회 |  |  |  |
| AC-f70aeb3e | SaveButton | GroupInfo.cs:236 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14e72284 | SaveButton | GroupInfo.cs:237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb09a76a | SaveButton | GroupInfo.cs:246 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b918a30 | SaveButton | GroupInfo.cs:247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-949c99ff | SaveButton | GroupInfo.cs:248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3daaa9c1 | SaveButton | GroupInfo.cs:252 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveGroupInfo" | 속성 InsertQueryId 설정 |  |  |  |
| AC-1caff741 | SaveButton | GroupInfo.cs:253 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteGroupInfo" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-ab73f84e | SaveButton | GroupInfo.cs:254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveGroupInfo" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-52dfc6ed | SaveButton | GroupInfo.cs:255 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-1986c2ee | SaveButton | GroupInfo.cs:255 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4a9f04e | SaveButton | GroupInfo.cs:259 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-db4f77f2 | SaveButton | GroupInfo.cs:263 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-816f0535 | SaveButton | GroupInfo.cs:263 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-15111fbd | SaveButton | GroupInfo.cs:268 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

