# AS-IS 액션 대조표 — SSP0028

> 원천: `Doc/asisfacts/screens/SSP0028/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 296행 · 메서드 38 · 종류 DATA_OP 112 · GRID_SET 58 · CALL_EXT 29 · GRID_INIT 19 · FLAG 17 · ENDPOINT 15 · LIST_REBIND 13 · RETURN 9 · UI_MISC 4 · GRID_LOCK 3 · LIST_CLEAR 3 · VALUE_SET 3 · GRID_BIND 2 · POPUP 2 · UI_PROP 2 · GRID_STYLE 2 · COMBO_DATA 2 · VALIDATE 1 · ⚠ 의미 확인 필요 29


## SSP0028_Delivery_Tracking_LT.AccuracyRange_NO

진입점: cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true) ▸ else of (AccuracyRangeCheck(System.Convert.ToInt32(Range[0]), System.Convert.ToInt32(Range[1]), Val) == true)] / FindButton [try ▸ if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true) ▸ else of (AccuracyRangeCheck(System.Convert.ToInt32(Range[0]), System.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc2c2abb | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1096 |  | GRID_SET | this.spdMain.Sheets[0].SetValue | (Rowindex, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-a1c7949e | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1100 | for (j <= 5) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (Rowindex, Visible) | ⚠ 의미 확인 필요 |  |  |  |
| AC-878bb20f | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1105 |  | RETURN | return Rowindex; |  | 처리 중단/반환 |  |  |  |

## SSP0028_Delivery_Tracking_LT.AccuracyRange_NoNumber

진입점: cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ else of (Ok_Number == true)] / FindButton [try ▸ if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ else of (Ok_Number == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38cd90d2 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1111 |  | GRID_SET | this.spdMain.Sheets[0].SetValue | (Rowindex, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-f092c035 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1115 | for (j <= 5) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (Rowindex, Visible) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44f8d6ae | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1120 |  | RETURN | return Rowindex; |  | 처리 중단/반환 |  |  |  |

## SSP0028_Delivery_Tracking_LT.AccuracyRange_OK

진입점: cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true) ▸ if (AccuracyRangeCheck(System.Convert.ToInt32(Range[0]), System.Convert.ToInt32(Range[1]), Val) == true)] / FindButton [try ▸ if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true) ▸ if (AccuracyRangeCheck(System.Convert.ToInt32(Range[0]), System.Convert.To…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e95bbf1d | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1079 |  | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (Rowindex, Visible) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9065a760 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1081 |  | GRID_SET | this.spdMain.Sheets[0].SetValue | (Rowindex, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-6a31d243 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1086 | for (j <= 5) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (Rowindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae3d1705 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1090 |  | RETURN | return Rowindex; |  | 처리 중단/반환 |  |  |  |

## SSP0028_Delivery_Tracking_LT.AccuracyRange_SelectALL

진입점: cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.ControlValues != "ALL")] / FindButton [try ▸ else of (cboAccuracy.ControlValues != "ALL")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bfe4cba | cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.Contr… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1128 |  | CALL_EXT | this.spdMain.Sheets[0].SetColumnLabel | (0, G_TTLColumnIndex, "구분 ▼") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8eea456 | cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.Contr… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1138 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (i, Visible) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3023bbd | cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.Contr… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1140 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) | GRID_SET | this.spdMain.Sheets[0].SetValue | (i, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-9e4064c7 | cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.Contr… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1145 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j <= 5) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-748c9da7 | cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.Contr… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1155 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < G_AccuracyColorIndex.Count) | GRID_SET | spdMain.Sheets[0].Cells[System.Convert.ToInt32(sep[0]), System.Convert.ToInt32(sep[1])].Ba… | Color.White | 그리드 속성/값 설정 |  |  |  |

## SSP0028_Delivery_Tracking_LT.AccuracyRangeCheck

진입점: cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true)] / FindButton [try ▸ if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6864fc09 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:1073 |  | RETURN | return Check; |  | 처리 중단/반환 |  |  |  |

## SSP0028_Delivery_Tracking_LT.btn_Search_Click

진입점: this.btn_Search.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6db21479 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1319 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL") ⇒ SSP.SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-ba0a4c85 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1320 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c2b0e534 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1321 |  | DATA_OP | request.Parameters["p_from_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-414faea1 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1322 |  | DATA_OP | request.Parameters["p_to_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4e296135 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1323 |  | DATA_OP | request.Parameters["p_from_site"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-35352391 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1324 |  | DATA_OP | request.Parameters["p_to_site"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3e1f859f | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1325 |  | DATA_OP | request.Parameters["p_bod_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ebaa5505 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1326 |  | DATA_OP | request.Parameters["p_route_id "] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3ea4715a | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1327 |  | DATA_OP | request.Parameters["p_from_country"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-991d8c67 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1328 |  | DATA_OP | request.Parameters["p_to_country"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7e758da8 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1329 |  | DATA_OP | request.Parameters["p_from_city"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ee3113a1 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1330 |  | DATA_OP | request.Parameters["p_to_city"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1fe0b14b | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1331 |  | DATA_OP | request.Parameters["p_from_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-69898027 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1332 |  | DATA_OP | request.Parameters["p_to_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ae254e95 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1336 | if (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_exfactory_from_yyyymmdd"] | p_exfactory_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-788bc950 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1337 | if (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_exfactory_to_yyyymmdd"] | p_exfactory_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1c150ef6 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1338 | if (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_fdest_from_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-21e42b97 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1339 | if (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_fdest_to_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6de13359 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1343 | else of (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_exfactory_from_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4077705d | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1344 | else of (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_exfactory_to_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9fad33a7 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1345 | else of (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_fdest_from_yyyymmdd"] | p_fdest_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-23aaffb7 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1346 | else of (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_fdest_to_yyyymmdd"] | p_fdest_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-050f3e03 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1349 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bc9007bc | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1354 |  | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4e3974b2 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1356 |  | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-999bdc50 | this.btn_Search.Click | SSP0028_Delivery_Tracking_LT.cs:1358 |  | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0028_Delivery_Tracking_LT.cboFromCountry_SelectedIndexChanged

진입점: cboFromCountry.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a71fbc6 | cboFromCountry.SelectedIndexChanged | SSP0028_Delivery_Tracking_LT.cs:936 |  | LIST_CLEAR | this.cboFromCity.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-27c2f9f4 | cboFromCountry.SelectedIndexChanged | SSP0028_Delivery_Tracking_LT.cs:937 |  | LIST_CLEAR | this.cboToCity.Items.Clear | () | 목록 항목 비움 |  |  |  |

## SSP0028_Delivery_Tracking_LT.cboToCountry_SelectedIndexChanged

진입점: cboToCountry.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dc1469f | cboToCountry.SelectedIndexChanged | SSP0028_Delivery_Tracking_LT.cs:950 |  | LIST_CLEAR | this.cboToCity.Items.Clear | () | 목록 항목 비움 |  |  |  |

## SSP0028_Delivery_Tracking_LT.CheckNumber

진입점: cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j >= 0)] / FindButton [try ▸ for (i < ds.Tables[0].Columns.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4c4f9a6 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SSP0028_Delivery_Tracking_LT.cs:696 |  | RETURN | return isNumeric; |  | 처리 중단/반환 |  |  |  |

## SSP0028_Delivery_Tracking_LT.CreateMonthlyGrid

진입점: FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bc2889c | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:253 | if (G_MonthlyIndex.Count != 0) | CALL_EXT | G_MonthlyIndex.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-074c558a | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:258 |  | GRID_INIT | siMain.Freeze | (0, G_MainGriHeaderdColumnIndex) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e8cd6e2c | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:268 | for (i < G_GRID_MONTH_HEADER.Count) | CALL_EXT | siMain.AddColumns | (G_MainGriHeaderdColumnIndex, G_Month_ColumnICount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-549ee7d1 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:269 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (0, G_MainGriHeaderdColumnIndex, 1, G_Month_ColumnICount, 20, G_GRID_MONTH_HEADER[i].ToStr… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-115571de | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:272 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | G_MonthlyIndex.Add | (G_GRID_MONTH_HEADER[i] + "/" + G_MainGriHeaderdColumnIndex.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-29f96947 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:274 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, G_MainGriHeaderdColumnIndex, 2, 1, 20, "기준LT(과거계획평균)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bea7bdb1 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:275 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, G_MainGriHeaderdColumnIndex + 1, 1, 3, 20, "실적 L/T", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08ef6c4b | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:276 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.SetColumnHeader | (2, G_MainGriHeaderdColumnIndex + 1, "평균") | 그리드 재구성/초기화 |  |  |  |
| AC-feaf9316 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:276 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | GColumnVisible[0] | GColumnVisible[0] + (G_MainGriHeaderdColumnIndex + 1).ToString() + "," | 행/컬럼 값 대입 |  |  |  |
| AC-cdc07115 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:277 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.SetColumnHeader | (2, G_MainGriHeaderdColumnIndex + 2, "최대") | 그리드 재구성/초기화 |  |  |  |
| AC-e61d1743 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:277 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | GColumnVisible[1] | GColumnVisible[1] + (G_MainGriHeaderdColumnIndex + 2).ToString() + "," | 행/컬럼 값 대입 |  |  |  |
| AC-b640b1bc | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:278 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.SetColumnHeader | (2, G_MainGriHeaderdColumnIndex + 3, "최소") | 그리드 재구성/초기화 |  |  |  |
| AC-13934508 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:278 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | GColumnVisible[2] | GColumnVisible[2] + (G_MainGriHeaderdColumnIndex + 3).ToString() + "," | 행/컬럼 값 대입 |  |  |  |
| AC-24f4c07a | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:279 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, G_MainGriHeaderdColumnIndex + 4, 2, 1, 20, "정확도(%)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f47bdbe9 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:279 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | GColumnVisible[3] | GColumnVisible[3] + (G_MainGriHeaderdColumnIndex + 4).ToString() + "," | 행/컬럼 값 대입 |  |  |  |
| AC-87345696 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:280 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, G_MainGriHeaderdColumnIndex + 5, 2, 1, 20, "차이", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72bf746a | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:281 | for (i < G_GRID_MONTH_HEADER.Count) | FLAG | G_MainGriHeaderdColumnIndex | += G_Month_ColumnICount | 화면 필드/플래그 변경 |  |  |  |
| AC-84863c3c | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:285 |  | CALL_EXT | siMain.AddRows | (0, MakeRowCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-59ce21b9 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:292 | for (i < MakeRowCount) ▸ if (i == 0) | GRID_SET | spdMain.Sheets[0].Cells[i, G_ShipmentCountIndex].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-324a4245 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:293 | for (i < MakeRowCount) ▸ if (i == 0) | GRID_SET | spdMain.Sheets[0].Cells[i, G_TTLColumnIndex].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-d6269a69 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:294 | for (i < MakeRowCount) ▸ if (i == 0) | GRID_SET | spdMain.Sheets[0].SetValue | (i, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-975762a3 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:299 | for (i < MakeRowCount) ▸ if (i == 0) ▸ for (j <= 5) | GRID_SET | spdMain.Sheets[0].SetValue | (j, G_TTLColumnIndex, "TTL" + TTLNumbering.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d06263ef | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:309 | for (i < MakeRowCount) ▸ else of (i == 0) ▸ if (YELLOWCOLORCELL_Index == G_OneDataRowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, G_ShipmentCountIndex].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-d073064b | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:310 | for (i < MakeRowCount) ▸ else of (i == 0) ▸ if (YELLOWCOLORCELL_Index == G_OneDataRowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, G_TTLColumnIndex].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-c36407b5 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:311 | for (i < MakeRowCount) ▸ else of (i == 0) ▸ if (YELLOWCOLORCELL_Index == G_OneDataRowCount) | GRID_SET | spdMain.Sheets[0].SetValue | (i, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-ec93a21b | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SSP0028_Delivery_Tracking_LT.cs:318 | for (i < MakeRowCount) ▸ else of (i == 0) ▸ if (YELLOWCOLORCELL_Index == G_OneDataRowCount) ▸ for (j <= 5) | GRID_SET | spdMain.Sheets[0].SetValue | (j + i, G_TTLColumnIndex, "TTL" + TTLNumbering.ToString()) | 그리드 값 설정 |  |  |  |

## SSP0028_Delivery_Tracking_LT.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dd20666 | this.Load | SSP0028_Delivery_Tracking_LT.cs:217 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-32c429cb | this.Load | SSP0028_Delivery_Tracking_LT.cs:218 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5c32e68 | this.Load | SSP0028_Delivery_Tracking_LT.cs:221 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtDetail, SpdSheet.shtDetail, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-34669883 | this.Load | SSP0028_Delivery_Tracking_LT.cs:222 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, spdDetail.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-11307e8c | this.Load | SSP0028_Delivery_Tracking_LT.cs:227 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Difference_Individual_Values

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d02c9ae | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:901 | for (DTTL <= 5) ▸ if (ds.Tables[0].Rows[j][DR] != DBNull.Value && ds.Tables[0].Rows[j][TTL] != DBNull.Value) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 5, System.Convert.ToInt32(Math.Round(System.Convert.T… | 그리드 값 설정 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95247c8e | Dispose | SSP0028_Delivery_Tracking_LT.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0028_Delivery_Tracking_LT.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-448a3a08 | FindButton | SSP0028_Delivery_Tracking_LT.cs:481 |  | CALL_EXT | G_GRID_MONTH_HEADER.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bded8375 | FindButton | SSP0028_Delivery_Tracking_LT.cs:483 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a10beb7a | FindButton | SSP0028_Delivery_Tracking_LT.cs:487 | try | FLAG | G_MainGriHeaderdColumnIndex | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-387e43f6 | FindButton | SSP0028_Delivery_Tracking_LT.cs:491 | try ▸ for (i < GColumnVisible.Length) | DATA_OP | GColumnVisible[i] | null | 행/컬럼 값 대입 |  |  |  |
| AC-d0b02844 | FindButton | SSP0028_Delivery_Tracking_LT.cs:493 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7473e5fe | FindButton | SSP0028_Delivery_Tracking_LT.cs:514 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a08590c2 | FindButton | SSP0028_Delivery_Tracking_LT.cs:515 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", sBinding)) { var request = new FoxD… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-061432ba | FindButton | SSP0028_Delivery_Tracking_LT.cs:519 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0028_GET_DELIVERY_TRACKING_LT") ⇒ SSP.SSP0028_GET_DELIVERY_TRACKING_LT | 엔드포인트 요청 생성 |  |  |  |
| AC-953a56af | FindButton | SSP0028_Delivery_Tracking_LT.cs:520 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6b12e0dd | FindButton | SSP0028_Delivery_Tracking_LT.cs:521 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-172c1478 | FindButton | SSP0028_Delivery_Tracking_LT.cs:522 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-18e369e4 | FindButton | SSP0028_Delivery_Tracking_LT.cs:523 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-08b03a3c | FindButton | SSP0028_Delivery_Tracking_LT.cs:524 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-99584d34 | FindButton | SSP0028_Delivery_Tracking_LT.cs:525 | try ▸ lambda | DATA_OP | request.Parameters["p_PIVOT_yyyymm"] | (object)Set_PIVOT_DATE(p_from_yyyymmdd.ToString(), p_to_yyyymmdd.ToString()) | 행/컬럼 값 대입 |  |  |  |
| AC-27cf1cbc | FindButton | SSP0028_Delivery_Tracking_LT.cs:526 | try ▸ lambda | DATA_OP | request.Parameters["p_from_country"] | p_from_country | 행/컬럼 값 대입 |  |  |  |
| AC-ed1587af | FindButton | SSP0028_Delivery_Tracking_LT.cs:527 | try ▸ lambda | DATA_OP | request.Parameters["p_to_country"] | p_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-bda44756 | FindButton | SSP0028_Delivery_Tracking_LT.cs:528 | try ▸ lambda | DATA_OP | request.Parameters["p_from_city"] | p_from_city | 행/컬럼 값 대입 |  |  |  |
| AC-5374e7a1 | FindButton | SSP0028_Delivery_Tracking_LT.cs:529 | try ▸ lambda | DATA_OP | request.Parameters["p_to_city"] | p_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-dd9e6773 | FindButton | SSP0028_Delivery_Tracking_LT.cs:530 | try ▸ lambda | DATA_OP | request.Parameters["p_from_area"] | p_from_area | 행/컬럼 값 대입 |  |  |  |
| AC-90106f60 | FindButton | SSP0028_Delivery_Tracking_LT.cs:531 | try ▸ lambda | DATA_OP | request.Parameters["p_to_area"] | p_to_area | 행/컬럼 값 대입 |  |  |  |
| AC-0c36d6c8 | FindButton | SSP0028_Delivery_Tracking_LT.cs:533 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-282c3be2 | FindButton | SSP0028_Delivery_Tracking_LT.cs:534 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3f14271e | FindButton | SSP0028_Delivery_Tracking_LT.cs:546 | try ▸ if (G_GRID_MONTH_HEADER.Count > 0) | FLAG | G_MainGriHeaderdColumnIndex | spdMain.Sheets[0].ColumnCount | 화면 필드/플래그 변경 |  |  |  |
| AC-3ebf506c | FindButton | SSP0028_Delivery_Tracking_LT.cs:562 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-14b3caf5 | FindButton | SSP0028_Delivery_Tracking_LT.cs:568 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6714c4df | FindButton | SSP0028_Delivery_Tracking_LT.cs:577 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db040dbd | this.Load | SSP0028_Delivery_Tracking_LT.cs:100 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Get_Month_Index

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fca5dacb | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:919 |  | RETURN | return rvalue; |  | 처리 중단/반환 |  |  |  |

## SSP0028_Delivery_Tracking_LT.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2bb2ebf | this.Load | SSP0028_Delivery_Tracking_LT.cs:469 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-d6428f79 | this.Load | SSP0028_Delivery_Tracking_LT.cs:470 |  | DATA_OP | request.Parameters["p_from_date"] | sFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-d2209fc2 | this.Load | SSP0028_Delivery_Tracking_LT.cs:471 |  | DATA_OP | request.Parameters["p_offset_day"] | "30" | 행/컬럼 값 대입 |  |  |  |
| AC-058bdc56 | this.Load | SSP0028_Delivery_Tracking_LT.cs:472 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-10c53055 | this.Load | SSP0028_Delivery_Tracking_LT.cs:473 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e82fbdb1 | this.Load | SSP0028_Delivery_Tracking_LT.cs:476 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Individual_Accuracy_Values

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6bf42ec | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:883 | for (DTTL <= 5) ▸ if (ds.Tables[0].Rows[j][DR] != DBNull.Value && ds.Tables[0].Rows[j][TTL] != DBNull.Value) ▸ if (System.Convert.ToDouble(d… | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 4, Math.Round((1 - Math.Abs(System.Convert.ToDouble(d… | 그리드 값 설정 |  |  |  |
| AC-f874958e | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:885 | for (DTTL <= 5) ▸ if (ds.Tables[0].Rows[j][DR] != DBNull.Value && ds.Tables[0].Rows[j][TTL] != DBNull.Value) ▸ else of (System.Convert.ToDou… | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 4, null) | 그리드 값 설정 |  |  |  |

## SSP0028_Delivery_Tracking_LT.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-678b5487 | this.Load | SSP0028_Delivery_Tracking_LT.cs:113 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-91afb707 | this.Load | SSP0028_Delivery_Tracking_LT.cs:114 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5ca58ba | this.Load | SSP0028_Delivery_Tracking_LT.cs:116 |  | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8cd36ccb | this.Load | SSP0028_Delivery_Tracking_LT.cs:118 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3bc8acb6 | this.Load | SSP0028_Delivery_Tracking_LT.cs:121 | if (G_dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-74cbddc2 | this.Load | SSP0028_Delivery_Tracking_LT.cs:123 |  | FLAG | G_dtMyDivision | G_dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-b854f39f | this.Load | SSP0028_Delivery_Tracking_LT.cs:123 |  | DATA_OP | G_dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0edf8f35 | this.Load | SSP0028_Delivery_Tracking_LT.cs:123 |  | DATA_OP | G_dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9fa60d0a | this.Load | SSP0028_Delivery_Tracking_LT.cs:124 |  | LIST_REBIND | clsCtrl.setListBox | (G_dtMyDivision, clbDivision_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-70d65ab9 | this.Load | SSP0028_Delivery_Tracking_LT.cs:129 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange("") | 컨트롤 값 설정 |  |  |  |
| AC-b613c69f | this.Load | SSP0028_Delivery_Tracking_LT.cs:132 |  | VALUE_SET | drpExfactory.InitValue | GetDayRange("") | 컨트롤 값 설정 |  |  |  |
| AC-9c9a6c9f | this.Load | SSP0028_Delivery_Tracking_LT.cs:133 |  | VALUE_SET | drpFDest.InitValue | GetDayRange("") | 컨트롤 값 설정 |  |  |  |

## SSP0028_Delivery_Tracking_LT.InitSpread

진입점: this.Load / clbDivision_ID.SelectedIndexChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8fe780e | this.Load 외 2 | SSP0028_Delivery_Tracking_LT.cs:233 | if (spreadInfo.ActiveSheet.RowCount != 0) | GRID_SET | spreadInfo.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b611348b | this.Load 외 2 | SSP0028_Delivery_Tracking_LT.cs:236 |  | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c58d2d47 | this.Load 외 2 | SSP0028_Delivery_Tracking_LT.cs:237 |  | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b28cc80c | this.Load 외 2 | SSP0028_Delivery_Tracking_LT.cs:241 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7a41fe8 | this.Load 외 2 | SSP0028_Delivery_Tracking_LT.cs:244 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ for (i < G_MainGridColumnCount) | GRID_INIT | siMain.ColumnHeaderSpan | (0, i, 3, 1, 20, spdMain.Sheets[0].GetColumnLabel(2, i), FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-84ad6bd7 | this.Load 외 2 | SSP0028_Delivery_Tracking_LT.cs:244 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ for (i < G_MainGridColumnCount) | CALL_EXT | spdMain.Sheets[0].GetColumnLabel | (2, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8156d7e0 | this.Load 외 2 | SSP0028_Delivery_Tracking_LT.cs:247 |  | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0028_Delivery_Tracking_LT.KuBunHeaderClick_ALL_Close

진입점: spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ else of (e.ColumnHeader == false) ▸ if (this.spdMain.Sheets[0].RowCount != 0) ▸ if (sep.Length == 2) ▸ if (sep[1] == "▲")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-468df3f2 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SSP0028_Delivery_Tracking_LT.cs:1263 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) | CALL_EXT | this.spdMain.Sheets[0].SetColumnLabel | (0, ColumnIndex, "구분 ▼") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d016817b | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SSP0028_Delivery_Tracking_LT.cs:1267 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") | GRID_SET | this.spdMain.Sheets[0].SetValue | (i, ColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-eefa10c6 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SSP0028_Delivery_Tracking_LT.cs:1270 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") ▸ for (j <= 5) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (i + j, Visible) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0028_Delivery_Tracking_LT.KuBunHeaderClick_ALL_Show

진입점: spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ else of (e.ColumnHeader == false) ▸ if (this.spdMain.Sheets[0].RowCount != 0) ▸ if (sep.Length == 2) ▸ else of (sep[1] == "▲")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9220644 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SSP0028_Delivery_Tracking_LT.cs:1287 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) | CALL_EXT | this.spdMain.Sheets[0].SetColumnLabel | (0, ColumnIndex, "구분 ▲") | ⚠ 의미 확인 필요 |  |  |  |
| AC-320a5066 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SSP0028_Delivery_Tracking_LT.cs:1291 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") | GRID_SET | this.spdMain.Sheets[0].SetValue | (i, ColumnIndex, "TTL ▲") | 그리드 값 설정 |  |  |  |
| AC-ecca3a8e | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SSP0028_Delivery_Tracking_LT.cs:1293 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") | CALL_EXT | this.spdMain.Sheets[0].GetRowVisible | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55b90866 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SSP0028_Delivery_Tracking_LT.cs:1297 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") ▸ for (j <= 5) | CALL_EXT | this.spdMain.Sheets[0].GetRowVisible | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-928927e2 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SSP0028_Delivery_Tracking_LT.cs:1298 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") ▸ for (j <= 5) ▸ if (this.spdMain… | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (i + j, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cfe60eb7 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SSP0028_Delivery_Tracking_LT.cs:1299 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") ▸ for (j <= 5) ▸ else of (this.sp… | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (i + j, Visible) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Make_Accuracy_ComboBox

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51405742 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:391 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f3d8fd2 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:392 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-67ce560f | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:394 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43070955 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:396 |  | DATA_OP | row["CODE"] | "91/100" | 행/컬럼 값 대입 |  |  |  |
| AC-cb4c3013 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:397 |  | DATA_OP | row["NAME"] | "91~100%" | 행/컬럼 값 대입 |  |  |  |
| AC-7c5f2811 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:398 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-014b82c9 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:400 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6961e424 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:401 |  | DATA_OP | row["CODE"] | "81/90" | 행/컬럼 값 대입 |  |  |  |
| AC-d28beb08 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:402 |  | DATA_OP | row["NAME"] | "81~90%" | 행/컬럼 값 대입 |  |  |  |
| AC-3f04cb6a | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:404 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2fa6b1e | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:405 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-314c6184 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:406 |  | DATA_OP | row["CODE"] | "51/80" | 행/컬럼 값 대입 |  |  |  |
| AC-4ced7113 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:407 |  | DATA_OP | row["NAME"] | "51~80%" | 행/컬럼 값 대입 |  |  |  |
| AC-99fe6476 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:408 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5a72363 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:410 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ccdbf7c1 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:411 |  | DATA_OP | row["CODE"] | "0/50" | 행/컬럼 값 대입 |  |  |  |
| AC-5980eef6 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:412 |  | DATA_OP | row["NAME"] | "0~50%" | 행/컬럼 값 대입 |  |  |  |
| AC-8c019cd0 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:413 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-da3845b8 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:415 |  | LIST_REBIND | clsCtrl.setListBox | (dt, cboAccuracy, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Make_Area_ComboBox

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16de6cd0 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:424 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0028_GET_AREA") ⇒ SSP.SSP0028_GET_AREA | 엔드포인트 요청 생성 |  |  |  |
| AC-1e4d8d4d | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:425 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-51262eec | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:429 |  | DATA_OP | ds.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3c305e04 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:431 |  | DATA_OP | row["NAME"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-cbf659ae | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:432 |  | DATA_OP | row["CODE"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-46b0b2ae | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:434 |  | CALL_EXT | ds.Tables[0].Rows.InsertAt | (row, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a8c5904d | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:435 |  | FLAG | this.G_dtFromArea | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-c9782e04 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:436 |  | FLAG | this.G_dtToArea | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d497af6c | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:436 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a2043745 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:438 |  | LIST_REBIND | clsCtrl.setListBox | (G_dtFromArea, cboFromArea, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-79c30434 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:439 |  | LIST_REBIND | clsCtrl.setListBox | (G_dtToArea, cboToArea, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Make_InquiryClassification_ComboBox

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73a5d47f | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:357 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8f62cd3 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:358 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ac806ef | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:360 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c9d64170 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:362 |  | DATA_OP | row["CODE"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-d1d73424 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:363 |  | DATA_OP | row["NAME"] | "평균" | 행/컬럼 값 대입 |  |  |  |
| AC-11878ccd | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:364 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4fe8760 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:366 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c90d0d9f | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:367 |  | DATA_OP | row["CODE"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-94e4d6ec | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:368 |  | DATA_OP | row["NAME"] | "최대" | 행/컬럼 값 대입 |  |  |  |
| AC-8192fdda | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:370 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc5bf909 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:371 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8226a1fd | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:372 |  | DATA_OP | row["CODE"] | 2 | 행/컬럼 값 대입 |  |  |  |
| AC-932a9bed | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:373 |  | DATA_OP | row["NAME"] | "최소" | 행/컬럼 값 대입 |  |  |  |
| AC-77cbfab8 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:374 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-726c207e | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:376 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9cc6ff5d | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:377 |  | DATA_OP | row["CODE"] | 3 | 행/컬럼 값 대입 |  |  |  |
| AC-e91ea65f | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:378 |  | DATA_OP | row["NAME"] | "정확도" | 행/컬럼 값 대입 |  |  |  |
| AC-6733138b | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:379 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d02dcce | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:381 |  | LIST_REBIND | clsCtrl.setListBox | (dt, cboInquiryClassification, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-618ce610 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:384 | for (i < dt.Rows.Count) | CALL_EXT | cboInquiryClassification.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0028_Delivery_Tracking_LT.SameDataMerge

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da5edf94 | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:746 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) ▸ for (Month_LT <= 5) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + Month_LT, MonthColumnIndex, Math.Round(System.Convert.ToDouble(ds.Tables[0].Ro… | 그리드 값 설정 |  |  |  |
| AC-f1776aa7 | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:759 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) ▸ if (CheckNumber(Math.Rou… | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 4, Math.Round(System.Convert.ToDouble(1 - Math.Abs((SUM_DR -… | 그리드 값 설정 |  |  |  |
| AC-f049a7a2 | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:761 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) ▸ else of (CheckNumber(Mat… | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 4, null) | 그리드 값 설정 |  |  |  |
| AC-ae6db79b | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:767 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 5, (SUM_TTL_AVG - SUM_DR)) | 그리드 값 설정 |  |  |  |
| AC-17e214bb | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:775 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex, System.Convert.ToInt32(SUM_DR)) | 그리드 값 설정 |  |  |  |
| AC-bebaf927 | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:776 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 1, System.Convert.ToInt32(SUM_TTL_AVG)) | 그리드 값 설정 |  |  |  |
| AC-54855e15 | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:777 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 2, System.Convert.ToInt32(SUM_TTL_MAX)) | 그리드 값 설정 |  |  |  |
| AC-b971361c | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:778 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 3, System.Convert.ToInt32(SUM_TTL_MIN)) | 그리드 값 설정 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Set_Accuracy_Row

진입점: cboAccuracy.SelectedIndexChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a73da4e3 | cboAccuracy.SelectedIndexChanged 외 1 | SSP0028_Delivery_Tracking_LT.cs:1006 | if (cboAccuracy.ControlValues != "ALL") ▸ if (G_AccuracyColorIndex.Count > 0) | CALL_EXT | G_AccuracyColorIndex.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7879a3e | cboAccuracy.SelectedIndexChanged 외 1 | SSP0028_Delivery_Tracking_LT.cs:1008 | if (cboAccuracy.ControlValues != "ALL") | CALL_EXT | this.spdMain.Sheets[0].SetColumnLabel | (0, G_TTLColumnIndex, "구분 ▼") | ⚠ 의미 확인 필요 |  |  |  |
| AC-30a3ef9e | cboAccuracy.SelectedIndexChanged 외 1 | SSP0028_Delivery_Tracking_LT.cs:1022 | if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.Active… | GRID_SET | spdMain.Sheets[0].Cells[i, System.Convert.ToInt32(sep[j])].BackColor | Color.FromArgb(70, Color.Magenta) | 그리드 속성/값 설정 |  |  |  |
| AC-d77198cb | cboAccuracy.SelectedIndexChanged 외 1 | SSP0028_Delivery_Tracking_LT.cs:1024 | if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.Active… | DATA_OP | G_AccuracyColorIndex.Add | (i + "/" + sep[j]) | 데이터 객체 조작/조회 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Set_City_ComboBox

진입점: this.Load / clbDivision_ID.SelectedIndexChanged / cboFromCountry.SelectedIndexChanged [if (cboFromCountry.ControlValues == "ALL")] / cboToCountry.SelectedIndexChanged [if (cboToCountry.ControlValues == "ALL")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2568e327 | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:161 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0028_GET_CITY") ⇒ SSP.SSP0028_GET_CITY | 엔드포인트 요청 생성 |  |  |  |
| AC-367aa266 | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:162 |  | DATA_OP | request.Parameters["p_country_parameter"] | CountryParameter | 행/컬럼 값 대입 |  |  |  |
| AC-5ee8654c | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:163 |  | DATA_OP | request.Parameters["p_kind"] | Kind | 행/컬럼 값 대입 |  |  |  |
| AC-78c0236e | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:164 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6549e7e1 | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:170 | if (Kind == "F") | FLAG | this.G_dtFromCity | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-1f83284d | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:171 | if (Kind == "F") | LIST_REBIND | clsCtrl.setListBox | (this.G_dtFromCity, cboFromCity, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f833de5c | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:175 | else of (Kind == "F") ▸ if (Kind == "T") | FLAG | this.G_dtToCity | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-e441447c | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:176 | else of (Kind == "F") ▸ if (Kind == "T") | LIST_REBIND | clsCtrl.setListBox | (this.G_dtToCity, cboToCity, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cc2e6519 | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:180 | else of (Kind == "F") ▸ else of (Kind == "T") ▸ if (Kind == "A") | FLAG | this.G_dtFromCity | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-88ec82bf | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:181 | else of (Kind == "F") ▸ else of (Kind == "T") ▸ if (Kind == "A") | LIST_REBIND | clsCtrl.setListBox | (this.G_dtFromCity, cboFromCity, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-489ca9f2 | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:183 | else of (Kind == "F") ▸ else of (Kind == "T") ▸ if (Kind == "A") | FLAG | this.G_dtToCity | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-40a357f1 | this.Load 외 3 | SSP0028_Delivery_Tracking_LT.cs:184 | else of (Kind == "F") ▸ else of (Kind == "T") ▸ if (Kind == "A") | LIST_REBIND | clsCtrl.setListBox | (this.G_dtToCity, cboToCity, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Set_ColumnVisible

진입점: cboInquiryClassification.SelectedIndexChanged / FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d070de2d | cboInquiryClassification.SelectedIndexChanged 외 1 | SSP0028_Delivery_Tracking_LT.cs:981 | try ▸ for (i < GColumnVisible.Length) | CALL_EXT | cboInquiryClassification.GetItemChecked | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fdffa5b | cboInquiryClassification.SelectedIndexChanged 외 1 | SSP0028_Delivery_Tracking_LT.cs:981 | try ▸ for (i < GColumnVisible.Length) ▸ if (cboInquiryClassification.GetItemChecked(i) == false) ▸ for (col < sep.Length) | GRID_STYLE | siMain.setColumnWidth | (System.Convert.ToInt32(sep[col]), 0) | 그리드 표시 설정 |  |  |  |
| AC-20b95483 | cboInquiryClassification.SelectedIndexChanged 외 1 | SSP0028_Delivery_Tracking_LT.cs:982 | try ▸ for (i < GColumnVisible.Length) ▸ else of (cboInquiryClassification.GetItemChecked(i) == false) ▸ for (col < sep.Length) | GRID_STYLE | siMain.setColumnWidth | (System.Convert.ToInt32(sep[col]), 50) | 그리드 표시 설정 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Set_CommonInformation

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) ▸ if (FirstCheck == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a4fbb84 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:794 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex, ds.Tables[0].Rows[j]["DIVISIONID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-783e8277 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:795 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex+1, ds.Tables[0].Rows[j]["FROM_SITE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-b111548e | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:796 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex+2, ds.Tables[0].Rows[j]["TO_SITE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-52a18b01 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:797 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex+3, ds.Tables[0].Rows[j]["POL_AREA"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-5c156e93 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:798 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex+4, ds.Tables[0].Rows[j]["POD_AREA"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-0865417b | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:799 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex+5, ds.Tables[0].Rows[j]["D_PORT_CODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-ae0aa075 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:800 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex+6, ds.Tables[0].Rows[j]["A_PORT_CODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-414ccc33 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:801 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex+7, ds.Tables[0].Rows[j]["FROM_CITY"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-a20eb00a | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:802 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex+8, ds.Tables[0].Rows[j]["TO_CITY"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-e8227517 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:803 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex+9, ds.Tables[0].Rows[j]["TRANSPORT_MODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-9600e162 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:804 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_BODIDIndex, ds.Tables[0].Rows[j]["BOD_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-d416c85d | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:805 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_RouteIDIndex, ds.Tables[0].Rows[j]["ROUTE_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-1ef0a421 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:806 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex+12, ds.Tables[0].Rows[j]["SSP_INCOTERMS"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-1ebc90d2 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:807 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_ShipmentCountIndex, System.Convert.ToInt32(ds.Tables[1].Rows[i]["SHIPMENTCOUN… | 그리드 값 설정 |  |  |  |
| AC-fd294e1e | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:811 | for (LT <= 5) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + LT, LTIndex, Math.Round(System.Convert.ToDouble(ds.Tables[0].Rows[j][NDR + LT]… | 그리드 값 설정 |  |  |  |
| AC-be5a56d6 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:819 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, LTIndex, System.Convert.ToInt32(SUM_NDR)) | 그리드 값 설정 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Set_Country_ComboBox

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82e08805 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:142 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0028_GET_COUNTRY") ⇒ SSP.SSP0028_GET_COUNTRY | 엔드포인트 요청 생성 |  |  |  |
| AC-5ee10bd7 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:143 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fa6678ad | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:148 |  | FLAG | this.G_dtFromCountry | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-5e82304b | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:149 |  | FLAG | this.G_dtToCountry | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-e0d1bd86 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:151 |  | LIST_REBIND | clsCtrl.setListBox | (this.G_dtFromCountry, cboFromCountry, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bf1b643d | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:152 |  | LIST_REBIND | clsCtrl.setListBox | (this.G_dtToCountry, cboToCountry, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Set_DetailgridColor

진입점: this.btn_Search.Click / spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c66ce87 | this.btn_Search.Click 외 2 | SSP0028_Delivery_Tracking_LT.cs:1377 | if (flag == 0) ▸ for (Index < sep1.Length) ▸ for (i < this.spdMain.Sheets[0].RowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, System.Convert.ToInt32(sep1[Index])].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-d75d3a97 | this.btn_Search.Click 외 2 | SSP0028_Delivery_Tracking_LT.cs:1378 | if (flag == 0) ▸ for (Index < sep1.Length) ▸ for (i < this.spdMain.Sheets[0].RowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, System.Convert.ToInt32(sep2[Index])].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-15e017cd | this.btn_Search.Click 외 2 | SSP0028_Delivery_Tracking_LT.cs:1379 | if (flag == 0) ▸ for (Index < sep1.Length) ▸ for (i < this.spdMain.Sheets[0].RowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, System.Convert.ToInt32(sep3[Index])].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-c80fc8a5 | this.btn_Search.Click 외 2 | SSP0028_Delivery_Tracking_LT.cs:1387 | else of (flag == 0) ▸ for (i < this.spdDetail.Sheets[0].RowCount) | GRID_SET | spdDetail.Sheets[0].Cells[i, TTL1_5].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-a3a5ff9e | this.btn_Search.Click 외 2 | SSP0028_Delivery_Tracking_LT.cs:1388 | else of (flag == 0) ▸ for (i < this.spdDetail.Sheets[0].RowCount) | GRID_SET | spdDetail.Sheets[0].Cells[i, TTL1_5 + 1].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-f1a486a4 | this.btn_Search.Click 외 2 | SSP0028_Delivery_Tracking_LT.cs:1389 | else of (flag == 0) ▸ for (i < this.spdDetail.Sheets[0].RowCount) | GRID_SET | spdDetail.Sheets[0].Cells[i, TTL1_5 + 2].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-0e3920e5 | this.btn_Search.Click 외 2 | SSP0028_Delivery_Tracking_LT.cs:1390 | else of (flag == 0) ▸ for (i < this.spdDetail.Sheets[0].RowCount) | GRID_SET | spdDetail.Sheets[0].Cells[i, TTL1_5 + 3].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-a80b57aa | this.btn_Search.Click 외 2 | SSP0028_Delivery_Tracking_LT.cs:1391 | else of (flag == 0) ▸ for (i < this.spdDetail.Sheets[0].RowCount) | GRID_SET | spdDetail.Sheets[0].Cells[i, TTL1_5 + 4].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |

## SSP0028_Delivery_Tracking_LT.SET_MONTH

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bebaeb8 | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:652 |  | DATA_OP | ds.Tables[0].Columns.Add | ("YYYYYMM", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-99ac310e | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:670 | for (i < ds.Tables[0].Columns.Count) ▸ if (CheckNumber(ds.Tables[0].Columns[ds.Tables[0].Columns.Count - CoulumIndex].ColumnName.ToString())… | DATA_OP | ds.Tables[0].Rows[r].BeginEdit | () | 데이터 객체 조작/조회 |  |  |  |
| AC-984a1b16 | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:671 | for (i < ds.Tables[0].Columns.Count) ▸ if (CheckNumber(ds.Tables[0].Columns[ds.Tables[0].Columns.Count - CoulumIndex].ColumnName.ToString())… | GRID_SET | ds.Tables[0].Rows[r]["YYYYYMM"] | ds.Tables[0].Columns[ds.Tables[0].Columns.Count - CoulumIndex].ColumnName.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-b7e12c59 | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:672 | for (i < ds.Tables[0].Columns.Count) ▸ if (CheckNumber(ds.Tables[0].Columns[ds.Tables[0].Columns.Count - CoulumIndex].ColumnName.ToString())… | DATA_OP | ds.Tables[0].Rows[r].EndEdit | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b29ec2a9 | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:673 | for (i < ds.Tables[0].Columns.Count) ▸ if (CheckNumber(ds.Tables[0].Columns[ds.Tables[0].Columns.Count - CoulumIndex].ColumnName.ToString())… | DATA_OP | ds.Tables[0].Rows[r].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a01da35e | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:689 | for (i >= 0) | DATA_OP | this.G_GRID_MONTH_HEADER.Add | (sep[i]) | 데이터 객체 조작/조회 |  |  |  |

## SSP0028_Delivery_Tracking_LT.Set_PIVOT_DATE

진입점: FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e92287da | FindButton [try ▸ lambda] | SSP0028_Delivery_Tracking_LT.cs:607 | else of (month_diff == 0) ▸ for (i < month_diff) ▸ if (YEAR == null) ▸ if (FDate.Substring(4, 2) != "12") | CALL_EXT | (System.Convert.ToInt32(FDate.Substring(4, 2)) + 1).ToString().PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-c509950a | FindButton [try ▸ lambda] | SSP0028_Delivery_Tracking_LT.cs:631 | else of (month_diff == 0) ▸ for (i < month_diff) ▸ else of (YEAR == null) ▸ else of (CheckMonth == true) | CALL_EXT | (System.Convert.ToInt32(MONTH) + 1).ToString().PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-deade599 | FindButton [try ▸ lambda] | SSP0028_Delivery_Tracking_LT.cs:641 |  | RETURN | return strDate.Substring(0, strDate.Length - 1); |  | 처리 중단/반환 |  |  |  |

## SSP0028_Delivery_Tracking_LT.SetChangedControl

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c688677 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:192 |  | FLAG | G_dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-708d3b2d | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:192 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c034573 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:193 |  | FLAG | G_dtToSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-60a763e7 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:193 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Current["NowGroupID… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e5819547 | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:195 |  | LIST_REBIND | clsCtrl.setListBox | (G_dtPlantSiteByDivision, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8a4723cf | this.Load 외 1 | SSP0028_Delivery_Tracking_LT.cs:197 |  | LIST_REBIND | clsCtrl.setListBox | (G_dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0028_Delivery_Tracking_LT.spdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d743387 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1174 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL") ⇒ SSP.SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-52696134 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1175 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_division_id"] | spdMain.Sheets[0].GetValue(e.Row, G_DivisionIDIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2d7fadcc | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1176 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-477997d9 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1177 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d9fb1a2e | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1178 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_from_site"] | spdMain.Sheets[0].GetValue(e.Row, G_FromSiteIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dbf6ccd7 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1179 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_to_site"] | spdMain.Sheets[0].GetValue(e.Row, G_ToSiteIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-27767601 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1180 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_bod_id"] | spdMain.Sheets[0].GetValue(e.Row, G_BODIDIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1a3b6fc2 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1181 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_route_id "] | spdMain.Sheets[0].GetValue(e.Row, G_RouteIDIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6faed4fc | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1182 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_exfactory_from_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fdcd1b7e | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1183 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_exfactory_to_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-939068c4 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1184 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_fdest_from_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b5d53c26 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1185 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_fdest_to_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f901572a | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1186 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_from_country"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6c40a84 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1187 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_to_country"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-47cbbcda | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1188 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_from_city"] | spdMain.Sheets[0].GetValue(e.Row, G_FromCityIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ea192f72 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1189 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_to_city"] | spdMain.Sheets[0].GetValue(e.Row, G_ToCityIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-874b7a20 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1190 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_from_area"] | spdMain.Sheets[0].GetValue(e.Row, G_FromAreaIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-acff2814 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1191 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) ▸ if (spdMain.Sheets[0].GetValue(e.Row… | DATA_OP | request.Parameters["p_to_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d18214e1 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1191 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) ▸ else of (spdMain.Sheets[0].GetValue(… | DATA_OP | request.Parameters["p_to_area"] | spdMain.Sheets[0].GetValue(e.Row, G_ToAreaIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-92fa3c87 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1193 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-21bf8c65 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1197 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7aa0a821 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1198 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e6b4337 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1199 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49194630 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1217 | else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ if (e.ColumnHeader == false) ▸ if (sep.Length == 2) ▸ if (s… | GRID_SET | spdMain.Sheets[0].SetValue | (e.Row, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-3dcfc698 | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1219 | else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ if (e.ColumnHeader == false) ▸ if (sep.Length == 2) ▸ else … | GRID_SET | spdMain.Sheets[0].SetValue | (e.Row, G_TTLColumnIndex, "TTL ▲") | 그리드 값 설정 |  |  |  |
| AC-d132edae | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1222 | else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ if (e.ColumnHeader == false) ▸ if (sep.Length == 2) ▸ for (… | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (e.Row + (i + 1), Visible) | ⚠ 의미 확인 필요 |  |  |  |
| AC-07f6a01b | spdMain.CellDoubleClick | SSP0028_Delivery_Tracking_LT.cs:1229 | else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ else of (e.ColumnHeader == false) ▸ if (this.spdMain.Sheets… | CALL_EXT | this.spdMain.Sheets[0].GetColumnLabel | (0, e.Column) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0028_Delivery_Tracking_LT.TTL1_5_Average_Maximum_MinimumValueDisplay

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4db7f291 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:856 | for (DTTL <= 5) ▸ if (ds.Tables[0].Rows[j][TTL] != DBNull.Value) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 1, Math.Round(System.Convert.ToDouble(ds.Tables[0].Ro… | 그리드 값 설정 |  |  |  |
| AC-418cdaca | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:861 | for (DTTL <= 5) ▸ if (ds.Tables[0].Rows[j][TTL] != DBNull.Value) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 2, Math.Round(System.Convert.ToDouble(ds.Tables[0].Ro… | 그리드 값 설정 |  |  |  |
| AC-89d82ad3 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SSP0028_Delivery_Tracking_LT.cs:866 | for (DTTL <= 5) ▸ if (ds.Tables[0].Rows[j][TTL] != DBNull.Value) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 3, Math.Round(System.Convert.ToDouble(ds.Tables[0].Ro… | 그리드 값 설정 |  |  |  |

## SSP0028_Delivery_Tracking_LT.TTLROWHIDE

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-907d363c | FindButton [try] | SSP0028_Delivery_Tracking_LT.cs:348 | for (i < spdMain.Sheets[0].RowCount) ▸ if (sep.Length == 2) ▸ for (j < 5) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | ((i + j) + 1, visible) | ⚠ 의미 확인 필요 |  |  |  |

