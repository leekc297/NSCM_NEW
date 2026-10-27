# AS-IS 액션 대조표 — GSCM_TERM

> 원천: `Doc/asisfacts/screens/GSCM_TERM/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 64행 · 메서드 9 · 종류 DATA_OP 23 · GRID_INIT 12 · ENDPOINT 5 · UI_PROP 4 · FLAG 3 · UI_MISC 3 · GRID_LOCK 3 · RETURN 3 · CALL_EXT 3 · GRID_BIND 1 · GRID_SET 1 · STATE_RESET 1 · VALIDATE 1 · MESSAGE 1 · ⚠ 의미 확인 필요 3


## TermInfo.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31d87c3c | this.Load | TermInfo.cs:101 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1e43a400 | this.Load | TermInfo.cs:102 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4213cfb6 | this.Load | TermInfo.cs:103 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## TermInfo.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ba29a3c | DeleteButton | TermInfo.cs:139 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## TermInfo.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aedcfb23 | Dispose | TermInfo.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## TermInfo.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bab5b7f5 | EditButton | TermInfo.cs:144 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3bdbd658 | EditButton | TermInfo.cs:145 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c4030537 | EditButton | TermInfo.cs:147 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TermID), siMain.GetColumnIndex(DefColumns.TermID), true) | 그리드 편집 잠금/해제 |  |  |  |

## TermInfo.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0caa23de | FindButton 외 1 | TermInfo.cs:166 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-343a0b69 | FindButton 외 1 | TermInfo.cs:170 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetTermInfoList") ⇒ SystemManager.UP_FX_GetTermInfoList | 엔드포인트 요청 생성 |  |  |  |
| AC-77674007 | FindButton 외 1 | TermInfo.cs:171 | lambda | DATA_OP | request.Parameters["Search"] | this.txtSearch.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1d30c59a | FindButton 외 1 | TermInfo.cs:172 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-34c1b5f7 | FindButton 외 1 | TermInfo.cs:174 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7a1e72b5 | FindButton 외 1 | TermInfo.cs:178 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-85f84411 | FindButton 외 1 | TermInfo.cs:179 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-746dc0f6 | FindButton 외 1 | TermInfo.cs:182 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d3b9c738 | FindButton 외 1 | TermInfo.cs:185 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f4ad4e79 | FindButton 외 1 | TermInfo.cs:190 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-06dc89b1 | FindButton 외 1 | TermInfo.cs:190 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8d3df1e2 | FindButton 외 1 | TermInfo.cs:191 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## TermInfo.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d98acc95 | this.Load | TermInfo.cs:79 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## TermInfo.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f89977f5 | this.Load 외 2 | TermInfo.cs:110 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-30bbcf90 | this.Load 외 2 | TermInfo.cs:112 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-566265be | this.Load 외 2 | TermInfo.cs:113 |  | GRID_INIT | siMain.AddTextColumn | ("TermID*", DefColumns.TermID, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3714c853 | this.Load 외 2 | TermInfo.cs:114 |  | GRID_INIT | siMain.AddTextColumn | ("Ko*", DefColumns.Ko, FPMerge.None, 250, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d93b7677 | this.Load 외 2 | TermInfo.cs:115 |  | GRID_INIT | siMain.AddTextColumn | ("En*", DefColumns.En, FPMerge.None, 250, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33dff1df | this.Load 외 2 | TermInfo.cs:116 |  | GRID_INIT | siMain.AddTextColumn | ("Ch*", DefColumns.Ch, FPMerge.None, 250, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-097a942e | this.Load 외 2 | TermInfo.cs:117 |  | GRID_INIT | siMain.AddTextColumn | ("Description*", DefColumns.Description, FPMerge.None, 250, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fcc9b13d | this.Load 외 2 | TermInfo.cs:118 |  | GRID_INIT | siMain.AddComboColumn | ("UseYN*", DefColumns.UseYN, FPMerge.None, 80, true, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1aab2c1a | this.Load 외 2 | TermInfo.cs:120 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.TermID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## TermInfo.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29783c69 | InsertButton | TermInfo.cs:292 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-982e953b | InsertButton | TermInfo.cs:295 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.TermID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7f5cb79 | InsertButton | TermInfo.cs:296 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.Ko, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-ecb8d16d | InsertButton | TermInfo.cs:297 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.En, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca3ac7cb | InsertButton | TermInfo.cs:298 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.Ch, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-63a4ea3f | InsertButton | TermInfo.cs:299 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.Description, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f9e8617 | InsertButton | TermInfo.cs:300 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.UseYN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f38770e | InsertButton | TermInfo.cs:302 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## TermInfo.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bd5f912 | SaveButton | TermInfo.cs:201 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-baa4508f | SaveButton | TermInfo.cs:204 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-727c6e0a | SaveButton | TermInfo.cs:204 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e20c214 | SaveButton | TermInfo.cs:213 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-334bb267 | SaveButton | TermInfo.cs:215 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-47573bc3 | SaveButton | TermInfo.cs:216 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.TermID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.TermID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-532bb98f | SaveButton | TermInfo.cs:217 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Ko] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Ko)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-88e00867 | SaveButton | TermInfo.cs:218 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.En] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.En)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9d450cb0 | SaveButton | TermInfo.cs:219 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Ch] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Ch)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8237f568 | SaveButton | TermInfo.cs:220 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Description] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Description)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5b442d3 | SaveButton | TermInfo.cs:221 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.UseYN] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UseYN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4495dfba | SaveButton | TermInfo.cs:222 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9a4315e1 | SaveButton | TermInfo.cs:224 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-96c9008e | SaveButton | TermInfo.cs:227 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b42bcf65 | SaveButton | TermInfo.cs:258 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d832256 | SaveButton | TermInfo.cs:259 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-795aec2f | SaveButton | TermInfo.cs:260 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-53ec3581 | SaveButton | TermInfo.cs:264 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveTermInfo" | 속성 InsertQueryId 설정 |  |  |  |
| AC-2d4af937 | SaveButton | TermInfo.cs:265 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteTermInfo" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-83a45c57 | SaveButton | TermInfo.cs:266 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveTermInfo" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-5d7b0e6a | SaveButton | TermInfo.cs:268 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-a3b49027 | SaveButton | TermInfo.cs:268 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-96e6d744 | SaveButton | TermInfo.cs:272 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a73c7634 | SaveButton | TermInfo.cs:276 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d1f61138 | SaveButton | TermInfo.cs:276 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-e61c34fb | SaveButton | TermInfo.cs:281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

