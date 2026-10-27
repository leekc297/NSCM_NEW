# AS-IS 액션 대조표 — GSCM_PROGRAMINFO

> 원천: `Doc/asisfacts/screens/GSCM_PROGRAMINFO/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 65행 · 메서드 9 · 종류 DATA_OP 25 · GRID_INIT 10 · ENDPOINT 5 · UI_PROP 4 · FLAG 3 · UI_MISC 3 · GRID_LOCK 3 · RETURN 3 · CALL_EXT 3 · MESSAGE 2 · GRID_BIND 1 · COMBO_DATA 1 · GRID_SET 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 3


## ProgramInfo.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-316e549c | this.Load | ProgramInfo.cs:94 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e44c750e | this.Load | ProgramInfo.cs:95 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d6e6094b | this.Load | ProgramInfo.cs:96 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## ProgramInfo.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce63c0eb | DeleteButton | ProgramInfo.cs:150 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## ProgramInfo.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-602635f4 | Dispose | ProgramInfo.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## ProgramInfo.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f26e34cf | EditButton | ProgramInfo.cs:155 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8bf23f92 | EditButton | ProgramInfo.cs:156 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-af8062ca | EditButton | ProgramInfo.cs:158 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ProgramID), siMain.GetColumnIndex(DefColumns.ProgramID),… | 그리드 편집 잠금/해제 |  |  |  |

## ProgramInfo.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-401bb967 | FindButton 외 1 | ProgramInfo.cs:177 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a237fce9 | FindButton 외 1 | ProgramInfo.cs:181 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetProgramInfoList") ⇒ SystemManager.UP_FX_GetProgramInfoList | 엔드포인트 요청 생성 |  |  |  |
| AC-6c45f972 | FindButton 외 1 | ProgramInfo.cs:182 | lambda | DATA_OP | request.Parameters["Search"] | this.txtSearch.Text | 행/컬럼 값 대입 |  |  |  |
| AC-40c02844 | FindButton 외 1 | ProgramInfo.cs:183 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a456ef1b | FindButton 외 1 | ProgramInfo.cs:185 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ca01d343 | FindButton 외 1 | ProgramInfo.cs:189 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-02599323 | FindButton 외 1 | ProgramInfo.cs:190 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-69fb19ee | FindButton 외 1 | ProgramInfo.cs:193 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-70b3a150 | FindButton 외 1 | ProgramInfo.cs:196 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1b2fdb8a | FindButton 외 1 | ProgramInfo.cs:201 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-9a5b7e6f | FindButton 외 1 | ProgramInfo.cs:201 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e405cfdd | FindButton 외 1 | ProgramInfo.cs:202 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## ProgramInfo.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed35381a | this.Load | ProgramInfo.cs:78 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## ProgramInfo.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb564ae8 | this.Load 외 2 | ProgramInfo.cs:103 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-cd44b992 | this.Load 외 2 | ProgramInfo.cs:105 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31b9cb6b | this.Load 외 2 | ProgramInfo.cs:106 |  | GRID_INIT | siMain.AddTextColumn | ("ProgramID*", DefColumns.ProgramID, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d22cf30 | this.Load 외 2 | ProgramInfo.cs:107 |  | GRID_INIT | siMain.AddTextColumn | ("ProgramName*", DefColumns.ProgramName, FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-846c10d9 | this.Load 외 2 | ProgramInfo.cs:108 |  | GRID_INIT | siMain.AddTextColumn | ("ProgramPath*", DefColumns.ProgramPath, FPMerge.None, 250, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ba437d8 | this.Load 외 2 | ProgramInfo.cs:109 |  | GRID_INIT | siMain.AddTextColumn | ("ClassName*", DefColumns.ClassName, FPMerge.None, 350, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c9044d3 | this.Load 외 2 | ProgramInfo.cs:110 |  | GRID_INIT | siMain.AddComboColumn | ("UseYN", DefColumns.UseYN, FPMerge.None, 60, false, Data.Common(Data.Type.YesOrNo), FPHAl… ⇒ biz:CommonData.YesOrNo | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb47e29a | this.Load 외 2 | ProgramInfo.cs:110 |  | COMBO_DATA | Data.Common | (Data.Type.YesOrNo) ⇒ biz:CommonData.YesOrNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## ProgramInfo.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc24a16b | InsertButton | ProgramInfo.cs:298 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-90b067cb | InsertButton | ProgramInfo.cs:301 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ProgramID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-84ad636a | InsertButton | ProgramInfo.cs:302 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ProgramPath, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-58755383 | InsertButton | ProgramInfo.cs:303 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ClassName, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-10b322d8 | InsertButton | ProgramInfo.cs:304 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ProgramName, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-e29516bd | InsertButton | ProgramInfo.cs:305 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.UseYN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a3fb9b9 | InsertButton | ProgramInfo.cs:307 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## ProgramInfo.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fdf475a | SaveButton | ProgramInfo.cs:212 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3755fb27 | SaveButton | ProgramInfo.cs:221 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cd3178fc | SaveButton | ProgramInfo.cs:223 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-3c9e3c6f | SaveButton | ProgramInfo.cs:224 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.ProgramID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ProgramID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e100fd93 | SaveButton | ProgramInfo.cs:225 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.ProgramPath] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ProgramPath)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6321413 | SaveButton | ProgramInfo.cs:226 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.ClassName] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ClassName)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d1c3277 | SaveButton | ProgramInfo.cs:227 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.ProgramName] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ProgramName)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fe6166d3 | SaveButton | ProgramInfo.cs:228 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.UseYN] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UseYN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-696602b5 | SaveButton | ProgramInfo.cs:229 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.RegtUserID] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f52d30e2 | SaveButton | ProgramInfo.cs:231 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa46fb36 | SaveButton | ProgramInfo.cs:234 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-18ea06e7 | SaveButton | ProgramInfo.cs:237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.ProgramID) | 데이터 객체 조작/조회 |  |  |  |
| AC-7938177b | SaveButton | ProgramInfo.cs:238 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.ProgramPath) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed728268 | SaveButton | ProgramInfo.cs:239 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.ClassName) | 데이터 객체 조작/조회 |  |  |  |
| AC-a890b989 | SaveButton | ProgramInfo.cs:240 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.ProgramName) | 데이터 객체 조작/조회 |  |  |  |
| AC-acb3d1e6 | SaveButton | ProgramInfo.cs:253 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-abf80f11 | SaveButton | ProgramInfo.cs:254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-027dd233 | SaveButton | ProgramInfo.cs:263 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-630eda7a | SaveButton | ProgramInfo.cs:264 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5db33dd | SaveButton | ProgramInfo.cs:265 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9fd12a18 | SaveButton | ProgramInfo.cs:269 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveProgramInfo" | 속성 InsertQueryId 설정 |  |  |  |
| AC-077fb902 | SaveButton | ProgramInfo.cs:270 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteProgramInfo" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-668c1ab0 | SaveButton | ProgramInfo.cs:271 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveProgramInfo" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-1b6d2a80 | SaveButton | ProgramInfo.cs:272 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-3a000f00 | SaveButton | ProgramInfo.cs:272 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d7ba83e | SaveButton | ProgramInfo.cs:276 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e7834272 | SaveButton | ProgramInfo.cs:280 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-07e4fdfe | SaveButton | ProgramInfo.cs:280 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-314b1e62 | SaveButton | ProgramInfo.cs:285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

