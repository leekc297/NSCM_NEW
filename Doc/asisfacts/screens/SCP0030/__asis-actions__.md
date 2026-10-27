# AS-IS 액션 대조표 — SCP0030

> 원천: `Doc/asisfacts/screens/SCP0030/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 316행 · 메서드 38 · 종류 DATA_OP 81 · RETURN 30 · FLAG 29 · UI_PROP 23 · MESSAGE 21 · GRID_INIT 18 · CALL_EXT 17 · GRID_LOCK 16 · GRID_SET 16 · GRID_STYLE 13 · POPUP 12 · ENDPOINT 12 · LIST_REBIND 12 · UI_MISC 8 · VALIDATE 5 · GRID_BIND 2 · VALUE_SET 1 · ⚠ 의미 확인 필요 17


## SCP0030_BOD_ITEM.btnItemId_Click

진입점: btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a69f4c1 | btnItemId.Click | SCP0030_BOD_ITEM.cs:1639 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (clbDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd519a63 | btnItemId.Click | SCP0030_BOD_ITEM.cs:1646 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d8e0136b | btnItemId.Click | SCP0030_BOD_ITEM.cs:1648 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0b7645fc | btnItemId.Click | SCP0030_BOD_ITEM.cs:1649 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a7771338 | btnItemId.Click | SCP0030_BOD_ITEM.cs:1650 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d9bcfd38 | btnItemId.Click | SCP0030_BOD_ITEM.cs:1656 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0030_BOD_ITEM.checkValidN1

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4d4dc89 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1231 | for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7c05814 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1232 | for (i < siMain.ActiveSheet.RowCount) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-8e4efe99 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1266 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iRow2 < siMain.ActiveSheet.RowCount) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_… | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f39f81f | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1267 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iRow2 < siMain.ActiveSheet.RowCount) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_… | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-4a338836 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1277 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00212", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5e476d26 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1280 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0030_BOD_ITEM.checkValidN2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f55d65d | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1293 | for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fff1183 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1294 | for (i < siMain.ActiveSheet.RowCount) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-e3d4decb | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1328 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iRow2 < siMain.ActiveSheet.RowCount) ▸ if (ORG_FROM_YYYYMMDD != cp_ORG_FROM_YYYYMMDD && ORG_… | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1d67cfd | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1329 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iRow2 < siMain.ActiveSheet.RowCount) ▸ if (ORG_FROM_YYYYMMDD != cp_ORG_FROM_YYYYMMDD && ORG_… | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-5223dbf5 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1339 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00213", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c5230e8f | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1342 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0030_BOD_ITEM.checkValidN3

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e128f3cb | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1359 | for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd5eea0d | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1360 | for (i < siMain.ActiveSheet.RowCount) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-45a556b9 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1409 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iRow2 < siMain.ActiveSheet.RowCount) ▸ if (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMM… | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d1997cc | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1410 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iRow2 < siMain.ActiveSheet.RowCount) ▸ if (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMM… | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-67e83470 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1420 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00216", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0746f15a | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1423 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0030_BOD_ITEM.checkValidN4

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-199b51c5 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1436 | for (j < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dbebe759 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1437 | for (j < siMain.ActiveSheet.RowCount) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-6d73d7a2 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1451 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | (siMain.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6fc63ccd | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1465 | for (i <= siMain.GetMaxRowIndex()) ▸ if (!isPass) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-648f214e | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1466 | for (i <= siMain.GetMaxRowIndex()) ▸ if (!isPass) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-aa3aae0c | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1470 | for (i <= siMain.GetMaxRowIndex()) ▸ if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { text }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d2d5e85e | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1475 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0030_BOD_ITEM.checkValidN6

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14e01540 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1488 | for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1d884a49 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1489 | for (i < siMain.ActiveSheet.RowCount) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-eb48e134 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1508 | for (iRow < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | row.Field | (DefColumns.BOD_ITEM_VALID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d2ed833 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1509 | for (iRow < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | row.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e61bb084 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1510 | for (iRow < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | row.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-323c648c | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1511 | for (iRow < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | row.Field | (DefColumns.BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-93afe211 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1511 | for (iRow < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | row.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e587fdd | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1513 | for (iRow < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | row.Field | (DefColumns.BOD_ITEM_VALID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d79df109 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1514 | for (iRow < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | row.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-89fed7b5 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1515 | for (iRow < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | row.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a19ec91a | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1516 | for (iRow < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | row.Field | (DefColumns.BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd66ae8c | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1565 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (!isExistNextDate) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-298d69de | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1566 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (!isExistNextDate) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-0b473817 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1572 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00217", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-081fc56c | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1576 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0030_BOD_ITEM.checkValidN8

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0b5cdbf | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1594 | for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb0cba41 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1595 | for (i < siMain.ActiveSheet.RowCount) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-dc77c624 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1611 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (strORG_FROM_YYYYMMDD == string.Empty \|\| strORG_TO_YYYYMMDD == string.Empty) | GRID_STYLE | siMain.SetBGColor | (iRow, iColIdx1, iRow, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-ccc642f0 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1612 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (strORG_FROM_YYYYMMDD == string.Empty \|\| strORG_TO_YYYYMMDD == string.Empty) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-909a0245 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1622 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46b17d59 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1623 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-a470e47e | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1629 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-317cdb8e | (진입점 미연결) | SCP0030_BOD_ITEM.cs:1632 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0030_BOD_ITEM.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1d2df32 | this.Load | SCP0030_BOD_ITEM.cs:340 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-11053f46 | this.Load | SCP0030_BOD_ITEM.cs:341 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtExcluded, SpdSheet.shtExcluded, 2, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-68b853e0 | this.Load | SCP0030_BOD_ITEM.cs:343 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-926be277 | this.Load | SCP0030_BOD_ITEM.cs:344 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e49c53a0 | this.Load | SCP0030_BOD_ITEM.cs:347 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtExcluded) | 화면 필드/플래그 변경 |  |  |  |
| AC-719458b1 | this.Load | SCP0030_BOD_ITEM.cs:348 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtExcluded) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27c640b8 | this.Load | SCP0030_BOD_ITEM.cs:352 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0030_BOD_ITEM.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d8cc338 | this.Load | SCP0030_BOD_ITEM.cs:211 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-2d47f189 | this.Load | SCP0030_BOD_ITEM.cs:212 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-38126465 | this.Load | SCP0030_BOD_ITEM.cs:213 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0030_BOD_ITEM.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e95009f4 | DeleteButton | SCP0030_BOD_ITEM.cs:460 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2859e3be | DeleteButton | SCP0030_BOD_ITEM.cs:467 | if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca102e1d | DeleteButton | SCP0030_BOD_ITEM.cs:469 | if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a891a3e1 | DeleteButton | SCP0030_BOD_ITEM.cs:473 | if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0030_BOD_ITEM.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa4182e9 | Dispose | SCP0030_BOD_ITEM.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0030_BOD_ITEM.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a26ac632 | EditButton | SCP0030_BOD_ITEM.cs:606 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d55845c2 | EditButton | SCP0030_BOD_ITEM.cs:607 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ee97623a | EditButton | SCP0030_BOD_ITEM.cs:612 | if (siMain.ActiveSheet.SheetName == "BOD ITEM") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.INCOTERMS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-df4de5aa | EditButton | SCP0030_BOD_ITEM.cs:613 | if (siMain.ActiveSheet.SheetName == "BOD ITEM") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), siMain.GetColumnIndex(DefColumns.TO_YYY… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0c4c7054 | EditButton | SCP0030_BOD_ITEM.cs:614 | if (siMain.ActiveSheet.SheetName == "BOD ITEM") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.BOD_VALID), siMain.GetColumnIndex(DefColumns.LAST_UPDATE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-58bf84e8 | EditButton | SCP0030_BOD_ITEM.cs:618 | else of (siMain.ActiveSheet.SheetName == "BOD ITEM") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.OPMZ_PLAN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1dd19d9e | EditButton | SCP0030_BOD_ITEM.cs:619 | else of (siMain.ActiveSheet.SheetName == "BOD ITEM") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FROM_SITE_NAME), siMain.GetColumnIndex(DefColumns.TRANSP… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e1d33946 | EditButton | SCP0030_BOD_ITEM.cs:620 | else of (siMain.ActiveSheet.SheetName == "BOD ITEM") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.PRE_K… | 그리드 편집 잠금/해제 |  |  |  |
| AC-034d41cb | EditButton | SCP0030_BOD_ITEM.cs:622 |  | FLAG | this._isEditMode | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0030_BOD_ITEM.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52425d26 | FindButton | SCP0030_BOD_ITEM.cs:430 | if (siMain.ActiveSheet != null) | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0030_BOD_ITEM.FindData_Main

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f77eda9a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:631 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2e356ca2 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:635 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-4ac7cbee | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:635 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca986cde | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:643 | try | FLAG | _iSelRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-1fb5ff96 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:658 | try | CALL_EXT | CommonUtils.CheckItemNoAct | (p_item_id, p_nick_name, ref message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7daa8d23 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:661 | try ▸ if (CommonUtils.CheckDataEmpty(message) == false) | MESSAGE | MessageHelper.GMessageBox | (message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6596ef42 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:668 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-75c6b0af | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:669 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-04da616a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:670 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-19a54c6c | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:674 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0030_GET_BOD_ITEM") ⇒ SCP.SCP0030_GET_BOD_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-299475b0 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:675 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5ae7e9b9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:676 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-54ea9a26 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:677 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-684b166b | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:678 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-4c8aaf98 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:679 | try ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-060f4afe | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:680 | try ▸ lambda | DATA_OP | request.Parameters["p_trans_mode"] | p_trans_mode | 행/컬럼 값 대입 |  |  |  |
| AC-64080eb9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:681 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f1e6db9f | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:682 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-5f18ad5a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:683 | try ▸ lambda | DATA_OP | request.Parameters["p_valid"] | p_valid | 행/컬럼 값 대입 |  |  |  |
| AC-3a175f98 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:684 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2b302bb9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:687 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8d8ab748 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:689 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-680e9364 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:696 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a3b5a444 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:697 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5155d607 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:700 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-be705c67 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:702 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f55c170 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:706 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-621a41da | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:708 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-795587ee | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:715 | finally | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c30e4a6a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0030_BOD_ITEM.cs:716 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0030_BOD_ITEM.FindData_Sub

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7977e3fb | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:724 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-95928208 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:727 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d4012f70 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:727 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8a0e9a36 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:735 | try | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e2845af | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:738 | try | FLAG | _iSelRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-b1078626 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:752 | try | CALL_EXT | CommonUtils.CheckItemNoAct | (p_item_id, p_nick_name, ref message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8cb9fab0 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:755 | try ▸ if (CommonUtils.CheckDataEmpty(message) == false) | MESSAGE | MessageHelper.GMessageBox | (message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53058227 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:765 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8ced853e | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:766 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9873436d | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:767 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-846e6ecf | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:771 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0030_GET_BOD_EXCLUDED_ITEM") ⇒ SCP.SCP0030_GET_BOD_EXCLUDED_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-6a7c7535 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:772 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d0fdf47b | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:773 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-27ca60d5 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:774 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-bb70adf1 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:775 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-b86ea64e | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:776 | try ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-91022ff4 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:777 | try ▸ lambda | DATA_OP | request.Parameters["p_trans_mode"] | p_trans_mode | 행/컬럼 값 대입 |  |  |  |
| AC-6774a658 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:778 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a930d743 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:779 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-e12f04ff | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:780 | try ▸ lambda | DATA_OP | request.Parameters["p_valid"] | p_valid | 행/컬럼 값 대입 |  |  |  |
| AC-823992f8 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:781 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-76c15c0f | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:782 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-b1a96c53 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:784 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-79f63ae1 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:786 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-01d0ba90 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:793 | try | GRID_BIND | siMain.Query | (dsSub) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8595360c | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:794 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4017dab5 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:797 | try | UI_MISC | SetSearchCount | (dsSub) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f3f4bcf2 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:799 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab595ae9 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:806 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-67b5f681 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:808 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7a9ca218 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:815 | finally | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d37fe913 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0030_BOD_ITEM.cs:816 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0030_BOD_ITEM.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-286a75e4 | this.Load | SCP0030_BOD_ITEM.cs:164 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0030_BOD_ITEM.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ebafed4 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:246 |  | RETURN | return CString.GetCheckedListValue(dtMyDivision, clbDivision.ControlValues, true… |  | 처리 중단/반환 |  |  |  |

## SCP0030_BOD_ITEM.GetDivisionChecked

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2860e0f | (진입점 미연결) | SCP0030_BOD_ITEM.cs:881 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0030_BOD_ITEM.GetDivisionFilter

진입점: this.Load / clbDivision.SelectedIndexChanged / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ else of (this._division == "")] / SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ else of (this._division == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64fb50bc | this.Load 외 3 | SCP0030_BOD_ITEM.cs:265 | try | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID" }, new List<string>() { this._division }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a01c430b | this.Load 외 3 | SCP0030_BOD_ITEM.cs:271 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0030_BOD_ITEM.GetSearchInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-694810f1 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:836 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0130_GET_SEARCH_INFO") ⇒ SCP.SCP0130_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-359843ed | (진입점 미연결) | SCP0030_BOD_ITEM.cs:838 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-821717f9 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:839 |  | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-c1d54e20 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:840 |  | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-2eeaa7f5 | (진입점 미연결) | SCP0030_BOD_ITEM.cs:841 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-05ddde0e | (진입점 미연결) | SCP0030_BOD_ITEM.cs:845 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0030_BOD_ITEM.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-263a1e67 | this.Load | SCP0030_BOD_ITEM.cs:222 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-e1416dde | this.Load | SCP0030_BOD_ITEM.cs:224 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff419b0e | this.Load | SCP0030_BOD_ITEM.cs:226 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-95516be1 | this.Load | SCP0030_BOD_ITEM.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtIncoterms, clbIncoterms, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-36da33a8 | this.Load | SCP0030_BOD_ITEM.cs:228 |  | LIST_REBIND | clsCtrl.setListBox | (dtTransMode, clbTransMode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-15fee8d8 | this.Load | SCP0030_BOD_ITEM.cs:229 |  | LIST_REBIND | clsCtrl.setListBox | (dtValidYN, cboValidYN, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eb05270a | this.Load | SCP0030_BOD_ITEM.cs:232 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-06af205e | this.Load | SCP0030_BOD_ITEM.cs:233 |  | FLAG | dtPlanGroup | dtPlanGroupAll | 화면 필드/플래그 변경 |  |  |  |
| AC-6b6c4b8b | this.Load | SCP0030_BOD_ITEM.cs:235 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f210df00 | this.Load | SCP0030_BOD_ITEM.cs:237 |  | FLAG | dtItemAll | dsSearchInfo.Tables[6] | 화면 필드/플래그 변경 |  |  |  |

## SCP0030_BOD_ITEM.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe361106 | this.Load 외 2 | SCP0030_BOD_ITEM.cs:374 |  | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7b14b992 | this.Load 외 2 | SCP0030_BOD_ITEM.cs:379 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-90dcc901 | this.Load 외 2 | SCP0030_BOD_ITEM.cs:381 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("FromSiteByDivision", dtFromSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-9faaf37f | this.Load 외 2 | SCP0030_BOD_ITEM.cs:382 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("ToSiteByDivision", dtToSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-71c32dba | this.Load 외 2 | SCP0030_BOD_ITEM.cs:384 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-22bec036 | this.Load 외 2 | SCP0030_BOD_ITEM.cs:386 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.PRIORITY), 0, 0, 99) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-46c544f2 | this.Load 외 2 | SCP0030_BOD_ITEM.cs:387 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK), 0, 0, 100) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-884dd4a6 | this.Load 외 2 | SCP0030_BOD_ITEM.cs:389 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff0d5272 | this.Load 외 2 | SCP0030_BOD_ITEM.cs:391 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4aa3cba6 | this.Load 외 2 | SCP0030_BOD_ITEM.cs:398 | if (spreadInfo.SheetName == SpdSheet.shtExcluded) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e584419e | this.Load 외 2 | SCP0030_BOD_ITEM.cs:399 | if (spreadInfo.SheetName == SpdSheet.shtExcluded) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-e0a5739c | this.Load 외 2 | SCP0030_BOD_ITEM.cs:401 | if (spreadInfo.SheetName == SpdSheet.shtExcluded) | LIST_REBIND | SpreadInfo.SetComBoParam | ("Division", dtMyDivision) | 목록 컨트롤 재구성 |  |  |  |
| AC-53e132b5 | this.Load 외 2 | SCP0030_BOD_ITEM.cs:403 | if (spreadInfo.SheetName == SpdSheet.shtExcluded) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd866818 | this.Load 외 2 | SCP0030_BOD_ITEM.cs:404 | if (spreadInfo.SheetName == SpdSheet.shtExcluded) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0030_BOD_ITEM.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09b41124 | InsertButton | SCP0030_BOD_ITEM.cs:579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcluded) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5df000b7 | InsertButton | SCP0030_BOD_ITEM.cs:590 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcluded) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b34e3a5 | InsertButton | SCP0030_BOD_ITEM.cs:591 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcluded) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-44e16923 | InsertButton | SCP0030_BOD_ITEM.cs:594 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcluded) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-722c0c18 | InsertButton | SCP0030_BOD_ITEM.cs:596 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcluded) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_NAME), siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f63d6dcb | InsertButton | SCP0030_BOD_ITEM.cs:597 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcluded) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.FROM_SITE_NAME), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-90d4dd51 | InsertButton | SCP0030_BOD_ITEM.cs:598 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (_sActiveSheetName == SpdSheet.shtExcluded) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0030_BOD_ITEM.InsertRow2

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (var bodItem in bodPopup.retList) ▸ if (idx > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbdd34a6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1899 |  | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ec5769dd | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1905 |  | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionId) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5f254b9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1906 |  | DATA_OP | defaultData.Add | (DefColumns.OPMZ_PLAN_GR_NAME, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-50dc9b98 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1907 |  | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-65806da7 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1908 |  | DATA_OP | defaultData.Add | (DefColumns.BOD_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-d81ba8fb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1909 |  | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE_NAME, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-edb869ef | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1910 |  | DATA_OP | defaultData.Add | (DefColumns.TO_SITE_NAME, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-f10a0473 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1911 |  | DATA_OP | defaultData.Add | (DefColumns.INCOTERMS, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9c0e047 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1912 |  | DATA_OP | defaultData.Add | (DefColumns.TRANSPORT_MODE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ce7e999 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1913 |  | DATA_OP | defaultData.Add | (DefColumns.BOD_EX_FROM_YYYYMMDD, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c7dc7b3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1914 |  | DATA_OP | defaultData.Add | (DefColumns.BOD_EX_TO_YYYYMMDD, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-d01076d9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1915 |  | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d721d96 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1916 |  | DATA_OP | defaultData.Add | (DefColumns.PRE_KEY_VALUES, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-35d33e3c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1918 |  | GRID_SET | this.siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-0ade8003 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1920 |  | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0e333968 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1921 |  | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.BOD_ID), siMain.GetColumnIndex(DefColumns.TRANS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-46d6e688 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:1922 |  | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0030_BOD_ITEM.RefreshCustomer

진입점: this.Load / clbDivision.SelectedIndexChanged / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7852bc9d | this.Load 외 3 | SCP0030_BOD_ITEM.cs:303 |  | FLAG | dtCustomer | DBUtils.Filter(dtCustomerAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d5d6dbc5 | this.Load 외 3 | SCP0030_BOD_ITEM.cs:303 |  | DATA_OP | DBUtils.Filter | (dtCustomerAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0030_BOD_ITEM.RefreshFromSite

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e395258d | this.Load 외 1 | SCP0030_BOD_ITEM.cs:278 |  | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-33c9e1c8 | this.Load 외 1 | SCP0030_BOD_ITEM.cs:278 |  | DATA_OP | DBUtils.Filter | (dtFromSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-33e0ad24 | this.Load 외 1 | SCP0030_BOD_ITEM.cs:279 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0030_BOD_ITEM.RefreshPlanGroupByDivision

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f1ba5e1 | this.Load 외 1 | SCP0030_BOD_ITEM.cs:310 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-8f6fdafe | this.Load 외 1 | SCP0030_BOD_ITEM.cs:310 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9eefb0ec | this.Load 외 1 | SCP0030_BOD_ITEM.cs:312 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0030_BOD_ITEM.RefreshToSite

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27f83b3b | this.Load 외 1 | SCP0030_BOD_ITEM.cs:286 |  | FLAG | dtToSite | DBUtils.Filter(dtToSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b7d265e0 | this.Load 외 1 | SCP0030_BOD_ITEM.cs:286 |  | DATA_OP | DBUtils.Filter | (dtToSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c9276af7 | this.Load 외 1 | SCP0030_BOD_ITEM.cs:287 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0030_BOD_ITEM.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee066141 | SaveButton | SCP0030_BOD_ITEM.cs:451 | if (siMain.ActiveSheet != null) | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0030_BOD_ITEM.SaveData_Main

진입점: SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3b62277 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:912 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad4113a0 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:929 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-cf96a5fd | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:929 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5dc03d96 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:934 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ae69eeeb | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:966 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | FLAG | p_seq | += delimiter + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0e787010 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:987 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0030_SAVE_BOD_ITEM") ⇒ SCP.SCP0030_SAVE_BOD_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-2af84fec | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:991 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e8b2a20c | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:992 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-c10836cc | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:993 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-68930668 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:994 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e1bdbebf | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:995 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b8dab7b6 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:996 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-c30db06b | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:997 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0d741d5b | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:998 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7a32dad1 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:999 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_safety_stock"] | p_safety_stock | 행/컬럼 값 대입 |  |  |  |
| AC-5a5d4f06 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:1000 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-3fd13ffb | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:1002 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ac135f32 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:1003 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-6b971fb5 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:1005 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a887d8a8 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:1010 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5eb7e7de | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:1019 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8732a3e2 | SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0030_BOD_ITEM.cs:1027 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0030_BOD_ITEM.SaveData_Sub

진입점: SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-523fde63 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1046 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f5efec1 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1067 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-1cb8fe54 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1067 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66f933f6 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1126 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ catc… | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { siMain.SheetName.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da0558e5 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1127 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ catc… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-202900ed | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1134 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4b65b672 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1135 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9ee0576 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1168 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0030_SAVE_BOD_EXCLUDED_ITEM") ⇒ SCP.SCP0030_SAVE_BOD_EXCLUDED_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-98647061 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1172 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-02bbf292 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1173 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9633a590 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1174 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b3e57f96 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1175 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-2d8218a2 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1176 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bod_ex_from_yyyymmdd"] | p_bod_ex_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fa151b60 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1177 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bod_ex_to_yyyymmdd"] | p_bod_ex_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-87109bdb | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1178 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-993e609e | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1179 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-054b9223 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1181 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-900bbce9 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1182 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a4cd8761 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1183 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pre_bod_id"] | p_pre_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-df513e9a | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1184 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pre_bod_ex_from_yyyymmdd"] | p_pre_bod_ex_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-58df4933 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1185 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pre_bod_ex_to_yyyymmdd"] | p_pre_bod_ex_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0140dbde | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1187 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3dbd16d3 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1192 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.Data… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-add40724 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1200 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ee89867 | SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0030_BOD_ITEM.cs:1209 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtExcluded) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0030_BOD_ITEM.SetImageCell

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (var bodItem in bodPopup.retList) ▸ if (idx > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d03574f8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader) ▸ if (e.C… | SCP0030_BOD_ITEM.cs:898 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SCP0030_BOD_ITEM.SetOrgData

진입점: dsdm.Changed [if (siMain.ActiveSheet.SheetName=="BOD ITEM") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD) \|\| e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD))] / dsdmExcept.Changed [if (siMain.ActiveSheet.SheetName=="BOD ITEM") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD) \|\| e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6ceb262 | dsdm.Changed [if (siMain.ActiveSheet.SheetName=="BOD ITEM") … 외 1 | SCP0030_BOD_ITEM.cs:1672 |  | GRID_SET | dt.Rows[nRowIdx][DefColumns.ORG_FROM_YYYYMMDD] | strFROM_YYYYMMDD | 그리드 속성/값 설정 |  |  |  |
| AC-7d3c7927 | dsdm.Changed [if (siMain.ActiveSheet.SheetName=="BOD ITEM") … 외 1 | SCP0030_BOD_ITEM.cs:1673 |  | GRID_SET | dt.Rows[nRowIdx][DefColumns.ORG_TO_YYYYMMDD] | strTO_YYYYMMDD | 그리드 속성/값 설정 |  |  |  |
| AC-1a885397 | dsdm.Changed [if (siMain.ActiveSheet.SheetName=="BOD ITEM") … 외 1 | SCP0030_BOD_ITEM.cs:1674 |  | GRID_SET | dt.Rows[nRowIdx][DefColumns.MERGE_DATE] | strFROM_YYYYMMDD + strTO_YYYYMMDD | 그리드 속성/값 설정 |  |  |  |
| AC-6ec4d317 | dsdm.Changed [if (siMain.ActiveSheet.SheetName=="BOD ITEM") … 외 1 | SCP0030_BOD_ITEM.cs:1675 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0030_BOD_ITEM.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d23d998 | this.spdMain.ActiveSheetChanged | SCP0030_BOD_ITEM.cs:1729 | if (sender != null) | FLAG | _sActiveSheetName | ((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |

## SCP0030_BOD_ITEM.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c11e4588 | spdMain.CellClick | SCP0030_BOD_ITEM.cs:1685 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-534145ea | spdMain.CellClick | SCP0030_BOD_ITEM.cs:1692 | if (siMain.ActiveSheet.SheetName == "Excluded Item") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.DIVISION_ID, dtMyDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-45b74fca | spdMain.CellClick | SCP0030_BOD_ITEM.cs:1697 |  | FLAG | _iSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## SCP0030_BOD_ITEM.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e598cc6 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1769 | if (siMain.ActiveSheet.SheetName != "Excluded Item") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef93c4d7 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1777 | if (!e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != C… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d04b1cff | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1787 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6ea09df7 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1789 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2a9c499f | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1790 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-db8ae14c | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1791 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e1cc6b47 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1797 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (sItemId != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-562c0441 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1800 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (sItemId != "") ▸ if (siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-46e7a148 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1813 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | DATA_OP | DBUtils.Filter | (dtItemAll, "DIVISION_ID = '" + p_division_id + "' AND ITEM_ID = '" + p_item_id + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8b5b99b5 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1816 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (dtItem.Rows.Count <= 0) | FLAG | p_operationGroup | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a949fde7 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1820 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ else of (dtItem.Rows.Count <= 0) | FLAG | p_operationGroup | dtItem.Rows[0]["OPERATION_GROUP"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1fda7dc7 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1823 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | FLAG | p_planType | "MA" | 화면 필드/플래그 변경 |  |  |  |
| AC-85cc2a9c | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1827 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | FLAG | p_prgram_id | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-1a5c4fef | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1828 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | FLAG | p_seq | "1" | 화면 필드/플래그 변경 |  |  |  |
| AC-8e8ab113 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1830 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | FLAG | p_plan_start_yyyymmdd | today.ToString("yyyymmdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-c2db0d10 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1834 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | POPUP | new SCM0002_GetBODItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6ae1f32a | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1835 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | UI_PROP | bodPopup.p_division_id | p_division_id | 속성 p_division_id 설정 |  |  |  |
| AC-55ea687f | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1836 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | UI_PROP | bodPopup.p_operation_group | p_operationGroup | 속성 p_operation_group 설정 |  |  |  |
| AC-7c7c30d7 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1837 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | UI_PROP | bodPopup.p_plan_start_yyyymmdd | p_plan_start_yyyymmdd | 속성 p_plan_start_yyyymmdd 설정 |  |  |  |
| AC-a503b93a | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1838 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | UI_PROP | bodPopup.p_plan_type | p_planType | 속성 p_plan_type 설정 |  |  |  |
| AC-da63d70f | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1839 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | UI_PROP | bodPopup.p_seq | p_seq | 속성 p_seq 설정 |  |  |  |
| AC-a8537055 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1840 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | UI_PROP | bodPopup.p_origin_from_division_id | p_division_id | 속성 p_origin_from_division_id 설정 |  |  |  |
| AC-37842238 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1841 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | UI_PROP | bodPopup.p_to_division_id | p_division_id | 속성 p_to_division_id 설정 |  |  |  |
| AC-8c98ab13 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1842 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | UI_PROP | bodPopup.p_item_id | p_item_id | 속성 p_item_id 설정 |  |  |  |
| AC-789d9ce6 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1843 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | UI_PROP | bodPopup.p_prgram_id | p_prgram_id | 속성 p_prgram_id 설정 |  |  |  |
| AC-6d3ff9a0 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1845 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | UI_PROP | bodPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f01ef44e | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1846 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) | POPUP | bodPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9e371128 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1851 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ if (bodPo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0fb3b102 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1866 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (… | GRID_LOCK | siMain.LockRange | (insRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), e.Row, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a8216528 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1874 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), p_division_id) | 그리드 값 설정 |  |  |  |
| AC-af75f442 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1875 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_NAME), p_plan_group) | 그리드 값 설정 |  |  |  |
| AC-24a79c91 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1876 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), p_item_id) | 그리드 값 설정 |  |  |  |
| AC-28f59771 | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1879 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefColumns.FROM_SITE_NAME), bodItem.c_from_site) | 그리드 값 설정 |  |  |  |
| AC-32ef5fdc | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1880 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefColumns.TO_SITE_NAME), bodItem.c_to_site) | 그리드 값 설정 |  |  |  |
| AC-0657b66e | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1881 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefColumns.BOD_ID), bodItem.c_bod_id) | 그리드 값 설정 |  |  |  |
| AC-fadb7cea | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1882 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), bodItem.c_incoterms) | 그리드 값 설정 |  |  |  |
| AC-32e794de | this.spdMain.CellDoubleClick | SCP0030_BOD_ITEM.cs:1883 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOD_ID)) ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), bodItem.c_transport_mode) | 그리드 값 설정 |  |  |  |

## SCP0030_BOD_ITEM.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efdd8a3b | spdMain.TopChange | SCP0030_BOD_ITEM.cs:201 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-88eb008b | spdMain.TopChange | SCP0030_BOD_ITEM.cs:204 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0030_BOD_ITEM.spdSub_ActiveSheetChanging

진입점: this.spdMain.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75120564 | this.spdMain.ActiveSheetChanging | SCP0030_BOD_ITEM.cs:1738 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!siMain.IsLock(SpdSheet.shtExcluded)) | UI_PROP | e.ActivatedSheetIndex | siMain.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-1ed7162c | this.spdMain.ActiveSheetChanging | SCP0030_BOD_ITEM.cs:1740 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!siMain.IsLock(SpdSheet.shtExcluded)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { SpdSheet.shtExcluded }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9d11da4e | this.spdMain.ActiveSheetChanging | SCP0030_BOD_ITEM.cs:1741 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!siMain.IsLock(SpdSheet.shtExcluded)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a115e81 | this.spdMain.ActiveSheetChanging | SCP0030_BOD_ITEM.cs:1748 | else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!siMain.IsLock(SpdSheet.shtMain)) | UI_PROP | e.ActivatedSheetIndex | siMain.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-dc48df57 | this.spdMain.ActiveSheetChanging | SCP0030_BOD_ITEM.cs:1750 | else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!siMain.IsLock(SpdSheet.shtMain)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { SpdSheet.shtMain }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d321b149 | this.spdMain.ActiveSheetChanging | SCP0030_BOD_ITEM.cs:1751 | else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!siMain.IsLock(SpdSheet.shtMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f0f51b7 | this.spdMain.ActiveSheetChanging | SCP0030_BOD_ITEM.cs:1758 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siMain.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-885c7571 | this.spdMain.ActiveSheetChanging | SCP0030_BOD_ITEM.cs:1760 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a738fc8e | this.spdMain.ActiveSheetChanging | SCP0030_BOD_ITEM.cs:1761 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

