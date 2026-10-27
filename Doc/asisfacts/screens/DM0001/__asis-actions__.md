# AS-IS 액션 대조표 — DM0001

> 원천: `Doc/asisfacts/screens/DM0001/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 56행 · 메서드 9 · 종류 DATA_OP 19 · GRID_INIT 9 · ENDPOINT 5 · UI_PROP 4 · FLAG 3 · GRID_LOCK 3 · RETURN 3 · CALL_EXT 3 · UI_MISC 2 · MESSAGE 2 · GRID_BIND 1 · GRID_SET 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 3


## DM0001_CustomerModelMapping.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d4df140 | this.Load | DM0001_CustomerModelMapping.cs:83 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b8de88e7 | this.Load | DM0001_CustomerModelMapping.cs:84 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f771a88 | this.Load | DM0001_CustomerModelMapping.cs:85 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0001_CustomerModelMapping.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d23ed4f | DeleteButton | DM0001_CustomerModelMapping.cs:118 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0001_CustomerModelMapping.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-561e0bd4 | Dispose | DM0001_CustomerModelMapping.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0001_CustomerModelMapping.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87f21362 | EditButton | DM0001_CustomerModelMapping.cs:125 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-739dc2c6 | EditButton | DM0001_CustomerModelMapping.cs:126 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8f73a38c | EditButton | DM0001_CustomerModelMapping.cs:128 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.Column1), siMain.GetColumnIndex(DefColumns.Column3), tru… | 그리드 편집 잠금/해제 |  |  |  |

## DM0001_CustomerModelMapping.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b57031c4 | FindButton 외 1 | DM0001_CustomerModelMapping.cs:148 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9c4146d3 | FindButton 외 1 | DM0001_CustomerModelMapping.cs:152 | lambda | ENDPOINT | new FoxDataRequest | ("xxxx.xxxx") ⇒ xxxx.xxxx | 엔드포인트 요청 생성 |  |  |  |
| AC-118cd443 | FindButton 외 1 | DM0001_CustomerModelMapping.cs:153 | lambda | DATA_OP | request.Parameters["Search"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a48f46a5 | FindButton 외 1 | DM0001_CustomerModelMapping.cs:154 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e6046d7 | FindButton 외 1 | DM0001_CustomerModelMapping.cs:156 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-773ab098 | FindButton 외 1 | DM0001_CustomerModelMapping.cs:160 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f1e384f0 | FindButton 외 1 | DM0001_CustomerModelMapping.cs:161 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-022f9f8b | FindButton 외 1 | DM0001_CustomerModelMapping.cs:164 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7eae7b8e | FindButton 외 1 | DM0001_CustomerModelMapping.cs:169 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-3b4522bd | FindButton 외 1 | DM0001_CustomerModelMapping.cs:169 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-46a18d2d | FindButton 외 1 | DM0001_CustomerModelMapping.cs:170 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0001_CustomerModelMapping.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adce8548 | this.Load | DM0001_CustomerModelMapping.cs:68 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0001_CustomerModelMapping.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92a738af | this.Load 외 2 | DM0001_CustomerModelMapping.cs:92 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8ef2a34d | this.Load 외 2 | DM0001_CustomerModelMapping.cs:94 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9c39845a | this.Load 외 2 | DM0001_CustomerModelMapping.cs:95 |  | GRID_INIT | siMain.AddTextColumn | ("Column1", DefColumns.Column1, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2dbe1bf | this.Load 외 2 | DM0001_CustomerModelMapping.cs:96 |  | GRID_INIT | siMain.AddTextColumn | ("Column2", DefColumns.Column2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-870be44f | this.Load 외 2 | DM0001_CustomerModelMapping.cs:97 |  | GRID_INIT | siMain.AddTextColumn | ("Column3", DefColumns.Column3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a3cddef | this.Load 외 2 | DM0001_CustomerModelMapping.cs:99 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Column3)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0001_CustomerModelMapping.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abb3946f | InsertButton | DM0001_CustomerModelMapping.cs:261 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-289d70f8 | InsertButton | DM0001_CustomerModelMapping.cs:264 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column1, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a50e4a1 | InsertButton | DM0001_CustomerModelMapping.cs:265 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column2, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-51bea9df | InsertButton | DM0001_CustomerModelMapping.cs:266 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column3, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-a34ac772 | InsertButton | DM0001_CustomerModelMapping.cs:268 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## DM0001_CustomerModelMapping.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a92431cd | SaveButton | DM0001_CustomerModelMapping.cs:180 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-a2557919 | SaveButton | DM0001_CustomerModelMapping.cs:189 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9afdbc3b | SaveButton | DM0001_CustomerModelMapping.cs:191 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-052b93ea | SaveButton | DM0001_CustomerModelMapping.cs:192 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column1] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f7db2cb4 | SaveButton | DM0001_CustomerModelMapping.cs:193 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column2] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-956d5d71 | SaveButton | DM0001_CustomerModelMapping.cs:194 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column3] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f644b185 | SaveButton | DM0001_CustomerModelMapping.cs:195 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5699e685 | SaveButton | DM0001_CustomerModelMapping.cs:197 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a69f077 | SaveButton | DM0001_CustomerModelMapping.cs:200 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-55171c31 | SaveButton | DM0001_CustomerModelMapping.cs:203 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.Column1) | 데이터 객체 조작/조회 |  |  |  |
| AC-91b72845 | SaveButton | DM0001_CustomerModelMapping.cs:204 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.Column2) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab8fca99 | SaveButton | DM0001_CustomerModelMapping.cs:215 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6055ca15 | SaveButton | DM0001_CustomerModelMapping.cs:216 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71dd3377 | SaveButton | DM0001_CustomerModelMapping.cs:225 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce66b622 | SaveButton | DM0001_CustomerModelMapping.cs:226 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3db99b78 | SaveButton | DM0001_CustomerModelMapping.cs:227 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | DATA_OP | saveDS.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d4dd24f5 | SaveButton | DM0001_CustomerModelMapping.cs:231 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-bfac9d7c | SaveButton | DM0001_CustomerModelMapping.cs:232 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-6580873b | SaveButton | DM0001_CustomerModelMapping.cs:233 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-18def15f | SaveButton | DM0001_CustomerModelMapping.cs:235 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-8ba724c6 | SaveButton | DM0001_CustomerModelMapping.cs:235 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffe94e82 | SaveButton | DM0001_CustomerModelMapping.cs:239 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2604c33 | SaveButton | DM0001_CustomerModelMapping.cs:243 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-37fa24e9 | SaveButton | DM0001_CustomerModelMapping.cs:243 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-c3fff80a | SaveButton | DM0001_CustomerModelMapping.cs:248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

