# AS-IS 액션 대조표 — SCP0022

> 원천: `Doc/asisfacts/screens/SCP0022/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 305행 · 메서드 40 · 종류 DATA_OP 88 · GRID_INIT 35 · RETURN 34 · MESSAGE 28 · FLAG 20 · GRID_LOCK 20 · ENDPOINT 16 · GRID_STYLE 15 · CALL_EXT 11 · GRID_SET 10 · UI_MISC 8 · POPUP 5 · UI_PROP 5 · VALIDATE 4 · GRID_BIND 3 · LIST_REBIND 2 · VALUE_SET 1 · ⚠ 의미 확인 필요 11


## SCP0022_Formation.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a9f53c5 | this.btnItemId.Click | SCP0022_Formation.cs:1882 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fdf71d2c | this.btnItemId.Click | SCP0022_Formation.cs:1884 |  | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-57319ad9 | this.btnItemId.Click | SCP0022_Formation.cs:1885 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-696afe59 | this.btnItemId.Click | SCP0022_Formation.cs:1886 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-989a5353 | this.btnItemId.Click | SCP0022_Formation.cs:1892 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0022_Formation.CheckDigitValueEntered

진입점: this.spdMain.EditModeOff / this.spdExcept.EditModeOff / dsdmMain.Changed / dsdmExcept.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b9c0872 | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:485 | if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (res == false) | GRID_SET | spread.SetValue | (nRow, nCol, 0) | 그리드 값 설정 |  |  |  |
| AC-c297a02c | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:488 | if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (res == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-486ebb1d | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:500 | if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (nCol == siMain.GetColumnIndex(DefMai… | GRID_SET | spread.SetValue | (nRow, nCol, 1) | 그리드 값 설정 |  |  |  |
| AC-8ab900bc | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:503 | if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (nCol == siMain.GetColumnIndex(DefMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d25421c9 | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:521 | if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ else of (nCol == siMain.GetColumnIndex(D… | GRID_SET | spread.SetValue | (nRow, nCol, 1) | 그리드 값 설정 |  |  |  |
| AC-1f1fac4b | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:522 | if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ else of (nCol == siMain.GetColumnIndex(D… | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { 1, 100 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0109a080 | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:544 | if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ else of (nCol == siMain.GetColumnIndex(D… | GRID_SET | spread.SetValue | (nRow, nCol, 1) | 그리드 값 설정 |  |  |  |
| AC-6dab5129 | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:545 | if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ else of (nCol == siMain.GetColumnIndex(D… | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { 1, 100 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e7be241d | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:560 | if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ else of (nCol == siMain.GetColumnIndex(D… | GRID_SET | spread.SetValue | (nRow, nCol, 1) | 그리드 값 설정 |  |  |  |
| AC-f18e0b89 | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:561 | if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ else of (nCol == siMain.GetColumnIndex(D… | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { 1, 100 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec3c79b7 | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:590 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdExcept.Name) ▸ if (nCol == siExcept.GetColumnIndex(DefExcept.FORMATION_YIELD)) ▸ if … | GRID_SET | spread.SetValue | (nRow, nCol, 1) | 그리드 값 설정 |  |  |  |
| AC-553bfec9 | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:591 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdExcept.Name) ▸ if (nCol == siExcept.GetColumnIndex(DefExcept.FORMATION_YIELD)) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { 1, 100 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91ca3576 | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:609 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdExcept.Name) ▸ else of (nCol == siExcept.GetColumnIndex(DefExcept.FORMATION_YIELD)) … | GRID_SET | spread.SetValue | (nRow, nCol, 1) | 그리드 값 설정 |  |  |  |
| AC-c87385e1 | this.spdMain.EditModeOff 외 3 | SCP0022_Formation.cs:610 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdExcept.Name) ▸ else of (nCol == siExcept.GetColumnIndex(DefExcept.FORMATION_YIELD)) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { 1, 100 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0022_Formation.checkValidLTN0

진입점: SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (_sActiveSheetName == SpdSheet.shtExceptLT) ▸ for (i <= siExcept.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93925891 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1414 | for (i <= siExcept.GetMaxRowIndex()) ▸ else of (DateTime.TryParse(siExcept.GetText(i, siExcept.GetColumnIndex(DefExceptLT.FORMATION_START_DA… | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f717d1d8 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1425 | for (i <= siExcept.GetMaxRowIndex()) ▸ else of (DateTime.TryParse(siExcept.GetText(i, siExcept.GetColumnIndex(DefExceptLT.FORMATION_END_DATE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1b892090 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1431 | for (i <= siExcept.GetMaxRowIndex()) ▸ if (Int64.Parse(strStartDate) < 17530101 \|\| Int64.Parse(strEndDate) < 17530101) | MESSAGE | MessageHelper.GMessageBox | ("MSG00048", new object[] { strStartDate + "~" + strEndDate }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51c8fda1 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1437 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.checkValidLTN5

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1a7603b | (진입점 미연결) | SCP0022_Formation.cs:1454 | for (i < dt.Rows.Count) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3bed38c | (진입점 미연결) | SCP0022_Formation.cs:1457 | for (i < dt.Rows.Count) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-2089d0c8 | (진입점 미연결) | SCP0022_Formation.cs:1465 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefExceptLT.FORMATION_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-327d19a2 | (진입점 미연결) | SCP0022_Formation.cs:1466 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefExceptLT.FORMATION_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-6beac42b | (진입점 미연결) | SCP0022_Formation.cs:1481 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExceptLT.FORMATION_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7521a9f | (진입점 미연결) | SCP0022_Formation.cs:1482 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExceptLT.FORMATION_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-5bc07e7d | (진입점 미연결) | SCP0022_Formation.cs:1493 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nFormation_START_DATE >= nCp_Formation_START_DATE && nFormation_START_DATE <= nCp_F… | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2504cd8c | (진입점 미연결) | SCP0022_Formation.cs:1494 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nFormation_START_DATE >= nCp_Formation_START_DATE && nFormation_START_DATE <= nCp_F… | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-755b853b | (진입점 미연결) | SCP0022_Formation.cs:1496 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nFormation_START_DATE >= nCp_Formation_START_DATE && nFormation_START_DATE <= nCp_F… | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-7c5b5ea0 | (진입점 미연결) | SCP0022_Formation.cs:1497 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nFormation_START_DATE >= nCp_Formation_START_DATE && nFormation_START_DATE <= nCp_F… | GRID_STYLE | siExcept.SetBGColor | (changeCpRowIdx, iColIdx1, changeCpRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-73219f96 | (진입점 미연결) | SCP0022_Formation.cs:1507 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00105", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f5878ae | (진입점 미연결) | SCP0022_Formation.cs:1510 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.checkValidLTN8

진입점: SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (_sActiveSheetName == SpdSheet.shtExceptLT) ▸ for (i <= siExcept.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0097a37b | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1524 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f889b474 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1525 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-38e05e9f | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1534 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExceptLT.FORMATION_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-9978fcb3 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1535 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExceptLT.FORMATION_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-46e68b8a | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1539 | for (i < dt.Rows.Count) ▸ if (strFormation_START_DATE == string.Empty \|\| strFormation_END_DATE == string.Empty) | GRID_STYLE | siExcept.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-486dbb4b | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1540 | for (i < dt.Rows.Count) ▸ if (strFormation_START_DATE == string.Empty \|\| strFormation_END_DATE == string.Empty) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9d55455d | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1548 | for (i < dt.Rows.Count) ▸ if (intFormation_START_DATE > intFormation_END_DATE) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4fb553fc | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1550 | for (i < dt.Rows.Count) ▸ if (intFormation_START_DATE > intFormation_END_DATE) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-d7c484f7 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1557 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a13cbd68 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1560 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.checkValidN0

진입점: SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) ▸ for (i <= siExcept.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66277fa4 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1226 | for (i <= siExcept.GetMaxRowIndex()) ▸ else of (DateTime.TryParse(siExcept.GetText(i, siExcept.GetColumnIndex(DefExcept.FORMATION_START_DATE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-983d18f6 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1237 | for (i <= siExcept.GetMaxRowIndex()) ▸ else of (DateTime.TryParse(siExcept.GetText(i, siExcept.GetColumnIndex(DefExcept.FORMATION_END_DATE))… | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a36abc35 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1243 | for (i <= siExcept.GetMaxRowIndex()) ▸ if (Int64.Parse(strStartDate) < 17530101 \|\| Int64.Parse(strEndDate) < 17530101) | MESSAGE | MessageHelper.GMessageBox | ("MSG00048", new object[] { strStartDate + "~" + strEndDate }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c488e06 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1249 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.checkValidN5

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4913196d | (진입점 미연결) | SCP0022_Formation.cs:1266 | for (i < dt.Rows.Count) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eccbda27 | (진입점 미연결) | SCP0022_Formation.cs:1269 | for (i < dt.Rows.Count) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-e5af44c0 | (진입점 미연결) | SCP0022_Formation.cs:1279 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefExcept.FORMATION_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-0841cc77 | (진입점 미연결) | SCP0022_Formation.cs:1280 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefExcept.FORMATION_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c479d70 | (진입점 미연결) | SCP0022_Formation.cs:1304 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExcept.FORMATION_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd96a020 | (진입점 미연결) | SCP0022_Formation.cs:1305 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExcept.FORMATION_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-353aa768 | (진입점 미연결) | SCP0022_Formation.cs:1316 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nFormation_START_DATE >= nCp_Formation_START_DATE && nFormation_START_DATE <= nCp_F… | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-67f36d26 | (진입점 미연결) | SCP0022_Formation.cs:1317 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nFormation_START_DATE >= nCp_Formation_START_DATE && nFormation_START_DATE <= nCp_F… | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f765d9f | (진입점 미연결) | SCP0022_Formation.cs:1319 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nFormation_START_DATE >= nCp_Formation_START_DATE && nFormation_START_DATE <= nCp_F… | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-f7d7de80 | (진입점 미연결) | SCP0022_Formation.cs:1320 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nFormation_START_DATE >= nCp_Formation_START_DATE && nFormation_START_DATE <= nCp_F… | GRID_STYLE | siExcept.SetBGColor | (changeCpRowIdx, iColIdx1, changeCpRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-085a3b4d | (진입점 미연결) | SCP0022_Formation.cs:1330 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00105", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c4c5e93 | (진입점 미연결) | SCP0022_Formation.cs:1333 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.checkValidN8

진입점: SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) ▸ for (i <= siExcept.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-768f574e | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1347 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3a42bc1 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1348 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-af5c2d82 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1359 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExcept.FORMATION_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-85f4bf6a | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1360 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExcept.FORMATION_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-d645412e | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1364 | for (i < dt.Rows.Count) ▸ if (strFormation_START_DATE == string.Empty \|\| strFormation_END_DATE == string.Empty) | GRID_STYLE | siExcept.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-d12dfab6 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1365 | for (i < dt.Rows.Count) ▸ if (strFormation_START_DATE == string.Empty \|\| strFormation_END_DATE == string.Empty) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-edf42823 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1373 | for (i < dt.Rows.Count) ▸ if (intFormation_START_DATE > intFormation_END_DATE) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb740a0d | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1375 | for (i < dt.Rows.Count) ▸ if (intFormation_START_DATE > intFormation_END_DATE) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-74fb2151 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1382 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c406def3 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1385 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ef9c13c | this.Load | SCP0022_Formation.cs:272 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-99331a83 | this.Load | SCP0022_Formation.cs:273 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-c54da94d | this.Load | SCP0022_Formation.cs:276 |  | GRID_INIT | this.AddSheet | (spdExcept, SpdSheet.shtExcept, SpdSheet.shtExcept, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cf2fb981 | this.Load | SCP0022_Formation.cs:277 |  | GRID_INIT | this.AddSheet | (spdExcept, SpdSheet.shtExceptLT, SpdSheet.shtExceptLT, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-969053d5 | this.Load | SCP0022_Formation.cs:279 |  | FLAG | siExcept | GetSheetInfo(spdExcept.Name, SpdSheet.shtExcept) | 화면 필드/플래그 변경 |  |  |  |
| AC-c3bc2814 | this.Load | SCP0022_Formation.cs:280 |  | FLAG | siExcept | GetSheetInfo(spdExcept.Name, SpdSheet.shtExceptLT) | 화면 필드/플래그 변경 |  |  |  |
| AC-046d1db8 | this.Load | SCP0022_Formation.cs:282 |  | GRID_INIT | siExcept.ChangeSheet | (SpdSheet.shtExcept) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0247abf | this.Load | SCP0022_Formation.cs:285 |  | GRID_INIT | siExcept.ChangeSheet | (SpdSheet.shtExceptLT) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35b93875 | this.Load | SCP0022_Formation.cs:288 |  | GRID_INIT | siExcept.ChangeSheet | (SpdSheet.shtExcept) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2967b35 | this.Load | SCP0022_Formation.cs:292 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0022_Formation.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0dd17650 | this.Load | SCP0022_Formation.cs:231 |  | UI_PROP | usrConditionPanel1.Height | 48 | 속성 Height 설정 |  |  |  |

## SCP0022_Formation.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-131daddb | DeleteButton | SCP0022_Formation.cs:702 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-def27a57 | DeleteButton | SCP0022_Formation.cs:706 | if (fps.Name == spdExcept.Name) ▸ if (siExcept.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04c7e98f | DeleteButton | SCP0022_Formation.cs:707 | if (fps.Name == spdExcept.Name) | DATA_OP | siExcept.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0022_Formation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ffa7add | Dispose | SCP0022_Formation.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0022_Formation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af425825 | EditButton | SCP0022_Formation.cs:722 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7fb8aee4 | EditButton | SCP0022_Formation.cs:723 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-fbba6dec | EditButton | SCP0022_Formation.cs:724 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (0, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-af9a2d8b | EditButton | SCP0022_Formation.cs:725 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefMain.SHIPMENT_PIC_USER), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7c191cc5 | EditButton | SCP0022_Formation.cs:726 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FORMATION_TOTAL_YIELD), siMain.GetColumnIndex(DefMain.FORMA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-333ca9b1 | EditButton | SCP0022_Formation.cs:727 | if (spdMain != null) ▸ if (fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CREATED_BY), siMain.GetColumnIndex(DefMain.LAST_UPDATE_DATE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f1380147 | EditButton | SCP0022_Formation.cs:736 | if (spdMain != null) ▸ if (fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (_sActiveSheet… | FLAG | siExcept | GetSheetInfo(spdExcept.Name, spdExcept.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e27e9c1 | EditButton | SCP0022_Formation.cs:737 | if (spdMain != null) ▸ if (fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (_sActiveSheet… | GRID_LOCK | siExcept.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-6e4ed8a2 | EditButton | SCP0022_Formation.cs:738 | if (spdMain != null) ▸ if (fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (_sActiveSheet… | GRID_LOCK | siExcept.LockColumn | (0, siExcept.GetColumnIndex(DefExcept.NICK_NAME), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ca66000 | EditButton | SCP0022_Formation.cs:739 | if (spdMain != null) ▸ if (fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (_sActiveSheet… | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefExcept.FORMATION_TOTAL_YIELD), siExcept.GetColumnIndex(DefExce… | 그리드 편집 잠금/해제 |  |  |  |
| AC-64fa8499 | EditButton | SCP0022_Formation.cs:740 | if (spdMain != null) ▸ if (fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (_sActiveSheet… | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefExcept.CREATED_BY), siExcept.GetColumnIndex(DefExcept.LAST_UPD… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a4ef45c | EditButton | SCP0022_Formation.cs:745 | if (spdMain != null) ▸ if (fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ else of (_sActive… | FLAG | siExcept | GetSheetInfo(spdExcept.Name, spdExcept.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-94ccec6b | EditButton | SCP0022_Formation.cs:746 | if (spdMain != null) ▸ if (fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ else of (_sActive… | GRID_LOCK | siExcept.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-98b87640 | EditButton | SCP0022_Formation.cs:747 | if (spdMain != null) ▸ if (fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ else of (_sActive… | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefExceptLT.DIVISION_ID), siExcept.GetColumnIndex(DefExceptLT.NIC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-914f8427 | EditButton | SCP0022_Formation.cs:748 | if (spdMain != null) ▸ if (fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ else of (_sActive… | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefExceptLT.CREATED_BY), siExcept.GetColumnIndex(DefExceptLT.LAST… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0022_Formation.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee04ada2 | FindButton | SCP0022_Formation.cs:651 |  | GRID_INIT | siExcept.ChangeSheet | (SpdSheet.shtExcept) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d837928 | FindButton | SCP0022_Formation.cs:652 |  | GRID_INIT | siExcept.ChangeActiveSheet | (SpdSheet.shtExcept) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-49ed65e8 | FindButton | SCP0022_Formation.cs:658 |  | GRID_INIT | siExcept.ChangeSheet | (SpdSheet.shtExceptLT) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5909cb4c | FindButton | SCP0022_Formation.cs:659 |  | GRID_INIT | siExcept.ChangeActiveSheet | (SpdSheet.shtExceptLT) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-193d992f | FindButton | SCP0022_Formation.cs:665 |  | GRID_INIT | siExcept.ChangeSheet | (SpdSheet.shtExcept) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35f5a99f | FindButton | SCP0022_Formation.cs:666 |  | GRID_INIT | siExcept.ChangeActiveSheet | (SpdSheet.shtExcept) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0022_Formation.FindData_Except

진입점: FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.shtExcept)] / SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ba7773c | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 2 | SCP0022_Formation.cs:1767 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0022_GET_FORMATION_EXCEPT") ⇒ SCP.SCP0022_GET_FORMATION_EXCEPT | 엔드포인트 요청 생성 |  |  |  |
| AC-65317665 | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 2 | SCP0022_Formation.cs:1768 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0960e864 | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 2 | SCP0022_Formation.cs:1769 |  | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-29eaa961 | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 2 | SCP0022_Formation.cs:1770 |  | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d16af385 | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 2 | SCP0022_Formation.cs:1771 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-17167400 | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 2 | SCP0022_Formation.cs:1780 |  | GRID_BIND | siExcept.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-972ed63c | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 2 | SCP0022_Formation.cs:1784 | if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siExcept.LockColumn | (0, siExcept.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ed98c9a8 | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 2 | SCP0022_Formation.cs:1790 |  | UI_MISC | siExcept.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0022_Formation.FindData_ExceptLT

진입점: FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.shtExceptLT)] / SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (_sActiveSheetName == SpdSheet.shtExceptLT) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f2cff4b | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 1 | SCP0022_Formation.cs:1817 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0022_GET_FORMATION_EXCEPT_LT") ⇒ SCP.SCP0022_GET_FORMATION_EXCEPT_LT | 엔드포인트 요청 생성 |  |  |  |
| AC-f2aa78c9 | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 1 | SCP0022_Formation.cs:1818 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1cc7d81f | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 1 | SCP0022_Formation.cs:1819 |  | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-484629b5 | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 1 | SCP0022_Formation.cs:1820 |  | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-07e3a1d1 | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 1 | SCP0022_Formation.cs:1821 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7859bc4d | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 1 | SCP0022_Formation.cs:1830 |  | GRID_BIND | siExcept.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d2687267 | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 1 | SCP0022_Formation.cs:1832 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-316e859b | FindButton [if (siExcept.ActiveSheet.SheetName == SpdSheet.s… 외 1 | SCP0022_Formation.cs:1842 |  | UI_MISC | siExcept.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0022_Formation.FindData_Main

진입점: FindButton / SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-621a8405 | FindButton 외 1 | SCP0022_Formation.cs:1665 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-dc2bca74 | FindButton 외 1 | SCP0022_Formation.cs:1665 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd415cd7 | FindButton 외 1 | SCP0022_Formation.cs:1679 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0266026e | FindButton 외 1 | SCP0022_Formation.cs:1682 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b2ff0c22 | FindButton 외 1 | SCP0022_Formation.cs:1685 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f5e1d9b8 | FindButton 외 1 | SCP0022_Formation.cs:1687 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e8988c3b | FindButton 외 1 | SCP0022_Formation.cs:1690 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0022_GET_FORMATION") ⇒ SCP.SCP0022_GET_FORMATION | 엔드포인트 요청 생성 |  |  |  |
| AC-a4ffb8bf | FindButton 외 1 | SCP0022_Formation.cs:1691 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d447c64a | FindButton 외 1 | SCP0022_Formation.cs:1692 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b680c770 | FindButton 외 1 | SCP0022_Formation.cs:1693 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-68513ea5 | FindButton 외 1 | SCP0022_Formation.cs:1694 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-99bc0d60 | FindButton 외 1 | SCP0022_Formation.cs:1695 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2790cc3a | FindButton 외 1 | SCP0022_Formation.cs:1696 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fd0f60ed | FindButton 외 1 | SCP0022_Formation.cs:1703 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e955ed87 | FindButton 외 1 | SCP0022_Formation.cs:1704 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e49b20c7 | FindButton 외 1 | SCP0022_Formation.cs:1708 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b630acbd | FindButton 외 1 | SCP0022_Formation.cs:1713 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d8ea736d | FindButton 외 1 | SCP0022_Formation.cs:1715 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3e1c185 | FindButton 외 1 | SCP0022_Formation.cs:1719 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c48742fd | FindButton 외 1 | SCP0022_Formation.cs:1720 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0022_Formation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45211ede | this.Load | SCP0022_Formation.cs:218 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0022_Formation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45ca2c8e | this.Load | SCP0022_Formation.cs:237 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-d1f96ee8 | this.Load | SCP0022_Formation.cs:239 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-bc607383 | this.Load | SCP0022_Formation.cs:241 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6398abde | this.Load | SCP0022_Formation.cs:246 |  | FLAG | _sActiveSheetName | SpdSheet.shtExcept | 화면 필드/플래그 변경 |  |  |  |

## SCP0022_Formation.InitSpread

진입점: this.Load / FindButton / SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ if (iCount > 0) ▸ if (tran.Success)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9668d61d | this.Load 외 3 | SCP0022_Formation.cs:302 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-7a5ae6fd | this.Load 외 3 | SCP0022_Formation.cs:304 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-af1d81b4 | this.Load 외 3 | SCP0022_Formation.cs:306 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefMain.LT_FORMATION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-255b3065 | this.Load 외 3 | SCP0022_Formation.cs:307 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefMain.ADD_LT_FORMATION), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8e511398 | this.Load 외 3 | SCP0022_Formation.cs:308 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefMain.FORMATION_YIELD), 0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2a7a101a | this.Load 외 3 | SCP0022_Formation.cs:309 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefMain.CHAR_YIELD), 0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a682ead9 | this.Load 외 3 | SCP0022_Formation.cs:310 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefMain.FORMATION_TOTAL_YIELD), 0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6953b692 | this.Load 외 3 | SCP0022_Formation.cs:312 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-724df0df | this.Load 외 3 | SCP0022_Formation.cs:313 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-df150111 | this.Load 외 3 | SCP0022_Formation.cs:318 | if (spdInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-4f910133 | this.Load 외 3 | SCP0022_Formation.cs:320 | if (spdInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-fe5cd32b | this.Load 외 3 | SCP0022_Formation.cs:322 | if (spdInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefExcept.FORMATION_YIELD), 0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0c4d5efc | this.Load 외 3 | SCP0022_Formation.cs:323 | if (spdInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefExcept.CHAR_YIELD), 0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e3a05234 | this.Load 외 3 | SCP0022_Formation.cs:324 | if (spdInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefExcept.FORMATION_TOTAL_YIELD), 0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-894ca92e | this.Load 외 3 | SCP0022_Formation.cs:326 | if (spdInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25a7a8e0 | this.Load 외 3 | SCP0022_Formation.cs:327 | if (spdInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2b57bf2e | this.Load 외 3 | SCP0022_Formation.cs:333 | if (spdInfo.SheetName == SpdSheet.shtExceptLT) | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-33f14d9a | this.Load 외 3 | SCP0022_Formation.cs:335 | if (spdInfo.SheetName == SpdSheet.shtExceptLT) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-5cd8eb25 | this.Load 외 3 | SCP0022_Formation.cs:337 | if (spdInfo.SheetName == SpdSheet.shtExceptLT) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefExceptLT.LT_FORMATION), 0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-406af763 | this.Load 외 3 | SCP0022_Formation.cs:338 | if (spdInfo.SheetName == SpdSheet.shtExceptLT) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefExceptLT.ADD_LT_FORMATION), 0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e9872ae8 | this.Load 외 3 | SCP0022_Formation.cs:340 | if (spdInfo.SheetName == SpdSheet.shtExceptLT) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb984d70 | this.Load 외 3 | SCP0022_Formation.cs:341 | if (spdInfo.SheetName == SpdSheet.shtExceptLT) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0022_Formation.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67834232 | InsertButton | SCP0022_Formation.cs:674 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89a1ce4b | InsertButton | SCP0022_Formation.cs:680 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eccacaf5 | InsertButton | SCP0022_Formation.cs:690 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdExcept.Name) ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false)… | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b619475b | InsertButton | SCP0022_Formation.cs:691 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdExcept.Name) ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false)… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.InsertRow

진입점: InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdExcept.Name) ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8474d648 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1570 |  | DATA_OP | siExcept.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-292fe76a | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1590 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | DATA_OP | dicData.Add | (DefExcept.DIVISION_ID, siMain.GetValue(row, siMain.GetColumnIndex(DefMain.DIVISION_ID))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a734088 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1591 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | DATA_OP | dicData.Add | (DefExcept.PLANT_SITE_ID, siMain.GetValue(row, siMain.GetColumnIndex(DefMain.PLANT_SITE_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-d9ab91c6 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1592 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | DATA_OP | dicData.Add | (DefExcept.PLANT_SITE_DESCRIPTION, siMain.GetValue(row, siMain.GetColumnIndex(DefMain.PLAN… | 데이터 객체 조작/조회 |  |  |  |
| AC-41a0e7b9 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1593 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | DATA_OP | dicData.Add | (DefExcept.ITEM_ID, siMain.GetValue(row, siMain.GetColumnIndex(DefMain.ITEM_ID))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f703e15 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1594 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | DATA_OP | dicData.Add | (DefExcept.NICK_NAME, siMain.GetValue(row, siMain.GetColumnIndex(DefMain.NICK_NAME))) | 데이터 객체 조작/조회 |  |  |  |
| AC-34a54fef | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1598 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | DATA_OP | dicData.Add | (DefExcept.FORMATION_YIELD, sFormationYield) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c949c00 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1599 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | DATA_OP | dicData.Add | (DefExcept.CHAR_YIELD, sCharYield) | 데이터 객체 조작/조회 |  |  |  |
| AC-f28f4be7 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1600 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | DATA_OP | dicData.Add | (DefExcept.FORMATION_TOTAL_YIELD, sTotalYield) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3b89844 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1601 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | DATA_OP | dicData.Add | (DefExcept.COMMENT, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-28411b37 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1603 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | GRID_SET | siExcept.SetValue | (insCell, dicData) | 그리드 값 설정 |  |  |  |
| AC-5ebe2b69 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1606 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefExcept.DIVISION_ID), siExcept.GetColumnIndex(DefExcep… | 그리드 편집 잠금/해제 |  |  |  |
| AC-50ebb3a2 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1607 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefExcept.FORMATION_TOTAL_YIELD), siExcept.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a7afbe6e | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1608 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefExcept.CREATED_BY), siExcept.GetColumnIndex(DefExcept… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c6f13579 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1618 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | DATA_OP | dicData.Add | (DefExceptLT.DIVISION_ID, siMain.GetValue(row, siMain.GetColumnIndex(DefMain.DIVISION_ID))… | 데이터 객체 조작/조회 |  |  |  |
| AC-43296e9a | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1619 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | DATA_OP | dicData.Add | (DefExceptLT.PLANT_SITE_ID, siMain.GetValue(row, siMain.GetColumnIndex(DefMain.PLANT_SITE_… | 데이터 객체 조작/조회 |  |  |  |
| AC-8eceb384 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1620 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | DATA_OP | dicData.Add | (DefExceptLT.PLANT_SITE_DESCRIPTION, siMain.GetValue(row, siMain.GetColumnIndex(DefMain.PL… | 데이터 객체 조작/조회 |  |  |  |
| AC-e0e4e258 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1621 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | DATA_OP | dicData.Add | (DefExceptLT.ITEM_ID, siMain.GetValue(row, siMain.GetColumnIndex(DefMain.ITEM_ID))) | 데이터 객체 조작/조회 |  |  |  |
| AC-93423c76 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1622 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | DATA_OP | dicData.Add | (DefExceptLT.NICK_NAME, siMain.GetValue(row, siMain.GetColumnIndex(DefMain.NICK_NAME))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8972a66a | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1624 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | DATA_OP | dicData.Add | (DefExceptLT.LT_FORMATION, sLTFormation) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ae42f8f | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1625 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | DATA_OP | dicData.Add | (DefExceptLT.ADD_LT_FORMATION, sAddLTFormation) | 데이터 객체 조작/조회 |  |  |  |
| AC-00d0781f | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1626 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | DATA_OP | dicData.Add | (DefExceptLT.COMMENT, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-021df8b6 | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1628 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | GRID_SET | siExcept.SetValue | (insCell, dicData) | 그리드 값 설정 |  |  |  |
| AC-c95780bc | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1630 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefExceptLT.DIVISION_ID), siExcept.GetColumnIndex(DefExc… | 그리드 편집 잠금/해제 |  |  |  |
| AC-85bdf27a | InsertButton [else of (fps.Name == spdMain.Name) ▸ if (fps.N… | SCP0022_Formation.cs:1631 | if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (siExcept.Act… | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefExceptLT.CREATED_BY), siExcept.GetColumnIndex(DefExce… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0022_Formation.ReturnStringDate

진입점: SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (_sActiveSheetName == SpdSheet.shtExcept) ▸ for (i <= siExcept.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ce36368 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1194 |  | RETURN | return sResult; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.SaveData_Main

진입점: SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-116e3a4a | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:845 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0022_SAVE_Formation") ⇒ SCP.SCP0022_SAVE_Formation | 엔드포인트 요청 생성 |  |  |  |
| AC-5d836cfa | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:847 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c7917d5a | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:850 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e741d254 | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:851 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3a4cd9da | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:852 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-e23834ff | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:853 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d6e125e | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:854 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_Lf_Formation"] | p_Lf_Formation | 행/컬럼 값 대입 |  |  |  |
| AC-077932e3 | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:855 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_Add_LT_Formation"] | p_Add_LT_Formation | 행/컬럼 값 대입 |  |  |  |
| AC-1c267a6f | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:856 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_formation_yield"] | p_formation_yield | 행/컬럼 값 대입 |  |  |  |
| AC-22937418 | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:857 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_char_yield"] | p_char_yield | 행/컬럼 값 대입 |  |  |  |
| AC-34360068 | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:858 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_formation_total_yield"] | p_formation_total_yield | 행/컬럼 값 대입 |  |  |  |
| AC-3f14693f | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:859 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-b20e4f83 | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:860 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-20934a0f | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:861 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_modify_yield"] | p_user_modify_yield | 행/컬럼 값 대입 |  |  |  |
| AC-1ce8455a | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:862 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dbeb4bf8 | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:862 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-5a2c614b | SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdM… | SCP0022_Formation.cs:868 | if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0022_Formation.SaveExcept

진입점: SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (_sActiveSheetName == SpdSheet.shtExcept)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4c0cd17 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:914 | for (i <= siExcept.GetMaxRowIndex()) | VALIDATE | DataUtil.checkRequiredOfSpread | (siExcept) | 프레임워크 검증 |  |  |  |
| AC-ea1dab9c | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:914 | for (i <= siExcept.GetMaxRowIndex()) ▸ if (!DataUtil.checkRequiredOfSpread(siExcept)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1dd1994c | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:915 | for (i <= siExcept.GetMaxRowIndex()) ▸ if (!checkValidN8(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48c9d1c3 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:917 | for (i <= siExcept.GetMaxRowIndex()) ▸ if (!checkValidN0()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82fd8de4 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:955 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0022_SAVE_FORMATION_EXCEPT") ⇒ SCP.SCP0022_SAVE_FORMATION_EXCEPT | 엔드포인트 요청 생성 |  |  |  |
| AC-2b2f716a | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:957 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-926cef66 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:960 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-05ed2353 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:961 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4ddcab81 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:962 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-4e9900c9 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:963 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa553229 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:964 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_formation_start_date"] | p_formation_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-5b248e01 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:965 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_formation_end_date"] | p_formation_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-59c73646 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:966 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_formation_yield"] | p_formation_yield | 행/컬럼 값 대입 |  |  |  |
| AC-d414cbff | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:967 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_char_yield"] | p_char_yield | 행/컬럼 값 대입 |  |  |  |
| AC-e45d143d | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:968 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_formation_total_yield"] | p_formation_total_yield | 행/컬럼 값 대입 |  |  |  |
| AC-d07b4061 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:969 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_comment"] | p_comment | 행/컬럼 값 대입 |  |  |  |
| AC-089f6c5b | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:970 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-a346ff06 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:971 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-a31d1e1e | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:974 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_division_id"] | p_org_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d2173cb | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:975 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_plant_site_id"] | p_org_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-78e541a3 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:976 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_item_id"] | p_org_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-517f5199 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:977 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_start_date"] | p_org_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-79b703a9 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:978 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_end_date"] | p_org_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-b84b5230 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:980 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-69c362fd | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:982 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f9d08fe2 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:982 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-a2350f3e | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:990 | if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4acf3e12 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1000 | if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (errCode == "2627") | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aed7c267 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1013 | if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (errCode == "2627") ▸ for (i < siEx… | GRID_STYLE | siExcept.SetBGColor | (i, siExcept.GetColumnIndex(DefExcept.FORMATION_START_DATE), i, siExcept.GetColumnIndex(De… | 그리드 표시 설정 |  |  |  |
| AC-10f4ccfb | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1021 | if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (errCode == "2627") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0022_Formation.SaveExceptLT

진입점: SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ else of (_sActiveSheetName == SpdSheet.shtExcept) ▸ if (_sActiveSheetName == SpdSheet.shtExceptLT)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adf799db | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1067 | for (i <= siExcept.GetMaxRowIndex()) | VALIDATE | DataUtil.checkRequiredOfSpread | (siExcept) | 프레임워크 검증 |  |  |  |
| AC-ab9a53fe | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1067 | for (i <= siExcept.GetMaxRowIndex()) ▸ if (!DataUtil.checkRequiredOfSpread(siExcept)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37ad46fd | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1068 | for (i <= siExcept.GetMaxRowIndex()) ▸ if (!checkValidLTN8(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c428078 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1070 | for (i <= siExcept.GetMaxRowIndex()) ▸ if (!checkValidLTN0()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2efcafa6 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1097 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0022_SAVE_FORMATION_EXCEPT_LT") ⇒ SCP.SCP0022_SAVE_FORMATION_EXCEPT_LT | 엔드포인트 요청 생성 |  |  |  |
| AC-1dec9727 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1099 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b5bf92e | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1102 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d7a06fc2 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1103 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ad086b91 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1104 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-81e73961 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1105 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5eda35e | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1106 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_formation_start_date"] | p_formation_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-61e1890a | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1107 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_formation_end_date"] | p_formation_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-1a3bfeaf | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1108 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_lt_formation"] | p_lt_formation | 행/컬럼 값 대입 |  |  |  |
| AC-02f44c31 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1109 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_add_lt_formation"] | p_add_lt_formation | 행/컬럼 값 대입 |  |  |  |
| AC-41a7724e | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1110 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_comment"] | p_comment | 행/컬럼 값 대입 |  |  |  |
| AC-036d63aa | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1111 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-40127918 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1112 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-bd042c9c | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1115 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_division_id"] | p_org_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-91ffc3c0 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1116 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_plant_site_id"] | p_org_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-c996a89e | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1117 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_item_id"] | p_org_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f7a7a093 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1118 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_start_date"] | p_org_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-16a6485b | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1119 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_end_date"] | p_org_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-fe150981 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1121 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-0a7af406 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1123 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0c8dd8af | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1123 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-74069f09 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1131 | if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51ac33fa | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1141 | if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (errCode == "2627") | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-951e4590 | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1154 | if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (errCode == "2627") ▸ for (i < siEx… | GRID_STYLE | siExcept.SetBGColor | (i, siExcept.GetColumnIndex(DefExceptLT.FORMATION_START_DATE), i, siExcept.GetColumnIndex(… | 그리드 표시 설정 |  |  |  |
| AC-92c9200e | SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals… | SCP0022_Formation.cs:1162 | if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (errCode == "2627") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0022_Formation.SetCellFocus_ERROR

진입점: this.spdMain.EditModeOff [if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (res == false)] / this.spdExcept.EditModeOff [if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (res == false)] / dsdmMain.Changed [if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (res == false)] / dsdmExcept.Changed [if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (res == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-404bc3ef | this.spdMain.EditModeOff [if (fps.Name == spdMain.Name) ▸ if… 외 3 | SCP0022_Formation.cs:621 |  | GRID_STYLE | spread.ActiveSheet.SetActiveCell | (this._siMainCellRowIdx, this._siMainCellColIdx) | 그리드 표시 설정 |  |  |  |

## SCP0022_Formation.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb83d18c | this.Load 외 1 | SCP0022_Formation.cs:1658 |  | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "' AND OPERATION_G… | 화면 필드/플래그 변경 |  |  |  |
| AC-cae2a6f4 | this.Load 외 1 | SCP0022_Formation.cs:1658 |  | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = 'A'", t… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f629ef40 | this.Load 외 1 | SCP0022_Formation.cs:1660 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0022_Formation.setTotalYield

진입점: this.spdMain.EditModeOff [if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.LT_FORMATION)) ▸ if (nCol == siMain.GetColumnIndex(DefMain.FORMATION_YIELD))] / this.spdExcept.EditModeOff [if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ else of (nCol == siMain.GetColumnIndex(DefMain.LT_FORMATION)) ▸ if (nCol == siMain.GetColumnIndex(DefMain.FORMATION_YIELD))] / dsdmMain.Changed [if (fps.Name == spdMain.Name) ▸ else of (nCol == siMain.GetColumnIndex(Def…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8022ca8 | this.spdMain.EditModeOff [if (fps.Name == spdMain.Name) ▸ el… 외 4 | SCP0022_Formation.cs:1866 | if ((!sFormationY.Equals("") && !sFormationY.Equals("0")) \|\| (!sCharY.Equals("") && !sCharY.Equals("0"))) ▸ else of (sFormationY.Equals(""… | CALL_EXT | Math.Truncate | (Double.Parse(sFormationY) / 100 * Double.Parse(sCharY) / 100 * 10000) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6dad24d | this.spdMain.EditModeOff [if (fps.Name == spdMain.Name) ▸ el… 외 4 | SCP0022_Formation.cs:1869 |  | GRID_SET | spread.SetValue | (nRow, spread.GetColumnIndex(DefMain.FORMATION_TOTAL_YIELD), sTotalY) | 그리드 값 설정 |  |  |  |

## SCP0022_Formation.SpdExcept_ActiveSheetChanged

진입점: this.spdExcept.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4654891 | this.spdExcept.ActiveSheetChanged | SCP0022_Formation.cs:1899 |  | FLAG | _sActiveSheetName | ((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |

## SCP0022_Formation.SpdExcept_ActiveSheetChanging

진입점: this.spdExcept.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f8c6aca | this.spdExcept.ActiveSheetChanging | SCP0022_Formation.cs:1908 | if (!siExcept.IsLock(siExcept.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siExcept.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-e58ba2dc | this.spdExcept.ActiveSheetChanging | SCP0022_Formation.cs:1910 | if (!siExcept.IsLock(siExcept.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siExcept.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f9d2de55 | this.spdExcept.ActiveSheetChanging | SCP0022_Formation.cs:1911 | if (!siExcept.IsLock(siExcept.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.SpdExcept_Changed

진입점: dsdmExcept.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d9e1cd5 | dsdmExcept.Changed | SCP0022_Formation.cs:402 |  | FLAG | this._siExceptCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-c0271127 | dsdmExcept.Changed | SCP0022_Formation.cs:403 |  | FLAG | this._siExceptCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-367ab60c | dsdmExcept.Changed | SCP0022_Formation.cs:406 | if (this._siExceptCellRowIdx < 0 \|\| this._siExceptCellColIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.SpdExcept_EditChange

진입점: this.spdExcept.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-870f8739 | this.spdExcept.EditChange | SCP0022_Formation.cs:414 |  | FLAG | this._siExceptCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e14ad63c | this.spdExcept.EditChange | SCP0022_Formation.cs:415 |  | FLAG | this._siExceptCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0022_Formation.SpdExcept_EditModeOff

진입점: this.spdExcept.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e71aff28 | this.spdExcept.EditModeOff | SCP0022_Formation.cs:394 | if (this._siExceptCellRowIdx < 0 \|\| this._siExceptCellColIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ebdb954 | this.spdMain.CellClick | SCP0022_Formation.cs:377 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d61f832d | this.spdMain.CellClick | SCP0022_Formation.cs:379 |  | FLAG | this._siMainSelectedRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## SCP0022_Formation.SpdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69bc419a | (진입점 미연결) | SCP0022_Formation.cs:421 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8939e1ba | (진입점 미연결) | SCP0022_Formation.cs:423 |  | FLAG | this._siMainSelectedRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## SCP0022_Formation.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b600b0c6 | dsdmMain.Changed | SCP0022_Formation.cs:450 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-36d75158 | dsdmMain.Changed | SCP0022_Formation.cs:451 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-d9e67a9d | dsdmMain.Changed | SCP0022_Formation.cs:454 | if (this._siMainCellRowIdx < 0 \|\| this._siMainCellColIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b3e8c05 | this.spdMain.EditChange | SCP0022_Formation.cs:434 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-3955c6f5 | this.spdMain.EditChange | SCP0022_Formation.cs:435 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0022_Formation.SpdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71bbbede | this.spdMain.EditModeOff | SCP0022_Formation.cs:442 | if (this._siMainCellRowIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0022_Formation.ValidateUserInput

진입점: this.spdMain.EditModeOff [if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (res == false)] / this.spdExcept.EditModeOff [if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (res == false)] / dsdmMain.Changed [if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (res == false)] / dsdmExcept.Changed [if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.ADD_LT_FORMATION)) ▸ if (res == false)] / SaveButton [if (this.fps != null) ▸ if (fps.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0faeb2d | this.spdMain.EditModeOff [if (fps.Name == spdMain.Name) ▸ if… 외 4 | SCP0022_Formation.cs:1641 | if (action_name.Equals("UPPER_ZERO")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a9b9c1a | this.spdMain.EditModeOff [if (fps.Name == spdMain.Name) ▸ if… 외 4 | SCP0022_Formation.cs:1645 | else of (action_name.Equals("UPPER_ZERO")) ▸ if (action_name.Equals("ZERO_OR_HIGHER")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2053341a | this.spdMain.EditModeOff [if (fps.Name == spdMain.Name) ▸ if… 외 4 | SCP0022_Formation.cs:1650 | else of (action_name.Equals("UPPER_ZERO")) ▸ else of (action_name.Equals("ZERO_OR_HIGHER")) ▸ if (action_name.Equals("OVER_DAY_MIN")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00160", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

