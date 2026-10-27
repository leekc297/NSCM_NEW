# AS-IS 액션 대조표 — DM0099

> 원천: `Doc/asisfacts/screens/DM0099/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 107행 · 메서드 10 · 종류 DATA_OP 33 · GRID_INIT 23 · UI_PROP 8 · ENDPOINT 7 · RETURN 6 · CALL_EXT 6 · FLAG 5 · GRID_LOCK 5 · MESSAGE 5 · UI_MISC 4 · GRID_SET 2 · STATE_RESET 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 6


## DM0099_CustomerFcstTest2.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4026507 | this.Load | DM0099_CustomerFcstTest2.cs:110 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a3c57c1d | this.Load | DM0099_CustomerFcstTest2.cs:111 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0dc3e76c | this.Load | DM0099_CustomerFcstTest2.cs:113 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-426c1e31 | this.Load | DM0099_CustomerFcstTest2.cs:114 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b8bde8d | this.Load | DM0099_CustomerFcstTest2.cs:116 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0099_CustomerFcstTest2.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a3bc297 | DeleteButton | DM0099_CustomerFcstTest2.cs:175 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0099_CustomerFcstTest2.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd411e8d | Dispose | DM0099_CustomerFcstTest2.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0099_CustomerFcstTest2.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1da5f1d0 | EditButton | DM0099_CustomerFcstTest2.cs:184 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-42d588a3 | EditButton | DM0099_CustomerFcstTest2.cs:185 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-644f359f | EditButton | DM0099_CustomerFcstTest2.cs:187 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ColumnS1), siMain.GetColumnIndex(DefColumns.ColumnS3), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fe19cc59 | EditButton | DM0099_CustomerFcstTest2.cs:192 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-57bc7d0a | EditButton | DM0099_CustomerFcstTest2.cs:193 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-794b4dde | EditButton | DM0099_CustomerFcstTest2.cs:195 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.ColumnS1), siSub.GetColumnIndex(DefColumns.ColumnS3), tru… | 그리드 편집 잠금/해제 |  |  |  |

## DM0099_CustomerFcstTest2.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e4b914f | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:213 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-073d92b2 | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:235 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6b86a1a9 | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:239 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0099_GET_CUSTOMER_FCST_TEST") ⇒ DM.DM0099_GET_CUSTOMER_FCST_TEST | 엔드포인트 요청 생성 |  |  |  |
| AC-9b86d317 | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:240 | lambda | DATA_OP | request.Parameters["p_plan_week"] | "201817" | 행/컬럼 값 대입 |  |  |  |
| AC-4cbb1910 | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:241 | lambda | DATA_OP | request.Parameters["p_customer_code"] | "Audi" | 행/컬럼 값 대입 |  |  |  |
| AC-bcbc763a | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:242 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ed875541 | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:244 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-668f00c1 | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:251 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1ddbede6 | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:252 |  | MESSAGE | MessageBox.Show | ( ds.Tables[0].Rows.Count.ToString()) | 메시지 표시 |  |  |  |
| AC-1c17aa0d | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:253 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-82d78056 | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:255 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5347c330 | FindButton 외 1 | DM0099_CustomerFcstTest2.cs:262 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0099_CustomerFcstTest2.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62dac02c | this.Load | DM0099_CustomerFcstTest2.cs:95 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0099_CustomerFcstTest2.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5f162aa | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:126 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-29143134 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:128 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-917edcbd | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:129 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("DIVISION_ID", DefColumns.DIVISION_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10c90c1f | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:130 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("PLAN_WEEK", DefColumns.PLAN_WEEK, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-226fdc33 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:131 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("CUSTOMER_CODE", DefColumns.CUSTOMER_CODE, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-38e64928 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:132 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("SCM_SITE_ID", DefColumns.SCM_SITE_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9525f6a3 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:133 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("SUMMARY_BUCKET_VALUE", DefColumns.SUMMARY_BUCKET_VALUE, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-166b9896 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:134 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("MEASURE_GROUP", DefColumns.MEASURE_GROUP, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0830846b | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:135 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("CUSTOMER_PSI", DefColumns.CUSTOMER_PSI, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-852eb99f | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:136 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("MEASURE", DefColumns.MEASURE, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1bbef270 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:137 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("VALID_YN", DefColumns.VALID_YN, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9af3c1f0 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:139 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (2, siMain.GetColumnIndex(DefColumns.CUSTOMER_CODE)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6ff88280 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:141 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a898737d | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:146 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-68d1fbb1 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:148 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-61418c51 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:149 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("ColumnS1", DefColumns.ColumnS1, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf176ed3 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:150 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("ColumnS2", DefColumns.ColumnS2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2cc51439 | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:151 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("ColumnS3", DefColumns.ColumnS3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ce36baa | this.Load 외 2 | DM0099_CustomerFcstTest2.cs:155 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0099_CustomerFcstTest2.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-973b0304 | InsertButton | DM0099_CustomerFcstTest2.cs:469 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6d7e7b64 | InsertButton | DM0099_CustomerFcstTest2.cs:472 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ColumnS1, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e8b9b22 | InsertButton | DM0099_CustomerFcstTest2.cs:473 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ColumnS2, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-d87c6629 | InsertButton | DM0099_CustomerFcstTest2.cs:474 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ColumnS3, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d3e71d3 | InsertButton | DM0099_CustomerFcstTest2.cs:476 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-5acf8b43 | InsertButton | DM0099_CustomerFcstTest2.cs:484 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5b6a6104 | InsertButton | DM0099_CustomerFcstTest2.cs:487 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | defaultData.Add | (DefColumns.ColumnS1, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-10b9f604 | InsertButton | DM0099_CustomerFcstTest2.cs:488 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | defaultData.Add | (DefColumns.ColumnS2, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-a42ee72e | InsertButton | DM0099_CustomerFcstTest2.cs:489 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | defaultData.Add | (DefColumns.ColumnS3, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf8cb1f2 | InsertButton | DM0099_CustomerFcstTest2.cs:491 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## DM0099_CustomerFcstTest2.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e12d553 | SaveButton | DM0099_CustomerFcstTest2.cs:308 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-035ac436 | SaveButton | DM0099_CustomerFcstTest2.cs:317 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a45346e4 | SaveButton | DM0099_CustomerFcstTest2.cs:319 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-fc25b3ee | SaveButton | DM0099_CustomerFcstTest2.cs:320 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.ColumnS1] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ColumnS1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-579ff908 | SaveButton | DM0099_CustomerFcstTest2.cs:321 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.ColumnS2] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ColumnS2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2d6dcb06 | SaveButton | DM0099_CustomerFcstTest2.cs:322 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.ColumnS3] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ColumnS3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5f525586 | SaveButton | DM0099_CustomerFcstTest2.cs:323 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7d2920ea | SaveButton | DM0099_CustomerFcstTest2.cs:325 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa95ad17 | SaveButton | DM0099_CustomerFcstTest2.cs:328 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-90db4996 | SaveButton | DM0099_CustomerFcstTest2.cs:331 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.ColumnS1) | 데이터 객체 조작/조회 |  |  |  |
| AC-016ef96b | SaveButton | DM0099_CustomerFcstTest2.cs:332 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.ColumnS2) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcdddab9 | SaveButton | DM0099_CustomerFcstTest2.cs:343 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2411275b | SaveButton | DM0099_CustomerFcstTest2.cs:344 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7000e5d9 | SaveButton | DM0099_CustomerFcstTest2.cs:353 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-06e9de78 | SaveButton | DM0099_CustomerFcstTest2.cs:354 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-77b3b063 | SaveButton | DM0099_CustomerFcstTest2.cs:355 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | DATA_OP | saveDS.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-39130ddf | SaveButton | DM0099_CustomerFcstTest2.cs:359 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-a391b1fd | SaveButton | DM0099_CustomerFcstTest2.cs:360 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-9fc9417e | SaveButton | DM0099_CustomerFcstTest2.cs:361 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-5aac3b03 | SaveButton | DM0099_CustomerFcstTest2.cs:363 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-bbd864e6 | SaveButton | DM0099_CustomerFcstTest2.cs:363 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a5b17737 | SaveButton | DM0099_CustomerFcstTest2.cs:367 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-20594a44 | SaveButton | DM0099_CustomerFcstTest2.cs:371 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5bd0878f | SaveButton | DM0099_CustomerFcstTest2.cs:371 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-f5339d4c | SaveButton | DM0099_CustomerFcstTest2.cs:376 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db7d991f | SaveButton | DM0099_CustomerFcstTest2.cs:388 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (saveDSSub != null) | STATE_RESET | saveDSSub.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5f49bed9 | SaveButton | DM0099_CustomerFcstTest2.cs:397 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a219d807 | SaveButton | DM0099_CustomerFcstTest2.cs:399 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-cf432243 | SaveButton | DM0099_CustomerFcstTest2.cs:400 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ColumnS1] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ColumnS1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-999057b2 | SaveButton | DM0099_CustomerFcstTest2.cs:401 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ColumnS2] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ColumnS2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-68502bae | SaveButton | DM0099_CustomerFcstTest2.cs:402 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ColumnS3] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ColumnS3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4629bfc3 | SaveButton | DM0099_CustomerFcstTest2.cs:403 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5c990e3f | SaveButton | DM0099_CustomerFcstTest2.cs:405 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDSSub.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fcfd59b | SaveButton | DM0099_CustomerFcstTest2.cs:408 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | saveDSSub.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b3ca8a61 | SaveButton | DM0099_CustomerFcstTest2.cs:411 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | DATA_OP | a.Field | (DefColumns.ColumnS1) | 데이터 객체 조작/조회 |  |  |  |
| AC-89b88dd7 | SaveButton | DM0099_CustomerFcstTest2.cs:412 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | DATA_OP | a.Field | (DefColumns.ColumnS2) | 데이터 객체 조작/조회 |  |  |  |
| AC-97cf2fc2 | SaveButton | DM0099_CustomerFcstTest2.cs:423 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3aab9e49 | SaveButton | DM0099_CustomerFcstTest2.cs:424 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7543ea01 | SaveButton | DM0099_CustomerFcstTest2.cs:433 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < saveDSSub.Tables[0].Rows.C… | CALL_EXT | saveDSSub.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-913d8b2c | SaveButton | DM0099_CustomerFcstTest2.cs:434 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < saveDSSub.Tables[0].Rows.C… | CALL_EXT | saveDSSub.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d1aa244 | SaveButton | DM0099_CustomerFcstTest2.cs:435 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < saveDSSub.Tables[0].Rows.C… | DATA_OP | saveDSSub.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a3c5d1d2 | SaveButton | DM0099_CustomerFcstTest2.cs:439 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-fba7ff33 | SaveButton | DM0099_CustomerFcstTest2.cs:440 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-cbf0b621 | SaveButton | DM0099_CustomerFcstTest2.cs:441 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-59f9dd50 | SaveButton | DM0099_CustomerFcstTest2.cs:443 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.DataSet | saveDSSub.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-1e5f2663 | SaveButton | DM0099_CustomerFcstTest2.cs:443 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | CALL_EXT | saveDSSub.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a7b834c | SaveButton | DM0099_CustomerFcstTest2.cs:447 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-46c2dc2e | SaveButton | DM0099_CustomerFcstTest2.cs:451 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-47b882e4 | SaveButton | DM0099_CustomerFcstTest2.cs:451 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-897ac5c8 | SaveButton | DM0099_CustomerFcstTest2.cs:456 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0099_CustomerFcstTest2.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10ca4f76 | this.spdMain.CellClick | DM0099_CustomerFcstTest2.cs:503 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20896a2a | this.spdMain.CellClick | DM0099_CustomerFcstTest2.cs:505 |  | FLAG | mainID | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ColumnS1)) | 화면 필드/플래그 변경 |  |  |  |

