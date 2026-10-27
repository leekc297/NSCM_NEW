# AS-IS 액션 대조표 — SCP0102

> 원천: `Doc/asisfacts/screens/SCP0102/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 379행 · 메서드 43 · 종류 DATA_OP 113 · FLAG 69 · GRID_SET 64 · CALL_EXT 34 · ENDPOINT 20 · GRID_INIT 20 · RETURN 14 · LIST_REBIND 13 · UI_PROP 6 · UI_MISC 4 · POPUP 4 · GRID_LOCK 3 · LIST_CLEAR 3 · VALUE_SET 3 · GRID_BIND 2 · CALL_BASE 2 · GRID_STYLE 2 · COMBO_DATA 2 · VALIDATE 1 · ⚠ 의미 확인 필요 36


## SCP0102_BOD_Validation_Report.AccuracyRange_NO

진입점: cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true) ▸ else of (AccuracyRangeCheck(System.Convert.ToInt32(Range[0]), System.Convert.ToInt32(Range[1]), Val) == true)] / FindButton [try ▸ if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true) ▸ else of (AccuracyRangeCheck(System.Convert.ToInt32(Range[0]), System.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8020e14 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1513 |  | GRID_SET | this.spdMain.Sheets[0].SetValue | (Rowindex, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-98193456 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1517 | for (j <= 3) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (Rowindex, Visible) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f1583b84 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1522 |  | RETURN | return Rowindex; |  | 처리 중단/반환 |  |  |  |

## SCP0102_BOD_Validation_Report.AccuracyRange_NoNumber

진입점: cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ else of (Ok_Number == true)] / FindButton [try ▸ if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ else of (Ok_Number == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3776f0f1 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1528 |  | GRID_SET | this.spdMain.Sheets[0].SetValue | (Rowindex, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-aa4b5525 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1532 | for (j <= 3) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (Rowindex, Visible) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12de753d | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1537 |  | RETURN | return Rowindex; |  | 처리 중단/반환 |  |  |  |

## SCP0102_BOD_Validation_Report.AccuracyRange_OK

진입점: cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true) ▸ if (AccuracyRangeCheck(System.Convert.ToInt32(Range[0]), System.Convert.ToInt32(Range[1]), Val) == true)] / FindButton [try ▸ if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true) ▸ if (AccuracyRangeCheck(System.Convert.ToInt32(Range[0]), System.Convert.To…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf0ece8d | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1496 |  | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (Rowindex, Visible) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93c6825b | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1498 |  | GRID_SET | this.spdMain.Sheets[0].SetValue | (Rowindex, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-3815d398 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1503 | for (j <= 3) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (Rowindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cefa8e2 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1507 |  | RETURN | return Rowindex; |  | 처리 중단/반환 |  |  |  |

## SCP0102_BOD_Validation_Report.AccuracyRange_SelectALL

진입점: cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.ControlValues != "ALL")] / FindButton [try ▸ else of (cboAccuracy.ControlValues != "ALL")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b34994b | cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.Contr… 외 1 | SCP0102_BOD_Validation_Report.cs:1545 |  | CALL_EXT | this.spdMain.Sheets[0].SetColumnLabel | (0, G_TTLColumnIndex, "구분 ▼") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f081511 | cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.Contr… 외 1 | SCP0102_BOD_Validation_Report.cs:1555 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (i, Visible) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d152e90 | cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.Contr… 외 1 | SCP0102_BOD_Validation_Report.cs:1557 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) | GRID_SET | this.spdMain.Sheets[0].SetValue | (i, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-f8e38323 | cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.Contr… 외 1 | SCP0102_BOD_Validation_Report.cs:1562 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j <= 3) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f1b6e94 | cboAccuracy.SelectedIndexChanged [else of (cboAccuracy.Contr… 외 1 | SCP0102_BOD_Validation_Report.cs:1572 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < G_AccuracyColorIndex.Count) | GRID_SET | spdMain.Sheets[0].Cells[System.Convert.ToInt32(sep[0]), System.Convert.ToInt32(sep[1])].Ba… | Color.White | 그리드 속성/값 설정 |  |  |  |

## SCP0102_BOD_Validation_Report.AccuracyRangeCheck

진입점: cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true)] / FindButton [try ▸ if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (Ok_Number == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce15ea03 | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:1490 |  | RETURN | return Check; |  | 처리 중단/반환 |  |  |  |

## SCP0102_BOD_Validation_Report.btn_Search_Click

진입점: this.btn_Search.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73c55360 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1764 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL") ⇒ SCP.SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-c1d52aa0 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1765 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5fa9b581 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1766 |  | DATA_OP | request.Parameters["p_from_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-191137e3 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1767 |  | DATA_OP | request.Parameters["p_to_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-30334b75 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1768 |  | DATA_OP | request.Parameters["p_from_site"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b09264df | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1769 |  | DATA_OP | request.Parameters["p_to_site"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-804f0c67 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1770 |  | DATA_OP | request.Parameters["p_bod_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b8503891 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1771 |  | DATA_OP | request.Parameters["p_route_id "] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6a15835 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1772 |  | DATA_OP | request.Parameters["p_from_country"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-66c37f0c | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1773 |  | DATA_OP | request.Parameters["p_to_country"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5b83885 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1774 |  | DATA_OP | request.Parameters["p_from_city"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8171c5d7 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1775 |  | DATA_OP | request.Parameters["p_to_city"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6bfa74ce | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1776 |  | DATA_OP | request.Parameters["p_from_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-10b076d7 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1777 |  | DATA_OP | request.Parameters["p_to_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ea654aae | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1781 | if (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_exfactory_from_yyyymmdd"] | p_exfactory_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-87d146d1 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1782 | if (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_exfactory_to_yyyymmdd"] | p_exfactory_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fa581e0a | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1783 | if (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_fdest_from_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ab38944b | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1784 | if (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_fdest_to_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3997bbf9 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1788 | else of (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_exfactory_from_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dfa0dacb | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1789 | else of (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_exfactory_to_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7c7bb4e8 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1790 | else of (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_fdest_from_yyyymmdd"] | p_fdest_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-16ff124d | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1791 | else of (rdoExFactory.Checked == true) | DATA_OP | request.Parameters["p_fdest_to_yyyymmdd"] | p_fdest_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-28d58042 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1794 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1ece1137 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1799 |  | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-02be12b3 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1801 |  | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-46b61aa8 | this.btn_Search.Click | SCP0102_BOD_Validation_Report.cs:1803 |  | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0102_BOD_Validation_Report.cboFromCountry_SelectedIndexChanged

진입점: cboFromCountry.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-549ae561 | cboFromCountry.SelectedIndexChanged | SCP0102_BOD_Validation_Report.cs:1353 |  | LIST_CLEAR | this.cboFromCity.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-4dc9301a | cboFromCountry.SelectedIndexChanged | SCP0102_BOD_Validation_Report.cs:1354 |  | LIST_CLEAR | this.cboToCity.Items.Clear | () | 목록 항목 비움 |  |  |  |

## SCP0102_BOD_Validation_Report.cboToCountry_SelectedIndexChanged

진입점: cboToCountry.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe07a428 | cboToCountry.SelectedIndexChanged | SCP0102_BOD_Validation_Report.cs:1367 |  | LIST_CLEAR | this.cboToCity.Items.Clear | () | 목록 항목 비움 |  |  |  |

## SCP0102_BOD_Validation_Report.CheckNumber

진입점: cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j >= 0)] / FindButton [try ▸ for (i < ds.Tables[0].Columns.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9845c2a | cboAccuracy.SelectedIndexChanged [if (cboAccuracy.ControlVal… 외 1 | SCP0102_BOD_Validation_Report.cs:791 |  | RETURN | return isNumeric; |  | 처리 중단/반환 |  |  |  |

## SCP0102_BOD_Validation_Report.CreateMonthlyGrid

진입점: FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1f8cac3 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:280 | if (G_MonthlyIndex.Count != 0) | CALL_EXT | G_MonthlyIndex.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e37c669 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:285 |  | GRID_INIT | siMain.Freeze | (0, G_MainGriHeaderdColumnIndex) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-77fa9057 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:295 | for (i < G_GRID_MONTH_HEADER.Count) | CALL_EXT | siMain.AddColumns | (G_MainGriHeaderdColumnIndex, G_Month_ColumnICount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7dce421e | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:296 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (0, G_MainGriHeaderdColumnIndex, 1, G_Month_ColumnICount, 20, G_GRID_MONTH_HEADER[i].ToStr… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f9a1b9b | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:299 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | G_MonthlyIndex.Add | (G_GRID_MONTH_HEADER[i] + "/" + G_MainGriHeaderdColumnIndex.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-558d37f8 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:301 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, G_MainGriHeaderdColumnIndex, 2, 1, 20, "기준LT(과거계획평균)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ca068e1 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:302 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, G_MainGriHeaderdColumnIndex + 1, 1, 4, 20, "실적 L/T", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc544088 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:303 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.SetColumnHeader | (2, G_MainGriHeaderdColumnIndex + 1, "평균") | 그리드 재구성/초기화 |  |  |  |
| AC-240b1a71 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:303 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | GColumnVisible[0] | GColumnVisible[0] + (G_MainGriHeaderdColumnIndex + 1).ToString() + "," | 행/컬럼 값 대입 |  |  |  |
| AC-387b4d9b | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:304 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.SetColumnHeader | (2, G_MainGriHeaderdColumnIndex + 2, "최대") | 그리드 재구성/초기화 |  |  |  |
| AC-bf977eb9 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:304 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | GColumnVisible[1] | GColumnVisible[1] + (G_MainGriHeaderdColumnIndex + 2).ToString() + "," | 행/컬럼 값 대입 |  |  |  |
| AC-162b163c | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:305 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.SetColumnHeader | (2, G_MainGriHeaderdColumnIndex + 3, "최소") | 그리드 재구성/초기화 |  |  |  |
| AC-618c1163 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:305 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | GColumnVisible[2] | GColumnVisible[2] + (G_MainGriHeaderdColumnIndex + 3).ToString() + "," | 행/컬럼 값 대입 |  |  |  |
| AC-65ad3b9c | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:306 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.SetColumnHeader | (2, G_MainGriHeaderdColumnIndex + 4, "CI 80%") | 그리드 재구성/초기화 |  |  |  |
| AC-445f1262 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:306 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | GColumnVisible[3] | GColumnVisible[3] + (G_MainGriHeaderdColumnIndex + 4).ToString() + "," | 행/컬럼 값 대입 |  |  |  |
| AC-0fd09aff | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:308 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, G_MainGriHeaderdColumnIndex + 5, 2, 1, 20, "정확도(%)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8bc33ba | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:308 | for (i < G_GRID_MONTH_HEADER.Count) | DATA_OP | GColumnVisible[4] | GColumnVisible[4] + (G_MainGriHeaderdColumnIndex + 5).ToString() + "," | 행/컬럼 값 대입 |  |  |  |
| AC-34d5cb2e | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:309 | for (i < G_GRID_MONTH_HEADER.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, G_MainGriHeaderdColumnIndex + 6, 2, 1, 20, "차이", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06f1a8be | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:310 | for (i < G_GRID_MONTH_HEADER.Count) | FLAG | G_MainGriHeaderdColumnIndex | += G_Month_ColumnICount | 화면 필드/플래그 변경 |  |  |  |
| AC-49f619fe | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:314 |  | CALL_EXT | siMain.AddRows | (0, MakeRowCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7e9d83a | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:321 | for (i < MakeRowCount) ▸ if (i == 0) | GRID_SET | spdMain.Sheets[0].Cells[i, G_RouteIDIndex].BackColor | colorLink | 그리드 속성/값 설정 |  |  |  |
| AC-ad819af2 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:322 | for (i < MakeRowCount) ▸ if (i == 0) | GRID_SET | spdMain.Sheets[0].Cells[i, G_ShipmentCountIndex].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-62afb44d | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:323 | for (i < MakeRowCount) ▸ if (i == 0) | GRID_SET | spdMain.Sheets[0].Cells[i, G_TTLColumnIndex].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-527f260b | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:324 | for (i < MakeRowCount) ▸ if (i == 0) | GRID_SET | spdMain.Sheets[0].SetValue | (i, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-a1f7675d | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:338 | for (i < MakeRowCount) ▸ if (i == 0) ▸ for (j <= 3) | GRID_SET | spdMain.Sheets[0].SetValue | (j, G_TTLColumnIndex, "TTL" + _str) | 그리드 값 설정 |  |  |  |
| AC-ed5a6e9b | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:348 | for (i < MakeRowCount) ▸ else of (i == 0) ▸ if (YELLOWCOLORCELL_Index == G_OneDataRowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, G_RouteIDIndex].BackColor | colorLink | 그리드 속성/값 설정 |  |  |  |
| AC-18bd5c0e | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:349 | for (i < MakeRowCount) ▸ else of (i == 0) ▸ if (YELLOWCOLORCELL_Index == G_OneDataRowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, G_ShipmentCountIndex].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-bffa8ad2 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:350 | for (i < MakeRowCount) ▸ else of (i == 0) ▸ if (YELLOWCOLORCELL_Index == G_OneDataRowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, G_TTLColumnIndex].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-e1f57f1e | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:351 | for (i < MakeRowCount) ▸ else of (i == 0) ▸ if (YELLOWCOLORCELL_Index == G_OneDataRowCount) | GRID_SET | spdMain.Sheets[0].SetValue | (i, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-43a5e192 | FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)] | SCP0102_BOD_Validation_Report.cs:367 | for (i < MakeRowCount) ▸ else of (i == 0) ▸ if (YELLOWCOLORCELL_Index == G_OneDataRowCount) ▸ for (j <= 3) | GRID_SET | spdMain.Sheets[0].SetValue | (j + i, G_TTLColumnIndex, "TTL" + _str) | 그리드 값 설정 |  |  |  |

## SCP0102_BOD_Validation_Report.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b487ab8 | this.Load | SCP0102_BOD_Validation_Report.cs:244 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-014716cc | this.Load | SCP0102_BOD_Validation_Report.cs:245 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a60bb827 | this.Load | SCP0102_BOD_Validation_Report.cs:248 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtDetail, SpdSheet.shtDetail, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb37a82e | this.Load | SCP0102_BOD_Validation_Report.cs:249 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, spdDetail.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3ebdf5a8 | this.Load | SCP0102_BOD_Validation_Report.cs:254 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0102_BOD_Validation_Report.Difference_Individual_Values

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70979301 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1318 | for (DTTL <= 3) ▸ if (ds.Tables[0].Rows[j][DR] != DBNull.Value && ds.Tables[0].Rows[j][TTL] != DBNull.Value) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 6, System.Convert.ToInt32(Math.Round(System.Convert.T… | 그리드 값 설정 |  |  |  |

## SCP0102_BOD_Validation_Report.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fe5de9f | Dispose | SCP0102_BOD_Validation_Report.designer.cs:19 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0102_BOD_Validation_Report.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d37d32a1 | FindButton | SCP0102_BOD_Validation_Report.cs:571 |  | CALL_EXT | G_GRID_MONTH_HEADER.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e1ec054 | FindButton | SCP0102_BOD_Validation_Report.cs:573 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cf43cf7b | FindButton | SCP0102_BOD_Validation_Report.cs:577 | try | FLAG | G_MainGriHeaderdColumnIndex | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b1922a8e | FindButton | SCP0102_BOD_Validation_Report.cs:581 | try ▸ for (i < GColumnVisible.Length) | DATA_OP | GColumnVisible[i] | null | 행/컬럼 값 대입 |  |  |  |
| AC-a21699ca | FindButton | SCP0102_BOD_Validation_Report.cs:583 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9ed39291 | FindButton | SCP0102_BOD_Validation_Report.cs:604 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-48fff402 | FindButton | SCP0102_BOD_Validation_Report.cs:605 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", sBinding)) { var request = new FoxD… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-693c6928 | FindButton | SCP0102_BOD_Validation_Report.cs:609 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0102_GET_BOD_VALIDATION_REPORT") ⇒ SCP.SCP0102_GET_BOD_VALIDATION_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-ff59dbad | FindButton | SCP0102_BOD_Validation_Report.cs:610 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-411543d8 | FindButton | SCP0102_BOD_Validation_Report.cs:611 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-71795e1c | FindButton | SCP0102_BOD_Validation_Report.cs:612 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5dee8a96 | FindButton | SCP0102_BOD_Validation_Report.cs:613 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-aa35caba | FindButton | SCP0102_BOD_Validation_Report.cs:614 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-c11dc1da | FindButton | SCP0102_BOD_Validation_Report.cs:615 | try ▸ lambda | DATA_OP | request.Parameters["p_PIVOT_yyyymm"] | (object)Set_PIVOT_DATE(p_from_yyyymmdd.ToString(), p_to_yyyymmdd.ToString()) | 행/컬럼 값 대입 |  |  |  |
| AC-6749349b | FindButton | SCP0102_BOD_Validation_Report.cs:616 | try ▸ lambda | DATA_OP | request.Parameters["p_from_country"] | p_from_country | 행/컬럼 값 대입 |  |  |  |
| AC-cde577e4 | FindButton | SCP0102_BOD_Validation_Report.cs:617 | try ▸ lambda | DATA_OP | request.Parameters["p_to_country"] | p_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-e239c100 | FindButton | SCP0102_BOD_Validation_Report.cs:618 | try ▸ lambda | DATA_OP | request.Parameters["p_from_city"] | p_from_city | 행/컬럼 값 대입 |  |  |  |
| AC-5923f318 | FindButton | SCP0102_BOD_Validation_Report.cs:619 | try ▸ lambda | DATA_OP | request.Parameters["p_to_city"] | p_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-572bc103 | FindButton | SCP0102_BOD_Validation_Report.cs:620 | try ▸ lambda | DATA_OP | request.Parameters["p_from_area"] | p_from_area | 행/컬럼 값 대입 |  |  |  |
| AC-f231e1ae | FindButton | SCP0102_BOD_Validation_Report.cs:621 | try ▸ lambda | DATA_OP | request.Parameters["p_to_area"] | p_to_area | 행/컬럼 값 대입 |  |  |  |
| AC-2fda2dbf | FindButton | SCP0102_BOD_Validation_Report.cs:623 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0ceed2c7 | FindButton | SCP0102_BOD_Validation_Report.cs:624 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-877d4cc1 | FindButton | SCP0102_BOD_Validation_Report.cs:631 | try ▸ if (!CommonUtils.CheckDataEmpty(ds) && !CommonUtils.CheckDataEmpty(ds.Tables[2])) | FLAG | dtCI80 | ds.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-eb364442 | FindButton | SCP0102_BOD_Validation_Report.cs:641 | try ▸ if (G_GRID_MONTH_HEADER.Count > 0) | FLAG | G_MainGriHeaderdColumnIndex | spdMain.Sheets[0].ColumnCount | 화면 필드/플래그 변경 |  |  |  |
| AC-84376a6c | FindButton | SCP0102_BOD_Validation_Report.cs:657 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3fc28cfa | FindButton | SCP0102_BOD_Validation_Report.cs:663 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3d39e93f | FindButton | SCP0102_BOD_Validation_Report.cs:672 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0102_BOD_Validation_Report.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a67420c | this.Load | SCP0102_BOD_Validation_Report.cs:119 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0102_BOD_Validation_Report.Get_Month_Index

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86ee0854 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1336 |  | RETURN | return rvalue; |  | 처리 중단/반환 |  |  |  |

## SCP0102_BOD_Validation_Report.GetCI80

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95f8c28e | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1011 | try | FLAG | strSUM_TTL_AVG_CI_80 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-a8c4d454 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1013 | try | FLAG | FILTER | string.Format("BOD_ID = '{0}' AND Y_YEAR = '{1}'", BOD_ID, MONTH) | 화면 필드/플래그 변경 |  |  |  |
| AC-d85e2b3d | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1014 | try | FLAG | findRowsCI | CommonUtils.FindData(dtCI80, FILTER) | 화면 필드/플래그 변경 |  |  |  |
| AC-6aff218b | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1014 | try | ENDPOINT | CommonUtils.FindData | (dtCI80, FILTER) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5580cff4 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1018 | try ▸ foreach (DataRow row in findRowsCI) | FLAG | strSUM_TTL_AVG_CI_80 | CommonUtils.GetValue(row["CI_TTL"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-81f2baa1 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1028 | try | FLAG | strSUM_TTL_AVG_CI_80 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-a34838d8 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1030 | try | FLAG | FILTER | string.Format("BOD_ID = '{0}' AND Y_YEAR = '{1}'", BOD_ID, MONTH) | 화면 필드/플래그 변경 |  |  |  |
| AC-705db7d0 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1031 | try | FLAG | findRowsCI | CommonUtils.FindData(dtCI80, FILTER) | 화면 필드/플래그 변경 |  |  |  |
| AC-c62c7afc | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1031 | try | ENDPOINT | CommonUtils.FindData | (dtCI80, FILTER) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f909cd73 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1035 | try ▸ foreach (DataRow row in findRowsCI) | FLAG | strSUM_TTL_AVG_CI_80 | CommonUtils.GetValue(row["CI_" + colName]) | 화면 필드/플래그 변경 |  |  |  |

## SCP0102_BOD_Validation_Report.GetCI80_OLD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc4c2df3 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1048 | try | FLAG | strSUM_TTL_AVG_CI_80 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-91db4cfd | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1050 | try | FLAG | FILTER | string.Format("BOD_ID = '{0}' AND Y_YEAR = '{1}'", BOD_ID, MONTH) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b372f15 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1051 | try | FLAG | findRowsCI | CommonUtils.FindData(dtCI80, FILTER) | 화면 필드/플래그 변경 |  |  |  |
| AC-1cd5fa47 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1051 | try | ENDPOINT | CommonUtils.FindData | (dtCI80, FILTER) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f3d01687 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1055 | try ▸ foreach (DataRow row in findRowsCI) | FLAG | oCI_UP | row["CI_TTL_UP"] | 화면 필드/플래그 변경 |  |  |  |
| AC-1954a5d7 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1056 | try ▸ foreach (DataRow row in findRowsCI) | FLAG | oCI_DOWN | row["CI_TTL_DOWN"] | 화면 필드/플래그 변경 |  |  |  |
| AC-e5f7f634 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1059 | try ▸ foreach (DataRow row in findRowsCI) ▸ if (CommonUtils.CheckDataEmpty(oCI_UP) == false \|\| CommonUtils.CheckDataEmpty(oCI_DOWN) == fal… | FLAG | strSUM_TTL_AVG_CI_80 | string.Format("{0} ~ {1}", oCI_DOWN, oCI_UP) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d290c4f | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1071 | try | FLAG | strSUM_TTL_AVG_CI_80 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0073d9fe | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1073 | try | FLAG | FILTER | string.Format("BOD_ID = '{0}' AND Y_YEAR = '{1}'", BOD_ID, MONTH) | 화면 필드/플래그 변경 |  |  |  |
| AC-e761e58d | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1074 | try | FLAG | findRowsCI | CommonUtils.FindData(dtCI80, FILTER) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5d81554 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1074 | try | ENDPOINT | CommonUtils.FindData | (dtCI80, FILTER) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0932c433 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1078 | try ▸ foreach (DataRow row in findRowsCI) | FLAG | oCI_UP | row["CI_" + colName + "_UP"] | 화면 필드/플래그 변경 |  |  |  |
| AC-657f7742 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1079 | try ▸ foreach (DataRow row in findRowsCI) | FLAG | oCI_DOWN | row["CI_" + colName + "_DOWN"] | 화면 필드/플래그 변경 |  |  |  |
| AC-940dfcc7 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:1082 | try ▸ foreach (DataRow row in findRowsCI) ▸ if (CommonUtils.CheckDataEmpty(oCI_UP) == false \|\| CommonUtils.CheckDataEmpty(oCI_DOWN) == fal… | FLAG | strSUM_TTL_AVG_CI_80 | string.Format("{0} ~ {1}", oCI_DOWN, oCI_UP) | 화면 필드/플래그 변경 |  |  |  |

## SCP0102_BOD_Validation_Report.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad120bb1 | this.Load | SCP0102_BOD_Validation_Report.cs:559 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-e40f7452 | this.Load | SCP0102_BOD_Validation_Report.cs:560 |  | DATA_OP | request.Parameters["p_from_date"] | sFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-d4deb8a8 | this.Load | SCP0102_BOD_Validation_Report.cs:561 |  | DATA_OP | request.Parameters["p_offset_day"] | "30" | 행/컬럼 값 대입 |  |  |  |
| AC-d8a6ee8b | this.Load | SCP0102_BOD_Validation_Report.cs:562 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-aa0c6353 | this.Load | SCP0102_BOD_Validation_Report.cs:563 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-de4a77c9 | this.Load | SCP0102_BOD_Validation_Report.cs:566 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0102_BOD_Validation_Report.Individual_Accuracy_Values

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-650ffd40 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1260 |  | FLAG | oBOD_ID | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3925faf4 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1261 |  | FLAG | oBOD_ID | ds.Tables[0].Rows[j]["BOD_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-59e5cc5a | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1276 | for (DTTL <= 3) | FLAG | oDR | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f303d933 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1277 | for (DTTL <= 3) | FLAG | oTTL | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0a318b8a | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1278 | for (DTTL <= 3) | FLAG | dAccuracy | 0.0 | 화면 필드/플래그 변경 |  |  |  |
| AC-756941da | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1279 | for (DTTL <= 3) | FLAG | oDR | ds.Tables[0].Rows[j][DR] | 화면 필드/플래그 변경 |  |  |  |
| AC-3ef16946 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1280 | for (DTTL <= 3) | FLAG | oTTL | ds.Tables[0].Rows[j][TTL] | 화면 필드/플래그 변경 |  |  |  |
| AC-90b25a3b | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1283 | for (DTTL <= 3) ▸ if (oDR != DBNull.Value && oTTL != DBNull.Value) | FLAG | dDR | System.Convert.ToDouble(oDR) | 화면 필드/플래그 변경 |  |  |  |
| AC-d05e80c0 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1284 | for (DTTL <= 3) ▸ if (oDR != DBNull.Value && oTTL != DBNull.Value) | FLAG | dTTL | System.Convert.ToDouble(oTTL) | 화면 필드/플래그 변경 |  |  |  |
| AC-df3086eb | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1288 | for (DTTL <= 3) ▸ if (oDR != DBNull.Value && oTTL != DBNull.Value) ▸ if (dDR != 0) | FLAG | dAccuracy | Math.Round((1 - Math.Abs(dDR - dTTL) / dDR) * 100) | 화면 필드/플래그 변경 |  |  |  |
| AC-c48037a1 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1289 | for (DTTL <= 3) ▸ if (oDR != DBNull.Value && oTTL != DBNull.Value) ▸ if (dDR != 0) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 5, dAccuracy) | 그리드 값 설정 |  |  |  |
| AC-c51fef10 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1293 | for (DTTL <= 3) ▸ if (oDR != DBNull.Value && oTTL != DBNull.Value) ▸ else of (dDR != 0) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 5, null) | 그리드 값 설정 |  |  |  |

## SCP0102_BOD_Validation_Report.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38b3361d | this.Load | SCP0102_BOD_Validation_Report.cs:132 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-c57cb9b3 | this.Load | SCP0102_BOD_Validation_Report.cs:133 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-291c5f78 | this.Load | SCP0102_BOD_Validation_Report.cs:135 |  | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9765865f | this.Load | SCP0102_BOD_Validation_Report.cs:137 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-91f4a73a | this.Load | SCP0102_BOD_Validation_Report.cs:140 | if (G_dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-96ce2262 | this.Load | SCP0102_BOD_Validation_Report.cs:142 |  | FLAG | G_dtMyDivision | G_dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-b93e934c | this.Load | SCP0102_BOD_Validation_Report.cs:142 |  | DATA_OP | G_dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-96515b89 | this.Load | SCP0102_BOD_Validation_Report.cs:142 |  | DATA_OP | G_dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5723e85d | this.Load | SCP0102_BOD_Validation_Report.cs:143 |  | LIST_REBIND | clsCtrl.setListBox | (G_dtMyDivision, clbDivision_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7849fb32 | this.Load | SCP0102_BOD_Validation_Report.cs:153 |  | VALUE_SET | drpPeriod.InitValue | _yyyyMM + "01" + ":" + _yyyyMM + DateTime.DaysInMonth(_yyyy, _MM) | 컨트롤 값 설정 |  |  |  |
| AC-498347d8 | this.Load | SCP0102_BOD_Validation_Report.cs:153 |  | CALL_EXT | DateTime.DaysInMonth | (_yyyy, _MM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e4dfc15 | this.Load | SCP0102_BOD_Validation_Report.cs:156 |  | VALUE_SET | drpExfactory.InitValue | GetDayRange("") | 컨트롤 값 설정 |  |  |  |
| AC-e10b4013 | this.Load | SCP0102_BOD_Validation_Report.cs:157 |  | VALUE_SET | drpFDest.InitValue | GetDayRange("") | 컨트롤 값 설정 |  |  |  |

## SCP0102_BOD_Validation_Report.InitSpread

진입점: this.Load / clbDivision_ID.SelectedIndexChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a10b7f3e | this.Load 외 2 | SCP0102_BOD_Validation_Report.cs:260 | if (spreadInfo.ActiveSheet.RowCount != 0) | GRID_SET | spreadInfo.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-0324e658 | this.Load 외 2 | SCP0102_BOD_Validation_Report.cs:263 |  | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-4e91ba78 | this.Load 외 2 | SCP0102_BOD_Validation_Report.cs:264 |  | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-17b12fe0 | this.Load 외 2 | SCP0102_BOD_Validation_Report.cs:268 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ef3f2ac4 | this.Load 외 2 | SCP0102_BOD_Validation_Report.cs:271 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ for (i < G_MainGridColumnCount) | GRID_INIT | siMain.ColumnHeaderSpan | (0, i, 3, 1, 20, spdMain.Sheets[0].GetColumnLabel(2, i), FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-033286dd | this.Load 외 2 | SCP0102_BOD_Validation_Report.cs:271 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ for (i < G_MainGridColumnCount) | CALL_EXT | spdMain.Sheets[0].GetColumnLabel | (2, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-494df18b | this.Load 외 2 | SCP0102_BOD_Validation_Report.cs:274 |  | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0102_BOD_Validation_Report.KuBunHeaderClick_ALL_Close

진입점: spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ else of (e.ColumnHeader == false) ▸ if (this.spdMain.Sheets[0].RowCount != 0) ▸ if (sep.Length == 2) ▸ if (sep[1] == "▲")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c715bcea | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SCP0102_BOD_Validation_Report.cs:1708 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) | CALL_EXT | this.spdMain.Sheets[0].SetColumnLabel | (0, ColumnIndex, "구분 ▼") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2971e38 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SCP0102_BOD_Validation_Report.cs:1712 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") | GRID_SET | this.spdMain.Sheets[0].SetValue | (i, ColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-f57695ae | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SCP0102_BOD_Validation_Report.cs:1715 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") ▸ for (j <= 3) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (i + j, Visible) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0102_BOD_Validation_Report.KuBunHeaderClick_ALL_Show

진입점: spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ else of (e.ColumnHeader == false) ▸ if (this.spdMain.Sheets[0].RowCount != 0) ▸ if (sep.Length == 2) ▸ else of (sep[1] == "▲")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bf5c617 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SCP0102_BOD_Validation_Report.cs:1732 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) | CALL_EXT | this.spdMain.Sheets[0].SetColumnLabel | (0, ColumnIndex, "구분 ▲") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef3504f5 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SCP0102_BOD_Validation_Report.cs:1736 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") | GRID_SET | this.spdMain.Sheets[0].SetValue | (i, ColumnIndex, "TTL ▲") | 그리드 값 설정 |  |  |  |
| AC-148e7329 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SCP0102_BOD_Validation_Report.cs:1738 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") | CALL_EXT | this.spdMain.Sheets[0].GetRowVisible | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0e079c6 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SCP0102_BOD_Validation_Report.cs:1742 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") ▸ for (j <= 3) | CALL_EXT | this.spdMain.Sheets[0].GetRowVisible | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c9c9a30 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SCP0102_BOD_Validation_Report.cs:1743 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") ▸ for (j <= 3) ▸ if (this.spdMain… | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (i + j, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57dc4014 | spdMain.CellDoubleClick [else of (e.Column == G_ShipmentCoun… | SCP0102_BOD_Validation_Report.cs:1744 | for (i < this.spdMain.Sheets[0].RowCount) ▸ if (sep2.Length == 2) ▸ if (sep2[1] == "▲" \|\| sep[1] == "▼") ▸ for (j <= 3) ▸ else of (this.sp… | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (i + j, Visible) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0102_BOD_Validation_Report.Make_Accuracy_ComboBox

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a42db0fd | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:440 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-35036b81 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:441 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3fb53e8 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:443 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e6cd3ff | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:445 |  | DATA_OP | row["CODE"] | "91/100" | 행/컬럼 값 대입 |  |  |  |
| AC-3014737f | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:446 |  | DATA_OP | row["NAME"] | "91~100%" | 행/컬럼 값 대입 |  |  |  |
| AC-1a7ca8dc | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:447 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-024bbc20 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:449 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d17cec9e | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:450 |  | DATA_OP | row["CODE"] | "81/90" | 행/컬럼 값 대입 |  |  |  |
| AC-c3dad124 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:451 |  | DATA_OP | row["NAME"] | "81~90%" | 행/컬럼 값 대입 |  |  |  |
| AC-13e1e89a | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:453 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-060bba71 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:454 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-04ce4d08 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:455 |  | DATA_OP | row["CODE"] | "51/80" | 행/컬럼 값 대입 |  |  |  |
| AC-5b1d47ea | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:456 |  | DATA_OP | row["NAME"] | "51~80%" | 행/컬럼 값 대입 |  |  |  |
| AC-c9b5abbd | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:457 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7ead6e1 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:459 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fe53bd0c | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:460 |  | DATA_OP | row["CODE"] | "0/50" | 행/컬럼 값 대입 |  |  |  |
| AC-6bbb5591 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:461 |  | DATA_OP | row["NAME"] | "0~50%" | 행/컬럼 값 대입 |  |  |  |
| AC-3d5a054b | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:462 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd2b5dab | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:464 |  | LIST_REBIND | clsCtrl.setListBox | (dt, cboAccuracy, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0102_BOD_Validation_Report.Make_Area_ComboBox

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbda6feb | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:473 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0028_GET_AREA") ⇒ SSP.SSP0028_GET_AREA | 엔드포인트 요청 생성 |  |  |  |
| AC-2c67c30b | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:474 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7a0be0be | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:478 |  | DATA_OP | ds.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8f500fd4 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:480 |  | DATA_OP | row["NAME"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-4bc6edfa | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:481 |  | DATA_OP | row["CODE"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-f27ff589 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:483 |  | CALL_EXT | ds.Tables[0].Rows.InsertAt | (row, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b07b8de3 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:484 |  | FLAG | this.G_dtFromArea | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-5d9fc7aa | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:485 |  | FLAG | this.G_dtToArea | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-0683c26e | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:485 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bf560b63 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:487 |  | LIST_REBIND | clsCtrl.setListBox | (G_dtFromArea, cboFromArea, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2ef55a0a | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:488 |  | LIST_REBIND | clsCtrl.setListBox | (G_dtToArea, cboToArea, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0102_BOD_Validation_Report.Make_InquiryClassification_ComboBox

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13640166 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:406 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc6ea2e9 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:407 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9359377f | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:409 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b6ad2528 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:411 |  | DATA_OP | row["CODE"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-839081e6 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:412 |  | DATA_OP | row["NAME"] | "평균" | 행/컬럼 값 대입 |  |  |  |
| AC-8807aaf7 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:413 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fe2bb4d | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:415 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cacbd83d | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:416 |  | DATA_OP | row["CODE"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-afb6d96d | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:417 |  | DATA_OP | row["NAME"] | "최대" | 행/컬럼 값 대입 |  |  |  |
| AC-8b198bab | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:419 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-624b55de | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:420 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2472aacc | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:421 |  | DATA_OP | row["CODE"] | 2 | 행/컬럼 값 대입 |  |  |  |
| AC-ce0d81ae | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:422 |  | DATA_OP | row["NAME"] | "최소" | 행/컬럼 값 대입 |  |  |  |
| AC-ac6c3cea | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:423 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-79cf9647 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:425 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a3843db8 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:426 |  | DATA_OP | row["CODE"] | 3 | 행/컬럼 값 대입 |  |  |  |
| AC-a7b74dd7 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:427 |  | DATA_OP | row["NAME"] | "정확도" | 행/컬럼 값 대입 |  |  |  |
| AC-1f109c0f | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:428 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-b78efa9a | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:430 |  | LIST_REBIND | clsCtrl.setListBox | (dt, cboInquiryClassification, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d50254f4 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:433 | for (i < dt.Rows.Count) | CALL_EXT | cboInquiryClassification.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0102_BOD_Validation_Report.OpenDistributionRoute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6245b974 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:509 | if (siDetail.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4eb265e | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:514 | if (oROUTE_ID == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b936cc1e | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:520 | if (string.IsNullOrWhiteSpace(ROUTE_ID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f555efa6 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:523 |  | CALL_EXT | BaseForm.CreateManualSearchCondtion | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c014e50 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:524 |  | CALL_EXT | BaseForm.SetManualCondition | (Msc, "ROUTE_ID", ROUTE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b264400 | (진입점 미연결) | SCP0102_BOD_Validation_Report.cs:526 |  | CALL_BASE | openSubMenu | ("SCP0005", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0102_BOD_Validation_Report.OpenDistributionRouteHistory

진입점: spdDetail.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5d1de5e | spdDetail.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:531 |  | POPUP | new GSCM.SCM.PopUp.UIL.SCP0005_DistributionRoutePopup | () | 팝업/폼 생성 |  |  |  |
| AC-e8d0c76e | spdDetail.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:533 |  | UI_PROP | popup.Width | 1280 | 속성 Width 설정 |  |  |  |
| AC-a568892c | spdDetail.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:534 |  | UI_PROP | popup.Height | 600 | 속성 Height 설정 |  |  |  |
| AC-25c5cd49 | spdDetail.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:535 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d97870b3 | spdDetail.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:536 |  | UI_PROP | popup.ROUTE_ID | route_id | 속성 ROUTE_ID 설정 |  |  |  |
| AC-4efe2f22 | spdDetail.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:538 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0102_BOD_Validation_Report.PastPlanAverage_Maximum_Minimum_SUM

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cc74490 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1097 | try | FLAG | BOD_ID | ds.Tables[0].Rows[j]["BOD_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3f45adf2 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1122 | try | FLAG | iSetMax | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-375f6bc6 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1123 | try | FLAG | iSetMin | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-a66ee917 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1126 | try | FLAG | FILTER | string.Format("{0} = '{1}'", "BOD_ID", BOD_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b7c7c64 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1127 | try | FLAG | findRows | CommonUtils.FindData(ds.Tables[0], FILTER) | 화면 필드/플래그 변경 |  |  |  |
| AC-295ebe12 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1127 | try | ENDPOINT | CommonUtils.FindData | (ds.Tables[0], FILTER) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-54382f3e | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1131 | try ▸ foreach (DataRow row in findRows) | FLAG | rowMonth | CommonUtils.GetValue(row[MonthFocus]) | 화면 필드/플래그 변경 |  |  |  |
| AC-56d782e2 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1136 | try ▸ foreach (DataRow row in findRows) | FLAG | TTL_FOCUS | TTL + "_AVG" | 화면 필드/플래그 변경 |  |  |  |
| AC-f7a7581a | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1140 | try ▸ foreach (DataRow row in findRows) ▸ if (row[TTL_FOCUS] != DBNull.Value) | FLAG | loopCntSUM | loopCntSUM++ | 화면 필드 증감 |  |  |  |
| AC-2b64008f | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1143 | try ▸ foreach (DataRow row in findRows) | FLAG | TTL_FOCUS | TTL + "_MAX" | 화면 필드/플래그 변경 |  |  |  |
| AC-0ed667b3 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1146 | try ▸ foreach (DataRow row in findRows) ▸ if (row[TTL_FOCUS] != DBNull.Value) | FLAG | SUM_TTL_MAX_FOCUS | Math.Round(System.Convert.ToDouble(row[TTL_FOCUS].ToString())) | 화면 필드/플래그 변경 |  |  |  |
| AC-a88ba3da | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1155 | try ▸ foreach (DataRow row in findRows) ▸ if (row[TTL_FOCUS] != DBNull.Value) | FLAG | iSetMax | iSetMax++ | 화면 필드 증감 |  |  |  |
| AC-b2ba6805 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1158 | try ▸ foreach (DataRow row in findRows) | FLAG | TTL_FOCUS | TTL + "_MIN" | 화면 필드/플래그 변경 |  |  |  |
| AC-bb3be23b | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1161 | try ▸ foreach (DataRow row in findRows) ▸ if (row[TTL_FOCUS] != DBNull.Value) | FLAG | SUM_TTL_MIN_FOCUS | Math.Round(System.Convert.ToDouble(row[TTL_FOCUS].ToString())) | 화면 필드/플래그 변경 |  |  |  |
| AC-9826d632 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1170 | try ▸ foreach (DataRow row in findRows) ▸ if (row[TTL_FOCUS] != DBNull.Value) | FLAG | iSetMin | iSetMin++ | 화면 필드 증감 |  |  |  |

## SCP0102_BOD_Validation_Report.SameDataMerge

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e036fdc0 | FindButton [try] | SCP0102_BOD_Validation_Report.cs:818 | try | FLAG | iCol_TTL_MIN | ds.Tables[0].Columns["TTL_MIN"].Ordinal + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-a1dd86e0 | FindButton [try] | SCP0102_BOD_Validation_Report.cs:861 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) ▸ for (Month_LT <= 3) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + Month_LT, MonthColumnIndex, Math.Round(System.Convert.ToDouble(ds.Tables[0].Ro… | 그리드 값 설정 |  |  |  |
| AC-e887256f | FindButton [try] | SCP0102_BOD_Validation_Report.cs:869 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | FLAG | SUM_TTL_MAX_FOCUS | 0.0 | 화면 필드/플래그 변경 |  |  |  |
| AC-1a90a6b3 | FindButton [try] | SCP0102_BOD_Validation_Report.cs:870 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | FLAG | SUM_TTL_MIN_FOCUS | 0.0 | 화면 필드/플래그 변경 |  |  |  |
| AC-53b892ca | FindButton [try] | SCP0102_BOD_Validation_Report.cs:872 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | FLAG | loopCntSUM | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-82f3378e | FindButton [try] | SCP0102_BOD_Validation_Report.cs:873 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | FLAG | findRows | null | 화면 필드/플래그 변경 |  |  |  |
| AC-88fa9f36 | FindButton [try] | SCP0102_BOD_Validation_Report.cs:874 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | FLAG | MonthFocus | ds.Tables[0].Rows[j]["YYYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1c774fd5 | FindButton [try] | SCP0102_BOD_Validation_Report.cs:897 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) ▸ if (CheckNumber(Math.Rou… | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 5, Math.Round(System.Convert.ToDouble(1 - Math.Abs((SUM_DR -… | 그리드 값 설정 |  |  |  |
| AC-680bd97b | FindButton [try] | SCP0102_BOD_Validation_Report.cs:901 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) ▸ else of (CheckNumber(Mat… | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 5, null) | 그리드 값 설정 |  |  |  |
| AC-bb32fdb2 | FindButton [try] | SCP0102_BOD_Validation_Report.cs:908 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 6, (SUM_TTL_AVG - SUM_DR)) | 그리드 값 설정 |  |  |  |
| AC-dd93ad9c | FindButton [try] | SCP0102_BOD_Validation_Report.cs:916 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex, System.Convert.ToInt32(SUM_DR)) | 그리드 값 설정 |  |  |  |
| AC-1634354e | FindButton [try] | SCP0102_BOD_Validation_Report.cs:917 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 1, System.Convert.ToInt32(SUM_TTL_AVG)) | 그리드 값 설정 |  |  |  |
| AC-4bca626f | FindButton [try] | SCP0102_BOD_Validation_Report.cs:918 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 2, System.Convert.ToInt32(SUM_TTL_MAX)) | 그리드 값 설정 |  |  |  |
| AC-91dfd50e | FindButton [try] | SCP0102_BOD_Validation_Report.cs:919 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 3, System.Convert.ToInt32(SUM_TTL_MIN)) | 그리드 값 설정 |  |  |  |
| AC-ba160c9f | FindButton [try] | SCP0102_BOD_Validation_Report.cs:922 | try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, MonthColumnIndex + 4, strSUM_TTL_AVG_CI_80) | 그리드 값 설정 |  |  |  |

## SCP0102_BOD_Validation_Report.Set_Accuracy_Row

진입점: cboAccuracy.SelectedIndexChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45e0fdc7 | cboAccuracy.SelectedIndexChanged 외 1 | SCP0102_BOD_Validation_Report.cs:1423 | if (cboAccuracy.ControlValues != "ALL") ▸ if (G_AccuracyColorIndex.Count > 0) | CALL_EXT | G_AccuracyColorIndex.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-af9d0f02 | cboAccuracy.SelectedIndexChanged 외 1 | SCP0102_BOD_Validation_Report.cs:1425 | if (cboAccuracy.ControlValues != "ALL") | CALL_EXT | this.spdMain.Sheets[0].SetColumnLabel | (0, G_TTLColumnIndex, "구분 ▼") | ⚠ 의미 확인 필요 |  |  |  |
| AC-620e1132 | cboAccuracy.SelectedIndexChanged 외 1 | SCP0102_BOD_Validation_Report.cs:1439 | if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.Active… | GRID_SET | spdMain.Sheets[0].Cells[i, System.Convert.ToInt32(sep[j])].BackColor | Color.FromArgb(70, Color.Magenta) | 그리드 속성/값 설정 |  |  |  |
| AC-46c81eda | cboAccuracy.SelectedIndexChanged 외 1 | SCP0102_BOD_Validation_Report.cs:1441 | if (cboAccuracy.ControlValues != "ALL") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (GColumnVisible[3].Length != 0) ▸ for (i < siMain.Active… | DATA_OP | G_AccuracyColorIndex.Add | (i + "/" + sep[j]) | 데이터 객체 조작/조회 |  |  |  |

## SCP0102_BOD_Validation_Report.Set_City_ComboBox

진입점: this.Load / clbDivision_ID.SelectedIndexChanged / cboFromCountry.SelectedIndexChanged [if (cboFromCountry.ControlValues == "ALL")] / cboToCountry.SelectedIndexChanged [if (cboToCountry.ControlValues == "ALL")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32f89909 | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:188 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0028_GET_CITY") ⇒ SSP.SSP0028_GET_CITY | 엔드포인트 요청 생성 |  |  |  |
| AC-9521add0 | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:189 |  | DATA_OP | request.Parameters["p_country_parameter"] | CountryParameter | 행/컬럼 값 대입 |  |  |  |
| AC-2a07cfea | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:190 |  | DATA_OP | request.Parameters["p_kind"] | Kind | 행/컬럼 값 대입 |  |  |  |
| AC-cc862b50 | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:191 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0a5eeaec | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:197 | if (Kind == "F") | FLAG | this.G_dtFromCity | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-c2d5069e | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:198 | if (Kind == "F") | LIST_REBIND | clsCtrl.setListBox | (this.G_dtFromCity, cboFromCity, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d67b5360 | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:202 | else of (Kind == "F") ▸ if (Kind == "T") | FLAG | this.G_dtToCity | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-dca3a063 | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:203 | else of (Kind == "F") ▸ if (Kind == "T") | LIST_REBIND | clsCtrl.setListBox | (this.G_dtToCity, cboToCity, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9abd2c0f | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:207 | else of (Kind == "F") ▸ else of (Kind == "T") ▸ if (Kind == "A") | FLAG | this.G_dtFromCity | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-1d8e288c | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:208 | else of (Kind == "F") ▸ else of (Kind == "T") ▸ if (Kind == "A") | LIST_REBIND | clsCtrl.setListBox | (this.G_dtFromCity, cboFromCity, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b81607c9 | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:210 | else of (Kind == "F") ▸ else of (Kind == "T") ▸ if (Kind == "A") | FLAG | this.G_dtToCity | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-5d031967 | this.Load 외 3 | SCP0102_BOD_Validation_Report.cs:211 | else of (Kind == "F") ▸ else of (Kind == "T") ▸ if (Kind == "A") | LIST_REBIND | clsCtrl.setListBox | (this.G_dtToCity, cboToCity, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0102_BOD_Validation_Report.Set_ColumnVisible

진입점: cboInquiryClassification.SelectedIndexChanged / FindButton [try ▸ if (G_GRID_MONTH_HEADER.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ddf4e9d | cboInquiryClassification.SelectedIndexChanged 외 1 | SCP0102_BOD_Validation_Report.cs:1398 | try ▸ for (i < GColumnVisible.Length) | CALL_EXT | cboInquiryClassification.GetItemChecked | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9560fc7 | cboInquiryClassification.SelectedIndexChanged 외 1 | SCP0102_BOD_Validation_Report.cs:1398 | try ▸ for (i < GColumnVisible.Length) ▸ if (cboInquiryClassification.GetItemChecked(i) == false) ▸ for (col < sep.Length) | GRID_STYLE | siMain.setColumnWidth | (System.Convert.ToInt32(sep[col]), 0) | 그리드 표시 설정 |  |  |  |
| AC-c13ee4d7 | cboInquiryClassification.SelectedIndexChanged 외 1 | SCP0102_BOD_Validation_Report.cs:1399 | try ▸ for (i < GColumnVisible.Length) ▸ else of (cboInquiryClassification.GetItemChecked(i) == false) ▸ for (col < sep.Length) | GRID_STYLE | siMain.setColumnWidth | (System.Convert.ToInt32(sep[col]), 50) | 그리드 표시 설정 |  |  |  |

## SCP0102_BOD_Validation_Report.Set_CommonInformation

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID) ▸ if (FirstCheck == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d075ec5 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:940 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex, ds.Tables[0].Rows[j]["DIVISIONID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-8f55f3fc | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:941 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex + 1, ds.Tables[0].Rows[j]["FROM_SITE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-f08c8cda | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:942 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex + 2, ds.Tables[0].Rows[j]["TO_SITE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-ad778996 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:943 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex + 3, ds.Tables[0].Rows[j]["POL_AREA"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-37ce0079 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:944 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex + 4, ds.Tables[0].Rows[j]["POD_AREA"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-59f68e78 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:945 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex + 5, ds.Tables[0].Rows[j]["D_PORT_CODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-8414d1d3 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:946 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex + 6, ds.Tables[0].Rows[j]["A_PORT_CODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-ca80c8d7 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:947 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex + 7, ds.Tables[0].Rows[j]["FROM_CITY"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-fb3df621 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:948 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex + 8, ds.Tables[0].Rows[j]["TO_CITY"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-1dbfd807 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:949 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex + 9, ds.Tables[0].Rows[j]["TRANSPORT_MODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-4fb61893 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:950 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_BODIDIndex, ds.Tables[0].Rows[j]["BOD_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-82470943 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:951 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_RouteIDIndex, ds.Tables[0].Rows[j]["ROUTE_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-15d8eef2 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:952 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_DivisionIDIndex + 12, ds.Tables[0].Rows[j]["SSP_INCOTERMS"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-72ee8ddd | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:953 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, G_ShipmentCountIndex, System.Convert.ToInt32(ds.Tables[1].Rows[i]["SHIPMENTCOUN… | 그리드 값 설정 |  |  |  |
| AC-01dfc8d0 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:954 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, siMain.GetColumnIndex("CONTAINER_COUNT"), System.Convert.ToInt32(ds.Tables[1].R… | 그리드 값 설정 |  |  |  |
| AC-dee7bd18 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:973 | for (LT <= 3) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + LT, LTIndex, Math.Round(System.Convert.ToDouble(ds.Tables[0].Rows[j][NDR + _st… | 그리드 값 설정 |  |  |  |
| AC-36d711e5 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:982 |  | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex, LTIndex, System.Convert.ToInt32(SUM_NDR)) | 그리드 값 설정 |  |  |  |

## SCP0102_BOD_Validation_Report.Set_Country_ComboBox

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78f514e1 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:169 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0028_GET_COUNTRY") ⇒ SSP.SSP0028_GET_COUNTRY | 엔드포인트 요청 생성 |  |  |  |
| AC-ff13ed14 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:170 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88346e6b | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:175 |  | FLAG | this.G_dtFromCountry | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-f2373622 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:176 |  | FLAG | this.G_dtToCountry | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-08057e68 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:178 |  | LIST_REBIND | clsCtrl.setListBox | (this.G_dtFromCountry, cboFromCountry, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-16480f92 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:179 |  | LIST_REBIND | clsCtrl.setListBox | (this.G_dtToCountry, cboToCountry, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0102_BOD_Validation_Report.Set_DetailgridColor

진입점: spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null)] / this.btn_Search.Click / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-488b1e6f | spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountInde… 외 2 | SCP0102_BOD_Validation_Report.cs:1815 | for (i < this.spdDetail.Sheets[0].RowCount) | GRID_SET | spdDetail.Sheets[0].Cells[i, iColRoute].BackColor | colorLink | 그리드 속성/값 설정 |  |  |  |
| AC-2478cad1 | spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountInde… 외 2 | SCP0102_BOD_Validation_Report.cs:1829 | if (flag == 0) ▸ for (Index < sep1.Length) ▸ for (i < this.spdMain.Sheets[0].RowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, System.Convert.ToInt32(sep1[Index])].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-8b0b1c41 | spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountInde… 외 2 | SCP0102_BOD_Validation_Report.cs:1830 | if (flag == 0) ▸ for (Index < sep1.Length) ▸ for (i < this.spdMain.Sheets[0].RowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, System.Convert.ToInt32(sep2[Index])].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-f9a2cc4a | spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountInde… 외 2 | SCP0102_BOD_Validation_Report.cs:1831 | if (flag == 0) ▸ for (Index < sep1.Length) ▸ for (i < this.spdMain.Sheets[0].RowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, System.Convert.ToInt32(sep3[Index])].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-91849d08 | spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountInde… 외 2 | SCP0102_BOD_Validation_Report.cs:1832 | if (flag == 0) ▸ for (Index < sep1.Length) ▸ for (i < this.spdMain.Sheets[0].RowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, System.Convert.ToInt32(sep4[Index])].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-d7340473 | spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountInde… 외 2 | SCP0102_BOD_Validation_Report.cs:1833 | if (flag == 0) ▸ for (Index < sep1.Length) ▸ for (i < this.spdMain.Sheets[0].RowCount) | GRID_SET | spdMain.Sheets[0].Cells[i, System.Convert.ToInt32(sep4[Index])].HorizontalAlignment | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-79981635 | spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountInde… 외 2 | SCP0102_BOD_Validation_Report.cs:1841 | else of (flag == 0) ▸ for (i < this.spdDetail.Sheets[0].RowCount) | GRID_SET | spdDetail.Sheets[0].Cells[i, TTL1_5].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-8c57d680 | spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountInde… 외 2 | SCP0102_BOD_Validation_Report.cs:1842 | else of (flag == 0) ▸ for (i < this.spdDetail.Sheets[0].RowCount) | GRID_SET | spdDetail.Sheets[0].Cells[i, TTL1_5 + 1].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-7049bf05 | spdMain.CellDoubleClick [if (e.Column == G_ShipmentCountInde… 외 2 | SCP0102_BOD_Validation_Report.cs:1843 | else of (flag == 0) ▸ for (i < this.spdDetail.Sheets[0].RowCount) | GRID_SET | spdDetail.Sheets[0].Cells[i, TTL1_5 + 2].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |

## SCP0102_BOD_Validation_Report.SET_MONTH

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bacd249a | FindButton [try] | SCP0102_BOD_Validation_Report.cs:747 |  | DATA_OP | ds.Tables[0].Columns.Add | ("YYYYYMM", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5c3624a | FindButton [try] | SCP0102_BOD_Validation_Report.cs:765 | for (i < ds.Tables[0].Columns.Count) ▸ if (CheckNumber(ds.Tables[0].Columns[ds.Tables[0].Columns.Count - CoulumIndex].ColumnName.ToString())… | DATA_OP | ds.Tables[0].Rows[r].BeginEdit | () | 데이터 객체 조작/조회 |  |  |  |
| AC-851ff848 | FindButton [try] | SCP0102_BOD_Validation_Report.cs:766 | for (i < ds.Tables[0].Columns.Count) ▸ if (CheckNumber(ds.Tables[0].Columns[ds.Tables[0].Columns.Count - CoulumIndex].ColumnName.ToString())… | GRID_SET | ds.Tables[0].Rows[r]["YYYYYMM"] | ds.Tables[0].Columns[ds.Tables[0].Columns.Count - CoulumIndex].ColumnName.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-54fa752e | FindButton [try] | SCP0102_BOD_Validation_Report.cs:767 | for (i < ds.Tables[0].Columns.Count) ▸ if (CheckNumber(ds.Tables[0].Columns[ds.Tables[0].Columns.Count - CoulumIndex].ColumnName.ToString())… | DATA_OP | ds.Tables[0].Rows[r].EndEdit | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9bad9081 | FindButton [try] | SCP0102_BOD_Validation_Report.cs:768 | for (i < ds.Tables[0].Columns.Count) ▸ if (CheckNumber(ds.Tables[0].Columns[ds.Tables[0].Columns.Count - CoulumIndex].ColumnName.ToString())… | DATA_OP | ds.Tables[0].Rows[r].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-39a6c685 | FindButton [try] | SCP0102_BOD_Validation_Report.cs:784 | for (i >= 0) | DATA_OP | this.G_GRID_MONTH_HEADER.Add | (sep[i]) | 데이터 객체 조작/조회 |  |  |  |

## SCP0102_BOD_Validation_Report.Set_PIVOT_DATE

진입점: FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91949d59 | FindButton [try ▸ lambda] | SCP0102_BOD_Validation_Report.cs:702 | else of (month_diff == 0) ▸ for (i < month_diff) ▸ if (YEAR == null) ▸ if (FDate.Substring(4, 2) != "12") | CALL_EXT | (System.Convert.ToInt32(FDate.Substring(4, 2)) + 1).ToString().PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-57d9433e | FindButton [try ▸ lambda] | SCP0102_BOD_Validation_Report.cs:726 | else of (month_diff == 0) ▸ for (i < month_diff) ▸ else of (YEAR == null) ▸ else of (CheckMonth == true) | CALL_EXT | (System.Convert.ToInt32(MONTH) + 1).ToString().PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-3801e4c6 | FindButton [try ▸ lambda] | SCP0102_BOD_Validation_Report.cs:736 |  | RETURN | return strDate.Substring(0, strDate.Length - 1); |  | 처리 중단/반환 |  |  |  |

## SCP0102_BOD_Validation_Report.SetChangedControl

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1b48c5c | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:219 |  | FLAG | G_dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-1638caa3 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:219 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e47dc0d1 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:220 |  | FLAG | G_dtToSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-d865fe32 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:220 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Current["NowGroupID… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-51e931b2 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:222 |  | LIST_REBIND | clsCtrl.setListBox | (G_dtPlantSiteByDivision, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e8030244 | this.Load 외 1 | SCP0102_BOD_Validation_Report.cs:224 |  | LIST_REBIND | clsCtrl.setListBox | (G_dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0102_BOD_Validation_Report.spdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1853d06e | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1593 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL") ⇒ SCP.SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-52956d0f | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1594 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_division_id"] | spdMain.Sheets[0].GetValue(e.Row, G_DivisionIDIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b272f851 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1595 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4a619d33 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1596 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-deca356e | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1597 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_from_site"] | spdMain.Sheets[0].GetValue(e.Row, G_FromSiteIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-76f726fc | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1598 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_to_site"] | spdMain.Sheets[0].GetValue(e.Row, G_ToSiteIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c87f72d5 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1599 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_bod_id"] | spdMain.Sheets[0].GetValue(e.Row, G_BODIDIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a2e01267 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1600 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_route_id "] | spdMain.Sheets[0].GetValue(e.Row, G_RouteIDIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1da5b523 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1601 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_exfactory_from_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4ff96dcd | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1602 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_exfactory_to_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a9dccd3e | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1603 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_fdest_from_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3bc5854e | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1604 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_fdest_to_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2631a414 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1605 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_from_country"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2b5ad2ed | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1606 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_to_country"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5150a152 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1607 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_from_city"] | spdMain.Sheets[0].GetValue(e.Row, G_FromCityIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2760a6e7 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1608 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_to_city"] | spdMain.Sheets[0].GetValue(e.Row, G_ToCityIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-889be7d6 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1609 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | DATA_OP | request.Parameters["p_from_area"] | spdMain.Sheets[0].GetValue(e.Row, G_FromAreaIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d83a8f32 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1610 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) ▸ if (spdMain.Sheets[0].GetValue(e.Row… | DATA_OP | request.Parameters["p_to_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-217f60e4 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1610 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) ▸ else of (spdMain.Sheets[0].GetValue(… | DATA_OP | request.Parameters["p_to_area"] | spdMain.Sheets[0].GetValue(e.Row, G_ToAreaIndex).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b073b58 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1612 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e445e3c0 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1616 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-53f32558 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1617 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d3c790b4 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1618 | if (e.Column == G_ShipmentCountIndex) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null) | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17fe60d0 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1636 | else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ if (e.ColumnHeader == false) ▸ if (sep.Length == 2) ▸ if (s… | GRID_SET | spdMain.Sheets[0].SetValue | (e.Row, G_TTLColumnIndex, "TTL ▼") | 그리드 값 설정 |  |  |  |
| AC-2f6953b5 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1638 | else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ if (e.ColumnHeader == false) ▸ if (sep.Length == 2) ▸ else … | GRID_SET | spdMain.Sheets[0].SetValue | (e.Row, G_TTLColumnIndex, "TTL ▲") | 그리드 값 설정 |  |  |  |
| AC-ff1cbe96 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1641 | else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ if (e.ColumnHeader == false) ▸ if (sep.Length == 2) ▸ for (… | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (e.Row + (i + 1), Visible) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c4b42c3 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1648 | else of (e.Column == G_ShipmentCountIndex) ▸ if (e.Column == G_TTLColumnIndex) ▸ else of (e.ColumnHeader == false) ▸ if (this.spdMain.Sheets… | CALL_EXT | this.spdMain.Sheets[0].GetColumnLabel | (0, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-07aaea7f | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1675 | else of (e.Column == G_ShipmentCountIndex) ▸ else of (e.Column == G_TTLColumnIndex) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0af81f9 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1681 | else of (e.Column == G_ShipmentCountIndex) ▸ else of (e.Column == G_TTLColumnIndex) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d13db28 | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1684 | else of (e.Column == G_ShipmentCountIndex) ▸ else of (e.Column == G_TTLColumnIndex) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE… | CALL_EXT | BaseForm.CreateManualSearchCondtion | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-504a86ad | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1685 | else of (e.Column == G_ShipmentCountIndex) ▸ else of (e.Column == G_TTLColumnIndex) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE… | CALL_EXT | BaseForm.SetManualCondition | (Msc, "ROUTE_ID", ROUTE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1506b0c | spdMain.CellDoubleClick | SCP0102_BOD_Validation_Report.cs:1687 | else of (e.Column == G_ShipmentCountIndex) ▸ else of (e.Column == G_TTLColumnIndex) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE… | CALL_BASE | openSubMenu | ("SCP0005", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0102_BOD_Validation_Report.TTL1_5_Average_Maximum_MinimumValueDisplay

진입점: FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ for (j < ds.Tables[0].Rows.Count) ▸ if (NoneMonth_BODID == Month_BODID)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09091d5d | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1227 | for (DTTL <= 3) ▸ if (ds.Tables[0].Rows[j][TTL] != DBNull.Value) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 1, Math.Round(System.Convert.ToDouble(ds.Tables[0].Ro… | 그리드 값 설정 |  |  |  |
| AC-12adaf3f | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1232 | for (DTTL <= 3) ▸ if (ds.Tables[0].Rows[j][TTL] != DBNull.Value) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 2, Math.Round(System.Convert.ToDouble(ds.Tables[0].Ro… | 그리드 값 설정 |  |  |  |
| AC-ecd427cf | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1237 | for (DTTL <= 3) ▸ if (ds.Tables[0].Rows[j][TTL] != DBNull.Value) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 3, Math.Round(System.Convert.ToDouble(ds.Tables[0].Ro… | 그리드 값 설정 |  |  |  |
| AC-7d9148f1 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1244 | for (DTTL <= 3) | FLAG | strSUM_TTL_AVG_CI_80 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-74aed9c6 | FindButton [try ▸ try ▸ for (i < ds.Tables[1].Rows.Count) ▸ … | SCP0102_BOD_Validation_Report.cs:1246 | for (DTTL <= 3) | GRID_SET | spdMain.Sheets[0].SetValue | (Rowindex + DTTL, MonthColumnIndex + 4, strSUM_TTL_AVG_CI_80) | 그리드 값 설정 |  |  |  |

## SCP0102_BOD_Validation_Report.TTLROWHIDE

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5701590 | FindButton [try] | SCP0102_BOD_Validation_Report.cs:397 | for (i < spdMain.Sheets[0].RowCount) ▸ if (sep.Length == 2) ▸ for (j < 3) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | ((i + j) + 1, visible) | ⚠ 의미 확인 필요 |  |  |  |

