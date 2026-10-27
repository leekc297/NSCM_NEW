# AS-IS 액션 대조표 — GSCM_BASECODE

> 원천: `Doc/asisfacts/screens/GSCM_BASECODE/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 133행 · 메서드 15 · 종류 DATA_OP 46 · GRID_INIT 41 · RETURN 8 · GRID_LOCK 7 · FLAG 6 · ENDPOINT 5 · GRID_SET 4 · UI_PROP 4 · UI_MISC 3 · MESSAGE 3 · CALL_EXT 3 · STATE 1 · GRID_BIND 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 3


## BaseCode.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93ed545c | this.Load | BaseCode.cs:115 |  | GRID_INIT | AddSheet | (spdLevel1, SpdSheet.shtLevel1, SpdSheet.shtLevel1, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2a5055f0 | this.Load | BaseCode.cs:116 |  | FLAG | siLevel1 | GetSheetInfo(spdLevel1.Name, spdLevel1.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a79f2ada | this.Load | BaseCode.cs:118 |  | GRID_INIT | AddSheet | (spdLevel2, SpdSheet.shtLevel2, SpdSheet.shtLevel2, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7cde573d | this.Load | BaseCode.cs:119 |  | FLAG | siLevel2 | GetSheetInfo(spdLevel2.Name, spdLevel2.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8acc696a | this.Load | BaseCode.cs:121 |  | GRID_INIT | AddSheet | (spdLevel3, SpdSheet.shtLevel3, SpdSheet.shtLevel3, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4683fb3d | this.Load | BaseCode.cs:122 |  | FLAG | siLevel3 | GetSheetInfo(spdLevel3.Name, spdLevel3.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f41b36aa | this.Load | BaseCode.cs:124 |  | GRID_INIT | siLevel1.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## BaseCode.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9761696d | this.Load | BaseCode.cs:110 |  | STATE | this.usrConditionPanel1.Visible | false | 컨트롤 상태 Visible |  |  |  |

## BaseCode.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32058eb8 | DeleteButton | BaseCode.cs:215 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": | DATA_OP | siLevel1.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e955745b | DeleteButton | BaseCode.cs:216 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": | DATA_OP | siLevel2.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c2f19a17 | DeleteButton | BaseCode.cs:217 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": | DATA_OP | siLevel3.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## BaseCode.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6008a56 | Dispose | BaseCode.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## BaseCode.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a84725cc | EditButton | BaseCode.cs:233 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": | GRID_LOCK | siLevel1.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-28700f52 | EditButton | BaseCode.cs:233 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": | GRID_LOCK | siLevel1.LockColumn | (0, siLevel1.GetColumnIndex(DefColumns.BaseCode), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9cbe3c2d | EditButton | BaseCode.cs:234 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": | GRID_LOCK | siLevel2.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-cb405788 | EditButton | BaseCode.cs:234 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": | GRID_LOCK | siLevel2.LockColumn | (0, siLevel2.GetColumnIndex(DefColumns.BaseCode), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6687adff | EditButton | BaseCode.cs:235 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": | GRID_LOCK | siLevel3.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-6ec1b8f7 | EditButton | BaseCode.cs:235 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": | GRID_LOCK | siLevel3.LockColumn | (0, siLevel3.GetColumnIndex(DefColumns.BaseCode), true) | 그리드 편집 잠금/해제 |  |  |  |

## BaseCode.FindData

진입점: this.Load / this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel2.CellDoubleClick [else of (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / FindButton / SaveButton [if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ switch (level) case 1:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c4e52fe | this.Load 외 4 | BaseCode.cs:276 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ee2968e1 | this.Load 외 4 | BaseCode.cs:280 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetBaseCodeList") ⇒ SystemManager.UP_FX_GetBaseCodeList | 엔드포인트 요청 생성 |  |  |  |
| AC-65c617ad | this.Load 외 4 | BaseCode.cs:281 | lambda | DATA_OP | request.Parameters["Level"] | level | 행/컬럼 값 대입 |  |  |  |
| AC-504c8548 | this.Load 외 4 | BaseCode.cs:282 | lambda | DATA_OP | request.Parameters["BaseCode"] | prntCode | 행/컬럼 값 대입 |  |  |  |
| AC-70942519 | this.Load 외 4 | BaseCode.cs:284 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-60273c10 | this.Load 외 4 | BaseCode.cs:286 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c4388a66 | this.Load 외 4 | BaseCode.cs:290 |  | GRID_BIND | spreadLevel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5673cec3 | this.Load 외 4 | BaseCode.cs:291 |  | GRID_LOCK | spreadLevel.LockColumn | (0, spreadLevel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-76128e61 | this.Load 외 4 | BaseCode.cs:294 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8722b784 | this.Load 외 4 | BaseCode.cs:297 |  | GRID_INIT | spreadLevel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-97af01aa | this.Load 외 4 | BaseCode.cs:305 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-938352af | this.Load 외 4 | BaseCode.cs:305 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d48ebac9 | this.Load 외 4 | BaseCode.cs:306 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## BaseCode.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-501eb480 | this.Load | BaseCode.cs:97 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## BaseCode.InitSpread

진입점: this.Load / this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (level) case 1:] / this.spdLevel2.CellDoubleClick [else of (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (level) case 1:] / FindButton [switch (level) case 1:] / SaveButton [if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ switch (level) case 1: ▸ switch (level) case 1:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47fcebe0 | this.Load 외 4 | BaseCode.cs:136 | if (level == 1) | GRID_INIT | siLevel1.InitSheet | (siLevel1.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-828e98c7 | this.Load 외 4 | BaseCode.cs:138 | if (level == 1) | GRID_INIT | siLevel1.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-890738e0 | this.Load 외 4 | BaseCode.cs:139 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("BaseCode*", DefColumns.BaseCode, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb64e015 | this.Load 외 4 | BaseCode.cs:140 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Code1*", DefColumns.ClsCode1, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-755401e6 | this.Load 외 4 | BaseCode.cs:141 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Code2*", DefColumns.ClsCode2, FPMerge.None, 70, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07d4ec20 | this.Load 외 4 | BaseCode.cs:142 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Code3*", DefColumns.ClsCode3, FPMerge.None, 70, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e949990b | this.Load 외 4 | BaseCode.cs:143 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("CodeName*", DefColumns.CodeName, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-860ed1ba | this.Load 외 4 | BaseCode.cs:144 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("PrntCode*", DefColumns.PrntCode, FPMerge.None, 150, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-24a46bc7 | this.Load 외 4 | BaseCode.cs:145 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("SortOrder*", DefColumns.SortOrder, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b3760c7 | this.Load 외 4 | BaseCode.cs:146 | if (level == 1) | GRID_INIT | siLevel1.AddComboColumn | ("UseYN*", DefColumns.UseYN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b8cc8c67 | this.Load 외 4 | BaseCode.cs:148 | if (level == 1) | GRID_INIT | siLevel1.Freeze | (0, siLevel1.GetColumnIndex(DefColumns.BaseCode)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b2dbf391 | this.Load 외 4 | BaseCode.cs:150 | if (level == 1) | GRID_INIT | siLevel1.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a117a77c | this.Load 외 4 | BaseCode.cs:156 | if (level == 2) | GRID_INIT | siLevel2.InitSheet | (siLevel2.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-619b1eda | this.Load 외 4 | BaseCode.cs:158 | if (level == 2) | GRID_INIT | siLevel2.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e951ac5 | this.Load 외 4 | BaseCode.cs:159 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("BaseCode*", DefColumns.BaseCode, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29805368 | this.Load 외 4 | BaseCode.cs:160 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Code1*", DefColumns.ClsCode1, FPMerge.None, 70, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb4c2d34 | this.Load 외 4 | BaseCode.cs:161 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Code2*", DefColumns.ClsCode2, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd41b10e | this.Load 외 4 | BaseCode.cs:162 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Code3*", DefColumns.ClsCode3, FPMerge.None, 70, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30fa9da1 | this.Load 외 4 | BaseCode.cs:163 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("CodeName*", DefColumns.CodeName, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79e3db15 | this.Load 외 4 | BaseCode.cs:164 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("PrntCode*", DefColumns.PrntCode, FPMerge.None, 150, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a5f9eb0 | this.Load 외 4 | BaseCode.cs:165 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("SortOrder*", DefColumns.SortOrder, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-442139f2 | this.Load 외 4 | BaseCode.cs:166 | if (level == 2) | GRID_INIT | siLevel2.AddComboColumn | ("UseYN*", DefColumns.UseYN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5788c994 | this.Load 외 4 | BaseCode.cs:168 | if (level == 2) | GRID_INIT | siLevel2.Freeze | (0, siLevel2.GetColumnIndex(DefColumns.BaseCode)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cbe75603 | this.Load 외 4 | BaseCode.cs:170 | if (level == 2) | GRID_INIT | siLevel2.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d633844d | this.Load 외 4 | BaseCode.cs:176 | if (level == 3) | GRID_INIT | siLevel3.InitSheet | (siLevel3.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3880687d | this.Load 외 4 | BaseCode.cs:178 | if (level == 3) | GRID_INIT | siLevel3.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-daec3101 | this.Load 외 4 | BaseCode.cs:179 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("BaseCode*", DefColumns.BaseCode, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c6585777 | this.Load 외 4 | BaseCode.cs:180 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Code1*", DefColumns.ClsCode1, FPMerge.None, 70, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9908f65 | this.Load 외 4 | BaseCode.cs:181 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Code2*", DefColumns.ClsCode2, FPMerge.None, 70, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37dd1872 | this.Load 외 4 | BaseCode.cs:182 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Code3*", DefColumns.ClsCode3, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae0104aa | this.Load 외 4 | BaseCode.cs:183 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("CodeName*", DefColumns.CodeName, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7dcc2eee | this.Load 외 4 | BaseCode.cs:184 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("PrntCode*", DefColumns.PrntCode, FPMerge.None, 150, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5bc4bc5 | this.Load 외 4 | BaseCode.cs:185 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("SortOrder*", DefColumns.SortOrder, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-416ef040 | this.Load 외 4 | BaseCode.cs:186 | if (level == 3) | GRID_INIT | siLevel3.AddComboColumn | ("UseYN*", DefColumns.UseYN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-671d6c86 | this.Load 외 4 | BaseCode.cs:188 | if (level == 3) | GRID_INIT | siLevel3.Freeze | (0, siLevel3.GetColumnIndex(DefColumns.BaseCode)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-91e2a630 | this.Load 외 4 | BaseCode.cs:190 | if (level == 3) | GRID_INIT | siLevel3.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## BaseCode.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d4130bb | InsertButton | BaseCode.cs:463 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ if (rowCnt > 0) | DATA_OP | dt.AsEnumerable().Select | (a => a.Field<string>("ClsCode1")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e9c1c57 | InsertButton | BaseCode.cs:463 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ if (rowCnt > 0) ▸ lambda | DATA_OP | a.Field | ("ClsCode1") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e38240f | InsertButton | BaseCode.cs:475 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ if (rowCnt > 0) | DATA_OP | dt.AsEnumerable().Select | (a => a.Field<int>("SortOrder")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbb56299 | InsertButton | BaseCode.cs:475 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ if (rowCnt > 0) ▸ lambda | DATA_OP | a.Field | ("SortOrder") | 데이터 객체 조작/조회 |  |  |  |
| AC-f122ceff | InsertButton | BaseCode.cs:497 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ if (string.IsNullOrEmpty(baseCode1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58996ed5 | InsertButton | BaseCode.cs:504 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ if (rowCnt > 0) | DATA_OP | dt.AsEnumerable().Select | (a => a.Field<string>("ClsCode2")) | 데이터 객체 조작/조회 |  |  |  |
| AC-553c3c96 | InsertButton | BaseCode.cs:504 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ if (rowCnt > 0) ▸ lambda | DATA_OP | a.Field | ("ClsCode2") | 데이터 객체 조작/조회 |  |  |  |
| AC-953da194 | InsertButton | BaseCode.cs:516 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ if (rowCnt > 0) | DATA_OP | dt.AsEnumerable().Select | (a => a.Field<int>("SortOrder")) | 데이터 객체 조작/조회 |  |  |  |
| AC-48caf538 | InsertButton | BaseCode.cs:516 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ if (rowCnt > 0) ▸ lambda | DATA_OP | a.Field | ("SortOrder") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbba7fa6 | InsertButton | BaseCode.cs:537 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ if (string.IsNullOrEmpty(baseCode2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1d056da | InsertButton | BaseCode.cs:544 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ if (rowCnt > 0) | DATA_OP | dt.AsEnumerable().Select | (a => a.Field<string>("ClsCode3")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f90e68a3 | InsertButton | BaseCode.cs:544 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ if (rowCnt > 0) ▸ lambda | DATA_OP | a.Field | ("ClsCode3") | 데이터 객체 조작/조회 |  |  |  |
| AC-57df2964 | InsertButton | BaseCode.cs:558 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ if (rowCnt > 0) | DATA_OP | dt.AsEnumerable().Select | (a => a.Field<int>("SortOrder")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cd0c1aa | InsertButton | BaseCode.cs:558 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ if (rowCnt > 0) ▸ lambda | DATA_OP | a.Field | ("SortOrder") | 데이터 객체 조작/조회 |  |  |  |
| AC-056c88c1 | InsertButton | BaseCode.cs:577 | if (this.fps != null) ▸ if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | spreadLevel.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5e671da7 | InsertButton | BaseCode.cs:580 | if (this.fps != null) ▸ if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.BaseCode, baseCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-300bf4eb | InsertButton | BaseCode.cs:581 | if (this.fps != null) ▸ if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.ClsCode1, clsCode1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f77c3fd | InsertButton | BaseCode.cs:582 | if (this.fps != null) ▸ if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.ClsCode2, clsCode2) | 데이터 객체 조작/조회 |  |  |  |
| AC-33812e2c | InsertButton | BaseCode.cs:583 | if (this.fps != null) ▸ if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.ClsCode3, clsCode3) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d3b3f63 | InsertButton | BaseCode.cs:584 | if (this.fps != null) ▸ if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.PrntCode, prntCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-95cb6d62 | InsertButton | BaseCode.cs:585 | if (this.fps != null) ▸ if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.SortOrder, sortOrder) | 데이터 객체 조작/조회 |  |  |  |
| AC-45c30785 | InsertButton | BaseCode.cs:586 | if (this.fps != null) ▸ if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.UseYN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-89614639 | InsertButton | BaseCode.cs:588 | if (this.fps != null) ▸ if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | GRID_SET | spreadLevel.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## BaseCode.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a88d34c8 | SaveButton | BaseCode.cs:343 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e0484c33 | SaveButton | BaseCode.cs:356 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) ▸ if (string.IsNull… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-32b8293f | SaveButton | BaseCode.cs:357 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) ▸ if (string.IsNull… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03369ac0 | SaveButton | BaseCode.cs:360 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-444a1e71 | SaveButton | BaseCode.cs:362 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-64112eec | SaveButton | BaseCode.cs:363 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.BaseCode] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.BaseCode)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-07f79a86 | SaveButton | BaseCode.cs:364 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ClsCode1] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.ClsCode1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3ca91d2 | SaveButton | BaseCode.cs:365 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ClsCode2] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.ClsCode2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-be47a991 | SaveButton | BaseCode.cs:366 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ClsCode3] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.ClsCode3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aadf79b2 | SaveButton | BaseCode.cs:367 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.CodeName] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.CodeName)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3304cf2d | SaveButton | BaseCode.cs:368 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.PrntCode] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.PrntCode)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-616de2d6 | SaveButton | BaseCode.cs:369 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SortOrder] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.SortOrder)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4c7276c0 | SaveButton | BaseCode.cs:371 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.UseYN] | spreadLevel.GetValue(i, spreadLevel.GetColumnIndex(DefColumns.UseYN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-87f0ba5c | SaveButton | BaseCode.cs:372 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-54ff54b0 | SaveButton | BaseCode.cs:374 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ for (i <= spreadLevel.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc6733a8 | SaveButton | BaseCode.cs:377 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cd50c620 | SaveButton | BaseCode.cs:380 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | DATA_OP | a.Field | (DefColumns.BaseCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-f94e7098 | SaveButton | BaseCode.cs:381 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | DATA_OP | a.Field | (DefColumns.ClsCode1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e64c2b48 | SaveButton | BaseCode.cs:382 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | DATA_OP | a.Field | (DefColumns.ClsCode2) | 데이터 객체 조작/조회 |  |  |  |
| AC-8779be85 | SaveButton | BaseCode.cs:383 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | DATA_OP | a.Field | (DefColumns.ClsCode3) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5bace10 | SaveButton | BaseCode.cs:384 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | DATA_OP | a.Field | (DefColumns.CodeName) | 데이터 객체 조작/조회 |  |  |  |
| AC-8760ef08 | SaveButton | BaseCode.cs:390 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f952d017 | SaveButton | BaseCode.cs:391 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44b3bdea | SaveButton | BaseCode.cs:400 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (ro… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff964a7e | SaveButton | BaseCode.cs:401 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (ro… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bb93411 | SaveButton | BaseCode.cs:402 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (ro… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3063191e | SaveButton | BaseCode.cs:406 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveBaseCode" | 속성 InsertQueryId 설정 |  |  |  |
| AC-76caddfe | SaveButton | BaseCode.cs:407 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteBaseCode" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-82a3b412 | SaveButton | BaseCode.cs:408 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveBaseCode" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-2cae68fc | SaveButton | BaseCode.cs:410 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-d1ff3530 | SaveButton | BaseCode.cs:410 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-22bf1b5f | SaveButton | BaseCode.cs:414 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8109a341 | SaveButton | BaseCode.cs:418 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-72e4e70f | SaveButton | BaseCode.cs:418 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-9ab5dbe1 | SaveButton | BaseCode.cs:423 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## BaseCode.SpdLevel1_CellDoubleClick

진입점: this.spdLevel1.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adfbe862 | this.spdLevel1.CellDoubleClick | BaseCode.cs:600 | if (siLevel1.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3ac5829 | this.spdLevel1.CellDoubleClick | BaseCode.cs:607 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | baseCode1 | siLevel1.GetText(e.Row, siLevel1.GetColumnIndex(DefColumns.BaseCode)) | 화면 필드/플래그 변경 |  |  |  |

## BaseCode.SpdLevel1_LeaveCell

진입점: this.spdLevel1.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-254c586e | this.spdLevel1.LeaveCell | BaseCode.cs:638 | if (siLevel1.IsLock(siLevel1.SheetName) == false) ▸ if (e.Column == siLevel1.GetColumnIndex(DefColumns.ClsCode1)) | GRID_SET | siLevel1.SetValue | (e.Row, siLevel1.GetColumnIndex(DefColumns.BaseCode), baseCode) | 그리드 값 설정 |  |  |  |

## BaseCode.SpdLevel2_CellDoubleClick

진입점: this.spdLevel2.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-038784f1 | this.spdLevel2.CellDoubleClick | BaseCode.cs:615 | if (siLevel2.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96a11e83 | this.spdLevel2.CellDoubleClick | BaseCode.cs:622 | else of (siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | baseCode2 | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.BaseCode)) | 화면 필드/플래그 변경 |  |  |  |

## BaseCode.SpdLevel2_LeaveCell

진입점: this.spdLevel2.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c4d79f2 | this.spdLevel2.LeaveCell | BaseCode.cs:654 | if (siLevel2.IsLock(siLevel2.SheetName) == false) ▸ if (e.Column == siLevel1.GetColumnIndex(DefColumns.ClsCode2)) | GRID_SET | siLevel2.SetValue | (e.Row, siLevel2.GetColumnIndex(DefColumns.BaseCode), baseCode) | 그리드 값 설정 |  |  |  |

## BaseCode.SpdLevel3_LeaveCell

진입점: this.spdLevel3.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35173320 | this.spdLevel3.LeaveCell | BaseCode.cs:670 | if (siLevel3.IsLock(siLevel3.SheetName) == false) ▸ if (e.Column == siLevel1.GetColumnIndex(DefColumns.ClsCode3)) | GRID_SET | siLevel3.SetValue | (e.Row, siLevel3.GetColumnIndex(DefColumns.BaseCode), baseCode) | 그리드 값 설정 |  |  |  |

