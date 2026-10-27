# AS-IS 액션 대조표 — SCP0115

> 원천: `Doc/asisfacts/screens/SCP0115/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 366행 · 메서드 43 · 종류 DATA_OP 90 · RETURN 62 · GRID_SET 41 · FLAG 31 · CALL_EXT 30 · UI_PROP 26 · ENDPOINT 14 · POPUP 13 · UI_MISC 12 · GRID_LOCK 11 · MESSAGE 9 · GRID_INIT 8 · LIST_REBIND 6 · STATE 4 · VALUE_SET 3 · GRID_COMBO 2 · CALL_BASE 1 · VALIDATE 1 · GRID_BIND 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 31


## SCP0115_PolicyInvMgmt.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa48a4ae | this.btnColumn.Click | SCP0115_PolicyInvMgmt.cs:2063 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0115", SpdSheet.shtMain, true, fixedColumns) | 팝업/폼 생성 |  |  |  |
| AC-dfdad24b | this.btnColumn.Click | SCP0115_PolicyInvMgmt.cs:2064 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7a82072d | this.btnColumn.Click | SCP0115_PolicyInvMgmt.cs:2065 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0115_PolicyInvMgmt.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2635c14 | this.btnImport.Click | SCP0115_PolicyInvMgmt.cs:1989 |  | POPUP | new ExcelUploadForm | ("SCP0115", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-23993cba | this.btnImport.Click | SCP0115_PolicyInvMgmt.cs:1990 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-8a69a887 | this.btnImport.Click | SCP0115_PolicyInvMgmt.cs:1991 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f16847e4 | this.btnImport.Click | SCP0115_PolicyInvMgmt.cs:1992 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0115_PolicyInvMgmt.ChangeEditCell

진입점: this.spdMain.Change / this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-997f026a | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1792 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | DATA_OP | notEditablePlanTypes.Contains | (planType) | 데이터 객체 조작/조회 |  |  |  |
| AC-658f2e32 | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1794 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_LOCK | siMain.LockRange | (rowIndex, siMain.GetColumnIndex(DefColumns.EXHT_TP_DESC), rowIndex, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f2db83dd | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1795 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, siMain.GetColumnIndex(DefColumns.EXHT_TP_DESC), "*") | 그리드 값 설정 |  |  |  |
| AC-39c0c9f0 | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1800 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_LOCK | siMain.LockRange | (rowIndex, siMain.GetColumnIndex(DefColumns.EXHT_TP_DESC), rowIndex, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-16f0bacd | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1801 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, siMain.GetColumnIndex(DefColumns.EXHT_TP_DESC), null) | 그리드 값 설정 |  |  |  |
| AC-a33ec953 | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1817 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.ActiveSheet.Cells[rowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID)].CellType | comboBoxValue | 그리드 속성/값 설정 |  |  |  |
| AC-4f3e4154 | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1820 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | CALL_EXT | Array.Exists | (comboBoxValue.Items, item => item.Equals(divId, StringComparison.Ordinal)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b13bb58b | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1823 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), divId) | 그리드 값 설정 |  |  |  |
| AC-a45e0ba5 | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1827 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), null) | 그리드 값 설정 |  |  |  |
| AC-59a9ad4c | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1833 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_LOCK | siMain.LockRange | (rowIndex, siMain.GetColumnIndex(DefColumns.COMPANY_ID), rowIndex, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d0df6030 | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1834 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, siMain.GetColumnIndex(DefColumns.COMPANY_ID), null) | 그리드 값 설정 |  |  |  |
| AC-eea4baeb | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1846 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.ActiveSheet.Cells[rowIndex, siMain.GetColumnIndex(DefColumns.PLANT_ID)].CellType | comboBoxValue | 그리드 속성/값 설정 |  |  |  |
| AC-eb6880ca | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1849 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | CALL_EXT | Array.Exists | (comboBoxValue.Items, item => item.Equals(plantId, StringComparison.Ordinal)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc9f8cdb | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1852 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, siMain.GetColumnIndex(DefColumns.PLANT_ID), plantId) | 그리드 값 설정 |  |  |  |
| AC-28f84daa | this.spdMain.Change 외 1 | SCP0115_PolicyInvMgmt.cs:1856 | if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, siMain.GetColumnIndex(DefColumns.PLANT_ID), null) | 그리드 값 설정 |  |  |  |

## SCP0115_PolicyInvMgmt.CheckExcelValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64935f2c | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1431 | try ▸ for (i < dtData.Rows.Count) ▸ if (string.IsNullOrEmpty(dtData.Rows[i][planDateIndex].ToString().Trim())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-646b0c96 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1440 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(dtData.Rows[i][planDateIndex].ToString().Trim())) ▸ if (!IsValidYyyyMmDd(p… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c094b009 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1448 | try ▸ for (i < dtData.Rows.Count) ▸ if (string.IsNullOrEmpty(dtData.Rows[i][planTPDescIndex].ToString().Trim())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4121f95b | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1455 | try ▸ for (i < dtData.Rows.Count) ▸ if (string.IsNullOrEmpty(dtData.Rows[i][occrCDIndex].ToString().Trim())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0618f58b | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1462 | try ▸ for (i < dtData.Rows.Count) ▸ if (string.IsNullOrEmpty(dtData.Rows[i][exhtCDIndex].ToString().Trim())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7f0841e8 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1470 | try ▸ for (i < dtData.Rows.Count) ▸ if (string.IsNullOrEmpty(dtData.Rows[i][companyIndex].ToString().Trim())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6695dbf6 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1477 | try ▸ for (i < dtData.Rows.Count) ▸ if (string.IsNullOrEmpty(dtData.Rows[i][divIndex].ToString().Trim())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ad32c31b | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1484 | try ▸ for (i < dtData.Rows.Count) ▸ if (string.IsNullOrEmpty(dtData.Rows[i][plantIdIndex].ToString().Trim())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-23d6d360 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1491 | try ▸ for (i < dtData.Rows.Count) ▸ if (string.IsNullOrEmpty(dtData.Rows[i][itemIdIndex].ToString().Trim())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-20c22998 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1498 | try ▸ for (i < dtData.Rows.Count) ▸ if (string.IsNullOrEmpty(dtData.Rows[i][etaIndex].ToString().Trim())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8b8a9739 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1506 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(dtData.Rows[i][etaIndex].ToString().Trim())) ▸ if (!IsValidYyyyMmDd(etaVal… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6130e172 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1511 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-29e41887 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1513 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.CheckSpreadValidation

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbf71b71 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1311 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(planDateCol.Trim())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-82360904 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1320 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrEmpty(planDateCol.Trim())) ▸ if (!IsValidYyyyMmDd(planDateCol)) ▸ if (!Is… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d16dc639 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1330 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_TP_DESC)).ToStr… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-81a04cb5 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1337 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OCCR_RSN_DESC)).ToSt… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-87c7e483 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1344 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EXHT_TP_DESC)).ToStr… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d12148e5 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1352 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToStri… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-304ccbb8 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1359 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString(… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-23bf6f18 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1367 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString()… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6edae2aa | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1381 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ foreach (DataRow dc in dataCheck) ▸ if (isInsert == true && dc[9].ToString() == siMain.GetValue(i… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d47a7fbc | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1389 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ETA)).ToString().Tri… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a8bcccaf | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1396 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrEmpty(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ETA)).ToString(… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-59c17f05 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1403 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-56e76319 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1405 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.ConvertDateToYyyyMmDd

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex())] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e70a87eb | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0115_PolicyInvMgmt.cs:1641 |  | CALL_EXT | Regex.IsMatch | (dateString, pattern) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f66d20bc | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0115_PolicyInvMgmt.cs:1643 | if (Regex.IsMatch(dateString, pattern)) | RETURN | return dateString.Substring(4); |  | 처리 중단/반환 |  |  |  |
| AC-86af1a00 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0115_PolicyInvMgmt.cs:1645 |  | RETURN | return dateString; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.convertMasterDataToList

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d49751a | this.Load | SCP0115_PolicyInvMgmt.cs:537 | if (masterData.Rows.Count > 0) ▸ foreach (DataRow row in masterData.Rows) | DATA_OP | result.Add | (pair) | 데이터 객체 조작/조회 |  |  |  |
| AC-87985c3b | this.Load | SCP0115_PolicyInvMgmt.cs:541 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.CreateComboboxCellType

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ for (iSheetIndex < spSpread.Sheets.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51a3df37 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0115_PolicyInvMgmt.cs:502 | if (listData != null && listData.Rows.Count > 0) ▸ for (i <= listData.Rows.Count - 1) ▸ if (lookupType == "DIV" \|\| lookupType == "PLANT_ID… | DATA_OP | list.Add | (listData.Rows[i][0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9b4cc50 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0115_PolicyInvMgmt.cs:506 | if (listData != null && listData.Rows.Count > 0) ▸ for (i <= listData.Rows.Count - 1) ▸ else of (lookupType == "DIV" \|\| lookupType == "PLA… | DATA_OP | list.Add | (listData.Rows[i][1].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a1b526a | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0115_PolicyInvMgmt.cs:509 | if (listData != null && listData.Rows.Count > 0) | UI_PROP | comboBoxCellType.Items | list.ToArray() | 속성 Items 설정 |  |  |  |
| AC-b851970b | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0115_PolicyInvMgmt.cs:510 | if (listData != null && listData.Rows.Count > 0) | STATE | comboBoxCellType.Editable | false | 컨트롤 상태 Editable |  |  |  |
| AC-26d6dc66 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0115_PolicyInvMgmt.cs:513 |  | RETURN | return comboBoxCellType; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.CreateComboBoxForSheetView

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (string.IsNullOrEmpty(saveReasonResult)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-566e0fee | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:949 |  | DATA_OP | masterData.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b65b7d88 | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:954 | if (resultTable != null && resultTable.Rows.Count > 0) ▸ for (i < resultTable.Rows.Count) | DATA_OP | resultTable.Select | ("") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7ea7cfe | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:956 | if (resultTable != null && resultTable.Rows.Count > 0) ▸ for (i < resultTable.Rows.Count) | GRID_SET | resultTable.Rows[i][1] | resultTable.Rows[i][0].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-595f0a86 | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:960 |  | RETURN | return resultTable; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.CreateDivComboboxById

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6570c5b | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1899 |  | FLAG | dtPlantByGroup | DBUtils.Filter(dtPlantByGroupAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-abde0b57 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1899 |  | DATA_OP | DBUtils.Filter | (dtPlantByGroupAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b69762ea | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1901 |  | DATA_OP | dtPlantByGroup.AsEnumerable().Select | (row => row["DIVISION_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea53ddfe | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1904 |  | DATA_OP | DBUtils.Filter | (dtMyDivision, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0b9e2a4f | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1912 | if (listData != null && listData.Rows.Count > 0) ▸ for (i <= listData.Rows.Count - 1) | DATA_OP | list.Add | (listData.Rows[i][0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-5547eee1 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1914 | if (listData != null && listData.Rows.Count > 0) | UI_PROP | comboBoxCellType.Items | list.ToArray() | 속성 Items 설정 |  |  |  |
| AC-7c370893 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1915 | if (listData != null && listData.Rows.Count > 0) | STATE | comboBoxCellType.Editable | false | 컨트롤 상태 Editable |  |  |  |
| AC-38623c8a | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1918 |  | RETURN | return comboBoxCellType; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.CreateDivisionComboboxById

진입점: this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns.COMPANY_ID)) ▸ if (!string.IsNullOrEmpty(company_id))] / this.spdMain.LeaveCell [if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns.COMPANY_ID)) ▸ if (!string.IsNullOrEmpty(company_id))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c50b835 | this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == C… 외 1 | SCP0115_PolicyInvMgmt.cs:1929 |  | DATA_OP | DBUtils.Filter | (dtMyCompanyAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8e450214 | this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == C… 외 1 | SCP0115_PolicyInvMgmt.cs:1937 | if (listData != null && listData.Rows.Count > 0) ▸ for (i <= listData.Rows.Count - 1) | DATA_OP | list.Add | (listData.Rows[i][2].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e21d197 | this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == C… 외 1 | SCP0115_PolicyInvMgmt.cs:1939 | if (listData != null && listData.Rows.Count > 0) | UI_PROP | comboBoxCellType.Items | list.ToArray() | 속성 Items 설정 |  |  |  |
| AC-9929fd30 | this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == C… 외 1 | SCP0115_PolicyInvMgmt.cs:1940 | if (listData != null && listData.Rows.Count > 0) | STATE | comboBoxCellType.Editable | false | 컨트롤 상태 Editable |  |  |  |
| AC-85ec0520 | this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == C… 외 1 | SCP0115_PolicyInvMgmt.cs:1943 |  | RETURN | return comboBoxCellType; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.CreatePlantComboboxById

진입점: this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (!string.IsNullOrEmpty(divId))] / this.spdMain.LeaveCell [if (!siMain.IsLock()) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM) ▸ if (colIndex == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (!string.IsNullOrEmpty(divId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a1b5c69 | this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == C… 외 1 | SCP0115_PolicyInvMgmt.cs:1954 |  | DATA_OP | DBUtils.Filter | (dtPlantByGroupAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b9fb897f | this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == C… 외 1 | SCP0115_PolicyInvMgmt.cs:1962 | if (listData != null && listData.Rows.Count > 0) ▸ for (i <= listData.Rows.Count - 1) | DATA_OP | list.Add | (listData.Rows[i][0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-29d7a2e8 | this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == C… 외 1 | SCP0115_PolicyInvMgmt.cs:1964 | if (listData != null && listData.Rows.Count > 0) | UI_PROP | comboBoxCellType.Items | list.ToArray() | 속성 Items 설정 |  |  |  |
| AC-a59e1b22 | this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == C… 외 1 | SCP0115_PolicyInvMgmt.cs:1965 | if (listData != null && listData.Rows.Count > 0) | STATE | comboBoxCellType.Editable | false | 컨트롤 상태 Editable |  |  |  |
| AC-eaccd507 | this.spdMain.Change [if (!siMain.IsLock()) ▸ if (action == C… 외 1 | SCP0115_PolicyInvMgmt.cs:1968 |  | RETURN | return comboBoxCellType; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9eb1aed | this.Load | SCP0115_PolicyInvMgmt.cs:243 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2cf15d5b | this.Load | SCP0115_PolicyInvMgmt.cs:245 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8e1da096 | this.Load | SCP0115_PolicyInvMgmt.cs:247 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0115_PolicyInvMgmt.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a045774e | DeleteButton | SCP0115_PolicyInvMgmt.cs:389 |  | FLAG | isInsert | false | 화면 필드/플래그 변경 |  |  |  |
| AC-102b2959 | DeleteButton | SCP0115_PolicyInvMgmt.cs:390 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0115_PolicyInvMgmt.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1dfc5a34 | Dispose | SCP0115_PolicyInvMgmt.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0115_PolicyInvMgmt.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7a7f88a | EditButton | SCP0115_PolicyInvMgmt.cs:314 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-648d2dee | EditButton | SCP0115_PolicyInvMgmt.cs:317 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-206c6f81 | EditButton | SCP0115_PolicyInvMgmt.cs:318 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1654f1aa | EditButton | SCP0115_PolicyInvMgmt.cs:324 | if (!siMain.IsLock()) ▸ if (siMain.ActiveSheet.RowCount > 0) | FLAG | isInsert | false | 화면 필드/플래그 변경 |  |  |  |
| AC-eaea161b | EditButton | SCP0115_PolicyInvMgmt.cs:325 | if (!siMain.IsLock()) ▸ if (siMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4cebd4f | EditButton | SCP0115_PolicyInvMgmt.cs:330 | if (!siMain.IsLock()) ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < editableColumnsInEditState.Length) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(editableColumnsInEditState[i]), siMain.ActiveSheet.RowCount - 1,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8bdbeb50 | EditButton | SCP0115_PolicyInvMgmt.cs:339 | else of (!siMain.IsLock()) ▸ if (siMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0115_PolicyInvMgmt.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67b62544 | ExcelButton | SCP0115_PolicyInvMgmt.cs:355 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00100") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-deb704a4 | ExcelButton | SCP0115_PolicyInvMgmt.cs:362 | try ▸ else of (result == DialogResult.Yes) ▸ else of (result == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.ExportExcelData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74aede9c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:558 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d98a6de5 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:562 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b582938c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:580 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-842f29b5 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:587 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e57238fd | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:589 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d485d11 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:592 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e9886e4 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:628 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-61699f22 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:633 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-0054b693 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:639 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | ScpUtils.GetColumnName | (newSheet, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-56ed30fb | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:645 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ switch (columnName) case "COLMERGE": | DATA_OP | newSheet.Columns[i].Remove | () | 데이터 객체 조작/조회 |  |  |  |
| AC-75851678 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:648 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ switch (columnName) case "ACTION": | DATA_OP | newSheet.Columns[i].Remove | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0f989f76 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:655 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | ScpUtils.GetColumnName | (newSheet, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e13509fa | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:686 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78dbd9e0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:688 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd301a41 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:697 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-51622b64 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:709 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-c0402425 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:710 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-5a340f22 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:719 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-25a9d06f | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:720 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-a7d90338 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:726 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-ac5dcd90 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:739 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-a7e31819 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:748 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-7888f507 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:760 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (dateColPos >= 0) | UI_PROP | dateCell.DateTimeFormat | FarPoint.Win.Spread.CellType.DateTimeFormat.UserDefined | 속성 DateTimeFormat 설정 |  |  |  |
| AC-732a6f08 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:761 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (dateColPos >= 0) | UI_PROP | dateCell.UserDefinedFormat | "yyyy-MM-dd hh:mm:ss" | 속성 UserDefinedFormat 설정 |  |  |  |
| AC-67fc8a0c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:762 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (dateColPos >= 0) | GRID_SET | newSheet.Columns[dateColPos].CellType | dateCell | 그리드 속성/값 설정 |  |  |  |
| AC-662f356d | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:781 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) | GRID_SET | newSheet.Cells[i, planTypeColPos].CellType | comboBoxCellType_PlanType | 그리드 속성/값 설정 |  |  |  |
| AC-099347b7 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:784 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) ▸ if (!string.IsNullOrEmpty(value_PlanType)) | GRID_SET | newSheet.Cells[i, planTypeColPos].Value | value_PlanType | 그리드 속성/값 설정 |  |  |  |
| AC-963d1c78 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:788 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) | GRID_SET | newSheet.Cells[i, occrColPos].CellType | comboBoxCellType_OCCR | 그리드 속성/값 설정 |  |  |  |
| AC-b02ec0f6 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:791 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) ▸ if (!string.IsNullOrEmpty(value_OCCR)) | GRID_SET | newSheet.Cells[i, occrColPos].Value | value_OCCR | 그리드 속성/값 설정 |  |  |  |
| AC-9d415785 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:795 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) | GRID_SET | newSheet.Cells[i, exthColPos].CellType | comboBoxCellType_EXHT | 그리드 속성/값 설정 |  |  |  |
| AC-aba168ab | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:798 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) ▸ if (!string.IsNullOrEmpty(value_EXHT)) | GRID_SET | newSheet.Cells[i, exthColPos].Value | value_EXHT | 그리드 속성/값 설정 |  |  |  |
| AC-9cea076b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:802 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) | GRID_SET | newSheet.Cells[i, divIdColPos].CellType | comboBoxCellType_DivisionId | 그리드 속성/값 설정 |  |  |  |
| AC-20abeedb | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:805 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) ▸ if (!string.IsNullOrEmpty(value_Div)) | GRID_SET | newSheet.Cells[i, divIdColPos].Value | value_Div | 그리드 속성/값 설정 |  |  |  |
| AC-1cc2d299 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:809 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) | GRID_SET | newSheet.Cells[i, plantIdColPos].CellType | comboBoxCellType_PlantId | 그리드 속성/값 설정 |  |  |  |
| AC-1ea55ebc | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:812 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) ▸ if (!string.IsNullOrEmpty(value_PlantId)) | GRID_SET | newSheet.Cells[i, plantIdColPos].Value | value_PlantId | 그리드 속성/값 설정 |  |  |  |
| AC-502be717 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:816 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) | GRID_SET | newSheet.Cells[i, companyIdColPos].CellType | comboBoxCellType_CompanyId | 그리드 속성/값 설정 |  |  |  |
| AC-ae7ad55a | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:819 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) ▸ if (!string.IsNullOrEmpty(value_CompanyId)) | GRID_SET | newSheet.Cells[i, companyIdColPos].Value | value_CompanyId | 그리드 속성/값 설정 |  |  |  |
| AC-7df6a5da | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:829 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (newSheet.RowCount < rowCountDefault) | CALL_EXT | newSheet.AddRows | (newSheet.RowCount, rowsToAdd - newSheet.RowCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9c7f1ec | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:830 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (newSheet.RowCount < rowCountDefault) | GRID_SET | newSheet.Cells[startRow, planTypeColPos, rowsToAdd - 1, planTypeColPos].CellType | comboBoxCellType_PlanType | 그리드 속성/값 설정 |  |  |  |
| AC-17ba117b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:831 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (newSheet.RowCount < rowCountDefault) | GRID_SET | newSheet.Cells[startRow, occrColPos, rowsToAdd - 1, occrColPos].CellType | comboBoxCellType_OCCR | 그리드 속성/값 설정 |  |  |  |
| AC-ff4a7856 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:832 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (newSheet.RowCount < rowCountDefault) | GRID_SET | newSheet.Cells[startRow, exthColPos, rowsToAdd - 1, exthColPos].CellType | comboBoxCellType_EXHT | 그리드 속성/값 설정 |  |  |  |
| AC-99cbd131 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:833 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (newSheet.RowCount < rowCountDefault) | GRID_SET | newSheet.Cells[startRow, divIdColPos, rowsToAdd - 1, divIdColPos].CellType | comboBoxCellType_DivisionId | 그리드 속성/값 설정 |  |  |  |
| AC-70b51633 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:834 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (newSheet.RowCount < rowCountDefault) | GRID_SET | newSheet.Cells[startRow, plantIdColPos, rowsToAdd - 1, plantIdColPos].CellType | comboBoxCellType_PlantId | 그리드 속성/값 설정 |  |  |  |
| AC-59b2aa2f | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:835 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (newSheet.RowCount < rowCountDefault) | GRID_SET | newSheet.Cells[startRow, companyIdColPos, rowsToAdd - 1, companyIdColPos].CellType | comboBoxCellType_CompanyId | 그리드 속성/값 설정 |  |  |  |
| AC-5be41fb7 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:840 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ac0c487 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:845 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-3d5b1b44 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:847 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-824c02c3 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:851 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-4df50c43 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:853 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-d1de3c36 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:861 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-d8b74a9a | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:863 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-4e76b9f8 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:868 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-94bfbd09 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:882 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4deb4b5a | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:884 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-49ba604d | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:888 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-63fc6659 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:889 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-19084943 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:890 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-c0443b3e | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:891 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-9c6ec0af | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:892 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8a432e4c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:899 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5038023a | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:901 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg) | ⚠ 의미 확인 필요 |  |  |  |
| AC-01a11899 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:904 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-783f00f3 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:908 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb714e61 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:914 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e5b5add | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:915 | catch ((Exception e)) | CALL_BASE | SCM_SYS_LOG_BATCH | ("ExcelDownload", "ERROR", 0, "########## UI ExcelDownload Error (" + tmpSheetName + ") ##… | ⚠ 의미 확인 필요 |  |  |  |
| AC-14fe1598 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:919 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cf066d26 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0115_PolicyInvMgmt.cs:922 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0115_PolicyInvMgmt.Find_Data

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (string.IsNullOrEmpty(saveReasonResult))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7914e9c5 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:399 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bef0d695 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:402 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c807d577 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:402 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6681e12b | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:406 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-09f23e08 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:422 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-37329756 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:423 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-70980bfe | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:427 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN") ⇒ SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-3544153d | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:428 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4719923d | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:429 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-ea6ebac3 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:430 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-29a87056 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:431 | try ▸ lambda | DATA_OP | request.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-a5efb2af | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:432 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fb2e4d6d | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:433 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-a59afea9 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:434 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-04cc4b30 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:435 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-58bdf06f | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:437 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-885e558b | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:440 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-827e8a86 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:447 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a7ba61d1 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:449 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0b1b18ae | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:451 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ccc573e | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:456 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d48d8b87 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:463 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4a65cb88 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:464 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-806e69a8 | FindButton 외 1 | SCP0115_PolicyInvMgmt.cs:468 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0115_PolicyInvMgmt.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd1a18c5 | FindButton | SCP0115_PolicyInvMgmt.cs:308 |  | FLAG | isInsert | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0115_PolicyInvMgmt.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7ad6312 | this.Load | SCP0115_PolicyInvMgmt.cs:164 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0115_PolicyInvMgmt.GetColumnIndexByHeaderName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-525cf89e | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1534 | for (i < dataTable.Columns.Count) ▸ if (dataTable.Columns[i].ColumnName.Equals(headerName, StringComparison.OrdinalIgnoreCase)) | RETURN | return i; |  | 처리 중단/반환 |  |  |  |
| AC-f7639cfd | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1537 |  | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.GetComboBoxMasterData

진입점: this.Load / ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ else of (lookupType == "DIV") ▸ else of (lookupType == "PLANT_ID") ▸ else of (lookupType == "COMPANY_ID")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e4c6ae4 | this.Load 외 1 | SCP0115_PolicyInvMgmt.cs:520 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0115_GET_COMBOBOX_DATA") ⇒ SCP.SCP0115_GET_COMBOBOX_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-fad104c5 | this.Load 외 1 | SCP0115_PolicyInvMgmt.cs:521 |  | DATA_OP | request.Parameters["p_lookup_type"] | lookup_type | 행/컬럼 값 대입 |  |  |  |
| AC-87dc6778 | this.Load 외 1 | SCP0115_PolicyInvMgmt.cs:522 |  | DATA_OP | request.Parameters["p_valid_yn"] | valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-0af9f645 | this.Load 외 1 | SCP0115_PolicyInvMgmt.cs:524 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e507d1d6 | this.Load 외 1 | SCP0115_PolicyInvMgmt.cs:524 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.GetLabelNameByName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73e2a84b | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1520 |  | DATA_OP | dataTable.Select | ($"COLUMN_NAME = '{name}'") | 데이터 객체 조작/조회 |  |  |  |
| AC-63940ddf | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1523 | if (foundRows.Length > 0) | RETURN | return foundRows[0]["COLUMN_LABEL_NAME"].ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-99634471 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1525 |  | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.GetPlanDateComboBox

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e52f3638 | this.Load | SCP0115_PolicyInvMgmt.cs:548 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN_DATE") ⇒ SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-4e51a27d | this.Load | SCP0115_PolicyInvMgmt.cs:550 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bfdc3ca3 | this.Load | SCP0115_PolicyInvMgmt.cs:550 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.GetPlantbyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8d1b79b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SCP0115_PolicyInvMgmt.cs:2140 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionAll, false, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b85508b2 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SCP0115_PolicyInvMgmt.cs:2142 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87a05da4 | this.Load | SCP0115_PolicyInvMgmt.cs:183 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-76c96840 | this.Load | SCP0115_PolicyInvMgmt.cs:185 |  | FLAG | dtPlanDate | GetPlanDateComboBox() | 화면 필드/플래그 변경 |  |  |  |
| AC-5ae7a52f | this.Load | SCP0115_PolicyInvMgmt.cs:187 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d940628a | this.Load | SCP0115_PolicyInvMgmt.cs:189 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e54f7dc6 | this.Load | SCP0115_PolicyInvMgmt.cs:191 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroupAll, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-315ef059 | this.Load | SCP0115_PolicyInvMgmt.cs:193 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboCategory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b1ec19ab | this.Load | SCP0115_PolicyInvMgmt.cs:196 |  | VALUE_SET | dCalendar.InitValue | DateUtil.GetDayRange("ALL", "WEEKLY", sToday) | 컨트롤 값 설정 |  |  |  |
| AC-cd24e797 | this.Load | SCP0115_PolicyInvMgmt.cs:196 |  | CALL_EXT | DateUtil.GetDayRange | ("ALL", "WEEKLY", sToday) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0115_PolicyInvMgmt.InitSpread

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (string.IsNullOrEmpty(saveReasonResult)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f373f93 | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:256 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-636f0fc6 | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:257 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0115_PolicyInvMgmt.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-821e89d3 | InsertButton | SCP0115_PolicyInvMgmt.cs:372 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f780a139 | InsertButton | SCP0115_PolicyInvMgmt.cs:373 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | FLAG | isInsert | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7d5308f6 | InsertButton | SCP0115_PolicyInvMgmt.cs:374 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, 0, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-70f795b5 | InsertButton | SCP0115_PolicyInvMgmt.cs:379 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i < fixedColumns.Length) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(fixedColumns[i]), siMain.GetColumnIndex(fixedColumns[i]), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-694918b4 | InsertButton | SCP0115_PolicyInvMgmt.cs:382 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.REQUEST_NO), siMain.GetColumnIndex(DefColumns.R… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0115_PolicyInvMgmt.IsValidWwwYyyyMmDd

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f67f3393 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1659 |  | CALL_EXT | Regex.IsMatch | (dateString, pattern) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e491c871 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1661 | if (Regex.IsMatch(dateString, pattern)) | CALL_EXT | DateTime.TryParseExact | (dateString.Substring(4), "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out … | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ea4b137 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1661 | if (Regex.IsMatch(dateString, pattern)) | RETURN | return DateTime.TryParseExact(dateString.Substring(4), "yyyyMMdd", null, System.… |  | 처리 중단/반환 |  |  |  |
| AC-a1a38a4a | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1663 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.IsValidYyyyMmDd

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrEmpty(planDateCol.Trim()))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1bcef48 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0115_PolicyInvMgmt.cs:1652 |  | CALL_EXT | DateTime.TryParseExact | (dateString, formats, null, System.Globalization.DateTimeStyles.None, out _) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca5b3e7c | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0115_PolicyInvMgmt.cs:1652 |  | RETURN | return DateTime.TryParseExact(dateString, formats, null, System.Globalization.Da… |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.LoadExcelToDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af63987b | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1705 | try ▸ if (bFile == false) | MESSAGE | MessageBox.Show | ("Check Excel File Name", "File Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-501c588a | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1706 | try ▸ if (bFile == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6e1c7518 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1709 | try | CALL_EXT | FarExcel.OpenExcel | (filePath, FarPoint.Excel.ExcelOpenFlags.ColumnHeaders) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb4caabc | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1735 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (k < iColCount) | DATA_OP | dt.Columns.Add | (FarExcel.ActiveSheet.ColumnHeader.Cells[iRowStart, k].Text.ToString(), typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-defbe148 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1741 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) | CALL_EXT | FarExcel.ActiveSheet.GetLastNonEmptyRow | (FarPoint.Win.Spread.NonEmptyItemFlag.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b07e4f60 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1744 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f145e62e | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1751 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) ▸ for… | DATA_OP | dr[k] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-72d515f3 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1753 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) ▸ for… | DATA_OP | dr[k] | FarExcel.ActiveSheet.Cells[i, k].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5dcee472 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1758 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) ▸ for… | DATA_OP | dr[k - 1] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6b9127e1 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1760 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) ▸ for… | DATA_OP | dr[k - 1] | FarExcel.ActiveSheet.Cells[i, k].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-447adbc5 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1763 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) | DATA_OP | dt.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-3538ad43 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1767 | try | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3b391c47 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1769 | try | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-7cdcacc7 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1773 | catch () | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.LoadMasterData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a78fd95 | this.Load | SCP0115_PolicyInvMgmt.cs:283 |  | FLAG | this.dtPlanType | GetComboBoxMasterData(PlanType, "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-f2ef5689 | this.Load | SCP0115_PolicyInvMgmt.cs:284 |  | FLAG | this.dtOccr_rsn_cd | GetComboBoxMasterData(OccrType, "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-08907568 | this.Load | SCP0115_PolicyInvMgmt.cs:285 |  | FLAG | this.dtExht_tp_cd | GetComboBoxMasterData(ExhtType, "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-765aa7da | this.Load | SCP0115_PolicyInvMgmt.cs:286 |  | FLAG | this.planTypeList | convertMasterDataToList(this.dtPlanType) | 화면 필드/플래그 변경 |  |  |  |
| AC-ec5efc40 | this.Load | SCP0115_PolicyInvMgmt.cs:287 |  | FLAG | this.occrList | convertMasterDataToList(this.dtOccr_rsn_cd) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee62cfa5 | this.Load | SCP0115_PolicyInvMgmt.cs:288 |  | FLAG | this.exhtList | convertMasterDataToList(this.dtExht_tp_cd) | 화면 필드/플래그 변경 |  |  |  |

## SCP0115_PolicyInvMgmt.Save_Data_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab7ed450 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1163 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-57b8ab7c | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1166 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-249a0faa | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1197 | try ▸ for (i < dtData.Rows.Count) | DATA_OP | this.planTypeList.Find | (x => x.Value.Trim() == planTypeValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-364701fc | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1200 | try ▸ for (i < dtData.Rows.Count) | DATA_OP | this.occrList.Find | (x => x.Value.Trim() == occrValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-72d6608c | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1207 | try ▸ for (i < dtData.Rows.Count) | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-485861d0 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1240 | try ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9a6a3187 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1244 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN") ⇒ SCP.SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-d44c7399 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1245 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f9f87af3 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1247 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1f82a6ee | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1248 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_no"] | p_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-3e5e9025 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1249 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b4df896c | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1250 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_tp_cd"] | p_plan_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-414fbacc | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1251 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-c310f907 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1252 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e99c6191 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1253 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-284f0b1d | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1254 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-9dfcb5fb | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1255 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_occr_rsn_cd"] | p_occr_rsn_cd | 행/컬럼 값 대입 |  |  |  |
| AC-2c5d8e08 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1256 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_occr_rsn_ctn"] | p_occr_rsn_ctn | 행/컬럼 값 대입 |  |  |  |
| AC-98162df0 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1257 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_exht_tp_cd"] | p_exht_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-43915b07 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1258 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_exht_tp_ctn"] | p_exht_tp_ctn | 행/컬럼 값 대입 |  |  |  |
| AC-6f2a9c8e | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1259 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_yyyymmdd"] | p_plan_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7aebcd11 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1260 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-6bad538d | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1261 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_supplier_code"] | p_supplier_code | 행/컬럼 값 대입 |  |  |  |
| AC-bd5c955b | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1262 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab2fa22a | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1264 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f14b7cdb | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1266 | try ▸ if (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0f59a70a | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1267 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-0a001d7b | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1272 | try ▸ else of (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ac4e44fc | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1273 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f3bfc7c | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1274 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-83317a60 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1279 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d3a67442 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1280 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a32067a8 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1281 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd2c9031 | SaveButton | SCP0115_PolicyInvMgmt.cs:965 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-dfa0c797 | SaveButton | SCP0115_PolicyInvMgmt.cs:985 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8c843c1c | SaveButton | SCP0115_PolicyInvMgmt.cs:986 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1a5f0cf6 | SaveButton | SCP0115_PolicyInvMgmt.cs:990 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN") ⇒ SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-3995d82d | SaveButton | SCP0115_PolicyInvMgmt.cs:991 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0ba24f29 | SaveButton | SCP0115_PolicyInvMgmt.cs:992 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | DATA_OP | request.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-f098f357 | SaveButton | SCP0115_PolicyInvMgmt.cs:993 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-89ea932e | SaveButton | SCP0115_PolicyInvMgmt.cs:994 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | DATA_OP | request.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d976ee5 | SaveButton | SCP0115_PolicyInvMgmt.cs:995 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-119d7575 | SaveButton | SCP0115_PolicyInvMgmt.cs:996 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-7944b2c0 | SaveButton | SCP0115_PolicyInvMgmt.cs:997 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2dd5a1c0 | SaveButton | SCP0115_PolicyInvMgmt.cs:998 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6f042bb9 | SaveButton | SCP0115_PolicyInvMgmt.cs:1000 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eb9b7321 | SaveButton | SCP0115_PolicyInvMgmt.cs:1003 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9c7a6892 | SaveButton | SCP0115_PolicyInvMgmt.cs:1013 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (string.IsNullOrEmpty(saveReasonResu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7e1e4a82 | SaveButton | SCP0115_PolicyInvMgmt.cs:1017 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (string.IsNullOrEmpty(saveReaso… | MESSAGE | MessageHelper.GMessageBox | (saveReasonResult) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4b228934 | SaveButton | SCP0115_PolicyInvMgmt.cs:1024 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b2cd744f | SaveButton | SCP0115_PolicyInvMgmt.cs:1025 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9fa598e4 | SaveButton | SCP0115_PolicyInvMgmt.cs:1029 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a3230470 | SaveButton | SCP0115_PolicyInvMgmt.cs:1030 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0115_PolicyInvMgmt.SavePlanData

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bb983cc | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1063 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (message != "") | RETURN | return message; |  | 처리 중단/반환 |  |  |  |
| AC-3aa29eaf | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1075 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | this.planTypeList.Find | (x => x.Value.Trim() == planTypeValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-d704a58f | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1078 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | this.occrList.Find | (x => x.Value.Trim() == occrValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f02685a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1086 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e87d95c | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1120 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN") ⇒ SCP.SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-89e500fb | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1121 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-525aef43 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1123 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-743978a0 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1124 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_request_no"] | p_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-09bd3f40 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1125 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b195a6df | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1126 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_plan_tp_cd"] | p_plan_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-aa5e270d | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1127 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa0953c5 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1128 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8bf926aa | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1129 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-05bf159a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1130 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-676c100a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1131 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_occr_rsn_cd"] | p_occr_rsn_cd | 행/컬럼 값 대입 |  |  |  |
| AC-89804826 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1132 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_occr_rsn_ctn"] | p_occr_rsn_ctn | 행/컬럼 값 대입 |  |  |  |
| AC-9ca714ef | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1133 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_exht_tp_cd"] | p_exht_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-9bb782eb | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1134 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_exht_tp_ctn"] | p_exht_tp_ctn | 행/컬럼 값 대입 |  |  |  |
| AC-7e68e92f | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1135 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_plan_yyyymmdd"] | p_plan_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-83d582f2 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1136 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1abb2c49 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1137 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_supplier_code"] | p_supplier_code | 행/컬럼 값 대입 |  |  |  |
| AC-7e1abbc2 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1138 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-02e21695 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1140 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6c3268f9 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1144 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) ▸ if (dst.Tables[dst.Tables.Count - 1].Rows[0][0].ToS… | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-8634ef71 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1152 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (recordCount > 0) ▸ else of (dst.Tables[dst.Tables.Count - 1].Rows[0][0… | RETURN | return errorMsg; |  | 처리 중단/반환 |  |  |  |
| AC-134c8425 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0115_PolicyInvMgmt.cs:1157 |  | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |

## SCP0115_PolicyInvMgmt.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7da4738d | this.Load 외 1 | SCP0115_PolicyInvMgmt.cs:208 |  | FLAG | dtPlantByGroup | DBUtils.Filter(dtPlantByGroupAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-acfd1651 | this.Load 외 1 | SCP0115_PolicyInvMgmt.cs:208 |  | DATA_OP | DBUtils.Filter | (dtPlantByGroupAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2a446a9e | this.Load 외 1 | SCP0115_PolicyInvMgmt.cs:210 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-05c90e31 | this.Load 외 1 | SCP0115_PolicyInvMgmt.cs:213 |  | VALUE_SET | dCalendar.InitValue | DateUtil.GetDayRange(currentDivision, "WEEKLY", sToday) | 컨트롤 값 설정 |  |  |  |
| AC-03518f2a | this.Load 외 1 | SCP0115_PolicyInvMgmt.cs:213 |  | CALL_EXT | DateUtil.GetDayRange | (currentDivision, "WEEKLY", sToday) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0115_PolicyInvMgmt.SetColumnFooterData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ if (this.DisplayFooter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfe7d70d | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0115_PolicyInvMgmt.cs:932 |  | DATA_OP | sv.Rows.Add | (newIdx, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-387f05f6 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0115_PolicyInvMgmt.cs:936 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Border | columnHeaerStyle.Border | 그리드 속성/값 설정 |  |  |  |
| AC-fcf93b23 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0115_PolicyInvMgmt.cs:937 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].BackColor | columnHeaerStyle.BackColor | 그리드 속성/값 설정 |  |  |  |
| AC-fac3e848 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0115_PolicyInvMgmt.cs:938 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].HorizontalAlignment | columnHeaerStyle.HorizontalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-c521c31f | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0115_PolicyInvMgmt.cs:939 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].VerticalAlignment | columnHeaerStyle.VerticalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-ee7c11fb | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0115_PolicyInvMgmt.cs:941 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Text | sv.ColumnFooter.Cells[0, col].Text | 그리드 속성/값 설정 |  |  |  |

## SCP0115_PolicyInvMgmt.SetComboBox

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (string.IsNullOrEmpty(saveReasonResult)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37f26f0c | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:272 |  | CALL_EXT | spdInfo.SetColumnCombo | (siMain.GetColumnIndex(DefColumns.PLAN_TP_DESC), dtPlanType) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d8a1a40 | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:273 |  | CALL_EXT | spdInfo.SetColumnCombo | (siMain.GetColumnIndex(DefColumns.OCCR_RSN_DESC), dtOccr_rsn_cd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffdf903a | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:274 |  | CALL_EXT | spdInfo.SetColumnCombo | (siMain.GetColumnIndex(DefColumns.EXHT_TP_DESC), dtExht_tp_cd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c3f7649 | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:275 |  | CALL_EXT | spdInfo.SetColumnCombo | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), CreateComboBoxForSheetView(dtMyCompany)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f27cf9f | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:276 |  | CALL_EXT | spdInfo.SetColumnCombo | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), CreateComboBoxForSheetView(dtMyDivision)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2dcd6f6 | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:277 |  | CALL_EXT | spdInfo.SetColumnCombo | (siMain.GetColumnIndex(DefColumns.PLANT_ID), CreateComboBoxForSheetView(dtPlantByGroupAll)… | ⚠ 의미 확인 필요 |  |  |  |

## SCP0115_PolicyInvMgmt.SetPlantChangedControl

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6db99b93 | clbPlant.SelectedIndexChanged | SCP0115_PolicyInvMgmt.cs:227 | if (cboDivision.ControlValues.ToString() == "ALL") | FLAG | dtPlantByGroup | DBUtils.Filter(dtPlantByGroupAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-325e3ebb | clbPlant.SelectedIndexChanged | SCP0115_PolicyInvMgmt.cs:227 | if (cboDivision.ControlValues.ToString() == "ALL") | DATA_OP | DBUtils.Filter | (dtPlantByGroupAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b81a8797 | clbPlant.SelectedIndexChanged | SCP0115_PolicyInvMgmt.cs:229 | if (cboDivision.ControlValues.ToString() == "ALL") | DATA_OP | dtPlantByGroup.AsEnumerable().Select | (row => row["DIVISION_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e400082 | clbPlant.SelectedIndexChanged | SCP0115_PolicyInvMgmt.cs:232 | if (cboDivision.ControlValues.ToString() == "ALL") | FLAG | dtDivision | DBUtils.Filter(dtMyDivision, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-6aff2731 | clbPlant.SelectedIndexChanged | SCP0115_PolicyInvMgmt.cs:232 | if (cboDivision.ControlValues.ToString() == "ALL") | DATA_OP | DBUtils.Filter | (dtMyDivision, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f2cec1ae | clbPlant.SelectedIndexChanged | SCP0115_PolicyInvMgmt.cs:233 | if (cboDivision.ControlValues.ToString() == "ALL") | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8f6ba7d9 | clbPlant.SelectedIndexChanged | SCP0115_PolicyInvMgmt.cs:236 | if (cboDivision.ControlValues.ToString() == "ALL") | VALUE_SET | dCalendar.InitValue | DateUtil.GetDayRange(currentDivision, "WEEKLY", sToday) | 컨트롤 값 설정 |  |  |  |
| AC-391a33ea | clbPlant.SelectedIndexChanged | SCP0115_PolicyInvMgmt.cs:236 | if (cboDivision.ControlValues.ToString() == "ALL") | CALL_EXT | DateUtil.GetDayRange | (currentDivision, "WEEKLY", sToday) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0115_PolicyInvMgmt.SetSpreadInit

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (string.IsNullOrEmpty(saveReasonResult)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-403cf76c | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:262 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b46dd98d | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:263 |  | GRID_INIT | spdInfo.ColumnHeaderHeight | (0, 50) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad86062a | this.Load 외 3 | SCP0115_PolicyInvMgmt.cs:264 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0115_PolicyInvMgmt.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43b2e2ea | this.spdMain.ComboSelChange | SCP0115_PolicyInvMgmt.cs:2131 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-58d89356 | this.spdMain.ComboSelChange | SCP0115_PolicyInvMgmt.cs:2132 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_DESC), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0115_PolicyInvMgmt.UpdateColumnIndexForUploadFunction

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63b050ed | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1547 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | planDateIndex | GetColumnIndexByHeaderName(dtExcel, planDateLabel) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd52eb91 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1554 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | planTPDescIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c727aaa | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1561 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | occrCDIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-ec4324fe | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1568 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | occrCTNIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-232cf5ae | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1575 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | exhtCDIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a76c066 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1582 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | exhtCTNIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-d81d3fbb | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1589 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | divIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b358e5a | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1596 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | plantIdIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-5400dda9 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1603 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | itemIdIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c024024 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1610 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | qtyIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a878a8a | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1617 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | etaIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d9f1ab5 | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1624 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | supplierCodeIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-721e2a1d | (진입점 미연결) | SCP0115_PolicyInvMgmt.cs:1632 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | requestNoIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |

